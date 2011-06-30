{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit KOLForm;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLSocket, FormSave {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, Grids, mckCtrls, mckObjs, mckSocket,  mckFormSave {$ENDIF};
{$ELSE}
{$I uses.inc} mirror,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
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
    KP: TKOLProject;
    KF: TKOLForm;
    Term: TKOLMemo;
    MM: TKOLMainMenu;
    KA: TKOLApplet;
    CS: TKOLSocket;
    FS: TKOLFormSave;
    procedure Connect;
    procedure Disconnect;
    procedure onConnect(Msg: TWMSocket);
    procedure onRead(Msg: TWMSocket);
    procedure onError(Msg: TWMSocket);
    procedure onDisconnect(Msg: TWMSocket);
    procedure TermChar(Sender: PControl; var Key: Char; Shift: Cardinal);
    procedure MMN2Menu(Sender: PMenu; Item: Integer);
    procedure MMN4Menu(Sender: PMenu; Item: Integer);
    procedure MMN5Menu(Sender: PMenu; Item: Integer);
    procedure CSDestroy(Sender: PObj);
  private
    { Private declarations }
    m_string: string;
    m_strBuff: Array[0..2047] of Char;
{    CS: PAsyncSocket;}
  public
    { Public declarations }
  end;
var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation
uses Params;
{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I KOLForm_1.inc}
{$ENDIF}

procedure TForm1.Connect;
begin
  Form.SimpleStatusText := 'Connecting ...';
  CS.DoClose;
  CS.PortNumber := str2int(Form2.EditBox1.Text);
  CS.IPAddress := Form2.EditBox2.Text;
  CS.DoConnect;
end;

procedure TForm1.Disconnect;
begin
   if CS <> nil then CS.DoClose;
end;

procedure TForm1.onConnect;
var mess: string;
begin
   mess := 'Connected to ' + CS.IPAddress + ':' + Int2Str(CS.PortNumber);
   Form.SimpleStatusText := PChar(mess);
   MM.ItemEnabled[ 1 ] := False;
   MM.ItemEnabled[ 2 ] := True;
end;

procedure TForm1.onRead;
begin
  while CS.count > 0 do begin
    ZeroMemory(@Form1.m_strBuff, 2048);
    CS.ReadData(@Form1.m_strBuff, 2048);
    Term.Add(m_strBuff);
    Term.SelStart := Term.TextSize;
    Term.Perform( EM_LINESCROLL, 0, 32767 );
    if Term.Count > 1000 then begin
      Term.SelStart := Term.Item2Pos( 0 );
      Term.SelLength := Term.Item2Pos( 0 + 1 ) - Term.SelStart;
      Term.ReplaceSelection( '', False );
    end;
    Term.Perform( EM_LINESCROLL, 0, 32767 );
  end;
end;

procedure TForm1.onError;
var mess: string;
begin
   Mess := 'Disconnected. Error: ' +
           Int2Str(Msg.SocketError) + ' (' +
           CS.ErrToStr(Msg.SocketError) + ').';
   Form.SimpleStatusText := PChar(Mess);
   MM.ItemEnabled[ 1 ] := True;
   MM.ItemEnabled[ 2 ] := False;
end;

procedure TForm1.onDisconnect;
begin
   Form.SimpleStatusText := 'Disconnected';
   MM.ItemEnabled[ 1 ] := True;
   MM.ItemEnabled[ 2 ] := False;
end;

procedure TForm1.TermChar(Sender: PControl; var Key: Char;
  Shift: Cardinal);
  var i: integer;
begin
   m_string := m_string + key;
   if key = #13 then begin
      m_string := m_string + #10;
      i := length(m_string);
      CS.DoSend(pchar(m_string), i);
      m_string := '';
   end;
end;

procedure TForm1.MMN2Menu(Sender: PMenu; Item: Integer);
begin
   Form2.Form.Show;
end;

procedure TForm1.MMN4Menu(Sender: PMenu; Item: Integer);
begin
   Applet.Close;
end;

procedure TForm1.MMN5Menu(Sender: PMenu; Item: Integer);
begin
   Disconnect;
end;

procedure TForm1.CSDestroy(Sender: PObj);
begin
   beep(500, 500);
end;

end.























