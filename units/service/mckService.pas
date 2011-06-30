unit mckService;

interface

{$I koldef.inc}

uses KOL, Classes, Forms, Controls, Dialogs, Windows, Messages, extctrls,
     stdctrls, comctrls, SysUtils, mirror, Service,
     {$IFDEF _D6orHigher}
     DesignIntf, DesignEditors, DesignConst,
     Variants
     {$ELSE}
     DsgnIntf
     {$ENDIF}
     ;

type

  TAcceptControl = (ACCEPT_STOP, ACCEPT_PAUSE_CONTINUE,
                    ACCEPT_SHUTDOWN, ACCEPT_PARAMCHANGE,
                    ACCEPT_NETBINDCHANGE,
                    ACCEPT_HARDWAREPROFILECHANGE,
                    ACCEPT_POWEREVENT);

  TAcceptControls = set of TAcceptControl;

  TKOLServiceFormEditor = class(TStringProperty)
  public
    function  AutoFill: boolean; override;
    function  GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TKOLService = class( TKOLDataModule )
  private
    FServiceName: String;
    FDisplayName: String;
    FOnStart: TServiceProc;
    FOnStop: TServiceProc;
    FOnControl: TControlProc;
    FOnExecute: TServiceProc;
    fNotAvailable: Boolean;
    FData: DWord;
    fControl: TAcceptControls;
    procedure SetServiceName(const Value: String);
    procedure SetOnStop(const Value: TServiceProc);
    procedure SetOnStart(const Value: TServiceProc);
    procedure SetOnControl(const Value: TControlProc);
    procedure SetOnExecute(const Value: TServiceProc);
    procedure SetData(const Value: DWord);
    procedure SetControl(const Value: TAcceptControls);
  protected
    procedure GenerateCreateForm( SL: TStringList ); override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    function AdditionalUnits: String; override;
    function FormTypeName: String; override;
    procedure AfterGeneratePAS( SL: TStringList ); override;
    procedure GenerateRun( SL: TStringList; const AName: String ); override;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor Destroy;
  published
    property ServiceName: String read FServiceName write SetServiceName;
    property OnStart: TServiceProc read FOnStart write SetOnStart;
    property OnExecute: TServiceProc read FOnExecute write SetOnExecute;
    property OnControl: TControlProc read FOnControl write SetOnControl;
    property OnStop: TServiceProc read FOnStop write SetOnStop;
    property Data: DWord read FData write SetData;
    property AcceptControl: TAcceptControls read fControl write SetControl;

    property AllBtnReturnClick: Boolean read fNotAvailable;
    property BorderStyle: Boolean read fNotAvailable;
    property Brush: Boolean read fNotAvailable;
    property Caption: Boolean read fNotAvailable;
    property EraseBackGround: Boolean read fNotAvailable;
    property ForceIcon16x16: Boolean read fNotAvailable;
    property HelpContextIcon: Boolean read fNotAvailable;
    property HowToDestroy: Boolean read fNotAvailable;
    property Localizy: Boolean read fNotAvailable;
    property Locked: Boolean read fNotAvailable;
    property popupMenu: Boolean read fNotAvailable;
    property ShowHint: Boolean read fNotAvailable;
    property StatusSizeGrip: Boolean read fNotAvailable;
    property SupportMnemonics: Boolean read fNotAvailable;
    property OnBeforeCreateWindow: Boolean read fNotAvailable;
    property OnDropFiles: Boolean read fNotAvailable;
    property OnMove: Boolean read fNotAvailable;
  end;

  TKOLServiceEx = class(TKOLService)
  private
    FOnPause: TServiceProc;
    FOnResume: TServiceProc;
    FOnInterrogate: TServiceProc;
    FOnShutdown: TServiceProc;
    FOnApplication: TServiceProc;
    fMCKForm: string;
    procedure SetOnPause(const Value: TServiceProc);
    procedure SetOnResume(const Value: TServiceProc);
    procedure SetOnInterrogate(const Value: TServiceProc);
    procedure SetOnShutdown(const Value: TServiceProc);
    procedure SetOnApplication(const Value: TServiceProc);
    procedure SetMCKForm(const Value: string);
  protected
    function AdditionalUnits: String; override;
    procedure GenerateCreateForm( SL: TStringList ); override;
    function FormTypeName: String; override;
    procedure AfterGeneratePAS( SL: TStringList ); override;
  published
    property OnPause: TServiceProc read FOnPause write SetOnPause;
    property OnResume: TServiceProc read FOnResume write SetOnResume;
    property OnInterrogate: TServiceProc read FOnInterrogate write SetOnInterrogate;
    property OnShutdown: TServiceProc read FOnShutdown write SetOnShutdown;
    property OnApplication: TServiceProc read FOnApplication write SetOnApplication;
    property MCKForm: string read fMCKForm write SetMCKForm;
  end;

