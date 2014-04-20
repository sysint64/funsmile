unit uWhirley;

interface

uses
  GLScene, uObjects, GLMaterial, GLObjects, SysUtils, uOde,
  uCollisions, GLTexture, VectorTypes, VectorGeometry, ODEImport2,
  ODEGL2, GLParticleFX, uDynamicPlatform, Dialogs, uAudio, uClasses,
  uPlayer;

type
  TWhirley = class(TBaseGameObject)
  private
    FKey: Integer;
    FAngle: Integer;
    FODEManager: TODEManager;
  public
    procedure Init;
  end;

  TWhirleyAng = (waOn,waOff,waEnd);
  TWhirleyButton = class(TBaseGameObject)
  private
    FKey: Integer;
    FAng: TWhirleyAng;
    FPlayer: TPlayer;
  public
    procedure Init;
  end;

function AddWhirley(Game: TGame; Scene: TGLScene; ODEManager: TODEManager; MaterialLibrary: TGLMaterialLibrary;
    Material: AnsiString;x,y: Single; Key: Integer; Angle: Integer): TGLPlane;
function AddWhirleyButton(Game: TGame; Scene: TGLScene; Player: TPlayer; MaterialLibrary: TGLMaterialLibrary;
    Material: AnsiString;x,y: Single; key: Integer): TGLPlane;

implementation

{ TWhirley }

procedure WhirleyStep(Sender: TObject; deltaTime: Double);
var
  Obj: TWhirley;
  i: Integer;
  R: TdMatrix3;
begin
  Obj:= Sender as TWhirley;

  for i:= 0 to Obj.Scene.Objects.Count - 1 do
    if Obj.Scene.Objects[i] is TWhirleyButton then
      if (Obj.Scene.Objects[i] as TWhirleyButton).FKey = Obj.FKey then
        if (Obj.Scene.Objects[i] as TWhirleyButton).FAng = waOn then
        begin
          //if Obj.FAngle = 0 then begin Obj.FAngle:= 1; Obj.RollAngle:= 90; end;
          //if Obj.FAngle = 1 then begin Obj.FAngle:= 0; Obj.RollAngle:= 0; end;

          if Obj.FAngle = 0 then
          if Obj.RollAngle < 90 then
          begin
            Obj.RollAngle:= Obj.RollAngle + 5;
            GLMatrixToODER(Obj.Matrix,R);
            dGeomSetRotation(Obj.FODEManager.GetObj(Obj.Name).Geom,R)
          end else
          begin
            Obj.RollAngle:= 90;
            GLMatrixToODER(Obj.Matrix,R);
            dGeomSetRotation(Obj.FODEManager.GetObj(Obj.Name).Geom,R);
            Obj.FAngle:= 1;
            (Obj.Scene.Objects[i] as TWhirleyButton).FAng:= waEnd;
            Exit;
          end;

          if Obj.FAngle = 1 then
          if Obj.RollAngle > 0 then
          begin
            Obj.RollAngle:= Obj.RollAngle - 5;//180*deltaTime;
            GLMatrixToODER(Obj.Matrix,R);
            dGeomSetRotation(Obj.FODEManager.GetObj(Obj.Name).Geom,R)
          end else
          begin
            Obj.RollAngle:= 0;
            GLMatrixToODER(Obj.Matrix,R);
            dGeomSetRotation(Obj.FODEManager.GetObj(Obj.Name).Geom,R);
            Obj.FAngle:= 0;
            (Obj.Scene.Objects[i] as TWhirleyButton).FAng:= waEnd;
            Exit;
          end;
        end;
        {begin
          if Obj.Material.FrontProperties.Diffuse.Alpha > 0 then
          begin
            Obj.Material.FrontProperties.Diffuse.Alpha:=
            Obj.Material.FrontProperties.Diffuse.Alpha - 0.1;
          end else dGeomDisable(Obj.FODEManager.GetObj(Obj.Name).Geom);
        end
        else
        begin
          if Obj.Material.FrontProperties.Diffuse.Alpha < 1 then
          begin
            Obj.Material.FrontProperties.Diffuse.Alpha:=
            Obj.Material.FrontProperties.Diffuse.Alpha + 0.1;
            dGeomEnable(Obj.FODEManager.GetObj(Obj.Name).Geom);
          end;
        end;}
