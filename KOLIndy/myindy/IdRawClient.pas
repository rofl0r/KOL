// 19-nov-2002
unit IdRawClient;

interface

uses IdRawBase;

type
  PIdRawClient=^TIdRawClient;
  TIdRawClient = object(TIdRawBase)
//  public
 //   procedure Init; virtual;
//    public
   { published }
//    property ReceiveTimeout;
//    property Host;
//    property Port;
//    property Protocol;
  end;

function NewIdRawClient:PIdRawClient;  

implementation

function NewIdRawClient:PIdRawClient;
begin
  New( Result, Create );
end;

end.
