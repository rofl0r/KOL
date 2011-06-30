{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  mckCtrls, Controls {$ENDIF},KOLFingCli,Sysutils;
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mirror;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TForm1 = class; PForm1 = TForm1; {$ELSE OBJECTS} PForm1 = ^TForm1; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm1.inc}{$ELSE} TForm1 = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    QueryEdit: TKOLEditBox;
    QueryButton: TKOLButton;
    CancelButton: TKOLButton;
    DisplayMemo: TKOLMemo;
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure QueryButtonClick(Sender: PObj);
    procedure CancelButtonClick(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FingerCli1SessionConnected(Sender: PObj; Error: Word);
    procedure FingerCli1DataAvailable(Sender: PObj; Error: Word);
    procedure FingerCli1QueryDone(Sender: PObj; Error: Word);
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;
  FingerCli1:PFingerCli;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure MemoAddLines(Memo : PControl; Msg : String);
const
    CR = #13;
    LF = #10;
var
    Start, Stop : Integer;
begin
    if Memo.Count = 0 then
        Memo.Add('');

    Start := 1;
    Stop  := Pos(CR, Msg);
    if Stop = 0 then
        Stop := Length(Msg) + 1;
    while Start <= Length(Msg) do begin
        Memo.Items[Memo.Count - 1] :=
            Memo.Items[Memo.Count - 1] +
            Copy(Msg, Start, Stop - Start);
        if Msg[Stop] = CR then begin
            Memo.Add('');
            SendMessage(Memo.Handle, WM_KEYDOWN, VK_UP, 1);
        end;
        Start := Stop + 1;
        if Start > Length(Msg) then
            Break;
        while Msg[Start] in [CR, LF] do
           Start := Start + 1;
        Stop := Start;
        while (Msg[Stop] <> CR) and (Stop <= Length(Msg)) do
            Stop := Stop + 1;
    end;
end;

procedure TForm1.FingerCli1SessionConnected(Sender: PObj; Error: Word);
begin
    if Error = 0 then
        MemoAddLines(DisplayMemo, 'Connected to host.' + #13);
end;

procedure TForm1.FingerCli1DataAvailable(Sender: PObj; Error: Word);
const
  BufferSize=1024;
var
    Buffer : array [0..BufferSize - 1] of char;
    Len    : Integer;
begin
    while TRUE do begin
        Len := FingerCli1.Receive(@Buffer, SizeOf(Buffer) - 1);
        if Len <= 0 then
            break;
        Buffer[Len] := #0;
        MemoAddLines(DisplayMemo, StrPas(Buffer));
    end;
end;

procedure TForm1.FingerCli1QueryDone(Sender: PObj; Error: Word);
const
  WSAECONNREFUSED=1;
  WSAETIMEDOUT=2;
begin
    if Error <> 0 then begin
        if Error = WSAECONNREFUSED then
            MemoAddLines(DisplayMemo, 'No finger service available.' + #13)
        else if Error = WSAETIMEDOUT then
            MemoAddLines(DisplayMemo, 'Host unreachable.' + #13)
        else
            MemoAddLines(DisplayMemo, 'Error #' + IntToStr(Error) + #13);
    end;
    MemoAddLines(DisplayMemo, 'Done.' + #13);

    QueryButton.Enabled  := TRUE;
    CancelButton.Enabled := FALSE;
    { If we started from command line, then close application }
    if ParamCount > 0 then
        Form.Close;
end;

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  FingerCli1:=NewFingerCli(nil);
  FingerCli1.OnSessionConnected:=FingerCli1SessionConnected;
  FingerCli1.OnDataAvailable:=FingerCli1DataAvailable;
  FingerCli1.OnQueryDone:=FingerCli1QueryDone;
end;

procedure TForm1.QueryButtonClick(Sender: PObj);
begin
    DisplayMemo.Clear;
    QueryButton.Enabled  := FALSE;
    CancelButton.Enabled := TRUE;
    FingerCli1.Query:= QueryEdit.Text;
    FingerCli1.StartQuery;
    MemoAddLines(DisplayMemo, 'Query started.' + #13);
end;

procedure TForm1.CancelButtonClick(Sender: PObj);
begin
  FingerCli1.Abort;
end;

end.


