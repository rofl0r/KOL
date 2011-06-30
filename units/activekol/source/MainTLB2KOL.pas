{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit MainTLB2KOL;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls, mckObjs {$ENDIF};
{$ELSE}
{$I uses.inc} mirror, 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  PForm1 = ^TForm1;
  TForm1 = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    Label1: TKOLLabel;
    EditBox1: TKOLEditBox;
    BtnBrowse: TKOLButton;
    OpenDialog1: TKOLOpenSaveDialog;
    BtnStart: TKOLButton;
    Memo1: TKOLMemo;
    procedure BtnBrowseClick(Sender: PObj);
    procedure EditBox1Change(Sender: PObj);
    procedure BtnStartClick(Sender: PObj);
  private
    { Private declarations }
    procedure DoCvt( const SrcPath: String );
  public
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I MainTLB2KOL_1.inc}
{$ENDIF}

procedure TForm1.BtnBrowseClick(Sender: PObj);
begin
  if OpenDialog1.Execute then
  begin
    Editbox1.Text := OpenDialog1.Filename;
  end;
end;

procedure TForm1.EditBox1Change(Sender: PObj);
var E: Boolean;
begin
  E := FALSE;
  if Editbox1.Text <> '' then
  if FileExists( Editbox1.Text ) then
    E := TRUE;
  BtnStart.Enabled := E;
  BtnStart.Visible := TRUE;
  Memo1.Visible := FALSE;
end;

procedure TForm1.BtnStartClick(Sender: PObj);
begin
  Memo1.Visible := TRUE;
  BtnStart.Visible := FALSE;
  EditBox1.Enabled := FALSE;
  BtnBrowse.Enabled := FALSE;
  DoCvt( EditBox1.Text );
end;

