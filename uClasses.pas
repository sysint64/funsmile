//* Автор [Xakep] *//

unit uClasses;

interface

uses
  HKStreamCol, Classes, SysUtils, GLScene, GLObjects, OffSetAnim,
  GLAnimatedSprite, GLFireFX, GLColor, GLScreen, Forms, Bass,
  uInterfaces, uRooms, uEffects, VectorTypes, VectorGeometry,
  GLHUDObjects, GLBitmapFontNFW;

type
  TDevice = class
  public
    Width: Integer;
    Height: Integer;
    BPP: Integer;
    FrameRate: Integer;

    procedure SterParam(pWidth, pHeight, pBPP, pFrameRate: Integer);
    procedure FullScreen; overload;
    procedure FullScreen(Form: TForm); overload;
    procedure Windowed; overload;
    procedure Windowed(Form: TForm); overload;
  end;

  TPak = class(THKStreams)
  public
    mStream: TMemoryStream;
    Files: TStringList;
    FilesCount: Integer;
    MainDir: String;

    procedure Init;
    procedure OpenPak(const FileName: String);
    function ExtractFormPak(const ID: String): String;
    procedure ClosePak;
    constructor Create;
  end;

  TBPoint = class(TGLAnimatedSprite)
  public
    Eff: TGLDummyCube;
    Explode: TGLFireFXManager;
    procedure Init;
  end;

  TBall = class(TGLPlane)
  public
    Timer: Integer;
    vx,vy: Integer;
    Dir: Integer;
  end;

  TEnemy = class(TGLPlane)
  private
    fg: Single;
  public
    Anim: TOffSetAnim;
    Timer: Integer;
    Dir: Integer;
    Health: Integer;
    God: Boolean;

    procedure Die;
    constructor Create(AOwner: TComponent); override;
  end;

  TGame = class
  public
    onMusic: Boolean;
    onSound: Boolean;
    BassStream: HStream;
    MainDir: String;
    CurrentLevel: Integer;
    GameOver: Boolean;
    Score: Integer;
    Lives: Integer;
    Timer: Integer;
    BScore: Integer;
    BLives: Integer;
    MaxPosCam: TVector2f;
    Points: TStringList;
    Player: TGLBaseSceneObject;
    PPX,PPY: Single;
    isLoad: Boolean;
    isHS: Boolean;
    isHS2: Boolean;
    ScoreTable: TStringList;
    White: TGLHUDSprite;
    Black: TGLHUDSprite;
    Dialog: TGLHUDText;
    ReadDialog: Boolean;
    DialogTimer: Integer;
    DialogTimer2: Integer;
    TitleTimer: Integer;
    HelpText: array[1..9] of String;
    MainFont: TGLBitmapFontNFW;
    TitleFont: TGLBitmapFontNFW;
    Objects: array of array of TGLBaseSceneObject;
    CollisionsList: TList;
    StepsList: TList;
    ButtonsList: TList;
    //
    PanelsManager: TPanelsManager;
    RoomsManager: TRoomsManager;

    procedure Save(const FileName: String);
    procedure Load(const FileName: String);
    procedure NullAll;
    constructor Create;
  end;

implementation

//* TGPak *//

procedure TPak.Init;
begin
  mStream:= TMemoryStream.Create;
  Files:= TStringList.Create;
  FilesCount:= 0;
end;

procedure TPak.OpenPak(const FileName: String);
begin
  LoadFromFile(FileName);
end;

function TPak.ExtractFormPak(const ID: String): String;
begin
  FilesCount:= FilesCount + 1;
  mStream.Clear;
  GetStream(ID,mStream);
  mStream.SaveToFile(MainDir + '\Packeges\Temp\Pak_' + IntToStr(FilesCount) + ExtractFileExt(ID));
  Files.Add(MainDir + '\Packeges\Temp\Pak_' + IntToStr(FilesCount) + ExtractFileExt(ID));

  result:= MainDir + '\Packeges\Temp\Pak_' + IntToStr(FilesCount) + ExtractFileExt(ID);
end;

procedure TPak.ClosePak;
Var
  i: Integer;
begin
  for i:= 0 to Files.Count - 1 do DeleteFile(PCHar(Files.Strings[i]));

  Files.Clear;
  ClearStreams;
  FilesCount:= 0;
end;

constructor TPak.Create;
begin
  inherited Create(nil);

  mStream:= TMemoryStream.Create;
  Files:= TStringList.Create;
end;

{ TBPoint }

