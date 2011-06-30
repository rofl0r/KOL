unit KOLFingCli;

interface

{$B-}           { Enable partial boolean evaluation   }
{$T-}           { Untyped pointers                    }
{$X+}           { Enable extended syntax              }
{$IFNDEF VER80} { Not for Delphi 1                    }
    {$H+}       { Use long strings                    }
    {$J+}       { Allow typed constant to be modified }
{$ENDIF}
{$IFDEF VER110} { C++ Builder V3.0                    }
    {$ObjExportAll On}
{$ENDIF}
{$IFDEF VER125} { C++ Builder V4.0                    }
    {$ObjExportAll On}
{$ENDIF}

uses KOL, Windows,{WinTypes,} {WinProcs,} SysUtils, Messages { , Classes } , Graphics, Controls,
    KOLWSocket;

const
    FingCliVersion            = 102;
    CopyRight    : String     = ' FingCli (c) 1997-2001 F. Piette V1.02 ';

type
    TFingerCli = object(TObj)
    private
      procedure _Init; virtual;
    public
         { constructor Create(AOwner: TComponent); override;
         } destructor  Destroy; 
         virtual; procedure   StartQuery;
        function    Receive(Buffer : Pointer; Len : Integer) : Integer;
        procedure   Abort;
    protected
        FWSocket            : PWSocket;//TWSocket;
        FQuery              : String;
        FQueryDoneFlag      : Boolean;
        FOnSessionConnected : TSessionConnected;
        FOnDataAvailable    : TDataAvailable;
        FOnQueryDone        : TSessionClosed;
        procedure WSocketDnsLookupDone(Sender: PObj; Error: Word);
        procedure WSocketSessionConnected(Sender: PObj; Error: Word);
        procedure WSocketDataAvailable(Sender: PObj; Error: Word);
        procedure WSocketSessionClosed(Sender: PObj; Error: Word);
        procedure TriggerQueryDone(Error: Word);
        public
     { published } 
        property Query : String                         read  FQuery
                                                        write FQuery;
        property OnSessionConnected : TSessionConnected read  FOnSessionConnected
                                                        write FOnSessionConnected;
        property OnDataAvailable : TDataAvailable       read  FOnDataAvailable
                                                        write FOnDataAvailable;
        property OnQueryDone : TSessionClosed           read  FOnQueryDone
                                                        write FOnQueryDone;
    end;
PFingerCli=^TFingerCli;
function NewFingerCli(AOwner: PObj):PFingerCli;
//type  MyStupid0=DWord;

//procedure Register;

implementation


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{procedure Register;
begin
    RegisterComponents('FPiette', [TFingerCli]);
end;
 }

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
//constructor TFingerCli.Create(AOwner: TComponent);
function NewFingerCli(AOwner: PObj):PFingerCli;
begin
  New( Result, Create );
with Result^ do
begin
  _Init;
//    inherited Create(AOwner);
//    FWSocket                    := NewWSocket(Result);//TWSocket.Create(Self);
//    FWSocket.OnSessionConnected := WSocketSessionConnected;
//    FWSocket.OnDataAvailable    := WSocketDataAvailable;
//    FWSocket.OnSessionClosed    := WSocketSessionClosed;
//    FWSocket.OnDnsLookupDone    := WSocketDnsLookupDone;
end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TFingerCli.Destroy;
begin
    if Assigned(FWSocket) then
        FWSocket.Destroy;
    inherited Destroy;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TFingerCli.StartQuery;
var
    I    : Integer;
    Host : String;
begin
    I := Pos('@', FQuery);
    if I <= 0 then
         raise Exception.CreateFmt('TFingerCli, Invalid Query: %s', [FQuery]);
    Host := Copy(FQuery, I + 1, Length(FQuery));
    if Length(Host) <= 0 then
         raise Exception.CreateFmt('TFingerCli, Invalid Host in query: %s', [FQuery]);
    FQueryDoneFlag := FALSE;
    FWSocket.DnsLookup(Host);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TFingerCli.Abort;
begin
    FWSocket.CancelDnsLookup;
    FWSocket.Abort;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TFingerCli.Receive(Buffer : Pointer; Len : Integer) : Integer;
begin
    Result := FWSocket.Receive(Buffer, Len);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TFingerCli.WSocketDnsLookupDone(Sender: PObj; Error: Word);
begin
    if Error <> 0 then
        TriggerQueryDone(Error)
    else begin
        FWSocket.Addr  := FWSocket.DnsResult;
        FWSocket.Proto := 'tcp';
        FWSocket.Port  := 'finger';
        FWSocket.Connect;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TFingerCli.WSocketSessionConnected(Sender: PObj; Error: Word);
var
	I: integer ;
begin
    if Assigned(FOnSessionConnected) then
        FOnSessionConnected(@Self, Error);

    if Error <> 0 then begin
        TriggerQueryDone(Error);
        FWSocket.Close
    end
    else
    begin
        I := Pos('@', FQuery);     { angus } 
        FWSocket.SendStr(copy (FQuery, 1, pred (I)) + #13 + #10);
	end ;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TFingerCli.WSocketDataAvailable(Sender: PObj; Error: Word);
begin
    if Assigned(FOnDataAvailable) then
        FOnDataAvailable(@Self, Error);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TFingerCli.TriggerQueryDone(Error: Word);
begin
    if (FQueryDoneFlag = FALSE) and Assigned(FOnQueryDone) then
        FOnQueryDone(@Self, Error);
    FQueryDoneFlag := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TFingerCli.WSocketSessionClosed(Sender: {TObject}PObj; Error: Word);
begin
    TriggerQueryDone(Error);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

procedure TFingerCli._Init;
begin
  inherited;
  //    inherited Create(AOwner);
    FWSocket                    := NewWSocket(@Self);//TWSocket.Create(Self);
    FWSocket.OnSessionConnected := WSocketSessionConnected;
    FWSocket.OnDataAvailable    := WSocketDataAvailable;
    FWSocket.OnSessionClosed    := WSocketSessionClosed;
    FWSocket.OnDnsLookupDone    := WSocketDnsLookupDone;

end;

end.

