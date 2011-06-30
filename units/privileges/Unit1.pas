{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, FormSave {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, mckCtrls,
  mckFormSave {$ENDIF};
{$ELSE}
{$I uses.inc} mirror, 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  PSvForm = ^TSvForm;
  TSvForm = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TSvForm = class(TForm)
  {$ENDIF KOL_MCK}
    KP: TKOLProject;
    KF: TKOLForm;
    P1: TKOLPanel;
    P2: TKOLPanel;
    LB1: TKOLListBox;
    LBG: TKOLListBox;
    SP: TKOLSplitter;
    LB2: TKOLListBox;
    LB3: TKOLListBox;
    B2: TKOLButton;
    B1: TKOLButton;
    FS: TKOLFormSave;
    procedure KFResize(Sender: PObj);
    procedure WMHK(var Msg: TMessage); {message WM_HOTKEY;}
    procedure B1Click(Sender: PObj);
    procedure B2Click(Sender: PObj);
    procedure FormCreate(Sender: PObj);
    procedure LB1Click(Sender: PObj);
    procedure LBGEnter(Sender: PObj);
    procedure LB2Enter(Sender: PObj);
    procedure FormDestroy(Sender: PObj);
    procedure LB1KeyDown(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
  private
    { Private declarations }
    procedure Refresh;
    procedure Refreshu(U: String);
    procedure Refreshg(G: String);
    function  LBindexof(LB: PControl; s: string): integer;
  public
    Aa: integer;
    { Public declarations }
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  Privil: array[1..28] of string = (
          'SeAssignPrimaryTokenPrivilege',
          'SeAuditPrivilege',
          'SeBackupPrivilege',
          'SeBatchLogonRight',
          'SeChangeNotifyPrivilege',
          'SeCreatePagefilePrivilege',
          'SeCreatePermanentPrivilege',
          'SeCreateTokenPrivilege',
          'SeDebugPrivilege',
          'SeIncreaseBasePriorityPrivilege',
          'SeIncreaseQuotaPrivilege',
          'SeInteractiveLogonRight',
          'SeLoadDriverPrivilege',
          'SeLockMemoryPrivilege',
          'SeMachineAccountPrivilege',
          'SeNetworkLogonRight',
          'SeProfileSingleProcessPrivilege',
          'SeRemoteShutdownPrivilege',
          'SeRestorePrivilege',
          'SeSecurityPrivilege',
          'SeServiceLogonRight',
          'SeShutdownPrivilege',
          'SeSystemEnvironmentPrivilege',
          'SeSystemProfilePrivilege',
          'SeSystemtimePrivilege',
          'SeTakeOwnershipPrivilege',
          'SeTcbPrivilege',
          'SeUndockPrivilege');

var
  SvForm {$IFDEF KOL_MCK} : PSvForm {$ELSE} : TSvForm {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewSvForm( var Result: PSvForm; AParent: PControl );
{$ENDIF}

implementation

uses LSAApi;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TSvForm.KFResize(Sender: PObj);
begin
   if P1 = nil then exit;
   if P2 = nil then exit;
   LBG.Height := P1.Height div 2;
   LB2.width  := P2.width div 2;
end;

procedure TSVForm.WMHK;
begin
   Form.Show;
end;

{$R *.DFM}

function NetLocalGroupAddMembers(Server:PWideChar;GroupName:PWideChar;Level:DWORD;MembersID:Pointer;Count:DWORD):LongInt; stdcall; external 'netapi32.dll' name 'NetLocalGroupAddMembers';
function NetLocalGroupDelMembers(Server:PWideChar;GroupName:PWideChar;Level:DWORD;MembersID:Pointer;Count:DWORD):LongInt; stdcall; external 'netapi32.dll' name 'NetLocalGroupDelMember';
{function NetGroupAddUser(ServerName:PWideChar;GroupName:PWideChar;UserName:PWideChar):LongInt; stdcall; external 'netapi32.dll' name 'NetGroupAddUser';}

procedure TSvForm.B1Click(Sender: PObj);
type
   mi = record
           sid: PSid;
        end;
var
   oa: TLsaObjectAttributes;
   ph: Lsa_Handle;
   ns: NTSTATUS;
   sd: PSid;
   us: TLsaUnicodeString;
   up,
   gp: array[0..255] of WideChar;
   ss: String;
   pc: PChar;
   sl: array[0..1] of mi;
   Si: TSid;
begin
if LB2.CurIndex > -1 then begin
   fillchar(oa, sizeof(oa), 0);
   ns := 0;
   ph := nil;
   ns := lsaopenpolicy(nil,
                       oa,
                       POLICY_ALL_ACCESS,
                       ph);
   if integer(ph) <> 0 then begin
      sd := getaccountsid(lb1.Items[lb1.CurIndex], Si);
      ss := lb2.Items[lb2.CurIndex];
      StringToWideChar(ss, @up, 255);
      us.Length := length(ss) * sizeof(WideChar);
      us.MaximumLength := 510;
      us.Buffer := @up;
      ns := LsaRemoveAccountRights(ph,
                                   sd,
                                   False,
                                   @us,
                                   1);
      LsaClose(ph);
      Refresh;
   end;
end else
if LBG.CurIndex > -1 then begin
   sd := getaccountsid(lb1.Items[lb1.curindex], si);
   ss := getaccountname(sd);
   ss := lbg.Items[lbg.CurIndex];
   StringToWideChar(ss, @gp, 255);
   sl[0].sid := sd;
   ns := NetLocalGroupAddMembers(
                       nil,
                       @gp,
                       0,
                       @sl,
                       1);
   if ns = STATUS_SUCCESS then begin
      refresh;
   end else begin
      FormatMessage( FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM,
                     nil,
                     ns,
                     LANG_NEUTRAL,
                    @pc,
                     0,
                     nil );
      MsgOK(pc);
      LocalFree(Cardinal(pc));
   end;
end;
end;

procedure TSvForm.B2Click(Sender: PObj);
type
   mi = record
           sid: PSid;
        end;
var
   oa: TLsaObjectAttributes;
   ph: Lsa_Handle;
   ns: NTSTATUS;
   sd: PSid;
   us: TLsaUnicodeString;
   up: array[0..255] of WideChar;
   ss: String;
   ii: integer;
   pc: pchar;
   sl: array[0..1] of mi;
   si: TSid;
begin
if lb3.curindex > -1 then begin
   fillchar(oa, sizeof(oa), 0);
   ns := 0;
   ph := nil;
   ns := lsaopenpolicy(nil,
                       oa,
                       POLICY_ALL_ACCESS,
                       ph);
   if (ns = 0) and (integer(ph) <> 0) then begin
      sd := getaccountsid(lb1.Items[lb1.CurIndex], si);
      if getaccountname(sd) = lb1.Items[lb1.CurIndex] then begin
      if lb3.CurIndex > -1 then begin
         ss := lb3.Items[lb3.CurIndex];
         StringToWideChar(ss, @up, 255);
         us.Length := length(ss) * sizeof(WideChar);
         us.MaximumLength := us.Length + sizeof(WideChar);
         us.Buffer := @up;
         ns := LsaAddAccountRights(ph,
                                   sd,
                                   @us,
                                   1);
         if ns <> STATUS_SUCCESS then begin
            ns := LsaNtStatusToWinError(ns);
            FormatMessage( FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM,
                           nil,
                           ns,
                           LANG_NEUTRAL,
                          @pc,
                           0,
                           nil );
            MsgOK(pc);
            LocalFree(Cardinal(pc));
         end;
      end;
      end;
      LsaClose(ph);
      Refresh;
   end;
end else
if lb2.CurIndex > - 1 then begin
   ss := lb2.items[lb2.CurIndex];
   if ss[1] = ' ' then begin
      StringToWideChar(Trim(ss), @up, 255);
      sd := getaccountsid(lb1.Items[lb1.CurIndex], si);
      sl[0].sid := sd;
      ns := NetLocalGroupDelMembers(
                          nil,
                         @up,
                          0,
                         @sl,
                          1);
      if ns = STATUS_SUCCESS then begin
         refresh;
      end else begin
         FormatMessage( FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM,
                        nil,
                        ns,
                        LANG_NEUTRAL,
                       @pc,
                        0,
                        nil );
         MsgOK(pc);
         LocalFree(Cardinal(pc));
      end;
   end;
end;
end;

function NetUserEnum(Server:PWideChar;Level:DWORD;Filter:DWORD;BufPtr:Pointer;PrefMaxLen:DWORD;EntriesRead:LPDWORD;TotalEntries:LPDWORD;ResumeHandle:LPDWORD):LongInt; stdcall; external 'netapi32.dll' name 'NetUserEnum';
function NetLocalGroupEnum(Server:PWideChar;Level:DWORD;BufPtr:Pointer;PrefMaxLen:DWORD;EntriesRead:LPDWORD;TotalEntries:LPDWORD;ResumeHandle:LPDWORD):LongInt; stdcall; external 'netapi32.dll' name 'NetLocalGroupEnum';
function NetUserGetGroups(Server:PWideChar;UserName:PWideChar;Level:DWORD;BufPtr:Pointer;PrefMaxLen:DWORD;EntriesRead:LPDWORD;TotalEntries:LPDWORD;ResumeHandle:LPDWORD):LongInt; stdcall; external 'netapi32.dll' name 'NetUserGetGroups';
function NetApiBufferFree(Buffer:Pointer):LongInt; stdcall; external 'netapi32.dll' name 'NetApiBufferFree';

procedure TSvForm.FormCreate(Sender: PObj);
Type USER_INFO_0=record
	usri0_name:LPWSTR;
     End;
     USER_INFO_A = array[1..1] of USER_INFO_0;
var pb:^USER_INFO_A;
    cc,
    tc,
    rs: dword;
    ii: integer;
    ns: dword;
begin
   Aa := globaladdatom('CatcherHotKey'#0);
   registerhotkey(Form.Handle, Aa,
      MOD_ALT or MOD_CONTROL, VK_DOWN);
   rs := 0;
   pb := nil;
   ns :=
   NetUserEnum(nil,
               0,
               0,
               @pb,
               $FFFFFFFF,
               @cc,
               @tc,
               @rs);
   LB1.Clear;
   for ii := 1 to cc do begin
      LB1.Add(pb^[ii].usri0_name);
   end;
   ns := NetApiBufferFree(pb);

   rs := 0;
   pb := nil;
   ns :=
   NetLocalGroupEnum(nil,
               0,
               @pb,
               $FFFFFFFF,
               @cc,
               @tc,
               @rs);
   LBG.Clear;
   for ii := 1 to cc do begin
      LBG.Add(pb^[ii].usri0_name);
   end;
   ns := NetApiBufferFree(pb);
   if LB1.Count > 0 then begin
      LB1.CurIndex := 0;
      refresh;
   end;
   Form.Height  := Form.Height + 1;
   Form.Height  := Form.Height - 1;
   Form.Visible := True;
end;

procedure TSvForm.Refresh;
var ii: integer;
begin
   LB2.Clear;
   LB3.BeginUpdate;
   LB3.Clear;
   for ii := low(privil) to high(privil) do lb3.add(privil[ii]);
   LB3.EndUpdate;
   LB2.Add('   ' + LB1.Items[LB1.CurIndex]);
   Refreshu(LB1.Items[LB1.CurIndex]);
   Refreshg(LB1.Items[LB1.CurIndex]);
end;

procedure TSvForm.LB1KeyDown(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
begin
   refresh;
end;

procedure TSvForm.LB1Click(Sender: PObj);
begin
   Refresh;
end;

function  TSvForm.LBindexof;
begin
   for result := 0 to LB.Count do
      if LB.Items[Result] = s then exit;
   result := -1;
end;

procedure TSvForm.Refreshu;
type
    ca = array[1..1] of TLsaUnicodeString;
var ub: PLsaUnicodeString;
    pa:^ca;
    oa: TLsaObjectAttributes;
    ph: Lsa_Handle;
    ns: NTSTATUS;
    pb: pointer;
    cc: ULong;
    sd: PSid;
    ii: integer;
    id: integer;
    ss: string;
    si: TSid;
begin
   fillchar(oa, sizeof(oa), 0);
   ns := 0;
   ph := nil;
   ns := lsaopenpolicy(nil,
                       oa,
                       $801,
                       ph);
   sd := getaccountsid(U, si);
   if integer(ph) <> 0 then begin
      ns := LsaEnumerateAccountRights(
                          ph,
                          sd,
                          ub,
                          cc);
      pa := pointer(ub);
      Form.caption          := 'wait a moment, please ...';
      lb2.BeginUpdate;
      lb3.BeginUpdate;
      for ii := 1 to cc do begin
         ss := pa[ii].Buffer;
         lb2.Add(ss);
         id := LBIndexOf(lb3, ss);
         if id > -1 then begin
            lb3.Delete(id);
         end;
      end;
      lb2.EndUpdate;
      lb3.EndUpdate;
      Form.caption          := 'KOL_NT_Privileges';
      LsaFreeMemory(ub);
      LsaClose(ph);
   end;
end;

function NetUserGetLocalGroups(Server:PWideChar;UserName:PWideChar;Level:DWORD;Flags:DWORD;BufPtr:Pointer;PrefMaxLen:DWORD;EntriesRead:LPDWORD;TotalEntries:LPDWORD;ResumeHandle:LPDWORD):LongInt; stdcall; external 'netapi32.dll' name 'NetUserGetLocalGroups';

procedure TSvForm.Refreshg;
Type USER_INFO_0=record
	usri0_name:LPWSTR;
     End;
     USER_INFO_A = array[1..1] of USER_INFO_0;
var pb:^USER_INFO_A;
    cc,
    tc,
    rs: dword;
    ii: integer;
    nr: dword;
    wa: array[0..255] of WideChar;
begin
   rs := 0;
   pb := nil;
   StringToWideChar(G, @wa, 255);
   nr :=
   NetUserGetLocalGroups(nil,
               @wa,
               0,
               0,
               @pb,
               $FFFFFFFF,
               @cc,
               @tc,
               @rs);
   for ii := 1 to cc do begin
      LB2.Add('   ' + pb^[ii].usri0_name);
      refreshu(pb^[ii].usri0_name);
   end;
   nr := NetApiBufferFree(pb);
end;

procedure TSvForm.LBGEnter(Sender: PObj);
begin
   LB2.CurIndex := -1;
end;

procedure TSvForm.LB2Enter(Sender: PObj);
begin
   LBG.CurIndex := -1;
end;

procedure TSvForm.FormDestroy(Sender: PObj);
begin
   globaldeleteatom(Aa);
   UnregisterHotKey(Form.Handle, Aa);
end;

end.





