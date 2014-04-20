//* Автор данного модуля является Lampogolovii *//

unit uUtils;
interface
Uses VectorGeometry, Windows, GLGraphics, glColor, GLScene;
  Function PointInRect (pnt : TVector; x1,y1,x2,y2 : Integer) : Boolean; overload;
  Function PointInRect (pnt : TVector; r : TRect) : Boolean; overload;

  Procedure Pixel322RGB(pix:TGlPixel32; var _r,_g,_b,_a:byte);
  Function RGB2Pixel32(_r,_g,_b,_a:byte):TGlPixel32;
  Function Sign(a: Real) : Real;

  Function  UpString(Source:String):String;
  Function  GetStrINstr(Source:string; St:Char; En:Char):String;

  procedure MoveLastObj(Obj: TGLBaseSceneObject);
implementation
//==============================================================================
Function FullSearchStr(Source:string; St:Char; En:Char;var Temp:Integer):String;
var
  i1,i2:Integer;
begin
  i1:=Pos(St, Source);
  i2:=Pos(En, Source);
  if i2<>0 then
    Temp:=i2+1
  else
    Temp:=Length(Source);
  if(i1<>0)and(i2<>0)then
    FullSearchStr:=Copy(Source, i1+1, i2-i1-1)
  else
    FullSearchStr:='';
end;
//==============================================================================
Function GetStrINstr(Source:string; St:Char; En:Char):String;
var
  A:Integer;
begin
  GetStrinstr:=FullSearchStr(Source, St, En, A);
end;
//==============================================================================
Function  UpString(Source:String):String;
var Dest:String; i:Integer;
begin
 Dest:='';
 for i:=1 to length(Source)do
  Dest:=Dest+UpCase(Source[i]);
 UpString:=Dest;
end;
//==============================================================================
Function Sign(a: Real) : Real;
begin
  if a>0 then
    result := 1
  else
    if a<0 then
      result := -1
    else
      result := 0;
end;
//==============================================================================
Procedure Pixel322RGB(pix:TGlPixel32; var _r,_g,_b,_a:byte);
begin
  _r := pix.r;
  _g := pix.g;
  _b := pix.b;
  _a := pix.a;
end;
//==============================================================================
Function RGB2Pixel32(_r,_g,_b,_a:byte):TGlPixel32;
begin
  result.r:=_r;
  result.g:=_g;
  result.b:=_b;
  result.a:=_a;
end;
//==============================================================================
Function PointInRect (pnt : TVector; x1,y1,x2,y2 : Integer) : Boolean; overload;
begin
  result := (pnt[0] >= x1) and (pnt[1] >= y1) and (pnt[0] <= x2) and (pnt[1] <= y2);
end;
//==============================================================================
Function PointInRect (pnt : TVector; r : TRect) : Boolean; overload;
begin
  result := PointInRect(pnt, r.left, r.top, r.right, r.bottom);
end;
//==============================================================================
procedure MoveLastObj(Obj: TGLBaseSceneObject);
var
  i: Integer;
begin
  for i:= 0 to Obj.Scene.Objects.Count - 1 do
    Obj.MoveDown;
end;

end.
