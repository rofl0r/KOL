{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  mckObjs, Controls, mckCtrls {$ENDIF};
{$ELSE}
{$I uses.inc}
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
    Thread1: TKOLThread;
    Button1: TKOLButton;
    Button2: TKOLButton;
    Memo1: TKOLMemo;
    Button3: TKOLButton;
    function Thread1Execute(Sender: PThread): Integer;
    procedure Thread1Resume(Sender: PObj);
    procedure Thread1Suspend(Sender: PObj);
    procedure Thread1Destroy(Sender: PObj);
    procedure Button1Click(Sender: PObj);
    procedure Button2Click(Sender: PObj);
    procedure KOLForm1Close(Sender: PObj; var Accept: Boolean);
    procedure Button3Click(Sender: PObj);
  private
    { Private declarations }
    StopThread: Boolean;
    ThreadFinished: Boolean;
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

function TForm1.Thread1Execute(Sender: PThread): Integer;
begin
  StopThread := FALSE;
  ThreadFinished := FALSE;
  while not StopThread do
  begin
    Sleep( 1000 );
    Beep( 1000, 100 );
  end;
  Result := 0;
  ThreadFinished := TRUE;
end;

procedure TForm1.Thread1Resume(Sender: PObj);
begin
  ShowMsgModal( 'Thread resumed' );
end;

procedure TForm1.Thread1Suspend(Sender: PObj);
begin
  ShowMsgModal( 'Thread suspended' );
end;

procedure TForm1.Thread1Destroy(Sender: PObj);
begin
  ShowMsgModal( 'Thread destroyed' );
end;

procedure TForm1.Button1Click(Sender: PObj);
begin
  Thread1.Resume;
end;

procedure TForm1.Button2Click(Sender: PObj);
begin
  Thread1.Suspend;
end;

procedure TForm1.KOLForm1Close(Sender: PObj; var Accept: Boolean);
begin
  StopThread := TRUE;
  if Thread1.Suspended then
    Thread1.Resume;
  Thread1.WaitFor;
end;

procedure TForm1.Button3Click(Sender: PObj);
begin
  Thread1.Terminate;
  Form.Close;
end;

end.


