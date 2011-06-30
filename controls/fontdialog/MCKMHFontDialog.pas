unit MCKMHFontDialog;
//  MHFontDialog Компонент (MHFontDialog Component)
//  Автор (Author): Жаров Дмитрий (Zharov Dmitry) aka Гэндальф (Gandalf)
//  Дата создания (Create date): 19-ноя(nov)-2002
//  Дата коррекции (Last correction Date): 15-авг(aug)-2003
//  Версия (Version): 1.3
//  EMail: Gandalf@kol.mastak.ru
//  WWW: http://kol.mastak.ru
//  Благодарности (Thanks):
//    Vladimir Kladov
//    Alexander Pravdin
//    Dominiko-m
//    Kiril Krasnov
//    Ajax Talamned
//  Новое в (New in):
//  V1.3 (KOL 1.80, Delphi 7)
//  [+] Device вернул (Return Device property) <Thanks to Ajax Talamned> [KOLnMCK]
//  [-] Убрал fdShowHelp fdApplyButton (Delete fdShowHelp fdApplyButton) [KOLnMCK]
//  [*] Переименовал  MaxSize,MinSize -> MaxFontSize,MinFontSize, как в VCL (Rename MaxSize,MinSize -> MaxFontSize,MinFontSize as in VCL) [KOLnMCK]
//  [+] Добавил fdInitFont (Add fdInitFont) [KOLnMCK]
//  [+] И другое (Add others) [KOLnMCK]
//
//  V1.21 (KOL 1.79, Delphi 7)
//  [+] Свойство Options (Options property) <Thanks to Ajax Talamned> [KOLnMCK]
//
//  V1.2
//  [-] Утечка памяти ликвидирована (Memory leak fixed) <Thanks to dominiko-m> [KOL]
//
//  V1.11
//  [+] Поддержка D7 (D7 Support) [KOLnMCK]
//
//  V1.1
//  [+] Поддержка D6 (D6 Support) <Thanks to Alexander Pravdin> [KOLnMCK]
//  [!] Неверное занчение InitFont (Incorrect InitFont) <Thanks to Kiril Krasnov, Dominiko-m> [KOL]
//  [N] KOLnMCK>=1.43
//
//  Список дел (To-Do list):
//  2. Good Default Values
//  3. Optimize
//  4. Asm
// 19. Add InitDialog Event
// 20. Printer DC not realized
// 21. Ассемблер (Asm)
// 22. Оптимизировать (Optimize)
// 23. Подчистить (Clear Stuff)
// 24. Ошибки (Errors)
//1) Может InitFont заменить на Font, т.е. в качестве инита используется
//текущий?
//2) Может убрать fdWysiwyg - это вндб комбинация стилей (но удобная)

interface

uses
  KOL, KOLMHFontDialog, mirror, mckObjs, Classes, Graphics,CommDlg,Windows;

type
  TKOLMHFontDialog = class(TKOLObj)
  private
//     FShowEffects:Boolean;
     FMinFontSize:Integer;
     FMaxFontSize:Integer;
//     FUseMinMaxSize:Boolean;
     FDevice:TFontDialogDevice;
//     FIgnoreInits:TFontIgnoreInits;
     FInitFont:TKOLFont;
//     FUseInitFont:Boolean;
//     FForceFontExist:Boolean;
     FOnHelp:TOnMHFontDHelp;
     FOnApply:TOnMHFontDApply;
     //FFlags:DWord;
     FOptions: TFontDialogOptions;
//     procedure SetShowEffects(const Value:Boolean);
     procedure SetMinFontSize(const Value:Integer);
     procedure SetMaxFontSize(const Value:Integer);
//     procedure SetUseMinMaxSize(const Value:Boolean);
     procedure SetDevice(const Value:TFontDialogDevice);
//     procedure SetIgnoreInits(const Value:TFontIgnoreInits);
     procedure SetInitFont(const Value:TKOLFont{TKOLLogFont}{TLogFont});
//     procedure SetUseInitFont(const Value:Boolean);
//     procedure SetForceFontExist(const Value:Boolean);
     procedure SetOnApply(const Value: TOnMHFontDApply);
     procedure SetOnHelp(const Value: TOnMHFontDHelp);
     //procedure SetFlags(const Value:DWord);
     procedure SetOptions(const Value:TFontDialogOptions);
  protected
    function  AdditionalUnits: string; override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    procedure SetupFirst(SL: TStringList; const AName,AParent, Prefix: String); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
//    property ShowEffects:Boolean read FShowEffects write SetShowEffects;
    property MinFontSize:Integer read FMinFontSize write SetMinFontSize;
    property MaxFontSize:Integer read FmaxFontSize write SetMaxFontSize;
//    property UseMinMaxSize:Boolean read FUseMinMaxSize write SetUseMinMaxSize;
    property Device:TFontDialogDevice read FDevice write SetDevice;
//    property IgnoreInits:TFontIgnoreInits read FIgnoreInits write SetIgnoreInits;
    property InitFont:TKOLFont read FInitFont write SetInitFont;
//    property UseInitFont:Boolean read FUseInitFont write SetUseInitFont;
//    property ForceFontExist:Boolean read FForceFontExist write SetForceFontExist;
    //property Flags:DWord read FFlags write SetFlags;

    property Options: TFontDialogOptions read FOptions write SetOptions default [fdEffects];

    property OnApply: TOnMHFontDApply read FOnApply write SetOnApply;
    property OnHelp: TOnMHFontDHelp read FOnHelp write SetOnHelp;
  end;

  procedure Register;

const
  LF_FACESIZE = 32;

implementation


constructor TKOLMHFontDialog.Create(AOwner: TComponent);
begin
  inherited;
  FInitFont:=TKOLFont.Create(Self);
