unit mckTCPSocket;

interface

uses
  Windows, Classes, Messages, Winsock, Forms, SysUtils, kolTCPSocket, mirror;

type
  TKOLTCPClient = class(TKOLObj)
  private
    FPort: smallint;
    FHost: string;
    FOnConnect: TOnTCPConnect;
    FOnDisconnect: TOnTCPDisconnect;
    FOnError: TOnTCPError;
    FOnReceive: TOnTCPReceive;
//    FOnResolve: TOnTCPResolve;
    FOnManualReceive: TOnTCPManualReceive;
    FOnStreamReceive: TOnTCPStreamReceive;
    FOnStreamSend: TOnTCPStreamSend;
    procedure SetHost(const Value: string);
    procedure SetOnConnect(const Value: TOnTCPConnect);
    procedure SetOnDisconnect(const Value: TOnTCPDisconnect);
    procedure SetOnError(const Value: TOnTCPError);
    procedure SetOnReceive(const Value: TOnTCPReceive);
//    procedure SetOnResolve(const Value: TOnTCPResolve);
    procedure SetPort(const Value: smallint);
    procedure SetOnManualReceive(const Value: TOnTCPManualReceive);
    procedure SetOnStreamReceive(const Value: TOnTCPStreamReceive);
    procedure SetOnStreamSend(const Value: TOnTCPStreamSend);
  protected
    function  AdditionalUnits: string; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
  public
  published
    property Host:string read FHost write SetHost;
    property Port:smallint read FPort write SetPort;
    property OnDisconnect:TOnTCPDisconnect read FOnDisconnect write SetOnDisconnect;
    property OnError:TOnTCPError read FOnError write SetOnError;
    property OnReceive:TOnTCPReceive read FOnReceive write SetOnReceive;
    property OnManualReceive:TOnTCPManualReceive read FOnManualReceive write SetOnManualReceive;
    property OnStreamSend:TOnTCPStreamSend read FOnStreamSend write SetOnStreamSend;
    property OnStreamReceive:TOnTCPStreamReceive read FOnStreamReceive write SetOnStreamReceive;
    property OnConnect:TOnTCPConnect read FOnConnect write SetOnConnect;
  end;

  TKOLTCPServer = class(TKOLObj)
  private
    FPort: smallint;
    FOnClientError: TOnTCPError;
    FOnAccept: TOnTCPAccept;
    FOnError: TOnTCPError;
    FOnConnect: TOnTCPConnect;
    FOnClientReceive: TOnTCPReceive;
    FOnClientConnect: TOnTCPClientConnect;
    FOnClientDisconnect: TOnTCPDisconnect;
    FOnClientManualReceive: TOnTCPManualReceive;
    FOnClientStreamReceive: TOnTCPStreamReceive;
    FOnClientStreamSend: TOnTCPStreamSend;
    procedure SetOnAccept(const Value: TOnTCPAccept);
    procedure SetOnError(const Value: TOnTCPError);
    procedure SetPort(const Value: smallint);
    procedure SetOnConnect(const Value: TOnTCPConnect);
    procedure SetOnClientError(const Value: TOnTCPError);
    procedure SetOnClientReceive(const Value: TOnTCPReceive);
    procedure SetOnClientConnect(const Value: TOnTCPClientConnect);
    procedure SetOnClientDisconnect(const Value: TOnTCPDisconnect);
    procedure SetOnClientManualReceive(const Value: TOnTCPManualReceive);
    procedure SetOnClientStreamReceive(const Value: TOnTCPStreamReceive);
    procedure SetOnClientStreamSend(const Value: TOnTCPStreamSend);
  protected
    function  AdditionalUnits: string; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
  public
  published
    property Port:smallint read FPort write SetPort;
    property OnAccept:TOnTCPAccept read FOnAccept write SetOnAccept;
    property OnError:TOnTCPError read FOnError write SetOnError;
    property OnConnect:TOnTCPConnect read FOnConnect write SetOnConnect;
    property OnClientError:TOnTCPError read FOnClientError write SetOnClientError;
    property OnClientReceive:TOnTCPReceive read FOnClientReceive write SetOnClientReceive;
    property OnClientManualReceive:TOnTCPManualReceive read FOnClientManualReceive write SetOnClientManualReceive;
    property OnClientConnect:TOnTCPClientConnect read FOnClientConnect write SetOnClientConnect;
    property OnClientDisconnect:TOnTCPDisconnect read FOnClientDisconnect write SetOnClientDisconnect;
    property OnClientStreamSend:TOnTCPStreamSend read FOnClientStreamSend write SetOnClientStreamSend;
    property OnClientStreamReceive:TOnTCPStreamReceive read FOnClientStreamReceive write SetOnClientStreamReceive;
  end;

  procedure Register;

implementation

{$R *.dcr}

procedure Register;
begin
  RegisterComponents('KOL', [TKOLTCPClient,TKOLTCPServer]);
end;

{ TKOLTCPClient }

function TKOLTCPClient.AdditionalUnits;
begin
  result:=', kolTCPSocket';
end;

