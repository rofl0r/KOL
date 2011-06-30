// 20-nov-2002
unit IdAntiFreeze;

interface

uses KOL { ,
  Classes } ,
  IdAntiFreezeBase,
  IdBaseComponent;

type
  TIdAntiFreeze = object(TIdAntiFreezeBase)
  public
    procedure Process; virtual;{ override;}
  end;
PIdAntiFreeze=^TIdAntiFreeze;

implementation

uses
{$IFDEF LINUX}
  QForms;
{$ELSE}
  Forms,
  Messages,
  Windows;
{$ENDIF}

{$IFDEF LINUX}

procedure TIdAntiFreeze.Process;
begin
  Application.ProcessMessages;
end;
{$ELSE}

procedure TIdAntiFreeze.Process;
var
  Msg: TMsg;
begin
  if ApplicationHasPriority then
  begin
    Application.ProcessMessages;
  end
  else
  begin
    if PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE) then
    begin
      Application.HandleMessage;
    end;
  end;
end;
{$ENDIF}

end.
