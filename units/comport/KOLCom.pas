unit KOLCom;
{ Объект для работы с СОМ-портом. Минимально необходимые свойства.
  Очень короткий код. Передача осуществляется независимо от состояния
  модемных концов, прием идет асинхронно без ожидания паузы в байтах.
  Проверялся на 98/ХР. Версия КОЛ/МСК - 1.56}
// автор - Пивко Василий. 2002 г.
interface

uses
  KOL, Windows, ShellAPI;

type
  TCommEvent = (evRxChar,evTxEmpty,evCTS,evDSR,evRLSD,evBreak,evErr,evRING);
  TCommEvents = set of TCommEvent;
  TCommParity =(None,Odd,Even,Mark,Space);
  TCommStopbits = (One,Two);
  TComRxByte = procedure (Buff : array of byte; Count : dWord) of object;
  TComModem = procedure (bDSR,bCTS,bRING,bRLSD : boolean) of object;
  TComTxEmpty = procedure of object;
  TComErr_Break = procedure (bError,bBreak : boolean) of object;

  PCom = ^TCom;
  TKOLCom = PCom;

  TCom = object(TObj)
  private
    FCid : DWord;
    FNum : byte;
    FDCB : TDCB;
    FOvr : TOverlapped;
    FStat : TComStat;
    FKols,FMask,FTrans,FErrs : DWord;
    FParity : TCommParity;
    FStopBits : TCommStopBits;
    FLines : array [0..7] of boolean;
    FEventMask : TCommEvents;
    FEvents : DWord;
    FCommThread : THandle;
    FLenBuff : array[0..1] of word;
    FTxEvent, FExist : THandle;
    FOnRxByte : TComRxByte;
    FOnTxEmpty : TComTxEmpty;
    FOnModem : TComModem;
    FOnErr_Break : TComErr_Break;
    FOpened : boolean;
    FWorking : boolean;
    FTerminated : boolean;
    FBuff : array [0..511] of byte;
    FModems : dWord;
    FClosed : boolean;
  protected
    procedure SetNum(Value : byte);
    function  GetLenBuff(Ind : integer) : word;
    procedure SetLenBuff(Ind : integer; Value : word);
    function  GetLines(Ind : integer) : boolean;
    procedure SetLines(Ind : integer; Value : boolean);
    procedure SetBaudRate(Value : DWord);
    procedure SetStopBits(Value : TCommStopBits);
    procedure SetParity(Value : TCommParity);
    procedure SetEventMask(Value : TCommEvents);
  public
    destructor Destroy; virtual;
  // функция открытия порта, 0 - норма,
  // При bWork = False - порт открывается, чтение невозможно, передача возможна
  // При bWork = True - порт открывается по полной программе
    function Open(bWork : boolean) : integer;
  // функция закрытия порта
    function Close : boolean;
  // функция записи в порт через буфер. Wait = True - ожидать окончания записи
  // в буфер передачи (в этом случае возвращает кол-во записанных байт)
    function Write(Buff : array of byte;
                   Count : DWord; Wait : boolean) : DWord;
  // функция записи в порт строки (все равно работает через буфер)
    function WriteStr(S : string; Wait : boolean) : DWord;
    property Handle : DWord read FCid;
  // номер порта
    property NumPort : byte read FNum write SetNum;
  // размеры приемного и передающего буфера
    property LenTxBuff : word index 0 read GetLenBuff write SetLenBuff;
    property LenRxBuff : word index 1 read GetLenBuff write SetLenBuff;
  // разрешение управления выходными модемными концами посредством EscapeCommFunction
    property CtrDTR : boolean index 0 read GetLines write SetLines;
    property CtrRTS : boolean index 1 read GetLines write SetLines;
  // выходные модемные концы
    property DTR : boolean index 2 read GetLines write SetLines;
    property RTS : boolean index 3 read GetLines write SetLines;
  // скорость передачи-приема (120 - 115200)
    property BaudRate : DWord read FDCB.BaudRate write SetBaudRate;
  // количество стоп-битов (1-2)
    property StopBits : TCommStopBits read FStopBits write SetStopBits;
  // наличие и характеристика бита четности
    property Parity : TCommParity read FParity write SetParity;
  // маска обрабатываемых прерываний СОМ-порта
    property EventMask : TCommEvents read FEventMask write SetEventMask;
  // эвент на принятие хотя бы одного байта
    property OnRxByte : TComRxByte read FOnRxByte write FOnRxByte;
  // эвент на возможность записи в СОМ-порт (отнюдь не означает,
  // что все байты уже вытолкнуты из порта)
    property OnTxEmpty : TComTxEmpty read FOnTxEmpty write FOnTxEmpty;
  // эвент на изменение состояния входных концов DSR,CTS,RING,RX
    property OnModem : TComModem read FOnModem write FOnModem;
  // эвент на возникновение ошибки или обрыва приема
    property OnErr_Break : TComErr_Break read FOnErr_Break write FOnErr_Break;
    property Closed : boolean read FClosed;
  // входные модемные концы
    property DSR : boolean index 4 read GetLines;
    property CTS : boolean index 5 read GetLines;
    property RING : boolean index 6 read GetLines;
    property RLSD : boolean index 7 read GetLines;
  end;

