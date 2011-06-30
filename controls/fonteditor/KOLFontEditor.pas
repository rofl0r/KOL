unit KOLFontEditor;
{
==================================================================

                  TKOLFont Property Editor
                          for MCK

          -----------------------------------------------
          Version:  1.0
          Date:     16-sep-2003
          Author:   (C) Alexander Pravdin (aka SPeller)
          e-mail:   speller@mail.primorye.ru
          www:      http://kol.mastak.ru
                    http://bonanzas.rinet.ru

          Thanks to:
          Dmitry Zharov (aka Gandalf):
                    Start point of this component (MHFontDialog).
                    Delphi 5 and Delphi 7 support.

          Tested Delphi versions: 5, 6, 7.


==================================================================}

interface

{$I KOLDEF.INC}

uses KOL, Windows, Messages, Graphics, Forms, CommDlg, Mirror,
{$IFDEF _D6orHigher}
    DesignEditors, DesignIntf;
{$ELSE}
    DsgnIntf;
{$ENDIF}

type

  TKOLFontProperty = class( TClassProperty )
  private
    DlgWnd,
    hWndOwner,
    LabelWnd,
    PickWnd,
    FontLWnd,
    EditWnd,
    CBWnd: HWND;
    ColorDlg: PColorDialog;
    Top, Left, Height, Width,
    OldPickWndProc,
    OldEditWndProc: Integer;
    Colors: PList;
    Font: TFont;
    Color: Integer;
    function DlgExecute: Boolean;
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;



procedure Register;


implementation

const
  ID_DLGOBJ = 'ID_DLGOBJ'#0;
  DLG_LBLID = 11200;
  DLG_PICKID = 11201;
  DLG_EDITID = 11202;
  DLG_COLORCB = 1139;
  DLG_EFFECTSGROUP = 1072;

  CN_APPLYCOLOR = 501;


function PickWndProc( Wnd: HWND; Msg: Cardinal; wParam, lParam: Integer ): Integer; stdcall;
var _Self: TKOLFontProperty;
    R: TRect;
    hBr, DC: THandle;
begin
  _Self := TKOLFontProperty( GetProp( Wnd, ID_DLGOBJ ) );
  with _Self do begin
  case Msg of
    WM_PAINT: begin
      GetClientRect( Wnd, R );
      CallWindowProc( Pointer( OldPickWndProc ), Wnd, Msg, wParam, lParam );
      hBr := CreateSolidBrush( Color );
      DC := GetDC( Wnd );
      FillRect( DC, R, hBr );
      ReleaseDC( Wnd, DC );
      DeleteObject( hBr );
      Result := 0;
      Exit;
    end;
  end; // case
  Result := CallWindowProc( Pointer( OldPickWndProc ), Wnd, Msg, wParam, lParam );
  end; // with
end;



function EditWndProc( Wnd: HWND; Msg: Cardinal; wParam, lParam: Integer ): Integer; stdcall;
var _Self: TKOLFontProperty;
begin
  _Self := TKOLFontProperty( GetProp( Wnd, ID_DLGOBJ ) );
  with _Self do begin
  Result := CallWindowProc( Pointer( OldEditWndProc ), Wnd, Msg, wParam, lParam );
  end; // with
end;



function FontDialogHook(Wnd: HWnd; Msg: UINT; WParam: WPARAM; LParam: LPARAM): UINT; stdcall;
var
    _Self: TKOLFontProperty;
    R, R2, SR: TRect;
    I, tmID, CBCurSel, CBCount: Integer;
    PCF: PChooseFontA;
    tmWnd, ChildWnd, hFont: THandle;
    st: string;
    FR: Boolean;
