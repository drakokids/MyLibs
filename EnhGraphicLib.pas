{
   v1.0 - Março2010 - Inclui GDI plus para ter reflexão
   v1.2 - Dez2021 - Get Image Size from File
}


unit EnhGraphicLib;

interface

{$IF DECLARED(FireMonkeyVersion)}
  {$DEFINE HAS_FMX}
{$ELSE}
  {$DEFINE HAS_VCL}
{$ENDIF}

uses windows, SysUtils,vcl.Graphics, math, Vcl.Imaging.jpeg ,GDIPAPI,
   {$IF HAS_FMX}PngImage,{$ENDIF}
     GDIPOBJ;

const
  Mask0101 = $00FF00FF;
  Mask1010 = $FF00FF00;

type
 TMyColor = record
     case Boolean of
        TRUE :  (C : TColor);
        FALSE :  ( R, G, B, A : Byte);
       // FALSE :  ( G, R, B, A : Byte);
  end;

type//structure of the bitmap
     bit24=record r,g,b:byte;end;
     bit24array=array[0..0] of bit24;
     pbit24array=^bit24array;
     PColor32 = ^TColor32;
     TColor32 = type Cardinal;
     PColor32Array = ^TColor32Array;
     TColor32Array = array [0..0] of TColor32;
     TArrayOfColor32 = array of TColor32;
     TRGBArray = array[Word] of TRGBTriple;
     pRGBArray = ^TRGBArray;
     
type TObjAlign=(OANone, OABottomRight, OABottomLeft, OATopLeft, OATopRight,OATop, OABottom, OALeft, OARight);
type TButtonState = (BSNormal, BSClick, BSMove);
type TGlyphStyle = (GsNone, GsOnTop, GsOnCenter, GsOnBottom, GsOnLeft, GsOnRight);
type TGlueonParent = (GalNone, GalBottomRight, GalBottomLeft, GalTopLeft, GalTopRight,
                      GalTop, GalBottom, GalLeft, GalRight);
type TTStyle = ( TsNormal, TsOutline, TsShadow );
type TImageStyle = ( IsStretch, IsTiled, IsCentered,
                     IsTopLeft, IsTopRight, IsLeft, IsRight,
                     IsBottomLeft, IsBottomRight, IsTop, IsBottom);
type TMove = ( MvStatic, MvDragParent );
Type TCorner = ( CTopLeft, CtopRight, CBottomLeft, CBottomRight );
type TEnhCurveStyle=(EcRect, EcRound, EcFlat, EcNRect, EcNRound);
//type TOutlineStyle = ( LsNone, LsLine, LsInset, LsOutset );
//type TEnhShape = ( EsNone, EsRectangle, EsRoundRect, EsEllipse, EsDiamond, EsMask );
type TEnhScroll = ( ScNone, ScSlideLeft, ScSlideRight, ScWave, ScAngleUp, ScAngleDown );

//Para fazer
//only for 24 bits bitmap
procedure CreateRgn_from_Bitmap(var rgn: HRGN; Bitmap: TBitmap);
procedure CreateRgn_from_Bitmap2(var rgn: HRGN; Bitmap: TBitmap; transpcolor: bit24);
procedure DrawSmart(handle: HWND; bitmap: TBitmap; Margins: TRect; left, top, Width, Height: integer; ClipRgn: TRect);
procedure DrawSmartBmp(Handle: HBitmap; bitmap: TBitmap;
                    Margins: TRect; left, top, Width, Height: integer;
                    ClipRgn: TRect);
procedure DrawSmartBmpStretchH(Handle: HBitmap; bitmap: TBitmap;
                    Margins: TRect; left, top, Width, Height: integer;
                    ClipRgn: TRect; noStretchValue: integer);
procedure DrawSmartBmpStretchV(Handle: HBitmap; bitmap: TBitmap;
                    Margins: TRect; left, top, Width, Height: integer;
                    ClipRgn: TRect; noStretchValue: integer);
//Function DrawStretched(handle: HWND; bitmap: TBitmap; Width, Height: integer):boolean;
//Function DrawTiled(handle: HWND; bitmap: TBitmap; Width, Height: integer):boolean;
//only for 24 bits bitmap
procedure BlendBitmap(var bitmap1, bitmap2: TBitmap; blendvalue: byte);
//figura a preto
//only for 24 bits bitmap
procedure BlendBitmapMasked2(var fundo: TBitmap; imagem, mascara: TBitmap);
//Máscara preto com figura a branco
//only for 24 bits bitmap
procedure BlendBitmapMasked(var bitmap1, bitmap2, maskbmp: TBitmap; blendvalue: byte);
//only for 24 bits bitmap
procedure Mask_from_Bitmap(var maskbmp:TBitmap;origbmp: TBitmap);
//function LightRGB(r, g, b: byte): tcolor;
//function darkrgb(r, g, b: byte): tcolor;
//procedure BitmapConvertB&W(BitmapFrom: TBitmap; var BitmapTo: TBitmap);
//functions FindVerMarginAuto(bitmap: TBitmap): integer;
//functions FindHorMarginAuto(bitmap: TBitmap): integer;
//procedure DrawEnhText(var DestBitmap: TBitmap; Caption: String; Font: TFont;
//                      Style: TTStyle; StyleValue: integer;
//                      Outline: TOutlineStyle; OutlineValue: integer;
//                      Width, Height: integer; Rotation: integer);
procedure FillZone(dc: Hdc; r: TRect; bmp: TBitmap);
procedure DrawMiddle(dc: Hdc; r: TRect; bmp: TBitmap);
procedure Grafitti(var destin, mask: TBitmap; color: TColor; blendvalue: byte);
function DarkerColor(c1 : TColor; darkness: Byte): TColor;
function LighterColor(c1 : TColor; lightness: Byte): TColor;
function Red(Color32: TColor32): Integer;
function Blue(Color32: cardinal): Integer;
function Green(Color32: cardinal): Integer;
function Alpha(Color32: cardinal): Integer;
//only for 24 bits bitmap
procedure InvertBitmap(var bitmap1: TBitmap);
//turns 24 bit bitmap in 32 bit bitmap with alpha
procedure MakeAlphaBitmap(var bitmap32: TBitmap; alpha: TBitmap);
procedure InvertMasked(var Imagebmp32: TBItmap; mask: TBitmap);
procedure Gray(var clip: tbitmap);
procedure AntiAliasRect(clip: tbitmap; XOrigin, YOrigin,XFinal, YFinal: Integer);
procedure AntiAlias(clip: tbitmap);
procedure AntiAliasedText(CV: TCanvas; const sText: String; x,y:integer );
procedure WordWrapTextOut(canvas: TCanvas; var x, y: integer; S: string; maxwidth, lineheight: integer);
procedure SetJPEGOptions(var pic: TPicture);
procedure DrawPicture(cv: TCanvas; x,y: integer; ThePic: TPicture);
procedure DrawBMPGrayed(DestHDC: HBitmap; x1,y1,w1,h1: integer; Src: TBitmap; x2,y2,w2,h2: integer);
FUNCTION JPEGSentinelsAreOK(CONST Filename:  TFilename):  BOOLEAN;
procedure DrawTransparentBitmap(DC: HDC; hBmp : HBITMAP ;
          xStart: integer; yStart : integer; cTransparentColor : COLORREF);
function TrimInt(i, Min, Max: Integer): Integer;
function IntToByte(i:Integer):Byte;
procedure RotateBmp(Src: TBitmap; var Dst: TBitmap; cx, cy: Integer;
          Angle: Extended; BColor: TColor);
procedure DrawReflection(Target: TGPGraphics; SourceBmp: TGPBitmap;
  SrcWidth, SrcHeight, ReflHeight, BottomCutOff, TargetX, TargetY, StartOpacity: Integer);
procedure SmoothResize(Src, Dst: TBitmap);
function LoadJPEGPictureFile(Bitmap: TBitmap; FilePath, FileName: string): Boolean;
{$IF HAS_FMX}
function LoadPNGPictureFile(Bitmap: TBitmap; FilePath, FileName: string): Boolean;
{$ENDIF}
function SaveJPEGPictureFile(Bitmap: TBitmap; FilePath, FileName: string;  Quality: Integer): Boolean;
procedure ResizeImage(FileName: string; MaxWidth: Integer);
function JPEGDimensions(Filename : string; var X, Y : Word) : boolean;
function DrawGDIText(var DestBitmap: TBitmap; caption: string; px,py: integer; r: TRect; FontName: string;
                      FontSize: integer; FontColor: TColor; Antialias: boolean):integer;
procedure GetJPGSize(const sFile: string; var wWidth, wHeight: word);
procedure GetPNGSize(const sFile: string; var wWidth, wHeight: word);
procedure GetGIFSize(const sGIFFile: string; var wWidth, wHeight: word);
function GetBMPSize(PictFileName: String; Var wd, ht: Word): Boolean; //Para BMP

implementation

uses classes;

function ReadMWord(f: TFileStream): word;
type
  TMotorolaWord = record
  case byte of
  0: (Value: word);
  1: (Byte1, Byte2: byte);
end;

var
  MW: TMotorolaWord;
begin
  {It would probably be better to just read these two bytes in normally and
  then do a small ASM routine to swap them. But we aren't talking about
  reading entire files, so I doubt the performance gain would be worth the
  trouble.}
  f.Read(MW.Byte2, SizeOf(Byte));
  f.Read(MW.Byte1, SizeOf(Byte));
  Result := MW.Value;
end;

function ReadMWord2(fh: HFile ; Var value: Word): Boolean;
type
  TMotorolaWord = record
    case byte of
      0: (Value: word);
      1: (Byte1, Byte2: byte);
  end;
var
  MW: TMotorolaWord;
  numread : DWord;
begin
  { It would probably be better to just read these two bytes in normally and
  then do a small ASM routine to swap them.  But we aren't talking about
  reading entire files, so I doubt the performance gain would be worth the
  trouble.}
  Result := False;
  if ReadFile(fh, MW.Byte2, SizeOf(Byte), numread, nil) then
    if ReadFile(fh, MW.Byte1, SizeOf(Byte), numread, nil) then
      Result := True;
  Value := MW.Value;
