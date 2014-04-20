unit uHightScore;

interface

uses
  Classes, SysUtils;

type
  THightScore = class
  private
    FNames: TStringList;
    FScores: TStringList;
    FMax: Integer;

    procedure FillTable;
    procedure LimitTable(Max: Integer);
    procedure Sort;
  public
    constructor Create;
    //
    procedure SetMax(Max: Integer);
    procedure AddToTable(Player: AnsiString; Score: Integer);
    procedure ClearTable;
    function  GetScores: AnsiString;
    function  GetNames: AnsiString;
    procedure SaveToFile(FileName: AnsiString);
    procedure LoadFromFile(FileName: AnsiString);
    //
    destructor Destroy;
  end;

implementation

//* THightScore *//

procedure THightScore.FillTable;
var
  i: Integer;
begin
  for i:= 0 to FMax - 1 do
    AddToTable('Nobody',0);
end;

procedure THightScore.LimitTable(Max: Integer);
var
  i: Integer;
begin
  if FNames.Count > Max then
    for i:= Max to FNames.Count-1 do
    begin
      FNames.Delete(i);
      FScores.Delete(i);
    end;
end;

procedure THightScore.Sort;
var
  i,j: Integer;
  buf: AnsiString;
  max: Integer;
begin
  for i:= 0 to FScores.Count - 1 do
  begin
    max:= i;

    for j:= i+1 to FScores.Count - 1 do
      if StrToInt(FScores.Strings[j]) > StrToInt(FScores.Strings[max]) then max:= j;

    buf:= FScores.Strings[i];
    FScores.Strings[i]:= FScores.Strings[max];
    FScores.Strings[max]:= buf;

    buf:= FNames.Strings[i];
    FNames.Strings[i]:= FNames.Strings[max];
    FNames.Strings[max]:= buf;
  end;
end;

// Public

constructor THightScore.Create;
begin
  inherited Create;

  FMax:= 10;
  FNames := TStringList.Create;
  FScores:= TStringList.Create;

  FillTable;
end;

procedure THightScore.SetMax(Max: Integer);
begin
  FMax:= Max;
end;

procedure THightScore.AddToTable(Player: AnsiString; Score: Integer);
var
  a: AnsiString;
begin
  if Score < 10 then a:= '0000';
  if (Score < 100) and (Score > 9) then a:= '000';
  if (Score < 1000) and (Score > 99) then a:= '00';
  if (Score < 10000) and (Score > 999) then a:= '0';
  if (Score < 100000) and (Score > 9999) then a:= '';
  if Score > 99999 then Score:= 99999;

  FNames.Add(Player);
  FScores.Add(a + IntToStr(Score));

  Sort;
  LimitTable(FMax);
end;

function THightScore.GetNames: AnsiString;
var
  i: Integer;
begin
  Result:= FNames.Text;
end;

function THightScore.GetScores: AnsiString;
begin
  Result:= FScores.Text;
end;

procedure THightScore.LoadFromFile(FileName: AnsiString);
var
  F: TextFile;
  i: Integer;
  S1: AnsiString;
  S2: Integer;
begin
  ClearTable;
  
  AssignFile(F,FileName);
  Reset(F);

  for i:= 0 to FMax - 1 do
  begin
    ReadLn(F,S1);
    ReadLn(F,S2);
    
    AddToTable(S1,S2);
  end;

  CloseFile(F);
end;

procedure THightScore.SaveToFile(FileName: AnsiString);
var
  F: TextFile;
  i: Integer;
begin
  AssignFile(F,FileName);
  Rewrite(F);

  for i:= 0 to FMax - 1 do
  begin
    WriteLn(F,FNames.Strings[i]);
    WriteLn(F,FScores.Strings[i]);
  end;

  CloseFile(F);
end;

destructor THightScore.Destroy;
begin
  inherited Destroy;

  FreeAndNil(FNames);
  FreeAndNil(FScores);
end;

procedure THightScore.ClearTable;
begin
  FNames.Clear;
  FScores.Clear;
end;

end.
