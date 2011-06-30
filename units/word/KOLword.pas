unit KOLword;

interface

{$I KOLDEF.inc}

uses
  windows, messages, {$IFDEF _D2} Ole2 {$ELSE} ActiveX {$ENDIF}, KOL;

const
  IID_NULL    : TGUID = ( //'{00000000-0000-0000-0000-000000000000}';
    D1:$00000000;D2:$0000;D3:$0000;D4:($00,$00,$00,$00,$00,$00,$00,$00));

  IID_IUnknown: TGUID = (
    D1:$00000000;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IDispatch: TGUID = (
    D1:$00020400;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));

  { from ActiveX: }
  VT_EMPTY           = 0;   { [V]   [P]  nothing                     }
  VT_NULL            = 1;   { [V]        SQL style Null              }
  VT_I2              = 2;   { [V][T][P]  2 byte signed int           }
  VT_I4              = 3;   { [V][T][P]  4 byte signed int           }
  VT_R4              = 4;   { [V][T][P]  4 byte real                 }
  VT_R8              = 5;   { [V][T][P]  8 byte real                 }
  VT_CY              = 6;   { [V][T][P]  currency                    }
  VT_DATE            = 7;   { [V][T][P]  date                        }
  VT_BSTR            = 8;   { [V][T][P]  binary string               }
  VT_DISPATCH        = 9;   { [V][T]     IDispatch FAR*              }
  VT_ERROR           = 10;  { [V][T]     SCODE                       }
  VT_BOOL            = 11;  { [V][T][P]  True=-1, False=0            }
  VT_VARIANT         = 12;  { [V][T][P]  VARIANT FAR*                }
  VT_UNKNOWN         = 13;  { [V][T]     IUnknown FAR*               }
  VT_DECIMAL         = 14;  { [V][T]   [S]  16 byte fixed point      }

  VT_I1              = 16;  {    [T]     signed char                 }
  VT_UI1             = 17;  {    [T]     unsigned char               }
  VT_UI2             = 18;  {    [T]     unsigned short              }
  VT_UI4             = 19;  {    [T]     unsigned short              }
  VT_I8              = 20;  {    [T][P]  signed 64-bit int           }
  VT_UI8             = 21;  {    [T]     unsigned 64-bit int         }
  VT_INT             = 22;  {    [T]     signed machine int          }
  VT_UINT            = 23;  {    [T]     unsigned machine int        }
  VT_VOID            = 24;  {    [T]     C style void                }
  VT_HRESULT         = 25;  {    [T]                                 }
  VT_PTR             = 26;  {    [T]     pointer type                }
  VT_SAFEARRAY       = 27;  {    [T]     (use VT_ARRAY in VARIANT)   }
  VT_CARRAY          = 28;  {    [T]     C style array               }
  VT_USERDEFINED     = 29;  {    [T]     user defined type          }
  VT_LPSTR           = 30;  {    [T][P]  null terminated string      }
  VT_LPWSTR          = 31;  {    [T][P]  wide null terminated string }

  VT_FILETIME        = 64;  {       [P]  FILETIME                    }
  VT_BLOB            = 65;  {       [P]  Length prefixed bytes       }
  VT_STREAM          = 66;  {       [P]  Name of the stream follows  }
  VT_STORAGE         = 67;  {       [P]  Name of the storage follows }
  VT_STREAMED_OBJECT = 68;  {       [P]  Stream contains an object   }
  VT_STORED_OBJECT   = 69;  {       [P]  Storage contains an object  }
  VT_BLOB_OBJECT     = 70;  {       [P]  Blob contains an object     }
  VT_CF              = 71;  {       [P]  Clipboard format            }
  VT_CLSID           = 72;  {       [P]  A Class ID                  }

  VT_VECTOR        = $1000; {       [P]  simple counted array        }
  VT_ARRAY         = $2000; { [V]        SAFEARRAY*                  }
  VT_BYREF         = $4000; { [V]                                    }
  VT_RESERVED      = $8000;
  VT_ILLEGAL       = $ffff;
  VT_ILLEGALMASKED = $0fff;
  VT_TYPEMASK      = $0fff;