end;

function GoodFileRead(fhdl: THandle; buffer: Pointer; readsize: DWord): Boolean;
var
  numread: DWord;
  retval: Boolean;
begin
  retval := ReadFile(fhdl, buffer^, readsize , numread , Nil);
  result := retval And (readsize = numread);
end;

function ImageType(Fname: String): Smallint;
var
  ImgExt: String;
  Itype: Smallint;
begin
  ImgExt := UpperCase(ExtractFileExt(Fname));
  if ImgExt = '.BMP' then
    Itype := 1
  else
  if (ImgExt = '.JPEG') or (ImgExt='.JPG') then
    Itype := 2
  else
    Itype := 0;
  Result := Itype;
end;

function TrimInt(i, Min, Max: Integer): Integer;
begin
  if      i>Max then Result:=Max
  else if i<Min then Result:=Min
  else               Result:=i;
end;

function IntToByte(i:Integer):Byte;
begin
  if      i>255 then Result:=255
  else if i<0   then Result:=0
  else               Result:=i;
end;

procedure CreateRgn_from_Bitmap(var rgn: HRGN; Bitmap: TBitmap);
var x,y,rc:integer;
    tmprgn,tmprgn2,NewRgn: HRGN;
    p:pbit24Array;
    transp:bit24;
begin
    Bitmap.pixelformat:=pf24bit;
    p:= Bitmap.scanline[0];
    //change this in order to set other color as bg
    transp:=p[0];
    //loop for lines
    for y := 0 to Bitmap.height-1 do
     begin
      p:= Bitmap.scanline[y];
      x:=0;
      //loop for rows :
      //this loop looks very stupid...
      //but it didn't work any other way:
      while x<(Bitmap.width) do
       if (p[x].r<>transp.r)or(p[x].g<>transp.g)or(p[x].b<>transp.b) then
        begin
         rc:=1;
         while (p[x+rc].r<>transp.r)and(p[x+rc].g<>transp.g)and(p[x+rc].b<>transp.b)
          do inc(rc);
         tmprgn:=CreateRectRgn(x,y,x+rc,y+1);
         //tmpRgn2:=CreateRectRgn(0,0,0,0);
         CombineRgn(rgn,rgn,tmpRgn,RGN_OR);
         DeleteObject(tmprgn);
         //CombineRgn(tmpRgn2,rgn,tmpRgn,RGN_OR);
         //DeleteObject(rgn);
         //rgn := tmprgn2;
         inc(x,rc);
        end else inc(x);
    end; //for y
    //DeleteObject(tmprgn);
//    DeleteObject(tmprgn2);
end;

procedure CreateRgn_from_Bitmap2(var rgn: HRGN; Bitmap: TBitmap; transpcolor: bit24);
var x,y,rc:integer;
    tmprgn,tmprgn2,NewRgn: HRGN;
    p:pbit24Array;
    transp:bit24;
begin
    Bitmap.pixelformat:=pf24bit;
    p:= Bitmap.scanline[0];
    //change this in order to set other color as bg
    transp:=transpcolor;
    //loop for lines
    for y := 0 to Bitmap.height-1 do
     begin
      p:= Bitmap.scanline[y];
      x:=0;
      //loop for rows :
      //this loop looks very stupid...
      //but it didn't work any other way:
      while x<(Bitmap.width) do
       if (p[x].r<>transp.r)or(p[x].g<>transp.g)or(p[x].b<>transp.b) then
        begin
         rc:=1;
         while (p[x+rc].r<>transp.r)and(p[x+rc].g<>transp.g)and(p[x+rc].b<>transp.b)
          do inc(rc);
         tmprgn:=CreateRectRgn(x,y,x+rc,y+1);
         //tmpRgn2:=CreateRectRgn(0,0,0,0);
         CombineRgn(rgn,rgn,tmpRgn,RGN_OR);
         DeleteObject(tmprgn);
         //CombineRgn(tmpRgn2,rgn,tmpRgn,RGN_OR);
         //DeleteObject(rgn);
         //rgn := tmprgn2;
         inc(x,rc);
        end else inc(x);
    end; //for y
    //DeleteObject(tmprgn);
//    DeleteObject(tmprgn2);
end;

procedure DrawSmart(handle: HWND; bitmap: TBitmap;
                    Margins: TRect; left, top, Width, Height: integer;
                    ClipRgn: TRect);
var
  Dc: hDC;
  FHorMargin, FVerMargin: integer;
  MyRgn: HRGN ;
begin
        //Dc:=getdc(handle);
        DC:=Handle;
        MyRgn := CreateRectRgn(ClipRgn.Left,ClipRgn.Top, ClipRgn.Right, ClipRgn.Bottom );
        SelectClipRgn(DC,MyRgn);

        FHorMargin:=Margins.left;
        FVerMargin:=Margins.top;
        //Canto superior esquerdo
         BitBlt(Dc,
             left+0,top+0,
             FHorMargin,FVerMargin,
             bitmap.Canvas.Handle,
             0,0,SRCCOPY);
         //Canto superior direito
         BitBlt(Dc,
             left+width-FHorMargin,top+0,
             FHorMargin,FVerMargin,
             bitmap.Canvas.Handle,
             bitmap.Width-FHorMargin,0,SRCCOPY);
         //Canto inferior esquerdo
         BitBlt(Dc,
             left+0,top+height-FVerMargin,
             FHorMargin,FVerMargin,
             bitmap.Canvas.Handle,
             0,bitmap.Height-FVerMargin,SRCCOPY);
         //Canto inferior direito
         BitBlt(Dc,
             left+width-FHorMargin,top+height-FVerMargin,
             FHorMargin,FVerMargin,
             bitmap.Canvas.Handle,
             bitmap.Width-FHorMargin,bitmap.Height-FVerMargin,
             SRCCOPY);
         //Lateral esquerda
         StretchBlt( Dc,
            left+0,top+FVerMargin,
            FHorMargin,height-FVerMargin*2,
            bitmap.Canvas.Handle,
            0,FVerMargin,
            FHorMargin,bitmap.Height-FVerMargin*2,
            SRCCOPY);
         //Lateral direita
         StretchBlt( Dc,
            left+Width-FHorMargin,top+FVerMargin,
            FHorMargin,height-FVerMargin*2,
            bitmap.Canvas.Handle,
            bitmap.width-FHorMargin,FVerMargin,
            FHorMargin,bitmap.Height-FVerMargin*2,
            SRCCOPY);
         //Lateral superior
         StretchBlt( Dc,
            left+FHorMargin,top+0,
            Width-FHorMargin*2,FVerMargin,
            bitmap.Canvas.Handle,
            FHorMargin,0,
            bitmap.width-FHorMargin*2,FVerMargin,
            SRCCOPY);
         //Lateral inferior
         StretchBlt( Dc,
            left+FHorMargin,top+height-FVerMargin,
            Width-FHorMargin*2,FVerMargin,
            bitmap.Canvas.Handle,
            FHorMargin,bitmap.Height-FVerMargin,
            bitmap.width-FHorMargin*2,FVerMargin,
            SRCCOPY);
         //corpo central
         StretchBlt( Dc,
            left+FHorMargin,top+FVerMargin,
            Width-FHorMargin*2,Height-FVerMargin*2,
            bitmap.Canvas.Handle,
            FHorMargin,FVerMargin,
            bitmap.width-FHorMargin*2,bitmap.Height-FVerMargin*2,
            SRCCOPY);

         DeleteObject(MyRgn);

         //ReleaseDC(Handle,DC);
end;

procedure DrawSmartBmp(handle: HBitmap; bitmap: TBitmap;
                    Margins: TRect; left, top, Width, Height: integer;
                    ClipRgn: TRect);
var
  Dc: hDC;
  FHorMargin, FVerMargin: integer;
  MyRgn: HRGN ;
begin
        MyRgn := CreateRectRgn(ClipRgn.Left,ClipRgn.Top, ClipRgn.Right, ClipRgn.Bottom );
        SelectClipRgn(handle,MyRgn);

        FHorMargin:=Margins.left;
        FVerMargin:=Margins.top;
        //Canto superior esquerdo
//        Bitmapdest.Canvas.Draw(left+0,top+0,bitmap);
         BitBlt(handle,
             left+0,top+0,
             FHorMargin,FVerMargin,
             bitmap.Canvas.Handle,
             0,0,SRCCOPY);
         //Canto superior direito
         BitBlt(handle,
             left+width-FHorMargin,top+0,
             FHorMargin,FVerMargin,
             bitmap.Canvas.Handle,
             bitmap.Width-FHorMargin,0,SRCCOPY);
         //Canto inferior esquerdo
         BitBlt(handle,
             left+0,top+height-FVerMargin,
             FHorMargin,FVerMargin,
             bitmap.Canvas.Handle,
             0,bitmap.Height-FVerMargin,SRCCOPY);
         //Canto inferior direito
         BitBlt(handle,
             left+width-FHorMargin,top+height-FVerMargin,
             FHorMargin,FVerMargin,
             bitmap.Canvas.Handle,
             bitmap.Width-FHorMargin,bitmap.Height-FVerMargin,
             SRCCOPY);
         //Lateral esquerda
         StretchBlt( handle,
            left+0,top+FVerMargin,
            FHorMargin,height-FVerMargin*2,
            bitmap.Canvas.Handle,
            0,FVerMargin,
            FHorMargin,bitmap.Height-FVerMargin*2,
            SRCCOPY);
         //Lateral direita
         StretchBlt( handle,
            left+Width-FHorMargin,top+FVerMargin,
            FHorMargin,height-FVerMargin*2,
            bitmap.Canvas.Handle,
            bitmap.width-FHorMargin,FVerMargin,
            FHorMargin,bitmap.Height-FVerMargin*2,
            SRCCOPY);
         //Lateral superior
         StretchBlt( handle,
            left+FHorMargin,top+0,
            Width-FHorMargin*2,FVerMargin,
            bitmap.Canvas.Handle,
            FHorMargin,0,
            bitmap.width-FHorMargin*2,FVerMargin,
            SRCCOPY);
         //Lateral inferior
         StretchBlt( handle,
            left+FHorMargin,top+height-FVerMargin,
            Width-FHorMargin*2,FVerMargin,
            bitmap.Canvas.Handle,
            FHorMargin,bitmap.Height-FVerMargin,
            bitmap.width-FHorMargin*2,FVerMargin,
            SRCCOPY);
         //corpo central
         StretchBlt( handle,
            left+FHorMargin,top+FVerMargin,
            Width-FHorMargin*2,Height-FVerMargin*2,
            bitmap.Canvas.Handle,
            FHorMargin,FVerMargin,
            bitmap.width-FHorMargin*2,bitmap.Height-FVerMargin*2,
            SRCCOPY);

         DeleteObject(MyRgn);

