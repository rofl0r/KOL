unit KOLFtp;

interface

uses
  Windows, KOL, KOLSocket;

type

  TLogEvent = procedure(Sender: PObj; Msg: string) of object;
  TOnExist  = procedure(Sender: PObj; Name: string; Size: integer; var append, cancel: boolean) of object;

  TStatus = (ftpNone,  ftpReady, ftpList,
             ftpGet,   ftpPut,   ftpOpen,
             ftpError, ftpLogin, ftpBusy,
             ftpConn,  ftpPutEr, ftpGetEr);

  TKOLFTP       =^TKOLFtpClient;
  PKOLFtpClient =^TKOLFtpClient;
  TKOLFtpClient = object(TObj)
  private
    fFirstAck: boolean;
    fUserName: string;
    fUserPass: string;
    frAddress: string;
    fHostPort: string;
    fpFTPPort: integer;
    fpFTPAddr: string;
    flPassive: boolean;
    fPNoError: boolean;
    fSavePath: string;
   fftpStatus: TStatus;
    fMainSock: PAsyncSocket;
    fAcptSock: PAsyncSocket;
    fDataSock: PAsyncSocket;
    fOnFTPSta: TOnEvent;
    fOnFTPMsg: TLogEvent;
    fOnFTPCon: TOnEvent;
    fOnFTPLog: TOnEvent;
    fOnFTPErr: TOnEvent;
    fOnFTPDat: TOnEvent;
    fOnFTPPro: TOnEvent;
    fOnFTPDon: TOnEvent;
    fOnFTPClo: TOnEvent;
    fOnGetExi: TOnExist;
    fOnPutExi: TOnExist;
    Connected: boolean;
    fMSLogged: boolean;
    frWelcome: PStrList;
    frListing: PStrList;
    fOpSystem: string;
    fLastCode: integer;
    fLastAnsw: string;
    fFileName: string;
    fJustName: string;
    OutStream: PStream;
    fLastLine: string;
    { Private declarations }
  protected
    { Protected declarations }
    destructor Destroy; virtual;
    procedure DoEvent(e: TOnEvent);
    procedure OpenData;
    procedure SetPasv;
    procedure SetPort;
    procedure SetupPasv(s: string);
    procedure SendFile;
    function  SendStr(s: string): boolean;
    procedure SetFtpStatus(Value: TStatus);
    procedure OnMSConnect(Msg: TWMSocket);
    procedure OnMSRead   (Msg: TWMSocket);
    procedure OnMSError  (Msg: TWMSocket);
    procedure OnMSClose  (Msg: TWMSocket);
    procedure OnASListen (Msg: TWMSocket);
    procedure OnASAccept (Msg: TWMSocket);
    procedure OnASClose  (Msg: TWMSocket);
    procedure OnDSConnect(Msg: TWMSocket);
    procedure OnDSARead  (Msg: TWMSocket);
    procedure OnDSBRead  (Msg: TWMSocket);
    procedure OnDSError  (Msg: TWMSocket);
    procedure OnDSClose  (Msg: TWMSocket);
  public
    { Public declarations }
    oldStatus: TStatus;
    fFileSize: longint;
    TotalRece: integer;
    TotalSent: integer;
    MovedFile: string;
    MovedSize: integer;
    property  UserName: string read fUserName write fUserName;
    property  UserPass: string read fUserPass write fUserPass;
    property  HostAddr: string read frAddress write frAddress;
    property  HostPort: string read fHostPort write fHostPort;
    property  Passive: boolean read flPassive write flPassive;
    property  SavePath: string read fSavePath write fSavePath;
    property ftpStatus: TStatus read fftpStatus write SetFtpStatus;
    property  LastCode: integer read fLastCode;
    property  LastText: string  read fLastAnsw;
    procedure Connect;
    procedure Login;
    procedure List;
    function  Size(const Name: string): boolean;
    procedure Cwd(const Name: string);
    procedure Cdup;
    procedure Get(const Name: string);
    procedure Put(const Name: string);
    procedure Abort;
    procedure RMD(const Name: string);
    procedure Delete(const Name: string);
    procedure MDir(const Name: string);
    procedure Close;
    property  OnFTPStatus: TOnEvent read fOnFTPSta write fOnFTPSta;
    property  OnFTPLogger: TLogEvent read fOnFTPMsg write fOnFTPMsg;
    property  OnFTPConnect: TOnEvent read fOnFTPCon write fOnFTPCon;
    property  OnFTPLogin: TOnEvent read fOnFTPLog write fOnFTPLog;
    property  OnFTPError: TOnEvent read fOnFTPErr write fOnFTPErr;
    property  OnFTPData : TOnEvent read fOnFTPDat write fOnFTPDat;
    property  OnProgress: TOnEvent read fOnFTPPro write fOnFTPPro;
    property  OnGetExist: TOnExist read fOnGetExi write fOnGetExi;
    property  OnPutExist: TOnExist read fOnPutExi write fOnPutExi;
    property  OnFileDone: TOnEvent read fOnFTPDon write fOnFTPDon;
    property  OnFTPClose: TOnEvent read fOnFTPClo write fOnFTPClo;
    property  Welcome: PStrList read frWelcome;
    property  Listing: PStrList read frListing;
  end;

  function  NewKOLFtpClient: PKOLFtpClient;
  function  IsInet: boolean;

