//* Автор [Xakep] *//

unit uOde;

interface

uses
  GLScene, ODEImport2, ODEGL2, VectorGeometry, Dialogs, VectorTypes,
  GLCoordinates;

type
  TOdeType = (otDynamic,otStatic);
  TGeomType = (gtBox,gtSphere,gtCylinder);
  TOde = class
  public
    World: pdxWorld;
    Space: pdxSpace;
    ContactGroup: TdJointGroupID;
    //ContactNum: Integer;
    Gravity: Single;

    procedure Step(DeltaTime: Double; dNearCallback: TdNearCallback);
    constructor Create;
  end;

  TdObj = class
  public
    Body: pdxBody;
    Geom: pdxGeom;
    Ode: TOde;
    Data: TGLBaseSceneObject;
    OdeType: TODEType;
    GeomType: TGeomType;
    lx,ly,lz: Single;
    Position: TVector3f;
    Tag: Integer;

    procedure Step;
    procedure Init;
    procedure SetRadius(Value: Single);
    procedure SetScale(X,Y,Z: Single);
    procedure SetRadiusLength(R,L: Single);
    constructor Create(fOde: TOde; fOdeType: TOdeType; fGeomType: TGeomType; fData: TGLBaseSceneObject);
    destructor Destroy;
  end;

  TODEManager = class
  public
    Ode: TOde;
    Objs: array of TdObj;
    Count: Integer;

    procedure Step(DeltaTime: Double; dNearCallback: TdNearCallback);
    constructor Create;
    destructor Destroy;
    function AddObj(Data: TGLBaseSceneObject; OdeType: TOdeType; GeomType: TGeomType): TdObj;
    function GetObj(Name: String): TdObj;
    function DestroyObj(Name: String): TdObj;
  end;

procedure GLMatrixToODER(m: TMatrix; var R: TdMatrix3);

implementation

procedure GLMatrixToODER(m: TMatrix; var R: TdMatrix3);
begin 
  TransposeMatrix(m);

  r[0] := m[0][0]; r[1]:= m[0][1];
  r[2] := m[0][2]; r[4]:= m[1][0];
  r[5] := m[1][1]; r[6]:= m[1][2];
  r[8] := m[2][0]; r[9]:= m[2][1];
  r[10]:= m[2][2];
end;

//* TdObj *//
//
constructor TdObj.Create(fOde: TOde; fOdeType: TOdeType; fGeomType: TGeomType; fData: TGLBaseSceneObject);
begin
  inherited Create;

  Ode:= fOde;
  OdeType:= fOdeType;
  GeomType:= fGeomType;
  Data:= fData;
end;

destructor TdObj.Destroy;
begin
  if OdeType = otDynamic then dBodyDestroy(Body);
  dGeomDestroy(Geom);
end;

procedure TdObj.Init;
Var
  R: TdMatrix3;
begin
  case GeomType of
    gtBox: Geom:= dCreateBox(Ode.Space,lx,ly,lz);
    gtSphere: Geom:= dCreateSphere(Ode.Space,lx / 2);
    gtCylinder: Geom:= dCreateCylinder(Ode.Space,lx / 2,ly);
  end;

  if OdeType = otDynamic then
  begin
    Body:= dBodyCreate(Ode.World);
    dGeomSetBody(Geom,Body);
    dBodySetPosition(Body,Data.Position.X,Data.Position.Y,Data.Position.Z);
  end else
    if Data <> nil then dGeomSetPosition(Geom,Data.Position.X,Data.Position.Y,Data.Position.Z)
    else dGeomSetPosition(Geom,Position[0],Position[1],Position[2]);

  if Data <> nil then
  begin
    GLMatrixToODER(Data.Matrix,R);
    dGeomSetRotation(Geom,R);
    dGeomSetData(Geom,Data);
  end;
end;

procedure TdObj.SetRadius(Value: Single);
begin
  lx:= Value * 2;
end;

procedure TdObj.SetRadiusLength(R,L: Single);
begin
  lx:= R * 2;
  ly:= L;
end;

procedure TdObj.SetScale(X, Y, Z: Single);
begin
  lx:= X; ly:= Y; lz:= Z;
end;

procedure TdObj.Step;
var
  R: TdMatrix3;
begin
  if PdxGeom(Geom).Data <> nil then
  begin
    
    PositionSceneObject(PdxGeom(Geom).Data,Geom);
  end;
end;

//* TOde *//
//
constructor TOde.Create;
begin
  inherited Create;

  World:= dWorldCreate;
  Space:= dHashSpaceCreate(nil);
  ContactGroup:= dJointGroupCreate(0);
  dWorldSetGravity(World,0,-30,0);
end;

procedure TOde.Step(DeltaTime: Double; dNearCallback: TdNearCallback);
begin
  dSpaceCollide(Space,nil,dNearCallback);
  dWorldQuickStep(World,DeltaTime);
  dJointGroupEmpty(ContactGroup);
end;

//* TODEManager *//
//
function TODEManager.AddObj(Data: TGLBaseSceneObject; OdeType: TOdeType; GeomType: TGeomType): TdObj;
begin
  SetLength(Objs,Count + 1);
  Objs[Count]:= TdObj.Create(Ode, OdeType, GeomType, Data);
  Result:= Objs[Count];
  Count:= Count + 1;
end;

constructor TODEManager.Create;
begin
  inherited Create;
  Count:= 0;
end;

destructor TODEManager.Destroy;
Var
  i: Integer;
begin
  inherited Destroy;

  for i:= 0 to Count - 1 do
    Objs[i].Destroy;

  Ode.Destroy;
end;

function TODEManager.GetObj(Name: String): TdObj;
Var
  i: Integer;
begin
  Result:= nil;

  for i:= 0 to Count - 1 do
    if Objs[i] <> nil then
      if Objs[i].Geom.Data <> nil then
        if Objs[i].Data.Name = Name then
        begin
          Result:= Objs[i];
          Exit;
        end;
end;

function TODEManager.DestroyObj(Name: String): TdObj;
Var
  i: Integer;
begin
  Result:= nil;

  for i:= 0 to Count - 1 do
    if Objs[i] <> nil then
      if Objs[i].Geom.Data <> nil then
        if Objs[i].Data.Name = Name then
        begin
          //Result:= Objs[i];
          Objs[i].Destroy;
          Exit;
        end;
end;

procedure TODEManager.Step(DeltaTime: Double; dNearCallback: TdNearCallback);
Var
  i: Integer;
begin
  Ode.Step(DeltaTime,dNearCallback);

  for i:= 0 to Count - 1 do
    Objs[i].Step;
end;

end.
