unit ServerThread;
interface 

uses 
  kol,err,windows,KOLScktComp;
type

  TTransportState = (tsDataSizeReceiving, tsDataBlockReceiving);

  EServerThread = class( Exception );
  // serverthread это потомок TServerClientThread
  PServerThread = ^TServerThread;
  TServerThread = object( TServerClientThread )
   private
     fSocketStream : PWinSocketStream;
     notConnected:boolean;
     TransportState: TTransportState ;
     TotalDataSizeBytesRead: DWord ;
     TotalDataBlockBytesRead: DWord;
     TotalBlockSize: DWord ;
     DataBlock: Pointer;

     function DoReadDataSize(Socket: TCustomWinSocket): Boolean;
     function DoReadDataBlock(Socket: TCustomWinSocket): Boolean;
     procedure DoProcessDataBlock(sckt : TCustomWinSocket;Data_Block : Pointer; TotalBlockSize_: Dword);

   public
     procedure ClientExecute;virtual;
end;
function NewServerThread(CreateSuspended: Boolean;
           ASocket: PServerClientWinSocket):PServerThread;

implementation


function NewServerThread(CreateSuspended: Boolean;
           ASocket: PServerClientWinSocket):PServerThread;
begin
  new(result,create(CreateSuspended,ASocket))
end;

function TServerThread.DoReadDataSize(Socket: TCustomWinSocket): Boolean;
var
 BytesRemains: DWord;
 ActualBytesRead : Integer;
 buf: Pointer;
begin
 BytesRemains := SizeOf(DWord) - TotalDataSizeBytesRead;
 if BytesRemains > 0 then
   begin
     buf := Pointer(DWord(@TotalBlockSize) + TotalDataSizeBytesRead);
     ActualBytesRead := Socket.ReceiveBuf(buf^, BytesRemains);
     if ActualBytesRead <> - 1 then
       Inc(TotalDataSizeBytesRead, ActualBytesRead);
   end;
 Result := TotalDataSizeBytesRead = SizeOf(DWord);
// Result := true;;
end;

function TServerThread.DoReadDataBlock(Socket: TCustomWinSocket): Boolean;
var
 BytesRemains: DWord;
 ActualBytesRead : Integer;
 buf: Pointer;
begin
 if not Assigned(DataBlock) then
   GetMem(DataBlock, TotalBlockSize);
 try
   BytesRemains := TotalBlockSize - TotalDataBlockBytesRead;
   if BytesRemains > 0 then
     begin
       buf := Pointer(DWord(DataBlock) + TotalDataBlockBytesRead);
       ActualBytesRead := Socket.ReceiveBuf(buf^, Min(BytesRemains, 4096));
       if ActualBytesRead <> - 1 then
         Inc(TotalDataBlockBytesRead, ActualBytesRead);
     end;
   Result := TotalDataBlockBytesRead = TotalBlockSize;
 except
   FreeMem(DataBlock);
   DataBlock := nil;
   raise;
 end;
end;

procedure TServerThread.DoProcessDataBlock(sckt : TCustomWinSocket;Data_Block : Pointer; TotalBlockSize_: Dword);
var
  s : string;
  body : PChar;
begin
 try
//    ... обработка блока ...
   GetMem(body,TotalBlockSize_);
   ZeroMemory(body,TotalBlockSize_);
   copyMemory(body,Data_Block,TotalBlockSize_);
   s:=body;
   sckt.SendText(copy(s,1,TotalBlockSize_));

   MessageBox(Applet.handle,PChar(copy(s,1,TotalBlockSize_)),'Server Thread',MB_OK+MB_ICONINFORMATION);
 finally
   FreeMem(DataBlock);
   DataBlock := nil;
   FreeMem(body);
   body:= nil;
 end;
end;
procedure TServerThread.ClientExecute;
var
  s : AnsiString;
  buf: Pointer;
begin
  notConnected:=false;
  try
    fSocketStream := NewWinSocketStream( ClientSocket,100000 );
     // 100000 - это таймаут в миллисекундах.
     try
        while ( not Terminated ) and ( ClientSocket.Connected ) do
        try
        // В это место обычно помещается код,
        // ожидающий входных данных, читающий из сокета или пишущий в него
        // Пример, приведённый ниже, показывает, что можно добавить в данную
        // секцию программы.
        if not fSocketStream.WaitForData(1000000) then begin
           // Обработчик таймаута (т.е. если по истечении 1000000 миллисекунд
           // от клиента не пришло запроса
             ShowMessage('таймаут');
           IF notConnected THEN BEGIN
              ShowMessage(format('Клиент %s не ответил на запрос. Отключен.',[ClientSocket.RemoteHost]));
              Terminate;
           end else begin
              notConnected:=TRUE;
           end;
        end else begin
           case TransportState of
              tsDataSizeReceiving:
                 if DoReadDataSize(ClientSocket^) then begin
                    TotalDataBlockBytesRead := 0;
                    TransportState := tsDataBlockReceiving;
                 end;
              tsDataBlockReceiving:
                 if DoReadDataBlock(ClientSocket^) then
                 try
                    DoProcessDataBlock(ClientSocket^,DataBlock, TotalBlockSize);
                    TotalDataSizeBytesRead := 0;
                    TransportState := tsDataSizeReceiving;
                 finally
                    DataBlock := nil;
                 end;

           end;
        end;
        except on e:exception do  begin
              ClientSocket.Close;
              Terminate;
           end;
        end;
     finally
        fSocketStream.Free;
     end;
  except on e:exception do  begin
        ClientSocket.Close;
        Terminate;
     end;
  end;
end;
 

end.
