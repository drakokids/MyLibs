unit EnhImage2;

//Nota ao programador:
//Quando fiz este código só eu e deus sabíamos como funcionava.
//Agora... só Deus sabe

interface

uses Messages, Windows, SysUtils, Classes, Controls, Forms, Menus, Graphics,
  StdCtrls,Math,MyGDIPAPI, MyGDIPOBJ,ExtCtrls, EnhGraphicLib; //bsSkinCtrls

type
  TEnhImage2Effect=(ImgNone,ImgInvert,ImgAntialias,ImgContrast, ImgGrayscale,
                   ImgLightness, ImgDarkness, ImgSaturation, ImgEmboss,
                   ImgSolorize, ImgPosterize, ImgSplitBlur, ImgGaussianBlur,
                   ImgMosaic, ImgTrace);

type
  TEnhImage2 = class(TShape)
  private
    FRegion: HRGN;
    FPicture: TPicture;
    FImageEffect: TEnhImage2Effect;
    FOnProgress: TProgressEvent;
    FStretch: Boolean;
    FCenter: Boolean;
    FIncrementalDisplay: Boolean;
    FTransparent: Boolean;
    FDrawing: Boolean;
    FZoomEven: Boolean;  // Jim
    FZoomY: Integer;  // Jim
    FZoomX: Integer;  // Jim
    FEffectAmount: integer;
    Fangle: integer;
    FBackColor: TColor;
    FReflection: boolean;
    OffScreen: TBitmap;
    Background: TBitmap;
    FMouseInControl, FDragging: Boolean;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    procedure SetZoomEven(const Value: Boolean);  // Jim
    procedure SetZoomX(const Value: Integer);  // Jim
    procedure SetZoomY(const Value: Integer);  // Jim
    function GetCanvas: TCanvas;
    procedure PictureChanged(Sender: TObject);
    procedure SetCenter(Value: Boolean);
    procedure SetPicture(Value: TPicture);
    procedure SetBackColor(Value: TColor);
    procedure SetStretch(Value: Boolean);
    procedure SetTransparent(Value: Boolean);
    procedure Draw(mycanvas: TCanvas; myrect: TRect; Graph: TGraphic);
    procedure SetImageEffect(value:TEnhImage2Effect);
    procedure SetEffectAmount(value:integer);
    procedure SetAngle(value: integer);
    procedure SetReflection(value: boolean);
    procedure MouseEnter;
    procedure MouseLeave;
  protected
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    function DestRect: TRect;
    function DoPaletteChange: Boolean;
    function GetPalette: HPALETTE; override;
    procedure Paint; override;
    procedure Progress(Sender: TObject; Stage: TProgressStage;
      PercentDone: Byte; RedrawNow: Boolean; const R: TRect; const Msg: string); dynamic;
    procedure Resize; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    //novo - 2015-10-27
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Canvas: TCanvas read GetCanvas;
  published
    property Align;
    property Anchors;
    property AutoSize;
    property Center: Boolean read FCenter write SetCenter default False;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property IncrementalDisplay: Boolean read FIncrementalDisplay write FIncrementalDisplay default False;
    property ParentShowHint;
    property Picture: TPicture read FPicture write SetPicture;
    property PopupMenu;
    property ShowHint;
    property Stretch: Boolean read FStretch write SetStretch default False;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
    property Visible;
    Property ZoomX: Integer read FZoomX write SetZoomX default 100;  // Jim
    Property ZoomY: Integer read FZoomY write SetZoomY default 100;  // Jim
    Property ZoomEven: Boolean read FZoomEven write SetZoomEven default true;  // Jim
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    property OnStartDock;
    property OnStartDrag;
    property Effect: TEnhImage2Effect read FImageEffect write SetImageEffect default ImgNone;
    property EffectAmount: integer read FEffectAmount write SetEffectAmount default 0;
    property RotateAngle: integer read FAngle write SetAngle default 0;
    property Reflection: boolean read FReflection write SetReflection default False;
    property BackColor: TColor read FBackColor write SetBackColor;
  end;

procedure Register;  // Jim

implementation

uses Consts;

procedure Register;
begin
  RegisterComponents('MyComponents', [TEnhImage2]);
end;

{ TEnhImage2 }


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