end;

//Igual a DrawSmartBmp mas apenas faz stretch na Horizontal,
//na vertical repete a imagem central de noStretchValue em noStretchValue
procedure DrawSmartBmpStretchH(Handle: HBitmap; bitmap: TBitmap;
                    Margins: TRect; left, top, Width, Height: integer;
                    ClipRgn: TRect; noStretchValue: integer);
var
  Dc: hDC;
  FHorMargin, FVerMargin: integer;
  MyRgn: HRGN ;
  i: integer;
begin
        MyRgn := CreateRectRgn(ClipRgn.Left,ClipRgn.Top, ClipRgn.Right, ClipRgn.Bottom );
        SelectClipRgn(handle,MyRgn);

        FHorMargin:=Margins.left;
        FVerMargin:=Margins.top;
        //Canto superior esquerdo
//        Bitmapdest.Canvas.Draw(left+0,top+0,bitmap);
         BitBlt(handle,
             left+0,top+0,
             FHorMargin,FVerMargin,
             bitmap.Canvas.Handle,
             0,0,SRCCOPY);
         //Canto superior direito
         BitBlt(handle,
             left+width-FHorMargin,top+0,
             FHorMargin,FVerMargin,
             bitmap.Canvas.Handle,
             bitmap.Width-FHorMargin,0,SRCCOPY);
         //Canto inferior esquerdo
         BitBlt(handle,
             left+0,top+height-FVerMargin,
             FHorMargin,FVerMargin,
             bitmap.Canvas.Handle,
             0,bitmap.Height-FVerMargin,SRCCOPY);
         //Canto inferior direito
         BitBlt(handle,
             left+width-FHorMargin,top+height-FVerMargin,
             FHorMargin,FVerMargin,
             bitmap.Canvas.Handle,
             bitmap.Width-FHorMargin,bitmap.Height-FVerMargin,
             SRCCOPY);
         //Lateral esquerda
         //Vai ser nostretch
         for i:=0 to ((Height-FVerMargin*2) div noStretchValue) do
          StretchBlt( handle,
            left+0,top+FVerMargin+i*noStretchValue,
            FHorMargin,noStretchValue,
            bitmap.Canvas.Handle,
            0,FVerMargin,
            FHorMargin,noStretchValue,
            SRCCOPY);
         //Lateral direita
         //Vai ser nostretch
         for i:=0 to ((Height-FVerMargin*2) div noStretchValue) do
          StretchBlt( handle,
            left+Width-FHorMargin,top+FVerMargin+i*noStretchValue,
            FHorMargin,noStretchValue,
            bitmap.Canvas.Handle,
            bitmap.width-FHorMargin,FVerMargin,
            FHorMargin,noStretchValue,
            SRCCOPY);
         //Lateral superior
         StretchBlt( handle,
            left+FHorMargin,top+0,
            Width-FHorMargin*2,FVerMargin,
            bitmap.Canvas.Handle,
            FHorMargin,0,
            bitmap.width-FHorMargin*2,FVerMargin,
            SRCCOPY);
         //Lateral inferior
         StretchBlt( handle,
            left+FHorMargin,top+height-FVerMargin,
            Width-FHorMargin*2,FVerMargin,
            bitmap.Canvas.Handle,
            FHorMargin,bitmap.Height-FVerMargin,
            bitmap.width-FHorMargin*2,FVerMargin,
            SRCCOPY);
         //corpo central
         //Vai ser nostretch
         for i:=0 to ((Height-FVerMargin*2) div noStretchValue) do
          StretchBlt( handle,
            left+FHorMargin,top+FVerMargin+i*noStretchValue,
            Width-FHorMargin*2,noStretchValue,
            bitmap.Canvas.Handle,
            FHorMargin,FVerMargin,
            bitmap.width-FHorMargin*2,noStretchValue,
            SRCCOPY);

         DeleteObject(MyRgn);

end;

procedure DrawSmartBmpStretchV(Handle: HBitmap; bitmap: TBitmap;
                    Margins: TRect; left, top, Width, Height: integer;
                    ClipRgn: TRect; noStretchValue: integer);
var
  Dc: hDC;
  FHorMargin, FVerMargin: integer;
  MyRgn: HRGN ;
  i: integer;
begin
        MyRgn := CreateRectRgn(ClipRgn.Left,ClipRgn.Top, ClipRgn.Right, ClipRgn.Bottom );
        SelectClipRgn(handle,MyRgn);

        FHorMargin:=Margins.left;
        FVerMargin:=Margins.top;
        //Canto superior esquerdo
//        Bitmapdest.Canvas.Draw(left+0,top+0,bitmap);
         BitBlt(handle,
             left+0,top+0,
             FHorMargin,FVerMargin,
             bitmap.Canvas.Handle,
             0,0,SRCCOPY);
         //Canto superior direito
         BitBlt(handle,
             left+width-FHorMargin,top+0,
             FHorMargin,FVerMargin,
             bitmap.Canvas.Handle,
             bitmap.Width-FHorMargin,0,SRCCOPY);
         //Canto inferior esquerdo
         BitBlt(handle,
             left+0,top+height-FVerMargin,
             FHorMargin,FVerMargin,
             bitmap.Canvas.Handle,
             0,bitmap.Height-FVerMargin,SRCCOPY);
         //Canto inferior direito
         BitBlt(handle,
             left+width-FHorMargin,top+height-FVerMargin,
             FHorMargin,FVerMargin,
             bitmap.Canvas.Handle,
             bitmap.Width-FHorMargin,bitmap.Height-FVerMargin,
             SRCCOPY);
         //Lateral esquerda
         StretchBlt( handle,
            left+0,top+FVerMargin,
            FHorMargin,height-FVerMargin*2,
            bitmap.Canvas.Handle,
            0,FVerMargin,
            FHorMargin,bitmap.Height-FVerMargin*2,
            SRCCOPY);
         //Lateral direita
         StretchBlt( handle,
            left+Width-FHorMargin,top+FVerMargin,
            FHorMargin,height-FVerMargin*2,
            bitmap.Canvas.Handle,
            bitmap.width-FHorMargin,FVerMargin,
            FHorMargin,bitmap.Height-FVerMargin*2,
            SRCCOPY);
         //Lateral superior
         //Vai ser nostretch
         for i:=0 to ((Width-FHorMargin*2) div noStretchValue) do
         StretchBlt( handle,
            left+FHorMargin,top+0,
            noStretchValue,FVerMargin,
            bitmap.Canvas.Handle,
            FHorMargin,0,
            noStretchValue,FVerMargin,
            SRCCOPY);
         //Lateral inferior
         //Vai ser nostretch
         for i:=0 to ((Width-FHorMargin*2) div noStretchValue) do
         StretchBlt( handle,
            left+FHorMargin,top+height-FVerMargin,
            noStretchValue,FVerMargin,
            bitmap.Canvas.Handle,
            FHorMargin,bitmap.Height-FVerMargin,
            noStretchValue,FVerMargin,
            SRCCOPY);
         //corpo central
         //Vai ser nostretch
         for i:=0 to ((Width-FHorMargin*2) div noStretchValue) do
         StretchBlt( handle,
            left+FHorMargin,top+FVerMargin,
            noStretchValue,Height-FVerMargin*2,
            bitmap.Canvas.Handle,
            FHorMargin,FVerMargin,
            noStretchValue,bitmap.Height-FVerMargin*2,
            SRCCOPY);

         DeleteObject(MyRgn);

end;


procedure BlendBitmap(var bitmap1, bitmap2: TBitmap; blendvalue: byte);
var
  Blendpba: PRGBTriple;
  Mainpba: PRGBTriple;
  result: pbytearray;
  mx,my: integer; // used to draw the blend in an area that won't try accessing information outside the images
  x,y: integer; // coordinates of a pixel
  x2: integer; // used to hold x shl 2
  x3: integer; // used to hold x2 + left for the memory location in th
  r, g, b: byte;
begin
     for y:=bitmap1.Height-1 downto 0 do // loop through the rows of pixels
     begin
          Blendpba:=bitmap1.ScanLine[y];
          Mainpba:=bitmap2.ScanLine[y];
          for x:=0 to (bitmap1.Width-1)  do// loop through the various pixels in a row
          begin

               Blendpba^.rgbtRed:=(Mainpba^.rgbtRed*Blendvalue+Blendpba^.rgbtRed*($FF-Blendvalue)) div 255;
               Blendpba^.rgbtGreen:=(Mainpba^.rgbtGreen*Blendvalue+Blendpba^.rgbtGreen*($FF-Blendvalue)) div 255;
               Blendpba^.rgbtBlue:=(Mainpba^.rgbtBlue*Blendvalue+Blendpba^.rgbtBlue*($FF-Blendvalue)) div 255;
               Inc(Blendpba);
               Inc(Mainpba);
          end;
     end;
end;

//Máscara preto com figura a branco
procedure BlendBitmapMasked(var bitmap1, bitmap2, maskbmp: TBitmap; blendvalue: byte);
var
  Blendpba, Mainpba, maskpba: PRGBTriple;
  x,y: integer; // coordinates of a pixel
  blendtemp: integer;
