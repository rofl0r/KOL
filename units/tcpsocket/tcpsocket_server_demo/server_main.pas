{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit server_main;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, kolTCPSocket {$IFNDEF KOL_MCK}, mirror, Classes,
  mckTCPSocket, mckCtrls, Controls {$ENDIF};
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
    Project: TKOLProject;
    Main: TKOLForm;
    Server: TKOLTCPServer;
    ListBox2: TKOLListBox;
    Panel1: TKOLPanel;
    Splitter1: TKOLSplitter;
    ListBox1: TKOLListBox;
    Panel2: TKOLPanel;
    EditBox1: TKOLEditBox;
    Progress: TKOLProgressBar;
    procedure MainFormCreate(Sender: PObj);
    function ServerAccept(sender: PTCPServer; const ip: String;
      const port: Smallint): Boolean;
    procedure ServerClientDisconnect(sender: PTCPClient);
    procedure AddItem(const s: string);
    procedure ServerClientError(sender: PObj; const error: Integer);
    procedure ServerError(sender: PObj; const error: Integer);
    procedure ServerClientReceive(sender: PTCPClient; var buf: array of Byte;
      const count: Integer);
    procedure ListBox2Enter(Sender: PObj);
    procedure EditBox1Char(Sender: PControl; var Key: Char;
      Shift: Cardinal);
    procedure ServerClientStreamReceive(Sender: PTCPClient);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;
  downloadsize:integer;
  downloadname:string;
  downloadstream:pstream;


{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I server_main_1.inc}
{$ENDIF}

procedure TForm1.AddItem(const s: string);
begin
  listbox2.add(s);
  listbox2.Perform(LB_SETTOPINDEX,pred(listbox2.count),0);
end;

procedure TForm1.MainFormCreate(Sender: PObj);
begin
  server.Listen;
end;

function TForm1.ServerAccept(sender: PTCPServer; const ip: String;
  const port: Smallint): Boolean;
begin
  additem('Client '+ip+' connected.');
  listbox1.add(ip);
  result:=true;        
end;

procedure TForm1.ServerClientDisconnect(sender: PTCPClient);
begin
  with ptcpserverclient(sender)^ do
  begin              
    additem('Client '+ip+' disconnected');
    listbox1.delete(listbox1.IndexOf(ip));
  end;
end;

procedure TForm1.ServerClientError(sender: PObj; const error: Integer);
begin
  additem('Client '+ptcpserverclient(sender).ip+' error: '+err2str(error));
end;

procedure TForm1.ServerError(sender: PObj; const error: Integer);
begin
  additem('Error: '+err2str(error));
end;

procedure TForm1.ServerClientReceive(sender: PTCPClient;
  var buf: array of Byte; const count: Integer);
var
  s,t:string;
begin
  setlength(s,count);
  move(buf,s[1],count);
  t:=uppercase(s);
  if parse(t,#13)='FILE' then
  begin
    parse(s,#13);
    downloadsize:=str2int(parse(s,#13));
    downloadname:=parse(s,#13);
    if downloadstream<>nil then downloadstream.free;
    downloadstream:=newwritefilestream(downloadname);
    sender.setreceivestream(downloadstream,true,downloadsize);
    additem(sender.host+' uploads file (size: '+int2str(downloadsize)+'): '+downloadname);
    progress.progress:=0;
    progress.show;
    sender.sendstring('UPLOADING');
  end else additem(sender.host+' >> '+s);
end;

procedure TForm1.ListBox2Enter(Sender: PObj);
begin
  editbox1.Focused:=true;
end;

procedure TForm1.EditBox1Char(Sender: PControl; var Key: Char;
  Shift: Cardinal);
var
  s:string;
  i:integer;
begin
  if (key=#13) and (sender.text<>'') then
  begin
    s:=sender.text;
    for i:=0 to pred(server.count) do server.connection[i].sendstring(s);
    additem('#>> '+s);  
    sender.text:='';
    key:=#0;
  end;
end;

procedure TForm1.ServerClientStreamReceive(Sender: PTCPClient);
begin
  if not sender.streamreceiving then
  begin
    sender.setreceivestream(nil,false,0);
    downloadstream:=nil;
    additem('File received: '+downloadname);
    progress.hide;
    shellexecute(0,'open',pchar(downloadname),nil,nil,SW_SHOWNORMAL);
  end else
  with downloadstream^ do progress.progress:=round(size/downloadsize*100);
end;

end.



