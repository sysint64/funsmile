unit uPngCopy;

interface

Uses
  PngImage, GLGraphics, glMaterial, glColor, glTexture,
  VectorGeometry, SysUtils, uUtils;

  procedure SetPngTexture(A: TPngObject; destBmp32: TGLBitmap32); overload;
  procedure SetPngTexture(fName: String; destBmp32: TGLBitmap32); overload;
  procedure SetMaterialPngTexture (fName:String; mat : TGlMaterial);

implementation

procedure SetPngTexture(A: TPngObject; destBmp32: TGLBitmap32);
var
  tmp: TGLBitmap32;
  i,j:Integer;
  cl: TVector;
begin
  try
    tmp:= TGLBitmap32.Create;
    tmp.Width:= A.Width;
    tmp.Height:= A.Height;

    for i:= 0 to A.Width - 1 do
      for j:= 0 to A.Height - 1 do
      begin
        cl:= ConvertWinColor(A.Pixels[i,j]);
        tmp.data[i + (A.Height-1-j) * A.Width]:= RGB2Pixel32(Round(cl[0]*255), Round(cl[1]*255), Round(cl[2]*255), A.AlphaScanline[j]^[i]);
      end;

    destBmp32.Assign(tmp);
  finally
    FreeAndNil(A);
    FreeAndNil(tmp);
  end;
end;

procedure SetPngTexture(fName: String; destBmp32: TGLBitmap32);
var
  A: TPngObject;
  tmp: TGLBitmap32;
  i,j:Integer;
  cl: TVector;
begin
  try
    A:= TPngObject.Create;
    A.LoadFromFile(fName);
    A.CreateAlpha;

    tmp:= TGLBitmap32.Create;
    tmp.Width:= A.Width;
    tmp.Height:= A.Height;

    for i:= 0 to A.Width - 1 do
      for j:= 0 to A.Height - 1 do
      begin
        cl:= ConvertWinColor(A.Pixels[i,j]);
        tmp.data[i + (A.Height-1-j) * A.Width]:= RGB2Pixel32(Round(cl[0]*255), Round(cl[1]*255), Round(cl[2]*255), A.AlphaScanline[j]^[i]);
      end;

    destBmp32.Assign(tmp);
  finally
    FreeAndNil(A);
    FreeAndNil(tmp);
  end;
end;

procedure SetMaterialPngTexture (fName:String; mat : TGlMaterial);
var
  A: TPngObject;
  i,j:Integer;
  cl: TVector;
  tmp: TglBitMap32;
begin
  try
    mat.Texture.Disabled:= false;
    mat.BlendingMode:= bmTransparency;
    mat.Texture.TextureMode:= tmModulate;
    mat.FrontProperties.Ambient.SetColor(1,1,1, 1);
    mat.FrontProperties.Diffuse.SetColor(1,1,1, 1);
    mat.FrontProperties.Emission.SetColor(1,1,1, 1);
    mat.FrontProperties.Specular.SetColor(1,1,1, 1);

    A:= TPngObject.Create;
    A.LoadFromFile(fName);
    A.CreateAlpha;

    tmp:= TglBitMap32.Create;
    tmp.Width:= A.Width;
    tmp.Height:= A.Height;

    for i:= 0 to A.Width - 1 do
      for j:= 0 to A.Height - 1 do
      begin
        cl:= ConvertWinColor(A.Pixels[i,j]);
        tmp.data[i + (A.Height-1-j) * A.Width]:= RGB2Pixel32(Round(cl[0]*255), Round(cl[1]*255), Round(cl[2]*255), A.AlphaScanline[j]^[i]);
      end;

    Mat.Texture.Image.Assign(tmp);
  finally
    FreeAndNil(A);
    FreeAndNil(tmp);
  end;
end;

end.
