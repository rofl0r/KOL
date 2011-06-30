unit mckFTP;

interface

uses
  Windows, Classes, Messages, Forms, SysUtils,
  KOLRAS, mirror, KOL, KOLFtp;

type

  PKOLFTP =^TKOLFTP; 
  TKOLFTP = class(TKOLObj)
  private

    fUserName: string;
    fUserPass: string;
    fHostAddr: string;
    fHostPort: string;
    flPassive: boolean;
    fSavePath: string;

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
    procedure SetlPassive(Value: boolean);
    procedure SetSavePath(Value: string);

    procedure SetOnFTPSta(Value: TOnEvent);
    procedure SetOnFTPMsg(Value: TLogEvent);
    procedure SetOnFTPCon(Value: TOnEvent);
    procedure SetOnFTPLog(Value: TOnEvent);
    procedure SetOnFTPErr(Value: TOnEvent);
    procedure SetOnFTPDat(Value: TOnEvent);
    procedure SetOnFTPPro(Value: TOnEvent);
    procedure SetOnGetExi(Value: TOnExist);
    procedure SetOnPutExi(Value: TOnExist);
    procedure SetOnFTPDon(Value: TOnEvent);
    procedure SetOnFTPClo(Value: TOnEvent);

  published

    property  UserName: string read fUserName write SetUserName;
    property  UserPass: string read fUserPass write SetUserPass;
    property  HostAddr: string read fHostAddr write SetHostAddr;
    property  HostPort: string read fHostPort write SetHostPort;
    property  Passive: boolean read flPassive write SetlPassive;
    property  SavePath: string read fSavePath write SetSavePath;

    property  OnFTPStatus: TOnEvent read fOnFTPSta write SetOnFTPSta;
    property  OnFTPLogger: TLogEvent read fOnFTPMsg write SetOnFTPMsg;
    property  OnFTPConnect: TOnEvent read fOnFTPCon write SetOnFTPCon;
    property  OnFTPLogin: TOnEvent read fOnFTPLog write SetOnFTPLog;
    property  OnFTPError: TOnEvent read fOnFTPErr write SetOnFTPErr;
    property  OnFTPData : TOnEvent read fOnFTPDat write SetOnFTPDat;
    property  OnProgress: TOnEvent read fOnFTPPro write SetOnFTPPro;
    property  OnGetExist: TOnExist read fOnGetExi write SetOnGetExi;
    property  OnPutExist: TOnExist read fOnPutExi write SetOnPutExi;
    property  OnFileDone: TOnEvent read fOnFTPDon write SetOnFTPDon;
    property  OnFTPClose: TOnEvent read fOnFTPClo write SetOnFTPClo;

  end;

  procedure Register;

implementation

{$R *.dcr}

constructor TKOLFTP.create;
begin
   inherited create(Owner);
   fHostPort := '21';
end;

procedure TKOLFTP.SetUserName;
begin
   fUserName := Value;
   Change;
end;

procedure TKOLFTP.SetUserPass;
begin
   fUserPass := Value;
   Change;
end;

procedure TKOLFTP.SetHostAddr;
begin
   fHostAddr := Value;
   Change;
end;

procedure TKOLFTP.SetHostPort;
begin
   fHostPort := Value;
   Change;
end;

procedure TKOLFTP.SetSavePath;
begin
   fSavePath := Value;
   Change;
end;

procedure TKOLFTP.SetlPassive;
begin
   flPassive := Value;
   Change;
end;

procedure TKOLFTP.SetOnFTPSta;
begin
   fOnFTPSta := Value;
   Change;
end;

procedure TKOLFTP.SetOnFTPMsg;
begin
   fOnFTPMsg := Value;
   Change;
end;

procedure TKOLFTP.SetOnFTPCon;
begin
   fOnFTPCon := Value;
   Change;
end;

procedure TKOLFTP.SetOnFTPLog;
begin
   fOnFTPLog := Value;
   Change;
end;

procedure TKOLFTP.SetOnFTPErr;
begin
   fOnFTPErr := Value;
   Change;
end;

procedure TKOLFTP.SetOnFTPDat;
begin
   fOnFTPDat := Value;
   Change;
end;

procedure TKOLFTP.SetOnFTPPro;
begin
   fOnFTPPro := Value;
   Change;
end;

procedure TKOLFTP.SetOnGetExi;
begin
   fOnGetExi := Value;
   Change;
end;

procedure TKOLFTP.SetOnPutExi;
begin
   fOnPutExi := Value;
   Change;
end;

procedure TKOLFTP.SetOnFTPDon;
begin
   fOnFTPDon := Value;
   Change;
end;

procedure TKOLFTP.SetOnFTPClo;
begin
   fOnFTPClo := Value;
   Change;
end;

function  TKOLFTP.AdditionalUnits;
begin
   Result := ', KOLFtp';
end;

procedure TKOLFTP.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
begin
  SL.Add( Prefix + AName + ' := NewKOLFtpClient;' );
  if fUserName <> '' then
  SL.Add( Prefix + AName + '.UserName := ''' + fUserName + ''';');
  if fUserPass <> '' then
  SL.Add( Prefix + AName + '.UserPass := ''' + fUserPass + ''';');
  if fHostAddr <> '' then
  SL.Add( Prefix + AName + '.HostAddr := ''' + fHostAddr + ''';');
  if fHostPort <> '21' then
  SL.Add( Prefix + AName + '.HostPort := ''' + fHostPort + ''';');
  if fSavePath <> '' then
  SL.Add( Prefix + AName + '.SavePath := ''' + fSavePath + ''';');
  if flPassive       then
  SL.Add( Prefix + AName + '.Passive  := True;');
end;

procedure TKOLFTP.SetupLast(SL: TStringList; const AName,
  AParent, Prefix: String);
begin
   //
end;

procedure TKOLFTP.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName,
  [ 'OnFTPStatus', 'OnFTPLogger', 'OnFTPConnect', 'OnFTPLogin', 'OnFTPError', 'OnFTPData', 'OnProgress', 'OnGetExist', 'OnPutExist', 'OnFileDone', 'OnFTPClose' ],
  [ @OnFTPStatus , @OnFTPLogger , @OnFTPConnect , @OnFTPLogin , @OnFTPError , @OnFTPData , @OnProgress , @OnGetExist , @OnPutExist , @OnFileDone , @OnFTPClose  ]);
end;

procedure Register;
begin
  RegisterComponents('KOLUtil', [TKOLFTP]);
end;

end.

