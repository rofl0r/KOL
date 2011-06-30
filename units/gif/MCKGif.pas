unit MCKGif;

interface

uses Windows, Classes, KOL, mirror, mckObjs, KOLGif, SysUtils, Graphics,
     ShellAPI, Forms, Dialogs, extdlgs,
     dsgnintf;

type
  TKOLGifShow = class( TKOLControl )
  private
    FAnimate: Boolean;
    FStretch: Boolean;
    FOnEndLoop: TOnEvent;
    FLoop: Boolean;
    FGifData: TMemoryStream;
    FpopupMenu: TKOLPopupMenu;
    procedure SetAnimate(const Value: Boolean);
    procedure SetOnEndLoop(const Value: TOnEvent);
    procedure SetStretch(const Value: Boolean);
    procedure SetLoop(const Value: Boolean);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
  protected
    Gif: PGif;
    procedure SetupConstruct( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    function Generate_SetSize: String; override;
    procedure AutoSizeNow; override;
    function AdditionalUnits: String; override;
    procedure DefineProperties( Filer: TFiler ); override;
    procedure LoadGifData( Reader: TReader );
    procedure SaveGifData( Writer: TWriter );
  protected
    procedure SelectImage;
    procedure GenerateResourceFile;
    procedure CreateGIF;
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
    function NoDrawFrame: Boolean; override;
  public
    Constructor Create( AOwner: TComponent ); override;
    Destructor Destroy; override;
  published
    property Animate: Boolean read FAnimate write SetAnimate;
    property Loop: Boolean read FLoop write SetLoop;
    property Stretch: Boolean read FStretch write SetStretch;
    property OnEndLoop: TOnEvent read FOnEndLoop write SetOnEndLoop;
    property Autosize;
    property Transparent;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
  end;

  TKOLGifEditor = class( TComponentEditor )
  private
  protected
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

procedure Register;
{$R MCKGifShow.DCR}

implementation

procedure Register;
begin
  RegisterComponents( 'KOL', [ TKOLGifShow ] );
  RegisterComponentEditor( TKOLGifShow, TKOLGifEditor );
end;

{ TKOLGifShow }

function TKOLGifShow.AdditionalUnits: String;
begin
  Result := ', KOLGif';
end;

procedure TKOLGifShow.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName, [ 'OnEndLoop' ], [ @ OnEndLoop ] );
end;

procedure TKOLGifShow.AutoSizeNow;
begin
  if not Autosize then Exit;
  if fAutoSizingNow then Exit;
  //if csLoading in ComponentState then Exit;
  fAutoSizingNow := TRUE;
  try
    if (Gif = nil) and (FGifData <> nil) and (FGifData.Size > 0) then
      CreateGIF;
    if (Gif <> nil) and (Gif.Width > 0) and (Gif.Height > 0) then
    begin
      if not (Align in [caClient, caTop, caBottom]) then
        Width := Gif.Width;
      if not (Align in [caClient, caLeft, caRight]) then
        Height := Gif.Height;
    end;
  finally
    fAutoSizingNow := FALSE;
  end;
end;

constructor TKOLGifShow.Create(AOwner: TComponent);
begin
  inherited;
  FautoSize := TRUE;
  FStretch := TRUE;
  FAnimate := TRUE;
  FLoop := TRUE;
  //Transparent := TRUE;
  Width := 40;
  Height := 40;
end;

procedure TKOLGifShow.CreateGIF;
var Strm: PStream;
begin
  if Gif <> nil then
    Gif.Clear
  else
    Gif := NewGif;
  if (FGifData = nil) or (FGifData.Size = 0) then Exit;
  Strm := NewMemoryStream;
  try
    Strm.Size := FGifData.Size;
    Move( FGifData.Memory^, Strm.Memory^, FGifData.Size );
    Gif.LoadFromStream( Strm );
    if (Gif.Width > 0) and (Gif.Height > 0) then
    begin
      if Autosize then AutoSizeNow;
    end;
  finally
    Strm.Free;
  end;
end;

procedure TKOLGifShow.DefineProperties( Filer: TFiler );
begin
  inherited;
  Filer.DefineProperty( 'GifData', LoadGifData, SaveGifData, Assigned( FGifData ) and (FGifData.Size > 0) )
end;

destructor TKOLGifShow.Destroy;
begin
  Gif.Free;
  FGifData.Free;
  inherited;
end;

procedure TKOLGifShow.GenerateResourceFile;
var SL: TStringList;
    Path: String;
begin
  if not Assigned(FGifData) or (FGifData.Size = 0) then Exit;
  if Application = nil then Exit;
  if ParentForm = nil then Exit;
  if Name = '' then Exit;
  SL := TStringList.Create;
  try
    Path := ProjectSourcePath + ParentForm.Name + '_' + Name;
    SL.Add( UpperCase( ParentForm.Name + '_' + Name ) + ' RCDATA "' + Path + '.gif"' );
    SL.SaveToFile( Path + '.rc' );
    FGifData.Position := 0;
    FGifData.SaveToFile( Path + '.gif' );
    ShellExecute( 0, 'open', PChar( ExtractFilePath( Application.ExeName ) + 'brcc32.exe' ),
                PChar( Path + '.rc' ), PChar( ProjectSourcePath ),
                SW_HIDE );
  finally
    SL.Free;
  end;
end;

