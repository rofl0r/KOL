{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit KOLForm;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLDHTML, FormSave {$IFNDEF KOL_MCK}, mirror, Classes,  Controls, OleCtrls, SHDocVw,  mckCtrls,  mckFormSave, mckDHTML {$ENDIF};
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
    KP: TKOLProject;
    KF: TKOLForm;
    CB: TKOLComboBox;
    FS: TKOLFormSave;
    DHTML: TDHTMLEDIT;
    procedure CBKeyDown(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
    procedure CBClick(Sender: PObj);
    procedure CBSelChange(Sender: PObj);
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
{$I KOLForm_1.inc}
{$ENDIF}

procedure TForm1.CBKeyDown(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
begin
   if key = 13 then begin
      CBClick(@self);
   end;
end;

procedure TForm1.CBSelChange(Sender: PObj);
begin
   CBClick(@self);
end;

procedure TForm1.CBClick(Sender: PObj);
var Path: OleVariant;
begin
   Path := CB.Text;
   try
      DHTML.LoadDocument( Path );
      if CB.IndexOf( Path ) < 0 then begin
         CB.Add(Path);
      end;
   except
      try
         DHTML.LoadURL( Path );
         if CB.IndexOf( Path ) < 0 then begin
            CB.Add(Path);
         end;
      except
         MsgOK('Exception loading document: ' + Path);
      end;
   end;
end;

end.











