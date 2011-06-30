////////////////////////////////////////////////////////////////////
//
//               TTTTTTTTTT   CCCCCCCC   PPPPPPPPP
//               T  TTTT  T  CCCC  CCCC  PPPP  PPPP
//                  TTTT     CCCC        PPPP  PPPP
//                  TTTT     CCCC        PPPP  PPPP
//                  TTTT     CCCC        PPPPPPPPP
//                  TTTT     CCCC  CCCC  PPPP
//                  TTTT      CCCCCCCC   PPPP
//
//                S     O     C     K     E     T
//
//   TCPServer, TCPClient implementation for Key Objects Library
//
//   (c) 2002 by Vorobets Roman
//                     Roman.Vorobets@p25.f8.n454.z2.fidonet.org
//
//                                 June 12, 2002 -- July 9, 2002
////////////////////////////////////////////////////////////////////
Changes by Brdo (June, 2003; published August, 2003):

A correction to the kolTCPSocket.pas:
Added function to TTCPBase:
function GetPort: SmallInt;
(add function declarations..)
property Port:SmallInt read FPort write SetPort;
changed to:
property Port:SmallInt read GetPort write SetPort;
The function is:
function TTCPBase.GetPort: SmallInt;
var buf: sockaddr_in; bufSz: Integer;
begin
  if FConnected then
  begin
    bufSz := SizeOf(buf);
    ZeroMemory( @buf, bufSz );
    getsockname(fhandle, buf, bufSz);
    FPort := htons(buf.sin_port);
  end;
  Result := FPort;
end;
In procedure TTCPServer.Listen;, this is changed:
if errortest(winsock.listen(fhandle,64)) then doclose
to:
      if errortest(winsock.listen(fhandle,64)) then
        doclose
      else
      begin
        FConnected := True;
        if assigned(onconnect) then onconnect(@self);
      end;
And to the TTCPBase this OnEvent is added:
FOnConnect: TOnTCPConnect;
procedure SetOnConnect(const Value: TOnTCPConnect);
property OnConnect:TOnTCPConnect read FOnConnect write SetOnConnect;
And to the TTCPServer these OnEvents:
    FOnClientConnect: TOnTCPClientConnect;
    procedure SetOnClientConnect(const Value: TOnTCPClientConnect);
    property OnClientConnect:TOnTCPClientConnect read FOnClientConnect write SetOnClientConnect;
In procedure TTCPServer.Method(var message: tmessage);, add under fconnections.add(sclient);:
if assigned(onclientconnect) then onclientconnect(sclient);
Then just write the SetOnConnect and SetOnClientConnect functions, and add the OnEvents to mckKOLTCPSocket.. U know that stuff better than me anywayz :)
I think that is all, but maybe i forgot something..