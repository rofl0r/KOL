unit MCKmdvDialogEx;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, DesignIntf, mirror, mckObjs, mckCtrls, KOL, Graphics, KOLmdvDialogEx;

type

  TcdCustomColors = class
    FcdCustomColors: TCustomColors;
    constructor Create;
    procedure Assign(Value: TcdCustomColors);
  end;

  TKOLmdvDialogEx = class(TKOLObj)
  private
    FfdOptions: TOpenOptions;
    FfdOptionsEx: TOpenOptionsEx;
    FfdFilterIndex: Integer;
    FfdFilter: string;
    FfdFileName: TFileName;
    FfdInitialDir: string;
    FfdDefaultExt: string;
    FOnShow: TmdvDialogExEvent;
    FOnClose: TmdvDialogExEvent;
    FOnHelp: TmdvDialogExEvent;
    FfdOnCanClose: TfdCanClose;
    FfdOnSelectionChange: TmdvDialogExEvent;
    FfdOnFolderChange: TmdvDialogExEvent;
    FfdOnTypeChange: TmdvDialogExEvent;
    FcdColor: TColor;
    FcdOptions: TColorDialogOptions;
    FcdCustomColors: TcdCustomColors;
    FcdOnCanClose: TcdCanClose;
    FcdOnChangeColor: TcdChangeColor;
    FcdOnChangeCustomColors: TcdChangeCustomColors;
    procedure SetfdOptions(const Value: TOpenOptions);
    procedure SetfdOptionsEx(const Value: TOpenOptionsEx);
    procedure SetfdFilter(const Value: string);
    procedure SetfdFilterIndex(const Value: Integer);
    procedure SetfdFileName(const Value: TFileName);
    procedure SetfdInitialDir(const Value: string);
    procedure SetfdDefaultExt(const Value: string);
    procedure SetOnShow(const Value: TmdvDialogExEvent);
    procedure SetOnClose(const Value: TmdvDialogExEvent);
    procedure SetfdOnCanClose(const Value: TfdCanClose);
    procedure SetfdOnSelectionChange(const Value: TmdvDialogExEvent);
    procedure SetfdOnFolderChange(const Value: TmdvDialogExEvent);
    procedure SetfdOnTypeChange(const Value: TmdvDialogExEvent);
    procedure SetOnHelp(const Value: TmdvDialogExEvent);
    procedure SetcdCustomColors(const Value: TcdCustomColors);
    procedure SetcdOptions(const Value: TColorDialogOptions);
    procedure SetcdColor(const Value: TColor);
    procedure SetcdOnCanClose(const Value: TcdCanClose);
    procedure SetcdOnChangeColor(const Value: TcdChangeColor);
    procedure SetcdOnChangeCustomColors(
      const Value: TcdChangeCustomColors);

    procedure ReadProperty(Reader: TReader);
    procedure WriteProperty(Writer: TWriter);

  protected
    function AdditionalUnits: String; override;
    procedure AssignEvents(SL: TStringList; const AName: String); override;
    procedure SetupFirst(SL: TStringList; const AName, AParent, Prefix: String); override;
    procedure SetupLast(SL: TStringList; const AName, AParent, Prefix: String); override;

    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create(Owner: TComponent); override;
    function TypeName: String; override;

  published

    property fdOptions: TOpenOptions read FfdOptions write SetfdOptions;
    property fdOptionsEx: TOpenOptionsEx read FfdOptionsEx write SetfdOptionsEx;
    property fdFilter: string read FfdFilter write SetfdFilter;
    property fdFilterIndex: Integer read FfdFilterIndex write SetfdFilterIndex;
    property fdFileName: TFileName read FfdFileName write SetfdFileName;
    property fdInitialDir: string read FfdInitialDir write SetfdInitialDir;
    property fdDefaultExt: string read FfdDefaultExt write SetfdDefaultExt;

    property cdOptions: TColorDialogOptions read FcdOptions write SetcdOptions;
    property cdColor: TColor read FcdColor write SetcdColor;
    property cdCustomColors: TcdCustomColors read FcdCustomColors write SetcdCustomColors;

    property OnShow: TmdvDialogExEvent read FOnShow write SetOnShow;
    property OnClose: TmdvDialogExEvent read FOnClose write SetOnClose;
    property OnHelp: TmdvDialogExEvent read FOnHelp write SetOnHelp;
    property fdOnSelectionChange: TmdvDialogExEvent read FfdOnSelectionChange write SetfdOnSelectionChange;
    property fdOnFolderChange: TmdvDialogExEvent read FfdOnFolderChange write SetfdOnFolderChange;
    property fdOnTypeChange: TmdvDialogExEvent read FfdOnTypeChange write SetfdOnTypeChange;
    property fdOnCanClose: TfdCanClose read FfdOnCanClose write SetfdOnCanClose;

    property cdOnChangeColor: TcdChangeColor read FcdOnChangeColor write SetcdOnChangeColor;
    property cdOnChangeCustomColors: TcdChangeCustomColors read FcdOnChangeCustomColors write SetcdOnChangeCustomColors;
    property cdOnCanClose: TcdCanClose read FcdOnCanClose write SetcdOnCanClose;
  end;

