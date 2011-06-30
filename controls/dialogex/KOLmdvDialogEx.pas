{$R Dlgtpl.RES}
unit KOLmdvDialogEx;
// TKOLmdvDialogEx - Open\Save\Color Dialog. Аналог стандартного + возможность размещать
//                   дополнительные контролы (например для реализации PictureDialog) +
//                   дополнительные настройки и события
// E-Mail: dominiko-m@yandex.ru
// Автор: Матвеев Дмитрий

// - История -

// Версия: 1.23 (30.07.2003)
// [!] - найдены и исправлены утечеки ресурсов.

// Версия: 1.22 (03.03.2003)
// [+] - добавлена процедура DisposemdvDialogEx (от ACP);

// Версия: 1.21 (15.01.2003)
// [!] - исправлена ошибка обработки cdCustomColors;
// [+] - добавлен редактор свойства cdCustomColors;

// Дата: 26.12.2002 Версия: 1.20
// [*] - для Open\SaveDialog: изменены названия и типы событий;
//                            метод Execute заменен на ExecuteFileDialog;
//                            свойство fdTitle удалено, Title задается в ExecuteFileDialog;
// [+] - добавлен ColorDialog

// Дата: 16.12.2002 Версия: 1.00
   {Стартовая версия}

{
  Описание ключевых свойств
  * Open\SaveDialog
    function ExecuteFileDialog(AIsSaveDialog: Boolean; AExtControl: PControl = nil; ATitle: String = ''): Boolean;
    Вызов диалога. AIsSaveDialog - тип диалога (Open или Save);
                   AExtControl - контрол, который будет использоваться в диалоге(при необходимости), если не нужно - nil
                   ATitle - заголовок окна диалога

    property fdOptions, fdOptionsEx, fdFilter, fdFilterIndex,
             fdDefaultExt, fdInitialDir: аналоги соответствующих свойств в TOpenDialog;
    property fdFileName: начальное значение имени файла, при инициализации.
                         Также содержит имена текущих выбранных файлов;
    property fdFileNames: содержит список файлов после закрытия диалога, разделеные #13#10;

    property OnShow, OnClose, fdOnSelectionChange, fdOnFolderChange, fdOnTypeChange, fdOnCanClose: аналоги соответствующих событий в TOpenDialog;
    property OnHelp - возникает при вызове справки;

  * ColorDialog
    function ExecuteColorDialog(AExtControl: PControl = nil; ATitle: String = ''): Boolean;
    Вызов диалога. AExtControl - контрол, который будет использоваться в диалоге(при необходимости), если не нужно - nil
                   ATitle - заголовок окна диалога
    property cdColor, cdCustomColors, cdOptions : аналоги соответствующих свойств в TColorDialog;

    procedure SetColor(AColor: TColor);
    Устанавливает цвет AColor в открытом диалоге

    property OnShow, OnClose: аналоги соответствующих событий в TOpenDialog;
    property OnHelp - возникает при вызове справки;
    property cdOnChangeColor - изменение цвета в диалоге (только в режиме FullOpen);
    property cdOnChangeCustomColors - изменение CustomColors в диалоге (только в режиме FullOpen);
    property cdOnCanClose: - запрос на закрытие диалога;

}

{$R-,H+,X+}
interface

uses Windows, CommDlg, Messages, KOL;

