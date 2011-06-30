// 19-nov-2002
unit IdSSLIntercept;

interface

uses KOL ,
  IdIntercept;

type
  PIdSSLConnectionIntercept=^TIdSSLConnectionIntercept;
  TIdSSLConnectionIntercept = object(TIdConnectionIntercept)
  public
    procedure Init;virtual;
  end;

  function NewIdSSLConnectionIntercept(AOwner: PControl):PIdSSLConnectionIntercept;

type
  PIdSSLServerIntercept=^TIdSSLServerIntercept;
  TIdSSLServerIntercept = object(TIdServerIntercept)
  end;

  function NewIdSSLServerIntercept:PIdSSLServerIntercept;

implementation

function NewIdSSLConnectionIntercept(AOwner: PControl):PIdSSLConnectionIntercept;
begin
  New( Result, Create );
  Result.Init;
  // !!!
//  inherited;
//  FRecvHandling := True;
//  FSendHandling := True;
end;

procedure TIdSSLConnectionIntercept.Init;
begin
  inherited;
  FRecvHandling := True;
  FSendHandling := True;
end;

function NewIdSSLServerIntercept:PIdSSLServerIntercept;
begin
  New( Result, Create );
end;

end.
