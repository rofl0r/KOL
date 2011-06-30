{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

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
}
unit mckCtrls;
{
  This unit contains definitions for mirrors of the most of visual controls,
  defined in KOL. This mirror objects are placed on form at design time and
  behave itselves like usual VCL visual components (controls). But after
  compiling of the project (and at run time) these are transformed to poor KOL
  controls, so all bloats of VCL are removed and executable file become very small.

  ƒ‡ÌÌ˚È ÏÓ‰ÛÎ¸ ÒÓ‰ÂÊËÚ ÓÔÂ‰ÂÎÂÌËÂ ÁÂÍ‡Î ‰Îˇ ·ÓÎ¸¯ËÌÒÚ‚‡ ‚ËÁÛ‡Î¸Ì˚ı Ó·˙ÂÍÚÓ‚,
  ÓÔÂ‰ÂÎÂÌÌ˚ı ‚ ·Ë·ÎËÓÚÂÍÂ KOL. «ÂÍ‡Î¸Ì˚Â Ó·˙ÂÍÚ˚ ÔÓÏÂ˘‡˛ÚÒˇ Ì‡ ÙÓÏÛ ‚Ó ‚ÂÏˇ
  ÔÓÂÍÚËÓ‚‡ÌËˇ Ë ‚Â‰ÛÚ ÒÂ·ˇ Ú‡Í ÊÂ, Í‡Í Ó·˚˜Ì˚Â ‚ËÁÛ‡Î¸Ì˚Â Ó·˙ÂÍÚ˚ VCL. ÕÓ
  ÔÓÒÎÂ ÍÓÏÔËÎˇˆËË ÔÓÂÍÚ‡ (Ë ‚Ó ‚ÂÏˇ ËÒÔÓÎÌÂÌËˇ) ÓÌË Ú‡ÌÒÙÓÏËÛ˛ÚÒˇ ‚
  Ó·˙ÂÍÚ˚ KOL, Ú‡Í ˜ÚÓ ‚ÒÂ "Ì‡‚ÓÓÚ˚" VCL Û‰‡Îˇ˛ÚÒˇ Ë ËÒÔÓÎÌËÏ˚È Ù‡ÈÎ ÒÚ‡ÌÓ‚ËÚÒˇ
  Ó˜ÂÌ¸ Ï‡ÎÂÌ¸ÍËÏ.
}

interface

{$I KOLDEF.INC}

uses KOL, Classes, Forms, Controls, Dialogs, Windows, Messages, extctrls,
     stdctrls, comctrls, CommCtrl, SysUtils, Graphics, mirror, ShellAPI,
     mckObjs,
//////////////////////////////////////////////////
     {$IFDEF _D6orHigher}                       //
     DesignIntf, DesignEditors, DesignConst,    //
     Variants,                                  //
     {$ELSE}                                    //
//////////////////////////////////////////////////
     DsgnIntf,
//////////////////////////////////////////////////////////
     {$ENDIF}                                           //
     mckToolbarEditor,  mckLVColumnsEditor
     ;

