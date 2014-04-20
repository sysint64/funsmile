unit uDynamicPlatform;

interface

uses
  GLScene, GLObjects, GLMaterial, uCollisions, uOde, uObjects,
  Dialogs, ODEGL2, ODEIMPORT2, SysUtils, GLTexture, uInterfaces,
  uConsts, uPlayer, uClasses;

type
  TDynamicPlatform = class(TBaseGameObject)
  private
    FDirection: Integer;
    FODEManager: TODEManager;
    FPlayer: TPlayer;
  public
    Direction: Integer;
    Speed: Single;

    procedure Init;
  end;

  TFallingPlatform = class(TBaseGameObject)
  private
    FPause: Integer;
    FOnPlatform: Boolean;
    FRunFall: Boolean;
    FPos: Single;
    FODEManager: TODEManager;
    FPlayer: TPlayer;
  public
    Speed: Single;
    ASpeed: Single;

    procedure Init;
  end;

  TBox = class(TBaseGameObject)
  private
    FODEManager: TODEManager;
    FPlane: array[1..4] of TGLPlane;
    FGame: TGame;
  public
    FBox: TGLDummyCube;
    procedure Init;
  end;

function AddDynamicPlatform(Scene: TGLScene; Player: TPlayer;
  MaterialLibrary: TGLMaterialLibrary; ODEManager: TODEManager; Material: String; x,y,dir: Integer): TGLPLane;
function AddFallingPlatform(Scene: TGLScene; Player: TPlayer;
  MaterialLibrary: TGLMaterialLibrary; ODEManager: TODEManager; Material: String; x,y: Integer): TGLPLane;
function AddBox(Game: TGame; Scene: TGLScene; MaterialLibrary: TGLMaterialLibrary;
  ODEManager: TODEManager; Material: String; x,y: Integer): TGLPLane;

implementation

//* TDynamicPlatform *//

procedure DynamicPlatformStep(Sender: TObject; deltaTime: Double);
var
  Pos, FPos: PdVector3;
  Obj: TDynamicPlatform;
