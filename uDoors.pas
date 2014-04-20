unit uDoors;

interface

uses
  GLScene, uObjects, GLMaterial, GLObjects, SysUtils, uOde,
  uCollisions, GLTexture, VectorTypes, VectorGeometry, ODEImport2,
  ODEGL2, GLParticleFX, uDynamicPlatform, Dialogs, uAudio, uClasses,
  uPlayer;

type
  TDoor = class(TBaseGameObject)
  private
    FKey: Integer;
    FODEManager: TODEManager;
    FGame: TGame;
  public
    procedure Init;
  end;

  TIceEff = class(TBaseGameObject)
  private
    FTime: Integer;
    FOk: Boolean;
  public
    procedure Init;
  end;

  TIceDoor = class(TBaseGameObject)
  private
    FODEManager: TODEManager;
    FEff: TIceEff;
    FGame: TGame;
  public
    procedure Init;
  end;

  TDoorButton = class(TBaseGameObject)
  private
    FKey: Integer;
    FOpen: Boolean;
    FPlayer: TPlayer;
  public
    procedure Init;
  end;

  function AddDoor(Game: TGame; Scene: TGLScene; ODEManager: TODEManager; MaterialLibrary: TGLMaterialLibrary;
    Material: AnsiString;x,y: Single; Key: Integer): TGLPlane;
  function AddIceDoor(Scene: TGLScene; Game: TGame; FManager: TGLParticleFXManager; ODEManager: TODEManager; MaterialLibrary: TGLMaterialLibrary;
    Material: AnsiString;x,y: Single): TGLPlane;
  function AddDoorButton(Game: TGame; Scene: TGLScene; Player: TPlayer; MaterialLibrary: TGLMaterialLibrary;
    Material: AnsiString;x,y: Single; key: Integer): TGLPlane;

implementation

//* TDoor *//

procedure DoorStep(Sender: TObject; deltaTime: Double);
var
  Obj: TDoor;
  Button: TDoorButton;
  i: Integer;