procedure TForm1.DoCvt( const SrcPath: String );
var Src, Dest: PStrList;
    DestPath: String;

    procedure Rpt( const S: String );
    begin
      Memo1.SelStart := Memo1.TextSize;
      if Memo1.SelStart <> 0 then
      begin
        Memo1.ReplaceSelection( #13#10, FALSE );
        Memo1.SelStart := Memo1.TextSize;
      end;
      Memo1.ReplaceSelection( S, FALSE );
      Memo1.SelStart := Memo1.TextSize;
    end;

    procedure Err( const S: String );
    begin
      Rpt( S );
      Rpt( '*** Errors found - converting not finished ***' );
    end;

    function Replace( var S: String; const From, _To_: String ): Boolean;
    var K: Integer;
    begin
      Result := FALSE;
      while TRUE do
      begin
        K := pos( LowerCase( From ), LowerCase( S ) );
        if K <= 0 then break;
        S := Copy( S, 1, K - 1 ) + _To_ + CopyEnd( S, K + Length( From ) );
        Result := TRUE;
      end;
    end;

    function alphaDigit( C: Char ): Boolean;
    begin
      Result := C in ['a'..'z','A'..'Z','0'..'9','_'];
    end;


    function ReplWord( var S: String; const From, _To_: String ): Boolean;
    var K: Integer;
    begin
      Result := FALSE;
      for K := Length( S ) downto 1 do
      begin
        if LowerCase( copy( S, K, Length( from ) ) ) = LowerCase( From ) then
        begin
          if (K = 1) or not AlphaDigit(S[ K-1 ]) then
          if (K + Length(From) >= Length(S)) or not AlphaDigit( S[K + Length(From)] ) then
            S := Copy( S, 1, K-1 ) + _To_ + CopyEnd( S, K + Length(From) );
        end;
      end;
    end;

    procedure Cvt;
    var I, J: Integer;
        S, S1: String;
        Units: PStrList;
        NextLine: Boolean;
        InOleCtl: Boolean;
        InImplementation: Boolean;

    begin

      if Src.Count <= 0 then
      begin
        Err( 'No lines found in source' );
        Exit;
      end;

      I := 0;

      // copy all lines above UNIT directive
      while I < Src.Count do
      begin
        if LowerCase( Copy( Src.Items[ I ], 1, 5 ) ) = 'unit ' then break;
        Dest.Add( Src.Items[ I ] );
        Inc( I );
      end;

      // insert modified UNIT directive
      Dest.Add( 'unit ' + ExtractFileNameWOext( DestPath ) + ';' );
      Inc( I );
      Dest.Add( '{ converted by TLB2KOL utility }' );

      // copy all lines above USES statement
      while I < Src.Count do
      begin
        if LowerCase( Copy( Src.Items[ I ], 1, 5 ) ) = 'uses ' then break;
        Dest.Add( Src.Items[ I ] );
        Inc( I );
      end;

      // scan uses clause:
      Units := NewStrList;
      S := CopyEnd( Src.Items[ I ], 6 );
      while S <> '' do
      begin
        NextLine := pos( ';', S ) <= 0;
        S1 := Trim( Parse( S, ',;' ) );
        if Trim( S ) = '' then
        if NextLine then
        begin
          Inc( I );
          S := Src.Items[ I ];
        end;
        if not StrIn( S1, [ 'classes', 'graphics', 'oleserver', 'olectrls' ] ) then
          Units.Add( S1 );
      end;
      Inc( I );

      // construct new USES clause and insert it into Dest:
      S := 'uses KOL, ActiveKOL';
      for J := 0 to Units.Count - 1 do
      begin
        S1 := Units.Items[ J ];
        if pos( '_TLB', UpperCase( S1 ) ) > 0 then
        begin
          Rpt( '*** unit ' + S1 + ' also should be converted ***' );
          S1 := S1 + 'KOL';
        end;
        S := S + ', ';
        if Length( S ) + Length( S1 ) > 64 then
        begin
          Dest.Add( S );
          S := '  ';
        end;
        S := S + S1;
      end;
      Dest.Add( S + ';' );
      Units.Free;

      InOleCtl := FALSE;
      InImplementation := FALSE;

      // processing all other strings:
      while I < Src.Count do
      begin
        S := Src.Items[ I ];
        if InOleCtl then
        begin
          Replace( S, 'override;', 'virtual;' );
          Replace( S, ': TObject;', ': TObj;' );
          Replace( S, ': TNotifyEvent', ': TOnEvent' );
          Replace( S, ': TFont;', 'PGraphicTool;' );
        end;
        Replace( S, 'uses ComObj', 'uses KOLComObj' );
        if StrIsStartingFrom( PChar( LowerCase( Trim( S ) ) ), 'constructor create' ) then
          S := '    constructor Create;';
        if InImplementation then
        begin
          if StrIsStartingFrom( PChar( LowerCase( Trim( S ) ) ), 'constructor ' ) then
          if pos( '.create(', LowerCase( S ) ) > 1 then
            S := Parse( S, '.' ) + '.Create;';
          if StrIsStartingFrom( PChar( LowerCase( Trim( S ) ) ), 'inherited create(' ) then
            S := '  inherited Create;';
        end;
        if InImplementation then
          ReplWord( S, 'Self', '@Self' );
        if InOleCtl then
          if StrEq( Trim( S ), 'published' ) then
            S := '  //' + S;
        if Replace( S, '= class(TOleControl)', '= object(TOleCtl)' ) then
        begin
          S1 := S;
          S1 := Trim( Parse( S1, '=' ) );
          Dest.Add( '  P' + CopyEnd( S1, 2 ) + ' = ^' + S1 + ';' );
          InOleCtl := TRUE;
        end;
        if InOleCtl then
          if StrEq( LowerCase( Trim( S ) ), 'end;' ) then
            InOleCtl := FALSE;
        if StrEq( Trim( S ), 'implementation' ) then
          InImplementation := TRUE;
        if not InImplementation then
          if StrEq( Trim( S ), 'procedure register;' ) then
            S := '//procedure Register';
        if InImplementation then
          if StrEq( Trim( S ), 'procedure register;' ) then
          begin
            S := '//' + S;
            repeat
               Inc( I );
            until (I >= Src.Count) or StrEq( Trim( Src.Items[ I ] ), 'end;' );
          end;
        Dest.Add( S );
        Inc( I );
      end;

      Rpt( 'Converting finished successfully for ' + SrcPath );
      Dest.SaveToFile( DestPath );
      Rpt( 'Destinstion file saved: ' + DestPath );

    end;

begin
  Src := NewStrList;
  Src.LoadFromFile( SrcPath );

  DestPath := Copy( SrcPath, 1, Length( SrcPath ) - 4 ) + 'KOL.pas';
  Dest := NewStrList;

  Memo1.Clear;
  Rpt( 'Converting unit ' + SrcPath );
  Rpt( 'Target unit is: ' + DestPath );
  Cvt;

  Src.Free;
  Dest.Free;

  EditBox1.Enabled := TRUE;
  BtnBrowse.Enabled := TRUE;
  BtnStart.Enabled := FALSE;

end;

end.


