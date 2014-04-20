program FunSmile;

uses
  Forms,
  uMain in 'uMain.pas' {fMain},
  uInit in 'uInit.pas' {fInit},
  uWhirley in 'uWhirley.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'FunSmile';
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TfInit, fInit);
  Application.Run;
end.
