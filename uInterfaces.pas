//* Автор [Xakep] *//

unit uInterfaces;

interface

uses
  GLTexture, JPEG, GLHUDObjects, GLObjects, GLBitmapFont, GLScene,
  GLMaterial;

type
  TPCursor = class(TGLHUDSprite)
  public
    TagBut: integer;
    procedure Move(x,y: single);
  end;

  TIPanel = class(TGLDummyCube)
  public
    Enter: TGLHUDSprite;
    Leav: TGLHUDSprite;
    Kind: integer;
    ki: integer;
    Down: boolean;
    Click: boolean;
    Mouse: boolean;
    Active: boolean;

    procedure SetDown(ft: integer);
    procedure SetUp(ft: integer; x,y: single);
    function OnPoint(x,y: single) : boolean;
  end;

  //TPanels = array[0..999] of TIPanel;

  TPanelsManager = class(TGLDummyCube)
  public
    BmpFont: TGLBitmapFont;
    Cursor: TPCursor;
    PanelCount: integer;
    Panels: array[1..999] of TIPanel;
    MaterialLibrary: TGLMaterialLibrary;

    procedure Init;
    function Panel(Name: String): TIPanel;
    function Add(PX,PY,W,H: Single): TIPanel;
    procedure OnMouseMove(x,y: single);
    procedure OnMouseDown;
    procedure OnMouseUp(x,y: single);
    procedure FreePanels;
    procedure Clear;
  end;

procedure NewAlpha(Material: TGLMaterial; znak: char; k1,k2: single);
procedure SmoothHideObject(Material: TGLMaterial; Range: Single);
procedure SmoothHideObject2(Material: TGLMaterial; Range: Single);
procedure SmoothShowObject(Material: TGLMaterial; Range: Single);
procedure Blink(Material: TGLMaterial; var i: Integer);
function MenuEL(Obj: TGLHUDSprite; X,Y: integer) : boolean;
procedure SetGammaImage(Material: TGLMaterial; Gamma: Single);

implementation

procedure NewAlpha(Material: TGLMaterial; znak: char; k1,k2: single);
begin
  if znak = '>' then
    if Material.FrontProperties.Diffuse.Alpha > k1 then
       Material.FrontProperties.Diffuse.Alpha:= Material.FrontProperties.Diffuse.Alpha + k2;

  if znak = '<' then
    if Material.FrontProperties.Diffuse.Alpha < k1 then
       Material.FrontProperties.Diffuse.Alpha:= Material.FrontProperties.Diffuse.Alpha + k2;
end;

procedure SmoothHideObject(Material: TGLMaterial; Range: Single);
begin
  NewAlpha(Material,'>',Range,-0.05);
end;

procedure SmoothHideObject2(Material: TGLMaterial; Range: Single);
begin
  NewAlpha(Material,'>',Range,-0.01);
end;

procedure SmoothShowObject(Material: TGLMaterial; Range: Single);
begin
  NewAlpha(Material,'<',Range, 0.05);
end;

procedure Blink(Material: TGLMaterial; var i: Integer);
begin
  if Material.FrontProperties.Diffuse.Alpha <= 0.5 then i:= -i;
  if Material.FrontProperties.Diffuse.Alpha >= 1 then i:= -i;

  Material.FrontProperties.Diffuse.Alpha:= Material.FrontProperties.Diffuse.Alpha - (0.04 * i);
end;

function MenuEL(Obj: TGLHUDSprite; X,Y: integer) : boolean;
begin
  result:= false;
  if (Obj.Position.X - Obj.Width / 2 < X) and (Obj.Position.X + Obj.Width / 2 > X) and
     (Obj.Position.Y - Obj.Height / 2 < Y) and (Obj.Position.Y + Obj.Height / 2 > Y) then result:= true;
end;

procedure SetGammaImage(Material: TGLMaterial; Gamma: Single);
begin
  Material.FrontProperties.Diffuse.SetColor(1,1,1);
end;

//* TCursor *//

procedure TPCursor.Move(x,y: single);
begin
  Position.X:= x + Width / 2;
  Position.Y:= y + Height / 2;
end;

//* TPanel *//

function TIPanel.OnPoint(x,y: single) : boolean;
begin
  try
  Result:= false;


  if (Leav.Position.X - Leav.Width / 2 < x) and (Leav.Position.X + Leav.Width / 2 > x) and
     (Leav.Position.Y - Leav.Height / 2 < y) and (Leav.Position.Y + Leav.Height / 2 > y) then Result:= true;
  except
  end;
