unit KOLDual;
{*
Simple dual list dialog for KOL.
|<br>
Idea from dual list component from RXLibrary.
|<br>
Version 1.0
|<br>
Author : Boguslaw Brandys
|<br>
Email : brandysb@poczta.onet.pl
|<br>
Todo :
|<br>
- drag'and drop
|<br>
- default ESC to close dual dialog without any action
}

interface

uses
 KOL,
 Windows;

{$I KolDef.inc} { you'll find KolDef.inc in KOL installation directory }

type
  PDualList =^TDualList;

  TDualList = object(TObj)
  private
  { Private declarations }
     Form          : PControl;


     {Components for Dual list form}
     Panel1              : PControl;
     List1,List2         : PControl;
     btn1,btn2,btn3,btn4 : PControl;
     h1,h2,h3,h4         : HBitmap;//set of handles for bitmaps
     lblList1,lblList2   : PControl;
     btnOK,btnCancel     : PControl;

     {Methods for Dual list form}
     procedure btnCancelClick(Sender: PObj);
     procedure btn2Click(Sender: PObj);
     procedure btn4Click(Sender: PObj);
     procedure List1KeyDown(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
     procedure btn1Click(Sender: PObj);
     procedure btn3Click(Sender: PObj);
     procedure List1SelChange(Sender: PObj);
     procedure List2KeyDown(Sender: PControl; var Key: Integer;
       Shift: Cardinal);
     procedure btnOKClick(Sender: PObj);
     procedure List2SelChange(Sender: PObj);
     procedure List1MouseDblClk(Sender: PControl;
       var Mouse: TMouseEventData);
     procedure List2MouseDblClk(Sender: PControl;
       var Mouse: TMouseEventData);

     {Additional functions}
     procedure DoButtons;
     function  SelCount(List : PControl): Integer;
  public
  end;


function DualListDialog(const Title,SrcTitle,DestTitle,OKCaption,CancelCaption:String;Src,Dest : PStrList): Boolean;{$IFNDEF _D2orD3}overload{$ENDIF};
{* Function to visually switch items among two string lists
|<br>
Title - title of dual form
|<br>
SrcTitle,DestTitle - captions of two listboxes used for visual operation with string lists
|<br>
OKCaption,CancelCaption - use this to customise dual list dialog.
|<br>
Src,Dest - string lists under manipulation
|<br>
Note : put
|<br>
!uses KOLDual;
into implementation section.
 }
{$IFNDEF _D2orD3}
function DualListDialog(const Title,SrcTitle,DestTitle:String;Src,Dest : PStrList): Boolean;overload;
{* Overloaded}
{$ENDIF}

implementation

{$R DualList.res}


function DualListDialog(const Title,SrcTitle,DestTitle,OKCaption,CancelCaption:String;Src,Dest : PStrList): Boolean;
var
Dual   : PDualList;
i      : Integer;
begin
  Result := False;
  New(Dual, Create);
  Dual.Form  := NewForm(Applet, Title).SetPosition( 187, 107 ).SetSize( 385, 318 ).Tabulate;
  with Dual^ do begin
  Form.Style := Form.Style and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX);
  DeleteMenu( GetSystemMenu( Form.GetWindowHandle, False ), SC_CLOSE, MF_BYCOMMAND );
  lblList2 := NewLabel(Form, DestTitle).SetPosition( 208, 8 ).SetSize( 121, 12 );
  lblList2.Font.FontHeight := 8;
  lblList1 := NewLabel( Form, SrcTitle ).SetPosition( 8, 8 ).SetSize( 121, 12 );
  lblList1.Font.FontHeight := 8;
  Panel1 := NewPanel( Form, esLowered ).SetPosition( 0, 24 ).SetSize( 377, 233 );
  List1 := NewListBox( Panel1, [ loNoExtendSel, loNoIntegralHeight, loTabstops, loNoData ] ).SetPosition( 7, 7 ).SetSize( 161, 217 );
  List1.Font.FontHeight := 8;
  List1.Cursor := LoadCursor( 0, IDC_HAND );
  List1.OnMouseDblClk := List1MouseDblClk;
  List1.OnKeyDown := List1KeyDown;
  List1.OnSelChange := List1SelChange;
  List2 := NewListBox( Panel1, [ loNoExtendSel, loNoIntegralHeight, loTabstops, loNoData ] ).SetPosition( 207, 7 ).SetSize( 161, 217 );
  List2.Font.FontHeight := 8;
  List2.Cursor := LoadCursor( 0, IDC_HAND );
  List2.OnMouseDblClk := List2MouseDblClk;
  List2.OnKeyDown := List2KeyDown;
  List2.OnSelChange := List2SelChange;
  h1 := LoadBitmap( hInstance, 'BTN1_BITMAP');
  h2 := LoadBitmap( hInstance, 'BTN2_BITMAP');
  h3 := LoadBitmap( hInstance, 'BTN3_BITMAP');
  h4 := LoadBitmap( hInstance, 'BTN4_BITMAP');
  btn2 := NewBitBtn( Panel1, '', [ bboNoCaption ], glyphOver,h2, 4 ).SetPosition( 175, 60 ).SetSize( 25, 25 ).LikeSpeedButton;
  btn2.TextAlign := taRight;
  btn2.Enabled := False;
  btn2.OnClick := btn2Click;
  btn1 := NewBitBtn( Panel1, '', [ bboNoCaption ], glyphOver,h1, 4 ).SetPosition( 175, 31 ).SetSize( 25, 25 ).LikeSpeedButton;
  btn1.TextAlign := taRight;
  btn1.Enabled := False;
  btn1.OnClick := btn1Click;
  btn4 := NewBitBtn( Panel1, '', [ bboNoCaption ], glyphOver, h4, 4 ).SetPosition( 175, 119 ).SetSize( 25, 25 ).LikeSpeedButton;
  btn4.TextAlign := taRight;
  btn4.Enabled := False;
  btn4.OnClick := btn4Click;
  btn3 := NewBitBtn( Panel1, '', [ bboNoCaption ], glyphOver, h3, 4 ).SetPosition( 175, 90 ).SetSize( 25, 25 ).LikeSpeedButton;
  btn3.TextAlign := taRight;
  btn3.Enabled := False;
  btn3.OnClick := btn3Click;
  btnOK := NewButton( Form, OKCaption ).SetPosition( 208, 264 ).SetSize( 73, 25 );
  btnOK.Font.FontHeight := 8;
  btnOK.OnClick := btnOKClick;
  btnCancel := NewButton( Form, CancelCaption ).SetPosition( 296, 264 ).SetSize( 73, 25 );
  btnCancel.Font.FontHeight := 8;
  btnCancel.OnClick := btnCancelClick;
  Form.CenterOnParent.CanResize := False;
  try
  List1.Clear;
  List2.Clear;
  for i:=0 to Src.Count-1 do List1.Add(Src.Items[i]);
  for i:=0 to Dest.Count-1 do List2.Add(Dest.Items[i]);
  DoButtons;
  Form.ShowModal;
  if Form.ModalResult = 1 then
    begin
    Result := True;
    Src.Clear;
    Dest.Clear;
    for i:=0 to List1.Count-1 do Src.Add(List1.Items[i]);
    for i:=0 to List2.Count-1 do Dest.Add(List2.Items[i]);
    end;
  finally
  Form.Close;
  Form.Free;
  DeleteObject(h1);
  DeleteObject(h2);
  DeleteObject(h3);
  DeleteObject(h4);
  end;
  end;
end;

{$IFNDEF _D2orD3}
function DualListDialog(const Title,SrcTitle,DestTitle:String;Src,Dest : PStrList): Boolean;
begin
Result :=DualListDialog(Title,SrcTitle,DestTitle,'&OK','&Cancel',Src,Dest);
end;
{$ENDIF}


{------- Dual list  form methods and properties -------}


function TDualList.SelCount(List : PControl): Integer;
var
i : Integer;
begin
Result := 0;
for i:=0 to List.Count-1 do
    begin
        if List.ItemSelected[i] then Inc(Result);
    end;
end;

procedure TDualList.DoButtons;
begin
btn2.Enabled  := Boolean(List1.Count);
btn4.Enabled  := Boolean(List2.Count);
btn1.Enabled  := Boolean(SelCount(List1));
btn3.Enabled  := Boolean(SelCount(List2));
end;

procedure TDualList.btnCancelClick(Sender: PObj);
begin
Form.ModalResult := 2;
end;

procedure TDualList.btn2Click(Sender: PObj);
var
i : Integer;
begin
for i:=0 to List1.Count-1 do List2.Add(List1.Items[i]);
List1.Clear;
DoButtons;
end;

procedure TDualList.btn4Click(Sender: PObj);
var
i : Integer;
begin
for i:=0 to List2.Count-1 do List1.Add(List2.Items[i]);
List2.Clear;
DoButtons;
end;

procedure TDualList.List1KeyDown(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
var
Incr : Integer;
begin
if (Shift=MK_SHIFT) and ((Key = VK_DOWN) or (Key = VK_UP)) then begin
      if Key = VK_DOWN then Incr := 1
      else Incr := -1;
      if not List1.ItemSelected[List1.CurIndex + Incr] then
         List1.ItemSelected[List1.CurIndex + Incr] := True
      else
         begin
         List1.ItemSelected[List1.CurIndex] := False;
         List1.ItemSelected[List1.CurIndex + Incr] := True;
      end;
      Key := 0;
    end;

end;





procedure TDualList.btn1Click(Sender: PObj);
var
k,i : Integer;
begin
k:=0;
for i:=List1.Count-1 downto 0 do
    begin
        if List1.ItemSelected[i]= True then
            begin
                List2.Add(List1.Items[i]);
                List1.Delete(i);
                k := i;

        end;
    end;
List1.ItemSelected[k] := True;
DoButtons;
end;

procedure TDualList.btn3Click(Sender: PObj);
var
k,i : Integer;
begin
k:=0;
for i:=List2.Count-1 downto 0 do
    begin
        if List2.ItemSelected[i]=True then
            begin
                List1.Add(List2.Items[i]);
                List2.Delete(i);
                k := i;
        end;
    end;
List2.ItemSelected[k] := True;
DoButtons;
end;



procedure TDualList.List1SelChange(Sender: PObj);
begin
DoButtons;
end;

procedure TDualList.List2KeyDown(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
var
Incr : Integer;
begin
if (Shift=MK_SHIFT) and ((Key = VK_DOWN) or (Key = VK_UP)) then begin
      if Key = VK_DOWN then Incr := 1
      else Incr := -1;
      if not List2.ItemSelected[List2.CurIndex + Incr] then
         List2.ItemSelected[List2.CurIndex + Incr] := True
      else
         begin
         List2.ItemSelected[List2.CurIndex] := False;
         List2.ItemSelected[List2.CurIndex + Incr] := True;
      end;
      Key := 0;
    end;
end;

procedure TDualList.btnOKClick(Sender: PObj);
begin
Form.ModalResult := 1;
end;

procedure TDualList.List2SelChange(Sender: PObj);
begin
DoButtons;
end;

procedure TDualList.List1MouseDblClk(Sender: PControl;
  var Mouse: TMouseEventData);
var
i : Integer;
begin
i := List1.CurIndex;
List2.Add(List1.Items[i]);
List1.Delete(i);
List1.ItemSelected[i] := True;
end;

procedure TDualList.List2MouseDblClk(Sender: PControl;
  var Mouse: TMouseEventData);
var
i : Integer;
begin
i := List2.CurIndex;
List1.Add(List2.Items[i]);
List2.Delete(i);
List2.ItemSelected[i] := True;
end;

end.




