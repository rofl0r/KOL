// 19-nov-2002
unit IdStatus;

interface

uses
  IdResourceStrings;

type
  TIdStatus = ( hsResolving,
                hsConnecting,
                hsConnected,
                hsDisconnecting,
                hsDisconnected);
const
  IdStati: array[TIdStatus] of string = (
                RSStatusResolving,
                RSStatusConnecting,
                RSStatusConnected,
                RSStatusDisconnecting,
                RSStatusDisconnected);

implementation

end.