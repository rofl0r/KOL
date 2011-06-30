unit mckDHTML;

interface

uses Classes, KOL, mirror;

type

  TDHTMLEditShowContextMenu = procedure(Sender: TObject; xPos: Integer; yPos: Integer) of object;
  TDHTMLEditContextMenuAction = procedure(Sender: TObject; itemIndex: Integer) of object;

  TDHTMLEDIT = class(TKOLCustomControl)
  private
    fBrowseMode: boolean;
    fActivateDTCs: boolean;
    fActivateApplets: boolean;
    fActivateActiveXControls: boolean;
    fScrollBars: boolean;
    fShowDetails: boolean;
    fOnDocumentComplete: TOnEvent;
    fOnDisplayChanged: TOnEvent;
    fOnShowContextMenu: TDHTMLEditShowContextMenu;
    fOnContextMenuAction: TDHTMLEditContextMenuAction;
    fOnonmousedown: TOnEvent;
    fOnonmousemove: TOnEvent;
    fOnonmouseup: TOnEvent;
    fOnonmouseout: TOnEvent;
    fOnonmouseover: TOnEvent;
    fOnonclick: TOnEvent;
    fOnondblclick: TOnEvent;
    fOnonkeydown: TOnEvent;
    fOnonkeypress: TOnEvent;
    fOnonkeyup: TOnEvent;
    fOnonblur: TOnEvent;
    fOnonreadystatechange: TOnEvent;
  protected
    function  AdditionalUnits: string; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    procedure SetBrowseMode(m: boolean);
    procedure SetActivateDTCs(m: boolean);
    procedure SetActivateApplets(m: boolean);
    procedure SetActivateActiveXControls(m: boolean);
    procedure SetScrollBars(m: boolean);
    procedure SetShowDetails(m: boolean);
    procedure SetOnDocumentComplete(e: TOnEvent);
    procedure SetOnDisplayChanged(e: TOnEvent);
    procedure SetOnShowContextMenu(e: TDHTMLEditShowContextMenu);
    procedure SetOnContextMenuAction(e: TDHTMLEditContextMenuAction);
    procedure SetOnonmousedown(e: TOnEvent);
    procedure SetOnonmousemove(e: TOnEvent);
    procedure SetOnonmouseup(e: TOnEvent);
    procedure SetOnonmouseout(e: TOnEvent);
    procedure SetOnonmouseover(e: TOnEvent);
    procedure SetOnonclick(e: TOnEvent);
    procedure SetOnondblclick(e: TOnEvent);
    procedure SetOnonkeydown(e: TOnEvent);
    procedure SetOnonkeypress(e: TOnEvent);
    procedure SetOnonkeyup(e: TOnEvent);
    procedure SetOnonblur(e: TOnEvent);
    procedure SetOnonreadystatechange(e: TOnEvent);
  published
    property Align;
    property BrowseMode: boolean read fBrowseMode write SetBrowseMode;
    property ActivateDTCs: boolean read fActivateDTCs write SetActivateDTCs;
    property ActivateApplets: boolean read fActivateApplets write SetActivateApplets;
    property ActivateActiveXControls: boolean read fActivateActiveXControls write SetActivateActiveXControls;
    property ScrollBars: boolean read fScrollBars write SetScrollBars;
    property ShowDetails: boolean read fShowDetails write SetShowDetails;
    property OnDocumentComplete: TOnEvent read FOnDocumentComplete write SetOnDocumentComplete;
    property OnDisplayChanged: TOnEvent read FOnDisplayChanged write SetOnDisplayChanged;
    property OnShowContextMenu: TDHTMLEditShowContextMenu read FOnShowContextMenu write SetOnShowContextMenu;
    property OnContextMenuAction: TDHTMLEditContextMenuAction read FOnContextMenuAction write SetOnContextMenuAction;
    property Ononmousedown: TOnEvent read FOnonmousedown write SetOnonmousedown;
    property Ononmousemove: TOnEvent read FOnonmousemove write SetOnonmousemove;
    property Ononmouseup: TOnEvent read FOnonmouseup write SetOnonmouseup;
    property Ononmouseout: TOnEvent read FOnonmouseout write SetOnonmouseout;
    property Ononmouseover: TOnEvent read FOnonmouseover write SetOnonmouseover;
    property Ononclick: TOnEvent read FOnonclick write SetOnonclick;
    property Onondblclick: TOnEvent read FOnondblclick write SetOnondblclick;
    property Ononkeydown: TOnEvent read FOnonkeydown write SetOnonkeydown;
    property Ononkeypress: TOnEvent read FOnonkeypress write SetOnonkeypress;
    property Ononkeyup: TOnEvent read FOnonkeyup write SetOnonkeyup;
    property Ononblur: TOnEvent read FOnonblur write SetOnonblur;
    property Ononreadystatechange: TOnEvent read FOnonreadystatechange write SetOnonreadystatechange;
  end;

  procedure Register;

{$R *.dcr}

implementation

procedure Register;
begin
  RegisterComponents('KOLUtil', [TDHTMLEDIT]);
end;

function TDHTMLEDIT.AdditionalUnits;
begin
   Result := ', KOLDHTML';
end;

