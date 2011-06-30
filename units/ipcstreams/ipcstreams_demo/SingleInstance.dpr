program SingleInstance;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:13-2-2003 23:13:05
//********************************************************************
//  Yet another Application Already Running Detector
//  But This one is the SHORTEST I've ever seen and very reliable
//  Stumbled upon it while reading the WIN32.hlp on Interprocess Calls
//  (IPC)
//  Tested under WIN ME and WINDOWS 2000 Professional
//  Tested with D4 CS,D6 personal,D7 personal
//  Author:  Thaddy de Koning  ©2003, Thaddy de Koning
//  Status:  MPL
//**************************************************************************************************
//  The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at http://www.mozilla.org/MPL/
//  Software distributed under the License is distributed on an "AS IS" basis,
//  WITHOUT WARRANTY OF ANY KIND, either express or implied.
//  See the License for the specific language governing rights and limitations under the License.
//**************************************************************************************************

uses
 Windows,
 Kol;


//  Simple utility functions I just dreamed up while playing with IPC
//  Both functions work, even if no Tcontrol type Object is created (yet) as
//  opposed to the KOL JustOne Function
//  Note: you don't have to release the event or mutex, the operating system
//  will do that for you when the application finishes.
function JustOneEvent:Boolean;
begin
  CreateEvent(nil,False,False,Pchar(ExtractFileName(ParamStr(0))));
  result := getlasterror = ERROR_ALREADY_EXISTS;
end;

//  Allows the user to set the name
function JustOneNamedEvent(aName:String):Boolean;
begin
  CreateEvent(nil,False,False,Pchar(aName));
  result := getlasterror = ERROR_ALREADY_EXISTS;
end;

//  Another approach, does the same thing
//  Note the name setting is slihly different: this is only because
//  I wanted both routines to be tested in this small demo and
//  Names of synchronisation objects have to be unique
function JustOneMutex:Boolean;
begin
  CreateMutex(nil,True,Pchar(ExtractFileNameWoExt(ParamStr(0))));
  result := getlasterror = ERROR_INVALID_HANDLE;
end;

//  Allows the user to set the name
function JustOneNamedMutex(aName:string):Boolean;
begin
  CreateMutex(nil,True,Pchar(aName));
  result := getlasterror = ERROR_INVALID_HANDLE;
end;

//  Another approach, does the same thing, but returns the handles
function JustOneHandleMutex(var Handle:Thandle):Boolean;
begin
  Handle:=CreateMutex(nil,True,Pchar(ExtractFileNameWoExt(ParamStr(0))));
  result := getlasterror = ERROR_INVALID_HANDLE;
end;

function JustOneHandleNamedMutex(var Handle:THandle;aName:string):Boolean;
begin
  Handle:=CreateMutex(nil,True,Pchar(aName));
  result := getlasterror = ERROR_INVALID_HANDLE;
end;


//  This is an example of how to return an error message from the systemerror stringtable
//  It returns the text in the default locale
//  It does the same as KOL's SysErrorStr function, but with less code
//  Because setlength on the result sets the string to contaain all zero's,
//  the Length function will determine the correct length, so some of the tail removal
//  code can simply be skipped. As a trade off, Length gets called
function SystemErrorString(Err:Dword):string;
begin
    SetLength(Result,255);
    FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil, err, 0, Pchar(Result),Length(Result),nil);
end;

begin
    JustOneEvent;
    ShowMessage('Event: '+SysErrorMessage(getLastError));
    SetLastError(0);
    JustOneMutex;
    ShowMessage('Mutex: '+SysErrorMessage(getLastError));
    SetLastError(0);
end.