end;

procedure TIPanel.SetDown(ft: integer);
begin
  case Kind of
    1:
      begin
        Enter.Position.X:= Enter.Position.X + ki;
        Enter.Position.Y:= Enter.Position.Y + ki;
      end;
    2:
      begin
        Enter.Width:= Enter.Width - ki;
        Enter.Height:= Enter.Height - ki;
      end;
  end;

  Down:= true;
  Click:= false;
end;

procedure TIPanel.SetUp(ft: integer; x,y: single);
begin
  case Kind of
    1:
      begin
        Enter.Position.X:= Enter.Position.X - ki;
        Enter.Position.Y:= Enter.Position.Y - ki;
      end;
    2:
      begin
        Enter.Width:= Enter.Width + ki;
        Enter.Height:= Enter.Height + ki;
      end;
  end;

  Down:= false;
  if OnPoint(x,y) then Click:= true;
end;

//* TPanelManager *//

procedure TPanelsManager.Init;
begin
  PanelCount:= 0;
  //New(Panels);
end;

procedure TPanelsManager.OnMouseMove(x, y: single);
var
  i: integer;
begin
  Cursor.TagBut:= 0;
  
  for i:= 1 to PanelCount do
  if Panels[i] <> nil then
  begin
    if (Panels[i].OnPoint(x,y)) and (Panels[i].Active) then
    begin
      Cursor.TagBut:= i;
      Panels[i].Enter.Visible:= true;
      Panels[i].Leav.Visible:= false;
      Panels[i].Mouse:= true;
    end
    else
    if Panels[i].Active then
    begin
      Panels[i].Enter.Visible:= false;
      Panels[i].Leav.Visible:= true;
      Panels[i].Mouse:= false;
    end;
  end;
  
  Cursor.Move(x,y);
end;

procedure TPanelsManager.OnMouseDown;
begin
  if (Cursor.TagBut > 0) and (Panels[Cursor.TagBut].Active) then
    Panels[Cursor.TagBut].SetDown(Cursor.TagBut);
end;

procedure TPanelsManager.OnMouseUp(x,y: single);
var
  i: integer;
begin
  for i:= 1 to PanelCount do
  if (Panels[i].Down) and (Panels[i].Active) then
    Panels[i].SetUp(i,x,y);
end;

function TPanelsManager.Add(PX,PY,W,H: Single): TIPanel;
begin
  PanelCount:= PanelCount + 1;

  Panels[PanelCount]:= TIPanel(Scene.Objects.AddNewChild(TIPanel));

  with Panels[PanelCount] do
  begin
    Enter:= TGLHUDSprite(AddNewChild(TGLHUDSprite));
    Leav:= TGLHUDSprite(AddNewChild(TGLHUDSprite));

    Enter.Visible:= false;

    Enter.Position.X:= PX;
    Enter.Position.Y:= PY;
    Leav.Position.X:= PX;
    Leav.Position.Y:= PY;

    Enter.Width:= W;
    Leav.Width:= W;
    Enter.Height:= H;
    Leav.Height:= H;

    Enter.Material.MaterialOptions:= [moNoLighting];
    Leav.Material.MaterialOptions:= [moNoLighting];
    Enter.Material.BlendingMode:= bmTransparency;
    Leav.Material.BlendingMode:= bmTransparency;
    Enter.Material.Texture.TextureMode:= tmModulate;
    Leav.Material.Texture.TextureMode:= tmModulate;
  end;

  Result:= Panels[PanelCount]
end;

procedure TPanelsManager.FreePanels;
Var
  i: Integer;
begin
  PanelCount:= 0;

  for i:= 1 to PanelCount do
  begin
    Panels[i].Enter.Destroy;
    Panels[i].Leav.Destroy;
  end;
end;

function TPanelsManager.Panel(Name: String): TIPanel;
Var
  i: Integer;
begin
  Result:= nil;

  for i:= 1 to PanelCount do
    if Panels[i].Name = Name then Result:= Panels[i];
end;

procedure TPanelsManager.Clear;
Var
  i: Integer;
begin
  for i:= 1 to PanelCount do
  begin
    //ShowMessage(Panels[i].Name);
    Panels[i].Destroy;
  end;

  PanelCount:= 0;
end;

end.