begin
     for y:=bitmap1.Height-1 downto 0 do // loop through the rows of pixels
     begin
          Blendpba:=bitmap1.ScanLine[y];
          Mainpba:=bitmap2.ScanLine[y];
          if not maskbmp.empty then
           maskpba:=maskbmp.ScanLine[y];
          for x:=0 to (bitmap1.Width-1)  do// loop through the various pixels in a row
          begin
             if not maskbmp.empty then
              begin
               blendtemp:=blendvalue*($FF-maskpba^.rgbtRed) div 255;
               Blendpba^.rgbtRed:=(Mainpba^.rgbtRed*blendtemp+Blendpba^.rgbtRed*($FF-blendtemp)) div 255;
               blendtemp:=blendvalue*($FF-maskpba^.rgbtGreen) div 255;
               Blendpba^.rgbtGreen:=(Mainpba^.rgbtGreen*blendtemp+Blendpba^.rgbtGreen*($FF-blendtemp)) div 255;
               blendtemp:=blendvalue*($FF-maskpba^.rgbtBlue)div 255;
               Blendpba^.rgbtBlue:=(Mainpba^.rgbtBlue*blendtemp+Blendpba^.rgbtBlue*($FF-blendtemp)) div 255;
              end
             else
              begin
               Blendpba^.rgbtRed:=(Mainpba^.rgbtRed*Blendvalue+Blendpba^.rgbtRed*($FF-Blendvalue)) div 255;
               Blendpba^.rgbtGreen:=(Mainpba^.rgbtGreen*Blendvalue+Blendpba^.rgbtGreen*($FF-Blendvalue)) div 255;
               Blendpba^.rgbtBlue:=(Mainpba^.rgbtBlue*Blendvalue+Blendpba^.rgbtBlue*($FF-Blendvalue)) div 255;
              end;
               Inc(Blendpba);
               Inc(Mainpba);
               Inc(maskpba);
          end;
     end;
end;

procedure BlendBitmapMasked2(var fundo: TBitmap; imagem, mascara: TBitmap);
var
  Blendpba: PRGBTriple;
  Mainpba: PRGBTriple;
  Maskpba: PRGBTriple;
  result: pbytearray;
  mx,my: integer; // used to draw the blend in an area that won't try accessing information outside the images
  x,y: integer; // coordinates of a pixel
  x2: integer; // used to hold x shl 2
  x3: integer; // used to hold x2 + left for the memory location in th
  r, g, b: byte;
  blendtemp: integer;
begin
     for y:=fundo.Height-1 downto 0 do // loop through the rows of pixels
     begin
          Mainpba:=fundo.ScanLine[y];
          Blendpba:=imagem.ScanLine[y];
          Maskpba:=mascara.ScanLine[y];
          for x:=0 to (fundo.Width-1)  do// loop through the various pixels in a row
          begin
              blendtemp:=255*($FF-maskpba^.rgbtRed) div 255;
               Mainpba^.rgbtRed:=(Blendpba^.rgbtRed*blendtemp+Mainpba^.rgbtRed*($FF-blendtemp)) div 255;
               blendtemp:=255*($FF-maskpba^.rgbtGreen) div 255;
               Mainpba^.rgbtGreen:=(Blendpba^.rgbtGreen*blendtemp+Mainpba^.rgbtGreen*($FF-blendtemp)) div 255;
               blendtemp:=255*($FF-maskpba^.rgbtBlue)div 255;
               Mainpba^.rgbtBlue:=(Blendpba^.rgbtBlue*blendtemp+Mainpba^.rgbtBlue*($FF-blendtemp)) div 255;
              Inc(Blendpba);
               Inc(Mainpba);
               Inc(maskpba);
          end;
     end;
end;


//Returns a mask for the bitmap and changes the original mask color to white
procedure Mask_from_Bitmap(var maskbmp: TBitmap;origbmp: TBitmap);
var Mainpba, maskpba: PRGBTriple;
    x,y: integer; // coordinates of a pixel
    transpcolor: TColor;
begin
    transpcolor:=origbmp.canvas.pixels[0,0];
    origbmp.pixelformat:=pf24bit;
    maskbmp.pixelformat:=pf24bit;
    maskbmp.width:=origbmp.width;
    maskbmp.height:=origbmp.height;
    for y:=origbmp.Height-1 downto 0 do // loop through the rows of pixels
     begin
          Mainpba:=origbmp.ScanLine[y];
          maskpba:=maskbmp.ScanLine[y];
          for x:=0 to (origbmp.Width-1)  do// loop through the various pixels in a row
          begin
            if RGB(Mainpba^.rgbtRed,Mainpba^.rgbtGreen,Mainpba^.rgbtBlue)<> transpcolor  then
              begin
               maskpba^.rgbtRed:=$FF;
               maskpba^.rgbtGreen:=$FF;
               maskpba^.rgbtBlue:=$FF;
              end
             else
              begin
               maskpba^.rgbtRed:=$00;
               maskpba^.rgbtGreen:=$00;
               maskpba^.rgbtBlue:=$00;
               Mainpba^.rgbtRed:=$FF;
               Mainpba^.rgbtGreen:=$FF;
               Mainpba^.rgbtBlue:=$FF;
              end;
            Inc(Mainpba);
            Inc(maskpba);
          end;
     end;
end;

//TILE
procedure FillZone(dc: Hdc; r: TRect; bmp: TBitmap);
var i, j, w, h, w1, h1, w2, h2: integer;
begin
    //
    w:=r.right-r.left;
    h:=r.bottom-r.top;
    if bmp.Width=75 then
     begin
      h:=h;
     end;
    if bmp.width<w then w1:=bmp.width else w1:=w;
    if bmp.height<h then h1:=bmp.height else h1:=h;
    for i:=0 to (w div w1)+1 do
     for j:=0 to (h div h1)+1 do
      begin
       if (i*w1+w1)>w then w2:=w-i*w1 else w2:=w1;
       if (j*h1+h1)>h then h2:=h-j*h1 else h2:=h1;
       bitblt(DC,r.left+i*w1,r.top+j*h1, w2, h2, bmp.Canvas.Handle,0,0,SRCCOPY);
      end;
end;

//CENTERED
procedure DrawMiddle(dc: Hdc; r: TRect; bmp: TBitmap);
var w, h, w1, h1, w2, h2, w3, h3: integer;
begin
    //
    w:=r.right-r.left;
    h:=r.bottom-r.top;

    if bmp.Width<=w then w1:=((w-bmp.Width) div 2) else w1:=0;
    if bmp.Height<=h then h1:=((h-bmp.height) div 2) else h1:=0;

    if bmp.Width<=w then w2:=bmp.Width else w2:=w;
    if bmp.Height<=h then h2:=bmp.height else h2:=h;

    if bmp.Width<=w then w3:=0 else w3:=bmp.Width-w;
    if bmp.Height<=h then h3:=0 else h3:=bmp.Height-h;

    bitblt(DC,r.left+w1,r.top+h1, w2, h2, bmp.Canvas.Handle,w3,h3,SRCCOPY);

end;

//Pinta uma imagem de determinada cor apenas na zona definida pela mascara
procedure Grafitti(var destin, mask: TBitmap; color: TColor; blendvalue: byte);
var
  Destinpba: PRGBTriple;
  Maskpba: PRGBTriple;
  result: pbytearray;
  mx,my: integer; // used to draw the blend in an area that won't try accessing information outside the images
  x,y: integer; // coordinates of a pixel
  x2: integer; // used to hold x shl 2
  x3: integer; // used to hold x2 + left for the memory location in th
  r, g, b: byte;
  blendtemp: integer;
begin
     for y:=destin.Height-1 downto 0 do // loop through the rows of pixels
     begin
          Destinpba:=destin.ScanLine[y];
          Maskpba:=mask.ScanLine[y];
          for x:=0 to (destin.Width-1)  do// loop through the various pixels in a row
          begin

             if RGB(Maskpba^.rgbtRed,Maskpba^.rgbtGreen,Maskpba^.rgbtBlue)<> clWhite  then
              begin
               blendtemp:=GetRValue(color)*($FF-Destinpba^.rgbtRed) div 255;
               Destinpba^.rgbtRed:=(blendtemp+Destinpba^.rgbtRed*($FF-Blendvalue)) div 255;
               blendtemp:=GetGValue(color)*($FF-Destinpba^.rgbtGreen) div 255;
               Destinpba^.rgbtGreen:=(blendtemp+Destinpba^.rgbtGreen*($FF-Blendvalue)) div 255;
               blendtemp:=GetBValue(color)*($FF-Destinpba^.rgbtBlue) div 255;
               Destinpba^.rgbtBlue:=(blendtemp+Destinpba^.rgbtBlue*($FF-Blendvalue)) div 255;
              end;

               Inc(Destinpba);
               Inc(Maskpba);
          end;
     end;
end;

function LighterColor(c1 : TColor; lightness: Byte): TColor;
var C:TmyColor;
begin
   C.R := (TmyColor(c1).R + lightness) MOD 255;
   C.B := (TmyColor(c1).B + lightness) MOD 255;
   C.G := (TmyColor(c1).G + lightness) MOD 255;
   C.A := TmyColor(c1).A;//(TmyColor(c1).A - darkness) MOD 255;
   Result := C.C;
end;

function DarkerColor(c1 : TColor; darkness: Byte): TColor;
var C:TmyColor;
begin
   C.R := (TmyColor(c1).R - darkness) MOD 255;
   C.B := (TmyColor(c1).B - darkness) MOD 255;
   C.G := (TmyColor(c1).G - darkness) MOD 255;
   C.A := TmyColor(c1).A;//(TmyColor(c1).A - darkness) MOD 255;
   Result := C.C;
end;

function Red(Color32: TColor32): Integer;
var i: integer;
begin
  i := (Color32 and $00FF0000) shr 16;
  i:=i+1-1;
  result:=i;
end;

function Green(Color32: cardinal): Integer;
var i: integer;
begin
  i := (Color32 and $0000FF00) shr 8;
  i:=i+1-1;
  result:=i;
end;

function Blue(Color32: cardinal): Integer;
var i: integer;
begin
  i := Color32 and $000000FF;
  i:=i+1-1;
  result:=i;
end;

function Alpha(Color32: cardinal): Integer;
begin
  Result := Color32 shr 24;
end;