procedure TBPoint.Init;
begin
  Explode:= TGLFireFXManager.Create(nil);
  Eff:= TGLDummyCube(Scene.Objects.AddNewChild(TGLDummyCube));
  Eff.Scale.SetVector(0.15,0.15,0.15);

  with Explode do
  begin
    Disabled:= True;
    InnerColor.Color:= clrWhite;
    OuterColor.Color:= clrGray;
    ParticleLife:= 5;
    ParticleSize:= 5;
    FireBurst:= 0;
    FireDensity:= 0.5;
    FireRadius:= 0.1;
    MaxParticles:= 20;
  end;

  Eff.Position:= Position;
  Eff.MoveLast;
  GetOrCreateFireFX(Eff).Manager:= Explode;
end;

{ TDevice }

procedure TDevice.SterParam(pWidth, pHeight, pBPP, pFrameRate: Integer);
begin
  Width:= pWidth;
  Height:= pHeight;
  BPP:= pBPP;
  FrameRate:= pFrameRate;
end;

procedure TDevice.FullScreen;
Var
  Resolution: TResolution;
begin
  Resolution:= GetIndexFromResolution(Width,Height,BPP);
  SetFullscreenMode(Resolution,FrameRate);
end;

procedure TDevice.FullScreen(Form: TForm);
Var
  Resolution: TResolution;
begin
  Resolution:= GetIndexFromResolution(Width,Height,BPP);
  SetFullscreenMode(Resolution,FrameRate);
  Form.ClientWidth:= Width;
  Form.ClientHeight:= Height;
  Form.Left:= 0;
  Form.Top:= 0;
  Form.BorderStyle:= bsNone;
end;

procedure TDevice.Windowed;
begin
  SetFullscreenMode(0,100);
end;

procedure TDevice.Windowed(Form: TForm);
begin
  SetFullscreenMode(0,100);
  Form.ClientWidth:= Width;
  Form.ClientHeight:= Height;
  Form.Position:= poScreenCenter;
  Form.BorderStyle:= bsSingle;
  Form.BorderIcons:= [biSystemMenu,biMinimize];
end;

{ TGame }

procedure TGame.Save(const FileName: String);
Var
  F: TextFile;
  i: Integer;
begin
  AssignFile(F,FileName);
  Rewrite(F);

  WriteLn(F,Score);
  WriteLn(F,Lives);
  WriteLn(F,BScore);
  WriteLn(F,BLives);
  WriteLn(F,CurrentLevel);
  WriteLn(F,Format('%.3f',[Player.Position.X]));
  WriteLn(F,Format('%.3f',[Player.Position.Y]));

  for i:= 0 to Points.Count - 1 do
    if Trim(Points[i]) <> '' then
      WriteLn(F,Points[i]);

  CloseFile(F);
end;

procedure TGame.Load(const FileName: String);
Var
  F: TextFile;
  S: String;
begin
  GameOver:= False;

  AssignFile(F,FileName);
  Reset(F);

  ReadLn(F,Score);
  ReadLn(F,Lives);
  ReadLn(F,BScore);
  ReadLn(F,BLives);
  ReadLn(F,CurrentLevel);

  ReadLn(F,S);
  PPX:= StrToFloat(S);
  ReadLn(F,S);
  PPY:= StrToFloat(S);

  Points.Clear;

  while not EOF(F) do
  begin
    ReadLn(F,S);

    if Trim(S) <> '' then
      Points.Add(S);
  end;

  CloseFile(F);

  isLoad:= True;
  Timer:= 0;
  RoomsManager.GoToRoom('Level');
end;

constructor TGame.Create;
begin
  inherited Create;

  Points:= TStringList.Create;
  CollisionsList:= TList.Create;
  ButtonsList:= TList.Create;
  StepsList:= TList.Create;
  DialogTimer:= 0;
  TitleTimer:= 0;
end;

procedure TGame.NullAll;
begin
  Timer:= 0;
  Score:= 0;
  Lives:= 9;
  BScore:= 0;
  BLives:= 9;
  GameOver:= False;
end;

//* TEnemy *//

constructor TEnemy.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fg:= 0.1;
end;

procedure TEnemy.Die;
begin
  Tag:= -1;

  if Material.FrontProperties.Diffuse.Alpha > 0 then
  begin
     Material.FrontProperties.Diffuse.Alpha := Material.FrontProperties.Diffuse.Alpha - 0.01;

     fg := fg - 0.01;
     Position.Y := Position.Y + fg;
     Roll(-5*dir);
  end else Destroy;
end;

end.