type
  PDecimal = ^TDecimal;
  tagDEC = packed record
    wReserved: Word;
    case Integer of
      0: (scale, sign: Byte; Hi32: Longint;
      case Integer of
        0: (Lo32, Mid32: Longint);
        1: (Lo64: LONGLONG));
      1: (signscale: Word);
  end;
  TDecimal = tagDEC;
  DECIMAL = TDecimal;

  TVariant = packed Record
    vt: WORD;
    reserved1,
    reserved2,
    reserved3: WORD;
    case Integer of
    0: ( bVal       : Byte );
    1: ( iVal       : ShortInt );
    2: ( lVal       : Integer );
    3: ( fltVal     : Extended );
    4: ( dblVal     : Double );
    5: ( boolVal    : Bool );
    //6: ( scode      : SCODE );
    //7: ( cyVal      : CY );
    //8: ( date       : Date );
    9: ( bstrVal    : Pointer ); // BSTR => [ Len: Integer; array[ 1..Len ] of WideChar ]
    10:( pdecVal    : ^Decimal );
    end;
  PVariant = ^TVariant;

  {$IFDEF _D2}
{ IDispatch interface }

  IDispatch = class(IUnknown)
  public
    function GetTypeInfoCount(var ctinfo: Integer): HResult; virtual; stdcall; abstract;
    function GetTypeInfo(itinfo: Integer; lcid: TLCID; var tinfo: ITypeInfo): HResult; virtual; stdcall; abstract;
    function GetIDsOfNames(const iid: TIID; rgszNames: POleStrList;
      cNames: Integer; lcid: TLCID; rgdispid: PDispIDList): HResult; virtual; stdcall; abstract;
    function Invoke(dispIDMember: TDispID; const iid: TIID; lcid: TLCID;
      flags: Word; var dispParams: TDispParams; varResult: PVariant;
      excepInfo: PExcepInfo; argErr: PInteger): HResult; virtual; stdcall; abstract;
  end;
  {$ENDIF}

  TDispParams = {$IFDEF _D2} Ole2 {$ELSE} ActiveX {$ENDIF}.TDispParams;

  PWordDocument = ^TWordDocument;
  TWordDocument = object( TObj )
  private
    fWordInstance: IUnknown;
    fWordDispatch: IDispatch;
    fObject: IDispatch;
    FObjName: PWideChar;
    fNoAutoQuit: Boolean;
    FShowErrors: Boolean;
    FError: String;
    FOnError: TOnEvent;
    FHaltOnError: Boolean;
    function GetFunctionID( Dispatch: IDispatch; const FunName: String): Integer;
    procedure SetObjName(Value: String);
    function GetObjName: String;
    function GetObject: IDispatch;
    function GetObjPropInt(const PropName: String): Integer;
    procedure SetObjPropInt(const PropName: String; const Value: Integer);
    function GetObjPropStr(const PropName: String): String;
    procedure SetObjPropStr(const PropName, Value: String);
    function GetObjPropBool(const PropName: String): Boolean;
    procedure SetObjPropBool(const PropName: String; const Value: Boolean);
    procedure SetShowErrors(const Value: Boolean);
  protected
    FShowErrorProc: procedure( Sender: PObj );
    FChkErrorProc: procedure( Sender: PWordDocument; hr: Integer );
    function ChkError( hr: Integer; const ErrorFun: String ): Boolean;
  public
    destructor Destroy; virtual;

    // These properties and methods are mainly for internal use. But You can
    // access those to extend functionality of the object without deriving a
    // new object type (which is always more coast way - for the size of the
    // executable).
    property Dispatcher: IDispatch read fWordDispatch;
    {* Interface to Word application dispatch interface. It is possible
       to call its Invoke method directly, if necessary. }
    property FunctionID[ Dispatch: IDispatch; const FunName: String ]: Integer read GetFunctionID;
    {* This property returns ID for given Word function. Use this function
       ID to pass it to Invoke method (or directly to Invoke method of the
       Dispatcher interface). }

    // The most common methods to work with Word automation:
    function Invoke( const AObjName, FunName: String; Flags: DWORD; var Params: TDispParams;
             Rslt: PVariant ): Boolean;
    {* Low-level method to invoke specified function of given (by its fully
       qualified name) object. To invoke methods and access properties of the
       root object, pass an empty string as ObjName parameter. See also
       properties ObjName, Obj and method ObjInvoke. }
    property ObjName: String read GetObjName write SetObjName;
    {* This method sets the current object by its fully qualified name
       (e.g. 'ActiveDocumnet.Selection'). This object is used then to
       invoke its methods, work with its properties and so on using
       methods below. }
    property Obj: IDispatch read GetObject;
    {* Object, currently selected to invoke its methods and to work
       with its properties. To select another object, assign fully
       qualified name to ObjName property. To select the root object
       (i.e. Word.Application), assign an empty string to ObjName
       property (in such case, the root object is invoked). }
    function ObjExecute( const FunName: String; var Params: TDispParams;
             Rslt: PVariant ): Boolean;
    {* Call this method to invoke method of the current object (or
       root object, if there are no objects selected). }
    function ObjExecuteEx( const FunName: String; Flags: DWORD;
             var Params: TDispParams; Rslt: PVariant ): Boolean;
    {* Call this method to invoke method of the current object or to
       access its properties. To work with a root object, set ObjName
       property to an empty string. }
    function ObjInvoke( const FunName: String; const ParamsArray: array of TVariant;
             Rslt: PVariant ): Boolean;
    {* Call this method to invoke method of the current object passing
       parameters as a dynamic array. You should not release memory, occupied
       by string parameters - those are freed automatically. To make variant
       parameters, use global functions iParam, sParam, etc. }
    function ObjInvokeNoParams( const FunName: String; Rslt: PVariant ): Boolean;
    {* Use this method to invoke method, which does not require parameters.
       Always use this method in case when parameters are not needed, if You
       want to create code compatible with earlier versions of Delphi (Delphi2
       and Delphi3 do not support empty dynamic array [ ] ). }
    property ObjPropInt[ const PropName: String ]: Integer read GetObjPropInt write SetObjPropInt;
    {* Access to a property as integer. }
    property ObjPropStr[ const PropName: String ]: String read GetObjPropStr write SetObjPropStr;
    {* Access to a property as string. }
    property ObjPropBool[ const PropName: String ]: Boolean read GetObjPropBool write SetObjPropBool;
    {* Access to a property as boolean. }

    property NoAutoQuit: Boolean read fNoAutoQuit write fNoAutoQuit;
    {* Set this property to True to prevent 'Quit' command from executing
       when the object is destroyed. }
    property Error: String read FError;
    {* Last known error. }
    property OnError: TOnEvent read FOnError write FOnError;
    {* This event is called every time when an error occure. }
    property ShowErrors: Boolean read FShowErrors write SetShowErrors;
    {* If set to True, all errors will be displayed using ShowMessage dialog. }
    property HaltOnError: Boolean read FHaltOnError write FHaltOnError;
    {* If set to True, an application will be stopped on any error. }
  end;