begin
  Obj:= Sender as TDynamicPlatform;
  
  if Obj.Direction = 0 then
  begin
    if Obj.FDirection = 1 then
    begin
      Pos:= dGeomGetPosition(Obj.FODEManager.GetObj(Obj.Name).Geom);
      Pos[0]:= Pos[0] + Obj.Speed * deltaTime;

      if Obj.FPlayer.Position.Y > Obj.Position.Y then
      begin
        dGeomEnable(Obj.FODEManager.GetObj(Obj.Name).Geom);
        dGeomSetPosition(Obj.FODEManager.GetObj(Obj.Name).Geom,Pos[0],Pos[1],Pos[2]);
      end else
      begin
        dGeomDisable(Obj.FODEManager.GetObj(Obj.Name).Geom);
      end;

      if Collision(Obj,Obj.FPlayer) then
      begin
        if Obj.FPlayer.OnGround then
        begin
          FPos:= dGeomGetPosition(Obj.FODEManager.GetObj('Player').Geom);
          FPos[0]:= FPos[0] + Obj.Speed * deltaTime;
          dGeomSetPosition(Obj.FODEManager.GetObj('Player').Geom,FPos[0],FPos[1],FPos[2]);
        end;
      end;
    end;
    if Obj.FDirection = 0 then
    begin
      Pos:= dGeomGetPosition(Obj.FODEManager.GetObj(Obj.Name).Geom);
      Pos[0]:= Pos[0] - Obj.Speed * deltaTime;

      if Obj.FPlayer.Position.Y > Obj.Position.Y then
      begin
        dGeomEnable(Obj.FODEManager.GetObj(Obj.Name).Geom);
        dGeomSetPosition(Obj.FODEManager.GetObj(Obj.Name).Geom,Pos[0],Pos[1],Pos[2]);
      end else
      begin
        dGeomDisable(Obj.FODEManager.GetObj(Obj.Name).Geom);
      end;

      if Collision(Obj,Obj.FPlayer) then
      begin
        if Obj.FPlayer.OnGround then
        begin
          FPos:= dGeomGetPosition(Obj.FODEManager.GetObj('Player').Geom);
          FPos[0]:= FPos[0] - Obj.Speed * deltaTime;
          dGeomSetPosition(Obj.FODEManager.GetObj('Player').Geom,FPos[0],FPos[1],FPos[2]);
        end;
      end;
    end;
  end;

  if Obj.Direction = 1 then
  begin
    if Obj.FDirection = 1 then
    begin
      Pos:= dGeomGetPosition(Obj.FODEManager.GetObj(Obj.Name).Geom);
      Pos[1]:= Pos[1] + Obj.Speed * deltaTime;

      if Obj.FPlayer.Position.Y > Obj.Position.Y then
      begin
        dGeomEnable(Obj.FODEManager.GetObj(Obj.Name).Geom);
        dGeomSetPosition(Obj.FODEManager.GetObj(Obj.Name).Geom,Pos[0],Pos[1],Pos[2]);
      end else
      begin
        dGeomDisable(Obj.FODEManager.GetObj(Obj.Name).Geom);
      end;

      if Collision(Obj,Obj.FPlayer) then
      begin
        if Obj.FPlayer.OnGround then
        begin
          FPos:= dGeomGetPosition(Obj.FODEManager.GetObj('Player').Geom);
          FPos[1]:= FPos[1] + Obj.Speed * deltaTime;
          dGeomSetPosition(Obj.FODEManager.GetObj('Player').Geom,FPos[0],FPos[1],FPos[2]);
        end;
      end;
      //dGeomSetPosition(Obj.ODEManager.GetObj(Obj.Player.Name).Geom,Pos[0],Pos[1],Pos[2]);
    end;
    if Obj.FDirection = 0 then
    begin
      Pos:= dGeomGetPosition(Obj.FODEManager.GetObj(Obj.Name).Geom);
      Pos[1]:= Pos[1] - Obj.Speed * deltaTime;

      if Obj.FPlayer.Position.Y > Obj.Position.Y then
      begin
        dGeomEnable(Obj.FODEManager.GetObj(Obj.Name).Geom);
        dGeomSetPosition(Obj.FODEManager.GetObj(Obj.Name).Geom,Pos[0],Pos[1],Pos[2]);
      end else
      begin
        dGeomDisable(Obj.FODEManager.GetObj(Obj.Name).Geom);
      end;

      if Collision(Obj,Obj.FPlayer) then
      begin
        if Obj.FPlayer.OnGround then
        begin
          FPos:= dGeomGetPosition(Obj.FODEManager.GetObj('Player').Geom);
          FPos[1]:= FPos[1] - Obj.Speed * deltaTime;
          dGeomSetPosition(Obj.FODEManager.GetObj('Player').Geom,FPos[0],FPos[1],FPos[2]);
        end;
      end;
      //dGeomSetPosition(Obj.ODEManager.GetObj(Obj.Player.Name).Geom,Pos[0],Pos[1],Pos[2]);
    end;
  end;

  if (Collision(Obj.FPlayer.Game.CollisionsList,Obj,200,0.5,0.1,1,1)) or (Collision(Obj.FPlayer.Game.CollisionsList,Obj,100,0.5,0.1,1,0.1)) or (Collision(Obj.FPlayer.Game.CollisionsList,Obj,2000,0.5,0.1,1,1)) then
  begin
    if Obj.FDirection = 0 then
    begin
      Obj.FDirection:= 1;
      Pos:= dGeomGetPosition(Obj.FODEManager.GetObj(Obj.Name).Geom);

      if Obj.Direction = 0 then Pos[0]:= Pos[0] + Obj.Speed * 2 * deltaTime;
      if Obj.Direction = 1 then Pos[1]:= Pos[1] + Obj.Speed * 2 * deltaTime;

      if Obj.FPlayer.Position.Y > Obj.Position.Y then
      begin
        dGeomEnable(Obj.FODEManager.GetObj(Obj.Name).Geom);
        dGeomSetPosition(Obj.FODEManager.GetObj(Obj.Name).Geom,Pos[0],Pos[1],Pos[2]);
      end else
      begin
        dGeomDisable(Obj.FODEManager.GetObj(Obj.Name).Geom);
      end;
    end else if Obj.FDirection = 1 then
    begin
      Obj.FDirection:= 0;
      Pos:= dGeomGetPosition(Obj.FODEManager.GetObj(Obj.Name).Geom);

      if Obj.Direction = 0 then Pos[0]:= Pos[0] - Obj.Speed * 2 * deltaTime;
      if Obj.Direction = 1 then Pos[1]:= Pos[1] - Obj.Speed * 2 * deltaTime;

      if Obj.FPlayer.Position.Y > Obj.Position.Y then
      begin
        dGeomEnable(Obj.FODEManager.GetObj(Obj.Name).Geom);
        dGeomSetPosition(Obj.FODEManager.GetObj(Obj.Name).Geom,Pos[0],Pos[1],Pos[2]);
      end else
      begin
        dGeomDisable(Obj.FODEManager.GetObj(Obj.Name).Geom);
      end;
    end;
  end;
