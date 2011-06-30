unit FormSave;

interface

uses KOL, messages;

type

   PFormSave =^TFormSave;
   TKOLFormSave = PFormSave;
   TFormSave = object(TObj)
    OwnerPTR: PControl;
   protected
    destructor Destroy; virtual;
   public
    FileName: String;
    Registry: boolean;
     Section: String;
    procedure SaveWindow(w: boolean);
    procedure SaveString(n, s: string);
    function  ReadString(n: string): string;
   end;

function NewFormSave(AOwner: PControl): PFormSave;

implementation

uses UStr, windows, objects;

function NewFormSave;
begin
   New(Result, Create);
   Result.OwnerPTR := AOwner;
   Result.FileName := JustPathName(ParamStr(0)) + '\' + JustName(ParamStr(0)) + '.ini';
   Result.Registry := False;
end;

destructor TFormSave.Destroy;
begin
   SaveWindow(True);
   inherited;
end;

procedure TFormSave.SaveWindow;
var i: PIniFile;
    k: HKEY;
    p: WINDOWPLACEMENT;
begin
   if Registry then begin
      if w then begin
         k := RegKeyOpenCreate(HKEY_CURRENT_USER, 'Software\KOLSoft\' + JustName(ParamStr(0)) + '\' + Section + '\');
         if GetWindowPlacement(OwnerPTR.Handle, @p) then begin
            RegKeySetDw(k, 'Left', p.rcNormalPosition.Left);
            RegKeySetDw(k, 'Top', p.rcNormalPosition.Top);
            RegKeySetDw(k, 'Width', p.rcNormalPosition.Right - p.rcNormalPosition.Left);
            RegKeySetDw(k, 'Height', p.rcNormalPosition.Bottom - p.rcNormalPosition.Top);
            RegKeySetDw(k, 'Show', DWord(OwnerPTR.Visible));
         end else begin
            RegKeySetDw(k, 'Left', OwnerPTR.Left);
            RegKeySetDw(k, 'Top', OwnerPTR.Top);
            RegKeySetDw(k, 'Width', OwnerPTR.Width);
            RegKeySetDw(k, 'Height', OwnerPTR.Height);
            RegKeySetDw(k, 'Show', DWord(OwnerPTR.Visible));
         end;
      end  else begin
         k := RegKeyOpenRead  (HKEY_CURRENT_USER, 'Software\KOLSoft\' + JustName(ParamStr(0)) + '\' + Section + '\');
         if k <> 0 then begin
            OwnerPTR.Left    := RegKeyGetDw(k, 'Left');
            OwnerPTR.Top     := RegKeyGetDw(k, 'Top');
            OwnerPTR.Width   := RegKeyGetDw(k, 'Width');
            OwnerPTR.Height  := RegKeyGetDw(k, 'Height');
            OwnerPTR.Visible := boolean(RegKeyGetDw(k, 'Show'));
         end;
      end;
   end else begin
      i := OpenIniFile(FileName);
      if w then i.Mode := ifmWrite
           else i.Mode := ifmRead;
      i.Section := Section;
      OwnerPTR.Left    := i.ValueInteger('Left', OwnerPTR.Left);
      OwnerPTR.Top     := i.ValueInteger('Top', OwnerPTR.Top);
      OwnerPTR.Width   := i.ValueInteger('Width', OwnerPTR.Width);
      OwnerPTR.Height  := i.ValueInteger('Height', OwnerPTR.Height);
      OwnerPTR.Visible := i.ValueBoolean('Show', OwnerPTR.Visible);
   end;
end;

procedure TFormSave.SaveString;
var i: PIniFile;
    k: HKEY;
begin
   if Registry then begin
      k := RegKeyOpenCreate(HKEY_CURRENT_USER, 'Software\KOLSoft\' + JustName(ParamStr(0)) + '\' + Section + '\');
      RegKeySetStr(k, n, s);
   end else begin
      i := OpenIniFile(FileName);
      i.Mode := ifmWrite;
      i.Section := Section;
      i.ValueString(n, s);
   end;
end;

function  TFormSave.ReadString;
var i: PIniFile;
    k: HKEY;
begin
   if Registry then begin
      k := RegKeyOpenCreate(HKEY_CURRENT_USER, 'Software\KOLSoft\' + JustName(ParamStr(0)) + '\' + Section + '\');
      Result := RegKeyGetStr(k, n);
   end else begin
      i := OpenIniFile(FileName);
      i.Mode := ifmRead;
      i.Section := Section;
      Result := i.ValueString(n, '');
   end;
end;

end.