procedure InvertBitmap(var bitmap1: TBitmap);
var
  Blendpba: PRGBTriple;
  x,y: integer; // coordinates of a pixel
begin
     for y:=bitmap1.Height-1 downto 0 do // loop through the rows of pixels
     begin
          Blendpba:=bitmap1.ScanLine[y];
          for x:=0 to (bitmap1.Width-1)  do// loop through the various pixels in a row
          begin

               Blendpba^.rgbtRed:=$FF-Blendpba^.rgbtRed;
               Blendpba^.rgbtGreen:=$FF-Blendpba^.rgbtGreen;
               Blendpba^.rgbtBlue:=$FF-Blendpba^.rgbtBlue;
               Inc(Blendpba);
          end;
     end;
end;

//Bitmap32 should be 32 bits
//Alpha 24
procedure MakeAlphaBitmap(var bitmap32: TBitmap; alpha: TBitmap);
var alphabmp: TBitmap;
  x,y,k: Integer;
  D, S: PColor32;
  T,U,p: Cardinal	;
begin
    {alphabmp:=TBitmap.Create;
    //alphabmp.HandleType := bmDIB;
    alphabmp.PixelFormat := pf32Bit;
    alphabmp.Width:=alpha.Width;
    alphabmp.Height:=alpha.Height;
    //qualquer uma das cores R, G, B deverão estar iguais pois a máscara é em tons de cinza
    bitblt(alphabmp.Handle,0,0,alphabmp.Width,alphabmp.Height,alpha.canvas.Handle,0,0,SRCCOPY);  }

    for y:=bitmap32.Height-1 downto 0 do // loop through the rows of pixels
     begin
      D := bitmap32.ScanLine[y];
      S := alpha.ScanLine[y];
      for x:=0 to (bitmap32.Width-1)  do// loop through the various pixels in a row
       begin
        // if invertmask then //S^:=$000000FF - (S^ and $000000FF);
          { S^:=s^ xor $FFFFFFFF;
           k:=S^;
           t:=(red(k)*(255-green(k))+green(k)*(255-red(k)))div 255;
           t:=(Blue(k)*(255-t)+t*(255-Blue(k)))div 255;
           p:=(red(D^)*(255-green(D^))+green(D^)*(255-red(D^)))div 255;
           p:=(Blue(D^)*(255-p)+p*(255-Blue(D^)))div 255;
           //t:=255-t;
           //d^:=d^ xor $FFFFFFFF;
           u:=(Blue(D^)*abs(t-p)+($FF-Blue(D^))*($FF-abs(t-p)))div 255+
              ((Green(D^)*abs(t-p)+($FF-Green(D^))*($FF-abs(t-p)))div 255) shl 8+
              ((Red(D^)*abs(t-p)+($FF-Red(D^))*($FF-abs(t-p)))div 255) shl 16;

         D^ := (U and $00FFFFFF)
               //+(S^ and $000000FF) shl 24;
               +t shl 24;   }

         //if invertmask then //S^:=$000000FF - (S^ and $000000FF);
         //  S^:=s^ xor $FFFFFFFF;
         //D^ := (S^ and $000000FF) shl 24 +(D^ and $00FFFFFF);
         D^ := (S^ and $000000FF)shl 24 +(D^ and $00FFFFFF);
        Inc(S); Inc(D);
       end;
     end;

   //alphabmp.Free;

end;

//Inverte um bitmap baseado numa máscara de cinzento
//Por defeito mascara com fundo negro
//ImageBMP and mask should be 32 bits
procedure InvertMasked(var Imagebmp32: TBItmap; mask: TBitmap);
var
  S: PColor32;
  D: PColor32;
  x,y: integer; // coordinates of a pixel
  r, g, b, blendvalue: byte;
begin
     for y:=Imagebmp32.Height-1 downto 0 do // loop through the rows of pixels
     begin
          S:=Imagebmp32.ScanLine[y];
          D:=mask.ScanLine[y];
          for x:=0 to (Imagebmp32.Width-1)  do// loop through the various pixels in a row
          begin
               S^:=(S^ and $FF000000)+ (((S^ xor $FFFFFFFF) and $00FFFFFF) xor ((D^ xor $FFFFFFFF) and $00FFFFFF));
               Inc(S);
               Inc(D);
          end;
     end;
end;

procedure Gray(var clip: tbitmap);
var
p0:pbytearray;
Gray,x,y: Integer;
begin
  for y:=0 to clip.Height-1 do
  begin
    p0:=clip.scanline[y];
    for x:=0 to clip.Width-1 do
    begin
      Gray:=Round(p0[x*3]*0.3+p0[x*3+1]*0.59+p0[x*3+2]*0.11);
      p0[x*3]:=Gray;
      p0[x*3+1]:=Gray;
      p0[x*3+2]:=Gray;
    end;
  end;
end;

procedure AntiAliasRect(clip: tbitmap; XOrigin, YOrigin,
  XFinal, YFinal: Integer);
var Memo,x,y: Integer; (* Composantes primaires des points environnants *)
    p0,p1,p2:pbytearray;
    bb: byte;
begin
   if XFinal<XOrigin then begin Memo:=XOrigin; XOrigin:=XFinal; XFinal:=Memo; end;  (* Inversion des valeurs   *)
   if YFinal<YOrigin then begin Memo:=YOrigin; YOrigin:=YFinal; YFinal:=Memo; end;  (* si diff‚rence n‚gative*)
   XOrigin:=max(1,XOrigin);
   YOrigin:=max(1,YOrigin);
   XFinal:=min(clip.width-2,XFinal);
   YFinal:=min(clip.height-2,YFinal);
   clip.PixelFormat :=pf24bit;
   for y:=YOrigin to YFinal do begin
    p0:=clip.ScanLine [y-1];
    p1:=clip.scanline [y];
    p2:=clip.ScanLine [y+1];
    for x:=XOrigin to XFinal do begin
      bb:=p0[x*3];
      if not ((bb=p0[x*3+1]) and (bb=p0[x*3+2])
      //and (bb=p1[x*3]) and (bb=p1[x*3+1]) and (bb=p1[x*3+2])
      //and (bb=p1[(x-1)*3]) and (bb=p1[(x+1)*3]) and (bb=p1[(x-1)*3+1])
      //and (bb=p1[(x+1)*3+1]) and (bb=p1[(x-1)*3+2]) and (bb=p1[(x+1)*3+2])
      //and (bb=p2[x*3]) and (bb=p2[x*3+1]) and (bb=p2[x*3+2])
      )
      then begin
           p1[x*3]:=(p0[x*3]+p2[x*3]+p1[(x-1)*3]+p1[(x+1)*3])div 4;
           p1[x*3+1]:=(p0[x*3+1]+p2[x*3+1]+p1[(x-1)*3+1]+p1[(x+1)*3+1])div 4;
           p1[x*3+2]:=(p0[x*3+2]+p2[x*3+2]+p1[(x-1)*3+2]+p1[(x+1)*3+2])div 4;
           end;
      end;
   end;
end;

procedure AntiAlias(clip: tbitmap);
begin
 AntiAliasRect(clip,0,0,clip.width,clip.height);
end;


procedure AntiAliasedText(CV: TCanvas; const sText: String; x,y: integer);
var
   LogFont: TLogFont;
   SaveFont: TFont;
begin
  cv.Lock;
  SetGraphicsMode(CV.Handle, GM_ADVANCED);//for NT
//  CV.Font.Size:=size;
//  CV.Font.Color:=Col;
  SaveFont := TFont.Create;
  SaveFont.Assign(CV.Font);
  GetObject(SaveFont.Handle, sizeof(TLogFont), @LogFont);
  with LogFont do
  begin
    lfPitchAndFamily := FIXED_PITCH or FF_DONTCARE;
    lfQuality := ANTIALIASED_QUALITY;
  end;
  CV.Font.Handle := CreateFontIndirect(LogFont);
  SetBkMode(CV.Handle, TRANSPARENT);
  CV.TextOut(x, y, sText);
  CV.Font.Assign(SaveFont);
  SaveFont.Free;
  cv.Unlock;
end;

{This will start drawing text from x, y. If it goes past maxwidth, it will drop to next line.
At the end of this routine, x and y will be at the position just past the end of the text}
procedure WordWrapTextOut(canvas: TCanvas; var x, y: integer; S: string; maxwidth, lineheight: integer);
  const
    delims = ' ,.:;?!';
  var
    textw, texth, tempw: integer;
    firststring, secondstring: string;
    i: integer;
  begin
    firststring := s;
    while firststring <> '' do
    begin
      secondstring := '';
      textw := canvas.TextWidth(firststring);
      while (
              (firststring <> '') and  (textw > maxwidth)
            ) do
      begin
        secondstring := firststring[length(firststring)] + secondstring;
        delete(firststring, length(firststring), 1);
        tempw := canvas.TextWidth(firststring);
        if ( (tempw <= maxwidth) and  (pos(firststring[length(firststring)], delims) > 0) ) then
          textw := tempw;
      end;
// searching for delimiter failed. fall back to wrap at last char
      if firststring = '' then
      begin
        firststring := secondstring;
        secondstring := '';
        textw := canvas.TextWidth(firststring);
        while ( (textw > maxwidth) and (length(firststring) > 0) ) do
        begin
          secondstring := firststring[length(firststring)] + secondstring;
          delete(firststring, length(firststring), 1);
          textw := canvas.TextWidth(firststring);
        end;
      end;
// actually draw some text
      canvas.TextOut(x, y, firststring);
      firststring := secondstring;
      if firststring <> '' then
      begin
        y := y + lineheight;
      end;
    end;
// get the position right in case the user wishes to add some more text to this line
    x := x + textw;
  end;

procedure SetJPEGOptions(var pic: TPicture);
var
  Temp: Boolean;
begin
  Temp := pic.Graphic is TJPEGImage;
  if Temp then
    with TJPEGImage(pic.Graphic) do
    begin
      PixelFormat := TJPEGPixelFormat(jf24bit);

      //Scale := TJPEGScale(1);
      Scale := jsFullSize;
      Grayscale := False;
      Performance := TJPEGPerformance(jpBestQuality);
      ProgressiveDisplay := True;
    end;

