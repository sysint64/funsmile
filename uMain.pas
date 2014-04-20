//* Проект FunSmile | 2009 - 2010 год *//
//* Выполнил Xakep  | Кабылин Андрей  *//

unit uMain;

interface

uses
  //* Модули игры *//
  //
  uClasses, uConsts, uPngCopy, uKeyBoard, uInterfaces, uRooms,
  uAudio, uDrawPanels, uCollisions, uOde, uPlayer, uHightScore,
  uDynamicPlatform, uObjects, uEffects, uDoors, uUtils, uWhirley,

  //* Основные модули *//
  //
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GLParticleFX, GLCadencer, GLBitmapFont, GLMaterial, OffSetAnim,
  GLCrossPlatform, BaseClasses, GLScene, GLWin32Viewer, GLObjects, Bass,
  GLCoordinates, TGA, JPEG, GLGraphics, VectorGeometry, ODEImport2, ODEGL2,
  VectorTypes, GLHUDObjects, GLTexture, GLScreen, GLAnimatedSprite,
  GLWin32FullScreenViewer, ExtCtrls, GLColor, GLPerlinPFX, GLFireFX,
  GLLinePFX, GLExplosionFx, PNGImage, StdCtrls, GLBitmapFontNFW,
  GLCollision, GLTerrainRenderer;