function IntToByte(i:Integer):Byte;
begin
  if      i>255 then Result:=255
  else if i<0   then Result:=0
  else               Result:=i;
end;

function TrimInt(i, Min, Max: Integer): Integer;
begin
  if      i>Max then Result:=Max
  else if i<Min then Result:=Min
  else               Result:=i;
end;

procedure PicInvert(src: tbitmap);
var w,h,x,y:integer;
    p:pbytearray;
begin
w:=src.width;
h:=src.height;
src.PixelFormat :=pf24bit;
 for y:=0 to h-1 do begin
  p:=src.scanline[y];
  for x:=0 to w-1 do begin
   p[x*3]:= not p[x*3];
   p[x*3+1]:= not p[x*3+1];
   p[x*3+2]:= not p[x*3+2];
   end;
  end;
end;

procedure AntiAliasRect(clip: tbitmap; XOrigin, YOrigin,
  XFinal, YFinal: Integer);
var Memo,x,y: Integer; (* Composantes primaires des points environnants *)
    p0,p1,p2:pbytearray;

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
      p1[x*3]:=(p0[x*3]+p2[x*3]+p1[(x-1)*3]+p1[(x+1)*3])div 4;
      p1[x*3+1]:=(p0[x*3+1]+p2[x*3+1]+p1[(x-1)*3+1]+p1[(x+1)*3+1])div 4;
      p1[x*3+2]:=(p0[x*3+2]+p2[x*3+2]+p1[(x-1)*3+2]+p1[(x+1)*3+2])div 4;
      end;
   end;
end;

procedure AntiAlias(clip: tbitmap);
begin
 AntiAliasRect(clip,0,0,clip.width,clip.height);
end;

procedure Contrast(var clip: tbitmap; Amount: Integer);
var
p0:pbytearray;
rg,gg,bg,r,g,b,x,y:  Integer;
begin
  for y:=0 to clip.Height-1 do
  begin
    p0:=clip.scanline[y];
    for x:=0 to clip.Width-1 do
    begin
      r:=p0[x*3];
      g:=p0[x*3+1];
      b:=p0[x*3+2];
      rg:=(Abs(127-r)*Amount)div 255;
      gg:=(Abs(127-g)*Amount)div 255;
      bg:=(Abs(127-b)*Amount)div 255;
      if r>127 then r:=r+rg else r:=r-rg;
      if g>127 then g:=g+gg else g:=g-gg;
      if b>127 then b:=b+bg else b:=b-bg;
      p0[x*3]:=IntToByte(r);
      p0[x*3+1]:=IntToByte(g);
      p0[x*3+2]:=IntToByte(b);
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


procedure Lightness(var clip: tbitmap; Amount: Integer);
var
p0:pbytearray;
r,g,b,x,y: Integer;
begin
  for y:=0 to clip.Height-1 do begin
    p0:=clip.scanline[y];
    for x:=0 to clip.Width-1 do
    begin
      r:=p0[x*3];
      g:=p0[x*3+1];
      b:=p0[x*3+2];
      p0[x*3]:=IntToByte(r+((255-r)*Amount)div 255);
      p0[x*3+1]:=IntToByte(g+((255-g)*Amount)div 255);
      p0[x*3+2]:=IntToByte(b+((255-b)*Amount)div 255);
    end;
  end;
end;

procedure Darkness(var src: tbitmap; Amount: integer);
var
p0:pbytearray;
r,g,b,x,y: Integer;
begin
  src.pixelformat:=pf24bit;
  for y:=0 to src.Height-1 do begin
    p0:=src.scanline[y];
    for x:=0 to src.Width-1 do
    begin
      r:=p0[x*3];
      g:=p0[x*3+1];
      b:=p0[x*3+2];
      p0[x*3]:=IntToByte(r-((r)*Amount)div 255);
      p0[x*3+1]:=IntToByte(g-((g)*Amount)div 255);
      p0[x*3+2]:=IntToByte(b-((b)*Amount)div 255);
   end;
  end;
end;