end;

procedure DrawPicture(cv: TCanvas; x,y: integer; ThePic: TPicture);
var bmp: TBitmap;
begin

    //in case of jpeg
    SetJPEGOptions(ThePic);

    bmp:=TBitmap.Create;
    bmp.Width:=ThePic.Width;
    bmp.Height:=ThePic.Height;

    if ThePic.Graphic is TJPEGImage then
     bmp.Canvas.Draw(0,0,ThePic.Graphic)
    else
    if not ThePic.Bitmap.Empty then
     bmp.Canvas.Draw(0,0,ThePic.Bitmap);

    cv.Draw(X,Y,bmp);

    bmp.Free;
end;

procedure DrawBMPGrayed(DestHDC: HBitmap; x1,y1,w1,h1: integer; Src: TBitmap; x2,y2,w2,h2: integer);
var tempbitmap: TBitmap;
begin
        tempbitmap:=TBitmap.Create;
        tempbitmap.Width:=w2;
        tempbitmap.Height:=h2;
        tempbitmap.pixelformat:=pf24bit;
        bitblt(tempbitmap.Canvas.Handle,0,0,w2,h2,src.Canvas.Handle,0,0,SRCCOPY);
        Gray(tempbitmap);
        //InvertBitmap(SRC);
        stretchblt(DestHDC,x1,y1,w1,h1,tempbitmap.Canvas.Handle,x2,y2,w2,h2,SRCCOPY);
        tempbitmap.Free;
end;

// Avoid JPEG Error #52:
  // Verify first two bytes of JPEG are $FFD8 (little endian $D8FF)
  // Verify last two bytes of JPEG are $FFD9 (little endian $D9FF)
FUNCTION JPEGSentinelsAreOK(CONST Filename:  TFilename):  BOOLEAN;
    VAR
      FileStream:  TFileStream;
      w1        :  WORD;     // a "word" is always 2 bytes long
      w2        :  WORD;
  BEGIN
    ASSERT(SizeOf(WORD) = 2);

    RESULT := FileExists(Filename);

    IF   RESULT
    THEN BEGIN
      FileStream := TFileStream.Create(Filename, fmOpenRead OR fmShareDenyNone);
      TRY
        FileStream.Seek(0, soFromBeginning); // use seek or position
        FileStream.Read(w1,2);

        FileStream.Position := FileStream.Size - 2;
        FileStream.Read(w2,2)
      FINALLY
        FileStream.Free
      END;

      RESULT := (w1 = $D8FF) AND (w2 = $D9FF);
    END
  END;


procedure DrawTransparentBitmap(DC: HDC; hBmp : HBITMAP ;
          xStart: integer; yStart : integer; cTransparentColor : COLORREF);
var
      bm:                                                  BITMAP;
      cColor:                                              COLORREF;
      bmAndBack, bmAndObject, bmAndMem, bmSave:            HBITMAP;
      bmBackOld, bmObjectOld, bmMemOld, bmSaveOld:         HBITMAP;
      hdcMem, hdcBack, hdcObject, hdcTemp, hdcSave:        HDC;
      ptSize:                                              TPOINT;

begin
   hdcTemp := CreateCompatibleDC(dc);
   SelectObject(hdcTemp, hBmp);   // Select the bitmap

   GetObject(hBmp, sizeof(BITMAP), @bm);
   ptSize.x := bm.bmWidth;            // Get width of bitmap
   ptSize.y := bm.bmHeight;           // Get height of bitmap
   DPtoLP(hdcTemp, ptSize, 1);        // Convert from device
                                      // to logical points

   // Create some DCs to hold temporary data.
   hdcBack   := CreateCompatibleDC(dc);
   hdcObject := CreateCompatibleDC(dc);
   hdcMem    := CreateCompatibleDC(dc);
   hdcSave   := CreateCompatibleDC(dc);

   // Create a bitmap for each DC. DCs are required for a number of
   // GDI functions.

   // Monochrome DC
   bmAndBack   := CreateBitmap(ptSize.x, ptSize.y, 1, 1, nil);

   // Monochrome DC
   bmAndObject := CreateBitmap(ptSize.x, ptSize.y, 1, 1, nil);

   bmAndMem    := CreateCompatibleBitmap(dc, ptSize.x, ptSize.y);
   bmSave      := CreateCompatibleBitmap(dc, ptSize.x, ptSize.y);

   // Each DC must select a bitmap object to store pixel data.
   bmBackOld   := SelectObject(hdcBack, bmAndBack);
   bmObjectOld := SelectObject(hdcObject, bmAndObject);
   bmMemOld    := SelectObject(hdcMem, bmAndMem);
   bmSaveOld   := SelectObject(hdcSave, bmSave);

   // Set proper mapping mode.
   SetMapMode(hdcTemp, GetMapMode(dc));

   // Save the bitmap sent here, because it will be overwritten.
   BitBlt(hdcSave, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0, SRCCOPY);

   // Set the background color of the source DC to the color.
   // contained in the parts of the bitmap that should be transparent
   cColor := SetBkColor(hdcTemp, cTransparentColor);

   // Create the object mask for the bitmap by performing a BitBlt
   // from the source bitmap to a monochrome bitmap.
   BitBlt(hdcObject, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0,
          SRCCOPY);

   // Set the background color of the source DC back to the original
   // color.
   SetBkColor(hdcTemp, cColor);

   // Create the inverse of the object mask.
   BitBlt(hdcBack, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0,
          NOTSRCCOPY);

   // Copy the background of the main DC to the destination.
   BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, dc, xStart, yStart,
          SRCCOPY);

   // Mask out the places where the bitmap will be placed.
   BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0, SRCAND);

   // Mask out the transparent colored pixels on the bitmap.
   BitBlt(hdcTemp, 0, 0, ptSize.x, ptSize.y, hdcBack, 0, 0, SRCAND);

   // XOR the bitmap with the background on the destination DC.
   BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0, SRCPAINT);

   // Copy the destination to the screen.
   BitBlt(dc, xStart, yStart, ptSize.x, ptSize.y, hdcMem, 0, 0,
          SRCCOPY);

   // Place the original bitmap back into the bitmap sent here.
   BitBlt(hdcTemp, 0, 0, ptSize.x, ptSize.y, hdcSave, 0, 0, SRCCOPY);

   // Delete the memory bitmaps.
   DeleteObject(SelectObject(hdcBack, bmBackOld));
   DeleteObject(SelectObject(hdcObject, bmObjectOld));
   DeleteObject(SelectObject(hdcMem, bmMemOld));
   DeleteObject(SelectObject(hdcSave, bmSaveOld));

   // Delete the memory DCs.
   DeleteDC(hdcMem);
   DeleteDC(hdcBack);
   DeleteDC(hdcObject);
   DeleteDC(hdcSave);
   DeleteDC(hdcTemp);
end;

procedure RotateBmp(Src: TBitmap; var Dst: TBitmap; cx, cy: Integer;
  Angle: Extended; BColor: TColor);
type
 TFColor  = record b,g,r:Byte end;
var
Top,
Bottom,
Left,
Right,
eww,nsw,
fx,fy,
wx,wy:    Extended;
cAngle,
sAngle:   Double;
xDiff,
yDiff,
ifx,ify,
px,py,
ix,iy,
x,y:      Integer;
nw,ne,
sw,se:    TFColor;
P1,P2,P3:Pbytearray;
begin
  Angle:=angle;
  Angle:=-Angle*Pi/180;
  sAngle:=Sin(Angle);
  cAngle:=Cos(Angle);
  xDiff:=(Dst.Width-Src.Width)div 2;
  yDiff:=(Dst.Height-Src.Height)div 2;
  for y:=0 to Dst.Height-1 do
  begin
    P3:=Dst.scanline[y];
    py:=2*(y-cy)+1;
    for x:=0 to Dst.Width-1 do
    begin
      px:=2*(x-cx)+1;
      fx:=(((px*cAngle-py*sAngle)-1)/ 2+cx)-xDiff;
      fy:=(((px*sAngle+py*cAngle)-1)/ 2+cy)-yDiff;
      ifx:=Round(fx);
      ify:=Round(fy);

      if(ifx>-1)and(ifx<Src.Width)and(ify>-1)and(ify<Src.Height)then
      begin
        eww:=fx-ifx;
        nsw:=fy-ify;
        iy:=TrimInt(ify+1,0,Src.Height-1);
        ix:=TrimInt(ifx+1,0,Src.Width-1);
        P1:=Src.scanline[ify];
        P2:=Src.scanline[iy];
        nw.r:=P1[ifx*3];
        nw.g:=P1[ifx*3+1];
        nw.b:=P1[ifx*3+2];
        ne.r:=P1[ix*3];
        ne.g:=P1[ix*3+1];
        ne.b:=P1[ix*3+2];
        sw.r:=P2[ifx*3];
        sw.g:=P2[ifx*3+1];
        sw.b:=P2[ifx*3+2];
        se.r:=P2[ix*3];
        se.g:=P2[ix*3+1];
        se.b:=P2[ix*3+2];

        Top:=nw.b+eww*(ne.b-nw.b);
        Bottom:=sw.b+eww*(se.b-sw.b);
        P3[x*3+2]:=IntToByte(Round(Top+nsw*(Bottom-Top)));

        Top:=nw.g+eww*(ne.g-nw.g);
        Bottom:=sw.g+eww*(se.g-sw.g);
        P3[x*3+1]:=IntToByte(Round(Top+nsw*(Bottom-Top)));

        Top:=nw.r+eww*(ne.r-nw.r);
        Bottom:=sw.r+eww*(se.r-sw.r);
        P3[x*3]:=IntToByte(Round(Top+nsw*(Bottom-Top)));
      end
     else
       begin
        P3[x*3+2]:=GetBValue(bColor);
        P3[x*3+1]:=GetGValue(bColor);
        P3[x*3]:=GetRValue(bColor);
       end;
    end;
  end;
end;

procedure DrawReflection(Target: TGPGraphics; SourceBmp: TGPBitmap;
  SrcWidth, SrcHeight, ReflHeight, BottomCutOff, TargetX, TargetY, StartOpacity: Integer);
