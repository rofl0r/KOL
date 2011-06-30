// 22-nov-2002
unit IdURI;

interface

uses
  KOL;

type
  PIdURI=^TIdURI;
  TIdURI = object(TObj)
  protected
    FDocument: string;
    FProtocol: string;
    FURI: string;
    FPort: string;
    Fpath: string;
    FHost: string;
    FBookmark: string;
    procedure SetHost(const Value: string);
    procedure SetDocument(const Value: string);
    procedure SetBookmark(const Value: string);
    procedure Setpath(const Value: string);
    procedure SetPort(const Value: string);
    procedure SetProtocol(const Value: string);
    procedure SetURI(const Value: string);
    procedure Refresh;
  public
{    object (TObj)}procedure NormalizePath(var APath: string);
{    object (TObj)}procedure ParseURI(AURI: string; var AProtocol, AHost, Apath, ADocument,
      APort, ABookmark: string);
     { constructor Create(const AURI: string = ''); virtual;   }
    property Protocol: string read FProtocol write SetProtocol;
    property Path: string read Fpath write Setpath;
    property Host: string read FHost write SetHost;
    property Document: string read FDocument write SetDocument;
    property Port: string read FPort write SetPort;
    property URI: string read FURI write SetURI;
    property Bookmark: string read FBookmark write SetBookmark;
  end;

  function NewIdURI(const AURI: string = ''):PIdURI;

implementation

uses
  IdGlobal, IdResourceStrings,
  SysUtils;

function NewIdURI(const AURI: string = ''):PIdURI;
begin
  New( Result, Create );
  with Result^ do
  begin
  if length(AURI) > 0 then
  begin
    URI := AURI;
  end;
  end;
end;

{class }procedure TIdURI.NormalizePath(var APath: string);
var
  i: Integer;
begin
  //// ???????????????????????????
  i := 1;
  while i <= Length(APath) do
  begin
    if APath[i] in LeadBytes then
    begin
      inc(i, 2)
    end
    else
      if APath[i] = '\' then
    begin
      APath[i] := '/';
      inc(i, 1);
    end
    else
    begin
      inc(i, 1);
    end;
  end;
end;

{class }procedure TIdURI.ParseURI(AURI: string; var AProtocol, AHost, Apath, ADocument,
  APort, ABookmark: string);
var
  sBuffer: string;
  iTokenPos: Integer;
begin
  //// ????????????????????????????????????
  AHost := '';
  AProtocol := '';
  APath := '';
  ADocument := '';
  NormalizePath(AURI);
  if IndyPos('://', AURI) > 0 then
  begin
    iTokenPos := IndyPos('://', AURI);
    AProtocol := Copy(AURI, 1, iTokenPos - 1);
    Delete(AURI, 1, iTokenPos + 2);
    sBuffer := fetch(AURI, '/', true);
    AHost := fetch(sBuffer, ':', true);
    APort := sBuffer;
    iTokenPos := RPos('/', AURI, -1);
    APath := Copy(AURI, 1, iTokenPos);
    Delete(AURI, 1, iTokenPos);
    ADocument := AURI;
  end
  else
  begin
    iTokenPos := RPos('/', AURI, -1);
    APath := Copy(AURI, 1, iTokenPos);
    Delete(AURI, 1, iTokenPos);
    ADocument := AURI;
  end;

  if Copy(APath, 1, 1) <> '/' then
  begin
    APath := '/' + APath;
  end;
  sBuffer := Fetch(ADocument, '#');
  ABookmark := ADocument;
  ADocument := sBuffer;
end;

procedure TIdURI.Refresh;
begin
  FURI := FProtocol + '://' + FHost;
  if Length(FPort) > 0 then
    FURI := FURI + ':' + FPort;
  FURI := FURI + FPath + FDocument;
  if Length(FBookmark) > 0 then
    FURI := FURI + '#' + FBookmark;
end;

procedure TIdURI.SetBookmark(const Value: string);
begin
  FBookmark := Value;
  Refresh;
end;

procedure TIdURI.SetDocument(const Value: string);
begin
  FDocument := Value;
  Refresh;
end;

procedure TIdURI.SetHost(const Value: string);
begin
  FHost := Value;
  Refresh;
end;

procedure TIdURI.Setpath(const Value: string);
begin
  Fpath := Value;
  Refresh;
end;

procedure TIdURI.SetPort(const Value: string);
begin
  FPort := Value;
  Refresh;
end;

procedure TIdURI.SetProtocol(const Value: string);
begin
  FProtocol := Value;
  Refresh;
end;

procedure TIdURI.SetURI(const Value: string);
begin
  FURI := Value;
  NormalizePath(FURI);
  ParseURI(FURI, FProtocol, FHost, FPath, FDocument, FPort, FBookmark);
end;

end.
