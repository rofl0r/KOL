{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit MainControlKOLService;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Controls, mckObjs, mckCtrls, Classes {$ENDIF},
     Service;
{$ELSE}
{$I uses.inc} mirror,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror;
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
    fmControlKOLService: TKOLForm;
    Label1: TKOLLabel;
    btnInstall: TKOLButton;
    btnStart: TKOLButton;
    btnStop: TKOLButton;
    btnPause: TKOLButton;
    btnResume: TKOLButton;
    btnRemove: TKOLButton;
    Label2: TKOLLabel;
    Timer1: TKOLTimer;
    Label3: TKOLLabel;
    Button1: TKOLButton;
    Button2: TKOLButton;
    Button3: TKOLButton;
    Button4: TKOLButton;
    Button5: TKOLButton;
    Button6: TKOLButton;
    Label4: TKOLLabel;
    procedure btnInstallClick(Sender: PObj);
    procedure Button1Click(Sender: PObj);
    procedure btnStartClick(Sender: PObj);
    procedure Button2Click(Sender: PObj);
    procedure btnStopClick(Sender: PObj);
    procedure Button3Click(Sender: PObj);
    procedure btnPauseClick(Sender: PObj);
    procedure Button4Click(Sender: PObj);
    procedure btnResumeClick(Sender: PObj);
    procedure Button5Click(Sender: PObj);
    procedure btnRemoveClick(Sender: PObj);
    procedure Button6Click(Sender: PObj);
    procedure fmControlKOLServiceFormCreate(Sender: PObj);
    function fmControlKOLServiceMessage(var Msg: tagMSG;
      var Rslt: Integer): Boolean;
    procedure Timer1Timer(Sender: PObj);
  private
    { Private declarations }
    procedure RefreshStatus;
    procedure DoRefreshStatus;
    function BadHandles( SrvCtl: PServiceCtl ): Boolean;
  public
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I MainControlKOLService_1.inc}
{$ENDIF}

procedure TForm1.DoRefreshStatus;
var SrvCtl: PServiceCtl;
    E_Inst, E_Remv, E_Strt, E_Stop, E_Paus, E_Resm: Boolean;
begin
  E_Inst := FALSE;
  E_Remv := FALSE;
  E_Strt := FALSE;
  E_Stop := FALSE;
  E_Paus := FALSE;
  E_Resm := FALSE;
  SrvCtl := OpenServiceCtl( '', '', 'KOL_ServiceA', SERVICE_QUERY_STATUS );
  if SrvCtl.Handle = 0 then
  begin
    Label1.Caption := 'Not installed';
    E_Inst := TRUE;
  end
    else
  case SrvCtl.Status.dwCurrentState of
  SERVICE_STOPPED:         begin
                             Label1.Caption := 'Stopped';
                             E_Strt := TRUE;
                             E_Remv := TRUE;
                           end;
  SERVICE_START_PENDING:   begin
                             Label1.Caption := 'Starting...';
                             E_Stop := TRUE;
                             E_Remv := TRUE;
                           end;
  SERVICE_STOP_PENDING:    begin
                             Label1.Caption := 'Stopping...';
                             E_Remv := TRUE;
                           end;
  SERVICE_RUNNING:         begin
                             Label1.Caption := 'RUNNING';
                             E_Stop := TRUE;
                             E_Paus := TRUE;
                             E_Remv := TRUE;
                           end;
  SERVICE_CONTINUE_PENDING:begin
                             Label1.Caption := 'Resuming...';
                             E_Stop := TRUE;
                             E_Remv := TRUE;
                           end;
  SERVICE_PAUSE_PENDING:   begin
                             Label1.Caption := 'Pausing...';
                             E_Remv := TRUE;
                           end;
  SERVICE_PAUSED:          begin
                             Label1.Caption := 'Paused';
                             E_Resm := TRUE;
                             E_Stop := TRUE;
                             E_Remv := TRUE;
                           end;
  end;
  btnInstall.Enabled := E_Inst;
  btnRemove .Enabled := E_Remv;
  btnStart  .Enabled := E_Strt;
  btnStop   .Enabled := E_Stop;
  btnPause  .Enabled := E_Paus;
  btnResume .Enabled := E_Resm;
  SrvCtl.Free;

  E_Inst := FALSE;
  E_Remv := FALSE;
  E_Strt := FALSE;
  E_Stop := FALSE;
  E_Paus := FALSE;
  E_Resm := FALSE;
  SrvCtl := OpenServiceCtl( '', '', 'KOL_ServiceB', SERVICE_QUERY_STATUS );
  if SrvCtl.Handle = 0 then
  begin
    Label3.Caption := 'Not installed';
    E_Inst := TRUE;
  end
    else
  case SrvCtl.Status.dwCurrentState of
  SERVICE_STOPPED:         begin
                             Label3.Caption := 'Stopped';
                             E_Strt := TRUE;
                             E_Remv := TRUE;
                           end;
  SERVICE_START_PENDING:   begin
                             Label3.Caption := 'Starting...';
                             E_Stop := TRUE;
                             E_Remv := TRUE;
                           end;
  SERVICE_STOP_PENDING:    begin
                             Label3.Caption := 'Stopping...';
                             E_Remv := TRUE;
                           end;
  SERVICE_RUNNING:         begin
                             Label3.Caption := 'RUNNING';
                             E_Stop := TRUE;
                             E_Paus := TRUE;
                             E_Remv := TRUE;
                           end;
  SERVICE_CONTINUE_PENDING:begin
                             Label3.Caption := 'Resuming...';
                             E_Stop := TRUE;
                             E_Remv := TRUE;
                           end;
  SERVICE_PAUSE_PENDING:   begin
                             Label3.Caption := 'Pausing...';
                             E_Remv := TRUE;
                           end;
  SERVICE_PAUSED:          begin
                             Label3.Caption := 'Paused';
                             E_Resm := TRUE;
                             E_Stop := TRUE;
                             E_Remv := TRUE;
                           end;
  end;
  Button1   .Enabled := E_Inst;
  Button6   .Enabled := E_Remv;
  Button2   .Enabled := E_Strt;
  Button3   .Enabled := E_Stop;
  Button4   .Enabled := E_Paus;
  Button5   .Enabled := E_Resm;
  SrvCtl.Free;