implementation

uses UStr, UWrd;

function  InetIsOffline(Flag: Integer): Boolean; stdcall; external 'URL.DLL';

function  NewKOLFtpClient: PKOLFtpClient;
begin
   New(Result, create);
   Result.fUserName            := 'anonymous';
   Result.fUserPass            := 'ftp@microsoft.com';
   Result.fHostPort            := '21';
   Result.frAddress            := '127.0.0.1';
   Result.flPassive            := False;
   Result.fLastLine            := '';
   Result.fMainSock            := NewAsyncSocket;
   Result.fMainSock.OnConnect  := Result.OnMSConnect;
   Result.fMainSock.OnRead     := Result.OnMSRead;
   Result.fMainSock.OnError    := Result.OnMSError;
   Result.fMainSock.OnClose    := Result.OnMSClose;
   Result.fAcptSock            := NewAsyncSocket;
   Result.fAcptSock.IPAddress  := '0.0.0.0';
   Result.fAcptSock.PortNumber := 0;
   Result.fAcptSock.OnAccept   := Result.OnASAccept;
   Result.fAcptSock.OnListen   := Result.OnASListen;
   Result.fAcptSock.OnError    := Result.OnMSError;
   Result.fAcptSock.OnClose    := Result.OnASClose;
   Result.fDataSock            := NewAsyncSocket;
   Result.fDataSock.OnConnect  := Result.OnDSConnect;
   Result.fDataSock.OnError    := Result.OnDSError;
   Result.fDataSock.OnClose    := Result.OnDSClose;
   Result.frWelcome            := NewStrList;
   Result.frListing            := NewStrList;
   Result.ftpStatus            := ftpNone;
end;

destructor TKOLFtpClient.Destroy;
begin
   fMainSock.DoClose;
   fMainSock.Free;
   fAcptSock.DoClose;
   fAcptSock.Free;
   fDataSock.DoClose;
   fDataSock.Free;
   frListing.Free;
   frWelcome.Free;
   inherited;
end;

procedure TKOLFtpClient.DoEvent;
begin
   if assigned(e) then e(@self);
end;

procedure TKOLFtpClient.OpenData;
begin
   if flPassive then begin
      SetPasv;
   end else begin
      fAcptSock.DoListen;
      SetPort;
   end;
end;

procedure TKOLFtpClient.SetPasv;
begin
   SendStr('PASV');
end;

procedure TKOLFtpClient.SetPort;
var s: string;
    i: word;
begin
   s := fMainSock.LocalIP + ',';
   for i := 1 to length(s) do
      if s[i] = '.' then s[i] := ',';
   i := fAcptSock.LocalPort;
   s := s + int2str(Hi(i)) + ',' + int2str(Lo(i));
   SendStr('PORT ' + s);
end;

procedure TKOLFtpClient.SetupPasv;
var i: integer;
    n: integer;
    r: string;
begin
   r := wordn(s, '(', 2);
   i := 1;
   n := 0;
   while i < length(r) do begin
      if r[i]  = ',' then begin
         r[i] := '.';
         inc(n);
         if n = 3 then begin
            fpFTPAddr := wordn(r, ',', 1);
            r := copy(r, length(fpFTPAddr) + 2, 255);
            r := wordn(r, ')', 1);
            fpFTPPort := str2int(wordn(r, ',', 1)) shl 8;
            fpFTPPort := fpFTPPort + str2int(wordn(r, ',', 2));
            fDataSock.IPAddress := fpFTPAddr;
            fDataSock.PortNumber := fpFTPPort;
            fDataSock.DoConnect;
            exit;
         end;
      end;
      inc(i);
   end;
end;

procedure TKOLFtpClient.SendFile;
var buf: array[0..1023] of byte;
    len: integer;