end;

procedure TDynamicPlatform.Init;
var
  Pos: PdVector3;
begin
  Direction:= 1;
  FDirection:= 0;
  Speed:= 1;
  Step:= DynamicPlatformStep;
end;

function AddDynamicPlatform(Scene: TGLScene; Player: TPlayer;
  MaterialLibrary: TGLMaterialLibrary; ODEManager: TODEManager; Material: String; x,y,dir: Integer): TGLPLane;
var
  Obj: TDynamicPlatform;
begin
  Obj:= TDynamicPlatform(Scene.Objects.AddNewChild(TDynamicPlatform));
  Obj.Position.SetPoint(X,Y,0);
  Obj.TagFloat:= 1;
  Obj.Tag:= 502;
  Obj.FODEManager:= ODEManager;
  Obj.FPlayer:= Player;
  Obj.Name:= 'Object_' + IntToStr(Scene.Objects.Count);

  with ODEManager.AddObj(Obj,otStatic,gtBox) do
  begin
    SetScale(1,0.1,1);
    Init;
  end;

  Obj.Material.MaterialLibrary:= MaterialLibrary;
  Obj.Material.LibMaterialName:= Material;
  Obj.Init;
  Obj.Direction:= dir;

  Player.Game.CollisionsList.Add(Obj);
  Player.Game.StepsList.Add(Obj);

  Result:= Obj;
end;

//* TFallingPlatform *//

procedure FallingPlatformStep(Sender: TObject; deltaTime: Double);
var
  Pos: PdVector3;
  Obj: TFallingPlatform;
  Mat: TGLMaterial;