type
  TOpenOption = (ofReadOnly, ofOverwritePrompt, ofHideReadOnly,
    ofNoChangeDir, ofShowHelp, ofNoValidate, ofAllowMultiSelect,
    ofExtensionDifferent, ofPathMustExist, ofFileMustExist, ofCreatePrompt,
    ofShareAware, ofNoReadOnlyReturn, ofNoTestFileCreate, ofNoNetworkButton,
    ofNoLongNames, ofOldStyleDialog, ofNoDereferenceLinks, ofEnableIncludeNotify,
    ofEnableSizing, ofDontAddToRecent, ofForceShowHidden);
  TOpenOptions = set of TOpenOption;

  TOpenOptionEx = (ofExNoPlacesBar);
  TOpenOptionsEx = set of TOpenOptionEx;
  TDialogTypeEx = (dtOpenFile, dtSaveFile, dtColorDialog);

  PCustomColors = ^TCustomColors;
  TCustomColors = array[1..16] of Longint;
  TColorDialogOption = (cdFullOpen, cdPreventFullOpen, cdShowHelp, cdSolidColor, cdAnyColor);
  TColorDialogOptions = set of TColorDialogOption;

  TmdvDialogExEvent = procedure(Sender: PObj; ADialogTypeEx: TDialogTypeEx) of object;
  TfdCanClose = procedure(Sender: PObj; ADialogTypeEx: TDialogTypeEx; AfdFileNames: String; var ACanClose: Boolean) of object;
  TcdChangeColor = procedure(Sender: PObj; AColor: TColor) of object;
  TcdChangeCustomColors = procedure(Sender: PObj; ACustomColors: TCustomColors) of object;
  TcdCanClose = procedure(Sender: PObj; ChooseColor: TChooseColor; var ACanClose: Boolean) of object;

  PmdvDialogEx = ^TmdvDialogEx;
  TmdvDialogEx = object(TObj)
  private
    FControl: PControl;
    FfdOptions: TOpenOptions;
    FfdOptionsEx: TOpenOptionsEx;
    FCurrentFilterIndex: DWORD;
    FfdFilterIndex: Integer;
    FfdFilter: string;
    FfdFileName: string;
    FfdInitialDir: string;
    FfdDefaultExt: string;
    FfdFileNames: string;
    FDialogTypeEx: TDialogTypeEx;
    FOnShow: TmdvDialogExEvent;
    FOnClose: TmdvDialogExEvent;
    FOnHelp: TmdvDialogExEvent;
    FfdOnCanClose: TfdCanClose;
    FfdOnSelectionChange: TmdvDialogExEvent;
    FfdOnFolderChange: TmdvDialogExEvent;
    FfdOnTypeChange: TmdvDialogExEvent;
    FExtControl: PControl;
    FOldParent: THandle;
    FExecute: Boolean;
    FHandle: THandle;
    FcdOptions: TColorDialogOptions;
    FcdColor: TColor;
    FChangeColor, FChangeCustomColors, FResize, FCreated: Boolean;
    FTitle: String;
    FcdOnCanClose: TcdCanClose;
    FcdOnChangeColor: TcdChangeColor;
    FcdOnChangeCustomColors: TcdChangeCustomColors;

    function GetFileNames(AOpenFilename: TOpenFilename): String;
    function GetfdFileName: string;
    function GetStaticRect: TRect;
    function CenterRect(Wnd: HWnd; ARect: TRect; AHor, AVer: Boolean): TRect;
  public
    cdCustomColors: TCustomColors;

    destructor Destroy; virtual;

    property OnShow: TmdvDialogExEvent read FOnShow write FOnShow;
    property OnClose: TmdvDialogExEvent read FOnClose write FOnClose;
    property OnHelp: TmdvDialogExEvent read FOnHelp write FOnHelp;

    function ExecuteFileDialog(AIsSaveDialog: Boolean; AExtControl: PControl = nil; ATitle: String = ''): Boolean;

    property fdOptions: TOpenOptions read FfdOptions write FfdOptions;
    property fdOptionsEx: TOpenOptionsEx read FfdOptionsEx write FfdOptionsEx;
    property fdFilter: string read FfdFilter write FfdFilter;
    property fdFilterIndex: Integer read FfdFilterIndex write FfdFilterIndex;
    property fdFileName: string read GetfdFileName write FfdFileName;
    property fdFileNames: string read FfdFileNames;
    property fdInitialDir: string read FfdInitialDir write FfdInitialDir;
    property fdDefaultExt: string read FfdDefaultExt write FfdDefaultExt;

    property fdOnSelectionChange: TmdvDialogExEvent read FfdOnSelectionChange write FfdOnSelectionChange;
    property fdOnFolderChange: TmdvDialogExEvent read FfdOnFolderChange write FfdOnFolderChange;
    property fdOnTypeChange: TmdvDialogExEvent read FfdOnTypeChange write FfdOnTypeChange;
    property fdOnCanClose: TfdCanClose read FfdOnCanClose write FfdOnCanClose;

    function ExecuteColorDialog(AExtControl: PControl = nil; ATitle: String = ''): Boolean;
    procedure SetColor(AColor: TColor);
    property cdOptions: TColorDialogOptions read FcdOptions write FcdOptions;
    property cdColor: TColor read FcdColor write FcdColor;

    property cdOnChangeColor: TcdChangeColor read FcdOnChangeColor write FcdOnChangeColor;
    property cdOnChangeCustomColors: TcdChangeCustomColors read FcdOnChangeCustomColors write FcdOnChangeCustomColors;
    property cdOnCanClose: TcdCanClose read FcdOnCanClose write FcdOnCanClose;
  end;

  TKOLmdvDialogEx = PmdvDialogEx;

