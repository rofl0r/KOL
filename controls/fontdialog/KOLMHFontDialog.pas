unit KOLMHFontDialog;
//  MHFontDialog Компонент (MHFontDialog Component)
//  Автор (Author): Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//  Дата создания (Create date): 19-ноя(nov)-2002
//  Дата коррекции (Last correction Date): 15-авг(aug)-2003
//  Версия (Version): 1.3
//  EMail: Gandalf@kol.mastak.ru
//  WWW: http://kol.mastak.ru
//  Благодарности (Thanks):
//    Vladimir Kladov
//    Alexander Pravdin
//    Dominiko-m
//    Kiril Krasnov
//    Ajax Talamned
//  Новое в (New in):
//  V1.3 (KOL 1.80, Delphi 7)
//  [+] Device вернул (Return Device property) <Thanks to Ajax Talamned> [KOLnMCK]
//  [-] Убрал fdShowHelp fdApplyButton (Delete fdShowHelp fdApplyButton) [KOLnMCK]
//  [*] Переименовал  MaxSize,MinSize -> MaxFontSize,MinFontSize, как в VCL (Rename MaxSize,MinSize -> MaxFontSize,MinFontSize as in VCL) [KOLnMCK]
//  [+] Добавил fdInitFont (Add fdInitFont) [KOLnMCK]
//  [+] И другое (Add others) [KOLnMCK]
//
//  V1.21 (KOL 1.79, Delphi 7)
//  [+] Свойство Options (Options property) <Thanks to Ajax Talamned> [KOLnMCK]
//
//  V1.2
//  [-] Утечка памяти ликвидирована (Memory leak fixed) <Thanks to dominiko-m> [KOL]
//
//  V1.11
//  [+] Поддержка D7 (D7 Support) [KOLnMCK]
//
//  V1.1
//  [+] Поддержка D6 (D6 Support) <Thanks to Alexander Pravdin> [KOLnMCK]
//  [!] Неверное занчение InitFont (Incorrect InitFont) <Thanks to Kiril Krasnov, Dominiko-m> [KOL]
//  [N] KOLnMCK>=1.43
//
//  Список дел (To-Do list):
//  2. Good Default Values
//  3. Optimize
//  4. Asm
// 19. Add InitDialog Event
// 20. Printer DC not realized
// 21. Ассемблер (Asm)
// 22. Оптимизировать (Optimize)
// 23. Подчистить (Clear Stuff)
// 24. Ошибки (Errors)
//1) Может InitFont заменить на Font, т.е. в качестве инита используется
//текущий?
//2) Может убрать fdWysiwyg - это вндб комбинация стилей (но удобная)


interface

uses
  KOL, Windows, ShellAPI, CommDlg, Messages;

type
  TFontDialogOption = (fdAnsiOnly, fdTrueTypeOnly, fdEffects, fdFixedPitchOnly,
    fdForceFontExist, fdNoFaceSel, fdNoOEMFonts, fdNoSimulations,
    fdNoSizeSel, fdNoStyleSel, fdNoVectorFonts, {fdShowHelp,}
    fdWysiwyg, fdLimitSize, fdScalableOnly,{ fdApplyButton,} fdInitFont);
  TFontDialogOptions = set of TFontDialogOption;

  TFontDialogDevice = (fdBoth, fdScreen, fdPrinter);
  TFontIgnoreInit = (fiiName, fiiStyle, fiiSize);
  TFontIgnoreInits = set of TFontIgnoreInit;

  PMHFontDialog = ^TMHFontDialog;
  TKOLMHFontDialog = PMHFontDialog;

  TOnMHFontDApply = procedure(Sender: PMHFontDialog) of object;
  TOnMHFontDHelp = procedure(Sender: PMHFontDialog) of object;

  TMHFontDialog = object(TObj)
  private
    FControl: PControl;
    //     FShowEffects:Boolean;
    //     FMinSize:Integer;
    //     FMaxSize:Integer;
         //FFlags:DWORD;
    //     FOptions: TFontDialogOptions;
    //     FUseMinMaxSize:Boolean;
    //     FDevice:TFontDialogDevice;
    //     FIgnoreInits:TFontIgnoreInits;
    FInitFont: PGraphicTool;
    //     FUseInitFont:Boolean;
    //     FForceFontExist:Boolean;
//    LastMHFontDialog: PMHFontDialog;
//    FOnHelp: TOnMHFontDHelp;
//    FOnApply: TOnMHFontDApply;
    FHandle: THandle;
  public
    Font: PGraphicTool;
    Device: TFontDialogDevice;
    MinFontSize: Integer;
    MaxFontSize: Integer;
    Options: TFontDialogOptions;
    OnHelp: TOnMHFontDHelp;// read FOnHelp write FOnHelp;
    OnApply: TOnMHFontDApply;// read FOnApply write FOnApply;
    //     property ShowEffects:Boolean read FShowEffects write FShowEffects;
    //     property MinSize:Integer read FMinSize write FMinSize;
    //     property MaxSize:Integer read FmaxSize write FMaxSize;
    //     property UseMinMaxSize:Boolean read FUseMinMaxSize write FUseMinMaxSize;
    //     property Device:TFontDialogDevice;// read FDevice write FDevice;
    //     property IgnoreInits:TFontIgnoreInits read FIgnoreInits write FIgnoreInits;
    property InitFont: PGraphicTool read FInitFont;
    //     property UseInitFont:Boolean read FUseInitFont write FUseInitFont;
    //     property ForceFontExist:Boolean read FForceFontExist write FForceFontExist;

         //Мое -- :)
    //    property Options: TFontDialogOptions read FOptions write FOptions default [fdEffects];

         //property Flags:DWORD read FFlags write FFlags;
