unit KOLMHFindReplaceDialog;
//  MHFindReplaceDialog Компонент (MHFindReplaceDialog Component)
//  Автор (Author): Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//  Дата создания (Create date): 1-дек(dec)-2001
//  Дата коррекции (Last correction Date): 25-мар(mar)-2003
//  Версия (Version): 0.81
//  EMail: Gandalf@kol.mastak.ru
//  Благодарности (Thanks):
//  Новое в (New in):
//  V0.81
//  [+] Поддержка D7 (D7 Support) [KOLnMCK]
//
//  V0.8
//  [N] Тест версия (Test version) [KOLnMCK]
//
//  Список дел (To-Do list):
//  1. Ассемблер (Asm)
//  2. Оптимизировать (Optimize)
//  3. Подчистить (Clear Stuff)
//  4. События (Events)
//  5. Все API (All API's)
//  6. Несколько диалогов (Multi dialog)

interface

uses
 KOL, Windows, ShellAPI,CommDlg,Messages;

type

{
//  FR_ENABLEHOOK = $00000100;
//  FR_ENABLETEMPLATE = $00000200;
//  FR_ENABLETEMPLATEHANDLE = $00002000;
  }

  TFindReplaceDialogType=(dtFind,dtReplace);

  TFindReplaceDialogOption=(doDown,doWholeWord,doMatchCase,doFindNext,
  doReplace,doReplaceAll,doDialogTerm,doShowHelp,doNoUpDown,doNoMatchCase,
  doNoWholeWord,doHideUpDown,doHideMatchCase,doHideWholeWord);

  TFindReplaceDialogOptions=set of TFindReplaceDialogOption;

  PMHFindReplaceDialog =^TMHFindReplaceDialog;
  TKOLMHFindReplaceDialog = PMHFindReplaceDialog;

  TMHFindReplaceDialog = object(TObj)
  private
    FOldProc: Pointer;
    procedure MessageLoop;
  public
    DialogType:TFindReplaceDialogType;
    ReplaceText:String;
    FindText:String;
    Options:TFindReplaceDialogOptions;
    WndOwner:HWnd;
    function Execute:Boolean;
  end;

function NewMHFindReplaceDialog:PMHFindReplaceDialog;

var
   FindMsg, HelpMsg : UINT ;
   TMsg: tagMSG;
   FRDlgNow : PMHFindReplaceDialog;
   DialogHandle: THandle;

const
  FindReplaceDialogOption2Style:array [TFindReplaceDialogOption] of Integer=(FR_DOWN
  ,FR_WHOLEWORD,FR_MATCHCASE,FR_FINDNEXT,FR_REPLACE,FR_REPLACEALL
  ,FR_DIALOGTERM,FR_SHOWHELP,FR_NOUPDOWN,FR_NOMATCHCASE,FR_NOWHOLEWORD
  ,FR_HIDEUPDOWN,FR_HIDEMATCHCASE,FR_HIDEWHOLEWORD);


implementation

function FindReplaceWndProc(Wnd: HWND; Msg : UINT; WParam, LParam: Longint): Longint; stdcall;
var
//Option: TFindReplaceOption;
  RetFR : TFindReplace;
begin
if Msg = FindMsg then begin
  CopyMemory (@RetFR, Pointer(lParam), SizeOf(RetFR));
//  FRDlgNow.FOptions := [];
{  for Option  := Low(Option) to High(Option) do
    if (RetFR.Flags and FindReplaceFlags[Option]) <> 0 then
       Include(FRDlgNow.FOptions, Option);}

  if (FR_DIALOGTERM and RetFR.Flags) <> 0 then
  begin // Cancel button pressed
     if FRDlgNow.FOldProc <> NIL then
     SetWindowLong (FRDlgNow.WndOwner, GWL_WNDPROC, LongInt (FRDlgNow.FOldProc) );

     FRDlgNow := NIL;
     DialogHandle := 0;
     Result:= 1;
     exit;
  end
  else if (FR_FINDNEXT and RetFR.Flags) <> 0 then
  begin // Find next button pressed
//    if Assigned( FRDlgNow.FOnFind ) then
//      FRDlgNow.FOnFind(FRDlgNow);
  end
  else
  if (RetFR.Flags and (FR_REPLACE or FR_REPLACEALL)) <> 0 then
  begin // Replace or replace all buttons pressed
//    if Assigned( FRDlgNow.FOnReplace ) then
//    FRDlgNow.FOnReplace(FRDlgNow);
  end