function NewmdvDialogEx(Wnd: PControl): TKOLmdvDialogEx;


{Добавлено ACP Team (Хотя, по моему, достаточно вызова Free)
Освобождает используемые ресурсы. Параметры: Wnd - хэндл окна; Dialog - указатель на диалог }
procedure DisposemdvDialogEx(Wnd : PControl; var Dialog : TKOLmdvDialogEx);

implementation

var mdvDialogEx: TKOLmdvDialogEx;
    HelpMsg, ColorOkMsg, SetRGBMsg: Cardinal;

function WndProcmdvDialogEx(Control: PControl; var Msg: TMsg; var Rslt: Integer) : Boolean;
begin
    Result:=False;
    if (Msg.message = HelpMsg) then begin
      if Assigned(mdvDialogEx.FOnHelp) then mdvDialogEx.FOnHelp(mdvDialogEx, mdvDialogEx.FDialogTypeEx);
      Rslt:=0;
      Result:=True;
    end;
    if Msg.message = SetRGBMsg then MsgOK('!');
end;

function NewmdvDialogEx(Wnd: PControl): PmdvDialogEx;
begin
    New(Result, Create);
    Result.FControl:=Wnd;
    Wnd.AttachProc(WndProcmdvDialogEx);
    Result.FfdFileNames:= '';
    Result.FExecute:= False;
end;

procedure DisposemdvDialogEx;
begin
  Wnd.DetachProc(WndProcmdvDialogEx);
  Dispose(Dialog);
end;

function TmdvDialogEx.CenterRect(Wnd: HWnd; ARect: TRect; AHor, AVer: Boolean): TRect;
var H, W: Integer;
begin
    Result:= ARect;
    if AHor then begin
      W:= GetSystemMetrics(SM_CXSCREEN);
      Result.Left:= (W - ARect.Right + ARect.Left) div 2;
      Result.Right:= Result.Left + (ARect.Right - ARect.Left);
    end;
    if AVer then begin
      H:= GetSystemMetrics(SM_CYSCREEN);
      Result.Top:= (H - ARect.Bottom + ARect.Top) div 2;
      Result.Bottom:= Result.Top + (ARect.Bottom - ARect.Top);
    end;
end;

destructor TmdvDialogEx.Destroy;
begin
    FTitle:= '';
    FfdFilter:= ''; FfdFileName:= ''; FfdInitialDir:= ''; FfdDefaultExt:= ''; FfdFileNames:= '';
    inherited;
end;

function FileDialogHook(Wnd: HWnd; Msg: UINT; WParam: WPARAM; LParam: LPARAM): UINT; stdcall;
var F: Boolean;
    CR, SR: Trect;