end;

destructor TKOLMHFontDialog.Destroy;
begin
  inherited;
  FInitFont.Free;
end;

function TKOLMHFontDialog.AdditionalUnits;
begin
   Result := ', KOLMHFontDialog';
end;

procedure TKOLMHFontDialog.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
Const OpenOption: array [TFontDialogOption] of String =
            ('fdAnsiOnly', 'fdTrueTypeOnly', 'fdEffects', 'fdFixedPitchOnly',
             'fdForceFontExist', 'fdNoFaceSel', 'fdNoOEMFonts', 'fdNoSimulations',
             'fdNoSizeSel', 'fdNoStyleSel',  'fdNoVectorFonts', {'fdShowHelp',}
             'fdWysiwyg', 'fdLimitSize', 'fdScalableOnly', {'fdApplyButton',}'fdInitFont');
      Device2Str:array [TFontDialogDevice] of String = ('fdBoth', 'fdScreen', 'fdPrinter');
var
  StrII:String;
  fd_option: TFontDialogOption;
begin
  SL.Add('');
  SL.Add(Prefix+AName+':=NewMHFontDialog('+AParent+');');
  SL.Add(Prefix+AName+'.MinFontSize:='+Int2Str(FMinFontSize)+';');
  SL.Add(Prefix+AName+'.MaxFontSize:='+Int2Str(FMaxFontSize)+';');
  SL.Add(Prefix+AName+'.Device:='+Device2Str[FDevice]+';');
{  if FShowEffects then
    SL.Add(Prefix+AName+'.ShowEffects:=True;')
  Else
    SL.Add(Prefix+AName+'.ShowEffects:=False;');}
{  if  FUseMinMaxSize then
    SL.Add(Prefix+AName+'.UseMinMaxSize:=True;')
  Else
    SL.Add(Prefix+AName+'.UseMinMaxSize:=False;');}
{  if  FUseInitFont then
    SL.Add(Prefix+AName+'.UseInitFont:=True;')
  Else
    SL.Add(Prefix+AName+'.UseInitFont:=False;');}

 { case FDevice of
    fddBoth: SL.Add(Prefix+AName+'.Device:=fddBoth;');
    fddScreen: SL.Add(Prefix+AName+'.Device:=fddScreen;');
    fddPrinter: SL.Add(Prefix+AName+'.Device:=fddPrinter;');
  end;// case}

{  StrII:='';
  if fiiName in FIgnoreInits then
    StrII:=StrII+'fiiName, ';
  if fiiStyle in FIgnoreInits then
    StrII:=StrII+'fiiStyle, ';
  if fiiSize in FIgnoreInits then
    StrII:=StrII+'fiiSize, ';
  if StrII<>'' then
    StrII:=Copy(StrII,1,Length(StrII)-2);
  SL.Add(Prefix+AName+'.IgnoreInits:=['+StrII+'];');
 }
{  if  FForceFontExist then
    SL.Add(Prefix+AName+'.ForceFontExist:=True;')
  Else
    SL.Add(Prefix+AName+'.ForceFontExist:=False;');
 }
  StrII:= '';
  for fd_Option := Low(fd_Option) to High(fd_Option) do
    if fd_Option in FOptions then StrII:= StrII + ', ' + OpenOption[fd_Option];
      Delete(StrII, 1, 2);
  SL.Add(Prefix+AName+'.Options:= ['+StrII+'];');

  InitFont.GenerateCode( SL, AName, InitFont );
end;

procedure TKOLMHFontDialog.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName, [ 'OnHelp', 'OnApply' ], [ @OnHelp, @OnApply ] );
end;

{procedure TKOLMHFontDialog.SetShowEffects(const Value:Boolean);
begin
  FShowEffects:=Value;
  Change;
end;}

procedure TKOLMHFontDialog.SetMinFontSize(const Value:Integer);
begin
  FMinFontSize:=Value;
  Change;
end;

procedure TKOLMHFontDialog.SetMaxFontSize(const Value:Integer);
begin
  FMaxFontSize:=Value;
  Change;
end;

{procedure TKOLMHFontDialog.SetUseMinMaxSize(const Value:Boolean);
begin
  FUseMinMaxSize:=Value;
  Change;
end;}

procedure TKOLMHFontDialog.SetDevice(const Value:TFontDialogDevice);
begin
  FDevice:=Value;
  Change;
end;

{procedure TKOLMHFontDialog.SetIgnoreInits(const Value:TFontIgnoreInits);
begin
  FIgnoreInits:=Value;
  Change;
end;}

procedure TKOLMHFontDialog.SetInitFont(const Value:TKOLFont{TKOLLogFont}{TLogFont});
begin
  FInitFont.Assign(Value);
  Change;
end;


{procedure TKOLMHFontDialog.SetUseInitFont(const Value:Boolean);
begin
  FUseInitFont:=Value;
  Change;
end;
}

{procedure TKOLMHFontDialog.SetForceFontExist(const Value:Boolean);
begin
  FForceFontExist:=Value;
  Change;
end;
}
procedure TKOLMHFontDialog.SetOnHelp(const Value:TOnMHFontDHelp);
begin
  FOnHelp:=Value;
  Change;
end;

procedure TKOLMHFontDialog.SetOnApply(const Value:TOnMHFontDApply);
begin
  FOnApply:=Value;
  Change;
end;

procedure TKOLMHFontDialog.SetOptions(const Value:TFontDialogOptions);
begin
  FOptions:=Value;
  Change;
end;

procedure Register;
begin
  RegisterComponents('KOL Dialogs', [TKOLMHFontDialog]);
end;

end.

