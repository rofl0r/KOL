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
                             Types for winpcap

                   used by winpcap.pas and sniffer.pas

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


unit kolwinpcaptypes;

interface

uses winsock,Windows,kol;

const
  PCAP_IF_LOOPBACK = $00000001;
  MAX_LINK_NAME_LENGTH  =64;
  PCAP_ERRBUF_SIZE      =256;

  PROTO_IP              = $0800;
  PROTO_ARP             = $0806;
  PROTO_XNS             = $0600;
  PROTO_SNMP            = $814C;
  PROTO_OLD_IPX         = $8137;
  PROTO_NOVELL          = $8138;
  PROTO_IPNG            = $86DD;

  (** IP Protocol # **)
  PROTO_ICMP            = 1;
  PROTO_TCP             = 6;
  PROTO_UDP             = 17;

  ARP_REQUEST           = $0001;
  ARP_REPLY             = $0002;

Type

  bpf_u_int32           = LongWord;
  bpf_int32             = Integer;
  ushort                = byte;
  uchar                 = byte;

  ptimeval = ^timeval;
  timeval  = record
    tv_sec,
    tv_usec: bpf_u_int32;
  End;
  Pttimeval = ^TtimeVal;
  TtimeVal  = timeval;

  ppcap_pkthdr = ^pcap_pkthdr;
  pcap_pkthdr = record
	ts       : timeval;
	CapLen,
	Len    : bpf_u_int32;
  end;
  PTpcap_pkthdr = ^Tpcap_pkthdr;
  Tpcap_pkthdr = pcap_pkthdr;

  ppcap_addr = ^pcap_addr;
  pcap_addr  = record
    next: PPCAP_ADDR;
    addr: PSOCKADDR;       {= address }
    netmask: PSOCKADDR;    {= netmask for that address }
    broadaddr: PSOCKADDR;  {= broadcast address for that address }
    dstaddr: PSOCKADDR;    {= P2P destination address for that address }
  end;

  PTpcap_addr = ^Tpcap_addr;
  Tpcap_addr  =pcap_addr;

  pppcap_if = ^ppcap_if;
  ppcap_if = ^pcap_if;
  pcap_if =  record
    next: ppcap_if;
    name: PChar;
    description: PChar;
    addresses: PPCAP_ADDR;
    flags: BPF_U_INT32;
  end;

  PTpcap_if = ^Tpcap_if;
  Tpcap_if =  pcap_if;

  pbf_insn = ^bpf_insn;
  bpf_insn = record
    code : ushort;
    jt   : uchar;
    jf   : uchar;
    k    : Integer;
  end;
  PTbf_insn = ^Tbpf_insn;
  Tbpf_insn = bpf_insn;

  ppcap_stat = ^pcap_stat;
  pcap_stat = record
    ps_recv,
    ps_drop,
    ps_ifdrop : u_int;
  {$IFDEF win32}
    bs_capt   : u_int;
  {$ENDIF}
  End;
  PTpcap_stat = ^Tpcap_stat;
  Tpcap_stat =pcap_stat;

  Padapter = ^adapter;
  adapter = packed Record
    hFile        : LongWord;
    SymbolicLink : array [0..MAX_LINK_NAME_LENGTH-1] of char;
  end;
  PTadapter = ^Tadapter;
  Tadapter = adapter;

  Ppacket = ^packet;
  packet = packed record
    hevent             :Thandle;
    OverLapped         :TOVERLAPPED;
    Buffer             :Pointer;
    Length             :Longword;
    ulBytesReceived    :LongWord;
    bIoComplete        :Boolean;
  end;
  PTpacket = ^Tpacket;
  Tpacket = ppacket;

 pcap_sf = record
   rfile                : HFILE;
   swapped              :Integer;
   version_major        : Integer;
   Version_Minor        : Integer;
   base                 : Pointer;
  end;

  Pbpf_program = ^bpf_program;
  bpf_program = record
    bf_len  : LongWord;
    bf_insns: ^bpf_insn;
  end;
  PTbpf_program = ^Tbpf_program;
  Tbpf_program  = bpf_program;

  Pbpf_stat = ^bpf_stat;
  bpf_stat = record
    bs_recv,
    bs_drop : LongWord;
  end;
  PTbpf_stat = ^Tbpf_stat;
  Tbpf_stat = bpf_stat;

  Pbpf_hdr = ^bpf_hdr;
  bpf_hdr =record
    bh_tstamp :timeval;
    bh_caplen,
    bh_datalen: bpf_u_int32;
    bh_hdrlen : Word ;

  end;
  PTbpf_hdr = ^Tbpf_hdr;
  Tbpf_hdr = bpf_hdr;

  pcap_md = record
	  Stat        : TPcap_stat;
	  use_bpf     : Integer;
	  TotPkts     : LongWord;
	  TotAccepted : LongWord;
	  TotDrops    : LongWord;
	  TotMissed   : Longword;
	  OrigMissed  : LongWord;
  end;

  Ppcap = ^pcap;
  pcap = record
	  Adapter  : Padapter;
	  Packet   : PPacket;
	  snapshot : Integer;
          linktype : Integer;
          tzoff    : Integer;
          offset   : Integer;
          sf       : pcap_sf;
          md       : pcap_md;
          bufsize  : Integer;
  	  buffer   : Pointer;
  	  bp       : Pointer;
          cc       : Integer;
          pkt      : Pointer;
          fcode    : bpf_program;
          errbuf   : array [0..PCAP_ERRBUF_SIZE-1] of Char;
  end;
  PTpcap = ^Tpcap;
  Tpcap  = pcap;

  Pnet_type = ^net_type;
  net_type = packed record
    LinkType,
    LinkSpeed : LongWord;
  end;

  MACADDRESS = array[0..5] of UCHAR;
  PMACADDRESS = ^MACADDRESS;
  PPChar = ^PChar;

  (** Ethernet **)
  PEthernetHdr = ^TEthernetHdr;
  TEthernetHdr  = packed record
	Destination,
	Source       : MACADDRESS;
	Protocol     : WORD;
  end;
  (** Ethernet - Packet **)
  PEthernetPckt = ^TEthernetPckt;
  TEthernetPckt = Packed record
    Header : TEthernetHdr;
    Data   : Array[0..0] of uchar;
  End;

  (** IP - Header **)
  PIPHdr  = ^TIPhdr;
  TIPHdr   = packed record
    EthernetHeader : TEthernetHdr;
    Verlen         : UCHAR;
    Service        : UCHAR;
    Length         : WORD;
    Ident          : WORD;
    Flagoff        : WORD;
    TimeLive       : UCHAR;
    Protocol       : UCHAR;
    Checksum       : WORD;
    Source         : DWORD;
    Destination    : DWORD;
  end;

  (** IP - Packet **)
  PIPPckt = ^TIPPckt;
  TIPPckt = Packed record
    IPHeaderr     : TIPHdr;
    Data          : Array[0..0] of uchar;
  End;

  (** IP - TCP Header **)
  PTCPHdr = ^TTCPHdr;
  TTCPHdr = packed record
    IPHeader      : TIPHdr;
    Source,
    Destination   : WORD;
    Seq,
    Ack           : DWORD;
    Off_Rsvd      : UCHAR;
    Rsvd_Flags    : UCHAR;
    Window        : WORD;
    Checksum      : WORD;
    UrgPoint      : WORD;
  end;

  (** IP - TCP Packet **)
  PTCPPckt = ^TTCPPckt;
  TTCPPckt = Packed record
    TCPHeader     : TTCPHdr;
    Data          : Array[0..0] of uchar;
  End;

  (** IP - UDP Header **)
  PUDPHdr = ^TUDPHdr;
  TUDPHdr = packed record
    IPHeader      : TIPHdr;
    Source,
    Destination,
    Length,
    Checksum      : WORD;
  end;

  PUDPPckt = ^TUDPPckt;
  TUDPPckt = Packed record
    TUDPHeader    : TUDPHdr;
    Data          : Array[0..0] of uchar;
  End;

  (** ARP HEADER **)

  PArpHdr = ^ArpHdr;
  ArpHdr = packed record
    HardwareType,
    ProtocolType  : WORD;
    HLen          : UCHAR;
    PLen          : UCHAR;
    Operation     : WORD;
    SenderHA      : MACADDRESS;
    SenderIP      : DWORD;
    TargetHA      : MACADDRESS;
    TargetIP      : DWORD;
  end;

function IPtoStr(IP: LongWord): String;
Function StrToIP(addr : PSOCKADDR):LongWord;

implementation

function IPtoStr(IP: LongWord): String;
begin
  Result := Format('%d.%d.%d.%d', [
      	    (IP and $ff000000) shr 24,
	    (IP and $00ff0000) shr 16,
	    (IP and $0000ff00) shr 8,
	    (IP and $000000ff) shr 0
	     ]);
end;

Function StrToIP(addr : PSOCKADDR):LongWord;
Var IP: array [0 .. 3 ] of LongWord;
Begin
   Result:=0;
   if addr= nil then
     Exit;
   IP[0]:=Ord(addr.sin_addr.S_un_b.s_b1);
   IP[1]:=Ord(addr.sin_addr.S_un_b.s_b2);
   IP[2]:=Ord(addr.sin_addr.S_un_b.s_b3);
   IP[3]:=Ord(addr.sin_addr.S_un_b.s_b4);
   Result :=
   	IP[0] shl 24 +
   	IP[1] shl 16 +
   	IP[2] shl 8 +
   	IP[3] shl 0;
End;

end.