//    property OnHelp: TOnMHFontDHelp read FOnHelp write FOnHelp;
//    property OnApply: TOnMHFontDApply read FOnApply write FOnApply;
    property Handle: THandle read FHandle; // write FHandle;
    function Execute: Boolean;
    destructor Destroy; virtual;
  end;

var
  HelpMessageIndex: UINT;
//  MHFontDialogNow: PMHFontDialog;
const
  IDAPPLYBTN = $402;

function NewMHFontDialog(AParent: PControl): PMHFontDialog;

implementation

function WndProcMHFontDialog(Control: PControl; var Msg: TMsg; var Rslt: Integer): Boolean;
var
  Self:PMHFontDialog;
begin
  Result := False;
  Self:=Pointer(GetProp(Msg.wParam, ID_SELF));
  if Msg.message = HelpMessageIndex then
  begin
    if Assigned(Self.OnHelp) then
      Self.OnHelp(@Self);
    Rslt := 0;
    Result := True;
  end;
end;

function NewMHFontDialog(AParent: PControl): PMHFontDialog;
begin
  New(Result, Create);
  Result.FControl := AParent;
  Result.Font := NewFont;
  Result.FInitFont := NewFont;
//  Result.Device := fdScreen;
  AParent.AttachProc(WndProcMHFontDialog);
end;

function MHKOLFontDialogHook(Wnd: HWnd; Msg: UINT; WParam: WPARAM; LParam: LPARAM): UINT; stdcall;
const
  IDCOLORCMB = $473;
var
  TMPLogFont: TLogFont;
  i: Integer;
  Self:PMHFontDialog;
  zzz:PChooseFont;
begin
  Result := 0;
  Self:=Pointer(GetProp(Wnd, ID_SELF));
  case Msg of
    WM_INITDIALOG:
    begin
      Self:=PMHFontDialog(PChooseFont(LParam).lCustData);
      SetProp( Wnd, ID_SELF, THandle(Self) );
      Self.FHandle:=Wnd;
//      MHFontDialogNow.FHandle := Wnd;
    end;

    WM_COMMAND:
      begin
        if (HiWord(wParam) = BN_CLICKED) and (LoWord(wParam) = IDAPPLYBTN) then
        begin

          SendMessage(Wnd, WM_CHOOSEFONT_GETLOGFONT, 0, LongInt(@TMPLogFont));
          Self.Font.LogFontStruct := TMPLogFont;
          I := SendDlgItemMessage(Wnd, IDCOLORCMB, CB_GETCURSEL, 0, 0);

          if I <> CB_ERR then
            Self.Font.Color := SendDlgItemMessage(Wnd, IDCOLORCMB, CB_GETITEMDATA, I, 0);

          if Assigned(Self.OnApply) then
            Self.OnApply(@Self);
          Result := 1;
        end;
      end;
  end; //case
end;

function TMHFontDialog.Execute: Boolean;
const
  FontOptions: array[TFontDialogOption] of Integer = (
    CF_ANSIONLY, CF_TTONLY, CF_EFFECTS, CF_FIXEDPITCHONLY, CF_FORCEFONTEXIST,
    CF_NOFACESEL, CF_NOOEMFONTS, CF_NOSIMULATIONS, CF_NOSIZESEL,
    CF_NOSTYLESEL, CF_NOVECTORFONTS, {CF_SHOWHELP,}
    CF_WYSIWYG or CF_BOTH or CF_SCALABLEONLY, CF_LIMITSIZE,
    CF_SCALABLEONLY, {CF_APPLY,} CF_INITTOLOGFONTSTRUCT);
  Device2Flag: array[TFontDialogDevice] of Integer = (CF_BOTH,
    CF_SCREENFONTS,
    CF_PRINTERFONTS);
var
  TMPCF: TChooseFont;
  TMPLogFont: TLogFont;
  i: Integer;
  Option: TFontDialogOption;
begin
  TMPCF.lStructSize := Sizeof(TMPCF);
  if assigned(Applet) then
    TMPCF.hWndOwner := Applet.Handle
  else
    TMPCF.hWndOwner := 0;
  TMPCF.hInstance := 0;
  TMPCF.Flags := CF_ENABLEHOOK;

  TMPLogFont := InitFont.LogFontStruct;
  TMPCF.lpLogFont := @TMPLogFont;

  TMPCF.hDC := 0; // None Full Correct

  TMPCF.nSizeMin := MinFontSize;
  TMPCF.nSizeMax := MaxFontSize;

  TMPCF.rgbColors := InitFont.Color;

  TMPCF.Flags := MakeFlags(@Options, FontOptions) or CF_ENABLEHOOK;
  if Assigned(OnApply) then
    TMPCF.Flags := TMPCF.Flags or CF_APPLY;
  if Assigned(OnHelp) then
    TMPCF.Flags := TMPCF.Flags or CF_SHOWHELP;
  TMPCF.Flags := TMPCF.Flags or Device2Flag[Device];

  TMPCF.lpfnHook := MHKOLFontDialogHook;

  TMPCF.lCustData:=DWord(@Self);

//  LastMHFontDialog := MHFontDialogNow;
//  MHFontDialogNow := @Self;

  Result := ChooseFont(TMPCF);

  if Result then
  begin
    Font.LogFontStruct := TMPLogFont;
    Font.Color := TMPCF.rgbColors;
  end;
//  MHFontDialogNow := LastMHFontDialog;
//  LastMHFontDialog := nil;
end;

destructor TMHFontDialog.Destroy;
begin
  Font.Free;
  FInitFont.Free;
  inherited;
end;

begin
  HelpMessageIndex := RegisterWindowMessage(HELPMSGSTRING);
end.