var
  ReflImg: TGPBitmap;
  x, y, alpha: Integer;
  colorTemp: TGPColor;
begin
  if SrcWidth < 0 then
    SrcWidth := SourceBmp.GetWidth();

  if SrcHeight < 0 then
    SrcHeight := SourceBmp.GetHeight();

  if ReflHeight < 0 then
    ReflHeight := SrcHeight div 3;

  if ReflHeight > SrcHeight then
    ReflHeight := SrcHeight;

  // bitmap that will be turned into the reflection:
  ReflImg := TGPBitmap.Create(SrcWidth, ReflHeight, PixelFormat32bppARGB);

  for y := SrcHeight - 1 downto SrcHeight - ReflHeight do
  begin
    for x := 0 to SrcWidth - 1 do
    begin
      SourceBmp.GetPixel(x, y - BottomCutOff, colorTemp);
      if GetAlpha(colorTemp) <> 0 then
      begin
        alpha := ((y - (SrcHeight - ReflHeight)) * StartOpacity div ReflHeight) - (255 - GetAlpha(colorTemp));
        if alpha > 0 then
        begin
          colorTemp := MakeColor(alpha, GetRed(colorTemp), GetGreen(colorTemp), GetBlue(colorTemp));
          ReflImg.SetPixel(x, SrcHeight - 1 - y, colorTemp);
        end;
      end;
    end;
  end;

  // copy reflection into main image:
  Target.DrawImage(ReflImg, TargetX, TargetY);
  ReflImg.Free();
end;

procedure SmoothResize(Src, Dst: TBitmap);
var
  x, y: Integer;
  xP, yP: Integer;
  xP2, yP2: Integer;
  SrcLine1, SrcLine2: pRGBArray;
  t3: Integer;
  z, z2, iz2: Integer;
  DstLine: pRGBArray;
  DstGap: Integer;
  w1, w2, w3, w4: Integer;
begin
  Src.PixelFormat := pf24Bit;
  Dst.PixelFormat := pf24Bit;

  if (Src.Width = Dst.Width) and (Src.Height = Dst.Height) then
    Dst.Assign(Src)
  else
  begin
    DstLine := Dst.ScanLine[0];
    DstGap  := Integer(Dst.ScanLine[1]) - Integer(DstLine);

    xP2 := MulDiv(pred(Src.Width), $10000, Dst.Width);
    yP2 := MulDiv(pred(Src.Height), $10000, Dst.Height);
    yP  := 0;

    for y := 0 to pred(Dst.Height) do
    begin
      xP := 0;

      SrcLine1 := Src.ScanLine[yP shr 16];

      if (yP shr 16 < pred(Src.Height)) then
        SrcLine2 := Src.ScanLine[succ(yP shr 16)]
      else
        SrcLine2 := Src.ScanLine[yP shr 16];

      z2  := succ(yP and $FFFF);
      iz2 := succ((not yp) and $FFFF);
      for x := 0 to pred(Dst.Width) do
      begin
        t3 := xP shr 16;
        z  := xP and $FFFF;
        w2 := MulDiv(z, iz2, $10000);
        w1 := iz2 - w2;
        w4 := MulDiv(z, z2, $10000);
        w3 := z2 - w4;
        DstLine[x].rgbtRed := (SrcLine1[t3].rgbtRed * w1 +
          SrcLine1[t3 + 1].rgbtRed * w2 +
          SrcLine2[t3].rgbtRed * w3 + SrcLine2[t3 + 1].rgbtRed * w4) shr 16;
        DstLine[x].rgbtGreen :=
          (SrcLine1[t3].rgbtGreen * w1 + SrcLine1[t3 + 1].rgbtGreen * w2 +

          SrcLine2[t3].rgbtGreen * w3 + SrcLine2[t3 + 1].rgbtGreen * w4) shr 16;
        DstLine[x].rgbtBlue := (SrcLine1[t3].rgbtBlue * w1 +
          SrcLine1[t3 + 1].rgbtBlue * w2 +
          SrcLine2[t3].rgbtBlue * w3 +
          SrcLine2[t3 + 1].rgbtBlue * w4) shr 16;
        Inc(xP, xP2);
      end; {for}
      Inc(yP, yP2);
      DstLine := pRGBArray(Integer(DstLine) + DstGap);
    end; {for}
  end; {if}
end; {SmoothResize}

function LoadJPEGPictureFile(Bitmap: TBitmap; FilePath, FileName: string): Boolean;
var
  JPEGImage: TJPEGImage;
begin
  if (FileName = '') then    // No FileName so nothing
    Result := False  //to load - return False...
  else
  begin
    try  // Start of try except
      JPEGImage := TJPEGImage.Create;  // Create the JPEG image... try  // now
      try  // to load the file but
        JPEGImage.LoadFromFile(FilePath + FileName);
        // might fail...with an Exception.
        Bitmap.Assign(JPEGImage);
        // Assign the image to our bitmap.Result := True;
        // Got it so return True.
      finally
        JPEGImage.Free;  // ...must get rid of the JPEG image. finally
         Result :=true;
      end; {try}
    except
      Result := False; // Oops...never Loaded, so return False.
    end; {try}
  end; {if}
end; {LoadJPEGPictureFile}

{$IF HAS_FMX}
function LoadPNGPictureFile(Bitmap: TBitmap; FilePath, FileName: string): Boolean;
var DestPNG: TPngImage;
begin
  if (FileName = '') then    // No FileName so nothing
    Result := False  //to load - return False...
  else
  begin
    try  // Start of try except
      DestPNG := TPngImage.Create;  // Create the JPEG image... try  // now
      try  // to load the file but
        DestPNG.LoadFromFile(FilePath + FileName);
        // might fail...with an Exception.
        Bitmap.Assign(DestPNG);
        // Assign the image to our bitmap.Result := True;
        // Got it so return True.
      finally
        DestPNG.Free;  // ...must get rid of the JPEG image. finally
         Result :=true;
      end; {try}
    except
      Result := False; // Oops...never Loaded, so return False.
    end; {try}
  end; {if}

end;  {LoadPNGPictureFile}
{$ENDIF}

function SaveJPEGPictureFile(Bitmap: TBitmap; FilePath, FileName: string;
  Quality: Integer): Boolean;
begin
  Result := True;
  try
    if ForceDirectories(FilePath) then
    begin
      with TJPegImage.Create do
      begin
        try
          Assign(Bitmap);
          CompressionQuality := Quality;
          SaveToFile(FilePath + FileName);
        finally
          Free;
        end; {try}
      end; {with}
    end; {if}
  except
    raise;
    Result := False;
  end; {try}
end; {SaveJPEGPictureFile}

procedure ResizeImage(FileName: string; MaxWidth: Integer);
var
  OldBitmap: TBitmap;
  NewBitmap: TBitmap;
  aWidth: Integer;
begin
  OldBitmap := TBitmap.Create;
  try
    if LoadJPEGPictureFile(OldBitmap, ExtractFilePath(FileName),
      ExtractFileName(FileName)) then
    begin
      aWidth := OldBitmap.Width;
      if (OldBitmap.Width > MaxWidth) then
      begin
        aWidth    := MaxWidth;
        NewBitmap := TBitmap.Create;
        try
          NewBitmap.Width  := MaxWidth;
          NewBitmap.Height := MulDiv(MaxWidth, OldBitmap.Height, OldBitmap.Width);
          SmoothResize(OldBitmap, NewBitmap);
          RenameFile(FileName, ChangeFileExt(FileName, '.$$$'));
          if SaveJPEGPictureFile(NewBitmap, ExtractFilePath(FileName),
            ExtractFileName(FileName), 75) then
            DeleteFile(ChangeFileExt(FileName, '.$$$'))
          else
            RenameFile(ChangeFileExt(FileName, '.$$$'), FileName);
        finally
          NewBitmap.Free;
        end; {try}
      end; {if}
    end; {if}
  finally
    OldBitmap.Free;
  end; {try}
end;

function JPEGDimensions(Filename : string; var X, Y : Word) : boolean;
var
  SegmentPos : Integer;
  SOIcount : Integer;
  b : byte;
begin
  Result  := False;
  with TFileStream.Create(Filename, fmOpenRead or fmShareDenyNone) do
  begin
    try
      Position := 0;
      Read(X, 2);
      if (X <> $D8FF) then
        exit;
      SOIcount  := 0;
      Position  := 0;
      while (Position + 7 < Size) do
      begin
        Read(b, 1);
        if (b = $FF) then begin
          Read(b, 1);
          if (b = $D8) then
            inc(SOIcount);
          if (b = $DA) then
            break;
        end; {if}
      end; {while}
      if (b <> $DA) then
        exit;
      SegmentPos  := -1;
      Position    := 0;
      while (Position + 7 < Size) do
      begin
        Read(b, 1);
        if (b = $FF) then
        begin
          Read(b, 1);
          if (b in [$C0, $C1, $C2]) then
          begin
            SegmentPos  := Position;
            dec(SOIcount);
            if (SOIcount = 0) then
              break;
          end; {if}
        end; {if}
      end; {while}
      if (SegmentPos = -1) then
        exit;
      if (Position + 7 > Size) then
        exit;
      Position := SegmentPos + 3;
      Read(Y, 2);
      Read(X, 2);
      X := Swap(X);
      Y := Swap(Y);
      Result  := true;
    finally
      Free;
    end; {try}
  end; {with}
end; {JPEGDimensions}

function DrawGDIText(var DestBitmap: TBitmap; caption: string; px,py: integer; r: TRect; FontName: string;
                      FontSize: integer; FontColor: TColor; Antialias: boolean):integer;
var DestGP: TGPGraphics;
    brush:     TGPBrush;
    fontFam:   TGPFontFamily;
    curFont:   TGPFont;
    strFormat: TGPStringFormat;
    rct:       TGPRectF;   // Designates the string drawing bounds
    //t_rct: TGPRectF;
