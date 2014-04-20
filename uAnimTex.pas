unit uAnimTex;

interface

uses
  GLScene, GLMaterial, GLTexture, SysUtils, Classes, uCLasses;

type
  TFramesList = array of String;
  TAnimTex = class
  private
    FFramesList: TFramesList;
  public
    MaterialLibrary: TGLMaterialLibrary;
    Obj: TGLBaseSceneObject;
    CurrentFrame: Integer;
    FramesCount: Integer;
    Interval: Integer;
    MainDir: String;

    procedure LoadFromFile(const FileName: String);
    procedure Step(DeltaTime: Double);
  end;

implementation

{ TAnimTex }

procedure TAnimTex.LoadFromFile(const FileName: String);
Var
  Pak: TPak;
  i: Integer;
  F: TextFile;
begin
  try
    Pak:= TPak.Create;
    Pak.MainDir:= MainDir;
    Pak.OpenPak(FileName);

    for i:= 1 to FramesCount do
      with MaterialLibrary.Materials.Add do
      begin
        Name:= Obj.Name + 'Frame' + IntToStr(i);

        with Material do
        begin
          Texture.Enabled:= True;
          Texture.Image.LoadFromFile(Pak.ExtractFormPak('Frame' + IntToStr(i)));
          Texture.TextureWrap:= twNone;
          FrontProperties.Diffuse.SetColor(1,1,1);
        end;
      end;
  finally
    Pak.ClosePak;
    Pak.Free;
  end;
end;

procedure TAnimTex.Step(DeltaTime: Double);
begin

end;

end.