begin
  Obj:= Sender as TDoor;

  for i:= 0 to Obj.FGame.ButtonsList.Count - 1 do
  begin
    Button:= Obj.FGame.ButtonsList.Items[i];

    if Button.FKey = Obj.FKey then
    begin
    if Button.FOpen then
    begin
      if Obj.Material.FrontProperties.Diffuse.Alpha > 0 then
      begin
        Obj.Material.FrontProperties.Diffuse.Alpha:=
        Obj.Material.FrontProperties.Diffuse.Alpha - 0.1;
      end else dGeomDisable(Obj.FODEManager.GetObj(Obj.Name).Geom);
    end else
    begin
      if Obj.Material.FrontProperties.Diffuse.Alpha < 1 then
      begin
        Obj.Material.FrontProperties.Diffuse.Alpha:=
        Obj.Material.FrontProperties.Diffuse.Alpha + 0.1;
      end else dGeomEnable(Obj.FODEManager.GetObj(Obj.Name).Geom);
    end;
    end;
  end;
  {for i:= 0 to Obj.Scene.Objects.Count - 1 do
    if Obj.Scene.Objects[i] is TDoorButton then
      if (Obj.Scene.Objects[i] as TDoorButton).FKey = Obj.FKey then
        if (Obj.Scene.Objects[i] as TDoorButton).FOpen then
        begin
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

procedure TDoor.Init;
begin
  Step:= DoorStep;
end;

function AddDoor(Game: TGame; Scene: TGLScene; ODEManager: TODEManager; MaterialLibrary: TGLMaterialLibrary;
    Material: AnsiString;x,y: Single; Key: Integer): TGLPlane;
var
  Obj: TDoor;
  Mat: TGLMaterial;
begin
  Obj:= TDoor(Scene.Objects.AddNewChild(TDoor));
  Obj.Position.SetPoint(X,Y,0);
  Obj.TagFloat:= 1;
  Obj.Tag:= 2003;
  Obj.Name:= 'Object_' + IntToStr(Scene.Objects.Count);
  Obj.Scale.SetVector(1,1,1);
  Obj.FODEManager:= ODEManager;

  with ODEManager.AddObj(Obj,otStatic,gtBox) do
  begin
    SetScale(0.5,0.5,0.5);
    Init;
  end;

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
  Obj.FGame:= Game;
  Obj.Init;

  Game.CollisionsList.Add(Obj);
  Game.StepsList.Add(Obj);

  Result:= Obj;
end;

//* TDoorButton *//

procedure DoorButtonStep(Sender: TObject; deltaTime: Double);
var
  Obj: TDoorButton;
begin
  Obj:= Sender as TDoorButton;

  if (Collision(Obj,Obj.FPlayer,0.4,0.4,0.4,0.4)) or
     (Collision(Obj.FPlayer.Game.CollisionsList,Obj,920,0.4,0.4,1,1)) then
  begin
    Obj.Material.FrontProperties.Diffuse.Alpha:= 0;
    Obj.FOpen:= True;
  end else
  begin
    Obj.Material.FrontProperties.Diffuse.Alpha:= 1;
    Obj.FOpen:= False;
  end;
end;

procedure TDoorButton.Init;
begin
  Step:= DoorButtonStep;
end;

function AddDoorButton(Game: TGame; Scene: TGLScene; Player: TPlayer; MaterialLibrary: TGLMaterialLibrary;
  Material: AnsiString;x,y: Single; key: Integer): TGLPlane;
var
  Obj: TDoorButton;
  Mat: TGLMaterial;
begin
  Obj:= TDoorButton(Scene.Objects.AddNewChild(TDoorButton));
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
  Obj.FPlayer:= Player;
  Obj.Init;

  Game.CollisionsList.Add(Obj);
  Game.StepsList.Add(Obj);
  Game.ButtonsList.Add(Obj);

  Result:= Obj;
end;

//* TIceEff *//

procedure IceEffStep(Sender: TObject; deltaTime: Double);
var
  Obj: TIceEff;
begin
  Obj:= Sender as TIceEff;

  if Obj.FOk then
  begin
    Obj.FTime:= Obj.FTime + 1;

    if Obj.FTime >= 20 then
    begin
      GetOrCreateSourcePFX(Obj).Enabled:= False;
      Obj.FOk:= False;
    end;
  end;
end;

procedure TIceEff.Init;
begin
  FTime:= 0;
  Step:= IceEffStep;
end;

//* TIceDoor *//

procedure IceDoorStep(Sender: TObject; deltaTime: Double);
var
  Obj: TIceDoor;
  dObj: TdObj;
  Obj2: TBox;
begin
  Obj:= Sender as TIceDoor;

  if Collision(Obj.FGame.CollisionsList,Obj,920) and (dGeomIsEnabled(Obj.FODEManager.GetObj(Obj.Name).Geom) = 1) then
  begin
    dObj:= Obj.FODEManager.GetObj((Obj.TagObject as TBox).FBox.Name);

    if (dBodyGetLinearVel(dObj.Body)[0] < -10) or
       (dBodyGetLinearVel(dObj.Body)[0] >  10) or
       (dBodyGetLinearVel(dObj.Body)[1] < -10) or
       (dBodyGetLinearVel(dObj.Body)[1] >  10) then
    begin
      if Obj.FGame.onSound then PlayAudio(Obj.FGame.BassStream,Obj.FGame.MainDir + '\Sound\Ice_Explosion.ogg',False);

      Obj.FEff.FOk:= True;
      GetOrCreateSourcePFX(Obj.FEff).Enabled:= True;
      dGeomDisable(Obj.FODEManager.GetObj(Obj.Name).Geom);
      Obj.Material.FrontProperties.Diffuse.Alpha:= 0;
      //Obj.Visible:= False;
    end;
  end;
end;

procedure TIceDoor.Init;
begin
  Step:= IceDoorStep;
end;

function AddIceDoor(Scene: TGLScene; Game: TGame; FManager: TGLParticleFXManager; ODEManager: TODEManager; MaterialLibrary: TGLMaterialLibrary;
    Material: AnsiString;x,y: Single): TGLPlane;
var
  Obj: TIceDoor;
  Mat: TGLMaterial;
begin
  Obj:= TIceDoor(Scene.Objects.AddNewChild(TIceDoor));
  Obj.FEff:= TIceEff(Scene.Objects.AddNewChild(TIceEff));

  Obj.Position.SetPoint(X,Y,0);
  Obj.FEff.Position.SetPoint(X,Y,0);

  Obj.TagFloat:= 1;
  Obj.FEff.TagFloat:= 1;
  Obj.FEff.Material.FrontProperties.Diffuse.Alpha:= 0;
  Obj.FEff.Material.BlendingMode:= bmTransparency;

  Obj.Name:= 'Object_' + IntToStr(Scene.Objects.Count);
  Obj.Scale.SetVector(1,1,1);
  Obj.FGame:= Game;
  Obj.FODEManager:= ODEManager;

  with GetOrCreateSourcePFX(Obj.FEff) do
  begin
    Enabled:= False;
    Manager:= FManager;
    EffectScale:= 0.2;
    ParticleInterval:= 0.01;
    VelocityDispersion:= 8;
    RotationDispersion:= 360;
  end;

  with ODEManager.AddObj(Obj,otStatic,gtBox) do
  begin
    SetScale(0.5,0.5,0.5);
    Init;
  end;

  Mat:= MaterialLibrary.Materials.GetLibMaterialByName(Material).Material;
  Obj.Material.Texture:= Mat.Texture;
  Obj.Material.BlendingMode:= bmTransparency;

  Obj.Material.BlendingMode:= bmTransparency;
  Obj.Material.Texture.TextureMode:= tmModulate;
  Obj.Material.FrontProperties.Ambient.SetColor(1,1,1, 1);
  Obj.Material.FrontProperties.Diffuse.SetColor(1,1,1, 1);
  Obj.Material.FrontProperties.Emission.SetColor(1,1,1, 1);
  Obj.Material.FrontProperties.Specular.SetColor(1,1,1, 1);

  Obj.Init;
  Obj.FEff.Init;

  Game.CollisionsList.Add(Obj);
  Game.StepsList.Add(Obj);
  Game.StepsList.Add(Obj.FEff);

  Result:= Obj;
end;

end.
