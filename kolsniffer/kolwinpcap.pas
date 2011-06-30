//
// purpose: Packet sniffer for use with the open source WinPcap driver
//  author: Authorized KOL version, © 2005, Thaddy de Koning
//          Original version © Umar Sear
// Remarks: The WinPCap driver is free ware and available from
//          http://winpcap.polito.it/ under a BSD style license
//
//          This KOL demo and the KOL headerfile translations are not freeware
//          They are subject to the same license as Umar states in his header
//          comments

{********************************************************************************
 --------------------------------------------------------------------------------
                         header conversion for Delphi

                                for winpcap

               Packet Capture Driver by Politecnico di Torino

                            Written by Umar Sear
 --------------------------------------------------------------------------------

 TERMS AND CONDITIONS OF USE.

 Code in this unit is Copyright(C) 2003 Umar Sear

 The author of this software assumes no liability for damages caused under
 any circumstances whatsoever, and is under no obligation. Use of the software
 indicates acceptance of all conditions contained in this document. If you do
 not agree to these terms, you must delete this software immediately.

 You may distribute the archive in which this software is distributed, but
 under no circumstances must this archive be changed. Distributing a modified
 archive is a violation of the software license.

 If you do redistribute this software, please let me know at the email address
 given below.

 This software is not freeware, if you wish to use it other than for trial
 purposes, please contact me for a full licence.

 If you have any questions, requests, bug reports, etc., please contact me at
 the address given below.

 Umar Sear
 Email  : usear@yahoo.com

 Winpcap author:
 webpsite: http://netgroup-serv.polito.it
********************************************************************************}

unit kolwinpcap;

interface

uses Windows,kol,kolwinpcaptypes;

Const

  DLL  = 'wpcap.dll';               // Name of DLL file
  DEFAULT_DRIVERBUFFER = 1000000;   // Dimension of the buffer in driver
  MAX_LINK_NAME_LENGTH = 64;        // Adapters symbolic names maximum length
  PcapBufSize          = 256000;    // Dimension of the buffer in TPcap
  DEFAULT_SNAPLEN      = 68;        // Default Snapshot length

type

  PTpcap_handler =^Tpcap_handler;
  Tpcap_handler = procedure(User:pointer;const Header:PTpcap_pkthdr;const Data:Pointer);

Type

  TDllpcap_loop          = function (P:Ppcap;cnt:Integer;callback:PTpcap_handler;user:Pointer):Integer; cdecl;
  TDllpcap_open_dead     = function (linktype :integer; SnapLen:Integer):ppcap; cdecl;
  TDllpcap_open_live     = function (Device:Pchar; SnapLen:Integer; Promisc:Integer;To_ms:Integer;
                                     errstr:Pchar) : ppcap; cdecl;
  TDllpcap_dispatch      = function (P:PPcap;cnt:Integer;callback:PTpcap_handler;user:Pointer):Integer; cdecl;
  TDllpcap_datalink      = function (P:Ppcap) : Integer; cdecl;
  TDllpcap_read          = function (p:Ppcap;cnt:Integer;callBack:PTpcap_handler;user:pointer) :Integer; cdecl;
  TDllpcap_read_ex       = function (p:Ppcap;Header:Ppcap_pkthdr;data:pointer) :Integer; cdecl;
  TDllpcap_stats_ex      = function (P:Ppcap;ps:Ppcap_stat) : Integer; cdecl;   //remove
  TDllpcap_setbuff       = function (p:Ppcap;dim:Integer)   : Integer; cdecl;
  TDllpcap_findalldevs   = function (alldevp : Pppcap_if;errstr:Pchar):Integer; cdecl;
  TDllpcapsetfilter      = function (P:PPcap;fp:Pbpf_program):integer; cdecl;
  TDllpcap_compile       = function (P:PPcap;fp:Pbpf_program;str:String;optimize:Integer;bpf_u_int32:LongWord):Integer; cdecl;
  TDllpcap_major_version = function (p: Ppcap):Integer; cdecl;
  TDllpcap_minor_version = function (p: Ppcap):Integer; cdecl;
  TDllpcap_snapshot      = Function (p: Ppcap):Integer; cdecl;
  TDllpcap_geterr        = Function (p: Ppcap):Pchar; cdecl;
  TDLLpcap_freealldevs   = procedure(alldevsp: ppcap_if);cdecl;
  TDllpcap_close         = procedure(p: ppcap); cdecl;
  TDllpcap_freecode      = procedure(fp:Pbpf_program); cdecl;