procedure Register;

{$R *.dcr}

implementation

procedure Register;
begin
    RegisterComponents('KOL Dialogs', [TKOLmdvDialogEx]);
    RegisterPropertyEditor(TypeInfo(String), TKOLmdvDialogEx, 'fdFilter', TKOLFileFilter);

end;

function TKOLmdvDialogEx.AdditionalUnits;
begin
    Result := ', KOLmdvDialogEx';
end;

function TKOLmdvDialogEx.TypeName: String;
begin
    Result := 'TKOLmdvDialogEx';
end;

procedure TKOLmdvDialogEx.AssignEvents;
begin
    inherited;
    DoAssignEvents(SL, AName, ['OnShow'], [@OnShow]);
    DoAssignEvents(SL, AName, ['OnClose'], [@OnClose]);
    DoAssignEvents(SL, AName, ['OnHelp'], [@OnHelp]);
    DoAssignEvents(SL, AName, ['fdOnCanClose'], [@fdOnCanClose]);
    DoAssignEvents(SL, AName, ['fdOnSelectionChange'], [@fdOnSelectionChange]);
    DoAssignEvents(SL, AName, ['fdOnFolderChange'], [@fdOnFolderChange]);
    DoAssignEvents(SL, AName, ['fdOnTypeChange'], [@fdOnTypeChange]);

    DoAssignEvents(SL, AName, ['cdOnChangeColor'], [@cdOnChangeColor]);
    DoAssignEvents(SL, AName, ['cdOnChangeCustomColors'], [@cdOnChangeCustomColors]);
    DoAssignEvents(SL, AName, ['cdOnCanClose'], [@cdOnCanClose]);
end;

procedure TKOLmdvDialogEx.SetupFirst;
const spc = ', ';
      Boolean2Str: array [Boolean] of String = ('FALSE', 'TRUE');
      OpenOption: array [TOpenOption] of String =
          ('ofReadOnly', 'ofOverwritePrompt', 'ofHideReadOnly',
           'ofNoChangeDir', 'ofShowHelp', 'ofNoValidate', 'ofAllowMultiSelect',
           'ofExtensionDifferent', 'ofPathMustExist', 'ofFileMustExist', 'ofCreatePrompt',
           'ofShareAware', 'ofNoReadOnlyReturn', 'ofNoTestFileCreate', 'ofNoNetworkButton',
           'ofNoLongNames', 'ofOldStyleDialog', 'ofNoDereferenceLinks', 'ofEnableIncludeNotify',
           'ofEnableSizing', 'ofDontAddToRecent', 'ofForceShowHidden');
      OpenOptionEx: array [TOpenOptionEx] of String =('ofExNoPlacesBar');
      ColorDialogOption: array [TColorDialogOption] of String = ('cdFullOpen', 'cdPreventFullOpen', 'cdShowHelp', 'cdSolidColor', 'cdAnyColor');

var fd_Option: TOpenOption;
    fd_OptionEx: TOpenOptionEx;
    cd_Option: TColorDialogOption;
    S: String;
    i: integer;