end;

procedure TWhirley.Init;
begin
  Step:= WhirleyStep;
end;

{ TWhirleyButton }

procedure WhirleyButtonStep(Sender: TObject; deltaTime: Double);
var
  Obj: TWhirleyButton;
begin
  Obj:= Sender as TWhirleyButton;

  if (Collision(Obj,Obj.FPlayer,0.4,0.4,0.4,0.4)) or
     (Collision(Obj.FPlayer.Game.CollisionsList,Obj,920,0.4,0.4,1,1)) then
  begin
    Obj.Material.FrontProperties.Diffuse.Alpha:= 0;
    if Obj.FAng <> waEnd then Obj.FAng:= waOn;
  end else
  begin
    Obj.Material.FrontProperties.Diffuse.Alpha:= 1;
    if Obj.FAng = waEnd then Obj.FAng:= waOff;
  end;
end;

procedure TWhirleyButton.Init;
begin
  Step:= WhirleyButtonStep;
end;

function AddWhirley(Game: TGame; Scene: TGLScene; ODEManager: TODEManager; MaterialLibrary: TGLMaterialLibrary;
    Material: AnsiString;x,y: Single; Key: Integer; Angle: Integer): TGLPlane;
var
  Obj: TWhirley;
  R: TdMatrix3;
begin
  Obj:= TWhirley(Scene.Objects.AddNewChild(TWhirley));
  Obj.Position.SetPoint(X,Y+0.2,0);
  Obj.TagFloat:= 1;
  Obj.Tag:= 2003;
  Obj.Name:= 'Object_' + IntToStr(Scene.Objects.Count);
  Obj.FODEManager:= ODEManager;

  with ODEManager.AddObj(Obj,otStatic,gtBox)  do
  begin
    SetScale(0.2,4,1);
    Init;
  end;

  Obj.FAngle:= Angle;

  if Angle = 0 then Obj.RollAngle:= 0;
  if Angle = 1 then Obj.RollAngle:= 90;

  GLMatrixToODER(Obj.Matrix,R);
  dGeomSetRotation(ODEManager.GetObj(Obj.Name).Geom,R);

  Obj.Scale.SetVector(0.3,4,1);
  Obj.Material.MaterialLibrary:= MaterialLibrary;
  Obj.Material.LibMaterialName:= Material;
  Obj.Init;
end;

function AddWhirleyButton(Game: TGame; Scene: TGLScene; Player: TPlayer; MaterialLibrary: TGLMaterialLibrary;
    Material: AnsiString;x,y: Single; key: Integer): TGLPlane;
var
  Obj: TWhirleyButton;
  Mat: TGLMaterial;
begin
  Obj:= TWhirleyButton(Scene.Objects.AddNewChild(TWhirleyButton));
  Obj.Position.SetPoint(X,Y,0);
  Obj.TagFloat:= 1;
  Obj.Tag:= 2003;
  Obj.Name:= 'Object_' + IntToStr(Scene.Objects.Count);
  Obj.Scale.SetVector(1,1,1);

  Mat:= MaterialLibrary.Materials.GetLibMaterialByName(Material).Material;
  Obj.Material.Texture:= Mat.Texture;
  Obj.Material.BlendingMode:= bmTransparency;

  Obj.Material.BlendingMode:= bmTransparency;
  Obj.Material.Texture.TextureMode:= tmModulate;
  Obj.Material.FrontProperties.Ambient.SetColor(1,1,1, 1);
  Obj.Material.FrontProperties.Diffuse.SetColor(1,1,1, 1);
  Obj.Material.FrontProperties.Emission.SetColor(1,1,1, 1);
  Obj.Material.FrontProperties.Specular.SetColor(1,1,1, 1);
  Obj.FKey:= Key;
  Obj.FAng:= waOff;
  Obj.FPlayer:= Player;
  Obj.Init;

  Game.CollisionsList.Add(Obj);

  Result:= Obj;
end;

end.

