{

       Unit: KolAsioList
    purpose: ASIO Driver list Auxiliary unit
     Author: KOL adaptation Thaddy de Koning
             Original codeMartin Fay
  Copyright: See below
    Remarks:
}
unit
    kolasiolist;

interface

uses
    Kol,ActiveX;

type
    TAsioDriverDesc = packed record
      id   : TCLSID;
      name : array[0..511] of char;
      path : array[0..511] of char;
    end;
    PAsioDriverDesc = ^TAsioDriverDesc;

    TAsioDriverList = array of TAsioDriverDesc;


procedure ListAsioDrivers(var List: TAsioDriverList);


implementation

uses
    Windows;

const
     ASIODRV_DESC  = 'description';
     INPROC_SERVER = 'InprocServer32';
     ASIO_PATH     = 'software\asio';
     COM_CLSID     = 'clsid';

//******************
//From D4 ComObj.Pas
//******************
procedure OleCheck(Result: HResult);
begin
  if not Succeeded(Result) then MsgOk(SysErrorMessage(Result));
end;

function StringToGUID(const S: string): TGUID;
begin
  OleCheck(CLSIDFromString(PWideChar(WideString(S)), Result));
end;

// ******************************************************************
// Local Functions
// ******************************************************************
function findDrvPath(const clsidstr: string; var dllpath: string): longint;
var
   //reg     : TRegistry;
   success : boolean;
   buf     : array[0..1024] of char;
   s       : string;
   temps   : string;
   TmpKey:HKEY;
begin
  Result := -1;

  //CharLowerBuff(clsidstr,strlen(clsidstr));
  //reg := TRegistry.Create;
  try
    //reg.RootKey := HKEY_CLASSES_ROOT;
    //success := reg.OpenKeyReadOnly(COM_CLSID + '\' + clsidstr + '\' + INPROC_SERVER);
    TmpKey:=RegKeyOpenRead(HKEY_CLASSES_ROOT,COM_CLSID + '\' + clsidstr + '\' + INPROC_SERVER);
    if TmpKey <>0 then
    begin
      dllpath := regKeyGetStr(TmpKey,'');
      if (ExtractFilePath(dllpath) = '') and (dllpath <> '') then
      begin
        RegKeyClose(TmpKey);
        buf[0] := #0;
        temps := dllpath;   // backup the value
        if GetSystemDirectory(buf, 1023) <> 0 then   // try the system directory first
        begin
          s := buf;
          dllpath := s + '\' + temps;
        end;

        if not FileExists(dllpath) then              // try the windows dir if necessary
        begin
          buf[0] := #0;
          if GetWindowsDirectory(buf, 1023) <> 0 then   // try the system directory first
          begin
            s := buf;
            dllpath := s + '\' + temps;
          end;
        end;
      end;

      if FileExists(dllpath) then
        Result := 0;
    end;
  finally
    //reg.Free;
  end;
end;

procedure ListAsioDrivers(var List: TAsioDriverList);
var
   //r       : TRegistry;
   TmpKey  :HKEY;
   keys    : pStrList;
   success : boolean;
   i       : integer;
   id      : string;
   dllpath : string;
   count   : integer;
begin
  SetLength(List, 0);

  keys := NewStrlist;
  //r := TRegistry.Create;
  try
    TmpKey:=HKEY_LOCAL_MACHINE;
    TmpKey:=RegKeyOpenRead(HKEY_LOCAL_MACHINE,ASIO_PATH);
    if TmpKey<>0  then
    begin
      regKeyGetSubKeys(TmpKey,keys);
      RegKeyClose(TmpKey);
    end;

    count := 0;
    for i := 0 to keys.Count-1 do
    begin
      TmpKey := RegKeyOpenRead(HKEY_LOCAL_MACHINE,ASIO_PATH + '\' + keys.items[i]);
      if TmpKey<>0 then
      begin
        id := RegKeyGetStr(TmpKey,COM_CLSID);
        if findDrvPath(id, dllpath) = 0 then  // check if the dll exists
        begin
          SetLength(List, count+1);
          List[count].id := StringToGUID(id);
          StrLCopy(List[count].name, Pchar(keys.items[i]), 512);
          StrLCopy(List[count].path, PChar(dllpath), 512);
          inc(count);
        end;
        RegKeyClose(TmpKey);
      end;
    end;
  finally
    keys.Free;

  end;
end;

end.
