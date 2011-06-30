unit mckHTTP;

interface

uses
  Windows, Classes, Messages, Forms, SysUtils,
  KOLRAS, mirror, KOL, KOLHTTP;

type

  PKOLHttp =^TKOLHttp; 
  TKOLHttp = class(TKOLObj)
  private

    fUserName: string;
    fUserPass: string;
    fHostAddr: string;
    fHostPort: string;
    fProxyAdr: string;
    fProxyPrt: string;

    fOnHttpClo: TOnEvent;

  public

    constructor Create(Owner: TComponent); override;

  protected

    function  AdditionalUnits: string; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;

    procedure SetUserName(Value: string);
    procedure SetUserPass(Value: string);
    procedure SetHostAddr(Value: string);
    procedure SetHostPort(Value: string);
    procedure SetProxyAdr(Value: string);
    procedure SetProxyPrt(Value: string);

    procedure SetOnHttpClo(Value: TOnEvent);

  published

    property  UserName : string read fUserName write SetUserName;
    property  Password : string read fUserPass write SetUserPass;
    property  Url      : string read fHostAddr write SetHostAddr;
    property  Port     : string read fHostPort write SetHostPort;
    property  ProxyAddr: string read fProxyAdr write SetProxyAdr;
    property  ProxyPort: string read fProxyPrt write SetProxyPrt;

    property  OnClose  : TOnEvent read fOnHttpClo write SetOnHttpClo;

  end;

  procedure Register;

implementation

{$R *.dcr}

constructor TKOLHttp.create;
begin
   inherited create(Owner);
   fHostPort := '80';
end;

procedure TKOLHttp.SetUserName;
begin
   fUserName := Value;
   Change;
end;

procedure TKOLHttp.SetUserPass;
begin
   fUserPass := Value;
   Change;
end;

procedure TKOLHttp.SetHostAddr;
begin
   fHostAddr := Value;
   Change;
end;

procedure TKOLHttp.SetHostPort;
begin
   fHostPort := Value;
   Change;
end;

procedure TKOLHttp.SetProxyAdr;
begin
   fProxyAdr := Value;
   Change;
end;

procedure TKOLHttp.SetProxyPrt;
begin
   fProxyPrt := Value;
   Change;
end;

procedure TKOLHttp.SetOnHttpClo;
begin
   fOnHttpClo := Value;
   Change;
end;

function  TKOLHttp.AdditionalUnits;
begin
   Result := ', KOLHttp';
end;

procedure TKOLHttp.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
begin
  SL.Add( Prefix + AName + ' := NewKOLHttpControl;' );
  if fUserName <> '' then
  SL.Add( Prefix + AName + '.UserName  := ''' + fUserName + ''';');
  if fUserPass <> '' then
  SL.Add( Prefix + AName + '.Password  := ''' + fUserPass + ''';');
  if fHostAddr <> '' then
  SL.Add( Prefix + AName + '.Url       := ''' + fHostAddr + ''';');
  if fHostPort <> '80' then
  SL.Add( Prefix + AName + '.HostPort  := '   + fHostPort + ';');
  if fProxyAdr <> '' then
  SL.Add( Prefix + AName + '.ProxyAddr := ''' + fProxyAdr + ''';');
  if fProxyPrt <> '' then
  SL.Add( Prefix + AName + '.ProxyPort := '   + fProxyPrt + ';');
end;

procedure TKOLHttp.SetupLast(SL: TStringList; const AName,
  AParent, Prefix: String);
begin
   //
end;

procedure TKOLHttp.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName,
  [ 'OnClose' ],
  [ @OnClose  ]);
end;

procedure Register;
begin
  RegisterComponents('KOLUtil', [TKOLHttp]);
end;

end.