function NewWordDocument: PWordDocument;
{* Creates new Word automation object. }

var NoParams: TDispParams = ( rgvarg: nil; rgdispidNamedArgs: nil;
              cArgs: 0; cNamedArgs: 0 );
{* Never change this variable. Use it in place the Params parameter for
   Invoke methods in case, when parameters are not needed. }

function sParam( const Value: String ): TVariant;
function iParam( const Value: Integer ): TVariant;
function bParam( const Value: Boolean ): TVariant;

implementation

function sParam( const Value: String ): TVariant;
begin
  FillChar( Result, Sizeof( TVariant ), 0 );
  Result.vt := VT_BSTR;
  Result.bstrVal := StringToOleStr( Value );
end;

function iParam( const Value: Integer ): TVariant;
begin
  FillChar( Result, Sizeof( TVariant ), 0 );
  Result.vt := VT_I4;
  Result.lVal := Value;
end;

function bParam( const Value: Boolean ): TVariant;
begin
  FillChar( Result, Sizeof( TVariant ), 0 );
  Result.vt := VT_BOOL;
  Result.boolVal := Value;
end;

function NewWordDocument: PWordDocument;
var clsid: TGUID;
    hr: HResult;
begin
  KOL.OleInit;
  new( Result, Create );
  ClsIdFromProgID( 'Word.Application', clsid );
  hr := CoCreateInstance( clsid, nil, CLSCTX_SERVER,
                   IID_IUnknown, Result.fWordInstance );
  if hr = 0 then
    Result.fWordInstance.QueryInterface( IID_IDispatch, Result.fWordDispatch );
end;

{ TWordDocument }


destructor TWordDocument.Destroy;
begin
  ObjName := '';
  if not NoAutoQuit then
    ObjExecute( 'Quit', NoParams, nil );
  fWordDispatch := nil; //._Release;
  fWordInstance := nil; //._Release;
  //FObjName := '';
  FError := '';
  inherited;
  KOL.OleUnInit;
end;