begin
  Result:=0;
  _Self := TKOLFontProperty( GetProp( Wnd, ID_DLGOBJ ) );
  if (_Self = nil) and (Msg = WM_INITDIALOG) then begin
    PCF := Pointer( lParam );
    SetProp( Wnd, ID_DLGOBJ, Cardinal( PCF.lCustData ) );
    _Self := TKOLFontProperty( GetProp( Wnd, ID_DLGOBJ ) );
  end;

  with _Self do begin
  case Msg of
    WM_INITDIALOG: begin
      DlgWnd := Wnd;
      GetWindowRect( Wnd, R );
      SR := MakeRect( 0, 0, GetSystemMetrics( SM_CXSCREEN ), GetSystemMetrics( SM_CYSCREEN ) );
      Width := R.Right - R.Left;
      Height := R.Bottom - R.Top + 0;
      Left := (SR.Left + SR.Right - Width) div 2;
      Top := (SR.Top + SR.Bottom - Height) div 2;
      SetWindowPos( Wnd, 0, Left, Top, Width, Height, SWP_NOZORDER );

      ChildWnd := 0;
      repeat
        ChildWnd := FindWindowEx( Wnd, ChildWnd, 'COMBOBOX', nil );
        tmID := GetWindowLong( ChildWnd, GWL_ID );
      until (tmID = DLG_COLORCB) or (ChildWnd = 0);
      if ChildWnd <> 0 then begin
        CBWnd := ChildWnd;
        GetWindowRect( CBWnd, R );
        R.Right := R.Right + 5;
        SetWindowPos( CBWnd, 0, 0, 0, R.Right - R.Left, R.Bottom - R.Top, SWP_NOZORDER or SWP_NOMOVE );
      end else
        Exit;

      ChildWnd := 0;
      repeat
        ChildWnd := FindWindowEx( Wnd, ChildWnd, 'BUTTON', nil );
        tmID := GetWindowLong( ChildWnd, GWL_ID );
      until (tmID = DLG_EFFECTSGROUP) or (ChildWnd = 0);
      if ChildWnd <> 0 then begin
        tmWnd := ChildWnd;
        GetWindowRect( tmWnd, R );
        ScreenToClient( Wnd, R.TopLeft );
        ScreenToClient( Wnd, R.BottomRight );
        R.Bottom := R.Bottom + 20;
        SetWindowPos( tmWnd, HWND_BOTTOM, R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top, 0 );
      end else
        Exit;

      ChildWnd := 0;
      repeat
        ChildWnd := FindWindowEx( Wnd, ChildWnd, 'STATIC', nil );
        tmID := GetWindowLong( ChildWnd, GWL_ID );
      until (tmID = 1093) or (ChildWnd = 0);
      if ChildWnd <> 0 then begin
        FontLWnd := ChildWnd;
        GetWindowRect( FontLWnd, R2 );
        R2 := MakeRect( 7, 172, 219, 20 );
        R2.Top := R2.Top + 25;
        R2.Bottom := R2.Bottom + 20;
        SetWindowPos( FontLWnd, 0, R2.Left, R2.Top, R2.Right - R2.Left, R2.Bottom - R2.Top, SWP_NOZORDER );
      end;

      LabelWnd := CreateWindow( 'STATIC', 'Exactly:',
          SS_LEFT or WS_VISIBLE or WS_CHILD,
          R.Left + 10, R.Bottom - 26, 40, 15,
          Wnd, 0, hInstance, nil );
      SetWindowLong( LabelWnd, GWL_ID, DLG_LBLID );
      SetProp( LabelWnd, ID_DLGOBJ, Cardinal( _Self ) );
      hFont := SendMessage( Wnd, WM_GETFONT, 0, 0 );
      SendMessage( LabelWnd, WM_SETFONT, hFont, 0 );

      if WinVer >= wvXP then begin
        I := 0;
        tmID := WS_BORDER;
      end else begin
        I := WS_EX_CLIENTEDGE;
        tmID := 0;
      end;
      PickWnd := CreateWindowEx( I,
          'STATIC', nil,
          WS_VISIBLE or WS_CHILD or SS_NOTIFY or tmID,
          R.Left + 116, R.Bottom - 30, 21, 21,
          Wnd, 0, hInstance, nil );
      SetProp( PickWnd, ID_DLGOBJ, Cardinal( _Self ) );
      SetWindowLong( PickWnd, GWL_ID, DLG_PICKID );
      OldPickWndProc := SetWindowLong( PickWnd, GWL_WNDPROC, Integer( @PickWndProc ) );

      EditWnd := CreateWindowEx( WS_EX_CLIENTEDGE,
          'EDIT', nil,
          WS_VISIBLE or WS_CHILD or ES_UPPERCASE or ES_AUTOHSCROLL,
          R.Left + 60, R.Bottom - 30, 55, 21,
          Wnd, 0, hInstance, nil );
      SetWindowLong( EditWnd, GWL_ID, DLG_EDITID );
      SetProp( EditWnd, ID_DLGOBJ, Cardinal( _Self ) );
      SendMessage( EditWnd, WM_SETFONT, hFont, 0 );
      SendMessage( EditWnd, EM_SETLIMITTEXT, 6, 0 );
      OldEditWndProc := SetWindowLong( EditWnd, GWL_WNDPROC, Integer( @EditWndProc ) );

      ColorDlg.OwnerWindow := Wnd;

      CBCount := SendMessage( CBWnd, CB_GETCOUNT, 0, 0 );
      for I := 0 to CBCount - 1 do begin
        Colors.Add( Pointer( SendMessage( CBWnd, CB_GETITEMDATA, I, 0 ) ) );
      end;
      CBCurSel := Colors.IndexOf( Pointer( Color ) );
      if CBCurSel < 0 then begin
        SendMessage( CBWnd, CB_ADDSTRING, 0, Integer( PChar( '$' + Int2Hex( Color, 6 ) ) ) );
        Colors.Add( Pointer( Color ) );
        CBCurSel := Colors.Count - 1;
        SendMessage( CBWnd, CB_SETITEMDATA, CBCurSel, Color );
      end;
      SendMessage( CBWnd, CB_SETCURSEL, CBCurSel, 0 );
      TSmallPoint( I ).x := DLG_COLORCB;
      TSmallPoint( I ).y := CBN_SELCHANGE;
      SendMessage( Wnd, WM_COMMAND, I, CBWnd );

    end;

    WM_COMMAND: begin
      case TSmallPoint( wParam ).X of
        DLG_PICKID: begin
          case TSmallPoint( wParam ).Y of
            STN_CLICKED: begin
              if GetWindowLong( PickWnd, GWL_USERDATA ) = CN_APPLYCOLOR then
                FR := True
              else begin
                ColorDlg.Color := Color;
                FR := ColorDlg.Execute;
                if FR then Color := ColorDlg.Color;
              end;
              if FR then begin
                //-----
                CBCurSel := Colors.IndexOf( Pointer( Color ) );
                if CBCurSel < 0 then begin
                  SendMessage( CBWnd, CB_ADDSTRING, 0, Integer( PChar( '$' + Int2Hex( Color, 6 ) ) ) );
                  Colors.Add( Pointer( Color ) );
                  CBCurSel := Colors.Count - 1;
                  SendMessage( CBWnd, CB_SETITEMDATA, CBCurSel, Color );
                end;
                SendMessage( CBWnd, CB_SETCURSEL, CBCurSel, 0 );
                TSmallPoint( I ).Y := CBN_SELCHANGE;
                TSmallPoint( I ).X := DLG_COLORCB;
                SendMessage( Wnd, WM_COMMAND, I, CBWnd );
                //-----
              end;
            end; // STN_CLICKED
          end; // case
        end; // DLG_PICKID

        DLG_COLORCB: begin
          if TSmallPoint( wParam ).Y = CBN_SELCHANGE then begin
            CBCurSel := SendMessage( CBWnd, CB_GETCURSEL, 0, 0 );
            if CBCurSel >= 0 then begin
              Color := SendMessage( CBWnd, CB_GETITEMDATA, CBCurSel, 0 );
              SetWindowText( EditWnd, PChar( Int2Hex( Color, 6 ) ) );
              SendMessage( PickWnd, WM_PAINT, 0, 0 );
            end;
          end;
        end; // DLG_COLORCB

        DLG_EDITID: begin
          case TSmallPoint( wParam ).Y of
            EN_CHANGE: begin
              SetLength( st, 20 );
              GetWindowText( EditWnd, @st[ 1 ], 18 );
              Color := Hex2Int( st );
              SendMessage( PickWnd, WM_PAINT, 0, 0 );
            end;
          end;
        end; // DLG_EDITID

      end; // case TSmallPoint( wParam ).X
    end; // WM_COMMAND

  end; // case
  end; // with
