unit uObjects;

interface

uses
  GLObjects;

type
  TGameObjectStep = procedure (Sender: TObject; deltaTime: Double);
  TBaseGameObject = class(TGLPlane)
  public
    Step: TGameObjectStep;
    //procedure Step(deltaTime: Double);
  end;

implementation


{ TBaseGameObject }

{procedure TBaseGameObject.Step(deltaTime: Double);
begin
  Position.Y:= Position.Y - 1 * deltaTime;
end;}

end.