end
else if Msg = HelpMsg then
begin  // Help  button pressed
//   if Assigned( FRDlgNow.FOnHelp ) then
//   FRDlgNow.FOnHelp(FRDlgNow);
end
else if Msg = WM_DESTROY then
begin
   if DialogHandle <> 0 then SendMessage(DialogHandle, WM_CLOSE, 0, 0);  ;
   if FRDlgNow.FOldProc <> NIL then
     SetWindowLong (FRDlgNow.WndOwner, GWL_WNDPROC, LongInt (FRDlgNow.FOldProc) );
   DialogHandle := 0;
   FRDlgNow := NIL;
   Result:= 1;
   exit;
end;
Result := CallWindowProc(FRDlgNow.FOldProc, FRDlgNow.WndOwner, Msg, WParam, LParam);
end;
(*

function WndProcMHFindDialog( Control: PControl; var Msg: TMsg; var Rslt: Integer ) : Boolean;
begin
  Result:=False;
  if Msg.message=uFindReplaceMsg then
  begin
//    if Assigned( MHFontDialogNow.FOnHelp ) then
//      MHFontDialogNow.FOnHelp( @MHFontDialogNow);
    Rslt:=0;
    Result:=True;
  end;
end;  *)

function NewMHFindReplaceDialog:PMHFindReplaceDialog;
begin
  New(Result, Create);
