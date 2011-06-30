unit ListEdit;

interface
uses KOL, Windows, Messages, objects;

const
   WM_JUSTFREE = WM_USER + 51;
   WM_EDITFREE = WM_USER + 52;
   WM_DBLCLICK = WM_USER + 53;
   WM_ROWCHANG = WM_USER + 54;

type

   PListEdit =^TListEdit;
   TKOLListEdit = PControl;
   TListEdit = object(Tobj)
     EList: PList;
     Enter: boolean;
     LView: PControl;
     TabSave: boolean;
     TabStrt: boolean;
     OldWind: longint;
     NewWind: longint;
     CurEdit: integer;
     destructor destroy; virtual;
     procedure SetEvents(LV: PControl);
     procedure NewWndProc(var Msg: TMessage);
     procedure LVPaint;
     procedure LVDblClk;
     procedure LVChange(Store: boolean);
     procedure PostFree(var Key: integer);
     procedure EDChar(Sender: PControl; var Key: integer; Sh: Cardinal);
     procedure EDPres(Sender: PControl; var Key: integer; Sh: Cardinal);
     procedure EDentr(Sender: PObj);
   end;

function NewListEdit(AParent: PControl; Style: TListViewStyle; Options: TListViewOptions;
  ImageListSmall, ImageListNormal, ImageListState: PImageList): PControl;

implementation

function NewListEdit;
var p: PListEdit;
begin
   Result := NewListView(AParent, Style, Options, ImageListSmall, ImageListNormal, ImageListState);
   Result.CreateWindow;
   New(p, create);
   AParent.Add2AutoFree(p);
   p.LView := Result;
   p.SetEvents(PControl(Result));
end;

destructor TListEdit.destroy;
begin
   LVChange(False);
   EList.Free;
   SetWindowLong(LView.Handle, GWL_WNDPROC, OldWind);
   FreeObjectInstance(Pointer(NewWind));
   inherited;
end;

procedure TListEdit.SetEvents;
begin
   EList              := NewList;
   Enter              := False;
   TabStrt            := False;
   OldWind := GetWindowLong(LV.Handle, GWL_WNDPROC);
   NewWind := LongInt(MakeObjectInstance(NewWndProc));
   SetWindowLong(LV.Handle, GWL_WNDPROC, NewWind);
end;

procedure TListEdit.NewWndProc;
var e: boolean;
begin
   e := EList.Count > 0;
   case Msg.Msg of
WM_LBUTTONDOWN:
      begin
         LVChange(True);
         CurEdit := 0;
         if e then PostMessage(LView.Handle, WM_DBLCLICK, 0, 0);
      end;
WM_LBUTTONDBLCLK:
      begin
         LVDblClk;
      end;
WM_KEYDOWN:
      begin
         if Msg.WParam = 13 then begin
            LVDblClk;
         end else
{         if Msg.WParam = 27 then begin
            LVChange(False);
         end else begin
            LVChange(True);
            if e then PostMessage(LView.Handle, WM_DBLCLICK, 0, 0);
         end;}
      end;
WM_NCPAINT:
      begin
         LVPaint;
      end;
WM_JUSTFREE:
      begin
         LVChange(Msg.WParam <> 27);
      end;
WM_EDITFREE:
      begin
         LVChange(Msg.WParam <> 27);
         if e then PostMessage(LView.Handle, WM_DBLCLICK, 0, 0);
      end;
WM_DBLCLICK:
      begin
         LVDblClk;
      end;
WM_PAINT:
      begin
         LVPaint;
      end;
   end;
   Msg.Result := CallWindowProc(Pointer(OldWind), LView.Handle, Msg.Msg, Msg.wParam, Msg.lParam);
end;

procedure TListEdit.LVPaint;
var i: integer;
    r: TRect;
    l: integer;
    e: PControl;
    p: TPoint;
begin
with LView^ do begin
   SendMessage(Handle, WM_SETFONT, Font.Handle, 0);
   l := 0;
   p := LVItemPos[0];
   for i := 0 to EList.Count - 1 do begin
      r := LVItemRect(LVCurItem, lvipBounds);
      r.Left  := l + p.X;
      r.Right := l + LVColWidth[i] + p.X;
      Dec(r.Top);
      Inc(r.Bottom);
      e := EList.Items[i];
      e.BoundsRect := r;
      l := l + LVColWidth[i];
   end;
end;
end;

procedure TListEdit.LVDblClk;
var i: integer;
    e: PControl;
    r: TRect;
    l: integer;
    a: PControl;
    p: TPoint;
    o: TPoint;
begin
with LView^ do begin
   if EList.Count <> 0 then LVChange(True);
   if enter then exit;
   enter := true;
   l := 0;
   a := nil;
   GetCursorPos(p);
   p := Screen2Client(p);
   o := LVItemPos[0];
   for i := 0 to LVColCount - 1 do begin
      r := LVItemRect(LVCurItem, lvipBounds);
      r.Left  := l + o.X;
      r.Right := l + LVColWidth[i] + o.X;
      l := l + LVColWidth[i];
      Dec(r.Top);
      Inc(r.Bottom);
      e := NewEditBox(LView, []);
      EList.Add(e);
      e.BoundsRect       := r;
      e.DoubleBuffered   := True;
      e.Tabstop          := True;
      e.Font.FontHeight  := LView.Font.FontHeight;
      e.Font.FontCharset := 204;
      e.Text             := LVItems[LVCurItem, i];
      e.OnKeyDown        := EDChar;
      e.OnKeyUp          := EDPres;
      e.OnEnter          := EDEntr;
      e.Show;
      if a = nil then a := e;
      if (CurEdit <>  0) then
      if (EList.Count = CurEdit) then a := e else else
      if (r.Left <= p.x) and (r.Right >= p.x) then
          a := e;
   end;
   if a <> nil then a.Focused := True;
   TabSave := TabStop;
   TabStop := False;
   TabStrt := True;
   enter := false;
end;
end;

procedure TListEdit.LVChange;
var e: PControl;
    i: integer;
    g: boolean;
begin
with LView^ do begin
   if enter then exit;
   enter := true;
   g := False;
   for i := 0 to EList.Count - 1 do begin
      e := EList.Items[i];
      if Store then begin
         g := g or (LVItems[LVCurItem, i] <> e.Text);
         LVItems[LVCurItem, i] := e.Text;
      end;
      if e.Focused then CurEdit := i + 1;
      e.Free;
   end;
   EList.Clear;
   enter := false;
   if TabStrt then TabStop := TabSave;
   if g then
   SendMessage(Parent.Handle, WM_ROWCHANG, LVCurItem, 0);
end;
end;

procedure TListEdit.PostFree;
begin
with LView^ do begin
   if Key = 27 then
      PostMessage(Handle, WM_JUSTFREE, key, 0);
   if Key = 13 then
      PostMessage(Handle, WM_EDITFREE, key, 0);
   if ((key = 40) and (LView.LVCurItem < LView.LVCount - 1)) or
      ((key = 38) and (LView.LVCurItem > 0)) then begin
      PostMessage(Handle, WM_EDITFREE, key, 0);
      PostMessage(Handle, wm_keydown, Key, 0);
      PostMessage(Handle, wm_keyup, Key, 0);
   end;
end;
end;

procedure TListEdit.EDChar;
begin
   case key of
 13,
 27,
 38,
 40: PostFree(key);
   end;
end;

procedure TListEdit.EDPres;
begin
   case key of
 38,
 40: key := 0;
   end;
end;

procedure TListEdit.EDentr;
begin
   PControl(Sender).SelectAll;
end;

end.