end;

procedure TForm1.btnInstallClick(Sender: PObj);
var SrvCtl: PServiceCtl;
begin
    SrvCtl := NewServiceCtl( '',
                             '',
                             'KOL_ServiceA',
                             'KOL_ServiceA',
                             GetStartDir + 'TestKOLService.exe',
                             '',
                             '',
                             '',
                             '',
                             SERVICE_ALL_ACCESS,
                             SERVICE_WIN32_OWN_PROCESS or
                             SERVICE_INTERACTIVE_PROCESS,
                             SERVICE_DEMAND_START,
                             SERVICE_ERROR_NORMAL );
    if BadHandles( SrvCtl ) then Exit;
    SrvCtl.Free;
    RefreshStatus;
    ShowMessage( 'Installed OK.' );
end;

procedure TForm1.Button1Click(Sender: PObj);
var SrvCtl: PServiceCtl;
begin
    SrvCtl := NewServiceCtl( '',
                             '',
                             'KOL_ServiceB',
                             'KOL_ServiceB',
                             GetStartDir + 'TestKOLService.exe',
                             '',
                             '',
                             '',
                             '',
                             SERVICE_ALL_ACCESS,
                             SERVICE_WIN32_OWN_PROCESS or
                             SERVICE_INTERACTIVE_PROCESS,
                             SERVICE_DEMAND_START,
                             SERVICE_ERROR_NORMAL );
    if BadHandles( SrvCtl ) then Exit;
    SrvCtl.Free;
    RefreshStatus;
    ShowMessage( 'Installed OK.' );
end;

procedure TForm1.btnStartClick(Sender: PObj);
var SrvCtl: PServiceCtl;
    OK: Boolean;
begin
    SrvCtl := OpenServiceCtl( '', '', 'KOL_ServiceA', SERVICE_ALL_ACCESS );
    if BadHandles( SrvCtl ) then Exit;
    OK := SrvCtl.Start( [ 'param1', 'param2', 'param3' ] );
    SrvCtl.Free;
    if not OK then
      ShowMessage( SysErrorMessage( GetLastError ) );
    RefreshStatus;
end;

procedure TForm1.Button2Click(Sender: PObj);
var SrvCtl: PServiceCtl;
    OK: Boolean;
begin
    SrvCtl := OpenServiceCtl( '', '', 'KOL_ServiceB', SERVICE_ALL_ACCESS );
    if BadHandles( SrvCtl ) then Exit;
    OK := SrvCtl.Start( [ 'param1', 'param2', 'param3' ] );
    SrvCtl.Free;
    if not OK then
      ShowMessage( SysErrorMessage( GetLastError ) );
    RefreshStatus;
end;

function TForm1.BadHandles(SrvCtl: PServiceCtl): Boolean;
begin
  Result := FALSE;
  if SrvCtl.SCHandle = 0 then
  begin
    ShowMessage( 'Can not obtain SCHandle, ' + SysErrorMessage( GetLastError ) );
    SrvCtl.Free;
    Result := TRUE;
    Exit;
  end;
  if SrvCtl.Handle = 0 then
  begin
    ShowMessage( 'Can not obtain service handle, ' + SysErrorMessage( GetLastError ) );
    SrvCtl.Free;
    Result := TRUE;
    Exit;
  end;
end;

procedure TForm1.btnStopClick(Sender: PObj);
var SrvCtl: PServiceCtl;
    OK: Boolean;
begin
    SrvCtl := OpenServiceCtl( '', '', 'KOL_ServiceA', SERVICE_ALL_ACCESS );
    if BadHandles( SrvCtl ) then Exit;
    OK := SrvCtl.Stop;
    SrvCtl.Free;
    if not OK then
      ShowMessage( SysErrorMessage( GetLastError ) );
    RefreshStatus;