function NewKOLCom (Wnd: PControl): PCom;

implementation

const
  CommEventList: array[TCommEvent] of Dword =
    (EV_RXCHAR,EV_TXEMPTY,EV_CTS,EV_DSR,EV_RLSD,EV_BREAK,EV_ERR,EV_RING);
  CommStopBits: array[TCommStopbits] of byte =
    (ONESTOPBIT,TWOSTOPBITS);
  CommParity: array[TCommParity] of byte =
    (NOPARITY,ODDPARITY,EVENPARITY,MARKPARITY,SPACEPARITY);

function NewKOLCom(Wnd: PControl) : PCom;
begin
  New(Result, Create);
  Result.FTxEvent := CreateEvent(nil,TRUE,FALSE,#0);
  Result.FExist := CreateEvent(nil,TRUE,FALSE,#0);
  Result.FOvr.hEvent := CreateEvent(nil,TRUE,FALSE,#0);
  Result.FNum := 1;
  Result.FStopBits := Two;
  Result.FParity := None;
  Result.FLenBuff[0] := 256;
  Result.FLenBuff[1] := 256;
  Result.FEventMask := [evRxChar,evTxEmpty];
  Result.FEvents := ev_RxChar + ev_TxEmpty;
  Result.FDCB.DCBlength := SizeOf(TDCB);
  Result.FDCB.ByteSize := 8;
  Result.FDCB.Flags := $1;
  Result.FDCB.BaudRate := 9600;
  Result.FDCB.Parity := CommParity[Result.FParity];
  Result.FDCB.StopBits := CommStopBits[Result.FStopBits];
end;

// процедура потока обработки СОМ-порта
procedure WorkComm(Parms : PCom); stdcall;
var
  Ovr : TOverlapped;
begin
  FillChar(Ovr,Sizeof(TOverlapped),0);
  Ovr.hEvent := CreateEvent(nil,TRUE,FALSE,#0);
  ResetEvent(Parms^.FExist);
  while True do begin
    if Parms^.FTerminated then break;
    Parms^.FMask := 0;
    if not WaitCommEvent(Parms^.FCid,Parms^.FMask,@Ovr)
     then if ERROR_IO_PENDING = GetLastError()
           then if WaitForSingleObject(Ovr.hEvent,INFINITE) = WAIT_OBJECT_0
                 then GetOverlappedResult(Parms^.FCid,Ovr,Parms^.FTrans,False);
    if Parms^.FTerminated then break;
    if Parms^.FWorking
     then begin
       if (Parms^.FMask and EV_RXCHAR) = EV_RXCHAR then begin
         ClearCommError(Parms^.FCid,Parms^.FErrs,@Parms^.FStat);
	 if Parms^.FStat.cbInQue < 512
	  then Parms^.FKols := Parms^.FStat.cbInQue
	  else Parms^.FKols := 512;
	 if Parms^.FTerminated then break;
	 ReadFile(Parms^.FCid,Parms^.FBuff,Parms^.FKols,Parms^.FKols,@Ovr);
	 if Parms^.FTerminated then break;
	 if Parms^.FKols > 0
          then if Assigned(Parms^.FOnRxByte)
                then Parms^.FOnRxByte(Parms^.FBuff,Parms^.FKols);
       end;
       if (Parms^.FMask and EV_TXEMPTY) = EV_TXEMPTY then begin
	 if Parms^.FTerminated then break;
	 SetEvent(Parms^.FTxEvent);
         if Assigned(Parms^.FOnTxEmpty) then Parms^.FOnTxEmpty;
       end;
       if ((Parms^.FMask and EV_DSR) = EV_DSR) or
          ((Parms^.FMask and EV_CTS) = EV_CTS) or
          ((Parms^.FMask and EV_RING) = EV_RING) or
          ((Parms^.FMask and EV_RLSD) = EV_RLSD) then begin
	 if Parms^.FTerminated then break;
         GetCommModemStatus(Parms^.FCid,Parms^.FModems);
         Parms^.FLines[4] := (Parms^.FModems and MS_DSR_ON) = MS_DSR_ON;
         Parms^.FLines[5] := (Parms^.FModems and MS_CTS_ON) = MS_CTS_ON;
         Parms^.FLines[6] := (Parms^.FModems and MS_RING_ON) = MS_RING_ON;
         Parms^.FLines[7] := (Parms^.FModems and MS_RLSD_ON) = MS_RLSD_ON;
         if Assigned(Parms^.FOnModem)
          then Parms^.FOnModem(Parms^.FLines[4],Parms^.FLines[5],
                               Parms^.FLines[6],Parms^.FLines[7]);
       end;
       if ((Parms^.FMask and EV_BREAK) = EV_BREAK) or
          ((Parms^.FMask and EV_ERR) = EV_ERR) then begin
	 if Parms^.FTerminated then break;
         if Assigned(Parms^.FOnErr_Break)
          then Parms^.FOnErr_Break((Parms^.FMask and EV_ERR) = EV_ERR,
                                   (Parms^.FMask and EV_BREAK) = EV_BREAK);
       end;
     end
     else begin
       if Parms^.FTerminated then break;
       PurgeComm(Parms^.FCid,PURGE_TXABORT or PURGE_RXABORT or
		             PURGE_TXCLEAR or PURGE_RXCLEAR);
     end;
  end;
  PurgeComm(Parms.FCid,PURGE_TXCLEAR or PURGE_RXCLEAR);
  CloseHandle(Ovr.hEvent);
  SetEvent(Parms^.FExist);
end;

destructor TCom.Destroy;
begin
  if FOpened then begin
    FTerminated := True;
    SetCommMask(FCid,0);
    WaitForSingleObject(FExist,200);
    CloseHandle(FCid);
  end;
  CloseHandle(FTxEvent);
  CloseHandle(FExist);
  CloseHandle(FOvr.hEvent);
  inherited;
end;

function TCom.WriteStr(S : string; Wait : boolean) : DWord;
var
  Buff : array of byte;
  i : integer;
begin
  SetLength(Buff,length(S));
  for i := 1 to length(S) do
   Buff[i-1] := Ord(S[i]);
  Result := Write(Buff,length(S),Wait);
end;

function TCom.Write(Buff : array of byte; Count : DWord; Wait : boolean) : DWord;
begin
  if not WriteFile(FCid,Buff,Count,Result,@FOvr)
   then if GetLastError() = ERROR_IO_PENDING
         then GetOverlappedResult(FCid,FOvr,Result,Wait);
end;

function TCom.Open(bWork : boolean) : integer;
var
  ThreadId : DWord;
  T_O : TCommTimeouts;
begin
  Result := 0;
  if FOpened
   then FWorking := bWork
   else begin
     FCid := CreateFile(PChar('COM' + Int2Str(FNum)),
			GENERIC_READ or GENERIC_WRITE,0,nil,OPEN_EXISTING,
			FILE_ATTRIBUTE_NORMAL or FILE_FLAG_OVERLAPPED,0);
     if FCid = INVALID_HANDLE_VALUE then begin
       Result := 1;
       Exit;
     end;
     if not (SetCommMask(FCid,FEvents) and
	     SetupComm(FCid,FLenBuff[1],FLenBuff[0]) and
	     PurgeComm(FCid,PURGE_TXABORT or PURGE_RXABORT or
			    PURGE_TXCLEAR or PURGE_RXCLEAR) and
	     SetCommState(FCid,FDCB))
      then begin
        Result := 2;
	CloseHandle(FCid);
	Exit;
      end;
    if FLines[0]
     then if FLines[2]
	   then EscapeCommFunction(FCid,SETDTR)
	   else EscapeCommFunction(FCid,CLRDTR);
    if FLines[1]
     then if FLines[3]
	   then EscapeCommFunction(FCid,SETRTS)
	   else EscapeCommFunction(FCid,CLRRTS);
     GetCommModemStatus(FCid,FModems);
     FLines[4] := (FModems and MS_DSR_ON) = MS_DSR_ON;
     FLines[5] := (FModems and MS_CTS_ON) = MS_CTS_ON;
     FLines[6] := (FModems and MS_RING_ON) = MS_RING_ON;
     FLines[7] := (FModems and MS_RLSD_ON) = MS_RLSD_ON;
     GetCommTimeOuts(FCid,T_O);
     T_O.ReadIntervalTimeout := MAXDWORD;
     T_O.ReadTotalTimeoutMultiplier := 0;
     T_O.ReadTotalTimeoutConstant := 0;
     SetCommTimeOuts(FCid,T_O);
     FCommThread := CreateThread(nil,0,@WorkComm,@Self,0,ThreadID);
     if FCommThread = 0 then begin
       Result := 3;
       CloseHandle(FCid);
       Exit;
     end;
     SetThreadPriority(FCommThread,8);
     FTerminated := False;
     FWorking := bWork;
     FOpened := True;
  end;
end;

function TCom.Close : boolean;
begin
  if FOpened then begin
    FTerminated := True;
    SetCommMask(FCid,0);
    WaitForSingleObject(FExist,200);
    CloseHandle(FCid);
  end;
  FOpened := False;
  Result := True;
end;

procedure TCom.SetBaudRate(Value : DWord);
begin
  if (Value >= 110) and (Value <= 115200) then begin
    FDCB.BaudRate := Value;
    if FOpened then SetCommState(FCid,FDCB);
  end;
end;

procedure TCom.SetParity(Value : TCommParity);
begin
  FParity := Value;
  FDCB.Parity := CommParity[FParity];
  if FOpened then SetCommState(FCid,FDCB);
end;

procedure TCom.SetStopBits(Value : TCommStopBits);
begin
  FStopBits := Value;
  FDCB.StopBits := CommStopBits[FStopBits];
  if FOpened then SetCommState(FCid,FDCB);
end;

function TCom.GetLines(Ind : integer) : boolean;
begin
  Result := FLines[Ind];
end;

procedure TCom.SetLines(Ind : integer; Value : boolean);
const
  Mask1 : array [0..1] of cardinal = ($FFFFFFCF,$FFFFCFFF);
  Mask2 : array [0..1,0..1] of cardinal = (($10,$20),($1000,$2000));
  Cmd : array[2..3,0..1] of Dword = ((SETDTR,CLRDTR),(SETRTS,CLRRTS));
begin
  FLines[Ind] := Value;
  case Ind of
    0..1 :
      begin
        FDCB.Flags := FDCB.Flags and mask1[Ind];
        if Value
         then FDCB.Flags := FDCB.Flags or Mask2[Ind,0]
         else FDCB.Flags := FDCB.Flags or Mask2[Ind,1];
        if FOpened then SetCommState(FCid,FDCB);
      end;
    2..3 :
      if FOpened
       then if Value
	     then EscapeCommFunction(FCid,Cmd[Ind,0])
	     else EscapeCommFunction(FCid,Cmd[Ind,1]);
  end;
end;

procedure TCom.SetEventMask(Value : TCommEvents);
var
  Events : TCommEvent;
begin
  FEventMask := Value + [evRxChar,evTxEmpty];
  FEvents := 0;
  for Events := evRxChar to evRing do
   if Events in FEventMask then FEvents := FEvents + CommEventList[Events];
  if FOpened then  SetCommMask(FCid,FEvents);
end;

procedure TCom.SetNum(Value : byte);
begin
  if Value < 1 then Value := 1;
  if Value > 32 then Value := 32;
  FNum := Value;
  if FOpened then begin
    Close;
    Open(FWorking);
  end;
end;

function TCom.GetLenBuff(Ind : integer) : word;
begin
  Result := FLenBuff[Ind];
end;

procedure TCom.SetLenBuff(Ind : integer; Value : word);
begin
  if Value < 256 then Value := 256;
  FLenBuff[Ind] := Value;
  if FOpened then SetupComm(FCid,FLenBuff[1],FLenBuff[0]);
end;

end.
