// 19-nov-2002
unit IdDayTime;

interface

uses KOL { , 
  Classes } ,
  IdGlobal,
  IdTCPClient;

type
  PIdDayTime=^TIdDayTime;
  TIdDayTime = object(TIdTCPClient)
  protected
    function GetDayTimeStr: string;
  public
     { constructor Create(AOwner: TComponent); override;
     } property DayTimeStr: string read GetDayTimeStr;
   { published }
    property Port default IdPORT_DAYTIME;
  end;

function NewIdDayTime(AOwner: PControl):PIdDayTime;

implementation

uses
  SysUtils;

function NewIdDayTime(AOwner: PControl):PIdDayTime;
begin
  New( Result, Create );
//  inherited;
  Port := IdPORT_DAYTIME;
end;

function TIdDayTime.GetDayTimeStr: string;
begin
  Result := Trim(ConnectAndGetAll);
end;

end.
