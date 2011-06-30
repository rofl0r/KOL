{-----------------------------------------------------------------------------
 Unit Name: kolIPCStreams
 Author:    Thaddy de Koning, © 2003, Thaddy de Koning
 Purpose:   Defines Interprocess Stream Descendants for KOL
 History:   February 17, 2003, Initial release;
 Status:    MPL
 Notes:     1) The use of this unit requires a slight modification of the
            KOL Tstream object:

            Add in the public segment:

              property Data:TStreamdata read Fdata;

            This surfaces the data structure for expansion

            I will ask Vladimir Kladov if he wants to change this in a
            future (i.e. higher than 1.68) release, because it seems logical
            as Methods is already a property.
            (Or make both fData and fMethods protected, so descendants or
            typecast-hacks can use them)

            2) Some bits of code from Delphi Magazine 60 (NOT the streaming bits)

            3) Not all Streaming methods of Tstream are supported (yet), since
            IPC objects do not always support things like position and Size.

            4) It is recommended to use the server objects from a Thread,
            Since (except the mailslot) Read Calls are Blocking
            See KolNamedpipeServer Example.

 TODO:      Write out ALL the Tmethod stubs to create a more robust implementation.
            Currently the KOL Tstream object is a rightfull mess for anything other
            than real filestreams and memorystreams.
            Note that the OS consiiders Mailslots and Pipes as Files, so inho this
            should not be the case.
            Write Non-blocking (asynchronous) pipestreams;
 -----------------------------------------------------------------------------}
//  The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at http://www.mozilla.org/MPL/
//  Software distributed under the License is distributed on an "AS IS" basis,
//  WITHOUT WARRANTY OF ANY KIND, either express or implied.
//  See the License for the specific language governing rights and limitations under the License.


unit kolIPCStreams;

interface
uses Windows, Kol;
//  Defines default names for local mailslots and pipes
//  Since this you don't need to pass a mailslot or pipename in the
//  constructing function if you want a simple mailslot on a
//  local machine

const
  MailslotNameLocalPrefix = '\\.\mailslot\';
  MailslotName = 'KolMailslot';
  MailslotWriteName = MailslotNameLocalPrefix + MailslotName;
  MailslotReadName  = MailslotNameLocalPrefix + MailslotName;
  MailslotMaxSize = 0; //any size
  MailslotTimeout = 0; //don't wait

  PipeNameFixedPrefix = '\\.\pipe\';
  PipeName = PipeNameFixedPrefix + 'SampleNamedPipe';
  PipeMaxInstances = 1; //only allow 1 pipe
  PipeOutBufferSize = 0; //any size
  PipeInBufferSize = 0; //any size
  PipeTimeout = 0; //don't wait


// Adapted from sysutils
function Win32Check(RetVal: Bool): Bool;

//  Mailslot ClientStream (Client)
//  Use this in your Mailslot Client application
function NewMailSLotWriteStream(MailSlotName:string = MailSLotWriteName):pStream;

//  Mailslot Serverstream (Server)
//  Use this in your Mailslot Server Application
function NewMailSLotReadStream(MailSlotName:string = MailSlotReadName):pStream;

//  Anonymous Pipe Writer (Client)
//  Use this to write to StdOut
function NewAnonymousPipeWriteStream:pStream;

//  Anonymous Pipe Reader (Server)
//  Use this to read from StdIn
function NewAnonymousPipeReadStream(ChildApp:String;OpenChild:Boolean):pStream;

//  Named Pipe  Writer (Ckient)
function NewNamedPipeWriteStream(Pipename:String = PipeName):pStream;

//  Named Pipe Reader (Server)
function NewNamedPipeReadStream(ChildApp:String; OpenChild:Boolean; Pipename:String = PipeName):pStream;


//  Creates a separate read stream on a stream;
//  function newreadviewstream(astream:pstream):pstream;

//  Helper function, from The Delphi Magazine 60
function LaunchChildApp(ChildApp:string): THandle;


implementation

function NewMailSLotWriteStream(MailSlotName:string):pStream;
var
  MailSlotMethods:TStreamMethods;
begin
  Result:= _NewStream(MailSlotMethods);
  Result.Methods.fWrite := WriteFileStream;
  Result.Methods.fClose:=CloseFileStream;
  with Result.Data do fHandle:= CreateFile(MailslotWriteName, Generic_Write, File_Share_Read,
        nil, Open_Existing, File_Attribute_Normal, 0);
    if Result.Data.fHandle = Invalid_Handle_Value then
    begin
      MsgOk(SysErrorMessage(getlasterror));
    end;
end;

function NewMailSLotReadStream(MailSlotName:string):pStream;
var
  MailSlotMethods:TStreamMethods;
begin
  Result:= _NewStream(MailSlotMethods);
  Result.Methods.fRead := ReadFileStream;
  Result.Methods.fClose:=CloseFileStream;
  with Result.Data do fHandle:=CreateMailslot(
    MailslotReadName, MailslotMaxSize, MailslotTimeout, nil);
    if Result.Data.fHandle = Invalid_Handle_Value then
    begin
      MsgOk(SysErrorMessage(getlastError));
    end;
end;

function NewAnonymousPipeWriteStream:pStream;
var
 PipeMethods:TStreamMethods;
