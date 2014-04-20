//* Автор [Xakep] *//

unit uRooms;

interface

uses
  GLScene, uInterfaces, uOde, Dialogs;

type
  TRoomStep = procedure (DeltaTime: Double);
  TRoom = class
  public
    ID: Integer;
    Name: String;
    Step: TRoomStep;
  end;

  TRoomsManager = class
    Rooms: array of TRoom;
    PanelsManager: TPanelsManager;
    ODEManager: TODEManager;

    //Player: TPlayer;
    Scene: TGLScene;
    Count: Integer;
    CurrentRoom: Integer;

    function AddRoom: TRoom;
    function Room(Name: String): TRoom;
    procedure NextRoom;
    procedure PrevRoom;
    procedure GoToRoom(id: String);
    procedure Step(deltaTime: Double);
    constructor Create;
    procedure ClearScene(Scene: TGLScene);
  end;

implementation

//* TRoomManager *//
//
procedure TRoomsManager.ClearScene(Scene: TGLScene);
Var
  i,j,n: Integer;
begin
  for i:= 0 to Scene.Objects.Count - 1 do
    for j:= 0 to Scene.Objects.Count - 1 do
      if Scene.Objects[j].Tag <> 999 then
        Scene.Objects[j].Destroy;

  {Player.vx1:= 0;
  Player.vy1:= 0;
  Player.vx2:= 0;
  Player.vy2:= 0;}

  n:= OdeManager.Count - 1;

  for i:= 1 to n do
    if OdeManager.Objs[i].Tag <> 999 then
    begin
      OdeManager.Objs[i].Destroy;
      OdeManager.Count:= OdeManager.Count - 1;
    end;

  //OdeManager.Count:= 1;
  PanelsManager.Clear;
end;

function TRoomsManager.AddRoom: TRoom;
begin
  SetLength(Rooms,Count + 1);
  Rooms[Count]:= TRoom.Create;
  Rooms[Count].ID:= Count;
  Result:= Rooms[Count];
  Count:= Count + 1;
end;

constructor TRoomsManager.Create;
begin
  Count:= 0;
  CurrentRoom:= 0;
end;

procedure TRoomsManager.GoToRoom(id: String);
begin
  PanelsManager.Clear;
  ClearScene(Scene);
  CurrentRoom:= Room(id).ID;
end;

procedure TRoomsManager.NextRoom;
begin
  PanelsManager.Clear;
  ClearScene(Scene);
  CurrentRoom:= CurrentRoom + 1;
end;

procedure TRoomsManager.PrevRoom;
begin
  PanelsManager.Clear;
  ClearScene(Scene);
  CurrentRoom:= CurrentRoom - 1;
end;

function TRoomsManager.Room(Name: String): TRoom;
Var
  i: Integer;
begin
  Result:= nil;

  for i:= 0 to Count - 1 do
    if Rooms[i].Name = Name then Result:= Rooms[i];
end;

procedure TRoomsManager.Step(DeltaTime: Double);
begin
  Rooms[CurrentRoom].Step(DeltaTime);
end;

end.
