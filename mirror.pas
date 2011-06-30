{******************************************************

        KKKKK    KKKKK    OOOOOOOOO    LLLLL
        KKKKK    KKKKK  OOOOOOOOOOOOO  LLLLL
        KKKKK    KKKKK  OOOOO   OOOOO  LLLLL
        KKKKK  KKKKK    OOOOO   OOOOO  LLLLL
        KKKKKKKKKK      OOOOO   OOOOO  LLLLL
        KKKKK  KKKKK    OOOOO   OOOOO  LLLLL
        KKKKK    KKKKK  OOOOO   OOOOO  LLLLL
        KKKKK    KKKKK  OOOOOOOOOOOOO  LLLLLLLLLLLLL     kkkkk
        KKKKK    KKKKK    OOOOOOOOO    LLLLLLLLLLLLL    kkkkk
                                                       kkkkk
    mmmmm  mmmmm   mmmmmm          cccccccccccc       kkkkk   kkkkk
   mmmmmmmm   mmmmm     mmmmm   cccccc       ccccc   kkkkk kkkkk
  mmmmmmmm   mmmmm     mmmmm   cccccc               kkkkkkkk
 mmmmm      mmmmm     mmmmm   cccccc      ccccc    kkkkk  kkkkk
mmmmm      mmmmm     mmmmm     cccccccccccc       kkkkk     kkkkk

  Key Objects Library (C) 2000 by Kladov Vladimir.
  KOL Mirror Classes Kit (C) 2000 by Kladov Vladimir.
********************************************************
* VERSION 2.08
********************************************************
}
unit mirror;
{
  This unit contains definitions of mirror classes reflecting to objects of
  KOL. Aim is to create kit for programming in KOL visually. Idea is not of main.
  Many people told me that they want to have such tool kit, and suggested
  different ways to implement it. But this implementation is made by me,
  and I reserve all rights for code below, containing my own (original, I
  hope) solutions, and for all accompanied files distributed together in
  KOL Mirror Classes Kit. While I am writing this, I have not yet clearance
  in all problems, which I can meet on such way, but... let God tell me the
  right direction.
                  by Vladimir Kladov, 27.11.2000

  В данном модуле определяются зеркальные классы для объектов библиотеки KOL.
  Цель - создать средство для визуального проектирования проектов KOL.
  Идея не моя. Поступила ко мне от различных людей в различное время.
  Но ей требовалось дозреть. Когда я эту пишу, мне еще не очень ясно, как
  будут решаться проблемы, которые встретятся, но... пусть Бог подскажет
  правильный путь.
                  Кладов Владимир, 27.11.2000.
}

interface

{$I KOLDEF.INC}

uses olectrls, KOL, Classes, Forms, Controls, Dialogs, Windows, Messages, extctrls,
     stdctrls, comctrls, SysUtils, Graphics,
//////////////////////////////////////////////////
     ExptIntf, ToolIntf, EditIntf, // DsgnIntf
//////////////////////////////////////////////////
     {$IFDEF _D6orHigher}                       //
     DesignIntf, DesignEditors, DesignConst,    //
     Variants                                   //
     {$ELSE}                                    //
     DsgnIntf                                   //
     {$ENDIF}                                   //
//////////////////////////////////////////////////
     {$IFNDEF _D2}{$IFNDEF _D3}, ToolsAPI{$ENDIF}{$ENDIF},
     TypInfo, Consts,
     mckMenuEditor, mckAccEditor, mckActionListEditor;

{$IFDEF _D4}
{$O-}
{$ENDIF}

{$IFDEF _D2}
type TCustomForm = TForm;
{$ENDIF}

const
  WM_USER_ALIGNCHILDREN = WM_USER + 1;
  cKOLTag = -999;

type


//////////////////////////////////////////////////////////
     {$IFDEF _D6orHigher}                               //
      TDesignerSelectionList = TDesignerSelections;     //
     {$ENDIF}                                           //
//////////////////////////////////////////////////////////
















  TKOLActionList = class;
  TKOLAction = class;



  TPaintType = ( ptWYSIWIG, ptWYSIWIGFrames, ptSchematic, ptWYSIWIGCustom ); {YS}

  //============================================================================
  // TKOLProject component corresponds to the KOL project. It must be present
  // once in a project. It is responding for code generation and contains
  // properties available from Object Inspector, common for entire project
  // (used for maintainig project and in generating of code).
  //
  // Проекту KOL соответствует компонент TKOLProject (должен присутствовать
  // один раз в проекте). Он отвечает за генерацию кода и содержит доступные
  // из ObjectInspector-а настройки (общие для всего проекта), используемые
  // при генерации кода dpr-файла.
  TKOLProject = class( TComponent )
  private
    fProjectName: String;
    FProjectDest: String;
    fSourcePath: TFileName;
    fDprResource: Boolean;
    fProtect: Boolean;
    fShowReport: Boolean;
    fBuild: Boolean;
    fIsKOL: Integer;
    fOutdcuPath: String;
    fAutoBuild: Boolean;
    fTimer: TTimer;
    fAutoBuilding: Boolean;
    FAutoBuildDelay: Integer;
    fGettingSourcePath: Boolean;
    FConsoleOut: Boolean;
    FIn, FOut: THandle;
    FBuilding: Boolean;
    fChangingNow: Boolean;
    FSupportAnsiMnemonics: LCID;
    FPaintType: TPaintType;
    FHelpFile: String;
    FLocalizy: Boolean;
    FShowHint: Boolean;
    FIsDestroying: Boolean;
    function GetProjectName: String;
    procedure SetProjectDest(const Value: String);

    function ConvertVCL2KOL( ConfirmOK: Boolean; ForceAllForms: Boolean ): Boolean;

    function UpdateConfig: Boolean;
    function GetSourcePath: TFileName;
    function GetProjectDest: String;
    function GetBuild: Boolean;
    procedure SetBuild(const Value: Boolean);
    function GetIsKOLProject: Boolean;
    procedure SetIsKOLProject(const Value: Boolean);
    function GetOutdcuPath: TFileName;
    procedure SetOutdcuPath(const Value: TFileName);
    procedure SetAutoBuild(const Value: Boolean);
    function GetShowReport: Boolean;
    procedure SetAutoBuildDelay(const Value: Integer);
    procedure SetConsoleOut(const Value: Boolean);
    procedure SetLocked(const Value: Boolean);
    procedure SetSupportAnsiMnemonics(const Value: LCID);
    procedure SetPaintType(const Value: TPaintType);
    procedure SetHelpFile(const Value: String);
    procedure SetLocalizy(const Value: Boolean);
    procedure SetShowHint(const Value: Boolean);
  protected
    FLocked: Boolean;
    function GenerateDPR( const Path: String ): Boolean; virtual;
    procedure BeforeGenerateDPR( const SL: TStringList; var Updated: Boolean ); virtual;
    procedure AfterGenerateDPR( const SL: TStringList; var Updated: Boolean ); virtual;
    procedure TimerTick( Sender: TObject );
    property AutoBuilding: Boolean read fAutoBuilding write fAutoBuilding;
    procedure BroadCastPaintTypeToAllForms;
    procedure Loaded; override;
    procedure SetName(const NewName: TComponentName); override;
  protected
    ResStrings: TStringList;
    function StringConstant( const Propname, Value: String ): String;
    procedure MakeResourceString( const ResourceConstName, Value: String );
  public
    procedure Change;
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure Report( const Txt: String );
    property Building: Boolean read FBuilding;
  published
    property Locked: Boolean read FLocked write SetLocked;

    property Localizy: Boolean read FLocalizy write SetLocalizy;

    // Name of source, i.e. mirror project. Detected by reading text of
    // Delphi IDE window. Can be corrected in Object Inspector.
    //
    // Имя проекта (зеркального, т.е. исходного). Определяется просто - по
    // заголовку окна Delphi IDE. Можно изменить руками.
    property projectName: String read GetProjectName write fProjectName;

    // Project name for converted (KOL) project. Must be entered manually,
    // and it must not much project name.
    // Имя проекта после конверсии в KOL. Требуется ввести руками.
    // Ни в коем случае не должен совпадать с именем самого проекта.
    property projectDest: String read GetProjectDest write SetProjectDest;

    // Path to source (=mirror) project. When TKOLProject component is
    // dropped onto form, a dialog is appear to select path to a directory
    // with source files of the project. Resulting project is store in
    // \KOL subdirectory of the path. Path to a source is necessary to
    // generate KOL project on base of mirror one.
    //
    // Путь к исходному проекту. При бросании компонента TKOLProject на
    // форму вываливается диалог с предложением указать путь к исходному
    // проекту. Результирующий проект (после конвертации в KOL) будет лежать
    // в поддиректории \KOL исходной папки. Без знания данного пути зеркала
    // форм не смогут найти свои исходные файлы.
    property sourcePath: TFileName read GetSourcePath write fSourcePath;

    property outdcuPath: TFileName read GetOutdcuPath write SetOutdcuPath;

    // True, if to include {$R *.RES} while generating dpr-file.
    // Истина, если включать ресурс проекта (иконка 'MAINICON' в файле
    // имя-проекта.res).
    property dprResource: Boolean read fDprResource write fDprResource;

    // True, if all generated files to be marked Read-Only (by default,
    // since it is suggested to correct only source (=mirror) files.
    // === no more used ===
    //
    // Истина, если делать результирующие файлы READ-ONLY (по умолчанию,
    // т.к. предполагается, что эти файлы не надо можифицировать вручную)
    // === более не используется ===
    property protectFiles: Boolean read fProtect write fProtect;

    property showReport: Boolean read GetShowReport write fShowReport;

    // True, if project is converted already to KOL. Since this,
    // it can be adjusted at design-time using visual capabilities
    // of Delphi IDE and when compiled only non-VCL features are
    // included into executable, so it is ten times smaller.
    property isKOLProject: Boolean read GetIsKOLProject write SetIsKOLProject;

    property autoBuild: Boolean read fAutoBuild write SetAutoBuild;
    property autoBuildDelay: Integer read FAutoBuildDelay write SetAutoBuildDelay;
    property BUILD: Boolean read GetBuild write SetBuild;
    property consoleOut: Boolean read FConsoleOut write SetConsoleOut;

    property SupportAnsiMnemonics: LCID read FSupportAnsiMnemonics write SetSupportAnsiMnemonics;
    {* Change this value to provide supporting of ANSI (localized) mnemonics.
       To have effect for a form, property SupportMnemonics should be set to
       TRUE for such form too. This value should be set to a number, correspondent
       to locale which is desired to be supported. Or, set it to value 1, to
       support default user locale of the system where the project is built.  }

    property PaintType: TPaintType read FPaintType write SetPaintType;

    property HelpFile: String read FHelpFile write SetHelpFile;
    property ShowHint: Boolean read FShowHint write SetShowHint;
    {* To provide tooltip (hint) showing, it is necessary to define conditional
       symbol USE_MHTOOLTIP in
       Project|Options|Directories/Conditionals|Conditional Defines. }
  end;

  TKOLProjectBuilder = class( TComponentEditor )
  private
  protected
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

























  TKOLFont = class( TPersistent )
  private
    fOwner: TComponent;
    FFontCharset: Byte;
    FFontOrientation: Integer;
    FFontWidth: Integer;
    FFontHeight: Integer;
    FFontWeight: Integer;
    FFontName: String;
    FColor: TColor;
    FFontPitch: TFontPitch;
    FFontStyle: TFontStyles;
    fChangingNow: Boolean;
    procedure SetColor(const Value: TColor);
    procedure SetFontCharset(const Value: Byte);
    procedure SetFontHeight(const Value: Integer);
    procedure SetFontName(const Value: String);
    procedure SetFontOrientation(Value: Integer);
    procedure SetFontPitch(const Value: TFontPitch);
    procedure SetFontStyle(const Value: TFontStyles);
    procedure SetFontWeight(Value: Integer);
    procedure SetFontWidth(const Value: Integer);
  protected
    procedure Changing;
  public
    procedure Change;
    constructor Create( AOwner: TComponent );
    function Equal2( AFont: TKOLFont ): Boolean;
    procedure GenerateCode( SL: TStrings; const AName: String; AFont: TKOLFont );
    procedure Assign( Value: TPersistent ); override;
    property Owner: TComponent read fOwner;
  published
    property Color: TColor read FColor write SetColor;
    property FontStyle: TFontStyles read FFontStyle write SetFontStyle;
    property FontHeight: Integer read FFontHeight write SetFontHeight;
    property FontWidth: Integer read FFontWidth write SetFontWidth;
    property FontWeight: Integer read FFontWeight write SetFontWeight;
    property FontName: String read FFontName write SetFontName;
    property FontOrientation: Integer read FFontOrientation write SetFontOrientation;
    property FontCharset: Byte read FFontCharset write SetFontCharset;
    property FontPitch: TFontPitch read FFontPitch write SetFontPitch;
  end;

  TKOLBrush = class( TPersistent )
  private
    fOwner: TComponent;
    FBrushStyle: TBrushStyle;
    FColor: TColor;
    FBitmap: TBitmap;
    fChangingNow: Boolean;
    procedure SetBitmap(const Value: TBitmap);
    procedure SetBrushStyle(const Value: TBrushStyle);
    procedure SetColor(const Value: TColor);
  protected
    procedure GenerateCode( SL: TStrings; const AName: String );
  public
    procedure Change;
    constructor Create( AOwner: TComponent );
    destructor Destroy; override;
    procedure Assign( Value: TPersistent ); override;
  published
    property Color: TColor read FColor write SetColor;
    property BrushStyle: TBrushStyle read FBrushStyle write SetBrushStyle;
    property Bitmap: TBitmap read FBitmap write SetBitmap;
  end;
















  //============================================================================
  // Mirror class, corresponding to unnecessary in KOL application
  // taskbar button (variable Applet).
  //
  // Зеркальный класс, соответствующий необязательному в KOL
  // приложению (окну, представляющему кнопку приложения на панели
  // задач)
  TKOLApplet = class( TComponent )
  private
    FLastWarnTimeAbtMainForm: Integer;
    FShowingWarnAbtMainForm: Boolean;
    FOnMessage: TOnMessage;
    FOnDestroy: TOnEvent;
    FOnClose: TOnEventAccept;
    FIcon: String;
    fChangingNow: Boolean;
    FOnQueryEndSession: TOnEventAccept;
    FOnMinimize: TOnEvent;
    FOnRestore: TOnEvent;
    FAllBtnReturnClick: Boolean;
    FTag: Integer;
    FForceIcon16x16: Boolean;
    FTabulate: Boolean;
    FTabulateEx: Boolean;
    procedure SetCaption(const Value: String);
    procedure SetVisible(const Value: Boolean);
    procedure SetEnabled(const Value: Boolean);
    procedure SetOnMessage(const Value: TOnMessage);
    procedure SetOnDestroy(const Value: TOnEvent);
    procedure SetOnClose(const Value: TOnEventAccept);
    procedure SetIcon(const Value: String);
    procedure SetOnQueryEndSession(const Value: TOnEventAccept);
    procedure SetOnMinimize(const Value: TOnEvent);
    procedure SetOnRestore(const Value: TOnEvent);
    procedure SetAllBtnReturnClick(const Value: Boolean);
    procedure SetTag(const Value: Integer);
    procedure SetForceIcon16x16(const Value: Boolean);
    procedure SetTabulate(const Value: Boolean);
    procedure SetTabulateEx(const Value: Boolean);
  protected
    fCaption: String;
    fVisible, fEnabled: Boolean;
    FChanged: Boolean;
    fSourcePath: String;
    fIsDestroying: Boolean;
    //Creating_DoNotGenerateCode: Boolean;
    procedure GenerateRun( SL: TStringList; const AName: String ); virtual;
    function AutoCaption: Boolean; virtual;
    procedure ChangeDPR; virtual;

    // Method to assign values to assigned events. Is called in SetupFirst
    // and actually should call DoAssignEvents, passing a list of (additional)
    // events to it.
    //
    // Процедура присваивания значений назначенным событиям. Вызывается из
    // SetupFirst и фактически должна (после вызова inherited) передать
    // в процедуру DoAssignEvents список (дополнительных) событий.
    procedure AssignEvents( SL: TStringList; const AName: String ); virtual;

    procedure DoAssignEvents( SL: TStringList; const AName: String;
              EventNames: array of PChar; EventHandlers: array of Pointer );

    function BestEventName: String; virtual;
  public
    procedure Change( Sender: TComponent ); virtual;
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    property Enabled: Boolean read fEnabled write SetEnabled;
  published
    property Icon: String read FIcon write SetIcon;
    property ForceIcon16x16: Boolean read FForceIcon16x16 write SetForceIcon16x16;
    property Caption: String read fCaption write SetCaption;
    property Visible: Boolean read fVisible write SetVisible;
    property OnMessage: TOnMessage read FOnMessage write SetOnMessage;
    property OnDestroy: TOnEvent read FOnDestroy write SetOnDestroy;
    property OnClose: TOnEventAccept read FOnClose write SetOnClose;
    property OnQueryEndSession: TOnEventAccept read FOnQueryEndSession write SetOnQueryEndSession;
    property OnMinimize: TOnEvent read FOnMinimize write SetOnMinimize;
    property OnRestore: TOnEvent read FOnRestore write SetOnRestore;
    property AllBtnReturnClick: Boolean read FAllBtnReturnClick write SetAllBtnReturnClick;
    property Tag: Integer read FTag write SetTag;
    property Tabulate: Boolean read FTabulate write SetTabulate;
    property TabulateEx: Boolean read FTabulateEx write SetTabulateEx;
    property UnitSourcePath: String read fSourcePath write fSourcePath;
  end;

  // Special class to avoid conflict with Left and Top properties of
  // component in VCL and component TKOLForm correspondent properties.
  //
  // Специальный класс, чтобы обойти конфликт со свойствами Left / Top
  // в Bounds формы (в компоненте TKOLForm).
  TFormBounds = class( TPersistent )
  private
    fOwner: TComponent;
    fTimer: TTimer;
    fL, fT, fW, fH: Integer;
    function GetHeight: Integer;
    function GetLeft: Integer;
    function GetTop: Integer;
    function GetWidth: Integer;
    procedure SetHeight(const Value: Integer);
    procedure SetLeft(const Value: Integer);
    procedure SetTop(const Value: Integer);
    procedure SetWidth(const Value: Integer);
    procedure CheckFormSize( Sender: TObject );
    procedure SetOwner(const Value: TComponent);
  protected
  public
    procedure Change;
    constructor Create;
    destructor Destroy; override;
    property Owner: TComponent read fOwner write SetOwner;
    procedure EnableTimer(Value: Boolean);
  published
    property Left: Integer read GetLeft write SetLeft stored False;
    property Top: Integer read GetTop write SetTop stored False;
    property Width: Integer read GetWidth write SetWidth stored False;
    property Height: Integer read GetHeight write SetHeight stored False;
  end;


























  //============================================================================
  // Mirror component, corresponding to KOL's form. It must be present
  // on each of mirror project's form to provide generating of corresponding
  // unit in resulting KOL project.
  //
  // Форме из KOL соответствует зеркальный компонент TKOLForm. Он должен
  // присутствовать на форме зеркального проекта для того, чтобы при запуске
  // его сгенерировался код соответствующего модуля для компиляции с
  // использованием KOL. Кроме того, модифицируя его свойства в Инспекторе,
  // возможно настроить свойства формы KOL "визуально".
  TKOLCustomControl = class;
  TKOLPopupMenu = class;

  TLocalizyOptions = ( loForm, loNo, loYes  );

  TKOLFormBorderStyle = ( fbsNone, fbsSingle, fbsDialog, fbsToolWindow );  {YS}

  TKOLForm = class( TKOLApplet )
  private
    fFormMain: Boolean;
    fFormUnit: String;
    fBounds: TFormBounds;
    fDefaultSize: Boolean;
    fMargin: Integer;
    fDefaultPos: Boolean;
    fCanResize: Boolean;
    fCenterOnScr: Boolean;
    FPreventResizeFlicks: Boolean;
    FDoubleBuffered: Boolean;
    FTransparent: Boolean;
    FAlphaBlend: Integer;
    FHasBorder: Boolean;
    FStayOnTop: Boolean;
    FHasCaption: Boolean;
    FCtl3D: Boolean;
    FModalResult: Integer;
    FWindowState: KOL.TWindowState;
    FOnChar: TOnChar;
    fOnClick: TOnEvent;
    FOnLeave: TOnEvent;
    FOnMouseEnter: TOnEvent;
    FOnEnter: TOnEvent;
    FOnMouseLeave: TOnEvent;
    FOnKeyUp: TOnKey;
    FOnKeyDown: TOnKey;
    FOnMouseMove: TOnMouse;
    FOnMouseWheel: TOnMouse;
    FOnMouseDown: TOnMouse;
    FOnMouseUp: TOnMouse;
    FOnResize: TOnEvent;
    FMaximizeIcon: Boolean;
    FMinimizeIcon: Boolean;
    FCloseIcon: Boolean;
    FIcon: String;
    FCursor: String;
    fFont: TKOLFont;
    fBrush: TKOLBrush;
    FOnFormCreate: TOnEvent;
    FParentLikeFontControls: TList;
    FParentLikeColorControls: TList;
    FMinimizeNormalAnimated: Boolean;
    FOnShow: TOnEvent;
    FOnHide: TOnEvent;
    FzOrderChildren: Boolean;
    FSimpleStatusText: String;
    FStatusText: TStringList;
    fOnMouseDblClk: TOnMouse;
    FMarginLeft: Integer;
    FMarginTop: Integer;
    FMarginBottom: Integer;
    FMarginRight: Integer;
    FOnEraseBkgnd: TOnPaint;
    FOnPaint: TOnPaint;
    FEraseBackground: Boolean;
    FOnMove: TOnEvent;
    FSupportMnemonics: Boolean;
    FStatusSizeGrip: Boolean;
    FPaintType: TPaintType;
    FRealignTimer: TTimer;
    FChangeTimer: TTimer;
    FMinWidth: Integer;
    FMaxWidth: Integer;
    FMinHeight: Integer;
    FMaxHeight: Integer;
    FOnDropFiles: TOnDropFiles;
    FpopupMenu: TKOLPopupMenu;
    FOnMaximize: TOnEvent;
    FLocalizy: Boolean;
    FHelpContext: Integer;
    FhelpContextIcon: Boolean;
    FOnHelp: TOnHelp;
    fDefaultBtnCtl, fCancelBtnCtl: TKOLCustomControl;
    FborderStyle: TKOLFormBorderStyle;  {YS}
    FGetShowHint: Boolean;
    FOnBeforeCreateWindow: TOnEvent;  {YS}
    function GetFormUnit: String;
    procedure SetFormMain(const Value: Boolean);
    procedure SetFormUnit(const Value: String);
    function GetFormMain: Boolean;

    function GetSelf: TKOLForm;
    procedure SetDefaultSize(const Value: Boolean);
    procedure SetMargin(const Value: Integer);
    procedure SetDefaultPos(const Value: Boolean);
    procedure SetCanResize(const Value: Boolean);
    procedure SetCenterOnScr(const Value: Boolean);
    procedure SetAlphaBlend(Value: Integer);
    procedure SetDoubleBuffered(const Value: Boolean);
    procedure SetPreventResizeFlicks(const Value: Boolean);
    procedure SetTransparent(const Value: Boolean);
    procedure SetHasBorder(const Value: Boolean);
    procedure SetStayOnTop(const Value: Boolean);
    procedure SetHasCaption(const Value: Boolean);
    procedure SetCtl3D(const Value: Boolean);
    procedure SetModalResult(const Value: Integer);
    procedure SetWindowState(const Value: KOL.TWindowState);
    procedure SetOnChar(const Value: TOnChar);
    procedure SetOnClick(const Value: TOnEvent);
    procedure SetOnEnter(const Value: TOnEvent);
    procedure SetOnKeyDown(const Value: TOnKey);
    procedure SetOnKeyUp(const Value: TOnKey);
    procedure SetOnLeave(const Value: TOnEvent);
    procedure SetOnMouseDown(const Value: TOnMouse);
    procedure SetOnMouseEnter(const Value: TOnEvent);
    procedure SetOnMouseLeave(const Value: TOnEvent);
    procedure SetOnMouseMove(const Value: TOnMouse);
    procedure SetOnMouseUp(const Value: TOnMouse);
    procedure SetOnMouseWheel(const Value: TOnMouse);
    procedure SetOnResize(const Value: TOnEvent);
    procedure SetMaximizeIcon(const Value: Boolean);
    procedure SetMinimizeIcon(const Value: Boolean);
    procedure SetCloseIcon(const Value: Boolean);
    procedure SetCursor(const Value: String);
    procedure SetIcon(const Value: String);
    function Get_Color: TColor;
    procedure Set_Color(const Value: TColor);
    procedure SetFont(const Value: TKOLFont);
    procedure SetBrush(const Value: TKOLBrush);
    procedure SetOnFormCreate(const Value: TOnEvent);
    procedure CollectChildrenWithParentFont;
    procedure ApplyFontToChildren;
    procedure CollectChildrenWithParentColor;
    procedure ApplyColorToChildren;
    procedure SetMinimizeNormalAnimated(const Value: Boolean);
    procedure SetLocked(const Value: Boolean);
    procedure SetOnShow(const Value: TOnEvent);
    procedure SetOnHide(const Value: TOnEvent);
    procedure SetzOrderChildren(const Value: Boolean);
    procedure SetSimpleStatusText(const Value: String);
    function GetStatusText: TStrings;
    procedure SetStatusText(const Value: TStrings);
    procedure SetOnMouseDblClk(const Value: TOnMouse);
    procedure SetMarginBottom(const Value: Integer);
    procedure SetMarginLeft(const Value: Integer);
    procedure SetMarginRight(const Value: Integer);
    procedure SetMarginTop(const Value: Integer);
    procedure SetOnEraseBkgnd(const Value: TOnPaint);
    procedure SetOnPaint(const Value: TOnPaint);
    procedure SetEraseBackground(const Value: Boolean);
    procedure SetOnMove(const Value: TOnEvent);
    procedure SetSupportMnemonics(const Value: Boolean);
    procedure SetStatusSizeGrip(const Value: Boolean);
    procedure SetPaintType(const Value: TPaintType);
    procedure SetMaxHeight(const Value: Integer);
    procedure SetMaxWidth(const Value: Integer);
    procedure SetMinHeight(const Value: Integer);
    procedure SetMinWidth(const Value: Integer);
    procedure SetOnDropFiles(const Value: TOnDropFiles);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
    procedure SetOnMaximize(const Value: TOnEvent);
    procedure SetLocalizy(const Value: Boolean);
    procedure SetHelpContext(const Value: Integer);
    procedure SethelpContextIcon(const Value: Boolean);
    procedure SetOnHelp(const Value: TOnHelp);
    procedure SetborderStyle(const Value: TKOLFormBorderStyle); {YS}
    procedure SetShowHint(const Value: Boolean);
    function GetShowHint: Boolean;
    procedure SetOnBeforeCreateWindow(const Value: TOnEvent); {YS}
  protected
    fUniqueID: Integer;
    FLocked: Boolean;
    //function CollectOtherFakes: String;
    function AdditionalUnits: String; virtual;
    function FormTypeName: String; virtual;
    function AppletOnForm: Boolean;
    function GetCaption: String; virtual;
    procedure SetFormCaption(const Value: String); virtual;
    function GetFormName: String;
    procedure SetFormName(const Value: String);
    function GenerateTransparentInits: String; virtual;
    function Result_Form: String; virtual;

    function StringConstant( const Propname, Value: String ): String;
  public
    procedure Change( Sender: TComponent ); override;
    // Methods to generate code of unit, containing form definition.
    // Методы, в которых генерится код модуля, содержащего форму
    procedure DoChangeNow;

    function GenerateUnit( const Path: String ): Boolean; virtual;
  protected
    function GeneratePAS( const Path: String; var Updated: Boolean ): Boolean; virtual;
    procedure AfterGeneratePas( SL: TStringList ); virtual;
    function GenerateINC( const Path: String; var Updated: Boolean ): Boolean; virtual;
    procedure GenerateChildren( SL: TStringList; OfParent: TComponent;
              const OfParentName: String; const Prefix: String;
              var Updated: Boolean );
    procedure GenerateCreateForm( SL: TStringList ); virtual;
    procedure GenerateDestroyAfterRun( SL: TStringList ); virtual;
    procedure GenerateAdd2AutoFree( SL: TStringList; const AName: String; AControl: Boolean;
              Add2AutoFreeProc: String; Obj: TObject ); virtual;

    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );
              virtual;

    // Is called after constructing of all child controls and objects
    // to generate final initialization if needed (only for form object
    // itself). Now, CanResize property assignment to False is placed
    // here.
    //
    // Вызывается уже после генерации конструирования всех
    // дочерних контролов и объектов формы - для генерации какой-либо
    // завершающей инициализации (самой формы):
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String );
              virtual;

    // Method to assign values to assigned events. Is called in SetupFirst
    // and actually should call DoAssignEvents, passing a list of (additional)
    // events to it.
    //
    // Процедура присваивания значений назначенным событиям. Вызывается из
    // SetupFirst и фактически должна (после вызова inherited) передать
    // в процедуру DoAssignEvents список (дополнительных) событий.
    procedure AssignEvents( SL: TStringList; const AName: String ); override;

    property PaintType: TPaintType read FPaintType write SetPaintType;
    procedure InvalidateControls;
    procedure Loaded; override;
    procedure GetPaintTypeFromProjectOrOtherForms;
    function DoNotGenerateSetPosition: Boolean; virtual;
    procedure RealignTimerTick( Sender: TObject );
    procedure ChangeTimerTick( Sender: TObject );

    function BestEventName: String; override;
  protected
    ResStrings: TStringList;
    procedure MakeResourceString( const ResourceConstName, Value: String );
  public
    AllowRealign: Boolean;
    FRealigning: Integer;

    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    function NextUniqueID: Integer;

    // Attention! This is very important definition. While designing
    // mirror form, and writing code in event handlers, such wizard
    // word must be used everywhere instead default (usually skipped)
    // word 'Self'. For instance, do not write in your handler
    //   Left := 100; Such code will be correct only while compiling
    // mirror project itself, but after converting to KOL an error
    // will be detected by the compiler. Write instead:
    //   Form.Left := 100; And this will be correct both in mirror
    // project and in resulting KOL project.
    //
    // Внимание! Здесь определяется важное слово. В проектировании
    // зеркальных форм это волшебное слово должно быть использовано
    // везде, где ранее можно было опустить подразумеваемое слово
    // Self. Например, в обработчике нельзя написать Left := 100;
    // Такой код будет правильным при компиляции зеркала, но после
    // конверсии в KOL при попытке оттранслировать проект транслятор
    // выдаст ошибку. Следует писать Form.Left := 100; И тогда это
    // будет правильно в обоих проектах.
    property Form: TKOLForm read GetSelf;
    property ModalResult: Integer read FModalResult write SetModalResult;
    property Margin: Integer read fMargin write SetMargin;
    procedure AlignChildren( PrntCtrl: TKOLCustomControl; Recursive: Boolean );
  published
    property Locked: Boolean read FLocked write SetLocked;

    //property AutoCreate: Boolean read GetAutoCreate write fAutoCreate;

    // Property FormName - just shows name of VCL form (it is possible to change
    // it in Object Inspaector). This name will be used as a name of correspondent
    // variable of type P<FormName> in generated unit (which actually is not
    // form, but contains Form: PControl as a field).
    //
    // Свойство FormName - просто показывает имя формы VCL (еще его можно здесь
    // же изменить). Это имя будет использовано как имя соответствующей
    // переменной формы типа P<FormName> в сгенерированном модуле для KOL-проекта.
    // Эта переменная не есть точное соответствие форме, но содержит переменую
    // Form: PControl, в действительности соответствующую ей.
    property formName: String read GetFormName write SetFormName stored False;

    // Unit name, containing form definition.
    // Имя модуля, в котором содержится форма.
    property formUnit: String read GetFormUnit write SetFormUnit;

    // Form is marked 'main', if it contain also TKOLProject component.
    // (Main form in KOL playes special role, and can even replace
    // Applet object if this last is not needed in KOL project - to make
    // application taskbar button ivisible, for instance).
    //
    // Форма считается главной, если именно на нее положен компонент
    // TKOLProject. Соответственно здесь возвращается True, только если
    // TKOLForm лежит на той же форме, что и TKOLProject. (В KOL главная
    // форма выполняет особую роль, и даже может замещать собой объект
    // Applet при его отсутствии).
    property formMain: Boolean read GetFormMain write SetFormMain;

    property Caption: String read GetCaption write SetFormCaption;
    property Visible;
    property Enabled;

    property bounds: TFormBounds read fBounds;
    property defaultSize: Boolean read fDefaultSize write SetDefaultSize;
    property defaultPosition: Boolean read fDefaultPos write SetDefaultPos;
    property MinWidth: Integer read FMinWidth write SetMinWidth;
    property MinHeight: Integer read FMinHeight write SetMinHeight;
    property MaxWidth: Integer read FMaxWidth write SetMaxWidth;
    property MaxHeight: Integer read FMaxHeight write SetMaxHeight;

    property HasBorder: Boolean read FHasBorder write SetHasBorder;
    property HasCaption: Boolean read FHasCaption write SetHasCaption;
    property StayOnTop: Boolean read FStayOnTop write SetStayOnTop;
    property CanResize: Boolean read fCanResize write SetCanResize;
    property CenterOnScreen: Boolean read fCenterOnScr write SetCenterOnScr;
    property Ctl3D: Boolean read FCtl3D write SetCtl3D;
    property WindowState: KOL.TWindowState read FWindowState write SetWindowState;

    // These three properties are for design time only:
    property minimizeIcon: Boolean read FMinimizeIcon write SetMinimizeIcon;
    property maximizeIcon: Boolean read FMaximizeIcon write SetMaximizeIcon;
    property closeIcon: Boolean read FCloseIcon write SetCloseIcon;
    property helpContextIcon: Boolean read FhelpContextIcon write SethelpContextIcon;
    property borderStyle: TKOLFormBorderStyle read FborderStyle write SetborderStyle; {YS}
    property HelpContext: Integer read FHelpContext write SetHelpContext;

    // Properties Icon and Cursor at design time are represented as strings.
    // These allow to autoload real Icon: HIcon and Cursor: HCursor from
    // resource with given name. Type here name of resource and use $R directive
    // to include correspondent res-file into executable.
    //
    // В дизайнере свойства Icon и Cursor являются строками, представляющими
    // собой имена соответствующих ресурсов. Для подключения файлов, содержащих
    // эти ресурсы, используйте в своем проекте директиву $R.
    property Icon: String read FIcon write SetIcon;
    property Cursor: String read FCursor write SetCursor;

    property Color: TColor read Get_Color write Set_Color;
    property Font: TKOLFont read fFont write SetFont;
    property Brush: TKOLBrush read FBrush write SetBrush;

    property DoubleBuffered: Boolean read FDoubleBuffered write SetDoubleBuffered;
    property PreventResizeFlicks: Boolean read FPreventResizeFlicks write SetPreventResizeFlicks;
    property Transparent: Boolean read FTransparent write SetTransparent;
    property AlphaBlend: Integer read FAlphaBlend write SetAlphaBlend;

    property Border: Integer read fMargin write SetMargin;
    property MarginLeft: Integer read FMarginLeft write SetMarginLeft;
    property MarginRight: Integer read FMarginRight write SetMarginRight;
    property MarginTop: Integer read FMarginTop write SetMarginTop;
    property MarginBottom: Integer read FMarginBottom write SetMarginBottom;

    property MinimizeNormalAnimated: Boolean read FMinimizeNormalAnimated write SetMinimizeNormalAnimated;
    property zOrderChildren: Boolean read FzOrderChildren write SetzOrderChildren;

    property SimpleStatusText: String read FSimpleStatusText write SetSimpleStatusText;
    property StatusText: TStrings read GetStatusText write SetStatusText;
    property statusSizeGrip: Boolean read FStatusSizeGrip write SetStatusSizeGrip;

    property Localizy: Boolean read FLocalizy write SetLocalizy;
    property ShowHint: Boolean read GetShowHint write SetShowHint;
    {* To provide tooltip (hint) showing, it is necessary to define conditional
       symbol USE_MHTOOLTIP in
       Project|Options|Directories/Conditionals|Conditional Defines. }

    property OnClick: TOnEvent read fOnClick write SetOnClick;
    property OnMouseDblClk: TOnMouse read fOnMouseDblClk write SetOnMouseDblClk;
    property OnMouseDown: TOnMouse read FOnMouseDown write SetOnMouseDown;
    property OnMouseMove: TOnMouse read FOnMouseMove write SetOnMouseMove;
    property OnMouseUp: TOnMouse read FOnMouseUp write SetOnMouseUp;
    property OnMouseWheel: TOnMouse read FOnMouseWheel write SetOnMouseWheel;
    property OnMouseEnter: TOnEvent read FOnMouseEnter write SetOnMouseEnter;
    property OnMouseLeave: TOnEvent read FOnMouseLeave write SetOnMouseLeave;
    property OnEnter: TOnEvent read FOnEnter write SetOnEnter;
    property OnLeave: TOnEvent read FOnLeave write SetOnLeave;
    property OnKeyDown: TOnKey read FOnKeyDown write SetOnKeyDown;
    property OnKeyUp: TOnKey read FOnKeyUp write SetOnKeyUp;
    property OnChar: TOnChar read FOnChar write SetOnChar;
    property OnResize: TOnEvent read FOnResize write SetOnResize;
    property OnMove: TOnEvent read FOnMove write SetOnMove;
    property OnDestroy;
    property OnShow: TOnEvent read FOnShow write SetOnShow;
    property OnHide: TOnEvent read FOnHide write SetOnHide;
    property OnDropFiles: TOnDropFiles read FOnDropFiles write SetOnDropFiles;

    property OnFormCreate: TOnEvent read FOnFormCreate write SetOnFormCreate;
    property OnPaint: TOnPaint read FOnPaint write SetOnPaint;
    property OnEraseBkgnd: TOnPaint read FOnEraseBkgnd write SetOnEraseBkgnd;
    property EraseBackground: Boolean read FEraseBackground write SetEraseBackground;
    property supportMnemonics: Boolean read FSupportMnemonics write SetSupportMnemonics;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property OnMaximize: TOnEvent read FOnMaximize write SetOnMaximize;
    property OnHelp: TOnHelp read FOnHelp write SetOnHelp;

    property OnBeforeCreateWindow: TOnEvent read FOnBeforeCreateWindow write SetOnBeforeCreateWindow;
  end;



























  TNotifyOperation = ( noRenamed, noRemoved, noChanged );


  //============================================================================
  // Mirror class TKOLObj approximately corresponds to TObj type in
  // KOL objects hierarchy. Here we use it as a base to produce mirror
  // classes, correspondent to non-visual objects in KOL.
  //
  // Зеркальный класс TKOLObj приблизительно соответствует типу TObj
  // в иерархии объектов KOL. От него производятся классы, зеркальные
  // невизуальным объектам KOL.
  TKOLObj = class( TComponent )
  private
    FOnDestroy: TOnEvent;
    F_Tag: Integer;
    FLocalizy: TLocalizyOptions;
    function Get_Tag:Integer ;
    procedure SetOnDestroy(const Value: TOnEvent);
    procedure Set_Tag(const Value: Integer);
    procedure SetLocalizy(const Value: TLocalizyOptions);
  protected
    fUpdated: Boolean;

    // A list of components which are linked to the TKOLObj component
    // and must be notifyed when the TKOLObj component is renamed or
    // removed from a form at design time.
    fNotifyList: TList;

    // This priority is used to determine objects of which types should be
    // created before others
    fCreationPriority: Integer;

    // NeedFree is used during code generation to determine if to
    // generate code to destroy the object together with destroying of
    // owning form (Usually True, but some objects, like ImageList
    // can be self-destructing).
    //
    // Поле NeedFree используется в конвертере для определения того,
    // подлежит ли объект принудительному уничтожению методом Free
    // вместе с экземпляром его формы (обычно да, но могут быть объекты
    // вроде ImageList'а, которые разрушают себя сами).
    NeedFree: Boolean;

    procedure SetName( const NewName: TComponentName ); override;
    procedure FirstCreate; virtual;
    function AdditionalUnits: String; virtual;
    procedure GenerateTag( SL: TStringList; const AName, APrefix: String );

    // This method adds operators of creation of object to the end of SL
    // and following ones for adjusting object properties and events.
    //
    // Процедура, которая добавляет в конец SL (:TStringList) операторы
    // создания объекта и те операторы настройки его свойств, которые
    // должны исполняться немедленно вслед за конструированием объекта:
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );
              virtual;

    // The same as above, but is called after generating of code to
    // create all child controls and objects - to insert final initialization
    // code (if needed).
    //
    // Аналогично, но вызывается уже после генерации конструирования всех
    // дочерних контролов и объектов формы - для генерации какой-либо
    // завершающей инициализации:
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String );
              virtual;

    procedure DoGenerateConstants( SL: TStringList ); virtual;

    procedure AssignEvents( SL: TStringList; const AName: String ); virtual;

    procedure DoAssignEvents( SL: TStringList; const AName: String;
              EventNames: array of PChar; EventHandlers: array of Pointer );
    function BestEventName: String; virtual;
    function NotAutoFree: Boolean; virtual;
    function CompareFirst(c, n: string): boolean; virtual;
    function StringConstant( const Propname, Value: String ): String;
  public
    procedure Change; virtual;
    function ParentKOLForm: TKOLForm;
    function OwnerKOLForm( AOwner: TComponent ): TKOLForm;
    function ParentForm: TForm;

    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure AddToNotifyList( Sender: TComponent );

    // procedure which is called by linked components, when those are
    // renamed or removed at design time.
    procedure NotifyLinkedComponent( Sender: TObject; Operation: TNotifyOperation );
              virtual;
    procedure DoNotifyLinkedComponents( Operation: TNotifyOperation );

    // Returns type name without <TKol> prefix. (TKOLTimer -> Timer).
    //
    // Данная функция возвращает имя типа объекта KOL (например,
    // зеркальный класс TKOLImageList соответствует типу TImageList в
    // KOL, возвращается 'ImageList').
    function TypeName: String; virtual;
    property Localizy: TLocalizyOptions read FLocalizy write SetLocalizy;

    property CreationPriority: Integer read fCreationPriority;

  published
    property Tag: Integer read Get_Tag write Set_Tag default 0;
    property OnDestroy: TOnEvent read FOnDestroy write SetOnDestroy;
  end;

  TKOLObjectCompEditor = class( TDefaultEditor )
  private
  protected
    FContinue: Boolean;
    FCount: Integer;
    BestEventName: String;
//////////////////////////////////////////////////////////
{$IFDEF _D6orHigher}                                    //
    FFirst: IProperty;
    FBest: IProperty;
    procedure CountEvents(const PropertyEditor: IProperty );
    procedure CheckEdit(const PropertyEditor: IProperty);
    procedure EditProperty(const PropertyEditor: IProperty;
              var Continue: Boolean); override;
////////////
{$ELSE}                                                 //
//////////////////////////////////////////////////////////
    FFirst: TPropertyEditor;
    FBest: TPropertyEditor;
    procedure CountEvents( PropertyEditor: TPropertyEditor );
    procedure CheckEdit(PropertyEditor: TPropertyEditor);
    procedure EditProperty(PropertyEditor: TPropertyEditor;
      var Continue, FreeEditor: Boolean); override;
//////////////////////////////////////////////////////////
{$ENDIF}                                                //
//////////////////////////////////////////////////////////
  public
    procedure Edit; override;
  end;

  TKOLOnEventPropEditor = class( TMethodProperty )
  private
  protected
    {$IFDEF _D2}
    function GetTrimmedEventName: String;
    function GetFormMethodName: String; virtual;
    {$ENDIF _D2}
  public
    procedure Edit; override;
  end;







  //============================================================================
  //---- MIRROR FOR A MENU ----
  //---- ЗЕРКАЛО ДЛЯ МЕНЮ ----
  TKOLMenu = class;
  TKOLMenuItem = class;

  TKOLAccPrefixes = ( kapShift, kapControl, kapAlt, kapNoinvert );
  TKOLAccPrefix = set of TKOLAccPrefixes;
  TVirtualKey = ( vkNotPresent, vkBACK, vkTAB, vkCLEAR, vkENTER, vkPAUSE, vkCAPITAL,
                  vkESCAPE, vkSPACE, vkPGUP, vkPGDN, vkEND, vkHOME, vkLEFT,
                  vkUP, vkRIGHT, vkDOWN, vkSELECT, vkEXECUTE, vkPRINTSCREEN,
                  vkINSERT, vkDELETE, vkHELP, vk0, vk1, vk2, vk3, vk4, vk5,
                  vk6, vk7, vk8, vk9, vkA, vkB, vkC, vkD, vkE, vkF, vkG, vkH,
                  vkI, vkJ, vkK, vkL, vkM, vkN, vkO, vkP, vkQ, vkR, vkS, vkT,
                  vkU, vkV, vkW, vkX, vkY, vkZ, vkLWIN, vkRWIN, vkAPPS,
                  vkNUM0, vkNUM1, vkNUM2, vkNUM3, vkNUM4, vkNUM5, vkNUM6,
                  vkNUM7, vkNUM8, vkNUM9, vkMULTIPLY, vkADD, vkSEPARATOR,
                  vkSUBTRACT, vkDECIMAL, vkDIVIDE, vkF1, vkF2, vkF3, vkF4,
                  vkF5, vkF6, vkF7, vkF8, vkF9, vkF10, vkF11, vkF12, vkF13,
                  vkF14, vkF15, vkF16, vkF17, vkF18, vkF19, vkF20, vkF21,
                  vkF22, vkF23, vkF24, vkNUMLOCK, vkSCROLL, vkATTN, vkCRSEL,
                  vkEXSEL, vkEREOF, vkPLAY, vkZOOM, vkPA1, vkOEMCLEAR );

  TKOLAccelerator = class(TPersistent)
  private
    FOwner: TComponent;
    FPrefix: TKOLAccPrefix;
    FKey: TVirtualKey;
    procedure SetKey(const Value: TVirtualKey);
    procedure SetPrefix(const Value: TKOLAccPrefix);
  protected
  public
    procedure Change;
    function AsText: String;
  published
    property Prefix: TKOLAccPrefix read FPrefix write SetPrefix;
    property Key: TVirtualKey read FKey write SetKey;
  end;

  TKOLAcceleratorPropEditor = class( TPropertyEditor )
  private
  protected
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
    procedure Edit; override;
  end;

  {$IFDEF _D2orD3}
    {$WARNINGS OFF}
  {$ENDIF}
  TKOLMenuItem = class(TComponent)
  private
    FCaption: String;
    FBitmap: TBitmap;
    FSubitems: TList;
    FChecked: Boolean;
    //FRadioItem: Boolean;
    FEnabled: Boolean;
    FVisible: Boolean;
    FOnMenu: TOnMenuItem;
    FOnMenuMethodName: String;
    FSeparator: Boolean;
    FAccelerator: TKOLAccelerator;
    FParent: TComponent;
    FWindowMenu: Boolean;
    FHelpContext: Integer;
    Fdefault: Boolean;
    FRadioGroup: Integer;
    FbitmapItem: TBitmap;
    FbitmapChecked: TBitmap;
    FownerDraw: Boolean;
    FMenuBreak: TMenuBreak;
    FTag: Integer;
    Faction: TKOLAction;
    procedure SetBitmap(Value: TBitmap);
    procedure SetCaption(const Value: String);
    function GetCount: Integer;
    function GetSubItems(Idx: Integer): TKOLMenuItem;
    procedure SetChecked(const Value: Boolean);
    procedure SetEnabled(const Value: Boolean);
    procedure SetOnMenu(const Value: TOnMenuItem);
    //procedure SetRadioItem(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
    function GetMenuComponent: TKOLMenu;
    function GetUplevel: TKOLMenuItem;
    procedure SetSeparator(const Value: Boolean);
    function GetItemIndex: Integer;
    procedure SetItemIndex_Dummy(const Value: Integer);
    procedure SetAccelerator(const Value: TKOLAccelerator);
    procedure SetWindowMenu(Value: Boolean);
    procedure SetHelpContext(const Value: Integer);
    //procedure LoadRadioItem(R: TReader);
    //procedure SaveRadioItem(W: TWriter);
    procedure SetbitmapChecked(const Value: TBitmap);
    procedure SetbitmapItem(const Value: TBitmap);
    procedure Setdefault(const Value: Boolean);
    procedure SetRadioGroup(const Value: Integer);
    procedure SetownerDraw(const Value: Boolean);
    procedure SetMenuBreak(const Value: TMenuBreak);
    procedure SetTag(const Value: Integer);
    procedure Setaction(const Value: TKOLAction);
  protected
    FDestroying: Boolean;
    FSubItemCount: Integer;
    procedure SetName( const NewName: TComponentName ); override;
    procedure DefProps( const Prefix: String; Filer: TFiler );
    procedure LoadName( R: TReader );
    procedure SaveName( W: TWriter );
    procedure LoadCaption( R: TReader );
    procedure SaveCaption( W: TWriter );
    procedure LoadEnabled( R: TReader );
    procedure SaveEnabled( W: TWriter );
    procedure LoadVisible( R: TReader );
    procedure SaveVisible( W: TWriter );
    procedure LoadChecked( R: TReader );
    procedure SaveChecked( W: TWriter );
    procedure LoadRadioGroup( R: TReader );
    procedure SaveRadioGroup( W: TWriter );
    procedure LoadOnMenu( R: TReader );
    procedure SaveOnMenu( W: TWriter );
    procedure LoadSubItemCount( R: TReader );
    procedure SaveSubItemCount( W: TWriter );
    procedure LoadBitmap( R: TReader );
    procedure SaveBitmap( W: TWriter );
    procedure LoadSeparator( R: TReader );
    procedure SaveSeparator( W: TWriter );
    procedure LoadAccel( R: TReader );
    procedure SaveAccel( W: TWriter );
    procedure LoadWindowMenu( R: TReader );
    procedure SaveWindowMenu( W: TWriter );
    procedure LoadHelpContext( R: TReader );
    procedure SaveHelpContext( W: TWriter );
    procedure LoadOwnerDraw( R: TReader );
    procedure SaveOwnerDraw( W: TWriter );
    procedure LoadMenuBreak( R: TReader );
    procedure SaveMenuBreak( W: TWriter );
    procedure LoadTag( R: TReader );
    procedure SaveTag( W: TWriter );
    procedure LoadDefault( R: TReader );
    procedure SaveDefault( W: TWriter );
    procedure LoadAction( R: TReader );
    procedure SaveAction( W: TWriter );
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
//    procedure Loaded; override;
  public
    procedure Change;
    property Parent: TComponent read FParent;
    constructor Create( AOwner: TComponent; AParent, Before: TKOLMenuItem );
    {$IFDEF _D4orHigher} reintroduce; {$ENDIF}
    destructor Destroy; override;
    property MenuComponent: TKOLMenu read GetMenuComponent;
    property UplevelMenuItem: TKOLMenuItem read GetUplevel;
    property Count: Integer read GetCount;
    property SubItems[ Idx: Integer ]: TKOLMenuItem read GetSubItems;
    procedure MoveUp;
    procedure MoveDown;
    procedure SetupTemplate( SL: TStringList; FirstItem: Boolean );
    procedure SetupAttributes( SL: TStringList; const MenuName: String );
    procedure DesignTimeClick;
  published
    property Tag: Integer read FTag write SetTag;
    property caption: String read FCaption write SetCaption;
    property bitmap: TBitmap read FBitmap write SetBitmap;
    property bitmapChecked: TBitmap read FbitmapChecked write SetbitmapChecked;
    property bitmapItem: TBitmap read FbitmapItem write SetbitmapItem;
    property default: Boolean read Fdefault write Setdefault;
    property enabled: Boolean read FEnabled write SetEnabled;
    property visible: Boolean read FVisible write SetVisible;
    property checked: Boolean read FChecked write SetChecked;
    property radioGroup: Integer read FRadioGroup write SetRadioGroup;
    property separator: Boolean read FSeparator write SetSeparator;
    property accelerator: TKOLAccelerator read FAccelerator write SetAccelerator;
    property MenuBreak: TMenuBreak read FMenuBreak write SetMenuBreak;
    property ownerDraw: Boolean read FownerDraw write SetownerDraw;
    property OnMenu: TOnMenuItem read FOnMenu write SetOnMenu;

    // property ItemIndex is to show only in ObjectInspector index of the
    // item (i.e. integer number, identifying menu item in OnMenu and
    // OnMenuItem events, and also in utility methods to access item
    // properties at run time).
    property itemindex: Integer read GetItemIndex write SetItemIndex_Dummy
             stored False;
    property WindowMenu: Boolean read FWindowMenu write SetWindowMenu;
    property HelpContext: Integer read FHelpContext write SetHelpContext;
    property action: TKOLAction read Faction write Setaction;
  end;
  {$IFDEF _D2orD3}
    {$WARNINGS ON}
  {$ENDIF}

  TKOLMenu = class(TKOLObj)
  private
    FItems: TList;
    FOnMenuItem: TOnMenuItem;
    Fshowshortcuts: Boolean;
    FOnUncheckRadioItem: TOnMenuItem;
    FgenerateConstants: Boolean;
    FgenerateSeparatorConstants: Boolean;
    FOnMeasureItem: TOnMeasureItem;
    FOnDrawItem: TOnDrawItem;
    function GetCount: Integer;
    function GetItems(Idx: Integer): TKOLMenuItem;
    procedure SetOnMenuItem(const Value: TOnMenuItem);
    procedure Setshowshortcuts(const Value: Boolean);
    procedure SetOnUncheckRadioItem(const Value: TOnMenuItem);
    procedure SetgenerateConstants(const Value: Boolean);
    procedure SetgenerateSeparatorConstants(const Value: Boolean);
    procedure SetOnMeasureItem(const Value: TOnMeasureItem);
    procedure SetOnDrawItem(const Value: TOnDrawItem);
  protected
    FItemCount: Integer;
    FUpdateDisabled: Boolean;
    FUpdateNeeded: Boolean;
    procedure DefineProperties( Filer: TFiler ); override;
    procedure LoadItemCount( R: TReader );
    procedure SaveItemCount( W: TWriter );
    procedure SetName( const NewName: TComponentName ); override;
    function OnMenuItemMethodName: String;
    // Methods to generate code for creating menu:
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function NotAutoFree: Boolean; override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;

    procedure UpdateDisable;
    procedure UpdateEnable;
    procedure UpdateMenu; virtual;
  public
    ActiveDesign: TKOLMenuDesign;
    procedure Change; override;
    property Items[ Idx: Integer ]: TKOLMenuItem read GetItems;
    property Count: Integer read GetCount;
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    function NameAlreadyUsed( const ItemName: String ): Boolean;
    procedure SaveTo( WR: TWriter );
    procedure DoGenerateConstants( SL: TStringList ); override;
  published
    property OnMenuItem: TOnMenuItem read FOnMenuItem write SetOnMenuItem;
    property OnUncheckRadioItem: TOnMenuItem read FOnUncheckRadioItem write SetOnUncheckRadioItem;
    property showShortcuts: Boolean read Fshowshortcuts write Setshowshortcuts;
    property generateConstants: Boolean read FgenerateConstants write SetgenerateConstants;
    property generateSeparatorConstants: Boolean read FgenerateSeparatorConstants write SetgenerateSeparatorConstants;
    property OnMeasureItem: TOnMeasureItem read FOnMeasureItem write SetOnMeasureItem;
    property OnDrawItem: TOnDrawItem read FOnDrawItem write SetOnDrawItem;
  end;

  TKOLMainMenu = class(TKOLMenu)
  private
  protected
    FOldWndProc: Pointer;
    procedure Loaded; override;
    procedure UpdateMenu; override;
    procedure RestoreWndProc( Wnd: HWnd );
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    procedure Change; override;
    procedure RebuildMenubar;
  published
    property Localizy;
  end;

  TPopupMenuFlag = ( tpmVertical, tpmRightButton, tpmCenterAlign, tpmRightAlign,
                  tpmVCenterAlign, tpmBottomAlign, tpmHorPosAnimation,
                  tpmHorNegAnimation, tpmVerPosAnimation, tpmVerNegAnimation,
                  tpmNoAnimation, {+ecm} tpmReturnCmd {/+ecm} );
  TPopupMenuFlags = Set of TPopupMenuFlag;

  TKOLPopupMenu = class(TKOLMenu)
  private
    FOnPopup: TOnEvent;
    FFlags: TPopupMenuFlags;
    procedure SetOnPopup(const Value: TOnEvent);
    procedure SetFlags(const Value: TPopupMenuFlags);
  protected
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
  public
  published
    property Flags: TPopupMenuFlags read FFlags write SetFlags;
    property OnPopup: TOnEvent read FOnPopup write SetOnPopup;
    property Localizy;
  end;

  TKOLMenuEditor = class( TComponentEditor )
  private
  protected
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TKOLOnItemPropEditor = class( TMethodProperty )
  private
  protected
  public
    function GetValue: string; override;
    procedure SetValue(const AValue: string); override;
  end;























  // Align property (names are another then in VCL).
  // Свойство выравнивания контрола относительно клиентской части родителького
  // контрола.
  TKOLAlign = ( caNone, caLeft, caTop, caRight, caBottom, caClient );

  // Text alignment property.
  // Свойство выравнивания текста по горизонтали. Хотя и определено для всех
  // контролов, актуально только для кнопок и меток.
  TTextAlign = ( taLeft, taRight, taCenter );

  // Text vertical alignment property.
  // Свойство выравнивания текста по вертикали. Хотя и определено в KOL для
  // всех контролов, актуально только для кнопок и меток.
  TVerticalAlign = ( vaTop, vaCenter, vaBottom );









{YS}//--------------------------------------------------------------
// TKOLVCLParent is KOL control that represents VCL parent control.

  PKOLVCLParent = ^TKOLVCLParent;
  TKOLVCLParent = object(kol.TControl)
  public
    OldVCLWndProc: TWndMethod;
    procedure AttachHandle(AHandle: HWND);
    procedure AssignDynHandlers(Src: PKOLVCLParent);
  end;

  TKOLCtrlWrapper = class(TCustomControl)
  protected
    FAllowSelfPaint: boolean;
    FAllowCustomPaint: boolean;
    FAllowPostPaint: boolean;
    procedure Change; virtual;
  protected
{$IFNDEF NOT_USE_KOLCtrlWrapper}
    FKOLParentCtrl: PKOLVCLParent;
    FRealParent: boolean;
    FKOLCtrlNeeded: boolean;

    procedure RemoveParentAttach;
    procedure CallKOLCtrlWndProc(var Message: TMessage);
    function GetKOLParentCtrl: PControl;
  protected
    FKOLCtrl: PControl;

    procedure SetParent( Value: TWinControl ); override;
    procedure WndProc(var Message: TMessage); override;
    procedure DestroyWindowHandle; override;
    procedure DestroyWnd; override;
    procedure CreateWnd; override;
    procedure PaintWindow(DC: HDC); override;
    procedure SetAllowSelfPaint(const Value: boolean); virtual;
    // Override method CreateKOLControl and create instance of real KOL control within it.
    // Example: FKOLCtrl := NewGroupBox(KOLParentCtrl, '');
    procedure CreateKOLControl(Recreating: boolean); virtual;
    // if False control does not paint itself
    property AllowSelfPaint: boolean read FAllowSelfPaint write SetAllowSelfPaint;
    // Update control state according to AllowSelfPaint property
    procedure UpdateAllowSelfPaint;
    // if False and assigned FKOLCtrl then Paint method is not called for control
    property AllowCustomPaint: boolean read FAllowCustomPaint write FAllowCustomPaint;
    // if True and assigned FKOLCtrl then Paint method is called for control
    property AllowPostPaint: boolean read FAllowPostPaint write FAllowPostPaint;
    // Called when KOL control has been recreated. You must set all visual properties
    // of KOL control within this method.
    procedure KOLControlRecreated; virtual;
    // Parent of real KOL control
    property KOLParentCtrl: PControl read GetKOLParentCtrl;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure DefaultHandler(var Message); override;
    procedure Invalidate; override;
{$ENDIF NOT_USE_KOLCtrlWrapper}
  end;
{YS}//--------------------------------------------------------------














  TOnSetBounds = procedure( Sender: TObject; var NewBounds: TRect ) of object;



  //============================================================================
  // BASE CLASS FOR ALL MIRROR CONTROLS.
  // All controls in KOL are determined in a single object type
  // TControl. But in Mirror Classes Kit, we are free to have its own
  // class for every Windows GUI control.
  //
  // БАЗОВЫЙ КЛАСС ДЛЯ ВСЕХ ЗЕРКАЛЬНЫХ КОНТРОЛОВ
  // Все контролы в KOL представлены в едином объекотном типе TControl.
  // Нам никто не мешает тем не менее в визуальном варианте иметь свой
  // собственный зеркальный класс, соответствующий каждому контролу.
  TKOLCustomControl = class( TKOLCtrlWrapper )
  public
    function Generate_SetSize: String; virtual;
  private
    fClsStyle: DWORD;
    fExStyle: DWORD;
    fStyle: DWORD;
    fCaption: String;
    FTextAlign: TTextAlign;
    fMargin: Integer;
    fOnClick: TOnEvent;
    fCenterOnParent: Boolean;
    fPlaceDown: Boolean;
    fPlaceUnder: Boolean;
    fPlaceRight: Boolean;
    FCtl3D: Boolean;
    FOnDropDown: TOnEvent;
    FOnCloseUp: TOnEvent;
    FOnBitBtnDraw: TOnBitBtnDraw;
    FOnMessage: TOnMessage;
    FTabOrder: Integer;
    FShadowDeep: Integer;
    FOnMouseEnter: TOnEvent;
    FOnMouseLeave: TOnEvent;
    FOnMouseUp: TOnMouse;
    FOnMouseMove: TOnMouse;
    FOnMouseWheel: TOnMouse;
    FOnMouseDown: TOnMouse;
    FOnEnter: TOnEvent;
    FOnLeave: TOnEvent;
    FOnChar: TOnChar;
    FOnKeyUp: TOnKey;
    FOnKeyDown: TOnKey;
    FFont: TKOLFont;
    FBrush: TKOLBrush;
    FTransparent: Boolean;
    FOnChange: TOnEvent;
    FDoubleBuffered: Boolean;
    FAdjustingTabOrder: Boolean;
    FOnSelChange: TOnEvent;
    FOnPaint: TOnPaint;
    FOnResize: TOnEvent;
    FOnProgress: TOnEvent;
    FOnDeleteLVItem: TOnDeleteLVItem;
    FOnDeleteAllLVItems: TOnEvent;
    FOnLVData: TOnLVData;
    FOnCompareLVItems: TOnCompareLVItems;
    FOnColumnClick: TOnLVColumnClick;
    FOnDrawItem: TOnDrawItem;
    FOnMeasureItem: TOnMeasureItem;
    FOnDestroy: TOnEvent;
    FParentLikeFontControls: TList;
    FParentLikeColorControls: TList;
    FOnTBDropDown: TOnEvent;
    FParentColor: Boolean;
    FParentFont: Boolean;
    FOnDropFiles: TOnDropFiles;
    FOnHide: TOnEvent;
    FOnShow: TOnEvent;
    FOnRE_URLClick: TOnEvent;
    fOnMouseDblClk: TOnMouse;
    FOnRE_InsOvrMode_Change: TOnEvent;
    FOnRE_OverURL: TOnEvent;
    FCursor: String;
    FFalse: Boolean;
    FMarginTop: Integer;
    FMarginLeft: Integer;
    FMarginRight: Integer;
    FMarginBottom: Integer;
    {$IFDEF KOL_MCK}
    //FParent: PControl;
    {$ENDIF}
    FOnEraseBkgnd: TOnPaint;
    FEraseBackground: Boolean;
    FOnTVSelChanging: TOnTVSelChanging;
    FOnTVBeginDrag: TOnTVBeginDrag;
    FOnTVBeginEdit: TOnTVBeginEdit;
    FOnTVDelete: TOnTVDelete;
    FOnTVEndEdit: TOnTVEndEdit;
    FOnTVExpanded: TOnTVExpanded;
    FOnTVExpanding: TOnTVExpanding;
    FOnLVStateChange: TOnLVStateChange;
    FOnMove: TOnEvent;
    FOnSplit: TOnSplit;
    FOnEndEditLVItem: TOnEditLVItem;
    fChangingNow: Boolean;
    FTag: Integer;
    FOnScroll: TOnScroll;
    FEditTabChar: Boolean;
    FMinWidth: Integer;
    FMaxWidth: Integer;
    FMinHeight: Integer;
    FMaxHeight: Integer;
    FLocalizy: TLocalizyOptions;
    FHelpContext1: Integer;
    FDefaultBtn: Boolean;
    FCancelBtn: Boolean;
    FIsGenerateSize: Boolean;
    FIsGeneratePosition: Boolean;
    FUnicode: Boolean;
    Faction: TKOLAction;
    FWindowed: Boolean;
    procedure SetAlign(const Value: TKOLAlign);

    procedure SetClsStyle(const Value: DWORD);
    procedure SetExStyle(const Value: DWORD);
    procedure SetStyle(const Value: DWORD);
    function Get_Color: TColor;
    procedure Set_Color(const Value: TColor);
    procedure SetOnClick(const Value: TOnEvent);
    procedure SetCenterOnParent(const Value: Boolean);
    procedure SetPlaceDown(const Value: Boolean);
    procedure SetPlaceRight(const Value: Boolean);
    procedure SetPlaceUnder(const Value: Boolean);
    procedure SetCtl3D(const Value: Boolean);
    procedure SetOnDropDown(const Value: TOnEvent);
    procedure SetOnCloseUp(const Value: TOnEvent);
    procedure SetOnBitBtnDraw(const Value: TOnBitBtnDraw);
    procedure SetOnMessage(const Value: TOnMessage);
    procedure SetTabStop(const Value: Boolean);
    procedure SetTabOrder(const Value: Integer);
    procedure SetShadowDeep(const Value: Integer);
    procedure SetOnMouseDown(const Value: TOnMouse);
    procedure SetOnMouseEnter(const Value: TOnEvent);
    procedure SetOnMouseLeave(const Value: TOnEvent);
    procedure SetOnMouseMove(const Value: TOnMouse);
    procedure SetOnMouseUp(const Value: TOnMouse);
    procedure SetOnMouseWheel(const Value: TOnMouse);
    procedure SetOnEnter(const Value: TOnEvent);
    procedure SetOnLeave(const Value: TOnEvent);
    procedure SetOnChar(const Value: TOnChar);
    procedure SetOnKeyDown(const Value: TOnKey);
    procedure SetOnKeyUp(const Value: TOnKey);
    procedure SetFont(const Value: TKOLFont);
    function GetParentFont: Boolean;
    procedure SetParentFont(const Value: Boolean);
    function Get_Visible: Boolean;
    procedure Set_Visible(const Value: Boolean);
    function Get_Enabled: Boolean;
    procedure Set_Enabled(const Value: Boolean);
    procedure SetTransparent(const Value: Boolean);
    procedure SetOnChange(const Value: TOnEvent);
    //function GetHint: String;
    procedure SetDoubleBuffered(const Value: Boolean);
    procedure SetOnSelChange(const Value: TOnEvent);
    procedure SetOnPaint(const Value: TOnPaint);
    procedure SetOnResize(const Value: TOnEvent);
    procedure SetOnProgress(const Value: TOnEvent);
    function GetActualLeft: Integer;
    function GetActualTop: Integer;
    procedure SetActualLeft(Value: Integer);
    procedure SetActualTop(Value: Integer);
    procedure SetOnDeleteAllLVItems(const Value: TOnEvent);
    procedure SetOnDeleteLVItem(const Value: TOnDeleteLVItem);
    procedure SetOnLVData(const Value: TOnLVData);
    procedure SetOnCompareLVItems(const Value: TOnCompareLVItems);
    procedure SetOnColumnClick(const Value: TOnLVColumnClick);
    procedure SetOnDrawItem(const Value: TOnDrawItem);
    procedure SetOnMeasureItem(const Value: TOnMeasureItem);
    procedure SetOnDestroy(const Value: TOnEvent);
    procedure CollectChildrenWithParentFont;
    procedure ApplyFontToChildren;
    procedure SetparentColor(const Value: Boolean);
    function GetParentColor: Boolean;
    procedure CollectChildrenWithParentColor;
    procedure ApplyColorToChildren;
    procedure SetOnTBDropDown(const Value: TOnEvent);
    procedure SetOnDropFiles(const Value: TOnDropFiles);
    procedure SetOnHide(const Value: TOnEvent);
    procedure SetOnShow(const Value: TOnEvent);
    procedure SetOnRE_URLClick(const Value: TOnEvent);
    procedure SetOnMouseDblClk(const Value: TOnMouse);
    procedure SetOnRE_InsOvrMode_Change(const Value: TOnEvent);
    procedure SetOnRE_OverURL(const Value: TOnEvent);
    procedure SetCursor(const Value: String);
    procedure SetMarginBottom(const Value: Integer);
    procedure SetMarginLeft(const Value: Integer);
    procedure SetMarginRight(const Value: Integer);
    procedure SetMarginTop(const Value: Integer);
    procedure SetOnEraseBkgnd(const Value: TOnPaint);
    procedure SetEraseBackground(const Value: Boolean);
    procedure SetOnTVBeginDrag(const Value: TOnTVBeginDrag);
    procedure SetOnTVBeginEdit(const Value: TOnTVBeginEdit);
    procedure SetOnTVDelete(const Value: TOnTVDelete);
    procedure SetOnTVEndEdit(const Value: TOnTVEndEdit);
    procedure SetOnTVExpanded(const Value: TOnTVExpanded);
    procedure SetOnTVExpanding(const Value: TOnTVExpanding);
    procedure SetOnTVSelChanging(const Value: TOnTVSelChanging);
    procedure SetOnLVStateChange(const Value: TOnLVStateChange);
    procedure SetOnMove(const Value: TOnEvent);
    procedure SetOnSplit(const Value: TOnSplit);
    procedure SetOnEndEditLVItem(const Value: TOnEditLVItem);
    procedure Set_autoSize(const Value: Boolean);
    procedure SetTag(const Value: Integer);
    procedure SetOnScroll(const Value: TOnScroll);
    procedure SetEditTabChar(const Value: Boolean);
    procedure SetMaxHeight(const Value: Integer);
    procedure SetMaxWidth(const Value: Integer);
    procedure SetMinHeight(const Value: Integer);
    procedure SetMinWidth(const Value: Integer);
    procedure SetLocalizy(const Value: TLocalizyOptions);
    procedure SetHelpContext(const Value: Integer);
    procedure SetCancelBtn(const Value: Boolean);
    procedure SetDefaultBtn(const Value: Boolean);
    procedure SetIgnoreDefault(const Value: Boolean);
    procedure SetBrush(const Value: TKOLBrush);
    procedure SetIsGenerateSize(const Value: Boolean);
    procedure SetIsGeneratePosition(const Value: Boolean);
    procedure SetUnicode(const Value: Boolean);
    procedure Setaction(const Value: TKOLAction);
    procedure SetWindowed(const Value: Boolean);
  private
    FHint: String;
    procedure SetHint(const Value: String);
  protected
    FVerticalAlign: TVerticalAlign;
    FTabStop: Boolean;
    FautoSize: Boolean;
    fAlign: TKOLAlign;
    DefaultWidth: Integer;
    DefaultHeight: Integer;
    FOnSetBounds: TOnSetBounds;
    DefaultMarginLeft, DefaultMarginTop, DefaultMarginRight,
    DefaultMarginBottom: Integer;
    DefaultAutoSize: Boolean;

    fUpdated: Boolean;
    fNoAutoSizeX: Boolean;
    fAutoSizingNow: Boolean;
    fAutoSzX, fAutoSzY: Integer;
    FHasBorder: Boolean;
    FDefHasBorder: Boolean;

    FDefIgnoreDefault: Boolean;

    // A list of components which are linked to the TKOLObj component
    // and must be notifyed when the TKOLObj component is renamed or
    // removed from a form at design time.
    fNotifyList: TList;

    FIgnoreDefault: Boolean;
    FResetTabStopByStyle: Boolean;
    FWordWrap: Boolean;
    procedure SetWordWrap(const Value: Boolean);

    procedure SetVerticalAlign(const Value: TVerticalAlign); virtual;
    procedure SetHasBorder(const Value: Boolean); virtual;
    procedure AutoSizeNow; virtual;
    function AutoSizeRunTime: Boolean; virtual;
    function AutoWidth( Canvas: graphics.TCanvas ): Integer; virtual;
    function AutoHeight( Canvas: graphics.TCanvas ): Integer; virtual;
    function ControlIndex: Integer;
    function AdditionalUnits: String; virtual;
    function TabStopByDefault: Boolean; virtual;

    procedure SetMargin(const Value: Integer); virtual;
    procedure SetCaption(const Value: String); virtual;
    procedure SetTextAlign(const Value: TTextAlign); virtual;

    // This function returns margins between control edges and edges of client
    // area. These are used to draw border with dark grey at design time.
    function ClientMargins: TRect; virtual;
    function DrawMargins: TRect; virtual;

    function GetTabOrder: Integer; virtual;

    function ParentControlUseAlign: Boolean;

    function ParentKOLControl: TComponent;
    function OwnerKOLForm( AOwner: TComponent ): TKOLForm;
    function ParentKOLForm: TKOLForm;
    function ParentForm: TForm;
    function ParentBounds: TRect;
    function PrevKOLControl: TKOLCustomControl;
    function PrevBounds: TRect;
    function ParentMargin: Integer;

    function TypeName: String; virtual;
    procedure BeforeFontChange( SL: TStrings; const AName, Prefix: String ); virtual;
    function FontPropName: String; virtual;
    procedure AfterFontChange( SL: TStrings; const AName, Prefix: String ); virtual;

    // Overriden to exclude prefix 'KOL' from names of all controls, dropped
    // onto form at design time. (E.g., when TKOLButton is dropped, its name
    // becomes 'Button1', not 'KOLButton1' as it could be done by default).
    //
    // Процедура SetName переопределена для того, чтобы выбрасывать префикс
    // KOL, присутствующий в названиях зеркальных классов, из вновь созданных
    // имен контролов. Например, TKOLButton -> Button1, а не KOLButton1.
    procedure SetName( const NewName: TComponentName ); override;

    procedure SetParent( Value: TWinControl ); override;

    // This method is created only when control is just dropped onto form.
    // For mirror classes, reflecting to controls, which should display
    // its Caption (like buttons, labels, etc.), it is possible in
    // overriden method to assign name of control itself to Caption property
    // (for instance).
    //
    // Данный метод будет вызываться только в момент "бросания" контрола
    // на форму. Для зеркал кнопок, меток и др. контролов с заголовком,
    // имеет смысл переопределить этот метод, чтобы инициализировать его
    // Caption именем создаваемого объекта.
    procedure FirstCreate; virtual;

    property TextAlign: TTextAlign read FTextAlign write SetTextAlign;
    property VerticalAlign: TVerticalAlign read FVerticalAlign write SetVerticalAlign;

    function RefName: String; virtual;
    function IsCursorDefault: Boolean; virtual;

    // Is called to generate constructor of control and operators to
    // adjust its properties first time.
    //
    // Процедура, которая добавляет в конец SL (:TStringList) операторы
    // создания объекта и те операторы настройки его свойств, которые
    // должны исполняться немедленно вслед за конструированием объекта:
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); virtual;
    procedure SetupConstruct( SL: TStringList; const AName, AParent, Prefix: String ); virtual;
    procedure DoGenerateConstants( SL: TStringList ); virtual;

    procedure SetupTabOrder( SL: TStringList; const AName: String ); virtual;
    function DefaultColor: TColor; virtual;
    {* by default, clBtnFace. Override it for controls, having another
       Color as default. Usually these are controls, which main purpose is
       input (edit controls, list box, list view, tree view, etc.) }
    function DefaultInitialColor: TColor; virtual;
    {* by default, DefaultColor is returned. For some controls this
       value can be overriden to force setting desired Color when the
       control is created first time (just dropped onto form in designer).
       E.g., this value is overriden for TKOLCombobox, which DefaultColor
       is clWindow. }
    function DefaultParentColor: Boolean; virtual;
    {* TRUE, if parentColor should be set to TRUE when the control is
       create (first dropped on form at design time). By default, this
       property is TRUE for controls with DefaultColor=clBtnFace and
       FALSE for all other controls. }
    function DefaultKOLParentColor: Boolean; virtual;
    {* TRUE, if the control is using Color of parent at run time
       by default. At least combo box control is using clWhite
       instead, so this function is overriden for it. This method
       is introduced to optimise code generated. }
    function CanChangeColor: Boolean; virtual;
    {* TRUE, if the Color can be changed (default). This function is
       overriden for TKOLButton, which represents standard GDI button
       and can not have other color then clBtnFace.  }
    procedure SetupColor( SL: TStrings; const AName: String ); virtual;
    //function RunTimeFont: TKOLFont;
    function Get_ParentFont: TKOLFont;
    procedure SetupFont( SL: TStrings; const AName: String ); virtual;
    procedure SetupTextAlign( SL: TStrings; const AName: String ); virtual;

    // Is called after generating of constructors of all child controls and
    // objects - to generate final initialization of object (if necessary).
    //
    // Вызывается уже после генерации конструирования всех
    // дочерних контролов и объектов формы - для генерации какой-либо
    // завершающей инициализации:
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String );
              virtual;

    // Method, which should return string with parameters for constructor
    // call. I.e. braces content in operator
    //     Result.Button1 := NewButton( ... )...;
    //
    // Функция, которая формирует правильные параметры для оператора
    // конструирования объекта (т.е. то, что будет в круглых скобках
    // в операторе: Result.Button1 := NewButton( ... )...;
    function SetupParams( const AName, AParent: String ): String; virtual;

    // Method to assign values to assigned events. Is called in SetupFirst
    // and actually should call DoAssignEvents, passing a list of (additional)
    // events to it.
    //
    // Процедура присваивания значений назначенным событиям. Вызывается из
    // SetupFirst и фактически должна (после вызова inherited) передать
    // в процедуру DoAssignEvents список (дополнительных) событий.
    procedure AssignEvents( SL: TStringList; const AName: String ); virtual;

    procedure DoAssignEvents( SL: TStringList; const AName: String;
              EventNames: array of PChar; EventHandlers: array of Pointer );

    // This method allows to initializy part of properties as a sequence
    // of "transparent" methods calls (see KOL documentation).
    //
    // Функция, которая инициализацию части свойств выполняет в виде
    // последовательности вызовов "прозрачных" методов (см. описание KOL)
    function GenerateTransparentInits: String; virtual;

    property ShadowDeep: Integer read FShadowDeep write SetShadowDeep;

    property OnDropDown: TOnEvent read FOnDropDown write SetOnDropDown;
    property OnCloseUp: TOnEvent read FOnCloseUp write SetOnCloseUp;
    property OnBitBtnDraw: TOnBitBtnDraw read FOnBitBtnDraw write SetOnBitBtnDraw;
    property OnChange: TOnEvent read FOnChange write SetOnChange;
    property OnSelChange: TOnEvent read FOnSelChange write SetOnSelChange;
    property OnProgress: TOnEvent read FOnProgress write SetOnProgress;
    property OnDeleteLVItem: TOnDeleteLVItem read FOnDeleteLVItem write SetOnDeleteLVItem;
    property OnDeleteAllLVItems: TOnEvent read FOnDeleteAllLVItems write SetOnDeleteAllLVItems;
    property OnLVData: TOnLVData read FOnLVData write SetOnLVData;
    property OnCompareLVItems: TOnCompareLVItems read FOnCompareLVItems write SetOnCompareLVItems;
    property OnColumnClick: TOnLVColumnClick read FOnColumnClick write SetOnColumnClick;
    property OnLVStateChange: TOnLVStateChange read FOnLVStateChange write SetOnLVStateChange;
    property OnEndEditLVItem: TOnEditLVItem read FOnEndEditLVItem write SetOnEndEditLVItem;
    property OnDrawItem: TOnDrawItem read FOnDrawItem write SetOnDrawItem;
    property OnMeasureItem: TOnMeasureItem read FOnMeasureItem write SetOnMeasureItem;
    property OnTBDropDown: TOnEvent read FOnTBDropDown write SetOnTBDropDown;
    property OnSplit: TOnSplit read FOnSplit write SetOnSplit;
    property OnScroll: TOnScroll read FOnScroll write SetOnScroll;

    // Following two properties are to manipulate with Left and Top, corrected
    // to parent's client origin, which can be another than (0,0).
    //
    // Следующие 2 свойства - для работы с Left и Top, подправленными
    // в соответствии с координатами начала клиентской области родителя,
    // которое может быть иное, чем просто (0,0)
    property actualLeft: Integer read GetActualLeft write SetActualLeft;
    property actualTop: Integer read GetActualTop write SetActualTop;

    procedure WantTabs( Want: Boolean ); virtual;
    function CanNotChangeFontColor: Boolean; virtual;

    // Painting of mirror class object by default. It is possible to override it
    // in derived class to make its image lookin like reflecting object as much
    // as possible.
    // To implement WYSIWIG painting, it is necessary to override Paint method,
    // and call inherited Paint one at the end of execution of the overriden
    // method (to provide additional painting, controlled by TKOLProject.PaintType
    // property and TKOLForm.PaintAdditionally property). Also, override method
    // WYSIWIGPaintImplemented function to return TRUE, this is also necessary
    // to provide correct additional painting in inherited Paint method.
    //
    // Отрисовка зеркального объекта по умолчанию. Можно заменить в наследуемом
    // классе конкретного зеркального класса на процедуру, в которой объект
    // изображается максимально похожим на оригинал.
    // Для реализации отрисовки контрола в режиме "как он должен выглядеть",
    // следует переопределить метод Paint, и вызвать унаследованный метод Paint
    // на конце исполнения переопределенного (для обеспечиния дополнительных функций
    // отрисовки, в соответствии со свойствами TKOLProject.PaintType и
    // TKOLForm.PaintAdditionally). Также, следует переопределить функцию
    // WYSIWIGPaintImplemented, чтобы она возвращала TRUE - это так же необходимо
    // для обеспечения правильной дополнительной отрисовки в унаследованном
    // методе Paint.
    procedure Paint; override;

    function PaintType: TPaintType;
    function WYSIWIGPaintImplemented: Boolean; virtual;
    procedure PrepareCanvasFontForWYSIWIGPaint( ACanvas: TCanvas );
    function NoDrawFrame: Boolean; virtual;

    //-- by Alexander Shakhaylo - to allow sort objects
    function CompareFirst(c, n: string): boolean; virtual;

    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    function StringConstant( const Propname, Value: String ): String;
    function BestEventName: String; virtual;
    function GetDefaultControlFont: HFONT; virtual;
    procedure KOLControlRecreated;
    {$IFNDEF NOT_USE_KOLCTRLWRAPPER}
     override;
    {$ELSE NOT_USE_KOLCTRLWRAPPER}
     virtual;
    procedure CreateKOLControl(Recreating: boolean); virtual;
    procedure UpdateAllowSelfPaint;
  protected
    FKOLCtrl: PControl;
    FKOLParentCtrl: PControl;
    property KOLParentCtrl: PControl read FKOLParentCtrl;
    {$ENDIF NOT_USE_KOLCTRLWRAPPER}
    property AllowPostPaint: boolean read FAllowPostPaint write FAllowPostPaint;
    property AllowSelfPaint: boolean read FAllowSelfPaint write FAllowSelfPaint;
    property AllowCustomPaint: boolean read FAllowCustomPaint write FAllowCustomPaint;
    property WordWrap: Boolean read FWordWrap write SetWordWrap; // only for graphic button (Windowed = FALSE)
  public
    property IsGenerateSize: Boolean read FIsGenerateSize write SetIsGenerateSize;
    property IsGeneratePosition: Boolean read FIsGeneratePosition write SetIsGeneratePosition;
    procedure Change; override;

    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    procedure AddToNotifyList( Sender: TComponent );

    // procedure which is called by linked components, when those are
    // renamed or removed at design time.
    procedure NotifyLinkedComponent( Sender: TObject; Operation: TNotifyOperation );
              virtual;
    procedure DoNotifyLinkedComponents( Operation: TNotifyOperation );

    property Style: DWORD read fStyle write SetStyle;
    property ExStyle: DWORD read fExStyle write SetExStyle;
    property ClsStyle: DWORD read fClsStyle write SetClsStyle;
    procedure Click; override;
    procedure SetBounds( aLeft, aTop, aWidth, aHeight: Integer ); override;
    procedure ReAlign( ParentOnly: Boolean );
    property Transparent: Boolean read FTransparent write SetTransparent;

    property TabStop: Boolean read FTabStop write SetTabStop;

    property OnEnter: TOnEvent read FOnEnter write SetOnEnter;
    property OnLeave: TOnEvent read FOnLeave write SetOnLeave;
    property OnKeyDown: TOnKey read FOnKeyDown write SetOnKeyDown;
    property OnKeyUp: TOnKey read FOnKeyUp write SetOnKeyUp;
    property OnChar: TOnChar read FOnChar write SetOnChar;
    property Margin: Integer read fMargin write SetMargin;
    property Border: Integer read fMargin write SetMargin;
    function BorderNeeded: Boolean; virtual;
    property MarginLeft: Integer read FMarginLeft write SetMarginLeft;
    property MarginRight: Integer read FMarginRight write SetMarginRight;
    property MarginTop: Integer read FMarginTop write SetMarginTop;
    property MarginBottom: Integer read FMarginBottom write SetMarginBottom;
    property OnRE_URLClick: TOnEvent read FOnRE_URLClick write SetOnRE_URLClick;
    property OnRE_OverURL: TOnEvent read FOnRE_OverURL write SetOnRE_OverURL;
    property OnRE_InsOvrMode_Change: TOnEvent read FOnRE_InsOvrMode_Change write SetOnRE_InsOvrMode_Change;
    property OnTVBeginDrag: TOnTVBeginDrag read FOnTVBeginDrag write SetOnTVBeginDrag;
    property OnTVBeginEdit: TOnTVBeginEdit read FOnTVBeginEdit write SetOnTVBeginEdit;
    property OnTVEndEdit: TOnTVEndEdit read FOnTVEndEdit write SetOnTVEndEdit;
    property OnTVExpanding: TOnTVExpanding read FOnTVExpanding write SetOnTVExpanding;
    property OnTVExpanded: TOnTVExpanded read FOnTVExpanded write SetOnTVExpanded;
    property OnTVDelete: TOnTVDelete read FOnTVDelete write SetOnTVDelete;
    property OnTVSelChanging: TOnTVSelChanging read FOnTVSelChanging write SetOnTVSelChanging;
    property autoSize: Boolean read FautoSize write Set_autoSize;
    property HasBorder: Boolean read FHasBorder write SetHasBorder;
    property EditTabChar: Boolean read FEditTabChar write SetEditTabChar;
  //published
    property TabOrder: Integer read GetTabOrder write SetTabOrder;
    // This section contains published properties, available in Object
    // Inspector at design time.
    //
    // В раздел published попадают свойства, которые могут изменяться из
    // Инспектора Объектов в design time. Воспользуемся этим, и разместим
    // здесь такие свойства визуальных объектов KOL, которые удобно
    // было бы настроить визуально.

    // Bound properties can be not overriden, Change is called therefore
    // when these are changed (because SetBounds is overriden)
    property Left;
    property Top;
    property Width;
    property Height;

    property MinWidth: Integer read FMinWidth write SetMinWidth;
    property MinHeight: Integer read FMinHeight write SetMinHeight;
    property MaxWidth: Integer read FMaxWidth write SetMaxWidth;
    property MaxHeight: Integer read FMaxHeight write SetMaxHeight;

    property Cursor_: String read FCursor write SetCursor;
    property Cursor: Boolean read FFalse;

    property PlaceDown: Boolean read fPlaceDown write SetPlaceDown;
    property PlaceRight: Boolean read fPlaceRight write SetPlaceRight;
    property PlaceUnder: Boolean read fPlaceUnder write SetPlaceUnder;

    property Visible: Boolean read Get_Visible write Set_Visible;
    property Enabled: Boolean read Get_Enabled write Set_Enabled;

    property DoubleBuffered: Boolean read FDoubleBuffered write SetDoubleBuffered;

    // Property Align is redeclared to provide type correspondence
    // (to avoid conflict between VCL.Align and KOL.Align).
    //
    // Свойство Align переопределено, чтобы обеспечить соответствие
    // наименований типов выравнивания между VCL.Align и KOL.Align.
    property Align: TKOLAlign read fAlign write SetAlign;

    property CenterOnParent: Boolean read fCenterOnParent write SetCenterOnParent;

    property Caption: String read fCaption write SetCaption;
    property Ctl3D: Boolean read FCtl3D write SetCtl3D;

    property Color: TColor read Get_Color write Set_Color;
    property parentColor: Boolean read GetParentColor write SetparentColor;
    property Font: TKOLFont read FFont write SetFont;
    property Brush: TKOLBrush read FBrush write SetBrush;
    property parentFont: Boolean read GetParentFont write SetParentFont;

    property OnClick: TOnEvent read fOnClick write SetOnClick;
    property OnMouseDblClk: TOnMouse read fOnMouseDblClk write SetOnMouseDblClk;
    property OnDestroy: TOnEvent read FOnDestroy write SetOnDestroy;
    property OnMessage: TOnMessage read FOnMessage write SetOnMessage;
    property OnMouseDown: TOnMouse read FOnMouseDown write SetOnMouseDown;
    property OnMouseMove: TOnMouse read FOnMouseMove write SetOnMouseMove;
    property OnMouseUp: TOnMouse read FOnMouseUp write SetOnMouseUp;
    property OnMouseWheel: TOnMouse read FOnMouseWheel write SetOnMouseWheel;
    property OnMouseEnter: TOnEvent read FOnMouseEnter write SetOnMouseEnter;
    property OnMouseLeave: TOnEvent read FOnMouseLeave write SetOnMouseLeave;
    property OnResize: TOnEvent read FOnResize write SetOnResize;
    property OnMove: TOnEvent read FOnMove write SetOnMove;
    property OnDropFiles: TOnDropFiles read FOnDropFiles write SetOnDropFiles;
    property OnShow: TOnEvent read FOnShow write SetOnShow;
    property OnHide: TOnEvent read FOnHide write SetOnHide;
    property OnPaint: TOnPaint read FOnPaint write SetOnPaint;
    property OnEraseBkgnd: TOnPaint read FOnEraseBkgnd write SetOnEraseBkgnd;
    property EraseBackground: Boolean read FEraseBackground write SetEraseBackground;

    property Tag: Integer read FTag write SetTag;
    property Hint: String read FHint write SetHint;

    property HelpContext: Integer read FHelpContext1 write SetHelpContext;
    property Localizy: TLocalizyOptions read FLocalizy write SetLocalizy;
    property DefaultBtn: Boolean read FDefaultBtn write SetDefaultBtn;
    property CancelBtn: Boolean read FCancelBtn write SetCancelBtn;
    property Unicode: Boolean read FUnicode write SetUnicode;
    property action: TKOLAction read Faction write Setaction stored False;
    property Windowed: Boolean read FWindowed write SetWindowed;
  published
    property IgnoreDefault: Boolean read FIgnoreDefault write SetIgnoreDefault;
  end;

  TKOLControl = class( TKOLCustomControl )
  public
    function Generate_SetSize: String; override;
    procedure Change; override;
  published
    property TabOrder;
    property Left;
    property Top;
    property Width;
    property Height;

    property MinWidth;
    property MinHeight;
    property MaxWidth;
    property MaxHeight;
    property Cursor_;
    property PlaceDown;
    property PlaceRight;
    property PlaceUnder;
    property Visible;
    property Enabled;
    property DoubleBuffered;
    property Align;
    property CenterOnParent;
    property Caption;
    property Ctl3D;
    property Color;
    property parentColor;
    property Font;
    property parentFont;
    property OnClick;
    property OnMouseDblClk;
    property OnDestroy;
    property OnMessage;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnResize;
    property OnMove;
    property OnDropFiles;
    property OnShow;
    property OnHide;
    property OnPaint;
    property OnEraseBkgnd;
    property EraseBackground;
    property Tag;
    property HelpContext;
    property Localizy;
    property Hint;
  end;


  {$IFDEF _D5}
  TLeftPropEditor = class( TIntegerProperty )
  private
    function VisualValue: string;
  protected
  public
    procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean); override;
  end;

  TTopPropEditor = class( TIntegerProperty )
  private
    function VisualValue: string;
  protected
  public
    procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean); override;
  end;
  {$ENDIF}

  TCursorPropEditor = class( TPropertyEditor )
  private
  protected
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;











  //============================================================================
  // Special component, intended to use it instead TKOLForm and to implement a
  // unit, which contains MDI child form.
  TKOLMDIChild = class( TKOLForm )
  private
    FParentForm: String;
    fNotAvailable: Boolean;
    procedure SetParentForm(const Value: String);
  protected
    procedure GenerateCreateForm( SL: TStringList ); override;
    function DoNotGenerateSetPosition: Boolean; override;
  public
  published
    property ParentMDIForm: String read FParentForm write SetParentForm;
    property OnQueryEndSession: Boolean read fNotAvailable;
  end;

  TParentMDIFormPropEditor = class( TPropertyEditor )
  private
  protected
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;


  //============================================================================
  // Special component, intended to use it instead TKOLForm and to implement a
  // unit, which does not contain a form, but non-visual KOL objects only.
  TDataModuleHowToDestroy = ( ddAfterRun, ddOnAppletDestroy, ddManually );

  TKOLDataModule = class( TKOLForm )
  private
    FOnCreate: TOnEvent;
    FhowToDestroy: TDataModuleHowToDestroy;
    procedure SetOnCreate(const Value: TOnEvent);
    procedure SethowToDestroy(const Value: TDataModuleHowToDestroy);
  protected
    fNotAvailable: Boolean;
    function GenerateTransparentInits: String; override;
    function GenerateINC( const Path: String; var Updated: Boolean ): Boolean; override;
    procedure GenerateCreateForm( SL: TStringList ); override;
    function Result_Form: String; override;
    procedure GenerateDestroyAfterRun( SL: TStringList ); override;
    procedure GenerateAdd2AutoFree( SL: TStringList; const AName: String;
              AControl: Boolean; Add2AutoFreeProc: String; Obj: TObject ); override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );
      override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String );
      override;
  public
  published
    property Locked;
    property formName: Boolean read fNotAvailable;
    property formUnit;
    property formMain;
    property defaultPosition: Boolean read fNotAvailable;
    property Caption: Boolean read fNotAvailable;
    property Visible: Boolean read fNotAvailable;
    property Enabled: Boolean read fNotAvailable;
    property Tabulate: Boolean read fNotAvailable;
    property TabulateEx: Boolean read fNotAvailable;
    property bounds: Boolean read fNotAvailable;
    property defaultSize: Boolean read fNotAvailable;
    property HasBorder: Boolean read fNotAvailable;
    property HasCaption: Boolean read fNotAvailable;
    property MarginLeft: Boolean read fNotAvailable;
    property MarginTop: Boolean read fNotAvailable;
    property MarginRight: Boolean read fNotAvailable;
    property MarginBottom: Boolean read fNotAvailable;
    property Tag: Boolean read fNotAvailable;
    property StayOnTop: Boolean read fNotAvailable;
    property CanResize: Boolean read fNotAvailable;
    property CenterOnScreen: Boolean read fNotAvailable;
    property Ctl3D: Boolean read fNotAvailable;
    property WindowState: Boolean read fNotAvailable;
    property minimizeIcon: Boolean read fNotAvailable;
    property maximizeIcon: Boolean read fNotAvailable;
    property closeIcon: Boolean read fNotAvailable;
    property Icon: Boolean read fNotAvailable;
    property Cursor: Boolean read fNotAvailable;
    property Color: Boolean read fNotAvailable;
    property Font: Boolean read fNotAvailable;
    property DoubleBuffered: Boolean read fNotAvailable;
    property PreventResizeFlicks: Boolean read fNotAvailable;
    property Transparent: Boolean read fNotAvailable;
    property AlphaBlend: Boolean read fNotAvailable;
    property Margin: Boolean read fNotAvailable;
    property Border: Boolean read fNotAvailable;
    property MinimizeNormalAnimated: Boolean read fNotAvailable;
    property zOrderChildren: Boolean read fNotAvailable;
    property SimpleStatusText: Boolean read fNotAvailable;
    property StatusText: Boolean read fNotAvailable;
    property OnClick: Boolean read fNotAvailable;
    property OnMouseDown: Boolean read fNotAvailable;
    property OnMouseMove: Boolean read fNotAvailable;
    property OnMouseUp: Boolean read fNotAvailable;
    property OnMouseWheel: Boolean read fNotAvailable;
    property OnMouseEnter: Boolean read fNotAvailable;
    property OnMouseLeave: Boolean read fNotAvailable;
    property OnMouseDblClk: Boolean read fNotAvailable;
    property OnEnter: Boolean read fNotAvailable;
    property OnLeave: Boolean read fNotAvailable;
    property OnKeyDown: Boolean read fNotAvailable;
    property OnKeyUp: Boolean read fNotAvailable;
    property OnChar: Boolean read fNotAvailable;
    property OnResize: Boolean read fNotAvailable;
    property OnShow: Boolean read fNotAvailable;
    property OnHide: Boolean read fNotAvailable;
    property OnMessage: Boolean read fNotAvailable;
    property OnClose: Boolean read fNotAvailable;
    property OnMinimize: Boolean read fNotAvailable;
    property OnMaximize: Boolean read fNotAvailable;
    property OnRestore: Boolean read fNotAvailable;
    property OnPaint: Boolean read fNotAvailable;
    property OnEraseBkgnd: Boolean read fNotAvailable;

    property OnFormCreate: Boolean read fNotAvailable;
    property OnCreate: TOnEvent read FOnCreate write SetOnCreate;
    property OnDestroy;
    property howToDestroy: TDataModuleHowToDestroy read FhowToDestroy write SethowToDestroy;

    property MinWidth: Boolean read fNotAvailable;
    property MinHeight: Boolean read fNotAvailable;
    property MaxWidth: Boolean read fNotAvailable;
    property MaxHeight: Boolean read fNotAvailable;
    property OnQueryEndSession: Boolean read fNotAvailable;

    property HelpContext: Boolean read fNotAvailable;
    property OnHelp: Boolean read fNotAvailable;
  end;








  //============================================================================
  // Special component, intended to use it instead TKOLForm and to implement a
  // unit, which can contain several visual and non-visual MCK components, which
  // can be adjusted at design time on a standalone designer form, and created
  // on KOL form at run time, like a panel with such controls.
  TKOLFrame = class( TKOLForm )
  private
    FEdgeStyle: TEdgeStyle;
    fNotAvailable: Boolean;
    FAlign: TKOLAlign;
    FCenterOnParent: Boolean;
    FzOrderTopmost: Boolean;
    fFrameCaption: String;
    FParentFont: Boolean;
    FParentColor: Boolean;
    procedure SetEdgeStyle(const Value: TEdgeStyle);
    procedure SetAlign(const Value: TKOLAlign);
    procedure SetCenterOnParent(const Value: Boolean);
    procedure SetzOrderTopmost(const Value: Boolean);
    function GetFrameHeight: Integer;
    function GetFrameWidth: Integer;
    procedure SetFrameHeight(const Value: Integer);
    procedure SetFrameWidth(const Value: Integer);
    procedure SetFrameCaption(const Value: String);
    procedure SetParentColor(const Value: Boolean);
    procedure SetParentFont(const Value: Boolean);
  protected
    function AutoCaption: Boolean; override;
    function GetCaption: String; override;
    function GenerateTransparentInits: String; override;
    procedure GenerateCreateForm( SL: TStringList ); override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );
              override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String );
              override;
    procedure GenerateAdd2AutoFree( SL: TStringList; const AName: String;
              AControl: Boolean; Add2AutoFreeProc: String; Obj: TObject ); override;
  public
    constructor Create( AOwner: TComponent ); override;
  published
    property EdgeStyle: TEdgeStyle read FEdgeStyle write SetEdgeStyle;
    property FormMain: Boolean read fNotAvailable;
    property AlphaBlend: Boolean read fNotAvailable;
    property bounds: Boolean read fNotAvailable;
    property Width: Integer read GetFrameWidth write SetFrameWidth;
    property Height: Integer read GetFrameHeight write SetFrameHeight;
    property Align: TKOLAlign read FAlign write SetAlign;
    property CenterOnParent: Boolean read FCenterOnParent write SetCenterOnParent;
    property zOrderTopmost: Boolean read FzOrderTopmost write SetzOrderTopmost;
    property CanResize: Boolean read fNotAvailable;
    property defaultPosition: Boolean read fNotAvailable;
    property defaultSize: Boolean read fNotAvailable;
    property HasBorder: Boolean read fNotAvailable;
    property HasCaption: Boolean read fNotAvailable;
    property Icon: Boolean read fNotAvailable;
    property maximizeIcon: Boolean read fNotAvailable;
    property minimizeIcon: Boolean read fNotAvailable;
    property MinimizeNormalAnimated: Boolean read fNotAvailable;
    property PreventResizeFlicks: Boolean read fNotAvailable;
    property SimpleStatusText: Boolean read fNotAvailable;
    property StatusText: Boolean read fNotAvailable;
    property StayOnTop: Boolean read fNotAvailable;
    property Tabulate: Boolean read fNotAvailable;
    property TabulateEx: Boolean read fNotAvailable;
    property WindowState: Boolean read fNotAvailable;
    property Caption: String read fFrameCaption write SetFrameCaption;
    property ParentColor: Boolean read FParentColor write SetParentColor;
    property ParentFont: Boolean read FParentFont write SetParentFont;
    property OnQueryEndSession: Boolean read fNotAvailable;
    property OnClose: Boolean read fNotAvailable;
    property OnMinimize: Boolean read fNotAvailable;
    property OnMaximize: Boolean read fNotAvailable;
    property OnRestore: Boolean read fNotAvailable;
    property OnHelp: Boolean read fNotAvailable;
  end;


  TKOLAction = class(TKOLObj)
  private
    FLinked: TStringList;
    FActionList: TKOLActionList;
    FVisible: boolean;
    FChecked: boolean;
    FEnabled: boolean;
    FHelpContext: integer;
    FHint: string;
    FCaption: string;
    FOnExecute: TOnEvent;
    FAccelerator: TKOLAccelerator;
    procedure SetCaption(const Value: string);
    procedure SetChecked(const Value: boolean);
    procedure SetEnabled(const Value: boolean);
    procedure SetHelpContext(const Value: integer);
    procedure SetHint(const Value: string);
    procedure SetOnExecute(const Value: TOnEvent);
    procedure SetVisible(const Value: boolean);
    procedure SetAccelerator(const Value: TKOLAccelerator);
    procedure SetActionList(const Value: TKOLActionList);
    function GetIndex: Integer;
    procedure SetIndex(Value: Integer);
    procedure ResolveLinks;
    function FindComponentByPath(const Path: string): TComponent;
    function GetComponentFullPath(AComponent: TComponent): string;
    procedure UpdateLinkedComponent(AComponent: TComponent);
    procedure UpdateLinkedComponents;
  protected
    procedure ReadState(Reader: TReader); override;
    procedure SetParentComponent(AParent: TComponent); override;
    procedure DefineProperties( Filer: TFiler ); override;
    procedure LoadLinks(R: TReader);
    procedure SaveLinks(W: TWriter);
    procedure Loaded; override;
    procedure SetName(const NewName: TComponentName); override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetParentComponent: TComponent; override;
    function HasParent: Boolean; override;
    procedure Assign(Source: TPersistent); override;
    property ActionList: TKOLActionList read FActionList write SetActionList stored False;
    property Index: Integer read GetIndex write SetIndex stored False;
    procedure LinkComponent(const AComponent: TComponent);
    procedure UnLinkComponent(const AComponent: TComponent);
    function AdditionalUnits: String; override;
  published
    property Caption: string read FCaption write SetCaption;
    property Hint: string read FHint write SetHint;
    property Checked: boolean read FChecked write SetChecked default False;
    property Enabled: boolean read FEnabled write SetEnabled default True;
    property Visible: boolean read FVisible write SetVisible default True;
    property HelpContext: integer read FHelpContext write SetHelpContext default 0;
    property Accelerator: TKOLAccelerator read FAccelerator write SetAccelerator;
    property OnExecute: TOnEvent read FOnExecute write SetOnExecute;
  end;

  TKOLActionList = class(TKOLObj)
  private
    FActions: TList;
    FOnUpdateActions: TOnEvent;
    function GetKOLAction(Index: Integer): TKOLAction;
    procedure SetKOLAction(Index: Integer; const Value: TKOLAction);
    function GetCount: integer;
    procedure SetOnUpdateActions(const Value: TOnEvent);
  protected
    procedure GetChildren(Proc: TGetChildProc {$IFDEF _D3orHigher} ; Root: TComponent {$ENDIF} ); override;
    procedure SetChildOrder(Component: TComponent; Order: Integer); override;

    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
  public
    ActiveDesign: TfmActionListEditor;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Actions[Index: Integer]: TKOLAction read GetKOLAction write SetKOLAction; default;
    property Count: integer read GetCount;
    property List: TList read FActions;
    function AdditionalUnits: String; override;
  published
    property OnUpdateActions: TOnEvent read FOnUpdateActions write SetOnUpdateActions;
  end;

  TKOLActionListEditor = class( TComponentEditor )
  private
  protected
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;








var
  // Variable KOLProject refers to a TKOLProject instance (must be
  // single in a project).
  //
  // Переменная KOLProject содержит указатель на представитель класса
  // TKOLProject (который должен быть единственным)
  KOLProject: TKOLProject;

function BuildKOLProject: Boolean;

var
  // Applet variable refers to (unnecessary) instance of TKOLApplet
  // class instance.
  //
  // Переменная Applet содержит ссылку на (неоябязательный) представитель
  // класса TKOLApplet (соответствующий объекту APPLET в KOL).
  Applet: TKOLApplet;

  // List of all TKOLForm objects created - provides access to all of them
  // (e.g. from TKOLProject) at design time and at run time.
  //
  // Список FormsList содержит ссылки на все объекты класса TKOLForm
  // проекта, обеспечивая доступ к ним из объект KOLProject (он должен
  // суметь перечислить все формы, чтобы сгенерировать код для них).
  FormsList: TList;

function Color2Str( Color: TColor ): String;

procedure Log( const S: String );
procedure LogOK ;
procedure Rpt( const S: String );
procedure Rpt_Stack;

function ProjectSourcePath: String;
function Get_ProjectName: String;

procedure AddLongTextField( var SL: TStringList; const Prefix:String;
 const Text:String; const Suffix:String );

//*///////////////////////////////////////
  {$IFDEF _D6orHigher}                  //
type
  IFormDesigner = IDesigner;            //
  {$ENDIF}                              //
//*///////////////////////////////////////

  {$IFDEF _D2orD3}
type
  IDesigner = TDesigner;
  IFormDesigner = TFormDesigner;
  {$ENDIF}


function QueryFormDesigner( D: IDesigner; var FD: IFormDesigner ): Boolean;



function PCharStringConstant( Sender: TObject; const Propname, Value: String ): String;

procedure LoadSource( SL: TStrings; const Path: String );
procedure SaveStrings( SL: TStrings; const Path: String; var Updated: Boolean );
procedure SaveStringToFile(const Path, Str: String );
procedure MarkModified( const Path: String );

const
  Signature = '{ KOL MCK } // Do not remove this line!';



procedure Register;

{$R KOLmirrors.dcr}

implementation

uses ShellAPI, shlobj {$IFNDEF _D2}, ActiveX {$ENDIF},
     mckCtrls, mckObjs;

  procedure Register;
  begin
    RegisterComponents( 'KOL', [ TKOLProject, TKOLApplet, TKOLForm, TKOLMDIChild,
                                 TKOLDataModule, TKOLFrame, TKOLActionList ] );
    RegisterComponentEditor( TKOLProject, TKOLProjectBuilder );
    {$IFDEF _D5}
    RegisterPropertyEditor( TypeInfo( Integer ), TKOLCustomControl, 'Left', TLeftPropEditor );
    RegisterPropertyEditor( TypeInfo( Integer ), TKOLCustomControl, 'Top', TTopPropEditor );
    {$ENDIF}
    RegisterComponentEditor( TKOLObj, TKOLObjectCompEditor );
    RegisterComponentEditor( TKOLApplet, TKOLObjectCompEditor );
    RegisterComponentEditor( TKOLCustomControl, TKOLObjectCompEditor );
    RegisterPropertyEditor( TypeInfo( TOnEvent ), nil, '', TKOLOnEventPropEditor );
    RegisterPropertyEditor( TypeInfo( TOnMessage ), nil, '', TKOLOnEventPropEditor );
    RegisterPropertyEditor( TypeInfo( String ), TKOLCustomControl, 'Cursor_', TCursorPropEditor  );
    RegisterPropertyEditor( TypeInfo( String ), TKOLForm, 'Cursor', TCursorPropEditor );
    RegisterPropertyEditor( TypeInfo( String ), TKOLMDIChild, 'ParentMDIForm', TParentMDIFormPropEditor );
    RegisterComponentEditor( TKOLMenu, TKOLMenuEditor );
    RegisterPropertyEditor( TypeInfo( TOnMenuItem ), TKOLMenuItem, 'OnMenu',
                            TKOLOnItemPropEditor );
    RegisterPropertyEditor( TypeInfo( TKOLAccelerator ), TKOLMenuItem, 'Accelerator',
                            TKOLAcceleratorPropEditor );
    RegisterNoIcon([TKOLAction]);
    RegisterClasses([TKOLAction]);
    RegisterComponentEditor( TKOLActionList, TKOLActionListEditor );
    RegisterPropertyEditor( TypeInfo( TKOLAccelerator ), TKOLAction, 'Accelerator',
                            TKOLAcceleratorPropEditor );
  end;

{$STACKFRAMES ON}
function GetCallStack: TStringList;
var RegEBP: PDWORD;
    RetAddr, MinSearchAddr, SrchPtr: PChar;
    Found: Boolean;
begin
  Result := TStringList.Create;
  asm
    MOV RegEBP, EBP
  end;
  while TRUE do
  begin
    Inc( RegEBP );
    RetAddr := Pointer( RegEBP^ );
    MinSearchAddr := RetAddr - 4000;
    if Integer( MinSearchAddr ) > Integer( RetAddr ) then
      break;
    Found := FALSE;
    SrchPtr := RetAddr - Length( '#$signature$#' ) - 1;
    while SrchPtr >= MinSearchAddr do
    begin
      if SrchPtr = '#$signature$#' then
      begin
        Found := TRUE;
        break;
      end;
      Dec( SrchPtr );
    end;
    if not Found then break;
    Inc( SrchPtr, Length( '#$signature$#' ) + 1 );
    Result.Add( SrchPtr );
    Dec( RegEBP );
    RegEBP := Pointer( RegEBP^ );
  end;
end;

function CmpInts( X, Y: Integer ): Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'CmpInts', 0
  @@e_signature:
  end;
  if X < Y then
    Result := -1
  else
  if X > Y then
    Result := 1
  else
    Result := 0;
end;

function IsVCLControl( C: TComponent ): Boolean;
var temp: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'IsVCLControl', 0
  @@e_signature:
  end;
  //----------------------- old
  {Result := C is controls.TControl;
  if Result then
  if (C is TKOLApplet) or (C is TKOLCustomControl) or (C is TOleControl) then
    Result := FALSE;}
  //----------------------- new - by Alexander Rabotyagov
  Result := C is controls.TControl;
  if Result then
  if (C is TKOLApplet) or (C is TKOLCustomControl) or (C is TOleControl)
  then result:=false
  else begin
    result:=false;
    if c.tag<>cKolTag
    then begin
      {KOL.ShowQuestion - более удобно, поэтому так:}
      temp:=KOL.ShowQuestion('Form contain VCL control!!!'+#13+#10+
        'Name this VCL control is '+c.name+'.'+#13+#10+
        'You have choise:'+#13+#10+
        '1) replace this VCL control - click "Replace"'+#13+#10+
        '2) ignore this VCL control - click "Ignore"'+#13+#10+
        '   (it change tag property to '+IntToStr(cKolTag)+','+#13+#10+
        '   remove it to Private'+#13+#10+
        '   and change source code to:'+#13+#10+
        '   {$IFNDEF KOL_MCK}'+c.Name+': '+c.ClassName+';{$ENDIF} {<-- It is a VCL control}'+#13+#10+
        '3) lock Your project - click "Lock"'
        ,'Replace/Ignore/Lock');
      try
        if temp=1 then c.free;
        if temp=2 then c.tag:=cKolTag;
        if temp=3 then result:=true;
      except
        Showmessage('Sorry, but can not do it! Your project will be locked!');
        result:=true;
      end;
    end;
  end;
end;

{$IFDEF MCKLOG}
var EnterLevel: array[ 0..7 ] of Integer;
    LevelOKStack: array[ 0..7, -1000..+1000 ] of Boolean;
    Threads: array[ 0..7 ] of DWORD;
function GetThreadIndex: Integer;
var i: Integer;
    CTI: DWORD;
begin
  CTI := GetCurrentThreadId;
  for i := 0 to 6 do
  begin
    if Threads[ i ] = CTI then
    begin
      Result := i;
      Exit;
    end;
  end;
  for i := 0 to 6 do
  begin
    if Threads[ i ] = 0 then
    begin
      Threads[ i ] := CTI;
      Result := i;
      Exit;
    end;
  end;
  Result := 7;
end;
{$ENDIF MCKLOG}

{$IFDEF MCKLOGBUFFERED}
var LogBuffer: TStringList;
{$ENDIF}

procedure Log( const S: String );
{$IFDEF MCKLOGBUFFERED}
var S1: String;
{$ENDIF}
begin
  {$IFDEF MCKLOG}
  if Copy( S, 1, 2 ) = '->' then
  begin
    Inc( EnterLevel[ GetThreadIndex ] );
    if (EnterLevel[ GetThreadIndex ] >= -1000) and (EnterLevel[ GetThreadIndex ] <= 1000) then
      LevelOKStack[ GetThreadIndex, EnterLevel[ GetThreadIndex ] ] := FALSE;
  end
  else
  if Copy( S, 1, 2 ) = '<-' then
  begin
    if (EnterLevel[ GetThreadIndex ] >= -1000) and (EnterLevel[ GetThreadIndex ] <= 1000) then
      if not LevelOKStack[ GetThreadIndex, EnterLevel[ GetThreadIndex ] ] then
        LogFileOutput( 'C:\MCK.log', DateTime2StrShort( Now ) +
                       ' <' + Int2Str( GetCurrentThreadId ) + '> ' +
                       IntToStr( EnterLevel[ GetThreadIndex ] ) + ' *** Leave not OK *** ' + S );
    Dec( EnterLevel[ GetThreadIndex ] );
  end;
  {$IFDEF MCKLOGwoRPT}
  if Copy( S, 1, 4 ) = 'Rpt:' then
    Exit;
  {$ENDIF MCKLOGwoRPT}
  {$IFDEF MCKLOGwoTKOLProject}
  if StrEq( Copy( S, 3, 11 ), 'TKOLProject' ) then
    Exit;
  {$ENDIF MCKLOGwoTKOLProject}

  S1 := DateTime2StrShort( Now ) +
       ' <' + Int2Str( GetCurrentThreadId ) + '> '
       + IntToStr( EnterLevel[ GetThreadIndex ] ) + ' ' + S;
  {$IFDEF MCKLOGBUFFERED}
  if LogBuffer = nil then
    LogBuffer := TStringList.Create;
  LogBuffer.Add( S1 );
  if LogBuffer.Count >= 100 then
  begin
    LogFileOutput( 'C:\MCK.log', TrimRight(LogBuffer.Text) );
    LogBuffer.Clear;
  end;
  {$ELSE}
  LogFileOutput( 'C:\MCK.log', S1 );
  {$ENDIF}
  {$ELSE}
  Sleep( 0 );
  {$ENDIF MCKLOG}
end;

procedure LogOK ;
begin
  {$IFDEF MCKLOG}
    if (EnterLevel[ GetThreadIndex ] >= -1000) and (EnterLevel[ GetThreadIndex ] <= 1000) then
      LevelOKStack[ GetThreadIndex, EnterLevel[ GetThreadIndex ] ] := TRUE;
  {$ENDIF}
end;

procedure Rpt( const S: String );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'Rpt', 0
  @@e_signature:
  end;
  Log( 'Rpt: ' + S );
  if KOLProject <> nil then
    KOLProject.Report( S )
  {else
  begin
    Windows.Beep( 100, 50 );
    ShowMessage( S );
  end};
end;

procedure Rpt_Stack;
var StrList: TStringList;
    I: Integer;
begin
  Rpt( 'Stack:' );
  StrList := GetCallStack;
  for I := 0 to StrList.Count-1 do
    Rpt( StrList[ I ] );
  StrList.Free;
end;

function ProjectSourcePath: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'ProjectSourcePath', 0
  @@e_signature:
  end;
  Result := '';
  if KOLProject <> nil then
    Result := KOLProject.SourcePath
  else
  if ToolServices <> nil then
    Result := ExtractFilePath( ToolServices.GetProjectName );
end;

function Get_ProjectName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'Get_ProjectName', 0
  @@e_signature:
  end;
  Result := '';
  if KOLProject <> nil then
    Result := KOLProject.ProjectName
  else
  if ToolServices <> nil then
    Result := ExtractFileNameWOExt( ToolServices.GetProjectName );
end;

function ReadTextFromIDE( Reader: TIEditReader ): PChar;
var Buf: PChar;
    Len, Pos: Integer;
    MS: TMemoryStream;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'ReadTextFromIDE', 0
  @@e_signature:
  end;
  Result := nil;
  GetMem( Buf, 10000 );
  MS := TMemoryStream.Create;
  Pos := 0;
  try

    Len := Reader.GetText( 0, Buf, 10000 );
    while Len > 0 do
    begin
      MS.Write( Buf[ 0 ], Len );
      Pos := Pos + Len;
      Len := Reader.GetText( Pos, Buf, 10000 );
    end;

    if MS.Size > 0 then
    begin
      GetMem( Result, MS.Size + 1 );
      Move( MS.Memory^, Result^, MS.Size );
      Result[ MS.Size ] := #0;
    end;

    //Rpt( IntToStr( MS.Size ) + ' bytes are read from IDE' );

  except
    on E: Exception do
    begin
      ShowMessage( 'Cannot read text from IDE, exception: ' + E.Message );
    end;
  end;
  FreeMem( Buf );
  MS.Free;
end;

{$IFNDEF VER90}
{$IFNDEF VER100}
function ReadTextFromIDE_0( Reader: IOTAEditReader ): PChar;
var Buf: PChar;
    Len, Pos: Integer;
    MS: TMemoryStream;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'ReadTextFromIDE_0', 0
  @@e_signature:
  end;
  Result := nil;
  GetMem( Buf, 10000 );
  MS := TMemoryStream.Create;
  Pos := 0;
  try

    Len := Reader.GetText( 0, Buf, 10000 );
    while Len > 0 do
    begin
      MS.Write( Buf[ 0 ], Len );
      Pos := Pos + Len;
      Len := Reader.GetText( Pos, Buf, 10000 );
    end;

    if MS.Size > 0 then
    begin
      GetMem( Result, MS.Size + 1 );
      Move( MS.Memory^, Result^, MS.Size );
      Result[ MS.Size ] := #0;
    end;

    //Rpt( IntToStr( MS.Size ) + ' bytes are read from IDE' );

  except
    on E: Exception do
    begin
      ShowMessage( 'Cannot read text from IDE, exception(0): ' + E.Message );
    end;
  end;
  FreeMem( Buf );
  MS.Free;
end;
{$ENDIF}
{$ENDIF}

procedure LoadSource( SL: TStrings; const Path: String );
var N, I: Integer;
    S: String;
    Loaded: Boolean;
    Module: TIModuleInterface;
    Editor: TIEditorInterface;
    Reader: TIEditReader;
    Buffer: PChar;

    {$IFNDEF VER90}
    {$IFNDEF VER100}
    MS: IOTAModuleServices;
    M: IOTAModule;
    E: IOTAEditor;
    SE: IOTASourceEditor;
    ER: IOTAEditReader;
    {$ENDIF}
    {$ENDIF}

begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'LoadSource', 0
  @@e_signature:
  end;
  Loaded := False;
  SL.Clear;
  if ToolServices <> nil then
  try
    //Rpt( 'trying to load from IDE Editor: ' + Path );

    N := ToolServices.GetUnitCount;
    for I := 0 to N - 1 do
    begin
      S := ToolServices.GetUnitName( I );
      if AnsiLowerCase( S ) = AnsiLowerCase( Path ) then
      begin
        // unit is loaded into IDE editor - make an attempt to get it from there
        Module := ToolServices.GetModuleInterface( S );
        if Module <> nil then
        try
          Editor := Module.GetEditorInterface;
          if Editor <> nil then
          try
            Reader := Editor.CreateReader;
            Buffer := nil;
            if Reader <> nil then
            try
              //Rpt( 'Loading source from IDE Editor: ' + Path );
              Buffer := ReadTextFromIDE( Reader );
              if Buffer <> nil then
              begin
                SL.Text := Buffer;
                Loaded := True;
                //Rpt( 'Loaded: ' + Path );
              end;
            finally
              Reader.Free;
              if Buffer <> nil then
                FreeMem( Buffer );
            end;
          finally
            Editor.Free;
          end;
        finally
          Module.Free;
        end;
        break;
      end;
    end;

    {$IFNDEF VER90}
    {$IFNDEF VER100}
    if not Loaded and (BorlandIDEServices <> nil) then
    begin
      if BorlandIDEServices.QueryInterface( IOTAModuleServices, MS ) = 0 then
      begin
        M := MS.FindModule( Path );
        if M <> nil then
        begin
          N := M.GetModuleFileCount;
          for I := 0 to N-1 do
          begin
            E := M.GetModuleFileEditor( I );
            if E.QueryInterface( IOTASourceEditor, SE ) = 0 then
            begin
              ER := SE.CreateReader;
              if ER <> nil then
              begin
                Buffer := ReadTextFromIDE_0( ER );
                if Buffer <> nil then
                begin
                  SL.Text := Buffer;
                  Loaded := True;
                  //Rpt( 'Loaded_0: ' + Path );
                end;
                break;
              end;
            end;
          end;
        end;
      end;
    end;
    {$ENDIF}
    {$ENDIF}

  except
    on E: Exception do
    begin
      ShowMessage( 'Can not load source of ' + Path + ', exception: ' + E.Message );
    end;
  end;

  if not Loaded then
  if FileExists( Path ) then
    SL.LoadFromFile( Path );

end;

function UpdateSource( SL: TStrings; const Path: String ): Boolean;
var N, I: Integer;
    S: String;
    Module: TIModuleInterface;
    Editor: TIEditorInterface;
    Writer: TIEditWriter;
    Buffer: String;

    {$IFNDEF VER90}
    {$IFNDEF VER100}
    MS: IOTAModuleServices;
    M: IOTAModule;
    E: IOTAEditor;
    SE: IOTASourceEditor;
    {$IFNDEF VER120}
    EB: IOTAEditBuffer;
    RO: Boolean;
    {$ENDIF}
    EW: IOTAEditWriter;
    {$ENDIF}
    {$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'UpdateSource', 0
  @@e_signature:
  end;
  Rpt( 'Updating source for ' + Path );
  //Rpt_Stack;
  Result := False;
  if ToolServices <> nil then
  try
    //Rpt( 'trying to save to IDE Editor: ' + Path );

    N := ToolServices.GetUnitCount;
    for I := 0 to N - 1 do
    begin
      S := ToolServices.GetUnitName( I );
      if AnsiLowerCase( S ) = AnsiLowerCase( Path ) then
      begin
        //Rpt( 'Updating in IDE: ' + Path );
        // unit is loaded into IDE editor - make an attempt to update it from there
        Module := ToolServices.GetModuleInterface( S );
        if Module <> nil then
        try
          Editor := Module.GetEditorInterface;
          if Editor <> nil then
          try
            Writer := Editor.CreateWriter;
            Buffer := SL.Text;
            if Writer <> nil then
            try
              //Rpt( 'Updating source in IDE Editor: ' + Path );
              if Writer.DeleteTo( $3FFFFFFF ) and Writer.Insert( PChar( Buffer ) ) then
                Result := True;
              //else Rpt( 'Can not update ' + S );
            finally
              Writer.Free;
            end;
          finally
            Editor.Free;
          end;
        finally
          Module.Free;
        end;
        break;
      end;
    end;

    {$IFNDEF VER90}
    {$IFNDEF VER100}
    if not Result and (BorlandIDEServices <> nil) then
    begin
      if BorlandIDEServices.QueryInterface( IOTAModuleServices, MS ) = 0 then
      begin
        M := MS.FindModule( Path );
        if M <> nil then
        begin
          N := M.GetModuleFileCount;
          for I := 0 to N-1 do
          begin
            E := M.GetModuleFileEditor( I );
            if E.QueryInterface( IOTASourceEditor, SE ) = 0 then
            begin
              {$IFNDEF VER120}
              if E.QueryInterface( IOTAEditBuffer, EB ) = 0 then
              begin
                RO := EB.IsReadOnly;
                if RO then
                  EB.IsReadOnly := FALSE;
              end;
              {$ENDIF}
              EW := SE.CreateWriter;
              if EW <> nil then
              begin
                Buffer := SL.Text;
                EW.DeleteTo( $3FFFFFFF );
                EW.Insert( PChar( Buffer ) );
                Result := True;
                break;
              end;
            end;
          end;
        end;
      end;
    end;
    {$ENDIF}
    {$ENDIF}

  except
    on E: Exception do
    begin
      ShowMessage( 'Can not update source, exception: ' + E.Message );
    end;
  end;

end;

procedure SaveStrings( SL: TStrings; const Path: String; var Updated: Boolean );
var S1: String;
    Old: TStringList;
    I: Integer;
    TheSame: Boolean;
    OldCount, NewCount: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'SaveStrings', 0
  @@e_signature:
  end;
  //Rpt( 'SaveStrings: ' + Path );
  Old := TStringList.Create;
  LoadSource( Old, Path );

  TheSame := FALSE;
  if Old.Count > 0 then
  begin
    OldCount := Old.Count;
    while (OldCount > 1) and (Trim(Old[ OldCount - 1 ]) = '') do
      Dec( OldCount );
    NewCount := SL.Count;
    while (NewCount > 1) and (Trim(SL[ NewCount - 1]) = '') do
      Dec( NewCount );
    TheSame := OldCount = NewCount;
    if TheSame then
    for I := 0 to OldCount - 1 do
      if Old[ I ] <> SL[ I ] then
      begin
        TheSame := False;
        break;
      end;
    Old.Free;
  end;
  if not TheSame then
  begin
    Rpt( 'SaveStrings: found that strings are different' ); //Rpt_Stack;

    if UpdateSource( SL, Path ) then
    begin
      //Rpt( 'updated (in IDE Editor): ' + Path );
      if FileExists( Path ) then
        SetFileAttributes( PChar( Path ), FILE_ATTRIBUTE_NORMAL );
      Updated := TRUE;
      Exit;
    end;

    //Rpt( 'writing to ' + Path );
    S1 := Copy( Path, 1, Length( Path ) - 3 ) + '$$$';
    if FileExists( S1 ) then
      DeleteFile( S1 );
    SetFileAttributes( PChar( Path ), FILE_ATTRIBUTE_NORMAL );
    MoveFile( PChar( Path ), PChar( S1 ) );
    if KOLProject <> nil then
    begin
      S1 := KOLProject.OutdcuPath + ExtractFileName( Path );
      if LowerCase( Copy( S1, Length( S1 ) - 3, 4 ) ) = '.inc' then
        S1 := Copy( S1, 1, Length( S1 ) - 6 ) + '.dcu'
      else
        S1 := Copy( S1, 1, Length( S1 ) - 3 ) + 'dcu';
      if FileExists( S1 ) then
      begin
        //Rpt( 'Remove: ' + S1 );
        DeleteFile( S1 );
      end;
    end;
    SL.SaveToFile( Path );
    Updated := TRUE;
    {if Protect then
      SetFileAttributes( PChar( Path ), FILE_ATTRIBUTE_READONLY );}
  end
     else
  begin
    //Rpt( 'file ' + Path + ' is the same.' );
    Exit;
  end;
end;

procedure SaveStringToFile(const Path, Str: String );
var SL: TStringList;
begin
  SL := TStringList.Create;
  TRY
  SL.Text := Str;
  SL.SaveToFile( Path );
  FINALLY
  SL.Free;
  END;
end;

procedure MarkModified( const Path: String );
{$IFNDEF VER90}
{$IFNDEF VER100}
var MS: IOTAModuleServices;
    M: IOTAModule;
    E: IOTAEditor;
    I, N: Integer;
{$ENDIF}
{$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'MarkModified', 0
  @@e_signature:
  end;
  Rpt( 'MarkModified: ' + Path ); //Rpt_Stack;
{$IFNDEF VER90}
{$IFNDEF VER100}
  if (BorlandIDEServices <> nil) and
     (BorlandIDEServices.QueryInterface( IOTAModuleServices, MS ) = 0) then
  begin
    M := MS.FindModule( Path );
    if M <> nil then
    begin
      N := M.GetModuleFileCount;
      for I := 0 to N-1 do
      begin
        E := M.GetModuleFileEditor( I );
        if E <> nil then
        begin
          E.MarkModified;
          break;
        end;
      end;
    end;
  end;
{$ENDIF}
{$ENDIF}
end;

procedure UpdateUnit( const Path: String );
var MI: TIModuleInterface;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'UpdateUnit', 0
  @@e_signature:
  end;
  if ToolServices = nil then Exit;
  MI := ToolServices.GetModuleInterface( Path );
  if MI <> nil then
  TRY
    Rpt( 'Update Unit: ' + Path ); //Rpt_Stack;
    MI.Save( TRUE );
  FINALLY
    MI.Free;
  END;
end;

procedure AddLongTextField( var SL: TStringList; const Prefix:String;
 const Text:String; const Suffix:String );
var //s:String;
    i,k,n:Integer;
const LIMIT = 80;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'AddLongTextField', 0
  @@e_signature:
  end;
     if ( Length( Text ) > LIMIT ) then
     begin
          SL.Add( Prefix + '''''' );

          k := Length( Text );
          i := 0;
          while ( i <> k ) do
          begin
               inc(i);
               n := ( i mod LIMIT );
               if ( ( n = LIMIT - 1 ) or ( i = k ) ) then
               begin
                    SL.Add( ' + ' + String2Pascal( Copy( Text, i + 1 - n, n + 1 ) ) );
               end;
          end;

          SL.Add( Suffix );
     end
     else
     begin
          SL.Add( Prefix + String2Pascal(Text) + Suffix );
     end;
end;






{YS}//--------------------------------------------------------------

{$IFNDEF NOT_USE_KOLCTRLWRAPPER}
function InterceptWndProc( W: HWnd; Msg: Cardinal; wParam, lParam: Integer ): Integer; stdcall;
var
  KOLParentCtrl: PControl;
  _Msg: TMsg;
  OldWndProc: pointer;

begin
  KOLParentCtrl:=PControl(GetProp(W, 'KOLParentCtrl'));
  OldWndProc:=pointer(GetProp(W, 'OldWndProc'));

  if Assigned(KOLParentCtrl) and KOLParentCtrl.HandleAllocated then
      if (Msg in [WM_DRAWITEM, WM_NOTIFY, WM_SIZE, WM_MEASUREITEM]) then begin
        _Msg.hwnd:=KOLParentCtrl.Handle;
        _Msg.message:=Msg;
        _Msg.wParam:=WParam;
        _Msg.lParam:=LParam;
        KOLParentCtrl.WndProc(_Msg);
      end;

  Result:=CallWindowProc(OldWndProc, W, Msg, wParam, lParam);
end;

function EnumChildProc(wnd: HWND; lParam: integer): BOOL; stdcall;
begin
  ShowWindow(wnd, lParam);
  Result:=True;
end;

{ TKOLVCLParent }

function NewKOLVCLParent: PKOLVCLParent;
begin
  New( Result, CreateParented( nil ) );
  Result.fControlClassName := 'KOLVCLParent';
  Result.Visible:=False;
end;
{$ENDIF NOT_USE_KOLCTRLWRAPPER}

procedure TKOLVCLParent.AttachHandle(AHandle: HWND);
begin
  fHandle:=AHandle;
end;

procedure TKOLVCLParent.AssignDynHandlers(Src: PKOLVCLParent);
var
  i: integer;

begin
  i:=0;
  while i < Src.fDynHandlers.Count do begin
    AttachProcEx(Src.fDynHandlers.Items[i], boolean(Src.fDynHandlers.Items[i + 1]));
    Inc(i, 2);
  end;
end;

{$IFNDEF NOT_USE_KOLCTRLWRAPPER}
{ TKOLCtrlWrapper }

constructor TKOLCtrlWrapper.Create(AOwner: TComponent);
begin
  inherited;
  FAllowSelfPaint:=True;
{$IFDEF _KOLCtrlWrapper_}
  CreateKOLControl(False);
{$ENDIF}
end;

destructor TKOLCtrlWrapper.Destroy;
begin
  if Assigned(FKOLCtrl) then begin
    Parent:=nil;
    if Assigned(FKOLCtrl) and (FKOLCtrl.Parent <> nil) and not FRealParent then begin
      FKOLParentCtrl.RefDec;
      RemoveParentAttach;
    end;
  end;
  inherited;
  if not FRealParent and Assigned(FKOLParentCtrl) and (FKOLParentCtrl.RefCount = 0) then
    FKOLParentCtrl.Free;
end;

procedure TKOLCtrlWrapper.RemoveParentAttach;
var
  wp: integer;
begin
  if not FRealParent and (FKOLParentCtrl.RefCount <= 1) and FKOLParentCtrl.HandleAllocated then begin
    wp:=GetProp(FKOLParentCtrl.Handle, 'OldWndProc');
    if wp <> 0 then
      SetWindowLong(FKOLParentCtrl.Handle, GWL_WNDPROC, wp);
    RemoveProp(FKOLParentCtrl.Handle, 'KOLParentCtrl');
    RemoveProp(FKOLParentCtrl.Handle, 'OldWndProc');
    FKOLParentCtrl.AttachHandle(0);
  end;
end;

procedure TKOLCtrlWrapper.SetParent(Value: TWinControl);
var
  KP: PKOLVCLParent;

  procedure AssignNewParent;
  begin
    KP.AssignDynHandlers(FKOLParentCtrl);
    FKOLCtrl.Parent:=KP;
    Windows.SetParent(FKOLCtrl.Handle, Value.Handle);
    if not FRealParent then
      FKOLParentCtrl.Free;
    FKOLParentCtrl:=KP;
  end;

var
  F: TCustomForm;

begin
  if Assigned(FKOLCtrl) and (Parent <> Value) then begin
    if Assigned(Parent) then begin
      FKOLCtrl.Parent:=nil;
      if not FRealParent then begin
        FKOLParentCtrl.RefDec;
        RemoveParentAttach;
      end;
    end;
    if Assigned(Value) then begin
      if (Value is TKOLCtrlWrapper) and Assigned(TKOLCtrlWrapper(Value).FKOLCtrl) then
        KP:=PKOLVCLParent(TKOLCtrlWrapper(Value).FKOLCtrl)
      else
        KP:=PKOLVCLParent(GetProp(Value.Handle, 'KOLParentCtrl'));
      if Assigned(KP) then begin
        AssignNewParent;
        FRealParent:=(Value is TKOLCtrlWrapper) and Assigned(TKOLCtrlWrapper(Value).FKOLCtrl);
      end
      else begin
        FRealParent:=False;
        if FKOLParentCtrl.HandleAllocated then begin
          KP:=NewKOLVCLParent;
          AssignNewParent;
        end;
        FKOLParentCtrl.AttachHandle(Value.Handle);
        SetProp(Value.Handle, 'KOLParentCtrl', integer(FKOLParentCtrl));
        SetProp(Value.Handle, 'OldWndProc', GetWindowLong(Value.Handle, GWL_WNDPROC));
        SetWindowLong(Value.Handle, GWL_WNDPROC, integer(@InterceptWndProc));
      end;
      if not FRealParent then
        FKOLParentCtrl.RefInc;
      FKOLCtrl.Style:=FKOLCtrl.Style or WS_CLIPSIBLINGS;
    end;
  end;
  inherited;
  if Assigned(FKOLCtrl) and Assigned(Value) then begin
    HandleNeeded;
    F:=GetParentForm(Self);
    if Assigned(F) then
      Windows.SetFocus(F.Handle);
    UpdateAllowSelfPaint;
  end;
end;

procedure TKOLCtrlWrapper.WndProc(var Message: TMessage);
var
  DeniedMessage: boolean;
  DC: HDC;
  PS: TPaintStruct;
begin
  if Assigned(FKOLCtrl) then begin
    DeniedMessage:=(((Message.Msg >= WM_MOUSEFIRST) and (Message.Msg <= WM_MOUSELAST)) or
       ((Message.Msg >= WM_KEYFIRST) and (Message.Msg <= WM_KEYLAST)) or
       (Message.Msg in [WM_NCHITTEST, WM_SETCURSOR]) or
       (Message.Msg = CM_DESIGNHITTEST)
       {$IFDEF _D3orHigher} or (Message.Msg = CM_RECREATEWND) {$ENDIF}
       );

    if not FAllowSelfPaint and (Message.Msg in [WM_NCCALCSIZE, WM_ERASEBKGND]) then
      exit;

    if FAllowSelfPaint or (Message.Msg <> WM_PAINT) then
      if not DeniedMessage then
        CallKOLCtrlWndProc(Message);

    if (FKOLCtrl.Parent = nil) and (Message.Msg = WM_NCDESTROY) then begin
      FKOLCtrl:=nil;
      if not FRealParent and Assigned(FKOLParentCtrl) and (FKOLParentCtrl.RefCount = 0) then begin
        FKOLParentCtrl.Free;
        FKOLParentCtrl:=nil;
      end;
      exit;
    end;

    if not (DeniedMessage or
            (Message.Msg in [WM_PAINT, WM_SIZE, WM_MOVE, WM_WINDOWPOSCHANGED, WM_WINDOWPOSCHANGING, WM_DESTROY]))
    then
      exit;

    if (Message.Msg = WM_PAINT) then begin
      if FAllowSelfPaint then
        DC:=GetDC(WindowHandle)
      else
        DC:=BeginPaint(WindowHandle, PS);
      try
        Message.WParam:=DC;
        inherited;
      finally
        if FAllowSelfPaint then
          ReleaseDC( WindowHandle, DC )
        else
          EndPaint(WindowHandle, PS);
      end;
      exit;
    end;

  end;
  inherited;
  if {$IFDEF _D3orHigher} (Message.Msg = CM_RECREATEWND) and {$ENDIF}
     FKOLCtrlNeeded then
    HandleNeeded;
end;

procedure TKOLCtrlWrapper.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var R: TRect;
begin
  Log( '->TKOLCtrlWrapper.SetBounds' );
  try
    TRY
    //Log( 'TKOLCtrlWrapper.SetBounds-1' );
    //if not( csLoading in ComponentState ) then
    begin
      //Log( 'TKOLCtrlWrapper.SetBounds-1A - very often crashed here on loading project' );
      //Rpt_Stack;
      inherited SetBounds( ALeft, ATop, AWidth, AHeight );
      //Log( 'TKOLCtrlWrapper.SetBounds-1B' );
      R := BoundsRect;
      //Log( 'TKOLCtrlWrapper.SetBounds-1C' );
    end
      {else
    begin
      //Log( 'TKOLCtrlWrapper.SetBounds-1D' );
      R := Rect( ALeft, ATop, ALeft+AWidth, ATop+AHeight  );
      //Log( 'TKOLCtrlWrapper.SetBounds-1E' );
    end};
    //Log( 'TKOLCtrlWrapper.SetBounds-2' );
    if Assigned(FKOLCtrl) then
    begin
      //Log( 'TKOLCtrlWrapper.SetBounds-3' );
      if FKOLCtrl <> nil then
      begin
        //Log( 'TKOLCtrlWrapper.SetBounds-3A' );
        //Log( 'FKOLCtrl.Handle = ' + Int2Str( FKOLCtrl.Handle ) );
        //Log( 'FKOLCtrl.Parent = ' + Int2Str( DWORD( FKOLCtrl.Parent ) ) );
        FKOLCtrl.BoundsRect := R;
        //Log( 'TKOLCtrlWrapper.SetBounds-3B' );
      end;
      //Log( 'TKOLCtrlWrapper.SetBounds-4' );
      if not FAllowSelfPaint and HandleAllocated then
      begin
        //Log( 'TKOLCtrlWrapper.SetBounds-5' );
        UpdateAllowSelfPaint;
        //Log( 'TKOLCtrlWrapper.SetBounds-6' );
      end;
      //Log( 'TKOLCtrlWrapper.SetBounds-7' );
    end;
    EXCEPT
      on E: EXception do
        Rpt( 'Exception in TKOLCtrlWrapper.SetBounds: ' + E.Message );
    END;
  LogOK;
  finally
  Log( '<-TKOLCtrlWrapper.SetBounds' );
  end;
end;

procedure TKOLCtrlWrapper.CreateWnd;
begin
  if not Assigned(FKOLCtrl) and FKOLCtrlNeeded then begin
    CreateKOLControl(True);
    if Assigned(FKOLCtrl) then
      FKOLCtrl.BoundsRect:=BoundsRect;
  end;
  if Assigned(FKOLCtrl) then begin
    WindowHandle:=FKOLCtrl.GetWindowHandle;
    CreationControl:=Self;
    InitWndProc(WindowHandle, 0, 0, 0);
    if FKOLCtrlNeeded then
      KOLControlRecreated;
    FKOLCtrlNeeded:=False;
    UpdateAllowSelfPaint;
    FKOLCtrl.Visible:=True;
  end
  else
    inherited;
end;

procedure TKOLCtrlWrapper.DestroyWindowHandle;
var
  i: integer;
begin
  if Assigned(FKOLCtrl) then begin
    WindowHandle:=0;
    while FKOLCtrl.ChildCount > 0 do
      FKOLCtrl.Children[0].Parent:=nil;
    {$IFDEF _D4orHigher}
    ControlState:=ControlState + [csDestroyingHandle];
    {$ENDIF}
    try
      FKOLCtrl.Free;
    finally
      {$IFDEF _D4orHigher}
      ControlState:=ControlState - [csDestroyingHandle];
      {$ENDIF}
    end;
    FKOLCtrl:=nil;
    if not (csDestroying in ComponentState) then begin
      for i:=0 to ControlCount - 1 do
        if Controls[i] is TKOLCtrlWrapper then
          with TKOLCtrlWrapper(Controls[i]) do begin
            FKOLParentCtrl:=nil;
          end;
    end;
    FKOLCtrlNeeded:=True;
  end
  else
    inherited;
end;

procedure TKOLCtrlWrapper.DefaultHandler(var Message);
begin
  if Assigned(FKOLCtrl) then begin
    if AllowSelfPaint and not (TMessage(Message).Msg in [WM_PAINT, WM_SETCURSOR, WM_DESTROY]) then
      CallKOLCtrlWndProc(TMessage(Message));
  end
  else
    inherited;
end;

procedure TKOLCtrlWrapper.CallKOLCtrlWndProc(var Message: TMessage);
var
  _Msg: TMsg;
begin
  _Msg.hwnd:=FKOLCtrl.Handle;
  _Msg.message:=Message.Msg;
  _Msg.wParam:=Message.wParam;
  _Msg.lParam:=Message.lParam;
  Message.Result:=FKOLCtrl.WndProc(_Msg);
end;

procedure TKOLCtrlWrapper.Invalidate;
begin
  if not Assigned(FKOLCtrl) then
    inherited
  else
  begin
    if HandleAllocated then
    begin
      InvalidateRect(WindowHandle, nil, not (csOpaque in ControlStyle))
    end;
    FKOLCtrl.Invalidate;
  end;
end;

procedure TKOLCtrlWrapper.SetAllowSelfPaint(const Value: boolean);
begin
  if FAllowSelfPaint = Value then exit;
  FAllowSelfPaint := Value;
  UpdateAllowSelfPaint;
end;

procedure TKOLCtrlWrapper.UpdateAllowSelfPaint;
var
  i: integer;

begin
  if Assigned(FKOLCtrl) and HandleAllocated then begin
    if not (csAcceptsControls in ControlStyle) then begin
      if FAllowSelfPaint then
        i:=SW_SHOW
      else
        i:=SW_HIDE;
      EnumChildWindows(WindowHandle, @EnumChildProc, i);
    end;
    SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_DRAWFRAME or SWP_FRAMECHANGED or SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER);
    Invalidate;
  end;
end;

function TKOLCtrlWrapper.GetKOLParentCtrl: PControl;
begin
  if (FKOLParentCtrl = nil) and (FKOLCtrl = nil) then begin
    if Assigned(Parent) and (Parent is TKOLCtrlWrapper) and Assigned(TKOLCtrlWrapper(Parent).FKOLCtrl) then
      FKOLParentCtrl:=PKOLVCLParent(TKOLCtrlWrapper(Parent).FKOLCtrl)
    else
      FKOLParentCtrl:=NewKOLVCLParent;
  end;
  Result:=FKOLParentCtrl;
end;

procedure TKOLCtrlWrapper.PaintWindow(DC: HDC);
begin
  if Assigned(FKOLCtrl) and not FAllowCustomPaint and not FAllowPostPaint then
    exit;
  inherited;
end;

procedure TKOLCtrlWrapper.CreateKOLControl(Recreating: boolean);
begin
end;

procedure TKOLCtrlWrapper.KOLControlRecreated;
begin
end;

procedure TKOLCtrlWrapper.DestroyWnd;
begin
  inherited;
  if FKOLCtrlNeeded then begin
    StrDispose(WindowText);
    WindowText:=nil;
  end;
end;
{$ENDIF NOT_USE_KOLCTRLWRAPPER}

procedure TKOLCtrlWrapper.Change;
begin
  Log( '->TKOLCtrlWrapper.Change' );
  TRY
  LogOK;
  FINALLY
  Log( '<-TKOLCtrlWrapper.Change' );
  END;
end;

{ TKOLCustomControl }

function TKOLCustomControl.AdditionalUnits: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.AdditionalUnits', 0
  @@e_signature:
  end;
  Result := '';
end;

procedure TKOLCustomControl.ApplyColorToChildren;
var I: Integer;
    C: TKOLCustomControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ApplyFontToChildren', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.ApplyColorToChildren' );
  try
  for I := 0 to FParentLikeColorControls.Count - 1 do
  begin
    C := FParentLikeColorControls[ I ];
    C.Color := Color;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.ApplyColorToChildren' );
  end;
end;

procedure TKOLCustomControl.ApplyFontToChildren;
var I: Integer;
    C: TKOLCustomControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ApplyFontToChildren', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.ApplyFontToChildren' );
  try
  if AutoSize then
    AutoSizeNow;
  for I := 0 to FParentLikeFontControls.Count - 1 do
  begin
    C := FParentLikeFontControls[ I ];
    C.Font.Assign( Font );
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.ApplyFontToChildren' );
  end;
end;

procedure TKOLCustomControl.AssignEvents(SL: TStringList; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.AssignEvents', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.AssignEvents' );
  try
  DoAssignEvents( SL, AName,
  [ 'OnClick', 'OnMouseDblClk', 'OnMessage', 'OnMouseDown', 'OnMouseMove', 'OnMouseUp', 'OnMouseWheel', 'OnMouseEnter', 'OnMouseLeave' ],
  [ @OnClick, @ OnMouseDblClk,  @OnMessage,  @OnMouseDown,  @OnMouseMove,  @OnMouseUp,  @OnMouseWheel,  @OnMouseEnter,  @OnMouseLeave  ] );
  DoAssignEvents( SL, AName,
  [ 'OnDestroy', 'OnEnter', 'OnLeave', 'OnKeyDown', 'OnKeyUp', 'OnChar' ],
  [ @ OnDestroy, @OnEnter,  @OnLeave,  @OnKeyDown,  @OnKeyUp,  @OnChar  ] );
  DoAssignEvents( SL, AName,
  [ 'OnChange', 'OnSelChange', 'OnPaint', 'OnEraseBkgnd', 'OnResize', 'OnMove', 'OnBitBtnDraw', 'OnDropDown', 'OnCloseUp', 'OnProgress' ],
  [ @OnChange,  @OnSelChange,  @OnPaint , @ OnEraseBkgnd, @OnResize,  @ OnMove, @OnBitBtnDraw,  @OnDropDown, @ OnCloseUp,  @ OnProgress  ] );
  DoAssignEvents( SL, AName,
  [ 'OnDeleteAllLVItems', 'OnDeleteLVItem', 'OnLVData', 'OnCompareLVItems', 'OnColumnClick', 'OnLVStateChange', 'OnEndEditLVItem' ],
  [ @ OnDeleteAllLVItems, @ OnDeleteLVItem, @ OnLVData, @ OnCompareLVItems, @ OnColumnClick, @ OnLVStateChange, @ OnEndEditLVItem ] );
  DoAssignEvents( SL, AName,
  [ 'OnDrawItem', 'OnMeasureItem', 'OnTBDropDown', 'OnDropFiles', 'OnShow', 'OnHide', 'OnSplit', 'OnScroll' ],
  [ @ OnDrawItem, @ OnMeasureItem, @ OnTBDropDown, @ OnDropFiles, @ OnShow, @ OnHide, @ OnSplit, @ OnScroll ] );
  DoAssignEvents( SL, AName,
  [ 'OnRE_URLClick', 'OnRE_InsOvrMode_Change', 'OnRE_OverURL' ],
  [ @ OnRE_URLClick, @ OnRE_InsOvrMode_Change, @ OnRE_OverURL ] );
  DoAssignEvents( SL, AName,
  [ 'OnTVBeginDrag', 'OnTVBeginEdit', 'OnTVEndEdit', 'OnTVExpanded', 'OnTVExpanding', 'OnTVSelChanging', 'OnTVDelete' ],
  [ @ OnTVBeginDrag, @ OnTVBeginEdit, @ OnTVEndEdit, @ OnTVExpanded, @ OnTVExpanding, @ OnTVSelChanging, @ OnTVDelete ] );
  LogOK;
  finally
  Log( '<-TKOLCustomControl.AssignEvents' );
  end;
end;

function TKOLCustomControl.AutoHeight(Canvas: TCanvas): Integer;
var Txt: String;
    Sz: TSize;
    R: TRect;
    Flags: DWORD;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.AutoHeight', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.AutoHeight' );
  try
  if Caption <> '' then
    Txt := Caption
  else
    Txt := 'Ap^_/|';
  Windows.GetTextExtentPoint32( Canvas.Handle, PChar( Txt ), Length( Txt ),
                                Sz );
  Result := Sz.cy;
  if WordWrap and (Align <> caClient) then
  begin
    R := ClientRect;
    Flags := DT_CALCRECT or DT_EXPANDTABS or DT_WORDBREAK;
    CASE TextAlign OF
    taCenter: Flags := Flags or DT_CENTER;
    taRight : Flags := Flags or DT_RIGHT;
    END;
    CASE VerticalAlign OF
    vaCenter: Flags := Flags or DT_VCENTER;
    vaBottom: Flags := Flags or DT_BOTTOM;
    END;
    DrawText( Canvas.Handle, PChar( Txt ), Length( Txt ), R, Flags );
    Result := R.Bottom - R.Top;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.AutoHeight' );
  end;
end;

procedure TKOLCustomControl.AutoSizeNow;
var TmpBmp: graphics.TBitmap;
    W, H: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'AutoSizeNow', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.AutoSizeNow' );
  try

  if fAutoSizingNow or (csLoading in ComponentState) then
  begin
    LogOK; Exit;
  end;
  fAutoSizingNow := TRUE;
  Rpt( 'Autosize, Name: ' + Name );
  TmpBmp := graphics.TBitmap.Create;
  try
    TmpBmp.Width := 10;
    TmpBmp.Height := 10;
    Rpt( 'Autosize, Prepare Font for WYSIWIG Paint' );
    PrepareCanvasFontForWYSIWIGPaint( TmpBmp.Canvas );
    Rpt( 'Name=' + Name + ': Canvas.Handle := ' + Int2Hex( TmpBmp.Canvas.Handle, 8 ) );
    if WordWrap then
      W := Width
    else
      W := AutoWidth( TmpBmp.Canvas );
    H := AutoHeight( TmpBmp.Canvas );
    Rpt( 'Name=' + Name + ': Canvas.Handle := ' + Int2Hex( TmpBmp.Canvas.Handle, 8 ) );
    Rpt( 'Name=' + Name + ': W=' + IntToStr( W ) + ' H=' + IntToStr( H ) );
    if Align in [ caNone, caLeft, caRight ] then
    if not fNoAutoSizeX and not WordWrap then
      Width := W + fAutoSzX;
    if Align in [ caNone, caTop, caBottom ] then
      Height := H + fAutoSzY;
  finally
    TmpBmp.Free;
    fAutoSizingNow := FALSE;
  end;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.AutoSizeNow' );
  end;
end;

function TKOLCustomControl.AutoWidth(Canvas: TCanvas): Integer;
var Txt: String;
    Sz: TSize;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.AutoWidth', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.AutoWidth' );
  try
  if WordWrap then
    Result := Width
  else
  begin
    Txt := Caption;
    if fsItalic in Font.FontStyle then
      Txt := Txt + ' ';
    Windows.GetTextExtentPoint32( Canvas.Handle, PChar( Txt ), Length( Txt ),
                                  Sz );
    Result := Sz.cx;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.AutoWidth' );
  end;
end;

procedure TKOLCustomControl.Change;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Change', 0
  @@e_signature:
  end;
  //Log( '->TKOLCustomControl.Change' );
  try
  if not fChangingNow then
  begin
    fChangingNow := TRUE;
    try
      if not (csLoading in ComponentState) then
      if ParentKOLForm <> nil then
        ParentKOLForm.Change( Self );
    finally
      fChangingNow := FALSE;
    end;
  end;
  //LogOK;
  finally
  //Log( '<-TKOLCustomControl.Change' );
  end;
end;

procedure TKOLCustomControl.Click;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Click', 0
  @@e_signature:
  end;
  //
end;

function TKOLCustomControl.ClientMargins: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ClientMargins', 0
  @@e_signature:
  end;
  Result :=  Rect( 0, 0, 0, 0 );
end;

procedure TKOLCustomControl.CollectChildrenWithParentColor;
var I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.CollectChildrenWithParentFont', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.CollectChildrenWithParentColor' );
  try
  FParentLikeColorControls.Clear;
  for I := 0 to ParentForm.ComponentCount - 1 do
  begin
    C := ParentForm.Components[ I ];
    if (C is TKOLCustomControl) and ((C as TKOLCustomControl).Parent = Self) then
    if (C as TKOLCustomControl).parentColor then
      FParentLikeColorControls.Add( C );
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.CollectChildrenWithParentColor' );
  end;
end;

procedure TKOLCustomControl.CollectChildrenWithParentFont;
var I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.CollectChildrenWithParentFont', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.CollectChildrenWithParentFont' );
  try
  FParentLikeFontControls.Clear;
  for I := 0 to ParentForm.ComponentCount - 1 do
  begin
    C := ParentForm.Components[ I ];
    if (C is TKOLCustomControl) and ((C as TKOLCustomControl).Parent = Self) then
    if (C as TKOLCustomControl).ParentFont then
      FParentLikeFontControls.Add( C );
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.CollectChildrenWithParentFont' );
  end;
end;

function TKOLCustomControl.ControlIndex: Integer;
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ControlIndex', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.ControlIndex' );
  try
  Result := -1;
  for I := 0 to Parent.ControlCount-1 do
    if Parent.Controls[ I ] = Self then
    begin
      Result := I;
      break;
    end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.ControlIndex' );
  end;
end;

constructor TKOLCustomControl.Create(AOwner: TComponent);
var F: TKOLForm;
    K: TComponent;
    ColorOfParent: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Create', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.Create' );
  try

  fWindowed := TRUE;
  FTabOrder := -2;
  fNotifyList := TList.Create;
  {$IFDEF NOT_USE_KOLCTRLWRAPPER}
  FAllowSelfPaint := TRUE;
  {$ENDIF NOT_USE_KOLCTRLWRAPPER}
  inherited;

  {if not(csLoading in ComponentState) then
  if OwnerKOLForm( AOwner ) = nil then
  begin
    raise Exception.Create( 'You forget to place TKOLForm or descendant component onto the form!'#13#10 +
          'Check also if TKOLProject already dropped onto the main form.' +
          #13#10'classname = ' + ClassName );
  end;}

  FIsGenerateSize := TRUE;
  FIsGeneratePosition := TRUE;
  fAutoSzX := 4;
  fAutoSzY := 4;
  FParentFont := TRUE;
  FParentColor := TRUE;
  FParentLikeFontControls := TList.Create;
  FParentLikeColorControls := TList.Create;
  FFont := TKOLFont.Create( Self );
  FBrush := TKOLBrush.Create( Self );
  Width := 64;  DefaultWidth := Width;
  Height := 64; DefaultHeight := Height;

  fMargin := 2;
  K := ParentKOLControl;

  if K <> nil then
  if not( K is TKOLCustomControl ) then
    K := nil;

  F := ParentKOLForm;

  ColorOfParent := clBtnFace;
  if K <> nil then
  begin
    fCtl3D := (K as TKOLCustomControl).Ctl3D;
    ColorOfParent := (K as TKOLCustomControl).Color;
  end
    else
  if F <> nil then
  begin
    fCtl3D := F.Ctl3D;
    ColorOfParent := F.Color;
  end
  else
    fCtl3D := True;

  if DefaultParentColor then
  begin
    //Color := DefaultColor;
    //Color := ColorOfParent;
    FParentColor := FALSE;
    ParentColor := TRUE;
  end
    else
  begin
    Color := ColorOfParent;
    parentColor := FALSE;
    Color := DefaultInitialColor;
  end;

  //FparentColor := Color = ColorOfParent;

  //inherited Color := Color;

  FHasBorder := TRUE;
  FDefHasBorder := TRUE;
  //Change;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.Create' );
  end;
end;

destructor TKOLCustomControl.Destroy;
var F: TKOLForm;
    SaveAlign: TKOLAlign;
    I: Integer;
    C: TComponent;
    Cname: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Destroy', 0
  @@e_signature:
  end;
  Cname := Name;
  Log( '->TKOLCustomControl.Destroy(' + Cname + ')' );
  try

  if Assigned( Owner ) and not (csDestroying in Owner.ComponentState) then
  if Assigned( fNotifyList ) then
    for I := fNotifyList.Count-1 downto 0 do
    begin
      C := fNotifyList[ I ];
      if C is TKOLObj then
        (C as TKOLObj).NotifyLinkedComponent( Self, noRemoved )
      else
      if C is TKOLCustomControl then
        (C as TKOLCustomControl).NotifyLinkedComponent( Self, noRemoved );
    end;
  F := nil;
  if Owner <> nil then
  begin
    F := ParentKOLForm;
    if F <> nil then
    begin
      if F.fDefaultBtnCtl = Self then
        F.fDefaultBtnCtl := nil;
      if F.fCancelBtnCtl = Self then
        F.fCancelBtnCtl := nil;
      SaveAlign := FAlign;
      FAlign := caNone;
      ReAlign( TRUE ); //-- realign only parent
      FAlign := SaveAlign;
    end;
  end;
  FFont.Free;
  FParentLikeFontControls.Free;
  FParentLikeColorControls.Free;
  fNotifyList.Free;
  fNotifyList := nil;
  FBrush.Free;  {YS}//! Memory leak fix
  inherited;
  if (F <> nil) and not F.FIsDestroying and
     (Owner <> nil) and not(csDestroying in Owner.ComponentState) then
    F.Change( F );

  LogOK;
  finally
  Log( '<-TKOLCustomControl.Destroy(' + Cname + ')' );
  end;
end;

procedure TKOLCustomControl.DoAssignEvents(SL: TStringList; const AName: String;
  EventNames: array of PChar; EventHandlers: array of Pointer);
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.DoAssignEvents', 0
  @@e_signature:
  end;
  //Log( '->TKOLCustomControl.DoAssignEvents' );
  try

  for I := 0 to High( EventHandlers ) do
  begin
    if EventHandlers[ I ] <> nil then
    SL.Add( '      ' + AName + '.' + EventNames[ I ] + ' := Result.' +
            ParentForm.MethodName( EventHandlers[ I ] ) + ';' );
  end;

  //LogOK;
  finally
  //Log( '<-TKOLCustomControl.DoAssignEvents' );
  end;
end;

function TKOLCustomControl.DrawMargins: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.DrawMargins', 0
  @@e_signature:
  end;
  Result := ClientMargins;
end;

procedure TKOLCustomControl.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.FirstCreate', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.FirstCreate' );
  try
  if Owner <> nil then
  if Owner is TKOLCustomControl then
  begin
    Transparent := (Owner as TKOLCustomControl).Transparent;
    {ShowMessage( 'First create of ' + Name + ' and owner Transparent = ' +
                 IntToStr( Integer( (Owner as TKOLCustomControl).Transparent ) ) );}
    if (Owner as TKOLCustomControl).Transparent then
    begin
    end;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.FirstCreate' );
  end;
end;

const
  AlignValues: array[ TKOLAlign ] of String = ( 'caNone', 'caLeft', 'caTop',
               'caRight', 'caBottom', 'caClient' );

function TKOLCustomControl.GenerateTransparentInits: String;
var KF: TKOLForm;
    S, S1, S2: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.GenerateTransparentInits', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.GenerateTransparentInits' );
  try

  S := ''; // пока ничего не надо
  if Align = caNone then
  begin
    if IsGenerateSize then
    begin
      if PlaceRight then
        S := '.PlaceRight'
      else
      if PlaceDown then
        S := '.PlaceDown'
      else
      if PlaceUnder then
        S := '.PlaceUnder'
      else
      if not CenterOnParent then
      if (actualLeft <> ParentMargin) or (actualTop <> ParentMargin) then
      begin
        S1 := IntToStr( actualLeft );
        S2 := IntToStr( actualTop );
        S := '.SetPosition( ' + S1 + ', ' + S2 + ' )';
      end;
    end;
  end;
  if Align <> caNone then
    S := S + '.SetAlign ( ' + AlignValues[ Align ] + ' )';
  S := S + Generate_SetSize;
  if CenterOnParent and (Align = caNone) then
    S := S + '.CenterOnParent';
  KF := ParentKOLForm;
  if KF <> nil then
  if KF.zOrderChildren then
    S := S + '.BringToFront';
  if EditTabChar then
    S := S + '.EditTabChar';
  if (HelpContext <> 0) and (Faction = nil) then
    S := S + '.AssignHelpContext( ' + IntToStr( HelpContext ) + ' )' ;
  if Unicode then
    S := S + '.SetUnicode( TRUE )';
  Result := Trim( S );

  LogOK;
  finally
  Log( '<-TKOLCustomControl.GenerateTransparentInits' );
  end;
end;

function TKOLCustomControl.GetActualLeft: Integer;
var P: TControl;
    R: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.GetActualLeft', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.GetActualLeft' );
  try
  Result := Left;
  P := Parent;
  if P is TKOLCustomControl then
  begin
    R := (P as TKOLCustomControl).ClientMargins;
    Dec( Result, R.Left );
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.GetActualLeft' );
  end;
end;

function TKOLCustomControl.GetActualTop: Integer;
var P: TControl;
    R: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'GetActualTop', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.GetActualTop' );
  try
  Result := Top;
  P := Parent;
  if P is TKOLCustomControl then
  begin
    R := (P as TKOLCustomControl).ClientMargins;
    Dec( Result, R.Top );
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.GetActualTop' );
  end;
end;

function TKOLCustomControl.GetParentColor: Boolean;
var KF: TKOLForm;
    KC: TKOLCustomControl;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.GetParentColor', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.GetParentColor' );
  try

  Result := FParentColor;
  if Result then
  begin
    C := ParentKOLControl;
    if C = nil then
    begin
      LogOK;
      Exit;
    end;
    if C is TKOLForm then
    begin
      KF := C as TKOLForm;
      if Color <> KF.Color then
        Color := KF.Color;
    end
      else
    begin
      KC := C as TKOLCustomControl;
      if Color <> KC.Color then
        Color := KC.Color;
    end;
  end;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.GetParentColor' );
  end;
end;

function TKOLCustomControl.GetParentFont: Boolean;
var KF: TKOLForm;
    KC: TKOLCustomControl;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.GetParentFont', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.GetParentFont' );
  try

  Result := FParentFont;
  if Result then
  begin
    C := ParentKOLControl;
    if C = nil then
    begin
      LogOK;
      Exit;
    end;
    if C is TKOLForm then
    begin
      KF := C as TKOLForm;
      if not Font.Equal2( KF.Font ) then
        Font.Assign( KF.Font );
    end
      else
    begin
      KC := C as TKOLCustomControl;
      if not Font.Equal2( KC.Font ) then
        Font.Assign( KC.Font );
    end;
  end;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.GetParentFont' );
  end;
end;

function TKOLCustomControl.GetTabOrder: Integer;
var I, J, N: Integer;
    K, C: TComponent;
    kC: TKOLCustomControl;
    Found: Boolean;
    L: TList;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.GetTabOrder', 0
  @@e_signature:
  end;
  //Log( '->TKOLCustomControl.GetTabOrder' );
  try

  //Old := FTabOrder;
  Result := FTabOrder;
  {if Old <> Result then
    ShowMessage( Name + '.TabOrder := ' + Int2Str( Result ) );}
  if Result = -2 then
  begin
    if (csLoading in ComponentState) or FAdjustingTabOrder then
    begin
      //LogOK;
      Exit;
    end;
    FAdjustingTabOrder := TRUE;
    L := TList.Create;
    try
      K := ParentForm;
      if K <> nil then
      begin
        for I := 0 to K.ComponentCount - 1 do
        begin
          C := K.Components[ I ];
          //if C = Self then continue;
          if not( C is TKOLCustomControl ) then continue;
          kC := C as TKOLCustomControl;
          if kC.Parent <> Parent then continue;
          L.Add( kC );
        end;
        for I := 0 to L.Count - 1 do
        begin
          kC := L[ I ];
          //ShowMessage( 'Check ' + kC.Name + ' with TabOrder = ' + IntToStr( kC.FTabOrder ) );
          if (kC.FTabOrder = Result) or (Result <= -2) then
          begin
            //ShowMessage( '! ' + kC.Name + '.TabOrder also = ' + IntToStr( Result ) );
            for N := 0 to MaxInt do
            begin
              Found := FALSE;
              for J := 0 to L.Count - 1 do
              begin
                kC := L[ J ];
                if kC.FTabOrder = N then
                begin
                  Found := TRUE;
                  break;
                end;
              end;
              if not Found then
              begin
                //ShowMessage( 'TabOrder ' + IntToStr( N ) + ' is not yet used. ( ). Assign to ' + Name );
                FTabOrder := N;
                break;
              end;
            end;
            break;
          end;
        end;
      end;
    finally
      FAdjustingTabOrder := FALSE;
      L.Free;
    end;
  end;
  if FTabOrder < 0 then
    FTabOrder := -1;
  if FTabOrder > 100000 then
    FTabOrder := 100000;
  Result := FTabOrder;

  //LogOK;
  finally
  //Log( '<-TKOLCustomControl.GetTabOrder' );
  end;
end;

function TKOLCustomControl.Get_Color: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Get_Color', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.Get_Color' );
  try
  Result := inherited Color;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.Get_Color' );
  end;
end;

function TKOLCustomControl.Get_Enabled: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Get_Enabled', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.Get_Enabled' );
  try
  Result := inherited Enabled;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.Get_Enabled' );
  end;
end;

function TKOLCustomControl.Get_Visible: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Get_Visible', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.Get_Visible' );
  //Rpt( 'where from Get_Visible called?' );
  //Rpt_Stack;
  try
  Result := inherited Visible;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.Get_Visible' );
  end;
end;

function TKOLCustomControl.IsCursorDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.IsCursorDefault', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.IsCursorDefault' );
  try
  Result := TRUE;
  if Trim( Cursor_ ) <> '' then
  if (ParentKOLControl = ParentKOLForm) and (ParentKOLForm.Cursor <> Cursor_)
  or (ParentKOLControl <> ParentKOLForm) and ((ParentKOLControl as TKOLCustomControl).Cursor_ <> Cursor_) then
    Result := FALSE;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.IsCursorDefault' );
  end;
end;

procedure TKOLCustomControl.Paint;
var R, MR: TRect;
    P: TPoint;
    F: TKOLForm;

    procedure PaintAdditional;
    begin

    end;

begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Paint', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.Paint' );
  try

  F := ParentKOLForm;
  if F = nil then
  begin
    LogOK;
    Exit;
  end;
  if F.FIsDestroying or (Owner = nil) or
     (csDestroying in Owner.ComponentState) then
  begin
    LogOK;
    Exit;
  end;

  R := ClientRect;
  case PaintType of
  {$IFDEF _KOLCtrlWrapper_}
  ptWYSIWIG:
      if WYSIWIGPaintImplemented or Assigned(FKOLCtrl) then {YS}
      begin
        PaintAdditional;
        LogOK;
        Exit;
      end;
{YS}
  {$ELSE}
  ptWYSIWIG,
  {$ENDIF}
  ptWYSIWIGCustom:
      if WYSIWIGPaintImplemented then
      begin
        PaintAdditional;
        LogOK;
        Exit;
      end;
{YS}
  ptWYSIWIGFrames:
      if WYSIWIGPaintImplemented
         {$IFDEF _KOLCtrlWrapper_} or Assigned(FKOLCtrl) {YS} {$ENDIF}
         then 
      begin
        PaintAdditional;
        if not NoDrawFrame then
        begin
          Canvas.Pen.Color := clBtnShadow;
          Canvas.Brush.Style := bsClear;
          Canvas.RoundRect( R.Left, R.Top, R.Right, R.Bottom, 3, 3 );
        end;
        LogOK;
        Exit;
      end;
  end;
  inherited;
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := clBtnFace; // Color;
  Canvas.FillRect( R );
  Canvas.Pen.Color := clWindowText;
  Canvas.Brush.Color := clDkGray;
  Canvas.RoundRect( R.Left, R.Top, R.Right, R.Bottom, 3, 3 );
  InflateRect( R, -1, -1 );
  MR := DrawMargins;
  if MR.Left > 1 then
    Inc( R.Left, MR.Left-1 );
  if MR.Top > 1 then
    Inc( R.Top, MR.Top-1 );
  if MR.Right > 1 then
    Dec( R.Right, MR.Right-1 );
  if MR.Bottom > 1 then
    Dec( R.Bottom, MR.Bottom-1 );
  P := Point( 0, 0 );
  P.x := (Width - Canvas.TextWidth( Name )) div 2;
  if P.x < R.Left then P.x := R.Left;
  P.y := (Height - Canvas.TextHeight( Name )) div 2;
  if P.y < R.Top then P.y := R.Top;
  Canvas.Brush.Color := clBtnFace;
  //Canvas.Brush.Style := bsClear;
  Canvas.TextRect( R, P.x, P.y, Name );

  LogOK;
  finally
  Log( '<-TKOLCustomControl.Paint' );
  end;
end;

function TKOLCustomControl.ParentBounds: TRect;
var C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ParentBounds', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.ParentBounds' );
  try

  Result := Rect( 0, 0, 0, 0 );
  C := ParentKOLControl;
  if C<> nil then
  if C is TKOLCustomControl then
    Result := (C as TKOLCustomControl).BoundsRect
  else
    Result := ParentForm.ClientRect;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.ParentBounds' );
  end;
end;

function TKOLCustomControl.ParentControlUseAlign: Boolean;
var C: TControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ParentControlUseAlign', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.ParentControlUseAlign' );
  try

  Result := False;
  C := Parent;
  if not(C is TForm) and (C is TKOLCustomControl) then
  begin
    Result := (C as TKOLCustomControl).Align <> caNone;
  end;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.ParentControlUseAlign' );
  end;
end;

function TKOLCustomControl.ParentForm: TForm;
var C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ParentForm', 0
  @@e_signature:
  end;
  //Log( '->TKOLCustomControl.ParentForm' );
  try

  C := Owner;
  while (C <> nil) and not(C is TForm) do
    C := C.Owner;
  Result := nil;
  if C <> nil then
  if C is TForm then
    Result := C as TForm;

  //LogOK;
  finally
  //Log( '<-TKOLCustomControl.ParentForm' );
  end;
end;

function TKOLCustomControl.ParentKOLControl: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ParentKOLControl', 0
  @@e_signature:
  end;
  //Log( '->TKOLCustomControl.ParentKOLControl' );
  try

  Result := Parent;
  while (Result <> nil) and
        not (Result is TKOLCustomControl) and
        not (Result is TForm) do
    Result := (Result as TControl).Parent;
  if Result <> nil then
  if (Result is TForm) then
    Result := ParentKOLForm;

  //LogOK;
  finally
  //Log( '<-TKOLCustomControl.ParentKOLControl' );
  end;
end;

function TKOLCustomControl.ParentKOLForm: TKOLForm;
var C, D: TComponent;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ParentKOLForm', 0
  @@e_signature:
  end;
  //Log( '->TKOLCustomControl.ParentKOLForm' );
  try

  C := Parent;
  {if C = nil then
    C := Owner;}
  while (C <> nil) and not(C is TForm) do
    if C is TControl then
      C := (C as TControl).Parent
    else
      C := nil;
  Result := nil;
  if C <> nil then
  if C is TForm then
  begin
    for I := 0 to (C as TForm).ComponentCount - 1 do
    begin
      D := (C as TForm).Components[ I ];
      if D is TKOLForm then
      begin
        Result := D as TKOLForm;
        break;
      end;
    end;
  end;

  //LogOK;
  finally
  //Log( '<-TKOLCustomControl.ParentKOLForm' );
  end;
end;

function TKOLCustomControl.ParentMargin: Integer;
var C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ParentMargin', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.ParentMargin' );
  try

  C := ParentKOLControl;
  Result := 0;
  if C <> nil then
  if C is TKOLForm then
    Result := (C as TKOLForm).Margin
  else
    Result := (C as TKOLCustomControl).Margin;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.ParentMargin' );
  end;
end;

function TKOLCustomControl.PrevBounds: TRect;
var K: TKOLCustomControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.PrevBounds', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.PrevBounds' );
  try

  Result := Rect( 0, 0, 0, 0 );
  K := PrevKOLControl;
  if K <> nil then
    Result := K.BoundsRect;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.PrevBounds' );
  end;
end;

function TKOLCustomControl.PrevKOLControl: TKOLCustomControl;
var F: TForm;
    I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.PrevKOLControl', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.PrevKOLControl' );
  try

  Result := nil;
  if ParentKOLForm <> nil then
  begin
    F := (ParentKOLForm.Owner as TForm);
    for I := 0 to F.ComponentCount - 1 do
    begin
      C := F.Components[ I ];
      if C = Self then break;
      if C is TKOLCustomControl then
      if (C as TKOLCustomControl).Parent = Parent then
        Result := C as TKOLCustomControl;
    end;
  end;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.PrevKOLControl' );
  end;
end;

function TKOLCustomControl.RefName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.RefName', 0
  @@e_signature:
  end;
  Result := 'Result.' + Name;
end;

procedure TKOLCustomControl.SetActualLeft(Value: Integer);
var P: TControl;
    R: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetActualLeft', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetActualLeft' );
  try
  P := Parent;
  if P is TKOLCustomControl then
  begin
    R := (P as TKOLCustomControl).ClientMargins;
    Inc( Value, R.Left );
  end;
  Left := Value;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetActualLeft' );
  end;
end;

procedure TKOLCustomControl.SetActualTop(Value: Integer);
var P: TControl;
    R: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetActualTop', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetActualTop' );
  try
  P := Parent;
  if P is TKOLCustomControl then
  begin
    R := (P as TKOLCustomControl).ClientMargins;
    Inc( Value, R.Top );
  end;
  Top := Value;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetActualTop' );
  end;
end;

procedure TKOLCustomControl.SetAlign(const Value: TKOLAlign);
var
  DoSwap: boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetAlign', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetAlign' );
  try
  if fAlign <> Value then
  begin
    DoSwap:=not (csLoading in ComponentState) and (
            ((Value in [caLeft, caRight]) and (fAlign in [caTop, caBottom])) or
            ((fAlign in [caLeft, caRight]) and (Value in [caTop, caBottom])));
    fAlign := Value;
    if fAlign <> caNone then
    begin
      PlaceRight := False;
      PlaceDown := False;
      PlaceUnder := False;
      CenterOnParent := False;
    end;
    //inherited Align := alNone;
    {case Value of
    caNone:   inherited Align := alNone;
    caLeft:   inherited Align := alLeft;
    caTop:    inherited Align := alTop;
    caRight:  inherited Align := alRight;
    caBottom: inherited Align := alBottom;
    caClient: inherited Align := alClient;
    end;}
    if DoSwap then
      SetBounds(Left, Top, Height, Width)
    else
      ReAlign( FALSE );
    Change;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetAlign' );
  end;
end;

procedure TKOLCustomControl.Set_autoSize(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Set_autoSize', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.Set_autoSize' );
  try
  FautoSize := Value;
  if Value and not (csLoading in ComponentState) then
    AutoSizeNow;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.Set_autoSize' );
  end;
end;

procedure TKOLCustomControl.SetBounds(aLeft, aTop, aWidth, aHeight: Integer);
var R, OldBounds: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetBounds', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetBounds' );
  try
  TRY
    OldBounds := BoundsRect;
    R := Rect( aLeft, aTop, aLeft + aWidth, aTop + aHeight );
    //Log( 'TKOLCustomControl.SetBounds1' );
    if Assigned( FOnSetBounds ) then
    begin
      //Log( 'TKOLCustomControl.SetBounds1A' );
      FOnSetBounds( Self, R );
      //Log( 'TKOLCustomControl.SetBounds1B' );
      aLeft := R.Left;
      aTop := R.Top;
      aWidth := R.Right - R.Left;
      aHeight := R.Bottom - R.Top;
    end;
    //Log( 'TKOLCustomControl.SetBounds2' );
    R := Rect( Left, Top, Left + Width, Top + Height );
    //Log( 'TKOLCustomControl.SetBounds3' );
    inherited SetBounds( aLeft, aTop, aWidth, aHeight );
    //Log( 'TKOLCustomControl.SetBounds4' );
    if AutoSize then AutoSizeNow;
    //Log( 'TKOLCustomControl.SetBounds5' );
    if (Left <> R.Left) or (Top <> R.Top) or
       (Width <> R.Right - R.Left) or (Height <> R.Bottom - R.Top) then
      ReAlign( FALSE );
    R := BoundsRect;
    if (R.Left <> OldBounds.Left) or (R.Right <> OldBounds.Right) or
       (R.Top <> OldBounds.Top) or (R.Bottom <> OldBounds.Bottom) then
    Change;
    //Log( 'TKOLCustomControl.SetBounds6 (after Change)' );
  EXCEPT
    on E: Exception do
    begin
      Rpt( 'Exception in TKOLCustomControl.SetBounds: ' + E.Message );
      Rpt_Stack;
    end;
  END;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetBounds' );
  end;
end;

procedure TKOLCustomControl.SetCaption(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetCaption', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetCaption' );
  try

  if fCaption = Value then
  begin
    LogOK;
    Exit;
  end;
  if Faction = nil then
    fCaption := Value
  else
    fCaption := Faction.Caption;
{YS}
  {$IFDEF _KOLCtrlWrapper_}
  if Assigned(FKOLCtrl) then
    FKOLCtrl.Caption:=fCaption;
  {$ENDIF}
{YS}
  if AutoSize then
    AutoSizeNow;
  Invalidate;
  Change;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetCaption' );
  end;
end;

procedure TKOLCustomControl.SetCenterOnParent(const Value: Boolean);
var R: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetCenterOnParent', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetCenterOnParent' );
  try

  if (fAlign <> caNone) and Value then
  begin
    LogOK;
    Exit;
  end;
  fCenterOnParent := Value;
  if Value then
  begin
    PlaceRight := False;
    PlaceDown := False;
    PlaceUnder := False;
    if not (csLoading in ComponentState) then
    begin
      R := ParentBounds;
      Left := (R.Right - R.Left - Width) div 2;
      Top := (R.Bottom - R.Top - Height) div 2;
    end;
  end;
  Change;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetCenterOnParent' );
  end;
end;

procedure TKOLCustomControl.SetClsStyle(const Value: DWORD);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetClsStyle', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetClsStyle' );
  try
  fClsStyle := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetClsStyle' );
  end;
end;

procedure TKOLCustomControl.SetCtl3D(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetCtl3D', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetCtl3D' );
  try
  FCtl3D := Value;
  if Assigned(FKOLCtrl) and not (csLoading in ComponentState) then
    FKOLCtrl.Ctl3D:=FCtl3D
  else
    Invalidate;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetCtl3D' );
  end;
end;

procedure TKOLCustomControl.SetCursor(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetCursor', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetCursor' );
  try
  FCursor := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetCursor' );
  end;
end;

procedure TKOLCustomControl.SetDoubleBuffered(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetDoubleBuffered', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetDoubleBuffered' );
  try
  FDoubleBuffered := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetDoubleBuffered' );
  end;
end;

procedure TKOLCustomControl.SetEraseBackground(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetEraseBackground', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetEraseBackground' );
  try
  FEraseBackground := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetEraseBackground' );
  end;
end;

procedure TKOLCustomControl.SetExStyle(const Value: DWORD);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetExStyle', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetExStyle' );
  try
  fExStyle := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetExStyle' );
  end;
end;

procedure TKOLCustomControl.SetFont(const Value: TKOLFont);
var KF: TKOLForm;
    KC: TKOLCustomControl;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetFont', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetFont' );
  try
  if not (csLoading in ComponentState) then
  begin
    C := ParentKOLControl;
    if C <> nil then
    if C is TKOLForm then
    begin
      KF := C as TKOLForm;
      if not Value.Equal2( KF.Font ) then
        parentFont := FALSE;
    end
      else
    if C is TKOLCustomControl then
    begin
      KC := C as TKOLCustomControl;
      if not Value.Equal2( KC.Font ) then
        parentFont := FALSE;
    end;
  end;
  if not fFont.Equal2( Value ) then
  begin
    CollectChildrenWithParentFont;
    fFont.Assign( Value );
    ApplyFontToChildren;
    //if csLoading in ComponentState then
    //  FParentFont := DetectParentFont;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetFont' );
  end;
end;

procedure TKOLCustomControl.SetMargin(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetMargin', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetMargin' );
  try
  if fMargin <> Value then
  begin
    fMargin := Value;
    ReAlign( FALSE );
    Change;
    Invalidate;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetMargin' );
  end;
end;

procedure TKOLCustomControl.SetMarginBottom(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetMarginBottom', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetMarginBottom' );
  try
  if FMarginBottom <> Value then
  begin
    FMarginBottom := Value;
    ReAlign( FALSE );
    Change;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetMarginBottom' );
  end;
end;

procedure TKOLCustomControl.SetMarginLeft(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetMarginLeft', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetMarginLeft' );
  try
  if FMarginLeft <> Value then
  begin
    FMarginLeft := Value;
    ReAlign( FALSE );
    Change;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetMarginLeft' );
  end;
end;

procedure TKOLCustomControl.SetMarginRight(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetMarginRight', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetMarginRight' );
  try
  if FMarginRight <> Value then
  begin
    FMarginRight := Value;
    ReAlign( FALSE );
    Change;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetMarginRight' );
  end;
end;

procedure TKOLCustomControl.SetMarginTop(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetMarginTop', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetMarginTop' );
  try
  if FMarginTop <> Value then
  begin
    FMarginTop := Value;
    ReAlign( FALSE );
    Change;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetMarginTop' );
  end;
end;

procedure TKOLCustomControl.SetName(const NewName: TComponentName);
var OldName, NameNew: String;
    I, N: Integer;
    Success: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetName', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetName' );
  try

  OldName := Name;
  inherited SetName( NewName );
  if (Copy( NewName, 1, 3 ) = 'KOL') and (OldName = '') then
  begin
    NameNew := Copy( NewName, 4, Length( NewName ) - 3 );
    Success := True;
    if Owner <> nil then
    while Owner.FindComponent( NameNew ) <> nil do
    begin
      Success := False;
      for I := 1 to Length( NameNew ) do
      begin
        if NameNew[ I ] in [ '0'..'9' ] then
        begin
          Success := True;
          N := StrToInt( Copy( NameNew, I, Length( NameNew ) - I + 1 ) );
          Inc( N );
          NameNew := Copy( NameNew, 1, I - 1 ) + IntToStr( N );
          break;
        end;
      end;
      if not Success then break;
    end;
    if Success then
      Name := NameNew;
    if not (csLoading in ComponentState) then
      FirstCreate;
  end;
  Invalidate;
  Change;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetName' );
  end;
end;

procedure TKOLCustomControl.SetOnBitBtnDraw(const Value: TOnBitBtnDraw);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnBitBtnDraw', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetOnBitBtnDraw' );
  try
  FOnBitBtnDraw := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetOnBitBtnDraw' );
  end;
end;

procedure TKOLCustomControl.SetOnChange(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnChange', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetOnChange' );
  try
  FOnChange := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetOnChange' );
  end;
end;

procedure TKOLCustomControl.SetOnChar(const Value: TOnChar);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnChar', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetOnChar' );
  try
  FOnChar := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetOnChar' );
  end;
end;

procedure TKOLCustomControl.SetOnClick(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnClick', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetOnClick' );
  try
  fOnClick := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetOnClick' );
  end;
end;

procedure TKOLCustomControl.SetOnCloseUp(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnCloseUp', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetOnCloseUp' );
  try
  FOnCloseUp := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetOnCloseUp' );
  end;
end;

procedure TKOLCustomControl.SetOnColumnClick(const Value: TOnLVColumnClick);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnColumnClick', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetOnColumnClick' );
  try
  FOnColumnClick := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetOnColumnClick' );
  end;
end;

procedure TKOLCustomControl.SetOnCompareLVItems(const Value: TOnCompareLVItems);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnCompareLVItems', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetOnCompareLVItems' );
  try
  FOnCompareLVItems := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetOnCompareLVItems' );
  end;
end;

procedure TKOLCustomControl.SetOnDeleteAllLVItems(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnDeleteAllLVItems', 0
  @@e_signature:
  end;
  FOnDeleteAllLVItems := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnDeleteLVItem(const Value: TOnDeleteLVItem);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnDeleteLVItem', 0
  @@e_signature:
  end;
  FOnDeleteLVItem := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnDestroy(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnDestroy', 0
  @@e_signature:
  end;
  FOnDestroy := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnDrawItem(const Value: TOnDrawItem);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnDrawItem', 0
  @@e_signature:
  end;
  FOnDrawItem := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnDropDown(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnDropDown', 0
  @@e_signature:
  end;
  FOnDropDown := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnDropFiles(const Value: TOnDropFiles);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnDropFiles', 0
  @@e_signature:
  end;
  FOnDropFiles := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnEndEditLVItem(const Value: TOnEditLVItem);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnEndEditLVItem', 0
  @@e_signature:
  end;
  FOnEndEditLVItem := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnEnter(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnEnter', 0
  @@e_signature:
  end;
  FOnEnter := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnEraseBkgnd(const Value: TOnPaint);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnEraseBkgnd', 0
  @@e_signature:
  end;
  FOnEraseBkgnd := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnHide(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnHide', 0
  @@e_signature:
  end;
  FOnHide := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnKeyDown(const Value: TOnKey);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnKeyDown', 0
  @@e_signature:
  end;
  FOnKeyDown := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnKeyUp(const Value: TOnKey);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnKeyUp', 0
  @@e_signature:
  end;
  FOnKeyUp := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnLeave(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnLeave', 0
  @@e_signature:
  end;
  FOnLeave := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnLVData(const Value: TOnLVData);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnLVData', 0
  @@e_signature:
  end;
  FOnLVData := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnLVStateChange(const Value: TOnLVStateChange);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnLVStateChange', 0
  @@e_signature:
  end;
  FOnLVStateChange := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnMeasureItem(const Value: TOnMeasureItem);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMeasureItem', 0
  @@e_signature:
  end;
  FOnMeasureItem := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnMessage(const Value: TOnMessage);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMessage', 0
  @@e_signature:
  end;
  FOnMessage := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnMouseDblClk(const Value: TOnMouse);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMouseDblClk', 0
  @@e_signature:
  end;
  fOnMouseDblClk := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnMouseDown(const Value: TOnMouse);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMouseDown', 0
  @@e_signature:
  end;
  FOnMouseDown := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnMouseEnter(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMouseEnter', 0
  @@e_signature:
  end;
  FOnMouseEnter := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnMouseLeave(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMouseLeave', 0
  @@e_signature:
  end;
  FOnMouseLeave := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnMouseMove(const Value: TOnMouse);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMouseMove', 0
  @@e_signature:
  end;
  FOnMouseMove := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnMouseUp(const Value: TOnMouse);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMouseUp', 0
  @@e_signature:
  end;
  FOnMouseUp := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnMouseWheel(const Value: TOnMouse);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMouseWheel', 0
  @@e_signature:
  end;
  FOnMouseWheel := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnMove(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMove', 0
  @@e_signature:
  end;
  FOnMove := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnPaint(const Value: TOnPaint);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnPaint', 0
  @@e_signature:
  end;
  FOnPaint := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnProgress(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnProgress', 0
  @@e_signature:
  end;
  FOnProgress := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnResize(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnResize', 0
  @@e_signature:
  end;
  FOnResize := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnRE_InsOvrMode_Change(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnRE_InsOvrMode_Change', 0
  @@e_signature:
  end;
  FOnRE_InsOvrMode_Change := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnRE_OverURL(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnRE_OverURL', 0
  @@e_signature:
  end;
  FOnRE_OverURL := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnRE_URLClick(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnRE_URLClick', 0
  @@e_signature:
  end;
  FOnRE_URLClick := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnSelChange(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnSelChange', 0
  @@e_signature:
  end;
  FOnSelChange := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnShow(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnShow', 0
  @@e_signature:
  end;
  FOnShow := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnSplit(const Value: TOnSplit);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnSplit', 0
  @@e_signature:
  end;
  FOnSplit := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnTBDropDown(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnTBDropDown', 0
  @@e_signature:
  end;
  FOnTBDropDown := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnTVBeginDrag(const Value: TOnTVBeginDrag);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnTVBeginDrag', 0
  @@e_signature:
  end;
  FOnTVBeginDrag := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnTVBeginEdit(const Value: TOnTVBeginEdit);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnTVBeginEdit', 0
  @@e_signature:
  end;
  FOnTVBeginEdit := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnTVDelete(const Value: TOnTVDelete);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnTVDelete', 0
  @@e_signature:
  end;
  FOnTVDelete := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnTVEndEdit(const Value: TOnTVEndEdit);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnTVEndEdit', 0
  @@e_signature:
  end;
  FOnTVEndEdit := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnTVExpanded(const Value: TOnTVExpanded);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnTVExpanded', 0
  @@e_signature:
  end;
  FOnTVExpanded := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnTVExpanding(const Value: TOnTVExpanding);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnTVExpanding', 0
  @@e_signature:
  end;
  FOnTVExpanding := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnTVSelChanging(const Value: TOnTVSelChanging);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnTVSelChanging', 0
  @@e_signature:
  end;
  FOnTVSelChanging := Value;
  Change;
end;

procedure TKOLCustomControl.SetParent(Value: TWinControl);
var PF: TKOLFont;
    PT: TPaintType;
    CodeAddr: procedure of object;
    F: TKOLForm;
    Cname: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetParent', 0
  @@e_signature:
  end;
  Cname := Name;
  Log( '->TKOLCustomControl.SetParent(' + Cname + ')' );
  try

  //Log( '1 - inherited' );
  inherited;

  F := ParentKOLForm;
  if (F <> nil) and not F.FIsDestroying and (Owner <> nil) and
     not( csDestroying in Owner.ComponentState ) then
  begin
    if Value <> nil then
    if (Value is TKOLCustomControl) or (Value is TForm) then
    begin
      PF := Get_ParentFont;
      Font.Assign(PF); {YS}
    end;
  {YS}
    {$IFDEF _KOLCtrlWrapper_}
    PT := PaintType;
    FAllowSelfPaint := PT in [ptWYSIWIG, ptWYSIWIGFrames];
    FAllowCustomPaint:=PT <> ptWYSIWIG;
    {$ENDIF}
  {YS}
    CodeAddr := Change;
    TRY
      Change;
    EXCEPT on E: Exception do
           Log( 'Exception in TKOLCustomControl.SetParent: ' + E.Message );
    END;
  end;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetParent(' + Cname + ')' );
  end;
end;

procedure TKOLCustomControl.SetparentColor(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetparentColor', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetparentColor' );
  try
  FParentColor := Value;
  if Value then
  begin
    if (ParentKOLControl = ParentKOLForm) and (ParentKOLForm <> nil) then
      Color := ParentKOLForm.Color
    else
    if ParentKOLControl <> nil then
      Color := (ParentKOLControl as TKOLCustomControl).Color;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetparentColor' );
  end;
end;

procedure TKOLCustomControl.SetParentFont(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetParentFont', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetParentFont' );
  try
  FParentFont := Value;
  if Value then
  begin
    if FFont = nil then Exit;
    if (ParentKOLControl = ParentKOLForm) and (ParentKOLForm <> nil) then
      Font.Assign( ParentKOLForm.Font )
    else
    if ParentKOLControl <> nil then
      Font.Assign( (ParentKOLControl as TKOLCustomControl).Font );
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetParentFont' );
  end;
end;

procedure TKOLCustomControl.SetPlaceDown(const Value: Boolean);
var R: TRect;
    M: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetPlaceDown', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetPlaceDown' );
  try
  if (fAlign <> caNone) and Value then
  begin
    LogOK;
    Exit;
  end;
  fPlaceDown := Value;
  if Value then
  begin
    fPlaceRight := False;
    fPlaceUnder := False;
    fCenterOnParent := False;
    if not (csLoading in ComponentState) then
    begin
      R := PrevBounds;
      M := ParentMargin;
      Left := M;
      Top := R.Bottom + M;
    end;
  end;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetPlaceDown' );
  end;
end;

procedure TKOLCustomControl.SetPlaceRight(const Value: Boolean);
var R: TRect;
    M: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetPlaceRight', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetPlaceRight' );
  try
  if (fAlign <> caNone) and Value then
  begin
    LogOK;
    Exit;
  end;
  fPlaceRight := Value;
  if Value then
  begin
    fPlaceDown := False;
    fPlaceUnder := False;
    fCenterOnParent := False;
    if not (csLoading in ComponentState) then
    begin
      R := PrevBounds;
      M := ParentMargin;
      Left := R.Right + M;
      Top := R.Top;
    end;
  end;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetPlaceRight' );
  end;
end;

procedure TKOLCustomControl.SetPlaceUnder(const Value: Boolean);
var R: TRect;
    M: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetPlaceUnder', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetPlaceUnder' );
  try
  if (fAlign <> caNone) and Value then
  begin
    LogOK;
    Exit;
  end;
  fPlaceUnder := Value;
  if Value then
  begin
    fPlaceDown := False;
    fPlaceRight := False;
    fCenterOnParent := False;
    if not (csLoading in ComponentState) then
    begin
      R := PrevBounds;
      M := ParentMargin;
      Left := R.Left;
      Top := R.Bottom + M;
    end;
  end;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetPlaceUnder' );
  end;
end;

procedure TKOLCustomControl.SetShadowDeep(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetShadowDeep', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetShadowDeep' );
  try
  FShadowDeep := Value;
  Invalidate;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetShadowDeep' );
  end;
end;

procedure TKOLCustomControl.SetStyle(const Value: DWORD);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetStyle', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetStyle' );
  try
  fStyle := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetStyle' );
  end;
end;

procedure TKOLCustomControl.SetTabOrder(const Value: Integer);
var K, C: TComponent;
    I, Old, N, MinIdx: Integer;
    L: TList;
    kC, kMin: TKOLCustomControl;
    Found: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetTabOrder', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetTabOrder' );
  try
  Old := FTabOrder;
  FTabOrder := Value;
  if FTabOrder < -2 then
    FTabOrder := -1;
  if FTabOrder > 100000 then
    FTabOrder := 100000;
  if FTabOrder >= 0 then
  if not(csLoading in ComponentState) and not FAdjustingTabOrder then
  begin
    FAdjustingTabOrder := TRUE;
    TRY

      L := TList.Create;
      K := ParentForm;
      if K <> nil then
      try
        for I := 0 to K.ComponentCount - 1 do
        begin
          C := K.Components[ I ];
          //if C = Self then continue;
          if not( C is TKOLCustomControl ) then continue;
          kC := C as TKOLCustomControl;
          if kC.Parent <> Parent then continue;
          L.Add( kC );
        end;
        // 1. Move TabOrder for all controls with TabOrder >= Value up.
        // 1. Переместить TabOrder для всех, кто имеет такой же и выше, на 1 вверх.
        for I := 0 to L.Count - 1 do
        begin
          kC := L.Items[ I ];
          if kC = Self then continue;
          if kC.FTabOrder >= Value then
            Inc( kC.FTabOrder );
        end;
        // 2. "Squeeze" to prevent holes. (To prevent situation, when N, N+k,
        //    values are present and N+1 is not used).
        for N := 0 to L.Count - 1 do
        begin
          Found := FALSE;
          for I := 0 to L.Count - 1 do
          begin
            kC := L.Items[ I ];
            if kC.FTabOrder = N then
            begin
              Found := TRUE;
              break;
            end;
          end;
          if not Found then
          begin
            // Value N is not used as a TabOrder. Try to find next used TabOrder
            // value and move it to N.
            MinIdx := -1;
            for I := 0 to L.Count - 1 do
            begin
              kC := L.Items[ I ];
              if kC.FTabOrder > MaxInt div 4 - 1 then continue;
              if kC.FTabOrder < -MaxInt div 4 + 1 then continue;
              if (kC.FTabOrder > N) then
              begin
                if (MinIdx >= 0) then
                begin
                  kMin := L.Items[ MinIdx ];
                  if kC.FTabOrder < kMin.FTabOrder then
                    MinIdx := I;
                end
                  else
                  MinIdx := I;
              end;
            end;
            if MinIdx < 0 then break;
            // Such TabOrder value found at control with MinIdx index in a list.
            kMin := L.Items[ MinIdx ];
            MinIdx := kMin.FTabOrder;
            for I := 0 to L.Count - 1 do
            begin
              kC := L.Items[ I ];
              if kC.FTabOrder > N then
              begin
                kC.FTabOrder := kC.FTabOrder - (MinIdx - N);
                //ShowMessage( kC.Name + '.TabOrder := ' + Int2Str( kC.TabOrder ) );
              end;
            end;
          end;
        end;

      finally
        L.Free;
      end;
    FINALLY
      FAdjustingTabOrder := FALSE;
    END;
  end;
  if Old <> FTabOrder then
    ReAlign( TRUE );
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetTabOrder' );
  end;
end;

procedure TKOLCustomControl.SetTabStop(const Value: Boolean);
{var K: TComponent;
    I, N: Integer;}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetTabStop', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetTabStop' );
  try
  FTabStop := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetTabStop' );
  end;
end;

procedure TKOLCustomControl.SetTag(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetTag', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetTag' );
  TRY
  FTag := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetTabStop' );
  end;
end;

procedure TKOLCustomControl.SetTextAlign(const Value: TTextAlign);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetTextAlign', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetTextAlign' );
  try
  FTextAlign := Value;
{YS}
  {$IFDEF _KOLCtrlWrapper_}
  if Assigned(FKOLCtrl) then
    FKOLCtrl.TextAlign:=kol.TTextAlign(Value);
  {$ENDIF}
{YS}
  Invalidate;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetTextAlign' );
  end;
end;

function Color2Str( Color: TColor ): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'Color2Str', 0
  @@e_signature:
  end;
  case Color of
  clScrollBar:             Result := 'clScrollBar';
  clBackground:            Result := 'clBackground';
  clActiveCaption:         Result := 'clActiveCaption';
  clInactiveCaption:       Result := 'clInactiveCaption';
  clMenu:                  Result := 'clMenu';
  clWindow:                Result := 'clWindow';
  clWindowFrame:           Result := 'clWindowFrame';
  clMenuText:              Result := 'clMenuText';
  clWindowText:            Result := 'clWindowText';
  clCaptionText:           Result := 'clCaptionText';
  clActiveBorder:          Result := 'clActiveBorder';
  clInactiveBorder:        Result := 'clInactiveBorder';
  clAppWorkSpace:          Result := 'clAppWorkSpace';
  clHighlight:             Result := 'clHighlight';
  clHighlightText:         Result := 'clHighlightText';
  clBtnFace:               Result := 'clBtnFace';
  clBtnShadow:             Result := 'clBtnShadow';
  clGrayText:              Result := 'clGrayText';
  clBtnText:               Result := 'clBtnText';
  clInactiveCaptionText:   Result := 'clInactiveCaptionText';
  clBtnHighlight:          Result := 'clBtnHighlight';
  cl3DDkShadow:            Result := 'cl3DDkShadow';
  cl3DLight:               Result := 'cl3DLight';
  clInfoText:              Result := 'clInfoText';
  clInfoBk:                Result := 'clInfoBk';

  clBlack:                 Result := 'clBlack';
  clMaroon:                Result := 'clMaroon';
  clGreen:                 Result := 'clGreen';
  clOlive:                 Result := 'clOlive';
  clNavy:                  Result := 'clNavy';
  clPurple:                Result := 'clPurple';
  clTeal:                  Result := 'clTeal';
  clGray:                  Result := 'clGray';
  clSilver:                Result := 'clSilver';
  clRed:                   Result := 'clRed';
  clLime:                  Result := 'clLime';
  clYellow:                Result := 'clYellow';
  clBlue:                  Result := 'clBlue';
  clFuchsia:               Result := 'clFuchsia';
  clAqua:                  Result := 'clAqua';
  //clLtGray:                Result := 'clLtGray';
  //clDkGray:                Result := 'clDkGray';
  clWhite:                 Result := 'clWhite';
  clNone:                  Result := 'clNone';
  clDefault:               Result := 'clDefault';

  else
    Result := '$' + Int2Hex( Color, 6 );
  end;
end;

procedure TKOLCustomControl.SetTransparent(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetTransparent', 0
  @@e_signature:
  end;
  FTransparent := Value;
  Invalidate;
  Change;
end;

procedure TKOLCustomControl.SetupColor(SL: TStrings; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetupColor', 0
  @@e_signature:
  end;
  if (Brush.Bitmap = nil) or Brush.Bitmap.Empty then
  begin
    if Brush.BrushStyle <> bsSolid then
      Brush.GenerateCode( SL, AName )
    else
    begin
      if DefaultKOLParentColor and not parentColor or
         not DefaultKOLParentColor and (Color <> DefaultColor) then
        SL.Add( '    ' + AName + '.Color := ' + Color2Str( Color ) + ';' );
    end;
  end
    else
    Brush.GenerateCode( SL, AName );
end;

procedure TKOLCustomControl.SetupConstruct(SL: TStringList; const AName, AParent,
  Prefix: String);
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetupConstruct', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetupConstruct' );
  try
  S := GenerateTransparentInits;
  SL.Add( Prefix + AName + ' := New' + TypeName + '( '
          + SetupParams( AName, AParent ) + ' )' + S + ';' );
  if Name <> '' then
  begin
    SL.Add( '   {$IFDEF USE_NAMES}' );
    SL.Add( Prefix + AName + '.Name := ''' + Name + ''';' );
    SL.Add( '   {$ENDIF}' );
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetupConstruct' );
  end;
end;

procedure TKOLCustomControl.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
const BoolVals: array[ Boolean ] of String = ( 'FALSE', 'TRUE' );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetupFirst', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetupFirst' );
  try

  SetupConstruct( SL, AName, AParent, Prefix );
  if Tag <> 0 then
  begin
    if Tag < 0 then
      SL.Add( Prefix + AName + '.Tag := DWORD(' + IntToStr(Tag) + ');' )
    else
      SL.Add( Prefix + AName + '.Tag := ' + IntToStr(Tag) + ';' );
  end;
  if not Ctl3D then
    SL.Add( Prefix + AName + '.Ctl3D := False;' );
  if FHasBorder <> FDefHasBorder then
  begin
    SL.Add( Prefix + AName + '.HasBorder := ' + BoolVals[ FHasBorder ] + ';' );
    //ShowMessage( AName + '.HasBorder := ' + BoolVals[ FHasBorder ] );
  end;
  SetupTabOrder( SL, AName );
  SetupFont( SL, AName );
  SetupTextAlign( SL, AName );
  //SetupColor( SL, AName );
  if (csAcceptsControls in ControlStyle) or BorderNeeded then
  if (ParentKOLControl = ParentKOLForm) and (ParentKOLForm.Border <> Border)
  or (ParentKOLControl <> ParentKOLForm) and ((ParentKOLControl as TKOLCustomControl).Border <> Border) then
    SL.Add( Prefix + AName + '.Border := ' + IntToStr( Border ) + ';' );
  if MarginTop <> DefaultMarginTop then
    SL.Add( Prefix + AName + '.MarginTop := ' + IntToStr( MarginTop ) + ';' );
  if MarginBottom <> DefaultMarginBottom then
    SL.Add( Prefix + AName + '.MarginBottom := ' + IntToStr( MarginBottom ) + ';' );
  if MarginLeft <> DefaultMarginLeft then
    SL.Add( Prefix + AName + '.MarginLeft := ' + IntToStr( MarginLeft ) + ';' );
  if MarginRight <> DefaultMarginRight then
    SL.Add( Prefix + AName + '.MarginRight := ' + IntToStr( MarginRight ) + ';' );
  if not IsCursorDefault then
    if Copy( Cursor_, 1, 4 ) = 'IDC_' then
      SL.Add( Prefix + AName + '.Cursor := LoadCursor( 0, ' + Cursor_ + ' );' )
    else
      SL.Add( Prefix + AName + '.Cursor := LoadCursor( hInstance, ''' + Trim( Cursor_ ) + ''' );' );
  if not Visible and (Faction = nil) then
    SL.Add( Prefix + AName + '.Visible := False;' );
  if not Enabled and (Faction = nil) then
    SL.Add( Prefix + AName + '.Enabled := False;' );
  if DoubleBuffered and not Transparent then
    SL.Add( Prefix + AName + '.DoubleBuffered := True;' );
  if Owner <> nil then
  if Transparent and ((Owner is TKOLCustomControl) and not (Owner as TKOLCustomControl).Transparent or
     not(Owner is TKOLCustomControl) and not ParentKOLForm.Transparent) then
    SL.Add( Prefix + AName + '.Transparent := True;' );
  if Owner = nil then
  if Transparent then
    SL.Add( Prefix + AName + '.Transparent := TRUE;' );
  //AssignEvents( SL, AName );
  if EraseBackground then
    SL.Add( Prefix + AName + '.EraseBackground := TRUE;' );
  if MinWidth > 0 then
    SL.Add( Prefix + AName + '.MinWidth := ' + IntToStr( MinWidth ) + ';' );
  if MinHeight > 0 then
    SL.Add( Prefix + AName + '.MinHeight := ' + IntToStr( MinHeight ) + ';' );
  if MaxWidth > 0 then
    SL.Add( Prefix + AName + '.MaxWidth := ' + IntToStr( MaxWidth ) + ';' );
  if MaxHeight > 0 then
    SL.Add( Prefix + AName + '.MaxHeight := ' + IntToStr( MaxHeight ) + ';' );
  if IgnoreDefault <> FDefIgnoreDefault then
    SL.Add( Prefix + AName + '.IgnoreDefault := ' + BoolVals[ IgnoreDefault ] + ';' );
  //Rpt( '-------- FHint = ' + FHint );
  if (Trim( FHint ) <> '') and (Faction = nil) then
  begin
    if (ParentKOLForm <> nil) and ParentKOLForm.ShowHint then
      SL.Add( Prefix + AName + '.Hint.Text := ' + StringConstant( 'Hint', Hint ) + ';' );
    {else
      ShowMessage( 'ParentKOLForm=' + Int2Hex( Integer( Pointer( ParentKOLForm ) ), 8 ) );}
  end;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetupFirst' );
  end;
end;

procedure TKOLCustomControl.SetupFont(SL: TStrings; const AName: String);
var PFont: TKOLFont;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetupFont', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetupFont' );
  try
  PFont := Get_ParentFont;
  if (PFont <> nil) and (not Assigned(Font) or not Font.Equal2( PFont )) then
    Font.GenerateCode( SL, AName, PFont );
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetupFont' );
  end;
end;

procedure TKOLCustomControl.SetupLast(SL: TStringList; const AName,
  AParent, Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetupLast', 0
  @@e_signature:
  end;
  //Log( '->TKOLCustomControl.SetupLast' );
  try
  SetupColor( SL, AName );
  AssignEvents( SL, AName );
  if fDefaultBtn then
    SL.Add( Prefix + AName + '.DefaultBtn := TRUE;' )
  else
  if fCancelBtn then
    SL.Add( Prefix + AName + '.CancelBtn := TRUE;' );
  //LogOK;
  finally
  //Log( '<-TKOLCustomControl.SetupLast' );
  end;
end;

function TKOLCustomControl.SetupParams(const AName, AParent: String): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetupParams', 0
  @@e_signature:
  end;
  Result := AParent;
end;

procedure TKOLCustomControl.SetupTabOrder(SL: TStringList; const AName: String);
{var K, C: TComponent;
    I, N: Integer;
    kC: TKOLCustomControl;}
    {
      Instead of assigning a value to TabOrder property, special creation order
      is provided correspondent to an order of tabulating the controls - while
      generating constructors for these.

      Вместо присваивания значения свойству TabOrder, обеспечивается особый
      порядок генерации конструкторов для визуальных объектов, при котором
      TabOrder получается такой, какой нужно.
    }
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetupTabOrder', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetupTabOrder' );
  try
  if not TabStop and TabStopByDefault then
  begin
    if FResetTabStopByStyle then
      SL.Add( '    ' + AName + '.Style := ' + AName + '.Style and not WS_TABSTOP;' )
    else
      SL.Add( '    ' + AName + '.TabStop := FALSE;' );
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetupTabOrder' );
  end;
end;

procedure TKOLCustomControl.SetupTextAlign(SL: TStrings; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetupTextAlign', 0
  @@e_signature:
  end;
  // nothing here
end;

procedure TKOLCustomControl.SetVerticalAlign(const Value: TVerticalAlign);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetVerticalAlign', 0
  @@e_signature:
  end;
  FVerticalAlign := Value;
  Invalidate;
  Change;
end;

procedure TKOLCustomControl.Set_Color(const Value: TColor);
var KF: TKOLForm;
    KC: TKOLCustomControl;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Set_Color', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.Set_Color' );
  try

  if not CanChangeColor and (Value <> DefaultColor) then
  begin
    //ShowMessage( 'This control can not change Color value.' );
    LogOK;
    Exit;
  end;
  if not (csLoading in ComponentState) then
  begin
    C := ParentKOLControl;
    if C <> nil then
    if C is TKOLForm then
    begin
      KF := C as TKOLForm;
      if Value <> KF.Color then
        parentColor := FALSE;
    end
      else
    if C is TKOLCustomControl then
    begin
      KC := C as TKOLCustomControl;
      if Value <> KC.Color then
        parentColor := FALSE;
    end;
  end;
  CollectChildrenWithParentColor;
  Brush.Color := Value;
  inherited Color := Value;
{YS}
  {$IFDEF _KOLCtrlWrapper_}
  if Assigned(FKOLCtrl) then
    FKOLCtrl.Color := Value;
  {$ENDIF}
{YS}
  Invalidate;
  ApplyColorToChildren;
  Change;
  //if csLoading in ComponentState then
  //  FParentColor := DetectParentColor;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.Set_Color' );
  end;
end;

procedure TKOLCustomControl.Set_Enabled(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Set_Enabled', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.Set_Enabled' );
  try
  if inherited Enabled <> Value then
  begin
    if Faction = nil then
      inherited Enabled := Value
    else
      inherited Enabled := Faction.Enabled;
    Change;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.Set_Enabled' );
  end;
end;

procedure TKOLCustomControl.Set_Visible(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Set_Visible', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.Set_Visible' );
  try
  if inherited Visible <> Value then
  begin
    if Faction = nil then
      inherited Visible := Value
    else
      inherited Visible := Faction.Visible;
  end;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.Set_Visible' );
  end;
end;

function TKOLCustomControl.TypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.TypeName', 0
  @@e_signature:
  end;
  //Log( '->TKOLCustomControl.TypeName' );
  try
  Result := ClassName;
  if UpperCase( Copy( Result, 1, 4 ) ) = 'TKOL' then
    Result := Copy( Result, 5, Length( Result ) - 4 );
  if not fWindowed then
    Result := 'Graph' + Result;
  //LogOK;
  finally
  //Log( '<-TKOLCustomControl.TypeName' );
  end;
end;

function TKOLCustomControl.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := FALSE;
end;

function TKOLCustomControl.FontPropName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.FontPropName', 0
  @@e_signature:
  end;
  Result := 'Font';
end;

procedure TKOLCustomControl.AfterFontChange( SL: TStrings; const AName, Prefix: String );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.AfterFontChange', 0
  @@e_signature:
  end;
  //
end;

procedure TKOLCustomControl.BeforeFontChange( SL: TStrings; const AName, Prefix: String );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.BeforeFontChange', 0
  @@e_signature:
  end;
  //
end;

procedure TKOLCustomControl.SetHasBorder(const Value: Boolean);
var CodeAddr: procedure of object;
    CodeAddr1: procedure( const V: Boolean ) of object;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetHasBorder', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetHasBorder' );
  try
  FHasBorder := Value;
{YS}
  {$IFDEF _KOLCtrlWrapper_}
  if Assigned(FKOLCtrl) then
    FKOLCtrl.HasBorder:=Value;
  {$ENDIF}
{YS}
  //Log( 'SetHasBorder - Change, Self=$' + Int2Hex( DWORD( Self ), 6 ) );
  CodeAddr := Change;
  //Log( 'SetHasBorder - Change Addr: $' + Int2Hex( DWORD( TMethod( CodeAddr ).Code ), 6 ) );
  CodeAddr1 := SetHasBorder;
  //Log( 'SetHasBorder = own Addr: $' + Int2Hex( DWORD( TMethod( CodeAddr1 ).code ), 6 ) );
  Change;
  Invalidate;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetHasBorder' );
  end;
end;

procedure TKOLCustomControl.SetOnScroll(const Value: TOnScroll);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnScroll', 0
  @@e_signature:
  end;
  FOnScroll := Value;
  Change;
end;

procedure TKOLCustomControl.SetEditTabChar(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetEditTabChar', 0
  @@e_signature:
  end;
  FEditTabChar := Value;
  WantTabs( Value );
  Change;
end;

procedure TKOLCustomControl.WantTabs( Want: Boolean );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.WantTabs', 0
  @@e_signature:
  end;
end;

function TKOLCustomControl.CanNotChangeFontColor: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.CanNotChangeFontColor', 0
  @@e_signature:
  end;
  Result := FALSE;
end;

function TKOLCustomControl.DefaultColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.DefaultColor', 0
  @@e_signature:
  end;
  Result := clBtnFace;
end;

function TKOLCustomControl.DefaultParentColor: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.DefaultParentColor', 0
  @@e_signature:
  end;
  Result := DefaultColor = clBtnFace;
end;

function TKOLCustomControl.DefaultInitialColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.DefaultInitialColor', 0
  @@e_signature:
  end;
  Result := DefaultColor;
end;

function TKOLCustomControl.DefaultKOLParentColor: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.DefaultKOLParentColor', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLCustomControl.CanChangeColor: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.CanChangeColor', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLCustomControl.PaintType: TPaintType;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.PaintType', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.PaintType' );
  try
  Result := ptWYSIWIG;
  if ParentKOLForm <> nil then
    Result := ParentKOLForm.PaintType;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.PaintType' );
  end;
end;

function TKOLCustomControl.WYSIWIGPaintImplemented: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.WYSIWIGPaintImplemented', 0
  @@e_signature:
  end;
  Result := FALSE;
end;

function TKOLCustomControl.CompareFirst(c, n: string): boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.CompareFirst', 0
  @@e_signature:
  end;
  Result := FALSE;
end;

procedure TKOLCustomControl.PrepareCanvasFontForWYSIWIGPaint( ACanvas: TCanvas );
//var RFont: TKOLFont;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.PrepareCanvasFontForWYSIWIGPaint', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.PrepareCanvasFontForWYSIWIGPaint' );
  try

  TRY

    Rpt( 'Call RunTimeFont' ); //Rpt_Stack;
    //RFont := RunTimeFont;

    if not Font.Equal2(nil) then
    //if (RFont = Font) or not Font.Equal2( RFont ) then
    begin
      Rpt( 'Font different ! Color=' + Int2Hex( Color2RGB( Font.Color ), 8 ) );
      ACanvas.Font.Name:= Font.FontName;
      ACanvas.Font.Height:= Font.FontHeight;
      //ACanvas.Font.Color:= Font.Color;
      ACanvas.Font.Style:= TFontStyles( Font.FontStyle );
      {$IFNDEF _D2}
      ACanvas.Font.Charset:= Font.FontCharset;
      {$ENDIF}
      ACanvas.Font.Pitch:= Font.FontPitch;
    end
    else
      ACanvas.Font.Handle:=GetDefaultControlFont;

    ACanvas.Font.Color:= Font.Color;    // !!!!!!
    ACanvas.Brush.Color := Color;

  EXCEPT
    on E: Exception do
    begin
      ShowMessage( 'Can not prepare WYSIWIG font, exception: ' + E.Message );
    end;

  END;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.PrepareCanvasFontForWYSIWIGPaint' );
  end;
end;

function TKOLCustomControl.NoDrawFrame: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.NoDrawFrame', 0
  @@e_signature:
  end;
  Result := FALSE;
end;

procedure TKOLCustomControl.ReAlign( ParentOnly: Boolean );
var ParentK: TComponent;
    ParentF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ReAlign', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.ReAlign' );
  try

  if not (csLoading in ComponentState) then
  begin
    ParentF := ParentKOLForm;
    ParentK := ParentKOLControl;
    if (ParentK <> nil) and (ParentF <> nil) then
    begin
      if ParentK is TKOLForm then
        (ParentK as TKOLForm).AlignChildren( nil, FALSE )
      else
      if ParentK is TKOLCustomControl then
        if ParentF <> nil then
          ParentF.AlignChildren( ParentK as TKOLCustomControl, FALSE );
      if not ParentOnly then
        ParentF.AlignChildren( Self, FALSE );
    end
      else
      //Rpt( 'TKOLCustomControl.ReAlign -- did nothing' )
      ;
  end;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.ReAlign' );
  end;
end;

procedure TKOLCustomControl.NotifyLinkedComponent(Sender: TObject;
  Operation: TNotifyOperation);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.NotifyLinkedComponent', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.NotifyLinkedComponent' );
  try
  if Operation = noRemoved then
  if Assigned( fNotifyList ) then
    fNotifyList.Remove( Sender );
  Invalidate;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.NotifyLinkedComponent' );
  end;
end;

procedure TKOLCustomControl.AddToNotifyList(Sender: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.AddToNotifyList', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.AddToNotifyList' );
  try
  if Assigned( fNotifyList ) then
  if fNotifyList.IndexOf( Sender ) < 0 then
    fNotifyList.Add( Sender );
  LogOK;
  finally
  Log( '<-TKOLCustomControl.AddToNotifyList' );
  end;
end;

procedure TKOLCustomControl.SetMaxHeight(const Value: Integer);
begin
  FMaxHeight := Value;
  Change;
end;

procedure TKOLCustomControl.SetMaxWidth(const Value: Integer);
begin
  FMaxWidth := Value;
  Change;
end;

procedure TKOLCustomControl.SetMinHeight(const Value: Integer);
begin
  FMinHeight := Value;
  Change;
end;

procedure TKOLCustomControl.SetMinWidth(const Value: Integer);
begin
  FMinWidth := Value;
  Change;
end;

procedure TKOLCustomControl.Loaded;
begin
  Log( '->TKOLCustomControl.Loaded' );
  try
  inherited;
  CollectChildrenWithParentFont;
  Font.Change;
  if AutoSize then
    AutoSizeNow;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.Loaded' );
  end;
end;

procedure TKOLCustomControl.DoGenerateConstants(SL: TStringList);
begin
  //
end;

function TKOLCustomControl.AutoSizeRunTime: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLCustomControl.SetLocalizy(const Value: TLocalizyOptions);
begin
  FLocalizy := Value;
  Change;
end;

function TKOLCustomControl.StringConstant(const Propname,
  Value: String): String;
begin
  Log( '->TKOLCustomControl.StringConstant' );
  try
  if (Value <> '') AND
     ((Localizy = loForm) and (ParentKOLForm <> nil) and
     (ParentKOLForm.Localizy) or (Localizy = loYes)) then
  begin
    Result := ParentKOLForm.Name + '_' + Name + '_' + Propname;
    ParentKOLForm.MakeResourceString( Result, Value );
  end
    else
  begin
    Result := String2Pascal( Value );
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.StringConstant' );
  end;
end;

function PCharStringConstant(Sender: TObject; const Propname,
  Value: String): String;
begin
  if Sender is TKOLCustomControl then
    Result := (Sender as TKOLCustomControl).StringConstant( Propname, Value )
  else
  if Sender is TKOLObj then
    Result := (Sender as TKOLObj).StringConstant( Propname, Value )
  else
  if Sender is TKOLForm then
    Result := (Sender as TKOLForm).StringConstant( PropName, Value )
  else
  begin
    Result := 'error';
    Exit;
  end;
  if Result <> '' then
    if Result[ 1 ] <> '''' then
      Result := 'PChar( ' + Result + ' )';
end;

procedure TKOLCustomControl.SetHelpContext(const Value: Integer);
begin
  if FHelpContext1 = Value then Exit;
  if Faction = nil then
    FHelpContext1 := Value
  else
    FHelpContext1 := Faction.HelpContext;
  Change;
end;

procedure TKOLCustomControl.SetCancelBtn(const Value: Boolean);
var F: TKOLForm;
begin
  Log( '->TKOLCustomControl.SetCancelBtn' );
  try
  if FCancelBtn <> Value then
  begin
    FCancelBtn := Value;
    if Value then
    begin
      DefaultBtn := FALSE;
      F := ParentKOLForm;
      if F <> nil then
      begin
        if (F.fCancelBtnCtl <> nil) and (F.fCancelBtnCtl <> Self) then
          F.fCancelBtnCtl.CancelBtn := FALSE;
        F.fCancelBtnCtl := Self;
      end;
    end;
    Change;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetCancelBtn' );
  end;
end;

procedure TKOLCustomControl.SetDefaultBtn(const Value: Boolean);
var F: TKOLForm;
begin
  Log( '->TKOLCustomControl.SetDefaultBtn' );
  try
  if FDefaultBtn <> Value then
  begin
    FDefaultBtn := Value;
    if Value then
    begin
      CancelBtn := FALSE;
      F := ParentKOLForm;
      if F <> nil then
      begin
        if (F.fDefaultBtnCtl <> nil) and (F.FDefaultBtnCtl <> Self) then
          F.fDefaultBtnCtl.DefaultBtn := FALSE;
        F.fDefaultBtnCtl := Self;
      end;
    end;
    if Assigned(FKOLCtrl) then
      with FKOLCtrl^ do
        if FDefaultBtn then
          Style := Style or BS_DEFPUSHBUTTON
        else
          Style := Style and not BS_DEFPUSHBUTTON;
    Change;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetDefaultBtn' );
  end;
end;

function TKOLCustomControl.Generate_SetSize: String;
const BoolVals: array[ Boolean ] of String = ( 'FALSE', 'TRUE' );
var W, H: Integer;
begin
  Log( '->TKOLCustomControl.Generate_SetSize' );
  try

  W := 0;
  H := 0;
  if Align <> caClient then
  if (Width <> DefaultWidth) or (Height <> DefaultHeight) or not fWindowed then
  begin
    if ((Width <> DefaultWidth) or not fWindowed) and not (Align in [ caTop, caBottom ]) then
      W := Width;
    if ((Height <> DefaultHeight) or not fWindowed) and not (Align in [ caLeft, caRight ]) then
      H := Height;
  end;

  if IsGenerateSize or not Windowed then
  if not (autoSize and AutoSizeRunTime) or WordWrap or fNoAutoSizeX then
  begin
    if autoSize and AutoSizeRunTime then
      H := 0;
    if (W <> 0) or (H <> 0) then
      Result := Result + '.SetSize( ' + IntToStr( W ) + ', ' + IntToStr( H ) + ' )';
  end;
  if WordWrap then
    Result := Result + '.MakeWordWrap';
  if (AutoSize and AutoSizeRunTime) xor DefaultAutoSize then
    Result := Result + '.AutoSize( ' + BoolVals[ AutoSize ] + ' )';


  LogOK;
  finally
  Log( '<-TKOLCustomControl.Generate_SetSize' );
  end;
end;

procedure TKOLCustomControl.SetIgnoreDefault(const Value: Boolean);
begin
  FIgnoreDefault := Value;
  Change;
end;

procedure TKOLCustomControl.SetBrush(const Value: TKOLBrush);
begin
  FBrush.Assign( Value );
  Change;
end;

function TKOLCustomControl.BorderNeeded: Boolean;
begin
  Result := FALSE;
end;

procedure TKOLCustomControl.SetIsGenerateSize(const Value: Boolean);
begin
  FIsGenerateSize := Value;
  Invalidate;
end;

procedure TKOLCustomControl.SetIsGeneratePosition(const Value: Boolean);
begin
  FIsGeneratePosition := Value;
  Change;
end;

function TKOLCustomControl.BestEventName: String;
begin
  Result := 'OnClick';
end;

procedure TKOLCustomControl.KOLControlRecreated;
begin
{$IFNDEF NOT_USE_KOLCTRLWRAPPER}
  Log( '->TKOLCustomControl.KOLControlRecreated' );
  try
  if Assigned(FKOLCtrl) then begin
    FKOLCtrl.Color:=Color;
    FKOLCtrl.Caption:=Caption;
    Font.Change;
    Brush.Change;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.KOLControlRecreated' );
  end;
{$ENDIF NOT_USE_KOLCTRLWRAPPER}
end;

function TKOLCustomControl.GetDefaultControlFont: HFONT;
begin
  Result:=GetStockObject(SYSTEM_FONT);
end;

procedure TKOLCustomControl.SetHint(const Value: String);
begin
  if FHint = Value then exit;
  if Faction = nil then
    FHint := Value
  else
    FHint := Faction.Hint;
  Change;
end;

function TKOLCustomControl.OwnerKOLForm(AOwner: TComponent): TKOLForm;
var C, D: TComponent;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.OwnerKOLForm', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.OwnerKOLForm' );
  try
  //Rpt( 'Where from TKOLCustomControl.OwnerKOLForm called?' );
  //Rpt_Stack;

  C := AOwner;
  Log( '*1 TKOLCustomControl.OwnerKOLForm' );
  while (C <> nil) and not(C is TForm) do
    C := C.Owner;
  Log( '*2 TKOLCustomControl.OwnerKOLForm' );
  Result := nil;
  if C <> nil then
  if C is TForm then
  begin
  Log( '*3 TKOLCustomControl.OwnerKOLForm' );
    for I := 0 to (C as TForm).ComponentCount - 1 do
    begin
      D := (C as TForm).Components[ I ];
      if D is TKOLForm then
      begin
        Result := D as TKOLForm;
        break;
      end;
    end;
  Log( '*4 TKOLCustomControl.OwnerKOLForm' );
  end;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.OwnerKOLForm' );
  end;
end;

procedure TKOLCustomControl.DoNotifyLinkedComponents(
  Operation: TNotifyOperation);
var I: Integer;
    C: TComponent;
begin
  Log( '->TKOLCustomControl.DoNotifyLinkedComponents' );
  try

  if Assigned( fNotifyList ) then
    for I := fNotifyList.Count-1 downto 0 do
    begin
      C := fNotifyList[ I ];
      if C is TKOLObj then
        (C as TKOLObj).NotifyLinkedComponent( Self, Operation )
      else
      if C is TKOLCustomControl then
        (C as TKOLCustomControl).NotifyLinkedComponent( Self, Operation );
    end;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.DoNotifyLinkedComponents' );
  end;
end;

function TKOLCustomControl.Get_ParentFont: TKOLFont;
begin
  Log( '->TKOLCustomControl.Get_ParentFont' );
  try
  if (ParentKOLControl <> nil) then
  begin
    if ParentKOLControl = ParentKOLForm then
      Result := ParentKOLForm.Font
    else
      Result := (ParentKOLControl as TKOLCustomControl).Font;
  end
  else
    Result := nil;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.Get_ParentFont' );
  end;
end;

{$IFDEF NOT_USE_KOLCTRLWRAPPER}
procedure TKOLCustomControl.CreateKOLControl(Recreating: boolean);
begin
  //
end;

procedure TKOLCustomControl.UpdateAllowSelfPaint;
begin
  //
end;
{$ENDIF NOT_USE_KOLCTRLWRAPPER}

procedure TKOLCustomControl.SetUnicode(const Value: Boolean);
begin
  FUnicode := Value;
  Change;
end;

procedure TKOLCustomControl.Setaction(const Value: TKOLAction);
begin
  Log( '->TKOLCustomControl.Setaction' );
  try
    if Faction <> Value then
    begin
      if Faction <> nil then
        Faction.UnLinkComponent(Self);
      Faction := Value;
      if Faction <> nil then
        Faction.LinkComponent(Self);
      Change;
    end;
    LogOK;
  finally
  Log( '<-TKOLCustomControl.Setaction' );
  end;
end;

procedure TKOLCustomControl.Notification(AComponent: TComponent; Operation: TOperation);
begin
  //Log( '->TKOLCustomControl.Notification' );
  try
    //Rpt( 'Where from TKOLCustomControl.Notification called:' );
    //Rpt_Stack;
  inherited;
  if Operation = opRemove then
    if AComponent = Faction then
    begin
      //Rpt( 'Faction.UnLinkComponent(Self);' );
      Faction.UnLinkComponent(Self);
      Faction := nil;
      //Rpt( 'eeeeeeeeeeeeeeeeeeeeeeeee' );
    end;
  //LogOK;
  finally
  //Log( '<-TKOLCustomControl.Notification' );
  end;
end;

procedure TKOLCustomControl.SetWindowed(const Value: Boolean);
begin
  if FWindowed = Value then Exit;
  FWindowed := Value;
  Change;
end;

procedure TKOLCustomControl.SetWordWrap(const Value: Boolean);
begin
  fWordWrap := Value;
  Change;
end;

{ TKOLApplet }

procedure TKOLApplet.AssignEvents(SL: TStringList; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.AssignEvents', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.AssignEvents' );
  TRY

  DoAssignEvents( SL, AName,
  [ 'OnMessage', 'OnDestroy', 'OnClose', 'OnQueryEndSession', 'OnMinimize', 'OnRestore' ],
  [ @OnMessage, @ OnDestroy, @ OnClose, @ OnQueryEndSession, @ OnMinimize, @ OnRestore  ] );

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.AssignEvents' );
  END;
end;

function TKOLApplet.AutoCaption: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.AutoCaption', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLApplet.BestEventName: String;
begin
  Result := 'OnMessage';
end;

procedure TKOLApplet.Change( Sender : TComponent );
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.Change', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.Change' );
  TRY

  if fChangingNow or ( csLoading in ComponentState ) or (Name = '') or fIsDestroying or
     (Owner = nil) or (csDestroying in Owner.ComponentState) then
  begin
    LogOK; Exit;
  end;
  //if Creating_DoNotGenerateCode then Exit;
  fChangingNow := TRUE;
  try
    FChanged := TRUE;

    if KOLProject <> nil then
    begin
      try
      S := KOLProject.SourcePath;
      except
        on E: Exception do
        begin
          ShowMessage( 'Can not obtain KOLProject.SourcePath, exception: ' +
                       E.Message );
          S := fSourcePath;
        end;
      end;
      fSourcePath := S;
      if (csLoading in ComponentState) then
      begin
        LogOK; Exit;
      end;
      if Sender <> nil then
      begin
        if (Self is TKOLForm) and ((Sender as TKOLForm).FormName <> '') then
        Rpt( Sender.Name + '(' + (Sender as TKOLForm).FormName + '): ' + Sender.ClassName + ' changed.' )
        else
        Rpt( Sender.Name + ': ' + Sender.ClassName + ' changed.' );
        //Rpt_Stack;
      end;
      //if (Sender <> nil) and (Sender.Name <> '') then
        KOLProject.Change;
    end
      else
    if (fSourcePath = '') or not DirectoryExists( fSourcePath ) or
       (ToolServices = nil) or not(Self is TKOLForm) then
    begin
      if FShowingWarnAbtMainForm then
      begin
        LogOK; Exit;
      end;
      if Abs( Integer( GetTickCount ) - FLastWarnTimeAbtMainForm ) > 3000 then
      begin
        FLastWarnTimeAbtMainForm := GetTickCount;
        if (csLoading in ComponentState) then
        begin
          LogOK; Exit;
        end;
        S := Name;
        if (Sender <> nil) and (Sender.Name <> '') then
          S := Sender.Name;
        if S = '' then
        begin
          LogOK; Exit;
        end;
        FShowingWarnAbtMainForm := True;
        ShowMessage( S + ' is changed, but changes can not ' +
                     'be applied because TKOLProject component is not found. ' +
                     'Be sure that your main form is opened in designer and ' +
                     'TKOLProject component present on it to provide automatic ' +
                     'or manual code generation for all changes made at design ' +
                     'time.' );
        FLastWarnTimeAbtMainForm := GetTickCount;
        FShowingWarnAbtMainForm := False;
      end;
    end
      else
    begin
      try
        if (csLoading in ComponentState) then
        begin
          LogOK; Exit;
        end;
        if Sender <> nil then
        begin
          if (Self is TKOLForm) and ((Sender as TKOLForm).FormName <> '') then
            Rpt( Sender.Name + '(' + (Sender as TKOLForm).FormName + '): ' + Sender.ClassName + ' changed.' )
          else
          Rpt( Sender.Name + ': ' + Sender.ClassName + ' changed.' );
        end;
        //S := ToolServices.GetCurrentFile;
        S := (Self as TKOLForm).formUnit; // by Speller
        //S := IncludeTrailingPathDelimiter( fSourcePath ) + ExtractFileName( S );
        S := IncludeTrailingPathDelimiter(fSourcePath) + S; // by Speller
        (Self as TKOLForm).GenerateUnit( S );
        //ShowMessage( S + ' is changed and is regenerated!' );
      except
        on E: Exception do
        begin
          ShowMessage( 'Can not handle Applet.Change, exception: ' + E.Message );
        end;
      end;
    end;

  finally
    fChangingNow := FALSE;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.Change' );
  END;
end;

procedure TKOLApplet.ChangeDPR;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.ChangeDPR', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.ChangeDPR' );
  TRY

  //BuildKOLProject;
  if (KOLProject <> nil) and not (KOLProject.FBuilding) then
    KOLProject.ConvertVCL2KOL( TRUE, FALSE );

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.ChangeDPR' );
  END;
end;

constructor TKOLApplet.Create(AOwner: TComponent);
//var WasCreating: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.Create', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.Create' );
  //WasCreating := Creating_DoNotGenerateCode;
  //Creating_DoNotGenerateCode := TRUE;
  TRY

  inherited;
  Visible := True;
  Enabled := True;
  if ClassName = 'TKOLApplet' then
  begin
    if KOLProject <> nil then
    begin
      if KOLProject.ProjectDest = '' then
        Caption := KOLProject.ProjectName
      else
        Caption := KOLProject.ProjectDest;
    end;
    if Applet <> nil then
    begin
      ShowMessage( 'You have already TKOLApplet component defined in your project. ' +
                   'It must be a single (and it is necessary in project only in ' +
                   'case, when the project contains several forms, or feature of ' +
                   'hiding application button on taskbar is desireable.'#13 +
                   'It is recommended to place TKOLApplet on main form of your ' +
                   'project, together with TKOLProject component.' );
    end
       else
      Applet := Self;
  end
     else
  begin
    if (Owner <> nil) and (Owner is TForm) then
    if AutoCaption then
      Caption := (Owner as TForm).Caption
    else
    begin
      if Caption <> '' then
        Caption := '';
      (Owner as TForm).Caption := '';
    end;
  end;
  FLastWarnTimeAbtMainForm := GetTickCount;

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.Create' );
    //Creating_DoNotGenerateCode := WasCreating;
  END;
end;

destructor TKOLApplet.Destroy;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.Destroy', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.Destroy' );
  TRY

  if Applet = Self then
    Applet := nil;
  inherited;

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.Destroy' );
  END;
end;

procedure TKOLApplet.DoAssignEvents(SL: TStringList; const AName: String;
  EventNames: array of PChar; EventHandlers: array of Pointer);
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.DoAssignEvents', 0
  @@e_signature:
  end;
  //Log( '->TKOLApplet.DoAssignEvents' );
  TRY

  for I := 0 to High( EventHandlers ) do
  begin
    if EventHandlers[ I ] <> nil then
    SL.Add( '      ' + AName + '.' + EventNames[ I ] + ' := Result.' +
            (Owner as TForm).MethodName( EventHandlers[ I ] ) + ';' );
  end;

  //LogOK;
  FINALLY
    //Log( '<-TKOLApplet.DoAssignEvents' );
  END;
end;

procedure TKOLApplet.GenerateRun(SL: TStringList; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.GenerateRun', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.GenerateRun' );
  TRY

  if Tag <> 0 then
  begin
    if Tag < 0 then
      SL.Add( '  Applet.Tag := DWORD(' + Int2Str( Tag ) + ');' )
    else
      SL.Add( '  Applet.Tag := ' + Int2Str( Tag ) + ';' );
  end;
  if not(Self is TKOLForm) then
  begin
    if AllBtnReturnClick then
      SL.Add( '  Applet.AllBtnReturnClick;' );
    if Tabulate then
      SL.Add( '  Applet.Tabulate;' )
    else
    if TabulateEx then
      SL.Add( '  Applet.TabulateEx;' );
  end;
  SL.Add( '  Run( ' + AName + ' );' );

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.GenerateRun' );
  END;
end;

procedure TKOLApplet.SetAllBtnReturnClick(const Value: Boolean);
begin
  Log( '->TKOLApplet.SetAllBtnReturnClick' );
  TRY
  FAllBtnReturnClick := Value;
  Change( Self );
  LogOK;
  FINALLY
    Log( '<-TKOLApplet.SetAllBtnReturnClick' );
  END;
end;


procedure TKOLApplet.SetCaption(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.SetCaption', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.SetCaption' );
  TRY

  fCaption := Value;
  Change( Self );

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.SetCaption' );
  END;
end;

procedure TKOLApplet.SetEnabled(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.SetEnabled', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.SetEnabled' );
  TRY

  fEnabled := Value;
  Change( Self );

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.SetEnabled' );
  END;
end;

procedure TKOLApplet.SetForceIcon16x16(const Value: Boolean);
begin
  Log('->TKOLApplet.SetForceIcon16x16');
  TRY

  FForceIcon16x16 := Value;
  Change( Self );

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.SetForceIcon16x16' );
  END;
end;

procedure TKOLApplet.SetIcon(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.SetIcon', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.SetIcon' );
  TRY

  FIcon := Value;
  Change( Self );

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.SetIcon' );
  END;
end;

procedure TKOLApplet.SetOnClose(const Value: TOnEventAccept);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.SetOnClose', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.SetOnClose' );
  TRY

  FOnClose := Value;
  Change( Self );

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.SetOnClose' );
  END;
end;

procedure TKOLApplet.SetOnDestroy(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.SetOnDestroy', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.SetOnDestroy' );
  TRY

  FOnDestroy := Value;
  Change( Self );

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.SetOnDestroy' );
  END;
end;

procedure TKOLApplet.SetOnMessage(const Value: TOnMessage);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.SetOnMessage', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.SetOnMessage' );
  TRY

  FOnMessage := Value;
  Change( Self );

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.SetOnMessage' );
  END;
end;

procedure TKOLApplet.SetOnMinimize(const Value: TOnEvent);
begin
  Log( '->TKOLApplet.SetOnMinimize' );
  TRY

  FOnMinimize := Value;
  Change( Self );

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.SetOnMinimize' );
  END;
end;

procedure TKOLApplet.SetOnQueryEndSession(const Value: TOnEventAccept);
begin
  Log( '->TKOLApplet.SetOnQueryEndSession' );
  try
  FOnQueryEndSession := Value;
  Change( Self );
  LogOK;
  finally
    Log( '<-TKOLApplet.SetOnQueryEndSession' );
  end;
end;

procedure TKOLApplet.SetOnRestore(const Value: TOnEvent);
begin
  Log( '->TKOLApplet.SetOnRestore' );
  try
  FOnRestore := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLApplet.SetOnRestore' );
  end;
end;

procedure TKOLApplet.SetTabulate(const Value: Boolean);
begin
  Log( '->TKOLApplet.SetTabulate' );
  try
  FTabulate := Value;
  if Value then
    FTabulateEx := False;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLApplet.SetTabulate' );
  end;
end;

procedure TKOLApplet.SetTabulateEx(const Value: Boolean);
begin
  Log( '->TKOLApplet.SetTabulateEx' );
  try
  FTabulateEx := Value;
  if Value then
    FTabulate := False;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLApplet.SetTabulateEx' );
  end;
end;

procedure TKOLApplet.SetTag(const Value: Integer);
begin
  Log( '->TKOLApplet.SetTag' );
  try
  FTag := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLApplet.SetTag' );
  end;
end;

procedure TKOLApplet.SetVisible(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.SetVisible', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.SetVisible' );
  try
  fVisible := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLApplet.SetVisible' );
  end;
end;

{ TKOLForm }

procedure TKOLForm.AssignEvents(SL: TStringList; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.AssignEvents', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.AssignEvents' );
  try
  if not FLocked then
  begin
    if (Applet <> nil) and (Applet.Owner = Owner) then
      Applet.AssignEvents( SL, 'Applet' );
    //inherited;
    DoAssignEvents( SL, AName, [ 'OnMessage', 'OnClose', 'OnQueryEndSession' ],
                               [ @OnMessage, @ OnClose, @ OnQueryEndSession  ] );
    DoAssignEvents( SL, AName, [ 'OnMinimize', 'OnMaximize', 'OnRestore' ],
                               [ @ OnMinimize, @ OnMaximize, @ OnRestore  ] );
    DoAssignEvents( SL, AName,
    [ 'OnClick', 'OnMouseDblClk', 'OnMouseDown', 'OnMouseMove', 'OnMouseUp', 'OnMouseWheel', 'OnMouseEnter', 'OnMouseLeave' ],
    [ @OnClick,  @ OnMouseDblClk, @OnMouseDown,  @OnMouseMove,  @OnMouseUp,  @OnMouseWheel,  @OnMouseEnter,  @OnMouseLeave  ] );
    DoAssignEvents( SL, AName,
    [ 'OnEnter', 'OnLeave', 'OnKeyDown', 'OnKeyUp', 'OnChar', 'OnResize', 'OnMove', 'OnShow', 'OnHide' ],
    [ @OnEnter,  @OnLeave,  @OnKeyDown,  @OnKeyUp,  @OnChar,  @OnResize, @ OnMove, @ OnShow, @ OnHide ] );
    DoAssignEvents( SL, AName,
    [ 'OnPaint', 'OnEraseBkgnd', 'OnDropFiles' ],
    [ @ OnPaint, @ OnEraseBkgnd, @ OnDropFiles ] );
    // This event must be called at last! (and not assigned!) - so do this in SetupLast method.
    {DoAssignEvents( SL, AName,
    [ 'OnFormCreate' ],
    [ @ OnFormCreate ] );}

    DoAssignEvents( SL, AName,
    [ 'OnDestroy', 'OnHelp' ],
    [ @ OnDestroy, @ OnHelp ] );
    {if Assigned( OnDestroy ) then
      SL.Add( '      ' + AName + '.OnDestroy := Result.' +
              (Owner as TForm).MethodName( OnFormDestroy ) + ';' );}
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.AssignEvents' );
  end;
end;

procedure TKOLForm.Change(Sender: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.Change', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.Change' );
  try
  if not FLocked and not ( csLoading in ComponentState ) and not FIsDestroying and
     (Owner <> nil) and not(csDestroying in Owner.ComponentState) then
  begin
    //if Creating_DoNotGenerateCode then Exit;
    if AllowRealign then
    if FRealigning = 0 then
    if FRealignTimer <> nil then
    begin
      FRealignTimer.Enabled := FALSE;
      FRealignTimer.Enabled := TRUE;
    end;
    if FChangeTimer <> nil then
    begin
      FChangeTimer.Enabled := FALSE;
      FChangeTimer.Enabled := TRUE;
    end
      else
    if not (csLoading in Sender.ComponentState) then
      DoChangeNow;
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.Change' );
  end;
end;

constructor TKOLForm.Create(AOwner: TComponent);
var I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.Create', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.Create' );
  try

  Log( '?01 TKOLForm.Create' );

  if KOLProject <> nil then
  begin
    if KOLProject.ProjectDest = '' then
    begin
      raise Exception.Create( 'You forget to change projectDest property ' +
            'of TKOLProject component!' );
    end;
  end;

  Log( '?02 TKOLForm.Create' );
  inherited;

  Log( '?03 TKOLForm.Create' );

  //Creating_DoNotGenerateCode := TRUE;
  AllowRealign := TRUE;

  Log( '?03.A TKOLForm.Create' );

  FStatusText := TStringList.Create;

  Log( '?03.B TKOLForm.Create' );

  FStatusSizeGrip := TRUE;

  Log( '?03.C TKOLForm.Create' );

  FParentLikeFontControls := TList.Create;

  Log( '?03.D TKOLForm.Create' );

  FParentLikeColorControls := TList.Create;
  //fDefaultPos := True;
  //fDefaultSize := True;

  Log( '?03.E TKOLForm.Create' );

  fCanResize := True;

  Log( '?03.F TKOLForm.Create' );

  fVisible := True;

  Log( '?03.G TKOLForm.Create' );

  fAlphaBlend := 255;

  Log( '?03.H TKOLForm.Create' );

  fEnabled := True;

  Log( '?03.I TKOLForm.Create' );

  fMinimizeIcon := True;

  Log( '?03.J TKOLForm.Create' );

  fMaximizeIcon := True;

  Log( '?03.K TKOLForm.Create' );

  fCloseIcon := True;

  Log( '?03.L TKOLForm.Create' );

  FborderStyle := fbsSingle; {YS}

  Log( '?03.M TKOLForm.Create' );

  fHasBorder := True;

  Log( '?03.N TKOLForm.Create' );

  fHasCaption := True;

  Log( '?03.o TKOLForm.Create' );

  fCtl3D := True;

  Log( '?03.P TKOLForm.Create' );

  //AutoCreate := True;
  fMargin := 2;

  Log( '?03.Q TKOLForm.Create' );

  fBounds := TFormBounds.Create;

  Log( '?03.R TKOLForm.Create' );

  fBounds.Owner := Self;
  {fBounds.fL := (Owner as TForm).Left;
  fBounds.fT := (Owner as TForm).Top;
  fBounds.fW := (Owner as TForm).Width;
  fBounds.fH := (Owner as TForm).Height;}
  //fBrush := TBrush.Create;

  Log( '?04 TKOLForm.Create' );
  fFont := TKOLFont.Create( Self );
  fBrush := TKOLBrush.Create( Self );

  Log( '?05 TKOLForm.Create' );

  if AOwner <> nil then
  begin
    Log( '?06 TKOLForm.Create' );
    for I := 0 to AOwner.ComponentCount - 1 do
    begin
      C := AOwner.Components[ I ];
      if C = Self then Continue;
      if IsVCLControl( C ) then
      begin
        FLocked := TRUE;
        ShowMessage( 'The form ' + FormName + ' contains already VCL controls.'#13 +
        'The TKOLForm component is locked now and will not functioning.'#13 +
        'Just delete it and never drop onto forms, beloning to VCL projects.' );
        break;
      end;
    end;
    Log( '?07 TKOLForm.Create' );
    if not FLocked then
    for I := 0 to AOwner.ComponentCount - 1 do
    begin
      C := AOwner.Components[ I ];
      if C = Self then Continue;
      if C is TKOLForm then
      begin
        ShowMessage( 'The form ' + FormName + ' contains more then one instance of ' +
                     'TKOLForm component. '#13 +
                     'This will cause unpredictable results. It is recommended to ' +
                     'remove all ambigous instances of TKOLForm component before ' +
                     'You launch the project.' );
        break;
      end;
    end;
    Log( '?08 TKOLForm.Create' );
  end;
  if FormsList = nil then
    FormsList := TList.Create;
  Log( '?09 TKOLForm.Create' );
  FormsList.Add( Self );
  if not (csLoading in ComponentState) then
    if Caption = '' then
      Caption := FormName;
  Log( '?10 TKOLForm.Create' );
  (Owner as TForm).Scaled := FALSE;
  (Owner as TForm).HorzScrollBar.Visible := FALSE;
  (Owner as TForm).VertScrollBar.Visible := FALSE;
  Log( '?11 TKOLForm.Create' );
  FRealignTimer := TTimer.Create( Self );
  FRealignTimer.Interval := 50;
  FRealignTimer.OnTimer := RealignTimerTick;
  Log( '?12 TKOLForm.Create' );
  FChangeTimer := TTimer.Create( Self );
  FChangeTimer.OnTimer := ChangeTimerTick;
  FChangeTimer.Enabled := FALSE;
  FChangeTimer.Interval := 100;
  Log( '?13 TKOLForm.Create' );
  if not (csLoading in ComponentState) then
    FRealignTimer.Enabled := TRUE;
  Log( '?14 TKOLForm.Create' );
  LogOK;
  finally
  Log( '<-TKOLForm.Create' );
  //Creating_DoNotGenerateCode := FALSE;
  FChanged := FALSE;
  end;
end;

destructor TKOLForm.Destroy;
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.Destroy', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.Destroy' );
  FIsDestroying := TRUE;
  try
  if bounds <> nil then
    bounds.EnableTimer( FALSE );
  AllowRealign := FALSE;
  fBounds.Free;
  if FormsList <> nil then
  begin
    I := FormsList.IndexOf( Self );
    if I >= 0 then
    begin
      FormsList.Delete( I );
      if FormsList.Count = 0 then
      begin
        FormsList.Free;
        FormsList := nil;
      end;
    end;
  end;
  fFont.Free;
  FParentLikeFontControls.Free;
  FParentLikeColorControls.Free;
  FStatusText.Free;
  ResStrings.Free;
  inherited;
  LogOK;
  finally
  Log( '<-TKOLForm.Destroy' );
  end;
end;

procedure SwapItems( Data: Pointer; const e1, e2: DWORD );
var Tmp: Pointer;
    L: TList;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'SwapItems', 0
  @@e_signature:
  end;
  L := Data;
  Tmp := L.Items[ e1 ];
  L.Items[ e1 ] := L.Items[ e2 ];
  L.Items[ e2 ] := Tmp;
  //Rpt( Int2Str( e1 ) + '<-->' + Int2Str( e2 ) );
end;

function CompareControls( Data: Pointer; const e1, e2: DWORD ): Integer;
const Signs: array[ -1..1 ] of Char = ( '<', '=', '>' );
var K1, K2: TKOLCustomControl;
    L: TList;
    function CompareInt( X, Y: Integer ): Integer;
    begin
      if X < Y then Result := -1
      else
      if X > Y then Result := 1
      else
      Result := 0;
    end;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'CompareControls', 0
  @@e_signature:
  end;
  L := Data;
  K1 := L.Items[ e1 ];
  K2 := L.Items[ e2 ];
  Result := 0;
  if K1.Align = K2.Align then
  case K1.Align of
  caLeft: Result := CompareInt( K1.Left, K2.Left );
  caTop:  Result := CompareInt( K1.Top, K2.Top );
  caRight:Result := CompareInt( K2.Left, K1.Left );
  caBottom: Result := CompareInt( K2.Top, K1.Top );
  caClient: Result := CompareInt( K1.ControlIndex,
                                  K1.ControlIndex );
  end;
  if Result = 0 then
    Result := CompareInt( K1.TabOrder, K2.TabOrder );
  //Rpt( 'Compare ' + K1.Name + '.' + Int2Str( K1.TabOrder ) + ' ' + Signs[ Result ] + ' ' +
  //                  K2.Name + '.' + Int2Str( K2.TabOrder ) );
end;

const
{$IFDEF VER90}
  {$DEFINE offDefined}
  offCreate = $24;
{$ENDIF}
{$IFDEF VER100}
  {$DEFINE offDefined}
  offCreate = $24;
{$ENDIF}
{$IFNDEF offDefined}
  offCreate = $2C;
{$ENDIF}

// Данная функция конструирует и возвращает компонент того же класса, что
// и компонент, переданный в качестве параметра. Для конструирования вызывается
// виртуальный коструктор компонента (смещение точки входа в vmt зависит от
// версии Delphi).
function ComponentLike( C: TComponent ): TComponent;
asm
  xor ecx, ecx
  mov dl,1
  mov eax, [eax]
  call dword ptr [eax+offCreate]
end;

function Comma2Pt( const S: String ): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'Comma2Pt', 0
  @@e_signature:
  end;
  Result := S;
  while pos( ',', Result ) > 0 do
    Result[ pos( ',', Result ) ] := '.';
end;

function Bool2Str( const S: String ): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'Bool2Str', 0
  @@e_signature:
  end;
  if S = '0' then Result := 'FALSE'
  else            Result := 'TRUE';
end;

{$IFDEF _D2}
function GetEnumProp(Instance: TObject; PropInfo: PPropInfo): string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'GetEnumProp', 0
  @@e_signature:
  end;
  Result := GetEnumName(PropInfo^.PropType, GetOrdProp(Instance, PropInfo));
end;
{$ENDIF}
{$IFDEF _D3orD4}
function GetEnumProp(Instance: TObject; PropInfo: PPropInfo): string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'GetEnumProp', 0
  @@e_signature:
  end;
  Result := GetEnumName(PropInfo^.PropType^, GetOrdProp(Instance, PropInfo));
end;
{$ENDIF}

{$IFDEF _D2}
type
  TIntegerSet = set of 0..SizeOf(Integer) * 8 - 1;

function GetSetProp(Instance: TObject; PropInfo: PPropInfo;
  Brackets: Boolean): string;
var
  S: TIntegerSet;
  TypeInfo: PTypeInfo;
  I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'GetSetProp', 0
  @@e_signature:
  end;
  Integer(S) := GetOrdProp(Instance, PropInfo);
  TypeInfo := GetTypeData(PropInfo.PropType).CompType;
  for I := 0 to SizeOf(Integer) * 8 - 1 do
    if I in S then
    begin
      if Result <> '' then
        Result := Result + ',';
      Result := Result + GetEnumName(TypeInfo, I);
    end;
  if Brackets then
    Result := '[' + Result + ']';
end;
{$ENDIF}
{$IFDEF _D3orD4}
type
  TIntegerSet = set of 0..SizeOf(Integer) * 8 - 1;

function GetSetProp(Instance: TObject; PropInfo: PPropInfo;
  Brackets: Boolean): string;
var
  S: TIntegerSet;
  TypeInfo: PTypeInfo;
  I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'GetSetProp', 0
  @@e_signature:
  end;
  Integer(S) := GetOrdProp(Instance, PropInfo);
  TypeInfo := GetTypeData(PropInfo.PropType^).CompType^;
  for I := 0 to SizeOf(Integer) * 8 - 1 do
    if I in S then
    begin
      if Result <> '' then
        Result := Result + ',';
      Result := Result + GetEnumName(TypeInfo, I);
    end;
  if Brackets then
    Result := '[' + Result + ']';
end;
{$ENDIF}

// Данная функция возвращает значение публикуемого свойства компонента в виде
// строки, которую можно вставить в текст программы в правую часть присваивания
// значения этому свойству.
function PropValueAsStr( C: TComponent; const PropName: String; PI: PPropInfo; SL: TStringList ): String;

  function StringConstant( const Propname, Value: String ): String;
  begin
    if C is TKOLForm then
      Result := (C as TKOLForm).StringConstant( Propname, Value )
    else if C is TKOLObj then
      Result := (C as TKOLObj).StringConstant( Propname, Value )
    else if C is TKOLCustomControl then
      Result := (C as TKOLCustomControl).StringConstant( Propname, Value )
    else
      Result := String2Pascal( Value );
  end;

var PropValue: String;
    V: Variant;
    Method: TMethod;
    Ch: Char;
    Wc: WChar;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'PropValueAsStr', 0
  @@e_signature:
  end;
  PropValue := '';
  Result := '';
  case PI.PropType^.Kind of
    tkVariant:
    begin
    try
      V := //GetPropValue( C, PropName, TRUE );
           GetVariantProp( C, PI );
      case VarType( V ) of
      varEmpty:     PropValue := 'UnAssigned';
      varNull:      PropValue := 'NULL';
      varSmallInt:  PropValue := 'VarAsType( ' + VarToStr( V ) + ', varSmallInt )';
      varInteger:   PropValue := IntToStr( V.AsInteger );
      varSingle:    PropValue := 'VarAsType( ' + Comma2Pt( VarToStr( V ) ) + ', varSingle )';
      varDouble:    PropValue := 'VarAsType( ' + Comma2Pt( VarToStr( V ) ) + ', varDouble )';
      varCurrency:  PropValue := 'VarAsType( ' + Comma2Pt( VarToStr( V ) ) + ', varCurrency )';
      varDate:      PropValue := 'VarAsType( ' + Comma2Pt( VarToStr( VarAsType( V, varDouble ) ) ) + ', varDate )';
      varByte:      PropValue := 'VarAsByte( ' + VarToStr( V ) + ' )';
      //varOLEStr:    PropValue := 'VarAsType( ' + String2Pascal( VarToStr( V ) ) + ', varOLEStr )';
      varOLEStr:    PropValue := 'VarAsType( ' + PCharStringConstant( C, Propname, VarToStr( V ) ) + ', varOLEStr )';
      //varString:    PropValue := String2Pascal( VarToStr( V ) );
      varString:    PropValue := StringConstant( Propname, VarToStr( V ) );
      varBoolean:   PropValue := Bool2Str( VarToStr( V ) );
      else
                   begin
       SL.Add( '    //----!!!---- Can not assign variant property ----!!!----' );
       Exit;
                   end;
      end;
    except
     SL.Add( '    //-----^----- Error getting variant value' )
    end;
    end;
    tkString, tkLString,
    {$IFDEF _D2} tkLWString {$ELSE} tkWString {$ENDIF}:
     try
       //PropValue := String2Pascal( GetStrProp( C,
       PropValue := StringConstant( Propname, GetStrProp( C,
                    {$IFDEF _D2orD3orD4} PI {$ELSE} PropName {$ENDIF} ) );
     except
       PropValue := '';
       SL.Add( '    //----^---- Cannot obtain string property ' + PropName +
               '. May be, it is write-only.' );
       raise;
     end;
    tkChar:
     begin
       Ch := Char( GetOrdProp( C, {$IFDEF _D2orD3orD4} PI {$ELSE} PropName {$ENDIF} ) );
       if Ch in [ ' '..#127 ] then
         PropValue := '''' + Ch + ''''
       else
         PropValue := '#' + IntToStr( Ord( Ch ) );
     end;
    tkWChar:
     begin
       Wc := WChar( GetOrdProp( C, {$IFDEF _D2orD3orD4} PI {$ELSE} PropName {$ENDIF} ) );
       if Wc in [ WChar(' ')..WChar(#127) ] then
         PropValue := '''' + Char( Wc ) + ''''
       else
         PropValue := 'WChar( ' + IntToStr( Ord( Wc ) ) + ' )';
     end;
    tkMethod:
    begin
      Method := GetMethodProp( C, {$IFDEF _D2orD3orD4} PI {$ELSE} PropName {$ENDIF} );
      if not Assigned( Method.Code ) then
        Exit;
      if C.Owner <> nil then
      if C.Owner is TForm then
        PropValue := 'Result.' + C.Owner.MethodName( Method.Code );
    end;
    tkInteger:     PropValue := Int2Str( GetOrdProp( C,
                                {$IFDEF _D2orD3orD4} PI {$ELSE} PropName {$ENDIF} ) );
    tkEnumeration: PropValue := GetEnumProp( C, PI );
    tkFloat:       begin
                    S := FloatToStr( GetFloatProp( C, PI ) );
                    while pos( ',', S ) > 0 do
                      S[ pos( ',', S ) ] := '.';
                    PropValue := S;
                  end;
    tkSet:         PropValue := GetSetProp( C, PI, TRUE );
    {$IFNDEF _D2orD3}
    tkInt64:       PropValue := IntToStr( GetInt64Prop( C, PI ) );
    {$ENDIF}
    tkUnknown: begin
                SL.Add( '    //-----?----- property type tkUnknown' );
                Exit;
              end;
    else      Exit;
  end;
  Result := PropValue;
end;

// Конструирование кода для компонента, унаследованного от TComponent.
// Вообще-то, в KOL-MCK-проектах желательно использовать только компоненты,
// специально разработанные для MCK. Но если компонент слабо связан с VCL и
// не тянет на себя много дополнительного кода, использование его в проектах
// KOL вполне возможно. А иногда желательно.
// Здесь генерируется код, конструирующий такой компонент, созданный и
// настроенный в deseign-time на форме MCK-проекта. Устанавливаются все публичные
// свойства, отличающиеся своим значением от тех, которые назначаются по умолчанию
// в конструкторе объекта.
procedure ConstructComponent( SL: TStringList; C: TComponent );
var Props, PropsD: PPropList;
    NProps, NPropsD, I, J: Integer;
    PropName, PropValue, PropValueD: String;
    PI, DPI: PPropInfo;
    D: TComponent;
    WasError: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'ConstructComponent', 0
  @@e_signature:
  end;
  SL.Add( '    Result.' + C.Name + ' := ' + C.ClassName + '.Create( nil );' );
  if C is TOleControl then
    SL.Add( '    Result.' + C.Name +
            '.ParentWindow := Result.Form.GetWindowHandle;' );
  D := nil;
  GetMem( Props, Sizeof( TPropList ) );
  GetMem( PropsD, Sizeof( TPropList ) );
  try
  try
    NProps := GetPropList( C.ClassInfo, tkAny, Props );
    SL.Add( '    //-- found ' + Int2Str( NProps ) + ' published props' );
    if NProps > 0 then
    BEGIN
      D := ComponentLike( C );
      NPropsD :=  GetPropList( C.ClassInfo, tkAny, PropsD );
      for I := 0 to NProps-1 do
      begin
         PI := Props[ I ];
         PropName := PI.Name;
         DPI := nil;
         for J := 0 to NPropsD-1 do
         begin
           DPI := PropsD[ J ];
           if PropName = DPI.Name then break;
           DPI := nil;
         end;

         SL.Add( '    // ' + IntToStr( I ) + ': ' + PropName );
         //if not IsStoredProp( C, PropName ) then continue;
         PropValueD := '';
         WasError := FALSE;
         try
           if DPI <> nil then
           if DPI.PropType^.Kind = PI.PropType^.Kind then
             PropValueD := PropValueAsStr( D, PropName, DPI, SL );
           PropValue := PropValueAsStr( C, PropName, PI, SL );
           if (DPI = nil) or (PropValue <> PropValueD) then
           SL.Add( '    Result.' + C.Name + '.' + PropName + ' := ' +
                   PropValue + ';' );
         except
           WasError := TRUE;
         end;
         if WasError then
         try
           if DPI <> nil then
           if DPI.PropType^.Kind = PI.PropType^.Kind then
           begin
             PropValueD := PropValueAsStr( D, PropName, DPI, SL );
             SL.Add( '    //Default: ' + PropName + '=' + PropValueD );
           end;
           PropValue := PropValueAsStr( C, PropName, PI, SL );
           SL.Add(   '    //Actual : ' + PropName + '=' + PropValue );
           if (DPI = nil) or (PropValue <> PropValueD) then
           SL.Add( '    Result.' + C.Name + '.' + PropName + ' := ' +
                   PropValue + ';' );
         except
           SL.Add( '    //-----^------Exception while getting propery ' +
                   PropName + ' of ' + C.Name );
         end;
      end;
    END;
  finally
    FreeMem( Props );
    D.Free;
  end;
  except
    SL.Add( '    //-----^------Exception while getting properties of ' + C.Name );
  end;
end;


procedure TKOLForm.GenerateChildren( SL: TStringList; OfParent: TComponent; const OfParentName: String; const Prefix: String;
          var Updated: Boolean );
var I: Integer;
    L: TList;
    S: String;
    KC: TKOLCustomControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GenerateChildren', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GenerateChildren' );
  try
  L := TList.Create;
  try
    for I := 0 to Owner.ComponentCount - 1 do
    begin
      if Owner.Components[ I ] is TKOLCustomControl then
      if (Owner.Components[ I ] as TKOLCustomControl).ParentKOLControl = OfParent then
      begin
        //Rpt( 'Look for ' + OfParent.Name + ': ' + Owner.Components[ I ].Name );
        //Rpt( '.ParentKOLControl = ' + (Owner.Components[ I ] as TKOLCustomControl).ParentKOLControl.Name );
        KC := Owner.Components[ I ] as TKOLCustomControl;
        L.Add( KC );
      end;
    end;
    SortData( L, L.Count, @CompareControls, @SwapItems );
    for I := 0 to L.Count - 1 do
    begin
      KC := L.Items[ I ];
      KC.fUpdated := FALSE;
      SL.Add( '    // ' + KC.RefName + '.TabOrder = ' + Int2Str( KC.TabOrder ) );
      KC.SetupFirst( SL, KC.RefName, OfParentName, Prefix );
      GenerateAdd2AutoFree( SL, KC.RefName, TRUE, '', KC );
      S := KC.RefName;
      GenerateChildren( SL, KC, S, Prefix + '  ', Updated );
      if KC.fUpdated then
        Updated := TRUE;
    end;
  finally
    L.Free;
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.GenerateChildren' );
  end;
end;

function TKOLForm.AppletOnForm: Boolean;
var I: Integer;
    F: TForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.AppletOnForm', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.AppletOnForm' );
  try
  Result := FALSE;
  if Owner <> nil then
  begin
    F := Owner as TForm;
    for I := 0 to F.ComponentCount - 1 do
      if F.Components[ I ].ClassNameIs( 'TKOLApplet' ) then
      begin
        Result := TRUE;
        break;
      end;
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.AppletOnForm' );
  end;
end;

function CompareComponentOrder( const AList : Pointer; const e1, e2 : DWORD ) : Integer;
var OC: TList;
    C1, C2: TComponent;
    S: String;
    B: Boolean;
    K1, K2: TKOLCustomControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'CompareComponentOrder', 0
  @@e_signature:
  end;
  OC := AList;
  C1 := OC[ e1 ];
  C2 := OC[ e2 ];
  Result := 0;
  if (C1 is TKOLObj) and (C2 is TKOLObj) then
  begin
    if (C1 as TKOLObj).CreationPriority <> (C2 as TKOLObj).CreationPriority then
      Result := CmpInts( (C1 as TKOLObj).CreationPriority,
                         (C2 as TKOLObj).CreationPriority );
  end;
  if Result = 0 then
  if ((C1 is TKOLObj) or (C1 is TKOLCustomControl)) and
     ((C2 is TKOLObj) or (C2 is TKOLCustomControl)) then
  begin
    if C2 is TKOLObj then
      S := (C2 as TKOLObj).TypeName
    else
      S := (C2 as TKOLCustomControl).TypeName;
    if C1 is TKOLObj then
      B := (C1 as TKOLObj).CompareFirst( S, C2.Name )
    else
      B := (C1 as TKOLCustomControl).CompareFirst( S, C2.Name );
    if B then Result := 1;
  end;
  if Result = 0 then
  begin
    if (C1 is TKOLCustomControl) and (C2 is TKOLCustomControl) then
    begin
      K1 := C1 as TKOLCustomControl;
      K2 := C2 as TKOLCustomControl;
      Result := CmpInts( K1.TabOrder, K2.TabOrder );
      if Result = 0 then
      begin
        if (K1.Align in [caLeft, caRight]) and (K2.Align in [caLeft, caRight]) then
          Result := CmpInts( K1.Left, K2.Left )
        else
        if (K1.Align in [caTop, caBottom]) and (K2.Align in [caTop, caBottom]) then
          Result := CmpInts( K1.Top, K2.Top );
      end;
    end
      else
    Result := CmpInts( e1, e2 );
  end;
end;

procedure SwapComponents( const AList : Pointer; const e1, e2 : DWORD );
var OC: TList;
    Tmp: Pointer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'SwapComponents', 0
  @@e_signature:
  end;
  OC := AList;
  Tmp := OC[ e1 ];
  OC[ e1 ] := OC[ e2 ];
  OC[ e2 ] := Tmp;
end;

  // В результирующем проекте:
  // Тип TMyForm - содержит обработчики событий формы и ее объектов,
  // а так же описания дочерних визуальных и невизуальных объектов.
  // (MyForm заменяется настоящим именем формы). Фактически не является
  // формой, как это происходит в VCL, где каждая визуально разрабатываемая
  // форма становится наследником от TForm. Нам просто удобно здесь
  // сделать так, потому, что появляется возможность вписывать код
  // прямо в зеркальный VCL-проект, и при этом объекты формы имеют ту же
  // область видимости в результирующем KOL-проекте. Более того, нет нужды
  // анализировать синтаксис Паскаля - достаточно скопировать исходный
  // модуль начиная со слова 'implementation' и добавить к нему только
  // пару генерируемых процедур.
  //
  // Как минимум, в нем содержится указатель на саму форму, имеющий
  // имя Form. Здесь мы выставим требование: так как в KOL переменная
  // Self будет недоступна (и будет означать указатель вот этого псевдо-
  // объекта, который сейчас описывается), то при написании кода
  // (в обработчиках событий) требуется явно указывать слово Form.
  // При таком подходе код сможет быть скомпилирован в обеих средах
  // (хотя это и будет разный код).
function TKOLForm.GenerateINC(const Path: String; var Updated: Boolean): Boolean;
var SL: TStringList;
    I: Integer;
var
    MainMenuPresent: boolean;
    PopupMenuPresent: boolean;
    KO: TKOLObj;
    KC: TKOLCustomControl;
    NeedOleInit: Boolean;

    //-- by Alexander Shakhaylo
    OC: TList;
    //--------------------------
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GenerateINC', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GenerateINC' );
  try
  Result := FALSE;
  if csLoading in ComponentState then
  begin
    LogOK; Exit;
  end;
  // не будем пытаться генерировать код, пока форма не загрузилась в дизайнер!
   
  Rpt( 'Generating INC for ' + Path ); //Rpt_Stack;

  ResStrings.Free;
  ResStrings := nil;

  //-- by Alexander Shakhaylo
  oc := TList.Create;
  TRY

    for i := 0 to Owner.ComponentCount - 1 do
       oc.Add(Owner.Components[ i ]);

    SortData( oc, oc.Count, @CompareComponentOrder, @SwapComponents );

  //--------------------------

    SL := TStringList.Create;
    Result := False;
    if FLocked then
    begin
      LogOK; Exit;
    end;

    try

    // Step 3. Generate <FormUnit_1.inc, containing constructor of
    // form holder object.
    //
    SL.Add( Signature );

    // Generating constants for menu items, toolbar buttons, list view columns, etc.
    for I := 0 to oc.Count - 1 do
    begin
      if TComponent( oc[ I ] ) is TKOLObj then
        TKOLObj( oc[ I ] ).DoGenerateConstants( SL )
      else
      if TComponent( oc[ I ] ) is TKOLCustomControl then
        TKOLToolbar( oc[ I ] ).DoGenerateConstants( SL );
    end;

    // Процедура создания объекта, сопоставленного форме. Вызывается
    // автоматически для автоматически создаваемых форм (и для главной
    // формы в первую очередь):
    SL.Add( '' );
    SL.Add( 'procedure New' + FormName + '( var Result: P' + FormName +
            '; AParent: PControl );' );
    SL.Add( 'begin' );
    SL.Add( '' );
    SL.Add( '  {$IFDEF KOLCLASSES}' );
    SL.Add( '  Result := P' + FormName + '.Create;' );
    SL.Add( '  {$ELSE OBJECTS}' );
    SL.Add( '  New( Result, Create );' );
    SL.Add( '  {$ENDIF KOL CLASSES/OBJECTS}' );
    // "Держатель формы" готов. Теперь конструируем саму форму.
    GenerateCreateForm( SL );
    Log( 'after GenerateCreateForm, next: GenerateAdd2AutoFree' );
    GenerateAdd2AutoFree( SL, 'Result', FALSE, '', nil );
    Log( 'after GenerateAdd2AutoFree, next: SetupFirst' );
    //SL.Add( '  Result.Form.Add2AutoFree( Result );' );

    SetupFirst( SL, Result_Form, 'AParent', '    ' );

    //////////////////////////////////////////////////////
    //  SUPPORT ACTIVE-X CONTROLS
    {}
    {}NeedOleInit := FALSE;
    {}for I := 0 to oc.Count-1 do
    {}begin
    {}  if TComponent( oc[ I ] ) is TOleControl then
    {}  begin
    {}    NeedOleInit := TRUE;
    {}    break;
    {}  end;
    {}end;
    {}
    {}if NeedOleInit then
    {}begin
    {}  SL.Add( '  OleInit;' );
    {}  SL.Add( '  Result.Add2AutoFreeEx( TObjectMethod( ' +
    {}            'MakeMethod( nil, @OleUninit ) ) );' );
    {}end;
    {}
    /////////////////////////////////////////////////////////


    // Конструируем компоненты VCL. Нехорошо использовать в проекта компоненты
    // завязанные на VCL, но не все они сильно завязаны с самим VCL.
    for I := 0 to oc.Count-1 do
    begin
      if not( (TComponent( oc[ I ] ) is TKOLObj) or
              (TComponent( oc[ I ] ) is TControl) or
              (TComponent( oc[ I ] ) is TKOLApplet or
              (TComponent( oc[ I ] ) is TKOLProject)))
         or (TComponent( oc[ I ] ) is TOlecontrol) then
      if TComponent( oc[ I ] ) is TComponent then // ай-я-яй!
      begin
        SL.Add( '' );
        ConstructComponent( SL, oc[ I ] );
        GenerateAdd2AutoFree( SL, 'Result.' + TComponent( oc[ I ] ).Name + '.Free',
          FALSE, 'Add2AutoFreeEx', nil );
      end;
    end;

    // Здесь выполняется конструирование дочерних объектов - в первую очередь тех,
    // которые не имеют формального родителя, т.е. наследников KOL.TObj (в зеркале
    // - TKOLObj). Сначала конструируется главное меню, если оно есть на форме.
    // Если главное меню отсутствует, но есть хотя бы одно контекстное меню,
    // генерируется пустой объект главной формы - с тем, чтобы прочие меню автоматом
    // были контекстными.
    MainMenuPresent := False;
    PopupMenuPresent := False;
    for I := 0 to oc.Count - 1 do
    begin
      if TComponent( oc[ I ] ) is TKOLMainMenu then
      begin
        MainMenuPresent := True;
        KO := TComponent( oc[ I ] ) as TKOLObj;
        SL.Add( '' );
        KO.SetupFirst( SL, 'Result.' + KO.Name, Result_Form, '    ' );
        GenerateAdd2AutoFree( SL, 'Result.' + KO.Name, TRUE, '', KO );
        KO.AssignEvents( SL, 'Result.' + KO.Name );
      end
        else
      if TComponent( oc[ I ] ) is TKOLPopupMenu then
        PopupMenuPresent := True;
    end;

    if PopupMenuPresent and not MainMenuPresent and
       ClassNameIs( 'TKOLForm' ) then
    begin
      SL.Add( '    NewMenu( ' + Result_Form + ', 0, [ '''' ], nil );' );
    end;

    for I := 0 to oc.Count - 1 do
    begin
      if TComponent( oc[ I ] ) is TKOLMainMenu then continue;
      if TComponent( oc[ I ] ) is TKOLObj then
      begin
        KO := TComponent( oc[ I ] ) as TKOLObj;
        KO.fUpdated := FALSE;
        SL.Add( '' );
        KO.SetupFirst( SL, 'Result.' + KO.Name, Result_Form, '    ' );
        GenerateAdd2AutoFree( SL, 'Result.' + KO.Name, FALSE, '', KO );
        //SL.Add( '    Result.Form.Add2AutoFree( Result.' + KO.Name + ' );'  );
        KO.AssignEvents( SL, 'Result.' + KO.Name );
        if KO.fUpdated then
          Updated := TRUE;
      end;
    end;

    // Далее выполняется рекурсивный обход по дереву дочерних контролов и
    // генерация кода для них:
    GenerateChildren( SL, Self, Result_Form, '    ', Updated );

    // По завершении первоначальной генерации выполняется еще один просмотр
    // всех контролов и объектов формы, и для них выполняется SetupLast -
    // генерация кода, который должен выполниться на последнем этапе
    // инициализации (например, свойство CanResize присваивается False только
    // на этом этапе. Если это сделать раньше, то могут возникнуть проблемы
    // с изменением размеров окна в процессе настройки формы).
    for I := 0 to oc.Count - 1 do
    begin
      if TComponent( oc[ I ] ) is TKOLCustomControl then
      begin
        KC := TComponent( oc[ I ] ) as TKOLCustomControl;
        KC.SetupLast( SL, KC.RefName, Result_Form, '    ' );
      end
         else
      if TComponent( oc[ I ] ) is TKOLObj then
      begin
        KO := TComponent( oc[ I ] ) as TKOLObj;
        KO.SetupLast( SL, 'Result.' + KO.Name, Result_Form, '    ' );
      end;
    end;
    // Не забудем так же вызвать SetupLast для самой формы (можно было бы
    // всунуть код прямо сюда, но так будет легче потом сопровождать):
    SetupLast( SL, Result_Form, 'AParent', '    ' );

    SL.Add( '' );
    SL.Add( 'end;' );
    SL.Add( '' );

    {P := True;
    if KOLProject <> nil then
      P := KOLProject.ProtectFiles;}

    if ResStrings <> nil then
    begin
      for I := ResStrings.Count-1 downto 0 do
        SL.Insert( 1, ResStrings[ I ] );
    end;

    SaveStrings( SL, Path + '_1.inc', Updated );
    Result := True;

    except
      //++++++++++ { Maxim Pushkar } +++++++++
      on E: Exception do
      begin
        Rpt( 'EXCEPTION FOUND 9289: ' + E.Message);
        Rpt_Stack;
      end;
      //++++++++++++++++++++++++++++++++++++++
    end;

    SL.Free;

  FINALLY
    oc.Free;
  END;

  Sleep( 0 ); //**** THIS IS MUST ****
  { added in v0.84 to fix TKOLFrame, when TKOLCustomControl descendant component
    is dropped on TKOLFrame. }
  LogOK;
  finally
  Log( '<-TKOLForm.GenerateINC' );
  end;
end;

function TrimAll( const S: String ): String;
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TrimAll', 0
  @@e_signature:
  end;
  Result := S;
  for I := Length( Result ) downto 1 do
    if Result[ I ] <= ' ' then
      Delete( Result, I, 1 );
end;

function EqualWithoutSpaces( S1, S2: String ): Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'EqualWithoutSpaces', 0
  @@e_signature:
  end;
  S1 := TrimAll( LowerCase( S1 ) );
  S2 := TrimAll( LowerCase( S2 ) );
  Result := S1 = S2;
end;


function TKOLForm.GeneratePAS(const Path: String; var Updated: Boolean): Boolean;
const DefString = '{$DEFINE KOL_MCK}';
var SL: TStringList;        // строки результирующего PAS-файла
    Source: TStringList;    // исходный файл
    I, J, K: Integer;
    UsesFound, FormDefFound, ImplementationFound: Boolean;
    S, S1, S2: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GeneratePAS', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GeneratePAS' );
  try
  Rpt( 'Generating PAS for ' + Path ); //Rpt_Stack;
  Result := False;
  // +++ by Alexander Shakhaylo:
  if not fileexists(Path + '.pas') or FLocked then
  begin
     LogOK; exit;
  end;
  // ---
  SL := TStringList.Create;
  Source := TStringList.Create;

  try

  SL.Add( Signature );
  SL.Add( '{ uses.inc' );
  SL.Add( '  This file is generated automatically - do not modify it manually.' );
  SL.Add( '  It is included to be recognized by compiler, but replacing word ' );
  SL.Add( '  <uses> with compiler directive <$I uses.inc> fakes auto-completion' );
  SL.Add( '  preventing it from automatic references adding to VCL units into' );
  SL.Add( '  uses clause aimed for KOL environment only. }' );
  SL.Add( '' );
  SL.Add( 'uses' );
  {P := True;
  if KOLProject <> nil then
    P := KOLProject.ProtectFiles;}
  SaveStrings( SL, ExtractFilePath( Path ) + 'uses.inc', Updated );
  SL.Clear;

  LoadSource( Source, Path + '.pas' );
  for I := 0 to Source.Count- 1 do
    if Source[ I ] = Signature then
    begin
      Result := True;
      if (I < Source.Count - 1) and (Source[ I + 1 ] <> DefString) and
         (KOLProject <> nil) and KOLProject.IsKOLProject then
      begin
        Source.Insert( I + 1, DefString );
        SaveStrings( Source, Path + '.pas', Updated );
      end;
      break;
    end;

  if Result then
  begin
    // Test the Source - may be form is renamed...

    for I := Source.Count - 2 downto 0 do
    begin
      S := Trim( Source[ I ] );
      if StrEq( S, '{$I MCKfakeClasses.inc}' ) then
      if I < Source.Count - 5 then
      begin
        Source[ I + 1 ] :=
          '  {$IFDEF KOLCLASSES} T' + FormName + ' = class; P' + FormName + ' = T' + FormName + ';' +
          ' {$ELSE OBJECTS}' +
          ' P' + FormName + ' = ^T' + FormName + ';' +
          ' {$ENDIF CLASSES/OBJECTS}';
        Source[ I + 2 ] :=
          '  {$IFDEF KOLCLASSES}{$I T' + FormName +
          '.inc}{$ELSE} T' + FormName +
          ' = object(TObj) {$ENDIF}';
        S := ExtractFilePath( Path ) + 'T' + FormName + '.inc';
        if not FileExists( S ) then
        begin
          SaveStringToFile( S, 'T' + FormName + ' = class(TObj)' );
        end;
        Source[ I + 5 ] := '  T' + FormName + ' = class(TForm)';
        //////////////////////// by Alexander Shakhaylo //////////////////
        if pos('{$ENDIF', UpperCase( Source[ I + 6 ] ) ) <= 0 then      //
        begin                                                           //
           Source.Insert( I + 6, '{$ENDIF}' );                          //
        end;                                                            //
        //////////////////////////////////////////////////////////////////
      end;
      ////////////////////////////////////////////////////////////////////
      S := UpperCase( 'T' + FormName + ' = class(TForm)' );             //
      if pos( S, UpperCase( Source[ I ] ) ) > 0 then                    //
      begin                                                             //
        if pos( '{$ENDIF', Source[ I + 1 ] ) <= 0 then                  //
          Source.Insert( I + 1, '  {$ENDIF KOL_MCK}' );                 //
      end;                                                              //
      ////////////////////////////////////////////////////////////////////
      S := ' {$IFDEF KOL_MCK} : ';
      if pos( S, UpperCase( Trim( Source[ I ] ) ) ) > 0 then
      begin
        Source[ I ] := '  ' + FormName + ' {$IFDEF KOL_MCK} : P' + FormName +
                       ' {$ELSE} : T' + FormName + ' {$ENDIF} ;';
      end;
      S := 'procedure new';
      if (UpperCase( Trim( Source[ I ] ) ) = '{$IFDEF KOL_MCK}') and
         (
         (LowerCase( Copy( Trim( Source[ I + 1 ] ), 1, Length( S ) ) ) = S)
         or
         (LowerCase( Copy( Trim( Source[ I + 1 ] ), 1, Length( 'function new' ) ) ) = 'function new')
         ) then
      begin
         Source[ I + 1 ] := 'procedure New' + FormName + '( var Result: P' +
         FormName + '; AParent: PControl );';
         ///////////////////////////// by Alexander Shakhaylo /////////
         if pos( '{$ENDIF', UpperCase( Source[ I + 2 ] ) ) <= 0 then //
           Source.Insert( I + 2, '{$ENDIF}');                        //
         //////////////////////////////////////////////////////////////
      end;
      if (UpperCase( Trim( Source[ I ] ) ) = '{$IFDEF KOL_MCK}') then
        if StrIsStartingFrom( PChar((UpperCase( Trim( Source[ I + 2 ] ) ))),
           'PROCEDURE FREEOBJECTS_') then
        begin
          // remove artefact
          Source.Delete( I + 2 );
        end;
    end;


    // Convert old definitions to the new ones
    K := -1;
    for I := 0 to Source.Count-3 do
    begin
      S := Trim( Source[ I ] );
      if S = '{$ELSE not_KOL_MCK}' then
      begin
        K := I;
        break;
      end;
    end;

    if K < 0 then
    begin
      for I := 0 to Source.Count-3 do
      begin
        S := UpperCase( Trim( Source[ I ] ) );
        if StrIsStartingFrom( PChar( S ), '{$I MCKFAKECLASSES.INC}' ) then
        begin
          for J := I+1 to Source.Count-3 do
          begin
            S := UpperCase( Trim( Source[ J ] ) );
            if Copy( S, 1, 6 )  = '{$ELSE' then
            begin
              Source[ J ] := '  {$ELSE not_KOL_MCK}';
              break;
            end;
          end;
          break;
        end;
      end;
    end;

    // Make corrections when Delphi inserts declarations not at the good place:
    for I := 0 to Source.Count-3 do
    begin
      S := Trim( Source[ I ] );
      if S = '{$ELSE not_KOL_MCK}' then
      begin
        S := Trim( Source[ I + 2 ] );
        if S <> '{$ENDIF KOL_MCK}' then
        begin
          for J := I+1 to Source.Count-1 do
          begin
            S := UpperCase( Trim( Source[ J ] ) );
            if Copy( S, 1, 7 ) = '{$ENDIF' then
            begin
              Source.Delete( J );
              Source.Insert( I+2, '  {$ENDIF KOL_MCK}' );
              break;
            end;
          end;
        end;
        break;
      end;
    end;

    //Check for changes in 'uses' clause:
    I := -1;
    while I < Source.Count - 1 do
    begin
      Inc( I );

      if StrEq( Trim( Source[ I ] ), 'implementation' ) then break;

      if (pos( 'uses ', LowerCase( Trim( Source[ I ] ) + ' ' ) ) = 1) then
      begin
        S := '';
        for J := I to Source.Count - 1 do
        begin
          S := S + Source[ J ];
          if pos( ';', Source[ J ] ) > 0 then
            break;
        end;

        S1 := 'uses Windows, Messages, ShellAPI, KOL' + AdditionalUnits;
        S2 := Parse( S, '{' ); S := '{' + S;
        if not EqualWithoutSpaces( S1, S2 ) then
        begin

          (*
          ShowMessage( 'Not equal:'#13#10 +
                       TrimAll( S1 ) + #13#10 +
                       TrimAll( S2 ) );
          *)

          repeat
            S1 := Source[ I ];
            Source.Delete( I );
          until pos( ';', S1 ) > 0;

          Source.Insert( I,
           'uses Windows, Messages, ShellAPI, KOL' + AdditionalUnits + ' ' +
           S );

        end;

        break;
      end;
    end;

    AfterGeneratePas( Source );
    SaveStrings( Source, Path + '.pas', Updated );

    SL.Free;
    Source.Free;
    LogOK;
    Exit;
  end;

  // Step 1. If unit is not yet prepared for working both
  // in KOL and VCL, then prepare it now.
  K := 0;
  for I := 0 to Source.Count - 1 do
    if pos( Signature, Source[ I ] ) > 0 then
    begin
      Inc( K );
      break;
    end;
  if K = 0 then
  begin
    UsesFound := False;
    FormDefFound := False;
    ImplementationFound := False;
    try
      SL.Add( Signature );
      for I := 0 to Source.Count - 1 do
      begin
        if pos( '{$r *.dfm}', LowerCase( Source[ I ] ) ) > 0 then
        begin
          Source[ I ] := '{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}';
          break;
        end;
      end;
      I := -1;
      while I < Source.Count - 1 do
      begin
        Inc( I );
        if not ImplementationFound then
        if not UsesFound and
           (pos( 'uses ', LowerCase( Trim( Source[ I ] ) + ' ' ) ) = 1) then
        begin
          UsesFound := True;
          SL.Add( '{$IFDEF KOL_MCK}' );
          SL.Add( 'uses Windows, Messages, ShellAPI, KOL' + AdditionalUnits + ' ' +
                  '{$IFNDEF KOL_MCK}, mirror, Classes, Controls, mckControls, ' +
                  'mckObjs, Graphics {$ENDIF};' );
          SL.Add( '{$ELSE}' );
          SL.Add( '{$I uses.inc}' + Copy( Source[ I ], 5, Length( Source[ I ] ) - 4 ) );
          Inc( I );
          if pos( ';', Source[ I - 1 ] ) < 1 then
          repeat
            SL.Add( Source[ I ] );
            Inc( I );
          until pos( ';', Source[ I - 1 ] ) > 0;
          SL.Add( '{$ENDIF}' );
          Dec( I );
          Continue;
        end;
        if not FormDefFound and
           (pos( LowerCase( 'T' + FormName + ' = class(TForm)' ),
                LowerCase( Source[ I ] ) ) > 0) then
        begin
          FormDefFound := True;
          SL.Add( '  {$IFDEF KOL_MCK}' );
          S := '  {$I MCKfakeClasses.inc}';
          SL.Add( S );
          SL.Add( '  {$IFDEF KOLCLASSES} T' + FormName +
          ' = class; P' + FormName + ' = T' + FormName + ';' +
          ' {$ELSE OBJECTS}' +
          ' P' + FormName + ' = ^T' + FormName + ';' +
          ' {$ENDIF CLASSES/OBJECTS}' );
          SL.Add( '  {$IFDEF KOLCLASSES}{$I T' + FormName +
          '.inc}{$ELSE} T' + FormName +
          ' = object(TObj) {$ENDIF}' );
          SL.Add( '    Form: ' + FormTypeName + ';' );
          SL.Add( '  {$ELSE not_KOL_MCK}' );
          SL.Add( Source[ I ] );
          SL.Add( '  {$ENDIF KOL_MCK}' );
          Continue;
        end;
        if not ImplementationFound then
        begin
          if LowerCase( Trim( Source[ I ] ) ) =
             LowerCase( FormName + ': T' + FormName + ';' ) then
          begin
            SL.Add( '  ' + FormName + ' {$IFDEF KOL_MCK} : P' + FormName +
                    ' {$ELSE} : T' + FormName + ' {$ENDIF} ;' );
            Continue;
          end;
        end;
        if not ImplementationFound and
           (pos( 'implementation', LowerCase( Source[ I ] ) ) > 0 ) then
        begin
          SL.Add( '{$IFDEF KOL_MCK}' );
          SL.Add( 'procedure New' + FormName + '( var Result: P' + FormName +
                  '; AParent: PControl );' );
          SL.Add( '{$ENDIF}' );
          SL.Add( '' );

          ImplementationFound := True;
          SL.Add( Source[ I ] );
          while True do
          begin
            Inc( I );
            if pos( 'uses ', LowerCase( Source[ I ] + ' ' ) ) > 0 then
            begin
              SL.Add( Source[ I ] );
              if pos( ';', Source[ I ] ) < 1 then
              begin
                repeat
                  Inc( I );
                  SL.Add( Source[ I ] );
                until pos( ';', Source[ I ] ) > 0;
              end;
              ImplementationFound := False;
              break;
            end
               else
            if (Trim( Source[ I ] ) <> '') and (Trim( Source[ I ] )[ 1 ] <> '{') then
              break;
            SL.Add( Source[ I ] );
          end;
          if not ImplementationFound then
            SL.Add( '' );
          SL.Add( '{$IFDEF KOL_MCK}' );
          SL.Add( '{$I ' + FormUnit + '_1.inc}' );
          SL.Add( '{$ENDIF}' );
          if ImplementationFound then
          begin
            SL.Add( '' );
            SL.Add( Source[ I ] );
          end;
          ImplementationFound := True;
          Continue;
        end;
        SL.Add( Source[ I ] );
      end;
    except
      ImplementationFound := False;
    end;
    if not UsesFound or not FormDefFound or not ImplementationFound then
    begin
      SL.Free;
      Source.Free;
      S := '';
      if not UsesFound then
        S := 'Uses not found'#13;
      if not FormDefFound then
        S := S + 'Form definition not found'#13;
      if not ImplementationFound then
        S := S + 'Implementation section not found'#13;
      ShowMessage( 'Error converting ' + FormUnit + ' unit to KOL:'#13 + S );
      LogOK;
      Exit;
    end;

    AfterGeneratePas( SL );
    SaveStrings( SL, Path + '.pas', Updated );
  end;

  Result := True;
  except
    Rpt( '**************** Unknown Exception - supressed' );
  end;

  SL.Free;
  Source.Free;
  LogOK;
  finally
  Log( '<-TKOLForm.GeneratePAS' );
  end;
end;

function TKOLForm.GenerateTransparentInits: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GenerateTransparentInits', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GenerateTransparentInits' );
  try
  Result := '';
  if not FLocked then
  begin

    //Log( '#1 TKOLForm.GenerateTransparentInits' );

    if not DefaultPosition then
    begin
      //Log( '#1.A TKOLForm.GenerateTransparentInits' );

      if not DoNotGenerateSetPosition then
      begin
        //Log( '#1.B TKOLForm.GenerateTransparentInits' );
        if FBounds <> nil then
          Result := '.SetPosition( ' + IntToStr( Bounds.Left ) + ', ' +
                    IntToStr( Bounds.Top ) + ' )';
        //Log( '#1.C TKOLForm.GenerateTransparentInits' );
      end;

      //Log( '#1.D TKOLForm.GenerateTransparentInits' );
    end;

    //Log( '#2 TKOLForm.GenerateTransparentInits' );

    if not DefaultSize then
    begin
      if {CanResize or} (Owner = nil) or not(Owner is TForm) then
        if HasCaption then
          Result := Result + '.SetSize( ' + IntToStr( Bounds.Width ) + ', ' +
                  IntToStr( Bounds.Height ) + ' )'
        else
          Result := Result + '.SetSize( ' + IntToStr( Bounds.Width ) + ', ' +
                  IntToStr( Bounds.Height-GetSystemMetrics(SM_CYCAPTION) ) + ' )'
      else
        if HasCaption then
          Result := Result + '.SetClientSize( ' + IntToStr( (Owner as TForm).ClientWidth ) +
                 ', ' + IntToStr( (Owner as TForm).ClientHeight ) + ' )'
        //+++++++ UaFM
        else
          Result := Result + '.SetClientSize( ' + IntToStr( (Owner as TForm).ClientWidth ) +
                 ', ' + IntToStr( (Owner as TForm).ClientHeight-GetSystemMetrics(SM_CYCAPTION) )
                 + ')'
    end;

    //Log( '#3 TKOLForm.GenerateTransparentInits' );

    if Tabulate then
      Result := Result + '.Tabulate'
    else
    if TabulateEx then
      Result := Result + '.TabulateEx';

    //Log( '#4 TKOLForm.GenerateTransparentInits' );

    {if AllBtnReturnClick then
      Result := Result + '.AllBtnReturnClick';}

    if PreventResizeFlicks then
      Result := Result + '.PreventResizeFlicks';

    //Log( '#5 TKOLForm.GenerateTransparentInits' );

    if supportMnemonics then
      Result := Result + '.SupportMnemonics';

    //Log( '#6 TKOLForm.GenerateTransparentInits' );

    if HelpContext <> 0 then
      Result := Result + '.AssignHelpContext( ' + IntToStr( HelpContext ) + ' )';
  end;

  //Log( '#7 TKOLForm.GenerateTransparentInits' );

  LogOK;
  finally
  Log( '<-TKOLForm.GenerateTransparentInits' );
  end;
end;

function TKOLForm.GenerateUnit(const Path: String): Boolean;
var PAS, INC: Boolean;
    Updated, PasUpdated, IncUpdated: Boolean;
    I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GenerateUnit', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GenerateUnit' );
  try
  Result := False;

  if not FLocked then
  begin
    for I := 0 to Owner.ComponentCount-1 do
    begin
      C := Owner.Components[ I ];
      if IsVCLControl( C ) then
      begin
        FLocked := TRUE;
        ShowMessage( 'Form ' + Owner.Name + ' contains VCL controls and can not ' +
                     'be converted to KOL form properly. TKOLForm component is locked. ' +
                     'Remove VCL controls first, then unlock TKOLForm component.' );
        LogOK;
        Exit;
      end;
    end;

    fUniqueID := 5000;
    Rpt( '*************** UNIQUE ID = ' + IntToStr( fUniqueID ) );
    if FormUnit = '' then
    begin
      Rpt( 'Error: FormUnit = ''''' );
      LogOK;
      Exit;
    end;

    PasUpdated := FALSE;
    IncUpdated := FALSE;
    PAS := GeneratePAS( Path, PasUpdated );
    INC := GenerateINC( Path, IncUpdated );
    Updated := PasUpdated or IncUpdated;
    Result := PAS and INC;
    if Result and Updated then
    begin
      // force mark modified here
      if PasUpdated then
        MarkModified( Path + '.pas' );
      if IncUpdated then
      begin
        MarkModified( Path + '_1.inc' );
        UpdateUnit( Path + '_1.inc' );
      end;
    end;
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.GenerateUnit' );
  end;
end;

function TKOLForm.GetCaption: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GetCaption', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GetCaption' );
  try
  Result := FCaption;
  if (Owner <> nil) and (Owner is TForm) then
    Result := (Owner as TForm).Caption;
  LogOK;
  finally
  Log( '<-TKOLForm.GetCaption' );
  end;
end;

function TKOLForm.GetFormMain: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GetFormMain', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GetFormMain' );
  try
  Result := fFormMain;
  if KOLProject <> nil then
    Result := KOLProject.Owner = Owner;
  LogOK;
  finally
  Log( '<-TKOLForm.GetFormMain' );
  end;
end;

function TKOLForm.GetFormName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GetFormName', 0
  @@e_signature:
  end;
  //Log( '->TKOLForm.GetFormName' );
  try
  Result := '';
  if Owner <> nil then
    Result := Owner.Name;
  LogOK;
  finally
  //Log( '<-TKOLForm.GetFormName' );
  end;
end;

var LastSrcLocatedWarningTime: Integer;

function TKOLForm.GetFormUnit: String;
var
    I, J: Integer;
    S, S1, S2: String;
    Dpr: TStringList;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GetFormUnit', 0
  @@e_signature:
  end;
  //Log( '->TKOLForm.GetFormUnit' );
  try
  Result := fFormUnit;
  if Result = '' then
  if ProjectSourcePath <> '' then
  begin
    S := ProjectSourcePath;
    if S[ Length( S ) ] <> '\' then
      S := S + '\';
    S1 := S;
    S := S + Get_ProjectName + '.dpr';
    if FileExists( S ) then
    begin
      Dpr := TStringList.Create;
      LoadSource( Dpr, S );
      for I := 0 to Dpr.Count - 1 do
      begin
        S := Trim( Dpr[ I ] );
        J := pos( '{' + LowerCase( FormName ) + '}', LowerCase( S ) );
        if (J > 0) and (pos( '''', S ) > 0) then
        begin
          J := pos( '''', S );
          S := Copy( S, J + 1, Length( S ) - J );
          J := pos( '''', S );
          if J > 0 then
          begin
            S := Copy( S, 1, J - 1 );
            if pos( ':', S ) < 1 then
              S := S1 + S;
            S2 := ExtractFilePath( S );
            S := ExtractFileName( S );
            if (S2 <> '') and (LowerCase( S2 ) <> LowerCase( S1 )) then
            begin
              if Abs( Integer( GetTickCount ) - LastSrcLocatedWarningTime ) > 60000 then
              begin
                LastSrcLocatedWarningTime := GetTickCount;
                ShowMessage( 'Source unit ' + S + ' is located not in the same ' +
                             'directory as SourcePath of TKOLProject component. ' +
                             'This can cause problems with converting project.' );
              end;
              //LogOK;
              Exit;
            end;
            J := pos( '.', S );
            if J > 0 then S := Copy( S, 1, J - 1 );
            Result := S;
            fFormUnit := S;
            //LogOK;
            Exit;
          end;
        end;
      end;
      Dpr.Free;
    end;
  end;
  //LogOK;
  finally
  //Log( '<-TKOLForm.GetFormUnit' );
  end;
end;

function TKOLForm.GetSelf: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GetSelf', 0
  @@e_signature:
  end;
  Result := Self;
end;

function TKOLForm.Get_Color: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.Get_Color', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.Get_Color' );
  try
  Result := (Owner as TForm).Color;
  LogOK;
  finally
  Log( '<-TKOLForm.Get_Color' );
  end;
end;

procedure TKOLForm.SetAlphaBlend(Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetAlphaBlend', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetAlphaBlend' );
  try
  if not FLocked then
  begin
    if not (csLoading in ComponentState) then
      if Value = 0 then Value := 256;
    if Value < 0 then Value := 255;
    if Value > 256 then Value := 256;
    FAlphaBlend := Value;
    Change( Self );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetAlphaBlend' );
  end;
end;

procedure TKOLForm.SetCanResize(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetCanResize', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetCanResize' );
  try
  if not FLocked then
  begin
    fCanResize := Value;
  {YS}
    if (FborderStyle = fbsDialog) and Value then
      FborderStyle := fbsSingle;
  {YS}
    Change( Self );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetCanResize' );
  end;
end;

procedure TKOLForm.SetCenterOnScr(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetCenterOnScr', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetCenterOnScr' );
  try
  if not FLocked then
  begin
    fCenterOnScr := Value;
    Change( Self );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetCenterOnScr' );
  end;
end;

procedure TKOLForm.SetCloseIcon(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetCloseIcon', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetCloseIcon' );
  try
  if not FLocked then
  begin
    FCloseIcon := Value;
    Change( Self );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetCloseIcon' );
  end;
end;

procedure TKOLForm.SetCtl3D(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetCtl3D', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetCtl3D' );
  try
  if not FLocked then
  begin
    FCtl3D := Value;
    (Owner as TForm).Ctl3D := Value;
    (Owner as TForm).Invalidate;
    Change( Self );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetCtl3D' );
  end;
end;

procedure TKOLForm.SetCursor(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetCursor', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetCursor' );
  try
  if not FLocked then
  begin
    FCursor := UpperCase( Value );
    Change( Self );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetCursor' );
  end;
end;

procedure TKOLForm.SetDefaultPos(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetDefaultPos', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetDefaultPos' );
  try
  if not FLocked then
  begin
    fDefaultPos := Value;
    Change( Self );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetDefaultPos' );
  end;
end;

procedure TKOLForm.SetDefaultSize(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetDefaultSize', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetDefaultSize' );
  try
  if not FLocked then
  begin
    fDefaultSize := Value;
    Change( Self );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetDefaultSize' );
  end;
end;

procedure TKOLForm.SetDoubleBuffered(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetDoubleBuffered', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetDoubleBuffered' );
  try

  if not FLocked then
  begin
    FDoubleBuffered := Value;
    Change( Self );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetDoubleBuffered' );
  end;
end;

procedure TKOLForm.SetFont(const Value: TKOLFont);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetFont', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetFont' );
  try

  if not FLocked and not fFont.Equal2( Value ) then
  begin
    CollectChildrenWithParentFont;
    fFont.Assign( Value );
    ApplyFontToChildren;
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetFont' );
  end;
end;

procedure TKOLForm.SetFormCaption(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetFormCaption', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetFormCaption' );
  try

  if not FLocked then
  begin
    inherited Caption := Value;
    if (Owner <> nil) and (Owner is TForm) then
      (Owner as TForm).Caption := Value;
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetFormCaption' );
  end;
end;

procedure TKOLForm.SetFormMain(const Value: Boolean);
var I: Integer;
    F: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetFormMain', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetFormMain' );
  try

  if not FLocked then
  begin

    if fFormMain <> Value then
    begin
      if Value then
      begin
        for I := 0 to FormsList.Count - 1 do
        begin
          F := FormsList[ I ];
          if F <> Self then
            F.FormMain := False;
        end;
      end;
      fFormMain := Value;
      Change( Self );
    end;

  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetFormMain' );
  end;
end;

procedure TKOLForm.SetFormName(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetFormName', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetFormName' );
  try

  if not FLocked then
  begin

    if KOLProject = nil then
    if (Value <> FormName) and (Value <> '') and (FormName <> '') then
    begin
      ShowMessage( 'Form name can not be changed properly, if main form (form with ' +
                   'TKOLProject component on it) is not opened in designer.'#13 +
                   'Operation failed.' );
      LogOK;
      Exit;
    end;
    if Owner <> nil then
    try
      Owner.Name := Value;
      Change( Self );
    except
      ShowMessage( 'Name "' + Value + '" can not be used as a name for form '+
                   'variable. Use another one, please.' );
      LogOK;
      exit;
    end;

  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetFormName' );
  end;
end;


procedure TKOLForm.SetFormUnit(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetFormUnit', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetFormUnit' );
  try

  if not FLocked then
  begin
    fFormUnit := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetFormUnit' );
  end;
end;

procedure TKOLForm.SetHasBorder(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetHasBorder', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetHasBorder' );
  try

  if not FLocked then
  begin
    FHasBorder := Value;
  {YS}
    if not Value then
      FborderStyle := fbsNone
    else
      if FborderStyle = fbsNone then
        FborderStyle := fbsSingle;
  {YS}
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetHasBorder' );
  end;
end;

procedure TKOLForm.SetHasCaption(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetHasCaption', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetHasCaption' );
  try

  if not FLocked then
  begin
    FHasCaption := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetHasCaption' );
  end;
end;

procedure TKOLForm.SetIcon(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetIcon', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetIcon' );
  try

  if not FLocked then
  begin
    FIcon := UpperCase( Value );
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetIcon' );
  end;
end;

procedure TKOLForm.SetMargin(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetMargin', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetMargin' );
  try

  if not FLocked then
  begin
    if fMargin <> Value then
    begin
      fMargin := Value;
      AlignChildren( nil, FALSE );
      Change( Self );
    end;
    // Invalidate;
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetMargin' );
  end;
end;

procedure TKOLForm.SetMaximizeIcon(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetMaximizeIcon', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetMaximizeIcon' );
  try

  if not FLocked then
  begin
    FMaximizeIcon := Value;
    if Value then
      helpContextIcon := FALSE;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetMaximizeIcon' );
  end;
end;

procedure TKOLForm.SetMinimizeIcon(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetMinimizeIcon', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetMinimizeIcon' );
  try

  if not FLocked then
  begin
    FMinimizeIcon := Value;
    if Value then
      helpContextIcon := FALSE;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetMinimizeIcon' );
  end;
end;

procedure TKOLForm.SetModalResult(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetModalResult', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetModalResult' );
  try

  if not FLocked then
    FModalResult := Value;

  LogOK;
  finally
  Log( '<-TKOLForm.SetModalResult' );
  end;
end;

procedure TKOLForm.SetOnChar(const Value: TOnChar);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnChar', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnChar' );
  try

  if not FLocked then
  begin
    FOnChar := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnChar' );
  end;
end;

procedure TKOLForm.SetOnClick(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnClick', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnClick' );
  try

  if not FLocked then
  begin
    fOnClick := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnClick' );
  end;
end;

procedure TKOLForm.SetOnFormCreate(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnFormCreate', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnFormCreate' );
  try

  if not FLocked then
  begin
    FOnFormCreate := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnFormCreate' );
  end;
end;

procedure TKOLForm.SetOnEnter(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnEnter', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnEnter' );
  try

  if not FLocked then
  begin
    FOnEnter := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnEnter' );
  end;
end;

procedure TKOLForm.SetOnKeyDown(const Value: TOnKey);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnKeyDown', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnKeyDown' );
  try

  if not FLocked then
  begin
    FOnKeyDown := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnKeyDown' );
  end;
end;

procedure TKOLForm.SetOnKeyUp(const Value: TOnKey);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnKeyUp', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnKeyUp' );
  try

  if not FLocked then
  begin
    FOnKeyUp := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnKeyUp' );
  end;
end;

procedure TKOLForm.SetOnLeave(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnLeave', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnLeave' );
  try

  if not FLocked then
  begin
    FOnLeave := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnLeave' );
  end;
end;

procedure TKOLForm.SetOnMouseDown(const Value: TOnMouse);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnMouseDown', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnMouseDown' );
  try

  if not FLocked then
  begin
    FOnMouseDown := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnMouseDown' );
  end;
end;

procedure TKOLForm.SetOnMouseEnter(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnMouseEnter', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnMouseEnter' );
  try

  if not FLocked then
  begin
    FOnMouseEnter := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnMouseEnter' );
  end;
end;

procedure TKOLForm.SetOnMouseLeave(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnMouseLeave', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnMouseLeave' );
  try

  if not FLocked then
  begin
    FOnMouseLeave := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnMouseLeave' );
  end;
end;

procedure TKOLForm.SetOnMouseMove(const Value: TOnMouse);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnMouseMove', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnMouseMove' );
  try

  if not FLocked then
  begin
  FOnMouseMove := Value;
  Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnMouseMove' );
  end;
end;

procedure TKOLForm.SetOnMouseUp(const Value: TOnMouse);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnMouseUp', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnMouseUp' );
  try

  if not FLocked then
  begin
  FOnMouseUp := Value;
  Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnMouseUp' );
  end;
end;

procedure TKOLForm.SetOnMouseWheel(const Value: TOnMouse);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnMouseWheel', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnMouseWheel' );
  try

  if not FLocked then
  begin
  FOnMouseWheel := Value;
  Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnMouseWheel' );
  end;
end;

procedure TKOLForm.SetOnResize(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnResize', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnResize' );
  try

  if not FLocked then
  begin
  FOnResize := Value;
  Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnResize' );
  end;
end;

procedure TKOLForm.SetPreventResizeFlicks(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetPreventResizeFlicks', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.PreventResizeFlicks' );
  try

  if not FLocked then
  begin
  FPreventResizeFlicks := Value;
  Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.PreventResizeFlicks' );
  end;
end;

procedure TKOLForm.SetStayOnTop(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetStayOnTop', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetStayOnTop' );
  try

  if not FLocked then
  begin
  FStayOnTop := Value;
  Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetStayOnTop' );
  end;
end;

procedure TKOLForm.SetTransparent(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetTransparent', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetTransparent' );
  try

  if not FLocked then
  begin
  FTransparent := Value;
  Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetTransparent' );
  end;
end;

const BrushStyles: array[ TBrushStyle ] of String = ( 'bsSolid', 'bsClear',
      'bsHorizontal', 'bsVertical', 'bsFDiagonal', 'bsBDiagonal', 'bsCross',
      'bsDiagCross' );
procedure TKOLForm.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
const WindowStates: array[ KOL.TWindowState ] of String = ( 'wsNormal',
      'wsMinimized', 'wsMaximized' );
var I: Integer;
    S: string; {YS}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetupFirst', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetupFirst' );
  try

  if FLocked then
  begin
    LogOK;
    Exit;
  end;

  // Установка каких-либо свойств формы - тех, которые выполняются
  // сразу после конструирования объекта формы:
  if Name <> '' then
  begin
    SL.Add( '   {$IFDEF USE_NAMES}' );
    SL.Add( Prefix + AName + '.Name := ''' + Owner.Name + ''';' );
    SL.Add( '   {$ENDIF}' );
  end;
  if Tag <> 0 then
  begin
    if Tag < 0 then
      SL.Add( Prefix + AName + '.Tag := DWORD(' + Int2Str( Tag ) + ');' )
    else
      SL.Add( Prefix + AName + '.Tag := ' + Int2Str( Tag ) + ';' );
  end;

  //Log( '&2 TKOLForm.SetupFirst' );

  if not statusSizeGrip then
  //if (StatusText.Count > 0) or (SimpleStatusText <> '') then
    SL.Add( Prefix + AName + '.SizeGrip := FALSE;' );

  //Log( '&3 TKOLForm.SetupFirst' );

{YS}
  S := '';
  case FborderStyle of
    fbsDialog:
      S := S + ' or WS_EX_DLGMODALFRAME or WS_EX_WINDOWEDGE';
    fbsToolWindow:
      S := S + ' or WS_EX_TOOLWINDOW';
  end;

  //Log( '&4 TKOLForm.SetupFirst' );

  if helpContextIcon then
    S := S + ' or WS_EX_CONTEXTHELP';
  if S <> '' then
    SL.Add( Prefix + AName + '.ExStyle := ' + AName + '.ExStyle' + S + ';' );

  //Log( '&5 TKOLForm.SetupFirst' );

{YS}
  {if helpContextIcon then
    SL.Add( Prefix + AName + '.ExStyle := ' + AName + '.ExStyle or WS_EX_CONTEXTHELP;' );}
  if not Visible then
    SL.Add( Prefix + AName + '.Visible := False;' );
  if not Enabled then
    SL.Add( Prefix + AName + '.Enabled := False;' );
  if DoubleBuffered and not Transparent then
    SL.Add( Prefix + AName + '.DoubleBuffered := True;' );
{YS}

  //Log( '&6 TKOLForm.SetupFirst' );

  S := '';
  case FborderStyle of
    fbsDialog:
      S := S + ' and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX)';
    fbsToolWindow, fbsNone:
      ;
    else
      begin
        if not MinimizeIcon and not MaximizeIcon then
          S := S + ' and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX)'
        else
        begin
          if not MinimizeIcon then
            S := S + ' and not WS_MINIMIZEBOX';
          if not MaximizeIcon then
            S := S + ' and not WS_MAXIMIZEBOX';
        end;
      end;
  end;

  //Log( '&7 TKOLForm.SetupFirst' );

  if S <> '' then
    SL.Add( Prefix + AName + '.Style := ' + AName + '.Style' + S + ';' );

  //Log( '&8 TKOLForm.SetupFirst' );

{YS}

  if Transparent then
    SL.Add( Prefix + AName + '.Transparent := True;' );

  if (AlphaBlend <> 255) and (AlphaBlend > 0) then
    SL.Add( Prefix + AName + '.AlphaBlend := ' + IntToStr( AlphaBlend and $FF ) + ';' );

  if not HasBorder then
    SL.Add( Prefix + AName + '.HasBorder := False;' );

  if not HasCaption and HasBorder then
    SL.Add( Prefix + AName + '.HasCaption := False;' );

  if StayOnTop then
    SL.Add( Prefix + AName + '.StayOnTop := True;' );

  if not Ctl3D then
    SL.Add( Prefix + AName + '.Ctl3D := False;' );

  if Icon <> '' then
  begin
    if Copy( Icon, 1, 1 ) = '#' then // +Alexander Pravdin
      SL.Add( Prefix + AName + '.IconLoad( hInstance, MAKEINTRESOURCE( ' +
        Copy( Icon, 2, Length( Icon ) - 1 ) + ' ) );' )
    else
    if Copy( Icon, 1, 4 ) = 'IDI_' then
      SL.Add( Prefix + AName + '.IconLoad( 0, ' + Icon + ' );' )
    else
    if Copy( Icon, 1, 4 ) = 'IDC_' then
      SL.Add( Prefix + AName + '.IconLoadCursor( 0, ' + Icon + ' );' )
    else
    if Icon = '-1' then
      SL.Add( Prefix + AName + '.Icon := THandle(-1);' )
    else
      SL.Add( Prefix + AName + '.IconLoad( hInstance, ''' + Icon + ''' );' );
  end;

  if WindowState <> KOL.wsNormal then
    SL.Add( Prefix + AName + '.WindowState := ' + WindowStates[ WindowState ] +
            ';' );

  if Trim( Cursor ) <> '' then
  begin
    if Copy( Cursor, 1, 4 ) = 'IDC_' then
      SL.Add( Prefix + AName + '.CursorLoad( 0, ' + Cursor + ' );' )
    else
      SL.Add( Prefix + AName + '.CursorLoad( hInstance, ''' + Trim( Cursor ) + ''' );' );
  end;

  if Brush <> nil then
    Brush.GenerateCode( SL, AName );

  if (Font <> nil) AND not Font.Equal2( nil ) then
    Font.GenerateCode( SL, AName, nil );

  if Border <> 2 then
    SL.Add( Prefix + AName + '.Border := ' + IntToStr( Border ) + ';' );

  if MarginTop <> 0 then
    SL.Add( Prefix + AName + '.MarginTop := ' + IntToStr( MarginTop ) + ';' );

  if MarginBottom <> 0 then
    SL.Add( Prefix + AName + '.MarginBottom := ' + IntToStr( MarginBottom ) + ';' );

  if MarginLeft <> 0 then
    SL.Add( Prefix + AName + '.MarginLeft := ' + IntToStr( MarginLeft ) + ';' );

  if MarginRight <> 0 then
    SL.Add( Prefix + AName + '.MarginRight := ' + IntToStr( MarginRight ) + ';' );

  if (FStatusText <> nil) and (FStatusText.Text <> '') then
  begin
    if FStatusText.Count = 1 then
      SL.Add( Prefix + AName + '.SimpleStatusText := ' + PCharStringConstant( Self, 'SimpleStatusText', FStatusText[ 0 ] ) + ';' )
    else
    begin
      for I := 0 to FStatusText.Count-1 do
        SL.Add( Prefix + AName + '.StatusText[ ' + IntToStr( I ) + ' ] := ' +
                PCharStringConstant( Self, 'StatusText' + IntToStr( I ), FStatusText[ I ] ) + ';' );
    end;
  end;

  if not CloseIcon then
  begin
    SL.Add( Prefix + 'DeleteMenu( GetSystemMenu( Result.Form.GetWindowHandle, ' +
            'False ), SC_CLOSE, MF_BYCOMMAND );' );
  end;

  AssignEvents( SL, AName );

  if EraseBackground then
    SL.Add( Prefix + AName + '.EraseBackground := TRUE;' );

  if MinWidth > 0 then
    SL.Add( Prefix + AName + '.MinWidth := ' + IntToStr( MinWidth ) + ';' );

  if MinHeight > 0 then
    SL.Add( Prefix + AName + '.MinHeight := ' + IntToStr( MinHeight ) + ';' );

  if MaxWidth > 0 then
    SL.Add( Prefix + AName + '.MaxWidth := ' + IntToStr( MaxWidth ) + ';' );

  if MaxHeight > 0 then
    SL.Add( Prefix + AName + '.MaxHeight := ' + IntToStr( MaxHeight ) + ';' );

  LogOK;
  finally
  Log( '<-TKOLForm.SetupFirst' );
  end;
end;

procedure TKOLForm.SetupLast(SL: TStringList; const AName,
  AParent, Prefix: String);
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetupLast', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetupLast' );
  try

  if not FLocked then
  begin
    S := '';
    if CenterOnScreen then
      S := Prefix + AName + '.CenterOnParent';
    if not CanResize then
    begin
      if S = '' then
        S := Prefix + AName;
      S := S + '.CanResize := False';
    end;
    if S <> '' then
      SL.Add( S + ';' );
    if MinimizeNormalAnimated then
      SL.Add( Prefix + AName + '.MinimizeNormalAnimated;' );
    if Assigned( FpopupMenu ) then
      SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
              ' );' );
    if @ OnFormCreate <> nil then
    begin
      SL.Add( Prefix + 'Result.' + (Owner as TForm).MethodName( @ OnFormCreate ) + '( Result );' );
    end;
  {YS}
    if FborderStyle = fbsDialog then
      SL.Add( Prefix + AName + '.Icon := THandle(-1);' );
  {YS}
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetupLast' );
  end;
end;

procedure TKOLForm.SetWindowState(const Value: KOL.TWindowState);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetWindowState', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetWindowState' );
  try

  if not FLocked then
  begin
  FWindowState := Value;
  Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetWindowState' );
  end;
end;

procedure TKOLForm.Set_Color(const Value: TColor);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.Set_Color', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.Set_Color' );
  try

  if not FLocked then
  begin
    if Color <> Value then
    begin
    CollectChildrenWithParentColor;
    (Owner as TForm).Color := Value;
    FBrush.FColor := Value;
    ApplyColorToChildren;
    Change( Self );
    end;
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.Set_Color' );
  end;
end;

procedure TKOLForm.ApplyFontToChildren;
var I: Integer;
    C: TKOLCustomControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.ApplyFontToChildren', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.ApplyFontToChildren' );
  try

  if not FLocked then
  begin
  for I := 0 to FParentLikeFontControls.Count - 1 do
  begin
    C := FParentLikeFontControls[ I ];
    //if C.parentFont then
      C.Font.Assign( Font );
  end;
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.ApplyFontToChildren' );
  end;
end;

procedure TKOLForm.CollectChildrenWithParentFont;
var ParentForm: TForm;
    I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.CollectChildrenWithParentFont', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.CollectChildrenWithParentFont' );
  try

  if not (Owner is TForm) then
  begin
    LogOK;
    Exit;
  end;
  ParentForm := Owner as TForm;
  FParentLikeFontControls.Clear;
  for I := 0 to ParentForm.ComponentCount - 1 do
  begin
    C := ParentForm.Components[ I ];
    if (C is TKOLCustomControl) and ((C as TKOLCustomControl).Parent = ParentForm) then
    if (C as TKOLCustomControl).parentFont then
      FParentLikeFontControls.Add( C );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.CollectChildrenWithParentFont' );
  end;
end;

procedure TKOLForm.ApplyColorToChildren;
var I: Integer;
    C: TKOLCustomControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.ApplyColorToChildren', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.ApplyColorToChildren' );
  try

  if not FLocked then
  begin
    for I := 0 to FParentLikeColorControls.Count - 1 do
    begin
      C := FParentLikeColorControls[ I ];
      //if C.parentColor then
        C.Color := Color;
    end;
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.ApplyColorToChildren' );
  end;
end;

procedure TKOLForm.CollectChildrenWithParentColor;
var ParentForm: TForm;
    I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.CollectChildrenWithParentFont', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.CollectChildrenWithParentColor' );
  try

  if not (Owner is TForm) then
  begin
    LogOK;
    Exit;
  end;
  ParentForm := Owner as TForm;
  FParentLikeColorControls.Clear;
  for I := 0 to ParentForm.ComponentCount - 1 do
  begin
    C := ParentForm.Components[ I ];
    if (C is TKOLCustomControl) and ((C as TKOLCustomControl).Parent = ParentForm) then
    if (C as TKOLCustomControl).parentColor then
      FParentLikeColorControls.Add( C );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.CollectChildrenWithParentColor' );
  end;
end;

function TKOLForm.NextUniqueID: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.NextUniqueID', 0
  @@e_signature:
  end;
  //Log( '->TKOLForm.NextUniqueID' );
  try

  Result := fUniqueID;
  Inc( fUniqueID );

  LogOK;
  finally
  //Log( '<-TKOLForm.NextUniqueID' );
  end;
end;

procedure TKOLForm.SetMinimizeNormalAnimated(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetMinimizeNormalAnimated', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetMinimizeNormalAnimated' );
  try

  if not FLocked then
  begin
  FMinimizeNormalAnimated := Value;
  Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetMinimizeNormalAnimated' );
  end;
end;

procedure TKOLForm.SetLocked(const Value: Boolean);
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetLocked', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetLocked' );
  try

  if FLocked = Value then
  begin
    LogOK;
    Exit;
  end;
  if not Value then
  begin
    for I := 0 to Owner.ComponentCount-1 do
      if IsVCLControl( Owner.Components[ I ] ) then
      begin
        ShowMessage( 'Form ' + Owner.Name + ' contains VCL controls. TKOLForm ' +
                     'component can not be unlocked.' );
        LogOK;
        Exit;
      end;
    I := MessageBox( 0, 'TKOLForm component was locked because the form had ' +
         'VCL controls placed on it. Are You sure You want to unlock TKOLForm?'#13 +
         '(Note: if the form is beloning to VCL-based project, unlocking TKOLForm ' +
         'component can damage the form).', 'CAUTION!', MB_YESNO or MB_SETFOREGROUND );
    if I = ID_NO then
    begin
      LogOK;
      Exit;
    end;
  end;
  FLocked := Value;

  LogOK;
  finally
  Log( '<-TKOLForm.SetLocked' );
  end;
end;

procedure TKOLForm.SetOnShow(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnShow', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnShow' );
  try

  FOnShow := Value;
  Change( Self );

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnShow' );
  end;
end;

procedure TKOLForm.SetOnHide(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnHide', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnHide' );
  try
  FOnHide := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetOnHide' );
  end;
end;

procedure TKOLForm.SetzOrderChildren(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetzOrderChildren', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetzOrderChildren' );
  try
  FzOrderChildren := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetzOrderChildren' );
  end;
end;

procedure TKOLForm.SetSimpleStatusText(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetSimpleStatusText', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetSimpleStatusText' );
  try
  FSimpleStatusText := Value;
  FStatusText.Text := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetSimpleStatusText' );
  end;
end;

function TKOLForm.GetStatusText: TStrings;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GetStatusText', 0
  @@e_signature:
  end;
  Result := FStatusText;
end;

procedure TKOLForm.SetStatusText(const Value: TStrings);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetStatusText', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetStatusText' );
  try
  if Value = nil then
    FStatusText.Text := ''
  else
    FStatusText.Text := Value.Text;
  if FStatusText.Count = 1 then
    FSimpleStatusText := FStatusText.Text
  else
    FSimpleStatusText := '';
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetStatusText' );
  end;
end;

procedure TKOLForm.SetOnMouseDblClk(const Value: TOnMouse);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnMouseDblClk', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnMouseDblClk' );
  try
  fOnMouseDblClk := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetOnMouseDblClk' );
  end;
end;

procedure TKOLForm.GenerateCreateForm(SL: TStringList);
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GenerateCreateForm', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GenerateCreateForm' );
  try

  S := GenerateTransparentInits;

  SL.Add( '  Result.Form := NewForm( AParent, ' + StringConstant( 'Caption', Caption ) +
          ' )' + S + ';' );
  if @ OnBeforeCreateWindow <> nil then
    SL.Add( '      Result.' +
          (Owner as TForm).MethodName( @ OnBeforeCreateWindow ) + '( Result );' );
  // Если форма главная, и Applet не используется, инициализировать здесь
  // переменную Applet:
  if FormMain and not AppletOnForm then
    SL.Add( '  Applet :=  Result.Form;' );

  LogOK;
  finally
  Log( '<-TKOLForm.GenerateCreateForm' );
  end;
end;

function TKOLForm.Result_Form: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.Result_Form', 0
  @@e_signature:
  end;
  Result := 'Result.Form';
end;

procedure TKOLForm.GenerateDestroyAfterRun(SL: TStringList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GenerateDestroyAfterRun', 0
  @@e_signature:
  end;
  // nothing
end;

procedure TKOLForm.SetMarginBottom(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetMarginBottom', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetMarginBottom' );
  try

  if FMarginBottom = Value then
  begin
    LogOK;
    Exit;
  end;
  FMarginBottom := Value;
  AlignChildren( nil, FALSE );
  Change( Self );

  LogOK;
  finally
  Log( '<-TKOLForm.SetMarginBottom' );
  end;
end;

procedure TKOLForm.SetMarginLeft(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetMarginLeft', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetMarginLeft' );
  try

  if FMarginLeft = Value then
  begin
    LogOK;
    Exit;
  end;
  FMarginLeft := Value;
  AlignChildren( nil, FALSE );
  Change( Self );

  LogOK;
  finally
  Log( '<-TKOLForm.SetMarginLeft' );
  end;
end;

procedure TKOLForm.SetMarginRight(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetMarginRight', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetMarginRight' );
  try

  if FMarginRight = Value then
  begin
    LogOK;
    Exit;
  end;
  FMarginRight := Value;
  AlignChildren( nil, FALSE );
  Change( Self );

  LogOK;
  finally
  Log( '<-TKOLForm.SetMarginRight' );
  end;
end;

procedure TKOLForm.SetMarginTop(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetMarginTop', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetMarginTop' );
  try

  if FMarginTop = Value then
  begin
    LogOK;
    Exit;
  end;
  FMarginTop := Value;
  AlignChildren( nil, FALSE );
  Change( Self );

  LogOK;
  finally
  Log( '<-TKOLForm.SetMarginTop' );
  end;
end;

procedure TKOLForm.SetOnEraseBkgnd(const Value: TOnPaint);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnEraseBkgnd', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnEraseBkgnd' );
  try

  FOnEraseBkgnd := Value;
  Change( Self );

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnEraseBkgnd' );
  end;
end;

procedure TKOLForm.SetOnPaint(const Value: TOnPaint);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnPaint', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnPaint' );
  try
  FOnPaint := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetOnPaint' );
  end;
end;

procedure TKOLForm.SetEraseBackground(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetEraseBackground', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetEraseBackground' );
  try
  FEraseBackground := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetEraseBackground' );
  end;
end;

procedure TKOLForm.GenerateAdd2AutoFree(SL: TStringList;
  const AName: String; AControl: Boolean; Add2AutoFreeProc: String; Obj: TObject);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GenerateAdd2AutoFree', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GenerateAdd2AutoFree' );
  try

  if Obj <> nil then
  if Obj is TKOLObj then
  if (Obj as TKOLObj).NotAutoFree then
  begin
    LogOK;
    Exit;
  end;
  if Add2AutoFreeProc = '' then
    Add2AutoFreeProc := 'Add2AutoFree';
  if not AControl then
    SL.Add( '  Result.Form.' + Add2AutoFreeProc + '( ' + AName + ' );' );

  LogOK;
  finally
  Log( '<-TKOLForm.GenerateAdd2AutoFree' );
  end;
end;

function TKOLForm.AdditionalUnits: String;
var I: Integer;
    C: TComponent;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.AdditionalUnits', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.AdditionalUnits' );
  try

  Result := '';
  for I := 0 to (Owner as TForm).ComponentCount-1 do
  begin
    C := (Owner as TForm).Components[ I ];
    S := '';
    if C is TKOLCustomControl then
      S := (C as TKOLCustomControl).AdditionalUnits
    else
    if C is TKOLObj then
      S := (C as TKOLObj).AdditionalUnits;
    if S <> '' then
      if pos(S, Result) = 0 then
      begin
        {if Result <> '' then
          Result := Result + ', ';}
        Result := Result + S;
      end;
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.AdditionalUnits' );
  end;
end;

function TKOLForm.FormTypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.FormTypeName', 0
  @@e_signature:
  end;
  Result := 'PControl';
end;

procedure TKOLForm.AfterGeneratePas(SL: TStringList);
var s0, s: String;
    NomPrivate, NomC: Integer;
    I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.AfterGeneratePas', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.AfterGeneratePas' );
  try

  // to change generated Pas after GeneratePas procedure - in descendants.
  //-------------------- added by Alexander Rabotyagov:
  s0:='private{$ENDIF} {<-- It is a VCL control}';
    s:='';
  repeat
    NomPrivate:=SL.IndexOf(s+s0);
  s:=s+' ';
  until not((NomPrivate<0)and(length(s)<15));
  if NomPrivate>=0 then SL[NomPrivate]:='  private';

  if not FLocked then
  for I := 0 to Owner.ComponentCount - 1 do
  begin
    C := Owner.Components[ I ];
    if C = Self then Continue;
    if (C is controls.TControl)and(not((C is TKOLApplet) or (C is TKOLCustomControl) or (C is TOleControl)))and(c.tag=cKolTag)
    then begin

       s0:=c.Name+': '+c.ClassName+';';
       s:='';
       repeat
         NomC:=SL.IndexOf(s+s0);
         s:=s+' ';
       until not((NomC<0)and(length(s)<15));

       s0:='private';
       s:='';
       repeat
         NomPrivate:=SL.IndexOf(s+s0);
         s:=s+' ';
       until not((NomPrivate<0)and(length(s)<15));

       if (NomC>=0)and(NomPrivate>=0)
       then begin
         SL.Insert(NomPrivate+1,'    {$IFNDEF KOL_MCK}'+c.Name+': '+c.ClassName+';{$ENDIF} {<-- It is a VCL control}');
         SL.Delete(NomC);
       end;

    end;
  end;//i

  LogOK;
  finally
  Log( '<-TKOLForm.AfterGeneratePas' );
  end;
end;

procedure TKOLForm.SetOnMove(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnMove', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnMove' );
  try
  FOnMove := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetOnMove' );
  end;
end;

procedure TKOLForm.SetSupportMnemonics(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetSupportMnemonics', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetSupportAnsiMnemonics' );
  try
  FSupportMnemonics := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetSupportAnsiMnemonics' );
  end;
end;

procedure TKOLForm.SetStatusSizeGrip(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetStatusSizeGrip', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetStatusSizeGrip' );
  try
  FStatusSizeGrip := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetStatusSizeGrip' );
  end;
end;

procedure TKOLForm.SetPaintType(const Value: TPaintType);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetPaintType', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetPaintType' );
  try
  if FPaintType = Value then
  begin
    LogOK;
    Exit;
  end;
  {ShowMessage( 'Painttype=' + IntToStr( Integer( Value ) ) + ', OldPaintType=' +
               IntToStr( Integer( FPaintType ) ) );}
  FPaintType := Value;
  InvalidateControls;
  LogOK;
  finally
  Log( '<-TKOLForm.SetPaintType' );
  end;
end;

procedure TKOLForm.InvalidateControls;
var I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.InvalidateControls', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.InvalidateControls' );
  try

  if Owner = nil then
  begin
    LogOK;
    Exit;
  end;
  if not( Owner is TForm ) then
  begin
    LogOK;
    Exit;
  end;
  for I := 0 to (Owner as TForm).ComponentCount - 1 do
  begin
    C := (Owner as TForm).Components[ I ];
    if C is TKOLCustomControl then
{YS}
      with  C as TKOLCustomControl do begin
  {$IFDEF _KOLCtrlWrapper_}
        AllowSelfPaint := PaintType in [ptWYSIWIG, ptWYSIWIGFrames];
        AllowCustomPaint := PaintType <> ptWYSIWIG;  {<<<<<<<}
  {$ENDIF}
        Invalidate;
      end;
{YS}
  end;
  (Owner as TForm).Invalidate;

  LogOK;
  finally
  Log( '<-TKOLForm.InvalidateControls' );
  end;
end;

procedure TKOLForm.Loaded;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.Loaded', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.Loaded' );
  try

  inherited;
  GetPaintTypeFromProjectOrOtherForms;
  Font.Change;
  FChangeTimer.Enabled := FALSE;
  FChangeTimer.Enabled := TRUE;
  bounds.EnableTimer( TRUE );

  LogOK;
  finally
  Log( '<-TKOLForm.Loaded' );
  end;
end;

procedure TKOLForm.GetPaintTypeFromProjectOrOtherForms;
var I, J: Integer;
    F: TForm;
    C: TComponent;
    NewPaintType: TPaintType;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GetPaintTypeFromProjectOrOtherForms', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GetPaintTypeFromProjectOrOtherForms' );
  try

  NewPaintType := PaintType;
  if Screen = nil then
  begin
    LogOK;
    Exit;
  end;
  for I := 0 to Screen.FormCount-1 do
  begin
    F := Screen.Forms[ I ];
    for J := 0 to F.ComponentCount-1 do
    begin
      C := F.Components[ J ];
      if C is TKOLProject then
      begin
        NewPaintType := (C as TKOLProject).PaintType;
        break;
      end;
      if C is TKOLForm then
      if C <> Self then
        NewPaintType := (C as TKOLForm).PaintType;
    end;
  end;
  PaintType := NewPaintType;

  LogOK;
  finally
  Log( '<-TKOLForm.GetPaintTypeFromProjectOrOtherForms' );
  end;
end;

function SortControls( Item1, Item2: Pointer ): Integer;
var K1, K2: TKOLCustomControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'SortControls', 0
  @@e_signature:
  end;
  K1 := Item1;
  K2 := Item2;
  Result := CmpInts( K1.TabOrder, K2.TabOrder );
  if (Result = 0) and (K1.Align = K2.Align) then
  begin
    case K1.Align of
    caTop: Result := CmpInts( K1.Top, K2.Top );
    caBottom: Result := CmpInts( K2.Top, K1.Top );
    caLeft: Result := CmpInts( K1.Left, K2.Left );
    caRight: Result := CmpInts( K2.Left, K1.Left );
    else
      Result := 0;
    end;
  end;
end;

procedure TKOLForm.AlignChildren(PrntCtrl: TKOLCustomControl; Recursive: Boolean);
type
  TAligns = set of TKOLAlign;
var Controls: TList;
    I: Integer;
    P: TComponent;
    CR, CM: TRect;
    PrntBorder: Integer;
  procedure DoAlign( Allowed: TAligns );
  var I: Integer;
      C: TKOLCustomControl;
      R, R1: TRect;
      W, H: Integer;
      ChgPos, ChgSiz: Boolean;
  begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.AlignChildren.DoAlign', 0
  @@e_signature:
  end;
    for I := 0 to Controls.Count - 1 do
    begin
      C := Controls[ I ];
      //if not C.ToBeVisible then continue;
      // important: not fVisible, and even not Visible, but ToBeVisible!
      //if C.UseAlign then continue;
      if C.Align in Allowed then
      begin
        R := C.BoundsRect;
        R1 := R;
        W := R.Right - R.Left;
        H := R.Bottom - R.Top;
        case C.Align of
        caTop:
          begin
            OffsetRect( R, 0, -R.Top + CR.Top + PrntBorder );
            Inc( CR.Top, H + PrntBorder );
            R.Left := CR.Left + PrntBorder;
            R.Right := CR.Right - PrntBorder;
          end;
        caBottom:
          begin
            OffsetRect( R, 0, -R.Bottom + CR.Bottom - PrntBorder );
            Dec( CR.Bottom, H + PrntBorder );
            R.Left := CR.Left + PrntBorder;
            R.Right := CR.Right - PrntBorder;
          end;
        caLeft:
          begin
            OffsetRect( R, -R.Left + CR.Left + PrntBorder, 0 );
            Inc( CR.Left, W + PrntBorder );
            R.Top := CR.Top + PrntBorder;
            R.Bottom := CR.Bottom - PrntBorder;
          end;
        caRight:
          begin
            OffsetRect( R, -R.Right + CR.Right - PrntBorder, 0 );
            Dec( CR.Right, W + PrntBorder );
            R.Top := CR.Top + PrntBorder;
            R.Bottom := CR.Bottom - PrntBorder;
          end;
        caClient:
          begin
            R := CR;
            InflateRect( R, -PrntBorder, -PrntBorder );
          end;
        end;
        if R.Right < R.Left then R.Right := R.Left;
        if R.Bottom < R.Top then R.Bottom := R.Top;
        ChgPos := (R.Left <> R1.Left) or (R.Top <> R1.Top);
        ChgSiz := (R.Right - R.Left <> W) or (R.Bottom - R.Top <> H);
        if ChgPos or ChgSiz then
        begin
          C.BoundsRect := R;
          {if ChgSiz then
            AlignChildrenProc( C );}
        end;
      end;
    end;
  end;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.AlignChildren', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.AlignChildren' );
  try

  if csLoading in ComponentState then
  begin
    LogOK;
    Exit;
  end;
  if not AllowRealign then
  begin
    LogOK;
    Exit;
  end;
  Controls := TList.Create;
  if PrntCtrl = nil then
    AllowRealign := FALSE;
  Inc( FRealigning );
  TRY
    //-- collect controls, which are children of PrntCtrl
    for I := 0 to (Owner as TForm).ComponentCount-1 do
    begin
      if (Owner as TForm).Components[ I ] is TKOLCustomControl then
      begin
        P := ((Owner as TForm).Components[ I ] as TKOLCustomControl).Parent;
        if (P = PrntCtrl) or (PrntCtrl = nil) and (P is TForm) then
          Controls.Add( (Owner as TForm).Components[ I ] );
      end;
    end;
    //-- order controls by TabOrder
    Controls.Sort( SortControls );
    //-- initialize client rectangle
    if PrntCtrl = nil then
    begin
      CR := //Rect( 0, 0, bounds.Width, bounds.Height );
           (Owner as TForm).ClientRect;
      CR.Left := CR.Left + MarginLeft;
      CR.Top  := CR.Top + MarginTop;
      CR.Right := CR.Right - MarginRight;
      CR.Bottom := CR.Bottom - MarginBottom;
      PrntBorder := Border;
    end
      else
    begin
      CR := PrntCtrl.ClientRect;
      CM := PrntCtrl.ClientMargins;
      CR.Left := CR.Left + PrntCtrl.MarginLeft + CM.Left;
      CR.Top := CR.Top + PrntCtrl.MarginTop + CM.Top;
      CR.Right := CR.Right - PrntCtrl.MarginRight - CM.Right;
      CR.Bottom := CR.Bottom - PrntCtrl.MarginBottom - CM.Bottom;
      PrntBorder := PrntCtrl.Border;
    end;
    DoAlign( [ caTop, caBottom ] );
    DoAlign( [ caLeft, caRight ] );
    DoAlign( [ caClient ] );
    if PrntCtrl = nil then
      AllowRealign := TRUE;
    if Recursive then
      for I := 0 to Controls.Count-1 do
        AlignChildren( TKOLCustomControl( Controls[ I ] ), TRUE );
  FINALLY
    Controls.Free;
    if PrntCtrl = nil then
      AllowRealign := TRUE;
    Dec( FRealigning );
  END;

  LogOK;
  finally
  Log( '<-TKOLForm.AlignChildren' );
  end;
end;

function TKOLForm.DoNotGenerateSetPosition: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.DoNotGenerateSetPosition', 0
  @@e_signature:
  end;
  Result := FALSE;
end;

procedure TKOLForm.RealignTimerTick(Sender: TObject);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFileFilter.RealignTimerTick', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.RealignTimerTick' );
  try

  if not AllowRealign then
  begin
    LogOK;
    Exit;
  end;
  if FRealigning > 0 then
  begin
    LogOK;
    Exit;
  end;
  FRealignTimer.Enabled := FALSE;
  Rpt( 'RealignTimerTick' );
  AlignChildren( nil, TRUE );

  LogOK;
  finally
  Log( '<-TKOLForm.RealignTimerTick' );
  end;
end;

procedure TKOLForm.SetMaxHeight(const Value: Integer);
begin
  Log( '->TKOLForm.SetMaxHeight' );
  try
  FMaxHeight := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetMaxHeight' );
  end;
end;

procedure TKOLForm.SetMaxWidth(const Value: Integer);
begin
  Log( '->TKOLForm.SetMaxWidth' );
  try
  FMaxWidth := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetMaxWidth' );
  end;
end;

procedure TKOLForm.SetMinHeight(const Value: Integer);
begin
  Log( '->TKOLForm.SetMinHeight' );
  try
  FMinHeight := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetMinHeight' );
  end;
end;

procedure TKOLForm.SetMinWidth(const Value: Integer);
begin
  Log( '->TKOLForm.SetMinWidth' );
  try
  FMinWidth := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetMinWidth' );
  end;
end;

procedure TKOLForm.SetOnDropFiles(const Value: TOnDropFiles);
begin
  Log( '->SetOnDropFiles' );
  try
  FOnDropFiles := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-SetOnDropFiles' );
  end;
end;

procedure TKOLForm.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  Log( '->TKOLForm.SetpopupMenu' );
  try
  FpopupMenu := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetpopupMenu' );
  end;
end;

procedure TKOLForm.SetOnMaximize(const Value: TOnEvent);
begin
  Log( '->TKOLForm.SetOnMaximize' );
  try
  FOnMaximize := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetOnMaximize' );
  end;
end;

procedure TKOLForm.SetLocalizy(const Value: Boolean);
begin
  Log( '->TKOLForm.SetLocalizy' );
  try
  FLocalizy := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetLocalizy' );
  end;
end;

procedure TKOLForm.MakeResourceString(const ResourceConstName,
  Value: String);
begin
  Log( '->TKOLForm.MakeResourceString' );
  try
  if ResStrings = nil then
    ResStrings := TStringList.Create;
  ResStrings.Add( 'resourcestring ' + ResourceConstName + ' = ' + String2Pascal( Value ) + ';' );
  LogOK;
  finally
  Log( '<-TKOLForm.MakeResourceString' );
  end;
end;

function TKOLForm.StringConstant(const Propname, Value: String): String;
begin
  Log( '->TKOLForm.StringConstant' );
  try
  if Localizy and (Value <> '') then
  begin
    Result := Name + '_' + Propname;
    MakeResourceString( Result, Value );
  end
    else
  begin
    Result := String2Pascal( Value );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.StringConstant' );
  end;
end;

procedure TKOLForm.SetHelpContext(const Value: Integer);
begin
  Log( '->TKOLForm.SetHelpContext' );
  try
  FHelpContext := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetHelpContext' );
  end;
end;

procedure TKOLForm.SethelpContextIcon(const Value: Boolean);
begin
  Log( '->TKOLForm.SethelpContextIcon' );
  try
  FhelpContextIcon := Value;
  if Value then
  begin
    maximizeIcon := FALSE;
    minimizeIcon := FALSE;
  end;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SethelpContextIcon' );
  end;
end;

procedure TKOLForm.SetOnHelp(const Value: TOnHelp);
begin
  Log( '->TKOLForm.SetOnHelp' );
  try
  FOnHelp := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetOnHelp' );
  end;
end;

procedure TKOLForm.SetBrush(const Value: TKOLBrush);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetFont', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetBrush' );
  try

  if not FLocked then
  begin
    FBrush.Assign( Value );
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetBrush' );
  end;
end;

{YS}
procedure TKOLForm.SetborderStyle(const Value: TKOLFormBorderStyle);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetborderStyle', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetborderStyle' );
  try
  if not FLocked then
  begin
    FborderStyle := Value;
    if not( csLoading in ComponentState ) then //+VK
    begin                                      //+VK
      FHasBorder := Value <> fbsNone;
      fCanResize := Value <> fbsDialog;
    end;                                       //+VK
    Change( Self );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetborderStyle' );
  end;
end;
{YS}

function TKOLForm.BestEventName: String;
begin
  Result := 'OnFormCreate';
end;

procedure TKOLForm.SetShowHint(const Value: Boolean);
begin
  Log( '->TKOLForm.SetShowHint' );
  try
  FGetShowHint := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetShowHint' );
  end;
end;

function TKOLForm.GetShowHint: Boolean;
begin
  Log( '->TKOLForm.GetShowHint' );
  try
  if KOLProject <> nil then
    FGetShowHint := KOLProject.ShowHint;
  Result := FGetShowHint;
  LogOK;
  finally
  Log( '<-TKOLForm.GetShowHint' );
  end;
end;

procedure TKOLForm.SetOnBeforeCreateWindow(const Value: TOnEvent);
begin
  Log( '->TKOLForm.SetOnBeforeCreateWindow' );
  try
  FOnBeforeCreateWindow := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetOnBeforeCreateWindow' );
  end;
end;

procedure TKOLForm.ChangeTimerTick(Sender: TObject);
begin
  Log( '->TKOLForm.ChangeTimerTick' );
  try
  FChangeTimer.Enabled := FALSE;
  DoChangeNow;
  LogOK;
  finally
  Log( '<-TKOLForm.ChangeTimerTick' );
  end;
end;

procedure TKOLForm.DoChangeNow;
var I: Integer;
    Success: Boolean;
    S: String;
begin
  Log( '->TKOLForm.DoChangeNow' );
  try

  Success := FALSE;
  if KOLProject = nil then
  begin
    if ToolServices <> nil then
    begin
      for I := 0 to ToolServices.GetUnitCount - 1 do
      begin
        S := ToolServices.GetUnitName( I );
        if LowerCase( ExtractFileName( S ) ) = LowerCase( FormUnit + '.pas' ) then
        begin
          S := Copy( ExtractFileName( S ), 1, Length( S ) - 4 );
          if fSourcePath <> '' then
            S := IncludeTrailingPathDelimiter( fSourcePath ) + S;
          //ShowMessage( 'Generating w/o KOLProject: ' + S {+#13#10 +
          //  'csLoading:' + IntToStr( Integer( csLoading in ComponentState ) )} );
          Success := GenerateUnit( S );
        end;
        if Success then break;
      end;
      if not Success then
      begin
        S := ToolServices.GetCurrentFile;
        if S <> '' then
        begin
          if LowerCase( ExtractFileName( S ) ) = LowerCase( FormUnit + '.pas' ) then
          begin
            S := Copy( ExtractFileName( S ), 1, Length( S ) - 4 );
            if fSourcePath <> '' then
              S := IncludeTrailingPathDelimiter( fSourcePath ) + S;
            //ShowMessage( 'Generating w/o KOLProject: ' + S );
            Success := GenerateUnit( S );
          end;
        end;
      end;
    end;
  end;
  if not Success then
    inherited Change( Self );

  LogOK;
  finally
  Log( '<-TKOLForm.DoChangeNow' );
  end;
end;

{ TKOLProject }

procedure TKOLProject.AfterGenerateDPR(const SL: TStringList; var Updated: Boolean);
begin
  Log( 'TKOLProject.AfterGenerateDPR' );
end;

procedure TKOLProject.BeforeGenerateDPR(const SL: TStringList; var Updated: Boolean);
begin
  Log( 'TKOLProject.BeforeGenerateDPR' );
end;

procedure TKOLProject.BroadCastPaintTypeToAllForms;
var I, J: Integer;
    F: TForm;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.BroadCastPaintTypeToAllForms', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.BroadCastPaintTypeToAllForms' );
  TRY

    if Screen <> nil then
    for I := 0 to Screen.FormCount-1 do
    begin
      F := Screen.Forms[ I ];
      for J := 0 to F.ComponentCount-1 do
      begin
        C := F.Components[ J ];
        if C is TKOLForm then
          (C as TKOLForm).PaintType := PaintType;
      end;
    end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.BroadCastPaintTypeToAllForms' );
  END;
end;

procedure TKOLProject.Change;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.Change', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.Change' );
  TRY

  if fChangingNow or FLocked or (csLoading in ComponentState) then
  begin
    LogOK;
    Exit;
  end;
  fChangingNow := TRUE;
  try

    if AutoBuild then
    begin
      if fTimer <> nil then
      begin
        if FAutoBuildDelay > 0 then
        begin
          Rpt( 'Autobuild timer off/on' );
          //Rpt_Stack;
          fTimer.Enabled := False;
          fTimer.Enabled := True;
        end
           else
        begin
          Rpt( 'Calling TimerTick directly' );
          //Rpt_Stack;
          TimerTick( fTimer );
        end;
      end;
    end;

  finally
    fChangingNow := FALSE;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.Change' );
  END;
end;

function TKOLProject.ConvertVCL2KOL( ConfirmOK: Boolean; ForceAllForms: Boolean ): Boolean;
var I, E, N: Integer;
    F: TKolForm;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.ConvertVCL2KOL', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.ConvertVCL2KOL' );
  TRY

  Result := FALSE;
  if not FLocked then
  begin
    if ProjectDest = '' then
    begin
      if not AutoBuilding then
      ShowMessage( 'You have forgot to assign valid name to ProjectDest property ' +
                   'TKOLProject component, which define KOL project name after ' +
                   'converting of your mirror project. It must not much name of any other ' +
                   'form in your project (FormName property of correspondent ' +
                   'TKOLForm component). But if You want, it can much the name of ' +
                   'source project (it will be stored in \KOL subdirectory, created ' +
                   'in directory with source (mirror) project).' );
      LogOK;
      Exit;
    end;
    if FormsList = nil then
    begin
      if not AutoBuilding then
      ShowMessage( 'There are not found TKOLForm component instances. You must create '+
                   'an instance for each form in your mirror project to provide ' +
                   'converting mirror project to KOL.' );
      LogOK;
      Exit;
    end;
    FBuilding := True;
    try

    fOutdcuPath := '';
    S := SourcePath;
    S := S + ProjectDest;
    E := 0;
    if not GenerateDPR( S ) then
      Inc( E );
    N := 0;
    if FormsList <> nil then
    for I := 0 to FormsList.Count - 1 do
    begin
      F := FormsList[ I ];
      if not ForceAllForms and not F.FChanged then continue;
      S := SourcePath + F.FormUnit;
      if not F.GenerateUnit( S ) then
        Inc( E )
      else
        Inc( N );
    end;
    if E = 0 then
      if not IsKOLProject then
        UpdateConfig;
    if E = 0 then
    begin
      S := 'Converting finished successfully.';
      if not ConfirmOK then S := '';
      Result := TRUE;
    end
    else
    begin
      if N > 0 then
        S := 'Converting finished.'#13 + IntToStr( E ) + ' errors found.';
    end;
    if S <> '' then
      Report( S );

    except
      on E: Exception do
      begin
        ShowMessage( 'Can not convert VCL to KOL, exception: ' + E.Message );
      end;
    end;
  end;

  FBuilding := False;
  LogOK;
  FINALLY
    Log( '<-TKOLProject.ConvertVCL2KOL' );
  END;
end;

constructor TKOLProject.Create(AOwner: TComponent);
var I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.Create', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.Create' );
  TRY

  inherited;
  fAutoBuild := True;
  fAutoBuildDelay := 500;
  fProtect := True;
  fShowReport := FALSE; // True;
  fTimer := TTimer.Create( Self );
  fTimer.Interval := 500;
  fTimer.OnTimer := TimerTick;
  fTimer.Enabled := FALSE;

  if AOwner <> nil then
  for I := 0 to AOwner.ComponentCount-1 do
  begin
    C := AOwner.Components[ I ];
    if IsVCLControl( C ) then
    begin
      FLocked := TRUE;
      ShowMessage( 'The form ' + AOwner.Name + ' contains already VCL controls.'#13 +
      'The TKOLProject component is locked now and will not functioning.'#13 +
      'Just delete it and never drop onto forms, beloning to VCL projects.' );
      break;
    end;
  end;
  if not FLocked then
  begin

    if (KOLProject <> nil) and (KOLProject.Owner <> AOwner) then
      ShowMessage( 'You have more then one instance of TKOLProject component in ' +
                   'your mirror project. Please remove all ambigous ones before ' +
                   'running the project to avoid problems with generating code.' +
                   ' Or, may be, you open several projects at a time or open main ' +
                   'form of another KOL&MCK project. This is not allowed.' )
    else
    begin
      KOLProject := Self;
      if not( csDesigning in ComponentState) then
      begin
        ShowMessage( 'You did not finish converting VCL project to MCK. ' +
                     'Do not forget, that you first must drop TKOLProject on ' +
                     'form and change its property projectDest, and then drop ' +
                     'TKOLForm component. Then you can open destination (MCK) project' +
                     ' and work with it.' );
        PostQuitMessage( 0 );
      end;
    end;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.Create' );
  END;
end;

destructor TKOLProject.Destroy;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.Destroy', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.Destroy' );
  FIsDestroying := TRUE;
  TRY

  if KOLProject = Self then
    KOLProject := nil;
  if FConsoleOut then
    FreeConsole;
  ResStrings.Free;
  inherited;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.Destroy' );
  END;
end;

type
  TFormKind = ( fkNormal, fkMDIParent, fkMDIChild );

function FormKind( const FName: String; var ParentFName: String ): TFormKind;
const Kinds: array[ TFormKind ] of String = ( 'fkNormal', 'fkMDIParent', 'fkMDIChild' );
var I, J: Integer;
    UN: String;
    MI: TIModuleInterface;
    FI: TIFormInterface;
    FCI, CI: TIComponentInterface;
    KindDefined: Boolean;
    S, ObjName, ObjType: String;
    SL: TStringList;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'FormKind', 0
  @@e_signature:
  end;
  Log( '->FormKind' );
  TRY

  Rpt( 'Analizing form: ' + FName );
  //Rpt_Stack;
  Result := fkNormal;
  TRY

  KindDefined := FALSE;
  //-- 1. Try to search a form among loaded into the designer.
  for I := 0 to ToolServices.GetUnitCount-1 do
  begin
    UN := ToolServices.GetUnitName( I );
    MI := ToolServices.GetModuleInterface( UN );
    if MI <> nil then
    TRY
      FI := MI.GetFormInterface;
      if FI <> nil then
      TRY
        FCI := FI.GetFormComponent;
        if FCI <> nil then
        TRY
          S := '';
          FCI.GetPropValueByName( 'Name', S );
          Rpt( 'Form component interface obtained for ' + FName +
               ', Name=' + S + ' (Unit=' + UN + ')' );
          if StrEq( S, FName ) then
          for J := 0 to FCI.GetComponentCount-1 do
          begin
            CI := FCI.GetComponent( J );
            if CI.GetComponentType = 'TKOLMDIClient' then
            begin
              Rpt( 'TKOLMDIClient found in ' + FName );
              Result := fkMDIParent;
              KindDefined := TRUE;
            end
              else
            if CI.GetComponentType = 'TKOLMDIChild' then
            begin
              Rpt( 'TKOLMDIChild found in ' + FName );
              Result := fkMDIChild;
              CI.GetPropValueByName( 'ParentMDIForm', ParentFName );
              KindDefined := TRUE;
            end;
            if KindDefined then
            begin
              LogOK;
              Exit;
            end;
          end
            else
          if S = '' then
          begin
            if CompareText( ExtractFileExt( UN ), '.pas' ) = 0 then
            begin
              SL := TStringList.Create;
              TRY
                SL.LoadFromFile( ChangeFileExt( UN, '.dfm' ) );
                Rpt( 'Loaded dfm for ' + UN );
                ObjName := '';
                ObjType := '';
                KindDefined := FALSE;
                for J := 0 to SL.Count-1 do
                begin
                  S := Trim( SL[ J ] );
                  if StrIsStartingFrom( PChar( S ), 'object ' ) then
                  begin
                    Parse( S, ' ' );
                    ObjName := Trim( Parse( S, ':' ) );
                    ObjType := Trim( S );
                    if J = 0 then
                    begin
                      if not StrEq( ObjName, FName ) then
                      begin
                        Rpt( 'Another form - - continue' );
                        break;
                      end;
                    end;
                    if (ObjType = 'TKOLMDIClient') then
                    begin
                      Rpt( 'TKOLMDIClient found for ' + FName + ' in dfm' );
                      Result := fkMDIParent;
                      KindDefined := TRUE;
                    end;
                  end
                    else
                  begin
                    if not KindDefined and
                       (ObjType = 'TKOLMDIChild') and
                       StrIsStartingFrom( PChar( S ), 'ParentMDIForm = ' ) then
                    begin
                      Rpt( 'TKOLMDIChild found for ' + FName + ' in dfm' );
                      Result := fkMDIChild;
                      KindDefined := TRUE;
                      Parse( S, '=' );
                      S := Trim( S );
                      if Length( S ) > 2 then
                        S := Copy( S, 2, Length( S ) - 2 );
                      ParentFName := S;
                    end;
                  end;
                  if KindDefined then
                  begin
                    LogOK;
                    Exit;
                  end;
                end;
              FINALLY
                SL.Free;
              END;
            end;
          end;
        FINALLY
          FCI.Free;
        END;
      FINALLY
        FI.Free;
      END;
    FINALLY
      MI.Free;
    END;
  end;
  Result := fkNormal;
  FINALLY
    Rpt( 'Analized form ' + FName + 'Kind: ' + Kinds[ Result ] );
  END;

  LogOK;
  FINALLY
    Log( '<-FormKind' );
  END;
end;

procedure ReorderForms( Prj: TKOLProject; Forms: TStringList );
var Rslt: TStringList;
    I, J: Integer;
    FormName, Name2, ParentFormName, S: String;
    Kind: TFormKind;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'ReorderForms', 0
  @@e_signature:
  end;
  Log( '->ReorderForms' );
  TRY

  Rslt := TStringList.Create;
  TRY
    for I := 0 to Forms.Count-1 do
    begin
      Kind := FormKind( Forms[ I ], ParentFormName );
      Forms.Objects[ I ] := Pointer( Kind );
      if Kind = fkMDIChild then
        Forms[ I ] := Forms[ I ] + ',' + ParentFormName;
    end;
    for I := 0 to Forms.Count-1 do
    begin
      FormName := Forms[ I ];
      if FormName = '' then continue;
      Kind := TFormKind( Forms.Objects[ I ] );
      if Kind in [ fkNormal, fkMDIParent ] then
      begin
        Rslt.Add( FormName );
        Forms[ I ] := '';
      end;
      if Kind = fkMDIParent then
      for J := 0 to Forms.Count - 1 do
      begin
        Name2 := Forms[ J ];
        if Name2 = '' then continue;
        if TFormKind( Forms.Objects[ J ] ) = fkMDIChild then
        begin
          S := Name2;
          Parse( S, ',' );
          if CompareText( S, FormName ) = 0 then
          begin
            Rslt.Add( Name2 );
            Forms[ J ] := '';
          end;
        end;
      end;
    end;
    Forms.Assign( Rslt );
  FINALLY
    Rslt.Free;
  END;

  LogOK;
  FINALLY
    Log( '<-ReorderForms' );
  END;
end;

function TKOLProject.GenerateDPR(const Path: String): Boolean;
const BeginMark = 'begin // PROGRAM START HERE -- Please do not remove this comment';
      BeginResourceStringsMark = '// RESOURCE STRINGS START HERE -- Please do not change this section';
var SL, Source, AForms: TStringList;
    A, S, S1, FM: String;
    I, J: Integer;
    F: TKOLForm;
    Found: Boolean;
    Updated: Boolean;
    Object2Run: TObject;
    IsDLL: Boolean;
    /////////////////////////////////////////////////////////////////////////
    procedure Prepare_0inc;
    var SL: TStringList;
        I, J: Integer;
        S: String;
    begin
      // prepare <ProjectDest>_0.inc, which is to replace
      // begin .. end. of a project.

      SL := TStringList.Create;
      TRY

      SL.Add( Signature );
      SL.Add( '{ ' + ProjectDest + '_0.inc' );
      SL.Add( '  Do not edit this file manually - it is generated automatically.' );
      SL.Add( '  You can only modify ' + ProjectDest + '_1.inc and ' + ProjectDest + '_3.inc' );
      SL.Add( '  files. }' );
      SL.Add( '' );

      if SupportAnsiMnemonics <> 0 then
      begin
        if SupportAnsiMnemonics = 1 then
          I := GetUserDefaultLCID
        else
          I := SupportAnsiMnemonics;
        SL.Add( '  SupportAnsiMnemonics( $' + IntToHex( I, 8 ) + ' );' );
      end;

      if Applet <> nil then
      begin
        SL.Add( '  Applet := NewApplet( ''' + Applet.Caption + ''' );' );
        if not Applet.Visible then
        begin
          SL.Add( '  Applet.GetWindowHandle;' );
          SL.Add( '  Applet.Visible := False;' );
        end;
        if (Applet.Icon <> '') or Applet.ForceIcon16x16 then
        begin
          if Copy( Applet.Icon, 1, 4 ) = 'IDI_' then
            SL.Add( '  Applet.IconLoad( 0, ' + Applet.Icon + ' );' )
          else
          if Applet.Icon = '-1' then
            SL.Add( '  Applet.Icon := THandle(-1);' )
          else
          begin
            if (Applet.Icon <> '-1') and Applet.ForceIcon16x16 then
            begin
              S := Applet.Icon;
              if S = '' then
                S := 'MAINICON';
              SL.Add( '  Applet.Icon := LoadImgIcon( ' + String2Pascal( S ) + ', 16 );' );
            end
              else
            SL.Add( '  Applet.IconLoad( hInstance, ''' + Applet.Icon + ''' );' );
          end;
        end;
      end
        else
      if not IsDLL then
      begin
        for I := 0 to FormsList.Count - 1 do
        begin
          F := FormsList[ I ];
          if F is TKOLFrame then continue;
          if F.FormMain then
          begin
            SL.Add( '  New' + F.FormName + '( ' + F.FormName + ', ' +
                    A + ' );' );
            //SL.Add( '  Applet := ' + F.FormName + '.Form;' );
            A := F.FormName + '.Form';
            Object2Run := F;

          end;
        end;
      end;

      SL.Add( '{$I ' + ProjectDest + '_1.inc}' );

      SL.Add( '' );
      SL.Add( '{$I ' + ProjectDest + '_2.inc}' );

      SL.Add( '' );
      SL.Add( '{$I ' + ProjectDest + '_3.inc}' );

      SL.Add( '' );

      FM := '';
      if FormsList <> nil then
      for I := 0 to FormsList.Count - 1 do
      begin
        F := FormsList[ I ];
        if F is TKOLFrame then continue;
        if F.FormMain then
        begin
          FM := F.FormName + '.Form';
          if Object2Run = nil then
            Object2Run := F;
        end;
      end;

      if A <> 'nil' then
        FM := A;

      if (HelpFile <> '') and not IsDLL then
      begin
        if StrEq( ExtractFileExt( HelpFile ), '.chm' ) then
          SL.Add( '  AssignHtmlHelp( ' + StringConstant( 'HelpFile', HelpFile ) + ' );' )
        else
          SL.Add( '  Applet.HelpPath := ' + StringConstant( 'HelpFile', HelpFile ) + ';' );
      end;
      if not IsDLL then
      begin
        TKOLApplet( Object2Run ).GenerateRun( SL, FM );
        //SL.Add( '  Run( ' + FM + ' );' );

        if FormsList <> nil then
        for I := 0 to FormsList.Count - 1 do
        begin
          F := FormsList[ I ];
          if F is TKOLFrame then continue;
          Found := FALSE;
          for J := 0 to AForms.Count-1 do
          begin
            if CompareText( AForms[ J ], F.FormName ) = 0 then
            begin
              Found := TRUE;
              break;
            end;
          end;
          if Found then
            F.GenerateDestroyAfterRun( SL );
        end;
      end;

      SL.Add( '' );
      SL.Add( '{$I ' + ProjectDest + '_4.inc}' );

      SL.Add( '' );
      SaveStrings( SL, Path + '_0.inc', Updated );

      FINALLY
        SL.Free;
      END;
    end;

    /////////////////////////////////////////////////////////////////////////
    procedure Prepare_134inc;
    var SL: TStringList;
    begin

      SL := TStringList.Create;
      TRY

      // if files _1.inc and _3.inc do not exist, create it (empty).

      if not FileExists( Path + '_1.inc' ) then
      begin
        SL.Add( '{ ' + ProjectDest + '_1.inc' );
        SL.Add( '  This file is for you. Place here any code to run it' );
        SL.Add( '  just following Applet creation (if it present) but ' );
        SL.Add( '  before creating other forms. E.g., You can place here' );
        SL.Add( '  <IF> statement, which prevents running of application' );
        SL.Add( '  in some cases. TIP: always use Applet for such checks' );
        SL.Add( '  and make it invisible until final decision if to run' );
        SL.Add( '  application or not. }' );
        SL.Add( '' );
        SaveStrings( SL, Path + '_1.inc', Updated );
        SL.Clear;
      end;

      if not FileExists( Path + '_3.inc' ) then
      begin
        SL.Add( '{ ' + ProjectDest + '_3.inc' );
        SL.Add( '  This file is for you. Place here any code to run it' );
        SL.Add( '  after forms creating, but before Run call, if necessary. }' );
        SL.Add( '' );
        SaveStrings( SL, Path + '_3.inc', Updated );
        SL.Clear;
      end;

      if not FileExists( Path + '_4.inc' ) then
      begin
        SL.Add( '{ ' + ProjectDest + '_4.inc' );
        SL.Add( '  This file is for you. Place here any code to be inserted' );
        SL.Add( '  after Run call, if necessary. }' );
        SL.Add( '' );
        SaveStrings( SL, Path + '_4.inc', Updated );
        SL.Clear;
      end;

      FINALLY
        SL.Free;
      END;
    end;

    ////////////////////////////////////////////////////////////////////////
    procedure Prepare_2inc;
    var SL: TStringList;
        I, J: Integer;
    begin
      SL := TStringList.Create;
      TRY
      // for now, generate <ProjectName>_2.inc
      SL.Add( Signature );
      SL.Add( '{ ' + ProjectDest + '_2.inc' );
      SL.Add( '  Do not modify this file manually - it is generated automatically. }' );
      SL.Add( '' );

      if not IsDLL then
      begin
        for I := 0 to AForms.Count - 1 do
        begin
          S := AForms[ I ];
          S := Trim( Parse( S, ',' ) );
          F := nil;
          for J := 0 to FormsList.Count - 1 do
          begin
            F := FormsList[ J ];
            if CompareText( AForms[ I ], F.formName ) = 0 then
              break
            else
              F := nil;
              // Это недостаточно, чтобы решить, что перед нами frame, а не form.
              // Фрейм должен быть исключен из списка авто-create.
          end;
          if (F <> nil) and (F is TKOLFrame) then continue;
          //Rpt( 'AutoForm: ' + S );
          if LowerCase( A ) = LowerCase( S + '.Form' ) then Continue;
          if pos( ',', AForms[ I ] ) > 0 then
          begin
            // MDI child form
            S1 := AForms[ I ];
            Parse( S1, ',' );
            SL.Add( '  New' + Trim( S ) + '( ' + Trim( S ) + ', ' +
                    Trim( S1 ) + '.Form );' );
          end
            else
          begin
            // normal or MDI parent form
            SL.Add( '  New' + S + '( ' + S + ', Pointer( ' + A + ' ) );' );
          end;
        end;
      end;

      SaveStrings( SL, Path + '_2.inc', Updated );

      FINALLY
        SL.Free;
      END;
    end;

    /////////////////////////////////////////////////////////////////////////

begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.GenerateDPR', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.GenerateDPR' );
  TRY

  Rpt( 'Generating DPR for ' + Path ); //Rpt_Stack;
  Result := False;
  if FLocked then
  begin
    LogOK; Exit;
  end;
  Updated := FALSE;
  SL := TStringList.Create;
  Source := TStringList.Create;
  AForms := TStringList.Create;

  try

  ResStrings.Free;
  ResStrings := nil;

  // First, generate <ProjectName>.dpr
  S := ExtractFilePath( Path ) + ProjectName + '.dpr';
  LoadSource( Source, S );
  IsDLL := FALSE;
  for I := 0 to Source.Count-1 do
  begin
    if pos( 'library', LowerCase( Source[ I ] ) ) > 0 then
    begin
      IsDLL := TRUE;
      break;
    end
      else
    if pos( 'program', LowerCase( Source[ I ] ) ) > 0 then
      break;
  end;
  if Source.Count = 0 then
  begin
    S := ExtractFilePath( Path ) + ExtractFileNameWOExt( Path ) + '.dpr';
    LoadSource( Source, S );
  end;
  if Source.Count = 0 then
  begin
    Rpt( 'Could not get source from ' + S );
    SL.Free;
    Source.Free;
    LogOK;
    Exit;
  end;

  BeforeGenerateDPR( SL, Updated );

  Object2Run := nil;
  A := 'nil';
  if Applet <> nil then  // TODO: TKOLApplet must be on main form
  begin                  // (to be always available for TKOLProject)
    A := 'Applet';
    Object2Run := Applet;
  end;

  SL.Clear;

  J := -1;
  for I := 0 to Source.Count - 1 do
  begin
    if Source[ I ] = 'begin' then
    begin
      if J = -1 then J := I else J := -2;
    end;
    if Source[ I ] = BeginMark then
    begin
      J := I; break;
    end;
  end;
  if J >= 0 then
    Source[ J ] := BeginMark
  else
  begin
    ShowMessage( 'Error while converting dpr: begin markup could not be found. ' +
                 'Dpr-file of the project must either have a single line having only ' +
                 '''begin'' reserved word at the beginning or such line must be marked ' +
                 'with special comment:'#13 +
                 BeginMark );
    LogOK;
    Exit;
  end;
  // copy lines from the first to 'begin', making
  // some changes:
  SL.Add( Signature ); // insert signature
  S := '';
  I := -1;
  while I < Source.Count - 1 do
  begin
    Inc( I );
    S := Source[ I ];
    if S = Signature then continue; // skip signature if present
    if LowerCase( Trim( S ) ) = LowerCase( 'program ' + ProjectName + ';' ) then
    begin
      SL.Add( 'program ' + ProjectDest + ';' );
      continue;
    end;
    if (LowerCase( Trim( S ) ) = LowerCase( 'library ' + ProjectName + ';' ))
    then
    begin
      SL.Add( 'library ' + ProjectDest + ';' );
      continue;
    end;
    if S = BeginMark then
      break;
    if LowerCase( Trim( S ) ) = 'uses' then
    begin
      SL.Add( S );
      SL.Add( 'KOL,' );
      continue;
    end;
    J := pos( 'KOL,', S );
    if J > 0 then
    begin
      S := Copy( S, 1, J-1 ) + Copy( S, J+4, Length( S )-J-3 );
      if Trim( S ) = '' then continue;
    end;
    J := pos( 'Forms,', S );
    if J > 0 then // remove reference to Forms.pas
    begin
      S := Copy( S, 1, J-1 ) + Copy( S, J+6, Length( S )-J-5 );
      if Trim( S ) = '' then continue;
    end;
    J := pos( '{$r *.res}', LowerCase( S ) );
    if J > 0 then // remove/insert reference to project resource file
      if DprResource then
        S := '{$R *.res}'
      else
        S := '//{$R *.res}';
    SL.Add( S );
  end;
  SL.Add( BeginMark );
  SL.Add( '' );
  SL.Add( '{$IFDEF KOL_MCK} {$I ' + ProjectDest + '_0.inc} {$ELSE}' );
  SL.Add( '' );

  // copy the rest of source dpr - between begin .. end.
  // and store all autocreated forms in AForms string list
  while I < Source.Count - 1 do
  begin
    Inc( I );
    S := Source[ I ];
    if Trim( S ) = '' then continue;

    if UpperCase( S ) = UpperCase( '{$IFDEF KOL_MCK} {$I ' + ProjectDest + '_0.INC} {$ELSE}' ) then
      continue;
    if UpperCase( S ) = '{$ENDIF}' then
      continue;
    if LowerCase( S ) = 'end.' then
    begin
      SL.Add( '' );
      SL.Add( '{$ENDIF}' );
      SL.Add( '' );
    end;

    SL.Add( S );

    J := pos( 'application.createform(', LowerCase( S ) );
    if J > 0 then
    begin
      S := Copy( S, J + 23, Length( S ) - J - 22 );
      J := pos( ',', S );
      if J > 0 then
        S := Copy( S, J + 1, Length( S ) - J );
      J := pos( ')', S );
      if J > 0 then
        S := Copy( S, 1, J - 1 );
      AForms.Add( Trim( S ) );
    end;
  end;
  ReorderForms( Self, AForms );

  Prepare_0inc;
  Prepare_134inc;
  Prepare_2inc;

  if (ResStrings <> nil) and (ResStrings.Count > 0) then
  begin
    for I := 0 to SL.Count-1 do
    begin
      S := SL[ I ];
      if S = BeginResourceStringsMark then
      begin
        while S <> BeginMark do
        begin
          SL.Delete( I );
          if I >= SL.Count then
          begin
            Rpt( 'Error: begin mark not found' );
            break;
          end;
          S := SL[ I ];
        end;
      end;
      if S = BeginMark then
      begin
        SL.Insert( I, BeginResourceStringsMark );
        for J := ResStrings.Count-1 downto 0 do
          SL.Insert( I + 1, ResStrings[ J ] );
        //Updated := TRUE;
        break;
      end;
    end;
  end;

  AfterGenerateDPR( SL, Updated );
  // store SL as <ProjectDest>.dpr
  SaveStrings( SL, Path + '.dpr', Updated );


  // at last, generate code for all (opened in designer) forms

  if FormsList <> nil then
  for I := 0 to FormsList.Count - 1 do
  begin
    F := FormsList[ I ];
    F.GenerateUnit( ExtractFilePath( Path ) + F.FormUnit );
  end;

  if Updated then
  begin
    // mark modified here
    MarkModified( Path + '.dpr' );
    MarkModified( Path + '_1.inc' );
    MarkModified( Path + '_2.inc' );
    MarkModified( Path + '_3.inc' );
  end;

  Result := True;

  except on E: Exception do
         begin
           SL := TStringList.Create;
           TRY
             SL := GetCallStack;
             ShowMessage( 'Exception 11873: ' + E.Message + #13#10 + SL.Text );
           FINALLY
             SL.Free;
           END;
         end;
  end;

  SL.Free;
  Source.Free;
  AForms.Free;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.GenerateDPR' );
  END;
end;

function TKOLProject.GetBuild: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.GetBuild', 0
  @@e_signature:
  end;
  Result := fBuild;
end;

function TKOLProject.GetIsKOLProject: Boolean;
var SL: TStringList;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.GetIsKOLProject', 0
  @@e_signature:
  end;
  Log( '->GetIsKOLProject' );
  TRY

  Result := FALSE;
  if not FLocked then
  begin
    if fIsKOL = 0 then
    begin
      //ShowMessage( 'find if project Is KOL...' );
      if (SourcePath <> '') and DirectoryExists( SourcePath ) and
         (ProjectName <> '') and FileExists( SourcePath + ProjectName + '.dpr' ) then
      begin
        //ShowMessage( 'find if project Is KOL in ' + SourcePath + ProjectName + '.dpr' );
        SL := TStringList.Create;
        try
          LoadSource( SL, SourcePath + ProjectName + '.dpr' );
          for I := 0 to SL.Count - 1 do
            if SL[ I ] = Signature then
            begin
              fIsKOL := 1;
              break;
            end;
          //if fIsKOL = 0 then
          //  fIsKOL := -1;
        finally
          SL.Free;
        end;
        //ShowMessage( IntToStr( fIsKOL ) );
      end;
    end;
    Result := fIsKOL > 0;
  end;

  LogOK;
  FINALLY
    Log( '<-GetIsKOLProject' );
  END;
end;

function TKOLProject.GetOutdcuPath: TFileName;
var S: String;
    L: TStringList;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.GetOutdcuPath', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.GetOutdcuPath' );
  TRY

  Result := '';
  if not FLocked then
  begin
    Result := SourcePath;
    S := SourcePath + ProjectName + '.cfg';
    if FileExists( S ) then
    begin
      L := TStringList.Create;
      L.LoadFromFile( S );
      for I := 0 to L.Count - 1 do
      begin
        if Length( L[ I ] ) < 2 then continue;
        if L[ I ][ 2 ] = 'N' then
        begin
          S := Trim( Copy( L[ I ], 3, Length( L[ I ] ) - 2 ) );
          if S[ 1 ] = '"' then
            S := Copy( S, 2, Length( S ) - 1 );
          if S[ Length( S ) ] = '"' then
            S := Copy( S, 1, Length( S ) - 1 );
          Result := S;
          break;
        end;
      end;
      L.Free;
    end;

    if Result = '' then
      Result := fOutdcuPath;
    if Result <> '' then
    if Result[ Length( Result ) ] <> '\' then
      Result := Result + '\';
    fOutdcuPath := Result;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.GetOutdcuPath' );
  END;
end;

function TKOLProject.GetProjectDest: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.GetProjectDest', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.GetProjectDest' );
  TRY

  Result := '';
  if not FLocked then
  begin
    //Result := ProjectName;
    if IsKOLProject then
      Result := ProjectName
    else
    begin
      Result := FProjectDest;
      if (ProjectName <> '') and (LowerCase(Result) = LowerCase(ProjectName)) then
        Result := '';
    end;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.GetProjectDest' );
  END;
end;

function TKOLProject.GetProjectName: String;
var Wnd: HWnd;
    Len, I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.GetProjectName', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.GetProjectName' );
  TRY

  Result := fProjectName;
  if csDesigning in ComponentState then
  begin
    if ToolServices <> nil then
    begin
      Result := ExtractFileNameWOExt( ToolServices.GetProjectName );
      LogOK;
      exit;
    end;
    Wnd := FindWindow( 'TAppBuilder', nil );
    if Wnd <> 0 then
    begin
      Len := GetWindowTextLength( Wnd );
      if Len > 0 then
      begin
        SetString( Result, nil, Len );
        GetWindowText( Wnd, PChar( Result ), Len + 1 );
        I := pos( '-', Result );
        if I > 0 then
          Result := Trim( Copy( Result, I + 1, Length( Result ) - I ) );
        if pos( '[', Result ) > 0 then
          Result := Trim( Copy( Result, 1, pos( '[', Result ) - 1 ) ); 
        if pos( '(', Result ) > 0 then
          Result := Trim( Copy( Result, 1, pos( '(', Result ) - 1 ) );
      end;
    end;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.GetProjectName' )
  END;
end;

function TKOLProject.GetShowReport: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.GetShowReport', 0
  @@e_signature:
  end;
  //Log( '->TKOLProject.GetShowReport' );
  TRY

  Result := fShowReport;
  if AutoBuilding then
    Result := False;

  LogOK;
  FINALLY
    //Log( '<-TKOLProject.GetShowReport' );
  END;
end;

{$IFDEF _D2}
function SHBrowseForFolder(var lpbi: TBrowseInfo): PItemIDList; stdcall;
  external 'shell32.dll' name 'SHBrowseForFolderA';
function SHGetPathFromIDList(pidl: PItemIDList; pszPath: PChar): BOOL; stdcall;
  external 'shell32.dll' name 'SHGetPathFromIDListA';
procedure CoTaskMemFree(pv: Pointer); stdcall;
  external 'ole32.dll' name 'CoTaskMemFree';
{$ENDIF}

function TKOLProject.GetSourcePath: TFileName;
var BI: TBrowseInfo;
    IIL: PItemIdList;
    Buf: array[ 0..MAX_PATH ] of Char;
    SL: TStringList;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.GetSourcePath', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.GetSourcePath' );
  TRY

  Result := '';
  TRY
    if FLocked then
    begin
      LogOK; Exit;
    end;
    Result := fSourcePath;
    if Result <> '' then
      if Result[ Length( Result ) ] <> '\' then
        Result := Result + '\';
    if (Result <> '') and DirectoryExists( Result ) {and (FprojectDest <> '') and
       FileExists( Result + FprojectDest + '.dpr' )} then
    begin
      LogOK; Exit;
    end;
    if fGettingSourcePath then
    begin
      LogOK; Exit;
    end;
    fGettingSourcePath := True;
    TRY
      try
        if Result <> '' then
        if Result[ Length( Result ) ] <> '\' then
          Result := Result + '\';
        if Result <> '' then
        if not DirectoryExists( Result ) or
           not FileExists( Result + fprojectDest + '.dpr' ) or
           not IsKOLProject then
           Result := '';
        if Result = '' then
        if csDesigning in ComponentState then
        //if not (csLoading in ComponentState) then
        begin
          try
            if ToolServices <> nil then
            begin
              Result := ToolServices.GetProjectName;
              Result := ExtractFilePath( Result );
            end;
          except on E: Exception do
             begin
               SL := TStringList.Create;
               TRY
                 SL := GetCallStack;
                 ShowMessage( 'Exception 12108: ' + E.Message + #13#10 + SL.Text );
               FINALLY
                 SL.Free;
               END;
             end;
          end;

          if Result <> '' then
          begin
            if Result[ Length( Result ) ] <> '\' then
              Result := Result + '\';
            fGettingSourcePath := False;
            LogOK;
            Exit;
          end;

          FillChar( BI, Sizeof( BI ), 0 );
          BI.lpszTitle := 'Define mirror project source (directory ' +
                          'where your source project is located before '+
                          'converting it to KOL).';
          BI.ulFlags := BIF_RETURNONLYFSDIRS;
          BI.pszDisplayName := @Buf[ 0 ];
          IIL := SHBrowseForFolder( BI );
          if IIL <> nil then
          begin
            SHGetPathFromIDList( IIL, @Buf[ 0 ] );
            CoTaskMemFree( IIL );
            Result := Buf;
            fSourcePath := Result;
          end;
        end;
        if Result <> '' then
        if Result[ Length( Result ) ] <> '\' then
          Result := Result + '\';
      except on E: Exception do
             begin
               SL := TStringList.Create;
               TRY
                 SL := GetCallStack;
                 ShowMessage( 'Exception 12146: ' + E.Message + #13#10 + SL.Text );
               FINALLY
                 SL.Free;
               END;
             end;
      end;
    FINALLY
      fGettingSourcePath := False;
    END;
  EXCEPT
    on E: Exception do
    begin
      ShowMessage( 'Can not obtain project source path, exception: ' + E.Message );
      Result := '';
    end;
  END;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.GetSourcePath' );
  END;
end;

procedure TKOLProject.Loaded;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.Loaded', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.Loaded' );
  TRY
    inherited;
    //fTimer.Enabled := TRUE;
    BroadCastPaintTypeToAllForms;
  LogOK;
  FINALLY
    Log( '<-TKOLProject.Loaded' );
  END;
end;

procedure TKOLProject.MakeResourceString(const ResourceConstName,
  Value: String);
begin
  Log( '->TKOLProject.MakeResourceString' );
  TRY

  if ResStrings = nil then
    ResStrings := TStringList.Create;
  ResStrings.Add( 'resourcestring ' + ResourceConstName + ' = ' + String2Pascal( Value ) + ';' );

  LogOK;
  FINALLY
    Log( '<-TKOLProject.MakeResourceString' );
  END;
end;

procedure TKOLProject.Report(const Txt: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.Report', 0
  @@e_signature:
  end;
  if FLocked then Exit;
  if FConsoleOut and (FOut <> 0) then
    Writeln( FOut, Txt );
  if ShowReport and Building then
    ShowMessage( Txt );
end;

procedure TKOLProject.SetAutoBuild(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetAutoBuild', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetAutoBuild' );
  TRY

  if not FLocked then
  begin
    if fAutoBuild <> Value then
    begin
      fAutoBuild := Value;
      if Value then
      begin
        // Setup timer
        if fTimer = nil then
          fTimer := TTimer.Create( Self );
        fTimer.Interval := FAutoBuildDelay;
        fTimer.OnTimer := TimerTick;
      end
         else
      begin
        // Stop timer
        if fTimer <> nil then
          fTimer.Enabled := False;
      end;
    end;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetAutoBuild' );
  END;
end;

procedure TKOLProject.SetAutoBuildDelay(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetAutoBuildDelay', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetAutoBuildDelay' );
  TRY

  if not FLocked then
  begin
    FAutoBuildDelay := Value;
    if fAutoBuildDelay < 0 then
      fAutoBuildDelay := 0;
    if AutoBuildDelay > 3000 then
      fAutoBuildDelay := 3000;
    if fTimer <> nil then
    if fAutoBuildDelay > 50 then
      fTimer.Interval := Value
    else
      fTimer.Interval := 50;
  end;
  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetAutoBuildDelay' );
  END;
end;

procedure TKOLProject.SetBuild(const Value: Boolean);
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetBuild', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetBuild' );
  TRY

  if not (csLoading in ComponentState) and not FLocked then
  begin
    if not IsKOLProject then
    begin
      S := 'Option <Build> is not available at design time ' +
           'unless project is already converted to KOL-MCK.';
      if projectDest = '' then
        S := S + #13#10'To convert a project to KOL-MCK, change property ' +
             'projectDest of TKOLProject component!';
      ShowMessage( S );
      LogOK;
      Exit;
    end;
    if Value = False then
    begin
      LogOK;
      Exit;
    end;
    fBuild := TRUE;
    try
      ConvertVCL2KOL( TRUE, FALSE );
    except
      on E: Exception do
      begin
        ShowMessage( 'ConvertVCL2KOL failed, exception: ' + E.Message );
      end;
    end;
    fBuild := False;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetBuild' );
  END;
end;

procedure TKOLProject.SetConsoleOut(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetConsoleOut', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetConsoloeOut' );
  TRY

  if not FLocked and (FConsoleOut <> Value) then
  begin
    FConsoleOut := Value;
    if Value then
    begin
      AllocConsole;
      FOut := GetStdHandle( STD_OUTPUT_HANDLE );
      if FOut <> 0 then
      begin
        FIn := GetStdHandle( STD_INPUT_HANDLE );
        SetConsoleTitle( 'KOL MCK console. Do not close! (use prop. ConsoleOut)' );
        SetConsoleMode( FIn, ENABLE_PROCESSED_OUTPUT or ENABLE_WRAP_AT_EOL_OUTPUT	);
      end
         else FConsoleOut := False;
    end
       else
      FreeConsole;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetConsoleOut' );
  END;
end;

procedure TKOLProject.SetHelpFile(const Value: String);
begin
  Log( '->TKOLProject.SetHelpFile' );
  TRY

  FHelpFile := Value;
  Change;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetHelpFile' );
  END;
end;

procedure TKOLProject.SetIsKOLProject(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetIsKOLProject', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetIsKOLProject' );
  TRY

  if not FLocked and not (csLoading in ComponentState) then
  begin
    if Value then
    begin
      GetIsKOLProject;
      if fIsKOL < 1 then
      begin
        ShowMessage( 'Your project is not yet converted to KOL-MCK. '+
                     'To convert it, change property projectDest of TKOLProject first, ' +
                     'and then drop TKOLForm (or change any TKOLForm property, if ' +
                     'it is already dropped). Then, open destination project and work ' +
                     'with it.' );
        LogOK;
        Exit;
      end;
    end
      else
    begin
      fIsKOL := 0;
      GetIsKOLProject;
    end;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetIsKOLProject' );
  END;
end;

procedure TKOLProject.SetLocalizy(const Value: Boolean);
begin
  Log( '->TKOLProject.SetLocalizy' );
  TRY

  FLocalizy := Value;
  Change;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetLocalizy' );
  END;
end;

procedure TKOLProject.SetLocked(const Value: Boolean);
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetLocked', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetLocked' );
  TRY

  if FLocked = Value then
  begin
    LogOK;
    Exit;
  end;
  if not Value then
  begin
    for I := 0 to Owner.ComponentCount-1 do
      if IsVCLControl( Owner.Components[ I ] ) then
      begin
        ShowMessage( 'Form ' + Owner.Name + ' contains VCL controls. TKOLProject ' +
                     'component can not be unlocked.' );
        LogOK;
        Exit;
      end;
    I := MessageBox( 0, 'TKOLProject component was locked because one of project''s form had ' +
         'VCL controls placed on it. Are You sure You want to unlock TKOLProject?'#13 +
         '(Note: if the the project is VCL-based, unlocking TKOLProject ' +
         'component can damage it).', 'CAUTION!', MB_YESNO or MB_SETFOREGROUND );
    if I = ID_NO then
    begin
      LogOK;
      Exit;
    end;
  end;
  FLocked := Value;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetLocked' );
  END;
end;

procedure TKOLProject.SetName(const NewName: TComponentName);
var I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetName', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetName' );
  TRY

  inherited;
  if not (csLoading in ComponentState) then
  if Owner <> nil then
  if Owner is TForm then
  if IsKOLProject then
  begin
    for I := 0 to (Owner as TForm).ComponentCount-1 do
    begin
      C := (Owner as TForm).Components[ I ];
      if C is TKOLForm then
      begin
        Build := TRUE;
        break;
      end;
    end;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetName' );
  END;
end;

procedure TKOLProject.SetOutdcuPath(const Value: TFileName);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetOutdcuPath', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetOutdcuPath' );
  TRY
    fOutdcuPath := ''; //TODO: understand what is it...
    //if FLocked then Exit;
  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetOutdcuPath' );
  END;
end;

procedure TKOLProject.SetPaintType(const Value: TPaintType);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetPaintType', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetPaintType' );
  TRY

  if FPaintType = Value then
  begin
    LogOK; Exit;
  end;
  FPaintType := Value;
  BroadCastPaintTypeToAllForms;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetPaintType' );
  END;
end;

procedure TKOLProject.SetProjectDest(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetProjectDest', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetProjectDest' );
  TRY

  if not FLocked then
  begin
    if not IsValidIdent( Value ) then
      ShowMessage( 'Destination project name must be valid identifier.' )
    else
    if (ProjectName = '') or (LowerCase( Value ) <> LowerCase( ProjectName )) then
      FProjectDest := Value;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetProjectDest' );
  END;
end;

procedure TKOLProject.SetShowHint(const Value: Boolean);
begin
  Log( '->TKOLProject.SetShowHint' );
  TRY

  FShowHint := Value;
  Change;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetShowHint' );
  END;
end;

procedure TKOLProject.SetSupportAnsiMnemonics(const Value: LCID);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetSupportAnsiMnemonics', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetSupportAnsiMnemonics' );
  TRY
    FSupportAnsiMnemonics := Value;
    Change;
  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetSupportAnsiMnemonics' );
  END;
end;

function TKOLProject.StringConstant(const Propname, Value: String): String;
begin
  Log( '->TKOLProject.StringConstant' );
  TRY

  if Localizy and (Value <> '') then
  begin
    Result := Name + '_' + Propname;
    MakeResourceString( Result, Value );
  end
    else
  begin
    Result := String2Pascal( Value );
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.StringConstant' );
  END;
end;

procedure TKOLProject.TimerTick( Sender: TObject );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.TimerTick', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.TimerTick' );
  TRY

  if not FBuilding then
  begin
  fTimer.Enabled := False;
  if not FLocked then
  begin
    if AutoBuild then
    begin
      AutoBuilding := True;
      ConvertVCL2KOL( FALSE, FALSE );
      AutoBuilding := False;
    end;
  end;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.TimerTick' );
  END;
end;

function TKOLProject.UpdateConfig: Boolean;
var S, R: String;
    L: TStringList;
    I: Integer;
    AFound, DFound {, DWere}: Boolean;
    Updated: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.UpdateConfig', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.UpdateConfig' );
  TRY

  Result := False;
  if not FLocked then
  begin
    S := SourcePath + ProjectName + '.cfg';
    R := SourcePath + ProjectDest + '.cfg';
    L := TStringList.Create;
    //DWere := FALSE;
    if FileExists( S ) then
    begin
      LoadSource( L, S );
      AFound := False;
      DFound := False;
      for I := 0 to L.Count - 1 do
      begin
        if Length( L[ I ] ) < 2 then continue;
        if L[ I ][ 2 ] = 'A' then
        begin
          L[ I ] := '-AClasses=;Controls=;mirror=';
          AFound := True;
        end;
        if L[ I ][ 2 ] = 'D' then
        begin
          {if pos( 'KOL_MCK', UpperCase( L[ I ] ) ) then
            DWere := TRUE;}
          if pos( 'KOL_MCK', UpperCase( L[ I ] ) ) <= 0 then
            L[ I ] := //'-DKOL_MCK';
                      IncludeTrailingChar( L[ I ], ';' ) + 'KOL_MCK';
          DFound := True;
        end;
      end;
      if not AFound then
        L.Add( '-AClasses=;Controls=;StdCtrls=;ExtCtrls=;mirror=' );
      if not DFound then
        L.Add( '-DKOL_MCK' );
      SaveStrings( L, R, Updated );
    end;
    L.Clear;
    S := SourcePath + ProjectName + '.dof';
    R := SourcePath + ProjectDest + '.dof';
    if FileExists( S ) then
    begin
      LoadSource( L, S );
      for I := 0 to L.Count - 1 do
      begin
        if Copy( L[ I ], 1, Length( 'UnitAliases=' ) ) = 'UnitAliases=' then
          L[ I ] := 'UnitAliases=Classes=;mirror=';
        if Copy( L[ I ], 1, Length( 'Conditionals=' ) ) = 'Conditionals=' then
        if pos( 'KOL_MCK', UpperCase( L[ I ] ) ) <= 0 then
          L[ I ] := 'Conditionals=KOL_MCK';
      end;
      SaveStrings( L, R, Updated );
    end;
    L.Free;
  end;
  LogOK;
  FINALLY
    Log( '<-TKOLProject.UpdateConfig' );
  END;
end;

{ TFormBounds }

procedure TFormBounds.Change;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.Change', 0
  @@e_signature:
  end;
  fL := Left;
  fT := Top;
  fH := Height;
  fW := Width;
  (Owner as TKOLForm).Change( nil );
  if not (csLoading in (Owner as TKOLForm).ComponentState) then
    (Owner as TKOLForm).AlignChildren( nil, FALSE );
end;

procedure TFormBounds.CheckFormSize(Sender: TObject);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.CheckFormSize', 0
  @@e_signature:
  end;
  if Owner = nil then Exit;
  //if Owner.Name = '' then Exit;
  if Owner.Owner = nil then Exit;
  //if Owner.Owner.Name = '' then Exit;
  if csLoading in (Owner as TComponent).ComponentState then Exit;
  if csLoading in (Owner.Owner as TComponent).ComponentState then Exit;
  if fL = (Owner.Owner as TForm).Left then
  if fT = (Owner.Owner as TForm).Top then
  if fW = (Owner.Owner as TForm).Width then
  if fH = (Owner.Owner as TForm).Height then Exit;
  {Rpt( 'L=' + IntToStr( fL ) + ' <> ' + IntToStr( (Owner.Owner as TForm).Left ) + #13#10 +
       'T=' + IntToStr( fT ) + ' <> ' + IntToStr( (Owner.Owner as TForm).Top ) + #13#10 +
       'W=' + IntToStr( fW ) + ' <> ' + IntToStr( (Owner.Owner as TForm).Width ) + #13#10 +
       'H=' + IntToStr( fH ) + ' <> ' + IntToStr( (Owner.Owner as TForm).Height ) + #13#10 );}
  Change;
end;

constructor TFormBounds.Create;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.Create', 0
  @@e_signature:
  end;
  inherited;
  fTimer := TTimer.Create( Owner );
  fTimer.Interval := 300;
  fTimer.OnTimer := CheckFormSize;
  fTimer.Enabled := FALSE;
end;

destructor TFormBounds.Destroy;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.Destroy', 0
  @@e_signature:
  end;
  if Assigned( fTimer ) then
  begin
    fTimer.Enabled := False;
    fTimer.Free;
    fTimer := nil;
  end;
  inherited;
end;

procedure TFormBounds.EnableTimer(Value: Boolean);
begin
  fTimer.Enabled := Value;
end;

function TFormBounds.GetHeight: Integer;
var F: TControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.GetHeight', 0
  @@e_signature:
  end;
  F := Owner.Owner as TControl;
  Result := F.Height;
end;

function TFormBounds.GetLeft: Integer;
var F: TControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.GetLeft', 0
  @@e_signature:
  end;
  F := Owner.Owner as TControl;
  Result := F.Left;
end;

function TFormBounds.GetTop: Integer;
var F: TControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.GetTop', 0
  @@e_signature:
  end;
  F := Owner.Owner as TControl;
  Result := F.Top;
end;

function TFormBounds.GetWidth: Integer;
var F: TControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.GetWidth', 0
  @@e_signature:
  end;
  F := Owner.Owner as TControl;
  Result := F.Width;
end;

procedure TFormBounds.SetHeight(const Value: Integer);
var F: TControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.SetHeight', 0
  @@e_signature:
  end;
  fH := Value;
  F := Owner.Owner as TControl;
  F.Height := Value;
  Change;
end;

procedure TFormBounds.SetLeft(const Value: Integer);
var F: TControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.SetLeft', 0
  @@e_signature:
  end;
  fL := Value;
  F := Owner.Owner as TControl;
  F.Left := Value;
  Change;
end;

procedure TFormBounds.SetOwner(const Value: TComponent);
begin
  fOwner := Value;
  if fOwner <> nil then
  if not(csLoading in fOwner.ComponentState) then
    fTimer.Enabled := True;
end;

procedure TFormBounds.SetTop(const Value: Integer);
var F: TControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.SetTop', 0
  @@e_signature:
  end;
  fT := Value;
  F := Owner.Owner as TControl;
  F.Top := Value;
  Change;
end;

procedure TFormBounds.SetWidth(const Value: Integer);
var F: TControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.SetWidth', 0
  @@e_signature:
  end;
  fW := Value;
  F := Owner.Owner as TControl;
  F.Width := Value;
  Change;
end;

{ TKOLObj }

function TKOLObj.AdditionalUnits: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.AdditionalUnits', 0
  @@e_signature:
  end;
  Result := '';
end;

procedure TKOLObj.AddToNotifyList(Sender: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.AddToNotifyList', 0
  @@e_signature:
  end;
  if Assigned( fNotifyList ) then
  if fNotifyList.IndexOf( Sender ) < 0 then
    fNotifyList.Add( Sender );
end;

procedure TKOLObj.AssignEvents(SL: TStringList; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.AssignEvents', 0
  @@e_signature:
  end;
  DoAssignEvents( SL, AName,
  [ 'OnDestroy' ],
  [ @ OnDestroy ] );
end;

function TKOLObj.BestEventName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.BestEventName', 0
  @@e_signature:
  end;
  Result := '';
end;

procedure TKOLObj.Change;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.Change', 0
  @@e_signature:
  end;
  if (csLoading in ComponentState) then Exit;
  if ParentKOLForm = nil then Exit;
  ParentKOLForm.Change( Self );
end;

function TKOLObj.CompareFirst(c, n: string): boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.CompareFirst', 0
  @@e_signature:
  end;
  Result := FALSE;
end;

constructor TKOLObj.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.Create', 0
  @@e_signature:
  end;
  fNotifyList := TList.Create;
  inherited;
  NeedFree := True;
end;

destructor TKOLObj.Destroy;
var F: TKOLForm;
    I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.Destroy', 0
  @@e_signature:
  end;
  if Assigned( Owner ) and not (csDestroying in Owner.ComponentState) then
  if Assigned( fNotifyList ) then
    for I := fNotifyList.Count-1 downto 0 do
    begin
      C := fNotifyList[ I ];
      if C is TKOLObj then
        (C as TKOLObj).NotifyLinkedComponent( Self, noRemoved )
      else
      if C is TKOLCustomControl then
        (C as TKOLCustomControl).NotifyLinkedComponent( Self, noRemoved );
    end;
  fNotifyList.Free;
  fNotifyList := nil;
  F := ParentKOLForm;
  inherited;
  if (F <> nil) and not F.FIsDestroying and (Owner <> nil) and
     not(csDestroying in Owner.ComponentState) then
    F.Change( F );
end;

procedure TKOLObj.DoAssignEvents(SL: TStringList; const AName: String;
  EventNames: array of PChar; EventHandlers: array of Pointer);
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.DoAssignEvents', 0
  @@e_signature:
  end;
  for I := 0 to High( EventHandlers ) do
  begin
    if EventHandlers[ I ] <> nil then
    begin
      SL.Add( '      ' + AName + '.' + EventNames[ I ] + ' := Result.' +
              ParentForm.MethodName( EventHandlers[ I ] ) + ';' );
    end;
  end;
end;

procedure TKOLObj.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.FirstCreate', 0
  @@e_signature:
  end;
end;

procedure TKOLObj.DoGenerateConstants( SL: TStringList );
begin
  //
end;

function TKOLObj.Get_Tag: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.Get_Tag', 0
  @@e_signature:
  end;
  Result := F_Tag;
end;

function TKOLObj.NotAutoFree: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.NotAutoFree', 0
  @@e_signature:
  end;
  Result := not NeedFree;
end;

procedure TKOLObj.NotifyLinkedComponent(Sender: TObject;
  Operation: TNotifyOperation);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.NotifyLinkedComponent', 0
  @@e_signature:
  end;
  if Operation = noRemoved then
  if Assigned( fNotifyList ) then
    fNotifyList.Remove( Sender );
end;

function TKOLObj.ParentForm: TForm;
var C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.ParentForm', 0
  @@e_signature:
  end;
  C := Owner;
  while (C <> nil) and not(C is TForm) do
    C := C.Owner;
  Result := nil;
  if C <> nil then
  if C is TForm then
    Result := C as TForm;
end;

function TKOLObj.ParentKOLForm: TKOLForm;
var C, D: TComponent;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.ParentKOLForm', 0
  @@e_signature:
  end;
  C := Owner;
  while (C <> nil) and not(C is TForm) do
    C := C.Owner;
  Result := nil;
  if C <> nil then
  if C is TForm then
  begin
    for I := 0 to (C as TForm).ComponentCount - 1 do
    begin
      D := (C as TForm).Components[ I ];
      if D is TKOLForm then
      begin
        Result := D as TKOLForm;
        break;
      end;
    end;
  end;
end;

procedure TKOLObj.SetName(const NewName: TComponentName);
var OldName, NameNew: String;
    I, N: Integer;
    Success: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.SetName', 0
  @@e_signature:
  end;
  OldName := Name;
  inherited SetName( NewName );
  if (Copy( NewName, 1, 3 ) = 'KOL') and (OldName = '') then
  begin
    NameNew := Copy( NewName, 4, Length( NewName ) - 3 );
    Success := True;
    if Owner <> nil then
    while Owner.FindComponent( NameNew ) <> nil do
    begin
      Success := False;
      for I := 1 to Length( NameNew ) do
      begin
        if NameNew[ I ] in [ '0'..'9' ] then
        begin
          Success := True;
          N := StrToInt( Copy( NameNew, I, Length( NameNew ) - I + 1 ) );
          Inc( N );
          NameNew := Copy( NameNew, 1, I - 1 ) + IntToStr( N );
          break;
        end;
      end;
      if not Success then break;
    end;
    if Success then
      Name := NameNew;
    if not (csLoading in ComponentState) then
      FirstCreate;
  end;
  Change;
end;

procedure TKOLObj.SetOnDestroy(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.SetOnDestroy', 0
  @@e_signature:
  end;
  FOnDestroy := Value;
  Change;
end;

procedure TKOLObj.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.SetupFirst', 0
  @@e_signature:
  end;
  SL.Add( Prefix + AName + ' := New' + TypeName + ';' );
  if Name <> '' then
  begin
    SL.Add( '   {$IFDEF USE_NAMES}' );
    SL.Add( Prefix + AName + '.Name := ''' + Name + ''';' );
    SL.Add( '   {$ENDIF}' );
  end;
  GenerateTag( SL, AName, Prefix );
end;

procedure TKOLObj.SetupLast(SL: TStringList; const AName, AParent, Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.SetupLast', 0
  @@e_signature:
  end;
  // по умолчанию ничего не надо... Разве только в наследниках.
end;

function TKOLObj.TypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.TypeName', 0
  @@e_signature:
  end;
  Result := ClassName;
  if UpperCase( Copy( Result, 1, 4 ) ) = 'TKOL' then
    Result := Copy( Result, 5, Length( Result ) - 4 );
end;

procedure TKOLObj.Set_Tag(const Value: Integer);
begin
  F_Tag := Value;
  Change;
end;

procedure TKOLObj.GenerateTag(SL: TStringList; const AName,
  APrefix: String);
var S: String;
begin
  if F_Tag <> 0 then
  begin
    S := IntToStr( F_Tag );
    if Integer( F_Tag ) < 0 then
      S := 'DWORD( ' + S + ' )';
    SL.Add( APrefix + AName + '.Tag := ' + S + ';' )
  end;
end;

function TKOLObj.StringConstant(const Propname, Value: String): String;
begin
  if (Value <> '') AND
     ((Localizy = loForm) and (ParentKOLForm <> nil) and
     (ParentKOLForm.Localizy) or (Localizy = loYes)) then
  begin
    Result := ParentKOLForm.Name + '_' + Name + '_' + Propname;
    ParentKOLForm.MakeResourceString( Result, Value );
  end
    else
  begin
    Result := String2Pascal( Value );
  end;
end;

procedure TKOLObj.SetLocalizy(const Value: TLocalizyOptions);
begin
  FLocalizy := Value;
  Change;
end;

function TKOLObj.OwnerKOLForm( AOwner: TComponent ): TKOLForm;
var C, D: TComponent;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.ParentKOLForm', 0
  @@e_signature:
  end;
  C := AOwner;
  while (C <> nil) and not(C is TForm) do
    C := C.Owner;
  Result := nil;
  if C <> nil then
  if C is TForm then
  begin
    for I := 0 to (C as TForm).ComponentCount - 1 do
    begin
      D := (C as TForm).Components[ I ];
      if D is TKOLForm then
      begin
        Result := D as TKOLForm;
        break;
      end;
    end;
  end;
end;

procedure TKOLObj.DoNotifyLinkedComponents(Operation: TNotifyOperation);
var I: Integer;
    C: TComponent;
begin
  if Assigned( fNotifyList ) then
    for I := fNotifyList.Count-1 downto 0 do
    begin
      C := fNotifyList[ I ];
      if C is TKOLObj then
        (C as TKOLObj).NotifyLinkedComponent( Self, Operation )
      else
      if C is TKOLCustomControl then
        (C as TKOLCustomControl).NotifyLinkedComponent( Self, Operation );
    end;
end;

{ TKOLFont }

procedure TKOLFont.Assign(Value: TPersistent);
var F: TKOLFont;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.Assign', 0
  @@e_signature:
  end;
  //inherited;
  if Value is TKOLFont then
  begin
    F := Value as TKOLFont;
    FColor := F.Color;
    //Rpt( '-------------------------------Assigned font color:' + Int2Hex( Color2RGB( F.Color ), 8 ) );
    FFontStyle := F.FontStyle;
    FFontHeight := F.FontHeight;
    FFontWidth := F.FontWidth;
    FFontWeight := F.FontWeight;
    FFontName := F.FontName;
    FFontOrientation := F.FontOrientation;
    FFontCharset := F.FontCharset;
    FFontPitch := F.FontPitch;
    Change;
  end;
end;

procedure TKOLFont.Change;
var ParentOfOwner: TComponent;
    {$IFDEF _KOLCtrlWrapper_}
    _FKOLCtrl: PControl;
    {$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.Change', 0
  @@e_signature:
  end;
  if fOwner = nil then Exit;
  if csLoading in fOwner.ComponentState then Exit;
  if fChangingNow then Exit;
  try

    if fOwner is TKOLForm then
    begin
      (fOwner as TKOLForm).ApplyFontToChildren;
      (fOwner as TKOLForm).Change( fOwner );
    end
    else
    {if (fOwner is TKOLCustomControl) then
    begin
      if not (csLoading in fOwner.ComponentState) then
      begin
        ParentOfOwner := (fOwner as TKOLCustomControl).ParentKOLControl;
        if ParentOfOwner <> nil then
          if ParentOfOwner is TKolForm then
          begin
            if not Equal2( (ParentOfOwner as TKOLForm).Font ) then
              (fOwner as TKOLCustomControl).ParentFont := FALSE;
          end
            else
          if ParentOfOwner is TKOLCustomControl then
          begin
            if not Equal2( (ParentOfOwner as TKOLCustomControl).Font ) then
              (fOwner as TKOLCustomControl).ParentFont := FALSE;
          end;
      end;}
    ////////////////////////////////////////// changed by YS 11-Dec-2003
    if (fOwner is TKOLCustomControl) then
    begin
      ParentOfOwner := (fOwner as TKOLCustomControl).ParentKOLControl;
      if (ParentOfOwner <> nil) and not (csLoading in ParentOfOwner.ComponentState) then
        if ParentOfOwner is TKolForm then
        begin
          if not Equal2( (ParentOfOwner as TKOLForm).Font ) then
            (fOwner as TKOLCustomControl).ParentFont := FALSE;
        end
          else
        if ParentOfOwner is TKOLCustomControl then
        begin
          if not Equal2( (ParentOfOwner as TKOLCustomControl).Font ) then
            (fOwner as TKOLCustomControl).ParentFont := FALSE;
        end;
  //////////////////////////////////////////////////////////////////////////////
  {YS}
  {$IFDEF _KOLCtrlWrapper_}
      if Assigned((fOwner as TKOLCustomControl).FKOLCtrl) then
      begin
          _FKOLCtrl := (fOwner as TKOLCustomControl).FKOLCtrl;
          if not Equal2(nil) then
          begin
            _FKOLCtrl.Font.FontName:=FontName;
            _FKOLCtrl.Font.FontHeight:=FontHeight;
            _FKOLCtrl.Font.FontWidth:=FontWidth;
            _FKOLCtrl.Font.Color:=Self.Color;
            _FKOLCtrl.Font.FontStyle:= KOL.TFontStyle( FontStyle );
            {$IFNDEF _D2}
            _FKOLCtrl.Font.FontCharset:=FontCharset;
            {$ENDIF}
          end
          else
            _FKOLCtrl.Font.AssignHandle((fOwner as TKOLCustomControl).GetDefaultControlFont);
          (fOwner as TKOLCustomControl).Invalidate;
      end;
  {$ENDIF}
{YS}
      (fOwner as TKOLCustomControl).ApplyFontToChildren;
      (fOwner as TKOLCustomControl).Change;
      (fOwner as TKOLCustomControl).Invalidate;
    end                               // correct by Gendalf
      else                            // +
        if (fOwner is TKOLObj) then   // +
          (fOwner as TKOLObj).Change; // +

  finally
    fChangingNow := FALSE;
  end;
end;

procedure TKOLFont.Changing;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.Changing', 0
  @@e_signature:
  end;
  if fOwner is TKOLForm then
    (fOwner as TKOLForm).CollectChildrenWithParentFont
  else
  if fOwner is TKOLCustomControl then
    (fOwner as TKOLCustomControl).CollectChildrenWithParentFont;
end;

constructor TKOLFont.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.Create', 0
  @@e_signature:
  end;
  inherited Create;
  fOwner := AOwner;
  fColor := clWindowText;
  fFontName := 'MS Sans Serif';
  fFontWidth := 0;
  fFontHeight := 0;
  fFontCharset := DEFAULT_CHARSET;
  fFontPitch := fpDefault;
  FFontOrientation := 0;
  FFontWeight := 0;
  FFontStyle := [ ];
end;

function TKOLFont.Equal2(AFont: TKOLFont): Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.Equal2', 0
  @@e_signature:
  end;
  Result := False;
  if AFont = nil then
  begin
    if Color <> clWindowText then Exit;
    if FontStyle <> [ ] then Exit;
    if FontHeight <> 0 then Exit;
    if FontWidth <> 0 then Exit;
    if FontWeight <> 0 then Exit;
    if FontName <> 'MS Sans Serif' then Exit;
    if FontOrientation <> 0 then Exit;
    if FontCharset <> DEFAULT_CHARSET then Exit;
    if FontPitch <> fpDefault then Exit;
    Result := True;
    Exit;
  end;
  if Color <> AFont.Color then Exit;
  if FontStyle <> AFont.FontStyle then Exit;
  if FontHeight <> AFont.FontHeight then Exit;
  if FontWidth <> AFont.FontWidth then Exit;
  if FontWeight <> AFont.FontWeight then Exit;
  if FontName <> AFont.FontName then Exit;
  if FontOrientation <> AFont.FontOrientation then Exit;
  if FontCharset <> AFont.FontCharset then Exit;
  if FontPitch <> AFont.FontPitch then Exit;
  Result := True;
end;

procedure TKOLFont.GenerateCode(SL: TStrings; const AName: String;
  AFont: TKOLFont);
const
  FontPitches: array[ TFontPitch ] of String = ( 'fpDefault', 'fpVariable', 'fpFixed' );
var BFont: TKOLFont;
    S: String;
    FontPname: String;
    Lines: Integer;

    procedure AddLine( const S: String );
    begin
      if Lines = 0 then
        if (fOwner <> nil) and (fOwner is TKOLCustomControl) then
          (fOwner as TKOLCustomControl).BeforeFontChange( SL, AName, '    ' );
      Inc( Lines );
      //Rpt( AName + '.' + FontPname + '.' + S + ';' );
      SL.Add( '    ' + AName + '.' + FontPname + '.' + S + ';' );
    end;

begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.GenerateCode', 0
  @@e_signature:
  end;
  //Rpt( fOwner.Name );
  BFont := AFont;
  if AFont = nil then
    BFont := TKOLFont.Create( nil );

  FontPname := 'Font';
  Lines := 0;
  if (fOwner <> nil) and (fOwner is TKOLCustomControl) then
    FontPname := (fOwner as TKOLCustomControl).FontPropName;

  if Color <> BFont.Color then
    AddLine( 'Color := ' + Color2Str( Color ) );
  if FontStyle <> BFont.FontStyle then
  begin
    S := '';
    if fsBold in TFontStyles( FontStyle ) then
      S := ' fsBold,';
    if fsItalic in TFontStyles( FontStyle ) then
      S := S + ' fsItalic,';
    if fsStrikeout in TFontStyles( FontStyle ) then
      S := S + ' fsStrikeOut,';
    if fsUnderline in TFontStyles( FontStyle ) then
      S := S + ' fsUnderline,';
    if S <> '' then
      S := Trim( Copy( S, 1, Length( S ) - 1 ) );
    AddLine( 'FontStyle := [ ' + S + ' ]' );
  end;
  if FontHeight <> BFont.FontHeight then
    AddLine( 'FontHeight := ' + IntToStr( FontHeight ) );
  if FontWidth <> BFont.FontWidth then
    AddLine( 'FontWidth := ' + IntToStr( FontWidth ) );
  if FontName <> BFont.FontName then
    AddLine( 'FontName := ''' + FontName + '''' );
  if FontOrientation <> BFont.FontOrientation then
    AddLine( 'FontOrientation := ' + IntToStr( FontOrientation ) );
  if FontCharset <> BFont.FontCharset then
    AddLine( 'FontCharset := ' + IntToStr( FontCharset ) );
  if FontPitch <> BFont.FontPitch then
    AddLine( 'FontPitch := ' + FontPitches[ FontPitch ] );

  if AFont = nil then
    BFont.Free;

  if Lines > 0 then
  if (fOwner <> nil) and (fOwner is TKOLCustomControl) then
    (fOwner as TKOLCustomControl).AfterFontChange( SL, AName, '    ' );
end;

procedure TKOLFont.SetColor(const Value: TColor);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.SetColor', 0
  @@e_signature:
  end;
  if FColor = Value then Exit;
  if Value <> clWindowText then
  begin
    if Assigned( fOwner ) then
    if fOwner is TKOLCustomControl then
    if (fOwner as TKOLCustomControl).CanNotChangeFontColor then
    begin
      ShowMessage( 'Can not change font color for some of controls, such as button.' );
      Exit;
    end;
  end;
  Changing;
  FColor := Value;
  Change;
end;

procedure TKOLFont.SetFontCharset(const Value: Byte);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.SetFontCharset', 0
  @@e_signature:
  end;
  if FFontCharset = Value then Exit;
  Changing;
  FFontCharset := Value;
  Change;
end;

procedure TKOLFont.SetFontHeight(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.SetFontHeight', 0
  @@e_signature:
  end;
  if FFontHeight = Value then Exit;
  Changing;
  FFontHeight := Value;
  Change;
end;

procedure TKOLFont.SetFontName(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.SetFontName', 0
  @@e_signature:
  end;
  if FFontName = Value then Exit;
  Changing;
  FFontName := Value;
  Change;
end;

procedure TKOLFont.SetFontOrientation(Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.SetFontOrientation', 0
  @@e_signature:
  end;
  if FFontOrientation = Value then Exit;
  Changing;
  if Value > 3600 then Value := 3600;
  if Value < -3600 then Value := -3600;
  FFontOrientation := Value;
  Change;
end;

procedure TKOLFont.SetFontPitch(const Value: TFontPitch);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.SetFontPitch', 0
  @@e_signature:
  end;
  if FFontPitch = Value then Exit;
  Changing;
  FFontPitch := Value;
  Change;
end;

procedure TKOLFont.SetFontStyle(const Value: TFontStyles);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.SetFontStyle', 0
  @@e_signature:
  end;
  if FFontStyle = Value then Exit;
  Changing;
  FFontStyle := Value;
  Change;
end;

procedure TKOLFont.SetFontWeight(Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.SetFontWeight', 0
  @@e_signature:
  end;
  if Value < 0 then Value := 0;
  if Value > 1000 then Value := 1000;
  if FFontWeight = Value then Exit;
  Changing;
  FFontWeight := Value;
  if Value > 0 then
    FFontStyle := FFontStyle + [ fsBold ]
  else
    FFontStyle := FFontStyle - [ fsBold ];
  Change;
end;

procedure TKOLFont.SetFontWidth(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.SetFontWidth', 0
  @@e_signature:
  end;
  if FFontWidth = Value then Exit;
  Changing;
  FFontWidth := Value;
  Change;
end;

{ TKOLProjectBuilder }

procedure TKOLProjectBuilder.Edit;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProjectBuilder.Edit', 0
  @@e_signature:
  end;
  if Component = nil then Exit;
  if not(Component is TKOLProject) then Exit;
  (Component as TKOLProject).SetBuild( True );
end;

procedure TKOLProjectBuilder.ExecuteVerb(Index: Integer);
var SL: TStringList;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProjectBuilder.ExecuteVerb', 0
  @@e_signature:
  end;
  case Index of
  0: Edit;
  1: if Component <> nil then
     if Component is TKOLProject then
     TRY
       S := (Component as TKOLProject).sourcePath;
       ShellExecute( 0, nil, PChar( S ), nil, nil, SW_SHOW );
     EXCEPT on E: Exception do
         begin
           SL := TStringList.Create;
           TRY
             SL := GetCallStack;
             ShowMessage( 'Exception 13611: ' + E.Message + ' (' + S + ')' +
                          #13#10 + SL.Text );
           FINALLY
             SL.Free;
           END;
         end;
     END;
  end;
end;

function TKOLProjectBuilder.GetVerb(Index: Integer): string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProjectBuilder.GetVerb', 0
  @@e_signature:
  end;
  case Index of
  0: Result := 'Convert to KOL';
  1: Result := 'Open project folder';
  end;
end;

function TKOLProjectBuilder.GetVerbCount: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProjectBuilder.GetVerbCount', 0
  @@e_signature:
  end;
  Result := 2;
end;

{$IFDEF _D5}
{ TLeftPropEditor }

function TLeftPropEditor.VisualValue: string;
var Comp: TPersistent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TLeftPropEditor.VisualValue', 0
  @@e_signature:
  end;
  Result := Value;
  Comp := GetComponent( 0 );
  if Comp is TKOLCustomControl then
    Result := IntToStr( (Comp as TKOLCustomControl).actualLeft );
end;

procedure TLeftPropEditor.PropDrawValue(ACanvas: TCanvas;
  const ARect: TRect; ASelected: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TLeftPropEditor.PropDrawValue', 0
  @@e_signature:
  end;
  ACanvas.Brush.Color := clBtnFace;
  ACanvas.Font.Color := clWindowText;
  if ASelected then
  begin
    ACanvas.Brush.Color := clHighLight;
    ACanvas.Font.Color := clHighlightText;
  end;
  ACanvas.TextRect( ARect, ARect.Left, ARect.Top, VisualValue );
end;

{ TTopPropEditor }

procedure TTopPropEditor.PropDrawValue(ACanvas: TCanvas;
  const ARect: TRect; ASelected: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TTopPropEditor.PropDrawValue', 0
  @@e_signature:
  end;
  ACanvas.Brush.Color := clBtnFace;
  ACanvas.Font.Color := clWindowText;
  if ASelected then
  begin
    ACanvas.Brush.Color := clHighLight;
    ACanvas.Font.Color := clHighlightText;
  end;
  ACanvas.TextRect( ARect, ARect.Left, ARect.Top, VisualValue );
end;

function TTopPropEditor.VisualValue: string;
var Comp: TPersistent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TTopPropEditor.VisualValue', 0
  @@e_signature:
  end;
  Result := Value;
  Comp := GetComponent( 0 );
  if Comp is TKOLCustomControl then
    Result := IntToStr( (Comp as TKOLCustomControl).actualTop );
end;
{$ENDIF}

{ TKOLDataModule }

procedure TKOLDataModule.GenerateAdd2AutoFree(SL: TStringList;
  const AName: String; AControl: Boolean; Add2AutoFreeProc: String; Obj: TObject);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.GenerateAdd2AutoFree', 0
  @@e_signature:
  end;
  if Obj <> nil then
  if Obj is TKOLObj then
  if (Obj as TKOLObj).NotAutoFree then
    Exit;
  if Add2AutoFreeProc = '' then
    Add2AutoFreeProc := 'Add2AutoFree';
  if AName <> 'Result' then
    SL.Add( '  Result.' + Add2AutoFreeProc + '( ' + AName + ' );' );
end;

procedure TKOLDataModule.GenerateCreateForm(SL: TStringList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.GenerateCreateForm', 0
  @@e_signature:
  end;
  // do not generate - there are no form
end;

procedure TKOLDataModule.GenerateDestroyAfterRun(SL: TStringList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.GenerateDestroyAfterRun', 0
  @@e_signature:
  end;
  if howToDestroy = ddAfterRun then
    SL.Add( '  ' + inherited FormName + '.Free;' );
end;

function TKOLDataModule.GenerateINC(const Path: String;
  var Updated: Boolean): Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.GenerateINC', 0
  @@e_signature:
  end;
  Result := inherited GenerateINC( Path, Updated );
end;

function TKOLDataModule.GenerateTransparentInits: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.GenerateTransparentInits', 0
  @@e_signature:
  end;
  Result := '';
end;

function TKOLDataModule.Result_Form: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.Result_Form', 0
  @@e_signature:
  end;
  Result := 'nil';
end;

procedure TKOLDataModule.SethowToDestroy(
  const Value: TDataModuleHowToDestroy);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.SethowToDestroy', 0
  @@e_signature:
  end;
  if Value = FhowToDestroy then Exit;
  FhowToDestroy := Value;
  Change( Self );
  if not (csLoading in ComponentState) then
    ChangeDPR;
end;

procedure TKOLDataModule.SetOnCreate(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.SetOnCreate', 0
  @@e_signature:
  end;
  FOnCreate := Value;
  Change( Self );
end;

procedure TKOLDataModule.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.SetupFirst', 0
  @@e_signature:
  end;
  if Name <> '' then
  begin
    SL.Add( '   {$IFDEF USE_NAMES}' );
    //SL.Add( Prefix + AName + '.Name := ''' + Name + ''';' );
    SL.Add( Prefix + 'Result.Name := ''' + Name + ''';' ); {*ecm}
    SL.Add( '   {$ENDIF}' );
  end;
  if howToDestroy = ddOnAppletDestroy then
    SL.Add( Prefix + 'Applet.Add2AutoFree( ' + inherited FormName + ' );' );
end;

procedure TKOLDataModule.SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.SetupLast', 0
  @@e_signature:
  end;
  // nothing
end;

{ TKOLObjectCompEditor }

//////////////////////////////////////////////////////////////////////////////////
{$IFDEF _D6orHigher}                                                            //
procedure TKOLObjectCompEditor.CheckEdit(const PropertyEditor: IProperty);      //
{$ELSE}                                                                         //
//////////////////////////////////////////////////////////////////////////////////
procedure TKOLObjectCompEditor.CheckEdit(PropertyEditor: TPropertyEditor);
var
  FreeEditor: Boolean;
//////////////////////////////////////////////////////////////////////////////////
{$ENDIF}                                                                        //
//////////////////////////////////////////////////////////////////////////////////
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObjectCompEditor.CheckEdit', 0
  @@e_signature:
  end;
{$IFNDEF _D6orHigher}
  FreeEditor := True;
{$ENDIF}
  try
//*///////////////////////////////////////////////////////////////////////////////////////////////
//    if FContinue then EditProperty(PropertyEditor, FContinue, FreeEditor);
//*///////////////////////////////////////////////////////////////////////////////////////////////
    if FContinue then EditProperty(PropertyEditor, FContinue{$IFNDEF _D6orHigher}, FreeEditor{$ENDIF}); //
//*///////////////////////////////////////////////////////////////////////////////////////////////
  finally
//*///////////////////////////////////////////////
{$IFNDEF _D6orHigher}                           //
//*///////////////////////////////////////////////
    if FreeEditor then PropertyEditor.Free;
//*///////////////////////////////////////////////
{$ENDIF}                                        //
//*///////////////////////////////////////////////
  end;
end;

//////////////////////////////////////////////////////////////////////////////////
{$IFDEF _D6orHigher}                                                            //
procedure TKOLObjectCompEditor.CountEvents(const PropertyEditor: IProperty );   //
{$ELSE}                                                                         //
//////////////////////////////////////////////////////////////////////////////////
procedure TKOLObjectCompEditor.CountEvents( PropertyEditor: TPropertyEditor);
//////////////////////////////////////////////////////////////////////////////////
{$ENDIF}                                                                        //
//////////////////////////////////////////////////////////////////////////////////
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObjectCompEditor.CountEvents', 0
  @@e_signature:
  end;
  {$IFDEF _D6orHigher}
  if Supports( PropertyEditor, IMethodProperty ) then
  {$ELSE}
  if PropertyEditor is TMethodProperty then
  {$ENDIF}
    Inc( FCount );
  {$IFNDEF _D6orHigher}
  PropertyEditor.Free;
  {$ENDIF}              
end;

procedure TKOLObjectCompEditor.Edit;
var
  {$IFDEF _D5orHigher}
  {$IFDEF _D6orHigher}
  Components: IDesignerSelections;
  {$ELSE}
  Components: TDesignerSelectionList;
  {$ENDIF}
  {$ELSE}
  Components: TComponentList;
  {$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObjectCompEditor.Edit', 0
  @@e_signature:
  end;
  {if Component.ClassNameIs( 'TKOLForm' ) then
  begin
    inherited;
    Exit;
  end;}
  {$IFDEF _D2orD3orD4}
  Components := TComponentList.Create;
  {$ELSE}
  {$IFDEF _D6orHigher}
  Components := CreateSelectionList;
  {$ELSE}
  Components := TDesignerSelectionList.Create;
  {$ENDIF}
  {$ENDIF}

  try
    BestEventName := '';
    if Component is TKOLObj then
      BestEventName := (Component as TKOLObj).BestEventName
    else
    if Component is TKOLApplet then
      BestEventName := (Component as TKOLApplet).BestEventName
    else
    if Component is TKOLCustomControl then
      BestEventName := (Component as TKOLCustomControl).BestEventName;
    FContinue := True;
//////////////////////////////////////////////////////////
  {$IFDEF _D6orHigher}                                  //
    Components.Add(Component);
  {$ELSE}                                               //
//////////////////////////////////////////////////////////
    Components.Add(Component);
//////////////////////////////////////////////////////////
  {$ENDIF}                                              //
//////////////////////////////////////////////////////////
    FFirst := nil;
    FBest := nil;
    try
      GetComponentProperties(Components, tkAny, Designer, CountEvents);
      //ShowMessage( 'Found ' + IntToStr( FCount ) + ' events' );
      GetComponentProperties(Components, tkAny, Designer, CheckEdit);
      if FContinue then
        if Assigned(FBest) then
        begin
          FBest.Edit;
          //ShowMessage( 'Best found ' + FBest.GetName );
        end
          else
        if Assigned(FFirst) then
        begin
          FFirst.Edit;
          //ShowMessage( 'First found ' + FFirst.GetName );
        end;
    finally
      {$IFDEF _D6orHigher}
      FFirst := nil;
      FBest := nil;
      {$ELSE}
      FFirst.Free;
      FBest.Free;
      {$ENDIF}
    end;
  finally
    {$IFDEF _D6orHigher}
    Components := nil;
    {$ELSE}
    Components.Free;
    {$ENDIF}
    //ShowMessage( 'FREE' );
  end;
end;

//////////////////////////////////////////////////////////////////////////////////////////////////////////
{$IFDEF _D6orHigher}                                                                                   //
procedure TKOLObjectCompEditor.EditProperty(const PropertyEditor: IProperty; var Continue: Boolean);    //
{$ELSE}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TKOLObjectCompEditor.EditProperty(
  PropertyEditor: TPropertyEditor; var Continue, FreeEditor: Boolean);
//////////////////////////
{$ENDIF}                //
//////////////////////////
var
  PropName: string;
  BestName: string;

  procedure ReplaceBest;
  begin
    {$IFDEF _D6orHigher}
    FBest := nil;
    {$ELSE}
    FBest.Free;
    {$ENDIF}
    FBest := PropertyEditor;
    if FFirst = FBest then FFirst := nil;
    {$IFNDEF _D6orHigher}
    FreeEditor := False;
    {$ENDIF}
  end;

begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObjectCompEditor.EditProperty', 0
  @@e_signature:
  end;
  {if Component.ClassNameIs( 'TKOLForm' ) then
  begin
    inherited;
    Exit;
  end;}
  {$IFDEF _D6orHigher}
  if not Assigned(FFirst) and Supports(PropertyEditor, IMethodProperty) then
  {$ELSE}
  if not Assigned(FFirst) and (PropertyEditor is TMethodProperty) then
  {$ENDIF}
  begin
    {$IFNDEF _D6orHigher}
    FreeEditor := False;
    {$ENDIF}
    FFirst := PropertyEditor;
  end;
  PropName := PropertyEditor.GetName;
  BestName := BestEventName;
  {$IFDEF _D6orHigher}
  if Supports( PropertyEditor, IMethodProperty ) then
  {$ELSE}
  if PropertyEditor is TMethodProperty then
  {$ENDIF}
  if (CompareText(PropName, BestName ) = 0) or (FCount = 1) then
    ReplaceBest
  else
    if (BestName = '') and
       (CompareText( PropName, 'ONDESTROY' ) <> 0) then
      ReplaceBest;
end;

{ TKOLOnEventPropEditor }

procedure TKOLOnEventPropEditor.Edit;
var
  FormMethodName: string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLOnEventPropEditor.Edit', 0
  @@e_signature:
  end;
  FormMethodName := GetValue;
  if (FormMethodName = '') or
    Designer.MethodFromAncestor(GetMethodValue) then
  begin
    if FormMethodName = '' then
      FormMethodName := GetFormMethodName;
    if FormMethodName = '' then
      {$IFDEF _D3orD4}
      raise EPropertyError.Create(SCannotCreateName);
      {$ELSE}
      raise EPropertyError.CreateRes( {$IFNDEF _D2}@{$ENDIF} SCannotCreateName);
      {$ENDIF}
    SetValue(FormMethodName);
  end;
  Designer.ShowMethod(FormMethodName);
end;

{$IFDEF _D2}
function TKOLOnEventPropEditor.GetFormMethodName: String;
var
  I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLOnEventPropEditor.GetFormMethodName', 0
  @@e_signature:
  end;
  if GetComponent(0) = Designer.GetRoot then
  begin
    Result := Designer.GetRoot.ClassName;
    if (Result <> '') and (Result[1] = 'T') then
      Delete(Result, 1, 1);
  end
  else
  begin
    {$IFDEF _D2}
    Result := GetComponent(0).Name;
    {$ELSE _D3orHigher}
    Result := Designer.GetObjectName(GetComponent(0));
    {$ENDIF}
    for I := Length(Result) downto 1 do
      if Result[I] in ['.','[',']'] then
        Delete(Result, I, 1);
  end;
  if Result = '' then
    raise EPropertyError.CreateRes( SCannotCreateName );
  Result := Result + GetTrimmedEventName;
end;

function TKOLOnEventPropEditor.GetTrimmedEventName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLOnEventPropEditor.GetTrimmedEventName', 0
  @@e_signature:
  end;
  Result := GetName;
  if (Length(Result) >= 2) and
    (Result[1] in ['O','o']) and (Result[2] in ['N','n']) then
    Delete(Result,1,2);
end;
{$ENDIF _D2}

{function SearchKOLProject( KOLPrj: Pointer; Child: TIComponentInterface ): Boolean;
         stdcall;
type PIComponentInterface = ^TIComponentInterface;
begin
  if CompareText( Child.GetComponentType, 'TKOLProject' ) = 0 then
  begin
    PIComponentInterface( KOLPrj )^ := Child;
    Result := FALSE;
  end
    else
  begin
    Child.Free;
    Result := TRUE;
  end;
end;}

function BuildKOLProject: Boolean;
{var N, I: Integer;
    S: String;}
    //ModIntf: TIModuleInterface;
    //FrmIntf: TIFormInterface;
    //CompIntf: TIComponentInterface;
    //PrjIntf: TIComponentInterface;
    //Value: LongBool;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'BuildKOLProject', 0
  @@e_signature:
  end;
  Result := FALSE;
  if KOLProject <> nil then
    Result := KOLProject.ConvertVCL2KOL( FALSE, TRUE );
  if not Result then
  begin
    ShowMessage( 'Main form is not opened, and changing of the project dpr file ' +
                 'is not finished. To apply changes, open and show main form.' );
  end;
end;

{ TCursorPropEditor }

function TCursorPropEditor.GetAttributes: TPropertyAttributes;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TCursorPropEditor.GetAttributes', 0
  @@e_signature:
  end;
  Result := [ paValueList, paSortList ];
end;

function TCursorPropEditor.GetValue: string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TCursorPropEditor.GetValue', 0
  @@e_signature:
  end;
  Result := GetStrValue;
end;

procedure TCursorPropEditor.GetValues(Proc: TGetStrProc);
const
  Cursors: array[ 0..16 ] of String = ( ' ', 'IDC_ARROW', 'IDC_IBEAM', 'IDC_WAIT',
  'IDC_CROSS', 'IDC_UPARROW', 'IDC_SIZE', 'IDC_ICON', 'IDC_SIZENWSE', 'IDC_SIZENESW',
  'IDC_SIZEWE', 'IDC_SIZENS', 'IDC_SIZEALL', 'IDC_NO', 'IDC_HAND', 'IDC_APPSTARTING',
  'IDC_HELP' );
var I: Integer;
    Found: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TCursorPropEditor.GetValues', 0
  @@e_signature:
  end;
  Found := FALSE;
  for I := 0 to High( Cursors ) do
    if Trim( Value ) = Trim( Cursors[ I ] ) then
    begin
      Found := TRUE;
      break;
    end;
  if not Found then
    Proc( Value );
  for I := 0 to High( Cursors ) do
    Proc( Cursors[ I ] );
end;

procedure TCursorPropEditor.SetValue(const Value: string);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TCursorPropEditor.SetValue', 0
  @@e_signature:
  end;
  SetStrValue( Trim( Value ) );
end;

{ TKOLFrame }

function TKOLFrame.AutoCaption: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.AutoCaption', 0
  @@e_signature:
  end;
  Result := FALSE;
end;

constructor TKOLFrame.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.Create', 0
  @@e_signature:
  end;
  inherited;
  edgeStyle := esNone;
  FParentFont := TRUE;
  FParentColor := TRUE;
end;

procedure TKOLFrame.GenerateAdd2AutoFree(SL: TStringList;
  const AName: String; AControl: Boolean; Add2AutoFreeProc: String; Obj: TObject);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.GenerateAdd2AutoFree', 0
  @@e_signature:
  end;
  if Obj <> nil then
  if Obj is TKOLObj then
  if (Obj as TKOLObj).NotAutoFree then
    Exit;
  if Add2AutoFreeProc = '' then
    Add2AutoFreeProc := 'Add2AutoFree';
  if not AControl then
    SL.Add( '  Result.Form.' + Add2AutoFreeProc + '( ' + AName + ' );' );
end;

procedure TKOLFrame.GenerateCreateForm(SL: TStringList);
const EdgeStyles: array[ TEdgeStyle ] of String = (
      'esRaised', 'esLowered', 'esNone' );
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.GenerateCreateForm', 0
  @@e_signature:
  end;
  S := GenerateTransparentInits;

  SL.Add( '  Result.Form := NewPanel( AParent, ' + EdgeStyles[ edgeStyle ] + ' )' +
          S + ';' );
  if Caption <> '' then
    SL.Add( '  Result.Form.Caption := ' + StringConstant( 'Caption', Caption ) + ';' );
end;

function TKOLFrame.GenerateTransparentInits: String;
var W, H: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.GenerateTransparentInits', 0
  @@e_signature:
  end;
  Result := '';
  if FLocked then Exit;

  if Align <> caNone then
    Result := '.SetAlign( ' + AlignValues[ Align ] + ')';

  if Align <> caNone then
  begin
    W := Width;
    H := Height;
    if Align in [ caLeft, caRight ] then H := 0;
    if Align in [ caTop, caBottom ] then W := 0;
    Result := Result + '.SetSize( ' + IntToStr( W ) + ', ' +
              IntToStr( H ) + ' )';
  end;

  if CenterOnParent and (Align = caNone) then
    Result := Result + '.CenterOnParent';

  if zOrderTopmost then
    Result := Result + '.BringToFront';

  if HelpContext <> 0 then
    Result := Result + '.AssignHelpContext( ' + IntToStr( HelpContext ) + ' )';

end;

function TKOLFrame.GetCaption: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.GetCaption', 0
  @@e_signature:
  end;
  Result := fFrameCaption;
  if Owner is TForm then
  if (Owner as TForm).Caption <> Result then
    (Owner as TForm).Caption := Result;
end;

function TKOLFrame.GetFrameHeight: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.GetFrameHeight', 0
  @@e_signature:
  end;
  Result := inherited Bounds.Height;
end;

function TKOLFrame.GetFrameWidth: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.GetFrameHeight', 0
  @@e_signature:
  end;
  Result := inherited Bounds.Width;
end;

procedure TKOLFrame.SetAlign(const Value: TKOLAlign);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.SetAlign', 0
  @@e_signature:
  end;
  FAlign := Value;
  Change( Self );
end;

procedure TKOLFrame.SetCenterOnParent(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.SetCenterOnParent', 0
  @@e_signature:
  end;
  FCenterOnParent := Value;
  Change( Self );
end;

procedure TKOLFrame.SetEdgeStyle(const Value: TEdgeStyle);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.SetEdgeStyle', 0
  @@e_signature:
  end;
  FEdgeStyle := Value;
  Change( Self );
end;

procedure TKOLFrame.SetFrameCaption(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.SetFrameCaption', 0
  @@e_signature:
  end;
  fFrameCaption := Value;
  Change( Self );
end;

procedure TKOLFrame.SetFrameHeight(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.SetFrameHeight', 0
  @@e_signature:
  end;
  inherited Bounds.Height := Value;
end;

procedure TKOLFrame.SetFrameWidth(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.SetFrameWidth', 0
  @@e_signature:
  end;
  inherited Bounds.Width := Value;
end;

procedure TKOLFrame.SetParentColor(const Value: Boolean);
begin
  FParentColor := Value;
  Change( Self );
end;

procedure TKOLFrame.SetParentFont(const Value: Boolean);
begin
  FParentFont := Value;
  Change( Self );
end;

procedure TKOLFrame.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  inherited;
  if not ParentFont then
    Font.GenerateCode( SL, AName, nil );
  if not ParentColor then
    SL.Add( Prefix + AName + '.Color := ' + ColorToString( Color ) + ';' );
end;

procedure TKOLFrame.SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.SetupLast', 0
  @@e_signature:
  end;
  inherited;
  SL.Add( '    Result.Form.CreateWindow;' );
end;

procedure TKOLFrame.SetzOrderTopmost(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.SetzOrderTopmost', 0
  @@e_signature:
  end;
  FzOrderTopmost := Value;
  Change( Self );
end;

{ TKOLMDIChild }

function TKOLMDIChild.DoNotGenerateSetPosition: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIChild.DoNotGenerateSetPosition', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

procedure TKOLMDIChild.GenerateCreateForm(SL: TStringList);
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIChild.GenerateCreateForm', 0
  @@e_signature:
  end;
  S := GenerateTransparentInits;
  SL.Add( '  Result.Form := NewMDIChild( AParent, ' + StringConstant( 'Caption', Caption ) +
          ' )' + S + ';' );
end;

procedure TKOLMDIChild.SetParentForm(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIChild.SetParentForm', 0
  @@e_signature:
  end;
  if FParentForm = Value then Exit;
  FParentForm := Value;
  Change( Self );
end;

{ TParentMDIFormPropEditor }

function TParentMDIFormPropEditor.GetAttributes: TPropertyAttributes;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIFormPropEditor.GetAttributes', 0
  @@e_signature:
  end;
  Result := [ paValueList, paSortList ];
end;

function TParentMDIFormPropEditor.GetValue: string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIFormPropEditor.GetValue', 0
  @@e_signature:
  end;
  Result := GetStrValue;
end;

procedure TParentMDIFormPropEditor.GetValues(Proc: TGetStrProc);
var I, J: Integer;
    UN, FormName: String;
    MI: TIModuleInterface;
    FI: TIFormInterface;
    CI, ChI: TIComponentInterface;
    IsMDIForm: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIFormPropEditor.GetValues', 0
  @@e_signature:
  end;
  for I := 0 to ToolServices.GetUnitCount-1 do
  begin
      UN := ToolServices.GetUnitName( I );
      MI := ToolServices.GetModuleInterface( UN );
      if MI <> nil then
      TRY
        FI := MI.GetFormInterface;
        if FI <> nil then
        TRY
          CI := FI.GetFormComponent;
          if CI <> nil then
          TRY
            IsMDIForm := FALSE;
            FormName := '';
            for J := 0 to CI.GetComponentCount-1 do
            begin
              ChI := CI.GetComponent( J );
              if ChI.GetComponentType = 'TKOLForm' then
                CI.GetPropValueByName( 'Name', FormName )
              else
              if ChI.GetComponentType = 'TKOLMDIClient' then
                IsMDIForm := TRUE;
              if IsMDIForm and (FormName <> '') then
                break;
            end;
            if IsMDIForm and (FormName <> '') then
              Proc( FormName );
          FINALLY
            CI.Free;
          END;
        FINALLY
          FI.Free;
        END;
      FINALLY
        MI.Free;
      END;
  end;
end;

procedure TParentMDIFormPropEditor.SetValue(const Value: string);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TParentMDIFormPropEditor.SetValue', 0
  @@e_signature:
  end;
  SetStrValue( Trim( Value ) );
end;

{ TKOLMenu }

procedure TKOLMenu.AssignEvents(SL: TStringList; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.AssignEvents', 0
  @@e_signature:
  end;
  inherited;
  DoAssignEvents( SL, AName, [ 'OnUncheckRadioItem', 'OnMeasureItem', 'OnDrawItem' ],
                             [ @ OnUncheckRadioItem, @ OnMeasureItem, @ OnDrawItem ] );
end;

procedure TKOLMenu.Change;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.Change', 0
  @@e_signature:
  end;
  inherited;
  if ActiveDesign <> nil then
     ActiveDesign.RefreshItems;
  //if not FReading then
  //begin
    if ParentForm <> nil then
////////////////////////////////////////////
      if ParentForm.Designer <> nil then  //    иногда может быть NIL ...
////////////////////////////////////////////
      ParentForm.Designer.Modified;
  //end;
end;

constructor TKOLMenu.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.Create', 0
  @@e_signature:
  end;
  inherited;
  FgenerateConstants := TRUE;
  FItems := TList.Create;
  NeedFree := False;
  Fshowshortcuts := True;
  fCreationPriority := 5;
end;

procedure TKOLMenu.DefineProperties(Filer: TFiler);
var I: Integer;
    MI: TKOLMenuItem;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.DefineProperties', 0
  @@e_signature:
  end;
  inherited;
  //--Filer.DefineProperty( 'Items', LoadItems, SaveItems, Count > 0 );
  Filer.DefineProperty( 'ItemCount', LoadItemCount, SaveItemCount, True );
  UpdateDisable;
  for I := 0 to FItemCount - 1 do
  begin
    if FItems.Count <= I then
      MI := TKOLMenuItem.Create( Self, nil, nil )
    else
      MI := FItems[ I ];
    MI.DefProps( 'Item' + Int2Str( I ), Filer );
  end;
  if not (csDestroying in ComponentState) then
    UpdateEnable;
end;

destructor TKOLMenu.Destroy;
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.Destroy', 0
  @@e_signature:
  end;
  //ShowMessage( 'enter: KOLMenu.Destroy' );
  ActiveDesign.Free;
  //ShowMessage( 'AD freed' );
  for I := FItems.Count - 1 downto 0 do
  begin
    TObject( FItems[ I ] ).Free;
  end;
  //ShowMessage( 'Items freed' );
  FItems.Free;
  //ShowMessage( 'FItems freed' );
  inherited;
  //ShowMessage( 'leave: KOLMenu.Destroy' );
end;

procedure TKOLMenu.DoGenerateConstants(SL: TStringList);
var N: Integer;

  procedure GenItemConst( MI: TKOLMenuItem );
  var J: Integer;
  begin
    if MI.Name <> '' then
    if MI.itemindex >= 0 then
    begin
      if not MI.separator or generateSeparatorConstants then
        SL.Add( 'const ' + MI.Name + ' = ' + IntToStr( MI.itemindex ) + ';' );
      Inc( N );
    end;
    for J := 0 to MI.Count-1 do
      GenItemConst( MI.SubItems[ J ] );
  end;

var I: Integer;
begin
  if not generateConstants then Exit;
  N := 0;
  for I := 0 to Count-1 do
    GenItemConst( Items[ I ] );
  if N > 0 then
    SL.Add( '' );
end;

function TKOLMenu.GetCount: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.GetCount', 0
  @@e_signature:
  end;
  Result := FItems.Count;
end;

function TKOLMenu.GetItems(Idx: Integer): TKOLMenuItem;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.GetItems', 0
  @@e_signature:
  end;
  Result := nil;
  if (FItems <> nil) and (Idx >= 0) and (Idx < FItems.Count) then
    Result := FItems[ Idx ];
end;

procedure TKOLMenu.LoadItemCount(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.LoadItemCount', 0
  @@e_signature:
  end;
  FItemCount := R.ReadInteger;
end;

function TKOLMenu.NameAlreadyUsed(const ItemName: String): Boolean;
  function NameUsed1( MI: TKOLMenuItem ): Boolean;
  var I: Integer;
      SI: TKOLMenuItem;
  begin
    Result := MI.Name = ItemName;
    if Result then Exit;
    for I := 0 to MI.Count - 1 do
    begin
      SI := MI.FSubItems[ I ];
      Result := NameUsed1( SI );
      if Result then Exit;
    end;
  end;
var I, J: Integer;
    MI: TKOLMenuItem;
    F: TForm;
    C: TComponent;
    MC: TKOLMenu;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.NameAlreadyUsed', 0
  @@e_signature:
  end;
  F := ParentForm;
  if F = nil then
  begin
    for I := 0 to FItems.Count - 1 do
    begin
      MI := FItems[ I ];
      Result := NameUsed1( MI );
      if Result then Exit;
    end;
    Result := False;
    Exit;
  end;
  Result := F.FindComponent( ItemName ) <> nil;
  if Result then Exit;
  for I := 0 to F.ComponentCount - 1 do
  begin
    C := F.Components[ I ];
    if C is TKOLMenu then
    begin
      MC := C as TKOLMenu;
      for J := 0 to MC.Count - 1 do
      begin
        MI := MC.FItems[ J ];
        Result := NameUsed1( MI );
        if Result then Exit;
      end;
    end;
  end;
  Result := False;
end;

function TKOLMenu.NotAutoFree: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.NotAutoFree', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLMenu.OnMenuItemMethodName: String;
var F: TForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.OnMenuItemMethodName', 0
  @@e_signature:
  end;
  Result := '';
  if TMethod( OnMenuItem ).Code <> nil then
  begin
    F := ParentForm;
    if F <> nil then
      Result := F.MethodName( TMethod( OnMenuItem ).Code );
  end;
  if Result = '' then
    Result := 'nil'
  else
    Result := 'Result.' + Result;
end;

procedure TKOLMenu.SaveItemCount(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.SaveItemCount', 0
  @@e_signature:
  end;
  FItemCount := FItems.Count;
  W.WriteInteger( FItemCount );
end;

procedure TKOLMenu.SaveTo(WR: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.SaveTo', 0
  @@e_signature:
  end;
  Writestate( WR );
end;

procedure TKOLMenu.SetgenerateSeparatorConstants(const Value: Boolean);
begin
  FgenerateSeparatorConstants := Value;
  Change;
end;

procedure TKOLMenu.SetgenerateConstants(const Value: Boolean);
begin
  FgenerateConstants := Value;
  Change;
end;

procedure TKOLMenu.SetName(const NewName: TComponentName);
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.SetName', 0
  @@e_signature:
  end;
  inherited;
  if ActiveDesign <> nil then
  begin
    S := NewName;
    if ParentForm <> nil then
      S := ParentForm.Name + '.' + S;
    ActiveDesign.Caption := S;
  end;
end;

procedure TKOLMenu.SetOnDrawItem(const Value: TOnDrawItem);
begin
  FOnDrawItem := Value;
  Change;
end;

procedure TKOLMenu.SetOnMeasureItem(const Value: TOnMeasureItem);
begin
  FOnMeasureItem := Value;
  Change;
end;

procedure TKOLMenu.SetOnMenuItem(const Value: TOnMenuItem);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.SetOnMenuItem', 0
  @@e_signature:
  end;
  FOnMenuItem := Value;
  Change;
end;

procedure TKOLMenu.SetOnUncheckRadioItem(const Value: TOnMenuItem);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.SetOnUncheckRadioItem', 0
  @@e_signature:
  end;
  FOnUncheckRadioItem := Value;
  Change;
end;

procedure TKOLMenu.Setshowshortcuts(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.Setshowshortcuts', 0
  @@e_signature:
  end;
  Fshowshortcuts := Value;
  Change;
end;

procedure TKOLMenu.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
var I: Integer;
    S: String;
    MI: TKOLMenuItem;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.SetupFirst', 0
  @@e_signature:
  end;
  if Count = 0 then Exit;
  SL.Add( Prefix + AName + ' := NewMenu( ' + AParent + ', 0, [ ' );
  for I := 0 to FItems.Count - 1 do
  begin
    MI := FItems[ I ];
    MI.SetupTemplate( SL, I = 0 );
  end;
  S := ''''' ], ' + OnMenuItemMethodName + ' );';
  if FItems.Count <> 0 then
    S := ', ' + S;
  if Length( S ) + Length( SL[ SL.Count - 1 ] ) > 64 then
    SL.Add( Prefix + '  ' + S )
  else
    SL[ SL.Count - 1 ] := SL[ SL.Count - 1 ] + S;
  if Name <> '' then
  begin
    SL.Add( '   {$IFDEF USE_NAMES}' );
    SL.Add( Prefix + AName + '.Name := ''' + Name + ''';' );
    SL.Add( '   {$ENDIF}' );
  end;
  for I := 0 to FItems.Count - 1 do
  begin
    MI := FItems[ I ];
    MI.SetupAttributes( SL, AName );
  end;
  GenerateTag( SL, AName, Prefix );
end;

procedure TKOLMenu.UpdateDisable;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.UpdateDisable', 0
  @@e_signature:
  end;
  FUpdateDisabled := TRUE;
end;

procedure TKOLMenu.UpdateEnable;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.UpdateEnable', 0
  @@e_signature:
  end;
  if not FUpdateDisabled then Exit;
  FUpdateDisabled := FALSE;
  if FUpdateNeeded then
  begin
    FUpdateNeeded := FALSE;
    UpdateMenu;
  end;
end;

procedure TKOLMenu.UpdateMenu;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.UpdateMenu', 0
  @@e_signature:
  end;
  //
end;

{ TKOLMenuItem }

procedure TKOLMenuItem.Change;
var Menu: TKOLMenu;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.Change', 0
  @@e_signature:
  end;
  if csLoading in ComponentState then Exit;
  Menu := MenuComponent;
  if Menu <> nil then
    Menu.Change;
end;

constructor TKOLMenuItem.Create(AOwner: TComponent; AParent, Before: TKOLMenuItem);
var Items: TList;
    I: Integer;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.Create', 0
  @@e_signature:
  end;
  S := '';
  if Before <> nil then
    S := Before.Name
  else
    S := 'nil';
  if AOwner <> nil then
    S := AOwner.Name + ', ' + S
  else
    S := 'nil, ' + S;
  Rpt( 'TKOLMenuItem.Create( ' + S + ' );' );
  inherited Create( AOwner );
  FParent := AParent;
  if FParent = nil then
    FParent := AOwner;
  FAccelerator := TKOLAccelerator.Create;
  FAccelerator.FOwner := Self;
  FBitmap := TBitmap.Create;
  FSubitems := TList.Create;
  FEnabled := True;
  FVisible := True;
  if AOwner = nil then Exit;
  if AParent = nil then
    Items := (AOwner as TKOLMenu).FItems
  else
    Items := AParent.FSubItems;
  if Before = nil then
    Items.Add( Self )
  else
  begin
    I := Items.IndexOf( Before );
    if I < 0 then
      Items.Add( Self )
    else
      Items.Insert( I, Self );
  end;
end;

destructor TKOLMenuItem.Destroy;
var I: Integer;
    Sub: TKOLMenuItem;
    Items: TList;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.Destroy', 0
  @@e_signature:
  end;
  Rpt( 'Destroying: ' + Name );
  FDestroying := True;
  for I := FSubitems.Count - 1 downto 0 do
  begin
    Sub := FSubitems[ I ];
    Sub.Free;
  end;
  FSubitems.Free;
  Rpt( 'destoying ' + Name + ': subitems freeed' );
  FBitmap.Free;
  if Parent <> nil then
  begin
    Items := nil;
    if Parent is TKOLMenu then
      Items := MenuComponent.FItems
    else
    if Parent is TKOLMenuItem then
      Items := (Parent as TKOLMenuItem).FSubItems;
    if Items <> nil then
    begin
      I := Items.IndexOf( Self );
      if I >= 0 then
        Items.Delete( I );
    end;
  end;
  S := Name;
  FAccelerator.Free;
  inherited;
  Rpt( 'Desroyed ' + S );
end;

function TKOLMenuItem.GetCount: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.GetCount', 0
  @@e_signature:
  end;
  Result := FSubitems.Count;
end;

function TKOLMenuItem.GetMenuComponent: TKOLMenu;
var C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.GetMenuComponent', 0
  @@e_signature:
  end;
  C := Owner;
  if C is TKOLMenuItem then
    Result := (C as TKOLMenuItem).GetMenuComponent
  else
  if C is TKOLMenu then
    Result := C as TKOLMenu
  else
    Result := nil;
end;

function TKOLMenuItem.GetSubItems(Idx: Integer): TKOLMenuItem;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.GetSubItems', 0
  @@e_signature:
  end;
  Result := FSubitems[ Idx ];
end;

function TKOLMenuItem.GetUplevel: TKOLMenuItem;
var C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.GetUplevel', 0
  @@e_signature:
  end;
  C := Parent;
  if C is TKOLMenuItem then
    Result := C as TKOLMenuItem
  else
    Result := nil;
end;

procedure StrList2Binary( SL: TStringList; Data: TStream );
var I: Integer;
    S: String;
    J: Integer;
    C: Byte;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'StrList2Binary', 0
  @@e_signature:
  end;
  for I := 0 to SL.Count - 1 do
  begin
    S := SL[ I ];
    J := 1;
    while J < Length( S ) do
    begin
      C := Hex2Int( Copy( S, J, 2 ) );
      Data.Write( C, 1 );
      Inc( J, 2 );
    end;
  end;
end;

procedure Binary2StrList( Data: TStream; SL: TStringList );
var S: String;
    C: Byte;
    V: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'Binary2StrList', 0
  @@e_signature:
  end;
  while Data.Position < Data.Size do
  begin
    S := '';
    while (Data.Position < Data.Size) and (Length( S ) < 56) do
    begin
      Data.Read( C, 1 );
      V := Copy( Int2Hex( C, 2 ), 1, 2 );
      while Length( V ) < 2 do
        V := '0' + V;
      S := S + V;
    end;
    SL.Add( S );
  end;
end;

procedure TKOLMenuItem.SetBitmap(Value: TBitmap);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetBitmap', 0
  @@e_signature:
  end;
  if Value <> nil then
    if Value.Width * Value.Height = 0 then
      Value := nil;
  if Value <> nil then
  begin
    if Parent is TKOLMainMenu then
    begin
      ShowMessage( 'Menu item in the menu bar can not be checked, so it is ' +
                   'not possible to assign bitmap to upper level items in ' +
                   'the main menu.' );
      Value := nil;
    end;
  end;
  if Value = nil then
  begin
    FBitmap.Width := 0;
    FBitmap.Height := 0;
  end
    else
  begin
    FBitmap.Assign( Value );
    FSeparator := False;
  end;
  Change;
end;

procedure TKOLMenuItem.SetCaption(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetCaption', 0
  @@e_signature:
  end;
  if (Value <> '') and (Value[ 1 ] in ['-','+']) then
  begin
    if not( (Length( Value ) > 1) and (Value[ 1 ] = '-') and (Value[ 2 ] in ['-','+']) ) then
    ShowMessage( 'Please do not start menu caption with ''-'' or ''+'' characters, ' +
                 'such prefixes are reserved for internal use only. Or, at least ' +
                 'insert once more leading ''-'' character. This is by design ' +
                 'reasons, sorry.' );
  end;
  if Faction = nil then
    FCaption := Value
  else
    FCaption:=Faction.Caption;
  if FCaption <> '' then
    FSeparator := False;
  Change;
end;

procedure TKOLMenuItem.SetChecked(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetChecked', 0
  @@e_signature:
  end;
  if Faction = nil then
    FChecked := Value
  else
    FChecked := Faction.Checked;
  if FChecked then
    FSeparator := False;
  Change;
end;

procedure TKOLMenuItem.SetEnabled(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetEnabled', 0
  @@e_signature:
  end;
  if Faction = nil then
    FEnabled := Value
  else
    FEnabled := Faction.Enabled;
  if FEnabled then
    FSeparator := False;
  Change;
end;

function QueryFormDesigner( D: IDesigner; var FD: IFormDesigner ): Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'QueryFormDesigner', 0
  @@e_signature:
  end;
  {$IFDEF _D4orHigher}
    Result := D.QueryInterface( IFormDesigner, FD ) = 0;
  {$ELSE}
    Result := False;
    if D is TFormDesigner then
    begin
      FD := D as TFormDesigner;
      Result := True;
    end;
  {$ENDIF}
end;

procedure TKOLMenuItem.SetName(const NewName: TComponentName);
var OldName, NewMethodName: String;
    L: Integer;
    F: TForm;
    D: IDesigner;
    FD: IFormDesigner;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetName', 0
  @@e_signature:
  end;
  OldName := Name;
  Rpt( 'Renaming ' + OldName + ' to ' + NewName );
  if (MenuComponent <> nil) and (OldName <> '') and
     MenuComponent.NameAlreadyUsed( NewName ) then
  begin
    ShowMessage( 'Can not rename to ' + NewName + ' - such name is already used.' );
    Exit;
  end;
  if (OldName <> '') and (NewName = '') then
  begin
    ShowMessage( 'Can not rename to '''' - name must not be empty.' );
    Exit;
  end;
  inherited;
  if OldName = '' then Exit;
  if FOnMenuMethodName <> '' then
  if MenuComponent <> nil then
  begin
    L := Length( OldName ) + 4;
    if LowerCase( Copy( FOnMenuMethodName, Length( FOnMenuMethodName ) - L + 1, L ) )
     = LowerCase( OldName + 'Menu' ) then
    begin
      // rename event handler also here:
      F := MenuComponent.ParentForm;
      NewMethodName := MenuComponent.Name + NewName + 'Menu';
      if F <> nil then
      begin
//*///////////////////////////////////////////////////////
  {$IFDEF _D6orhigher}                                  //
        F.Designer.QueryInterface(IFormDesigner,D);     //
  {$ELSE}                                               //
//*///////////////////////////////////////////////////////
        D := F.Designer;
//*///////////////////////////////////////////////////////
  {$ENDIF}                                              //
//*///////////////////////////////////////////////////////
        if D <> nil then
        if QueryFormDesigner( D, FD ) then
        //if D.QueryInterface( IFormDesigner, FD ) = 0 then
        begin
          if not FD.MethodExists( NewMethodName ) then
          begin
            FD.RenameMethod( FOnMenuMethodName, NewMethodName );
            if FD.MethodExists( NewMethodName ) then
              FOnMenuMethodName := NewMethodName;
          end;
        end;
      end;
    end;
  end;
  Change;
end;

procedure TKOLMenuItem.SetOnMenu(const Value: TOnMenuItem);
var F: TForm;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetOnMenu', 0
  @@e_signature:
  end;
  FOnMenu := Value;
  if TMethod( Value ).Code <> nil then
  begin
    if MenuComponent <> nil then
    begin
      F := (MenuComponent as TKOLMenu).ParentForm;
      S := F.MethodName( TMethod( Value ).Code );
      //Rpt( 'Assigned method: ' + S + ' (' +
      //     IntToStr( Integer( TMethod( Value ).Code ) ) + ')' );
      FOnMenuMethodName := S;
      //FOnMenuMethodNum := Integer( TMethod( Value ).Code );
      //if TMethod( Value ).Data = F then
      //  Rpt( 'Assigned method is of form object!' );
    end;
  end
    else
    FOnMenuMethodName := '';
  Change;
end;

{procedure TKOLMenuItem.SetRadioItem(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetRadioItem', 0
  @@e_signature:
  end;
  FRadioItem := Value;
  if Value then
    FSeparator := False;
  Change;
end;}

procedure TKOLMenuItem.SetVisible(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetVisible', 0
  @@e_signature:
  end;
  if Faction = nil then
    FVisible := Value
  else
    FVisible := Faction.Visible;
  Change;
end;

procedure TKOLMenuItem.MoveUp;
var ParentItems: TList;
    I: Integer;
    Tmp: Pointer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.MoveUp', 0
  @@e_signature:
  end;
  if Parent = MenuComponent then
    ParentItems := MenuComponent.FItems
  else
    ParentItems := (Parent as TKOLMenuItem).FSubitems;
  I := ParentItems.IndexOf( Self );
  if I > 0 then
  begin
    Tmp := ParentItems[ I - 1 ];
    ParentItems[ I - 1 ] := Self;
    ParentItems[ I ] := Tmp;
    Change;
  end;
end;

procedure TKOLMenuItem.MoveDown;
var ParentItems: TList;
    I: Integer;
    Tmp: Pointer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.MoveDown', 0
  @@e_signature:
  end;
  if Parent = MenuComponent then
    ParentItems := MenuComponent.FItems
  else
    ParentItems := (Parent as TKOLMenuItem).FSubitems;
  I := ParentItems.IndexOf( Self );
  if I < ParentItems.Count - 1 then
  begin
    Tmp := ParentItems[ I + 1 ];
    ParentItems[ I + 1 ] := Self;
    ParentItems[ I ] := Tmp;
    Change;
  end;
end;

procedure TKOLMenuItem.DefProps(const Prefix: String; Filer: TFiler);
var I: Integer;
    MI: TKOLMenuItem;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.DefProps', 0
  @@e_signature:
  end;
  Filer.DefineProperty( Prefix + 'Name', LoadName, SaveName, True );
  Filer.DefineProperty( Prefix + 'Caption', LoadCaption, SaveCaption,  Caption <> '' );
  Filer.DefineProperty( Prefix + 'Enabled', LoadEnabled, SaveEnabled, True );
  Filer.DefineProperty( Prefix + 'Visible', LoadVisible, SaveVisible, True );
  Filer.DefineProperty( Prefix + 'Checked', LoadChecked, SaveChecked, True );
  Filer.DefineProperty( Prefix + 'RadioGroup', LoadRadioGroup, SaveRadioGroup, True );
  Filer.DefineProperty( Prefix + 'Separator', LoadSeparator, SaveSeparator, True );
  Filer.DefineProperty( Prefix + 'Accelerator', LoadAccel, SaveAccel, True );
  Filer.DefineProperty( Prefix + 'Bitmap', LoadBitmap, SaveBitmap, True );
  Filer.DefineProperty( Prefix + 'OnMenu', LoadOnMenu, SaveOnMenu, FOnMenuMethodName <> '' );
  Filer.DefineProperty( Prefix + 'SubItemCount', LoadSubItemCount, SaveSubItemCount, True );
  Filer.DefineProperty( Prefix + 'WindowMenu', LoadWindowMenu, SaveWindowMenu, True );
  Filer.DefineProperty( Prefix + 'HelpContext', LoadHelpContext, SaveHelpContext, HelpContext <> 0 );
  Filer.DefineProperty( Prefix + 'OwnerDraw', LoadOwnerDraw, SaveOwnerDraw, ownerDraw );
  Filer.DefineProperty( Prefix + 'MenuBreak', LoadMenuBreak, SaveMenuBreak, MenuBreak <> mbrNone );
  for I := 0 to FSubItemCount - 1 do
  begin
    if FSubItems.Count <= I then
      MI := TKOLMenuItem.Create( MenuComponent, Self, nil )
    else
      MI := FSubItems[ I ];
    MI.DefProps( Prefix + 'SubItem' + IntToStr( I ), Filer );
  end;
  Filer.DefineProperty( Prefix + 'Tag', LoadTag, SaveTag, Tag <> 0 );
  Filer.DefineProperty( Prefix + 'Default', LoadDefault, SaveDefault, Default );
//  Filer.DefineProperty( Prefix + 'Action', LoadAction, SaveAction, FActionComponentName <> '');
end;

procedure TKOLMenuItem.LoadCaption(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadCaption', 0
  @@e_signature:
  end;
  FCaption := R.ReadString;
end;

procedure TKOLMenuItem.LoadChecked(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadChecked', 0
  @@e_signature:
  end;
  FChecked := R.ReadBoolean;
end;

procedure TKOLMenuItem.LoadEnabled(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadEnabled', 0
  @@e_signature:
  end;
  FEnabled := R.ReadBoolean;
end;

procedure TKOLMenuItem.LoadName(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadName', 0
  @@e_signature:
  end;
  Name := R.ReadString;
end;

procedure TKOLMenuItem.LoadOnMenu(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadOnMenu', 0
  @@e_signature:
  end;
  FOnMenuMethodName := R.ReadString;
end;

{procedure TKOLMenuItem.LoadRadioItem(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadRadioItem', 0
  @@e_signature:
  end;
  FRadioItem := R.ReadBoolean;
end;}

procedure TKOLMenuItem.LoadSubItemCount(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadSubItemCount', 0
  @@e_signature:
  end;
  FSubItemCount := R.ReadInteger;
end;

procedure TKOLMenuItem.LoadVisible(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadVisible', 0
  @@e_signature:
  end;
  FVisible := R.ReadBoolean;
end;

procedure TKOLMenuItem.SaveCaption(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveCaption', 0
  @@e_signature:
  end;
  W.WriteString( Caption );
end;

procedure TKOLMenuItem.SaveChecked(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveChecked', 0
  @@e_signature:
  end;
  W.WriteBoolean( Checked );
end;

procedure TKOLMenuItem.SaveEnabled(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveEnabled', 0
  @@e_signature:
  end;
  W.WriteBoolean( Enabled );
end;

procedure TKOLMenuItem.SaveName(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveName', 0
  @@e_signature:
  end;
  W.WriteString( Name );
end;

procedure TKOLMenuItem.SaveOnMenu(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveOnMenu', 0
  @@e_signature:
  end;
  W.WriteString( FOnMenuMethodName );
end;

{procedure TKOLMenuItem.SaveRadioItem(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveRadioItem', 0
  @@e_signature:
  end;
  W.WriteBoolean( FradioItem );
end;}

procedure TKOLMenuItem.SaveSubItemCount(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveSubItemCount', 0
  @@e_signature:
  end;
  FSubItemCount := FSubItems.Count;
  W.WriteInteger( FSubItemCount );
end;

procedure TKOLMenuItem.SaveVisible(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveVisible', 0
  @@e_signature:
  end;
  W.WriteBoolean( Visible );
end;

procedure TKOLMenuItem.LoadBitmap(R: TReader);
var MS: TMemoryStream;
    SL: TStringList;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadBitmap', 0
  @@e_signature:
  end;
  MS := TMemoryStream.Create;
  SL := TStringList.Create;
  try
    R.ReadListBegin;
    while not R.EndOfList do
    begin
      S := R.ReadString;
      if Trim( S ) <> '' then
        SL.Add( Trim( S ) );
    end;
    R.ReadListEnd;
    if SL.Count = 0 then
    begin
      FBitmap.Width := 0;
      FBitmap.Height := 0;
    end
      else
    begin
      StrList2Binary( SL, MS );
      MS.Position := 0;
      FBitmap.LoadFromStream( MS );
    end;
  finally
    MS.Free;
    SL.Free;
  end;
end;

procedure TKOLMenuItem.SaveBitmap(W: TWriter);
var MS: TMemoryStream;
    SL: TStringList;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveBitmap', 0
  @@e_signature:
  end;
  MS := TMemoryStream.Create;
  SL := TStringList.Create;
  try
    Bitmap.SaveToStream( MS );
    MS.Position := 0;
    if Bitmap.Width * Bitmap.Height > 0 then
      Binary2StrList( MS, SL );
    W.WriteListBegin;
    for I := 0 to SL.Count - 1 do
      W.WriteString( SL[ I ] );
    W.WriteListEnd;
  finally
    MS.Free;
    SL.Free;
  end;
end;

procedure TKOLMenuItem.SetupTemplate(SL: TStringList; FirstItem: Boolean);
    procedure Add2SL( const S: String );
    begin
      if Length( SL[ SL.Count - 1 ] + S ) > 64 then
        SL.Add( '      ' + S )
      else
        SL[ SL.Count - 1 ] := SL[ SL.Count - 1 ] + S;
    end;
var S, U: String;
    I: Integer;
    MI: TKOLMenuItem;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetupTemplate', 0
  @@e_signature:
  end;
  if Separator then
    S := '-'
  else
  begin
    U := Caption;
    if (U = '') or (Faction <> nil) then
      U := ' ';
    S := '';
    if FradioGroup <> 0 then
    begin
      S := '!' + S;
      if (FParent <> nil) and (FParent is TKOLMenuItem) then
      begin
        I := (FParent as TKOLMenuItem).FSubitems.IndexOf( Self );
        if I > 0 then
        begin
          MI := (FParent as TKOLMenuItem).FSubItems[ I - 1 ];
          if (MI.FradioGroup <> 0) and (MI.FradioGroup <> FradioGroup) then
            S := '!' + S;
        end;
      end;
      if not Checked then
        S := '-' + S;
    end;
    if Checked and (Faction = nil) then
      S := '+' + S;
  end;
  if Accelerator.Key <> vkNotPresent then
  if MenuComponent.showshortcuts and (Faction = nil) then
    U := U + #9 + Accelerator.AsText;
  if S = '' then
  begin
    if Faction = nil then
    S := PCharStringConstant( MenuComponent, Name, U )
  else
      S := '''' + U + '''';
  end
  else
  begin
    S := '''' + S + ''' + ';
    U := MenuComponent.StringConstant( Name, U );
    if (U <> '') and (U[ 1 ] <> '''') then
      S := 'PChar( ' + S + U + ')'
    else
      S := S + U;
  end;
  if not FirstItem then
    S := ', ' + S;
  Add2SL( S );
  if Count > 0 then
  begin
    Add2SL( ', ''(''' );
    for I := 0 to Count - 1 do
    begin
      MI := FSubItems[ I ];
      MI.SetupTemplate( SL, False );
    end;
    Add2SL( ', '')''' );
  end;
end;

procedure TKOLMenuItem.SetSeparator(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetSeparator', 0
  @@e_signature:
  end;
  FSeparator := Value;
  Change;
end;

procedure TKOLMenuItem.LoadSeparator(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadSeparator', 0
  @@e_signature:
  end;
  FSeparator := R.ReadBoolean;
end;

procedure TKOLMenuItem.SaveSeparator(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveSeparator', 0
  @@e_signature:
  end;
  W.WriteBoolean( Separator );
end;

function TKOLMenuItem.GetItemIndex: Integer;
var N: Integer;
  procedure IterateThroughSubItems( MI: TKOLMenuItem );
  var I: Integer;
  begin
    if MI = Self then
    begin
      Result := N;
      Exit;
    end;
    Inc( N );
    for I := 0 to MI.Count - 1 do
    begin
      IterateThroughSubItems( MI.FSubItems[ I ] );
      if Result >= 0 then break;
    end;
  end;
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.GetItemIndex', 0
  @@e_signature:
  end;
  Result := -1;
  N := 0;
  if MenuComponent <> nil then
  for I := 0 to MenuComponent.Count - 1 do
  begin
    IterateThroughSubItems( MenuComponent.FItems[ I ] );
    if Result >= 0 then break;
  end;
end;

procedure TKOLMenuItem.SetItemIndex_Dummy(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetItemIndex_Dummy', 0
  @@e_signature:
  end;
  // dummy method - nothing to set
end;

const VirtKeys: array[ TVirtualKey ] of String = (
  '0', 'VK_BACK', 'VK_TAB', 'VK_CLEAR', 'VK_RETURN', 'VK_PAUSE', 'VK_CAPITAL',
  'VK_ESCAPE', 'VK_SPACE', 'VK_PRIOR', 'VK_NEXT', 'VK_END', 'VK_HOME', 'VK_LEFT',
  'VK_UP', 'VK_RIGHT', 'VK_DOWN', 'VK_SELECT', 'VK_EXECUTE', 'VK_SNAPSHOT',
  'VK_INSERT', 'VK_DELETE', 'VK_HELP', '$30', '$31', '$32', '$33', '$34', '$35',
  '$36', '$37', '$38', '$39', '$41', '$42', '$43', '$44', '$45', '$46', '$47',
  '$48', '$49', '$4A', '$4B', '$4C', '$4D', '$4E', '$4F', '$50', '$51', '$52',
  '$53', '$54', '$55', '$56', '$57', '$58', '$59', '$5A', 'VK_LWIN', 'VK_RWIN', 'VK_APPS',
  'VK_NUMPAD0', 'VK_NUMPAD1', 'VK_NUMPAD2', 'VK_NUMPAD3', 'VK_NUMPAD4', 'VK_NUMPAD5',
  'VK_NUMPAD6', 'VK_NUMPAD7', 'VK_NUMPAD8', 'VK_NUMPAD9',  'VK_MULTIPLY', 'VK_ADD',
  'VK_SEPARATOR', 'VK_SUBTRACT', 'VK_DECIMAL', 'VK_DIVIDE', 'VK_F1', 'VK_F2', 'VK_F3',
  'VK_F4', 'VK_F5', 'VK_F6', 'VK_F7', 'VK_F8', 'VK_F9', 'VK_F10', 'VK_F11', 'VK_F12',
  'VK_F13', 'VK_F14', 'VK_F15', 'VK_F16', 'VK_F17', 'VK_F18', 'VK_F19', 'VK_F20',
  'VK_F21', 'VK_F22', 'VK_F23', 'VK_F24', 'VK_NUMLOCK', 'VK_SCROLL', 'VK_ATTN',
  'VK_CRSEL', 'VK_EXSEL', 'VK_EREOF', 'VK_PLAY', 'VK_ZOOM', 'VK_PA1', 'VK_OEMCLEAR' );

// Maxim Pushkar:
const VirtualKeyNames: array [TVirtualKey] of string =
             ( '', 'Back'{'BackSpace'}, 'Tab', 'CLEAR', 'Enter', 'Pause', 'CapsLock',
                 'Escape'{'Esc'}, 'Space', 'PageUp', 'PageDown', 'End', 'Home', 'Left',
                 'Up', 'Right', 'Down', 'SELECT', 'EXECUTE', 'PrintScreen',
                 'Ins', 'Delete'{'Del'}, 'Help'{'?'}, '0', '1', '2', '3', '4', '5',
                 '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
                 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
                 'U', 'V', 'W', 'X', 'Y', 'Z', 'LWin', 'RWin', 'APPS',
                 'Numpad0', 'Numpad1', 'Numpad2', 'Numpad3', 'Numpad4',
                 'Numpad5', 'Numpad6', 'Numpad7', 'Numpad8', 'Numpad9',
                 '*', '+', '|', '-', '.', '/', 'F1', 'F2', 'F3', 'F4',
                 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12', 'F13',
                 'F14', 'F15', 'F16', 'F17', 'F18', 'F19', 'F20', 'F21',
                 'F22', 'F23', 'F24', 'NumLock', 'ScrollLock', 'ATTN', 'CRSEL',
                 'EXSEL', 'EREOF', 'PLAY', 'ZOOM', 'PA1', 'OEMCLEAR');


procedure TKOLMenuItem.SetupAttributes(SL: TStringList;
  const MenuName: String);
const Breaks: array[ TMenuBreak ] of String = ( 'mbrNone', 'mbrBreak', 'mbrBarBreak' );
var I: Integer;
    SI: TKOLMenuItem;
    RsrcName: String;
    S: String;
    F: TForm;
    FD: IFormDesigner;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetupAttributes', 0
  @@e_signature:
  end;
  if not Enabled and (Faction = nil) then
    SL.Add( '    ' + MenuName + '.ItemEnabled[ ' + IntToStr( ItemIndex ) + ' ] := False;' );
  if not Visible and (Faction = nil) then
    SL.Add( '    ' + MenuName + '.ItemVisible[ ' + IntToStr( ItemIndex ) + ' ] := False;' );
  if (HelpContext <> 0) and (Faction = nil) then
    SL.Add( '    ' + MenuName + '.ItemHelpContext[ ' + IntToStr( ItemIndex ) + ' ] := ' +
            IntToStr( HelpContext ) + ';' );
  if (Bitmap <> nil) and (Bitmap.Width <> 0) and (Bitmap.Height <> 0) then
  begin
    RsrcName := MenuComponent.ParentForm.Name + '_' + Name + '_BMP';
    SL.Add( '    ' + MenuName + '.ItemBitmap[ ' + IntToStr( ItemIndex ) +
            ' ] := LoadBmp( hInstance, ''' + UpperCase( RsrcName + '_BITMAP' ) + ''', ' +
            MenuName + ' );' );
    SL.Add( '    {$R ' + RsrcName + '.res}' );
    GenerateBitmapResource( Bitmap, UPPERCASE( RsrcName + '_BITMAP' ), RsrcName,
    MenuComponent.fUpdated );
  end;
  if (BitmapChecked <> nil) and (bitmapChecked.Width <> 0) and (bitmapChecked.Height <> 0) then
  begin
    RsrcName := MenuComponent.ParentForm.Name + '_' + Name + '_BMPCHECKED';
    SL.Add( '    ' + MenuName + '.Items[ ' + IntToStr( ItemIndex ) +
            ' ].BitmapChecked := LoadBmp( hInstance, ''' + UpperCase( RsrcName + '_BITMAP' ) + ''', ' +
            MenuName + ' );' );
    SL.Add( '    {$R ' + RsrcName + '.res}' );
    GenerateBitmapResource( bitmapChecked, UPPERCASE( RsrcName ), RsrcName,
    MenuComponent.fUpdated );
  end;
  if (BitmapItem <> nil) and (bitmapItem.Width <> 0) and (bitmapItem.Height <> 0) then
  begin
    RsrcName := MenuComponent.ParentForm.Name + '_' + Name + '_BMPITEM';
    SL.Add( '    ' + MenuName + '.Items[ ' + IntToStr( ItemIndex ) +
            ' ].BitmapChecked := LoadBmp( hInstance, ''' + UpperCase( RsrcName + '_BITMAP' ) + ''', ' +
            MenuName + ' );' );
    SL.Add( '    {$R ' + RsrcName + '.res}' );
    GenerateBitmapResource( bitmapItem, UPPERCASE( RsrcName ), RsrcName,
    MenuComponent.fUpdated );
  end;
  if FownerDraw then
    SL.Add( '    ' + MenuName + '.Items[ ' + IntToStr( ItemIndex ) +
            ' ].OwnerDraw := TRUE;' );
  if Fdefault then
    SL.Add( '    ' + MenuName + '.Items[ ' + IntToStr( ItemIndex ) +
            ' ].DefaultItem := TRUE;' );
  if FmenuBreak <> mbrNone then
    SL.Add( '    ' + MenuName + '.Items[ ' + IntToStr( ItemIndex ) +
            ' ].MenuBreak := ' + Breaks[ FmenuBreak ] + ';' );
  if FOnMenuMethodName <> '' then
  begin
    F := MenuComponent.ParentForm;
//////////////////////////////////////////////////////////////////////////////////
  {$IFDEF _D6orHigher}                                                          //
    if (F <> nil) and (F.Designer <> nil) then                                  //
    begin                                                                       //
    F.Designer.QueryInterface( IDesigner, FD );                                 //
    if FD <>nil then                                                            //
    //if F.Designer.QueryInterface( IFormDesigner, FD ) = 0 then                //
    if FD.MethodExists( FOnMenuMethodName ) then                                //
      SL.Add( '    ' + MenuName + '.AssignEvents( ' + IntToStr( ItemIndex ) +   //
              ', [ Result.' + FOnMenuMethodName + ' ] );' );                    //
    end;                                                                        //
  {$ELSE}                                                                       //
//////////////////////////////////////////////////////////////////////////////////
    if (F <> nil) and (F.Designer <> nil) then
    if QueryFormDesigner( F.Designer, FD ) then
    //if F.Designer.QueryInterface( IFormDesigner, FD ) = 0 then
    if FD.MethodExists( FOnMenuMethodName ) then
      SL.Add( '    ' + MenuName + '.AssignEvents( ' + IntToStr( ItemIndex ) +
              ', [ Result.' + FOnMenuMethodName + ' ] );' );
//////////////////////////////////////////////////////////////////////////////////
  {$ENDIF}                                                                      //
//////////////////////////////////////////////////////////////////////////////////
  end;
  if (Accelerator.Key <> vkNotPresent) and (Faction = nil) then
  begin
    S := 'FVIRTKEY';
    if kapShift in Accelerator.Prefix then
      S := S + ' or FSHIFT';
    if kapControl in Accelerator.Prefix then
      S := S + ' or FCONTROL';
    if kapAlt in Accelerator.Prefix then
      S := S + ' or FALT';
    if kapNoinvert in Accelerator.Prefix then
      S := S + ' or FNOINVERT';
    SL.Add( '    ' + MenuName + '.ItemAccelerator[ ' + IntToStr( ItemIndex ) +
            ' ] := MakeAccelerator( ' + S + ', ' + VirtKeys[ Accelerator.Key ] +
            ' );' );
  end;
  if Tag <> 0 then
    SL.Add( '    ' + MenuName + '.Items[' + IntToStr( ItemIndex ) +
            '].Tag := DWORD(' + IntToStr( Tag ) + ');' );
  for I := 0 to Count - 1 do
  begin
    SI := FSubItems[ I ];
    SI.SetupAttributes( SL, MenuName );
  end;
end;

procedure TKOLMenuItem.SetAccelerator(const Value: TKOLAccelerator);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetAccelerator', 0
  @@e_signature:
  end;
  FAccelerator := Value;
  Change;
end;

procedure TKOLMenuItem.LoadAccel(R: TReader);
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadAccel', 0
  @@e_signature:
  end;
  I := R.ReadInteger;
  FAccelerator.Prefix := [ ];
  if LongBool(I and $100) then
    FAccelerator.Prefix := [ kapShift ];
  if LongBool(I and $200) then
    FAccelerator.Prefix := FAccelerator.Prefix + [ kapControl ];
  if LongBool(I and $400) then
    FAccelerator.Prefix := FAccelerator.Prefix + [ kapAlt ];
  if LongBool(I and $800) then
    Faccelerator.Prefix := FAccelerator.Prefix + [ kapNoinvert ];
  FAccelerator.Key := TVirtualKey( I and $FF );
end;

procedure TKOLMenuItem.LoadWindowMenu(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadWindowMenu', 0
  @@e_signature:
  end;
  FWindowMenu := R.ReadBoolean;
end;

procedure TKOLMenuItem.SaveWindowMenu(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveWindowMenu', 0
  @@e_signature:
  end;
  W.WriteBoolean( FWindowMenu );
end;

procedure TKOLMenuItem.SaveAccel(W: TWriter);
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveAccel', 0
  @@e_signature:
  end;
  I := Ord( Accelerator.Key );
  if kapShift in Accelerator.Prefix then
    I := I or $100;
  if kapControl in Accelerator.Prefix then
    I := I or $200;
  if kapAlt in Accelerator.Prefix then
    I := I or $400;
  if kapNoinvert in Accelerator.Prefix then
    I := I or $800;
  W.WriteInteger( I );
end;

procedure TKOLMenuItem.DesignTimeClick;
var F: TForm;
    D: IDesigner;
    FD: IFormDesigner;
    EvntName: String;
    TI: TTypeInfo;
    TD: TTypeData;
    Meth: TMethod;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.DesignTimeClick', 0
  @@e_signature:
  end;
  Rpt( 'DesignTimeClick: ' + Caption );
  if Count > 0 then Exit;
  F := MenuComponent.ParentForm;
  if F = nil then Exit;
//*///////////////////////////////////////////////////////
  {$IFDEF _D6orHigher}                                  //
        F.Designer.QueryInterface(IFormDesigner,D);     //
  {$ELSE}                                               //
//*///////////////////////////////////////////////////////
        D := F.Designer;
//*///////////////////////////////////////////////////////
  {$ENDIF}                                              //
//*///////////////////////////////////////////////////////
  if D = nil then Exit;
  if not QueryFormDesigner( D, FD ) then Exit;
  //if D.QueryInterface( IFormDesigner, FD ) <> 0 then Exit;
  EvntName := FOnMenuMethodName;
  if EvntName = '' then
    EvntName := MenuComponent.ParentKOLForm.Name + Name + 'Menu';
  if FD.MethodExists( EvntName ) then
  begin
    FOnMenuMethodName := EvntName;
    FD.ShowMethod( EvntName );
    Change;
    Exit;
  end;
  TI.Kind := tkMethod;
  TI.Name := 'TOnMenuItem';
  TD.MethodKind := mkProcedure;
  TD.ParamCount := 2;
  TD.ParamList := 'Sender: PMenu; Item: Integer'#0#0;
  Meth := FD.CreateMethod( EvntName, {@TD} GetTypeData( TypeInfo( TOnMenuItem ) ) );
  if Meth.Code <> nil then
  begin
    FOnMenuMethodName := EvntName;
    FD.ShowMethod( EvntName );
    Change;
  end;
end;

procedure TKOLMenuItem.SetWindowMenu(Value: Boolean);
  procedure ClearWindowMenuForSubMenus( MI: TKOLMenuItem );
  var I: Integer;
      SMI: TKOLMenuItem;
  begin
    for I := 0 to MI.Count-1 do
    begin
      SMI := MI.SubItems[ I ];
      if SMI = Self then continue;
      SMI.WindowMenu := FALSE;
      ClearWindowMenuForSubMenus( SMI );
    end;
  end;
var I: Integer;
    Menu: TKOLMenu;
    MI: TKOLMenuItem;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetWindowMenu', 0
  @@e_signature:
  end;
  if csLoading in ComponentState then
    FWindowMenu := Value
  else
  begin
    Menu := MenuComponent;
    if (Menu = nil) or not(Menu is TKOLMainMenu) then
      Value := FALSE;
    if FWindowMenu = Value then Exit;
    FWindowMenu := Value;
    for I := 0 to Menu.Count-1 do
    begin
      MI := Menu.Items[ I ];
      if MI = Self then continue;
      MI.WindowMenu := FALSE;
      ClearWindowMenuForSubMenus( MI );
    end;
    Change;
  end;
end;

procedure TKOLMenuItem.SetHelpContext(const Value: Integer);
begin
  if Faction = nil then
    FHelpContext := Value
  else
    FHelpContext := Faction.HelpContext;
  Change;
end;

procedure TKOLMenuItem.LoadHelpContext(R: TReader);
begin
  FHelpContext := R.ReadInteger;
end;

procedure TKOLMenuItem.SaveHelpContext(W: TWriter);
begin
  W.WriteInteger( FHelpContext );
end;

procedure TKOLMenuItem.LoadRadioGroup(R: TReader);
begin
  FradioGroup := R.ReadInteger;
end;

procedure TKOLMenuItem.SaveRadioGroup(W: TWriter);
begin
  W.WriteInteger( FradioGroup );
end;

procedure TKOLMenuItem.SetbitmapChecked(const Value: TBitmap);
begin
  FbitmapChecked := Value;
  Change;
end;

procedure TKOLMenuItem.SetbitmapItem(const Value: TBitmap);
begin
  FbitmapItem := Value;
  Change;
end;

procedure TKOLMenuItem.Setdefault(const Value: Boolean);
begin
  Fdefault := Value;
  Change;
end;

procedure TKOLMenuItem.SetRadioGroup(const Value: Integer);
begin
  FRadioGroup := Value;
  Change;
end;

procedure TKOLMenuItem.SetownerDraw(const Value: Boolean);
begin
  FownerDraw := Value;
  Change;
end;

procedure TKOLMenuItem.LoadOwnerDraw(R: TReader);
begin
  FownerDraw := R.ReadBoolean;
end;

procedure TKOLMenuItem.SaveOwnerDraw(W: TWriter);
begin
  W.WriteBoolean( FownerDraw );
end;

procedure TKOLMenuItem.SetMenuBreak(const Value: TMenuBreak);
begin
  FMenuBreak := Value;
  Change;
end;

procedure TKOLMenuItem.LoadMenuBreak(R: TReader);
begin
  FmenuBreak := TMenuBreak( R.ReadInteger );
end;

procedure TKOLMenuItem.SaveMenuBreak(W: TWriter);
begin
  W.WriteInteger( Integer( FmenuBreak ) );
end;

procedure TKOLMenuItem.SetTag(const Value: Integer);
begin
  FTag := Value;
  Change;
end;

procedure TKOLMenuItem.LoadTag(R: TReader);
begin
  FTag := R.ReadInteger;
end;

procedure TKOLMenuItem.SaveTag(W: TWriter);
begin
  W.WriteInteger( FTag );
end;

procedure TKOLMenuItem.LoadDefault(R: TReader);
begin
  Default := R.ReadBoolean;
end;

procedure TKOLMenuItem.SaveDefault(W: TWriter);
begin
  W.WriteBoolean( Default );
end;

procedure TKOLMenuItem.Setaction(const Value: TKOLAction);
begin
  if Faction = Value then exit;
  if Faction <> nil then
    Faction.UnLinkComponent(Self);
  Faction := Value;
  if Faction <> nil then
    Faction.LinkComponent(Self);
  Change;
end;

procedure TKOLMenuItem.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
    if AComponent = Faction then begin
      Faction.UnLinkComponent(Self);
      Faction := nil;
    end;
end;

procedure TKOLMenuItem.LoadAction(R: TReader);
begin
//  FActionComponentName:=R.ReadString;
end;

procedure TKOLMenuItem.SaveAction(W: TWriter);
begin
{
  if Faction <> nil then
    W.WriteString(Faction.GetNamePath)
  else
    W.WriteString('');
}    
end;

{ TKOLMenuEditor }

procedure TKOLMenuEditor.Edit;
var M: TKOLMenu;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuEditor.Edit', 0
  @@e_signature:
  end;
  if Component = nil then Exit;
  if not(Component is TKOLMenu) then Exit;
  M := Component as TKOLMenu;
  if M.ActiveDesign <> nil then
  begin
    M.ActiveDesign.MenuComponent := M;
    //M.ActiveDesign.Designer := Designer;
    M.ActiveDesign.Visible := True;
    SetForegroundWindow( M.ActiveDesign.Handle );
    M.ActiveDesign.MakeActive;
  end
     else
  begin
    M.ActiveDesign := TKOLMenuDesign.Create( Application );
    S := M.Name;
    if M.ParentKOLForm <> nil then
      S := M.ParentKOLForm.FormName + '.' + S;
    M.ActiveDesign.Caption := S;
    M.ActiveDesign.MenuComponent := M;
  end;
  if M.ParentForm <> nil then
    M.ParentForm.Invalidate;
end;

procedure TKOLMenuEditor.ExecuteVerb(Index: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuEditor.ExecuteVerb', 0
  @@e_signature:
  end;
  Edit;
end;

function TKOLMenuEditor.GetVerb(Index: Integer): string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuEditor.GetVerb', 0
  @@e_signature:
  end;
  Result := '&Edit menu';
end;

function TKOLMenuEditor.GetVerbCount: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuEditor.GetVerbCount', 0
  @@e_signature:
  end;
  Result := 1;
end;

{ TKOLMainMenu }

procedure TKOLMainMenu.Change;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMainMenu.Change', 0
  @@e_signature:
  end;
  inherited;
  RebuildMenubar;
end;

constructor TKOLMainMenu.Create(AOwner: TComponent);
var F: TForm;
    I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMainMenu.Create', 0
  @@e_signature:
  end;
  inherited;
  F := ParentForm;
  if F = nil then Exit;
  for I := 0 to F.ComponentCount - 1 do
  begin
    C := F.Components[ I ];
    if C = Self then continue;
    if C is TKOLMainMenu then
    begin
      ShowMessage(  'Another TKOLMainMenu component is already found on form ' +
                    F.Name + ' ( ' + C.Name + ' ). ' +
                    'Remember, please, that only one instance of TKOLMainMenu ' +
                    'should be placed on a form. Otherwise, code will be ' +
                    'generated only for one of those.' );
      Exit;
    end;
  end;
end;

var CommonOldWndProc: Pointer;
function WndProcDesignMenu( Wnd: HWnd; uMsg: DWORD; wParam, lParam: Integer ): Integer;
         stdcall;
var Id: Integer;
    M: HMenu;
    MII: TMenuItemInfo;
    KMI: TKOLMenuItem;
    C: TControl;
    F: TForm;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'WndProcDesignMenu', 0
  @@e_signature:
  end;
  if (uMsg = WM_COMMAND)  then
  begin
    if (lParam = 0) and (HIWORD( wParam ) <= 1) then
    begin
      Id := LoWord( wParam );
      M := GetMenu( Wnd );
      if M <> 0 then
      begin
        Fillchar( MII, 44, 0 );
        MII.cbsize := 44;
        MII.fMask := MIIM_DATA;
        if GetMenuItemInfo( M, Id, False, MII ) then
        begin
          KMI := Pointer( MII.dwItemData );
          if KMI <> nil then
          begin
            try
              if KMI is TKOLMenuItem then
              begin
                //Rpt( 'Click on ' + KMI.Caption );
                KMI.DesignTimeClick;
                Result := 0;
                Exit;
              end;
            except
              on E: Exception do
              begin
                ShowMessage( 'Design-time click failed, exception: ' + E.Message );
              end;
            end;
          end;
        end;
      end;
    end;
  end
    else
  if (uMsg = WM_DESTROY) then
  begin
    M := GetMenu( Wnd );
    SetMenu( Wnd, 0 );
    if M <> 0 then
    begin
      C := FindControl( Wnd );
      if (C <> nil) and (C is TForm) then
      begin
        F := C as TForm;
        for I := 0 to F.ComponentCount-1 do
          if F.Components[ I ] is TKOLMainMenu then
          begin
            DestroyMenu( M );
            (F.Components[ I ] as TKOLMainMenu).RestoreWndProc( Wnd );
            break;
          end;
      end
        else
      DestroyMenu( M );
    end;
  end;
  Result := CallWindowProc( CommonOldWndProc, Wnd, uMsg, wParam, lParam );
end;

destructor TKOLMainMenu.Destroy;
var F: TForm;
    KF: TKOLForm;
    M: HMenu;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMainMenu.Destroy', 0
  @@e_signature:
  end;
  F := ParentForm;
  KF := nil;
  if F <> nil then
  begin
    KF := ParentKOLForm;
  end;
  if F <> nil then
  begin
    M := 0;
    if F.HandleAllocated then
    if F.Handle <> 0 then
    begin
      M := GetMenu( F.Handle );
      RestoreWndProc( F.Handle );
      SetMenu( F.Handle, 0 );
    end;
    if M <> 0 then
      DestroyMenu( M );
  end;
  inherited;
  if KF <> nil then
    KF.AlignChildren( nil, FALSE );
end;

procedure TKOLMainMenu.Loaded;
//var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMainMenu.Loaded', 0
  @@e_signature:
  end;
  inherited;
  {KF := ParentKOLForm;
  if KF <> nil then
  begin
    KF.AllowRealign := TRUE;
    if not (csLoading in KF.ComponentState) then
      KF.AlignChildren( nil );
  end;}
end;

procedure TKOLMainMenu.RebuildMenubar;
var F: TForm;
    M: HMenu;
    KMI: TKOLMenuItem;
    I: Integer;

    procedure BuildMenuItem( ParentMenu: HMenu; KMI: TKOLMenuItem );
    var MII: TMenuItemInfo;
        S: String;
        J: Integer;
    begin
      asm
        jmp @@e_signature
        DB '#$signature$#', 0
        DB 'TKOLMainMenu.RebuildMenubar.BuildMenuItem', 0
      @@e_signature:
      end;
      FillChar( MII, 44, 0 );

      if KMI.Separator then
        S := '-'
      else
      begin
        S := KMI.Caption;
        if S = '' then S := ' ';
        if showshortcuts and (KMI.Accelerator.Key <> vkNotPresent) then
          S := S + #9 + KMI.Accelerator.AsText;
      end;

      MII.cbSize := 44;
      MII.fMask := MIIM_DATA or MIIM_ID or MIIM_STATE or MIIM_SUBMENU or MIIM_TYPE
                   or MIIM_CHECKMARKS;
      MII.dwItemData := Integer(KMI);
      if KMI.Separator then
      begin
        MII.fType := MFT_SEPARATOR;
        MII.fState := MFS_GRAYED;
      end
        else
      begin
        MII.fType := MFT_STRING;
        MII.dwTypeData := PChar( S );
        MII.cch := StrLen( PChar( S ) );
        if KMI.FradioGroup <> 0 then
        begin
          MII.fType := MII.fType or MFT_RADIOCHECK;
          //MII.dwItemData := MII.dwItemData or MIDATA_RADIOITEM;
        end;
        if KMI.Checked then
        begin
          //if not KMI.RadioItem then
          //  MII.dwItemData := MII.dwItemData or MIDATA_CHECKITEM;
          MII.fState := MII.fState or MFS_CHECKED;
        end;
        if not KMI.Enabled then
          MII.fState := MFS_GRAYED;
        if (KMI.Bitmap <> nil) and (KMI.Bitmap.Width * KMI.Bitmap.Height > 0) then
          MII.hBmpUnchecked := KMI.Bitmap.Handle;
        MII.wID := 100 + KMI.itemIndex;
        if KMI.Count > 0 then
        begin
          MII.hSubmenu := CreatePopupMenu;
          for J := 0 to KMI.Count - 1 do
            BuildMenuItem( MII.hSubMenu, KMI.FSubItems[ J ] );
        end;
      end;
      InsertMenuItem( ParentMenu, Cardinal(-1), True, MII );
    end;

var oldM: HMenu;
    oldWndProc: Pointer;
    KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMainMenu.RebuildMenubar', 0
  @@e_signature:
  end;
  if (csDestroying in ComponentState) then Exit;
  if FUpdateDisabled then
  begin
    FUpdateNeeded := TRUE;
    Exit;
  end;
  TRY

    F := ParentForm;
    if F = nil then Exit;
    oldM := GetMenu( F.Handle );
    F.Menu := nil;

    M := CreateMenu;
    for I := 0 to Count - 1 do
    begin
      KMI := FItems[ I ];
      BuildMenuItem( M, KMI );
    end;
    //F.Menu := M;
    SetMenu( F.Handle, M );
    if oldM <> 0 then
      DestroyMenu( oldM );
    Integer(oldWndProc) := GetWindowLong( F.Handle, GWL_WNDPROC );
    if oldWndProc <> @WndProcDesignMenu then
    begin
      Rpt( 'Reset WndProc (old: ' + IntToStr( Integer(oldWndProc) ) + ' )' );
      CommonOldWndProc := oldWndProc;
      FoldWndProc := oldWndProc;
      SetWindowLong( F.Handle, GWL_WNDPROC, Integer( @WndProcDesignMenu ) );
    end;

  FINALLY
    KF := ParentKOLForm;
    if KF <> nil then
    begin
      KF.AllowRealign := TRUE;
      if not (csLoading in KF.ComponentState) then
        KF.AlignChildren( nil, FALSE );
    end;
  END;
end;

procedure TKOLMainMenu.RestoreWndProc( Wnd: HWnd );
var CurwndProc: Pointer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMainMenu.RestoreWndProc', 0
  @@e_signature:
  end;
  Integer(CurWndProc) := GetWindowLong( Wnd, GWL_WNDPROC );
  if CurWndProc = @WndProcDesignMenu then
  begin
    SetWindowLong( Wnd, GWL_WNDPROC, Integer( CommonOldWndProc ) );
  end;
end;

procedure TKOLMainMenu.UpdateMenu;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMainMenu.UpdateMenu', 0
  @@e_signature:
  end;
  inherited;
  RebuildMenubar;
end;

{ TKOLPopupMenu }

procedure TKOLPopupMenu.AssignEvents(SL: TStringList; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPopupMenu.AssignEvents', 0
  @@e_signature:
  end;
  inherited;
  DoAssignEvents( SL, AName, [ 'OnPopup' ],
                             [ @ OnPopup ] );
end;

procedure TKOLPopupMenu.SetFlags(const Value: TPopupMenuFlags);
begin
  FFlags := Value;
  Change;
end;

procedure TKOLPopupMenu.SetOnPopup(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPopupMenu.SetOnPopup', 0
  @@e_signature:
  end;
  FOnPopup := Value;
  Change;
end;

procedure TKOLPopupMenu.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var S: String;
begin
  inherited;
  if Flags <> [ ] then
  begin
    if tpmVertical     in Flags then S := S + 'TPM_VERTICAL or ';
    if tpmRightButton  in Flags then S := S + 'TPM_RIGHTBUTTON or ';
    if tpmCenterAlign  in Flags then S := S + 'TPM_CENTERALIGN or ';
    if tpmRightAlign   in Flags then S := S + 'TPM_RIGHTALIGN or ';
    if tpmVCenterAlign in Flags then S := S + 'TPM_VCENTERALIGN or ';
    if tpmBottomAlign  in Flags then S := S + 'TPM_BOTTOMALIGN or ';
    if tpmHorPosAnimation in Flags then S := S + 'TPM_HORPOSANIMATION or ';
    if tpmHorNegAnimation in Flags then S := S + 'TPM_HORNEGANIMATION or ';
    if tpmVerPosAnimation in Flags then S := S + 'TPM_VERPOSANIMATION or ';
    if tpmVerNegAnimation in Flags then S := S + 'TPM_VERNEGANIMATION or ';
    if tpmNoAnimation in Flags then S := S + 'TPM_NOANIMATION or ';
    if tpmReturnCmd in Flags then S := S + 'TPM_RETURNCMD or '; {+ecm}
    S := Copy(S,1,Length(S)-4);
    SL.Add( Prefix + AName + '.Flags := ' + S + ';' );
  end;
end;

{ TKOLOnItemPropEditor }

function TKOLOnItemPropEditor.GetValue: string;
var Comp: TPersistent;
    F: TForm;
    D: IDesigner;
    FD: IFormDesigner;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLOnItemPropEditor.GetValue', 0
  @@e_signature:
  end;
  Result := inherited GetValue;
  if Result = '' then
  begin
    Comp := GetComponent( 0 );
    if Comp <> nil then
    if Comp is TKOLMenuItem then
    begin
      Result := (Comp as TKOLMenuItem).FOnMenuMethodName;
      {
      if Result <> '' then
      begin
        Rpt( 'inherited OnMenu=NULL, but name is ' + Result + ', trying to restore correct value' );
        SetValue( Result );
        Result := inherited GetValue;
        Rpt( '--------- OnMenu=' + Result );
      end;
      }
    end;
  end;
  TRY

  Comp := GetComponent( 0 );
  if (Comp <> nil) and
     (Comp is TKOLMenuItem) and
     ((Comp as TKOLMenuItem).MenuComponent <> nil) then
  begin
    F := ((Comp as TKOLMenuItem).MenuComponent as TKOLMenu).ParentForm;
    if (F = nil) or (F.Designer = nil) then
    begin
      Result := ''; Exit;
    end;
//*///////////////////////////////////////////////////////
  {$IFDEF _D6orHigher}                                  //
        F.Designer.QueryInterface(IFormDesigner,D);     //
  {$ELSE}                                               //
//*///////////////////////////////////////////////////////
        D := F.Designer;
//*///////////////////////////////////////////////////////
  {$ENDIF}                                              //
//*///////////////////////////////////////////////////////
    if QueryFormDesigner( D, FD ) then
    //if D.QueryInterface( IFormDesigner, FD ) = 0 then
    begin
      if not FD.MethodExists( Result ) then Result := '';
    end
      else Result := '';
  end
    else Result := '';

  EXCEPT
    on E: Exception do
    begin
      Rpt( 'Exception while retrieving property OnMenu of TKOLMenuItem' );
      ShowMessage( 'Could not retrieve TKOLMenuItem.OnMenu, exception: ' + E.Message );
    end;
  END;
end;

procedure TKOLOnItemPropEditor.SetValue(const AValue: string);
var Comp: TPersistent;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLOnItemPropEditor.SetValue', 0
  @@e_signature:
  end;
  inherited;
  for I := 0 to PropCount - 1 do
  begin
    Comp := GetComponent( I );
    if Comp <> nil then
    if Comp is TKOLMenuItem then
    begin
      (Comp as TKOLMenuItem).FOnMenuMethodName := AValue;
      (Comp as TKOLMenuItem).Change;
    end;
  end;
end;

{ TKOLAccelerator }

function TKOLAccelerator.AsText: String;
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLAccelerator.AsText', 0
  @@e_signature:
  end;
  Result:='';// {RA}
  if kapControl in Prefix then
    Result := 'Ctrl+';
  if kapAlt in Prefix then
    Result := Result + 'Alt+';
  if kapShift in Prefix then
    Result := Result + 'Shift+';
  {case Key of
  vkA..vkZ: S := Char(Ord(Key)-Ord(vkA)+Integer('A'));
  vk0..vk9: S := Char(Ord(Key)-Ord(vk0)+Integer('0'));
  vkF1..vkF24: S := 'F' + IntToStr( Ord(Key)-Ord(vkF1)+1 );
  vkDivide:   S := '/';
  vkMultiply: S := '*';
  vkSubtract: S := '-';
  vkAdd:      S := '+';
  vkNUM0..vkNUM9: S := 'Numpad' + IntToStr( Ord(Key)-Ord(vkNUM0) );
  vkNotPresent: S := '';
  else begin
         S := VirtKeys[ Key ];
         if Copy( S, 1, 3 ) = 'VK_' then
           S := CopyEnd( S, 4 );
       end;
  end;}
  S := VirtualKeyNames[Key]; // Maxim Pushkar
  if S = '' then Result := '' else Result := Result + S;
end;

procedure TKOLAccelerator.Change;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLAccelerator.Change', 0
  @@e_signature:
  end;
  if FOwner is TKOLMenuItem then
    TKOLMenuItem(FOwner).Change
  else
  if FOwner is TKOLAction then
    TKOLAction(FOwner).Change;
end;

procedure TKOLAccelerator.SetKey(const Value: TVirtualKey);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLAccelerator.SetKey', 0
  @@e_signature:
  end;
  FKey := Value;
  Change;
end;

procedure TKOLAccelerator.SetPrefix(const Value: TKOLAccPrefix);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLAccelerator.SetPrefix', 0
  @@e_signature:
  end;
  FPrefix := Value;
  Change;
end;

{ TKOLAccelearatorPropEditor }

procedure TKOLAcceleratorPropEditor.Edit;
var CAE: TKOLAccEdit;
    Comp: TPersistent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLAccelearatorPropEditor.Edit', 0
  @@e_signature:
  end;
  Comp := Getcomponent( 0 );
  if Comp = nil then Exit;
  if not ( Comp is TKOLMenuItem ) and not ( Comp is TKOLAction ) then Exit;
  CAE := TKOLAccEdit.Create( Application );
  try
    if Comp is TKOLMenuItem then
      with TKOLMenuItem(Comp) do
        CAE.Caption := CAE.Caption + MenuComponent.Name + '.' + Name
    else
    if Comp is TKOLAction then
      with TKOLAction(Comp) do
        CAE.Caption := CAE.Caption + ActionList.Name + '.' + Name;
        
    CAE.edAcc.Text := GetValue;
    CAE.ShowModal;
    if CAE.ModalResult = mrOK then
      SetValue( CAE.edAcc.Text );
  finally
    CAE.Free;
  end;
end;

function TKOLAcceleratorPropEditor.GetAttributes: TPropertyAttributes;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLAcceleratorPropEditor.GetAttributes', 0
  @@e_signature:
  end;
  Result := [ paDialog {, pasubProperties} ];
end;

function TKOLAcceleratorPropEditor.GetValue: string;
var Comp: TPersistent;
    MA: TKOLAccelerator;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLAcceleratorPropEditor.GetValue', 0
  @@e_signature:
  end;
  Comp := GetComponent( 0 );
  if Comp is TKOLMenuItem then
    MA := (Comp as TKOLMenuItem).Accelerator
  else
  if Comp is TKOLAction then
    MA := (Comp as TKOLAction).Accelerator
  else
    MA := nil;
  if MA <> nil then
    Result := MA.AsText
  else
    Result := '';
end;

procedure TKOLAcceleratorPropEditor.SetValue(const Value: string);
var Comp: TPersistent;
    MA: TKOLAccelerator;
    _Prefix: TKOLAccPrefix;
    _Key, K: TVirtualKey;
    S: String;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLAcceleratorPropEditor.SetValue', 0
  @@e_signature:
  end;
  Comp := GetComponent( 0 );
  if Comp is TKOLMenuItem then
    MA := (Comp as TKOLMenuItem).Accelerator
  else
  if Comp is TKOLAction then
    MA := (Comp as TKOLAction).Accelerator
  else
    MA := nil;
  if MA <> nil then
  begin
    _Prefix := [ ];
    _Key := vkNotPresent;
    S := Value;
    for I := Length( S ) downto 1 do
      if S[ I ] <= ' ' then
        S := Copy( S, 1, I - 1 ) + Copy( S, I + 1, Length( S ) - I );
    while S <> '' do
    begin
      if UPPERCASE(Copy( S, 1, 6 )) = 'SHIFT+' then
      begin
        S := Copy( S, 7, Length(S)-6 );
        _Prefix := _Prefix + [ kapShift ];
        continue;
      end;
      if UPPERCASE(Copy( S, 1, 5 )) = 'CTRL+' then
      begin
        S := Copy( S, 6, Length(S)-5 );
        _Prefix := _Prefix + [ kapControl ];
        continue;
      end;
      if UPPERCASE(Copy( S, 1, 4 )) = 'ALT+' then
      begin
        S := Copy( S, 5, Length(S)-4 );
        _Prefix := _Prefix + [ kapAlt ];
        continue;
      end;
      _Key := vkNotPresent;
      //---------------------- { Maxim Pushkar } ----------------------\
      {if Length( S ) = 1 then                                          |
      case S[ 1 ] of                                                    |
      'A'..'Z': _Key := TVirtualKey( Ord(S[1])-Ord('A')+Ord(vkA) );     |
      '0'..'9': _Key := TVirtualKey( Ord(S[1])-Ord('0')+Ord(vk0) );     |
      '-': _Key := vkSubtract;                                          |
      '+': _Key := vkAdd;                                               |
      '/': _Key := vkDivide;                                            |
      '*': _Key := vkMultiply;                                          |
      ',': _Key := vkDecimal;                                           |
      else _Key := vkNotPresent;                                        |
      end                                                               |
        else                                                            |
      if Length( S ) > 1 then                                           |
      begin                                                             |
        if (S[ 1 ] = 'F') and (Str2Int(CopyEnd(S,2)) <> 0) then         |
          _Key := TVirtualKey( Ord(vkF1) - 1 + Str2Int(CopyEnd(S,2) ) ) |
        else                                                            |
        begin                                                           |
          for K := Low(TVirtualKey) to High(TVirtualKey) do             |
            if 'VK_' + UPPERCASE(S) = UPPERCASE(VirtKeys[ K ]) then     |
            begin                                                       |
              _Key := K;                                                |
              break;                                                   /|
            end;                                                      //
        end;                                                         //
      end;}                                                         //
      //++++++++++++++++++++++ Maxim Pushkar ++++++++++++++++++++++//
      for K := Low(TVirtualKey) to High(TVirtualKey) do           //
        if UpperCase(S) = UpperCase(VirtualKeyNames[K]) then     //
          _Key := K;                                            //
      //-------------------------------------------------------//
      break;
    end;
    if _Key = vkNotPresent then
    begin
      MA.Key := _Key;
      MA.Prefix := [ ];
    end
      else
    begin
      MA.Key := _Key;
      MA.Prefix := _Prefix;
    end;
  end
    else
    Beep;
end;

{ TKOLBrush }

procedure TKOLBrush.Assign(Value: TPersistent);
var B: TKOLBrush;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBrush.Assign', 0
  @@e_signature:
  end;
  //inherited;
  if Value is TKOLBrush then
  begin
    B := Value as TKOLBrush;
    FColor := B.Color;
    FBrushStyle := B.BrushStyle;
    if B.FBitmap <> nil then
    begin
      if FBitmap = nil then
        FBitmap := TBitmap.Create;
      FBitmap.Assign( B.FBitmap )
    end
    else
    begin
      FBitmap.Free; FBitmap := nil;
    end;
    Change;
  end;
end;

procedure TKOLBrush.Change;
var Form: TCustomForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBrush.Change', 0
  @@e_signature:
  end;
  if fOwner = nil then Exit;
  if fChangingNow then Exit;
  try

    if fOwner is TKOLForm then
    begin
      (fOwner as TKOLForm).Change( fOwner );
      if (fOwner as TKOLForm).Owner <> nil then
      begin
        Form := (fOwner as TKOLForm).Owner as TCustomForm;
        Form.Invalidate;
      end;
    end
    else
    if (fOwner is TKOLCustomControl) then
    begin
{YS}
  {$IFDEF _KOLCtrlWrapper_}
      with (fOwner as TKOLCustomControl) do
        if Assigned(FKOLCtrl) then
          with FKOLCtrl^ do begin
            Brush.Color:=Self.Color;
            Brush.BrushStyle:=kol.TBrushStyle(BrushStyle);
//            Brush.BrushBitmap:=Bitmap.Handle;
          end;
  {$ENDIF}
{YS}
      (fOwner as TKOLCustomControl).Change;
      (fOwner as TKOLCustomControl).Invalidate;
     end
     else
       if (fOwner is TKOLObj) then
         (fOwner as TKOLObj).Change;

  finally
    fChangingNow := FALSE;
  end;
end;

constructor TKOLBrush.Create(AOwner: TComponent);
begin
  inherited Create;
  FOwner := AOwner;
  FBitmap := TBitmap.Create;
  FColor := clBtnFace;
end;

destructor TKOLBrush.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

procedure TKOLBrush.GenerateCode(SL: TStrings; const AName: String);
const
  BrushStyles: array[ TBrushStyle ] of String = ( 'bsSolid', 'bsClear', 'bsHorizontal', 'bsVertical',
    'bsFDiagonal', 'bsBDiagonal', 'bsCross', 'bsDiagCross' );
var RsrcName: String;
    Updated: Boolean;
begin
  if FOwner = nil then Exit;
  if FOwner is TKOLForm then
  begin
    if Bitmap.Empty then
    begin
      case BrushStyle of
      bsSolid: if (FOwner as TKOLForm).Color <> clBtnFace then
                 SL.Add( '    ' + AName + '.Color := ' + Color2Str( (FOwner as TKOLForm).Color ) + ';' );
      else SL.Add( '    ' + AName + '.Brush.BrushStyle := ' + BrushStyles[ BrushStyle ] + ';' );
      end;
    end
      else
    begin
      RsrcName := (FOwner as TKOLForm).Owner.Name + '_' +
                  (FOwner as TKOLForm).Name + '_BRUSH_BMP';
      SL.Add( '    {$R ' + RsrcName + '.res}' );
      GenerateBitmapResource( Bitmap, UPPERCASE( RsrcName ), RsrcName, Updated );
      SL.Add( '    ' + AName + '.Brush.BrushBitmap := LoadBmp( hInstance, ''' + UpperCase( RsrcName )
              + ''', Result );' );
    end;
  end
    else
  if FOwner is TKOLCustomControl then
  begin
    if Bitmap.Empty then
    begin
      case BrushStyle of
      bsSolid: if not (FOwner as TKOLCustomControl).ParentColor then
                 SL.Add( '    ' + AName + '.Color := ' + Color2Str( (FOwner as TKOLForm).Color ) + ';' );
      else SL.Add( '    ' + AName + '.Brush.BrushStyle := ' + BrushStyles[ BrushStyle ] + ';' );
      end;
    end
      else
    begin
      RsrcName := (FOwner as TKOLCustomControl).ParentForm.Name + '_' +
                  (FOwner as TKOLCustomControl).Name + '_BRUSH_BMP';
      SL.Add( '    {$R ' + RsrcName + '.res}' );
      GenerateBitmapResource( Bitmap, UPPERCASE( RsrcName ), RsrcName, Updated );
      SL.Add( '    ' + AName + '.Brush.BrushBitmap := LoadBmp( hInstance, ''' + UpperCase( RsrcName )
              + ''', Result );' );
    end;
  end;
end;

procedure TKOLBrush.SetBitmap(const Value: TBitmap);
begin
  FBitmap.Assign(Value);
  if FOwner <> nil then
    if FOwner is TKOLForm then
    begin
      {if (FOwner as TKOLForm).Owner <> nil then
        ((FOwner as TKOLForm).Owner as TCustomForm).Brush.Bitmap.Assign( Value );}
    end;
  Change;
end;

procedure TKOLBrush.SetBrushStyle(const Value: TBrushStyle);
begin
  if FBrushStyle = Value then Exit;
  FBrushStyle := Value;
  if FOwner <> nil then
    if FOwner is TKOLForm then
    begin
      if (FOwner as TKOLForm).Owner <> nil then
        ((Fowner as TKOLForm).Owner as TCustomForm).Brush.Style :=
        Graphics.TBrushStyle( Value );
    end;
  Change;
end;

procedure TKOLBrush.SetColor(const Value: TColor);
begin
  if FColor = Value then Exit;
  FColor := Value;
  if FOwner <> nil then
    if FOwner is TKOLForm then
      (FOwner as TKOLForm).Color := Value
    else
    if FOwner is TKOLCustomControl then
      (FOwner as TKOLCustomControl).Color := Value;
  Change;
end;

{ TKOLAction }

procedure TKOLAction.Assign(Source: TPersistent);
begin
  if Source is TKOLAction then
  begin
    FCaption := TKOLAction(Source).FCaption;
    FHint := TKOLAction(Source).FHint;
    FChecked := TKOLAction(Source).FChecked;
    FEnabled := TKOLAction(Source).FEnabled;
    FVisible := TKOLAction(Source).FVisible;
    FHelpContext := TKOLAction(Source).FHelpContext;
    FOnExecute := TKOLAction(Source).FOnExecute;

  end
  else
    inherited Assign(Source);
end;

constructor TKOLAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLinked:=TStringList.Create;
  FAccelerator:=TKOLAccelerator.Create;
  FAccelerator.FOwner:=Self;
  FVisible:=True;
  FEnabled:=True;
  NeedFree:=False;
end;

procedure TKOLAction.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('Links', LoadLinks, SaveLinks, FLinked.Count > 0);
end;

destructor TKOLAction.Destroy;
begin
  inherited;
  if FActionList <> nil then
    FActionList.List.Remove(Self);
  FLinked.Free;
  FAccelerator.Free;
end;

function TKOLAction.GetIndex: Integer;
begin
  if ActionList <> nil then
    Result := ActionList.List.IndexOf(Self)
  else
    Result := -1;
end;

function TKOLAction.GetParentComponent: TComponent;
begin
  if FActionList <> nil then
    Result := FActionList
  else
    Result := inherited GetParentComponent;
end;

function TKOLAction.HasParent: Boolean;
begin
  if FActionList <> nil then
    Result := True
  else
    Result := inherited HasParent;
end;

procedure TKOLAction.LinkComponent(const AComponent: TComponent);
begin
  ResolveLinks;
  if (FLinked.IndexOfObject(AComponent) = -1) and
     (FLinked.IndexOf(GetComponentFullPath(AComponent)) = -1) then
  begin
    FLinked.AddObject('', AComponent);
    AComponent.FreeNotification(Self); // 1.87 +YS
    UpdateLinkedComponent(AComponent);
  end;
end;

procedure TKOLAction.Loaded;
begin
  inherited;
  ResolveLinks;
end;

procedure TKOLAction.LoadLinks(R: TReader);
begin
  R.ReadListBegin;
  while not R.EndOfList do
    FLinked.Add(R.ReadString);
  R.ReadListEnd;
end;

procedure TKOLAction.ReadState(Reader: TReader);
begin
  inherited ReadState(Reader);
  if Reader.Parent is TKOLActionList then begin
    ActionList := TKOLActionList(Reader.Parent);
  end;
end;

procedure TKOLAction.ResolveLinks;
var
  i: integer;
  s: string;
  c: TComponent;
begin
  for i:=0 to FLinked.Count - 1 do begin
    s:=FLinked[i];
    if s <> '' then begin
      c:=FindComponentByPath(s);
      if c <> nil then begin
        FLinked[i]:='';
        FLinked.Objects[i]:=c;
        if c is TKOLMenuItem then
          TKOLMenuItem(c).action:=Self
        else
        if c is TKOLCustomControl then
          TKOLCustomControl(c).action:=Self
        else
        if c is TKOLToolbarButton then
          TKOLToolbarButton(c).action:=Self;
        c.FreeNotification(Self); // v1.87 YS
        UpdateLinkedComponent(c);
      end;
    end;
  end;
end;

procedure TKOLAction.SaveLinks(W: TWriter);
var
  i: integer;
  s: string;
begin
  W.WriteListBegin;
  for i:=0 to FLinked.Count - 1 do begin
    s:=FLinked[i];
    if (s = '') and (FLinked.Objects[i] <> nil) then
      s:=GetComponentFullPath(TComponent(FLinked.Objects[i]));
    if s <> '' then
      W.WriteString(s);
  end;
  W.WriteListEnd;
end;

procedure TKOLAction.SetActionList(const Value: TKOLActionList);
begin
  if FActionList = Value then exit;
  FActionList := Value;
  if FActionList <> nil then
    FActionList.List.Add(Self);
end;

procedure TKOLAction.SetCaption(const Value: string);
begin
  if FCaption = Value then exit;
  FCaption := Value;
  UpdateLinkedComponents;
  Change;
end;

procedure TKOLAction.SetChecked(const Value: boolean);
begin
  if FChecked = Value then exit;
  FChecked := Value;
  UpdateLinkedComponents;
  Change;
end;

procedure TKOLAction.SetEnabled(const Value: boolean);
begin
  if Enabled = Value then exit;
  FEnabled := Value;
  UpdateLinkedComponents;
  Change;
end;

procedure TKOLAction.SetHelpContext(const Value: integer);
begin
  if FHelpContext = Value then exit;
  FHelpContext := Value;
  UpdateLinkedComponents;
  Change;
end;

procedure TKOLAction.SetHint(const Value: string);
begin
  if FHint = Value then exit;
  FHint := Value;
  UpdateLinkedComponents;
  Change;
end;

procedure TKOLAction.SetIndex(Value: Integer);
var
  CurIndex, Count: Integer;
begin
  CurIndex := GetIndex;
  if CurIndex >= 0 then
  begin
    Count := ActionList.FActions.Count;
    if Value < 0 then Value := 0;
    if Value >= Count then Value := Count - 1;
    if Value <> CurIndex then
    begin
      ActionList.FActions.Delete(CurIndex);
      ActionList.FActions.Insert(Value, Self);
    end;
  end;
end;

procedure TKOLAction.SetName(const NewName: TComponentName);
begin
  inherited;
  if Assigned(ActionList) and Assigned(ActionList.ActiveDesign) then
    ActionList.ActiveDesign.NameChanged(Self);
end;

procedure TKOLAction.SetOnExecute(const Value: TOnEvent);
begin
  if @FOnExecute = @Value then exit;
  FOnExecute := Value;
  Change;
end;

procedure TKOLAction.SetParentComponent(AParent: TComponent);
begin
  if not (csLoading in ComponentState) and (AParent is TKOLActionList) then
    ActionList := TKOLActionList(AParent);
end;

procedure TKOLAction.SetupFirst(SL: TStringList; const AName, AParent, Prefix: String);
begin
  if Name <> '' then
  begin
    SL.Add( '   {$IFDEF USE_NAMES}' );
    SL.Add( Prefix + AName + '.Name := ''' + Name + ''';' );
    SL.Add( '   {$ENDIF}' );
  end;
end;

procedure TKOLAction.SetVisible(const Value: boolean);
begin
  if FVisible = Value then exit;
  FVisible := Value;
  UpdateLinkedComponents;
  Change;
end;

procedure TKOLAction.UnLinkComponent(const AComponent: TComponent);
var
  i: integer;
begin
  ResolveLinks;
  while True do begin
    i:=FLinked.IndexOfObject(AComponent);
    if i <> -1 then
      FLinked.Delete(i)
    else
      break;  
  end;
end;

function TKOLAction.FindComponentByPath(const Path: string): TComponent;
var
  i, j: integer;
  p, n: string;
begin
  p:=Path;
  Result:=nil;
  repeat
    i:=Pos('.', p);
    if i = 0 then
      i:=Length(p) + 1;
    n:=Copy(p, 1, i - 1);
    p:=Copy(p, i + 1, MaxInt);
    if Result = nil then begin
      for j:=0 to Screen.FormCount - 1 do
        if AnsiCompareText(Screen.Forms[j].Name, n) = 0 then begin
          Result:=Screen.Forms[j];
          break;
        end;
    end
    else
      Result:=Result.FindComponent(n);

//    if Result <> nil then
//      Rpt('Found: ' + Result.Name);
  until (p = '') or (Result = nil);
end;

function TKOLAction.GetComponentFullPath(AComponent: TComponent): string;
begin
  Result:='';
  while AComponent <> nil do begin
    if Result <> '' then
      Result:='.' + Result;
    Result:=AComponent.Name + Result;
    AComponent:=AComponent.Owner;
  end;
end;

procedure TKOLAction.UpdateLinkedComponents;
var
  i: integer;
begin
  for i:=0 to FLinked.Count - 1 do
    UpdateLinkedComponent(TComponent(FLinked.Objects[i]));
end;

procedure TKOLAction.UpdateLinkedComponent(AComponent: TComponent);
begin
  if AComponent is TKOLMenuItem then
    with TKOLMenuItem(AComponent) do begin
      if Self.FAccelerator.Key <> vkNotPresent then
        FCaption:=Self.FCaption + #9 + Self.FAccelerator.AsText
      else
        FCaption:=Self.FCaption;
      FVisible:=Self.FVisible;
      FEnabled:=Self.FEnabled;
      FChecked:=Self.FChecked;
      FHelpContext:=Self.FHelpContext;
      Change;
    end
  else
  if AComponent is TKOLCustomControl then begin
    with TKOLCustomControl(AComponent) do begin
      Caption:=Self.FCaption;
      Visible:=Self.FVisible;
      Enabled:=Self.FEnabled;
      HelpContext:=Self.FHelpContext;
      Change;
    end;
    if AComponent is TKOLCheckBox then
      with TKOLCheckBox(AComponent) do begin
        Checked:=Self.FChecked;
      end
    else
    if AComponent is TKOLRadioBox then
      with TKOLRadioBox(AComponent) do begin
        Checked:=Self.FChecked;
      end;
  end
  else
  if AComponent is TKOLToolbarButton then
    with TKOLToolbarButton(AComponent) do begin
      Caption:=Self.FCaption;
      Visible:=Self.FVisible;
      Enabled:=Self.FEnabled;
      Checked:=Self.FChecked;
      HelpContext:=Self.FHelpContext;
      tooltip:=Self.FHint;
      Change;
    end
  else
end;

procedure TKOLAction.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
    UnLinkComponent(AComponent);
end;

procedure TKOLAction.SetAccelerator(const Value: TKOLAccelerator);
begin
  if (FAccelerator.Prefix = Value.Prefix) and (FAccelerator.Key = Value.Key) then exit;
  FAccelerator := Value;
  UpdateLinkedComponents;
  Change;
end;

function TKOLAction.AdditionalUnits: String;
begin
  Result := ', KOLadd';
end;

{ TKOLActionList }

function TKOLActionList.AdditionalUnits: String;
begin
  Result := ', KOLadd';
end;

procedure TKOLActionList.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents(SL, AName, ['OnUpdateActions'], [@OnUpdateActions]);
end;

constructor TKOLActionList.Create(AOwner: TComponent);
begin
  inherited;
  FActions:=TList.Create;
end;

destructor TKOLActionList.Destroy;
begin
  ActiveDesign.Free;
  FActions.Free;
  inherited;
end;

procedure TKOLActionList.GetChildren(Proc: TGetChildProc {$IFDEF _D3orHigher} ; Root: TComponent {$ENDIF});
var
  I: Integer;
  Action: TKOLAction;
begin
  for I := 0 to FActions.Count - 1 do
  begin
    Action := FActions[I];
    {if Action.Owner = Root then }Proc(Action);
  end;
end;

function TKOLActionList.GetCount: integer;
begin
  Result:=FActions.Count;
end;

function TKOLActionList.GetKOLAction(Index: Integer): TKOLAction;
begin
  Result:=FActions[Index];
end;

procedure TKOLActionList.SetChildOrder(Component: TComponent;
  Order: Integer);
begin
  if FActions.IndexOf(Component) >= 0 then
    (Component as TKOLAction).Index := Order;
end;

procedure TKOLActionList.SetKOLAction(Index: Integer; const Value: TKOLAction);
begin
  TKOLAction(FActions[Index]).Assign(Value);
end;

procedure TKOLActionList.SetOnUpdateActions(const Value: TOnEvent);
begin
  if @FOnUpdateActions = @Value then exit;
  FOnUpdateActions:=Value;
  Change;
end;

procedure TKOLActionList.SetupFirst(SL: TStringList; const AName, AParent, Prefix: String);
begin
  SL.Add( Prefix + AName + ' := NewActionList( ' + AParent + ' );' );
  if Name <> '' then
  begin
    SL.Add( '   {$IFDEF USE_NAMES}' );
    SL.Add( Prefix + AName + '.Name := ''' + Name + ''';' );
    SL.Add( '   {$ENDIF}' );
  end;
  GenerateTag( SL, AName, Prefix );
end;

procedure TKOLActionList.SetupLast(SL: TStringList; const AName, AParent, Prefix: String);
var
  i, j: integer;
  s, ss, n, p, pf: string;
  c: TComponent;
begin
  SL.Add('');
  n:=Prefix + AName;
  p:=AName;
  i:=Pos('.', AName);
  if i <> 0 then
    pf:=Copy(AName, 1, i - 1)
  else
    pf:=AName;
  p:=Prefix + pf;

  for i:=0 to FActions.Count - 1 do
    with Actions[i] do begin
      ResolveLinks;
      if @FOnExecute <> nil then
        s:=pf + '.' + ParentForm.MethodName(@FOnExecute)
      else
        s:='nil';

      ss:=Caption;
      //---------------------------------------- remove by YS 7 Aug 2004 -|
      //if Accelerator.Key <> vkNotPresent then                           |
      //  ss:=ss + #9 + Accelerator.AsText;                               |
      //------------------------------------------------------------------|
      SL.Add(Format('%s.%s := %s.Add( %s, %s, %s );',
                    [p, Name, AName, StringConstant('Caption', ss),
                     StringConstant('Hint', Hint), s]));

      for j:=0 to FLinked.Count - 1 do begin
        c:=TComponent(FLinked.Objects[j]);
        if c = nil then
          SL.Add(Format('%s// WARNING: Linked component %s can not be found. Possibly it is located at form that not currently loaded.', [Prefix, FLinked[j]]))
        else
          if c is TKOLMenuItem then begin
            with TKOLMenuItem(c) do
              SL.Add(Format('%s.%s.LinkMenuItem( %s.%s, %d );', [p, Actions[i].Name, pf, MenuComponent.Name, itemindex]))
          end
          else
          if c is TKOLCustomControl then
            with TKOLCustomControl(c) do
              SL.Add(Format('%s.%s.LinkControl( %s.%s );', [p, Actions[i].Name, pf, Name]))
          else
          if c is TKOLToolbarButton then
            with TKOLToolbarButton(c) do
              SL.Add(Format('%s.%s.LinkToolbarButton( %s.%s, %d );', [p, Actions[i].Name, pf, ToolbarComponent.Name, ToolbarComponent.Items.IndexOf(c)]))
      end;

      if Checked then
        SL.Add(Format('%s.%s.Checked := True;', [p, Name]));
      if not Visible then
        SL.Add(Format('%s.%s.Visible := False;', [p, Name]));
      if not Enabled then
        SL.Add(Format('%s.%s.Enabled := False;', [p, Name]));
      if HelpContext <> 0 then
        SL.Add(Format('%s.%s.HelpContext := %d;', [p, Name, HelpContext]));
      if Tag <> 0 then
        SL.Add(Format('%s.%s.Tag := %d;', [p, Name, Tag]));

      if Accelerator.Key <> vkNotPresent then begin
        S := 'FVIRTKEY';
        if kapShift in Accelerator.Prefix then
          S := S + ' or FSHIFT';
        if kapControl in Accelerator.Prefix then
          S := S + ' or FCONTROL';
        if kapAlt in Accelerator.Prefix then
          S := S + ' or FALT';
        if kapNoinvert in Accelerator.Prefix then
          S := S + ' or FNOINVERT';
        SL.Add(Format('%s.%s.Accelerator := MakeAccelerator(%s, %s);', [p, Name, S, VirtKeys[ Accelerator.Key ]]));
      end;


      SL.Add('');
    end;
end;

{ TKOLActionListEditor }

procedure TKOLActionListEditor.Edit;
var AL: TKOLActionList;
begin
  if Component = nil then Exit;
  if not(Component is TKOLActionList) then Exit;
  AL := Component as TKOLActionList;
  if AL.ActiveDesign = nil then
    AL.ActiveDesign := TfmActionListEditor.Create( Application );
  AL.ActiveDesign.ActionList := AL;
  AL.ActiveDesign.Visible := True;
  SetForegroundWindow( AL.ActiveDesign.Handle );
  AL.ActiveDesign.MakeActive( TRUE );
{
  if AL.ParentForm <> nil then
    AL.ParentForm.Invalidate;
}
end;

procedure TKOLActionListEditor.ExecuteVerb(Index: Integer);
begin
  Edit;
end;

function TKOLActionListEditor.GetVerb(Index: Integer): string;
begin
  Result := '&Edit actions';
end;

function TKOLActionListEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

{ TKOLControl }

procedure TKOLControl.Change;
begin
  //Log( '->TKOLControl.Change' );
  TRY
    inherited;
  //LogOK;
  FINALLY
    //Log( '<-TKOLControl.Change' );
  END;
end;

function TKOLControl.Generate_SetSize: String;
begin
  Result := inherited Generate_SetSize;
end;


initialization

finalization
  {$IFDEF MCKLOG}
    Log( '->F i n a l i z a t i o n' );
    FormsList.Free;
    FormsList := nil;
    LogOK;
    Log( '<-F i n a l i z a t i o n' );
    {$IFDEF MCKLOGBUFFERED}
      if (LogBuffer <> nil) and (LogBuffer.Count > 0) then
        LogFileOutput( 'C:\MCK.log', LogBuffer.Text );
      FreeAndNil( LogBuffer );
    {$ENDIF}
  {$ENDIF}

end.
