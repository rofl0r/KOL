unit KOLHttp;

interface

uses
  Windows, KOL, KOLSocket;

type

  TKOLhttp        =^TKOLhttpControl;
  PKOLhttpControl =^TKOLhttpControl;
  TKOLhttpControl = object(TObj)
  private
   fAdr: string;
   fUrl: string;
   fRef: string;
   fUsr: string;
   fPas: string;
   fMth: string;
   fPAd: string;
   fPPr: integer;
   fCod: integer;
   fCnl: integer;
   Body: boolean;
   fHdr: PStrList;
   fCnt: PStrList;
   fSoc: PAsyncSocket;
  fPort: integer;
  fOnClos: TOnEvent;
  procedure OnDumm(Sender: TWMSocket);
  procedure OnConn(Sender: TWMSocket);
  procedure OnRead(Sender: TWMSocket);
  procedure OnClos(Sender: TWMSocket);
  procedure Prepare;
  protected
  procedure ParseUrl;
  public
  procedure Get; overload;
  procedure Get(_Url: string); overload;
  property Url: string read fUrl write fUrl;
  property HostPort: integer read fPort write fPort;
  property HostAddr: string read fAdr write fAdr;
  property UserName: string read fUsr write fUsr;
  property Password:  string read fPas write fPas;
  property Responce: integer read fCod write fCod;
  property Header: PStrList  read fHdr;
  property Content: PStrList read fCnt;
  property ContentLength: integer read fCnl;
  property ProxyAddr: string read fPAd write fPAd;
  property ProxyPort: integer read fPPr write fPPr;
  property OnClose: TOnEvent read fOnClos write fOnClos;
  end;

  function  NewKOLhttpControl: PKOLhttpControl;

implementation

uses UStr, UWrd;

const
  bin2b64:string='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

function  NewKOLhttpControl: PKOLhttpControl;
begin
   New(Result, create);
   Result.fPort := 80;
   Result.fAdr  := '';
   Result.fUsr  := '';
   Result.fPas  := '';
   Result.fMth  := 'GET';
   Result.fHdr  := NewStrList;
   Result.fCnt  := NewStrList;
end;

function encode_line(const buf: string):string;
var
  offset: shortint;
  pos1,pos2: byte;
  i: byte;
  out: string;
begin
  setlength(out, length(buf) * 4 div 3 + 4);
  fillchar(out[1], length(buf) * 4 div 3 + 2, #0);
  offset:=2;
  pos1:=0;
  pos2:=1;
  out[pos2]:=#0;
while pos1 < length(buf) do begin
  if offset > 0 then begin
    out[pos2]:=char(ord(out[pos2]) or ((ord(buf[pos1 + 1]) and ($3f shl offset)) shr offset));
    offset:=offset-6;
    inc(pos2);
    out[pos2]:=#0;
    end
  else if offset < 0 then begin
    offset:=abs(offset);
    out[pos2]:=char(ord(out[pos2]) or ((ord(buf[pos1 + 1]) and ($3f shr offset)) shl offset));
    offset:=8-offset;
    inc(pos1);
    end
  else begin
    out[pos2]:=char(ord(out[pos2]) or ((ord(buf[pos1 + 1]) and $3f)));
    inc(pos2);
    inc(pos1);
    out[pos2]:=#0;
    offset:=2;
    end;
  end;
  if offset=2 then dec(pos2);
  for i:=1 to pos2 do
    out[i]:=bin2b64[ord(out[i])+1];
  while (pos2 and 3)<>0  do begin
    inc(pos2);
    out[pos2] := '=';
  end;
  encode_line := copy(out, 1, pos2);
end;

procedure TKOLhttpControl.OnDumm;
begin
end;

procedure TKOLhttpControl.OnConn;
begin
   fHdr.Clear;
   fCnt.Clear;
   fSoc.SendString(fMth + ' ' + fRef + ' HTTP/1.1'#13#10);
   fSoc.SendString('User-Agent: KOL-HTTP'#13#10);
   fSoc.SendString('Host: ' + fAdr + #13#10);
   if fUsr <> '' then begin
      fSoc.SendString('Authorization: Basic ' + encode_line(fUsr + ':' + fPas) + #13#10);
   end;
   fSoc.SendString(#13#10);
end;

procedure TKOLhttpControl.OnRead;
var s: string;
    c: integer;
begin
   while fSoc.Count > 0 do begin
      c := fSoc.Count;
      s := Wordn(fSoc.ReadLine(#10), #13, 1);
      if (c > 0) and (c = fSoc.Count) and (fCnl = c) then begin
         setlength(s, c);
         fSoc.ReadData(@s[1], c);
         Body := True;
      end;
      if pos('<', s) = 1 then Body := True;
      if Body then fCnt.Add(s)
              else fHdr.Add(s);
      if pos('HTTP/1.', s) = 1 then fCod := str2int(wordn(s, ' ', 2));
      if pos('Content-Length', s) = 1 then
         fCnl := str2int(wordn(s, ' ', 2));
   end;
   if Assigned(fOnClos) then fOnClos(@self);
end;

procedure TKOLhttpControl.OnClos;
begin
   if Assigned(fOnClos) then fOnClos(@self);
end;

procedure TKOLhttpControl.ParseUrl;
var s,
    r: string;
begin
   s := Url;
   if pos('HTTP://', UpSt(s)) = 1 then begin
      s := copy(s, 8, length(s) - 7);
   end;
   r := wordn(s, '@', 1);
   if r <> s then begin
      fUsr := wordn(r, ':', 1);
      fPas := wordn(r, ':', 2);
      s := wordn(s, '@', 2);
   end;
   r := wordn(s, ':', 2);
   if r <> '' then begin
      fPort := str2int(r);
      s := wordn(s, ':', 1);
   end;
   r := wordn(s, '/', 1);
   fAdr := r;
   if fAdr = '' then fAdr := s;
   fRef := copy(s, length(fAdr) + 1, length(s) - length(fAdr));
   if fRef = '' then fRef := '/';
end;

procedure TKOLhttpControl.Prepare;
begin
   Body := False;
   fSoc := NewAsyncSocket;
   ParseUrl;
   fSoc.PortNumber := fPort;
   fSoc.IPAddress  := fAdr;
   if fPAd <> '' then begin
      fSoc.IPAddress  := fPAd;
      fSoc.PortNumber := fPPr;
      fRef := 'http://' + fAdr + fRef;
   end;
   fSoc.OnConnect  := OnConn;
   fSoc.OnRead     := OnRead;
   fSoc.OnError    := OnDumm;
   fSoc.OnClose    := OnClos;
end;

procedure TKOLhttpControl.Get;
begin
   Prepare;
   fMth := 'GET';
   fSoc.DoConnect;
end;

procedure TKOLhttpControl.Get(_Url: string);
begin
   Url := _Url;
   Get;
end;

end.