function TWordDocument.GetFunctionID( Dispatch: IDispatch; const FunName: String): Integer;
var W: PWideChar;
begin
  Result := 0;
  if Dispatch = nil then Exit;
  W := StringToOleStr( FunName );
  Dispatch.GetIDsOfNames( IID_NULL, @W, 1, LOCALE_USER_DEFAULT, @Result );
  SysFreeString( W );
  if Result <= 0 then
    ChkError( -1, FunName );
end;

function TWordDocument.Invoke(const AObjName, FunName: String; Flags: DWORD;
  var Params: TDispParams; Rslt: PVariant): Boolean;
var OldObj: IDispatch;
begin
  OldObj := fObject;
  ObjName := AObjName;
  Result := ObjExecuteEx( FunName, Flags, Params, Rslt );
  fObject := OldObj;
end;

procedure TWordDocument.SetObjName(Value: String);
var FunID: Integer;
    vResult: TVariant;
    I: Integer;
    InvDisp: IDispatch;
begin
  InvDisp := fWordDispatch;
  for I := Length( Value ) downto 1 do
    if Value[ I ] = '.' then
    begin
      SetObjName( Copy( Value, 1, I - 1 ) );
      Value := CopyEnd( Value, I + 1 );
      InvDisp := fObject;
      break;
    end;
  FillChar( vResult, Sizeof( vResult ), 0 );
  if FObjName <> nil then
    SysFreeString( FObjName );
  FObjName := nil;
  fObject := nil;
  if Value <> '' then
  begin
    FObjName := StringToOleStr( Value );
    FunID := FunctionID[ InvDisp,
          {$IFDEF _D2} LStrFromPWChar( FObjName ) {$ELSE} FObjName {$ENDIF}
             ];
    if FunID > 0 then
      if ChkError( InvDisp.Invoke( FunID, IID_NULL, LOCALE_USER_DEFAULT,
                          DISPATCH_PROPERTYGET, NoParams, @vResult, nil, nil ),
                   Value ) then
        fObject := IDispatch( vResult.bStrVal );
    if fObject = nil then
      SetObjName( '' );
  end;
end;

function TWordDocument.GetObjName: String;
begin
  Result := {$IFDEF _D2} LStrFromPWChar( FObjName ) {$ELSE} FObjName {$ENDIF};
end;

function TWordDocument.ObjExecute(const FunName: String;
  var Params: TDispParams; Rslt: PVariant): Boolean;
begin
  Result := ObjExecuteEx( FunName, DISPATCH_METHOD, Params, Rslt );
end;

function TWordDocument.ObjExecuteEx(const FunName: String; Flags: DWORD;
  var Params: TDispParams; Rslt: PVariant): Boolean;
var InvObj: IDispatch;
    FunID: Integer;
begin
  Result := FALSE;
  InvObj := fObject;
  if InvObj = nil then
    InvObj := fWordDispatch;
  FunID := FunctionID[ InvObj, FunName ];
  if FunID > 0 then
  begin
    Result := ChkError( InvObj.Invoke( FunID, IID_NULL, LOCALE_USER_DEFAULT,
             Flags, Params, Rslt, nil, nil ),
                        FunName );
  end;
end;

function TWordDocument.GetObject: IDispatch;
begin
  Result := fObject;
  if Result = nil then
    Result := fWordDispatch;
end;

function TWordDocument.GetObjPropInt(const PropName: String): Integer;
var vResult: TVariant;
begin
  Result := 0;
  FillChar( vResult, Sizeof( vResult ), 0 );
  if ObjExecuteEx( PropName, DISPATCH_PROPERTYGET, NoParams, @vResult ) then
    Result := vResult.lVal;
end;

procedure TWordDocument.SetObjPropInt(const PropName: String;
  const Value: Integer);
var Params: TDispParams;
    vValue: TVariant;
begin
  Params.rgvarg := @vValue;
  Params.rgdispidNamedArgs := nil;
  Params.cArgs := 1;
  Params.cNamedArgs := 0;

  vValue.vt := VT_I4;
  vValue.lVal := Value;
  ObjExecuteEx( PropName, DISPATCH_PROPERTYPUT, Params, nil );
end;

function TWordDocument.ObjInvoke(const FunName: String;
  const ParamsArray: array of TVariant; Rslt: PVariant): Boolean;
var Params: TDispParams;
    I: Integer;
