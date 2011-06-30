unit KOLInputQuery;

interface

uses 
  KOL,
  Windows;

function InputBox(const ACaption, APrompt, ADefault: String): String;
function InputQuery(const ACaption, APrompt: string; var Value: string): Boolean;

implementation

procedure OKClick( Dialog, Btn: PControl );
var Rslt: Integer;
begin
  Rslt := -1;
  if Btn <> nil then
    Rslt := Btn.Tag;
  Dialog.Tag := Rslt;
  Dialog.ModalResult := Rslt;
  Dialog.Close;
end;

procedure KeyClick( Dialog, Btn: PControl; var Key: Longint; Shift: DWORD );
begin
  if (Key = VK_RETURN) or (Key = VK_ESCAPE) then
  begin
    if Key = VK_ESCAPE then
      Btn := nil;
    OKClick( Dialog, Btn );
  end;
end;

function GetAveCharSize(Canvas: PCanvas): TPoint;
var I: Integer; Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint32(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;

function InputQuery(const ACaption, APrompt: string; var Value: string): Boolean;
var Dialog, Prompt, Edit: PControl;
    DlgWnd: HWnd;
    DialogUnits: TPoint;
    ButtonTop, ButtonWidth, ButtonHeight: Integer;
    AppTermFlag: Boolean;
begin
  // IF YOU CLOSE THE WINDOW, YOU GET A RUNTIME ERROR.. TRYING TO FIX IT, BUT NO LUCK..
  Result := False; // Return "Clicked Cancel" If Anything Goes Wrong
  // Save Applet Stuff
  AppTermFlag := AppletTerminated;
  AppletTerminated := False;
  // Create our main form
  Dialog := NewForm( Applet, ACaption );
  try
   Dialog.Visible := False; // Hide until everything is not created
   Dialog.CreateWindow; // Until not created, access to canvas is not possible

   Dialog.Font.FontHeight:=8;
   DialogUnits := GetAveCharSize(Dialog.Canvas);
   Dialog.Icon := LoadIcon(0, IDI_INFORMATION);
   Dialog.Style := Dialog.Style  and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX);
   Dialog.ClientWidth := MulDiv(180, DialogUnits.X, 4);

   Prompt := NewLabel(Dialog, APrompt);
  //  Prompt := NewEditbox( Dialog, [ eoMultiline, eoReadonly, eoNoHScroll, eoNoVScroll ] );
   with Prompt^ do begin
     //* Only Editbox
     //Caption:=APrompt;
     //Style := Style and not WS_TABSTOP;
     //TabStop := FALSE;
     //*

     HasBorder := FALSE;
     Color := clBtnFace;
     Left := MulDiv(8, DialogUnits.X, 4);
     Top := MulDiv(8, DialogUnits.Y, 8);
     MaxWidth := MulDiv(164, DialogUnits.X, 4);
     //Wordwrap := True;
     CreateWindow;
     Height := Prompt.Canvas.TextHeight(Text);
     Width := Prompt.Canvas.TextWidth(Text);
   end;

   Edit := NewEditbox( Dialog, [  ] );
   with Edit^ do begin
     Caption:=APrompt;
     HasBorder := TRUE;
     Color := clWhite;
     Left := Prompt.Left;
     Top := Prompt.Top + Prompt.Height + 5;
     Width := MulDiv(164, DialogUnits.X, 4);
     MaxTextSize := 255;
     Tag := idOk;
     OnKeyDown := TOnKey( MakeMethod( Dialog, @KeyClick ) );
     Text := Value;
     SelectAll;
     CreateWindow;
   end;
   ButtonTop := Edit.Top + Edit.Height + 15;
   ButtonWidth := MulDiv(50, DialogUnits.X, 4);
   ButtonHeight := MulDiv(14, DialogUnits.Y, 8);

   with NewButton(Dialog, 'OK')^ do begin
    ModalResult:=idOk;
     DefaultBtn:=True;
      Left:=MulDiv(38, DialogUnits.X, 4);
      Top:=ButtonTop;
      Width:=ButtonWidth;
      Height:=ButtonHeight;
      Tag := ModalResult;
      OnClick := TOnEvent( MakeMethod( Dialog, @OKClick ) );
      OnKeyDown := TOnKey( MakeMethod( Dialog, @KeyClick ) );
    end;

    with NewButton(Dialog, 'Cancel')^ do begin
      ModalResult := idCancel;
      CancelBtn := True;
      Left:=MulDiv(92, DialogUnits.X, 4);
      Top:=Edit.Top + Edit.Height + 15;
      Width:=ButtonWidth;
      Height:=ButtonHeight;
      Dialog.ClientHeight := Top + Height + 13;
      Tag := ModalResult;
      OnClick := TOnEvent( MakeMethod( Dialog, @OKClick ) );
      OnKeyDown := TOnKey( MakeMethod( Dialog, @KeyClick ) );
    end;

    Dialog.CenterOnParent.Tabulate.CanResize := FALSE;
    Dialog.Visible := True;
        
    if (Applet <> nil) and Applet.IsApplet then begin
        Dialog.ShowModal;
        if Dialog.Tag = idOK then begin
          Value := Edit.Text;
          Result := True;
        end;
    end else begin
      DlgWnd := Dialog.Handle;
      while IsWindow( DlgWnd ) and (Dialog.ModalResult = 0) do
        Dialog.ProcessMessage;
      if Dialog.ModalResult = idOk then begin
        Value := Edit.Text;
        Result := True;
      end;
      CreatingWindow := nil;
    end;
  finally
    Dialog.Free;
  end;
  AppletTerminated := AppTermFlag;
end;

function InputBox(const ACaption, APrompt, ADefault: String): string;
begin
  Result := ADefault;
  InputQuery(ACaption, APrompt, Result);
end;

end.