procedure TKOLTCPClient.SetupFirst(SL: TStringList; const AName, AParent, Prefix: String);
begin
  sl.add(prefix+aname+':=newtcpclient;');
  sl.add(prefix+aname+'.port:='+inttostr(fport)+';');
  sl.add(prefix+aname+'.host:='#39+fhost+#39';');
end;

procedure TKOLTCPClient.SetupLast(SL: TStringList; const AName, AParent, Prefix: String);
begin
   //
end;

procedure TKOLTCPClient.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  doassignevents(sl,aname,
    ['OnConnect','OnDisconnect','OnError','OnReceive','OnManualReceive',
     'OnStreamSend','OnStreamReceive'],
    [@OnConnect,@OnDisconnect,@OnError,@OnReceive,@OnManualReceive,
     @OnStreamSend,@OnStreamReceive]);
end;

procedure TKOLTCPClient.SetHost(const Value: string);
begin
  FHost := Value;
  change;
end;

procedure TKOLTCPClient.SetOnConnect(const Value: TOnTCPConnect);
begin
  FOnConnect := Value;
  change;
end;

procedure TKOLTCPClient.SetOnDisconnect(const Value: TOnTCPDisconnect);
begin
  FOnDisconnect := Value;
  change;
end;

procedure TKOLTCPClient.SetOnError(const Value: TOnTCPError);
begin
  FOnError := Value;
  change;
end;

procedure TKOLTCPClient.SetOnReceive(const Value: TOnTCPReceive);
begin
  FOnReceive := Value;
  change;
end;

{procedure TKOLTCPClient.SetOnResolve(const Value: TOnTCPResolve);
begin
  FOnResolve := Value;
  change;
end;
}
procedure TKOLTCPClient.SetPort(const Value: smallint);
begin
  FPort := Value;
  change;
end;

procedure TKOLTCPClient.SetOnManualReceive( const Value: TOnTCPManualReceive);
begin
  FOnManualReceive := Value;
  change;
end;

procedure TKOLTCPClient.SetOnStreamReceive(const Value: TOnTCPStreamReceive);
begin
  FOnStreamReceive := Value;
  change;
end;

procedure TKOLTCPClient.SetOnStreamSend(const Value: TOnTCPStreamSend);
begin
  FOnStreamSend := Value;
  change;
end;

{ TKOLTCPServer }

function TKOLTCPServer.AdditionalUnits: string;
begin
  result:=', kolTCPSocket';
end;

procedure TKOLTCPServer.AssignEvents(SL: TStringList;
  const AName: String);
begin
  inherited;
  doassignevents(sl,aname,
    ['OnConnect','OnAccept','OnError','OnClientError','OnClientConnect','OnClientDisconnect','OnClientReceive',
     'OnClientManualReceive','OnClientStreamSend','OnClientStreamReceive'],
    [@OnConnect,@OnAccept,@OnError,@OnClientError,@OnClientConnect,@OnClientDisconnect,@OnClientReceive,
    @OnClientManualReceive,@OnClientStreamSend,@OnClientStreamReceive]);
end;

procedure TKOLTCPServer.SetOnConnect(const Value: TOnTCPConnect);
begin
  FOnConnect := Value;
  change;
end;

procedure TKOLTCPServer.SetOnAccept(const Value: TOnTCPAccept);
begin
  FOnAccept := Value;
  change;
end;

procedure TKOLTCPServer.SetOnClientConnect( const Value: TOnTCPClientConnect);
begin
  FOnClientConnect := Value;
  change;
end;

procedure TKOLTCPServer.SetOnClientDisconnect( const Value: TOnTCPDisconnect);
begin
  FOnClientDisconnect := Value;
  change;
end;

procedure TKOLTCPServer.SetOnClientError(const Value: TOnTCPError);
begin
  FOnClientError := Value;
  change;
end;

procedure TKOLTCPServer.SetOnClientManualReceive( const Value: TOnTCPManualReceive);
begin
  FOnClientManualReceive := Value;
  change;
end;

procedure TKOLTCPServer.SetOnClientReceive(const Value: TOnTCPReceive);
begin
  FOnClientReceive := Value;
  change;
end;

procedure TKOLTCPServer.SetOnClientStreamReceive( const Value: TOnTCPStreamReceive);
begin
  FOnClientStreamReceive := Value;
  change;
end;

procedure TKOLTCPServer.SetOnClientStreamSend( const Value: TOnTCPStreamSend);
begin
  FOnClientStreamSend := Value;
  change;
end;

procedure TKOLTCPServer.SetOnError(const Value: TOnTCPError);
begin
  FOnError := Value;             
  change;
end;

procedure TKOLTCPServer.SetPort(const Value: smallint);
begin
  FPort := Value;
  change;
end;

procedure TKOLTCPServer.SetupFirst(SL: TStringList; const AName, AParent, Prefix: String);
begin
  sl.add(prefix+aname+':=newtcpserver;');
  sl.add(prefix+aname+'.port:='+inttostr(fport)+';');
end;

procedure TKOLTCPServer.SetupLast(SL: TStringList; const AName, AParent, Prefix: String);
begin
//
end;

end.