begin
  FillChar( Params, Sizeof( Params ), 0 );
  if High( ParamsArray ) >= 0 then
  {$IFDEF _D2orD3}
  if not ( (High(ParamsArray) = 0) and (ParamsArray[ 0 ].vt = VT_EMPTY) ) then
  {$ENDIF}
  begin
    Params.rgvarg := @ ParamsArray[ 0 ];
    Params.cArgs := High( ParamsArray ) + 1;
  end;

  Result := ObjExecute( FunName, Params, Rslt );

  for I := 0 to High( ParamsArray ) do
  begin
    if ParamsArray[ I ].vt = VT_BSTR then
      SysFreeString( ParamsArray[ I ].bstrVal );
  end;

end;

function TWordDocument.GetObjPropStr(const PropName: String): String;
var vResult: TVariant;
begin
  Result := '';
  FillChar( vResult, Sizeof( vResult ), 0 );
  if ObjExecuteEx( PropName, DISPATCH_PROPERTYGET, NoParams, @vResult ) then
    Result :=
    {$IFDEF _D2}
      LStrFromPWChar( PWideChar( vResult.bStrVal ) )
    {$ELSE}
      PWideChar( vResult.bStrVal )
    {$ENDIF}
    ;
  SysFreeString( vResult.bStrVal );
end;

procedure TWordDocument.SetObjPropStr(const PropName, Value: String);
var Params: TDispParams;
    vValue: TVariant;
begin
  Params.rgvarg := @vValue;
  Params.rgdispidNamedArgs := nil;
  Params.cArgs := 1;
  Params.cNamedArgs := 0;

  vValue.vt := VT_BSTR;
  vValue.bStrVal := StringToOleStr( Value );
  ObjExecuteEx( PropName, DISPATCH_PROPERTYPUT, Params, nil );
  SysFreeString( vValue.bStrVal );
end;

function TWordDocument.GetObjPropBool(const PropName: String): Boolean;
var vResult: TVariant;
begin
  Result := FALSE;
  FillChar( vResult, Sizeof( vResult ), 0 );
  if ObjExecuteEx( PropName, DISPATCH_PROPERTYGET, NoParams, @vResult ) then
    Result := vResult.boolVal;
end;

procedure TWordDocument.SetObjPropBool(const PropName: String;
  const Value: Boolean);
var Params: TDispParams;
    vValue: TVariant;
begin
  Params.rgvarg := @vValue;
  Params.rgdispidNamedArgs := nil;
  Params.cArgs := 1;
  Params.cNamedArgs := 0;

  vValue.vt := VT_BOOL;
  vValue.boolVal := Value;
  ObjExecuteEx( PropName, DISPATCH_PROPERTYPUT, Params, nil );
end;

procedure ErrorShowMessage( Sender: PObj );
begin
  ShowMessage( 'Error in WordDocument object:'#13 + PWordDocument(Sender).Error );
end;

procedure HandleError( Sender: PWordDocument; hr: Integer );
begin
  if hr <> 0 then
  begin
    Sender.FError := 'Code ' + Int2Str( hr ) + '. Function ' + Sender.Error +
              '. Object "' + Sender.ObjName + '"';
    if Assigned( Sender.FOnError ) then
      Sender.FOnError( Sender );
    if Assigned( Sender.FShowErrorProc ) then
      Sender.FShowErrorProc( Sender );
    if Sender.FHaltOnError then Halt;
  end;
end;

procedure TWordDocument.SetShowErrors(const Value: Boolean);
begin
  FShowErrors := Value;
  FShowErrorProc := ErrorShowMessage;
  FChkErrorProc := HandleError;
end;

function TWordDocument.ChkError(hr: Integer; const ErrorFun: String): Boolean;
begin
  if Assigned( FChkErrorProc ) then
    FChkErrorProc( @Self, hr );
  Result := hr = 0;
end;

{$IFDEF _D2orD3}
function TWordDocument.ObjInvokeNoParams(const FunName: String;
  Rslt: PVariant): Boolean;
var Param: TVariant;
begin
  FillChar( Param, Sizeof( Param ), 0 );
  Param.vt := VT_EMPTY;
  Result := ObjInvoke( FunName, [ Param ], Rslt );
end;
{$ELSE}
function TWordDocument.ObjInvokeNoParams(const FunName: String;
  Rslt: PVariant): Boolean;
begin
  Result := ObjInvoke( FunName, [ ], Rslt );
end;
{$ENDIF}

end.
