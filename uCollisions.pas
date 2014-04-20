//* Автор [Xakep] *//

unit uCollisions;

interface

uses
  GLScene, Classes;

function Collision(CollisionsList: TList; Obj1: TGLBaseSceneObject; Tag: Integer): Boolean; overload;
function Collision(Obj1: TGLBaseSceneObject; Obj2: TGLBaseSceneObject): Boolean; overload;
function Collision(CollisionsList: TList; Obj1: TGLBaseSceneObject; Tag: Integer; w1,h1,w2,h2: Single): Boolean; overload;
function Collision(Obj1: TGLBaseSceneObject; Obj2: TGLBaseSceneObject; w1,h1,w2,h2: Single): Boolean; overload;

implementation

function Collision(CollisionsList: TList; Obj1: TGLBaseSceneObject; Tag: Integer): Boolean;
Var
  i: Integer;
  P,Obj2: TGLBaseSceneObject;
  t: array[1..4] of Integer;
begin
  Result:= False;

  for i:= 0 to CollisionsList.Count - 1 do
  begin
    P:= CollisionsList.Items[i];

    if Assigned(P) then
    if (P.Tag = Tag) and (P.Visible) then
    begin
      Obj2:= P;

      if Obj1.Scale.X < 0 then t[1]:= -1 else t[1]:= 1;
      if Obj1.Scale.Y < 0 then t[2]:= -1 else t[2]:= 1;
      if Obj2.Scale.X < 0 then t[3]:= -1 else t[3]:= 1;
      if Obj2.Scale.Y < 0 then t[4]:= -1 else t[4]:= 1;

      if ((Obj1.Position.X + 0.1 + ((Obj1.Scale.X / 2) * t[1]) >= (Obj2.Position.X - ((Obj2.Scale.X / 2) * t[3]))) and
          (Obj1.Position.X - 0.1 - ((Obj1.Scale.X / 2) * t[1]) <= (Obj2.Position.X + ((Obj2.Scale.X / 2) * t[3])))) and
         ((Obj1.Position.Y + 0.1 + ((Obj1.Scale.Y / 2) * t[2]) >= (Obj2.Position.Y - ((Obj2.Scale.Y / 2) * t[4]))) and
          (Obj1.Position.Y - 0.1 - ((Obj1.Scale.Y / 2) * t[2]) <= (Obj2.Position.Y + ((Obj2.Scale.Y / 2) * t[4])))) then
      begin
        Obj1.TagObject:= Obj2;
        Obj2.TagObject:= Obj1;
        Result:= True;
        Exit;
      end;
    end;
  end;
end;

function Collision(Obj1: TGLBaseSceneObject; Obj2: TGLBaseSceneObject): Boolean;
Var
  t: array[1..4] of Integer;
begin
  Result:= False;

  if Obj1.Scale.X < 0 then t[1]:= -1 else t[1]:= 1;
  if Obj1.Scale.Y < 0 then t[2]:= -1 else t[2]:= 1;
  if Obj2.Scale.X < 0 then t[3]:= -1 else t[3]:= 1;
  if Obj2.Scale.Y < 0 then t[4]:= -1 else t[4]:= 1;

  if ((Obj1.Position.X + 0.1 + ((Obj1.Scale.X / 2) * t[1]) >= (Obj2.Position.X - ((Obj2.Scale.X / 2) * t[3]))) and
      (Obj1.Position.X - 0.1 - ((Obj1.Scale.X / 2) * t[1]) <= (Obj2.Position.X + ((Obj2.Scale.X / 2) * t[3])))) and
     ((Obj1.Position.Y + 0.1 + ((Obj1.Scale.Y / 2) * t[2]) >= (Obj2.Position.Y - ((Obj2.Scale.Y / 2) * t[4]))) and
      (Obj1.Position.Y - 0.1 - ((Obj1.Scale.Y / 2) * t[2]) <= (Obj2.Position.Y + ((Obj2.Scale.Y / 2) * t[4])))) then
  begin
    Obj1.TagObject:= Obj2;
    Obj2.TagObject:= Obj1;
    Result:= True;
  end;
end;

function Collision(CollisionsList: TList; Obj1: TGLBaseSceneObject; Tag: Integer; w1,h1,w2,h2: Single): Boolean;
Var
  i: Integer;
  P,Obj2: TGLBaseSceneObject;
  t: array[1..4] of Integer;
begin
  Result:= False;

  for i:= 0 to CollisionsList.Count - 1 do
  begin
    P:= CollisionsList.Items[i];

    if Assigned(P) then
    if (P.Tag = Tag) and (P.Visible) then
    begin
      Obj2:= P;

      if w1 < 0 then t[1]:= -1 else t[1]:= 1;
      if h1 < 0 then t[2]:= -1 else t[2]:= 1;
      if w2 < 0 then t[3]:= -1 else t[3]:= 1;
      if h2 < 0 then t[4]:= -1 else t[4]:= 1;

      if ((Obj1.Position.X + 0.1 + ((w1 / 2) * t[1]) >= (Obj2.Position.X - ((w2 / 2) * t[3]))) and
          (Obj1.Position.X - 0.1 - ((w1 / 2) * t[1]) <= (Obj2.Position.X + ((w2 / 2) * t[3])))) and
         ((Obj1.Position.Y + 0.1 + ((h1 / 2) * t[2]) >= (Obj2.Position.Y - ((h2 / 2) * t[4]))) and
          (Obj1.Position.Y - 0.1 - ((h1 / 2) * t[2]) <= (Obj2.Position.Y + ((h2 / 2) * t[4])))) then
      begin
        Obj1.TagObject:= Obj2;
        Obj2.TagObject:= Obj1;
        Result:= True;
        Exit;
      end;
    end;
  end;
end;

function Collision(Obj1: TGLBaseSceneObject; Obj2: TGLBaseSceneObject; w1,h1,w2,h2: Single): Boolean;
Var
  t: array[1..4] of Integer;
begin
  Result:= False;

  if w1 < 0 then t[1]:= -1 else t[1]:= 1;
  if h1 < 0 then t[2]:= -1 else t[2]:= 1;
  if w2 < 0 then t[3]:= -1 else t[3]:= 1;
  if h2 < 0 then t[4]:= -1 else t[4]:= 1;

  if ((Obj1.Position.X + 0.1 + ((w1 / 2) * t[1]) >= (Obj2.Position.X - ((w2 / 2) * t[3]))) and
      (Obj1.Position.X - 0.1 - ((w1 / 2) * t[1]) <= (Obj2.Position.X + ((w2 / 2) * t[3])))) and
     ((Obj1.Position.Y + 0.1 + ((h1 / 2) * t[2]) >= (Obj2.Position.Y - ((h2 / 2) * t[4]))) and
      (Obj1.Position.Y - 0.1 - ((h1 / 2) * t[2]) <= (Obj2.Position.Y + ((h2 / 2) * t[4])))) then
  begin
    Obj1.TagObject:= Obj2;
    Obj2.TagObject:= Obj1;
    Result:= True;
  end;
end;

end.