begin
  Obj:= Sender as TFallingPlatform;

  {if Obj.FPlayer.Position.Y > Obj.Position.Y then
  begin
    dGeomEnable(Obj.FODEManager.GetObj(Obj.Name).Geom);
    if Obj.FOnPlatform then Obj.FRunFall:= False;
    //Obj.FRunFall:= False;
    //Obj.FPause:= 0;
  end
  else
  begin
    dGeomDisable(Obj.FODEManager.GetObj(Obj.Name).Geom);
    //if Obj.FOnPlatform then Obj.FRunFall:= True;
    Obj.FRunFall:= False;
    Obj.FPause:= 0;
  end;}

  if Collision(Obj,Obj.FPlayer,1,0.1,0,1) or (Collision(Obj.FPlayer.Game.CollisionsList,Obj,920,0.5,0.1,1,1)) then
  begin
    Obj.FOnPlatform:= True;
    Obj.FPause:= Obj.FPause + 1;
  end else
  begin
    if Obj.FOnPlatform then Obj.FRunFall:= True;
    Obj.FPause:= 0;
  end;

  {if (Collision(Obj.FPlayer.Game.CollisionsList,Obj,920,0.5,0.1,1,1)) then
  begin
    Obj.FOnPlatform:= True;
    Obj.FPause:= Obj.FPause + 1;
  end else
  begin
    if Obj.FOnPlatform then Obj.FRunFall:= True;
    Obj.FPause:= 0;
  end;}

  if Obj.FPause >= 25 then Obj.FRunFall:= True;
  if Obj.FRunFall then
  begin
    Obj.FRunFall:= True;

    if Obj.ASpeed <= 4 then
      Obj.ASpeed:= Obj.ASpeed + 0.5;

    if Obj.Material.FrontProperties.Diffuse.Alpha > 0 then
    begin
      Obj.Material.FrontProperties.Diffuse.Alpha:= Obj.Material.FrontProperties.Diffuse.Alpha - 0.02;
      dGeomDisable(Obj.FODEManager.GetObj(Obj.Name).Geom);
      Obj.Position.Y:= Obj.Position.Y - (Obj.Speed + Obj.ASpeed) * deltaTime;
      Pos:= dGeomGetPosition(Obj.FODEManager.GetObj(Obj.Name).Geom);
      Pos[1]:= Pos[1] - (Obj.Speed + Obj.ASpeed) * deltaTime;

      dGeomSetPosition(Obj.FODEManager.GetObj(Obj.Name).Geom,Pos[0],Pos[1],Pos[2]);
    end else Obj.FRunFall:= False;
  
    Obj.FOnPlatform:= False;
  end else
  begin
    if Obj.Material.FrontProperties.Diffuse.Alpha < 1 then
    begin
      Obj.Material.FrontProperties.Diffuse.Alpha:= Obj.Material.FrontProperties.Diffuse.Alpha + 0.02;
      dGeomEnable(Obj.FODEManager.GetObj(Obj.Name).Geom);
      Pos:= dGeomGetPosition(Obj.FODEManager.GetObj(Obj.Name).Geom);
      Pos[1]:= Obj.FPos;
      dGeomSetPosition(Obj.FODEManager.GetObj(Obj.Name).Geom,Pos[0],Pos[1],Pos[2]);
    end;
  end;
end;

procedure TFallingPlatform.Init;
begin
  FPause:= 0;
  Speed:= 2;
  ASpeed:= 0.5;
  Step:= FallingPlatformStep;
end;

function AddFallingPlatform(Scene: TGLScene; Player: TPlayer;
  MaterialLibrary: TGLMaterialLibrary; ODEManager: TODEManager; Material: String; x,y: Integer): TGLPLane;
var
  Obj: TFallingPlatform;
  Mat: TGLMaterial;
begin
  Obj:= TFallingPlatform(Scene.Objects.AddNewChild(TFallingPlatform));
  Obj.Position.SetPoint(X,Y,0);
  Obj.TagFloat:= 1;
  Obj.Tag:= 502;
  Obj.FODEManager:= ODEManager;
  Obj.FPlayer:= Player;
  Obj.Name:= 'Object_' + IntToStr(Scene.Objects.Count);

  with ODEManager.AddObj(Obj,otStatic,gtBox) do
  begin
    SetScale(1,0.1,1);
    Init;
  end;

  Obj.FPos:= Obj.Position.Y;

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

  Player.Game.CollisionsList.Add(Obj);
  Player.Game.StepsList.Add(Obj);

  Result:= Obj;
end;

//* TBox *//

procedure BoxStep(Sender: TObject; deltaTime: Double);
var
  Obj: TBox;
  i,n: Integer;
  Pos: PdVector3;
  R: TdMatrix3;
