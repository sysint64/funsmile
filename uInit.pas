unit uInit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, jpeg, PNGImage, XPMan, AsyncTimer;

type
  TfInit = class(TForm)
    pInit: TPanel;
    LoadScreen: TImage;
    XPManifest1: TXPManifest;
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fInit: TfInit;
  s: Integer;
  cl: Boolean;
  i: Integer;

implementation

uses uMain;

{$R *.dfm}

procedure TfInit.FormCreate(Sender: TObject);
begin
  s:= 0;
  i:= 1;
  fInit.Refresh;
end;

procedure TfInit.TimerTimer(Sender: TObject);
begin
  s:= s + 1;
  fInit.Refresh;

  case s of
    1: begin fMain.CreateAll; end;
    2: fMain.InitAll;
    3: fMain.DrawRooms;
    4: fMain.LoadTexts(False);
    5: fMain.LoadOptions;
    6:
    begin
      Timer.Enabled:= False;
      cl:= True;
      fMain.Step.Enabled:= True;
      Close;
    end;
  end;
end;

procedure TfInit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not cl then Exit;
end;

procedure TfInit.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if not cl then CanClose:= False;
end;

end.