const
  AlignValues: array[ TKOLAlign ] of String = ( 'caNone', 'caLeft', 'caTop',
               'caRight', 'caBottom', 'caClient' );

procedure TDHTMLEDIT.SetupFirst;
begin
  SL.Add( Prefix + AName + ' := NewDHTMLEDIT(Result.Form);' );
  if Align <> caNone then begin
     SL.Add( Prefix + AName + '.SetAlign(' + AlignValues[Align] + ');' );
  end else begin
     SL.Add( Prefix + AName + '.SetPosition(' + int2str(Left) + ', ' + int2str(Top) + ');' );
     SL.Add( Prefix + AName + '.SetSize(' + int2str(Width) + ', ' + int2str(Height) + ');' );
  end;
  if fBrowseMode then begin
     SL.Add( Prefix + AName + '.BrowseMode := True;' );
  end;
  if fActivateDTCs then begin
     SL.Add( Prefix + AName + '.ActivateDTCs := True;' );
  end;
  if fActivateApplets then begin
     SL.Add( Prefix + AName + '.ActivateApplets := True;' );
  end;
  if fActivateActiveXControls then begin
     SL.Add( Prefix + AName + '.ActivateActiveXControls := True;' );
  end;
  if not fScrollBars then begin
     SL.Add( Prefix + AName + '.ScrollBars := False;' );
  end;
  if fShowDetails then begin
     SL.Add( Prefix + AName + '.ShowDetails := True;' );
  end;
  AssignEvents(SL, AName);
end;

procedure TDHTMLEDIT.AssignEvents;
begin
  inherited;
  DoAssignEvents( SL, AName,
  [ 'OnDocumentComplete', 'OnDisplayChanged', 'OnShowContextMenu', 'OnContextMenuAction',
    'Ononmousedown', 'Ononmousemove', 'Ononmouseup', 'Ononmouseout', 'Ononmouseover',
    'Ononclick', 'Onondblclick', 'Ononkeydown', 'Ononkeypress', 'Ononkeyup', 'Ononblur',
    'Ononreadystatechange' ],
  [ @OnDocumentComplete,  @OnDisplayChanged,  @OnShowContextMenu, @OnContextMenuAction,
    @Ononmousedown,  @Ononmousemove,  @Ononmouseup,  @Ononmouseout,  @Ononmouseover,
    @Ononclick,  @Onondblclick,  @Ononkeydown,  @Ononkeypress,  @Ononkeyup,  @Ononblur,
    @Ononreadystatechange ]);
end;

procedure TDHTMLEDIT.SetBrowseMode;
begin
   fBrowseMode := m;
   Change;
end;

procedure TDHTMLEDIT.SetActivateDTCs;
begin
   fActivateDTCs := m;
   Change;
end;

procedure TDHTMLEDIT.SetActivateApplets;
begin
   fActivateApplets := m;
   Change;
end;

procedure TDHTMLEDIT.SetActivateActiveXControls;
begin
   fActivateActiveXControls := m;
   Change;
end;

procedure TDHTMLEDIT.SetScrollBars;
begin
   fScrollBars := m;
   Change;
end;

procedure TDHTMLEDIT.SetShowDetails;
begin
   fShowDetails := m;
   Change;
end;

procedure TDHTMLEDIT.SetOnDocumentComplete;
begin
   fOnDocumentComplete := e;
   Change;
end;

procedure TDHTMLEDIT.SetOnDisplayChanged;
begin
   fOnDisplayChanged := e;
   Change;
end;

procedure TDHTMLEDIT.SetOnShowContextMenu;
begin
   fOnShowContextMenu := e;
   Change;
end;

procedure TDHTMLEDIT.SetOnContextMenuAction;
begin
   fOnContextMenuAction := e;
   Change;
end;

procedure TDHTMLEDIT.SetOnonmousedown;
begin
   fOnonmousedown := e;
   Change;
end;

procedure TDHTMLEDIT.SetOnonmousemove;
begin
   fOnonmousemove := e;
   Change;
end;

procedure TDHTMLEDIT.SetOnonmouseup;
begin
   fOnonmouseup := e;
   Change;
end;

procedure TDHTMLEDIT.SetOnonmouseout;
begin
   fOnonmouseout := e;
   Change;
end;

procedure TDHTMLEDIT.SetOnonmouseover;
begin
   fOnonmouseover := e;
   Change;
end;

procedure TDHTMLEDIT.SetOnonclick;
begin
   fOnonclick := e;
   Change;
end;

procedure TDHTMLEDIT.SetOnondblclick;
begin
   fOnondblclick := e;
   Change;
end;

procedure TDHTMLEDIT.SetOnonkeydown;
begin
   fOnonkeydown := e;
   Change;
end;

procedure TDHTMLEDIT.SetOnonkeypress;
begin
   fOnonkeypress := e;
   Change;
end;

procedure TDHTMLEDIT.SetOnonkeyup;
begin
   fOnonkeyup := e;
   Change;
end;

procedure TDHTMLEDIT.SetOnonblur;
begin
   fOnonblur := e;
   Change;
end;

procedure TDHTMLEDIT.SetOnonreadystatechange;
begin
   fOnonreadystatechange := e;
   Change;
end;

end.