end;

procedure TForm1.Button3Click(Sender: PObj);
var SrvCtl: PServiceCtl;
    OK: Boolean;
begin
    SrvCtl := OpenServiceCtl( '', '', 'KOL_ServiceB', SERVICE_ALL_ACCESS );
    if BadHandles( SrvCtl ) then Exit;
    OK := SrvCtl.Stop;
    SrvCtl.Free;
    if not OK then
      ShowMessage( SysErrorMessage( GetLastError ) );
    RefreshStatus;
end;

procedure TForm1.btnPauseClick(Sender: PObj);
var SrvCtl: PServiceCtl;
    OK: Boolean;
begin
    SrvCtl := OpenServiceCtl( '', '', 'KOL_ServiceA', SERVICE_ALL_ACCESS );
    if BadHandles( SrvCtl ) then Exit;
    OK := SrvCtl.Pause;
    SrvCtl.Free;
    if not OK then
      ShowMessage( SysErrorMessage( GetLastError ) );
    RefreshStatus;
end;

procedure TForm1.Button4Click(Sender: PObj);
var SrvCtl: PServiceCtl;
    OK: Boolean;
begin
    SrvCtl := OpenServiceCtl( '', '', 'KOL_ServiceB', SERVICE_ALL_ACCESS );
    if BadHandles( SrvCtl ) then Exit;
    OK := SrvCtl.Pause;
    SrvCtl.Free;
    if not OK then
      ShowMessage( SysErrorMessage( GetLastError ) );
    RefreshStatus;
end;

procedure TForm1.btnResumeClick(Sender: PObj);
var SrvCtl: PServiceCtl;
    OK: Boolean;
begin
    SrvCtl := OpenServiceCtl( '', '', 'KOL_ServiceA', SERVICE_ALL_ACCESS );
    if BadHandles( SrvCtl ) then Exit;
    OK := SrvCtl.Resume;
    SrvCtl.Free;
    if not OK then
      ShowMessage( SysErrorMessage( GetLastError ) );
    RefreshStatus;
end;

procedure TForm1.Button5Click(Sender: PObj);
var SrvCtl: PServiceCtl;
    OK: Boolean;
begin
    SrvCtl := OpenServiceCtl( '', '', 'KOL_ServiceB', SERVICE_ALL_ACCESS );
    if BadHandles( SrvCtl ) then Exit;
    OK := SrvCtl.Resume;
    SrvCtl.Free;
    if not OK then
      ShowMessage( SysErrorMessage( GetLastError ) );
    RefreshStatus;
end;

procedure TForm1.btnRemoveClick(Sender: PObj);
var SrvCtl: PServiceCtl;
    OK: Boolean;
    Count: Integer;
begin
  SrvCtl := OpenServiceCtl( '', '', 'KOL_ServiceA', SERVICE_ALL_ACCESS );
  if BadHandles( SrvCtl ) then Exit;
  SrvCtl.Stop;
  Count := 30; // wait 3 seconds
  while SrvCtl.Status.dwCurrentState = SERVICE_STOP_PENDING do
  begin
    Sleep( 100 );
    Dec( Count );
    if Count = 0 then break;
  end;
  //if SrvCtl.Status.dwCurrentState = SERVICE_STOPPED then
  OK := SrvCtl.Delete;
  SrvCtl.Free;
  if not OK then
    ShowMessage( SysErrorMessage( GetLastError ) );
  RefreshStatus;
end;

procedure TForm1.Button6Click(Sender: PObj);
var SrvCtl: PServiceCtl;
    OK: Boolean;
    Count: Integer;
begin
  SrvCtl := OpenServiceCtl( '', '', 'KOL_ServiceB', SERVICE_ALL_ACCESS );
  if BadHandles( SrvCtl ) then Exit;
  SrvCtl.Stop;
  Count := 30; // wait 3 seconds
  while SrvCtl.Status.dwCurrentState = SERVICE_STOP_PENDING do
  begin
    Sleep( 100 );
    Dec( Count );
    if Count = 0 then break;
  end;
  //if SrvCtl.Status.dwCurrentState = SERVICE_STOPPED then
  OK := SrvCtl.Delete;
  SrvCtl.Free;
  if not OK then
    ShowMessage( SysErrorMessage( GetLastError ) );
  RefreshStatus;
end;

procedure TForm1.fmControlKOLServiceFormCreate(Sender: PObj);
begin
  RefreshStatus;
end;

procedure TForm1.RefreshStatus;
begin
  Form.CreateWindow;
  PostMessage( Form.Handle, WM_USER, 0, 0 );
end;

function TForm1.fmControlKOLServiceMessage(var Msg: tagMSG;
  var Rslt: Integer): Boolean;
begin
  if Msg.message = WM_USER then
    DoRefreshStatus;
  Result := FALSE;
end;

procedure TForm1.Timer1Timer(Sender: PObj);
begin
  DoRefreshStatus;
end;

end.


