{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit MainGif;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls, mckObjs {$ENDIF}, KolGif;
{$ELSE}
{$I uses.inc} mirror,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror;
{$ENDIF}

var
  ImagesPath: String = 'd:\Images\animated\';

//{$DEFINE STRETCHED}
//{$DEFINE NOMASKEDGIF}
//{$DEFINE GIFDECODERONLY}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  PForm1 = ^TForm1;
  TForm1 = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    PaintBox1: TKOLPaintBox;
    Panel1: TKOLPanel;
    BitBtn1: TKOLBitBtn;
    CheckBox1: TKOLCheckBox;
    Timer1: TKOLTimer;
    ListBox1: TKOLListBox;
    Splitter1: TKOLSplitter;
    OpenDirDialog1: TKOLOpenDirDialog;
    Label1: TKOLLabel;
    Label2: TKOLLabel;
    Button1: TKOLButton;
    procedure Button1Click(Sender: PObj);
    procedure PaintBox1Paint(Sender: PControl; DC: HDC);
    procedure KOLForm1Destroy(Sender: PObj);
    procedure Button2Click(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure Timer1Timer(Sender: PObj);
    procedure CheckBox1Click(Sender: PObj);
    procedure ListBox1SelChange(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
    {$IFDEF GIFDECODERONLY}
      FGif: PGifDecoder;
    {$ELSE}
      FGif: PGif;
    {$ENDIF}
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I MainGif_1.inc}
{$ENDIF}

procedure TForm1.Button1Click(Sender: PObj);
begin
  Timer1.Enabled := FALSE;
  if OpenDirDialog1.Execute then
  begin
    listbox1.Clear;
    ImagesPath := IncludeTrailingPathDelimiter( OpenDirDialog1.Path );
    listbox1.AddDirList( ImagesPath + '*.gif', 0 );
  end;
end;

procedure TForm1.PaintBox1Paint(Sender: PControl; DC: HDC);
{$IFNDEF STRETCHED}
var TmpBmp: PBitmap;
{$ENDIF}
begin
  if FGif <> nil then
  begin
    {$IFDEF STRETCHED}
      {$IFDEF GIFDECODERONLY}
        {$IFDEF NOMASKEDGIF}
          FGif.Bitmap.StretchDraw( PaintBox1.Canvas.Handle, PaintBox1.ClientRect );
        {$ELSE}
          //if not FGif.Transparent then
            FGif.Bitmap.StretchDraw( PaintBox1.Canvas.Handle, PaintBox1.ClientRect )
          {else
            FGif.Bitmap.StretchDrawTransparent( PaintBox1.Canvas.Handle,
                        PaintBox1.ClientRect, FGif.BkColor );}
        {$ENDIF}
      {$ELSE}
        //FGif.StretchDrawTransp( PaintBox1.Canvas.Handle, PaintBox1.ClientRect );
        FGif.StretchDraw( PaintBox1.Canvas.Handle, PaintBox1.ClientRect );
      {$ENDIF}
    {$ELSE}
      {TmpBmp := NewBitmap( PaintBox1.Width, PaintBox1.Height );
      TmpBmp.PixelFormat := pf15bit;}
      TmpBmp := NewDIBBitmap( PaintBox1.Width, PaintBox1.Height, pf16bit );
      TmpBmp.BkColor := Color2RGB( clBtnFace );
      //^^^TmpBmp.Canvas.Brush.Color := clBtnFace;
      TmpBmp.Canvas.FillRect( PaintBox1.ClientRect );
      {$IFDEF GIFDECODERONLY}
        {$IFDEF NOMASKEDGIF}
          FGif.Bitmap.Draw( TmpBmp.Canvas.Handle, 0, 0 );
        {$ELSE}
          if not FGif.Transparent then
            FGif.Bitmap.Draw( TmpBmp.Canvas.Handle, 0, 0 )
          else
          if FGif.Mask <> nil then
            DrawBitmapMask( TmpBmp.Canvas.Handle, 0, 0, FGif.Bitmap, FGif.Mask )
          else
            FGif.Bitmap.DrawTransparent( TmpBmp.Canvas.Handle, 0, 0, FGif.BkColor );
        {$ENDIF}
      {$ELSE}
        FGif.DrawTransp( TmpBmp.Canvas.Handle, 0, 0 );
      {$ENDIF}
      TmpBmp.Draw( PaintBox1.Canvas.Handle, 0, 0 );
      //TmpBmp.SaveToFile( GetStartDir + 'tmp.bmp' );
      TmpBmp.Free;
    {$ENDIF}
  end else
  begin
    PaintBox1.Canvas.FillRect( PaintBox1.ClientRect );
  end;
end;

procedure TForm1.KOLForm1Destroy(Sender: PObj);
begin
  FGif.Free;
end;

procedure TForm1.Button2Click(Sender: PObj);
begin
  if FGif = nil then Exit;
  {$IFNDEF GIFDECODERONLY}
  FGif.Frame := FGif.Frame + 1;
  PaintBox1.Invalidate;
  {$ELSE}
  FGif.Frame := FGif.Frame + 1;
  PaintBox1.Invalidate;
  {$ENDIF}
  Label2.Caption := Int2Str( FGif.Frame + 1 ) + '/' + Int2Str( FGif.Count );
end;

procedure AssertErrorHandler(const Message, Filename: string;
  LineNumber: Integer; ErrorAddr: Pointer);
begin
  MsgOK( 'Assertion filed in line # ' + Int2Str( LineNumber ) +
                ' of module ' + FileName + ' :'#13#10 +
                Message );
  Halt;
end;

function InitMyAssert: Boolean;
begin
  AssertErrorProc := @AssertErrorHandler;
  Result := TRUE;
end;

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
//var ST: TSystemTime;
begin
  {GetSystemTime( ST );
  ST.wHour := 10;
  SetSystemTime( ST );
  SendMessage( HWND_TOPMOST, WM_TIMECHANGE, 0, 0 );}
  
  //BitBtn1.RepeatInterval := 300;
  Assert( InitMyAssert, '' );
  //Form.CreateWindow;
  listbox1.AddDirList( ImagesPath + '*.gif', 0 );
end;

procedure TForm1.Timer1Timer(Sender: PObj);
begin
  if FGif <> nil then
  begin
    {$IFNDEF GIFDECODERONLY}
    Timer1.Enabled := FALSE;
    if CheckBox1.Checked then
    begin
      FGif.Frame := FGif.Frame + 1;
      FGif.FreeResources;
      PaintBox1.Invalidate;
      Timer1.Interval := Max( 10, FGif.Delay[ FGif.Frame ] );
      Timer1.Enabled := TRUE;
    end;
    {$ELSE}
    Timer1.Enabled := FALSE;
    if CheckBox1.Checked then
    begin
      FGif.Frame := FGif.Frame + 1;
      FGif.FreeResources;
      PaintBox1.Invalidate;
      Timer1.Interval := Max( 10, FGif.Frames[ FGif.Frame ].Delay );
      Timer1.Enabled := TRUE;
    end;
    {$ENDIF}
    if FGif.Corrupted then
      Label1.Caption := 'Corrupted';
  end;
  Label2.Caption := Int2Str( FGif.Frame + 1 ) + '/' + Int2Str( FGif.Count );
end;

procedure TForm1.CheckBox1Click(Sender: PObj);
begin
  Timer1Timer( Timer1 );
end;

procedure TForm1.ListBox1SelChange(Sender: PObj);
var S: String;
begin
  S := ListBox1.Items[ ListBox1.CurIndex ];
    if FGif = nil then
    {$IFDEF GIFDECODERONLY}
      FGif := NewGifDecoder;
      {$IFNDEF NOMASKEDGIF}
        FGif.NeedMask := TRUE;
      {$ENDIF}
    {$ELSE}
      {$IFDEF NOMASKEDGIF}
        FGif := NewGifNoMask;
      {$ELSE}
        FGif := NewGif;
      {$ENDIF}
    {$ENDIF}
    Label1.Caption := '';
    Form.Caption := S;
    FGif.LoadFromFile( ImagesPath + S );
    if FGif.Corrupted then
      Label1.Caption := 'Corrupted';
    PaintBox1.Invalidate;
    {$IFNDEF GIFDECODERONLY}
    if CheckBox1.Checked then
    if FGif.Count > 1 then
    begin
      Timer1.Interval := Max( 10, FGif.Delay[ FGif.Frame ] );
      Timer1.Enabled := TRUE;
    end;
    {$ELSE}
    if CheckBox1.Checked then
    if FGif.Count > 1 then
    begin
      Timer1.Interval := Max( 10, FGif.Frames[ FGif.Frame ].Delay );
      Timer1.Enabled := TRUE;
    end;
    {$ENDIF}
    Label2.Caption := '';
    if FGif.Count > 0 then
    Label2.Caption := Int2Str( FGif.Frame + 1 ) + '/' + Int2Str( FGif.Count );
end;

end.