begin
    Result:= 0;
    case Msg of
      WM_INITDIALOG: begin
        mdvDialogEx.FHandle:= Wnd;
        if (ofOldStyleDialog in mdvDialogEx.FfdOptions) and Assigned(mdvDialogEx.FOnShow) then mdvDialogEx.FOnShow(mdvDialogEx, mdvDialogEx.FDialogTypeEx);
      end;
      WM_DESTROY: begin
        if mdvDialogEx.FExtControl <> nil then begin
          mdvDialogEx.FExtControl.Visible:= False;
          SetParent(mdvDialogEx.FExtControl.Handle, mdvDialogEx.FOldParent);
        end;
        if Assigned(mdvDialogEx.FOnClose) then mdvDialogEx.FOnClose(mdvDialogEx, mdvDialogEx.FDialogTypeEx);
      end;
      WM_NOTIFY:
        case (POFNotify(LParam)^.hdr.code) of
          CDN_INITDONE: begin
            if mdvDialogEx.FExtControl <> nil then begin
              GetClientRect(Wnd, CR);
              SR := mdvDialogEx.GetStaticRect;
              CR.Left := SR.Left + (SR.Right - SR.Left);
              Inc(CR.Top, 4);
              mdvDialogEx.FExtControl.BoundsRect:= CR;
              mdvDialogEx.FOldParent:= GetParent(mdvDialogEx.FExtControl.Handle);
              SetParent(mdvDialogEx.FExtControl.Handle, Wnd);
              mdvDialogEx.FExtControl.Visible:= True;
            end;
            if Assigned(mdvDialogEx.FOnShow) then mdvDialogEx.FOnShow(mdvDialogEx, mdvDialogEx.FDialogTypeEx);
          end;
          CDN_FILEOK: begin
            F := True;
            if Assigned(mdvDialogEx.FfdOnCanClose) then mdvDialogEx.FfdOnCanClose(mdvDialogEx, mdvDialogEx.FDialogTypeEx, mdvDialogEx.GetFileNames(POFNotify(LParam)^.lpOFN^), F);
            if not F then begin
              Result := 1; SetWindowLong(Wnd, DWL_MSGRESULT, Result); Exit;
            end;
          end;
          CDN_SELCHANGE: if Assigned(mdvDialogEx.FfdOnSelectionChange) then mdvDialogEx.FfdOnSelectionChange(mdvDialogEx, mdvDialogEx.FDialogTypeEx);
          CDN_FOLDERCHANGE: if Assigned(mdvDialogEx.FfdOnFolderChange) then mdvDialogEx.FfdOnFolderChange(mdvDialogEx, mdvDialogEx.FDialogTypeEx);
          CDN_TYPECHANGE:
            begin
              if POFNotify(LParam)^.lpOFN^.nFilterIndex <> mdvDialogEx.FCurrentFilterIndex then
              begin
                mdvDialogEx.FCurrentFilterIndex := POFNotify(LParam)^.lpOFN^.nFilterIndex;
                if Assigned(mdvDialogEx.FfdOnTypeChange) then mdvDialogEx.FfdOnTypeChange(mdvDialogEx, mdvDialogEx.FDialogTypeEx);
              end;
            end;
        end;
  end;
end;

function ColorDialogHook(Wnd: HWnd; Msg: UINT; WParam: WPARAM; LParam: LPARAM): UINT; stdcall;
function ProcessMessage: Boolean;
var Msg: TMsg;
begin
   Result := False;
   if PeekMessage( Msg, 0, 0, 0, PM_NOREMOVE ) then begin
     if (Msg.message <> WM_LBUTTONUP) then PeekMessage( Msg, 0, 0, 0, PM_REMOVE );
     TranslateMessage( Msg );
     DispatchMessage( Msg );
   end;