procedure Register;

implementation

Uses UWrd;

{$R *.dcr}

procedure Register;
begin
  RegisterComponents( 'KOLUtil', [ TKOLService, TKOLServiceEx ] );
  RegisterPropertyEditor(TypeInfo(string), TKOLServiceEx, 'MCKForm', TKOLServiceFormEditor);
end;

{ TKOLServiceFormEditor }

function  GetFileList(dir: string): TStringList;
var
   Srch: TSearchRec;
   flag: Integer;
begin
   result := nil;
   flag := FindFirst(dir, faAnyFile, Srch);
   while flag = 0 do begin
      if (Srch.Name <> '.') and (Srch.Name <> '..') and (not(Srch.Attr and faDirectory > 0))then begin
         if Result = nil then begin
            Result := TStringList.Create;
         end;
         Result.Add(Srch.Name);
      end;
      flag := FindNext(Srch);
   end;
   FindClose(Srch);
end;

function TKOLServiceFormEditor.AutoFill;
begin
   Result := True;
end;

function TKOLServiceFormEditor.GetAttributes;
begin
   Result := [paValueList, paSortList];
end;

procedure TKOLServiceFormEditor.GetValues;
var List: TStringList;
       i: integer;
       f: Text;
       s: string;
begin
   List := GetFileList('*_1.inc');
   if List <> nil then begin
      for i := 0 to List.Count - 1 do begin
         AssignFile(f, List[i]);
         Reset(f);
         while not Eof(f) do begin
            readln(f, s);
            if pos('NewForm(', s) > 0 then begin
               proc(wordn(List[i], '_', 1));
               break;
            end;
         end;
         closeFile(f);
      end;
      List.Free;
   end;
end;

{ TKOLService }

constructor TKOLService.Create;
begin
   inherited;
   fControl := [ACCEPT_STOP, ACCEPT_PAUSE_CONTINUE,
                ACCEPT_SHUTDOWN];
end;

destructor TKOLService.Destroy;
begin
   inherited;
end;

function TKOLService.AdditionalUnits: String;
begin
  Result := ', Service';
end;

function TKOLServiceEx.AdditionalUnits: String;
begin
  Result := ', Service';
  if fMCKForm <> '' then Result := Result + ', ' + fMCKForm;
end;

procedure TKOLService.AssignEvents(SL: TStringList; const AName: String);
begin
  //
end;

function TKOLService.FormTypeName: String;
begin
  Result := 'PService';
end;

function TKOLServiceEx.FormTypeName: String;
begin
  Result := 'PServiceEx';
end;

procedure TKOLService.GenerateCreateForm(SL: TStringList);
var P: PDWord;
begin
  SL.Add( '  Result.Form := Service.NewService( ' +
     String2PascalStrExpr( FServiceName ) + ', ' +
     String2PascalStrExpr( FDisplayName ) + ');');
  if @OnStart <> nil then
     SL.Add( '  Result.Form.onStart   := Result.' + (Owner as TForm).MethodName( @onStart   ) + ';');
  if @OnExecute <> nil then
     SL.Add( '  Result.Form.onExecute := Result.' + (Owner as TForm).MethodName( @onExecute ) + ';');
  if @OnControl <> nil then
     SL.Add( '  Result.Form.onControl := Result.' + (Owner as TForm).MethodName( @onControl ) + ';');
  if @OnStop <> nil then
     SL.Add( '  Result.Form.onStop    := Result.' + (Owner as TForm).MethodName( @onStop    ) + ';');
  P := @fControl;
  if P^ <> 0 then
     SL.Add( '  Result.Form.Accepted  := $' + Int2Hex( P^, 8) + ';' );
  if Data <> 0 then
     SL.Add( '  Result.Form.Data      := $' + Int2Hex( Data, 8 ) + ';' );
  // Здесь можно присвоить дополнительные свойства, назначить дополнительные события...
  if @OnCreate <> nil then
     SL.Add( '  Result.' + (Owner as TForm).MethodName( @OnCreate ) +
             '( Result );' );
