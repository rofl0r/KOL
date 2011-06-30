unit OLETable;

interface

uses KOLEdb, KOL, ListEdit, Windows, Messages;

type
    TKOLDataSource = PDataSource;
    TKOLSession = PSession;
    TKOLQuery = PQuery;

    PListData =^TListData;
    TKOLListData = PListData;
    TListData = object(TObj)
     Owner: PControl;
     LView: PControl;
     OWind: longint;
     NWind: longint;
     fRowC: TOnEvent;
     fQuer: PQuery;
    protected
     destructor destroy; virtual;
     procedure NewWndProc(var Msg: TMessage);
     function  GetColor: TColor;
     procedure SetColor(C: TColor);
     function  GetCtl3D: boolean;
     procedure SetCtl3D(C: boolean);
     function  GetCursor: HIcon;
     procedure SetCursor(C: HIcon);
     function  GetEnabled: boolean;
     procedure SetEnabled(E: boolean);
     function  GetTransparent: boolean;
     procedure SetTransparent(T: boolean);
     function  GetVisible: boolean;
     procedure SetVisible(V: boolean);
     function  GetFont: PGraphicTool;
     function  GetTextBkColor: TColor;
     procedure SetTextBkColor(C: TColor);
     function  GetBkColor: TColor;
     procedure SetBkColor(C: TColor);
    public
     function  SetAlign( AAlign: TControlAlign ): PListData;
     function  SetPosition(X, Y: integer): PListData;
     function  SetSize(X, Y: integer): PListData;
     function  CenterOnParent: PListData;

     procedure Open;
     procedure LVColAdd( const aText: String; aalign: TTextAlign; aWidth: Integer );

     property  Color: TColor read GetColor write SetColor;
     property  Ctl3D: boolean read GetCtl3D write SetCtl3D;
     property  Cursor: HIcon read GetCursor write SetCursor;
     property  Enabled: boolean read GetEnabled write SetEnabled;
     property  Transparent: boolean read GetTransparent write SetTransparent;
     property  Visible: boolean read GetVisible write SetVisible;
     property  Font: PGraphicTool read GetFont;
     property  LVTextBkColor: TColor read GetTextBkColor write SetTextBkColor;
     property  LVBkColor: TColor read GetBkColor write SetBkColor;

     property  Query: PQuery read fQuer write fQuer;
     property  OnRowChanged: TOnEvent read fRowC write fRowC;
    end;

function NewKOLTable(s: string): PDataSource;
function NewListData(AParent: PControl; Style: TListViewStyle; Options: TListViewOptions;
  ImageListSmall, ImageListNormal, ImageListState: PImageList): PListData;

implementation

uses objects;

function NewKOLTable;
begin
   Result := NewDataSource(s);
end;

function NewListData;
begin
   New(Result, Create);
   Aparent.Add2AutoFree(Result);
   Result.Owner := Aparent;
   Result.LView := NewListEdit(AParent, Style, Options, ImageListSmall, ImageListNormal, ImageListState);
   Result.fQuer := nil;
   Result.OWind := GetWindowLong(Aparent.Handle, GWL_WNDPROC);
   Result.NWind := LongInt(MakeObjectInstance(Result.NewWndProc));
   SetWindowLong(Aparent.Handle, GWL_WNDPROC, Result.NWind);
end;

destructor TListData.destroy;
begin
   SetWindowLong(Owner.Handle, GWL_WNDPROC, OWind);
   FreeObjectInstance(pointer(NWind));
   inherited;
end;

procedure TListData.NewWndProc;
var i: integer;
    n: integer;
begin
   case Msg.Msg of
   WM_ROWCHANG:
   begin
      n := LView.LVCurItem;
      fQuer.CurIndex := LView.LVItemData[n];
      for i := 1 to fQuer.ColCount - 1 do begin
          fQuer.FieldAsStr[i] := LView.LVItems[n, i - 1];
          LView.LVItems[n, i - 1] := fQuer.FieldAsStr[i];
      end;
      fQuer.Post;
      if Assigned(fRowC) then fRowC(@self);
   end;
   end;
   Msg.Result := CallWindowProc(Pointer(OWind), Owner.Handle, Msg.Msg, Msg.wParam, Msg.lParam);
end;

function  TListData.SetAlign;
begin
   Result := @self;
   LView.SetAlign(AAlign);
end;

function  TListData.SetPosition;
begin
   Result := @self;
   LView.Left := X;
   LView.Top  := Y;
end;

function  TListData.SetSize;
begin
   Result := @self;
   LView.Width  := X;
   LView.Height := Y;
end;

function  TListData.CenterOnParent;
begin
   Result := @self;
   LView.CenterOnParent;
end;

function  TListData.GetColor;
begin
   Result := LView.Color;
end;

procedure TListData.SetColor;
begin
   LView.Color := C;
end;

function  TListData.GetCtl3D;
begin
   Result := LView.Ctl3D;
end;

procedure TListData.SetCtl3D;
begin
   LView.Ctl3D := C;
end;

function  TListData.GetCursor;
begin
   Result := LView.Cursor;
end;

procedure TListData.SetCursor;
begin
   LView.Cursor := C;
end;

function  TListData.GetEnabled;
begin
   Result := LView.Enabled;
end;

procedure TListData.SetEnabled;
begin
   LView.Enabled := E;
end;

function  TListData.GetTransparent;
begin
   Result := LView.Transparent;
end;

procedure TListData.SetTransparent;
begin
   LView.Transparent := T;
end;

function  TListData.GetVisible;
begin
   Result := LView.Visible;
end;

procedure TListData.SetVisible;
begin
   LView.Visible := V;
end;

function  TListData.GetFont;
begin
   Result := LView.Font;
end;

procedure TListData.LVColAdd;
begin
   LView.LVColAdd(aText, aAlign, aWidth);
end;

function  TListData.GetTextBkColor;
begin
   Result := LView.LVTextBkColor;
end;

procedure TListData.SetTextBkColor;
begin
   LView.LVTextBkColor := C;
end;

function  TListData.GetBkColor;
begin
   Result := LView.LVBkColor;
end;

procedure TListData.SetBkColor;
begin
   LView.LVBkColor := C;
end;

procedure TListData.Open;
var i: integer;
    n: integer;
    s: string;
    d: double;
    f: integer;
begin
   if fQuer <> nil then begin
      if fQuer.Session.DataSource.Initialized then begin
         fQuer.Open;
         fQuer.First;
         f := fQuer.FirstColumn;
         while not fQuer.EOF do begin
            s := fQuer.FieldAsStr[f];
            i := LView.LVItemAdd(s);
            LView.LVItemData[i] := fQuer.CurIndex;
            for n := f + 1 to fQuer.ColCount - 1 do begin
               try
                  LView.LVItems[i, n - f] := fQuer.FieldAsStr[n];
               except
                  LView.LVItems[i, n - f] := '';
               end;
            end;
            fQuer.Next;
         end;
      end;
   end;
end;

end.