end;
procedure ShowControls(AllCmd: Integer; SolidCmd: Boolean);
const COLOR_ADD = 712; COLOR_RAINBOW = 710; COLOR_LUMSCROLL = 702; COLOR_CURRENT = 709;
      COLOR_HUEACCEL = 723; COLOR_SATACCEL = 724; COLOR_LUMACCEL = 725;
      COLOR_REDACCEL = 726; COLOR_GREENACCEL = 727; COLOR_BLUEACCEL = 728;
      COLOR_HUE = 703; COLOR_SAT = 704; COLOR_LUM = 705;
      COLOR_RED = 706; COLOR_GREEN = 707; COLOR_BLUE = 708;
      COLOR_SOLID_LEFT = 730; COLOR_SOLID_RIGHT  = 731;
      COLOR_Controls: array [1..18] of integer = (COLOR_ADD, COLOR_RAINBOW, COLOR_LUMSCROLL, COLOR_CURRENT,
                                                  COLOR_HUEACCEL, COLOR_SATACCEL, COLOR_LUMACCEL,
                                                  COLOR_REDACCEL, COLOR_GREENACCEL, COLOR_BLUEACCEL,
                                                  COLOR_HUE, COLOR_SAT, COLOR_LUM,
                                                  COLOR_RED, COLOR_GREEN, COLOR_BLUE,
                                                  COLOR_SOLID_LEFT, COLOR_SOLID_RIGHT);

var i: Integer;
begin
    for i:= 1 to 18 do ShowWindow(GetDlgItem(Wnd, COLOR_Controls[i]), AllCmd);
    if SolidCmd then ShowWindow(GetDlgItem(Wnd, COLOR_SOLID_RIGHT), SW_SHOW);
end;
procedure SetExtControl;
var CR, PR: Trect;
begin
    GetWindowRect(Wnd, PR);
    if mdvDialogEx.FExtControl <> nil then begin
      GetClientRect(Wnd, CR);
      CR.Left:= CR.Right; CR.Right:= CR.Right + mdvDialogEx.FExtControl.Width;
      PR.Right:= PR.Right + (CR.Right - CR.Left);

      mdvDialogEx.FExtControl.BoundsRect:= CR;
      SetParent(mdvDialogEx.FExtControl.Handle, Wnd);
      mdvDialogEx.FExtControl.Visible:= True;
    end;
    PR:= mdvDialogEx.CenterRect(Wnd, PR, True, False);
    MoveWindow(Wnd, PR.Left,  PR.Top, PR.Right-PR.Left, PR.Bottom-PR.Top, True);
    if mdvDialogEx.FTitle <> '' then SetWindowText(Wnd, PChar(mdvDialogEx.FTitle));
end;
const ID_ChangeColorFirst = 703; ID_ChangeColorEnd = 708; ID_AddCustomColor = 712; ID_ColorMix = 719;
var F: Boolean;
begin
    Result:= 0;
    if Msg = ColorOkMsg then begin
      if mdvDialogEx.FChangeColor and Assigned(mdvDialogEx.FcdOnChangeColor) then begin
        mdvDialogEx.FcdOnChangeColor(mdvDialogEx, TColor(PChooseColor(LParam)^.rgbResult));
        Result:= 1;
        ProcessMessage;
      end
      else
        if mdvDialogEx.FChangeCustomColors and Assigned(mdvDialogEx.FcdOnChangeCustomColors) then begin
          mdvDialogEx.FcdOnChangeCustomColors(mdvDialogEx, PCustomColors(PChooseColor(LParam)^.lpCustColors)^);
          Result:= 1;
        end
        else
          if Assigned(mdvDialogEx.FcdOnCanClose) then begin
            F:= True;
            mdvDialogEx.FcdOnCanClose(mdvDialogEx, PChooseColor(LParam)^, F);
            Result:= Ord(F);
          end;
      mdvDialogEx.FChangeColor:= False;
      mdvDialogEx.FChangeCustomColors:= False;
    end;
    case Msg of
      WM_INITDIALOG: begin
        mdvDialogEx.FHandle:= Wnd;
        if mdvDialogEx.FExtControl <> nil then begin
           mdvDialogEx.FOldParent:= GetParent(mdvDialogEx.FExtControl.Handle);
           if not(cdFullOpen in mdvDialogEx.FcdOptions) then ShowControls(SW_HIDE, False);
        end;
        SetExtControl;
        if Assigned(mdvDialogEx.FOnShow) then mdvDialogEx.FOnShow(mdvDialogEx, mdvDialogEx.FDialogTypeEx);
         mdvDialogEx.FCreated:= True;
      end;
      WM_DESTROY: begin
        if mdvDialogEx.FExtControl <> nil then begin
          mdvDialogEx.FExtControl.Visible:= False;
          SetParent(mdvDialogEx.FExtControl.Handle, mdvDialogEx.FOldParent);
        end;
        if Assigned(mdvDialogEx.FOnClose) then mdvDialogEx.FOnClose(mdvDialogEx, mdvDialogEx.FDialogTypeEx);
      end;
      WM_COMMAND:
        case LOWORD(wParam) of
          ID_ChangeColorFirst..ID_ChangeColorEnd: begin
            if Assigned(mdvDialogEx.FcdOnChangeColor) and mdvDialogEx.FCreated then begin
              mdvDialogEx.FChangeColor:= True;
              SendMessage(Wnd, WM_COMMAND, ID_OK, Wnd);
            end;
          end;
          ID_AddCustomColor: begin
            if Assigned(mdvDialogEx.FcdOnChangeCustomColors) and mdvDialogEx.FCreated then begin
              mdvDialogEx.FChangeCustomColors:= True;
              PostMessage(Wnd, WM_COMMAND, ID_OK, Wnd);
            end;
          end;
          ID_ColorMix: mdvDialogEx.FResize:= True;
        end;
        WM_SIZE: begin
          if mdvDialogEx.FResize and (mdvDialogEx.FExtControl <> nil) then begin
             mdvDialogEx.FResize:= False;
             ShowControls(SW_SHOW, not(cdSolidColor in mdvDialogEx.FcdOptions));
             SetExtControl;
           end;
        end;
  end;