end;

procedure TKOLService.AfterGeneratePAS(SL: TStringList);
var i: integer;
    f: boolean;
    s: boolean;
begin
   i := 0;
   f := False;
   s := False;
   while i < SL.count do begin
      if pos('Form:', SL[i]) > 0 then begin
         SL[i] := '    Form: PService;';
      end;
      if pos('RunService', SL[i]) > 0 then f := True;
      if not f and FormMain then
      if pos('New' + Owner.Name + '(', SL[i]) > 0 then begin
         SL.Insert(i, 'procedure RunService;');
         inc(i);
         f := True;
      end;
      if (pos('implementation', SL[i]) > 0) and f and not s then begin
         SL.Insert(i + 1, '');
         SL.Insert(i + 2, 'procedure RunService;');
         SL.Insert(i + 3, 'begin');
         SL.Insert(i + 4, '   Service.Run;');
         SL.Insert(i + 5, 'end;');
         inc(i, 5);
         s := True;
      end;
      if (pos('RunService', SL[i]) > 0) and s then begin
         while pos('{$IFNDEF', SL[i]) = 0 do SL.Delete(i - 1);
      end;
      inc(i);
   end;
end;

procedure TKOLService.GenerateRun(SL: TStringList; const AName: String);
begin
  SL.Add( '  RunService;');
end;

procedure TKOLService.SetData(const Value: DWord);
begin
  FData := Value;
  Change( Self );
end;

procedure TKOLService.SetControl(const Value: TAcceptControls);
begin
  fControl := Value;
  Change( Self );
end;

procedure TKOLService.SetOnStart(const Value: TServiceProc);
begin
  FOnStart := Value;
  Change( Self );
end;

procedure TKOLService.SetOnControl(const Value: TControlProc);
begin
  FOnControl := Value;
  Change( Self );
end;

procedure TKOLService.SetOnExecute(const Value: TServiceProc);
begin
  FOnExecute := Value;
  Change( Self );
end;

procedure TKOLService.SetOnStop(const Value: TServiceProc);
begin
  FOnStop := Value;
  Change( Self );
end;

procedure TKOLService.SetServiceName(const Value: String);
begin
  FServiceName := Value;
  Change( Self );
end;

procedure TKOLService.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  //
end;

procedure TKOLService.SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  // SL.Add( '  InstallServices( [ Result.Form ] );' );
end;

procedure TKOLServiceEx.AfterGeneratePAS;
var i,
    s,
    m: integer;
    f,
    r: string;
    l: TStringList;
begin
   inherited;
   i := 0;
   m := 0;
   while (i < SL.count) and (pos('procedure', SL[i]) = 0) do begin
      if pos('Form:', SL[i]) > 0 then begin
         SL[i] := '    Form: PServiceEx;';
      end;
      inc(i);
   end;
   if i < SL.count then begin
      s := i;
      while (i < SL.count) do begin
         if pos('    procedure runMCK', SL[i]) > 0 then begin
            m := i;
            break;
         end;
         inc(i);
      end;
      if (m = 0) and (MCKForm <> '') then
         SL.Insert(s, '    procedure runMCK(Sender: PService);');
      if (m > 0) and (MCKForm =  '') then
         SL.delete(m);
      while (i < SL.count) and (pos('{$I ', SL[i]) = 0) do begin
         inc(i);
      end;
      if i < SL.count then begin
         s := i + 3;
         while (i < SL.count) do begin
            if pos('runMCK', SL[i]) > 0 then begin
               s := i;
               while SL[i] <> 'end;' do SL.delete(i);
               SL.delete(i);
               SL.delete(i);
               break;
            end;
            inc(i);
         end;
         if MCKForm <> '' then begin
            if s > 0 then begin
               l := TStringList.create;
               l.LoadFromFile(MCKForm + '.pas');
               i := 0;
               f := '';
               while i < l.count do begin
                  m := pos('^', l[i]);
                  if m > 0 then begin
                     f := '';
                     r := l[i];
                     i := m + 2;
                     while (r[i] <> ';') and (i < length(r)) do begin
                        f := f + r[i];
                        inc(i);
                     end;