function TKOLGifShow.Generate_SetSize: String;
begin
  if Autosize then
    Result := ''
  else
    Result := inherited Generate_SetSize;
end;

procedure TKOLGifShow.LoadGifData(Reader: TReader);
var S: String;
begin
  if FGifData = nil then
    FGifData := TMemoryStream.Create
  else
    FGifData.Size := 0;
  S := Reader.ReadString;
  if Length( S ) <> 0 then
  begin
    FGifData.Size := Length( S );
    Move( S[ 1 ], FGifData.Memory^, Length( S ) );
    if (ParentForm <> nil) and (Name <> '') then
    begin
      CreateGIF;
      GenerateResourceFile;
      if ParentKOLForm <> nil then
        ParentKOLForm.Change( ParentKOLForm );
    end;
  end;
end;

function TKOLGifShow.NoDrawFrame: Boolean;
begin
  Result := (FGifData <> nil) and (FGifData.Size > 0);
end;

procedure TKOLGifShow.Paint;
begin
  if (FGifData <> nil) and (FGifData.Size > 0) then
  begin
    if Gif = nil then CreateGIF;
    if Stretch then
      Gif.StretchDraw( Canvas.Handle, ClientRect )
    else
      Gif.Draw( Canvas.Handle, 0, 0 );
  end;
  inherited;
end;

procedure TKOLGifShow.SaveGifData(Writer: TWriter);
var S: String;
begin
  if (FGifData = nil) or (FGifData.Size = 0) then Exit;
  SetLength( S, FGifData.Size );
  Move( FGifData.Memory^, S[ 1 ], FGifData.Size );
  Writer.WriteString( S );
end;

procedure TKOLGifShow.SelectImage;
{$IFDEF _D2}
var OD: TOpenDialog;
{$ELSE}
var OD: TOpenPictureDialog;
{$ENDIF}
var F: TFileStream;
begin
  {$IFDEF _D2}
  OD := TOpenDialog.Create( Self );
  {$ELSE Above _D2}
  OD := TOpenPictureDialog.Create( Self );
  {$ENDIF Above _D2}
  try
    OD.Title := 'Select GIF image';
    OD.DefaultExt := 'gif';
    OD.Filter := 'Graphic Interchange Format files (*.gif)|*.gif';
    OD.FilterIndex := 1;
    if OD.Execute then
    begin
      F := TFileStream.Create( OD.Filename, fmOpenRead );
      try
        if FGifData <> nil then
          FGifData.Size := 0
        else
          FGifData := TMemoryStream.Create;
        FGifData.Size := F.Size;

        //ShowMessage( 'Прочитано ' + IntToStr(
        F.Read( FGifData.Memory^, F.Size )
        //) + ' байтов из gif-файла ' + OD.FileName )
        ;
        GenerateResourceFile;
        CreateGIF;
        Change;
        if ParentKOLForm <> nil then
          ParentKOLForm.Change( ParentKOLForm )
      finally
        F.Free;
      end;
    end;
  finally
    OD.Free;
  end;
end;

procedure TKOLGifShow.SetAnimate(const Value: Boolean);
begin
  FAnimate := Value;
  Change;
end;

procedure TKOLGifShow.SetLoop(const Value: Boolean);
begin
  FLoop := Value;
  Change;
end;

procedure TKOLGifShow.SetOnEndLoop(const Value: TOnEvent);
begin
  FOnEndLoop := Value;
  Change;
end;

procedure TKOLGifShow.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  FpopupMenu := Value;
  Change;
end;

procedure TKOLGifShow.SetStretch(const Value: Boolean);
begin
  FStretch := Value;
  Change;
end;

procedure TKOLGifShow.SetupConstruct(SL: TStringList; const AName, AParent,
  Prefix: String);
var S: String;
begin
  S := GenerateTransparentInits;
  SL.Add( Prefix + AName + ' := TKOLGifShow( NewGifShow( '
          + SetupParams( AName, AParent ) + ' )' + S + ');' );
end;

procedure TKOLGifShow.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  inherited;
  if not Autosize then
    SL.Add( Prefix + AName + '.Autosize := FALSE;' );
  if not Animate then
    SL.Add( Prefix + AName + '.Animate := FALSE;' );
  if not Loop then
    SL.Add( Prefix + AName + '.Loop := FALSE;' );
  if not Stretch then
    SL.Add( Prefix + AName + '.Stretch := FALSE;' );
  if (FGifData <> nil) and (FGifData.Size > 0) then
  begin
    SL.Add( '    {$R ' + ParentForm.Name + '_' + Name + '.RES}' );
    SL.Add( Prefix + AName + '.LoadFromResourceName( hInstance, ' +
            String2Pascal( UpperCase( ParentForm.Name + '_' + Name ) ) + ' );' );
  end;
end;

function TKOLGifShow.WYSIWIGPaintImplemented: Boolean;
begin
  Result := TRUE;
end;

{ TKOLGifEditor }

procedure TKOLGifEditor.Edit;
begin
  if Component = nil then Exit;
  if not(Component is TKOLGifShow) then Exit;
  (Component as TKOLGifShow).SelectImage;
end;

procedure TKOLGifEditor.ExecuteVerb(Index: Integer);
begin
  Edit;
end;

function TKOLGifEditor.GetVerb(Index: Integer): string;
begin
  Result := 'Select image';
end;

function TKOLGifEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

end.
