{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit4;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, Service, Unit2 {$IFNDEF KOL_MCK}, mirror, Classes,  mckService {$ENDIF};
{$ELSE}
{$I uses.inc} mirror,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TForm4 = class; PForm4 = TForm4; {$ELSE OBJECTS} PForm4 = ^TForm4; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm4.inc}{$ELSE} TForm4 = object(TObj) {$ENDIF}
    Form: PServiceEx;
  {$ELSE not_KOL_MCK}
  TForm4 = class(TForm)
  {$ENDIF KOL_MCK}
    Service: TKOLServiceEx;
    procedure runMCK(Sender: PService);
    procedure ServiceStart(Sender: PService);
    procedure ServiceControl(Sender: PService; Code: Cardinal);
    procedure ServiceExecute(Sender: PService);
    procedure ServicePause(Sender: PService);
    procedure ServiceResume(Sender: PService);
    procedure ServiceStop(Sender: PService);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4 {$IFDEF KOL_MCK} : PForm4 {$ELSE} : TForm4 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm4( var Result: PForm4; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit4_1.inc}
{$ENDIF}

procedure TForm4.runMCK(Sender: PService);
begin
   Applet := NewApplet('KOL_ServiceB');
   Applet.Visible := False;
   NewForm2(Form2, Applet);
   KOL.run( Applet );
   Form2 := nil;
end;

procedure TForm4.ServiceStart(Sender: PService);
begin
   MSGOk('Service B is about to start');
end;

procedure TForm4.ServiceControl(Sender: PService; Code: Cardinal);
begin
   if assigned(Form2) then begin
      Form2.Label2.Caption := 'code: ' + int2str(code);
   end;
end;

procedure TForm4.ServiceExecute(Sender: PService);
var i: integer;
begin
  i := 0;
  repeat
    Sleep(1000);
    windows.Beep( 50, 50 );
    inc(i);
    if assigned(Form2) then begin
       Form2.Label1.Caption := int2str(i);
       Form2.Form.Caption := int2str(Form2.Form.Handle);
    end;
  until False;
end;

procedure TForm4.ServicePause(Sender: PService);
begin
   if assigned(form2) then
      Form2.Form.SimpleStatusText := 'Paused';
end;

procedure TForm4.ServiceResume(Sender: PService);
begin
   if assigned(form2) then
      Form2.Form.SimpleStatusText := 'Running';
end;

procedure TForm4.ServiceStop(Sender: PService);
begin
   MSGOk('Service B is about to stop')
end;

end.










































































