end;

function TmdvDialogEx.ExecuteColorDialog(AExtControl: PControl = nil; ATitle: String = ''): Boolean;
const DialogOptions: array[TColorDialogOption] of Integer = (CC_FULLOPEN, CC_PREVENTFULLOPEN, CC_SHOWHELP, CC_SOLIDCOLOR, CC_ANYCOLOR);
var ChooseColorRec: TChooseColor;
    OldmdvDialogEx: TKOLmdvDialogEx;
begin
    Result:= False;
    if FExecute then Exit;
    FExecute:= True;
    FTitle:= ATitle;
    FillChar(ChooseColorRec, SizeOf(ChooseColorRec), 0);
    ChooseColorRec.lStructSize := SizeOf(ChooseColorRec);
    ChooseColorRec.hInstance := HInstance;
    ChooseColorRec.rgbResult := Color2RGB(FcdColor);
    ChooseColorRec.lpCustColors := @cdCustomColors;
    ChooseColorRec.Flags := CC_RGBINIT or CC_ENABLEHOOK or MakeFlags(@FcdOptions, DialogOptions);

    ChooseColorRec.lpfnHook := ColorDialogHook;
    if FControl <> nil then ChooseColorRec.hWndOwner := FControl.Handle
    else if Assigned(Applet) then ChooseColorRec.hwndOwner:= Applet.Handle else ChooseColorRec.hWndOwner := 0;

    FExtControl:= AExtControl;
    FChangeColor:= False; FChangeCustomColors:= False; FResize:= False; FCreated:= False;
    FDialogTypeEx:= dtColorDialog;
    OldmdvDialogEx:= mdvDialogEx;
    mdvDialogEx:= @Self;
    Result := ChooseColor(ChooseColorRec);
    mdvDialogEx:= OldmdvDialogEx;
    if Result then begin
      FcdColor := ChooseColorRec.rgbResult;
    end;
    FExecute:= False;

end;