begin
  //
  DestBitmap.Canvas.lock;
  DestGP := TGPGraphics.Create(DestBitmap.canvas.Handle);

  brush := TGPSolidBrush.Create(FontColor);
  //GdipCreateSolidFill(FontColor, brush);

  fontFam := TGPFontFamily.Create(FontName);
  curFont := TGPFont.Create(fontFam, FontSize);
  //GdipCreateFontFamilyFromName(PWideChar(FontName), 0, fontFam);
  //GdipCreateFont(fontFam, FontSize, FontStyleRegular, 3 {UnitPoint}, curFont);

  strFormat := TGPStringFormat.Create;
  //GdipCreateStringFormat(0, 0, strFormat);

  //GDIPAPI.gdipc
  rct.X:=r.Left;
  rct.Y:=r.Top;
  rct.Width:=r.Right-r.Left;
  rct.Height:= r.Bottom-r.Top;
  //rct:=^t_rct;
  //StringAlignmentNear,StringAlignmentCenter,StringAlignmentFar
  strFormat.SetFormatFlags(StringFormatFlagsNoFitBlackBox or
              StringFormatFlagsNoClip );
  strFormat.SetAlignment(StringAlignmentCenter);
  strFormat.SetLineAlignment(StringAlignmentCenter);
  strFormat.SetTrimming(StringTrimmingNone);

  //GdipSetStringFormatAlign(strFormat,StringAlignmentCenter );
  //GdipSetStringFormatLineAlign(strFormat,StringAlignmentCenter );

  {
  function GdipDrawString(graphics: GPGRAPHICS; string_: PWCHAR;
    length: Integer; font: GPFONT; layoutRect: PGPRectF;
    stringFormat: GPSTRINGFORMAT; brush: GPBRUSH): GPSTATUS; stdcall;

  function GdipMeasureString(graphics: GPGRAPHICS; string_: PWCHAR;
    length: Integer; font: GPFONT; layoutRect: PGPRectF;
    stringFormat: GPSTRINGFORMAT; boundingBox: PGPRectF;
    codepointsFitted: PInteger; linesFilled: PInteger): GPSTATUS; stdcall;

  }

  DestGP.DrawString( caption,Length(caption), curFont, rct, strFormat, brush);
  //GdipDrawString(DestGP, PWideChar(caption), -1, curFont, @rct, strFormat, brush);

  brush.free;
  curFont.Free;
  fontFam.Free;
  strFormat.Free;
  DestGP.Free;
  DestBitmap.Canvas.Unlock;
  //Devolve quanto tinha de altura

  result:= 20; //para já assim
end;

procedure GetJPGSize(const sFile: string; var wWidth, wHeight: word);
const
  ValidSig : array[0..1] of byte = ($FF, $D8);
  Parameterless = [$01, $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7];
var
  Sig: array[0..1] of byte;
  f: TFileStream;
  x: integer;
  Seg: byte;
  Dummy: array[0..15] of byte;
  Len: word;
  ReadLen: LongInt;
begin
  FillChar(Sig, SizeOf(Sig), #0);
  f := TFileStream.Create(sFile, fmOpenRead);
  try
    ReadLen := f.Read(Sig[0], SizeOf(Sig));
    for x := Low(Sig) to High(Sig) do
      if Sig[x] <> ValidSig[x] then
        ReadLen := 0;
      if ReadLen > 0 then
      begin
        ReadLen := f.Read(Seg, 1);
        while (Seg = $FF) and (ReadLen > 0) do
        begin
          ReadLen := f.Read(Seg, 1);
          if Seg <> $FF then
          begin
            if (Seg = $C0) or (Seg = $C1) then
            begin
              ReadLen := f.Read(Dummy[0], 3);  { don't need these bytes }
              wHeight := ReadMWord(f);
              wWidth := ReadMWord(f);
            end
            else
            begin
              if not (Seg in Parameterless) then
              begin
                Len := ReadMWord(f);
                f.Seek(Len - 2, 1);
                f.Read(Seg, 1);
              end
              else
                Seg := $FF;  { Fake it to keep looping. }
            end;
          end;
        end;
      end;
    finally
    f.Free;
  end;
end;

procedure GetPNGSize(const sFile: string; var wWidth, wHeight: word);
type
  TPNGSig = array[0..7] of byte;
const
  ValidSig: TPNGSig = (137, 80, 78, 71, 13, 10, 26, 10);
var
  Sig: TPNGSig;
  f: tFileStream;
  x: integer;
begin
  FillChar(Sig, SizeOf(Sig), #0);
  f := TFileStream.Create(sFile, fmOpenRead);
  try
    f.Read(Sig[0], SizeOf(Sig));
    for x := Low(Sig) to High(Sig) do
      if Sig[x] <> ValidSig[x] then
        exit;
      f.Seek(18, 0);
      wWidth := ReadMWord(f);
      f.Seek(22, 0);
      wHeight := ReadMWord(f);
  finally
    f.Free;
  end;
end;


procedure GetGIFSize(const sGIFFile: string; var wWidth, wHeight: word);
type
  TGIFHeader = record
  Sig: array[0..5] of char;
  ScreenWidth, ScreenHeight: word;
  Flags, Background, Aspect: byte;
end;
  TGIFImageBlock = record
  Left, Top, Width, Height: word;
  Flags: byte;
end;
var
  f: file;
  Header: TGifHeader;
  ImageBlock: TGifImageBlock;
  nResult: integer;
  x: integer;
  c: char;
  DimensionsFound: boolean;
begin
  wWidth  := 0;
  wHeight := 0;
  if sGifFile = '' then
    exit;

  {$I-}

  FileMode := 0;  { read-only }
  AssignFile(f, sGifFile);
  reset(f, 1);
  if IOResult <> 0 then
    {Could not open file}
  exit;
  {Read header and ensure valid file}
  BlockRead(f, Header, SizeOf(TGifHeader), nResult);
  if (nResult <> SizeOf(TGifHeader)) or (IOResult <> 0)
    or (StrLComp('GIF', Header.Sig, 3) <> 0) then
  begin
    {Image file invalid}
    close(f);
    exit;
  end;
  {Skip color map, if there is one}
  if (Header.Flags and $80) > 0 then
  begin
    x := 3 * (1 SHL ((Header.Flags and 7) + 1));
    Seek(f, x);
    if IOResult <> 0 then
    begin
      { Color map thrashed }
      close(f);
      exit;
    end;
  end;
  DimensionsFound := False;
  FillChar(ImageBlock, SizeOf(TGIFImageBlock), #0);
  { Step through blocks }
  BlockRead(f, c, 1, nResult);
  while (not EOF(f)) and (not DimensionsFound) do
  begin
    case c of
    ',':  { Found image }
    begin
      BlockRead(f, ImageBlock, SizeOf(TGIFImageBlock), nResult);
      if nResult <> SizeOf(TGIFImageBlock) then
      begin
        { Invalid image block encountered }
        close(f);
        exit;
      end;
      wWidth := ImageBlock.Width;
      wHeight := ImageBlock.Height;
      DimensionsFound := True;
    end;

    { nothing else, just ignore }
  end;
  BlockRead(f, c, 1, nResult);
end;
close(f);

{$I+}

end;

function GetBMPSize(PictFileName: String; Var wd, ht: Word): Boolean;
{similar routine is in "BitmapRegion" routine}
label ErrExit;
const
  ValidSig: array[0..1] of byte = ($FF, $D8);
  Parameterless = [$01, $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7];
  BmpSig = $4d42;
var
  {Err : Boolean;}
  fh: HFile;
  {tof : TOFSTRUCT;}
  bf: TBITMAPFILEHEADER;
  bh: TBITMAPINFOHEADER;
  {JpgImg  : TJPEGImage;}
  Itype: Smallint;
  Sig: array[0..1] of byte;
  x: integer;
  Seg: byte;
  Dummy: array[0..15] of byte;
  skipLen: word;
  OkBmp, Readgood: Boolean;
begin
  {Open the file and get a handle to it's BITMAPINFO}
  OkBmp := False;
  Itype := ImageType(PictFileName);
  fh := CreateFile(PChar(PictFileName), GENERIC_READ, FILE_SHARE_READ, Nil,
           OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if (fh = INVALID_HANDLE_VALUE) then
    goto ErrExit;
  if Itype = 1 then
  begin
    {read the BITMAPFILEHEADER}
    if not GoodFileRead(fh, @bf, sizeof(bf)) then
      goto ErrExit;
    if (bf.bfType <> BmpSig) then  {'BM'}
      goto ErrExit;
    if not GoodFileRead(fh, @bh, sizeof(bh)) then
      goto ErrExit;
    {for now, don't even deal with CORE headers}
    if (bh.biSize = sizeof(TBITMAPCOREHEADER)) then
      goto ErrExit;
    wd := bh.biWidth;
    ht := bh.biheight;
    OkBmp := True;
  end
  else
  if (Itype = 2) then
  begin
    FillChar(Sig, SizeOf(Sig), #0);
    if not GoodFileRead(fh, @Sig[0], sizeof(Sig)) then
      goto ErrExit;
    for x := Low(Sig) to High(Sig) do
      if Sig[x] <> ValidSig[x] then
        goto ErrExit;
      Readgood := GoodFileRead(fh, @Seg, sizeof(Seg));
      while (Seg = $FF) and Readgood do
      begin
        Readgood := GoodFileRead(fh, @Seg, sizeof(Seg));
        if Seg <> $FF then
        begin
          if (Seg = $C0) or (Seg = $C1) or (Seg = $C2) then
          begin
            Readgood := GoodFileRead(fh, @Dummy[0],3);  {don't need these bytes}
            if ReadMWord2(fh, ht) and ReadMWord2(fh, wd) then
              OkBmp := True;
          end
          else
          begin
            if not (Seg in Parameterless) then
            begin
              ReadMWord2(fh,skipLen);
              SetFilePointer(fh, skipLen - 2, nil, FILE_CURRENT);
              GoodFileRead(fh, @Seg, sizeof(Seg));
            end
            else
              Seg := $FF;  {Fake it to keep looping}
          end;
        end;
      end;
  end;
  ErrExit: CloseHandle(fh);
  Result := OkBmp;
end;

end.
