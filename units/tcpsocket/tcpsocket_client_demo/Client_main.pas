{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Client_main;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, kolTCPSocket {$IFNDEF KOL_MCK}, mirror, Classes,
  mckTCPSocket, Controls, mckCtrls, mckObjs {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mirror;
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
    Project: TKOLProject;
    Main: TKOLForm;
    Client: TKOLTCPClient;
    Menu: TKOLMainMenu;
    ListBox1: TKOLListBox;
    EditBox1: TKOLEditBox;
    Applet: TKOLApplet;
    Upload: TKOLOpenSaveDialog;
    Progress: TKOLProgressBar;
    procedure ListBox1Enter(Sender: PObj);
    procedure MainN9Menu(Sender: PMenu; Item: Integer);
    procedure MainN6Menu(Sender: PMenu; Item: Integer);
    procedure ClientConnect(sender: PTCPClient);
    procedure AddItem(const s: string);
    procedure ClientDisconnect(sender: PTCPClient);
    procedure ClientError(sender: PObj; const error: Integer);
    procedure ClientResolve(sender: PTCPClient; const ip: String);
    procedure ClientReceive(sender: PTCPClient; var buf: array of Byte;
      const count: Integer);
    procedure EditBox1Char(Sender: PControl; var Key: Char;
      Shift: Cardinal);
    procedure MenuN7Menu(Sender: PMenu; Item: Integer);
    procedure ClientStreamSend(Sender: PTCPClient);
    procedure MenuN2Menu(Sender: PMenu; Item: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;
  uploadname:string;
  uploadstream:pstream;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

uses Client_conn;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Client_main_1.inc}
{$ENDIF}

procedure TForm1.ListBox1Enter(Sender: PObj);
begin
  editbox1.Focused:=true;
end;

procedure TForm1.MainN9Menu(Sender: PMenu; Item: Integer);
begin
  form.close;
end;

procedure TForm1.MainN6Menu(Sender: PMenu; Item: Integer);
begin
  form2.form.showmodal;
end;

procedure TForm1.ClientConnect(sender: PTCPClient);
begin
  additem('Connected to: '+sender.host);
  menu.ItemEnabled[N6]:=false;
  menu.ItemEnabled[N7]:=true;
  menu.ItemEnabled[N2]:=true;
end;

procedure TForm1.AddItem(const s: string);
begin
  listbox1.add(s);
  listbox1.Perform(LB_SETTOPINDEX,pred(listbox1.count),0);
end;

procedure TForm1.ClientDisconnect(sender: PTCPClient);
begin
  additem('Disconnected.');
  menu.ItemEnabled[N6]:=true;
  menu.ItemEnabled[N7]:=false;
  menu.ItemEnabled[N2]:=false;
end;

procedure TForm1.ClientError(sender: PObj; const error: Integer);
begin
  additem('Error: '+err2str(error));
end;

procedure TForm1.ClientResolve(sender: PTCPClient; const ip: String);
begin
  additem('Resolved with IP: '+ip);
end;

procedure TForm1.ClientReceive(sender: PTCPClient; var buf: array of Byte;
  const count: Integer);
var
  s:string;
begin
  setlength(s,count);
  move(buf,s[1],count);
  if uppercase(s)='UPLOADING' then
  begin
    client.sendstream(uploadstream,true);
    progress.show;
  end else additem(ptcpclient(sender).host+' >> '+s);
end;

procedure TForm1.EditBox1Char(Sender: PControl; var Key: Char;
  Shift: Cardinal);
var
  s:string;
begin
  if (key=#13) and (sender.text<>'') then
  begin
    s:=sender.text;
    client.sendstring(s);
    additem('#>> '+s);
    sender.text:='';
    key:=#0;
  end;
end;

procedure TForm1.MenuN7Menu(Sender: PMenu; Item: Integer);
begin
  client.Disconnect;
end;

procedure TForm1.ClientStreamSend(Sender: PTCPClient);
begin
  if not sender.streamsending then
  begin
    additem('File '+uploadname+' sent.');
    progress.hide;
  end else
  with uploadstream^ do progress.progress:=position*100 div size;
end;

procedure TForm1.MenuN2Menu(Sender: PMenu; Item: Integer);
var
  s:string;
begin
  if upload.execute then
  begin
    uploadname:=upload.filename;
    uploadstream:=newreadfilestream(uploadname);
    s:='FILE'#13+int2str(uploadstream.size)+#13+extractfilename(uploadname)+#13;
    client.sendstring(s);
  end;
end;

end.



