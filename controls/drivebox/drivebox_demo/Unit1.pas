{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLBAPDriveBox {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, mckCtrls, mckBAPDriveBox,  mckObjs,  StdCtrls {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} PForm1 = TForm1; {$ELSE OBJECTS} PForm1 = ^TForm1; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm1.inc}{$ELSE} TForm1 = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    lDrive: TKOLLabel;
    Button1: TKOLButton;
    Button2: TKOLButton;
    ColorDialog1: TKOLColorDialog;
    CheckBox1: TKOLCheckBox;
    Button3: TKOLButton;
    Button4: TKOLButton;
    Label1: TKOLLabel;
    lLabel: TKOLLabel;
    BAPDriveBox1: TKOLBAPDriveBox;
    BAPDriveBox2: TKOLBAPDriveBox;
    ebVol: TKOLEditBox;
    bSetVol: TKOLButton;
    lVol: TKOLLabel;
    procedure Button1Click(Sender: PObj);
    procedure Button2Click(Sender: PObj);
    procedure Button3Click(Sender: PObj);
    procedure Button4Click(Sender: PObj);
    procedure CheckBox1Click(Sender: PObj);
    procedure BAPDriveBox1ChangeDrive(Sender: PControl; Drive: String;
      const ReadErr: Boolean; var Retry: Boolean);
    procedure bSetVolClick(Sender: PObj);
    procedure KOLForm1Show(Sender: PObj);
    procedure BAPDriveBox1ChangeDriveLabel(Sender: PControl);
  private
    { Private declarations }
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
{$I Unit1_1.inc}
{$ENDIF}

procedure TForm1.KOLForm1Show(Sender: PObj);
begin
  ColorDialog1.OwnerWindow := Form.Handle;
  lDrive.Caption := BAPDriveBox1.Drive;
  lLabel.Caption := BAPDriveBox1.DriveLabel;
  ebVol.Text := lLabel.Caption;
  lVol.Caption := 'Новая метка диска '+ BAPDriveBox1.Drive;
end;

procedure TForm1.Button1Click(Sender: PObj);
begin
  if not ColorDialog1.Execute then
    Exit;
  BAPDriveBox1.SelTextColor := ColorDialog1.Color;
end;

procedure TForm1.Button2Click(Sender: PObj);
begin
  if not ColorDialog1.Execute then
    Exit;
  BAPDriveBox1.SelBackColor := ColorDialog1.Color;
end;

procedure TForm1.Button3Click(Sender: PObj);
begin
  BAPDriveBox1.OpenList;
end;

procedure TForm1.Button4Click(Sender: PObj);
begin
  BAPDriveBox1.UpdateList;
  BAPDriveBox2.UpdateList;
end;

procedure TForm1.CheckBox1Click(Sender: PObj);
begin
  if CheckBox1.Checked then
    BAPDriveBox1.LightIcon := True
  else
    BAPDriveBox1.LightIcon := False;
end;

procedure TForm1.BAPDriveBox1ChangeDrive(Sender: PControl; Drive: String;
  const ReadErr: Boolean; var Retry: Boolean);
begin
  if ReadErr then
    if MessageBox(0, PChar('Не могу прочитать диск ' + Drive + #13 + #10 +
        'Повторить чтение?'), 'Ошибка чтения',
        MB_RETRYCANCEL + MB_ICONSTOP) = IDRETRY then
      Retry := True;

  if ReadErr then
    Exit;
  lDrive.Caption := Drive;
  lLabel.Caption := BAPDriveBox1.DriveLabel;
  ebVol.Text := lLabel.Caption;
  lVol.Caption := 'Новая метка диска '+ Drive;
end;

procedure TForm1.BAPDriveBox1ChangeDriveLabel(Sender: PControl);
begin
  lLabel.Caption := BAPDriveBox1.DriveLabel;
  ebVol.Text := lLabel.Caption;
end;

(* ИЗМЕНЕНИЕ МЕТКИ ДИСКА *)

procedure TForm1.bSetVolClick(Sender: PObj);
var
  Flag: Boolean;
begin
  Flag := SetVolumeLabel(PChar(BAPDriveBox1.Drive + '\'), PChar(ebVol.Text));
  if not Flag then
    MessageBox(Applet.Handle, PChar('Не могу изменить метку диска ' +
      BAPDriveBox1.Drive), 'Error', MB_ICONSTOP)
  else if GetDriveType(PChar(BAPDriveBox1.Drive + '\')) <> DRIVE_FIXED then
    BAPDriveBox1ChangeDriveLabel(@Self);
end;

end.