//  Result.Owner:=AOwner;
//  Wnd.AttachProc(WndProcMHFindDialog);
end;
(*

function MHKOLFindDialogHook(Wnd: HWnd; Msg: UINT; WParam: WPARAM; LParam: LPARAM): UINT; stdcall;
const
  IDCOLORCMB = $473;
var
  TMPLogFont:TLogFont;
  i:Integer;
begin
  Result:=1;
  if Msg=uFindReplaceMsg then
  begin
    Result:=0;
  end;
  case Msg of
    WM_INITDIALOG:
    begin
      Result:=1;
    end;
  end; // case
//  Result:=1;

{  case Msg of
    WM_INITDIALOG: MHFontDialogNow.Handle:=Wnd;

    WM_COMMAND:
    begin
      if (HiWord(wParam)=BN_CLICKED) and (LoWord(wParam)=IDAPPLYBTN) then
      begin

        SendMessage(Wnd, WM_CHOOSEFONT_GETLOGFONT, 0, LongInt(@TMPLogFont));
        I := SendDlgItemMessage(Wnd, IDCOLORCMB, CB_GETCURSEL, 0, 0);

        if I <> CB_ERR then
          MHFontDialogNow.Font.Color:=SendDlgItemMessage(Wnd, IDCOLORCMB, CB_GETITEMDATA, I, 0)
        else
          MHFontDialogNow.Font.Color:=0;
        MHFontDialogNow.Font.FontHeight:=TMPLogFont.lfHeight;
        MHFontDialogNow.Font.FontWidth:=TMPLogFont.lfWidth;
        MHFontDialogNow.Font.FontOrientation:=TMPLogFont.lfOrientation;
        MHFontDialogNow.Font.FontWeight:=TMPLogFont.lfWeight;
        MHFontDialogNow.Font.FontCharSet:=TMPLogFont.lfCharSet;
        MHFontDialogNow.Font.FontPitch:=TFontPitch(TMPLogFont.lfPitchAndFamily);
        MHFontDialogNow.Font.FontStyle:=[];
        if TMPLogFont.lfWeight=FW_BOLD then
          MHFontDialogNow.Font.FontStyle:=MHFontDialogNow.Font.FontStyle+[fsBold];
        if TMPLogFont.lfItalic=1 then
          MHFontDialogNow.Font.FontStyle:=MHFontDialogNow.Font.FontStyle+[fsItalic];
        if TMPLogFont.lfUnderline=1 then
          MHFontDialogNow.Font.FontStyle:=MHFontDialogNow.Font.FontStyle+[fsUnderline];
        if TMPLogFont.lfStrikeOut=1 then
          MHFontDialogNow.Font.FontStyle:=MHFontDialogNow.Font.FontStyle+[fsStrikeOut];

        MHFontDialogNow.Font.FontName:='';

        For i:=0 to LF_FACESIZE-1 do
          MHFontDialogNow.Font.FontName:=MHFontDialogNow.Font.FontName+TMPLogFont.lfFaceName[i];

}
        {if I <> CB_ERR then
          MHFontDialogNow.Font:=(LogFontToKOLFont(TMPLogFont,SendDlgItemMessage(Wnd, IDCOLORCMB, CB_GETITEMDATA, I, 0)))
        else
          MHFontDialogNow.Font:=(LogFontToKOLFont(TMPLogFont,0));}
 {       if Assigned( MHFontDialogNow.FOnApply ) then
          MHFontDialogNow.FOnApply( @MHFontDialogNow);
        Result:=1;
      end;
    end;
  end; //case}
end;

  *)

{
function DialogHook(Wnd: HWnd; Msg: UINT; WParam: WPARAM; LParam: LPARAM): UINT; stdcall;
begin
  Result := 0;
  if Msg = WM_INITDIALOG then
  begin
//    CenterWindow(Wnd);
//    CreationControl.FHandle := Wnd;
//    CreationControl.FDefWndProc := Pointer(SetWindowLong(Wnd, GWL_WNDPROC,
//      Longint(CreationControl.FObjectInstance)));
//    CallWindowProc(CreationControl.FObjectInstance, Wnd, Msg, WParam, LParam);
//    CreationControl := nil;
  end;
end;
}
(*
function TMHFindDialog.Execute:Hwnd;
var
  TMPFR: TFindReplace;
begin

  with TMPFR do
  begin
    lStructSize:=Sizeof(TMPFR);
    if Assigned(Applet) then
      hWndOwner:=Applet.Handle
    else
      hWndOwner:=0;
    hInstance:=0;
    Flags:=0;//FR_DOWN or FR_ENABLEHOOK;
    lpstrFindWhat:='1234567890';
    lpstrReplaceWith:='';
    wFindWhatLen:=10;
    wReplaceWithLen:=0;
    lCustData:=0;
//    lpfnHook:=MHKOLFindDialogHook;
//    lpTemplateName:='';

{
  FR_DOWN = $00000001;
  FR_WHOLEWORD = $00000002;
  FR_MATCHCASE = $00000004;
  FR_FINDNEXT = $00000008;
  FR_REPLACE = $00000010;
  FR_REPLACEALL = $00000020;
  FR_DIALOGTERM = $00000040;
  FR_SHOWHELP = $00000080;
  FR_ENABLEHOOK = $00000100;
  FR_ENABLETEMPLATE = $00000200;
  FR_NOUPDOWN = $00000400;
  FR_NOMATCHCASE = $00000800;
  FR_NOWHOLEWORD = $00001000;
  FR_ENABLETEMPLATEHANDLE = $00002000;
  FR_HIDEUPDOWN = $00004000;
  FR_HIDEMATCHCASE = $00008000;
  FR_HIDEWHOLEWORD = $00010000;
 }

    Result := FindText(TMPFR);
//    Wnd.AttachProc(WndProcMHFindDialog);
    if Result<>0 then
    begin
    //  BringWindowToTop(Result);
  //    Result := True;
    end;

//    CommDlgExtendedError;
  end;
end;
*)

function  TMHFindReplaceDialog.Execute:Boolean ;
var
  TMP:TFindReplace;
begin
  Result := False;
  Fillchar(TMP,sizeof(TMP),0);
  with TMP do
  begin
    lStructSize:=SizeOf(TMP);
    if WndOwner <> 0 then
      hWndOwner := WndOwner
    else
      if assigned( Applet ) then
        hWndOwner := Applet.Handle
      else
        hWndOwner := 0;
    hInstance:=hInstance;
    if FindText<>'' then
    begin
      lpstrFindWhat:=PChar(FindText);
      wFindWhatLen:=Length(FindText);
    end
    else
    begin
      lpstrFindWhat:=#0;
      wFindWhatLen:=1;
    end;

    if ReplaceText<>'' then
    begin
      lpstrReplaceWith:=PChar(ReplaceText);
      wReplaceWithLen:=Length(ReplaceText);
    end
    else
    begin
      lpstrReplaceWith:=#0;
      wReplaceWithLen:=1;
    end;
//    lpfnHook := nil;//@FindReplaceHook;
    Flags :=MakeFlags ( @Options, FindReplaceDialogOption2Style ) ;
  end;
//  FHeap := HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, SizeOf(FFR) );
//  CopyMemory (Pointer(lHeap), Pointer(FFR), SizeOf(FFR));
  FOldProc := Pointer (SetWindowLong (WndOwner, GWL_WNDPROC, Longint (@FindReplaceWndProc)));
  FRDlgNow := @Self;
  case DialogType of
    dtFind:DialogHandle := CommDlg.FindText(TMP);
    dtReplace:DialogHandle := CommDlg.ReplaceText(TMP);
  end;
  if DialogHandle > 0 then
  begin
     MessageLoop;
     Result:= True;
  end;
end;

procedure  TMHFindReplaceDialog.MessageLoop;
begin
  while GetMessage(TMsg, 0, 0, 0) and (DialogHandle > 0) do
  begin
     if IsDialogMessage(DialogHandle, TMsg)=False then
     begin
       TranslateMessage (TMsg);
       DispatchMessage (TMsg);
     end;
  end;
end;

begin
  FindMsg := RegisterWindowMessage(FINDMSGSTRING);
  HelpMsg := RegisterWindowMessage(HELPMSGSTRING);
end.