procedure Saturation(var clip: tbitmap; Amount: Integer);
var
p0:pbytearray;
Gray,r,g,b,x,y: Integer;
begin
  for y:=0 to clip.Height-1 do begin
    p0:=clip.scanline[y];
    for x:=0 to clip.Width-1 do
    begin
      r:=p0[x*3];
      g:=p0[x*3+1];
      b:=p0[x*3+2];
      Gray:=(r+g+b)div 3;
      p0[x*3]:=IntToByte(Gray+(((r-Gray)*Amount)div 255));
      p0[x*3+1]:=IntToByte(Gray+(((g-Gray)*Amount)div 255));
      p0[x*3+2]:=IntToByte(Gray+(((b-Gray)*Amount)div 255));
    end;
  end;
end;

procedure SmoothRotate(var Src, Dst: TBitmap; cx, cy: Integer;
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

procedure SplitBlur(var clip: tbitmap; Amount: integer);
var
p0,p1,p2:pbytearray;
cx,x,y: Integer;
Buf:   array[0..3,0..2]of byte;
begin
  if Amount=0 then Exit;
  for y:=0 to clip.Height-1 do
  begin
    p0:=clip.scanline[y];
    if y-Amount<0         then p1:=clip.scanline[y]
    else {y-Amount>0}          p1:=clip.ScanLine[y-Amount];
    if y+Amount<clip.Height    then p2:=clip.ScanLine[y+Amount]
    else {y+Amount>=Height}    p2:=clip.ScanLine[clip.Height-y];

    for x:=0 to clip.Width-1 do
    begin
      if x-Amount<0     then cx:=x
      else {x-Amount>0}      cx:=x-Amount;
      Buf[0,0]:=p1[cx*3];
      Buf[0,1]:=p1[cx*3+1];
      Buf[0,2]:=p1[cx*3+2];
      Buf[1,0]:=p2[cx*3];
      Buf[1,1]:=p2[cx*3+1];
      Buf[1,2]:=p2[cx*3+2];
      if x+Amount<clip.Width     then cx:=x+Amount
      else {x+Amount>=Width}     cx:=clip.Width-x;
      Buf[2,0]:=p1[cx*3];
      Buf[2,1]:=p1[cx*3+1];
      Buf[2,2]:=p1[cx*3+2];
      Buf[3,0]:=p2[cx*3];
      Buf[3,1]:=p2[cx*3+1];
      Buf[3,2]:=p2[cx*3+2];
      p0[x*3]:=(Buf[0,0]+Buf[1,0]+Buf[2,0]+Buf[3,0])shr 2;
      p0[x*3+1]:=(Buf[0,1]+Buf[1,1]+Buf[2,1]+Buf[3,1])shr 2;
      p0[x*3+2]:=(Buf[0,2]+Buf[1,2]+Buf[2,2]+Buf[3,2])shr 2;
    end;
  end;
end;

procedure GaussianBlur(var clip: tbitmap; Amount: integer);
var
i: Integer;
begin
  for i:=Amount downto 0 do
  SplitBlur(clip,3);
end;

procedure Mosaic(var Bm:TBitmap;size:Integer);
var
   x,y,i,j:integer;
   p1,p2:pbytearray;
   r,g,b:byte;
begin
  y:=0;
  repeat
    p1:=bm.scanline[y];
    x:=0;
    repeat
      j:=1;
      repeat
      p2:=bm.scanline[y];
      x:=0;
      repeat
        r:=p1[x*3];
        g:=p1[x*3+1];
        b:=p1[x*3+2];
        i:=1;
       repeat
       p2[x*3]:=r;
       p2[x*3+1]:=g;
       p2[x*3+2]:=b;
       inc(x);
       inc(i);
       until (x>=bm.width) or (i>size);
      until x>=bm.width;
      inc(j);
      inc(y);
      until (y>=bm.height) or (j>size);
    until (y>=bm.height) or (x>=bm.width);
  until y>=bm.height;
end;

procedure Trace (src:Tbitmap;intensity:integer);
var
  x,y,i : integer;
  P1,P2,P3,P4 : PByteArray;
  tb,TraceB:byte;
  hasb:boolean;
  bitmap:tbitmap;
begin
  bitmap:=tbitmap.create;
  bitmap.width:=src.width;
  bitmap.height:=src.height;
  bitmap.canvas.draw(0,0,src);
  bitmap.PixelFormat :=pf8bit;
  src.PixelFormat :=pf24bit;
  hasb:=false;
  TraceB:=$00;
  for i:=1 to Intensity do begin
    for y := 0 to BitMap.height -2 do begin
      P1 := BitMap.ScanLine[y];
      P2 := BitMap.scanline[y+1];
      P3 := src.scanline[y];
      P4 := src.scanline[y+1];
      x:=0;
      repeat
        if p1[x]<>p1[x+1] then begin
           if not hasb then begin
             tb:=p1[x+1];
             hasb:=true;
             p3[x*3]:=TraceB;
             p3[x*3+1]:=TraceB;
             p3[x*3+2]:=TraceB;
             end
             else begin
             if p1[x]<>tb then
                 begin
                 p3[x*3]:=TraceB;
                 p3[x*3+1]:=TraceB;
                 p3[x*3+2]:=TraceB;
                 end
               else
                 begin
                 p3[(x+1)*3]:=TraceB;
                 p3[(x+1)*3+1]:=TraceB;
                 p3[(x+1)*3+1]:=TraceB;
                 end;
             end;
           end;
        if p1[x]<>p2[x] then begin
           if not hasb then begin
             tb:=p2[x];
             hasb:=true;
             p3[x*3]:=TraceB;
             p3[x*3+1]:=TraceB;
             p3[x*3+2]:=TraceB;
             end
             else begin
             if p1[x]<>tb then
                 begin
                 p3[x*3]:=TraceB;
                 p3[x*3+1]:=TraceB;
                 p3[x*3+2]:=TraceB;
                 end
               else
                 begin
                 p4[x*3]:=TraceB;
                 p4[x*3+1]:=TraceB;
                 p4[x*3+2]:=TraceB;
                 end;
             end;
           end;
      inc(x);
      until x>=(BitMap.width -2);
    end;
    if i>1 then
    for y := BitMap.height -1 downto 1 do begin
      P1 := BitMap.ScanLine[y];
      P2 := BitMap.scanline[y-1];
      P3 := src.scanline[y];
      P4 := src.scanline [y-1];
      x:=Bitmap.width-1;
      repeat
        if p1[x]<>p1[x-1] then begin
           if not hasb then begin
             tb:=p1[x-1];
             hasb:=true;
             p3[x*3]:=TraceB;
             p3[x*3+1]:=TraceB;
             p3[x*3+2]:=TraceB;
             end
             else begin
             if p1[x]<>tb then
                 begin
                 p3[x*3]:=TraceB;
                 p3[x*3+1]:=TraceB;
                 p3[x*3+2]:=TraceB;
                 end
               else
                 begin
                 p3[(x-1)*3]:=TraceB;
                 p3[(x-1)*3+1]:=TraceB;
                 p3[(x-1)*3+2]:=TraceB;
                 end;
             end;
           end;
        if p1[x]<>p2[x] then begin
           if not hasb then begin
             tb:=p2[x];
             hasb:=true;
             p3[x*3]:=TraceB;
             p3[x*3+1]:=TraceB;
             p3[x*3+2]:=TraceB;
             end
             else begin
             if p1[x]<>tb then
                 begin
                 p3[x*3]:=TraceB;
                 p3[x*3+1]:=TraceB;
                 p3[x*3+2]:=TraceB;
                 end
               else
                 begin
                 p4[x*3]:=TraceB;
                 p4[x*3+1]:=TraceB;
                 p4[x*3+2]:=TraceB;
                 end;
             end;
           end;
      dec(x);
      until x<=1;
    end;
  end;
bitmap.free;
end;

procedure Emboss(var Bmp:TBitmap);
var
x,y:   Integer;
p1,p2: Pbytearray;
begin
  for y:=0 to Bmp.Height-2 do
  begin
    p1:=bmp.scanline[y];
    p2:=bmp.scanline[y+1];
    for x:=0 to Bmp.Width-4 do
    begin
      p1[x*3]:=(p1[x*3]+(p2[(x+3)*3] xor $FF))shr 1;
      p1[x*3+1]:=(p1[x*3+1]+(p2[(x+3)*3+1] xor $FF))shr 1;
      p1[x*3+2]:=(p1[x*3+2]+(p2[(x+3)*3+2] xor $FF))shr 1;
    end;
  end;

end;

procedure Solorize(src, dst: tbitmap; amount: integer);
var w,h,x,y:integer;
    ps,pd:pbytearray;
    c:integer;
begin
  w:=src.width;
  h:=src.height;
  src.PixelFormat :=pf24bit;
  dst.PixelFormat :=pf24bit;
  for y:=0 to h-1 do begin
   ps:=src.scanline[y];
   pd:=dst.scanline[y];
   for x:=0 to w-1 do begin
    c:=(ps[x*3]+ps[x*3+1]+ps[x*3+2]) div 3;
    if c>amount then begin
     pd[x*3]:= 255-ps[x*3];
     pd[x*3+1]:=255-ps[x*3+1];
     pd[x*3+2]:=255-ps[x*3+2];
     end
     else begin
     pd[x*3]:=ps[x*3];
     pd[x*3+1]:=ps[x*3+1];
     pd[x*3+2]:=ps[x*3+2];
     end;
    end;
   end;
end;

procedure Posterize(src, dst: tbitmap; amount: integer);
var w,h,x,y:integer;
    ps,pd:pbytearray;
    c:integer;
begin
  w:=src.width;
  h:=src.height;
  src.PixelFormat :=pf24bit;
  dst.PixelFormat :=pf24bit;
  for y:=0 to h-1 do begin
   ps:=src.scanline[y];
   pd:=dst.scanline[y];
   for x:=0 to w-1 do begin
     pd[x*3]:= round(ps[x*3]/amount)*amount;
     pd[x*3+1]:=round(ps[x*3+1]/amount)*amount;
     pd[x*3+2]:=round(ps[x*3+2]/amount)*amount;
    end;
   end;
end;


constructor TEnhImage2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChanged;
  FPicture.OnProgress := Progress;
  FBackColor:=clWhite;
  Background:=TBitmap.Create;
  Height := 105;
  Width := 105;
  Background.Width:=width;
  Background.Height:=height;
  ZoomX:=100;  // Jim
  ZoomY:=100;  // Jim
  ZoomEven:=true;  // Jim
end;

destructor TEnhImage2.Destroy;
begin
  FPicture.Free;
  Background.Free;
  inherited Destroy;
end;

function TEnhImage2.GetPalette: HPALETTE;
begin
  Result := 0;
  if FPicture.Graphic <> nil then
    Result := FPicture.Graphic.Palette;
end;

function TEnhImage2.DestRect: TRect;
var
  DeltaX,DeltaY: Integer;  // Jim
begin
  if FStretch then
    Result := ClientRect
  else if FCenter then
    Result := Bounds((Width - Picture.Width) div 2, (Height - Picture.Height) div 2,
      Picture.Width, Picture.Height)
  else
    Result := Rect(0, 0, Picture.Width, Picture.Height);

  // <Jim>
  DeltaX:=Trunc(FZoomX/100*Picture.Width)-Picture.Width;
  DeltaY:=Trunc(FZoomY/100*Picture.Height)-Picture.Height;

  If FCenter Then
    Begin
      Result.Left:=Result.left-DeltaX div 2;
      Result.Right:=Result.right+DeltaX div 2;
      Result.Top:=Result.Top-DeltaY div 2;
      Result.Bottom:=Result.bottom+DeltaY div 2;
    End
  else
    Begin
      Result.Right:=Result.right+deltaX;
      Result.Bottom:=Result.bottom+DeltaY;
    End;
  // </Jim>
end;

procedure TEnhImage2.Paint;
var
  Save: Boolean;
begin

  //inherited paint; depende do tipo de objecto

  if csDesigning in ComponentState then
    with inherited Canvas do
    begin
      Pen.Style := psDash;
      Brush.Style := bsClear;
      Rectangle(0, 0, Width, Height);
    end;
  Save := FDrawing;
  FDrawing := True;
  try

      Draw(inherited Canvas,DestRect,Picture.Graphic)

  finally
    FDrawing := Save;
  end;
end;

procedure TEnhImage2.Draw(mycanvas: TCanvas; myrect: TRect; Graph: TGraphic);
Var OriginalStretched, Final, temp:TBitmap;
    originrect,finalrect: TRect;
    xc,yc, w, h, dx, dy: integer;
    canv: TGPGraphics;
    source: TGPBitmap;
    Dc: hDC;
    LPoint: Tpoint;
begin

 // o background vai ficar com o fundo se tivermos transparencia
 if FTransparent then
  begin
   //background.Width:=Graph.width;
   //background.Height:=Graph.Height*2;
   background.Width:=width;
   background.Height:=Height;
   LPoint := ClientToScreen(point(Left,Top));
   //if parent is TbsSkinPanel then
   if false then
    begin
     DC := GetDC(0);
     BitBlt(background.canvas.Handle, 0, 0,background.width, background.Height, DC,
     LPoint.x-left,lpoint.y-top, SrcCopy);
     ReleaseDC(0, DC);
    end
   else
    begin
     DC := GetDC(0);
     BitBlt(background.canvas.Handle, 0, 0,background.width, background.Height, DC,
     LPoint.x-left,lpoint.y-top, SrcCopy);
     ReleaseDC(0, DC);
    end;
  end
 else
  begin
   background.Width:=width;
   background.Height:=Height;
   finalrect:=rect(0,0,width,height);
   background.Canvas.Brush.Color:=FBackColor;
   background.Canvas.Brush.Style:=bsSolid;
   background.Canvas.FillRect(finalrect);
  end;


 OriginalStretched := TBitmap.Create;
 OriginalStretched.PixelFormat := pf24bit;
 OriginalStretched.Width:=myrect.Right-myrect.Left;
 OriginalStretched.Height:=myrect.Bottom-myrect.Top;
 originrect:=Rect(0,0,myrect.Right-myrect.Left,myrect.Bottom-myrect.Top);
 if FTransparent then
  BitBlt(OriginalStretched.canvas.Handle, 0, 0,OriginalStretched.width, OriginalStretched.Height,
   background.canvas.Handle, myrect.Left,myrect.Top, SrcCopy);
 OriginalStretched.Canvas.StretchDraw(originrect,graph);

 finalrect:=myrect; //Por agora como não existe rotação
 Final := TBitmap.Create;
 Final.PixelFormat := pf24bit;
 Final.Width:=finalrect.Right-finalrect.Left;
 Final.Height:=finalrect.Bottom-finalrect.Top;
 xc:=Final.Width div 2;
 yc:=Final.height div 2;
 w:=Final.Width;
 h:=Final.height;

 if FAngle<>0 then begin
                    //Pode precisar de aumentar o tamanho de final bitmap
                    Final.Width:=trunc(abs(w*cos(DegToRad(FAngle)))+abs(h*sin(DegToRad(FAngle))));
                    Final.Height:=trunc(w*sin(DegToRad(FAngle))+h*cos(DegToRad(FAngle)));
                    SmoothRotate(OriginalStretched, Final,
                                Final.Width div 2, Final.height div 2,
                                FAngle, FBackCOlor);
                   end
 else
  Final.Canvas.Draw(0,0,OriginalStretched);

 //Guarda o deslocamento final
 dx:=(final.width-w) div 2;
 dy:=(final.height-h) div 2;

 if FImageEffect=ImgInvert then PicInvert(Final);
 if FImageEffect=ImgAntialias then Antialias(Final);
 if FImageEffect=ImgContrast then Contrast(Final, FEffectAmount);
 if FImageEffect=ImgGrayscale then Gray(Final);
 if FImageEffect=ImgLightness    then Lightness(Final, FEffectAmount);
 if FImageEffect=ImgDarkness    then Darkness(Final, FEffectAmount);
 if FImageEffect=ImgSaturation    then Saturation(Final, FEffectAmount);
 if FImageEffect=ImgEmboss        then Emboss(Final);
 if FImageEffect=ImgSolorize      then Solorize(Final,Final, FEffectAmount);
 if FImageEffect=ImgPosterize     then Posterize(Final,Final, FEffectAmount);
 if FImageEffect=ImgSplitBlur     then SplitBlur(Final, FEffectAmount);
 if FImageEffect=ImgGaussianBlur  then GaussianBlur(Final, FEffectAmount);
 if FImageEffect=ImgMosaic        then Mosaic(Final, FEffectAmount);
 if FImageEffect=ImgTrace         then Trace(Final, FEffectAmount);

 //vai utilizar GDI+ para alguns efeitos especiais
 if FReflection then
  begin
   {temp:=TBitmap.Create;
   temp.Width:=picture.Width;
   temp.Height:=picture.Height;
   temp.Canvas.Draw(0,0,Graph);
   source := TGPBitmap.Create(temp.canvas.Handle);       }
   source := TGPBitmap.Create(Final.Handle,Final.Palette); 
   canv := TGPGraphics.Create(background.canvas.Handle);
   canv.SetInterpolationMode(InterpolationModeHighQuality);   //20150108
   canv.DrawImage(source, finalrect.Left-dx,finalrect.Top-dy, myrect.Right-myrect.Left,myrect.Bottom-myrect.Top);
   DrawReflection(canv, source,-1, -1, -1, 0,
                 finalrect.Left-dx, finalrect.Top-dy+source.getHeight, 200);

   mycanvas.draw(0,0,background);   //Desenha o fundo seja ele qual for

   DrawTransparentBitmap(mycanvas.Handle,
     background.Handle, 0, 0, background.Canvas.Pixels[0,0]);

   //TransparentStretchBlt(DstDC: HDC; DstX: Integer; DstY: Integer; DstW: Integer; DstH: Integer; SrcDC: HDC; SrcX: Integer; SrcY: Integer; SrcW: Integer; SrcH: Integer; MaskDC: HDC; MaskX: Integer; MaskY: Integer): Boolean;
   canv.Destroy;
   source.Destroy;
   //temp.Destroy;
  end
 else
  begin
   mycanvas.draw(0,0,background);   //Desenha o fundo seja ele qual for
   mycanvas.draw(finalrect.Left-dx,finalrect.Top-dy,Final);
  end;
  
 OriginalStretched.Free;
 final.Free;
end;

function TEnhImage2.DoPaletteChange: Boolean;
var
  ParentForm: TCustomForm;
  Tmp: TGraphic;
begin
  Result := False;
  Tmp := Picture.Graphic;
  if Visible and (not (csLoading in ComponentState)) and (Tmp <> nil) and
    (Tmp.PaletteModified) then
  begin
    if (Tmp.Palette = 0) then
      Tmp.PaletteModified := False
    else
    begin
      ParentForm := GetParentForm(Self);
      if Assigned(ParentForm) and ParentForm.Active and Parentform.HandleAllocated then
      begin
        if FDrawing then
          ParentForm.Perform(wm_QueryNewPalette, 0, 0)
        else
          PostMessage(ParentForm.Handle, wm_QueryNewPalette, 0, 0);
        Result := True;
        Tmp.PaletteModified := False;
      end;
    end;
  end;
end;

procedure TEnhImage2.Progress(Sender: TObject; Stage: TProgressStage;
  PercentDone: Byte; RedrawNow: Boolean; const R: TRect; const Msg: string);
begin
  if FIncrementalDisplay and RedrawNow then
  begin
    if DoPaletteChange then Update
    else Paint;
  end;
  if Assigned(FOnProgress) then FOnProgress(Sender, Stage, PercentDone, RedrawNow, R, Msg);
end;

function TEnhImage2.GetCanvas: TCanvas;
var
  Bitmap: TBitmap;
begin
  if Picture.Graphic = nil then
  begin
    Bitmap := TBitmap.Create;
    try
      Bitmap.Width := Width;
      Bitmap.Height := Height;
      Picture.Graphic := Bitmap;
    finally
      Bitmap.Free;
    end;
  end;
  if Picture.Graphic is TBitmap then
    Result := TBitmap(Picture.Graphic).Canvas
  else
    raise EInvalidOperation.Create(SImageCanvasNeedsBitmap);
end;

procedure TEnhImage2.SetCenter(Value: Boolean);
begin
  if FCenter <> Value then
  begin
    FCenter := Value;
    PictureChanged(Self);
  end;
end;

procedure TEnhImage2.SetPicture(Value: TPicture);
begin
  FPicture.Assign(Value);
  invalidate;
end;

procedure TEnhImage2.SetBackColor(Value: TColor);
begin
  FBackColor:=Value;
  invalidate;
end;

procedure TEnhImage2.SetStretch(Value: Boolean);
begin
  if Value <> FStretch then
  begin
    FStretch := Value;
    PictureChanged(Self);
  end;
end;

procedure TEnhImage2.SetTransparent(Value: Boolean);
begin
  if Value <> FTransparent then
  begin
    FTransparent := Value;
    PictureChanged(Self);
  end;
end;

procedure TEnhImage2.PictureChanged(Sender: TObject);
var
  G: TGraphic;
begin
  if AutoSize and (Picture.Width > 0) and (Picture.Height > 0) then
    SetBounds(Left, Top, Trunc(FZoomX/100*Picture.Width), Trunc(FZoomY/100*Picture.Height));
  G := Picture.Graphic;
  if G <> nil then
  begin
    if not ((G is TMetaFile) or (G is TIcon)) then
      G.Transparent := FTransparent;
    if (not G.Transparent) and (Stretch or (G.Width >= Width)
      and (G.Height >= Height)) then
      ControlStyle := ControlStyle + [csOpaque]
    else
      ControlStyle := ControlStyle - [csOpaque];
    if DoPaletteChange and FDrawing then Update;
  end
  else ControlStyle := ControlStyle - [csOpaque];
  if not FDrawing then Invalidate;
end;

function TEnhImage2.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
begin
  Result := True;
  if not (csDesigning in ComponentState) or (Picture.Width > 0) and
    (Picture.Height > 0) then
  begin
    if Align in [alNone, alLeft, alRight] then
      NewWidth := Trunc(FZoomX/100*Picture.Width);
    if Align in [alNone, alTop, alBottom] then
      NewHeight := Trunc(FZoomY/100*Picture.Height);
  end;
end;

procedure TEnhImage2.SetZoomEven(const Value: Boolean);
begin  // Jim
  If value<>FZoomEven Then
    Begin
      FZoomEven := Value;
      If value Then FZoomY := FZoomX;
      PictureChanged(self);
    End;
end;

procedure TEnhImage2.SetZoomX(const Value: Integer);
begin  // Jim
  If value<>FZoomX Then
    Begin
      FZoomX := Value;
      If FZoomEven Then FZoomY := Value;
      PictureChanged(self);
    End;
end;

procedure TEnhImage2.SetZoomY(const Value: Integer);
begin  // Jim
  If value<>FZoomY Then
    Begin
      FZoomY := Value;
      If FZoomEven Then FZoomX := Value;
      PictureChanged(self);
    End;
end;

procedure TEnhImage2.SetImageEffect(value:TEnhImage2Effect);
begin
    if value<>FImageEffect then
     FImageEffect:=Value;
    invalidate;
end;

procedure TEnhImage2.SetEffectAmount(value:integer);
begin
if value<>FEffectAmount then
     FEffectAmount:=Value;
    invalidate;
end;

procedure TEnhImage2.SetAngle(value: integer);
begin
if value<>FAngle then
     FAngle:=Value;
    invalidate;
end;

procedure TEnhImage2.SetReflection(value: boolean);
begin
if value<>FReflection then
 begin
  FReflection:=value;
 end;
 invalidate;
end;

procedure TEnhImage2.Resize;
begin
  try
    inherited Resize;
    if Background<>nil then
     begin
      Background.Width := Width;
      Background.Height := Height;
     end;
  finally
  end;
end;


procedure TEnhImage2.MouseEnter;
begin
  if (FMouseInControl) and (Assigned(FOnMouseEnter)) then
    FOnMouseEnter(Self);
end;

procedure TEnhImage2.MouseLeave;
begin
  if (not FMouseInControl) and (Assigned(FOnMouseLeave)) then
    FOnMouseLeave(Self);
end;

procedure TEnhImage2.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
  if PtInRegion(FRegion, X, Y) then
  begin
    FMouseInControl := True;
    MouseEnter;
  end
  else
  begin
    FMouseInControl := False;
    MouseLeave;
  end;
end;

procedure TEnhImage2.WMEraseBkgnd(var Msg: TWMEraseBkgnd);
begin
  Paint; //20/11/2018
end;

procedure TEnhImage2.WMPaint(var Msg: TWMPaint);
begin
    inherited;
    Paint;
end;


{ end TEnhImage2 }


end.