function TmdvDialogEx.ExecuteFileDialog(AIsSaveDialog: Boolean; AExtControl: PControl = nil; ATitle: String = ''): Boolean;
const MultiSelectBufferSize = High(Word) - 16;
      OpenOptions: array [TOpenOption] of Integer = (
          OFN_READONLY, OFN_OVERWRITEPROMPT, OFN_HIDEREADONLY,
          OFN_NOCHANGEDIR, OFN_SHOWHELP, OFN_NOVALIDATE, OFN_ALLOWMULTISELECT,
          OFN_EXTENSIONDIFFERENT, OFN_PATHMUSTEXIST, OFN_FILEMUSTEXIST,
          OFN_CREATEPROMPT, OFN_SHAREAWARE, OFN_NOREADONLYRETURN,
          OFN_NOTESTFILECREATE, OFN_NONETWORKBUTTON, OFN_NOLONGNAMES,
          OFN_EXPLORER, OFN_NODEREFERENCELINKS, OFN_ENABLEINCLUDENOTIFY,
          OFN_ENABLESIZING, OFN_DONTADDTORECENT, OFN_FORCESHOWHIDDEN);

  OpenOptionsEx: array [TOpenOptionEx] of Integer = (OFN_EX_NOPLACESBAR);
var
  OpenFilename: TOpenFilename;

  function MakeFilter(s : string) : String;
  var Str: PChar;
  begin
    Result := s;
    if Result='' then exit;
    Result:=Result+#0; {Delphi string always end on #0 is this is #0#0}
    Str := PChar( Result );
    while Str^ <> #0 do begin
      if Str^ = '|' then Str^ := #0;
      Inc(Str);
    end;
  end;
var TempFilter, TempFilename: string;
    OSVersionInfo: TOSVersionInfo;
    OldmdvDialogEx: TKOLmdvDialogEx;
begin
    Result:= False;
    if FExecute then Exit;
    FExecute:= True;
    OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo); GetVersionEx(OSVersionInfo);
    FillChar(OpenFileName, SizeOf(OpenFileName), 0);

    if { Win2k }(OSVersionInfo.dwMajorVersion >= 5) and (OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT) or
       { WinME }((OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS) and (OSVersionInfo.dwMajorVersion >= 4) and (OSVersionInfo.dwMinorVersion >= 90)) then OpenFilename.lStructSize := SizeOf(TOpenFilename)
    else OpenFilename.lStructSize := SizeOf(TOpenFilename) - (SizeOf(DWORD) shl 1) - SizeOf(Pointer); { subtract size of added fields }

    OpenFilename.hInstance := HInstance;
    TempFilter := MakeFilter(FfdFilter);
    OpenFilename.lpstrFilter := PChar(TempFilter);
    OpenFilename.nFilterIndex := FfdFilterIndex;
    FCurrentFilterIndex := FfdFilterIndex;

    if ofAllowMultiSelect in FfdOptions then OpenFilename.nMaxFile := MultiSelectBufferSize
    else OpenFilename.nMaxFile := MAX_PATH;

    SetLength(TempFilename, OpenFilename.nMaxFile + 2);
    OpenFilename.lpstrFile := PChar(TempFilename);
    FillChar(OpenFilename.lpstrFile^, OpenFilename.nMaxFile + 2, 0);
    StrLCopy(OpenFilename.lpstrFile, PChar(FfdFileName), OpenFilename.nMaxFile);

    if (FfdInitialDir = '') then OpenFilename.lpstrInitialDir := '.'
    else OpenFilename.lpstrInitialDir := PChar(FfdInitialDir);

    OpenFilename.lpstrTitle := PChar(ATitle);

    OpenFilename.Flags:= OFN_ENABLEHOOK or MakeFlags(@FfdOptions, OpenOptions);

    if Lo(GetVersion) >= 4 then begin
      OpenFilename.Flags := OpenFilename.Flags xor OFN_EXPLORER;
      if { Win2k }(OSVersionInfo.dwMajorVersion >= 5) and (OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT) or
         { WinME }((OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS) and (OSVersionInfo.dwMajorVersion >= 4) and (OSVersionInfo.dwMinorVersion >= 90)) then
        OpenFilename.FlagsEx := MakeFlags(@FfdOptionsEx, OpenOptionsEx);
    end
    else OpenFilename.Flags := OpenFilename.Flags and not OFN_EXPLORER;

    OpenFilename.lpstrDefExt := PChar(FfdDefaultExt);

    OpenFilename.lpfnHook := FileDialogHook;

    if FControl <> nil then OpenFilename.hWndOwner := FControl.Handle
    else if Assigned(Applet) then OpenFilename.hwndOwner:= Applet.Handle else OpenFilename.hWndOwner := 0;

    FExtControl:= AExtControl;
    if (FExtControl <> nil) and (Lo(GetVersion) >= 4) and not (ofOldStyleDialog in FfdOptions) then begin
      OpenFilename.lpTemplateName := 'DLGTEMPLATE';
      OpenFilename.Flags := OpenFilename.Flags or OFN_ENABLETEMPLATE;
    end
    else OpenFilename.lpTemplateName := nil;

    if AIsSaveDialog then FDialogTypeEx:= dtSaveFile else FDialogTypeEx:= dtOpenFile;
    OldmdvDialogEx:= mdvDialogEx;
    mdvDialogEx:= @Self;
    if not AIsSaveDialog then Result:= GetOpenFileName(OpenFileName)
    else Result:= GetSaveFileName(OpenFileName);
    mdvDialogEx:= OldmdvDialogEx;

    if Result then begin
      FfdFileNames:= GetFileNames(OpenFilename);
      if (OpenFilename.Flags and OFN_EXTENSIONDIFFERENT) <> 0 then
        Include(FfdOptions, ofExtensionDifferent) else
        Exclude(FfdOptions, ofExtensionDifferent);
      if (OpenFilename.Flags and OFN_READONLY) <> 0 then
        Include(FfdOptions, ofReadOnly) else
        Exclude(FfdOptions, ofReadOnly);
      FfdFilterIndex := OpenFilename.nFilterIndex;
    end;
    FExecute:= False;