begin
    SL.Add(Prefix + AName + ' := NewmdvDialogEx('+AParent+');');
    S:= '';
    for fd_Option := Low(fd_Option) to High(fd_Option) do if fd_Option in FfdOptions then S:= S + ', ' + OpenOption[fd_Option];
    Delete(S, 1, 2);
    SL.Add(Prefix+AName+'.fdOptions:= ['+S+'];');
    S:= '';
    for fd_OptionEx := Low(fd_OptionEx) to High(fd_OptionEx) do if fd_OptionEx in FfdOptionsEx then S:= S + ', ' + OpenOptionEx[fd_OptionEx];
    Delete(S, 1, 2);
    SL.Add(Prefix+AName+'.fdOptionsEx:= ['+S+'];');
    SL.Add(Prefix+AName+'.fdFilter:= '''+FfdFilter+'''; ' + AName+'.fdFilterIndex:= '+Int2Str(FfdFilterIndex)+';');
    SL.Add(Prefix+AName+'.fdFileName:= '''+FfdFileName+'''; ' + AName+'.fdInitialDir:= '''+FfdInitialDir+''';');

    S:= '';
    for cd_Option := Low(cd_Option) to High(cd_Option) do if cd_Option in FcdOptions then S:= S + ', ' + ColorDialogOption[cd_Option];
    Delete(S, 1, 2);
    SL.Add(Prefix+AName+'.cdOptions:= ['+S+'];');
    SL.Add(Prefix+AName+'.cdColor:= '+IntToStr(FcdColor)+';');

    S:= Prefix;
    for i:= Low(TCustomColors) to High(TCustomColors) do
      S:= S + AName+'.cdCustomColors['+IntToStr(i)+']:= $'+IntToHex(FcdCustomColors.FcdCustomColors[i], 8)+'; ';
    SL.Add(S);

// Boolean2Str[TRUE]
// Color2Str(myColor)
// SL.Add(Prefix + AName + '.myStr := ''' + myStr + ''';');
end;

procedure TKOLmdvDialogEx.SetupLast;
begin
// SL.Add(Prefix + AName + '.myInt := ' + Int2Str(myInt) + ';');
end;

constructor TKOLmdvDialogEx.Create;
begin
    inherited;
    FcdCustomColors:= TcdCustomColors.Create;
    FfdOptions:= [ofHideReadOnly, ofEnableSizing];
    FfdOptionsEx:= []; FfdFilter:= ''; FfdFilterIndex:= 1;
end;

procedure TKOLmdvDialogEx.SetfdOptions(const Value: TOpenOptions);
begin
    FfdOptions := Value;
    Change;
end;

procedure TKOLmdvDialogEx.SetfdOptionsEx(const Value: TOpenOptionsEx);
begin
    FfdOptionsEx := Value;
    Change;
end;

procedure TKOLmdvDialogEx.SetfdFilter(const Value: string);
begin
    FfdFilter := Value;
    Change;
end;

procedure TKOLmdvDialogEx.SetfdFilterIndex(const Value: Integer);
begin
    FfdFilterIndex := Value;
    Change;
end;

procedure TKOLmdvDialogEx.SetfdFileName(const Value: TFileName);
begin
    FfdFileName := Value;
    Change;
end;

procedure TKOLmdvDialogEx.SetfdInitialDir(const Value: string);
begin
    FfdInitialDir := Value;
    Change;
end;

procedure TKOLmdvDialogEx.SetfdDefaultExt(const Value: string);
begin
    FfdDefaultExt := Value;
    Change;
end;

procedure TKOLmdvDialogEx.SetOnShow(const Value: TmdvDialogExEvent);
begin
    FOnShow := Value;
    Change;
end;

procedure TKOLmdvDialogEx.SetOnClose(const Value: TmdvDialogExEvent);
begin
    FOnClose := Value;
    Change;
end;

procedure TKOLmdvDialogEx.SetfdOnCanClose(const Value: TfdCanClose);
begin
    FfdOnCanClose := Value;
    Change;
end;

procedure TKOLmdvDialogEx.SetfdOnSelectionChange(const Value: TmdvDialogExEvent);
begin
    FfdOnSelectionChange := Value;
    Change;
end;

procedure TKOLmdvDialogEx.SetfdOnFolderChange(const Value: TmdvDialogExEvent);
begin
    FfdOnFolderChange := Value;
    Change;
end;

procedure TKOLmdvDialogEx.SetfdOnTypeChange(const Value: TmdvDialogExEvent);
begin
    FfdOnTypeChange := Value;
    Change;
end;

procedure TKOLmdvDialogEx.SetOnHelp(const Value: TmdvDialogExEvent);
begin
    FOnHelp := Value;
    Change;
end;

procedure TKOLmdvDialogEx.SetcdCustomColors(const Value: TcdCustomColors);
begin
    FcdCustomColors.Assign(Value);
    Change;
end;

procedure TKOLmdvDialogEx.SetcdOptions(const Value: TColorDialogOptions);
begin
    FcdOptions := Value;
    Change;
end;

procedure TKOLmdvDialogEx.SetcdColor(const Value: TColor);
begin
    FcdColor := Value;
    Change;
end;

procedure TKOLmdvDialogEx.SetcdOnCanClose(const Value: TcdCanClose);
begin
    FcdOnCanClose := Value;
    Change;
end;

procedure TKOLmdvDialogEx.SetcdOnChangeColor(const Value: TcdChangeColor);
begin
    FcdOnChangeColor := Value;
    Change;
end;

procedure TKOLmdvDialogEx.SetcdOnChangeCustomColors(
  const Value: TcdChangeCustomColors);
begin
    FcdOnChangeCustomColors := Value;
    Change;
end;

procedure TKOLmdvDialogEx.ReadProperty(Reader: TReader);
var i: Byte;
begin
    try
      Reader.ReadListBegin; i:= Low(TCustomColors);
      while not Reader.EndOfList do begin
        FcdCustomColors.FcdCustomColors[i]:= Reader.ReadInteger;
        inc(i);
      end;
      Reader.ReadListEnd;
    except
    end;
end;

procedure TKOLmdvDialogEx.WriteProperty(Writer: TWriter);
var i: Byte;
begin
    Writer.WriteListBegin;
    for i:= Low(TCustomColors) to High(TCustomColors) do Writer.WriteInteger(FcdCustomColors.FcdCustomColors[i]);
    Writer.WriteListEnd;
end;

procedure TKOLmdvDialogEx.DefineProperties(Filer: TFiler);
begin
    inherited DefineProperties(Filer);
    Filer.DefineProperty('cdCustomColorsItems', ReadProperty, WriteProperty, True);
end;

{ TCustomColors_ }

procedure TcdCustomColors.Assign(Value: TcdCustomColors);
var i: Byte;
begin
    for i:= Low(TCustomColors) to High(TCustomColors) do FcdCustomColors[i]:= Value.FcdCustomColors[i];
end;

constructor TcdCustomColors.Create;
begin
    inherited;
    FillChar(FcdCustomColors, SizeOf(TCustomColors), 0);
end;

end.