//                     f := copy(l[i], m + 2, length(l[i]) - m - 2);
                     break;
                  end;
                  inc(i);
               end;
               SL.insert(s + 0, 'procedure T' + Owner.Name + '.runMCK(Sender: PService);');
               SL.insert(s + 1, 'begin');
               SL.insert(s + 2, '   Applet := NewApplet(''' + ServiceName + ''');');
               SL.insert(s + 3, '   Applet.Visible := False;');
               SL.insert(s + 4, '   New' + f + '(' + f + ', Applet);');
               SL.insert(s + 5, '   KOL.run( Applet );');
               SL.insert(s + 6, '   ' + f + ' := nil;');
               SL.insert(s + 7, 'end;');
               SL.insert(s + 8, '');
               l.Free;
            end;
         end;
      end;
   end;
end;

procedure TKOLServiceEx.GenerateCreateForm(SL: TStringList);
var P: PDWord;
begin
  SL.Add( '  Result.Form := Service.NewServiceEx( ' +
     String2PascalStrExpr( FServiceName ) + ', ' +
     String2PascalStrExpr( FDisplayName ) + ');');
  if @OnExecute <> nil then
     SL.Add( '  Result.Form.onExecute        := Result.' + (Owner as TForm).MethodName( @onExecute ) + ';');
  if @OnControl <> nil then
     SL.Add( '  Result.Form.onControl        := Result.' + (Owner as TForm).MethodName( @onControl ) + ';');
  if @OnStop <> nil then
     SL.Add( '  Result.Form.onStop           := Result.' + (Owner as TForm).MethodName( @onStop    ) + ';');
  if @OnPause <> nil then
     SL.Add( '  Result.Form.onPause          := Result.' + (Owner as TForm).MethodName( @onPause ) + ';');
  if @OnResume <> nil then
     SL.Add( '  Result.Form.onResume         := Result.' + (Owner as TForm).MethodName( @onResume ) + ';');
  if @OnInterrogate <> nil then
     SL.Add( '  Result.Form.onInterrogate    := Result.' + (Owner as TForm).MethodName( @onInterrogate ) + ';');
  if @OnShutdown <> nil then
     SL.Add( '  Result.Form.onShutdown       := Result.' + (Owner as TForm).MethodName( @onShutdown ) + ';');
  if MCKForm <> '' then
     SL.Add( '  Result.Form.onApplicationRun := Result.runMCK;') else
  if @OnApplication <> nil then
     SL.Add( '  Result.Form.onApplicationRun := Result.' + (Owner as TForm).MethodName( @onApplication ) + ';');
  P := @fControl;
  if P^ <> 0 then
     SL.Add( '  Result.Form.Accepted         := $' + Int2Hex( P^, 8) + ';' );
  if Data <> 0 then
     SL.Add( '  Result.Form.Data             := $' + Int2Hex( Data, 8 ) + ';' );
  // Здесь можно присвоить дополнительные свойства, назначить дополнительные события...
  if @OnCreate <> nil then
     SL.Add( '  Result.' + (Owner as TForm).MethodName( @OnCreate ) +
             '( Result );' );
end;

procedure TKOLServiceEx.SetOnPause(const Value: TServiceProc);
begin
  FOnPause := Value;
  Change( Self );
end;

procedure TKOLServiceEx.SetOnResume(const Value: TServiceProc);
begin
  FOnResume := Value;
  Change( Self );
end;

procedure TKOLServiceEx.SetOnInterrogate(const Value: TServiceProc);
begin
  FOnInterrogate := Value;
  Change( Self );
end;

procedure TKOLServiceEx.SetOnShutdown(const Value: TServiceProc);
begin
  FOnShutdown := Value;
  Change( Self );
end;

procedure TKOLServiceEx.SetOnApplication(const Value: TServiceProc);
begin
  FOnApplication := Value;
  Change( Self );
end;

procedure TKOLServiceEx.SetMCKForm(const Value: string);
begin
   if fileexists(Value + '.pas') then begin
      fMCKForm := Value;
   end else begin
      if Value <> '' then
         ShowMessage('File: ' + Value + '.pas does not exist')
      else begin
         fMCKForm := Value;
      end;
   end;
   Change( Self );
end;

end.
