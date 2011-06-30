{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
{$DEFINE DEMOVER}
//{$DEFINE DEMOVER}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLSPLPicture {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls, mckSPLPicture {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;
{$ENDIF}

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
    SPLPicture1: TKOLSPLPicture;
    SPLPicture2: TKOLSPLPicture;
    Label1: TKOLLabel;
    Label2: TKOLLabel;
    SPLPicture3: TKOLSPLPicture;
    SPLPicture4: TKOLSPLPicture;
    Label3: TKOLLabel;
    SPLPicture5: TKOLSPLPicture;
    Label4: TKOLLabel;
    Label5: TKOLLabel;
    procedure SPLPicture1Click(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure Label1MouseEnter(Sender: PObj);
    procedure Label1MouseLeave(Sender: PObj);
    procedure SPLPicture1MouseMove(Sender: PControl;
      var Mouse: TMouseEventData);
    procedure Label1MouseMove(Sender: PControl;
      var Mouse: TMouseEventData);
    procedure Label2MouseMove(Sender: PControl;
      var Mouse: TMouseEventData);
    procedure Label3MouseMove(Sender: PControl;
      var Mouse: TMouseEventData);
    function SPLPicture1Message(var Msg: tagMSG;
      var Rslt: Integer): Boolean;
    procedure Label3MouseUp(Sender: PControl; var Mouse: TMouseEventData);
    procedure Label1MouseUp(Sender: PControl; var Mouse: TMouseEventData);
    procedure Label2MouseUp(Sender: PControl; var Mouse: TMouseEventData);
    procedure Label4MouseMove(Sender: PControl;
      var Mouse: TMouseEventData);
    procedure Label4MouseUp(Sender: PControl; var Mouse: TMouseEventData);
  private
{    pt: TPoint;
    CanMove: Boolean;}
  public
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

function InRect( const Rect: TRect; const Point: TPoint ): Boolean;


implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}
{$R mainicon.res}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TForm1.SPLPicture1Click(Sender: PObj);
begin
  ShowMessage( 'Bla-Bla' );
end;

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
var F: TextFile; mv: string;
begin
  AssignFile( F, ExtractFilePath( ParamStr( 0 ) ) + 'MOVIE.DAT' );
  Reset( F );
  Readln( F, mv );
  Readln( F, mv );
  Form.Caption := 'Autorun: ' + mv;
  CloseFile( F );
  Label5.Caption := mv;
end;

procedure TForm1.Label1MouseEnter(Sender: PObj);
begin
{  SPLPicture1.Panel.Visible := True;
  SPLPicture1.Refresh;}
  SPLPicture2.Show;
  SPLPicture2.Refresh;
end;

procedure TForm1.Label1MouseLeave(Sender: PObj);
begin
  SPLPicture2.Hide;
  SPLPicture1.Refresh;
end;

procedure TForm1.SPLPicture1MouseMove(Sender: PControl;
  var Mouse: TMouseEventData);
begin
  if SPLPicture2.Visible then SPLPicture2.Visible := False;
  if SPLPicture3.Visible then SPLPicture3.Visible := False;
  if SPLPicture4.Visible then SPLPicture4.Visible := False;
  if SPLPicture5.Visible then SPLPicture5.Visible := False;
end;

procedure TForm1.Label1MouseMove(Sender: PControl;
  var Mouse: TMouseEventData);
begin
  if SPLPicture3.Visible then SPLPicture3.Visible := False;
  if SPLPicture4.Visible then SPLPicture4.Visible := False;
  if SPLPicture5.Visible then SPLPicture5.Visible := False;
  if not SPLPicture2.Visible then SPLPicture2.Visible := True;
end;

procedure TForm1.Label2MouseMove(Sender: PControl; var Mouse: TMouseEventData);
begin
  if SPLPicture2.Visible then SPLPicture2.Visible := False;
  if SPLPicture4.Visible then SPLPicture4.Visible := False;
  if SPLPicture5.Visible then SPLPicture5.Visible := False;
  if not SPLPicture3.Visible then SPLPicture3.Visible := True;
end;

procedure TForm1.Label3MouseMove(Sender: PControl; var Mouse: TMouseEventData);
begin
  if SPLPicture2.Visible then SPLPicture2.Visible := False;
  if SPLPicture3.Visible then SPLPicture3.Visible := False;
  if SPLPicture5.Visible then SPLPicture5.Visible := False;
  if not SPLPicture4.Visible then SPLPicture4.Visible := True;
end;

procedure TForm1.Label4MouseMove(Sender: PControl; var Mouse: TMouseEventData);
begin
  if SPLPicture2.Visible then SPLPicture2.Visible := False;
  if SPLPicture3.Visible then SPLPicture3.Visible := False;
  if SPLPicture4.Visible then SPLPicture4.Visible := False;
  if not SPLPicture5.Visible then SPLPicture5.Visible := True;
end;

function TForm1.SPLPicture1Message(var Msg: tagMSG; var Rslt: Integer): Boolean;
//var pt: TSmallPoint;
begin
  Result := False;
  case Msg.message of
  WM_LBUTTONDOWN: SPLPicture1.Perform( WM_NCLBUTTONDOWN, HTCAPTION, Msg.lParam );
  WM_LBUTTONUP: SPLPicture1.Perform( WM_NCLBUTTONUP, HTCAPTION, Msg.lParam );
  end;
end;

function InRect( const Rect: TRect; const Point: TPoint ): Boolean;
begin
  Result := not ( ( Point.X < 0 ) or ( Point.X > ( Rect.Right - Rect.Left ) ) or
    ( Point.Y < 0 ) or ( Point.Y > ( Rect.Bottom - Rect.Top ) ) );
end;

procedure TForm1.Label3MouseUp(Sender: PControl; var Mouse: TMouseEventData);
var pt: TPoint; F: TextFile; mv: string;
begin
  pt.X := Mouse.X;
  pt.Y := Mouse.Y;
  if ( not InRect( Sender.BoundsRect, pt ) ) or ( Mouse.Button <> mbLeft ) then Exit;
  AssignFile( F, ExtractFilePath( ParamStr( 0 ) ) + 'MOVIE.DAT' );
  Reset( F );
  Read( F, mv );
  mv := ExtractFilePath( ParamStr( 0 ) ) + mv;
  CloseFile( F );
  ShellExecute( Form.Handle, 'open', PChar( mv ), nil, nil, SW_SHOW );
  Form.Close;
end;

procedure TForm1.Label1MouseUp(Sender: PControl; var Mouse: TMouseEventData);
var Path: string; pt: TPoint;
begin
  pt.X := Mouse.X;
  pt.Y := Mouse.Y;
  if ( not InRect( Sender.BoundsRect, pt ) ) or ( Mouse.Button <> mbLeft ) then Exit;
{$IFDEF DEMOVER}
  ShowMessage( '—читайте что установили DivX :-)' );
{$ELSE}
  Path := ExtractFilePath( ParamStr( 0 ) ) + 'Codec\DIVX\RUNINF.EXE';
  ShellExecute( Form.Handle, 'open', PChar( Path ), 'DIVX.INF', nil, SW_SHOWNA );
  Path := ExtractFilePath( ParamStr( 0 ) ) + 'Codec\DIVXAF\SETUP.EXE';
  ShellExecute( Form.Handle, 'open', PChar( Path ), nil, nil, SW_SHOWNA );
{$ENDIF}
end;

procedure TForm1.Label2MouseUp(Sender: PControl; var Mouse: TMouseEventData);
var Path: string; pt: TPoint;
begin
  pt.X := Mouse.X;
  pt.Y := Mouse.Y;
  if ( not InRect( Sender.BoundsRect, pt ) ) or ( Mouse.Button <> mbLeft ) then Exit;
{$IFDEF DEMOVER}
  ShowMessage( '—читайте что установили MPEG4 :)' );
{$ELSE}
  Path := ExtractFilePath( ParamStr( 0 ) ) + 'Codec\MPEG4\RUNINF.EXE';
  ShellExecute( Form.Handle, 'open', PChar( Path ), 'MPEG4FIX.INF', nil, SW_SHOWNA );
{$ENDIF}
end;

procedure TForm1.Label4MouseUp(Sender: PControl; var Mouse: TMouseEventData);
var pt: TPoint;
begin
  pt.X := Mouse.X;
  pt.Y := Mouse.Y;
  if ( not InRect( Sender.BoundsRect, pt ) ) or ( Mouse.Button <> mbLeft ) then Exit;
  Form.Close;
end;

end.



