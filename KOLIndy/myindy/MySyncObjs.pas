{ *************************************************************************** }
{                                                                             }
{ Kylix and Delphi Cross-Platform Visual Component Library                    }
{                                                                             }
{ Copyright (c) 1997, 2001 Borland Software Corporation                       }
{                                                                             }
{ *************************************************************************** }


unit MySyncObjs;

{$H+,X+}

interface

uses 
{$IFDEF MSWINDOWS}
  Windows,
  Messages;
{$ENDIF}
{$IFDEF LINUX}
  Libc;
{$ENDIF}

type
{$IFNDEF MSWINDOWS}
  PSecurityAttributes = pointer;
{$ENDIF}

  TSynchroObject = class(TObject)
  public
    procedure Acquire; virtual;
    procedure Release; virtual;
  end;

  THandleObject = class(TSynchroObject)
{$IFDEF MSWINDOWS}
  private
    FHandle: THandle;
    FLastError: Integer;
  public
    destructor Destroy; override;
    property LastError: Integer read FLastError;
    property Handle: THandle read FHandle;
{$ENDIF}
  end;

  TWaitResult = (wrSignaled, wrTimeout, wrAbandoned, wrError);

  TEvent = class(THandleObject)
  {$IFDEF LINUX}
  private
    FEvent: TSemaphore;
    FManualReset: Boolean;
  {$ENDIF}
  public
    constructor Create(EventAttributes: PSecurityAttributes; ManualReset,
      InitialState: Boolean; const Name: string);
    function WaitFor(Timeout: LongWord): TWaitResult;
    procedure SetEvent;
    procedure ResetEvent;
  end;

  TSimpleEvent = class(TEvent)
  public
    constructor Create;
  end;

  TCriticalSection = class(TSynchroObject)
  protected
    FSection: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Acquire; override;
    procedure Release; override;
    procedure Enter;
    procedure Leave;
  end;

implementation

{ TSynchroObject }

procedure TSynchroObject.Acquire;
begin
end;

procedure TSynchroObject.Release;
begin
end;

{ THandleObject }

{$IFDEF MSWINDOWS}
destructor THandleObject.Destroy;
begin
  CloseHandle(FHandle);
  inherited Destroy;
end;
{$ENDIF}

{ TEvent }

constructor TEvent.Create(EventAttributes: PSecurityAttributes; ManualReset,
  InitialState: Boolean; const Name: string);
{$IFDEF MSWINDOWS}
begin
  FHandle := CreateEvent(EventAttributes, ManualReset, InitialState, PChar(Name));
end;
{$ENDIF}
{$IFDEF LINUX}
var
   Value: Integer;
begin
   if InitialState then
     Value := 1
  else 
    Value := 0;
  
  FManualReset := ManualReset;

   sem_init(FEvent, False, Value);
end;
{$ENDIF}

function TEvent.WaitFor(Timeout: LongWord): TWaitResult;
begin
{$IFDEF MSWINDOWS}
  case WaitForSingleObject(Handle, Timeout) of
    WAIT_ABANDONED: Result := wrAbandoned;
    WAIT_OBJECT_0: Result := wrSignaled;
    WAIT_TIMEOUT: Result := wrTimeout;
    WAIT_FAILED:
      begin
        Result := wrError;
        FLastError := GetLastError;
      end;
  else
    Result := wrError;    
  end;
{$ENDIF}
{$IFDEF LINUX}
  if Timeout = LongWord($FFFFFFFF) then
  begin
    sem_wait(FEvent);
    Result := wrSignaled;
  end 
  else if FManualReset then
    sem_post(FEvent)
  else
    Result := wrError;
{$ENDIF}
end;

procedure TEvent.SetEvent;
{$IFDEF MSWINDOWS}
begin
  Windows.SetEvent(Handle);
end;
{$ENDIF}
{$IFDEF LINUX}
var
  I: Integer;
begin
  sem_getvalue(FEvent, I);
  if I = 0 then
    sem_post(FEvent);
end;
{$ENDIF}

procedure TEvent.ResetEvent;
begin
{$IFDEF MSWINDOWS}
  Windows.ResetEvent(Handle);
{$ENDIF}
{$IFDEF LINUX}
  while sem_trywait(FEvent) = 0 do { nothing };
{$ENDIF}
end;

{ TSimpleEvent }

constructor TSimpleEvent.Create;
begin
  inherited Create(nil, True, False, '');
end;

{ TCriticalSection }

constructor TCriticalSection.Create;
begin
  inherited Create;
  InitializeCriticalSection(FSection);
end;

destructor TCriticalSection.Destroy;
begin
  DeleteCriticalSection(FSection);
  inherited Destroy;
end;

procedure TCriticalSection.Acquire;
begin
  EnterCriticalSection(FSection);
end;

procedure TCriticalSection.Release;
begin
  LeaveCriticalSection(FSection);
end;

procedure TCriticalSection.Enter;
begin
  Acquire;
end;

procedure TCriticalSection.Leave;
begin
  Release;
end;

end.