type
  TfMain = class(TForm)
    Step: TGLCadencer;
    GLPointLightPFXManager1: TGLPointLightPFXManager;
    GLCustomSpritePFXManager1: TGLCustomSpritePFXManager;
    Scene: TGLScene;
    Target: TGLDummyCube;
    l_back: TGLPlane;
    Camera: TGLCamera;
    Texts: TGLDummyCube;
    ScoreText: TGLHUDText;
    Snow: TGLDummyCube;
    PFXRender: TGLParticleFXRenderer;
    Black: TGLHUDSprite;
    MaterialLibrary: TGLMaterialLibrary;
    LivesText: TGLHUDText;
    TimerStart: TTimer;
    Scn: TGLSceneViewer;
    GLCustomSpritePFXManager2: TGLCustomSpritePFXManager;
    FinishPFXManager: TGLCustomSpritePFXManager;
    IceVapourPFXManager: TGLCustomSpritePFXManager;
    HSPlayerName: TGLHUDText;
    HSNames: TGLHUDText;
    HSScores: TGLHUDText;
    HSText: TGLHUDText;
    White: TGLHUDSprite;
    Dialog: TGLHUDText;
    TitleText: TGLHUDText;
    l_back3: TGLPlane;
    PanelFont: TGLBitmapFont;
    l_back2: TGLPlane;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLTerrainRenderer1: TGLTerrainRenderer;
    procedure GLCustomSpritePFXManager1PrepareTextureImage(Sender: TObject;
      destBmp32: TGLBitmap32; var texFormat: Integer);
    procedure StepProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure ScnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ScnMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ScnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TimerStartTimer(Sender: TObject);
    procedure GLCustomSpritePFXManager2PrepareTextureImage(Sender: TObject;
      destBmp32: TGLBitmap32; var texFormat: Integer);
    procedure FinishPFXManagerPrepareTextureImage(Sender: TObject;
      destBmp32: TGLBitmap32; var texFormat: Integer);
    procedure IceVapourPFXManagerPrepareTextureImage(Sender: TObject;
      destBmp32: TGLBitmap32; var texFormat: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TeleportPFXManagerPrepareTextureImage(Sender: TObject;
      destBmp32: TGLBitmap32; var texFormat: Integer);
    procedure DialogProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure DialogProgress2(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure TitleTextProgress(Sender: TObject; const deltaTime,
      newTime: Double);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    Device: TDevice;
    Pak: TPak;
    mX,mY: Integer;
    BlinkI: Integer;
    Paused: Boolean;
    mOde: TOde;
    ODEManager: TODEManager;
    Player: TPlayer;
    OnkeyEsc: Boolean;
    OnKeyEnter: Boolean;
    AnyKey: Boolean;
    Shadow: TGLPlane;
    Game: TGame;
    BassStream: HStream;
    MusicN: Integer;
    TitleLevel: String;
    World: Integer;
    HS: THightScore;
    //
    procedure FreeAll;
    procedure CreateAll;
    procedure InitAll;
    procedure LoadOptions;
    procedure LoadTexts(A: Boolean);
    //
    procedure DrawRooms;
    procedure SetEnabledSnow(Visible: Boolean);
    procedure StepSnow;
    procedure LoadLevel(const FileName: String);
    procedure ScanOnGround;
    procedure StepShadow;
    function  AddPlatform(const Name: String; x,y: Single): TGLPlane;
    function  AddTiltedPlatform(const Name: String; x,y,a: Single): TGLPlane;
    function  AddEmptyPlatform(const Name: String; x,y: Single): TGLPlane;
    function  AddGround(const Name: String; x,y: Single): TGLPlane;
    function  AddSolidGround(const Name: String; x,y: Single): TGLPlane;
    function  AddPoint(const Name: String; x,y: Single; w,h,fEnd: Integer;
      cl1,cl2: TColorVector; Density: Single): TGLAnimatedSprite;
    function  AddDecor(const Name: String; x,y: Single): TGLPlane;
    function  AddAnimDecor(const Name: String; x,y: Single; w,h,fEnd: Integer): TGLAnimatedSprite;
    function  AddEnemy(const Name: String; Progress: TGLProgressEvent; x,
  y: Single; w, h, fEnd, Health: Integer; God: Boolean): TEnemy;
    function  AddBorder(x,y,w,h: Single; Tag: Integer): TGLPlane;
    function  AddPartUp(x,y: Single; FManager: TGLParticleFXManager; Tag: Integer): TGLPlane;
    procedure PointProgress(Sender: TObject; const deltaTime, newTime: Double);
    procedure SnowballProgress(Sender: TObject; const deltaTime, newTime: Double);
    procedure FireballProgress(Sender: TObject; const deltaTime, newTime: Double);
    procedure PlatformProgress(Sender: TObject; const deltaTime, newTime: Double);
    procedure PenguinMove(Sender: TObject; const deltaTime, newTime: Double);
    procedure SheepMove(Sender: TObject; const deltaTime, newTime: Double);
    procedure Penguin2Move(Sender: TObject; const deltaTime, newTime: Double);
  end;

var
  fMain: TfMain;

implementation

uses uInit;

{$R *.dfm}

//* Functions *//
//
procedure SetVisibleCursor(Visible: Boolean);
begin
  fMain.Game.PanelsManager.Cursor.Visible:= Visible;
end;

procedure TfMain.SetEnabledSnow(Visible: Boolean);
begin
  (Snow.Effects[0] as TGLSourcePFXEffect).Enabled:= Visible;
  (Snow.Effects[1] as TGLSourcePFXEffect).Enabled:= Visible;
end;

procedure TfMain.StepSnow;
begin
  with TGLSourcePFXEffect(Snow.Effects[0])do
  begin
    InitialPosition.AsVector:= Snow.AbsolutePosition;
    InitialVelocity.AsVector:= VectorScale(VectorNormalize(VectorNegate(Snow.AbsolutePosition)),4);
  end;

  with TGLSourcePFXEffect(Snow.Effects[1])do
  begin
    InitialPosition.AsVector:= Snow.AbsolutePosition;
    InitialVelocity.AsVector:= VectorScale(VectorNormalize(VectorNegate(Snow.AbsolutePosition)),4);
  end;
end;

procedure TfMain.PointProgress(Sender: TObject; const deltaTime,
  newTime: Double);
begin
  if Paused then (Sender as TGLAnimatedSprite).AnimationMode:= samNone
  else (Sender as TGLAnimatedSprite).AnimationMode:= samLoop;
end;

procedure TfMain.PenguinMove(Sender: TObject; const deltaTime,
  newTime: Double);
Var
  Enemy: TEnemy;
  i: Integer;
begin
  Enemy:= Sender as TEnemy;

  if not Paused then
  begin
    Enemy.Position.X:= Enemy.Position.X + 0.003 * Enemy.Dir;
    Enemy.Anim.Tick(newTime);
    Enemy.timer:= Enemy.timer + 1;

    if (Enemy.Health > 0) or (Enemy.God) then
    begin
      if Collision(Game.CollisionsList,Enemy,100) or
         Collision(Game.CollisionsList,Enemy,2001,0.5,1,1,1) or
         Collision(Game.CollisionsList,Enemy,2003,0.5,1,1,1) then
      begin
        Enemy.Dir:= -Enemy.Dir;
        Enemy.Scale.X:= -Enemy.Scale.X;
      end;
    end else Enemy.Die;
  end;
end;

procedure TfMain.SheepMove(Sender: TObject; const deltaTime,
  newTime: Double);
Var
  Enemy: TEnemy;
  i: Integer;
begin
  Enemy:= Sender as TEnemy;

  if not Paused then
  begin
    Enemy.Position.X:= Enemy.Position.X + 0.01 * Enemy.Dir;
    Enemy.Anim.Tick(newTime);

    Enemy.timer:= Enemy.timer + 1;

    if Collision(Game.CollisionsList,Enemy,100) or
       Collision(Game.CollisionsList,Enemy,2001,0.5,1,1,1) or
       Collision(Game.CollisionsList,Enemy,2003,0.5,1,1,1) then
    begin
      Enemy.Dir:= -Enemy.Dir;
      Enemy.Scale.X:= -Enemy.Scale.X;
    end;
  end;
end;

procedure TfMain.Penguin2Move(Sender: TObject; const deltaTime,
  newTime: Double);
Var
  Enemy: TEnemy;
  Snowball: TBall;
  i: Integer;
begin
  Enemy:= Sender as TEnemy;
  
  if not Paused then
  begin
    //Enemy.AnimationMode:= samLoop;
    Enemy.Position.X:= Enemy.Position.X + 0.003 * Enemy.Dir;
    Enemy.Anim.Tick(newTime);

    Enemy.timer:= Enemy.timer + 1;

    if Enemy.Timer = 100 then
    begin
      Snowball:= TBall(Scene.Objects.AddNewChild(TBall));

      with Snowball do
      begin
        Tag:= 9;
        Position:= Enemy.Position;
        Position.Y:= Position.Y + 0.15;
        vx:= 100;
        randomize;
        i:= Random(50);
        vy:= 100 + i;
        Dir:= Enemy.Dir;
        OnProgress:= SnowballProgress;
        Scale.SetVector(0.4,0.4,0.4);
        Material.MaterialLibrary:= MaterialLibrary;
        Material.LibMaterialName:= 'Snowball';
      end;
    end;

    if Enemy.Timer = 150 then
    begin
      Enemy.Timer:= 0;
      Snowball:= TBall(Scene.Objects.AddNewChild(TBall));

      with Snowball do
      begin
        Tag:= 9;
        Position:= Enemy.Position;
        Position.Y:= Position.Y + 0.15;
        vx:= 100;
        randomize;
        i:= Random(50);
        vy:= 100 + i;
        Dir:= Enemy.Dir;
        OnProgress:= SnowballProgress;
        Scale.SetVector(0.4,0.4,0.4);
        Material.MaterialLibrary:= MaterialLibrary;
        Material.LibMaterialName:= 'Snowball';
      end;
    end;

    if Collision(Game.CollisionsList,Enemy,100) then
    begin
      Enemy.Dir:= -Enemy.Dir;
      Enemy.Scale.X:= -Enemy.Scale.X;
    end;
  end;
end;

procedure TfMain.FireballProgress(Sender: TObject; const deltaTime,
  newTime: Double);
begin

end;

procedure TfMain.SnowballProgress(Sender: TObject; const deltaTime,
  newTime: Double);
Var
  Snowball: TBall;
begin
  if not Paused then
  begin
    Snowball:= Sender as TBall;
    Snowball.Roll(5 * Snowball.Dir);
    Snowball.Timer:= Snowball.Timer + 1;

    with Snowball do
    begin
      if vx > -100 then vx:= vx - 1;
      if vy > -100 then vy:= vy - 2;

      if vx > -50 then Position.X:= Position.X + 1 * deltaTime * 150 * deltaTime * Dir;
      Position.Y:= Position.Y + 2 * deltaTime * vy * deltaTime;
    end;

    if Snowball.Timer > 100 then Snowball.Destroy;
  end;
end;

procedure TfMain.StepShadow;
Var
  i,j,n: Integer;
  R: TdMatrix3;
  P: TGLBaseSceneObject;
begin
  //n:= 1;

  {for i:= 0 to Scene.Objects.Count - 1 do
    if Scene.Objects[i].Tag = 2000 then
      with Scene.Objects[i] do
      if (Position.Y > Player.Position.Y - co_r) and
         (Position.Y < Player.Position.Y + co_r) and
         (Position.X > Player.Position.X - co_r) and
         (Position.X < Player.Position.X + co_r) then
      begin
        if n <= 2 then
        begin
          //ODEManager.GetObj('CO_1');
          dGeomSetPosition(ODEManager.GetObj('CO_' + IntToStr(n)).Geom,
                           Position.X,Position.Y,Position.Z);
          GLMatrixToODER(Matrix,R);
          dGeomSetRotation(ODEManager.GetObj('CO_' + IntToStr(n)).Geom,R);
          n:= n + 1;
        end;
      end;

  n:= 1;
  for i:= 0 to Scene.Objects.Count - 1 do
    if Scene.Objects[i].Tag = 2001 then
      with Scene.Objects[i] do
      if (Position.Y > Player.Position.Y - co_r) and
         (Position.Y < Player.Position.Y + co_r) and
         (Position.X > Player.Position.X - co_r) and
         (Position.X < Player.Position.X + co_r) then
      begin
        if n <= 2 then
        begin
          dGeomSetPosition(ODEManager.GetObj('CO_2_' + IntToStr(n)).Geom,
                           Position.X,Position.Y,Position.Z);
          GLMatrixToODER(Matrix,R);
          dGeomSetRotation(ODEManager.GetObj('CO_2_' + IntToStr(n)).Geom,R);
          n:= n + 1;
        end;
      end;

  Shadow.Position.X:= Player.Position.X;

  for i:= Scene.Objects.Count - 1 downto 0 do
    if (Scene.Objects[i].Tag = 2000) or (Scene.Objects[i].Tag = 920) then
      with Scene.Objects[i] do
      if (Player.Position.Y > Position.Y - (Scale.Y / 2)) and
         (Player.Position.X > Position.X - (Scale.X / 2)) and
         (Player.Position.X < Position.X + (Scale.X / 2))
      then
      begin
        Shadow.Visible:= True;
        Shadow.Position.Y:= Position.Y + 0.3;
        Exit;
      end;
  {for i:= 0 to ODEManager.Count - 1 do
    if ODEManager.Objs[i].ODEType = otStatic then
      with TGLBaseSceneObject(ODEManager.Objs[i].Geom.Data) do
      if
         (Player.Position.Y > Position.Y - (ODEManager.Objs[i].ly / 2)) and
         (Player.Position.X > Position.X - (ODEManager.Objs[i].lx / 2)) and
         (Player.Position.X < Position.X + (ODEManager.Objs[i].lx / 2))
      then
      begin
        Shadow.Visible:= True;
        Shadow.Position.Y:= Position.Y + 0.3;
        Exit;
      end;}

  n:= 1;

  for i:= 0 to Game.CollisionsList.Count - 1 do
  begin
    P:= Game.CollisionsList.Items[i];

    if Assigned(P) then
      if (P.Tag = 2000) and (P.Visible) then
        if (P.Position.Y > Player.Position.Y - co_r) and
           (P.Position.Y < Player.Position.Y + co_r) and
           (P.Position.X > Player.Position.X - co_r) and
           (P.Position.X < Player.Position.X + co_r) then
        begin
          if n <= 2 then
          begin
            //ODEManager.GetObj('CO_1');
            dGeomSetPosition(ODEManager.GetObj('CO_' + IntToStr(n)).Geom,
                             P.Position.X,P.Position.Y,P.Position.Z);
            GLMatrixToODER(P.Matrix,R);
            dGeomSetRotation(ODEManager.GetObj('CO_' + IntToStr(n)).Geom,R);
            n:= n + 1;
          end;
        end;
  end;

  n:= 1;

  for i:= 0 to Game.CollisionsList.Count - 1 do
  begin
    P:= Game.CollisionsList.Items[i];

    if Assigned(P) then
      if (P.Tag = 2001) and (P.Visible) then
        if (P.Position.Y > Player.Position.Y - co_r) and
           (P.Position.Y < Player.Position.Y + co_r) and
           (P.Position.X > Player.Position.X - co_r) and
           (P.Position.X < Player.Position.X + co_r) then
        begin
          if n <= 2 then
          begin
            dGeomSetPosition(ODEManager.GetObj('CO_2_' + IntToStr(n)).Geom,
                             P.Position.X,P.Position.Y,P.Position.Z);
            GLMatrixToODER(P.Matrix,R);
            dGeomSetRotation(ODEManager.GetObj('CO_2_' + IntToStr(n)).Geom,R);
            n:= n + 1;
          end;
        end;
  end;

  Shadow.Position.X:= Player.Position.X;

  for i:= 0 to Game.CollisionsList.Count - 1 do
  begin
    P:= Game.CollisionsList.Items[i];

    if Assigned(P) then
      if ((P.Tag = 2000) or (P.Tag = 920)) and (P.Visible) then
        if (Player.Position.Y > P.Position.Y - (P.Scale.Y / 2)) and
           (Player.Position.X > P.Position.X - (P.Scale.X / 2)) and
           (Player.Position.X < P.Position.X + (P.Scale.X / 2))
        then
        begin
          Shadow.Visible:= True;
          Shadow.Position.Y:= P.Position.Y + 0.3;
          Exit;
        end;
  end;

  Shadow.Visible:= False;
end;

function TfMain.AddPlatform(const Name: String; x,y: Single): TGLPlane;
Var
  Obj: TGLPlane;
begin
  Obj:= TGLPlane(Scene.Objects.AddNewChild(TGLPlane));
  Obj.Position.SetPoint(X,Y,0);

  Obj.Entity:= 'AddPlatform("'+Name+'",'+FloatToStr(X)+','+FloatToStr(Y)+');';

  {with ODEManager.AddObj(Obj,otStatic,gtBox) do
  begin
    SetScale(1,0.6,1);
    Init;
  end;}

  //Obj.TagFloat:= 0.6;
  Obj.Tag:= 2000;
  Obj.OnProgress:= PlatformProgress;
  Obj.Material.MaterialLibrary:= MaterialLibrary;
  Obj.Material.LibMaterialName:= Name;
  Obj.Material.BlendingMode:= bmTransparency;
  Obj.MoveFirst;
  
  Game.CollisionsList.Add(Obj);
  
  Target.MoveFirst;
end;

function TfMain.AddTiltedPlatform(const Name: String; x,y,a: Single): TGLPlane;
Var
  Obj: TGLPlane;
begin
  Obj:= TGLPlane(Scene.Objects.AddNewChild(TGLPlane));
  Obj.Position.SetPoint(X,Y,0);
  Obj.RollAngle:= a;

  Obj.Entity:= 'AddTiltedPlatform("'+Name+'",'+FloatToStr(X)+','+FloatToStr(Y)+','+FloatToStr(a)+');';

  {with ODEManager.AddObj(Obj,otStatic,gtBox) do
  begin
    SetScale(1,0.6,1);
    Init;
  end;}

  //Obj.TagFloat:= 0.6;
  Obj.Tag:= 2002;
  Obj.OnProgress:= PlatformProgress;
  Obj.Material.MaterialLibrary:= MaterialLibrary;
  Obj.Material.LibMaterialName:= Name;
  Obj.Material.BlendingMode:= bmTransparency;
  Obj.MoveFirst;

  with ODEManager.AddObj(Obj,otStatic,gtBox) do
  begin
    SetScale(1.42,0.6,1);
    Init;
  end;

  Result:= Obj;
  
  Target.MoveFirst;
end;

function TfMain.AddEmptyPlatform(const Name: String; x,y: Single): TGLPlane;
Var
  Obj: TGLPlane;
  i: Integer;
begin
  Obj:= TGLPlane(Scene.Objects.AddNewChild(TGLPlane));
  Obj.Position.SetPoint(X,Y,0);

  Obj.Material.MaterialLibrary:= MaterialLibrary;
  Obj.Material.LibMaterialName:= Name;

  Obj.Entity:= 'AddEmptyPlatform("'+Name+'",'+FloatToStr(X)+','+FloatToStr(Y)+');';

  //Obj.MoveFirst;
  Obj.MoveDown;
  Target.MoveFirst;
end;

function TfMain.AddGround(const Name: String; x,y: Single): TGLPlane;
Var
  Obj: TGLPlane;
begin
  Obj:= TGLPlane(Scene.Objects.AddNewChild(TGLPlane));
  Obj.Position.SetPoint(X,Y,0);

  {with ODEManager.AddObj(Obj,otStatic,gtBox) do
  begin
    SetScale(1,1,1);
    Init;
  end;}

  //Obj.TagFloat:= 1;
  //Obj.Tag:= 9020;
  //Obj.OnProgress:= PlatformProgress;
  Obj.Material.MaterialLibrary:= MaterialLibrary;
  Obj.Material.LibMaterialName:= Name;
  Obj.Entity:= 'AddGround("'+Name+'",'+FloatToStr(X)+','+FloatToStr(Y)+');';
  //Obj.MoveFirst;
  Target.MoveFirst;

  Result:= Obj;
end;

function TfMain.AddSolidGround(const Name: String; x,y: Single): TGLPlane;
Var
  Obj: TGLPlane;
begin
  Obj:= TGLPlane(Scene.Objects.AddNewChild(TGLPlane));
  Obj.Position.SetPoint(X,Y,0);
  Obj.Entity:= 'AddSolidGround("'+Name+'",'+FloatToStr(X)+','+FloatToStr(Y)+');';

  {with ODEManager.AddObj(Obj,otStatic,gtBox) do
  begin
    SetScale(1,1,1);
    Init;
  end;}

  //Obj.OnProgress:= Pla
  Obj.TagFloat:= 1;
  Obj.Tag:= 2001;
  Obj.OnProgress:= PlatformProgress;
  //Obj.TagFloat:= 1;
  //Obj.Tag:= 2001;tformProgress;
  Obj.Material.MaterialLibrary:= MaterialLibrary;
  Obj.Material.LibMaterialName:= Name;
  Obj.MoveFirst;
  Target.MoveFirst;

  Result:= Obj;
end;

function TfMain.AddPoint(const Name: String; x,y: Single; w,h,fEnd: Integer;
  cl1,cl2: TColorVector; Density: Single): TGLAnimatedSprite;
Var
  Obj: TBPoint;
  Anim: TSpriteAnimation;
begin
  Obj:= TBPoint(Scene.Objects.AddNewChild(TBPoint));
  Obj.Position.SetPoint(X,Y - 0.25,0);

  Obj.AnimationIndex:= 0;
  Obj.AnimationMode:= samLoop;
  Obj.Interval:= (fEnd - 1) * 5;
  Obj.MaterialLibrary:= MaterialLibrary;
  Obj.PixelRatio:= 100;
  Obj.OnProgress:= PointProgress;
  Obj.Name:= 'Point_' + IntToStr(Scene.Objects.Count);

  Obj.Entity:= 'AddPoint("'+Name+'",'+FloatToStr(X)+','+FloatToStr(Y)+');';

  Anim:= TSpriteAnimation.Create(nil);
  Obj.Animations.Add(Anim);
  Anim.CurrentFrame:= Random(fEnd);
  Anim.StartFrame:= 0;
  Anim.EndFrame:= fEnd - 1;
  Anim.FrameWidth:= w;
  Anim.FrameHeight:= h;
  Anim.Name:= Name;
  Anim.LibMaterialName:= Name;

  Obj.MoveFirst;
  Target.MoveFirst;

  Obj.TagFloat:= Scene.Objects.Count;
  Obj.Init;
  Obj.Explode.Cadencer:= fMain.Step;
  Obj.Explode.InnerColor.Color:= cl1;
  Obj.Explode.OuterColor.Color:= cl2;
  Obj.Explode.FireDensity:= Density;

  Game.CollisionsList.Add(Obj);

  Result:= Obj;
end;

function TfMain.AddDecor(const Name: String; x, y: Single): TGLPlane;
Var
  Obj: TGLPlane;
begin
  Obj:= TGLPlane(Scene.Objects.AddNewChild(TGLPlane));
  Obj.Position.SetPoint(X,Y,0);
  Obj.Tag:= 996;

  Obj.Entity:= 'AddDecor("'+Name+'",'+FloatToStr(X)+','+FloatToStr(Y)+');';

  Obj.Material.MaterialLibrary:= MaterialLibrary;
  Obj.Material.LibMaterialName:= Name;

  Obj.MoveFirst;
  Target.MoveFirst;

  Result:= Obj;
end;

function TfMain.AddAnimDecor(const Name: String; x,y: Single; w,h,fEnd: Integer): TGLAnimatedSprite;
Var
  Obj: TGLAnimatedSprite;
  Anim: TSpriteAnimation;
begin
  Obj:= TGLAnimatedSprite(Scene.Objects.AddNewChild(TGLAnimatedSprite));
  Obj.Position.SetPoint(X,Y - 0.25,0);

  Obj.Entity:= 'AddAnimDecor("'+Name+'",'+FloatToStr(X)+','+FloatToStr(Y)+','+FloatToStr(W)+','+FloatToStr(H)+');';

  Obj.AnimationIndex:= 0;
  Obj.AnimationMode:= samLoop;
  Obj.Interval:= (fEnd - 1) * 5;
  Obj.MaterialLibrary:= MaterialLibrary;
  Obj.PixelRatio:= 100;
  Obj.OnProgress:= PointProgress;

  Anim:= TSpriteAnimation.Create(nil);
  Obj.Animations.Add(Anim);
  Anim.CurrentFrame:= 0;
  Anim.StartFrame:= 0;
  Anim.EndFrame:= fEnd - 1;
  Anim.FrameWidth:= w;
  Anim.FrameHeight:= h;
  Anim.Name:= Name;
  Anim.LibMaterialName:= Name;

  Obj.MoveFirst;
  Target.MoveFirst;
  Game.PanelsManager.Panel('Panel').MoveLast;

  Result:= Obj;
end;

function TfMain.AddEnemy(const Name: String; Progress: TGLProgressEvent; x,
  y: Single; w, h, fEnd, Health: Integer; God: Boolean): TEnemy;
Var
  Obj: TEnemy;
  i,b: Integer;
  g: String;
begin
  Obj:= TEnemy(Scene.Objects.AddNewChild(TEnemy));
  Obj.Position.SetPoint(X,Y - 0.25,0);
  Obj.Health:= Health;
  Obj.God:= God;

  g:= 'false';
  if God then g:= 'true';

  Obj.Entity:= 'AddEnemy("'+Name+'",'+FloatToStr(X)+','+FloatToStr(Y)+','+FloatToStr(W)+','+FloatToStr(H)+','+IntToStr(Health)+','+g+');';

  {Obj.AnimationIndex:= 0;
  Obj.AnimationMode:= samLoop;
  Obj.Interval:= (fEnd - 1) * 10;
  Obj.MaterialLibrary:= MaterialLibrary;
  Obj.PixelRatio:= 100;}
  Obj.OnProgress:= Progress;
  Obj.Tag:= 8;
  Obj.Name:= 'Enemy_' + IntToStr(Scene.Objects.Count);
  b:= MaterialLibrary.Materials.GetLibMaterialByName(Name).Tag - 1;
  Obj.Anim:= TOffSetAnim.Create;
  Obj.Anim.MakeAnim(w,h,b,MaterialLibrary,30,apmLoop);
  Obj.Anim.SetFrame(1);
  Obj.Material.MaterialLibrary:= MaterialLibrary;
  Obj.Material.LibMaterialName:= Name;

  RandomIze;
  i:= Random(2);

  if i = 0 then Obj.Dir:= 1 else Obj.Dir:= -1;

  Obj.Scale.X:= -Obj.Dir;
  Obj.MoveFirst;
  Target.MoveFirst;

  Game.CollisionsList.Add(Obj);

  Result:= Obj;
end;

function TfMain.AddBorder(x,y,w,h: Single; Tag: Integer): TGLPlane;
Var
  Obj: TGLPLane;
begin
  Obj:= TGLPlane(Scene.Objects.AddNewChild(TGLPlane));
  Obj.Tag:= Tag;
  Obj.Material.FrontProperties.Diffuse.Alpha:= 0;
  Obj.Material.BlendingMode:= bmTransparency;
  Obj.Scale.SetVector(w,h,1);
  Obj.Position.SetPoint(X,Y,0);
  Obj.Name:= 'Border'+intToStr(Scene.Objects.Count);

  Obj.Entity:= 'AddBorder('+FloatToStr(X)+','+FloatToStr(Y)+','+FloatToStr(W)+','+FloatToStr(H)+','+IntToStr(Tag)+');';

  Game.CollisionsList.Add(Obj);

  Result:= Obj;
end;

function TfMain.AddPartUp(x,y: Single; FManager: TGLParticleFXManager; Tag: Integer): TGLPlane;
Var
  Obj: TGLPLane;
begin
  Obj:= TGLPlane(Scene.Objects.AddNewChild(TGLPlane));
  Obj.Tag:= Tag;
  Obj.Material.FrontProperties.Diffuse.Alpha:= 0;
  Obj.Material.BlendingMode:= bmTransparency;
  Obj.Scale.SetVector(0.1,1,1);
  Obj.Position.SetPoint(X,Y,0);

  Obj.Entity:= 'AddFinish('+FloatToStr(X)+','+FloatToStr(Y)+','+IntToStr(Tag)+');';

  with GetOrCreateSourcePFX(Obj) do
  begin
    Manager:= FManager;
    EffectScale:= 0.2;
    InitialVelocity.Y:= 10;
    InitialPosition.Y:= -0.8;
    ParticleInterval:= 0.05;
    PositionDispersion:= 2;
    PositionDispersionRange.SetPoint(1,0,0);
    VelocityDispersion:= 1;
    RotationDispersion:= 360;
    Enabled:= True;
  end;

  Game.CollisionsList.Add(Obj);

  Result:= Obj;
end;

procedure TfMain.LoadLevel(const FileName: String);
Var
  F: TextFile;
  S: Char;
  i,j: Integer;
  Obj: TGLPlane;
  m: Single;
  Anm: TGLAnimatedSprite;
  Enm: TEnemy;
  w: Integer;
  r: Integer;
  ext: String;
begin
  l_back.Visible:= False;
  l_back2.Visible:= False;

  Player.Visible:= True;
  Shadow.Visible:= True;
  Player.pPlayer.Visible:= True;

  for i:= 1 to 2 do
    dGeomSetPosition(ODEManager.GetObj('CO_' + IntToStr(i)).Geom,0,0,0);

  for i:= 1 to 2 do
    dGeomSetPosition(ODEManager.GetObj('CO_2_' + IntToStr(i)).Geom,0,0,0);

  try
    AssignFile(F,FileName);
    Reset(F);

    i:= World;
    ReadLn(F,World);

    if World <> i then
    begin
      MaterialLibrary.Materials.Clear;
      LoadTexts(True);
      Player.pPlayer.Visible:= True;
    end;

    SetEnabledSnow(True);

    if World = 1 then l_back .Visible := True;
    if World = 2 then l_back2.Visible := True;
    if World = 3 then l_back3.Visible := True;

    ReadLn(F,TitleLevel);

    for i:= 1 to 9 do
      ReadLn(F,Game.HelpText[i]);

    i:= 0; j:= 0; m:= 0.3;

    try
      Pak.OpenPak(Game.MainDir + '\Packeges\World'+IntToStr(World)+'.pak');

      while not EOF(F) do
      begin
        Read(F,S);
        i:= i + 1;

        case S of
          '/':
          begin
            if j = 0 then Game.MaxPosCam[0]:= i;
            AddBorder(i,j,1,1,2001);
            j:= j - 1;
            i:= -2;
          end;
          '\':
          begin
            AddBorder(i,j,1,1,2001);
          end;

          'o': begin AddGround('ground1_' + IntToStr(Random(4)),i,j); end;
          'i': begin Obj:= AddGround('ground2_' + IntToStr(Random(4)),i,j); Game.CollisionsList.Add(Obj); Obj.Tag:= 2001; end;
          'j': begin Obj:= AddGround('ground3_' + IntToStr(Random(4)),i,j); Game.CollisionsList.Add(Obj); Obj.Tag:= 2001; end;
          't': AddPlatform('platform1_' + IntToStr(Random(4)),i,j);
          '>': AddPlatform('platform2_' + IntToStr(Random(4)),i,j);
          '<': AddPlatform('platform3_' + IntToStr(Random(4)),i,j);
          'u': AddPlatform('platform4_' + IntToStr(Random(4)),i,j);
          '}': AddPlatform('platform5_' + IntToStr(Random(4)),i,j);
          '{': AddPlatform('platform6_' + IntToStr(Random(4)),i,j);
          '-': AddPlatform('platform7_' + IntToStr(Random(4)),i,j);
          ')': AddPlatform('platform8_' + IntToStr(Random(4)),i,j);
          '(': AddPlatform('platform9_' + IntToStr(Random(4)),i,j);

          '"' : begin Obj:= AddTiltedPlatform('tilted_platform7_' + IntToStr(Random(4)),i,j+0.4,45); Obj.Scale.X:= 1.42; end;
          ']' : begin Obj:= AddTiltedPlatform('platform8_' + IntToStr(Random(4)),i-0.15,j+0.4-0.15,45); end;
          '[' : begin Obj:= AddTiltedPlatform('platform9_' + IntToStr(Random(4)),i+0.15,j+0.4+0.15,45); end;

          'э' : begin Obj:= AddTiltedPlatform('tilted_platform7_' + IntToStr(Random(4)),i,j+0.4,-45); Obj.Scale.X:= 1.42; end;
          'ъ' : begin Obj:= AddTiltedPlatform('platform8_' + IntToStr(Random(4)),i-0.15,j+0.4+0.15,-45); end;
          'х' : begin Obj:= AddTiltedPlatform('platform9_' + IntToStr(Random(4)),i+0.15,j+0.4-0.15,-45); end;

          'O': begin Obj:= AddGround('ground1_' + IntToStr(Random(4)),i,j); Game.CollisionsList.Add(Obj); Obj.Tag:= 2000; end;
          'I': AddEmptyPlatform('ground2_' + IntToStr(Random(4)),i,j);
          'J': AddEmptyPlatform('ground3_' + IntToStr(Random(4)),i,j);
          'T': AddEmptyPlatform('platform1_' + IntToStr(Random(4)),i,j);
          'U': AddEmptyPlatform('platform4_' + IntToStr(Random(3)),i,j);
          '_': AddEmptyPlatform('platform7_' + IntToStr(Random(4)),i,j);
          '1': begin Anm:= AddPoint('Point1',i,j,48,48,16,clrAqua,clrBlue,1); Anm.Tag:= 1; end;
          '2': begin Anm:= AddPoint('Point8',i,j,48,48,16,clrPurple,clrRed,5); Anm.Tag:= 1; end;
          '3': begin Anm:= AddPoint('Point9',i,j,48,48,16,clrLime,clrLime,1); Anm.Tag:= 1; end;
          '4': begin Anm:= AddPoint('Point10',i,j,48,48,16,clrRed,clrRed,5); Anm.Tag:= 1; end;
          '5': begin Anm:= AddPoint('Point11',i,j,48,48,16,clrYellow,clrOrange,1); Anm.Tag:= 1; end;
          '6': begin Anm:= AddPoint('Point12',i,j,48,48,16,clrPurple,clrRed,1); Anm.Tag:= 2; end;
          '7': begin Anm:= AddPoint('Point13',i,j,48,48,16,clrLime,clrLime,1); Anm.Tag:= 2; end;
          '8': begin Anm:= AddPoint('Point14',i,j,48,48,16,clrRed,clrRed,1); Anm.Tag:= 2; end;
          '9': begin Anm:= AddPoint('Point15',i,j,48,48,16,clrYellow,clrOrange,1); Anm.Tag:= 2; end;
          '0': begin Anm:= AddPoint('Point16',i,j,48,48,16,clrPurple,clrRed,1); Anm.Tag:= 3; end;
          '!': begin Anm:= AddPoint('Point17',i,j,48,48,16,clrLime,clrLime,1); Anm.Tag:= 3; end;
          '@': begin Anm:= AddPoint('Point18',i,j,48,48,16,clrRed,clrRed,1); Anm.Tag:= 3; end;
          '#': begin Anm:= AddPoint('Point19',i,j,48,48,16,clrYellow,clrOrange,1); Anm.Tag:= 3; end;
          '$': begin Anm:= AddPoint('Point20',i,j,48,48,16,clrPurple,clrRed,1); Anm.Tag:= 4; end;
          '%': begin Anm:= AddPoint('Point21',i,j,48,48,16,clrLime,clrLime,1); Anm.Tag:= 4; end;
          '^': begin Anm:= AddPoint('Point22',i,j,48,48,16,clrPurple,clrRed,1); Anm.Tag:= 4; end;
          '&': begin Anm:= AddPoint('Point23',i,j,48,48,16,clrYellow,clrOrange,1); Anm.Tag:= 4; end;
          '*': begin Anm:= AddPoint('Point2',i,j,48,48,16,clrAqua,clrBlue,1); Anm.Tag:= 2; end;
          '+': begin Anm:= AddPoint('Point3',i,j,48,48,16,clrAqua,clrBlue,1); Anm.Tag:= 3; end;
          '=': begin Anm:= AddPoint('Point4',i,j,48,48,16,clrAqua,clrBlue,1); Anm.Tag:= 4; end;
          'h': begin Anm:= AddPoint('Point6',i,j,48,48,16,clrRed,clrRed,1); Anm.Tag:= 6; end;
          'm': begin Anm:= AddPoint('Point7',i,j,48,48,16,clrYellow,clrOrange,1); Anm.Tag:= 6; end;
          'd': begin Anm:= AddPoint('Point5',i,j,48,48,16,clrWhite,clrGray,1); Anm.Tag:= 5; end;
          'Y': begin Anm:= AddAnimDecor('Tree',i,j + 0.35,100,75,12); Anm.Scale.SetVector(1.3,1.3,1.3); Anm.MoveLast; Anm.Tag:= 997 end;
          'y': begin Anm:= AddAnimDecor('Tree',i,j + 0.2,100,75,12); Anm.Scale.SetVector(1.2,1.2,1.2); Anm.Tag:= 996 end;
          'q': begin Obj:= AddDecor('Snowman' + IntToStr(Random(2) + 1),i,j + 0.1); Obj.Scale.SetVector(1.5,1.8,1.5); end;

          'Н': begin Anm:= AddAnimDecor('Tree',i,j + 0.35+0.43,100,75,12); Anm.Scale.SetVector(1.3,1.3,1.3); Anm.MoveLast; Anm.Tag:= 997; end;
          'н': begin Anm:= AddAnimDecor('Tree',i,j + 0.2+0.43,100,75,12); Anm.Scale.SetVector(1.2,1.2,1.2); Anm.Tag:= 996; end;
          'й': begin Obj:= AddDecor('Snowman' + IntToStr(Random(2) + 1),i,j + 0.1+0.84); Obj.Scale.SetVector(1.5,1.8,1.5); Obj.RollAngle:= 45; end;
          'Й': begin Obj:= AddDecor('Snowman' + IntToStr(Random(2) + 1),i,j + 0.1+0.84); Obj.Scale.SetVector(1.5,1.8,1.5); Obj.RollAngle:= -45; end;

          'a': begin Obj:= AddDecor('d_thorns_down',i,j - 0.2); Obj.Tag:= 500; Game.CollisionsList.Add(Obj); end;
          'e': begin Obj:= AddDecor('d_thorns_up',i,j + 0.2); Obj.Tag:= 501; Game.CollisionsList.Add(Obj); end;
          'k': begin Obj:= AddDynamicPlatform(Scene,Player,MaterialLibrary,ODEManager,'dp_down',i,j,1); end;
          'K': begin Obj:= AddDynamicPlatform(Scene,Player,MaterialLibrary,ODEManager,'dp_down',i,j,0); end;
          'x': begin Obj:= AddBox(Game,Scene,MaterialLibrary,ODEManager,'box',i,j); end;
          'z': begin Obj:= AddFallingPlatform(Scene,Player,MaterialLibrary,ODEManager,'dp_down',i,j) end;
          'w': begin Obj:= AddIceVapour(Game.CollisionsList,Scene,IceVapourPFXManager,i,j); end;

          'ц': begin
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i+0.25,j,0);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i+0.25,j-0.5,0);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i-0.25,j,0);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i-0.25,j-0.5,0);
               end;
          'у': begin
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i+0.25,j,1);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i+0.25,j-0.5,1);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i-0.25,j,1);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i-0.25,j-0.5,1);
               end;
          'к': begin
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i+0.25,j,2);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i+0.25,j-0.5,2);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i-0.25,j,2);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i-0.25,j-0.5,2);
               end;
          'е': begin
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i+0.25,j,3);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i+0.25,j-0.5,3);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i-0.25,j,3);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i-0.25,j-0.5,3);
               end;
          'г': begin
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i+0.25,j,4);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i+0.25,j-0.5,4);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i-0.25,j,4);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i-0.25,j-0.5,4);
               end;
          'щ': begin
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i+0.25,j,5);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i+0.25,j-0.5,5);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i-0.25,j,5);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i-0.25,j-0.5,5);
               end;
          'з': begin
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i+0.25,j,6);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i+0.25,j-0.5,6);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i-0.25,j,6);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i-0.25,j-0.5,6);
               end;
          'ф': begin
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i+0.25,j,7);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i+0.25,j-0.5,7);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i-0.25,j,7);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i-0.25,j-0.5,7);
               end;
          'ы': begin
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i+0.25,j,8);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i+0.25,j-0.5,8);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i-0.25,j,8);
                 Obj:= AddDoor(Game,Scene,ODEManager,MaterialLibrary,'door',i-0.25,j-0.5,8);
               end;
               
          'ч': begin Obj:= AddDoorButton(Game,Scene,Player,MaterialLibrary,'button',i,j-0.2,0); end;
          'в': begin Obj:= AddDoorButton(Game,Scene,Player,MaterialLibrary,'button',i,j-0.2,1); end;
          'а': begin Obj:= AddDoorButton(Game,Scene,Player,MaterialLibrary,'button',i,j-0.2,2); end;
          'п': begin Obj:= AddDoorButton(Game,Scene,Player,MaterialLibrary,'button',i,j-0.2,3); end;
          'р': begin Obj:= AddDoorButton(Game,Scene,Player,MaterialLibrary,'button',i,j-0.2,4); end;
          'о': begin Obj:= AddDoorButton(Game,Scene,Player,MaterialLibrary,'button',i,j-0.2,5); end;
          'л': begin Obj:= AddDoorButton(Game,Scene,Player,MaterialLibrary,'button',i,j-0.2,6); end;
          'д': begin Obj:= AddDoorButton(Game,Scene,Player,MaterialLibrary,'button',i,j-0.2,7); end;
          'ж': begin Obj:= AddDoorButton(Game,Scene,Player,MaterialLibrary,'button',i,j-0.2,8); end;

          'ш': begin
                 Obj:= AddIceDoor(Scene,Game,GLCustomSpritePFXManager2,ODEManager,MaterialLibrary,'icedoor',i+0.25,j);
                 Obj:= AddIceDoor(Scene,Game,GLCustomSpritePFXManager2,ODEManager,MaterialLibrary,'icedoor',i+0.25,j-0.5);
                 Obj:= AddIceDoor(Scene,Game,GLCustomSpritePFXManager2,ODEManager,MaterialLibrary,'icedoor',i-0.25,j);
                 Obj:= AddIceDoor(Scene,Game,GLCustomSpritePFXManager2,ODEManager,MaterialLibrary,'icedoor',i-0.25,j-0.5);
               end;
          'P':
          begin
            Obj:= AddDecor('Decor4',i,j - 0.44);
            Obj.Scale.Y:= 0.7;
          end;
          'E':
          begin
            Obj:= AddDecor('Decor3',i,j + 0.22);
            Obj.Scale.Y:= 2;
            Obj.Scale.X:= 2;
          end;
          'W':
          begin
            Obj:= AddDecor('Decor2',i,j - 0.22);
            Obj.Tag:= 997;
            Obj.Scale.Y:= 1;
            Obj.Scale.X:= 1;
          end;
          'Q':
          begin
            Obj:= AddDecor('Decor1',i,j - 0.22);
          end;
          'H':
          begin
            Obj:= AddDecor('Decor5',i,j - 0.5);
            Obj.Scale.Y:= 3;
            Obj.MoveLast;
            Obj.Tag:= 997;
          end;
          'м':
          begin
            Obj:= AddDecor('Sugrob',i,j - 0.22);
          end;
          'М':
          begin
            Obj:= AddDecor('Sugrob',i,j + 0.22);
            Obj.RollAngle:= 45;
          end;
          'и':
          begin
            Obj:= AddDecor('Sugrob',i,j + 0.22);
            Obj.RollAngle:= -45;
          end;
          'c':
          begin
            Obj:= AddDecor('Ice',i,j - 0.44);
            Obj.Scale.SetVector(1,0.5,1);
            Obj.Tag:= 998;
          end; 
          'C':
          begin
            Obj:= AddDecor('Ice',i,j + 0.22);
            Obj.Scale.SetVector(1,0.5,1);
            Obj.RollAngle:= 45;
            Obj.Tag:= 998;
          end;
          'с':
          begin
            Obj:= AddDecor('Ice',i,j + 0.22);
            Obj.Scale.SetVector(1,0.5,1);
            Obj.RollAngle:= -45;
            Obj.Tag:= 998;
          end;
          
          'g': AddEnemy('Penguin2Move',PenguinMove,i,j - 0.15,96,96,16,3,false);
          'b': AddEnemy('PenguinMove',PenguinMove,i,j - 0.15,96,96,16,1,false);
          'l': AddEnemy('Bird_Fly',PenguinMove,i,j - 0.15,96,96,8,1,false);
          'ю': AddEnemy('Bird_Fly',PenguinMove,i,j - 0.15,96,96,8,0,true);
          'я': AddEnemy('Hegdehog_Move',PenguinMove,i,j - 0.15,96,96,8,0,true);
          'т': AddEnemy('SheepAttack',SheepMove,i,j - 0.15,96,96,16,5,false);
          's': AddBorder(i,j,0.1,1,930);
          'S': AddBorder(i,j,0.1,1,940);

          'A':
          begin
            Obj:= AddDecor('help_table',i,j - 0.33);
            Obj.Tag:= 4001;
            Obj.Scale.SetVector(0.7,0.7,0.7);
            Game.CollisionsList.Add(Obj);
          end;
          'D':
          begin
            Obj:= AddDecor('help_table',i,j - 0.33);
            Obj.Tag:= 4002;
            Obj.Scale.SetVector(0.7,0.7,0.7);
            Game.CollisionsList.Add(Obj);
          end;
          'F': 
          begin
            Obj:= AddDecor('help_table',i,j - 0.33);
            Obj.Tag:= 4003;
            Obj.Scale.SetVector(0.7,0.7,0.7);
            Game.CollisionsList.Add(Obj);
          end;
          'G': 
          begin
            Obj:= AddDecor('help_table',i,j - 0.33);
            Obj.Tag:= 4004;
            Obj.Scale.SetVector(0.7,0.7,0.7);
            Game.CollisionsList.Add(Obj);
          end;
          'B': 
          begin
            Obj:= AddDecor('help_table',i,j - 0.33);
            Obj.Tag:= 4005;
            Obj.Scale.SetVector(0.7,0.7,0.7);
            Game.CollisionsList.Add(Obj);
          end;
          'R': 
          begin
            Obj:= AddDecor('help_table',i,j - 0.33);
            Obj.Tag:= 4006;
            Obj.Scale.SetVector(0.7,0.7,0.7);
            Game.CollisionsList.Add(Obj);
          end;
          'V': 
          begin
            Obj:= AddDecor('help_table',i,j - 0.33);
            Obj.Tag:= 4007;
            Obj.Scale.SetVector(0.7,0.7,0.7);
            Game.CollisionsList.Add(Obj);
          end;
          'X': 
          begin
            Obj:= AddDecor('help_table',i,j - 0.33);
            Obj.Tag:= 4008;
            Obj.Scale.SetVector(0.7,0.7,0.7);
            Game.CollisionsList.Add(Obj);
          end;
          'L': 
          begin
            Obj:= AddDecor('help_table',i,j - 0.33);
            Obj.Tag:= 4009;
            Obj.Scale.SetVector(0.7,0.7,0.7);
            Game.CollisionsList.Add(Obj);
          end;

          '|': AddBorder(i,j,0.1,0.1,100);
          '''': AddBorder(i,j,1,1,200);
          'f': AddPartUp(i,j,FinishPFXManager,10);
          //'Ф': AddPartUp(i,j,TeleportPFXManager,960);

          'Ц': Obj:= AddWhirley(Game,Scene,ODEManager,MaterialLibrary,'whirley',i,j,0,0);
          'У': Obj:= AddWhirley(Game,Scene,ODEManager,MaterialLibrary,'whirley',i,j,0,1);

          'Ч': begin Obj:= AddWhirleyButton(Game,Scene,Player,MaterialLibrary,'button_2',i,j-0.2,0); end;
          {'в': begin Obj:= AddDoorButton(Game,Scene,Player,MaterialLibrary,'button',i,j-0.2,1); end;
          'а': begin Obj:= AddDoorButton(Game,Scene,Player,MaterialLibrary,'button',i,j-0.2,2); end;
          'п': begin Obj:= AddDoorButton(Game,Scene,Player,MaterialLibrary,'button',i,j-0.2,3); end;
          'р': begin Obj:= AddDoorButton(Game,Scene,Player,MaterialLibrary,'button',i,j-0.2,4); end;
          'о': begin Obj:= AddDoorButton(Game,Scene,Player,MaterialLibrary,'button',i,j-0.2,5); end;
          'л': begin Obj:= AddDoorButton(Game,Scene,Player,MaterialLibrary,'button',i,j-0.2,6); end;
          'д': begin Obj:= AddDoorButton(Game,Scene,Player,MaterialLibrary,'button',i,j-0.2,7); end;
          'ж': begin Obj:= AddDoorButton(Game,Scene,Player,MaterialLibrary,'button',i,j-0.2,8); end;}

          'p':
          begin
            dBodySetPosition(ODEManager.GetObj(Player.Name).Body,i,j,0);
            dBodySetForce(ODEManager.GetObj(Player.Name).Body,0,0,0);
            dBodySetLinearVel(ODEManager.GetObj(Player.Name).Body,0,0,0);
            
            Player.Position.SetPoint(i,j,0);
            Target.Position:= Player.Position;
          end;
        end;
      end;
    finally
      Pak.ClosePak;
    end;

    Game.MaxPosCam[1]:= j;

    CloseFile(F);

    for i:= 0 to Scene.Objects.Count - 1 do
    begin
      //if Scene.Objects[i].TagFloat = 100 then MoveLastObj(Scene.Objects[i]);
      if (Scene.Objects[i].Tag = 998) or (Scene.Objects[i].Tag = 2003) then
      begin
        Scene.Objects[i].MoveFirst;
        Target.MoveFirst;
      end;
      if Scene.Objects[i].Tag = 8 then Scene.Objects[i].MoveLast;
      if Scene.Objects[i].Tag = 997 then Scene.Objects[i].MoveLast;
    end;

    //SetEnabledSnow(True);
  except
    SetEnabledSnow(True);
    //SnowStep.Enabled:= True;
    Game.Timer:= 0;
    Game.RoomsManager.GoToRoom('WinGame');

    l_back .Visible := False;
    l_back2.Visible := False;
    l_back3.Visible := False;

    Player.Visible:= False;
    Shadow.Visible:= False;
    Player.pPlayer.Visible:= False;
  end;

  AssignFile(F,'C:\fsLevel.txt');
  Rewrite(F);

  for i:= 0 to Scene.Objects.Count-1 do
    if trim(Scene.Objects[i].Entity) <> '' then
      WriteLn(F,Scene.Objects[i].Entity);

  CloseFile(F);
end;

procedure nearCallback(data: pointer; o1,o2: PdxGeom);cdecl;
var 
  i,n: integer;
  b1,b2: PdxBody;
  c: TdJointID;
  Contact: array of TdContact;
begin
  SetLength(contact,cContacts);

  b1:= dGeomGetBody(o1);
  b2:= dGeomGetBody(o2);

  if (assigned(b1) and assigned(b2) and (dAreConnected(b1,b2) <> 0)) then exit;

  n:= dCollide (o1, o2, cContacts,contact[0].geom,sizeof(TdContact));

  if (n > 0) then
  begin
    for i := 0 to n - 1 do
    begin
      contact[i].surface.mode:= ord(dContactBounce);

      contact[i].surface.mu:= 1;
      contact[i].surface.mu2:= 0;
      contact[i].surface.bounce:= 0;
      contact[i].surface.bounce_vel:= 0;

      c:= dJointCreateContact(fMain.mOde.world,fMain.mOde.contactgroup,@contact[i]);
      dJointAttach(c,dGeomGetBody(contact[i].geom.g1),dGeomGetBody(contact[i].geom.g2));
    end;
  end;
end;

procedure TfMain.ScanOnGround;
Var
  i: Integer;
begin
  for i:= 0 to ODEManager.Count - 1 do
    if (ODEManager.Objs[i].ODEType = otStatic) or (ODEManager.Objs[i].ODEType = otDynamic) then
      if (ODEManager.Objs[i].Data <> nil) and (ODEManager.Objs[i].Data.Name <> 'Player') then
        if (ODEManager.Objs[i].Data.TagFloat = 1) or (ODEManager.Objs[i].Data.TagFloat = 2) or (ODEManager.Objs[i].ODEType = otDynamic) then
          if (ODEManager.Objs[i].Data as TGLCustomSceneObject).Material.FrontProperties.Diffuse.Alpha > 0 then
      with ODEManager.Objs[i].Data do
      begin
        if abs(RollAngle) = 90 then
        if (Player.Position.Y - cRadius <= Position.Y + (ODEManager.Objs[i].lx / 2)) and
           (Player.Position.Y + cRadius >= Position.Y - (ODEManager.Objs[i].lx / 2)) and
           (Player.Position.X + (cRadius - 0.01) > Position.X - (ODEManager.Objs[i].ly / 2)) and
           (Player.Position.X - (cRadius - 0.01) < Position.X + (ODEManager.Objs[i].ly / 2))
        then begin Player.OnGround:= True; Exit; end
        else Player.OnGround:= False;

        if abs(RollAngle) <> 90 then
        if (Player.Position.Y - cRadius <= Position.Y + (ODEManager.Objs[i].ly / 2)) and
           (Player.Position.Y + cRadius >= Position.Y - (ODEManager.Objs[i].ly / 2)) and
           (Player.Position.X + (cRadius - 0.01) > Position.X - (ODEManager.Objs[i].lx / 2)) and
           (Player.Position.X - (cRadius - 0.01) < Position.X + (ODEManager.Objs[i].lx / 2))
        then begin Player.OnGround:= True; Exit; end
        else Player.OnGround:= False;
      end;

  {if (dBodyGetAngularVel(ODEManager.GetObj('Player').Body)[1] >= -0.5) and
     (dBodyGetAngularVel(ODEManager.GetObj('Player').Body)[1] <= 0) then Player.OnGround:= True
  else Player.OnGround:= False;}
end;

//* Rooms *//
//
procedure LoBoSoFt(deltaTime: Double);
begin
  with fMain do
  begin
    Game.Timer:= Game.Timer + 1;
    SetVisibleCursor(False);

    if Game.Timer = 1 then
    begin
      DrawLobosoft(Game.PanelsManager,Pak);

      SetEnabledSnow(True);
      Snow.Visible:= False;

      FreeAudio(Game.BassStream);
      InitAudio(Handle);
      
      if Game.onMusic then PlayAudio(Game.BassStream,Game.MainDir + '\Music\Menu.ogg',True);
    end;
    if Game.Timer < 100 then SmoothHideObject(Black.Material,0);
    if (Game.Timer < 200) and (Game.Timer > 150) then SmoothShowObject(Black.Material,1);
    if (Game.Timer < 250) and (Game.Timer > 200) then begin Game.Timer:= 0; Game.RoomsManager.NextRoom; end;
  end;
end;

procedure HellRoom(deltaTime: Double);
begin
  with fMain do
  begin
    Game.Timer:= Game.Timer + 1;
    SetVisibleCursor(False);

    if Game.Timer = 1 then
    begin
      DrawHellroom(Game.PanelsManager,Pak);
      InitAudio(Handle);

      SetEnabledSnow(True);
      Snow.Visible:= False;
    end;
    if Game.Timer < 100 then SmoothHideObject(Black.Material,0);
    if (Game.Timer < 200) and (Game.Timer > 150) then SmoothShowObject(Black.Material,1);
    if (Game.Timer < 250) and (Game.Timer > 200) then
    begin
      Game.Timer:= 0;
      Game.RoomsManager.NextRoom;
    end;
  end;
end;

procedure MainMenu(deltaTime: Double);
begin
  with fMain do
  begin
    Game.Timer:= Game.Timer + 1;
    SetVisibleCursor(True);
    //SmoothHideObject(Black.Material,0);

    if Game.Timer = 1 then
    begin
      DrawMainMenu(Game.PanelsManager,Pak);

      Snow.Visible:= True;
      ScoreText.Visible:= False;
      LivesText.Visible:= False;
      HSText.Visible:= False;
      HSPlayerName.Visible:= False;
      HSNames.Visible:= False;
      HSScores.Visible:= False;
      Dialog.Visible:= False;
      TitleText.Visible:= False;
    end;
    if Game.Timer < 100 then SmoothHideObject(Black.Material,0);
    if Game.Timer < 150 then
    begin
      Game.Timer:= 101;
      SmoothHideObject(Black.Material,0);

      if Game.PanelsManager.Panel('btnStartGame').Click then Game.Timer:= 151;
      if Game.PanelsManager.Panel('btnLoadGame').Click then Game.Timer:= 251;
      if Game.PanelsManager.Panel('btnExitGame').Click then Game.Timer:= 351;
    end;
    //* StartGame *//
    if (Game.Timer < 200) and (Game.Timer > 150) then SmoothShowObject(Black.Material,1);
    if (Game.Timer < 250) and (Game.Timer > 200) then
    begin
      FreeAudio(Game.BassStream);
      Game.NullAll;
      Game.CurrentLevel:= 1;
      Game.RoomsManager.NextRoom;
    end;
    //* LoadGame *//
    if (Game.Timer < 300) and (Game.Timer > 250) then SmoothShowObject(Black.Material,1);
    if (Game.Timer < 350) and (Game.Timer > 300) then
    begin
      FreeAudio(Game.BassStream);

      try
        Game.Load(Game.MainDir + '\Save.sav');
      except
        Game.NullAll;
        Game.CurrentLevel:= 1;
        Game.RoomsManager.NextRoom;
      end;
    end;
    //* ExitGame *//
    if (Game.Timer < 400) and (Game.Timer > 350) then SmoothShowObject(Black.Material,1);
    if (Game.Timer < 450) and (Game.Timer > 400) then begin FreeAudio(Game.BassStream); Application.Terminate; end;
  end;
end;

procedure Level(deltaTime: Double);
var
  i: Integer;
  Obj: TBaseGameObject;
begin
  with fMain do
  begin
    Game.Timer:= Game.Timer + 1;
    //SetVisibleCursor(False);

    if Game.Timer = 1 then
    begin
      DrawLevelPanels(Game.PanelsManager,Pak,World);

      Game.PanelsManager.Panel('MessageBKLeft').OnProgress:= DialogProgress2;
      Game.PanelsManager.Panel('MessageBKRight').OnProgress:= DialogProgress2;
      Game.PanelsManager.Panel('MessageBKCenter').OnProgress:= DialogProgress2;
      Game.PanelsManager.Panel('MessageBKPimp').OnProgress:= DialogProgress2;

      Randomize;
      Texts.Visible:= True;
      ScoreText.Visible:= True;
      LivesText.Visible:= True;
      Dialog.Visible:= True;
      TitleText.Visible:= True;
      LoadLevel(Game.MainDir + '\Levels\Level' + IntToStr(Game.CurrentLevel) + '.fsl');
      Paused:= False;

      TitleText.ModulateColor.Alpha:= 1;
      TitleText.Text:= 'Уровень' + IntToStr(Game.CurrentLevel);;

      if Game.onMusic then
      begin
        if not Game.isLoad then
        begin
          if Game.CurrentLevel = 1 then
          begin
            FreeAudio(Game.BassStream);
            InitAudio(Handle);
            PlayAudio(Game.BassStream,Game.MainDir + '\Music\World_1\Music_1.ogg',True);
          end;
          if Game.CurrentLevel = 6 then
          begin
            FreeAudio(Game.BassStream);
            InitAudio(Handle);
            PlayAudio(Game.BassStream,Game.MainDir + '\Music\World_1\Music_2.ogg',True);
          end;
          if Game.CurrentLevel = 11 then
          begin
            FreeAudio(Game.BassStream);
            InitAudio(Handle);
            PlayAudio(Game.BassStream,Game.MainDir + '\Music\World_2\Music_1.ogg',True);
          end;
          if Game.CurrentLevel = 16 then
          begin
            FreeAudio(Game.BassStream);
            InitAudio(Handle);
            PlayAudio(Game.BassStream,Game.MainDir + '\Music\World_2\Music_2.ogg',True);
          end;
        end
        else
        begin
          if Game.CurrentLevel < 6 then
          begin
            FreeAudio(Game.BassStream);
            InitAudio(Handle);
            PlayAudio(Game.BassStream,Game.MainDir + '\Music\World_1\Music_1.ogg',True);
          end;
          if (Game.CurrentLevel < 11) and (Game.CurrentLevel > 5) then
          begin
            FreeAudio(Game.BassStream);
            InitAudio(Handle);
            PlayAudio(Game.BassStream,Game.MainDir + '\Music\World_1\Music_2.ogg',True);
          end;
          if (Game.CurrentLevel < 16) and (Game.CurrentLevel > 10) then
          begin
            FreeAudio(Game.BassStream);
            InitAudio(Handle);
            PlayAudio(Game.BassStream,Game.MainDir + '\Music\World_2\Music_1.ogg',True);
          end;
          if (Game.CurrentLevel < 21) and (Game.CurrentLevel > 15) then
          begin
            FreeAudio(Game.BassStream);
            InitAudio(Handle);
            PlayAudio(Game.BassStream,Game.MainDir + '\Music\World_2\Music_2.ogg',True);
          end;
        end;
      end;
      if Game.isLoad then
      begin
        dBodySetPosition(ODEManager.GetObj(Player.Name).Body,Game.PPX,Game.PPY,0);
        Player.Position.SetPoint(Game.PPX,Game.PPY,0);
        Target.Position:= Player.Position;

        Game.PPX:= 0;
        Game.PPY:= 0;

        for i:= 0 to Game.Points.Count - 1 do
          if Scene.FindSceneObject(Game.Points[i]) <> nil then
            Scene.FindSceneObject(Game.Points[i]).Visible:= False;

        Game.isLoad:= False;
      end;
    end;
    if Game.Timer = 25 then
    begin
      //FreeAudio(Game.BassStream);
      InitAudio(Handle);
      //if Game.onMusic then PlayAudio(Game.BassStream,Game.MainDir + '\Music\World_' + IntToStr(Random(5) + 1) + '.ogg',True);
    end;
    if Game.Timer < 100 then SmoothHideObject(Black.Material,0);
    if Game.Timer < 150 then
    begin
      Game.Timer:= 101;

      Player.MoveLast;
      Player.Eff.MoveLast;

      if Game.ReadDialog then
      begin
        //if Black.Material.FrontProperties.Diffuse.Alpha < 0.5 then
        begin
          SmoothShowObject(Black.Material,0.5);
        end;
      end
      else SmoothHideObject(Black.Material,0);

      SmoothHideObject2(White.Material,0);

      if not Game.GameOver then
      begin
        ScanOnGround;
        StepShadow;
        Player.Step(DeltaTime);

        for i:= 0 to Game.StepsList.Count - 1 do
        begin
          Obj:= Game.StepsList.Items[i];
          if Obj.Visible then Obj.Step(Obj,deltaTime);
        end;
        {for i:= 0 to Scene.Objects.Count - 1 do
        begin
          if (Scene.Objects[i].TagFloat = 1) and (Scene.Objects[i].Visible) then
          begin
            Obj:= Scene.Objects[i] as TBaseGameObject;
            Obj.Step(Obj,deltaTime);
          end;
        end;}

        ODEManager.Step(DeltaTime,nearCallback);

        if Paused then
        begin
          Game.PanelsManager.Panel('btnRestartGameP').Visible:= True;
          Game.PanelsManager.Panel('btnExitGameP').Visible:= True;
          //Game.PanelsManager.Panel('PausedBack').Visible:= True;
          Game.PanelsManager.Panel('PausedText').Visible:= True;

          //SetEnabledSnow(False);
          SetVisibleCursor(True);

          Game.Timer:= 151;
        end else SetVisibleCursor(False);
      end
      else
      begin
        Player.Explode.RingExplosion(1,15,0.1,XVector,YVector);
        Texts.Visible:= False;
        Player.pPlayer.Visible:= False;

        Game.CollisionsList.Clear;
        Game.StepsList.Clear;
        Game.ButtonsList.Clear;

        Game.Timer:= 251;
      end;
    end;
    if (Game.Timer < 250) and (Game.Timer > 150) then
    begin
      //Timer:= 151;

      if (Game.Timer < 200) and (Game.Timer > 150) then SmoothShowObject(Black.Material,0.4);
      if (Game.Timer < 250) and (Game.Timer > 200) then Game.Timer:= 201;

      Blink(Game.PanelsManager.Panel('PausedText').Leav.Material,BlinkI);

      if not Paused then
      begin
        Game.PanelsManager.Panel('PausedBack').Visible:= False;
        Game.PanelsManager.Panel('PausedText').Visible:= False;
        Game.PanelsManager.Panel('PausedText').Material.FrontProperties.Diffuse.Alpha:= 1;
        Game.PanelsManager.Panel('btnRestartGameP').Visible:= False;
        Game.PanelsManager.Panel('btnExitGameP').Visible:= False;

        //SetEnabledSnow(True);

        Game.Timer:= 101;
      end;

      if Game.PanelsManager.Panel('btnRestartGameP').Click then
      begin
        Game.Timer:= 500;
        
        Game.Points.Clear;
        Game.CollisionsList.Clear;
        Game.StepsList.Clear;
        Game.ButtonsList.Clear;

        Paused:= False;
        
        Game.PanelsManager.Panel('PausedBack').Visible:= False;
        Game.PanelsManager.Panel('PausedText').Visible:= False;
        Game.PanelsManager.Panel('PausedText').Material.FrontProperties.Diffuse.Alpha:= 1;
        Game.PanelsManager.Panel('btnRestartGameP').Visible:= False;
        Game.PanelsManager.Panel('btnExitGameP').Visible:= False;
      end;
      if Game.PanelsManager.Panel('btnExitGameP').Click then
      begin
        Game.Timer:= 600;
        
        Game.Points.Clear;
        Game.CollisionsList.Clear;
        Game.StepsList.Clear;
        Game.ButtonsList.Clear;

        Paused:= False;

        Game.PanelsManager.Panel('PausedBack').Visible:= False;
        Game.PanelsManager.Panel('PausedText').Visible:= False;
        Game.PanelsManager.Panel('PausedText').Material.FrontProperties.Diffuse.Alpha:= 1;
        Game.PanelsManager.Panel('btnRestartGameP').Visible:= False;
        Game.PanelsManager.Panel('btnExitGameP').Visible:= False;
      end;
    end;

    {if (Timer < 300) and (Timer > 250) then
    begin
      Texts.Visible:= False;
      Player.pPlayer.Visible:= False;
    end;}
    if (Game.Timer < 350) and (Game.Timer > 300) then SmoothShowObject(Black.Material,1);
    if (Game.Timer < 400) and (Game.Timer > 350) then begin Game.Timer:= 0; Game.RoomsManager.GoToRoom('HightScore'); end;
    if (Game.Timer < 450) and (Game.Timer > 400) then SmoothShowObject(Black.Material,1);
    if (Game.Timer < 500) and (Game.Timer > 450) then
    begin
      Game.Timer:= 0;
      Game.BScore:= Game.Score;
      Game.BLives:= Game.Lives;
      Game.CurrentLevel:= Game.CurrentLevel + 1;
      Game.RoomsManager.GoToRoom('Level');
    end;

    if (Game.Timer < 550) and (Game.Timer > 500) then SmoothShowObject(Black.Material,1);
    if (Game.Timer < 600) and (Game.Timer > 550) then
    begin
      Game.Timer:= 0;
      Game.Score:= Game.BScore;
      Game.Lives:= Game.BLives;
      Game.RoomsManager.GoToRoom('Level');
    end;

    if (Game.Timer < 650) and (Game.Timer > 600) then SmoothShowObject(Black.Material,1);
    if (Game.Timer > 650) and (Game.Timer < 700) then
    begin
      Game.Timer:= 0;
      Game.RoomsManager.GoToRoom('MainMenu');
    end;

    if (Game.Timer < 750) and (Game.Timer > 700) then SmoothShowObject(Black.Material,1);
    if (Game.Timer > 750) then
    begin
      Game.Timer:= 0;
      Game.RoomsManager.GoToRoom('WinGame');
    end;
  end;
end;

procedure HightScore(deltaTime: Double);
var
  i: Integer;
begin
  with fMain do
  begin
    Game.Timer:= Game.Timer + 1;
    SetVisibleCursor(False);

    if Game.Timer = 1 then
    begin
      DrawWinPanels(Game.PanelsManager,Pak);
      l_back.Visible:= False;
      l_back2.Visible:= False;
      Game.isHS:= True;
      HSText.Visible:= True;
      HSText.Text:= 'Введите Ваше имя:';
      HSText.Position.Y:= 260;
      Shadow.Visible:= False;
      Texts.Visible:= True;
      HSPlayerName.Visible:= True;
      ScoreText.Visible:= False;
      LivesText.Visible:= False;
      AnyKey:= False;
      OnKeyEnter:= False;

      try
        HS.LoadFromFile(Game.MainDir + '\HightScore.dat');
      except
        for i:= 1 to 10 do HS.AddToTable('Nobody',0);
        HS.SaveToFile(Game.MainDir + '\HightScore.dat');
      end;
    end;
    if Game.Timer < 100 then
    begin
      Game.Timer:= 2;
      SmoothHideObject(Black.Material,0);

      //if not  then
      if OnKeyEnter then
      begin
        Game.isHS:= False;
        Game.isHS2:= True;
      end;

      if Game.isHS2 then
      begin
        Game.isHS2:= False;
      end;

      if not Game.isHS then
      begin
        HSPlayerName.Visible:= False;

        HSText.Position.Y:= 30;
        HSText.Text:= 'Нажмите любую клавишу';

        if (AnyKey) and (not OnKeyEnter) then Game.Timer:= 101;
      end
    end;
    if (Game.Timer < 150) and (Game.Timer > 100) then SmoothShowObject(Black.Material,1);
    if (Game.Timer < 200) and (Game.Timer > 150) then
    begin
      Game.Timer:= 0;
      Game.RoomsManager.GoToRoom('MainMenu');
    end;
  end;
end;

procedure WinGame(deltaTime: Double);
begin
  with fMain do
  begin
    Game.Timer:= Game.Timer + 1;
    SetVisibleCursor(False);

    if Game.Timer = 1 then
    begin
      //Texts.Visible:= False;
      DrawWinPanels(Game.PanelsManager,Pak);
      TitleText.ModulateColor.Alpha:= 0;
      AnyKey:= False;

      HSText.Visible:= True;
      Game.Score:= Game.Score*2;
      HSText.Text:= 'Поздравляем! Вы прошли всю игру.' +#13+
                    'Ваши очки удваиваются: ' + IntToStr(Game.Score);
      HSText.Position.Y:= 260;
      Texts.Visible:= True;
      ScoreText.Visible:= False;
      LivesText.Visible:= False;
    end;
    if Game.Timer < 100 then
    begin
      Game.Timer:= 2;
      SmoothHideObject(Black.Material,0);

      if AnyKey then Game.Timer:= 101;
    end;
    if (Game.Timer < 150) and (Game.Timer > 100) then SmoothShowObject(Black.Material,1);
    if (Game.Timer < 200) and (Game.Timer > 150) then
    begin
      Game.Timer:= 0;
      Game.RoomsManager.GoToRoom('HightScore');
    end;
  end;
end;

//* TfMain *//
//
procedure TfMain.DrawRooms;
begin
  with Game.RoomsManager.AddRoom do begin Step:= LoBoSoFt; Name:= 'LoBoSoFt'; end;
  with Game.RoomsManager.AddRoom do begin Step:= HellRoom; Name:= 'HellRoom'; end;
  with Game.RoomsManager.AddRoom do begin Step:= MainMenu; Name:= 'MainMenu'; end;
  with Game.RoomsManager.AddRoom do begin Step:= Level; Name:= 'Level'; end;
  with Game.RoomsManager.AddRoom do begin Step:= HightScore; Name:= 'HightScore'; end;
  with Game.RoomsManager.AddRoom do begin Step:= WinGame; Name:= 'WinGame'; end;
end;

procedure TfMain.GLCustomSpritePFXManager1PrepareTextureImage(
  Sender: TObject; destBmp32: TGLBitmap32; var texFormat: Integer);
var
  bmp: TBitmap;
begin
  Pak.OpenPak(Game.MainDir + '\Packeges\World1.pak');

  try
    bmp:= TBitmap.Create;
    bmp.LoadFromFile(Pak.ExtractFormPak('mask.bmp'));
    destBmp32.Assign(bmp);
  finally
    Pak.ClosePak;
    FreeAndNil(bmp);
  end;
end;

procedure TfMain.StepProgress(Sender: TObject; const deltaTime,
  newTime: Double);
Var
  S1,S2: String;
begin
  StepSnow;
  Scn.Invalidate;
  Game.RoomsManager.Step(deltaTime);
  Game.PanelsManager.OnMouseMove(mX,mY);

  //Player.MoveLast;
  Snow.MoveLast;
  Game.PanelsManager.MoveLast;

  if Game.PanelsManager.Panel('MessageBKLeft') <> nil then
     Game.PanelsManager.Panel('MessageBKLeft').MoveLast;
  if Game.PanelsManager.Panel('MessageBKRight') <> nil then
     Game.PanelsManager.Panel('MessageBKRight').MoveLast;
  if Game.PanelsManager.Panel('MessageBKCenter') <> nil then
     Game.PanelsManager.Panel('MessageBKCenter').MoveLast;
  if Game.PanelsManager.Panel('MessageBKPimp') <> nil then
     Game.PanelsManager.Panel('MessageBKPimp').MoveLast;

  Texts.MoveLast;
  White.MoveLast;
  Black.MoveLast;
  Dialog.MoveLast;

  Player.pPlayer.Position.Y:= Player.Position.Y + Player.AY;
  Player.pPlayer.Position.X:= Player.Position.X;
  Player.Eff.Position:= Player.Position;

  if Screen.Cursor <> crNone then Screen.Cursor:= crNone;

  if Game.Score < 10 then S1:= '    ';
  if (Game.Score < 100) and (Game.Score > 9) then S1:= '   ';
  if (Game.Score < 999) and (Game.Score > 99) then S1:= '  ';
  if (Game.Score < 9999) and (Game.Score > 999) then S1:= ' ';
  if (Game.Score < 99999) and (Game.Score > 9999) then S1:= '';

  if Game.Score > 99999 then Game.Score:= 99999;

  if Game.Lives > 20 then Game.Lives:= 20;
  if Game.Lives < 10 then S2:= '    ';
  if (Game.Lives < 100) and (Game.Lives > 9) then S2:= '   ';
  if Game.Lives <= 0 then
  begin
    Player.Visible:= False;
    Game.Lives:= 0;
    Game.GameOver:= True;
  end;

  ScoreText.Text:= ':' + S1 + IntToStr(Game.Score);
  LivesText.Text:= ':' + S2 + IntToStr(Game.Lives);

  if Game.PanelsManager.Panel('PausedText') <> nil then
     Game.PanelsManager.Panel('PausedText').MoveLast;

  if Game.PanelsManager.Panel('btnRestartGameP') <> nil then
     Game.PanelsManager.Panel('btnRestartGameP').MoveLast;

  if Game.PanelsManager.Panel('btnExitGameP') <> nil then
     Game.PanelsManager.Panel('btnExitGameP').MoveLast;

  Game.PanelsManager.Cursor.MoveLast;

  (Snow.Effects[0] as TGLSourcePFXEffect).InitialPosition.X:= Target.Position.X;
  (Snow.Effects[0] as TGLSourcePFXEffect).InitialPosition.Y:= Target.Position.Y + 1.2;
  (Snow.Effects[1] as TGLSourcePFXEffect).InitialPosition.X:= Target.Position.X;
  (Snow.Effects[1] as TGLSourcePFXEffect).InitialPosition.Y:= Target.Position.Y + 1.2;

  if Game.isHS then
  begin
    HSPlayerName.Text:= Player.HSName + '_';
  end;
end;

procedure TfMain.ScnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Game.PanelsManager.OnMouseDown;
end;

procedure TfMain.ScnMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  mX:= X; mY:= Y;
end;

procedure TfMain.ScnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Game.PanelsManager.OnMouseUp(X,Y);
end;

procedure TfMain.FreeAll;
begin
  Screen.Cursor:= crDefault;
  Game.RoomsManager.Destroy;
  Pak.Destroy;
  ODEManager.Destroy;
  FreeAudio(Game.BassStream);
  Scn.Free;
end;

procedure TfMain.FormDestroy(Sender: TObject);
begin
  FreeAll;
end;

procedure TfMain.CreateAll;
begin
  HS:= THightScore.Create;
  Pak:= TPak.Create;
  mOde:= TOde.Create;
  Device:= TDevice.Create;
  ODEManager:= TODEManager.Create;
  Shadow:= TGLPlane(Scene.Objects.AddNewChild(TGLPlane));

  Player:= TPlayer(Scene.Objects.AddNewChild(TPlayer));
  Player.pPlayer:= TGLPlane(Scene.Objects.AddNewChild(TGLPlane));

  Game:= TGame.Create;
  Player.Game:= Game;
  Game.PanelsManager:= TPanelsManager(Scene.Objects.AddNewChild(TPanelsManager));
  Game.PanelsManager.Cursor:= TPCursor(Scene.Objects.AddNewChild(TPCursor));
  Game.RoomsManager:= TRoomsManager.Create;

  Game.MainFont:= TGLBitmapFontNFW.Create(nil);
  Game.TitleFont:= TGLBitmapFontNFW.Create(nil);
end;

procedure TfMain.InitAll;
Var
  i: integer;
  Plane: TGLPlane;
begin
  World:= 1;
  Game.MainDir:= ExtractFilePath(Application.ExeName);
  Pak.MainDir:= Game.MainDir;
  Pak.Key:= 'FS';

  ODEManager.Ode:= mOde;

  Shadow.Scale.Y:= 0.2;
  Shadow.Scale.X:= 0.8;
  Shadow.Tag:= 999;

  Game.PanelsManager.Tag:= 999;
  Game.RoomsManager.PanelsManager:= Game.PanelsManager;
  Game.RoomsManager.Scene:= Scene;
  Game.RoomsManager.ODEManager:= ODEManager;
  Game.Player:= Player;
  Game.White:= White;
  Game.Black:= Black;
  Game.Dialog:= Dialog;

  Snow.Direction.SetVector(0,1,0);
  Snow.Position.SetPoint(0,2,0);
  Game.CurrentLevel:= 1;
  BlinkI:= -1;
  Player.ODEManager:= ODEManager;
  Player.Camera:= Camera;
  MusicN:= 1;

  for i:= 1 to 2 do
  begin
    Plane:= TGLPlane(Scene.Objects.AddNewChild(TGLPlane));
    Plane.Name:= 'CO_' + IntToStr(i);
    Plane.Visible:= False;
    Plane.TagFloat:= 2;
    Plane.Tag:= 999;

    with ODEManager.AddObj(Plane,otStatic,gtBox) do
    begin
      SetScale(1,0.6,1);
      Init;
      Tag:= 999;
    end;
  end;

  for i:= 1 to 2 do
  begin
    Plane:= TGLPlane(Scene.Objects.AddNewChild(TGLPlane));
    Plane.Name:= 'CO_2_' + IntToStr(i);
    Plane.Visible:= False;
    Plane.Tag:= 999;

    with ODEManager.AddObj(Plane,otStatic,gtBox) do
    begin
      SetScale(1,1,1);
      Init;
      Tag:= 999;
    end;
  end;

  {with ODEManager.AddObj(Plane,otStatic,gtBox) do
  begin
    SetScale(1,1,1);
    Init;
    Tag:= 999;
  end;}

  Device.SterParam(800,600,32,85);

  try
    Pak.OpenPak(Game.MainDir + '\Packeges\Fonts.pak');
    PanelFont.LoadFromPngTexture(Pak.ExtractFormPak('Nums.png'));

    Game.MainFont.PathGGFnt:= Pak.ExtractFormPak('Main.nfw');
    Game.MainFont.LoadFromPngTexture(Pak.ExtractFormPak('Main.png'));

    Game.TitleFont.PathGGFnt:= Pak.ExtractFormPak('Title.nfw');
    Game.TitleFont.LoadFromPngTexture(Pak.ExtractFormPak('Title.png'));

    HSPlayerName.BitmapFont:= Game.MainFont;
    HSNames.BitmapFont:= Game.MainFont;
    HSScores.BitmapFont:= Game.MainFont;
    HSText.BitmapFont:=  Game.MainFont;

    Dialog.BitmapFont:=  Game.MainFont;
    TitleText.BitmapFont:= Game.TitleFont;
  finally
    Pak.ClosePak;
  end;
end;

procedure TfMain.LoadOptions;
Var
  F: TextFile;
  S: String;
begin
  try
    AssignFile(F,'Options.ini');
    Reset(F);

    ReadLn(F,S);
    if S = '[music:1]' then Game.onMusic:= True
    else if S = '[music:0]' then Game.onMusic:= False
    else Game.onMusic:= True;

    ReadLn(F,S);
    if S = '[sound:1]' then Game.onSound:= True
    else if S = '[sound:0]' then Game.onSound:= False
    else Game.onSound:= True;

    CloseFile(F);
  except
    Game.onMusic:= True;
    Game.onSound:= True;
  end;

  Device.FullScreen(fMain);
  Scn.Width:= Device.Width;
  Scn.Height:= Device.Height;
end;

procedure TfMain.LoadTexts(A: Boolean);
Var
  i,j: Integer;
  S, Ext: String;
begin
  with Shadow do
  begin
    try
      Pak.OpenPak(Pak.MainDir + '\Packeges\World'+IntToStr(World)+'.pak');
      Material.Texture.Enabled:= True;
      Material.Texture.TextureWrap:= twNone;
      SetMaterialPngTexture(Pak.ExtractFormPak('Shadow.png'),Material);
      Visible:= False;
    finally
      Pak.ClosePak;
    end;
  end;

  if not A then
  with Player do
  begin
    pPlayer.Name:= 'pPlayer';
    pPlayer.Tag:= 999;
    pPlayer.Scale.SetVector(0.8,0.8,0.8);
    Name:= 'Player';
    Dir:= 1;
    Tag:= 999;
    Init;
    Explode.Cadencer:= fMain.Step;
  end;

  with Player.pPlayer do
  begin
    try
      Pak.OpenPak(Pak.MainDir + '\Packeges\World'+IntToStr(World)+'.pak');
      Material.Texture.Enabled:= True;
      Material.Texture.TextureWrap:= twNone;
      SetMaterialPngTexture(Pak.ExtractFormPak('Player.png'),Material);
      Visible:= False;
    finally
      Pak.ClosePak;
    end;
  end;

  with Game.PanelsManager.Cursor do
  begin
    Name:= 'Cursor';
    Width:= 40;
    Height:= 40;
    Tag:= 999;

    try
      Pak.OpenPak(Pak.MainDir + '\Packeges\MainMenu.pak');
      Material.Texture.Enabled:= True;
      Material.Texture.TextureWrap:= twNone;
      SetMaterialPngTexture(Pak.ExtractFormPak('Cursor.png'),Material);
    finally
      Pak.ClosePak;
    end;
  end;

  try
    Pak.OpenPak(Game.MainDir + '\Packeges\World'+IntToStr(World)+'.pak');

    for i:= 0 to Pak.StreamList.Count - 1 do
    begin
      if Pak.StreamList[i] <> 'Ice.bmp' then
      with MaterialLibrary.Materials.Add do
      begin
        S:= Pak.ExtractFormPak(Pak.StreamList[i]);
        Name:= ChangeFileExt(Pak.StreamList[i],'');
        Ext:= ExtractFileExt(S);

        if CompareText('.png',Ext) = 0 then SetMaterialPngTexture(S,Material)
        else
        begin
          Material.Texture.Enabled:= True;
          Material.BlendingMode:= bmTransparency;
          Material.Texture.Image.LoadFromFile(S);
          Material.Texture.ImageAlpha:= tiaAlphaFromIntensity;
          Material.Texture.TextureMode:= tmReplace;
        end;

        //if Name= 'Sugrob' then
        //  Material.Texture.ImageGamma:= 8;

        Material.Texture.TextureWrap:= twNone;
        Tag:= MaterialLibrary.Materials.Count;
      end;

      for j:= 0 to 4 do
        if ChangeFileExt(Pak.StreamList[i],'') = 'platform7_' + IntToStr(j) then
        begin
          with MaterialLibrary.Materials.Add do
          begin
            S:= Pak.ExtractFormPak(Pak.StreamList[i]);
            Name:= 'tilted_' + ChangeFileExt(Pak.StreamList[i],'');
            Ext:= ExtractFileExt(S);
            TextureScale.X:= 1.42;

            if CompareText('.png',Ext) = 0 then SetMaterialPngTexture(S,Material)
            else
            begin
              Material.Texture.Enabled:= True;
              Material.BlendingMode:= bmTransparency;
              Material.Texture.Image.LoadFromFile(S);
              Material.Texture.ImageAlpha:= tiaAlphaFromIntensity;
              Material.Texture.TextureMode:= tmReplace;
            end;

            Material.Texture.TextureWrap:= twHorizontal;
            Tag:= MaterialLibrary.Materials.Count;
          end;
        end;
    end;

    if World <> 3 then
    with MaterialLibrary.Materials.Add do
    begin
      Name:= 'Tree';

      with Material.Texture do
      begin
        Enabled:= True;
        Image.LoadFromFile(Pak.ExtractFormPak('Tree.tga'));
        TextureMode:= tmModulate;
        ImageAlpha:= tiaSuperBlackTransparent;
      end;

      Tag:= MaterialLibrary.Materials.Count;
      Material.FrontProperties.Diffuse.SetColor(1,1,1,0.7);
      Material.BlendingMode:= bmTransparency;
    end;
  finally
    Pak.ClosePak;
  end;
end;

procedure TfMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
//  Abort;
end;

procedure TfMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  bmp: TBitmap;
begin
  AnyKey:= True;
  
  if (Key = KeyEscape) and (not OnkeyEsc) then
  begin
    if Paused then Paused:= False
    else Paused:= True;
    OnkeyEsc:= True;
  end;

  if OnKey('g') then Game.Lives:= Game.Lives + 1;
  if OnKey(keyF5) then
  begin
    //Scn.Buffer.RenderToFile('C:\ScreenShot.bmp');
    //Scn.Buffer.CopyToTexture(GLMaterialLibrary1.Materials[0].Material.Texture);
    //Scn.Buffer.CopyToTexture(GLMaterialLibrary1.Materials[0].Material.Texture);
    //GLMaterialLibrary1.Materials[0].Material.Texture.Image.SaveToFile('C:\ScreenShot.bmp');
    //Scn.Buffer.RenderToFile('C:\ScreenShot.bmp',640,480);
    bmp:= TBitmap.Create;
    bmp.Width:= 640;
    bmp.Height:= 480;
    Scn.Buffer.CreateSnapShotBitmap.SaveToFile('C:\ScreenShot.bmp');
    //bmp.SaveToFile('C:\ScreenShot.bmp');
    bmp.Free;
  end;

  OnKeyEnter:= False;
end;

procedure TfMain.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  OnkeyEsc:= False;

  if (Key = KeyEnter) and (not OnKeyEnter) then
  begin
    OnKeyEnter:= True;

    if Game.isHS then
    begin
      HS.AddToTable(Player.HSName,Game.Score);
      HS.SaveToFile(Game.MainDir + '\HightScore.dat');

      HSNames.Visible:= True;
      HSScores.Visible:= True;

      HSNames.Text:= HS.GetNames;
      HSScores.Text:= HS.GetScores;

      HSNames.Position.X:= 140;
      HSNames.Position.Y:= 100;
      //
      HSScores.Position.X:= 540;
      HSScores.Position.Y:= 100;
    end;
  end;
end;

procedure TfMain.TimerStartTimer(Sender: TObject);
begin
  TimerStart.Enabled:= False;
  fMain.Width:= 0;
  fMain.Height:= 0;
  fInit. ShowModal;
end;

procedure TfMain.PlatformProgress(Sender: TObject; const deltaTime,
  newTime: Double);
Var
  Obj: TGLBaseSceneObject;
begin
  Obj:= Sender as TGLBaseSceneObject;
end;

procedure TfMain.GLCustomSpritePFXManager2PrepareTextureImage(
  Sender: TObject; destBmp32: TGLBitmap32; var texFormat: Integer);
var
  bmp: TBitmap;
  p: TGLBitmap32;
  i: Integer;
begin
  Pak.OpenPak(Game.MainDir + '\Packeges\Particles.pak');

  try
    bmp:= TBitmap.Create;
    bmp.LoadFromFile(Pak.ExtractFormPak('ice.bmp'));

    p:= TGLBitmap32.Create;
    p.Assign(bmp);
    destBmp32.Assign(bmp);

    for i:= 0 to destBmp32.width * destBmp32.Height - 1 do
      destBmp32.Data[i].a:= (destBmp32.Data[i].r + destBmp32.Data[i].g + destBmp32.Data[i].b) div 3;
  finally
    Pak.ClosePak;
    FreeAndNil(bmp);
    FreeAndNil(p);
  end;
end;

procedure TfMain.FinishPFXManagerPrepareTextureImage(Sender: TObject;
  destBmp32: TGLBitmap32; var texFormat: Integer);
begin
  try
    Pak.OpenPak(Game.MainDir + '\Packeges\Particles.pak');
    SetPngTexture(Pak.ExtractFormPak('Finish.png'),destBmp32);
  finally
    Pak.ClosePak;
  end;
end;

procedure TfMain.IceVapourPFXManagerPrepareTextureImage(
  Sender: TObject; destBmp32: TGLBitmap32; var texFormat: Integer);
begin
  try
    Pak.OpenPak(Game.MainDir + '\Packeges\Particles.pak');
    SetPngTexture(Pak.ExtractFormPak('LightPoint.png'),destBmp32);
  finally
    Pak.ClosePak;
  end;
end;

procedure TfMain.FormKeyPress(Sender: TObject; var Key: Char);
Var
  i: Integer;
  j: Char;
begin
  if Game.isHS then
  begin
    for i:= 0 to Game.MainFont.Ranges.Count - 1 do
      for j:= Game.MainFont.Ranges[i].StartASCII to Game.MainFont.Ranges[i].StopASCII do
        if (Key = j) and (Length(Player.HSName) < 10) then
          Player.HSName:= Player.HSName + Key;

    if Ord(Key) = 8 then
      Player.HSName:= Copy(Player.HSName,1,length(Player.HSName)-1);
  end;
end;

procedure TfMain.TeleportPFXManagerPrepareTextureImage(Sender: TObject;
  destBmp32: TGLBitmap32; var texFormat: Integer);
begin
  try
    Pak.OpenPak(Game.MainDir + '\Packeges\Particles.pak');
    SetPngTexture(Pak.ExtractFormPak('LightPoint.png'),destBmp32);
  finally
    Pak.ClosePak;
  end;
end;

procedure TfMain.DialogProgress(Sender: TObject; const deltaTime,
  newTime: Double);
begin
  if Dialog.ModulateColor.Alpha > 0 then
  begin
    Game.DialogTimer:= Game.DialogTimer + 1;

    if Game.DialogTimer > 200 then
      Dialog.ModulateColor.Alpha:= Dialog.ModulateColor.Alpha - 0.1;
  end else Game.DialogTimer:= 0;
end;

procedure TfMain.DialogProgress2(Sender: TObject; const deltaTime,
  newTime: Double);
var
  sobj: TIPanel;
begin
  sobj:= Sender as TIPanel;

  if sobj.Leav.Material.FrontProperties.Diffuse.Alpha > 0 then
  begin
    Game.DialogTimer2:= Game.DialogTimer2 + 1;

    if Game.DialogTimer2 > 200 then
      sobj.Leav.Material.FrontProperties.Diffuse.Alpha:= sobj.Leav.Material.FrontProperties.Diffuse.Alpha - 0.1;
  end else Game.DialogTimer2:= 0;
end;

procedure TfMain.TitleTextProgress(Sender: TObject; const deltaTime,
  newTime: Double);
begin
  if TitleText.ModulateColor.Alpha > 0 then
  begin
    Game.TitleTimer:= Game.TitleTimer + 1;

    if Game.TitleTimer > 200 then
      TitleText.ModulateColor.Alpha:= TitleText.ModulateColor.Alpha - 0.1;
  end else Game.TitleTimer:= 0;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
  DecimalSeparator:= '.';
end;

end.
