unit uEffects;

interface

uses
  GLScene, GLObjects, GLParticleFX, GLFireFX, GLPerlinPFX, GLColor,
  Classes, GLMaterial;

type
  TFireEffect = class (TGLDummyCube)
  public
    Manager: TGLFireFXManager;
    Run: Boolean;

    procedure Init;
  end;

function AddIceVapour(CollisionsList: TList; Scene: TGLScene; FManager: TGLParticleFXManager; x,y: Integer): TGLPlane;

implementation

//* TFireEffect *//

procedure TFireEffect.Init;
begin
  Manager:= TGLFireFXManager.Create(nil);

  with Manager do
  begin
    Disabled:= True;
    InnerColor.Color:= clrWhite;
    OuterColor.Color:= clrGray;
    ParticleLife:= 10;
    ParticleSize:= 5;
    FireBurst:= 1;
    FireBurst:= 0;
    FireDensity:= 0.5;
    FireRadius:= 0.5;
    MaxParticles:= 124;
  end;

  GetOrCreateFireFX(Self).Manager:= Manager;
end;

function AddIceVapour(CollisionsList: TList; Scene: TGLScene; FManager: TGLParticleFXManager; x,y: Integer): TGLPlane;
var
  Eff: TGLPlane;
begin
  Eff:= TGLPlane(Scene.Objects.AddNewChild(TGLPlane));
  Eff.Tag:= 503;
  //Eff.Visible:= False;
  Eff.Material.BlendingMode:= bmTransparency;
  Eff.Material.FrontProperties.Diffuse.Alpha:= 0;

  with GetOrCreateSourcePFX(Eff) do
  begin
    Manager:= FManager;
    EffectScale:= 0.2;
    InitialVelocity.Y:= 20;
    InitialPosition.Y:= -3.2;
    ParticleInterval:= 0.01;
    PositionDispersion:= 2;
    PositionDispersionRange.SetPoint(0.5,0,0);
    VelocityDispersion:= 1;
    RotationDispersion:= 0;
    Enabled:= True;
  end;

  Eff.Scale.Y:= 5;
  Eff.Scale.X:= 0.5;
  Eff.Position.SetPoint(x,y + 2.5,0);

  CollisionsList.Add(Eff);
  Result:= Eff;
end;

end.
