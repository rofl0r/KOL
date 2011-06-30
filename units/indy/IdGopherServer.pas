// 27-nov-2002
unit IdGopherServer;

interface

uses KOL { , 
  Classes } ,
  IdGlobal,
  IdTCPServer;

const
  Id_TIdGopherServer_TruncateUserFriendly = True;
  Id_TIdGopherServer_TruncateLength = 70;

type
  TRequestEvent = procedure(AThread: TIdPeerThread; ARequest: string) of object;
  TPlusRequestEvent = procedure(AThread: TIdPeerThread; ARequest: string;
    APlusData: string) of object;

  TIdGopherServer = object(TIdTCPServer)
  private
    fAdminEmail: string;

    fOnRequest: TRequestEvent;
    fOnPlusRequest: TPlusRequestEvent;

    fTruncateUserFriendly: Boolean;
    fTruncateLength: Integer;
  protected
    function DoExecute(Thread: TIdPeerThread): boolean; virtual;//override;
  public
     { constructor Create(AOwner: TComponent); override;

     } function ReturnGopherItem(ItemType: Char;
      UserFriendlyName, RealResourceName: string;
      HostServer: string; HostPort: Integer): string;
    procedure SendDirectoryEntry(Thread: TIdPeerThread;
      ItemType: Char; UserFriendlyName, RealResourceName: string;
      HostServer: string; HostPort: Integer);
    procedure SetTruncateUserFriendlyName(truncate: Boolean);
    procedure SetTruncateLength(length: Integer);
   { published } 
    property AdminEmail: string read fAdminEmail write fAdminEmail;
    property OnRequest: TRequestEvent read fOnRequest write fOnRequest;
    property OnPlusRequest: TPlusRequestEvent read fOnPlusRequest
    write fOnPlusRequest;
    property TruncateUserFriendlyName: Boolean read fTruncateUserFriendly
    write SetTruncateUserFriendlyName default
      Id_TIdGopherServer_TruncateUserFriendly;
    property TruncateLength: Integer read fTruncateLength
    write SetTruncateLength default Id_TIdGopherServer_TruncateLength;
    property DefaultPort default IdPORT_GOPHER;
  end;
PIdGopherServer=^TIdGopherServer;
function NewIdGopherServer(AOwner: PControl):PIdGopherServer;


implementation

uses
  IdGopherConsts, IdResourceStrings,
  SysUtils;

//constructor TIdGopherServer.Create(AOwner: TComponent);
function NewIdGopherServer(AOwner: PControl):PIdGopherServer;
begin
//  inherited Create(AOwner);
New( Result, Create );
with Result^ do
begin
//  DefaultPort := IdPORT_GOPHER;
  fAdminEmail := '<gopher@domain.example>';
  FTruncateUserFriendly := Id_TIdGopherServer_TruncateUserFriendly;
  FTruncateLength := Id_TIdGopherServer_TruncateLength;
end;
end;

function TIdGopherServer.DoExecute(Thread: TIdPeerThread): boolean;
var
  s: string;
  i: Integer;
begin
  result := true;
  with Thread.Connection do
  begin
    while Connected do
    begin
      try
        s := ReadLn;
        i := Pos(TAB, s);
        if i > 0 then
        begin
          if Assigned(OnPlusRequest) then
          begin
            OnPlusRequest(Thread, Copy(s, 1, i - 1), Copy(s, i + 1, length(s)));
          end
          else
            if Assigned(OnRequest) then
          begin
            OnRequest(Thread, s);
          end
          else
          begin
            Thread.Connection.Write(IdGopherPlusData_ErrorBeginSign
              + IdGopherPlusError_NotAvailable
              + RSGopherServerNoProgramCode + EOL
              + IdGopherPlusData_EndSign);
          end;
        end
        else
          if Assigned(OnRequest) then
        begin
          OnRequest(Thread, s)
        end
        else
        begin
          Thread.Connection.Write(RSGopherServerNoProgramCode
            + EOL + IdGopherPlusData_EndSign);
        end;
      except
        break;
      end;
      Thread.Connection.Disconnect;
    end;
  end;
end;

function TIdGopherServer.ReturnGopherItem(ItemType: Char;
  UserFriendlyName, RealResourceName: string;
  HostServer: string; HostPort: Integer): string;
begin
  if fTruncateUserFriendly then
  begin
    if (Length(UserFriendlyName) > fTruncateLength)
      and (fTruncateLength <> 0) then
    begin
      UserFriendlyName := Copy(UserFriendlyName, 1, fTruncateLength);
    end;
  end;
  result := ItemType + UserFriendlyName +
    TAB + RealResourceName + TAB + HostServer + TAB + IntToStr(HostPort);
end;

procedure TIdGopherServer.SendDirectoryEntry;
begin
  Thread.Connection.WriteLn(ReturnGopherItem(ItemType, UserFriendlyName,
    RealResourceName, HostServer, HostPort));
end;

procedure TIdGopherServer.SetTruncateUserFriendlyName;
begin
  fTruncateUserFriendly := Truncate;
end;

procedure TIdGopherServer.SetTruncateLength;
begin
  fTruncateLength := Length;
end;

end.