end;



function TKOLFontProperty.DlgExecute:Boolean;
var
  TMPCF:tagChooseFont;
  TMPLogFont:tagLogFontA;
begin
  FillChar( TMPCF, SizeOf( TMPCF ), 0 );
  GetObject( Font.Handle, SizeOf( tagLOGFONT ), @TMPLogFont );

  TMPCF.lStructSize := Sizeof(TMPCF);
  TMPCF.hWndOwner := hWndOwner;
  TMPCF.Flags:=CF_EFFECTS or CF_BOTH or CF_ENABLEHOOK or CF_INITTOLOGFONTSTRUCT;
  TMPCF.lpfnHook := FontDialogHook;
  TMPCF.lpLogFont := @TMPLogFont;
  TMPCF.rgbColors := Color2RGB( Font.Color );
  TMPCF.lCustData := Integer( Self );
  Color := TMPCF.rgbColors;

  Result := ChooseFont(TMPCF);

  if Result then begin
    DeleteObject( Font.Handle );
    Font.Handle := CreateFontIndirect( TMPLogFont );
    Font.Color := Color;
  end;
end;



function TKOLFontProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [ paDialog, paReadOnly ];
end;



procedure TKOLFontProperty.Edit;
const Pitch2API: array [ TFontPitch ] of Byte = ( DEFAULT_PITCH, VARIABLE_PITCH, FIXED_PITCH );
var LF: tagLOGFONT;
    F: TKOLFont;
    FS1: TFontStyles;