Var
  pcap_dispatch        : TDllpcap_dispatch;
  pcap_loop            : TDllpcap_loop;
  pcap_open_live       : TDllpcap_open_live;
  pcap_open_dead       : TDllpcap_open_dead;
  pcap_datalink        : TDllpcap_datalink;
  pcap_freecode        : TDllpcap_freecode;
  pcap_read	       : TDllpcap_read;
  pcap_read_ex	       : TDllpcap_read_ex;
  pcap_stats_ex        : TDllpcap_stats_ex;
  pcap_setbuff         : TDllpcap_setbuff;
  pcap_close           : TDllpcap_close;
  pcap_setfilter       : TDllpcapsetfilter;
  pcap_compile         : TDllpcap_compile;
  pcap_freealldevs     : TDLLpcap_freealldevs;
  pcap_findalldevs     : TDLLpcap_findalldevs;
  pcap_major_version   : TDllpcap_major_version;
  pcap_minor_version   : TDllpcap_minor_version;
  pcap_snapshot        : TDllpcap_snapshot;
  pcap_geterr          : TDllpcap_geterr;


function Initializewpcap : Boolean;

Implementation

var
 wpcapsucceed: Boolean = false;

function Initializewpcap : Boolean;
var
	hInst: THandle;
begin
  if wpcapsucceed then
  begin
    Result := true;
    exit;
  end;
  Result := false;
  hInst := LoadLibrary('wpcap.dll');

  if hInst = 0 then
   exit;

  pcap_loop := GetProcAddress(hInst, 'pcap_loop');
  if @pcap_loop = nil then
    exit;

  pcap_open_live := GetProcAddress(hInst, 'pcap_open_live');
  if @pcap_open_live = nil then
    exit;

  pcap_open_dead := GetProcAddress(hInst, 'pcap_open_dead');
  if @pcap_open_dead = nil then
    exit;

  pcap_dispatch := GetProcAddress(hInst, 'pcap_dispatch');
  if @pcap_dispatch = nil then
    exit;

  pcap_datalink  := GetProcAddress(hInst, 'pcap_datalink');
  if @pcap_datalink = nil then
    exit;

  pcap_read      := GetProcAddress(hInst, 'pcap_read');
  if @pcap_read = nil then
    exit;

  pcap_read_ex   := GetProcAddress(hInst, 'pcap_read_ex');
  if @pcap_read = nil then
    exit;

  pcap_stats_ex  := GetProcAddress(hInst, 'pcap_stats_ex');
  if @pcap_stats_ex = nil then
    exit;

  pcap_setbuff   := GetProcAddress(hInst, 'pcap_setbuff');
  if @pcap_setbuff = nil then
    exit;

  pcap_close     := GetProcAddress(hInst, 'pcap_close');
  if @pcap_close = nil then
    exit;

  pcap_freecode  := GetProcAddress(hInst, 'pcap_freecode');
  if @pcap_freecode = nil then
    exit;

  pcap_setfilter := GetProcAddress(hInst, 'pcap_setfilter');
  if @pcap_setfilter = nil then
    exit;

  pcap_compile   := GetProcAddress(hInst, 'pcap_compile');
  if @pcap_compile = nil then
    exit;

  pcap_findalldevs := GetProcAddress(hInst, 'pcap_findalldevs');
  if @pcap_findalldevs = nil then
    exit;

  pcap_freealldevs   := GetProcAddress(hInst, 'pcap_freealldevs');
  if @pcap_freealldevs = nil then
    exit;

  pcap_major_version := GetProcAddress(hInst, 'pcap_major_version');
  if @pcap_major_version = nil then
    exit;

  pcap_minor_version := GetProcAddress(hInst, 'pcap_minor_version');
  if @pcap_minor_version = nil then
    exit;

  pcap_snapshot := GetProcAddress(hInst, 'pcap_snapshot');
  if @pcap_snapshot = nil then
    exit;

  pcap_geterr := GetProcAddress(hInst, 'pcap_geterr');
  if @pcap_geterr = nil then
    exit;


  wpcapsucceed := true;
  Result := true;
end;

End.