end;

function TmdvDialogEx.GetfdFileName: string;
var Path: array[0..MAX_PATH] of Char;
begin
  if (Lo(GetVersion) >= 4) and (FHandle <> 0) then begin
    SendMessage(GetParent(FHandle), CDM_GETFILEPATH, SizeOf(Path), Integer(@Path));
    Result := PChar(@Path);
  end
  else Result := FfdFileName;
end;

function TmdvDialogEx.GetFileNames(AOpenFilename: TOpenFilename): String;
var k: Integer;
    Dir: String;
begin
    if (ofAllowMultiSelect in FfdOptions) and (ofOldStyleDialog in FfdOptions)or not(Lo(GetVersion) >= 4) then
      for k:= 1 to Length(AOpenFilename.lpstrFile) do
        if AOpenFilename.lpstrFile[k] = ' ' then AOpenFilename.lpstrFile[k]:= #0;
    Dir:= PChar(AOpenFilename.lpstrFile);
    k:= Length(Dir)+1;
    if PChar(AOpenFilename.lpstrFile)[k] = #0 then Result:= Dir+#13#10
    else begin
      if Dir[k-1] <> '\' then Dir:= Dir + '\';
      Result:= '';
      while PChar(AOpenFilename.lpstrFile)[k] <> #0 do begin
        Result:= Result + Dir  + String(PChar(AOpenFilename.lpstrFile)+k)+#13#10;
        k:= k + Length(String(PChar(AOpenFilename.lpstrFile)+k))+1;
      end;
    end;
    SetLength(Result, Length(Result)-2);
end;

function TmdvDialogEx.GetStaticRect: TRect;
begin
  if FHandle <> 0 then
  begin
    if not (ofOldStyleDialog in FfdOptions) then
    begin
      GetWindowRect(GetDlgItem(FHandle, $045f), Result);
      MapWindowPoints(0, FHandle, Result, 2);
    end
    else GetClientRect(FHandle, Result)
  end
  else Result := MakeRect(0,0,0,0);
end;

procedure TmdvDialogEx.SetColor(AColor: TColor);
begin
   if (FHandle <> 0) and (FDialogTypeEx = dtColorDialog) then SendMessage(FHandle, SetRGBMsg, 0, Color2RGB(AColor));
end;

initialization
  HelpMsg:= RegisterWindowMessage(HELPMSGSTRING);
  ColorOkMsg:= RegisterWindowMessage(COLOROKSTRING);
  SetRGBMsg:= RegisterWindowMessage(SETRGBSTRING);
end.