begin
   while TotalSent < fFileSize do begin
      ftpStatus := ftpPut;
      if not fDataSock.Connected then begin
         oldStatus := ftpPut;
         ftpStatus := ftpReady;
         exit;
      end;
      if OutStream <> Nil then
         len := OutStream.Read(buf, sizeof(buf))
                          else exit;
      if len = 0 then break;
      fDataSock.DoSend(@buf, len);
      TotalSent := TotalSent + len;
      if len = -1 then begin
         TotalSent := TotalSent + 1;
         While applet.ProcessMessage do;
      end else applet.ProcessMessage;
      if TotalSent < fFileSize then begin
         if OutStream <> nil then begin
            OutStream.Seek(TotalSent, spBegin);
         end else begin
            exit;
         end;
      end;
      if assigned(fOnFTPPro) then fOnFTPPro(@self);
   end;
   fDataSock.DoClose;
end;

function  TKOLFtpClient.SendStr;
begin
   result := False;
   if fMainSock.Connected then begin
      if assigned(fOnFTPMsg) then fOnFTPMsg(@self, s);
      fLastCode := 0;
      fMainSock.SendString(s + #13#10);
      while (fLastCode = 0) and fMainSock.Connected do begin
         fMainSock.ProcessMessages;
         applet.ProcessMessage;
      end;
      result := fMainSock.Connected;
   end else DoEvent(fOnFTPErr);
end;

procedure TKOLFtpClient.SetFtpStatus;
begin
   fftpStatus := Value;
   DoEvent(fOnFTPSta);
end;

procedure TKOLFtpClient.OnMSConnect;
begin
   Connected := True;
   fFirstAck := True;
end;

procedure TKOLFtpClient.OnMSRead;
var s: string;
    m: integer;
begin
   m := 0;
   while fMainSock.Count > 0 do begin
      s := fMainSock.ReadLine(#10);
      if length(s) < 3 then break;
      if assigned(fOnFTPMsg) then fOnFTPMsg(@self, s);
      m := str2int(copy(s, 1, 3));
      if m > 0 then s := copy(s, 5, length(s) - 5);
      fLastCode := m;
      fLastAnsw := s;
      case m of
{     125: if flPassive then fDataSock.DoConnect;
     150: if flPassive then fDataSock.DoConnect;}
     213: fFileSize := str2int(s);
     215: fOpSystem := s;
     220: frWelcome.Add(s);
     227: SetupPasv(s);
     230: frWelcome.Add(s);
     331: begin
             if fUserPass = '' then s := 'guest@' + frAddress
                               else s := fUserPass;
             SendStr('PASS ' + s);
          end;
      end;
   end;
   if (m = 200) and (ftpStatus = ftpLogin) then begin
      ftpStatus := ftpReady;
      if assigned(fOnFTPLog) then fOnFTPLog(@self);
   end;
   if (m = 215) and (ftpStatus = ftpLogin) then begin
      ftpStatus := ftpReady;
      if assigned(fOnFTPLog) then fOnFTPLog(@self);
   end;
   if (m = 220) then begin
      if assigned(fOnFTPCon) then fOnFTPCon(@self);
      login;
   end;
   if (m = 230) and (fFirstAck) then begin
      fFirstAck := False;
      SendStr('SYST');
   end;
   if m > 499 then begin
      fAcptSock.DoClose;
      fDataSock.DoClose;
      if not fPNoError then DoEvent(fOnFTPErr);
      ftpStatus := ftpReady;
   end;
end;

procedure TKOLFtpClient.OnMSError;
begin
   DoEvent(fOnFTPErr);
   fMainSock.DoClose;
end;

procedure TKOLFtpClient.OnMSClose;
begin
   fMSLogged := False;
   Connected := False;
   fAcptSock.DoClose;
   fDataSock.DoClose;
   ftpStatus := ftpNone;
   if assigned(fOnFTPClo) then fOnFTPClo(@self);
end;

procedure TKOLFtpClient.OnASListen;
begin
end;

procedure TKOLFtpClient.OnASAccept;
begin
   fAcptSock.DoAccept(fDataSock);
   if ftpStatus = ftpPut then begin
      SendFile;
   end;
end;

procedure TKOLFtpClient.OnASClose;
begin
   ftpStatus := ftpReady;
end;

procedure TKOLFtpClient.OnDSConnect;
begin
{   ftpStatus := ftpOpen;}
end;

procedure TKOLFtpClient.OnDSARead;
var s: string;
    r: string;
    d: char;
    i: integer;

const
  Mon: array[0..12] of string = ('???',
                                 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');

function divider(s: string): char;
var i: integer;
begin
   result := ' ';
   for i := 1 to length(s) do
      if not (s[i] in ['0'..'9']) then begin
         result := s[i];
         exit;
      end;
end;

begin
   ftpStatus := ftpList;
   while fDataSock.Count > 0 do begin
      s := fDataSock.ReadLine(#10);
      if fLastLine <> '' then begin
         s := fLastLine + s;
      end;
      if s = '' then break;
      if pos(#13, s) = 0 then begin
         fLastLine := s;
         break;
      end;
      fLastLine := '';
      if s[1] in ['0'..'9'] then begin
         d := divider(wordn(s, ' ', 1));
         if str2int(wordn(s, ' ', 3)) = 0 then r := 'd'
                                          else r := '-';
         r := r + 'rwxrwxrwx 1 ftp ftp ' +
              int2str(str2int(wordn(s, ' ', 3))) + ' ' +
              Mon[str2int(wordn(wordn(s, ' ', 1), d, 1))] + ' ' +
              wordn(wordn(s, ' ', 1), d, 2) + ' ' +
              wordn(s, ' ', 2) + ' ';
         for i := 1 to 3 do s := wordd(s, ' ', 1);
         r := r + s;
         s := r;
      end;
      frListing.Add(s);
   end;
   if assigned(fOnFTPDat) then fOnFTPDat(@self);
end;

procedure TKOLFtpClient.OnDSBRead;
var buf: array[0..1024] of byte;
    len: integer;
begin
   ftpStatus := ftpGet;
   if TotalRece = 0 then
      while (fLastCode = 0) do begin
      applet.ProcessMessage;
      if not fMainSock.Connected then break;
   end;
   while fDataSock.Count > 0 do begin
      len := fDataSock.ReadData(@buf, 1024);
      if OutStream <> nil then begin
         OutStream.Write(buf, len);
      end else begin
         ftpStatus := ftpError;
         exit;
      end;
      TotalRece := TotalRece + len;
      if assigned(fOnFTPPro) then fOnFTPPro(@self);
      applet.ProcessMessage;
   end;
end;

procedure TKOLFtpClient.OnDSError;
begin
end;

procedure TKOLFtpClient.OnDSClose;
var m: TWMSocket;
begin
   if fDataSock.Count > 0 then begin
      if ftpStatus = ftpGet then begin
         OnDSBRead(m);
         applet.processpendingmessages;
         if fDataSock.Count > 0 then
            OnDSBRead(m);
      end;
      if ftpStatus = ftpList then begin
         OnDSARead(m);
         applet.processpendingmessages;
         if fDataSock.Count > 0 then
            OnDSARead(m);
      end;
   end;
   OutStream.Free;
   OutStream := Nil;
   if ftpStatus <> ftpReady then oldStatus := ftpStatus;
   ftpStatus := ftpReady;
   MovedFile := fFileName;
   MovedSize := TotalSent;
   fAcptSock.DoClose;
   fMainSock.ProcessMessages;
   if not fLastCode in [125, 150, 226] then
   if oldStatus = ftpPut then ftpStatus := ftpPutEr else
   if oldStatus = ftpGet then ftpStatus := ftpGetEr;
   DoEvent(fOnFTPDon);
   ftpStatus := ftpReady;
   if not fMainSock.Connected then DoEvent(fOnFTPClo);
end;

procedure TKOLFtpClient.Connect;
begin
   ftpStatus := ftpConn;
   fMainSock.IPAddress  := frAddress;
   fMainSock.PortNumber := str2int(fHostPort);
   fMainSock.DoConnect;
end;

procedure TKOLFtpClient.Login;
var s: string;
begin
   ftpStatus := ftpLogin;
   if fUserName = '' then s := 'anonymous'
                     else s :=  fUserName;
   SendStr('USER ' + s);
   if fLastCode = 530 then begin
      DoEvent(fOnFTPErr);
      fMainSock.doClose;
   end;
end;

procedure TKOLFtpClient.List;
begin
   if ftpStatus = ftpReady then begin
      frListing.Clear;
      ftpStatus := ftpList;
      oldStatus := ftpList;
      OpenData;
      fDataSock.OnRead := OnDSARead;
      if SendStr('TYPE A') then SendStr('LIST');
      if not fMainSock.Connected then DoEvent(fOnFTPClo);
   end else DoEvent(fOnFTPErr);
end;

function  TKOLFtpClient.Size;
begin
   Result := False;
   fMainSock.ProcessMessages;
   if SendStr('TYPE I') then begin
      fMainSock.ProcessMessages;
      fFileSize := 0;
      fPNoError := True;
      if SendStr('SIZE ' + Name) then Result := True;
      fPNoError := False;
   end;
end;

procedure TKOLFtpClient.Cwd;
begin
   if SendStr('CWD ' + Name) then
      if fLastCode = 250 then List else DoEvent(fOnFTPErr);
end;

procedure TKOLFtpClient.Cdup;
begin
   if SendStr('CDUP') then
      if fLastCode = 250 then List else DoEvent(fOnFTPErr);
end;

procedure TKOLFtpClient.get;
var a,
    c: boolean;
    s: integer;
begin
   if Name = '' then exit;
   s := 0;
   if ftpStatus = ftpReady then begin
      fFileName := Name;
      fJustName := JustFileName(Name);
      Size(Name);
      a := False;
      c := False;
      if KOL.FileExists(fSavePath + fFileName) then begin
         s := KOL.FileSize(fSavePath + fFileName);
         if assigned(fOnGetExi) then
            fOnGetExi(@self, fSavePath + fFileName, s, a, c);
         if c then begin
            ftpStatus := ftpReady;
            exit;
         end;
      end;
      ftpStatus := ftpGet;
      if fMainSock.Connected then begin
         try
            {$I-}
            MkDir(fSavePath);
            {$I-}
            if ioresult = 0 then;
            OutStream := NewWriteFileStream(fSavePath + fFileName);
         except
            ShowMessage('Error opening output file: ' + fSavePath + fFileName);
            OutStream.Free;
            OutStream := nil;
            exit;
         end;
         OpenData;
         fDataSock.OnRead := OnDSBRead;
         if SendStr('TYPE I') then begin
            TotalRece := 0;
            if a then begin
               TotalRece := s;
               OutStream.Position := s;
               if SendStr('REST ' + int2str(s)) then begin
               end;
            end;
            SendStr('RETR ' + NAME);
         end;
      end else DoEvent(fOnFTPErr)
   end else DoEvent(fOnFTPErr);
end;

procedure TKOLFtpClient.Put;
var a,
    c: boolean;
    s: integer;
begin
   if Name = '' then exit;
   if ftpStatus = ftpReady then begin
      fFileName := Name;
      fJustName := JustFileName(fFileName);
      if Size(fJustName) then begin
         ftpStatus := ftpPut;
         a := False;
         c := False;
         if fFileSize > 0 then begin
            if assigned(fOnPutExi) then
               fOnPutExi(@self, fJustName, fFileSize, a, c);
            if c then begin
               ftpStatus := ftpReady;
               exit;
            end;
         end;
         if fMainSock.Connected then begin
            s := fFileSize;
            fFileSize := KOL.FileSize(fFileName);
            OpenData;
            try
               OutStream := NewReadFileStream(fFileName);
            except
               ShowMessage('Error opening input file: ' + fFileName);
               OutStream.Free;
               OutStream := nil;
               exit;
            end;
            TotalSent := 0;
            fDataSock.OnRead := nil;
            if a then begin
               OutStream.Position := s;
               TotalSent := s;
               c := SendStr('APPE ' + fJustName);
            end  else begin
               c := SendStr('STOR ' + fJustName);
            end;
            if c then
            if (fLastCode in [110, 125, 150]) then begin
               if flPassive then SendFile;
            end else
            if fLastCode > 499 then begin
               if not flPassive then begin
                  oldStatus := ftpPut;
                  ftpStatus := ftpPutEr;
                  MovedFile := fFileName;
                  DoEvent(fOnFTPDon);
                  ftpStatus := ftpReady;
               end;
            end;
         end;
      end else DoEvent(fOnFTPErr)
   end else DoEvent(fOnFTPErr);
end;

procedure TKOLFtpClient.RMD;
begin
   ftpStatus := ftpBusy;
   SendStr('RMD ' + Name);
   ftpStatus := ftpReady;
end;

procedure TKOLFtpClient.Delete;
begin
   ftpStatus := ftpBusy;
   SendStr('DELE ' + Name);
   ftpStatus := ftpReady;
end;

procedure TKOLFtpClient.MDir;
begin
   SendStr('MKD ' + Name);
end;

procedure TKOLFtpClient.Abort;
begin
   if ftpStatus = ftpPut then fDataSock.DoClose
                         else SendStr('ABOR');
end;

procedure TKOLFtpClient.Close;
begin
   fMainSock.DoClose;
   fAcptSock.DoClose;
   fDataSock.DoClose;
end;

function  IsInet;
begin
  if InetIsOffline(0) then Result := False
                      else Result := True;
end;

end.