type

  //============================================================================
  //---- MIRROR FOR A BUTTON ----
  //---- «≈– ¿ÀŒ ƒÀﬂ  ÕŒœ » ----
  TKOLButton = class(TKOLControl)
  private
    FpopupMenu: TKOLPopupMenu;
    FLikeSpeedButton: Boolean;
    Fimage: TPicture;
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
    procedure SetLikeSpeedButton(const Value: Boolean);
    procedure Setimage(const Value: TPicture);
  protected
    function TabStopByDefault: Boolean; override;
    procedure FirstCreate; override;
    function GenerateTransparentInits: String; override;
    function SetupParams( const AName, AParent: String ): String; override;
    procedure SetupColor( SL: TStrings; const AName: String ); override;
    procedure SetupFont( SL: TStrings; const AName: String ); override;
    procedure SetupTextAlign( SL: TStrings; const AName: String ); override;
    function ClientMargins: TRect; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function CanNotChangeFontColor: Boolean; override;
    function DefaultParentColor: Boolean; override;
    function CanChangeColor: Boolean; override;
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
    function NoDrawFrame: Boolean; override;
    procedure CreateKOLControl(Recreating: boolean); override;
    function ImageResourceName: String;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    property TextAlign;
    property VerticalAlign;
    property TabStop;
    property TabOrder;
    property OnEnter;
    property OnLeave;
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property LikeSpeedButton: Boolean read FLikeSpeedButton write SetLikeSpeedButton;
    property autoSize;
    property DefaultBtn;
    property CancelBtn;
    property image: TPicture read Fimage write Setimage;
    property action;
  end;

  //============================================================================
  //---- MIRROR FOR A BIT BUTTON ----
  //---- «≈– ¿ÀŒ ƒÀﬂ –»—Œ¬¿ÕÕŒ…  ÕŒœ » ----
  TKOLBitBtn = class(TKOLControl)
  private
    FOptions: TBitBtnOptions;
    FGlyphBitmap: TBitmap;
    FGlyphCount: Integer;
    FImageList: TKOLImageList;
    FGlyphLayout: TGlyphLayout;
    FImageIndex: Integer;
    FOnTestMouseOver: TOnTestMouseOver;
    FpopupMenu: TKOLPopupMenu;
    FLikeSpeedButton: Boolean;
    FRepeatInterval: Integer;
    FFlat: Boolean;
    FautoAdjustSize: Boolean;
    FBitBtnDrawMnemonic: Boolean;
    FTextShiftY: Integer;
    FTextShiftX: Integer;
    procedure SetOptions(Value: TBitBtnOptions);
    procedure SetGlyphBitmap(const Value: TBitmap);
    procedure SetGlyphCount(Value: Integer);
    procedure SetImageList(const Value: TKOLImageList);
    procedure SetGlyphLayout(const Value: TGlyphLayout);
    procedure SetImageIndex(const Value: Integer);
    procedure RecalcSize;
    procedure SetOnTestMouseOver(const Value: TOnTestMouseOver);
    procedure SetautoAdjustSize(const Value: Boolean);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
    procedure SetLikeSpeedButton(const Value: Boolean);
    procedure SetRepeatInterval(const Value: Integer);
    procedure SetFlat(const Value: Boolean);
    procedure SetBitBtnDrawMnemonic(const Value: Boolean);
    procedure SetTextShiftX(const Value: Integer);
    procedure SetTextShiftY(const Value: Integer);
  protected
    function TabStopByDefault: Boolean; override;
    procedure FirstCreate; override;
    function GenerateTransparentInits: String; override;
    function SetupParams( const AName, AParent: String ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupTextAlign( SL: TStrings; const AName: String ); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    function ClientMargins: TRect; override;
    procedure AutoSizeNow; override;
    procedure CreateKOLControl(Recreating: boolean); override;
    function NoDrawFrame: Boolean; override;
  public
    constructor Create( AOwner: TComponent ); override;
    procedure NotifyLinkedComponent( Sender: TObject; Operation: TNotifyOperation ); override;
    destructor Destroy; override;
  published
    property options: TBitBtnOptions read FOptions write SetOptions;
    property glyphBitmap: TBitmap read FGlyphBitmap write SetGlyphBitmap;
    property glyphCount: Integer read FGlyphCount write SetGlyphCount;
    property glyphLayout: TGlyphLayout read FGlyphLayout write SetGlyphLayout;
    property imageList: TKOLImageList read FImageList write SetImageList;
    property imageIndex: Integer read FImageIndex write SetImageIndex;
    property TextAlign;
    property VerticalAlign;
    property TabStop;
    property TabOrder;
    property Transparent;
    property OnEnter;
    property OnLeave;
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property OnBitBtnDraw;
    property OnTestMouseOver: TOnTestMouseOver read FOnTestMouseOver write SetOnTestMouseOver;
    property autoAdjustSize: Boolean read FautoAdjustSize write SetautoAdjustSize;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property LikeSpeedButton: Boolean read FLikeSpeedButton write SetLikeSpeedButton;
    property RepeatInterval: Integer read FRepeatInterval write SetRepeatInterval;
    property Flat: Boolean read FFlat write SetFlat;
    property autoSize;
    property BitBtnDrawMnemonic: Boolean read FBitBtnDrawMnemonic write SetBitBtnDrawMnemonic;
    property TextShiftX: Integer read FTextShiftX write SetTextShiftX;
    property TextShiftY: Integer read FTextShiftY write SetTextShiftY;
    property DefaultBtn;
    property CancelBtn;
    property Brush;
    property action;
  end;























  //============================================================================
  //---- MIRROR FOR A LABEL ----
  //---- «≈– ¿ÀŒ ƒÀﬂ Ã≈“ » ----
  TKOLLabel = class(TKOLControl)
  private
    FwordWrap: Boolean;
    FpopupMenu: TKOLPopupMenu;
    FShowAccelChar: Boolean;
    function Get_VertAlign: TVerticalAlign;
    procedure Set_VertAlign(const Value: TVerticalAlign);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
    procedure SetShowAccelChar(const Value: Boolean);
  protected
    fTabOrder: Integer;
    function AdjustVerticalAlign( Value: TVerticalAlign ): TVerticalAlign; virtual;
    procedure SetwordWrap(const Value: Boolean); virtual;
    procedure FirstCreate; override;
    function SetupParams( const AName, AParent: String ): String; override;
    procedure SetupTextAlign( SL: TStrings; const AName: String ); override;
    function GetTaborder: Integer; override;
    function TypeName: String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );
              override;
    procedure CallInheritedPaint;
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
  public
    constructor Create( AOwner: TComponent ); override;
  published
    property Transparent;
    property TextAlign;
    property VerticalAlign: TVerticalAlign read Get_VertAlign write Set_VertAlign;
    property wordWrap: Boolean read FwordWrap write SetwordWrap;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property autoSize;
    property Brush;
    property ShowAccelChar: Boolean read FShowAccelChar write SetShowAccelChar;
  end;


  //============================================================================
  //---- MIRROR FOR A LABEL EFFECT ----
  //---- «≈– ¿ÀŒ ƒÀﬂ Ã≈“ » — ›‘‘≈ “¿Ã» ----
  TKOLLabelEffect = class( TKOLLabel )
  private
    FShadowDeep: Integer;
    FColor2: TColor;
    procedure SetShadowDeep(const Value: Integer);
    procedure SetColor2(const Value: TColor);
  protected
    function AdjustVerticalAlign( Value: TVerticalAlign ): TVerticalAlign; override;
    procedure SetwordWrap(const Value: Boolean); override;
    function SetupParams( const AName, AParent: String ): String; override;
    procedure SetupTextAlign( SL: TStrings; const AName: String ); override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function AutoWidth( Canvas: graphics.TCanvas ): Integer; override;
    function AutoHeight( Canvas: graphics.TCanvas ): Integer; override;
    procedure Paint; override;
  public
    constructor Create( AOwner: TComponent ); override;
  published
    property ShadowDeep: Integer read FShadowDeep write SetShadowDeep;
    property Color2: TColor read FColor2 write SetColor2;
    property autoSize;
    //property wordWrap: Boolean read fNotAvailable;
    property Ctl3D;
    property Brush;
  end;

















  //============================================================================
  //---- MIRROR FOR A PANEL ----
  //---- «≈– ¿ÀŒ ƒÀﬂ œ¿Õ≈À» ----
  TKOLPanel = class(TKOLControl)
  private
    FEdgeStyle: TEdgeStyle;
    FpopupMenu: TKOLPopupMenu;
    FShowAccelChar: Boolean;
    procedure SetEdgeStyle(const Value: TEdgeStyle);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
    procedure SetShowAccelChar(const Value: Boolean);
  protected
    function Get_VA: TVerticalAlign;
    procedure Set_VA(const Value: TVerticalAlign); virtual;
    function SetupParams( const AName, AParent: String ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupConstruct( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupTextAlign( SL: TStrings; const AName: String ); override;
    function ClientMargins: TRect; override;
    function RefName: String; override;
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
    function NoDrawFrame: Boolean; override;
    procedure SetCaption( const Value: String ); override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    property Transparent;
    property TextAlign;
    property edgeStyle: TEdgeStyle read FEdgeStyle write SetEdgeStyle;
    property TabOrder;
    property VerticalAlign: TVerticalAlign read Get_VA write Set_VA;
    property Border;
    property MarginTop;
    property MarginBottom;
    property MarginLeft;
    property MarginRight;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property Brush;
    property ShowAccelChar: Boolean read FShowAccelChar write SetShowAccelChar;
  end;

  //============================================================================
  //---- MIRROR FOR MDI CLIENT ----
  //---- «≈– ¿ÀŒ ƒÀﬂ MDI  À»≈Õ“¿ ----
  TKOLMDIClient = class(TKOLControl)
  private
    FTimer: TTimer;
    procedure Tick( Sender: TObject );
  protected
    function SetupParams( const AName, AParent: String ): String; override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    property TabOrder;
  end;


  //===========================================================================
  //---- MIRROR FOR A GRADIENT PANEL
  //---- «≈– ¿ÀŒ ƒÀﬂ √–¿ƒ»≈Õ“ÕŒ… œ¿Õ≈À»
  TKOLGradientPanel = class(TKOLControl)
  private
    FColor1: TColor;
    FColor2: TColor;
    FpopupMenu: TKOLPopupMenu;
    FgradientLayout: TGradientLayout;
    FgradientStyle: TGradientStyle;
    procedure SetColor1(const Value: TColor);
    procedure SetColor2(const Value: TColor);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
    procedure SetgradientLayout(const Value: TGradientLayout);
    procedure SetgradientStyle(const Value: TGradientStyle);
  protected
    function TabStopByDefault: Boolean; override;
    function TypeName: String; override;
    function SetupParams( const AName, AParent: String ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
    function NoDrawFrame: Boolean; override;
  public
    constructor Create( AOwner: TComponent ); override;
  published
    property Transparent;
    property Color1: TColor read FColor1 write SetColor1;
    property Color2: TColor read FColor2 write SetColor2;
    property GradientStyle: TGradientStyle read FgradientStyle write SetgradientStyle;
    property GradientLayout: TGradientLayout read FgradientLayout write SetgradientLayout;
    property TabOrder;
    property Border;
    property MarginTop;
    property MarginBottom;
    property MarginLeft;
    property MarginRight;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property HasBorder;
  end;



  //===========================================================================
  //---- MIRROR FOR A SPLITTER
  //---- «≈– ¿ÀŒ ƒÀﬂ –¿«ƒ≈À»“≈Àﬂ
  TKOLSplitter = class( TKOLControl )
  private
    FMinSizePrev: Integer;
    FMinSizeNext: Integer;
    //FBeveled: Boolean;
    FEdgeStyle: TEdgeStyle;
    fNotAvailable: Boolean;
    procedure SetMinSizeNext(const Value: Integer);
    procedure SetMinSizePrev(const Value: Integer);
    //procedure SetBeveled(const Value: Boolean);
    procedure SetEdgeStyle(const Value: TEdgeStyle);
  protected
    function IsCursorDefault: Boolean; override;
    function SetupParams( const AName, AParent: String ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function TypeName: String; override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    function BestEventName: String; override;
    procedure CreateKOLControl(Recreating: boolean); override;
    function NoDrawFrame: Boolean; override;
  public
    constructor Create( AOwner: TComponent ); override;
  published
    property Transparent;
    property MinSizePrev: Integer read FMinSizePrev write SetMinSizePrev;
    property MinSizeNext: Integer read FMinSizeNext write SetMinSizeNext;
    property TabOrder;
    //property beveled: Boolean read FBeveled write SetBeveled;
    property edgeStyle: TEdgeStyle read FEdgeStyle write SetEdgeStyle;
    property Caption: Boolean read fNotAvailable;
    //property CenterOnParent: Boolean read fNotAvailable;
    property OnSplit;
    property Brush;
  end;



  //===========================================================================
  //---- MIRROR FOR A GROUPBOX
  //---- «≈– ¿ÀŒ ƒÀﬂ √–”œœ€
  TKOLGroupBox = class( TKOLControl )
  private
    FpopupMenu: TKOLPopupMenu;
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
  protected
    function TabStopByDefault: Boolean; override;
    procedure FirstCreate; override;
    function SetupParams( const AName, AParent: String ): String; override;
    function ClientMargins: TRect; override;
    function DrawMargins: TRect; override;
    {$IFDEF _KOLCtrlWrapper_} {YS}
    procedure CreateKOLControl(Recreating: boolean); override;
    {$ENDIF}
  public
    constructor Create( AOwner: TComponent ); override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
  published
    property Transparent;
    property TabOrder;
    property Border;
    property MarginTop;
    property MarginBottom;
    property MarginLeft;
    property MarginRight;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property TextAlign;
    property HasBorder;
    property Brush;
  end;


  //===========================================================================
  //---- MIRROR FOR A CHECKBOX
  //---- «≈– ¿ÀŒ ƒÀﬂ ‘À¿∆ ¿
  TKOLCheckBox = class( TKOLControl )
  private
    FChecked: Boolean;
    FpopupMenu: TKOLPopupMenu;
    FAuto3State: Boolean;
    procedure SetChecked(const Value: Boolean);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
    procedure SetAuto3State(const Value: Boolean);
  protected
    function TabStopByDefault: Boolean; override;
    procedure FirstCreate; override;
    function SetupParams( const AName, AParent: String ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
    function NoDrawFrame: Boolean; override;
    procedure CreateKOLControl(Recreating: boolean); override;
    function TypeName: String; override;
  public
    constructor Create( AOwner: TComponent ); override;
  published
    property Transparent;
    property Checked: Boolean read FChecked write SetChecked;
    property TabStop;
    property TabOrder;
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property OnEnter;
    property OnLeave;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property autoSize;
    property HasBorder;
    property Brush;
    property Auto3State: Boolean read FAuto3State write SetAuto3State;
    property action;
  end;


  //===========================================================================
  //---- MIRROR FOR A RADIOBOX
  //---- «≈– ¿ÀŒ ƒÀﬂ –¿ƒ»Œ-‘À¿∆ ¿
  TKOLRadioBox = class( TKOLControl )
  private
    FChecked: Boolean;
    FpopupMenu: TKOLPopupMenu;
    procedure SetChecked(const Value: Boolean);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
  protected
    function TabStopByDefault: Boolean; override;
    procedure FirstCreate; override;
    function SetupParams( const AName, AParent: String ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
    function NoDrawFrame: Boolean; override;
  public
    constructor Create( AOwner: TComponent ); override;
  published
    property Transparent;
    property Checked: Boolean read FChecked write SetChecked;
    property TabStop;
    property TabOrder;
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property OnEnter;
    property OnLeave;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property autoSize;
    property HasBorder;
    property Brush;
    property action;
  end;








  //===========================================================================
  //---- MIRROR FOR AN EDITBOX
  //---- «≈– ¿ÀŒ ƒÀﬂ Œ Õ¿ ¬¬Œƒ¿
  TKOLEditOption = ( {eoNoHScroll, eoNoVScroll,} eoLowercase, {eoMultiline,}
                  eoNoHideSel, eoOemConvert, eoPassword, eoReadonly,
                  eoUpperCase, eoWantTab, eoNumber );
  TKOLEditOptions = Set of TKOLEditOption;

  TKOLEditBox = class( TKOLControl )
  private
    FOptions: TKOLEditOptions;
    FpopupMenu: TKOLPopupMenu;
    FEdTransparent: Boolean;
    procedure SetOptions(const Value: TKOLEditOptions);
    function GetCaption: String;
    function GetText: String;
    procedure SetText(const Value: String);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
    procedure SetEdTransparent(const Value: Boolean);
  protected
    function TabStopByDefault: Boolean; override;
    procedure FirstCreate; override;
    function SetupParams( const AName, AParent: String ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure WantTabs( Want: Boolean ); override;
    function DefaultColor: TColor; override;
    function BestEventName: String; override;
    procedure SetupTextAlign(SL: TStrings; const AName: String); override;
  public
    constructor Create( AOwner: TComponent ); override;
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
    function NoDrawFrame: Boolean; override;
  published
    property Transparent: Boolean read FEdTransparent write SetEdTransparent;
    property Text: String read GetText write SetText;
    property Options: TKOLEditOptions read FOptions write SetOptions;
    property TabStop;
    property TabOrder;
    property OnChange;
    property OnSelChange;
    property Caption: String read GetCaption; // redefined as read only to remove from Object Inspector
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property OnEnter;
    property OnLeave;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property TextAlign;
    property autoSize;
    property HasBorder;
    property EditTabChar;
    property Brush;
  end;


  //===========================================================================
  //---- MIRROR FOR A MEMO
  //---- «≈– ¿ÀŒ ƒÀﬂ ÃÕŒ√Œ—“–Œ◊ÕŒ√Œ Œ Õ¿ ¬¬Œƒ¿
  TKOLMemoOption = ( eo_NoHScroll, eo_NoVScroll, eo_Lowercase, {eoMultiline,}
                  eo_NoHideSel, eo_OemConvert, eo_Password, eo_Readonly,
                  eo_UpperCase, eo_WantReturn, eo_WantTab );
                  // Character '_' is used to prevent conflict of option names
                  // with the same in TKOLEditOption type. Fortunately, we never
                  // should to use these names in run-time code of the project.
                  //
                  // —ËÏ‚ÓÎ '_' ËÒÔÓÎ¸ÁÛÂÚÒˇ, ˜ÚÓ·˚ ÔÂ‰ÓÚ‚‡ÚËÚ¸ ÍÓÌÙÎËÍÚ Ò
                  // ËÏÂÌ‡ÏË Ú‡ÍËı ÊÂ ÓÔˆËÈ ‰Îˇ ÚËÔ‡ TKOLEditOption.   Ò˜‡ÒÚ¸˛,
                  // Ì‡Ï ˝ÚË ËÏÂÌ‡ ÌËÍÓ„‰‡ ÌÂ ÔÓÌ‡‰Ó·ˇÚÒˇ ÔË Ì‡ÔËÒ‡ÌËË ÍÓÌÂ˜ÌÓ„Ó
                  // ÍÓ‰‡.
  TKOLMemoOptions = Set of TKOLMemoOption;

  TKOLMemo = class( TKOLControl )
  private
    FOptions: TKOLMemoOptions;
    FLines: TStrings;
    FpopupMenu: TKOLPopupMenu;
    FEdTransparent: Boolean;
    procedure SetOptions(const Value: TKOLMemoOptions);
    function GetCaption: String;
    procedure SetText(const Value: TStrings);
    function GetText: TStrings;
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
    procedure SetEdTransparent(const Value: Boolean);
  protected
    function TabStopByDefault: Boolean; override;
    procedure FirstCreate; override;
    function SetupParams( const AName, AParent: String ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function DefaultColor: TColor; override;
    function BestEventName: String; override;
    procedure CreateKOLControl(Recreating: boolean); override;
    procedure KOLControlRecreated; override;
    function NoDrawFrame: Boolean; override;
    procedure Loaded; override;
    procedure SetTextAlign(const Value: TTextAlign); override;
    procedure SetupTextAlign(SL: TStrings; const AName: String); override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    function TypeName: String; override;
    procedure WantTabs( Want: Boolean ); override;
  published
    property Transparent: Boolean read FEdTransparent write SetEdTransparent;
    property Text: TStrings read GetText write SetText;
    property TextAlign;
    property TabStop;
    property TabOrder;
    property Options: TKOLMemoOptions read FOptions write SetOptions;
    property OnChange;
    property OnSelChange;
    property Caption: String read GetCaption; // redefined as read only to remove from Object Inspector
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property OnEnter;
    property OnLeave;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property HasBorder;
    property OnScroll;
    property EditTabChar;
    property Brush;
  end;




  //===========================================================================
  //---- MIRROR FOR A RICHEDIT
  //---- «≈– ¿ÀŒ ƒÀﬂ –≈ƒ¿ “Œ–¿
  TKOLRichEditVersion = ( ver1, ver3 );

  TKOLRichEdit = class( TKOLControl )
  private
    FOptions: TKOLMemoOptions;
    FLines: TStrings;
    Fversion: TKOLRichEditVersion;
    FMaxTextSize: DWORD;
    FRE_FmtStandard: Boolean;
    FRE_AutoKeyboard: Boolean;
    FRE_AutoKeybdSet: Boolean;
    FRE_DisableOverwriteChange: Boolean;
    FRE_AutoURLDetect: Boolean;
    FRE_Transparent: Boolean;
    FpopupMenu: TKOLPopupMenu;
    FOLESupport: Boolean;
    function GetText: TStrings;
    procedure SetText(const Value: TStrings);
    procedure SetOptions(const Value: TKOLMemoOptions);
    function GetCaption: String;
    procedure Setversion(const Value: TKOLRichEditVersion);
    procedure SetMaxTextSize(const Value: DWORD);
    procedure SetRE_FmtStandard(const Value: Boolean);
    procedure SetRE_AutoKeyboard(const Value: Boolean);
    procedure SetRE_AutoKeybdSet(const Value: Boolean);
    procedure SetRE_DisableOverwriteChange(const Value: Boolean);
    procedure SetRE_AutoURLDetect(const Value: Boolean);
    procedure SetRE_Transparent(const Value: Boolean);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
    procedure SetOLESupport(const Value: Boolean);
  protected
    function TabStopByDefault: Boolean; override;
    procedure FirstCreate; override;
    function SetupParams( const AName, AParent: String ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function TypeName: String; override;
    function GenerateTransparentInits: String; override;
    procedure BeforeFontChange( SL: TStrings; const AName, Prefix: String ); override;
    function FontPropName: String; override;
    procedure AfterFontChange( SL: TStrings; const AName, Prefix: String ); override;
    procedure WantTabs( Want: Boolean ); override;
    function DefaultColor: TColor; override;
    function AdditionalUnits: String; override;
    function BestEventName: String; override;
    procedure CreateKOLControl(Recreating: boolean); override;
    procedure KOLControlRecreated; override;
    procedure Loaded; override;
    function NoDrawFrame: Boolean; override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    property Transparent read FRE_Transparent write SetRE_Transparent;
    property RE_Transparent: Boolean read FRE_Transparent write SetRE_Transparent;
    property Text: TStrings read GetText write SetText;
    property TabStop;
    property TabOrder;
    property Options: TKOLMemoOptions read FOptions write SetOptions;
    property OnChange;
    property OnSelChange;
    property Caption: String read GetCaption; // redefined as read only to remove from Object Inspector
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property version: TKOLRichEditVersion read Fversion write Setversion;
    property OnProgress;
    property OnRE_URLClick;
    property OnRE_OverURL;
    property OnRE_InsOvrMode_Change;
    property RE_DisableOverwriteChange: Boolean read FRE_DisableOverwriteChange write SetRE_DisableOverwriteChange;
    property MaxTextSize: DWORD read FMaxTextSize write SetMaxTextSize;
    property RE_FmtStandard: Boolean read FRE_FmtStandard write SetRE_FmtStandard;
    property RE_AutoKeyboard: Boolean read FRE_AutoKeyboard write SetRE_AutoKeyboard;
    property RE_AutoKeybdSet: Boolean read FRE_AutoKeybdSet write SetRE_AutoKeybdSet;
    property RE_AutoURLDetect: Boolean read FRE_AutoURLDetect write SetRE_AutoURLDetect;
    property OnEnter;
    property OnLeave;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property HasBorder;
    property OnScroll;
    property EditTabChar;
    property Brush;
    property OLESupport: Boolean read FOLESupport write SetOLESupport;
  end;





  //===========================================================================
  //---- MIRROR FOR A LISTBOX
  //---- «≈– ¿ÀŒ ƒÀﬂ —œ»— ¿
  TKOLListboxOption = ( loNoHideScroll, loNoExtendSel, loMultiColumn, loMultiSelect,
                  loNoIntegralHeight, loNoSel, loSort, loTabstops,
                  loNoStrings, loNoData, loOwnerDrawFixed, loOwnerDrawVariable );
  TKOLListboxOptions = Set of TKOLListboxOption;

  TKOLListBox = class( TKOLControl )
  private
    FOptions: TKOLListboxOptions;
    FItems: TStrings;
    FCurIndex: Integer;
    FCount: Integer;
    FpopupMenu: TKOLPopupMenu;
    procedure SetOptions(const Value: TKOLListboxOptions);
    procedure SetItems(const Value: TStrings);
    procedure SetCurIndex(const Value: Integer);
    function GetCaption: String;
    procedure SetCount(Value: Integer);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
    procedure UpdateItems;
  protected
    function TabStopByDefault: Boolean; override;
    procedure FirstCreate; override;
    function SetupParams( const AName, AParent: String ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function DefaultColor: TColor; override;
    procedure CreateKOLControl(Recreating: boolean); override;
    procedure KOLControlRecreated; override;
    function NoDrawFrame: Boolean; override;
    procedure Loaded; override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    property Transparent;
    property TabStop;
    property TabOrder;
    property Options: TKOLListboxOptions read FOptions write SetOptions;
    property OnSelChange;
    property Items: TStrings read FItems write SetItems;
    property CurIndex: Integer read FCurIndex write SetCurIndex;
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property Caption: String read GetCaption; // hide Caption in Object Inspector
    property OnDrawItem;
    property OnMeasureItem;
    property Count: Integer read FCount write SetCount;
    property OnEnter;
    property OnLeave;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property HasBorder;
    property OnScroll;
    property Brush;
  end;






  //===========================================================================
  //---- MIRROR FOR A COMBOBOX
  //---- «≈– ¿ÀŒ ƒÀﬂ ¬€œ¿ƒ¿ﬁŸ≈√Œ —œ»— ¿
  TKOLComboOption = ( coReadOnly, coNoHScroll, coAlwaysVScroll, coLowerCase,
                   coNoIntegralHeight, coOemConvert, coSort, coUpperCase,
                   coOwnerDrawFixed, coOwnerDrawVariable, coSimple );
  TKOLComboOptions = Set of TKOLComboOption;

  TKOLComboBox = class( TKOLControl )
  private
    FOptions: TKOLComboOptions;
    FItems: TStrings;
    FCurIndex: Integer;
    FDroppedWidth: Integer;
    FpopupMenu: TKOLPopupMenu;
    procedure SetOptions(const Value: TKOLComboOptions);
    procedure SetCurIndex(const Value: Integer);
    procedure SetItems(const Value: TStrings);
    procedure SetDroppedWidth(const Value: Integer);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
  protected
    function TabStopByDefault: Boolean; override;
    procedure FirstCreate; override;
    function SetupParams( const AName, AParent: String ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function DefaultColor: TColor; override;
    function DefaultInitialColor: TColor; override;
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
    function NoDrawFrame: Boolean; override;
    function AutoHeight( Canvas: graphics.TCanvas ): Integer; override;
    function AutoSizeRunTime: Boolean; override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    property Transparent;
    property TabStop;
    property TabOrder;
    property Options: TKOLComboOptions read FOptions write SetOptions;
    property OnChange;
    property OnSelChange;
    property OnDropDown;
    property OnCloseUp;
    property Items: TStrings read FItems write SetItems;
    property CurIndex: Integer read FCurIndex write SetCurIndex;
    property DroppedWidth: Integer read FDroppedWidth write SetDroppedWidth;
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property OnMeasureItem;
    property OnDrawItem;
    property OnEnter;
    property OnLeave;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property autoSize;
    property Brush;
  end;




  //===========================================================================
  //---- MIRROR FOR A PAINTBOX
  //---- «≈– ¿ÀŒ ƒÀﬂ ÃŒÀ‹¡≈–“¿
  TKOLPaintBox = class( TKOLControl )
  private
    FpopupMenu: TKOLPopupMenu;
    fNotAvailable: Boolean;
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
  protected
    function SetupParams( const AName, AParent: String ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function BestEventName: String; override;
  public
    constructor Create( AOwner: TComponent ); override;
  published
    property Transparent;
    property OnPaint;
    property Border;
    property MarginTop;
    property MarginBottom;
    property MarginLeft;
    property MarginRight;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property Caption: Boolean read fNotAvailable;
  end;



  //===========================================================================
  //---- MIRROR FOR A IMAGESHOW
  //---- «≈– ¿ÀŒ ƒÀﬂ  ¿–“»Õ »
  TKOLImageShow = class( TKOLControl )
  private
    FCurIndex: Integer;
    FImageListNormal: TKOLImageList;
    FpopupMenu: TKOLPopupMenu;
    fNotAvailable: Boolean;
    FHasBorder: Boolean;
    fImgShwAutoSize: Boolean;
    procedure SetCurIndex(const Value: Integer);
    procedure SetImageListNormal(const Value: TKOLImageList);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
    procedure SetImgShwAutoSize(const Value: Boolean);
  protected
    function SetupParams( const AName, AParent: String ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure DoAutoSize;
    procedure SetHasBorder(const Value: Boolean); override;
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
    function NoDrawFrame: Boolean; override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    procedure NotifyLinkedComponent( Sender: TObject; Operation: TNotifyOperation ); override;
    procedure SetBounds( aLeft, aTop, aWidth, aHeight: Integer ); override;
  published
    property ImageListNormal: TKOLImageList read FImageListNormal write SetImageListNormal;
    property CurIndex: Integer read FCurIndex write SetCurIndex;
    property Transparent;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property Caption: Boolean read fNotAvailable;
    property HasBorder; //: Boolean read FHasBorder write SetHasBorder;
    property autoSize: Boolean read fImgShwAutoSize write SetImgShwAutoSize;
    property Brush;
  end;

  //===========================================================================
  //---- MIRROR FOR A PROGRESSBAR
  //---- «≈– ¿ÀŒ ƒÀﬂ À»Õ≈… » œ–Œ√–≈——¿
  TKOLProgressBar = class( TKOLControl )
  private
    FVertical: Boolean;
    FSmooth: Boolean;
    //FProgressBkColor: TColor;
    FProgressColor: TColor;
    FMaxProgress: Integer;
    FProgress: Integer;
    fNotAvailable: Boolean;
    FpopupMenu: TKOLPopupMenu;
    procedure SetSmooth(const Value: Boolean);
    procedure SetVertical(const Value: Boolean);
    //procedure SetProgressBkColor(const Value: TColor);
    procedure SetProgressColor(const Value: TColor);
    procedure SetMaxProgress(const Value: Integer);
    procedure SetProgress(const Value: Integer);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
    function GetColor: TColor;
    procedure SetColor(const Value: TColor);
  protected
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function SetupParams( const AName, AParent: String ): String; override;
    function TypeName: String; override;
    procedure CreateKOLControl(Recreating: boolean); override;
    procedure KOLControlRecreated; override;
    function NoDrawFrame: Boolean; override;
  public
    constructor Create( AOwner: TComponent ); override;
  published
    property Transparent;
    property Vertical: Boolean read FVertical write SetVertical;
    property Smooth: Boolean read FSmooth write SetSmooth;
    property ProgressColor: TColor read FProgressColor write SetProgressColor;
    property ProgressBkColor: TColor read GetColor write SetColor;
    property Progress: Integer read FProgress write SetProgress;
    property MaxProgress: Integer read FMaxProgress write SetMaxProgress;
    property Caption: Boolean read fNotAvailable;
    property OnMouseDblClk: Boolean read fNotAvailable;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property Brush;
  end;


  //===========================================================================
  //---- MIRROR FOR A LISTVIEW
  //---- «≈– ¿ÀŒ ƒÀﬂ œ–Œ—ÃŒ“–¿ —œ»— ¿ / “¿¡À»÷€
  TKOLListViewStyle = ( lvsIcon, lvsSmallIcon, lvsList, lvsDetail, lvsDetailNoHeader );

  TKOLListViewOption = ( lvoIconLeft, lvoAutoArrange, lvoButton, lvoEditLabel,
    lvoNoLabelWrap, lvoNoScroll, lvoNoSortHeader, lvoHideSel, lvoMultiselect,
    lvoSortAscending, lvoSortDescending, lvoGridLines, lvoSubItemImages,
    lvoCheckBoxes, lvoTrackSelect, lvoHeaderDragDrop, lvoRowSelect, lvoOneClickActivate,
    lvoTwoClickActivate, lvoFlatsb, lvoRegional, lvoInfoTip, lvoUnderlineHot,
    lvoMultiWorkares, lvoOwnerData, lvoOwnerDrawFixed );
  TKOLListViewOptions = Set of TKOLListViewOption;

  TKOLListViewColWidthType = ( lvcwtCustom, lvcwtAutosize, lvcwtAutoSizeCaption );

  TKOLListView = class;

  TKOLListViewColumn = class( TComponent )
  private
    FListView: TKOLListView;
    FLVColImage: Integer;
    FLVColOrder: Integer;
    FWidth: Integer;
    FCaption: String;
    FWidthType: TKOLListViewColWidthType;
    FTextAlign: TTextAlign;
    FLVColRightImg: Boolean;
    procedure SetCaption(const Value: String);
    procedure SetLVColImage(const Value: Integer);
    procedure SetLVColOrder(const Value: Integer);
    procedure SetTextAlign(const Value: TTextAlign);
    procedure SetWidth(const Value: Integer);
    procedure SetWidthType(const Value: TKOLListViewColWidthType);
    procedure Change;
    procedure SetLVColRightImg(const Value: Boolean);
  protected
    procedure SetName( const AName: TComponentName ); override;
    procedure DefProps( const Prefix: String; Filer: TFiler );
    procedure LoadName( Reader: TReader );
    procedure SaveName( Writer: TWriter );
    procedure LoadCaption( Reader: TReader );
    procedure SaveCaption( Writer: TWriter );
    procedure LoadTextAlign( Reader: TReader );
    procedure SaveTextAlign( Writer: TWriter );
    procedure LoadWidth( Reader: TReader );
    procedure SaveWidth( Writer: TWriter );
    procedure LoadWidthType( Reader: TReader );
    procedure SaveWidthType( Writer: TWriter );
    procedure LoadLVColImage( Reader: TReader );
    procedure SaveLVColImage( Writer: TWriter );
    procedure LoadLVColOrder( Reader: TReader );
    procedure SaveLVColOrder( Writer: TWriter );
    procedure LoadLVColRightImg( Reader: TReader );
    procedure SaveLVColRightImg( Writer: TWriter );
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    property Caption: String read FCaption write SetCaption;
    property TextAlign: TTextAlign read FTextAlign write SetTextAlign;
    property Width: Integer read FWidth write SetWidth;
    property WidthType: TKOLListViewColWidthType read FWidthType write SetWidthType;
    property LVColImage: Integer read FLVColImage write SetLVColImage;
    property LVColRightImg: Boolean read FLVColRightImg write SetLVColRightImg;
    property LVColOrder: Integer read FLVColOrder write SetLVColOrder;
  end;

  TKOLListView = class( TKOLControl )
  private
    FOptions: TKOLListViewOptions;
    FStyle: TKOLListViewStyle;
    FImageListNormal: TKOLImageList;
    FImageListSmall: TKOLImageList;
    FImageListState: TKOLImageList;
    FCurIndex: Integer;
    FLVCount: Integer;
    FpopupMenu: TKOLPopupMenu;
    FLVBkColor: TColor;
    FLVTextBkColor: TColor;
    FOnLVDelete: TOnLVDelete;
    FGenerateColIdxConst: Boolean;
    FOnLVCustomDraw: TOnLVCustomDraw;
    {$IFNDEF _D2}
    FOnLVDataW: TOnLVDataW;
    {$ENDIF _D2}
    fLVItemHeight: Integer;
    procedure SetOptions(const Value: TKOLListViewOptions);
    procedure SetStyle(const Value: TKOLListViewStyle);
    procedure SetImageListNormal(const Value: TKOLImageList);
    procedure SetImageListSmall(const Value: TKOLImageList);
    procedure SetImageListState(const Value: TKOLImageList);
    function GetCaption: String;
    procedure SetLVCount(Value: Integer);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
    procedure SetLVTextBkColor(const Value: TColor);
    function GetColor: TColor;
    procedure SetColor(const Value: TColor);
    procedure SetOnLVDelete(const Value: TOnLVDelete);
    function GetColumns: String;
    procedure SetColumns(const Value: String);
    procedure SetGenerateColIdxConst(const Value: Boolean);
    procedure SetOnLVCustomDraw(const Value: TOnLVCustomDraw);
    procedure UpdateColumns;
    {$IFNDEF _D2}
    procedure SetOnLVDataW(const Value: TOnLVDataW); {YS}
    {$ENDIF _D2}
    procedure SetLVItemHeight(const Value: Integer);
  protected
    FCols: TList;
    FColCount: Integer;
    function TabStopByDefault: Boolean; override;
    function SetupParams( const AName, AParent: String ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function DefaultColor: TColor; override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    procedure DefineProperties( Filer: TFiler ); override;
    procedure LoadColCount( Reader: TReader );
    procedure SaveColCount( Writer: TWriter );
    procedure DoGenerateConstants( SL: TStringList ); override;
    procedure Loaded; override; {YS}
    function NoDrawFrame: Boolean; override;
    procedure CreateKOLControl(Recreating: boolean); override;
    procedure KOLControlRecreated; override;
    function GetDefaultControlFont: HFONT; override;
    function GenerateTransparentInits: String; override;
  public
    ActiveDesign: TfmLVColumnsEditor;
    constructor Create( AOwner: TComponent ); override;
    procedure NotifyLinkedComponent( Sender: TObject; Operation: TNotifyOperation ); override;
    destructor Destroy; override;
    property Cols: TList read FCols;
    function HasOrderedColumns: Boolean;
    procedure Invalidate; override; {YS}
  published
    property Transparent;
    property Style: TKOLListViewStyle read FStyle write SetStyle;
    property Options: TKOLListViewOptions read FOptions write SetOptions;
    property ImageListSmall: TKOLImageList read FImageListSmall write SetImageListSmall;
    property ImageListNormal: TKOLImageList read FImageListNormal write SetImageListNormal;
    property ImageListState: TKOLImageList read FImageListState write SetImageListState;
    //property CurIndex: Integer read FCurIndex write SetCurIndex;
    property OnChange;
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property Caption: String read GetCaption; // hide Caption in Object Inspector
    property OnDeleteLVItem;
    property OnDeleteAllLVItems;
    property OnLVData;
    property LVCount: Integer read FLVCount write SetLVCount;
    property LVTextBkColor: TColor read FLVTextBkColor write SetLVTextBkColor;
    property LVBkColor: TColor read GetColor write SetColor;
    property LVItemHeight: Integer read fLVItemHeight write SetLVItemHeight;
    property OnCompareLVItems;
    property OnEndEditLVItem;
    property OnColumnClick;
    property OnLVStateChange;
    property OnDrawItem;
    property OnLVCustomDraw: TOnLVCustomDraw read FOnLVCustomDraw write SetOnLVCustomDraw;
    property OnEnter;
    property OnLeave;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property OnMeasureItem;
    property HasBorder;
    property OnScroll;
    property TabStop;
    property OnLVDelete: TOnLVDelete read FOnLVDelete write SetOnLVDelete;
    property Columns: String read GetColumns write SetColumns stored FALSE;
    property generateConstants: Boolean read FGenerateColIdxConst write SetGenerateColIdxConst;
    property Brush;
    property Unicode;
    {$IFNDEF _D2}
    property OnLVDataW: TOnLVDataW read FOnLVDataW write SetOnLVDataW;
    {$ENDIF _D2}
  end;

  TKOLLVColumnsEditor = class( TComponentEditor )
  private
  protected
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TKOLLVColumnsPropEditor = class( TStringProperty )
  private
  protected
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;



  //===========================================================================
  //---- MIRROR FOR A TREEVIEW
  //---- «≈– ¿ÀŒ ƒÀﬂ œ–Œ—ÃŒ“–¿ ƒ≈–≈¬¿
  TKOLTreeViewOption = ( tvoNoLines, tvoLinesRoot, tvoNoButtons, tvoEditLabels, tvoHideSel,
                  tvoDragDrop, tvoNoTooltips, tvoCheckBoxes, tvoTrackSelect,
                  tvoSingleExpand, tvoInfoTip, tvoFullRowSelect, tvoNoScroll,
                  tvoNonEvenHeight );
  TKOLTreeViewOptions = Set of TKOLTreeViewOption;

  TKOLTreeView = class( TKOLControl )
  private
    FOptions: TKOLTreeViewOptions;
    FCurIndex: Integer;
    FImageListNormal: TKOLImageList;
    FImageListState: TKOLImageList;
    FTVRightClickSelect: Boolean;
    FpopupMenu: TKOLPopupMenu;
    FTVIndent: Integer;
    procedure SetOptions(const Value: TKOLTreeViewOptions);
    procedure SetCurIndex(const Value: Integer);
    procedure SetImageListNormal(const Value: TKOLImageList);
    procedure SetImageListState(const Value: TKOLImageList);
    procedure SetTVRightClickSelect(const Value: Boolean);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
    procedure SetTVIndent(const Value: Integer);
  protected
    function TabStopByDefault: Boolean; override;
    function SetupParams( const AName, AParent: String ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function DefaultColor: TColor; override;
    procedure CreateKOLControl(Recreating: boolean); override;
    function NoDrawFrame: Boolean; override;
  public
    constructor Create( AOwner: TComponent ); override;
    procedure NotifyLinkedComponent( Sender: TObject; Operation: TNotifyOperation ); override;
    destructor Destroy; override;
  published
    property Transparent;
    property Options: TKOLTreeViewOptions read FOptions write SetOptions;
    property ImageListNormal: TKOLImageList read FImageListNormal write SetImageListNormal;
    property ImageListState: TKOLImageList read FImageListState write SetImageListState;
    property CurIndex: Integer read FCurIndex write SetCurIndex;
    property TVRightClickSelect: Boolean read FTVRightClickSelect write SetTVRightClickSelect;
    property OnChange;
    property OnSelChange;
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property OnTVBeginDrag;
    property OnTVBeginEdit;
    property OnTVEndEdit;
    property OnTVExpanding;
    property OnTVExpanded;
    property OnTVDelete;
    property OnTVSelChanging;
    property OnEnter;
    property OnLeave;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property TVIndent: Integer read FTVIndent write SetTVIndent;
    property HasBorder;
    property OnScroll;
    property TabStop;
    property Brush;
    property Unicode;
  end;

  //===========================================================================
  //---- MIRROR FOR A TOOLBAR
  //---- «≈– ¿ÀŒ ƒÀﬂ À»Õ≈… »  ÕŒœŒ 
  TKOLToolbar = class;

  TSystemToolbarImage = ( stiCustom, stdCUT, stdCOPY, stdPASTE, stdUNDO,
                      stdREDO, stdDELETE, stdFILENEW, stdFILEOPEN,
                      stdFILESAVE, stdPRINTPRE, stdPROPERTIES,
                      stdHELP, stdFIND, stdREPLACE, stdPRINT,

                      viewLARGEICONS, viewSMALLICONS, viewLIST,
                      viewDETAILS, viewSORTNAME, viewSORTSIZE,
                      viewSORTDATE, viewSORTTYPE, viewPARENTFOLDER,
                      viewNETCONNECT, viewNETDISCONNECT, viewNEWFOLDER,
                      viewVIEWMENU,

                      histBACK, histFORWARD, histFAVORITES,
                      histADDTOFAVORITES, histVIEWTREE );

  TKOLToolbarButton = class( TComponent )
  private
    FToolbar: TKOLToolbar;
    Fenabled: Boolean;
    Fseparator: Boolean;
    Fvisible: Boolean;
    Fdropdown: Boolean;
    Fcaption: String;
    Ftooltip: String;
    FonClick: TOnToolbarButtonClick;
    fOnClickMethodName: String;
    Fpicture: TPicture;
    Fchecked: Boolean;
    fNotAvailable: Boolean;
    Fsysimg: TSystemToolbarImage;
    FradioGroup: Integer;
    FimgIndex: Integer;
    Faction: TKOLAction;
    procedure Setcaption(const Value: String);
    procedure Setdropdown(const Value: Boolean);
    procedure Setenabled(const Value: Boolean);
    procedure SetonClick(const Value: TOnToolbarButtonClick);
    procedure Setpicture(Value: TPicture);
    procedure Setseparator(const Value: Boolean);
    procedure Settooltip(const Value: String);
    procedure Setvisible(const Value: Boolean);
    procedure Setchecked(const Value: Boolean);
    procedure Setsysimg(const Value: TSystemToolbarImage);
    procedure SetradioGroup(const Value: Integer);
    procedure SetimgIndex(const Value: Integer);
    procedure Setaction(const Value: TKOLAction);
  protected
    procedure Change;
    procedure SetName( const NewName: TComponentName ); override;
    procedure DefProps( const Prefix: String; Filer: Tfiler );
    procedure LoadName( Reader: TReader );
    procedure SaveName( Writer: TWriter );
    procedure LoadProps( Reader: TReader );
    procedure SaveProps( Writer: TWriter );
    procedure LoadCaption( Reader: TReader );
    procedure SaveCaption( Writer: TWriter );
    procedure LoadChecked( Reader: TReader );
    procedure SaveChecked( Writer: TWriter );
    procedure LoadDropDown( Reader: TReader );
    procedure SaveDropDown( Writer: TWriter );
    procedure LoadEnabled( Reader: TReader );
    procedure SaveEnabled( Writer: TWriter );
    procedure LoadSeparator( Reader: TReader );
    procedure SaveSeparator( Writer: TWriter );
    procedure LoadTooltip( Reader: TReader );
    procedure SaveTooltip( Writer: TWriter );
    procedure LoadVisible( Reader: TReader );
    procedure SaveVisible( Writer: TWriter );
    procedure LoadOnClick( Reader: TReader );
    procedure SaveOnClick( Writer: TWriter );
    procedure LoadPicture( Reader: TReader );
    procedure SavePicture( Writer: TWriter );
    procedure LoadSysImg( Reader: TReader );
    procedure SaveSysImg( Writer: TWriter );
    procedure LoadRadioGroup( Reader: TReader );
    procedure SaveRadioGroup( Writer: TWriter );
    procedure LoadImgIndex( Reader: TReader );
    procedure SaveImgIndex( Writer: TWriter );
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    function HasPicture: Boolean;
    property ToolbarComponent: TKOLToolbar read FToolbar;
  published
    property separator: Boolean read Fseparator write Setseparator;
    property dropdown: Boolean read Fdropdown write Setdropdown;
    property checked: Boolean read Fchecked write Setchecked;
    property radioGroup: Integer read FradioGroup write SetradioGroup;
    property picture: TPicture read Fpicture write Setpicture;
    property sysimg: TSystemToolbarImage read Fsysimg write Setsysimg;
    property imgIndex: Integer read FimgIndex write SetimgIndex;
    property visible: Boolean read Fvisible write Setvisible;
    property enabled: Boolean read Fenabled write Setenabled;
    property onClick: TOnToolbarButtonClick read FonClick write SetonClick;
    property caption: String read Fcaption write Setcaption;
    property tooltip: String read Ftooltip write Settooltip;
    property Tag: Boolean read fNotAvailable;
    property action: TKOLAction read Faction write Setaction;
  end;

  TKOLToolbar = class( TKOLControl )
  private
    FOptions: TToolbarOptions;
    Fbitmap: TBitmap;
    Fbuttons: String;
    FnoTextLabels: Boolean;
    Ftooltips: TStrings;
    FshowTooltips: Boolean;
    FmapBitmapColors: Boolean;
    FpopupMenu: TKOLPopupMenu;
    fNotAvailable: Boolean;
    FTimer: TTimer;
    FItems: TList; // of TKOLToolbarButton
    FButtonCount: Integer;
    FStandardImagesLarge: Boolean;
    FgenerateConstants: Boolean;
    FbuttonMinWidth: Integer;
    FbuttonMaxWidth: Integer;
    FHeightAuto: Boolean;
    FimageListNormal: TKOLImageList;
    FimageListDisabled: TKOLImageList;
    FimageListHot: TKOLImageList;
    FFixFlatXP: Boolean;
    FTBButtonsWidth: Integer;
    procedure SetOptions(const Value: TToolbarOptions);
    procedure Setbitmap(const Value: TBitmap);
    procedure SetnoTextLabels(const Value: Boolean);
    procedure Settooltips(const Value: TStrings);
    procedure SetshowTooltips(const Value: Boolean);
    procedure SetmapBitmapColors(const Value: Boolean);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
    procedure SetBtnCount_Dummy(const Value: Integer);
    function MaxBtnImgHeight: Integer;
    function MaxBtnImgWidth: Integer;
    procedure SetStandardImagesLarge(const Value: Boolean);
    procedure SetgenerateConstants(const Value: Boolean);
    procedure SetbuttonMaxWidth(const Value: Integer);
    procedure SetbuttonMinWidth(const Value: Integer);
    function GetButtons: String;
    procedure SetAutoHeight(const Value: Boolean);
    procedure UpdateButtons;
    procedure CMDesignHitTest(var Message: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure SetimageList(const Value: TKOLImageList);
    procedure SetDisabledimageList(const Value: TKOLImageList);
    procedure SetHotimageList(const Value: TKOLImageList);
    procedure SetFixFlatXP(const Value: Boolean);
    procedure SetTBButtonsWidth(const Value: Integer);
  protected
    FResBmpID: Integer;
    fNewVersion: Boolean;
    FBmpTranColor: TColor;
    FBmpDesign: HBitmap;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function SetupParams( const AName, AParent: String ): String; override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadNewVersion( Reader: TReader );
    procedure WriteNewVersion( Writer: TWriter );
    procedure LoadButtonCount( R: TReader );
    procedure SaveButtonCount( W: TWriter );
    procedure Loaded; override;
    function StandardImagesUsed: Integer;
    function PicturedButtonsCount: Integer;
    function ImagedButtonsCount: Integer;
    function NoMorePicturedButtonsFrom( Idx: Integer ): Boolean;
    function AllPicturedButtonsAreLeading: Boolean;
    function LastBtnHasPicture: Boolean;
    procedure CreateKOLControl(Recreating: boolean); override;
    procedure KOLControlRecreated; override;
    function NoDrawFrame: Boolean; override;
    procedure SetMargin(const Value: Integer); override;
    procedure Paint; override;
    function GetDefaultControlFont: HFONT; override;
    function ImageListsUsed: Boolean;
  public
    function Generate_SetSize: String; override;
  public
    ActiveDesign: TfmToolbarEditor;
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    procedure Change; override;
    procedure Tick( Sender: TObject );
    property Items: TList read FItems;
    procedure Items2buttons;
    procedure DoGenerateConstants( SL: TStringList ); override;
    procedure NotifyLinkedComponent( Sender: TObject; Operation: TNotifyOperation ); override;
    function MaxImgIndex: Integer;
  published
    property Transparent;
    property Options: TToolbarOptions read FOptions write SetOptions;
    property bitmap: TBitmap read Fbitmap write Setbitmap;
    property buttons: String read GetButtons write Fbuttons;
    property OnTBDropDown;
    property OnClick;
    property noTextLabels: Boolean read FnoTextLabels write SetnoTextLabels;
    property tooltips: TStrings read Ftooltips write Settooltips;
    property showTooltips: Boolean read FshowTooltips write SetshowTooltips;
    property mapBitmapColors: Boolean read FmapBitmapColors write SetmapBitmapColors;
    property Border;
    property MarginTop;
    property MarginBottom;
    property MarginLeft;
    property MarginRight;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property Caption: Boolean read fNotAvailable;
    property HasBorder;

    property ButtonCount: Integer read FButtonCount write SetBtnCount_Dummy
             stored FALSE;
    procedure buttons2Items;
    procedure bitmap2ItemPictures( AnyWay: Boolean );
    procedure AssembleBitmap;
    procedure AssembleTooltips;
    property StandardImagesLarge: Boolean read FStandardImagesLarge write SetStandardImagesLarge;
    property generateConstants: Boolean read FgenerateConstants write SetgenerateConstants;
    property TBButtonsMinWidth: Integer read FbuttonMinWidth write SetbuttonMinWidth;
    property TBButtonsMaxWidth: Integer read FbuttonMaxWidth write SetbuttonMaxWidth;
    property TBButtonsWidth: Integer read FTBButtonsWidth write SetTBButtonsWidth;
    property HeightAuto: Boolean read FHeightAuto write SetAutoHeight;
    property Brush;
    property Ctl3D;

    property imageListNormal: TKOLImageList read FimageListNormal write SetimageList;
    property imageListDisabled: TKOLImageList read FimageListDisabled write SetDisabledimageList;
    property imageListHot: TKOLImageList read FimageListHot write SetHotimageList;

    property FixFlatXP: Boolean read FFixFlatXP write SetFixFlatXP;
        // If TRUE (default) then some styles are changed in case of XP on start.
        // This useful (and necessary) only if XP Manifest is used in the application
        // in other case this property can be set to FALSE to make code smaller
        // and to prevent "heavy" property TRUE from usage.
        // This property has effect only for toolbars with tboFlat style though.
  end;

  TKOLToolbarButtonsEditor = class( TStringProperty )
  private
  protected
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TKOLToolbarEditor = class( TComponentEditor )
  private
  protected
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TKOLToolButtonOnClickPropEditor = class( TMethodProperty )
  private
    FResetting: Boolean;
  protected
  public
    function GetValue: string; override;
    procedure SetValue(const AValue: string); override;
  end;


  //===========================================================================
  //---- MIRROR FOR A DATE TIME PICKER
  //---- «≈– ¿ÀŒ ƒÀﬂ ¬¬Œƒ¿ ƒ¿“€ » ¬–≈Ã≈Õ»
  TKOLDateTimePicker = class( TKOLControl )
  private
    FOnDTPUserString: TDTParseInputEvent;
    FOptions: TDateTimePickerOptions;
    FFormat: String;
    procedure SetOnDTPUserString(const Value: TDTParseInputEvent);
    procedure SetOptions(const Value: TDateTimePickerOptions);
    procedure SetFormat(const Value: String);
  protected
    function SetupParams( const AName, AParent: String ): String; override;
    function GenerateTransparentInits: String; override;
    procedure SetupFirst(SL: TStringList; const AName, AParent, Prefix: String); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
  public
    constructor Create( AOwner: TComponent ); override;
  published
    function TabStopByDefault: Boolean; override;
    property OnDTPUserString: TDTParseInputEvent read FOnDTPUserString write SetOnDTPUserString;
    property Options: TDateTimePickerOptions read FOptions write SetOptions;
    property Format: String read FFormat write SetFormat;
    property TabStop;
  end;



  //===========================================================================
  //---- MIRROR FOR A TAB CONTROL
  //---- «≈– ¿ÀŒ ƒÀﬂ “¿¡”À»–Œ¬¿ÕÕŒ√Œ ¡ÀŒ ÕŒ“¿
  TKOLTabPage = TKOLPanel;

  TKOLTabControl = class( TKOLControl )
  private
    FOptions: TTabControlOptions;
    FImageList: TKOLImageList;
    FTabs: TList;
    FImageList1stIdx: Integer;
    FedgeType: TEdgeStyle;
    FpopupMenu: TKOLPopupMenu; // of TRect
    FCurPage: TKOLPanel;
    FgenerateConstants: Boolean;
    procedure SetOptions(const Value: TTabControlOptions);
    procedure SetImageList(const Value: TKOLImageList);
    function GetPages(Idx: Integer): TKOLTabPage;
    procedure SetCount(const Value: Integer);
    function GetCount: Integer;
    procedure AdjustPages;
    function GetCurIndex: Integer;
    procedure SetCurIndex(const Value: Integer);
    procedure AttemptToChangePageBounds( Sender: TObject; var NewBounds: TRect );
    procedure SetImageList1stIdx(const Value: Integer);
    procedure SetedgeType(const Value: TEdgeStyle);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
    procedure SetgenerateConstants(const Value: Boolean);
  protected
    fDestroyingTabControl: Boolean;
    FAdjustingPages: Boolean;
    function TabStopByDefault: Boolean; override;
    function SetupParams( const AName, AParent: String ): String; override;
    procedure SetupFirst(SL: TStringList; const AName, AParent, Prefix: String); override;
    procedure SetupLast(SL: TStringList; const AName, AParent, Prefix: String); override;
    procedure SchematicPaint;
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
    function NoDrawFrame: Boolean; override;
    function GetCurrentPage: TKOLTabPage;
    procedure DoGenerateConstants( SL: TStringList ); override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    property Pages[ Idx: Integer ]: TKOLTabPage read GetPages;
    procedure SetBounds( aLeft, aTop, aWidth, aHeight: Integer ); override;
  published
    property Transparent;
    property Options: TTabControlOptions read FOptions write SetOptions;
    property ImageList: TKOLImageList read FImageList write SetImageList;
    property ImageList1stIdx: Integer read FImageList1stIdx write SetImageList1stIdx;
    property Count: Integer read GetCount write SetCount;
    property Font;
    property CurIndex: Integer read GetCurIndex write SetCurIndex stored FALSE;
    property OnSelChange;
    property edgeType: TEdgeStyle read FedgeType write SetedgeType;
    property Border;
    property MarginTop;
    property MarginBottom;
    property MarginLeft;
    property MarginRight;
    property OnEnter;
    property OnLeave;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property generateConstants: Boolean read FgenerateConstants write SetgenerateConstants;
    property OnDrawItem;
    property Brush;
  end;

  TKOLTabControlEditor = class( TComponentEditor )
  // This component editor is to provide easy page select on tab control with
  // double click on one of page indicators.
  private
  protected
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;



  //===========================================================================
  //---- MIRROR FOR A SCROLL BOX
  //---- «≈– ¿ÀŒ ƒÀﬂ Œ Õ¿ œ–Œ –”“ »
  TScrollBars = ( ssNone, ssHorz, ssVert, ssBoth );

  TKOLScrollBox = class( TKOLControl )
  private
    FScrollBars: TScrollBars;
    FControlContainer: Boolean;
    FEdgeStyle: TEdgeStyle;
    FpopupMenu: TKOLPopupMenu;
    fNotAvailable: Boolean;
    procedure SetScrollBars(const Value: TScrollBars);
    procedure SetControlContainer(const Value: Boolean);
    procedure SetEdgeStyle(const Value: TEdgeStyle);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
  protected
    procedure SetupFirst(SL: TStringList; const AName, AParent, Prefix: String); override;
    function SetupParams( const AName, AParent: String ): String; override;
    function IsControlContainer: Boolean; virtual;
    function TypeName: String; override;
  public
  published
    constructor Create( AOwner: TComponent ); override;
    property ScrollBars: TScrollBars read FScrollBars write SetScrollBars;
    property ControlContainer: Boolean read FControlContainer write SetControlContainer;
    property EdgeStyle: TEdgeStyle read FEdgeStyle write SetEdgeStyle;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property Border;
    property Caption: Boolean read fNotAvailable;
    property Enabled;
    property MarginBottom;
    property MarginLeft;
    property MarginRight;
    property MarginTop;
    property Transparent;
    property OnScroll;
    property Brush;
  end;

procedure Register;


implementation

uses mckCtrlDraw;

procedure Register;
begin
  RegisterComponents( 'KOL', [ TKOLButton, TKOLBitBtn, TKOLLabel, TKOLLabelEffect, TKOLPanel,
    TKOLSplitter, TKOLGradientPanel, TKOLGroupBox, TKOLCheckBox, TKOLRadioBox,
    TKOLEditBox, TKOLMemo, TKOLRichEdit, TKOLListBox, TKOLComboBox, TKOLPaintBox,
    TKOLProgressBar, TKOLListView, TKOLTreeView, TKOLToolbar, TKOLTabControl,
    TKOLDateTimePicker, TKOLImageShow, TKOLScrollBox, TKOLMDIClient ] );
  RegisterPropertyEditor( TypeInfo( string ), TKOLToolbar, 'buttons',
                          TKOLToolbarButtonsEditor );
  RegisterPropertyEditor( TypeInfo( TOnToolbarButtonClick ), TKOLToolbarButton, 'onClick',
                          TKOLToolButtonOnClickPropEditor );
  RegisterPropertyEditor( TypeInfo( string ), TKOLListView, 'Columns',
                          TKOLLVColumnsPropEditor );
  RegisterComponentEditor( TKOLToolbar, TKOLToolbarEditor );
  RegisterComponentEditor( TKOLTabControl, TKOLTabControlEditor );
  RegisterComponentEditor( TKOLListView, TKOLLVColumnsEditor );
end;

{function CanMapBitmap( Bitmap: TBitmap ): Boolean;
var KOLBmp: KOL.PBitmap;
begin
  KOLBmp := NewDIBBitmap( Bitmap.Width, Bitmap.Height, KOL.pf32bit );
  TRY
    BitBlt( KOLBmp.Canvas.Handle, 0, 0, Bitmap.Width, Bitmap.Height,
            Bitmap.Canvas.Handle, 0, 0, SRCCOPY );
    KOLBmp.HandleType := KOL.bmDIB;
    KOLBmp.PixelFormat := KOL.pf32bit;
    case CountSystemColorsUsedInBitmap( KOLBmp ) of
    KOL.pf1bit, KOL.pf4bit, KOL.pf8bit: Result := TRUE;
    else                    Result := FALSE
    end;
    //Rpt( '!!!! CanMapBitmap: ' + Int2Str( Integer( Result ) ) );
  FINALLY
    KOLBmp.Free;
  END;
end;}
(*var BI: TBitmapInfo;
    C: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'CanMapBitmap', 0
  @@e_signature:
  end;
  Result := TRUE;
  if Bitmap = nil then Exit;
  if (Bitmap.Width = 0) or (Bitmap.Height = 0) then Exit;
  {$IFNDEF _D2}
  if (Bitmap.HandleType = bmDIB) and not (Bitmap.PixelFormat in [pfCustom, pfDevice]) then
  begin
    //ShowMessage( 'format=' + IntToStr( Integer( Bitmap.PixelFormat ) ) );
    Result := Bitmap.PixelFormat in [ pf1bit, pf4bit, pf8bit ];
  end
    else
  {$ENDIF _D2}
  begin
    if Bitmap.Handle = 0 then
      Result := FALSE
    else
    begin
      if GetObject( Bitmap.Handle, Sizeof( BI ), @BI ) = 0 then
        Result := FALSE
      else
      begin
        C := BI.bmiHeader.biBitCount;
        Result := (C=1) or (C=4) or (C=8);
      end;
    end;
  end;
end;*)

{ TKOLButton }

function TKOLButton.CanChangeColor: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.CanChangeColor', 0
  @@e_signature:
  end;
  Result := FALSE;
end;

function TKOLButton.CanNotChangeFontColor: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.CanNotChangeFontColor', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLButton.ClientMargins: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.ClientMargins', 0
  @@e_signature:
  end;
  Result := Rect( 2, 2, 2, 2 );
end;

constructor TKOLButton.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.Create', 0
  @@e_signature:
  end;
  inherited;
  FImage := TPicture.Create;
  FDefIgnoreDefault := TRUE;
  FIgnoreDefault := TRUE;
  fAutoSzX := 14;
  Height := 22; DefaultHeight := 22;
  TextAlign := taCenter;
  VerticalAlign := vaCenter;
  TabStop := True;
end;

procedure TKOLButton.CreateKOLControl(Recreating: boolean);
begin
  FKOLCtrl:=NewButton(KOLParentCtrl, '');
end;

function TKOLButton.DefaultParentColor: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.DefaultParentColor', 0
  @@e_signature:
  end;
  Result := FALSE;
end;

destructor TKOLButton.Destroy;
begin
  FImage.Free;
  inherited;
end;

procedure TKOLButton.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.FirstCreate', 0
  @@e_signature:
  end;
  Caption := Name;
  inherited;
end;

function TKOLButton.GenerateTransparentInits: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.GenerateTransparentInits', 0
  @@e_signature:
  end;
  Result := inherited GenerateTransparentInits;
  if assigned( Fimage ) {and Assigned( Fimage.Graphic ) and
     not Fimage.Graphic.Empty} then
  begin
    if Assigned( image.Icon ) and not image.icon.Empty
    {$IFDEF _D2orD3}
       and (image.icon.Width > 0) and (image.icon.Height > 0)
    {$ENDIF}
    then
    begin
      Result := Result + '.SetButtonIcon( LoadIcon( hInstance, ''' +
             ImageResourceName + ''' ) )';
      Rpt( 'Button has icon, generating code SetButtonIcon:'#13#10 + Result );
    end
      else
    if Assigned( image.Bitmap ) and not image.Bitmap.Empty then
    begin
      Rpt( 'Button has bitmap, generating code SetBittonBitmap' );
      Result := Result + '.SetButtonBitmap( LoadBitmap( hInstance, ''' +
             ImageResourceName + ''' ) )';
    end;
  end;
  if LikeSpeedButton then
    Result := Result + '.LikeSpeedButton';
end;

function TKOLButton.ImageResourceName: String;
begin
  Result := 'Z' + UpperCase( ParentForm.Name ) + '_' + UpperCase( Name ) + '_IMAGE';
end;

function TKOLButton.NoDrawFrame: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLButton.Paint;
begin
  if not (Assigned(FKOLCtrl) and (PaintType in [ptWYSIWIG, ptWYSIWIGFrames])) then begin
    PrepareCanvasFontForWYSIWIGPaint( Canvas );
    DrawButton( Self, Canvas );
  end;
  inherited;
end;

procedure TKOLButton.Setimage(const Value: TPicture);
begin
  TRY
    if Assigned( Value ) and Assigned( Value.Graphic ) then
    begin
      Fimage.Assign( Value.Graphic );
      Rpt( '$$$$$$$$$$$$ Success' );
    end
    else
    begin
      FImage.Assign( nil );
      Rpt( '$$$$$$$$$$$$ nil' );
    end;
  EXCEPT
    Rpt( '$$$$$$$$$$$$ Exception assigning image (' + Name + ')' );
  END;
  Change;
end;

procedure TKOLButton.SetLikeSpeedButton(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.SetLikeSpeedButton', 0
  @@e_signature:
  end;
  FLikeSpeedButton := Value;
  Change;
end;

procedure TKOLButton.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLButton.SetupColor(SL: TStrings; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.SetupColor', 0
  @@e_signature:
  end;
  // there are no setup color for TKOLButton:
  if ClassName = 'TKOLButton' then Exit;
  inherited;
end;

procedure TKOLButton.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var Updated: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );

  if assigned( Fimage ) {and Assigned( Fimage.Graphic ) and
     not Fimage.Graphic.Empty} then
  begin
    if Assigned( image.Icon ) and not image.icon.Empty then
    begin
      Rpt( 'Button has icon, generate resource' );
      SL.Add( '{$R ' + ImageResourceName + '.res}' );
      GenerateIconResource( image.Icon, ImageResourceName, ImageResourceName,
                           Updated );
    end
      else
    if Assigned( image.Bitmap ) and not image.Bitmap.Empty then
    begin
      Rpt( 'Button has bitmap, generate resource' );
      GenerateBitmapResource( image.Bitmap, ImageResourceName, ImageResourceName,
                           Updated );
    end;
  end;
end;

procedure TKOLButton.SetupFont(SL: TStrings; const AName: String);
var BFont: TKOLFont;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.SetupFont', 0
  @@e_signature:
  end;
  if ParentKOLControl = ParentKOLForm then
    BFont := ParentKOLForm.Font
  else
    BFont := (ParentKOLControl as TKOLCustomControl).Font;
  BFont.Color := Font.Color;
  if not Font.Equal2( BFont ) then
    Font.GenerateCode( SL, AName, BFont );
end;

function TKOLButton.SetupParams(const AName, AParent: String): String;
var
  C: string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.SetupParams', 0
  @@e_signature:
  end;
  if action = nil then
    C := StringConstant('Caption',Caption)
  else
    C := '''''';
  Result := AParent + ', ' + C;
end;

const TextAligns: array[ TTextAlign ] of String = ( 'taLeft', 'taRight', 'taCenter' );
      VertAligns: array[ TVerticalAlign ] of String = ( 'vaTop', 'vaCenter', 'vaBottom' );

procedure TKOLButton.SetupTextAlign(SL: TStrings; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.SetupTextAlign', 0
  @@e_signature:
  end;
  if TextAlign <> taCenter then
    SL.Add( '    ' + AName + '.TextAlign := ' + TextAligns[ TextAlign ] + ';' );
  if VerticalAlign <> vaCenter then
    SL.Add( '    ' + AName + '.VerticalAlign := ' + VertAligns[ VerticalAlign ] + ';' );
end;

function TKOLButton.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLButton.WYSIWIGPaintImplemented: Boolean;
begin
  Result := TRUE;  
end;

{ TKOLLabel }

function TKOLLabel.AdjustVerticalAlign(
  Value: TVerticalAlign): TVerticalAlign;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.AdjustVerticalAlign', 0
  @@e_signature:
  end;
  if Value = vaBottom then
    Result := vaCenter
  else
    Result := Value;
end;

procedure TKOLLabel.CallInheritedPaint;
begin
  inherited Paint;
end;

constructor TKOLLabel.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.Create', 0
  @@e_signature:
  end;
  inherited;
  fAutoSzX := 1;
  fAutoSzY := 1;
  Height := 22; DefaultHeight := 22;
  fTabOrder := -1;
end;

procedure TKOLLabel.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.FirstCreate', 0
  @@e_signature:
  end;
  Caption := Name;
  inherited;
end;

function TKOLLabel.GetTaborder: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.GetTaborder', 0
  @@e_signature:
  end;
  Result := -1;
end;

function TKOLLabel.Get_VertAlign: TVerticalAlign;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.Get_VertAlign', 0
  @@e_signature:
  end;
  Result := inherited VerticalAlign;
end;

procedure TKOLLabel.Paint;
var
  R:TRect;
  Flag:DWord;
  TMPBrushStyle: TBrushStyle;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.Paint', 0
  @@e_signature:
  end;

  R.Left:=0;
  R.Top:=0;
  R.Right:=Width;
  R.Bottom:=Height;
  Flag:=0;
  case TextAlign of
    taRight: Flag:=Flag or DT_RIGHT;
    taLeft: Flag:=Flag or DT_LEFT;
    taCenter: Flag:=Flag or DT_CENTER;
  end;

  case VerticalAlign of
    vaTop: Flag:=Flag or DT_TOP;
    vaBottom: Flag:=Flag or DT_BOTTOM;
    vaCenter: Flag:=Flag or DT_VCENTER or DT_SINGLELINE;
  end;

  if (WordWrap) and (not AutoSize or (Align in [ caClient, caTop, caBottom ])) then
      Flag:=Flag or DT_WORDBREAK;

  PrepareCanvasFontForWYSIWIGPaint( Canvas );

  TMPBrushStyle := Canvas.Brush.Style;
  Canvas.Brush.Style := bsClear;
  DrawText(Canvas.Handle,PChar(Caption),Length(Caption),R,Flag);
  Canvas.Brush.Style :=TMPBrushStyle;

  inherited;

end;

procedure TKOLLabel.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLLabel.SetShowAccelChar(const Value: Boolean);
begin
  FShowAccelChar := Value;
  Change;
end;

procedure TKOLLabel.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );
  if ShowAccelChar then
    SL.Add( Prefix + AName + '.Style := ' + AName + '.Style and not SS_NOPREFIX;' );
end;

function TKOLLabel.SetupParams(const AName, AParent: String): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.SetupParams', 0
  @@e_signature:
  end;
  Result := AParent + ', ' + StringConstant('Caption', Caption);
end;

procedure TKOLLabel.SetupTextAlign(SL: TStrings; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.SetupTextAlign', 0
  @@e_signature:
  end;
  if TextAlign <> taLeft then
    SL.Add( '    ' + AName + '.TextAlign := ' + TextAligns[ TextAlign ] + ';' );
  if VerticalAlign <> vaTop then
    SL.Add( '    ' + AName + '.VerticalAlign := ' + VertAligns[ VerticalAlign ] + ';' );
end;

procedure TKOLLabel.SetwordWrap(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.SetwordWrap', 0
  @@e_signature:
  end;
  FwordWrap := Value;
  Change;
end;

procedure TKOLLabel.Set_VertAlign(const Value: TVerticalAlign);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.Set_VertAlign', 0
  @@e_signature:
  end;
  inherited VerticalAlign := AdjustVerticalAlign( Value );
end;

function TKOLLabel.TypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.TypeName', 0
  @@e_signature:
  end;
  Result := inherited TypeName;
  if wordWrap then
    Result := 'WordWrapLabel';
end;

function TKOLLabel.WYSIWIGPaintImplemented: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.WYSIWIGPaintImplemented', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

{ TKOLPanel }

function TKOLPanel.ClientMargins: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.ClientMargins', 0
  @@e_signature:
  end;
  case edgeStyle of
  esLowered: Result := Rect( 1, 1, 1, 1 );
  esRaised:  Result := Rect( 3, 3, 3, 3 );
  esNone:    Result := Rect( 0, 0, 0, 0 );
  end;
end;

constructor TKOLPanel.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.Create', 0
  @@e_signature:
  end;
  inherited;
  Width := 100; DefaultWidth := Width;
  Height := 100; DefaultHeight := 100;
  ControlStyle := ControlStyle + [ csAcceptsControls ];
end;

destructor TKOLPanel.Destroy;
var P: TKOLTabControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.Destroy', 0
  @@e_signature:
  end;
  if Parent <> nil then
  if Parent is TKOLTabControl then
  begin
    P:=Parent as TKOLTabControl;
    if (P.FCurPage=self) and (P.CurIndex>0) then P.CurIndex:=pred(P.CurIndex);
    P.Invalidate;
  end;
  inherited;
end;

function TKOLPanel.Get_VA: TVerticalAlign;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.Get_VA', 0
  @@e_signature:
  end;
  Result := inherited VerticalAlign;
end;

function TKOLPanel.NoDrawFrame: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.NoDrawFrame', 0
  @@e_signature:
  end;
  Result := (EdgeStyle <> esNone) or
         (Parent <> nil) and (Parent is TKOLTabControl);
end;

procedure TKOLPanel.Paint;
var
  R:TRect;
  Flag,EdgeFlag:DWord;
  Delta:Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.Paint', 0
  @@e_signature:
  end;

  R.Left:=0;
  R.Top:=0;
  R.Right:=Width;
  R.Bottom:=Height;

  case edgeStyle of
    esRaised:
    begin
      EdgeFlag:=EDGE_RAISED;
      Delta:=3;
    end;

    esLowered:
    begin
      EdgeFlag:=BDR_SUNKENOUTER;
      Delta:=1;
    end;

    //esNone:
    else
    begin
      EdgeFlag:=0;
      Delta:=0;
    end;
  end; //case

  if Delta <> 0 then
  begin
    DrawEdge(Canvas.Handle,R,EdgeFlag,BF_RECT or BF_MIDDLE );
    R.Left:=Delta;
    R.Top:=Delta;
    R.Right:=Width-Delta;
    R.Bottom:=Height-Delta;
    Canvas.Brush.Color := Color;
    Canvas.FillRect( R );
  end;

  Flag:=0;
  case TextAlign of
    taRight: Flag:=Flag or DT_RIGHT;
    taLeft: Flag:=Flag or DT_LEFT;
    taCenter: Flag:=Flag or DT_CENTER;
  end; //case

  case VerticalAlign of
    vaTop: Flag:=Flag or DT_TOP or DT_SINGLELINE;
    vaBottom: Flag:=Flag or DT_BOTTOM or DT_SINGLELINE;
    vaCenter: Flag:=Flag or DT_VCENTER or DT_SINGLELINE;
  end; //case

  Flag:=Flag+DT_WORDBREAK;

  if not( (Parent <> nil) and (Parent is TKOLTabControl) ) then
  begin
    PrepareCanvasFontForWYSIWIGPaint( Canvas );
    DrawText(Canvas.Handle,PChar(Caption),Length(Caption),R,Flag);
  end;

  inherited;
end;

function TKOLPanel.RefName: String;
var J: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.RefName', 0
  @@e_signature:
  end;
  Result := inherited RefName;
  if Parent is TKOLTabControl then
  begin
    for J := 0 to (Parent as TKOLTabControl).Count - 1 do
      if (Parent as TKOLTabControl).Pages[ J ] = Self then
      begin
        Result := (Parent as TKOLTabControl).RefName + '.Pages[ ' + IntToStr( J ) + ' ]';
        break;
      end;
  end;
end;

procedure TKOLPanel.SetCaption(const Value: String);
begin
  inherited;
  if (Parent <> nil) and (Parent is TKOLTabControl) then
    Parent.Invalidate;
end;

procedure TKOLPanel.SetEdgeStyle(const Value: TEdgeStyle);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.SetEdgeStyle', 0
  @@e_signature:
  end;
  if FEdgeStyle = Value then Exit;
  FEdgeStyle := Value;
  Change;
  ReAlign( FALSE );
  Invalidate;
end;

procedure TKOLPanel.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLPanel.SetShowAccelChar(const Value: Boolean);
begin
  FShowAccelChar := Value;
  Change;
end;

procedure TKOLPanel.SetupConstruct(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.SetupConstruct', 0
  @@e_signature:
  end;
  if Parent <> nil then
  if Parent is TKOLTabControl then
    Exit; // this is not a panel, but a tab page on tab control.
  inherited;
end;

procedure TKOLPanel.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if Parent <> nil then
  if Parent is TKOLTabControl then
    Exit; // this is not a panel, but a tab page on tab control.
  if Caption <> '' then
    SL.Add( Prefix + AName + '.Caption := ' + StringConstant('Caption', Caption) + ';' );
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );
  if ShowAccelChar then
    SL.Add( Prefix + AName + '.Style := ' + AName + '.Style and not SS_NOPREFIX;' );
end;

function TKOLPanel.SetupParams(const AName, AParent: String): String;
const EdgeStyles: array[ TEdgeStyle ] of String = ( 'esRaised', 'esLowered', 'esNone' );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.SetupParams', 0
  @@e_signature:
  end;
  Result := AParent + ', ' + EdgeStyles[ EdgeStyle ];
end;

procedure TKOLPanel.SetupTextAlign(SL: TStrings; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.SetupTextAlign', 0
  @@e_signature:
  end;
  if TextAlign <> taLeft then
    SL.Add( '    ' + AName + '.TextAlign := ' + TextAligns[ TextAlign ] + ';' );
  if VerticalAlign <> vaTop then
    SL.Add( '    ' + AName + '.VerticalAlign := ' + VertAligns[ VerticalAlign ] + ';' );
end;

procedure TKOLPanel.Set_VA(const Value: TVerticalAlign);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.Set_VA', 0
  @@e_signature:
  end;
  if Value = vaBottom then
    inherited VerticalAlign := vaCenter
  else
    inherited VerticalAlign := Value;
end;

function TKOLPanel.WYSIWIGPaintImplemented: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.WYSIWIGPaintImplemented', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

{ TKOLBitBtn }

procedure TKOLBitBtn.AssignEvents(SL: TStringList; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.AssignEvents', 0
  @@e_signature:
  end;
  inherited;
  DoAssignEvents( SL, AName, [ 'OnTestMouseOver' ], [ @OnTestMouseOver ] );
end;

procedure TKOLBitBtn.AutoSizeNow;
var TmpBmp: graphics.TBitmap;
    W, H, I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.AutoSizeNow', 0
  @@e_signature:
  end;
  if fAutoSizingNow then Exit;
  fAutoSizingNow := TRUE;
  TmpBmp := graphics.TBitmap.Create;
  try
    TmpBmp.Width := 10;
    TmpBmp.Height := 10;
    //Rpt( 'TmpBmp.Width=' + IntToStr( TmpBmp.Width ) + ' TmpBmp.Height=' + IntToStr( TmpBmp.Height ) );
    TmpBmp.Canvas.Font.Name := Font.FontName;
    TmpBmp.Canvas.Font.Style := TFontStyles(Font.FontStyle);
    if Font.FontHeight > 0 then
      TmpBmp.Canvas.Font.Height := Font.FontHeight
    else
    if Font.FontHeight < 0 then
      TmpBmp.Canvas.Font.Size := - Font.FontHeight
    else
      TmpBmp.Canvas.Font.Size := 0;
    W := TmpBmp.Canvas.TextWidth( Caption );
    if fsItalic in TFontStyles( Font.FontStyle ) then
      Inc( W, TmpBmp.Canvas.TextWidth( ' ' ) );
    H := TmpBmp.Canvas.TextHeight( 'Ap^_' );
    //Rpt( 'W=' + IntToStr( W ) + ' H=' + IntToStr( H ) );
    if Align in [ caNone, caLeft, caRight ] then
    begin
      if (glyphBitmap.Width > 0) and (glyphBitmap.Height > 0) then
      begin
        I := glyphBitmap.Width;
        if glyphCount > 1 then
          I := I div glyphCount;
        if glyphLayout in [ glyphLeft, glyphRight ] then
          W := W + I
        else
          if W < I then
            W := I;
      end;
      if not (bboNoBorder in options) then
        Inc( W, 4 );
      Width := W + fAutoSzX;
    end;
    if Align in [ caNone, caTop, caBottom ] then
    begin
      if (glyphBitmap.Width > 0) and (glyphBitmap.Height > 0) then
      begin
        I := glyphBitmap.Height;
        if glyphLayout in [ glyphTop, glyphBottom ] then
          H := H + I + fAutoSzY
        else
          H := I;
      end;
      if not (bboNoBorder in options) then
        Inc( H, 4 );
      Height := H; // + fAutoSzY;
    end;
  finally
    TmpBmp.Free;
    fAutoSizingNow := FALSE;
  end;
end;

function TKOLBitBtn.ClientMargins: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.ClientMargins', 0
  @@e_signature:
  end;
  Result := Rect( 3, 3, 3, 3 );
end;

constructor TKOLBitBtn.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.Create', 0
  @@e_signature:
  end;
  inherited;
  FDefIgnoreDefault := TRUE;
  FIgnoreDefault := TRUE;
  fAutoSzX := 8;
  fAutoSzY := 8;
  FGlyphBitmap := TBitmap.Create;
  Height := 22; DefaultHeight := 22;
  DefaultWidth := Width;
  TextAlign := taCenter;
  VerticalAlign := vaCenter;
  TabStop := True;
  fTextShiftX := 1;
  fTextShiftY := 1;
end;

procedure TKOLBitBtn.CreateKOLControl(Recreating: boolean);
begin
  FKOLCtrl:=NewBitBtn(KOLParentCtrl, '', [], glyphLeft, 0, 0);
end;

destructor TKOLBitBtn.Destroy;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.Destroy', 0
  @@e_signature:
  end;
  FGlyphBitmap.Free;
  if ImageList <> nil then
    ImageList.NotifyLinkedComponent( Self, noRemoved );
  inherited;
end;

procedure TKOLBitBtn.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.FirstCreate', 0
  @@e_signature:
  end;
  Caption := Name;
  inherited;
end;

function TKOLBitBtn.GenerateTransparentInits: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.GenerateTransparentInits', 0
  @@e_signature:
  end;
  if autoAdjustSize then
  begin
    DefaultWidth := Width;
    DefaultHeight := Height;
  end;
  Result := inherited GenerateTransparentInits;
  if LikeSpeedButton then
    Result := Result + '.LikeSpeedButton';
end;

function TKOLBitBtn.NoDrawFrame: Boolean;
begin
  Result:=HasBorder;
end;

procedure TKOLBitBtn.NotifyLinkedComponent(Sender: TObject;
  Operation: TNotifyOperation);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.NotifyLinkedComponent', 0
  @@e_signature:
  end;
  inherited;
  if Operation = noRemoved then
    ImageList := nil;
end;

procedure TKOLBitBtn.RecalcSize;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.RecalcSize', 0
  @@e_signature:
  end;
  if (ImageList <> nil) or
     (GlyphBitmap.Width <> 0) and (GlyphBitmap.Height <> 0) then
  begin
    DefaultWidth := 0;
    DefaultHeight := 0;
  end
     else
  begin
    DefaultWidth := 64;
    DefaultHeight := 22;
  end;
end;

procedure TKOLBitBtn.SetautoAdjustSize(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetautoAdjustSize', 0
  @@e_signature:
  end;
  FautoAdjustSize := Value;
  Change;
end;

procedure TKOLBitBtn.SetBitBtnDrawMnemonic(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetBitBtnDrawMnemonic', 0
  @@e_signature:
  end;
  FBitBtnDrawMnemonic := Value;
  Change;
end;

procedure TKOLBitBtn.SetFlat(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetFlat', 0
  @@e_signature:
  end;
  FFlat := Value;
  Change;
end;

procedure TKOLBitBtn.SetGlyphBitmap(const Value: TBitmap);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetGlyphBitmap', 0
  @@e_signature:
  end;
  if (Value <> nil) and (not Value.Empty) then
  begin
    FGlyphBitmap.Assign( Value );
    FOptions := FOptions - [bboImageList];
    FImageList := nil;
  end
    else
  begin
    {FGlyphBitmap.Width := 0;
    FGlyphBitmap.Height := 0;}
    FGlyphBitmap.Free;
    FGlyphBitmap := TBitmap.Create;
  end;
  FGlyphCount := 0;
  if FGlyphBitmap.Height > 0 then
    FGlyphCount := FGlyphBitmap.Width div FGlyphBitmap.Height;
  RecalcSize;
  if (DefaultWidth <> 0) and (DefaultHeight <> 0) then
  begin
    Width := DefaultWidth;
    Height := DefaultHeight;
  end;
  Change;
end;

procedure TKOLBitBtn.SetGlyphCount(Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetGlyphCount', 0
  @@e_signature:
  end;
  if Value < 0 then
    Value := 0;
  if Value > 5 then
    Value := 5;
  if Value = FGlyphCount then Exit;
  FGlyphCount := Value;
  Change;
end;

procedure TKOLBitBtn.SetGlyphLayout(const Value: TGlyphLayout);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetGlyphLayout', 0
  @@e_signature:
  end;
  FGlyphLayout := Value;
  if AutoSize then
    AutoSizeNow;
  Change;
end;

procedure TKOLBitBtn.SetImageIndex(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetImageIndex', 0
  @@e_signature:
  end;
  FImageIndex := Value;
  Change;
end;

procedure TKOLBitBtn.SetImageList(const Value: TKOLImageList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetImageList', 0
  @@e_signature:
  end;
  if FImageList <> nil then
    FImageList.NotifyLinkedComponent( Self, noRemoved );
  FImageList := Value;
  if (Value <> nil) and (Value is TKOLImageList) then
  begin
    FGlyphBitmap.Width := 0;
    FGlyphBitmap.Height := 0;
    FOptions := FOptions + [bboImageList];
    Value.AddToNotifyList( Self );
  end
     else
    FOptions := FOptions - [bboImageList];
  Change;
end;

procedure TKOLBitBtn.SetLikeSpeedButton(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetLikeSpeedButton', 0
  @@e_signature:
  end;
  FLikeSpeedButton := Value;
  Change;
end;

procedure TKOLBitBtn.SetOnTestMouseOver(const Value: TOnTestMouseOver);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetOnTestMouseOver', 0
  @@e_signature:
  end;
  FOnTestMouseOver := Value;
  Change;
end;

procedure TKOLBitBtn.SetOptions(Value: TBitBtnOptions);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetOptions', 0
  @@e_signature:
  end;
  Value := Value - [ bboImageList ];
  if Assigned( ImageList ) then
    Value := Value + [bboImageList];
  FOptions := Value;
  Change;
end;

function BitBtnOptions( Options: TBitBtnOptions ): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'BitBtnOptions', 0
  @@e_signature:
  end;
  Result := '';
  if bboImageList in Options then
    Result := 'bboImageList, ';
  if bboNoBorder in Options then
    Result := Result + 'bboNoBorder, ';
  if bboNoCaption in Options then
    Result := Result + 'bboNoCaption, ';
  if bboFixed in Options then
    Result := Result + 'bboFixed, ';
  Result := Trim( Result );
  if Result <> '' then
    Result := Copy( Result, 1, Length( Result ) - 1 );
  Result := '[ ' + Result + ' ]';
end;

procedure TKOLBitBtn.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLBitBtn.SetRepeatInterval(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetRepeatInterval', 0
  @@e_signature:
  end;
  FRepeatInterval := Value;
  Change;
end;

procedure TKOLBitBtn.SetTextShiftX(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetTextShiftX', 0
  @@e_signature:
  end;
  FTextShiftX := Value;
  Change;
end;

procedure TKOLBitBtn.SetTextShiftY(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetTextShiftY', 0
  @@e_signature:
  end;
  FTextShiftY := Value;
  Change;
end;

procedure TKOLBitBtn.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
var RName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetupFirst', 0
  @@e_signature:
  end;
  if ImageList = nil then
  if Assigned( GlyphBitmap ) and
     (GlyphBitmap.Width <> 0) and (GlyphBitmap.Height <> 0) then
  begin
    RName := ParentKOLForm.FormName + '_' + Name;
    Rpt( 'Prepare resource ' + RName + ' (' + UpperCase( Name + '_BITMAP' ) + ')' );
    GenerateBitmapResource( GlyphBitmap, UpperCase( Name + '_BITMAP' ), RName, fUpdated );
    SL.Add( Prefix + '{$R ' + RName + '.res}' );
  end;
  inherited;
  if (Height = DefaultHeight) or autoAdjustSize then
  if imageList <> nil then
  if ImageIndex >= 0 then
    SL.Add( Prefix + AName + '.Height := ' + IntToStr( Height ) + ';' );
  if (Width = DefaultWidth) or autoAdjustSize then
  if imageList <> nil then
  if ImageIndex >= 0 then
    SL.Add( Prefix + AName + '.Width := ' + IntToStr( Width ) + ';' );
  if RepeatInterval > 0 then
    SL.Add( Prefix + AName + '.RepeatInterval := ' + IntToStr( RepeatInterval ) + ';' );
  if Flat then
    SL.Add( Prefix + AName + '.Flat := TRUE;' );
  if BitBtnDrawMnemonic then
    SL.Add( Prefix + AName + '.BitBtnDrawMnemonic := TRUE;' );
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );
  if TextShiftX <> 0 then
    SL.Add( Prefix + AName + '.TextShiftX := ' + IntToStr( TextShiftX ) + ';' );
  if TextShiftY <> 0 then
    SL.Add( Prefix + AName + '.TextShiftY := ' + IntToStr( TextShiftY ) + ';' );

end;

function TKOLBitBtn.SetupParams(const AName, AParent: String): String;
const Layouts: array[ TGlyphLayout ] of String = ( 'glyphLeft', 'glyphTop',
               'glyphRight', 'glyphBottom', 'glyphOver' );
var S, U, C: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetupParams', 0
  @@e_signature:
  end;
  S := '0';
  U := '0';
  if (GlyphBitmap <> nil) and
     (GlyphBitmap.Width <> 0) and (GlyphBitmap.Height <> 0) then
  begin
    S := 'LoadBmp( hInstance, ' + String2Pascal(UpperCase( Name + '_BITMAP' )) +
         ', Result )';
    U := IntToStr( GlyphCount );
  end
    else
  if (ImageList <> nil) then
  begin
    if ImageList.ParentFORM.Name = ParentForm.Name then
      S := 'Result.' + ImageList.Name + '.Handle'
    else S := ImageList.ParentFORM.Name +'.'+ ImageList.Name + '.Handle';
    if GlyphCount > 0 then
      U := '$' + Int2Hex( GlyphCount shl 16, 5 ) + ' + ' + IntToStr( ImageIndex )
    else
      U := IntToStr( ImageIndex );
  end;
  if action = nil then
    C := StringConstant('Caption',Caption)
  else
    C := '''''';
  Result := AParent + ', ' + C + ', ' +
            BitBtnOptions( Options ) + ', ' +
            Layouts[ GlyphLayout ] + ', ' + S + ', ' + U;
end;

procedure TKOLBitBtn.SetupTextAlign(SL: TStrings; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetupTextAlign', 0
  @@e_signature:
  end;
  if TextAlign <> taCenter then
    SL.Add( '    ' + AName + '.TextAlign := ' + TextAligns[ TextAlign ] + ';' );
  if VerticalAlign <> vaCenter then
    SL.Add( '    ' + AName + '.VerticalAlign := ' + VertAligns[ VerticalAlign ] + ';' );
end;

function TKOLBitBtn.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

{ TKOLGradientPanel }

constructor TKOLGradientPanel.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.Create', 0
  @@e_signature:
  end;
  inherited;
  Width := 40; DefaultWidth := Width;
  Height := 40; DefaultHeight := Height;
  ControlStyle := ControlStyle + [ csAcceptsControls ];
  FColor1 := clBlue;
  FColor2 := clNavy;
  //Transparent := TRUE;
  gradientLayout := glTop;
  gradientStyle := gsVertical;
end;

function TKOLGradientPanel.NoDrawFrame: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.NoDrawFrame', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

procedure TKOLGradientPanel.Paint;

  function Ceil( X: Double ): Integer;
  begin
    Result := Round( X );
  end;
const
  SQRT2 = 1.4142135623730950488016887242097;
  
var
//  R:TRect;
//  Flag:DWord;
//  Delta: Integer;
  CR:TRect;
  W,H,WH,I:Integer;
  BMP:TBitmap;
  C:TColor;
  R,G,B,R1,G1,B1:Byte;

  RC, RF, R0: TRect;
   C2: TColor;
  R2, G2, B2: Integer;
  DX1, DX2, DY1, DY2, DR, DG, DB, K: Double;
//  PaintStruct: TPaintStruct;
  Br: HBrush;
  Rgn: HRgn;
  Poly: array[ 0..3 ] of TPoint;
//  OldPaintDC: HDC;
//  RRR:TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.Paint', 0
  @@e_signature:
  end;

  PrepareCanvasFontForWYSIWIGPaint( Canvas );
  case fGradientStyle of
    gsHorizontal,gsVertical:
    begin
  CR := ClientRect;
  W := 1;
  H := CR.Bottom;
  WH := H;
  //Bmp := nil;
  if fGradientStyle = gsHorizontal then
  begin
    W := CR.Right;
    H := 1;
    WH := W;
  end;
  Bmp :=TBitmap.Create();
  Bmp.Width:=W;
  Bmp.Height:=H;
  C := Color2RGB( fColor1 );
  R := C shr 16;
  G := (C shr 8) and $FF;
  B := C and $FF;
  C := Color2RGB( fColor2 );
  R1 := C shr 16;
  G1 := (C shr 8) and $FF;
  B1 := C and $FF;
  for I := 0 to WH-1 do
  begin
    C := ((( R + (R1 - R) * I div WH ) and $FF) shl 16) or
         ((( G + (G1 - G) * I div WH ) and $FF) shl 8) or
         ( B + (B1 - B) * I div WH ) and $FF;

    if fGradientStyle = gsVertical then
      Bmp.Canvas.Pixels[0,I]:=C
    else
      Bmp.Canvas.Pixels[I,0]:=C;
  end;
  Canvas.StretchDraw(CR,BMP);
  Bmp.Free; {YS}//! Memory leak fix
  end;

  gsRectangle, gsRombic, gsElliptic:
  begin

    C := Color2RGB( fColor2 );
    R2 := C and $FF;
    G2 := (C shr 8) and $FF;
    B2 := (C shr 16) and $FF;
    C := Color2RGB( fColor1 );
    R1 := C and $FF;
    G1 := (C shr 8) and $FF;
    B1 := (C shr 16) and $FF;
    DR := (R2 - R1) / 256;
    DG := (G2 - G1) / 256;
  DB := (B2 - B1) / 256;
  {OldPaintDC :=} Canvas.handle;//fPaintDC;
//  Self_.fPaintDC := Msg.wParam;
//  if Self_.fPaintDC = 0 then
//    Self_.fPaintDC := BeginPaint( Self_.fHandle, PaintStruct );
  RC := ClientRect;
  case fGradientStyle of
  gsRombic:
    RF := MakeRect( 0, 0, RC.Right div 128, RC.Bottom div 128 );
  gsElliptic:
    RF := MakeRect( 0, 0, Ceil( RC.Right / 256 * SQRT2 ), Ceil( RC.Bottom / 256 * SQRT2 ) );
  else
    RF := MakeRect( 0, 0, RC.Right div 256, RC.Bottom div 256 );
  end;
  case fGradientStyle of
  gsRectangle, gsRombic, gsElliptic:
    begin
      case FGradientLayout of
      glCenter, glTop, glBottom:
        OffsetRect( RF, (RC.Right - RF.Right) div 2, 0 );
      glTopRight, glBottomRight, glRight:
        OffsetRect( RF, RC.Right - RF.Right div 2, 0 );
      glTopLeft, glBottomLeft, glLeft:
        OffsetRect( RF, -RF.Right div 2, 0 );
      end;
      case FGradientLayout of
      glCenter, glLeft, glRight:
        OffsetRect( RF, 0, (RC.Bottom - RF.Bottom) div 2 );
      glBottom, glBottomLeft, glBottomRight:
        OffsetRect( RF, 0, RC.Bottom - RF.Bottom div 2 );
      glTop, glTopLeft, glTopRight:
        OffsetRect( RF, 0, -RF.Bottom div 2 );
      end;
    end;
  end;
  DX1 := (-RF.Left) / 255;
  DY1 := (-RF.Top) / 255;
  DX2 := (RC.Right - RF.Right) / 255;
  DY2 := (RC.Bottom - RF.Bottom) / 255;
  case fGradientStyle of
  gsRombic, gsElliptic:
    begin
      if DX2 < -DX1 then DX2 := -DX1;
      if DY2 < -DY1 then DY2 := -DY1;
      K := 2;
      if fGradientStyle = gsElliptic then K := SQRT2;
      DX2 := DX2 * K;
      DY2 := DY2 * K;
      DX1 := -DX2;
      DY1 := -DY2;
    end;
  end;
  C2 := C;
  for I := 0 to 255 do
  begin
    if (I < 255) then
    begin
      C2 := TColor( (( Ceil( B1 + DB * (I+1) ) and $FF) shl 16) or
          (( Ceil( G1 + DG * (I+1) ) and $FF) shl 8) or
           Ceil( R1 + DR * (I+1) ) and $FF );
      if (fGradientStyle in [gsRombic,gsElliptic,gsRectangle]) and
         (C2 = C) then continue;
    end;
    Br := CreateSolidBrush( C );
    R0 := MakeRect( Ceil( RF.Left + DX1 * I ),
                    Ceil( RF.Top + DY1 * I ),
                    Ceil( RF.Right + DX2 * I ),
                    Ceil( RF.Bottom + DY2 * I ) );
    Rgn := 0;
    case fGradientStyle of
    gsRectangle:
      Rgn := CreateRectRgnIndirect( R0 );
    gsRombic:
      begin
        Poly[ 0 ].x := R0.Left;
        Poly[ 0 ].y := R0.Top + (R0.Bottom - R0.Top) div 2;
        Poly[ 1 ].x := R0.Left + (R0.Right - R0.Left) div 2;
        Poly[ 1 ].y := R0.Top;
        Poly[ 2 ].x := R0.Right;
        Poly[ 2 ].y := Poly[ 0 ].y;
        Poly[ 3 ].x := Poly[ 1 ].x;
        Poly[ 3 ].y := R0.Bottom;
        Rgn := CreatePolygonRgn( Poly[ 0 ].x, 4, ALTERNATE );
      end;
    gsElliptic:
      Rgn := CreateEllipticRgnIndirect( R0 );
    end;
    if Rgn <> 0 then
    begin
      if Rgn <> NULLREGION then
      begin
        Windows.FillRgn({ fPaintDC}Canvas.Handle, Rgn, Br );
        ExtSelectClipRgn( {fPaintDC}Canvas.Handle, Rgn, RGN_DIFF );
      end;
      DeleteObject( Rgn );
    end;
    DeleteObject( Br );
    C := C2;
  end;
//  if Self_.fPaintDC <> HDC( Msg.wParam ) then
//    EndPaint( Self_.fHandle, PaintStruct );
//  Self_.fPaintDC := OldPaintDC;

  end;

  end; //case

  inherited;

end;

procedure TKOLGradientPanel.SetColor1(const Value: TColor);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.SetColor1', 0
  @@e_signature:
  end;
  FColor1 := Value;
  Invalidate;
  Change;
end;

procedure TKOLGradientPanel.SetColor2(const Value: TColor);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.SetColor2', 0
  @@e_signature:
  end;
  FColor2 := Value;
  Invalidate;
  Change;
end;

procedure TKOLGradientPanel.SetgradientLayout(
  const Value: TGradientLayout);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.SetgradientLayout', 0
  @@e_signature:
  end;
  FgradientLayout := Value;
  Invalidate;
  Change;
end;

procedure TKOLGradientPanel.SetgradientStyle(const Value: TGradientStyle);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.SetgradientStyle', 0
  @@e_signature:
  end;
  FgradientStyle := Value;
  Invalidate;
  Change;
end;

procedure TKOLGradientPanel.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLGradientPanel.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if GradientStyle = gsHorizontal then
    SL.Add( Prefix + AName + '.GradientStyle := gsHorizontal;' );
  if HasBorder then
    SL.Add( Prefix + AName + '.HasBorder := TRUE;' );
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );
end;

function TKOLGradientPanel.SetupParams(const AName,
  AParent: String): String;
const
    GradientLayouts: array[ TGradientLayout ] of String = ( 'glTopLeft',
                      'glTop', 'glTopRight',
                      'glLeft', 'glCenter', 'glRight',
                      'glBottomLeft', 'glBottom', 'glBottomRight' );
    GradientStyles: array[ TGradientStyle ] of String = ( 'gsHorizontal',
                    'gsVertical', 'gsRectangle', 'gsElliptic', 'gsRombic' );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.SetupParams', 0
  @@e_signature:
  end;
  Result := AParent + ', ' + Color2Str( FColor1 ) + ', ' + Color2Str( FColor2 );
  if TypeName <> 'GradientPanel' then
    Result := Result + ', ' + GradientStyles[ gradientStyle ] + ', ' +
           GradientLayouts[ GradientLayout ];
end;

function TKOLGradientPanel.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLGradientPanel.TypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.TypeName', 0
  @@e_signature:
  end;
  Result := inherited TypeName;
  if not (GradientStyle in [ gsVertical, gsHorizontal ]) or (gradientLayout <> glTop) then
    Result := 'GradientPanelEx';
end;

function TKOLGradientPanel.WYSIWIGPaintImplemented: Boolean;
begin
  Result := TRUE;
end;

{ TKOLGroupBox }

function TKOLGroupBox.ClientMargins: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.ClientMargins', 0
  @@e_signature:
  end;
  Result := Rect( 0, 0, 0, 0 );
end;

constructor TKOLGroupBox.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGroupBox.Create', 0
  @@e_signature:
  end;
  inherited;
  Width := 100; DefaultWidth := Width;
  Height := 100; DefaultHeight := 100;
  ControlStyle := ControlStyle + [ csAcceptsControls ];
  DefaultMarginTop := 22;   MarginTop := 22;
  DefaultMarginLeft := 2;   MarginLeft := 2;
  DefaultMarginRight := 2;  MarginRight := 2;
  DefaultMarginBottom := 2; MarginBottom := 2;
  FHasBorder := FALSE; FDefHasBorder := FALSE;
end;

{$IFDEF _KOLCtrlWrapper_} {YS}
procedure TKOLGroupBox.CreateKOLControl(Recreating: boolean);
begin
  FKOLCtrl := NewGroupbox(KOLParentCtrl, '');
end;
{$ENDIF}

function TKOLGroupBox.DrawMargins: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGroupBox.DrawMargins', 0
  @@e_signature:
  end;
  Result := Rect( 4, 18, 4, 4 );
  if Font <> nil then
  if Font.FontHeight > 0 then
    Result.Top := Font.FontHeight;
end;

procedure TKOLGroupBox.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGroupBox.FirstCreate', 0
  @@e_signature:
  end;
  Caption := Name;
  inherited;
end;

procedure TKOLGroupBox.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGroupBox.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLGroupBox.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
const
  TextAligns: array[ TTextAlign ] of String = ( 'taLeft', 'taRight', 'taCenter' );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGroupBox.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if TextAlign <> taLeft then
    SL.Add( Prefix + AName + '.TextAlign := ' + TextAligns[ TextAlign ] + ';' );
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );
end;

function TKOLGroupBox.SetupParams(const AName, AParent: String): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGroupBox.SetupParams', 0
  @@e_signature:
  end;
  Result := AParent + ', ' + StringConstant('Caption',Caption);
end;

function TKOLGroupBox.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGroupBox.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

{ TKOLCheckBox }

constructor TKOLCheckBox.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCheckBox.Create', 0
  @@e_signature:
  end;
  inherited;
  fTabstop := TRUE;
  fAutoSzX := 20;
  Width := 72; DefaultWidth := Width;
  Height := 22; DefaultHeight := 22;
  FHasBorder := FALSE;
  FDefHasBorder := FALSE;
end;

procedure TKOLCheckBox.CreateKOLControl(Recreating: boolean);
begin
  if Auto3State then
    FKOLCtrl:=NewCheckBox3State(KOLParentCtrl, '')
  else
    FKOLCtrl:=NewCheckbox(KOLParentCtrl, '');
end;

procedure TKOLCheckBox.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCheckBox.FirstCreate', 0
  @@e_signature:
  end;
  Caption := Name;
  inherited;
end;

function TKOLCheckBox.NoDrawFrame: Boolean;
begin
  Result := HasBorder;
end;

procedure TKOLCheckBox.Paint;
begin
  if not (Assigned(FKOLCtrl) and (PaintType in [ptWYSIWIG, ptWYSIWIGFrames])) then begin
    PrepareCanvasFontForWYSIWIGPaint( Canvas );
    DrawCheckBox( Self, Canvas );
  end;  
  inherited;
end;

procedure TKOLCheckBox.SetAuto3State(const Value: Boolean);
begin
  FAuto3State := Value;
  Change;
end;

procedure TKOLCheckBox.SetChecked(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCheckBox.SetChecked', 0
  @@e_signature:
  end;
  if FChecked = Value then exit;
  if action = nil then
    FChecked := Value
  else
    FChecked := action.Checked;
  Change;
  if Assigned(FKOLCtrl) then
    FKOLCtrl.Checked:=FChecked;
  Invalidate;
end;

procedure TKOLCheckBox.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCheckBox.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLCheckBox.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCheckBox.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if Checked and (action = nil) then
    SL.Add( Prefix + AName + '.Checked := TRUE;' );
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );
end;

function TKOLCheckBox.SetupParams(const AName, AParent: String): String;
var
  C: string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCheckBox.SetupParams', 0
  @@e_signature:
  end;
  if action = nil then
    C := StringConstant('Caption',Caption)
  else
    C := '''''';
  Result := AParent + ', ' + C;
end;

function TKOLCheckBox.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCheckBox.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLCheckBox.TypeName: String;
begin
  if Auto3State then Result := 'CheckBox3State'
                else Result := inherited TypeName;
end;

function TKOLCheckBox.WYSIWIGPaintImplemented: Boolean;
begin
  Result := TRUE;
end;

{ TKOLRadioBox }

constructor TKOLRadioBox.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRadioBox.Create', 0
  @@e_signature:
  end;
  inherited;
  fTabstop := TRUE;
  fAutoSzX := 20;
  Width := 72; DefaultWidth := Width;
  Height := 22; DefaultHeight := 22;
  FHasBorder := FALSE;
  FDefHasBorder := FALSE;
end;

procedure TKOLRadioBox.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRadioBox.FirstCreate', 0
  @@e_signature:
  end;
  Caption := Name;
  inherited;
end;

function TKOLRadioBox.NoDrawFrame: Boolean;
begin
  Result := HasBorder;
end;

procedure TKOLRadioBox.Paint;
begin
  PrepareCanvasFontForWYSIWIGPaint( Canvas );
  DrawRadioBox( Self, Canvas );
  inherited;
end;

procedure TKOLRadioBox.SetChecked(const Value: Boolean);
var I: Integer;
    C: TComponent;
    K: TKOLCustomControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRadioBox.SetChecked', 0
  @@e_signature:
  end;
  if FChecked = Value then exit;
  if action = nil then
    FChecked := Value
  else
    FChecked := action.Checked;
  Change;
  if FChecked then
  if Parent <> nil then
  begin
    for I := 0 to ParentForm.ComponentCount - 1 do
    begin
      C := ParentForm.Components[ I ];
      if C <> Self then
      if C is TKOLCustomControl then
      begin
        K := C as TKOLCustomControl;
        if K.Parent = Parent then
        if K is TKOLRadioBox then
          (K as TKOLRadioBox).Checked := FALSE;
      end;
    end;
  end;
end;

procedure TKOLRadioBox.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRadioBox.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLRadioBox.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRadioBox.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if Checked and (action = nil) then
    SL.add( Prefix + AName + '.SetRadioChecked;' );
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );
end;

function TKOLRadioBox.SetupParams(const AName, AParent: String): String;
var
  C: string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRadioBox.SetupParams', 0
  @@e_signature:
  end;
  if action = nil then
    C := StringConstant('Caption',Caption)
  else
    C := '''''';
  Result := AParent + ', ' + C;
end;

function TKOLRadioBox.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRadioBox.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLRadioBox.WYSIWIGPaintImplemented: Boolean;
begin
  Result := TRUE;
end;

{ TKOLEditBox }

function TKOLEditBox.BestEventName: String;
begin
  Result := 'OnChange';
end;

constructor TKOLEditBox.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.Create', 0
  @@e_signature:
  end;
  inherited;
  fNoAutoSizeX := TRUE;
  fAutoSzY := 6;
  Width := 100; DefaultWidth := Width;
  Height := 22; DefaultHeight := 22;
  TabStop := TRUE;
  FResetTabStopByStyle := TRUE;
end;

function TKOLEditBox.DefaultColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.DefaultColor', 0
  @@e_signature:
  end;
  Result := clWindow;
end;

procedure TKOLEditBox.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.FirstCreate', 0
  @@e_signature:
  end;
  Text := Name;
  inherited;
end;

function TKOLEditBox.GetCaption: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.GetCaption', 0
  @@e_signature:
  end;
  Result := inherited Caption;
end;

function TKOLEditBox.GetText: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.GetText', 0
  @@e_signature:
  end;
  Result := Caption;
end;

function TKOLEditBox.NoDrawFrame: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.NoDrawFrame', 0
  @@e_signature:
  end;
  Result := HasBorder;
end;

procedure TKOLEditBox.Paint;
var
  R:TRect;
  Flag:DWord;
  Delta: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.Paint', 0
  @@e_signature:
  end;

  PrepareCanvasFontForWYSIWIGPaint( Canvas );

  R.Left:=0;
  R.Top:=0;
  R.Right:=Width;
  R.Bottom:=Height;

  if HasBorder then
  begin
    if Ctl3D then
    begin
      DrawEdge(Canvas.Handle,R,EDGE_SUNKEN,BF_RECT);
      Delta := 3;
    end
      else
    begin
      Canvas.Brush.Color := clWindowText;
      Canvas.FrameRect(R);
      Delta := 2;
    end;

    R.Left:=Delta;
    R.Top:=Delta;
    R.Right:=Width-Delta;
    R.Bottom:=Height-Delta;
  end;

  Flag:=0;
  case TextAlign of
    taRight: Flag:=Flag or DT_RIGHT;
    taLeft: Flag:=Flag or DT_LEFT;
    taCenter: Flag:=Flag or DT_CENTER;
  end;

  Canvas.Brush.Color := Color;
  DrawText(Canvas.Handle,PChar(Caption),Length(Caption),R,Flag);

  inherited;

end;

procedure TKOLEditBox.SetEdTransparent(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.SetEdTransparent', 0
  @@e_signature:
  end;
  FEdTransparent := Value;
  Change;
end;

procedure TKOLEditBox.SetOptions(const Value: TKOLEditOptions);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.SetOptions', 0
  @@e_signature:
  end;
  FOptions := Value;
  Change;
end;

procedure TKOLEditBox.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLEditBox.SetText(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.SetText', 0
  @@e_signature:
  end;
  SetCaption( Value );
end;

procedure TKOLEditBox.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
const
  Aligns: array[ TTextAlign ] of String = ( 'taLeft', 'taRight', 'taCenter' );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if Text <> '' then
    AddLongTextField( SL, Prefix + AName + '.Text := ', Text, ';' );
  if TextAlign <> taLeft then
    SL.Add( Prefix + AName + '.TextAlign := ' + Aligns[ TextAlign ] + ';' );
  if Transparent then
    SL.Add( Prefix + AName + '.Ed_Transparent := TRUE;' );
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );
end;

function TKOLEditBox.SetupParams(const AName, AParent: String): String;
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.SetupParams', 0
  @@e_signature:
  end;
  S := '';
  if eoLowercase in Options then
    S := S + ', eoLowercase';
  if eoNoHideSel in Options then
    S := S + ', eoNoHideSel';
  if eoOemConvert in Options then
    S := S + ', eoOemConvert';
  if eoPassword in Options then
    S := S + ', eoPassword';
  if eoReadonly in Options then
    S := S + ', eoReadonly';
  if eoUpperCase in Options then
    S := S + ', eoUpperCase';
  if eoWantTab in Options then
    S := S + ', eoWantTab';
  if eoNumber in Options then
    S := S + ', eoNumber';
  if S <> '' then
  if S[ 1 ] = ',' then
    S := Copy( S, 3, MaxInt );
  Result := AParent + ', [ ' + S + ' ]';
end;

procedure TKOLEditBox.SetupTextAlign(SL: TStrings; const AName: String);
begin
  inherited;
  if TextAlign <> taLeft then
    SL.Add('    ' + AName + '.TextAlign := ' + TextAligns[TextAlign] + ';');
end;

function TKOLEditBox.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

procedure TKOLEditBox.WantTabs( Want: Boolean );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.WantTabs', 0
  @@e_signature:
  end;
  if Want then
    Options := Options + [ eoWantTab ]
  else
    Options := Options - [ eoWantTab ];
end;

function TKOLEditBox.WYSIWIGPaintImplemented: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.WYSIWIGPaintImplemented', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

{ TKOLMemo }

function TKOLMemo.BestEventName: String;
begin
  Result := 'OnChange';
end;

constructor TKOLMemo.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.Create', 0
  @@e_signature:
  end;
  FLines := TStringList.Create;
  inherited;
  FDefIgnoreDefault := TRUE;
  FIgnoreDefault := TRUE;
  Width := 200; DefaultWidth := Width;
  Height := 222; DefaultHeight := Height;
  TabStop := TRUE;
end;

procedure TKOLMemo.CreateKOLControl(Recreating: boolean);
var
  opts: kol.TEditOptions;
begin
  opts:=[eoMultiline];
  if eo_Lowercase in FOptions then
    Include(opts, kol.eoLowercase);
  if eo_NoHScroll in FOptions then
    Include(opts, kol.eoNoHScroll);
  if eo_NoVScroll in FOptions then
    Include(opts, kol.eoNoVScroll);
  if eo_UpperCase in FOptions then
    Include(opts, kol.eoUpperCase);
  FKOLCtrl:=NewEditbox(KOLParentCtrl, opts);
  if Recreating then 
    FKOLCtrl.TextAlign:=kol.TTextAlign(TextAlign);
end;

function TKOLMemo.DefaultColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.DefaultColor', 0
  @@e_signature:
  end;
  Result := clWindow;
end;

destructor TKOLMemo.Destroy;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.Destroy', 0
  @@e_signature:
  end;
  FLines.Free;
  inherited;
end;

procedure TKOLMemo.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.FirstCreate', 0
  @@e_signature:
  end;
  FLines.Text := Name;
  if Assigned(FKOLCtrl) then
    FKOLCtrl.Text:=FLines.Text;
  inherited;
end;

function TKOLMemo.GetCaption: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.GetCaption', 0
  @@e_signature:
  end;
  Result := inherited Caption;
end;

function TKOLMemo.GetText: TStrings;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.GetText', 0
  @@e_signature:
  end;
  Result := FLines;
end;

procedure TKOLMemo.KOLControlRecreated;
begin
  inherited;
  FKOLCtrl.Text:=FLines.Text;
end;

procedure TKOLMemo.Loaded;
begin
  inherited;
  if Assigned(FKOLCtrl) then
    FKOLCtrl.Text:=FLines.Text;
end;

function TKOLMemo.NoDrawFrame: Boolean;
begin
  Result := HasBorder;
end;

procedure TKOLMemo.SetEdTransparent(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.SetEdTransparent', 0
  @@e_signature:
  end;
  FEdTransparent := Value;
  Change;
end;

procedure TKOLMemo.SetOptions(const Value: TKOLMemoOptions);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.SetOptions', 0
  @@e_signature:
  end;
  FOptions := Value;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
  Change;
end;

procedure TKOLMemo.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLMemo.SetText(const Value: TStrings);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.SetText', 0
  @@e_signature:
  end;
  FLines.Text := Value.Text;
  if Assigned(FKOLCtrl) then
    FKOLCtrl.Text:=Value.Text;
  Change;
end;

procedure TKOLMemo.SetTextAlign(const Value: TTextAlign);
begin
  inherited;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
end;

procedure TKOLMemo.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if TextAlign <> taLeft then
    SL.Add( Prefix + AName + '.TextAlign := ' + TextAligns[ TextAlign ] + ';' );
  if FLines.Text <> '' then
    AddLongTextField( SL, Prefix + AName + '.Text := ', FLines.Text, ';' );
  if Transparent then
    SL.Add( Prefix + AName + '.Ed_Transparent := TRUE;' );
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );
end;

function TKOLMemo.SetupParams(const AName, AParent: String): String;
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.SetupParams', 0
  @@e_signature:
  end;
  S := 'eoMultiline';
  if eo_NoHScroll in Options then
    S := S + ', eoNoHScroll';
  if eo_NoVScroll in Options then
    S := S + ', eoNoVScroll';
  if eo_Lowercase in Options then
    S := S + ', eoLowercase';
  if eo_NoHideSel in Options then
    S := S + ', eoNoHideSel';
  if eo_OemConvert in Options then
    S := S + ', eoOemConvert';
  if eo_Password in Options then
    S := S + ', eoPassword';
  if eo_Readonly in Options then
    S := S + ', eoReadonly';
  if eo_UpperCase in Options then
    S := S + ', eoUpperCase';
  if eo_WantReturn in Options then
    S := S + ', eoWantReturn';
  if eo_WantTab in Options then
    S := S + ', eoWantTab';
  if S <> '' then
  if S[ 1 ] = ',' then
    S := Copy( S, 3, MaxInt );
  Result := AParent + ', [ ' + S + ' ]';
end;

procedure TKOLMemo.SetupTextAlign(SL: TStrings; const AName: String);
begin
  inherited;
  if TextAlign <> taLeft then
    SL.Add('    ' + AName + '.TextAlign := ' + TextAligns[TextAlign] + ';');
end;

function TKOLMemo.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLMemo.TypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.TypeName', 0
  @@e_signature:
  end;
  Result := 'EditBox';
end;

procedure TKOLMemo.WantTabs( Want: Boolean );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.WantTabs', 0
  @@e_signature:
  end;
  if Want then
    Options := Options + [ eo_WantTab ]
  else
    Options := Options - [ eo_WantTab ];
end;

{ TKOLListBox }

constructor TKOLListBox.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.Create', 0
  @@e_signature:
  end;
  FItems := TStringList.Create;
  inherited;
  Width := 164; DefaultWidth := Width;
  Height := 200; DefaultHeight := Height;
  TabStop := TRUE;
  Options := [ loNoIntegralHeight ];
end;

procedure TKOLListBox.CreateKOLControl(Recreating: boolean);
var
  opts: kol.TListOptions;
begin
  opts:=[];
  if loNoHideScroll in FOptions then
    Include(opts, kol.loNoHideScroll);
  if loMultiColumn in FOptions then
    Include(opts, kol.loMultiColumn);
  FKOLCtrl:=NewListbox(KOLParentCtrl, opts + [kol.loNoIntegralHeight]);
end;

function TKOLListBox.DefaultColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.DefaultColor', 0
  @@e_signature:
  end;
  Result := clWindow;
end;

destructor TKOLListBox.Destroy;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.Destroy', 0
  @@e_signature:
  end;
  inherited;
  FItems.Free;
end;

procedure TKOLListBox.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.FirstCreate', 0
  @@e_signature:
  end;
  //FItems.Text := Name;
  FCurIndex := 0;
  inherited;
end;

function TKOLListBox.GetCaption: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.GetCaption', 0
  @@e_signature:
  end;
  Result := inherited Caption;
end;

procedure TKOLListBox.KOLControlRecreated;
begin
  inherited;
  UpdateItems;
end;

procedure TKOLListBox.Loaded;
begin
  inherited;
  UpdateItems;
end;

function TKOLListBox.NoDrawFrame: Boolean;
begin
  Result:=HasBorder;
end;

procedure TKOLListBox.SetCount(Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.SetCount', 0
  @@e_signature:
  end;
  if Value < 0 then
    Value := 0;
  FCount := Value;
  Change;
end;

procedure TKOLListBox.SetCurIndex(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.SetCurIndex', 0
  @@e_signature:
  end;
  FCurIndex := Value;
  Change;
end;

procedure TKOLListBox.SetItems(const Value: TStrings);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.SetItems', 0
  @@e_signature:
  end;
  FItems.Text := Value.Text;
  UpdateItems;
  Change;
end;

procedure TKOLListBox.SetOptions(const Value: TKOLListboxOptions);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.SetOptions', 0
  @@e_signature:
  end;
  FOptions := Value;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
  Change;
end;

procedure TKOLListBox.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLListBox.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if FItems.Text <> '' then
  begin
    for I := 0 to FItems.Count - 1 do
    SL.Add( Prefix + AName + '.Items[ ' + Int2Str( I ) + ' ] := ' +
            StringConstant( 'Item' + IntToStr( I ), FItems[ I ] ) + ';' );
  end;
  if FCurIndex >= 0 then
    SL.Add( Prefix + AName + '.CurIndex := ' + Int2Str( FCurIndex ) + ';' );
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );
end;

procedure TKOLListBox.SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.SetupLast', 0
  @@e_signature:
  end;
  inherited;
  if loNoData in Options then
  if Count > 0 then
    SL.Add( Prefix + AName + '.Count := ' + IntToStr( Count ) + ';' );
end;

function TKOLListBox.SetupParams(const AName, AParent: String): String;
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.SetupParams', 0
  @@e_signature:
  end;
  if loNoHideScroll in Options then
    S := S + 'loNoHideScroll';
  if loNoExtendSel in Options then
    S := S + ', loNoExtendSel';
  if loMultiColumn in Options then
    S := S + ', loMultiColumn';
  if loMultiSelect in Options then
    S := S + ', loMultiSelect';
  if loNoIntegralHeight in Options then
    S := S + ', loNoIntegralHeight';
  if loNoSel in Options then
    S := S + ', loNoSel';
  if loSort in Options then
    S := S + ', loSort';
  if loTabstops in Options then
    S := S + ', loTabstops';
  if loNoStrings in Options then
    S := S + ', loNoStrings';
  if loNoData in Options then
    S := S + ', loNoData';
  if loOwnerDrawFixed in Options then
    S := S + ', loOwnerDrawFixed';
  if loOwnerDrawVariable in Options then
    S := S + ', loOwnerDrawVariable';
  if S <> '' then
  if S[ 1 ] = ',' then
    S := Copy( S, 3, MaxInt );
  Result := AParent + ', [ ' + S + ' ]';
end;

function TKOLListBox.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

procedure TKOLListBox.UpdateItems;
var
  i: integer;
begin
  if Assigned(FKOLCtrl) then begin
    FKOLCtrl.BeginUpdate;
    try
      FKOLCtrl.Clear;
      if [loOwnerDrawFixed, loOwnerDrawVariable] * FOptions = [] then
        for i:=0 to FItems.Count - 1 do
          FKOLCtrl.Items[i]:=FItems[i];
    finally
      FKOLCtrl.EndUpdate;
    end;
  end;
end;

{ TKOLComboBox }

function TKOLComboBox.AutoHeight(Canvas: TCanvas): Integer;
begin
  if coSimple in Options then
    Result := Height
  else
    Result := inherited AutoHeight( Canvas );
end;

function TKOLComboBox.AutoSizeRunTime: Boolean;
begin
  Result := not( coSimple in Options );
end;

constructor TKOLComboBox.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.Create', 0
  @@e_signature:
  end;
  FItems := TStringList.Create;
  inherited;
  fNoAutoSizeX := TRUE;
  fAutoSzY := 6;
  Width := 100; DefaultWidth := Width;
  Height := 22; DefaultHeight := Height;
  TabStop := TRUE;
  Options := [ coNoIntegralHeight ];
end;

function TKOLComboBox.DefaultColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.DefaultColor', 0
  @@e_signature:
  end;
  Result := clWhite; // !!! in Windows, default color for combobox really is clWhite
end;

function TKOLComboBox.DefaultInitialColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.DefaultInitialColor', 0
  @@e_signature:
  end;
  Result := clWindow;
end;

destructor TKOLComboBox.Destroy;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.Destroy', 0
  @@e_signature:
  end;
  inherited;
  FItems.Free;
end;

procedure TKOLComboBox.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.FirstCreate', 0
  @@e_signature:
  end;
  FItems.Text := Name;
  FCurIndex := 0;
  inherited;
end;

function TKOLComboBox.NoDrawFrame: Boolean;
begin
  Result := HasBorder;
end;

procedure TKOLComboBox.Paint;
begin
  if not (Assigned(FKOLCtrl) and (PaintType in [ptWYSIWIG, ptWYSIWIGFrames])) then begin
    PrepareCanvasFontForWYSIWIGPaint( Canvas );
    DrawCombobox( Self, Canvas );
  end;  
  inherited;
end;

procedure TKOLComboBox.SetCurIndex(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.SetCurIndex', 0
  @@e_signature:
  end;
  FCurIndex := Value;
  Change;
end;

procedure TKOLComboBox.SetDroppedWidth(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.SetDroppedWidth', 0
  @@e_signature:
  end;
  FDroppedWidth := Value;
  Change;
end;

procedure TKOLComboBox.SetItems(const Value: TStrings);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.SetItems', 0
  @@e_signature:
  end;
  FItems.Text := Value.Text;
  Change;
end;

procedure TKOLComboBox.SetOptions(const Value: TKOLComboOptions);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.SetOptions', 0
  @@e_signature:
  end;
  FOptions := Value;
  Change;
  if AutoSize then
    AutoSizeNow;
  Invalidate;
end;

procedure TKOLComboBox.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLComboBox.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if FItems.Text <> '' then
  begin
    for I := 0 to FItems.Count - 1 do
    SL.Add( Prefix + AName + '.Items[ ' + Int2Str( I ) + ' ] := ' +
            StringConstant( 'Item' + IntToStr( I ), FItems[ I ] ) + ';' );
  end;
  if FCurIndex >= 0 then
    SL.Add( Prefix + AName + '.CurIndex := ' + Int2Str( FCurIndex ) + ';' );
  if (FDroppedWidth <> Width) and (FDroppedWidth <> 0) then
    SL.Add( Prefix + AName + '.DroppedWidth := ' + Int2Str( FDroppedWidth ) + ';' );
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );
end;

function TKOLComboBox.SetupParams(const AName, AParent: String): String;
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.SetupParams', 0
  @@e_signature:
  end;
  if coReadOnly in Options then
    S := S + 'coReadOnly';
  if coNoHScroll in Options then
    S := S + ', coNoHScroll';
  if coAlwaysVScroll in Options then
    S := S + ', coAlwaysVScroll';
  if coLowerCase in Options then
    S := S + ', coLowerCase';
  if coNoIntegralHeight in Options then
    S := S + ', coNoIntegralHeight';
  if coOemConvert in Options then
    S := S + ', coOemConvert';
  if coSort in Options then
    S := S + ', coSort';
  if coUpperCase in Options then
    S := S + ', coUpperCase';
  if coOwnerDrawFixed in Options then
    S := S + ', coOwnerDrawFixed';
  if coOwnerDrawVariable in Options then
    S := S + ', coOwnerDrawVariable';
  if coSimple in Options then
    S := S + ', coSimple';
  if S <> '' then
  if S[ 1 ] = ',' then
    S := Copy( S, 3, MaxInt );
  Result := AParent + ', [ ' + S + ' ]';
end;

function TKOLComboBox.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLComboBox.WYSIWIGPaintImplemented: Boolean;
begin
  Result := TRUE;
end;

{ TKOLSplitter }

procedure TKOLSplitter.AssignEvents(SL: TStringList; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLSplitter.AssignEvents', 0
  @@e_signature:
  end;
  inherited;
  DoAssignEvents( SL, AName, [ 'OnSplit' ], [ @OnSplit ] );
end;

function TKOLSplitter.BestEventName: String;
begin
  Result := 'OnSplit';
end;

constructor TKOLSplitter.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLSplitter.Create', 0
  @@e_signature:
  end;
  inherited;
  Align := caLeft;
  Width := 4; DefaultWidth := Width;
  DefaultHeight := 4;
  MinSizePrev := 0;
  MinSizeNext := 0;
  //FBeveled := TRUE;
  EdgeStyle := esLowered;
end;

procedure TKOLSplitter.CreateKOLControl(Recreating: boolean);
var
  es: TEdgeStyle;
begin
  if Recreating then
    es:=FEdgeStyle
  else
    es:=esLowered;
  FKOLCtrl:=NewSplitterEx(KOLParentCtrl, 0, 0, es);
end;

function TKOLSplitter.IsCursorDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLSplitter.IsCursorDefault', 0
  @@e_signature:
  end;
  case Align of
  caLeft, caRight:  Result := (Trim(Cursor_)='') or (Trim(Cursor_)='IDC_SIZEWE');
  caTop, caBottom:  Result := (Trim(Cursor_)='') or (Trim(Cursor_)='IDC_SIZENS');
  else Result := inherited IsCursorDefault;
  end;
end;

function TKOLSplitter.NoDrawFrame: Boolean;
begin
  Result:=FEdgeStyle <> esNone;
end;

procedure TKOLSplitter.SetEdgeStyle(const Value: TEdgeStyle);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLSplitter.SetEdgeStyle', 0
  @@e_signature:
  end;
  FEdgeStyle := Value;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
  Change;
end;

procedure TKOLSplitter.SetMinSizeNext(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLSplitter.SetMinSizeNext', 0
  @@e_signature:
  end;
  FMinSizeNext := Value;
  Change;
end;

procedure TKOLSplitter.SetMinSizePrev(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLSplitter.SetMinSizePrev', 0
  @@e_signature:
  end;
  FMinSizePrev := Value;
  Change;
end;

procedure TKOLSplitter.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLSplitter.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
end;

function TKOLSplitter.SetupParams(const AName, AParent: String): String;
const Styles: array[ TEdgeStyle ] of String = ( 'esRaised', 'esLowered', 'esNone' );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLSplitter.SetupParams', 0
  @@e_signature:
  end;
  Result := AParent + ', ' + Int2Str( MinSizePrev ) + ', ' + Int2Str( MinSizeNext );
  if EdgeStyle <> esLowered then
    Result := Result + ', ' + Styles[ EdgeStyle ];
end;

function TKOLSplitter.TypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLSplitter.TypeName', 0
  @@e_signature:
  end;
  Result := inherited TypeName;
  if EdgeStyle <> esLowered then
    Result := 'SplitterEx';
end;

{ TKOLPaintBox }

function TKOLPaintBox.BestEventName: String;
begin
  Result := 'OnPaint';
end;

constructor TKOLPaintBox.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPaintBox.Create', 0
  @@e_signature:
  end;
  inherited;
  Width := 40; DefaultWidth := Width;
  Height := 40; DefaultHeight := Height;
  ControlStyle := ControlStyle + [ csAcceptsControls ];
end;

procedure TKOLPaintBox.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPaintBox.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLPaintBox.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPaintBox.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );
end;

function TKOLPaintBox.SetupParams(const AName, AParent: String): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPaintBox.SetupParams', 0
  @@e_signature:
  end;
  Result := AParent;
end;

{ TKOLListView }

procedure TKOLListView.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName, [ 'OnLVDelete', 'OnLVCustomDraw'
                  {$IFNDEF _D2}, 'OnLVDataW' {$ENDIF _D2} ],
                             [ @ OnLVDelete, @ OnLVCustomDraw
                  {$IFNDEF _D2}, @ OnLVDataW {$ENDIF _D2} ] );
end;

constructor TKOLListView.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.Create', 0
  @@e_signature:
  end;
  inherited;
  FCols := TList.Create;
  FGenerateColIdxConst := TRUE;
  Width := 200; DefaultWidth := Width;
  Height := 150; DefaultHeight := Height;
  FCurIndex := 0;
  FLVBkColor := clWindow;
  FLVTextBkColor := clWindow;
  TabStop := TRUE;
end;

function TKOLListView.DefaultColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.DefaultColor', 0
  @@e_signature:
  end;
  Result := clWindow;
end;

procedure TKOLListView.DefineProperties(Filer: TFiler);
var I: Integer;
    Col: TKOLListViewColumn;
begin
  inherited;
  Filer.DefineProperty( 'ColCount', LoadColCount, SaveColCount, TRUE );
  for I := 0 to FColCount-1 do
  begin
    if FCols.Count <= I then
      Col := TKOLListViewColumn.Create( Self )
    else
      Col := FCols[ I ];
    Col.DefProps( 'Column' + IntToStr( I ), Filer );
  end;
end;

destructor TKOLListView.Destroy;
var I: Integer;
begin
  ActiveDesign.Free;
  if ImageListNormal <> nil then
    ImageListNormal.NotifyLinkedComponent( Self, noRemoved );
  if ImageListSmall <> nil then
    ImageListSmall.NotifyLinkedComponent( Self, noRemoved );
  if ImageListState <> nil then
   ImageListState.NotifyLinkedComponent( Self, noRemoved );
  for I := FCols.Count-1 downto 0 do
    TObject( FCols[ I ] ).Free;
  FCols.Free;
  inherited;
end;

procedure TKOLListView.DoGenerateConstants(SL: TStringList);
var I: Integer;
    Col: TKOLListViewColumn;
begin
  if not generateConstants then Exit;
  for I := 0 to Cols.Count-1 do
  begin
    Col := Cols[ I ];
    if Col.Name <> '' then
      SL.Add( 'const ' + Col.Name + ' = ' + IntToStr( I ) + ';' );
  end;
end;

function TKOLListView.GetCaption: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.GetCaption', 0
  @@e_signature:
  end;
  Result := inherited Caption;
end;

function TKOLListView.GetColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.GetColor', 0
  @@e_signature:
  end;
  Result := inherited Color;
end;

function TKOLListView.GetColumns: String;
//var I: Integer;
begin
  Result := '';
  if Cols.Count > 0 then
    Result := IntToStr( Cols.Count ) + ' columns';
  {for I := 0 to Cols.Count-1 do
  begin
    if Result <> '' then Result := Result + ';';
    Result := Result + Trim( TKOLListViewColumn( Cols[ I ] ).Caption );
  end;}
end;

function TKOLListView.HasOrderedColumns: Boolean;
var I: Integer;
    C: TKOLListViewColumn;
begin
  Result := FALSE;
  for I := 0 to Cols.Count-1 do
  begin
    C := Cols[ I ];
    if C.FLVColOrder >= 0 then
    begin
      Result := TRUE;
      break;
    end;
  end;
end;

{YS}
procedure TKOLListView.Invalidate;
begin
  {$IFDEF _KOLCtrlWrapper_}
  if Assigned(FKOLCtrl) then
    FKOLCtrl.InvalidateEx
  else
  {$ENDIF}
    inherited;
end;

procedure TKOLListView.Loaded;
begin
  inherited;
  UpdateColumns;
end;
{YS}
procedure TKOLListView.LoadColCount(Reader: TReader);
begin
  FColCount := Reader.ReadInteger;
end;

procedure TKOLListView.NotifyLinkedComponent(Sender: TObject;
  Operation: TNotifyOperation);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.NotifyLinkedComponent', 0
  @@e_signature:
  end;
  inherited;
  if Operation = noRemoved then
  begin
    if Sender = FImageListNormal then
      ImageListNormal := nil;
    if Sender = FImageListSmall then
      ImageListSmall := nil;
    if Sender = FImageListState then
      ImageListState := nil;
  end;
end;

procedure TKOLListView.SaveColCount(Writer: TWriter);
begin
  FColCount := FCols.Count;
  Writer.WriteInteger( FColCount );
end;

procedure TKOLListView.SetColor(const Value: TColor);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetColor', 0
  @@e_signature:
  end;
  inherited Color := Value;
end;

procedure TKOLListView.SetColumns(const Value: String);
begin
  //
end;

procedure TKOLListView.SetGenerateColIdxConst(const Value: Boolean);
begin
  FGenerateColIdxConst := Value;
  Change;
end;

procedure TKOLListView.SetImageListNormal(const Value: TKOLImageList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetImageListNormal', 0
  @@e_signature:
  end;
  if FImageListNormal <> nil then
    FImageListNormal.NotifyLinkedComponent( Self, noRemoved );
  FImageListNormal := Value;
  if Value <> nil then
    Value.AddToNotifyList( Self );
  Change;
end;

procedure TKOLListView.SetImageListSmall(const Value: TKOLImageList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetImageListSmall', 0
  @@e_signature:
  end;
  if FImageListSmall <> nil then
    FImageListSmall.NotifyLinkedComponent( Self, noRemoved );
  FImageListSmall := Value;
  if Value <> nil then
    Value.AddToNotifyList( Self );
  Change;
end;

procedure TKOLListView.SetImageListState(const Value: TKOLImageList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetImageListState', 0
  @@e_signature:
  end;
  if FImageListState <> nil then
    FImageListState.NotifyLinkedComponent( Self, noRemoved );
  FImageListState := Value;
  if Value <> nil then
    Value.AddToNotifyList( Self );
  Change;
end;

procedure TKOLListView.SetLVCount(Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetLVCount', 0
  @@e_signature:
  end;
  if Value < 0 then
    Value := 0;
  FLVCount := Value;
  Change;
end;

procedure TKOLListView.SetLVTextBkColor(const Value: TColor);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetLVTextBkColor', 0
  @@e_signature:
  end;
  FLVTextBkColor := Value;
  Change;
end;

procedure TKOLListView.SetOnLVCustomDraw(const Value: TOnLVCustomDraw);
begin
  FOnLVCustomDraw := Value;
  Change;
end;

procedure TKOLListView.SetOnLVDelete(const Value: TOnLVDelete);
begin
  FOnLVDelete := Value;
  Change;
end;

procedure TKOLListView.SetOptions(const Value: TKOLListViewOptions);
var
  Opts: kol.TListViewOptions;
  OldOpts: TKOLListViewOptions;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetOptions', 0
  @@e_signature:
  end;
  OldOpts := FOptions;
  FOptions := Value;
  if Assigned(FKOLCtrl) then begin
    if ([lvoNoScroll, lvoNoSortHeader] * OldOpts <> []) or ([lvoNoScroll, lvoNoSortHeader] * Value <> []) then
      RecreateWnd
    else begin
      Opts:=[];
      if lvoGridLines in FOptions then
        Include(Opts, kol.lvoGridLines);
      if lvoFlatsb in FOptions then
        Include(Opts, kol.lvoFlatsb);
      FKOLCtrl.LVOptions:=Opts;
      UpdateAllowSelfPaint;
    end;
  end;
  Change;
end;

procedure TKOLListView.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLListView.SetStyle(const Value: TKOLListViewStyle);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetStyle', 0
  @@e_signature:
  end;
  FStyle := Value;
{YS}
  {$IFDEF _KOLCtrlWrapper_}
  if Assigned( FKOLCtrl ) then
    FKOLCtrl.LVStyle:=TListViewStyle(Value);
  UpdateAllowSelfPaint;
  {$ENDIF}
{YS}
  Change;
end;

procedure TKOLListView.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var I: Integer;
    Col: TKOLListViewColumn;
    W: Integer;
    WifUnicode: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if Unicode then WifUnicode := 'W' else WifUnicode := '';
  if (Font.Color <> clWindowText) and (Font.Color <> clNone) and (Font.Color <> clDefault) then
    SL.Add( Prefix + AName + '.LVTextColor := ' + Color2Str( Font.Color ) + ';' );
  if (LVTextBkColor <> clDefault) and (LVTextBkColor <> clNone) and (LVTextBkColor <> clWindow) then
    SL.Add( Prefix + AName + '.LVTextBkColor := ' + Color2Str( LVTextBkColor ) + ';' );
  if (LVBkColor <> clDefault) and (LVBkColor <> clNone) and (LVBkColor <> clWindow) then
    SL.Add( Prefix + AName + '.LVBkColor := ' + Color2Str( LVBkColor ) + ';' );
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );
  for I := 0 to Cols.Count-1 do
  begin
    Col := Cols[ I ];
    W := Col.Width;
    if Col.FLVColRightImg then
      W := -W;
    SL.Add( Prefix + AName + '.LVColAdd' + WifUnicode + '( ' +
            StringConstant( 'Column' + IntToStr( I ) + 'Caption',
            Col.Caption ) + ', ' +
            TextAligns[ Col.TextAlign ] + ', ' + IntToStr( W ) + ');' );
    if Col.LVColImage >= 0 then
      SL.Add( Prefix + AName + '.LVColImage[ ' + IntToStr( I ) + ' ] := ' +
              IntToStr( Col.LVColImage ) + ';' );
  end;
  for I := 0 to Cols.Count-1 do
  begin
    Col := Cols[ I ];
    if Col.LVColOrder >= 0 then
    if Col.LVColOrder <> I then
      SL.Add( Prefix + AName + '.LVColOrder[ ' + IntToStr( I ) + ' ] := ' +
              IntToStr( Col.LVColOrder ) + ';' );
  end;
end;

procedure TKOLListView.SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetupLast', 0
  @@e_signature:
  end;
  inherited;
  if LVCount > 0 then
    SL.Add( Prefix + AName + '.LVCount := ' + IntToStr( LVCount ) + ';' );
end;

function TKOLListView.SetupParams(const AName, AParent: String): String;
var S, O, ILSm, ILNr, ILSt: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetupParams', 0
  @@e_signature:
  end;
  case Style of
  lvsIcon:      S := 'lvsIcon';
  lvsSmallIcon: S := 'lvsSmallIcon';
  lvsList:      S := 'lvsList';
  lvsDetail:    S := 'lvsDetail';
  lvsDetailNoHeader: S := 'lvsDetailNoHeader';
  end;
  O := '';
  if lvoIconLeft in Options then
    O := 'lvoIconLeft';
  if lvoAutoArrange in Options then
    O := O + ', lvoAutoArrange';
  if lvoButton in Options then
    O := O + ', lvoButton';
  if lvoEditLabel in Options then
    O := O + ', lvoEditLabel';
  if lvoNoLabelWrap in Options then
    O := O + ', lvoNoLabelWrap';
  if lvoNoScroll in Options then
    O := O + ', lvoNoScroll';
  if lvoNoSortHeader in Options then
    O := O + ', lvoNoSortHeader';
  if lvoHideSel in Options then
    O := O + ', lvoHideSel';
  if lvoMultiselect in Options then
    O := O + ', lvoMultiselect';
  if lvoSortAscending in Options then
    O := O + ', lvoSortAscending';
  if lvoSortDescending in Options then
    O := O + ', lvoSortDescending';
  if lvoGridLines in Options then
    O := O + ', lvoGridLines';
  if lvoSubItemImages in Options then
    O := O + ', lvoSubItemImages';
  if lvoCheckBoxes in Options then
    O := O + ', lvoCheckBoxes';
  if lvoTrackSelect in Options then
    O := O + ', lvoTrackSelect';
  if lvoHeaderDragDrop in Options then
    O := O + ', lvoHeaderDragDrop';
  if lvoRowSelect in Options then
    O := O + ', lvoRowSelect';
  if lvoOneClickActivate in Options then
    O := O + ', lvoOneClickActivate';
  if lvoTwoClickActivate in Options then
    O := O + ', lvoTwoClickActivate';
  if lvoFlatsb in Options then
    O := O + ', lvoFlatsb';
  if lvoRegional in Options then
    O :=  O + ', lvoRegional';
  if lvoInfoTip in Options then
    O := O + ', lvoInfoTip';
  if lvoUnderlineHot in Options then
    O := O + ', lvoUnderlineHot';
  if lvoMultiWorkares in Options then
    O := O + ', lvoMultiWorkares';
  if lvoOwnerData in Options then
    O := O + ', lvoOwnerData';
  if lvoOwnerDrawFixed in Options then
    O := O + ', lvoOwnerDrawFixed';
  if O <> '' then
  if O[ 1 ] = ',' then
    O := Copy( O, 3, MaxInt );
  ILSm := 'nil';
  if ImageListSmall <> nil then
  begin
    if ImageListSmall.ParentFORM.Name = ParentForm.Name then
      ILSm := 'Result.' + ImageListSmall.Name
    else
      ILSm := ImageListSmall.ParentFORM.Name +'.'+ ImageListSmall.Name;
  end;
  ILNr := 'nil';
  if ImageListNormal <> nil then
  begin
    if ImageListNormal.ParentFORM.Name = ParentForm.Name then
      ILNr := 'Result.' + ImageListNormal.Name
    else
      ILNr := ImageListNormal.ParentFORM.Name +'.'+ ImageListNormal.Name;
  end;
  ILSt := 'nil';
  if ImageListState <> nil then
  begin
    if ImageListState.ParentFORM.Name = ParentForm.Name then
      ILSt := 'Result.' + ImageListState.Name
    else
      ILSt := ImageListState.ParentFORM.Name +'.'+ ImageListState.Name;
  end;
  Result := AParent + ', ' + S + ', [ ' + O + ' ], ' + ILSm + ', ' + ILNr
            + ', ' + ILSt;
end;

function TKOLListView.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;
{YS}
procedure TKOLListView.UpdateColumns;
{$IFDEF _KOLCtrlWrapper_}
var
  i: integer;
  col: TKOLListViewColumn;
{$ENDIF}
begin
  {$IFDEF _KOLCtrlWrapper_}
  if Assigned(FKOLCtrl) then
  with FKOLCtrl^ do begin
    BeginUpdate;
    try
      while LVColCount > 0 do
        LVColDelete(0);
      for i:=0 to FCols.Count - 1 do begin
        col:=FCols[i];
        LVColAdd(col.Caption, KOL.TTextAlign(col.TextAlign), col.Width)
      end;
    finally
      EndUpdate;
    end;
    UpdateAllowSelfPaint;
  end;
  {$ENDIF}
end;

procedure TKOLListView.CreateKOLControl(Recreating: boolean);
var
  Opts: kol.TListViewOptions;
begin
  Opts:=[];
  if lvoGridLines in FOptions then
    Include(Opts, kol.lvoGridLines);
  if lvoFlatsb in FOptions then
    Include(Opts, kol.lvoFlatsb);
  if lvoNoScroll in FOptions then
    Include(Opts, kol.lvoNoScroll);
  if lvoNoSortHeader in FOptions then
    Include(Opts, kol.lvoNoSortHeader);
  FKOLCtrl := NewListView(KOLParentCtrl, TListViewStyle(Style), opts, nil, nil, nil);
end;

function TKOLListView.NoDrawFrame: Boolean;
begin
  Result:=HasBorder;
end;
{YS}

procedure TKOLListView.KOLControlRecreated;
begin
  inherited;
  UpdateColumns;
end;

function TKOLListView.GetDefaultControlFont: HFONT;
begin
  Result:=GetStockObject(DEFAULT_GUI_FONT);
end;

{$IFNDEF _D2}
procedure TKOLListView.SetOnLVDataW(const Value: TOnLVDataW);
begin
  FOnLVDataW := Value;
  Change;
end;
{$ENDIF _D2}

procedure TKOLListView.SetLVItemHeight(const Value: Integer);
begin
  if fLVItemHeight <> Value then begin
    fLVItemHeight := Value;
    Change;
  end;
end;

function TKOLListView.GenerateTransparentInits: String;
begin
  if fLVItemHeight > 0 then Result := '.SetLVItemHeight('+IntToStr(fLVItemHeight)+')'
  else Result := '';
  Result := Result + inherited GenerateTransparentInits();
end;

{ TKOLTreeView }

constructor TKOLTreeView.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.Create', 0
  @@e_signature:
  end;
  inherited;
  Width := 150; DefaultWidth := Width;
  Height := 200; DefaultHeight := Height;
  FCurIndex := 0;
  TabStop := TRUE;
end;

procedure TKOLTreeView.CreateKOLControl(Recreating: boolean);
begin
  FKOLCtrl:=NewTreeView(KOLParentCtrl, [], nil, nil);
end;

function TKOLTreeView.DefaultColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.DefaultColor', 0
  @@e_signature:
  end;
  Result := clWindow;
end;

destructor TKOLTreeView.Destroy;
begin
  if ImageListNormal <> nil then
    ImageListNormal.NotifyLinkedComponent( Self, noRemoved );
  if ImageListState <> nil then
    ImageListState.NotifyLinkedComponent( Self, noRemoved );
  inherited;
end;

function TKOLTreeView.NoDrawFrame: Boolean;
begin
  Result:=HasBorder;
end;

procedure TKOLTreeView.NotifyLinkedComponent(Sender: TObject;
  Operation: TNotifyOperation);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.NotifyLinkedComponent', 0
  @@e_signature:
  end;
  inherited;
  if Operation = noRemoved then
  begin
    if Sender = FImageListNormal then
      ImageListNormal := nil;
    if Sender = FImageListState then
      ImageListState := nil;
  end;
end;

procedure TKOLTreeView.SetCurIndex(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.SetCurIndex', 0
  @@e_signature:
  end;
  FCurIndex := Value;
  Change;
end;

procedure TKOLTreeView.SetImageListNormal(const Value: TKOLImageList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.SetImageListNormal', 0
  @@e_signature:
  end;
  if FImageListNormal <> nil then
    FImageListNormal.NotifyLinkedComponent( Self, noRemoved );
  FImageListNormal := Value;
  if Value <> nil then
    Value.AddToNotifyList( Self );
  Change;
end;

procedure TKOLTreeView.SetImageListState(const Value: TKOLImageList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.SetImageListState', 0
  @@e_signature:
  end;
  if FImageListState <> nil then
    FImageListState.NotifyLinkedComponent( Self, noRemoved );
  FImageListState := Value;
  if Value <> nil then
    Value.AddToNotifyList( Self );
  Change;
end;

procedure TKOLTreeView.SetOptions(const Value: TKOLTreeViewOptions);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.SetOptions', 0
  @@e_signature:
  end;
  FOptions := Value;
  Change;
end;

procedure TKOLTreeView.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLTreeView.SetTVIndent(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.SetTVIndent', 0
  @@e_signature:
  end;
  FTVIndent := Value;
  Change;
end;

procedure TKOLTreeView.SetTVRightClickSelect(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView,SetTVRightClickSelect', 0
  @@e_signature:
  end;
  FTVRightClickSelect := Value;
  Change;
end;

procedure TKOLTreeView.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if TVRightClickSelect then
    SL.Add( Prefix + AName + '.TVRightClickSelect := TRUE;' );
  if TVIndent > 0 then
    SL.Add( Prefix + AName + '.TVIndent := ' + IntToStr( TVIndent ) + ';' );
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );
end;

function TKOLTreeView.SetupParams(const AName, AParent: String): String;
var O, ILNr, ILSt: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.SetupParams', 0
  @@e_signature:
  end;
  O := '';
  if tvoNoLines in Options then
    O := 'tvoNoLines';
  if tvoLinesRoot in Options then
    O := O + ', tvoLinesRoot';
  if tvoNoButtons in Options then
    O := O + ', tvoNoButtons';
  if tvoEditLabels in Options then
    O := O + ', tvoEditLabels';
  if tvoHideSel in Options then
    O := O + ', tvoHideSel';
  if tvoDragDrop in Options then
    O := O + ', tvoDragDrop';
  if tvoNoTooltips in Options then
    O := O + ', tvoNoTooltips';
  if tvoCheckBoxes in Options then
    O := O + ', tvoCheckBoxes';
  if tvoTrackSelect in Options then
    O := O + ', tvoTrackSelect';
  if tvoSingleExpand in Options then
    O := O + ', tvoSingleExpand';
  if tvoInfoTip in Options then
    O := O + ', tvoInfoTip';
  if tvoFullRowSelect in Options then
    O := O + ', tvoFullRowSelect';
  if tvoNoScroll in Options then
    O := O + ', tvoNoScroll';
  if tvoNonEvenHeight in Options then
    O := O + ', tvoNonEvenHeight';
  if O <> '' then
  if O[ 1 ] = ',' then
    O := Copy( O, 3, MaxInt );
  ILNr := 'nil';
  if ImageListNormal <> nil then
  begin
    if ImageListNormal.ParentFORM.Name = ParentForm.Name then
      ILNr := 'Result.' + ImageListNormal.Name
    else
      ILNr := ImageListNormal.ParentFORM.Name +'.'+ ImageListNormal.Name;
  end;
  ILSt := 'nil';
  if ImageListState <> nil then
  begin
    if ImageListState.ParentFORM.Name = ParentForm.Name then
      ILSt := 'Result.' + ImageListState.Name
    else
      ILSt := ImageListState.ParentFORM.Name +'.'+ ImageListState.Name;
  end;
  Result := AParent + ', [ ' + O + ' ], ' + ILNr + ', ' + ILSt;
end;

function TKOLTreeView.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

{ TKOLRichEdit }

function TKOLRichEdit.AdditionalUnits: String;
begin
  Result := inherited AdditionalUnits;
  if OLESupport then
    Result := Result + ', KOLOLERE';
end;

procedure TKOLRichEdit.AfterFontChange( SL: TStrings; const AName, Prefix: String );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.AfterFontChange', 0
  @@e_signature:
  end;
  SL.Add( Prefix + AName + '.RE_CharFmtArea := raSelection;' );
end;

procedure TKOLRichEdit.BeforeFontChange( SL: TStrings; const AName, Prefix: String );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.BeforeFontChange', 0
  @@e_signature:
  end;
  SL.Add( Prefix + AName + '.RE_CharFmtArea := raAll;' );
end;

function TKOLRichEdit.BestEventName: String;
begin
  Result := 'OnChange';
end;

constructor TKOLRichEdit.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.Create', 0
  @@e_signature:
  end;
  FLines := TStringList.Create;
  inherited;
  FDefIgnoreDefault := TRUE;
  FIgnoreDefault := TRUE;
  Width := 164; DefaultWidth := 100;
  Height := 200; DefaultHeight := Height;
  TabStop := TRUE;
  version := ver3;
  FMaxTextSize := 32767;
end;

procedure TKOLRichEdit.CreateKOLControl(Recreating: boolean);
var
  opts: kol.TEditOptions;
begin
  opts:=[];
  if eo_Lowercase in FOptions then
    Include(opts, kol.eoLowercase);
  if eo_NoHScroll in FOptions then
    Include(opts, kol.eoNoHScroll);
  if eo_NoVScroll in FOptions then
    Include(opts, kol.eoNoVScroll);
  if eo_UpperCase in FOptions then
    Include(opts, kol.eoUpperCase);
  FKOLCtrl:=NewRichEdit(KOLParentCtrl, opts);
end;

function TKOLRichEdit.DefaultColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.DefaultColor', 0
  @@e_signature:
  end;
  Result := clWindow;
end;

destructor TKOLRichEdit.Destroy;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.Destroy', 0
  @@e_signature:
  end;
  FLines.Free;
  inherited;
end;

procedure TKOLRichEdit.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.FirstCreate', 0
  @@e_signature:
  end;
  FLines.Text := Name;
  inherited;
end;

function TKOLRichEdit.FontPropName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.FontPropName', 0
  @@e_signature:
  end;
  Result := 'RE_Font';
end;

function TKOLRichEdit.GenerateTransparentInits: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.GenerateTransparentInits', 0
  @@e_signature:
  end;
  Result := inherited GenerateTransparentInits;
  if RE_FmtStandard then
    Result := Result + '.RE_FmtStandard';
end;

function TKOLRichEdit.GetCaption: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.GetCaption', 0
  @@e_signature:
  end;
  Result := FLines.Text;
end;

function TKOLRichEdit.GetText: TStrings;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.GetText', 0
  @@e_signature:
  end;
  Result := FLines;
end;

procedure TKOLRichEdit.KOLControlRecreated;
begin
  inherited;
  if Assigned(FKOLCtrl) then
    FKOLCtrl.Text:=FLines.Text;
end;

procedure TKOLRichEdit.Loaded;
begin
  inherited;
  if Assigned(FKOLCtrl) then
    FKOLCtrl.Text:=FLines.Text;
end;

function TKOLRichEdit.NoDrawFrame: Boolean;
begin
  Result:=HasBorder;
end;

procedure TKOLRichEdit.SetMaxTextSize(const Value: DWORD);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetMaxTextSize', 0
  @@e_signature:
  end;
  FMaxTextSize := Value;
  Change;
end;

procedure TKOLRichEdit.SetOLESupport(const Value: Boolean);
begin
  FOLESupport := Value;
  Change;
end;

procedure TKOLRichEdit.SetOptions(const Value: TKOLMemoOptions);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetOptions', 0
  @@e_signature:
  end;
  if FOptions = Value then exit;
  FOptions := Value;
  if Assigned(FKOLCtrl) then 
    RecreateWnd;
  Change;
end;

procedure TKOLRichEdit.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLRichEdit.SetRE_AutoKeybdSet(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetRE_AutoKeybdSet', 0
  @@e_signature:
  end;
  FRE_AutoKeybdSet := Value;
  Change;
end;

procedure TKOLRichEdit.SetRE_AutoKeyboard(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetRE_AutoKeyboard', 0
  @@e_signature:
  end;
  FRE_AutoKeyboard := Value;
  Change;
end;

procedure TKOLRichEdit.SetRE_AutoURLDetect(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetRE_AutoURLDetect', 0
  @@e_signature:
  end;
  FRE_AutoURLDetect := Value;
  Change;
end;

procedure TKOLRichEdit.SetRE_DisableOverwriteChange(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetRE_DisableOverwriteChange', 0
  @@e_signature:
  end;
  FRE_DisableOverwriteChange := Value;
  Change;
end;

procedure TKOLRichEdit.SetRE_FmtStandard(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetRE_FmtStandard', 0
  @@e_signature:
  end;
  FRE_FmtStandard := Value;
  Change;
end;

procedure TKOLRichEdit.SetRE_Transparent(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetRE_Transparent', 0
  @@e_signature:
  end;
  FRE_Transparent := Value;
  Change;
end;

procedure TKOLRichEdit.SetText(const Value: TStrings);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetText', 0
  @@e_signature:
  end;
  FLines.Text := Value.Text;
  if Assigned(FKOLCtrl) then
    FKOLCtrl.Text:=Value.Text;
  Change;
end;

procedure TKOLRichEdit.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
const
  BoolVal: array[ Boolean ] of String = ( 'FALSE', 'TRUE' );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if FLines.Text <> '' then
    AddLongTextField( SL, Prefix + AName + '.Text := ', FLines.Text, ';' );
  if MaxTextSize <> 32767 then
    if MaxTextSize > $7FFFffff then
      SL.Add( Prefix + AName + '.MaxTextSize := $' + Int2Hex( MaxTextSize, 8 ) + ';' )
    else
      SL.Add( Prefix + AName + '.MaxTextSize := ' + IntToStr( MaxTextSize ) + ';' );
  if RE_AutoKeybdSet then
    SL.Add( Prefix + AName + '.RE_AutoKeyboard := ' + BoolVal[ RE_AutoKeyboard ] + ';' );
  if RE_DisableOverwriteChange then
    SL.Add( Prefix + AName + '.RE_DisableOverwriteChange := TRUE;' );
  if RE_AutoURLDetect then
    SL.Add( Prefix + AName + '.RE_AutoURLDetect := TRUE;' );
  if RE_Transparent then
    SL.Add( Prefix + AName + '.RE_Transparent := TRUE;' );
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );
end;

function TKOLRichEdit.SetupParams(const AName, AParent: String): String;
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetupParams', 0
  @@e_signature:
  end;
  S := 'eoMultiline';
  if eo_NoHScroll in Options then
    S := S + ', eoNoHScroll';
  if eo_NoVScroll in Options then
    S := S + ', eoNoVScroll';
  if eo_Lowercase in Options then
    S := S + ', eoLowercase';
  if eo_NoHideSel in Options then
    S := S + ', eoNoHideSel';
  if eo_OemConvert in Options then
    S := S + ', eoOemConvert';
  if eo_Password in Options then
    S := S + ', eoPassword';
  if eo_Readonly in Options then
    S := S + ', eoReadonly';
  if eo_UpperCase in Options then
    S := S + ', eoUpperCase';
  if eo_WantReturn in Options then
    S := S + ', eoWantReturn';
  if eo_WantTab in Options then
    S := S + ', eoWantTab';
  if S <> '' then
  if S[ 1 ] = ',' then
    S := Copy( S, 3, MaxInt );
  Result := AParent + ', [ ' + S + ' ]';
end;

procedure TKOLRichEdit.Setversion(const Value: TKOLRichEditVersion);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.Setversion', 0
  @@e_signature:
  end;
  Fversion := Value;
  Change;
end;

function TKOLRichEdit.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLRichEdit.TypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.TypeName', 0
  @@e_signature:
  end;
  Result := inherited TypeName;
  if version = ver1 then
    Result := 'RichEdit1';
  if OLESupport then
    Result := 'OLERichEdit';
end;

procedure TKOLRichEdit.WantTabs( Want: Boolean );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.WantTabs', 0
  @@e_signature:
  end;
  if Want then
    Options := Options + [ eo_WantTab ]
  else
    Options := Options - [ eo_WantTab ];
end;

{ TKOLProgressBar }

constructor TKOLProgressBar.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.Create', 0
  @@e_signature:
  end;
  inherited;
  Width := 300; DefaultWidth := Width;
  Height := 20; DefaultHeight := Height;
  MaxProgress := 100;
  ProgressColor := clHighLight;
  ProgressBkColor := clBtnFace;
end;

procedure TKOLProgressBar.CreateKOLControl(Recreating: boolean);
var
  opts: kol.TProgressbarOptions;
begin
  opts:=[];
  if Smooth then
    Include(opts, kol.pboSmooth);
  if Vertical then
    Include(opts, kol.pboVertical);
  FKOLCtrl:=NewProgressbarEx(KOLParentCtrl, opts);
end;

function TKOLProgressBar.GetColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.GetColor', 0
  @@e_signature:
  end;
  Result := inherited Color;
end;

procedure TKOLProgressBar.KOLControlRecreated;
begin
  inherited;
  FKOLCtrl.Progress:=Progress;
  FKOLCtrl.MaxProgress:=MaxProgress;
  FKOLCtrl.ProgressBkColor:=ProgressBkColor;
end;

function TKOLProgressBar.NoDrawFrame: Boolean;
begin
  Result:=True;
end;

procedure TKOLProgressBar.SetColor(const Value: TColor);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.SetColor', 0
  @@e_signature:
  end;
  inherited Color := Value;
end;

procedure TKOLProgressBar.SetMaxProgress(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.SetMaxProgress', 0
  @@e_signature:
  end;
  if Value < 1 then Exit;
  FMaxProgress := Value;
  if Value < Progress then
    FProgress := Value;
  if Assigned(FKOLCtrl) then begin
    FKOLCtrl.MaxProgress:=FMaxProgress;
    FKOLCtrl.Progress:=FProgress;
  end;
  Change;
end;

procedure TKOLProgressBar.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLProgressBar.SetProgress(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.SetProgress', 0
  @@e_signature:
  end;
  if Value < 0 then Exit;
  FProgress := Value;
  if Value > MaxProgress then
    FMaxProgress := Value;
  if Assigned(FKOLCtrl) then begin
    FKOLCtrl.MaxProgress:=FMaxProgress;
    FKOLCtrl.Progress:=FProgress;
  end;
  Change;
end;

procedure TKOLProgressBar.SetProgressColor(const Value: TColor);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.SetProgressColor', 0
  @@e_signature:
  end;
  FProgressColor := Value;
  if Assigned(FKOLCtrl) then
    FKOLCtrl.ProgressColor:=Value;
  Change;
end;

procedure TKOLProgressBar.SetSmooth(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.SetSmooth', 0
  @@e_signature:
  end;
  FSmooth := Value;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
  Change;
end;

procedure TKOLProgressBar.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if MaxProgress <> 100 then
    SL.Add( Prefix + AName + '.MaxProgress := ' + IntToStr( MaxProgress ) + ';' );
  if Progress <> 0 then
    SL.Add( Prefix + AName + '.Progress := ' + IntToStr( Progress ) + ';' );
  if ProgressColor <> clHighLight then
    SL.Add( Prefix + AName + '.ProgressColor := ' + Color2Str( ProgressColor ) + ';' );
  {if ProgressBkColor <> clBtnFace then
    SL.Add( Prefix + AName + '.ProgressBkColor := ' + Color2Str( ProgressBkColor ) + ';' );}
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );
end;

function TKOLProgressBar.SetupParams(const AName, AParent: String): String;
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.SetupParams', 0
  @@e_signature:
  end;
  Result := AParent;
  if Smooth or Vertical then
  begin
    S := '';
    if Smooth then
      S := 'pboSmooth';
    if Vertical then
      S := S + ', pboVertical';
    if S <> '' then
    if S[ 1 ] = ',' then
      S := Copy( S, 3, MaxInt );
    Result := Result + ', [ ' + S + ' ]';
  end;
end;

procedure TKOLProgressBar.SetVertical(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.SetVertical', 0
  @@e_signature:
  end;
  FVertical := Value;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
  Change;
end;

function TKOLProgressBar.TypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.TypeName', 0
  @@e_signature:
  end;
  Result := inherited TypeName;
  if Smooth or Vertical then
    Result := 'ProgressBarEx';
end;

{ TKOLTabControl }

procedure TKOLTabControl.AdjustPages;
var R: TRect;
    Dx, Dy: Integer;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.AdjustPages', 0
  @@e_signature:
  end;
  if Parent = nil then
    Exit;
  R := ClientRect;
  Inc( R.Left, 4 );
  Inc( R.Top, 4 );
  Dec( R.Right, 4 );
  Dec( R.Bottom, 4 );
  Dx := 0;
  Dy := 22;
  if tcoVertical in Options then
  begin
    Dx := 22;
    Dy := 0;
  end;
  if tcoBottom in Options then
  begin
    Dec( R.Right, Dx );
    Dec( R.Bottom, Dy );
  end
    else
  begin
    Inc( R.Left, Dx );
    Inc( R.Top, Dy );
  end;
  FAdjustingPages := TRUE;
  for I := 0 to Count-1 do
  begin
    Pages[ I ].FOnSetBounds := AttemptToChangePageBounds;
    Pages[ I ].BoundsRect := R;
  end;
  FAdjustingPages := FALSE;
end;

procedure TKOLTabControl.AttemptToChangePageBounds(Sender: TObject;
  var NewBounds: TRect);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.AttemptToChangePageBounds', 0
  @@e_signature:
  end;
  if FAdjustingPages then Exit;
  if Count > 0 then
  begin
    AdjustPages;
    NewBounds := Pages[ 0 ].BoundsRect;
  end;
end;

constructor TKOLTabControl.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.Create', 0
  @@e_signature:
  end;
  inherited;
  Width := 100;  DefaultWidth := Width;
  Height := 100; DefaultHeight := Height;
  FTabs := TList.Create;
  FedgeType := esNone;
  FgenerateConstants := TRUE;
end;

destructor TKOLTabControl.Destroy;
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.Destroy', 0
  @@e_signature:
  end;
  fDestroyingTabControl := TRUE;
  for I := FTabs.Count-1 downto 0 do
    FreeMem( FTabs[ I ] );
  FTabs.Free;
  inherited;
end;

function CompareTabPages( L: TList; e1, e2: DWORD ): Integer;
var P1, P2: TKOLTabPage;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'CompareTabPages', 0
  @@e_signature:
  end;
  P1 := L[ e1 ];
  P2 := L[ e2 ];
  if P1.TabOrder < P2.TabOrder then Result := -1
  else
  if P1.TabOrder > P2.TabOrder then Result := 1
  else
  Result := 0;
end;

procedure SwapTabPages( L: TList; e1, e2: DWORD );
var P: Pointer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'SwapTabPages', 0
  @@e_signature:
  end;
  P := L[ e1 ];
  L[ e1 ] := L[ e2 ];
  L[ e2 ] := P;
end;

procedure TKOLTabControl.DoGenerateConstants(SL: TStringList);
var I: Integer;
    C: TComponent;
    K: TKOLTabPage;
    Pages: TList;
    F: TForm;
begin
  if not generateConstants then Exit;
  if Owner = nil then Exit;
  if not( Owner is TForm ) then Exit;
  F := Owner as TForm;
  Pages := TList.Create;
  TRY
    for I := 0 to F.ComponentCount-1 do
    begin
      C := F.Components[ I ];
      if not ( C is TKOLTabPage ) then CONTINUE;
      K := C as TKOLTabPage;
      if K.Parent <> Self then CONTINUE;
      Pages.Add( K );
    end;
    SortData( Pages, Pages.Count, @ CompareTabPages, @ SwapTabPages );
    for I := 0 to Pages.Count-1 do
    begin
      K := Pages[ I ];
      SL.Add( 'const _' + K.Name + ' = ' + IntToStr( I ) + ';' );
    end;
  FINALLY
    Pages.Free;
  END;
end;

function TKOLTabControl.GetCount: Integer;
var I: Integer;
    C: TComponent;
    K: TKOLTabPage;
    F: TForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.GetCount', 0
  @@e_signature:
  end;
  Result := 0;
  if Owner = nil then Exit;
  if not( Owner is TForm ) then Exit;
  F := Owner as TForm;
  for I := 0 to F.ComponentCount-1 do
  begin
    C := F.Components[ I ];
    if not ( C is TKOLTabPage ) then CONTINUE;
    K := C as TKOLTabPage;
    if K.Parent <> Self then CONTINUE;
    Inc( Result );
  end;
end;

function TKOLTabControl.GetCurIndex: Integer;
var I: Integer;
    CurPage: TKOLTabPage;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.GetCurIndex', 0
  @@e_signature:
  end;
  Result := -1;
  CurPage := GetCurrentPage;
  if CurPage = nil then Exit;
  for I := 0 to Count-1 do
    if CurPage = Pages[ I ] then
    begin
      Result := I;
      break;
    end;
end;

function TKOLTabControl.GetCurrentPage: TKOLTabPage;
var W: HWnd;
    C: TWinControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.GetCurrentPage', 0
  @@e_signature:
  end;
  Result := FCurPage;
  if Result = nil then
  begin
    W := GetWindow( Handle, GW_CHILD );
    if W = 0 then Exit;
    C := FindControl( W );
    if C is TKOLTabPage then
    begin
      Result := C as TKOLTabPage;
      FCurPage:=Result;
    end;
  end;
  {Result := nil;
  W := GetWindow( Handle, GW_CHILD );
  if W = 0 then Exit;
  C := FindControl( W );
  if C is TKOLTabPage then
    Result := C as TKOLTabPage;}
end;

function TKOLTabControl.GetPages(Idx: Integer): TKOLTabPage;
var I: Integer;
    C: TComponent;
    K: TKOLTabPage;
    F: TForm;
    L: TList;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.GetPages', 0
  @@e_signature:
  end;
  Result := nil;
  L := TList.Create;
  try
    if Owner = nil then Exit;
    if not( Owner is TForm ) then Exit;
    F := Owner as TForm;
    for I := 0 to F.ComponentCount-1 do
    begin
      C := F.Components[ I ];
      if not ( C is TKOLTabPage ) then CONTINUE;
      K := C as TKOLTabPage;
      if K.Parent <> Self then CONTINUE;
      L.Add( K );
    end;
    SortData( L, L.Count, @CompareTabPages, @SwapTabPages );
    Result := L.Items[ Idx ];
  finally
    L.Free;
  end;
end;

function TKOLTabControl.NoDrawFrame: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLTabControl.Paint;
var
  R, CurR: TRect;
  I, Tw, Sx, Sy, W, H: Integer;
  S : String;
  CurPage: TKOLTabPage;
  M: PRect;
  DirXX_YY,DirXY_YX:SmallInt;
  O_V, O_B, O_BTN, O_F, O_BRD: Boolean;
  P:TPoint;
  Col: array[0..3] of TColor;
  Fnt: HFont;

 procedure _MoveTo(const x,y:integer);
 begin
   p.x:=x;
   p.y:=y;
   canvas.moveto(x,y);
 end;

 procedure MoveRel(const dx,dy:integer);
 begin
   p.x:=p.x+dirxx_yy*dx+dirxy_yx*dy;
   p.y:=p.y+dirxx_yy*dy+dirxy_yx*dx;
   canvas.moveto(p.x,p.y);
 end;

 procedure LineRel(const dx,dy:integer);
 begin
   p.x:=p.x+dirxx_yy*dx+dirxy_yx*dy;
   p.y:=p.y+dirxx_yy*dy+dirxy_yx*dx;
   canvas.lineto(p.x,p.y);
 end;

 procedure prepare(const r:trect);
 begin
   if o_v xor o_b then
   begin
     sy:=r.top;
     sx:=r.right;
   end else
   begin
     sy:=r.bottom;
     sx:=r.left;
   end;
   if o_v then
   begin
     h:=r.right-r.left;
     w:=r.bottom-r.top;
   end else
   begin
     w:=r.right-r.left;
     h:=r.bottom-r.top;
   end;
   if o_b then
   begin
     dec(sx);
     dec(sy);
   end;
   dec(h,2);
 end;

 procedure DrawTab(r:trect; const cur:boolean);
 begin
   inflaterect(r,2,2);
   if o_btn then
   begin
     if not cur and o_f
       then drawedge(canvas.handle,r,BDR_RAISEDOUTER,BF_RECT or BF_SOFT)
       else drawedge(canvas.handle,r,EDGE_RAISED*succ(ord(cur)),BF_RECT or BF_SOFT);
     if cur then
     begin
       inflaterect(r,-2,-2);
       drawcaption(findwindow('Shell_TrayWnd',nil),canvas.handle,r,
         DC_TEXT or DC_ACTIVE or DC_INBUTTON);
     end;
   end else
   begin
     if cur then
     begin
       inflaterect(r,2,2);
       if o_b
         then if o_v then inc(r.left,2) else inc(r.top,2)
        else if o_v then dec(r.right,2) else dec(r.bottom,2);
     end;
     prepare(r);
     with canvas,r do
     begin
       if cur then
       begin
         _moveto(sx,sy);
         moverel(0,-2);
         pen.color:=clbtnface;
         linerel(w-3,0);
         linerel(0,1);
         linerel(4-w,0);
       end;
       _moveto(sx,sy);
       moverel(0,-2);
       pen.color:=col[0];
       linerel(0,2-h);
       linerel(2,-2);
       linerel(w-4,0);
       moverel(0,1);
       pen.color:=col[1];
       linerel(1,1);
       linerel(0,h-1);
       _moveto(sx,sy);
       moverel(1,-2);
       pen.color:=col[2];
       linerel(0,2-h);
       linerel(1,-1);
       linerel(w-4,0);
       moverel(0,1);
       pen.color:=col[3];
       linerel(0,h-1);
     end;
   end;
 end;

 procedure preparefont;
 var
   a:integer;
 begin
   a:=900*pred(ord(not o_b) shl 1);
   fnt:=createfont(10,0,a,a,0,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,
     CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,VARIABLE_PITCH,'MS Serif');
 end;

begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.Paint', 0
  @@e_signature:
  end;
  if PaintType = ptSchematic then
  begin
    SchematicPaint;
    Exit;
  end;
  o_b:=tcobottom in options;
  o_v:=tcovertical in options;
  o_btn:=tcobuttons in options;
  o_f:=tcoflat in options;
  o_brd:=tcoBorder in options;
  r:=clientrect;
  if o_brd then
  begin
    drawedge(canvas.handle,r,EDGE_SUNKEN,BF_RECT);
    inflaterect(r,-2,-2);
  end;
  inflaterect(r,-4,-4);
  if o_b
    then if o_v then r.left:=r.right-17 else r.top:=r.bottom-17
    else if o_v then r.right:=r.left+17 else r.bottom:=r.top+17;
  dirxx_yy:=ord(not o_v)*pred(ord(not o_b) shl 1);
  dirxy_yx:=ord(o_v)*pred(ord(not o_b) shl 1);
  col[0 xor ord(o_b)]:=clbtnhighlight;
  col[1 xor ord(o_b)]:=cl3ddkshadow;
  col[2 xor ord(o_b)]:=cl3dlight;
  col[3 xor ord(o_b)]:=clbtnshadow;
  if not o_v then PrepareCanvasFontForWYSIWIGPaint(canvas) else
  begin
    preparefont;
    selectobject(canvas.handle,fnt);
  end;
  curpage:=getcurrentpage;
  for i:=0 to pred(ftabs.count) do freemem(ftabs[i]);
  ftabs.clear;
  setbkmode(canvas.handle,windows.TRANSPARENT);
  for i:=0 to pred(count) do
  begin
    getmem(m,sizeof(trect));
    s:=pages[i].caption;
    tw:=canvas.textwidth(s);
    if o_v then r.bottom:=r.top+tw+8 else r.right:=r.left+tw+8;
    m^:=r;
    ftabs.add(m);
    if curpage=pages[i] then curr:=r else
    begin
      drawtab(r,false);
      drawtext(canvas.handle,pchar(s),length(s),r,DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end;
    pages[i].fonsetbounds:=attempttochangepagebounds;
    if o_v then r.top:=r.bottom+4 else r.left:=r.right+4;
    if o_btn then
      if o_v then inc(r.top,2) else inc(r.left,2);
  end;
  r:=clientrect;
  if o_brd then inflaterect(r,-2,-2);
  if o_b
    then if o_v then r.right:=r.right-21 else r.bottom:=r.bottom-21
    else if o_v then r.left:=r.left+21 else r.top:=r.top+21;
  if not o_btn then drawedge(canvas.handle,r,EDGE_RAISED,BF_RECT or BF_SOFT);
  if curpage<>nil then
  begin
    drawtab(curr,true);
    s:=curpage.caption;
    if o_btn then offsetrect(curr,2,2) else offsetrect(curr,-2*dirxy_yx,-2*dirxx_yy);
    drawtext(canvas.handle,pchar(s),length(s),curr,DT_CENTER or DT_VCENTER or DT_SINGLELINE);
  end;
  if o_v then deleteobject(fnt);
  inherited;
end;

procedure TKOLTabControl.SchematicPaint;
var R: TRect;
    I, Tw, Th: Integer;
    S: String;
    CurPage: TKOLTabPage;
    M: PRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.Paint', 0
  @@e_signature:
  end;
  inherited Paint;
  R := ClientRect;
  Inc( R.Top, 4 );
  Inc( R.Left, 4 );
  Dec( R.Right, 4 );
  Dec( R.Bottom, 4 );
  if tcoBottom in Options then
    if tcoVertical in Options then
      R.Left := R.Right - 18
    else
      R.Top := R.Bottom - 18
  else
    if tcoVertical in Options then
      R.Right := R.Left + 18
    else
      R.Bottom := R.Top + 18;
  R.Right := R.Left + 18;
  R.Bottom := R.Top + 18;
  Canvas.Font.Height := 8;
  Canvas.Brush.Color := clDkGray;
  CurPage := GetCurrentPage;
  for I := 0 to FTabs.Count-1 do
    FreeMem( FTabs[ I ] );
  FTabs.Clear;
  for I := 0 to Count-1 do
  begin
    GetMem( M, SizeOf( TRect ) );
    M^ := R;
    FTabs.Add( M );
    S := IntToStr( I );
    Tw := Canvas.TextWidth( S );
    Th := Canvas.TextHeight( S );
    Canvas.TextRect( R, R.Left + (18 - Tw) div 2, R.Top + (18 - Th) div 2, S );
    Pages[ I ].FOnSetBounds := AttemptToChangePageBounds;
    if CurPage = Pages[ I ] then
    begin
      Canvas.Brush.Color := clBlack;
      Canvas.FrameRect( R );
      Canvas.Brush.Color := clDkGray;
    end;
    if tcoVertical in Options then
    begin
      Inc( R.Top, 22 );
      Inc( R.Bottom, 22 );
    end
      else
    begin
      Inc( R.Left, 22 );
      Inc( R.Right, 22 );
    end;
  end;
end;

procedure TKOLTabControl.SetBounds(aLeft, aTop, aWidth, aHeight: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetBounds', 0
  @@e_signature:
  end;
  inherited;
  AdjustPages;
end;

procedure TKOLTabControl.SetCount(const Value: Integer);
var Pg: TKOLTabPage;
    I: Integer;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetCount', 0
  @@e_signature:
  end;
  if Value < Count then Exit;
  if csLoading in ComponentState then Exit;
  I := Count;
  while Value > Count do
  begin
    while True do
    begin
      S := Name + '_Tab' + IntToStr( I );
      if (Owner as TForm).FindComponent( S ) = nil then
        break;
      Inc( I );
    end;
    Pg := TKOLTabPage.Create( Owner );
    Pg.Parent := Self;
    Pg.Name := S;
    Pg.Caption := 'Tab' + IntToStr( I );
    //Pg.BevelOuter := bvNone;
    Pg.edgeStyle := esNone;
    //Pg.Align := caClient;
    Inc( I );
  end;
  AdjustPages;
  Invalidate;
  Change;
end;

procedure TKOLTabControl.SetCurIndex(const Value: Integer);
//var Pg: TKOLTabPage;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetCurIndex', 0
  @@e_signature:
  end;
  if (Value >= Count) or (Value < 0) then
  begin
    FCurPage := nil;
    Exit;
  end;
  FCurPage:=Pages[ Value ];
  if FCurPage <> nil then
  begin
    FCurPage.BringToFront;
    Invalidate;
  end;
  {Pg := Pages[ Value ];
  if Pg <> nil then
  begin
    Pg.BringToFront;
    Invalidate;
  end;}
  Change;
end;

procedure TKOLTabControl.SetedgeType(const Value: TEdgeStyle);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetedgeType', 0
  @@e_signature:
  end;
  FedgeType := Value;
  if Value = esNone then
    Options := Options - [ tcoBorder ]
  else
    Options := Options + [ tcoBorder ];
  Change;
end;

procedure TKOLTabControl.SetgenerateConstants(const Value: Boolean);
begin
  FgenerateConstants := Value;
  Change;
end;

procedure TKOLTabControl.SetImageList(const Value: TKOLImageList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetImageList', 0
  @@e_signature:
  end;
  FImageList := Value;
  Change;
end;

procedure TKOLTabControl.SetImageList1stIdx(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetImageList1stIdx', 0
  @@e_signature:
  end;
  FImageList1stIdx := Value;
  Change;
end;

procedure TKOLTabControl.SetOptions(const Value: TTabControlOptions);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetOptions', 0
  @@e_signature:
  end;
  FOptions := Value;
  AdjustPages;
  Invalidate;
  Change;
end;

procedure TKOLTabControl.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLTabControl.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  case edgeType of
  esLowered:;
  esRaised: SL.Add( Prefix + AName + '.Style := ' + AName +
                     '.Style or WS_THICKFRAME;' );
  esNone:   ;
  end;
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );
end;

procedure TKOLTabControl.SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetupLast', 0
  @@e_signature:
  end;
  inherited;
  if CurIndex > 0 then
  begin
    //SL.Add( Prefix + '  ' + AName + '.GetWindowHandle;' );
    //SL.Add( Prefix + '  ' + AName + '.CreateWindow;' );
    SL.Add( Prefix + '  ' + AName + '.CurIndex := ' + IntToStr( CurIndex ) + ';' );
    //SL.Add( Prefix + '  PostMessage( ' + AName + '.GetWindowHandle, TCM_SETCURSEL, ' + IntToStr( CurIndex ) +
    //        ', 0 );' );
    SL.Add( Prefix + '  ' + AName + '.Pages[ ' + IntToStr( CurIndex ) + ' ].BringToFront;' );
  end;
end;

function TKOLTabControl.SetupParams(const AName, AParent: String): String;
var O, IL, S: String;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetupParams', 0
  @@e_signature:
  end;
  S := '';
  for I := 0 to Count - 1 do
  begin
    if S <> '' then
      S := S + ', ';
    S := S + StringConstant( 'Page' + IntToStr( I ) + 'Caption', Pages[ I ].Caption );
  end;
  O := '';
  if tcoButtons in Options then
    O := 'tcoButtons';
  if tcoFixedWidth in Options then
    O := O + ', tcoFixedWidth';
  if tcoFocusTabs in Options then
    O := O + ', tcoFocusTabs';
  if tcoIconLeft in Options then
    O := O + ', tcoIconLeft';
  if tcoLabelLeft in Options then
    O := O + ', tcoLabelLeft';
  if tcoMultiline in Options then
    O := O + ', tcoMultiline';
  if tcoMultiselect in Options then
    O := O + ', tcoMultiselect';
  if tcoFitRows in Options then
    O := O + ', tcoFitRows';
  if tcoScrollOpposite in Options then
    O := O + ', tcoScrollOpposite';
  if tcoBottom in Options then
    O := O + ', tcoBottom';
  if tcoVertical in Options then
    O := O + ', tcoVertical';
  if tcoFlat in Options then
    O := O + ', tcoFlat';
  if tcoHotTrack in Options then
    O := O + ', tcoHotTrack';
  if tcoBorder in Options then
    O := O + ', tcoBorder';
  if tcoOwnerDrawFixed in Options then
    O := O + ', tcoOwnerDrawFixed';
  if O <> '' then
  if O[ 1 ] = ',' then
    O := Copy( O, 3, MaxInt );
  IL := 'nil';
  if ImageList <> nil then
    IL := 'Result.' + ImageList.Name;
  Result := AParent + ', [ ' + S + ' ], [ ' + O + ' ], ' + IL
            + ', ' + IntToStr( ImageList1stIdx );
end;

function TKOLTabControl.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLTabControl.WYSIWIGPaintImplemented: Boolean;
begin
  Result := TRUE;
end;

{ TKOLToolbar }

function TKOLToolbar.AllPicturedButtonsAreLeading: Boolean;
var I: Integer;
    Bt: TKOLToolbarButton;
begin
  Result := FALSE;
  if PicturedButtonsCount = 0 then Exit;
  Bt := Items[ 0 ];
  if not Bt.HasPicture then Exit;
  Result := TRUE;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if not Bt.HasPicture then
    begin
      if NoMorePicturedButtonsFrom( I ) then
        break;
      Result := FALSE;
      break;
    end;
  end;
end;

function TKOLToolbar.LastBtnHasPicture: Boolean;
var Bt: TKOLToolbarButton;
begin
  Result := FALSE;
  if PicturedButtonsCount = 0 then Exit;
  if not Assigned( Items ) then Exit;
  if Items.Count = 0 then Exit;
  Bt := Items[ Items.Count-1 ];
  Result := Bt.HasPicture;
end;

procedure TKOLToolbar.AssembleBitmap;
var MaxWidth, MaxHeight: Integer;
    I: Integer;
    Bt: TKOLToolbarButton;
    TranColor: TColor;
    TmpBmp: TBitmap;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.AssembleBitmap', 0
  @@e_signature:
  end;
  MaxWidth := 0;
  MaxHeight := 0;
  TranColor := clNone;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if Bt.HasPicture then
    begin
      if MaxWidth < Bt.picture.Width then
        MaxWidth := Bt.picture.Width;
      if MaxHeight < Bt.picture.Height then
        MaxHeight := Bt.picture.Height;
      if TranColor = clNone then
      begin
        TmpBmp := TBitmap.Create;
        TRY
          TmpBmp.Width := Bt.picture.Width;
          TmpBmp.Height := Bt.picture.Height;
          TmpBmp.Canvas.Draw( 0, 0, Bt.picture.Graphic );
          TranColor := TmpBmp.Canvas.Pixels[ 0, TmpBmp.Height - 1 ];
        FINALLY
          TmpBmp.Free;
        END;
      end;
    end;
  end;
  if (MaxWidth = 0) or (MaxHeight = 0) then
  begin
    Fbitmap.Width := 0;
    Fbitmap.Height := 0;
  end
    else
  begin
    Fbitmap.Width := MaxWidth * Items.Count;
    Fbitmap.Height := MaxHeight;
    if TranColor <> clNone then
    begin
      Fbitmap.Canvas.Brush.Color := TranColor;
      Fbitmap.Canvas.FillRect( Rect( 0, 0, Fbitmap.Width, Fbitmap.Height ) );
    end;
    for I := 0 to Items.Count - 1 do
    begin
      Bt := Items[ I ];
      if Bt.HasPicture then
        Fbitmap.Canvas.Draw( I * MaxWidth, 0, Bt.picture.Graphic );
    end;
  end;
  if ActiveDesign <> nil then
  begin
    ActiveDesign.Bitmap.Assign( Fbitmap );
    ActiveDesign.ApplyImages;
  end;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
end;

function IsBitmapEmpty( Bmp: TBitmap ): Boolean;
var //TmpBmp: TBitmap;
    Y, X: Integer;
    Color1: TColor;
    Lin: PDWORD;
    KOLBmp: KOL.PBitmap;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'IsBitmapEmpty', 0
  @@e_signature:
  end;
  Result := TRUE;
  if not Assigned( Bmp ) then Exit;
  if Bmp.Width * Bmp.Height = 0 then Exit;
  KOLBmp := NewBitmap( Bmp.Width, Bmp.Height );
  TRY

    KOLBmp.HandleType := KOL.bmDIB;
    KOLBmp.PixelFormat := KOL.pf32bit;
    BitBlt( KOLBmp.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height,
            Bmp.Canvas.Handle, 0, 0, SrcCopy );
    Lin := KOLBmp.ScanLine[ 0 ];
    if Lin = nil then
    begin
      Result := FALSE;
      Exit;
    end;
    Color1 := Lin^ and $FFFFFF;
    for Y := 0 to KOLBmp.Height-1 do
    begin
      Lin := KOLBmp.ScanLine[ Y ];
      for X := 0 to KOLBmp.Width-1 do
      begin
        if DWORD(Lin^ and $FFFFFF) <> DWORD( Color1 ) then
        begin
          Result := FALSE;
          Exit;
        end;
        Inc( Lin );
      end;
    end;
  FINALLY
    KOLBmp.Free;
  END;
end;

procedure TKOLToolbar.AssembleTooltips;
var SL: TStringList;
    I, N: Integer;
    Bt: TKOLToolbarButton;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.AssembleTooltips', 0
  @@e_signature:
  end;
  N := 0;
  SL := TStringList.Create;
  TRY
    for I := 0 to Items.Count-1 do
    begin
      Bt := Items[ I ];
      if Bt.separator then continue;
      SL.Add( Bt.Ftooltip );
      if Length( Bt.Ftooltip ) > 0 then
        Inc( N );
    end;
    if N = 0 then
      SL.Clear;
    tooltips := SL;
    showTooltips := SL.Count > 0;
  FINALLY
    SL.Free;
  END;
end;

procedure TKOLToolbar.bitmap2ItemPictures( AnyWay: Boolean );
var W, I: Integer;
    Bmp: TBitmap;
    Bt: TKOLToolbarButton;
    Format: TPixelFormat;
    KOLBmp: KOL.PBitmap;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.bitmap2ItemPictures', 0
  @@e_signature:
  end;
  if not Assigned( bitmap ) then Exit;
  if Items.Count = 0 then Exit;
  if bitmap.Width = 0 then Exit;
  if bitmap.Height = 0 then Exit;
  if not AnyWay then
  begin
    for I := 0 to Items.Count - 1 do
    begin
      Bt := Items[ I ];
      if Bt.HasPicture then
        Exit;
    end;
    ShowMessage( 'Restoring toolbar buttons bitmap from then previous version of the KOL&MCK format.' );
  end;
  W := bitmap.Width div Items.Count;
  Bmp := TBitmap.Create;
  KOLBmp := NewDIBBitmap( Bitmap.Width, Bitmap.Height, KOL.pf32bit );
  TRY
    BitBlt( KOLBmp.Canvas.Handle, 0, 0, bitmap.Width, bitmap.Height,
            bitmap.Canvas.Handle, 0, 0, SRCCOPY );
    KOLBmp.HandleType := KOL.bmDIB;
    KOLBmp.PixelFormat := KOL.pf32bit;
    case CountSystemColorsUsedInBitmap( KOLBmp ) of
    KOL.pf1bit: Format := pf1bit;
    KOL.pf4bit: Format := pf4bit;
    KOL.pf8bit: Format := pf8bit;
    else        Format := pf24bit;
    end;
  FINALLY
    KOLBmp.Free;
  END;
  TRY
    Bmp.Width := W;
    Bmp.Height := bitmap.Height;
    {$IFNDEF _D2}
    Bmp.PixelFormat := Format;
    {$ENDIF}
    for I := 0 to Items.Count - 1 do
    begin
      if I >= Items.Count then break;
      if Items[ I ] = nil then break;
      Bmp.Canvas.CopyRect( Rect( 0, 0, Bmp.Width, Bmp.Height ),
                           bitmap.Canvas,
                           Rect( I * Bmp.Width, 0, (I + 1) * Bmp.Width, Bmp.Height ) );
      Bt := Items[ I ];
      if IsBitmapEmpty( Bmp ) then
      begin
        Bt.Fpicture.Free;
        Bt.Fpicture := TPicture.Create;
      end
        else
      begin
        Bt.Fpicture.Assign( Bmp );
      end;
    end;
  FINALLY
    Bmp.Free;
  END;
end;

procedure TKOLToolbar.buttons2Items;
var I, J: Integer;
    S, C: String;
    Bt: TKOLToolbarButton;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.buttons2Items', 0
  @@e_signature:
  end;
  S := buttons;
  J := 0;
  while S <> '' do
  begin
    I := pos( #1, S );
    if I > 0 then
    begin
      C := Copy( S, 1, I - 1 );
      S := Copy( S, I + 1, MaxInt );
    end
      else
    begin
      C := S;
      S := '';
    end;
    if J >= Items.Count then
      Bt := TKOLToolbarButton.Create( Self )
    else
      Bt := Items[ J ];
    if C <> '' then
    if C[ 1 ] = '^' then
    begin
      C := Copy( C, 2, MaxInt );
      Bt.Fdropdown := TRUE;
    end;
    Bt.Fcaption := C;
    if C <> '-' then
      Bt.Fseparator := FALSE;
    Inc( J );
  end;
  bitmap2ItemPictures( FALSE );
end;

procedure TKOLToolbar.Change;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.Change', 0
  @@e_signature:
  end;
  inherited;
  if ActiveDesign <> nil then
    ActiveDesign.RefreshItems;
  if ParentForm <> nil then
    if ParentForm.Designer <> nil then
      ParentForm.Designer.Modified;
end;

constructor TKOLToolbar.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.Create', 0
  @@e_signature:
  end;
  Ftooltips := TStringList.Create;
  inherited;
  FFixFlatXP := TRUE;
  FgenerateConstants := TRUE;
  FHeightAuto := TRUE;
  Fitems := TList.Create;
  ControlStyle := ControlStyle + [ csAcceptsControls ];
  Height := 22; DefaultHeight := Height;
  Width := 400;
  DefaultWidth := 400;
  Align := caTop;
  FBitmap := TBitmap.Create;
  {$IFNDEF VER90}
  FmapBitmapColors := TRUE;
  {$ENDIF}
  FHasBorder := FALSE;
  FDefHasBorder := FALSE;
  FTimer := TTimer.Create( Self );
  FTimer.Interval := 200;
  FTimer.OnTimer := Tick;
  FTimer.Enabled := TRUE;
  AllowPostPaint := True;
end;

procedure TKOLToolbar.DefineProperties(Filer: TFiler);
var I: Integer;
    Bt: TKOLToolbarButton;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.DefineProperties', 0
  @@e_signature:
  end;
  inherited;
  Filer.DefineProperty( 'Buttons_Count', LoadButtonCount, SaveButtonCount, TRUE );
  for I := 0 to FButtonCount-1 do
  begin
    if FItems.Count <= I then
      Bt := TKOLToolbarButton.Create( Self )
    else
      Bt := FItems[ I ];
    //Bt.DefineProperties( Filer );
    Bt.DefProps( 'Btn' + IntToStr( I + 1 ), Filer );
  end;
  Filer.DefineProperty( 'NewVersion', ReadNewVersion, WriteNewVersion, fNewVersion );
end;

destructor TKOLToolbar.Destroy;
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.Destroy', 0
  @@e_signature:
  end;
  for I := FItems.Count-1 downto 0 do
    TObject( FItems[ I ] ).Free;
  FItems.Free;
  FTimer.Free;
  ActiveDesign.Free;
  FBitmap.Free;
  FBitmap := nil;
  Ftooltips.Free;
  {if FKOLCtrl <> nil then
  begin
    FKOLCtrl.Free;
    FKOLCtrl := nil;
  end;}
  if FBmpDesign <> 0 then
    DeleteObject( FBmpDesign );
  inherited;
end;

function IsNumber( const S: String ): Boolean;
var I: Integer;
begin
  Result := FALSE;
  if S = '' then Exit;
  for I := 1 to Length( S ) do
    if not( S[ I ] in [ '0'..'9' ] ) then
      Exit;
  Result := TRUE;
end;

procedure TKOLToolbar.DoGenerateConstants(SL: TStringList);
var I, N, K: Integer;
    Bt: TKOLToolbarButton;
begin
  if not generateConstants then Exit;
  N := 0;
  K := 0;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if Bt.separator and (Copy( Bt.Name, 1, 2 ) = 'TB') and
       IsNumber( Copy( Bt.Name, 3, MaxInt ) ) then
    begin
      Inc( N );
      continue;
    end;
    if Bt.Name <> '' then
    begin
      SL.Add( 'const ' + Bt.Name + ' = ' + IntToStr( N ) + ';' );
      Inc( K );
    end;
    Inc( N );
  end;
  if ( K > 0 ) then
    SL.Add( '' );
end;

function TKOLToolbar.GetButtons: String;
begin
  Result := Fbuttons;
  if Items.Count = 0 then Exit;
  Items2buttons;
  Result := FButtons;
end;

procedure TKOLToolbar.Items2buttons;
var I: Integer;
    S: String;
    Bt: TKOLToolbarButton;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.Items2buttons', 0
  @@e_signature:
  end;
  S := '';
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if S <> '' then
      S := S + #1;
    if Bt.dropdown then
      S := S + '^';
    S := S + Bt.caption;
  end;
  buttons := S;
end;

procedure TKOLToolbar.LoadButtonCount(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.LoadButtonCount', 0
  @@e_signature:
  end;
  FButtonCount := R.ReadInteger;
  //ShowMessage( 'loaded FButtonCount=' + IntToStr( FButtonCount ) );
end;

procedure TKOLToolbar.Loaded;
var I, J: Integer;
    Bt: TKOLToolbarButton;
    S: String;
    AnyEnabled: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.Loaded', 0
  @@e_signature:
  end;
  inherited;
  buttons2Items;
  AnyEnabled := FALSE;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if Bt.Name = '' then
    begin
      for J := 1 to MaxInt do
      begin
        S := 'TB' + IntToStr( J );
        if (FindComponent( S ) = nil) and ((Owner as TForm).FindComponent( S ) = nil) then
        begin
          Bt.Name := S;
          break;
        end;
      end;
    end;
    if Bt.enabled then
      AnyEnabled := TRUE;
  end;
  if not AnyEnabled then
  begin
    for I := 0 to Items.Count-1 do
    begin
      Bt := Items[ I ];
      Bt.enabled := TRUE;
    end;
  end;
  fNewVersion := TRUE;
  if Assigned(FKOLCtrl) then
    if StandardImagesUsed > 0 then
      RecreateWnd
    else
      UpdateButtons;
end;

function TKOLToolbar.MaxBtnImgHeight: Integer;
var I: Integer;
    Bt: TKOLToolbarButton;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.MaxBtnImgHeight', 0
  @@e_signature:
  end;
  Result := 0;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if Bt.HasPicture and (Bt.picture.Height > Result) then
      Result := Bt.picture.Height;
  end;
end;

function TKOLToolbar.MaxBtnImgWidth: Integer;
var I: Integer;
    Bt: TKOLToolbarButton;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.MaxBtnImgWidth', 0
  @@e_signature:
  end;
  Result := 0;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if Bt.HasPicture and (Bt.picture.Width > Result) then
      Result := Bt.picture.Width;
  end;
end;

function TKOLToolbar.NoMorePicturedButtonsFrom(Idx: Integer): Boolean;
var I: Integer;
    Bt: TKOLToolbarButton;
begin
  Result := TRUE;
  for I := Idx to Items.Count - 1 do
  begin
    Bt := Items[ I ];
    if Bt.HasPicture or (Bt.sysimg <> stiCustom) then
    begin
      Result := FALSE;
      break;
    end;
  end;
end;

function TKOLToolbar.PicturedButtonsCount: Integer;
var I: Integer;
    Bt: TKOLToolbarButton;
begin
  Result := 0;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if Bt.HasPicture then
      Inc( Result );
  end;
  //Rpt( '%%%%%%%%% PicturedButtonsCount := ' + IntToStr( Result ) );
end;

procedure TKOLToolbar.SaveButtonCount(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.SaveButtonCount', 0
  @@e_signature:
  end;
  FButtonCount := FItems.Count;
  //ShowMessage( 'saved FButtonCount=' + IntToStr( FButtonCount ) );
  W.WriteInteger( FButtonCount );
end;

procedure TKOLToolbar.Setbitmap(const Value: TBitmap);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.Setbitmap', 0
  @@e_signature:
  end;
  if Value <> nil then
    Fbitmap.Assign( Value )
  else
  begin
    Fbitmap.Width := 0;
    Fbitmap.Height := 0;
  end;
  if not (csLoading in ComponentState) then
    bitmap2ItemPictures( TRUE );
  if Assigned(FKOLCtrl) then
    RecreateWnd;
  Change;
end;

procedure TKOLToolbar.SetBtnCount_Dummy(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.SetBtnCount_Dummy', 0
  @@e_signature:
  end;
  //FButtonCount := Value;
end;

procedure TKOLToolbar.SetbuttonMaxWidth(const Value: Integer);
begin
  FbuttonMaxWidth := Value;
  Change;
end;

procedure TKOLToolbar.SetbuttonMinWidth(const Value: Integer);
begin
  FbuttonMinWidth := Value;
  Change;
end;

procedure TKOLToolbar.SetgenerateConstants(const Value: Boolean);
begin
  FgenerateConstants := Value;
  Change;
end;

procedure TKOLToolbar.SetmapBitmapColors(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.SetmapBitmapColors', 0
  @@e_signature:
  end;
  if Value = FmapBitmapColors then Exit;
  FmapBitmapColors := Value;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
  Change;
end;

procedure TKOLToolbar.SetnoTextLabels(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.SetnoTextLabels', 0
  @@e_signature:
  end;
  FnoTextLabels := Value;
  UpdateButtons;
  Change;
end;

procedure TKOLToolbar.SetOptions(const Value: TToolbarOptions);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.SetOptions', 0
  @@e_signature:
  end;
  FOptions := Value;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
  Change;
end;

procedure TKOLToolbar.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLToolbar.SetshowTooltips(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.SetshowTooltips', 0
  @@e_signature:
  end;
  FshowTooltips := Value;
  Change;
end;

procedure TKOLToolbar.SetStandardImagesLarge(const Value: Boolean);
begin
  FStandardImagesLarge := Value;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
  Change;
end;

procedure TKOLToolbar.Settooltips(const Value: TStrings);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.Settooltips', 0
  @@e_signature:
  end;
  Ftooltips.Text := Value.Text;
  Change;
end;

procedure TKOLToolbar.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var RsrcFile, RsrcName: String;
    S, B: String;
    I, J, K, W, H, N, I0: Integer;
    ResBmpID: Integer;
    Bmp: TBitmap;
    Bt, Bt1: TKOLToolbarButton;
    Btn1st: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.SetupFirst', 0
  @@e_signature:
  end;
  ResBmpID := -1;
  RsrcName := '';
  H := MaxBtnImgHeight;
  W := MaxBtnImgWidth;
  if W * H > 0 then
  begin
    ResBmpID := ParentKOLForm.NextUniqueID;
    RsrcName := UpperCase( ParentKOLForm.FormName ) + '_TBBMP' +  IntToStr( ResBmpID );
    RsrcFile := ParentKOLForm.FormName + '_' + Name;
    SL.Add( Prefix + '  {$R ' + RsrcFile + '.res}' );
    Bmp := TBitmap.Create;
    TRY
      N := 0;
      FBmpTranColor := clNone;
      for I := 0 to Items.Count-1 do
      begin
        Bt := Items[ I ];
        if Bt.HasPicture then
        begin
          if FBmpTranColor = clNone then
          begin
            Bmp.Assign( Bt.picture );
            FBmpTranColor := Bmp.Canvas.Pixels[ 0, Bmp.Height - 1 ];
          end;
          Inc( N );
        end;
      end;
      Bmp.Width := N * W;
      Bmp.Height := H;
      {$IFNDEF _D2}
      Bmp.PixelFormat := pf24bit;
      {$ENDIF}
      if FBmpTranColor <> clNone then
      begin
        Bmp.Canvas.Brush.Color := FBmpTranColor;
        Bmp.Canvas.FillRect( Rect( 0, 0, Bmp.Width, Bmp.Height ) );
      end;
      N := 0;
      for I := 0 to Items.Count-1 do
      begin
        Bt := Items[ I ];
        if Bt.HasPicture then
        begin
          Bmp.Canvas.Draw( N * W, 0, Bt.picture.Graphic );
          Inc( N );
        end;
      end;
      GenerateBitmapResource( Bmp, RsrcName, RsrcFile, fUpdated );
    FINALLY
      Bmp.Free;
    END;
  end;
  if HeightAuto then
  begin
    DefaultHeight := Height;
    DefaultWidth := Width;
  end
    else
  begin
    if Align in [ caTop, caBottom, caNone ] then
    begin
      DefaultHeight := 22;
      DefaultWidth := Width;
    end
      else
    if Align in [ caLeft, caRight ] then
    begin
      DefaultHeight := Height;
      DefaultWidth := 44;
    end
      else
    begin
      DefaultHeight := Height;
      DefaultWidth := Width;
    end;
  end;
  inherited;
  FResBmpID := ResBmpID;
  if Assigned( bitmap ) and (bitmap.Width * bitmap.Height > 0) then
  begin
    W := MaxBtnImgWidth;
    H := MaxBtnImgHeight;
    if (W <> H) or (StandardImagesUsed > 0) then
    begin
      SL.Add( '  ' + Prefix + AName + '.TBBtnImgWidth := ' + IntToStr( W ) + ';' );
      S := '  ' + Prefix + AName + '.TBAddBitmap( ';
      if mapBitmapColors then
        S := S + 'LoadMappedBitmapEx( ' + AName + ', hInstance, ''' + RsrcName + ''', [ ' +
                  Color2Str( FBmpTranColor ) + ', Color2RGB( clBtnFace ) ] ) );'
      else
        S := S + 'LoadBmp( hInstance, ''' + RsrcName + ''', ' +
                 AName + ' ) );';
      SL.Add( S );
    end;
  end;
  if TBButtonsWidth > 0 then
    SL.Add( '  ' + Prefix + AName + '.Perform( TB_SETBUTTONSIZE, ' +
      Int2Str( TBButtonsWidth ) + ', 0 );' );
  if ((StandardImagesUsed > 0) and (PicturedButtonsCount > 0)) or
     not IntIn(StandardImagesUsed, [ 1, 2, 4 ]) then
  begin
    if LongBool( StandardImagesUsed and 1 ) then
    begin
      if StandardImagesLarge then
        S := '-2'
      else
        S := '-1';
      SL.Add( '  ' + Prefix + AName + '.TBAddBitmap( THandle( ' + S + ' ) );' );
    end;
    if LongBool( StandardImagesUsed and 2 ) then
    begin
      if StandardImagesLarge then
        S := '-6'
      else
        S := '-5';
      SL.Add( '  ' + Prefix + AName + '.TBAddBitmap( THandle( ' + S + ' ) );' );
    end;
    if LongBool( StandardImagesUsed and 4 ) then
    begin
      if StandardImagesLarge then
        S := '-10'
      else
        S := '-9';
      SL.Add( '  ' + Prefix + AName + '.TBAddBitmap( THandle( ' + S + ' ) );' );
    end;
  end;

  if showTooltips or (tooltips.Count > 0) then
  begin
    S := '';
    J := 0;
    for I := 0 to Items.Count-1 do
    begin
      Bt := Items[ I ];
      //if Bt.Faction <> nil then continue; // remove by YS 7-Aug-2004
      //if Bt.separator then continue;

      //---------{ Maxim Pushkar }----------------------------------------------
      //if (tooltips.Count > 0) and (J > tooltips.Count) then break;
      //----------------------------------------------------------------------//
      if (tooltips.Count > 0) and (J >= tooltips.Count) then break;          //
      //--------------------------------------------------------------------//

      if Bt.Tooltip <> '' then
        B := Bt.Tooltip
      else
      if (tooltips.Count > 0) and (tooltips[ J ] <> '') and not Bt.separator then
        B := tooltips[ J ]
      else
      if showTooltips then
        B := Bt.Caption
      else
        B := '';
      if Bt.Faction = nil then                     // {YS} ‰Ó·‡‚ËÚ¸
      begin                                        // {YS} ‰Ó·‡‚ËÚ¸
        if not Bt.separator then                   // {YS} ‰Ó·‡‚ËÚ¸
        begin
          if S <> '' then
            S := S + ', ';
          S := S + PCharStringConstant( Self, Bt.Name + '_tip', B );
        end
          else
        //+++++++ v1.94
        begin
          if S <> '' then
            S := S + ', '''''
          else
            S := S + '''''';
        end;
        //------
      end                                          // {YS} ‰Ó·‡‚ËÚ¸
      else                                         // {YS} ‰Ó·‡‚ËÚ¸
       Inc( J );
    end;
    // change by Alexander Pravdin (to fix tooltips for case of first separator):
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    Btn1st := 0;
    {for i := 0 to ButtonCount - 1 do
      if not TKOLToolbarButton( FItems.Items[i] ).Fseparator then begin
        Btn1st := i;
        Break;
      end;}
    if S <> '' then
        SL.Add( Prefix + '  ' + AName + '.TBSetTooltips( ' + AName +
          '.TBIndex2Item( ' + IntToStr( Btn1st ) + ' ), [ ' + S + ' ] );' );
    //--------------------------------------------------------------------------
    {if S <> '' then
      SL.Add( Prefix + '  ' + AName + '.TBSetTooltips( ' + AName +
              '.TBIndex2Item( 0 ), [ ' + S + ' ] );' );}
    ////////////////////////////////////////////////////////////////////////////
  end;

  // assign image list if used:
  if ImageListNormal <> nil then
  begin
    SL.Add( Prefix + ' ' + AName + '.Perform( TB_SETIMAGELIST, 0, Result.' +
            ImageListNormal.Name + '.Handle );' );
  end;
  if ImageListDisabled <> nil then
  begin
    SL.Add( Prefix + ' ' + AName + '.Perform( TB_SETDISABLEDIMAGELIST, 0, Result.' +
            ImageListDisabled.Name + '.Handle );' );
  end;
  if ImageListHot <> nil then
  begin
    SL.Add( Prefix + ' ' + AName + '.Perform( TB_SETHOTIMAGELIST, 0, Result.' +
            ImageListHot.Name + '.Handle );' );
  end;

  I0 := -1;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    Inc( I0 );
    //if Bt.separator then Continue;
    if Bt.fOnClickMethodName <> '' then
    begin
      S := '';
      for J := I to Items.Count - 1 do
      begin
        Bt := Items[ J ];
        //if Bt.separator then Continue;
        if Bt.separator or (Bt.fOnClickMethodName = '') then
        begin
          N := 0;
          for K := J to Items.Count-1 do
          begin
            Bt1 := Items[ K ];
            if Bt1.separator then Continue;
            if Bt1.fOnClickMethodName <> '' then
            begin
              Inc( N );
              break;
            end;
          end;
          if N = 0 then break;
        end;
        if S <> '' then S := S + ', ';
        if Bt.fOnClickMethodName <> '' then
          S := S + 'Result.' + Bt.fOnClickMethodName
        else
          S := S + 'nil';
      end;
      SL.Add( '  ' + Prefix + AName + '.TBAssignEvents( ' + IntToStr( I0 ) +
              ', [ ' + S + ' ] );' );
      break;
    end;
  end;
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );
  if TBButtonsMinWidth > 0 then
    SL.Add( Prefix + AName + '.TBButtonsMinWidth := ' + IntToStr( TBButtonsMinWidth ) + ';' );
  if TBButtonsMaxWidth > 0 then
    SL.Add( Prefix + AName + '.TBButtonsMaxWidth := ' + IntToStr( TBButtonsMaxWidth ) + ';' );
  for I := Items.Count-1 downto 0 do
  begin
    Bt := Items[ I ];
    if not Bt.visible and (Bt.Faction = nil) then
      SL.Add( Prefix + AName + '.TBButtonVisible[ ' + IntToStr( I ) + ' ] := FALSE;' );
    {if Bt.Checked and (Bt.Faction = nil) then
      SL.Add( Prefix + AName + '.TBButtonChecked[ ' + IntToStr( I ) + ' ] := TRUE;' );}
    if not Bt.enabled and (Bt.Faction = nil) then
      SL.Add( Prefix + AName + '.TBButtonEnabled[ ' + IntToStr( I ) + ' ] := FALSE;' );
  end;

  if FixFlatXP then
  if (tboFlat in Options) and (Parent <> nil) and not(Parent is TForm) then
  begin
    if Align in [ caLeft, caRight ] then
    begin
      SL.Add( Prefix + '  ' + AName + '.Style := ' + AName +
        '.Style or TBSTYLE_WRAPABLE;' );
    end
      else
    begin
      SL.Add( Prefix + 'if WinVer >= wvXP then' );
      SL.Add( Prefix + 'begin' );
      SL.Add( Prefix + '  ' + AName + '.Style := ' + AName +
        '.Style or TBSTYLE_WRAPABLE;' );
      SL.Add( Prefix + '  ' + AName + '.Transparent := TRUE;' );
      SL.Add( Prefix + 'end;' );
    end;
  end;
end;

function TKOLToolbar.SetupParams(const AName, AParent: String): String;
var S, A: String;
    B: String;
    I, N: Integer;
    Bt, Bt1: TKOLToolbarButton;
    StdImagesStart, ViewImagesStart, HistImagesStart: Integer;
    TheSameBefore, TheSameAfter: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.SetupParams', 0
  @@e_signature:
  end;
  // 1. Options parameter
  S := '';
  if (tboTextRight in Options) or
      FixFlatXP and {(Align in [caLeft, caRight]) and} (tboFlat in Options) then
    S := 'tboTextRight';
  if (tboTextBottom in Options) and (S = '') then
    S := S + ', tboTextBottom';
  if tboFlat in Options then
    S := S + ', tboFlat';
  if tboTransparent in Options then
    S := S + ', tboTransparent';
  if (tboWrapable in Options) and not( FixFlatXP and (Align in [caLeft, caRight]) and
     (tboFlat in Options) )
     {or
     ( (tboFlat in Options) and not (Align in [caLeft, caRight] ) and FixFlatXP )} then
    S := S + ', tboWrapable';
  if tboNoDivider in Options then
    S := S + ', tboNoDivider';
  if tbo3DBorder in Options then
    S := S + ', tbo3DBorder';
  if S <> '' then
  if S[ 1 ] = ',' then
    S := Trim( Copy( S, 2, MaxInt ) );

  // 2. Align parameter
  case Align of
    caLeft: A := 'caLeft';
    caRight:A := 'caRight';
    caClient: A := 'caClient';
    caTop: A := 'caTop';
    caBottom: A := 'caBottom';
    else A := 'caNone';
  end;
  Result := AParent + ', ' + A + ', [' + S + '], ';

  // 3. Bitmap from a resource
  if (Bitmap.Width > 0) and (Bitmap.Height > 0) and
     (FResBmpID >= 0) and (MaxBtnImgWidth = MaxBtnImgHeight) and
     (StandardImagesUsed=0) then
  begin
    if mapBitmapColors then
      Result := Result + 'LoadMappedBitmapEx( Result, hInstance, ''' +
                UpperCase( ParentKOLForm.FormName ) + '_TBBMP' + IntToStr( FResBmpID ) + ''', [ ' +
                Color2Str( FBmpTranColor ) + ', Color2RGB( clBtnFace ) ] ), '
    else
      Result := Result + 'LoadBmp( hInstance, PChar( ''' +
                UpperCase( ParentKOLForm.FormName ) + '_TBBMP' + IntToStr( FResBmpID ) +
                ''' ), Result ), ';
  end
    else // or if standard images are used, type of images here
  if (PicturedButtonsCount = 0) and (IntIn( StandardImagesUsed, [ 1, 2, 4 ] )) then
  begin
    if StandardImagesUsed = 1 then
      if StandardImagesLarge then
        Result := Result + 'THandle( -2 ), '
      else
        Result := Result + 'THandle( -1 ), '
    else
    if StandardImagesUsed = 2 then
      if StandardImagesLarge then
        Result := Result + 'THandle( -6 ), '
      else
        Result := Result + 'THandle( -5 ), '
    else
      if StandardImagesLarge then
        Result := Result + 'THandle( -10 ), '
      else
        Result := Result + 'THandle( -9 ), ';
  end
    else
  begin // or if Bitmap is empty, value 0
    if not ((Bitmap.Width > 0) and (Bitmap.Height > 0) and
     (FResBmpID >= 0)) then
      FResBmpID := 0;
    Result := Result + '0, ';
  end;

  // 4. Button captions
  Result := Result + '[ ';

  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if Bt.separator then
      Result := Result + '''-'''
    else
    begin
      if noTextLabels then
        B := ' '
      else
        B := Bt.Fcaption;
      S := '';
      if Bt.radioGroup <> 0 then
      begin
        TheSameBefore := FALSE;
        TheSameAfter := FALSE;
        if I > 0 then
        begin
          Bt1 := Items[ I - 1 ];
          if not Bt1.separator and (Bt1.FradioGroup = Bt.FradioGroup) then
            TheSameBefore := TRUE;
        end;
        if I < Items.Count-1 then
        begin
          Bt1 := Items[ I + 1 ];
          if not Bt1.separator and (Bt1.FradioGroup = Bt.FradioGroup) then
            TheSameAfter := TRUE;
        end;
        if TheSameBefore or TheSameAfter then
          S := '!' + S;
      end;
      if Bt.checked and (Bt.Faction = nil) then
        S := '+' + S
      else
      if Bt.radioGroup <> 0 then
        S := '-' + S;
      if Bt.dropdown then
        S := '^' + S;
      if noTextLabels then
        Result := Result + '''' + S + B + ''''
      else
      if Bt.Faction <> nil then
        Result := Result + '''' + S + '  '''
      else
      begin
        B := StringConstant( Bt.Name + '_btn', B );
        if (B <> '') and (B[ 1 ] = '''') then
          Result := Result + '''' + S + Copy( B, 2, MaxInt )
        else
        if S <> '' then
          Result := Result + 'PChar( ''' + S + ''' + ' + B + ')'
        else
          Result := Result + 'PChar( ' + B + ' )';
      end;
    end;
    if I < Items.Count-1 then
      Result := Result  + ', ';
  end;
  Result := Result + ' ], ';

  // 5. Button image indexes used
  //Rpt( '$$$$$$$$$$$$$$$ PicturedButtonsCount := ' + IntToStr( PicturedButtonsCount ) );
  if (StandardImagesUsed = 0) and (PicturedButtonsCount = 0) and not ImageListsUsed then
    Result := Result + '[ -2 ]' else
  if (StandardImagesUsed = 0) and AllPicturedButtonsAreLeading and
     LastBtnHasPicture and not ImageListsUsed then
    Result := Result + '[ 0 ]' else
  begin
    N := PicturedButtonsCount;
    Result := Result + '[ ';
    StdImagesStart := N;
    ViewImagesStart := N;
    HistImagesStart := N;
    if (StandardImagesUsed > 1) and LongBool(StandardImagesUsed and 1) then
    begin
      ViewImagesStart := N + 15;
      HistImagesStart := N + 15;
    end;
    if LongBool(StandardImagesUsed and 2) then
      HistImagesStart := HistImagesStart + 12;
    N := 0;
    S := '';
    for I := 0 to Items.Count-1 do
    begin
      Bt := Items[ I ];
      //Rpt( '%%%%%%%%%% Bt ' + Bt.Name + ' HasPicture := ' + IntToStr( Integer( Bt.HasPicture ) ) );
      if ImageListsUsed then
      begin
        if Bt.imgIndex >= 0 then
          S := IntToStr( Bt.imgIndex )
        else
          S := '-2';
      end
      else
      if Bt.HasPicture then
      begin
        S := IntToStr( N );
        Inc( N );
      end
        else
      case Bt.sysimg of
      stiCustom:
        S := '-2'; // I_IMAGENONE
      stdCUT..stdPRINT:
        S := IntToStr( StdImagesStart + Ord( Bt.sysimg ) - Ord( stdCUT ) );
      viewLARGEICONS..viewVIEWMENU:
        S := IntToStr( ViewImagesStart + Ord( Bt.sysimg ) - Ord( viewLARGEICONS ) );
      else
        S := IntToStr( HistImagesStart + Ord( Bt.sysimg ) - Ord( histBACK ) );
      end;
      Result := Result + S + ', ';
    end;
    if Items.Count > 0 then
      Result := Copy( Result, 1, Length( Result ) - 2 ) + ' ]'
    else
      Result := Result + ']';
  end;
end;

var LastToolbarWarningtime: Integer;
procedure ToolbarBetterToPlaceOverPanelWarning;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'ToolbarBetterToPlaceOverPanelWarning', 0
  @@e_signature:
  end;
  if Abs( Integer( GetTickCount ) - LastToolbarWarningtime ) > 60000 then
  begin
    LastToolbarWarningtime := GetTickCount;
    {ShowMessage( 'It is better to place toolbar on a panel aligning it caClient.'#13 +
                 'This can improve performance of the application, especially in ' +
                 'Windows 9x/Me.' );}
  end;
end;

function TKOLToolbar.StandardImagesUsed: Integer;
var I: Integer;
    Bt: TKOLToolbarButton;
begin
  Result := 0;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if Bt.sysimg <> stiCustom then
    begin
      if Bt.sysimg in [ stdCUT..stdPRINT ] then
        Result := Result or 1
      else
      if Bt.sysimg in [ viewLARGEICONS..viewVIEWMENU ] then
        Result := Result or 2
      else
        Result := Result or 4;
      if Result = 7 then break;
    end;
  end;
end;

procedure TKOLToolbar.Tick(Sender: TObject);
var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.Tick', 0
  @@e_signature:
  end;
  if Parent <> nil then
  begin
    FTimer.Enabled := FALSE;
    if Parent = Owner then
      ToolbarBetterToPlaceOverPanelWarning;
    //ParentKOLForm.AlignChildren( nil );
    if Parent is TKOLCustomControl then
      (Parent as TKOLCustomControl).ReAlign( FALSE )
    else
    begin
      KF := ParentKOLForm;
      if KF <> nil then
        KF.AlignChildren( nil, FALSE );
    end;
    FTimer.Free;
    FTimer := nil;
  end;
end;

procedure TKOLToolbar.ReadNewVersion(Reader: TReader);
begin
  fNewVersion := Reader.ReadBoolean;
end;

procedure TKOLToolbar.WriteNewVersion(Writer: TWriter);
begin
  Writer.WriteBoolean( fNewVersion );
end;

function TKOLToolbar.Generate_SetSize: String;
begin
  Result := inherited Generate_SetSize;
end;

procedure TKOLToolbar.SetAutoHeight(const Value: Boolean);
begin
  FHeightAuto := Value;
  Change;
end;

procedure TKOLToolbar.CreateKOLControl(Recreating: boolean);
var
  al: kol.TControlAlign;
  bmp: HBITMAP;
begin
  if Recreating then begin
    al:=kol.TControlAlign(Align);
    //bmp:=bitmap.Handle;
    bmp := 0;
  end
  else begin
    al:=kol.caTop;
    bmp:=0;
  end;
  TRY
    FKOLCtrl:=NewToolbar(KOLParentCtrl, al, kol.TToolbarOptions(FOptions), bmp, [nil], [-2]);
    FKOLCtrl.Visible:=False;
  EXCEPT
    on E: Exception do
    begin
      ShowMessage( 'Error: ' + E.Message );
    end;
  END;
end;

procedure TKOLToolbar.KOLControlRecreated;
var
  N: integer;
  TmpBmp, TmpBmp2: TBitmap;
begin
  inherited;
  if ImageListsUsed then
  begin
    if ImageListNormal <> nil then
      FKOLCtrl.Perform( TB_SETIMAGELIST, 0, ImageListNormal.Handle );
    if ImageListDisabled <> nil then
      FKOLCtrl.Perform( TB_SETDISABLEDIMAGELIST, 0, ImageListDisabled.Handle );
    if ImageListHot <> nil then
      FKOLCtrl.Perform( TB_SETHOTIMAGELIST, 0, ImageListHot.Handle );
  end
    else
  begin
    if StandardImagesUsed > 0 then begin
      if StandardImagesLarge then
        N:=1
      else
        N:=0;
      FKOLCtrl.TBAddBitmap(HBITMAP(-1-N));
      FKOLCtrl.TBAddBitmap(HBITMAP(-5-N));
      FKOLCtrl.TBAddBitmap(HBITMAP(-9-N));
    end;
    if (Bitmap <> nil) and not Bitmap.Empty then
    begin
      if mapBitmapColors then
      begin
        TmpBmp := TBitmap.Create;
        TRY
          TmpBmp.Canvas.Brush.Color := clBtnFace;
          TmpBmp.Width := Bitmap.Width;
          TmpBmp.Height := Bitmap.Height;
          {$IFDEF _D3orHigher}
          Bitmap.Transparent := TRUE;
          {$ENDIF}
          //Bitmap.TransparentColor := Bitmap.Canvas.Pixels[ 0, Bitmap.Height-1 ];
          TmpBmp.Canvas.Draw( 0, 0, Bitmap );
          {$IFDEF _D3orHigher}
          Bitmap.Transparent := FALSE;
          {$ENDIF}
          FBmpDesign := //CopyImage( TmpBmp.Handle, IMAGE_BITMAP, 0, 0, 0 {LR_CREATEDIBSECTION} );
                     TmpBmp.ReleaseHandle;
        FINALLY
          TmpBmp.Free;
        END;
      end
        else
      begin
        FBmpDesign := CopyImage( Bitmap.Handle, IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION );
      end;

      if mapBitmapColors then
      begin
        TmpBmp := TBitmap.Create;
        TmpBmp2 := TBitmap.Create;
        TRY
          TmpBmp.Handle := FBmpDesign;
          TmpBmp2.Canvas.Brush.Color := clBtnFace;
          TmpBmp2.Width := TmpBmp.Width;
          TmpBmp2.Height := TmpBmp.Height;
          {$IFDEF _D3orHigher}
          TmpBmp.Transparent := TRUE;
          {$ENDIF}
          TmpBmp2.Canvas.Draw( 0, 0, TmpBmp );
          FBmpDesign := TmpBmp2.ReleaseHandle;
        FINALLY
          TmpBmp.Free;
          TmpBmp2.Free;
        END;
      end;
      FKOLCtrl.TBAddBitmap( FBmpDesign );
    end;
  end;
  UpdateButtons;
  ReAlign(True);
end;

function TKOLToolbar.NoDrawFrame: Boolean;
begin
  Result:=HasBorder;
end;

procedure TKOLToolbar.UpdateButtons;

  procedure GenerateButtons{(var Captions: array of string; var PCaptions: array of PChar; var ImgIndices: array of integer)};
  var
    i, N, StdImagesStart, ViewImagesStart, HistImagesStart: integer;
    s: string;
    ii: Integer;
    Bt: TKOLToolbarButton;
  begin
    if FItems.Count = 0 then exit;
    {if PicturedButtonsCount > 0 then
      N := FItems.Count
    else
      N:=0;}
    StdImagesStart := 0;
    ViewImagesStart := 15;
    HistImagesStart := 15 + 12;
    N := 0;
    if StandardImagesUsed > 0 then
    N := 15 + 12 + 5;
    for i:=0 to FItems.Count - 1 do
      with TKOLToolbarButton(FItems[i]) do begin
        if noTextLabels then
          s:=' '
        else
          s:=caption;
        if checked then
          S := '+' + S
        else
        if radioGroup <> 0 then
          S := '-' + S;
        if dropdown then
          S := '^' + S;
        {Captions[i]:=s;
        PCaptions[i]:=PChar(Captions[i]);}
        Bt := Items[ i ];
        if ImageListsUsed then
        begin
          ii := Bt.imgIndex;
          if ii < 0 then ii := -2;
        end
        else
        if HasPicture then begin
          ii {ImgIndices[i]} := N + i;
        end
        else
          case sysimg of
            stiCustom:
              ii {ImgIndices[i]} := -2; // I_IMAGENONE
            stdCUT..stdPRINT:
              ii {ImgIndices[i]} := StdImagesStart + Ord( sysimg ) - Ord( stdCUT );
            viewLARGEICONS..viewVIEWMENU:
              ii {ImgIndices[i]} := ViewImagesStart + Ord( sysimg ) - Ord( viewLARGEICONS );
            else
              ii {ImgIndices[i]} := HistImagesStart + Ord( sysimg ) - Ord( histBACK );
          end;
        FKOLCtrl.TBAddButtons( [ PChar( S ) ], [ ii ] );
      end;
  end;

var
  {capts: array of string;
  pcapts: array of PChar;
  imgs: array of integer;}
  i: integer;

begin
  if not Assigned(FKOLCtrl) then exit;
  while FKOLCtrl.TBButtonCount > 0 do
    FKOLCtrl.TBDeleteButton(0);

  if FItems.Count > 0 then begin
    {SetLength(capts, FItems.Count);
    SetLength(pcapts, FItems.Count);
    SetLength(imgs, FItems.Count);}
    GenerateButtons{(capts, pcapts, imgs)};
    //FKOLCtrl.TBAddButtons(pcapts, imgs);
    for i:=0 to FItems.Count - 1 do
      with TKOLToolbarButton(FItems[i]) do begin
        if not enabled then
          FKOLCtrl.TBButtonEnabled[i]:=False;
      end;
  end;
end;

procedure TKOLToolbar.SetMargin(const Value: Integer);
begin
  inherited;
  if Assigned(FKOLCtrl) then
    FKOLCtrl.Perform( TB_SETINDENT, Border, 0 );
end;

procedure TKOLToolbar.CMDesignHitTest(var Message: TCMDesignHitTest);
var
  pt: TPoint;
  res: integer;
begin
  if Assigned(FKOLCtrl) and (PaintType in [ptWYSIWIG, ptWYSIWIGFrames]) then begin
    Message.Result:=0;
    pt:=SmallPointToPoint(Message.Pos);
    res:=FKOLCtrl.Perform(WM_USER + 69 {TB_HITTEST}, 0, integer(@pt));
    if Abs(res) <= FKOLCtrl.TBButtonCount then
      Message.Result:=1;
  end
  else
    inherited;
end;

procedure TKOLToolbar.WMLButtonDown(var Message: TWMLButtonDown);
var
  pt: TPoint;
  res: integer;
  F: TForm;
  D: IDesigner;
  FD: IFormDesigner;
begin
  if Assigned(FKOLCtrl) then begin
    pt:=SmallPointToPoint(Message.Pos);
    res:=FKOLCtrl.Perform(WM_USER + 69 {TB_HITTEST}, 0, integer(@pt));
    if res < 0 then
      res:=-res - 1;
    if res < FItems.Count then begin
      F := Owner as TForm;
      if F <> nil then begin
  //*///////////////////////////////////////////////////////
    {$IFDEF _D6orHigher}                                  //
          F.Designer.QueryInterface(IFormDesigner,D);     //
    {$ELSE}                                               //
  //*///////////////////////////////////////////////////////
          D := F.Designer;
  //*///////////////////////////////////////////////////////
    {$ENDIF}                                              //
  //*///////////////////////////////////////////////////////
        if (D <> nil) and QueryFormDesigner( D, FD ) then begin
          FD.SelectComponent( FItems[res] );
        end;
      end;
    end;
  end
  else
    inherited;
end;

procedure TKOLToolbar.WMMouseMove(var Message: TWMMouseMove);
begin
end;

procedure TKOLToolbar.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
end;

procedure TKOLToolbar.Paint;
var
  i: integer;
  R: TRect;
begin
  inherited;
  if Assigned(FKOLCtrl) and (PaintType in [ptWYSIWIG, ptWYSIWIGFrames]) then
    with Canvas do begin
      Brush.Style:=bsClear;
      Pen.Color:=clBtnShadow;
      Pen.Style:=psDot;
      for i:=0 to FItems.Count - 1 do
      with TKOLToolbarButton(FItems[i]) do begin
        if checked or (not separator and not (tboFlat in Options)) then continue;
        FKOLCtrl.Perform( TB_GETITEMRECT, i, Integer( @R ) );
        if separator then
          Windows.Rectangle( Handle, R.Left, R.Top, R.Right, R.Bottom )
        else
          DrawEdge(Handle, R, BDR_RAISEDINNER, BF_RECT);
      end;
      Pen.Style:=psSolid;
      Brush.Style:=bsSolid;
    end;
end;

function TKOLToolbar.GetDefaultControlFont: HFONT;
begin
  Result:=GetStockObject(DEFAULT_GUI_FONT);
end;

procedure TKOLToolbar.SetimageList(const Value: TKOLImageList);
  procedure RemoveOldImageList;
  begin
    if FImageListNormal <> nil then
      FImageListNormal.NotifyLinkedComponent( Self, noRemoved );
    FImageListNormal := nil;
  end;

var I: Integer;
    Bt: TKOLToolbarButton;
begin
  if (Value <> nil) and (Value is TKOLImageList) then
  begin
    if ImagedButtonsCount > 0 then
    begin
      I := MessageBox( Application.Handle, 'Some buttons have pictures assigned.'#13#10 +
        'All pictures will be removed. Continue assigning image list to a toolbar?',
        PChar( Application.Title + ' : ' + Name ), MB_OKCANCEL );
      if I <> ID_OK then Exit;
      for I := 0 to Items.Count-1 do
      begin
        Bt := Items[ I ];
        if Bt.HasPicture then
          Bt.picture := nil
        else
        if Bt.sysimg <> stiCustom then
          Bt.sysimg := stiCustom;
        if Bt.Fseparator then
          Bt.FimgIndex := -1;
      end;
    end;
    RemoveOldImageList;
    Value.AddToNotifyList( Self );
  end
    else
    RemoveOldImageList;
  FImageListNormal := Value;
  if Value <> nil then
  if FKOLCtrl <> nil then
  begin
    //ShowMessage( 'ImageListNormal.Handle=' + Int2Str( Value.Handle ) );
    FKOLCtrl.Perform( TB_SETIMAGELIST, 0, FImageListNormal.Handle );
    UpdateButtons;
  end;
  Change;
end;

procedure TKOLToolbar.NotifyLinkedComponent(Sender: TObject;
  Operation: TNotifyOperation);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.NotifyLinkedComponent', 0
  @@e_signature:
  end;
  inherited;
  if Operation = noRemoved then
  begin
    if Sender = ImageListNormal then
      ImageListNormal := nil
    else
    if Sender = ImageListDisabled then
      ImageListDisabled := nil
    else
    if Sender = ImageListHot then
      ImageListHot := nil
    else
      ShowMessage( 'Could not remove a reference to image list !' );
  end;
end;

function TKOLToolbar.ImagedButtonsCount: Integer;
var I: Integer;
    Bt: TKOLToolbarButton;
begin
  Result := 0;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if Bt.HasPicture or (Bt.sysimg <> stiCustom) then
      Inc( Result );
  end;
end;

function TKOLToolbar.MaxImgIndex: Integer;
var I: Integer;
    Bt: TKOLToolbarButton;
begin
  Result := 0;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if Bt.FimgIndex >= Result then
      Result := Bt.FimgIndex + 1;
  end;
end;

procedure TKOLToolbar.SetDisabledimageList(const Value: TKOLImageList);
  procedure RemoveOldImageList;
  begin
    if FimageListDisabled <> nil then
      FimageListDisabled.NotifyLinkedComponent( Self, noRemoved );
    FimageListDisabled := nil;
  end;

var I: Integer;
    Bt: TKOLToolbarButton;
begin
  if (Value <> nil) and (Value is TKOLImageList) then
  begin
    if ImagedButtonsCount > 0 then
    begin
      I := MessageBox( Application.Handle, 'Some buttons have pictures assigned.'#13#10 +
        'All pictures will be removed. Continue assigning image list to a toolbar?',
        PChar( Application.Title + ' : ' + Name ), MB_OKCANCEL );
      if I <> ID_OK then Exit;
      for I := 0 to Items.Count-1 do
      begin
        Bt := Items[ I ];
        if Bt.HasPicture then
          Bt.picture := nil
        else
        if Bt.sysimg <> stiCustom then
          Bt.sysimg := stiCustom;
        if Bt.Fseparator then
          Bt.FimgIndex := -1;
      end;
    end;
    RemoveOldImageList;
    Value.AddToNotifyList( Self );
  end
    else
    RemoveOldImageList;
  FimageListDisabled := Value;
  if Value <> nil then
  if FKOLCtrl <> nil then
  begin
    FKOLCtrl.Perform( TB_SETDISABLEDIMAGELIST, 0, FimageListDisabled.Handle );
    UpdateButtons;
  end;
  Change;
end;

procedure TKOLToolbar.SetHotimageList(const Value: TKOLImageList);
  procedure RemoveOldImageList;
  begin
    if FImageListHot <> nil then
      FImageListHot.NotifyLinkedComponent( Self, noRemoved );
    FImageListHot := nil;
  end;

var I: Integer;
    Bt: TKOLToolbarButton;
begin
  if (Value <> nil) and (Value is TKOLImageList) then
  begin
    if ImagedButtonsCount > 0 then
    begin
      I := MessageBox( Application.Handle, 'Some buttons have pictures assigned.'#13#10 +
        'All pictures will be removed. Continue assigning image list to a toolbar?',
        PChar( Application.Title + ' : ' + Name ), MB_OKCANCEL );
      if I <> ID_OK then Exit;
      for I := 0 to Items.Count-1 do
      begin
        Bt := Items[ I ];
        if Bt.HasPicture then
          Bt.picture := nil
        else
        if Bt.sysimg <> stiCustom then
          Bt.sysimg := stiCustom;
        if Bt.Fseparator then
          Bt.FimgIndex := -1;
      end;
    end;
    RemoveOldImageList;
    Value.AddToNotifyList( Self );
  end
    else
    RemoveOldImageList;
  FImageListHot := Value;
  if Value <> nil then
  if FKOLCtrl <> nil then
  begin
    FKOLCtrl.Perform( TB_SETHOTIMAGELIST, 0, FimageListHot.Handle );
    UpdateButtons;
  end;
  Change;
end;

function TKOLToolbar.ImageListsUsed: Boolean;
begin
  Result := (ImageListNormal <> nil) or (ImageListDisabled <> nil) or
         (ImageListHot <> nil);
end;

procedure TKOLToolbar.SetFixFlatXP(const Value: Boolean);
begin
  FFixFlatXP := Value;
  Change;
end;

procedure TKOLToolbar.SetTBButtonsWidth(const Value: Integer);
begin
  FTBButtonsWidth := Value;
  Change;
end;

{ TKOLToolbarButtonsEditor }

procedure TKOLToolbarButtonsEditor.Edit;
var Tb: TKOLToolbar;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButtonsEditor.Edit', 0
  @@e_signature:
  end;
  if GetComponent( 0 ) = nil then Exit;
  Tb := GetComponent( 0 ) as TKOLToolbar;
  if Tb.ActiveDesign = nil then
    Tb.ActiveDesign := TfmToolbarEditor.Create( Application );
  Tb.ActiveDesign.ToolbarControl := Tb;
  Tb.ActiveDesign.Visible := TRUE;
  SetForegroundWindow( Tb.ActiveDesign.Handle );
  Tb.ActiveDesign.MakeActive( TRUE );
  if Tb.ParentForm <> nil then
    Tb.ParentForm.Invalidate;
end;

function TKOLToolbarButtonsEditor.GetAttributes: TPropertyAttributes;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButtonsEditor.GetAttributes', 0
  @@e_signature:
  end;
  Result := [ paDialog, paReadOnly ];
end;

{ TKOLToolbarEditor }

procedure TKOLToolbarEditor.Edit;
var Tb: TKOLToolbar;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarEditor.Edit', 0
  @@e_signature:
  end;
  if Component = nil then Exit;
  Tb := Component as TKOLToolbar;
  if Tb.ActiveDesign = nil then
    Tb.ActiveDesign := TfmToolbarEditor.Create( Application );
  Tb.ActiveDesign.ToolbarControl := Tb;
  Tb.ActiveDesign.Visible := TRUE;
  SetForegroundWindow( Tb.ActiveDesign.Handle );
  Tb.ActiveDesign.MakeActive( TRUE );
  if Tb.ParentForm <> nil then
    Tb.ParentForm.Invalidate;
end;

procedure TKOLToolbarEditor.ExecuteVerb(Index: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarEditor.ExecuteVerb', 0
  @@e_signature:
  end;
  Edit;
end;

function TKOLToolbarEditor.GetVerb(Index: Integer): string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarEditor.GetVerb', 0
  @@e_signature:
  end;
  Result := '&Edit';
end;

function TKOLToolbarEditor.GetVerbCount: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarEditor.GetVerbCount', 0
  @@e_signature:
  end;
  Result := 1;
end;

{ TKOLTabControlEditor }

procedure TKOLTabControlEditor.Edit;
var P: TPoint;
    C: TComponent;
    TabControl: TKOLTabControl;
    I: Integer;
    R: PRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControlEditor.Edit', 0
  @@e_signature:
  end;
  GetCursorPos( P );
  C := Component;
  if C = nil then Exit;
  if not( C is TKOLTabControl ) then Exit;
  TabControl := C as TKOLTabControl;
  P := TabControl.ScreenToClient( P );
  for I := 0 to TabControl.Count-1 do
  begin
    R := TabControl.FTabs[ I ];
    if PtInRect( R^, P ) then
    begin
      TabControl.CurIndex := I;
      break;
    end;
  end;
end;

procedure TKOLTabControlEditor.ExecuteVerb(Index: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControlEditor.ExecuteVerb', 0
  @@e_signature:
  end;
  Edit;
end;

function TKOLTabControlEditor.GetVerb(Index: Integer): string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControlEditor.GetVerb', 0
  @@e_signature:
  end;
  Result := '';
end;

function TKOLTabControlEditor.GetVerbCount: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControlEditor.GetVerbCount', 0
  @@e_signature:
  end;
  Result := 0;
end;

{ TKOLImageShow }

constructor TKOLImageShow.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.Create', 0
  @@e_signature:
  end;
  inherited;
  FHasBorder := FALSE;
  FDefHasBorder := FALSE;
end;

destructor TKOLImageShow.Destroy;
begin
  if ImageListNormal <> nil then
    ImageListNormal.NotifyLinkedComponent( Self, noRemoved );
  inherited;
end;

procedure TKOLImageShow.DoAutoSize;
var Delta: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.DoAutoSize', 0
  @@e_signature:
  end;
  if not fImgShwAutoSize then Exit;
  if FImageListNormal = nil then Exit;
  Delta := 0;
  if HasBorder then
  begin
    Inc( Delta, 6 );
  end;
  Width := FImageListNormal.ImgWidth + Delta;
  Height := FImageListNormal.ImgHeight + Delta;
  //FAutoSize := TRUE;
  fImgShwAutoSize := TRUE;
  Change;
end;

function TKOLImageShow.NoDrawFrame: Boolean;
begin
  Result := HasBorder;
end;

procedure TKOLImageShow.NotifyLinkedComponent(Sender: TObject;
  Operation: TNotifyOperation);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.NotifyLinkedComponent', 0
  @@e_signature:
  end;
  inherited;
  if Operation = noRemoved then
    ImageListNormal := nil;
end;

procedure TKOLImageShow.Paint;
var
  R:TRect;
  EdgeFlag:DWord;
  //Flag:DWord;
  Delta:DWord;
  TMP:TBitMap;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.Paint', 0
  @@e_signature:
  end;

  R.Left:=0;
  R.Top:=0;
  R.Right:=Width;
  R.Bottom:=Height;

  if HasBorder then
  begin
    EdgeFlag:=EDGE_RAISED;
    Delta:=3;
  end
  else
  begin
    EdgeFlag:=0;
    Delta:=0;
  end;

  if Delta <> 0 then
  begin
    DrawEdge(Canvas.Handle,R,EdgeFlag,BF_RECT or BF_MIDDLE );
    R.Left:=Delta-1;
    R.Top:=Delta-1;
    R.Right:=Width-Integer( Delta )+1;
    R.Bottom:=Height-Integer( Delta )+1;
    Canvas.Brush.Color :=clInactiveBorder;
    Canvas.FrameRect(R);
    R.Left:=R.Left+1;
    R.Top:=R.Top+1;
    R.Right:=R.Right-1;
    R.Bottom:=R.Bottom-1;
    Canvas.Brush.Color := Color;
    Canvas.FillRect( R );
  end;

  if ImageListNormal<>nil then
  begin
    TMP:=TBitMap.Create;
    TMP.Width:=ImageListNormal.ImgWidth;
    TMP.Height:=ImageListNormal.ImgHeight;
   
TMP.Canvas.CopyRect(Rect(0,0,ImageListNormal.ImgWidth,ImageListNormal.ImgHeight),ImageListNormal.Bitmap.Canvas,Rect(ImageListNormal.ImgWidth*(CurIndex),0,ImageListNormal.ImgWidth*(CurIndex+1),ImageListNormal.ImgHeight));
    {$IFNDEF _D2}
    TMP.Transparent:=True;
    TMP.TransparentColor:=ImageListNormal.TransparentColor;
    {$ENDIF}
    Canvas.Draw(Delta,Delta,TMP);
    TMP.Free;
  end;

  inherited;
end;

procedure TKOLImageShow.SetBounds(aLeft, aTop, aWidth, aHeight: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.SetBounds', 0
  @@e_signature:
  end;
  if (aWidth <> Width) or (aHeight <> Height) then
    AutoSize := FALSE;
  inherited;
  Change;
end;

procedure TKOLImageShow.SetCurIndex(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.SetCurIndex', 0
  @@e_signature:
  end;
  FCurIndex := Value;
  Change;
  Invalidate;
end;

procedure TKOLImageShow.SetHasBorder(const Value: Boolean);
var WasAuto: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.SetHasBorder', 0
  @@e_signature:
  end;
  WasAuto := AutoSize;
  inherited;
  AutoSize := WasAuto;
  if AutoSize then DoAutoSize;
  Change;
end;

procedure TKOLImageShow.SetImageListNormal(const Value: TKOLImageList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.SetImageListNormal', 0
  @@e_signature:
  end;
  if FImageListNormal <> nil then
    FImageListNormal.NotifyLinkedComponent( Self, noRemoved );
  FImageListNormal := Value;
  if Value <> nil then
  begin
    Value.AddToNotifyList( Self );
    if Value.ImgWidth * Value.ImgHeight > 0 then
    begin
      if AutoSize then
        DoAutoSize;
    end;
  end;
  DoAutoSize;
  Change;
  Invalidate;
end;

procedure TKOLImageShow.SetImgShwAutoSize(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.SetImgShwAutoSize', 0
  @@e_signature:
  end;
  fImgShwAutoSize := Value;
  //Change;
  if Value then
    DoAutoSize;
end;

procedure TKOLImageShow.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLImageShow.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if CurIndex <> 0 then
    SL.Add( Prefix + AName + '.CurIndex := ' + IntToStr( CurIndex ) + ';' );
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );
end;

function TKOLImageShow.SetupParams(const AName, AParent: String): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.SetupParams', 0
  @@e_signature:
  end;
  Result := AParent + ', ';
  if ImageListNormal <> nil then
  begin
    if ImageListNormal.ParentFORM.Name = ParentForm.Name then
      Result := Result + 'Result.' + ImageListNormal.Name
    else Result := Result + ImageListNormal.ParentFORM.Name +'.'+ ImageListNormal.Name;
  end
  else
    Result := Result + 'nil';
  Result := Result + ', ' + IntToStr( CurIndex );
end;

function TKOLImageShow.WYSIWIGPaintImplemented: Boolean;
begin
  Result := TRUE;
end;

{ TKOLLabelEffect }

function TKOLLabelEffect.AdjustVerticalAlign(
  Value: TVerticalAlign): TVerticalAlign;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.AdjustVerticalAlign', 0
  @@e_signature:
  end;
  Result := Value;
end;

function TKOLLabelEffect.AutoHeight(Canvas: TCanvas): Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.AutoHeight', 0
  @@e_signature:
  end;
  Result := inherited AutoHeight(Canvas);
  if Font.FontOrientation = 0 then Exit;
  try
    Result := Trunc( Result * cos( Font.FontOrientation / 1800 * PI ) +
              inherited AutoWidth(Canvas) * sin( Font.FontOrientation / 1800 * PI ) );
  except
  end;
end;

function TKOLLabelEffect.AutoWidth(Canvas: TCanvas): Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.AutoWidth', 0
  @@e_signature:
  end;
  Result := inherited AutoWidth(Canvas);
  if Font.FontOrientation = 0 then Exit;
  try
    Result := Trunc( Result * cos( Font.FontOrientation / 1800 * PI ) +
              inherited AutoHeight(Canvas) * sin( Font.FontOrientation / 1800 * PI ) );
  except
  end;
end;

constructor TKOLLabelEffect.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.Create', 0
  @@e_signature:
  end;
  inherited;
  //Color := clWindowText;
  fColor2 := clNone;
  Ctl3D := FALSE;
end;

procedure TKOLLabelEffect.Paint;
var
  R:TRect;
  Flag:DWord;
begin

  PrepareCanvasFontForWYSIWIGPaint( Canvas );

  R.Left:=ShadowDeep;
  R.Top:=ShadowDeep;
  R.Right:=Width+ShadowDeep;
  R.Bottom:=Height+ShadowDeep;
  Flag:=0;
  case TextAlign of
    taRight: Flag:=Flag or DT_RIGHT;
    taLeft: Flag:=Flag or DT_LEFT;
    taCenter: Flag:=Flag or DT_CENTER;
  end;

  case VerticalAlign of
    vaTop: Flag:=Flag or DT_TOP or DT_SINGLELINE;
    vaBottom: Flag:=Flag or DT_BOTTOM or DT_SINGLELINE;
    vaCenter: Flag:=Flag or DT_VCENTER or DT_SINGLELINE;
  end;

  if (WordWrap) and (not AutoSize) then
      Flag:=Flag or DT_WORDBREAK and not DT_SINGLELINE;
  Canvas.Font.Color:=Color2;    
  DrawText(Canvas.Handle,PChar(Caption),Length(Caption),R,Flag);

  inherited;

end;

procedure TKOLLabelEffect.SetColor2(const Value: TColor);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.SetColor2', 0
  @@e_signature:
  end;
  FColor2 := Value;
  Change;
  Invalidate;
end;

procedure TKOLLabelEffect.SetShadowDeep(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.SetShadowDeep', 0
  @@e_signature:
  end;
  FShadowDeep := Value;
  Change;
  Invalidate;
end;

procedure TKOLLabelEffect.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if Color2 <> clNone then
    SL.Add( Prefix + AName + '.Color2 := ' + Color2Str( Color2 ) + ';' );
  if Ctl3D then
    SL.Add( Prefix + AName + '.Ctl3D := TRUE;' );
end;

function TKOLLabelEffect.SetupParams(const AName, AParent: String): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.SetupParams', 0
  @@e_signature:
  end;
  Result := AParent + ', ' + StringConstant('Caption', Caption) + ', ' +
            Int2Str( ShadowDeep );
end;

procedure TKOLLabelEffect.SetupTextAlign(SL: TStrings;
  const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.SetupTextAlign', 0
  @@e_signature:
  end;
  if TextAlign <> taCenter then
    SL.Add( '    ' + AName + '.TextAlign := ' + TextAligns[ TextAlign ] + ';' );
  if VerticalAlign <> vaTop then
    SL.Add( '    ' + AName + '.VerticalAlign := ' + VertAligns[ VerticalAlign ] + ';' );
end;

procedure TKOLLabelEffect.SetwordWrap(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.SetwordWrap', 0
  @@e_signature:
  end;
  FwordWrap := FALSE;
end;

{ TKOLScrollBox }

constructor TKOLScrollBox.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBox.Create', 0
  @@e_signature:
  end;
  inherited;
  FEdgeStyle := esLowered;
  FScrollBars := ssBoth;
  ControlStyle := ControlStyle + [ csAcceptsControls ];
end;

function TKOLScrollBox.IsControlContainer: Boolean;
var I: Integer;
    C: TComponent;
    K: TControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBox.IsControlContainer', 0
  @@e_signature:
  end;
  Result := ControlContainer;
  if Result then Exit;
  if Owner = nil then Exit;
  for I := 0 to Owner.ComponentCount - 1 do
  begin
    C := Owner.Components[ I ];
    if C is TControl then
    begin
      K := C as TControl;
      if K.Parent = Self then
      begin
        Result := TRUE;
        Exit;
      end;
    end;
  end;
end;

procedure TKOLScrollBox.SetControlContainer(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBox.SetControlContainer', 0
  @@e_signature:
  end;
  FControlContainer := Value;
  Change;
end;

procedure TKOLScrollBox.SetEdgeStyle(const Value: TEdgeStyle);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBox.SetEdgeStyle', 0
  @@e_signature:
  end;
  FEdgeStyle := Value;
  ReAlign( FALSE );
  Change;
end;

procedure TKOLScrollBox.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBox.SetpopupMenu', 0
  @@e_signature:
  end;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLScrollBox.SetScrollBars(const Value: TScrollBars);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBox.SetScrollBars', 0
  @@e_signature:
  end;
  FScrollBars := Value;
  Change;
end;

procedure TKOLScrollBox.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBox.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if Assigned( FpopupMenu ) then
    SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
            ' );' );
end;

function TKOLScrollBox.SetupParams(const AName, AParent: String): String;
const EdgeStyles: array[ TEdgeStyle ] of String = ( 'esRaised', 'esLowered', 'esNone' );
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBox.SetupParams', 0
  @@e_signature:
  end;
  Result := AParent + ', ' + EdgeStyles[ EdgeStyle ];
  if not IsControlContainer then
  begin
    S := '';
    case ScrollBars of
    ssHorz: S := 'sbHorizontal';
    ssVert: S := 'sbVertical';
    ssBoth: S := 'sbHorizontal, sbVertical';
    end;
    Result := Result + ', [ ' + S + ' ]';
  end;
end;

function TKOLScrollBox.TypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBox.TypeName', 0
  @@e_signature:
  end;
  Result := inherited TypeName;
  if IsControlContainer then
    Result := 'ScrollBoxEx';
end;

{ TKOLMDIClient }

var MDIWarningLastTime: Integer;
procedure MDIClientMustBeAChildOfTheFormWarning;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'MDIClientMustBeAChildOfTheFormWarning', 0
  @@e_signature:
  end;
  if Abs( Integer( GetTickCount ) - MDIWarningLastTime ) > 60000 then
  begin
    MDIWarningLastTime := GetTickCount;
    ShowMessage( 'TKOLMDIClient control must be a child of the form itself!'#13 +
                 'Otherwise maximizing of MDI children will lead to access violation ' +
                 'at run-time execution.' );
  end;
end;

procedure MsgDuplicatedMDIClient;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'MsgDuplicatedMDIClient', 0
  @@e_signature:
  end;
  if Abs( Integer( GetTickCount ) - MDIWarningLastTime ) > 60000 then
  begin
    MDIWarningLastTime := GetTickCount;
    ShowMessage( 'TKOLMDIClient control must be a single on the form, ' +
                 'but another instance of MDI client object found there.' );
  end;
end;

constructor TKOLMDIClient.Create(AOwner: TComponent);
var I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIClient.Create', 0
  @@e_signature:
  end;
  inherited;
  Align := caClient;
  if (AOwner <> nil) and (AOwner is TForm) then
  begin
    for I := 0 to (AOwner as TForm).ComponentCount-1 do
    begin
      C := (AOwner as TForm).Components[ I ];
      if C = Self then continue;
      if C is TKOLMDIClient then
      begin
        MsgDuplicatedMDIClient;
        break;
      end;
    end;
  end;
  FTimer := TTimer.Create( Self );
  FTimer.Interval := 200;
  FTimer.OnTimer := Tick;
  FTimer.Enabled := TRUE;
end;

destructor TKOLMDIClient.Destroy;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIClient.Destroy', 0
  @@e_signature:
  end;
  inherited;
  MDIWarningLastTime := 0;
end;

function TKOLMDIClient.SetupParams(const AName, AParent: String): String;

  function FindWindowMenu( MI: TKOLMenuItem ): Integer;
  var I: Integer;
      SMI: TKOLMenuItem;
  begin
    Result := 0;
    if MI.WindowMenu then
      Result := MI.itemindex
    else
    for I := 0 to MI.Count-1 do
    begin
      SMI := MI.SubItems[ I ];
      Result := FindWindowMenu( SMI );
      if Result > 0 then
        break;
    end;
  end;

var I, J, WM: Integer;
    C: TComponent;
    MM: TKOLMainMenu;
    MI: TKOLMenuItem;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIClient.SetupParams', 0
  @@e_signature:
  end;
    Result := AParent + ', ';
    S := '0';
    for I := 0 to (Owner as TForm).ComponentCount-1 do
    begin
      C := (Owner as TForm).Components[ I ];
      if C is TKOLMainMenu then
      begin
        MM := C as TKOLMainMenu;
        for J := 0 to MM.Count-1 do
        begin
          MI := MM.Items[ J ];
          WM := FindWindowMenu( MI );
          if WM > 0 then
          begin
            S := 'Result.' + MM.Name + '.ItemHandle[ ' +
                 IntToStr( WM ) + ' ]';
            break;
          end;
        end;
        break;
      end;
    end;
    Result := Result + S;
end;

procedure TKOLMDIClient.Tick(Sender: TObject);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIClient.Tick', 0
  @@e_signature:
  end;
  if Parent <> nil then
  begin
    FTimer.Enabled := FALSE;
    if Parent <> Owner then
      MDIClientMustBeAChildOfTheFormWarning
    else
      ParentKOLForm.AlignChildren( nil, FALSE );
    FTimer.Free;
    FTimer := nil;
  end;
end;

{ TKOLToolbarButton }

procedure TKOLToolbarButton.Change;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Change', 0
  @@e_signature:
  end;
  if csLoading in ComponentState then Exit;
  if FToolbar <> nil then begin
    FToolbar.UpdateButtons;
    FToolbar.Change;
  end;
end;

constructor TKOLToolbarButton.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Create', 0
  @@e_signature:
  end;
  inherited;
  if AOwner <> nil then
  if AOwner is TKOLToolbar then
  begin
    FToolbar := AOwner as TKOLToolbar;
    FToolbar.FItems.Add( Self );
  end;
  Fpicture := TPicture.Create;
  Fvisible := TRUE;
  Fenabled := TRUE;
  FimgIndex := -1;
end;

procedure TKOLToolbarButton.DefProps(const Prefix: String; Filer: Tfiler);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.DefProps', 0
  @@e_signature:
  end;
  Filer.DefineProperty( Prefix + 'Name', LoadName, SaveName, TRUE );
  Filer.DefineProperty( Prefix + 'caption', LoadCaption, SaveCaption, TRUE );
  Filer.DefineProperty( Prefix + 'checked', LoadChecked, SaveChecked, TRUE );
  Filer.DefineProperty( Prefix + 'dropdown', LoadDropDown, SaveDropDown, TRUE );
  Filer.DefineProperty( Prefix + 'enabled', LoadEnabled, SaveEnabled, TRUE );
  Filer.DefineProperty( Prefix + 'separator', LoadSeparator, SaveSeparator, TRUE );
  Filer.DefineProperty( Prefix + 'tooltip', LoadTooltip, SaveTooltip, TRUE );
  Filer.DefineProperty( Prefix + 'visible', LoadVisible, SaveVisible, TRUE );
  Filer.DefineProperty( Prefix + 'onClick', LoadOnClick, SaveOnClick, TRUE );
  Filer.DefineProperty( Prefix + 'picture', LoadPicture, SavePicture, TRUE );
  Filer.DefineProperty( Prefix + 'sysimg', LoadSysImg, SaveSysImg, TRUE );
  Filer.DefineProperty( Prefix + 'radioGroup', LoadRadioGroup, SaveRadioGroup, radioGroup <> 0 );
  Filer.DefineProperty( Prefix + 'imgIndex', LoadImgIndex, SaveImgIndex, imgIndex >= 0 );
end;

destructor TKOLToolbarButton.Destroy;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Destroy', 0
  @@e_signature:
  end;
  if FToolbar <> nil then
    FToolbar.FItems.Remove( Self );
  Fpicture.Free;
  inherited;
end;

function TKOLToolbarButton.HasPicture: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.HasPicture', 0
  @@e_signature:
  end;
  {if Assigned( picture ) then
    Rpt( '%%%%%%%% ' + Name + '.picture: Width=' + Int2Str( picture.Width ) +
         ' Height=' + Int2Str( picture.Height ) );}
  Result := Assigned( picture ) and (picture.Width * picture.Height > 0);
end;

procedure TKOLToolbarButton.LoadCaption(Reader: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadCaption', 0
  @@e_signature:
  end;
  Fcaption := Reader.ReadString;
end;

procedure TKOLToolbarButton.LoadChecked(Reader: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadChecked', 0
  @@e_signature:
  end;
  Fchecked := Reader.ReadBoolean;
end;

procedure TKOLToolbarButton.LoadDropDown(Reader: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadDropDown', 0
  @@e_signature:
  end;
  Fdropdown := Reader.ReadBoolean;
end;

procedure TKOLToolbarButton.LoadEnabled(Reader: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadEnabled', 0
  @@e_signature:
  end;
  Fenabled := Reader.ReadBoolean;
end;

procedure TKOLToolbarButton.LoadImgIndex(Reader: TReader);
begin
  FimgIndex := Reader.ReadInteger;
end;

procedure TKOLToolbarButton.LoadName(Reader: TReader);
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadName', 0
  @@e_signature:
  end;
  S := Reader.ReadString;
  if FToolbar = nil then Exit;
  if FToolbar.FindComponent( S ) <> nil then Exit;
  if (FToolbar.Owner <> nil) and (FToolbar.Owner is TForm) then
  begin
    if (FToolbar.Owner as TForm).FindComponent( S ) <> nil then Exit;
    Name := S;
  end;
end;

procedure TKOLToolbarButton.LoadOnClick(Reader: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadOnClick', 0
  @@e_signature:
  end;
  fOnClickMethodName := Reader.ReadString;
end;

procedure TKOLToolbarButton.LoadPicture(Reader: TReader);
var S: String;
    MS: TMemoryStream;
    Bmp: TBitmap;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadPicture', 0
  @@e_signature:
  end;
  S := Reader.ReadString;
  if S <> '' then
  begin
    MS := TMemoryStream.Create;
    TRY
      MS.Write( S[ 1 ], Length( S ) );
      MS.Position := 0;
      Bmp := TBitmap.Create;
      TRY
        Bmp.LoadFromStream( MS );
        Fpicture.Assign( Bmp );
      FINALLY
        Bmp.Free;
      END;
    FINALLY
      MS.Free;
    END;
  end;
end;

procedure TKOLToolbarButton.LoadProps(Reader: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadProps', 0
  @@e_signature:
  end;
  Fcaption := Reader.ReadString;
  Fchecked := Reader.ReadBoolean;
  Fdropdown := Reader.ReadBoolean;
  Fenabled := Reader.ReadBoolean;
  Fseparator := Reader.ReadBoolean;
  Ftooltip := Reader.ReadString;
  Fvisible := Reader.ReadBoolean;
  fOnClickMethodName := Reader.ReadString;
end;

procedure TKOLToolbarButton.LoadRadioGroup(Reader: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadRadioGroup', 0
  @@e_signature:
  end;
  FradioGroup := Reader.ReadInteger;
end;

procedure TKOLToolbarButton.LoadSeparator(Reader: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadSeparator', 0
  @@e_signature:
  end;
  Fseparator := Reader.ReadBoolean;
end;

procedure TKOLToolbarButton.LoadSysImg(Reader: TReader);
begin
  Fsysimg := TSystemToolbarImage( Reader.ReadInteger );
end;

procedure TKOLToolbarButton.LoadTooltip(Reader: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadTooltip', 0
  @@e_signature:
  end;
  Ftooltip := Reader.ReadString;
end;

procedure TKOLToolbarButton.LoadVisible(Reader: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadVisible', 0
  @@e_signature:
  end;
  Fvisible := Reader.ReadBoolean;
end;

procedure TKOLToolbarButton.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
    if AComponent = Faction then begin
      Faction.UnLinkComponent(Self);
      Faction := nil;
    end;
end;

procedure TKOLToolbarButton.SaveCaption(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveCaption', 0
  @@e_signature:
  end;
  Writer.WriteString( Fcaption );
end;

procedure TKOLToolbarButton.SaveChecked(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveChecked', 0
  @@e_signature:
  end;
  Writer.WriteBoolean( Fchecked );
end;

procedure TKOLToolbarButton.SaveDropDown(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveDropDown', 0
  @@e_signature:
  end;
  Writer.WriteBoolean( Fdropdown );
end;

procedure TKOLToolbarButton.SaveEnabled(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveEnabled', 0
  @@e_signature:
  end;
  Writer.WriteBoolean( Fenabled );
end;

procedure TKOLToolbarButton.SaveImgIndex(Writer: TWriter);
begin
  Writer.WriteInteger( FimgIndex );
end;

procedure TKOLToolbarButton.SaveName(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveName', 0
  @@e_signature:
  end;
  Writer.WriteString( Name );
end;

procedure TKOLToolbarButton.SaveOnClick(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveOnClick', 0
  @@e_signature:
  end;
  Writer.WriteString( fOnClickMethodName );
end;

procedure TKOLToolbarButton.SavePicture(Writer: TWriter);
var S: String;
    MS: TMemoryStream;
    Bmp: TBitmap;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SavePicture', 0
  @@e_signature:
  end;
  MS := TMemoryStream.Create;
  TRY
    S := '';
    if Assigned( picture ) and (picture.Width * picture.Height > 0) then
    begin
      Bmp := TBitmap.Create;
      TRY
        Bmp.Assign( picture.Graphic );
        Bmp.SaveToStream( MS );
      FINALLY
        Bmp.Free;
      END;
      SetLength( S, MS.Size );
      Move( MS.Memory^, S[ 1 ], MS.Size );
    end;
    Writer.WriteString( S );
  FINALLY
    MS.Free;
  END;
end;

procedure TKOLToolbarButton.SaveProps(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveProps', 0
  @@e_signature:
  end;
  Writer.WriteString( Fcaption );
  Writer.WriteBoolean( Fchecked );
  Writer.WriteBoolean( Fdropdown );
  Writer.WriteBoolean( Fenabled );
  Writer.WriteBoolean( Fseparator );
  Writer.WriteString( Ftooltip );
  Writer.WriteBoolean( Fvisible );
  Writer.WriteString( fOnClickMethodName );
end;

procedure TKOLToolbarButton.SaveRadioGroup(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveRadioGroup', 0
  @@e_signature:
  end;
  Writer.WriteInteger( FradioGroup );
end;

procedure TKOLToolbarButton.SaveSeparator(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveSeparator', 0
  @@e_signature:
  end;
  Writer.WriteBoolean( Fseparator );
end;

procedure TKOLToolbarButton.SaveSysImg(Writer: TWriter);
begin
  Writer.WriteInteger( Integer( Fsysimg ) );
end;

procedure TKOLToolbarButton.SaveTooltip(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveTooltip', 0
  @@e_signature:
  end;
  Writer.WriteString( Ftooltip );
end;

procedure TKOLToolbarButton.SaveVisible(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveVisible', 0
  @@e_signature:
  end;
  Writer.WriteBoolean( Fvisible );
end;

procedure TKOLToolbarButton.Setaction(const Value: TKOLAction);
begin
  if Faction = Value then exit;
  if Faction <> nil then
    Faction.UnLinkComponent(Self);
  Faction := Value;
  if Faction <> nil then
    Faction.LinkComponent(Self);
  Change;
end;

procedure TKOLToolbarButton.Setcaption(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Setcaption', 0
  @@e_signature:
  end;
  if Fcaption = Value then Exit;
  if Faction = nil then
    Fcaption := Value
  else
    Fcaption:=Faction.Caption;
  if Fcaption <> '-' then
    Fseparator := FALSE;
  Change;
end;

procedure TKOLToolbarButton.Setchecked(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Setchecked', 0
  @@e_signature:
  end;
  if FChecked = Value then Exit;
  if Faction = nil then
    FChecked := Value
  else
    FChecked:=Faction.Checked;
  Change;
end;

procedure TKOLToolbarButton.Setdropdown(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Setdropdown', 0
  @@e_signature:
  end;
  if Fdropdown = Value then Exit;
  Fdropdown := Value;
  Change;
end;

procedure TKOLToolbarButton.Setenabled(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Setenabled', 0
  @@e_signature:
  end;
  if Fenabled = Value then Exit;
  if Faction = nil then
    Fenabled := Value
  else
    Fenabled:=Faction.Enabled;
  Change;
end;

procedure TKOLToolbarButton.SetimgIndex(const Value: Integer);
begin
  if Fseparator then
    FimgIndex := -1
  else
    FimgIndex := Value;
  Change;
end;

procedure TKOLToolbarButton.SetName(const NewName: TComponentName);
var OldName, NewMethodName: String;
    F: TForm;
    D: IDesigner;
    FD: IFormDesigner;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SetName', 0
  @@e_signature:
  end;
  OldName := Name;
  //Rpt( 'Renaming ' + OldName + ' to ' + NewName );
  if (FToolbar <> nil) and (OldName <> '') and
     (FToolbar.FindComponent( NewName ) <> nil) then
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
  if fOnClickMethodName <> '' then
  if FToolbar <> nil then
  begin
    if LowerCase( FToolbar.Name + OldName + 'Click' ) = LowerCase( fOnClickMethodName ) then
    begin
      // rename event handler also here:
      F := FToolbar.ParentForm;
      NewMethodName := FToolbar.Name + NewName + 'Click';
      if F <> nil then
      begin
  {$IFDEF _D6orHigher}
        F.Designer.QueryInterface(IFormDesigner,D);
  {$ELSE}
        D := F.Designer;
  {$ENDIF}
        if D <> nil then
        if QueryFormDesigner( D, FD ) then
        begin
          if not FD.MethodExists( NewMethodName ) then
          begin
            FD.RenameMethod( fOnClickMethodName, NewMethodName );
            if FD.MethodExists( NewMethodName ) then
              fOnClickMethodName := NewMethodName;
          end;
        end;
      end;
    end;
  end;
  Change;
end;

procedure TKOLToolbarButton.SetonClick(const Value: TOnToolbarButtonClick);
var F: TForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SetOnClick', 0
  @@e_signature:
  end;
  if @ fOnClick = @ Value then Exit;
  FonClick := Value;
  if TMethod( Value ).Code <> nil then
  begin
    if FToolbar <> nil then
    begin
      F := FToolbar.ParentForm;
      fOnClickMethodName := F.MethodName( TMethod( Value ).Code );
    end;
  end
    else
    FOnClickMethodName := '';
  Change;
end;

procedure TKOLToolbarButton.Setpicture(Value: TPicture);
var Bmp: TBitmap;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Setpicture', 0
  @@e_signature:
  end;
  if Value <> nil then
    if Value.Width * Value.Height = 0 then
      Value := nil;
  if Value = nil then
  begin
    Fpicture.Free;
    Fpicture := TPicture.Create;
  end
    else
  begin
    if FToolbar.ImageListsUsed then
    begin
      I := MessageBox( Application.Handle, 'Image list(s) will be detached from the toolbar.'#13#10 +
        'Continue?', PChar( Application.Title + ' : ' + Name ), MB_OKCANCEL );
      if I <> ID_OK then Exit;
      FToolbar.imageListNormal := nil;
      FToolbar.imageListDisabled := nil;
      FToolbar.imageListHot := nil;
    end;
    Bmp := TBitmap.Create;
    TRY
      Bmp.Width := Value.Width;
      Bmp.Height := Value.Height;
      if Value.Graphic is TIcon then
      begin
        Bmp.Canvas.Brush.Color := clSilver;
        Bmp.Canvas.FillRect( Rect( 0, 0, Bmp.Width, Bmp.Height ) );
        Bmp.Canvas.Draw( 0, 0, Value.Graphic );
      end
        else
      Bmp.Assign( Value.Graphic );
      Fpicture.Assign( Bmp );
      {if FToolbar.mapBitmapColors then
      if not CanMapBitmap( Bmp ) then
        FToolbar.mapBitmapColors := FALSE;}
    FINALLY
      Bmp.Free;
    END;
    Fseparator := False;
  end;
  FToolbar.AssembleBitmap;
  if Assigned(FToolbar.FKOLCtrl) then
    FToolbar.RecreateWnd;
  Change;
end;

procedure TKOLToolbarButton.SetradioGroup(const Value: Integer);
var I, J: Integer;
    AlreadyPresent, TheSameBefore, TheSameAfter: Boolean;
    Bt: TKOLToolbarButton;
begin
  if Value = FradioGroup then Exit;
  I := FToolbar.Items.IndexOf( Self );
  if I < 0 then Exit;
  if Value <> 0 then
  begin
    AlreadyPresent := FALSE;
    for J := 0 to FToolbar.Items.Count-1 do
    begin
      if I = J then continue;
      Bt := FToolbar.Items[ J ];
      if Bt.FradioGroup = Value then
      begin
        AlreadyPresent := TRUE;
        break;
      end;
    end;
    if AlreadyPresent then
    begin
      TheSameBefore := FALSE;
      TheSameAfter := FALSE;
      if (I > 0) then
      begin
        Bt := FToolbar.Items[ I - 1 ];
        if not Bt.separator and (Bt.FradioGroup = Value) then
          TheSameBefore := TRUE;
      end;
      if (I < FToolbar.Items.Count-1) then
      begin
        Bt := FToolbar.Items[ I + 1 ];
        if not Bt.separator and (Bt.FradioGroup = Value) then
          TheSameAfter := TRUE;
      end;
      if not (TheSameBefore or TheSameAfter) then Exit;
    end;
  end;
  FradioGroup := Value;
  Change;
end;

procedure TKOLToolbarButton.Setseparator(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Setseparator', 0
  @@e_signature:
  end;
  if Fseparator = Value then Exit;
  Fseparator := Value;
  if Value then
  begin
    Fcaption := '-';
    FimgIndex := -1;
  end;
  Change;
end;

procedure TKOLToolbarButton.Setsysimg(const Value: TSystemToolbarImage);
var I: Integer;
begin
  if Value <> stiCustom then
  begin
    if (FToolbar.ImageListNormal <> nil) or
       (FToolbar.ImageListDisabled <> nil) or
       (FToolbar.ImageListHot <> nil) then
    begin
      I := MessageBox( Application.Handle, 'Image list(s) will be detached from ' +
        'the toolbar. Continue?', PChar( Application.Title + ' : ' + Name ),
        MB_OKCANCEL );
      if I <> ID_OK then Exit;
      FToolbar.ImageListNormal := nil;
      FToolbar.ImageListDisabled := nil;
      FToolbar.ImageListHot := nil;
    end;
    picture := nil;
  end;
  Fsysimg := Value;
  if Assigned(FToolbar.FKOLCtrl) then
    FToolbar.RecreateWnd;
  Change;
end;

procedure TKOLToolbarButton.Settooltip(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Settooltip', 0
  @@e_signature:
  end;
  if Ftooltip = Value then Exit;
  if Faction = nil then
    Ftooltip := Value
  else
    Ftooltip:=Faction.Hint;
  if FToolbar <> nil then
    FToolbar.AssembleTooltips;
  Change;
end;

procedure TKOLToolbarButton.Setvisible(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Setvisible', 0
  @@e_signature:
  end;
  if Fvisible = Value then Exit;
  if Faction = nil then
    Fvisible := Value
  else
    Fvisible:=Faction.Visible;
  Change;
end;

{ TKOLToolButtonOnClickPropEditor }

function TKOLToolButtonOnClickPropEditor.GetValue: string;
var Comp: TPersistent;
    F: TForm;
    D: IDesigner;
    FD: IFormDesigner;
    Orig: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButtonOnClickPropEditor.GetValue', 0
  @@e_signature:
  end;
  if FResetting then
  begin
    Result := '';
    Exit;
  end;
  Result := inherited GetValue;
  Orig := Result;
  //**Windows.Beep( 100, 100 );
  if Result = '' then
  begin
    Comp := GetComponent( 0 );
    if Comp <> nil then
    if Comp is TKOLToolbarButton then
    begin
      Result := (Comp as TKOLToolbarButton).FOnClickMethodName;
    end;
  end;
  //**Windows.Beep( 200, 100 );
  TRY

  Comp := GetComponent( 0 );
  if (Comp <> nil) and
     (Comp is TKOLToolbarButton) and
     ((Comp as TKOLToolbarButton).FToolbar <> nil) then
  begin
    F := (Comp as TKOLToolbarButton).FToolbar.ParentForm;
    if (F = nil) or (F.Designer = nil) then
    begin
      Result := ''; Exit;
    end;
  {$IFDEF _D6orHigher}
        F.Designer.QueryInterface(IFormDesigner,D);
  {$ELSE}
        D := F.Designer;
  {$ENDIF}
    if (D <> nil) and QueryFormDesigner( D, FD ) then
    begin
      if not FD.MethodExists( Result ) then Result := '';
    end
      else Result := '';
  end
    else Result := '';
  //**Windows.Beep( 200, 100 );
  if (Result = '') and (Orig <> '') then
  begin
    FResetting := TRUE;
    TRY
      //Windows.Beep( 100, 200 );
      SetValue( '' );
    FINALLY
      FResetting := FALSE;
    END;
  end;

  EXCEPT
    Rpt( 'Exception while retrieving property onClick for TKOLToolbarButton' );
  END;
end;

procedure TKOLToolButtonOnClickPropEditor.SetValue(const AValue: string);
var Comp: TPersistent;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButtonOnClickPropEditor.SetValue', 0
  @@e_signature:
  end;
  inherited;
  for I := 0 to PropCount - 1 do
  begin
    Comp := GetComponent( I );
    if Comp <> nil then
    if Comp is TKOLToolbarButton then
    begin
      (Comp as TKOLToolbarButton).FOnClickMethodName := AValue;
      (Comp as TKOLToolbarButton).Change;
    end;
  end;
end;

{ TKOLListViewColumn }

procedure TKOLListViewColumn.Change;
begin
  if Assigned( FListView ) then begin
    FListView.UpdateColumns; {YS}
    FListView.Change;
  end;
end;

constructor TKOLListViewColumn.Create(AOwner: TComponent);
begin
  inherited;
  FLVColOrder := -1;
  FLVColImage := -1;
  if AOwner <> nil then
  if AOwner is TKOLListView then
  begin
    FListView := AOwner as TKOLListView;
    FListView.Cols.Add( Self );
    {ShowMessage( 'Parent FListView=' + Int2Hex( DWORD( FListView ), 8 ) + ', ' +
                 FListView.Name );}
  end;
  FWidth := 50;
end;

procedure TKOLListViewColumn.DefProps(const Prefix: String; Filer: TFiler);
begin
  Filer.DefineProperty( Prefix + 'Name', LoadName, SaveName, True );
  Filer.DefineProperty( Prefix + 'Caption', LoadCaption, SaveCaption, True );
  Filer.DefineProperty( Prefix + 'TextAlign', LoadTextAlign, SaveTextAlign, True );
  Filer.DefineProperty( Prefix + 'Width', LoadWidth, SaveWidth, True );
  Filer.DefineProperty( Prefix + 'WidthType', LoadWidthType, SaveWidthType, True );
  Filer.DefineProperty( Prefix + 'LVColImage', LoadLVColImage, SaveLVColImage, True );
  Filer.DefineProperty( Prefix + 'LVColOrder', LoadLVColOrder, SaveLVColOrder, LVColOrder >= 0 );
  Filer.DefineProperty( Prefix + 'LVColRightImg', LoadLVColRightImg, SaveLVColRightImg, LVColRightImg );
end;

destructor TKOLListViewColumn.Destroy;
begin
  if FListView <> nil then
  begin
    FListView.FCols.Remove( Self );
    FListView.UpdateColumns;
    FListView.Change;
  end;
  inherited;
end;

procedure TKOLListViewColumn.LoadCaption(Reader: TReader);
begin
  fCaption := Reader.ReadString;
end;

procedure TKOLListViewColumn.LoadLVColImage(Reader: TReader);
begin
  FLVColImage := Reader.ReadInteger;
end;

procedure TKOLListViewColumn.LoadLVColOrder(Reader: TReader);
begin
  LVColOrder := Reader.ReadInteger;
end;

procedure TKOLListViewColumn.LoadLVColRightImg(Reader: TReader);
begin
  FLVColRightImg := Reader.ReadBoolean;
end;

procedure TKOLListViewColumn.LoadName(Reader: TReader);
begin
  Name := Reader.ReadString;
end;

procedure TKOLListViewColumn.LoadTextAlign(Reader: TReader);
begin
  FTextAlign := TTextAlign( Reader.ReadInteger );
end;

procedure TKOLListViewColumn.LoadWidth(Reader: TReader);
begin
  FWidth := Reader.ReadInteger;
end;

procedure TKOLListViewColumn.LoadWidthType(Reader: TReader);
begin
  FWidthType := TKOLListViewColWidthType( Reader.ReadInteger );
end;

procedure TKOLListViewColumn.SaveCaption(Writer: TWriter);
begin
  Writer.WriteString( fCaption );
end;

procedure TKOLListViewColumn.SaveLVColImage(Writer: TWriter);
begin
  Writer.WriteInteger( FLVColImage );
end;

procedure TKOLListViewColumn.SaveLVColOrder(Writer: TWriter);
begin
  Writer.WriteInteger( FLVColOrder );
end;

procedure TKOLListViewColumn.SaveLVColRightImg(Writer: TWriter);
begin
  Writer.WriteBoolean( FLVColRightImg );
end;

procedure TKOLListViewColumn.SaveName(Writer: TWriter);
begin
  Writer.WriteString( Name );
end;

procedure TKOLListViewColumn.SaveTextAlign(Writer: TWriter);
begin
  Writer.WriteInteger( Integer( FTextAlign ) );
end;

procedure TKOLListViewColumn.SaveWidth(Writer: TWriter);
begin
  Writer.WriteInteger( FWidth );
end;

procedure TKOLListViewColumn.SaveWidthType(Writer: TWriter);
begin
  Writer.WriteInteger( Integer( FWidthType ) );
end;

procedure TKOLListViewColumn.SetCaption(const Value: String);
begin
  FCaption := Value;
  Change;
end;

procedure TKOLListViewColumn.SetLVColImage(const Value: Integer);
begin
  FLVColImage := Value;
  Change;
end;

procedure TKOLListViewColumn.SetLVColOrder(const Value: Integer);
var I: Integer;
    Col: TKOLListViewColumn;
begin
  if FListView <> nil then
  begin
    for I := 0 to FListView.Cols.Count-1 do
    begin
      Col := FListView.Cols[ I ];
      if Col = Self then continue;
      if Col.FLVColOrder > FLVColOrder then
        Dec( Col.FLVColOrder );
    end;
    if Value >= 0 then
    for I := 0 to FListView.Cols.Count-1 do
    begin
      Col := FListView.Cols[ I ];
      if Col = Self then continue;
      if Col.FLVColOrder >= Value then
        Inc( Col.FLVColOrder );
    end;
  end;
  FLVColOrder := Value;
  Change;
end;

procedure TKOLListViewColumn.SetLVColRightImg(const Value: Boolean);
begin
  FLVColRightImg := Value;
  Change;
end;

procedure TKOLListViewColumn.SetName(const AName: TComponentName);
begin
  inherited;
  Change;
end;

procedure TKOLListViewColumn.SetTextAlign(const Value: TTextAlign);
begin
  FTextAlign := Value;
  Change;
end;

procedure TKOLListViewColumn.SetWidth(const Value: Integer);
begin
  FWidth := Value;
  Change;
end;

procedure TKOLListViewColumn.SetWidthType(
  const Value: TKOLListViewColWidthType);
begin
  FWidthType := Value;
  Change;
end;

{ TKOLLVColumnsPropEditor }

procedure TKOLLVColumnsPropEditor.Edit;
var LV: TKOLListView;
begin
  if GetComponent( 0 ) = nil then Exit;
  LV := GetComponent( 0 ) as TKOLListView;
  if LV.ActiveDesign = nil then
    LV.ActiveDesign := TfmLVColumnsEditor.Create( Application );
  LV.ActiveDesign.ListView := LV;
  LV.ActiveDesign.Visible := TRUE;
  SetForegroundWindow( LV.ActiveDesign.Handle );
  LV.ActiveDesign.MakeActive( TRUE );
  if LV.ParentForm <> nil then
    LV.ParentForm.Invalidate;
end;

function TKOLLVColumnsPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [ paDialog, paReadOnly ];
end;

{ TKOLLVColumnsEditor }

procedure TKOLLVColumnsEditor.Edit;
var LV: TKOLListView;
begin
  if Component = nil then Exit;
  if not(Component is TKOLListView) then Exit;
  LV := Component as TKOLListView;
  if LV.ActiveDesign = nil then
    LV.ActiveDesign := TfmLVColumnsEditor.Create( Application );
  LV.ActiveDesign.ListView := LV;
  LV.ActiveDesign.Visible := True;
  SetForegroundWindow( LV.ActiveDesign.Handle );
  LV.ActiveDesign.MakeActive( TRUE );
  if LV.ParentForm <> nil then
    LV.ParentForm.Invalidate;
end;

procedure TKOLLVColumnsEditor.ExecuteVerb(Index: Integer);
begin
  Edit;
end;

function TKOLLVColumnsEditor.GetVerb(Index: Integer): string;
begin
  Result := '&Edit columns';
end;

function TKOLLVColumnsEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

{ TKOLDateTimePicker }

procedure TKOLDateTimePicker.AssignEvents(SL: TStringList;
  const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName, [ 'OnDTPUserString' ], [ @ OnDTPUserString ] );
end;

constructor TKOLDateTimePicker.Create(AOwner: TComponent);
begin
  inherited;
  Width := 110; DefaultWidth := Width;
  Height := 24; DefaultHeight := Height;
  Color := clWindow;
  fTabStop := TRUE;
end;

function TKOLDateTimePicker.GenerateTransparentInits: String;
begin
  Result := inherited GenerateTransparentInits;
end;

procedure TKOLDateTimePicker.SetFormat(const Value: String);
begin
  FFormat := Value;
  Change;
end;

procedure TKOLDateTimePicker.SetOnDTPUserString(
  const Value: TDTParseInputEvent);
begin
  FOnDTPUserString := Value;
  Change;
end;

procedure TKOLDateTimePicker.SetOptions(
  const Value: TDateTimePickerOptions);
begin
  if ( dtpoTime in Value ) and not( dtpoTime in FOptions ) then
    FOptions := Value + [ dtpoUpDown ]
  else
    FOptions := Value;
  Change;
end;

procedure TKOLDateTimePicker.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
begin
  inherited;
  if Format <> '' then
    SL.Add( Prefix + AName + '.DateTimeFormat := ' +
      StringConstant( 'Format', Format ) + ';' );
  if not ParentColor then
    SL.Add( Prefix + AName + '.DateTimePickerColors[ dtpcBackground ] := ' +
      Color2Str( Color ) + ';' );
end;

function TKOLDateTimePicker.SetupParams(const AName,
  AParent: String): String;
var S: String;
begin
  S := '';
  if dtpoTime       in Options then S := S + ',dtpoTime';
  if dtpoDateLong   in Options then S := S + ',dtpoDateLong';
  if dtpoUpDown     in Options then S := S + ',dtpoUpDown';
  if dtpoRightAlign in Options then S := S + ',dtpoRightAlign';
  if dtpoShowNone   in Options then S := S + ',dtpoShowNone';
  if dtpoParseInput in Options then S := S + ',dtpoParseInput';
  Delete( S, 1, 1 );
  Result := AParent + ', [' + S + ']';
end;

function TKOLDateTimePicker.TabStopByDefault: Boolean;
begin
  Result := TRUE;
end;

end.



