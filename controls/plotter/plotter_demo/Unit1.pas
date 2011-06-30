{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLPlotter, FormSave {$IFNDEF KOL_MCK}, mirror, Classes,  mckCtrls, Controls,  mckPlotter,
  mckFormSave {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mirror;
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
    KF: TKOLForm;
    P1: TKOLPanel;
    P2: TKOLPanel;
    EB: TKOLEditBox;
    L1: TKOLLabel;
    PL: TKOLPlotter;
    PM: TKOLPopupMenu;
    FS: TKOLFormSave;
    procedure EBLeave(Sender: PObj);
    procedure EBKeyDown(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
    procedure PLMouseMove(Sender: PControl; var Mouse: TMouseEventData);
    procedure PLMouseDown(Sender: PControl; var Mouse: TMouseEventData);
    procedure PLMouseUp(Sender: PControl; var Mouse: TMouseEventData);
    procedure PMN1Menu(Sender: PMenu; Item: Integer);
    procedure PMN2Menu(Sender: PMenu; Item: Integer);
    procedure PLDestroy(Sender: PObj);
  private
    { Private declarations }
    fx,
    fy: integer;
    dr: boolean;
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

procedure TForm1.EBLeave(Sender: PObj);
begin
   PL.formula := EB.Text;
end;

procedure TForm1.EBKeyDown(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
begin
   if key = 13 then begin
      PL.formula := EB.Text;
   end;
end;

procedure TForm1.PLMouseDown(Sender: PControl; var Mouse: TMouseEventData);
begin
   if mouse.Button = mbLeft then begin
      dr := true;
      fx := mouse.X;
      fy := mouse.Y;
      PL.Cursor := LoadCursor(0, IDC_HAND);
   end;   
end;

procedure TForm1.PLMouseMove(Sender: PControl; var Mouse: TMouseEventData);
begin
   if dr then begin
      PL.translate(mouse.X - fx, mouse.Y - fy);
      fx := mouse.X;
      fy := mouse.Y;
   end;   
end;

procedure TForm1.PLMouseUp(Sender: PControl; var Mouse: TMouseEventData);
begin
   dr := false;
   PL.Cursor := LoadCursor(0, IDC_ARROW);
end;

procedure TForm1.PMN1Menu(Sender: PMenu; Item: Integer);
begin
   PL.zoomIn;
end;

procedure TForm1.PMN2Menu(Sender: PMenu; Item: Integer);
begin
   PL.zoomOut;
end;

procedure TForm1.PLDestroy(Sender: PObj);
begin
//
end;

end.