begin
  Result:=_NewStream(PipeMethods);
  Result.Methods.fWrite:=WriteFileStream;
  Result.Methods.fClose:=CloseFileStream;
  with Result.Data do fHandle:=GetStdHandle(Std_Output_Handle);
  if Result.Data.fHandle = Invalid_Handle_Value then
  begin
    MsgOk(SysErrorMessage(getlastError));
  end;
end;


{This will create an anonymous pipe and get a read and write handle
back. The intention is for a child app to write to the pipe and for
this parent app to read from the pipe.
The security attributes will be specified to ensure that
child processes can inherit these handles (i.e use their values)
To communicate the write pipe handle value to the child app
the STDOUT handle of this process will be replaced with the pipe
handle. The child process will get a copy of this process's
standard handles and so will inherit it.
To ensure there is only one write handle and one read handle
(for solid error trapping to work) this process must close its write
handle after launching the child and before reading from the pipe.
Also, to ensure the child cannot use the read pipe handle, we
will duplicate the given handle and make it non-inheritable.}
function NewAnonymousPipeReadStream(ChildApp:String;OpenChild:Boolean):pStream;
var
  PipeMethods:TSTreamMethods;
  Security: TSecurityAttributes;
  ThisProcess, PipeReadTmp, PipeWrite: THandle;
const
  PipeBufferSize = 0; //default size
begin
  Result:=_NewStream(PipeMethods);
  Result.Methods.fRead:=ReadFileStream;
  Result.Methods.fClose:=CloseFileStream;
  with Security do
  begin
    nLength := SizeOf(Security);
    bInheritHandle := True; //create inheritable handles
    lpSecurityDescriptor := nil;
  end;
  with result.Data do (CreatePipe(fhandle, PipeWrite, @Security, PipeBufferSize));
  //Turn STDOUT into the write pipe handle
  Win32Check(SetStdHandle(Std_Output_Handle, PipeWrite));
  //Ensure pipe read handle is not inheritable
  ThisProcess := GetCurrentProcess();
  Win32Check(DuplicateHandle(ThisProcess, Result.Data.fHandle, ThisProcess,
    @PipeReadTmp, 0, False, Duplicate_Same_Access));
  CloseHandle(Result.Data.fHandle);
  with Result.Data do fHandle:=PipeReadTmp;
  //This launches the child process and waits for it to
  //settle down before moving on to the next statement
  if OpenChild then
     WaitForInputIdle(LaunchChildApp(ChildApp), Infinite);
  //Ensure only the child has an open write pipe handle
  CloseHandle(PipeWrite);
  if Result.Data.fHandle = Invalid_Handle_Value then
  begin
    MsgOk(SysErrorMessage(getlastError));
  end;
end;

//  Named Pipe Writer (Ckient)
function NewNamedPipeWriteStream(Pipename:String):pStream;
var
 PipeMethods:TStreamMethods;
begin
  Result:=_NewStream(PipeMethods);
  Result.Methods.fWrite:=WriteFileStream;
  Result.Methods.fClose:=CloseFileStream;
  with Result.Data do fHandle:=CreateFile(pAnsiChar(PipeName), Generic_Write, 0,
    nil, Open_Existing, File_Attribute_Normal, 0);
  if Result.Data.fHandle = Invalid_Handle_Value then
  begin
    MsgOk(SysErrorMessage(getlastError));
  end;
end;

//  Named Pipe Reader (Server)
function NewNamedPipeReadStream(ChildApp:String;OpenChild:Boolean;Pipename:String):pStream;
{This will create a named pipe and get a read and write handle
back. The intention is for a child app to write to the pipe and for
this parent app to read from the pipe.}
const
  PipeBufferSize = 0; //default size
var
 PipeMethods:TStreamMethods;
begin
  Result:=_NewStream(PipeMethods);
  Result.Methods.fRead:=ReadFileStream;
  Result.Methods.fClose:=CloseFileStream;
  with Result.Data do
  begin
    fHandle := CreateNamedPipe(pAnsiChar(PipeName), Pipe_Access_Inbound, Pipe_Type_Byte,
       PipeMaxInstances, PipeOutBufferSize, PipeInBufferSize, PipeTimeOut, nil);
    if fHandle = Invalid_Handle_Value then
      MsgOk(SysErrorMessage(getlastError));
    //This launches the child process and waits for it to
    //settle down before moving on to the next statement
    if OpenChild then
      WaitForInputIdle(LaunchChildApp(ChildApp), Infinite);
  end;
end;

function LaunchChildApp(ChildApp:string): THandle;
var
  SI: TStartupInfo;
  PI: TProcessInformation;
begin
  GetStartupInfo(SI);
  if not CreateProcess(nil, pAnsiChar(ChildApp), nil, nil,
     //Make sure child inherits our inheritable handles
     //as it will need to refer to them to use the pipes
     True,
     0, nil, nil, SI, PI) then
    MsgOk('Unable to launch ' + ChildApp);
  Result := PI.HProcess
end;


function Win32Check(RetVal: Bool): Bool;
var
  LastError: DWORD;
begin
  Result := RetVal;
  if not RetVal then
  begin
    LastError := GetLastError;
    if LastError <> ERROR_SUCCESS then
      MsgOk( Format('Win32 Error.  Code: %d.'#10'%s',
        [LastError, SysErrorMessage(LastError)]))
    else
      MsgOk('A Win32 API function failed')
  end;
end;


end.
