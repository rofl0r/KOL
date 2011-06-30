//---------------------------------------------------------------//
//                                                               //
//                        SPLPicture                             //
//                                                               //
//     Visual KOL control for displaying and storing bitmaps.    //
//                             ---                               //
//                                                               //
//        author:     Alexander Pravdin aka SPeller              //
//        version:    1.0                                        //
//        date:       10-dec-2002                                //
//        e-mail:     speller@mail.primorye.ru                   //
//        www:        http://kol.mastak.ru                       //
//                                                               //
//---------------------------------------------------------------//

unit KOLSPLPicture;

interface
uses Windows, KOL;

type

PSPLPicture = ^TSPLPicture;
TSPLPicture = object( TControl )
  private
    fBitmap: PBitmap;
//    fBmpCreated: Boolean;
//    function GetBitmap: PBitmap;
  public
    property Bitmap: PBitmap read fBitmap;
    constructor Create( const AParent: PControl; const EdgeStyle: TEdgeStyle );
//    destructor Destroy; virtual;
    procedure SelfPaint( Sender: PControl; DC: HDC );// Обработчик
//    OnPaint по умолчанию, производящий отрисовку битмапа на
//    контроле. При желании можно повесить свой, но чтобы вернуть
//    обратно, не забудьте снова OnPaint присвоить SelfPaint.
//    Default OnPaint handler, draws bitmap on the control. Assign
//    your own procedure if you wish to draw another bitmap or do
//    any changes in the drawing process, but don't forget assign
//    it back.

    procedure Refresh;// "Насильная" отрисовка. Используйте её при
//    необходимости обновить изображение, например при загрузке
//    нового битмапа.
//    Redraws bitmap. Should be used to update picture on the
//    control when, for example, new bitmap loaded.
end;

TKOLSPLPicture = PSPLPicture;

function NewSPLPicture( const AParent: PControl; const EdgeStyle: TEdgeStyle ): PSPLPicture;


implementation


function NewSPLPicture( const AParent: PControl; const EdgeStyle: TEdgeStyle ): PSPLPicture;
begin
  New( Result, Create( AParent, EdgeStyle ) );
end;

constructor TSPLPicture.Create( const AParent: PControl; const EdgeStyle: TEdgeStyle );
const Edgestyles: array[ TEdgeStyle ] of DWORD = ( WS_DLGFRAME, SS_SUNKEN, 0 );
begin
  inherited CreateParented( AParent );
  fControlClassName := 'STATIC';
  if AParent <> nil then
  begin
     fCtl3Dchild := True;
     fCtl3D := False;
     fMargin := AParent.Margin;
     with fBoundsRect do
     begin
       Left := 0;
       Top  := 0;
       Right := 64;
       Bottom := 64;
     end;
     fTextColor := AParent.ProgressColor;
     fFont := fFont.Assign( AParent.Font );
     if fFont <> nil then
     begin
       fFont.OnChange := FontChanged;
       FontChanged( fFont );
     end;
     fColor := AParent.Color;
     fBrush := fBrush.Assign( AParent.Brush );
     if fBrush <> nil then
     begin
       fBrush.OnChange := BrushChanged;
       BrushChanged( fBrush );
     end;
    fTabOrder := AParent.ParentForm.TabOrder + 1;
    fCursor := AParent.Cursor;
  end;
  fIsControl := True;
  fStyle := WS_VISIBLE or WS_CHILD or SS_NOTIFY or SS_LEFTNOWORDWRAP
    or SS_NOPREFIX or WS_CLIPSIBLINGS or WS_CLIPCHILDREN or Edgestyles[ EdgeStyle ];
  fVisible := (fStyle and WS_VISIBLE) <> 0;
  fTabstop := (fStyle and WS_TABSTOP) <> 0;
  fLookTabKeys := [ tkTab, tkLeftRight, tkUpDown, tkPageUpPageDn ];
{  fMenu := CtlIdCount;
  Inc( CtlIdCount );}
  AttachProc( WndProcCtrl );
  ExStyle := ExStyle or WS_EX_CONTROLPARENT;

  OnPaint := SelfPaint;

  fBitmap := NewBitmap( 0, 0 );
  Add2AutoFree( fBitmap );
//  fBmpCreated := False;
end;

{destructor TSPLPicture.Destroy;
begin
//  fBitmap.Free;
  inherited;
end;}

procedure TSPLPicture.SelfPaint( Sender: PControl; DC: HDC );
var r: TRect; oldObj, tmDC, tmBmp: Cardinal;
begin
  r := MakeRect( 0, 0, ClientWidth + 0, ClientHeight + 2 );
  tmDC := CreateCompatibleDC( DC );
  tmBmp := CreateCompatibleBitmap( DC, r.Right, r.Bottom );
  oldObj := SelectObject( tmDC, tmBmp );
  FillRect( tmDC, r, Canvas.Brush.Handle );
  if not fBitmap.Empty then fBitmap.Draw( tmDC, 0, 0 );
  BitBlt( DC, 0, 0, r.Right, r.Bottom, tmDC, 0, 0, SRCCOPY );
  SelectObject( tmDC, oldObj );
  DeleteDC( tmDC );
  DeleteObject( tmBmp );
end;

procedure TSPLPicture.Refresh;
begin
  if Assigned( OnPaint ) then OnPaint( @Self, Canvas.Handle );
end;

{function TSPLPicture.GetBitmap: PBitmap;
begin
  if not fBmpCreated then begin
      fBitmap := NewBitmap( 0, 0 );
      Add2AutoFree( fBitmap );
      fBmpCreated := True;
  end;
  Result := fBitmap;
end;}




end.