begin
//----------------
  hWndOwner := Application.Handle;
  Font := TFont.Create;
  Colors := NewList;
  ColorDlg := NewColorDialog( ccoFullOpen );
//-----------------
  F := TKOLFont( GetOrdValue );

  FillChar( LF, SizeOf( tagLOGFONT ), 0 );
  LF.lfHeight := F.FontHeight;
  LF.lfWidth := F.FontWidth;
  LF.lfOrientation := F.FontOrientation;
  if fsBold in F.FontStyle then LF.lfWeight := 700;
  LF.lfItalic := Byte( fsItalic in F.FontStyle );
  LF.lfUnderline := Byte( fsUnderline in F.FontStyle );
  LF.lfStrikeOut := Byte( fsStrikeOut in F.FontStyle );
  LF.lfCharSet := F.FontCharset;
  LF.lfPitchAndFamily := Pitch2API[ F.FontPitch ];
  Move( F.FontName[ 1 ], LF.lfFaceName, Length( F.FontName ) );
  Font.Color := F.Color;

  Font.Handle := CreateFontIndirect( LF );

  if DlgExecute then begin
    FillChar( LF, SizeOf( tagLOGFONT ), 0 );
    GetObject( Font.Handle, SizeOf( tagLOGFONT ), @LF );
    F.FontHeight := LF.lfHeight;
    F.FontWidth := LF.lfWidth;
    F.FontOrientation := LF.lfOrientation;

    FS1 := [];
    if Boolean( LF.lfItalic ) then Include( FS1, fsItalic );
    if Boolean( LF.lfUnderline ) then Include( FS1, fsUnderline );
    if Boolean( LF.lfStrikeOut ) then Include( FS1, fsStrikeout );
    if LF.lfWeight > FW_NORMAL then Include( FS1, fsBold );
    F.FontStyle := FS1;

    F.FontCharset := LF.lfCharSet;
    case LF.lfPitchAndFamily of
      DEFAULT_PITCH: F.FontPitch := fpDefault;
      FIXED_PITCH: F.FontPitch := fpFixed;
      VARIABLE_PITCH: F.FontPitch := fpVariable;
    end;
    F.FontName := LF.lfFaceName;
    F.Color := Font.Color;

    SetOrdValue( Integer( F ) );
  end;

//-----------------
  ColorDlg.Free;
  Colors.Free;
  Font.Free;
//-----------------
end;



procedure Register;
begin
  RegisterPropertyEditor( TypeInfo(TKOLFont), nil, '', TKOLFontProperty );
end;



end.