begin
  Obj:= Sender as TBox;
  n:= 1;

  for i:= 0 to Obj.Scene.Objects.Count - 1 do
    if Obj.Scene.Objects[i].Tag = 2000 then
      with Obj.Scene.Objects[i] do
      if (Position.Y > Obj.Position.Y - co_r) and
         (Position.Y < Obj.Position.Y + co_r) and
         (Position.X > Obj.Position.X - co_r) and
         (Position.X < Obj.Position.X + co_r) then
      begin
        if n <= 2 then
        begin
          dGeomSetPosition(Obj.FODEManager.GetObj(Obj.FPlane[n].Name).Geom,
                           Position.X,Position.Y,Position.Z);
          GLMatrixToODER(Matrix,R);
          dGeomSetRotation(Obj.FODEManager.GetObj(Obj.FPlane[n].Name).Geom,R);
          n:= n + 1;
        end;
      end;

  n:= 3;
  for i:= 0 to Obj.Scene.Objects.Count - 1 do
    if Obj.Scene.Objects[i].Tag = 2001 then
      with Obj.Scene.Objects[i] do
      if (Position.Y > Obj.Position.Y - co_r) and
         (Position.Y < Obj.Position.Y + co_r) and
         (Position.X > Obj.Position.X - co_r) and
         (Position.X < Obj.Position.X + co_r) then
      begin
        if n <= 4 then
        begin
          dGeomSetPosition(Obj.FODEManager.GetObj(Obj.FPlane[n].Name).Geom,
                           Position.X,Position.Y,Position.Z);
          GLMatrixToODER(Matrix,R);
          dGeomSetRotation(Obj.FODEManager.GetObj(Obj.FPlane[n].Name).Geom,R);
          n:= n + 1;
        end;
      end;

  if (Collision(Obj.FGame.CollisionsList,Obj,503)) then
    dBodySetForce(Obj.FODEManager.GetObj(Obj.FBox.Name).Body,0,40,0);

  Pos:= dGeomGetPosition(Obj.FODEManager.GetObj(Obj.FBox.Name).Geom);
  dGeomSetPosition(Obj.FODEManager.GetObj(Obj.FBox.Name).Geom,Pos[0],Pos[1],0);

  Obj.Position:= Obj.FBox.Position;
  Obj.Up.SetVector(Obj.FBox.Up.X,Obj.FBox.Up.Y,0);

  GLMatrixToODER(Obj.Matrix,R);
  dGeomSetRotation(Obj.FODEManager.GetObj(Obj.FBox.Name).Geom,R);
end;

procedure TBox.Init;
begin
  Step:= BoxStep;
end;

function AddBox(Game: TGame; Scene: TGLScene; MaterialLibrary: TGLMaterialLibrary;
  ODEManager: TODEManager; Material: String; x,y: Integer): TGLPLane;
var
  Obj: TBox;
  i: Integer;
begin
  Obj:= TBox(Scene.Objects.AddNewChild(TBox));
  Obj.Name:= 'Box_' + IntToStr(Scene.Objects.Count);

  Obj.FBox:= TGLDummyCube(Scene.Objects.AddNewChild(TGLDummyCube));
  Obj.FBox.Name:= 'FBox_' + IntToStr(Scene.Objects.Count);

  for i:= 1 to 2 do
  begin
    Obj.FPlane[i]:= TGLPlane(Scene.Objects.AddNewChild(TGLPlane));
    Obj.FPlane[i].Name:= 'Object_' + IntToStr(Scene.Objects.Count);
    Obj.FPlane[i].Position.SetPoint(0,0,0);
    Obj.FPlane[i].Visible:= False;

    with ODEManager.AddObj(Obj.FPlane[i],otStatic,gtBox) do
    begin
      SetScale(1,0.6,1);
      Init;
    end;
  end;

  for i:= 3 to 4 do
  begin
    Obj.FPlane[i]:= TGLPlane(Scene.Objects.AddNewChild(TGLPlane));
    Obj.FPlane[i].Name:= 'Object_' + IntToStr(Scene.Objects.Count);
    Obj.FPlane[i].Position.SetPoint(0,0,0);
    Obj.FPlane[i].Visible:= False;

    with ODEManager.AddObj(Obj.FPlane[i],otStatic,gtBox) do
    begin
      SetScale(1,1,1);
      Init;
    end;
  end;

  Obj.Position.SetPoint(X,Y,0);
  Obj.FBox.Position.SetPoint(X,Y,0);
  Obj.TagFloat:= 1;
  Obj.Tag:= 920;
  Obj.FODEManager:= ODEManager;

  with ODEManager.AddObj(Obj.FBox,otDynamic,gtBox) do
  begin
    SetScale(1,1,1);
    Init;
  end;
  
  Obj.Material.MaterialLibrary:= MaterialLibrary;
  Obj.Material.LibMaterialName:= Material;
  Obj.Init;
  Obj.FGame:= Game;

  Game.CollisionsList.Add(Obj);
  Game.StepsList.Add(Obj);

  Result:= Obj;
end;

end.
