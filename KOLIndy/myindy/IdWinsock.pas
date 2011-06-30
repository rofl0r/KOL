// 19-nov-2002
unit IdWinsock;

interface

uses
  {IdException,}
  Windows;

type
{$NODEFINE u_char}
  u_char = Char;
{$NODEFINE u_short}
  u_short = Word;
{$NODEFINE u_int}
  u_int = Integer;
{$NODEFINE u_long}
  u_long = DWORD;

{$NODEFINE TSocket}
  TSocket = u_int;

const
{$NODEFINE FD_SETSIZE}
  FD_SETSIZE = 64;

type
{$NODEFINE PFDSet}
  PFDSet = ^TFDSet;
{$NODEFINE TFDSet}
  TFDSet = record
    fd_count: u_int;
    fd_array: array[0..FD_SETSIZE - 1] of TSocket;
  end;

{$NODEFINE PTimeVal}
  PTimeVal = ^TTimeVal;
{$NODEFINE timeval}
  timeval = record
    tv_sec: Longint;
    tv_usec: Longint;
  end;
{$NODEFINE TTimeVal}
  TTimeVal = timeval;

const
{$NODEFINE IOCPARM_MASK}
  IOCPARM_MASK = $7F;
{$NODEFINE IOC_VOID    }
  IOC_VOID = $20000000;
{$NODEFINE IOC_OUT     }
  IOC_OUT = $40000000;
{$NODEFINE IOC_IN      }
  IOC_IN = $80000000;
{$NODEFINE IOC_INOUT   }
  IOC_INOUT = (IOC_IN or IOC_OUT);

{$NODEFINE FIONREAD   }
  FIONREAD = IOC_OUT or { get # bytes to read }
    ((Longint(SizeOf(Longint)) and IOCPARM_MASK) shl 16) or
    (Longint(Byte('f')) shl 8) or 127;
{$NODEFINE FIONBIO    }
  FIONBIO = IOC_IN or { set/clear non-blocking i/o }
    ((Longint(SizeOf(Longint)) and IOCPARM_MASK) shl 16) or
    (Longint(Byte('f')) shl 8) or 126;
{$NODEFINE FIOASYNC   }
  FIOASYNC = IOC_IN or { set/clear async i/o }
    ((Longint(SizeOf(Longint)) and IOCPARM_MASK) shl 16) or
    (Longint(Byte('f')) shl 8) or 125;

type
{$NODEFINE PHostEnt}
  PHostEnt = ^THostEnt;
{$NODEFINE hostent}
  hostent = record
    h_name: PChar;
    h_aliases: ^PChar;
    h_addrtype: Smallint;
    h_length: Smallint;
    case Byte of
      0: (h_addr_list: ^PChar);
      1: (h_addr: ^PChar)
  end;
{$NODEFINE THostEnt}
  THostEnt = hostent;

{$NODEFINE PNetEnt}
  PNetEnt = ^TNetEnt;
{$NODEFINE netent}
  netent = record
    n_name: PChar;
    n_aliases: ^PChar;
    n_addrtype: Smallint;
    n_net: u_long;
  end;
{$NODEFINE TNetEnt}
  TNetEnt = netent;

{$NODEFINE PServEnt}
  PServEnt = ^TServEnt;
{$NODEFINE servent}
  servent = record
    s_name: PChar;
    s_aliases: ^PChar;
    s_port: Word;
    s_proto: PChar;
  end;
{$NODEFINE TServEnt}
  TServEnt = servent;

{$NODEFINE PProtoEnt}
  PProtoEnt = ^TProtoEnt;
{$NODEFINE protoent}
  protoent = record
    p_name: PChar;
    p_aliases: ^Pchar;
    p_proto: Smallint;
  end;
{$NODEFINE TProtoEnt}
  TProtoEnt = protoent;

const

{ Protocols }
{$NODEFINE IPPROTO_IP     }
  IPPROTO_IP = 0; { dummy for IP }
{$NODEFINE IPPROTO_ICMP   }
  IPPROTO_ICMP = 1; { control message protocol }
{$NODEFINE IPPROTO_IGMP   }
  IPPROTO_IGMP = 2; { group management protocol }
{$NODEFINE IPPROTO_GGP    }
  IPPROTO_GGP = 3; { gateway^2 (deprecated) }
{$NODEFINE IPPROTO_TCP    }
  IPPROTO_TCP = 6; { tcp }
{$NODEFINE IPPROTO_PUP   }
  IPPROTO_PUP = 12; { pup }
{$NODEFINE IPPROTO_UDP   }
  IPPROTO_UDP = 17; { user datagram protocol }
{$NODEFINE IPPROTO_IDP   }
  IPPROTO_IDP = 22; { xns idp }
{$NODEFINE IPPROTO_ND    }
  IPPROTO_ND = 77; { UNOFFICIAL net disk proto }

{$NODEFINE IPPROTO_RAW   }
  IPPROTO_RAW = 255; { raw IP packet }
{$NODEFINE IPPROTO_MAX   }
  IPPROTO_MAX = 256;

{ Ports < IPPORT_RESERVED are reserved for
  privileged processes (e.g. root). }

{$NODEFINE IPPORT_RESERVED   }
  IPPORT_RESERVED = 1024;

{ Link numbers }

{$NODEFINE IMPLINK_IP        }
  IMPLINK_IP = 155;
{$NODEFINE IMPLINK_LOWEXPER  }
  IMPLINK_LOWEXPER = 156;
{$NODEFINE IMPLINK_HIGHEXPER }
  IMPLINK_HIGHEXPER = 158;

type
{$NODEFINE SunB}
  SunB = packed record
    s_b1, s_b2, s_b3, s_b4: u_char;
  end;

{$NODEFINE SunW}
  SunW = packed record
    s_w1, s_w2: u_short;
  end;

{$NODEFINE PInAddr}
  PInAddr = ^TInAddr;
{$NODEFINE in_addr}
  in_addr = record
    case integer of
      0: (S_un_b: SunB);
      1: (S_un_w: SunW);
      2: (S_addr: u_long);
  end;
{$NODEFINE TInAddr}
  TInAddr = in_addr;

{$NODEFINE PSockAddrIn}
  PSockAddrIn = ^TSockAddrIn;
{$NODEFINE sockaddr_in}
  sockaddr_in = record
    case Integer of
      0: (sin_family: u_short;
        sin_port: u_short;
        sin_addr: TInAddr;
        sin_zero: array[0..7] of Char);
      1: (sa_family: u_short;
        sa_data: array[0..13] of Char)
  end;
{$NODEFINE TSockAddrIn}
  TSockAddrIn = sockaddr_in;

const
{$NODEFINE INADDR_ANY      }
  INADDR_ANY = $00000000;
{$NODEFINE INADDR_LOOPBACK }
  INADDR_LOOPBACK = $7F000001;
{$NODEFINE INADDR_BROADCAST}
  INADDR_BROADCAST = $FFFFFFFF;
{$NODEFINE INADDR_NONE     }
  INADDR_NONE = $FFFFFFFF;

{$NODEFINE WSADESCRIPTION_LEN     }
  WSADESCRIPTION_LEN = 256;
{$NODEFINE WSASYS_STATUS_LEN      }
  WSASYS_STATUS_LEN = 128;

type
{$NODEFINE PWSAData}
  PWSAData = ^TWSAData;
{$NODEFINE WSAData}
  WSAData = record
    wVersion: Word;
    wHighVersion: Word;
    szDescription: array[0..WSADESCRIPTION_LEN] of Char;
    szSystemStatus: array[0..WSASYS_STATUS_LEN] of Char;
    iMaxSockets: Word;
    iMaxUdpDg: Word;
    lpVendorInfo: PChar;
  end;
{$NODEFINE TWSAData}
  TWSAData = WSAData;

{$NODEFINE PTransmitFileBuffers}
  PTransmitFileBuffers = ^TTransmitFileBuffers;
{$NODEFINE _TRANSMIT_FILE_BUFFERS}
  _TRANSMIT_FILE_BUFFERS = record
    Head: Pointer;
    HeadLength: DWORD;
    Tail: Pointer;
    TailLength: DWORD;
  end;
{$NODEFINE TTransmitFileBuffers}
  TTransmitFileBuffers = _TRANSMIT_FILE_BUFFERS;
{$NODEFINE TRANSMIT_FILE_BUFFERS}
  TRANSMIT_FILE_BUFFERS = _TRANSMIT_FILE_BUFFERS;

const
{$NODEFINE TF_DISCONNECT          }
  TF_DISCONNECT = $01;
{$NODEFINE TF_REUSE_SOCKET        }
  TF_REUSE_SOCKET = $02;
{$NODEFINE TF_WRITE_BEHIND        }
  TF_WRITE_BEHIND = $04;

{ Options for use with [gs]etsockopt at the IP level. }

{$NODEFINE IP_OPTIONS        }
  IP_OPTIONS = 1;
{$NODEFINE IP_MULTICAST_IF   }
  IP_MULTICAST_IF = 2; { set/get IP multicast interface   }
{$NODEFINE IP_MULTICAST_TTL  }
  IP_MULTICAST_TTL = 3; { set/get IP multicast timetolive  }
{$NODEFINE IP_MULTICAST_LOOP }
  IP_MULTICAST_LOOP = 4; { set/get IP multicast loopback    }
{$NODEFINE IP_ADD_MEMBERSHIP }
  IP_ADD_MEMBERSHIP = 5; { add  an IP group membership      }
{$NODEFINE IP_DROP_MEMBERSHIP}
  IP_DROP_MEMBERSHIP = 6; { drop an IP group membership      }
{$NODEFINE IP_TTL            }
  IP_TTL = 7; { set/get IP Time To Live          }
{$NODEFINE IP_TOS            }
  IP_TOS = 8; { set/get IP Type Of Service       }
{$NODEFINE IP_DONTFRAGMENT   }
  IP_DONTFRAGMENT = 9; { set/get IP Don't Fragment flag   }

{$NODEFINE IP_DEFAULT_MULTICAST_TTL }
  IP_DEFAULT_MULTICAST_TTL = 1; { normally limit m'casts to 1 hop  }
{$NODEFINE IP_DEFAULT_MULTICAST_LOOP}
  IP_DEFAULT_MULTICAST_LOOP = 1; { normally hear sends if a member  }
{$NODEFINE IP_MAX_MEMBERSHIPS       }
  IP_MAX_MEMBERSHIPS = 20; { per socket; must fit in one mbuf }

{ This is used instead of -1, since the
  TSocket type is unsigned.}

{$NODEFINE INVALID_SOCKET	}
  INVALID_SOCKET = TSocket(not (0));
{$NODEFINE SOCKET_ERROR		}
  SOCKET_ERROR = -1;

{ Types }

{$NODEFINE SOCK_STREAM   }
  SOCK_STREAM = 1; { stream socket }
{$NODEFINE SOCK_DGRAM    }
  SOCK_DGRAM = 2; { datagram socket }
{$NODEFINE SOCK_RAW      }
  SOCK_RAW = 3; { raw-protocol interface }
{$NODEFINE SOCK_RDM      }
  SOCK_RDM = 4; { reliably-delivered message }
{$NODEFINE SOCK_SEQPACKET}
  SOCK_SEQPACKET = 5; { sequenced packet stream }

{ Option flags per-socket. }

{$NODEFINE SO_DEBUG       }
  SO_DEBUG = $0001; { turn on debugging info recording }
{$NODEFINE SO_ACCEPTCONN  }
  SO_ACCEPTCONN = $0002; { socket has had listen() }
{$NODEFINE SO_REUSEADDR   }
  SO_REUSEADDR = $0004; { allow local address reuse }
{$NODEFINE SO_KEEPALIVE   }
  SO_KEEPALIVE = $0008; { keep connections alive }
{$NODEFINE SO_DONTROUTE   }
  SO_DONTROUTE = $0010; { just use interface addresses }
{$NODEFINE SO_BROADCAST   }
  SO_BROADCAST = $0020; { permit sending of broadcast msgs }
{$NODEFINE SO_USELOOPBACK }
  SO_USELOOPBACK = $0040; { bypass hardware when possible }
{$NODEFINE SO_LINGER      }
  SO_LINGER = $0080; { linger on close if data present }
{$NODEFINE SO_OOBINLINE   }
  SO_OOBINLINE = $0100; { leave received OOB data in line }

{$NODEFINE SO_DONTLINGER  =}
  SO_DONTLINGER = $FF7F;

{ Additional options. }

{$NODEFINE SO_SNDBUF      }
  SO_SNDBUF = $1001; { send buffer size }
{$NODEFINE SO_RCVBUF      }
  SO_RCVBUF = $1002; { receive buffer size }
{$NODEFINE SO_SNDLOWAT    }
  SO_SNDLOWAT = $1003; { send low-water mark }
{$NODEFINE SO_RCVLOWAT    }
  SO_RCVLOWAT = $1004; { receive low-water mark }
{$NODEFINE SO_SNDTIMEO    }
  SO_SNDTIMEO = $1005; { send timeout }
{$NODEFINE SO_RCVTIMEO    }
  SO_RCVTIMEO = $1006; { receive timeout }
{$NODEFINE SO_ERROR       }
  SO_ERROR = $1007; { get error status and clear }
{$NODEFINE SO_TYPE        }
  SO_TYPE = $1008; { get socket type }

{ Options for connect and disconnect data and options.  Used only by
  non-TCP/IP transports such as DECNet, OSI TP4, etc. }

{$NODEFINE SO_CONNDATA    }
  SO_CONNDATA = $7000;
{$NODEFINE SO_CONNOPT     }
  SO_CONNOPT = $7001;
{$NODEFINE SO_DISCDATA    }
  SO_DISCDATA = $7002;
{$NODEFINE SO_DISCOPT     }
  SO_DISCOPT = $7003;
{$NODEFINE SO_CONNDATALEN }
  SO_CONNDATALEN = $7004;
{$NODEFINE SO_CONNOPTLEN  }
  SO_CONNOPTLEN = $7005;
{$NODEFINE SO_DISCDATALEN }
  SO_DISCDATALEN = $7006;
{$NODEFINE SO_DISCOPTLEN  }
  SO_DISCOPTLEN = $7007;

{ Option for opening sockets for synchronous access. }

{$NODEFINE SO_OPENTYPE    }
  SO_OPENTYPE = $7008;

{$NODEFINE SO_SYNCHRONOUS_ALERT   }
  SO_SYNCHRONOUS_ALERT = $10;
{$NODEFINE SO_SYNCHRONOUS_NONALERT}
  SO_SYNCHRONOUS_NONALERT = $20;

{ Other NT-specific options. }

{$NODEFINE SO_MAXDG       }
  SO_MAXDG = $7009;
{$NODEFINE SO_MAXPATHDG   }
  SO_MAXPATHDG = $700A;
{$NODEFINE SO_UPDATE_ACCEPT_CONTEXT    }
  SO_UPDATE_ACCEPT_CONTEXT = $700B;
{$NODEFINE SO_CONNECT_TIME}
  SO_CONNECT_TIME = $700C;

{ TCP options. }

{$NODEFINE TCP_NODELAY    }
  TCP_NODELAY = $0001;
{$NODEFINE TCP_BSDURGENT  }
  TCP_BSDURGENT = $7000;

{ Address families. }

{$NODEFINE AF_UNSPEC     }
  AF_UNSPEC = 0; { unspecified }
{$NODEFINE AF_UNIX       }
  AF_UNIX = 1; { local to host (pipes, portals) }
{$NODEFINE AF_INET       }
  AF_INET = 2; { internetwork: UDP, TCP, etc. }
{$NODEFINE AF_IMPLINK    }
  AF_IMPLINK = 3; { arpanet imp addresses }
{$NODEFINE AF_PUP        }
  AF_PUP = 4; { pup protocols: e.g. BSP }
{$NODEFINE AF_CHAOS      }
  AF_CHAOS = 5; { mit CHAOS protocols }
{$NODEFINE AF_IPX        }
  AF_IPX = 6; { IPX and SPX }
{$NODEFINE AF_NS         }
  AF_NS = 6; { XEROX NS protocols }
{$NODEFINE AF_ISO        }
  AF_ISO = 7; { ISO protocols }
{$NODEFINE AF_OSI        }
  AF_OSI = AF_ISO; { OSI is ISO }
{$NODEFINE AF_ECMA       }
  AF_ECMA = 8; { european computer manufacturers }
{$NODEFINE AF_DATAKIT    }
  AF_DATAKIT = 9; { datakit protocols }
{$NODEFINE AF_CCITT      }
  AF_CCITT = 10; { CCITT protocols, X.25 etc }
{$NODEFINE AF_SNA        }
  AF_SNA = 11; { IBM SNA }
{$NODEFINE AF_DECnet     }
  AF_DECnet = 12; { DECnet }
{$NODEFINE AF_DLI        }
  AF_DLI = 13; { Direct data link interface }
{$NODEFINE AF_LAT        }
  AF_LAT = 14; { LAT }
{$NODEFINE AF_HYLINK     }
  AF_HYLINK = 15; { NSC Hyperchannel }
{$NODEFINE AF_APPLETALK  }
  AF_APPLETALK = 16; { AppleTalk }
{$NODEFINE AF_NETBIOS    }
  AF_NETBIOS = 17; { NetBios-style addresses }
{$NODEFINE AF_VOICEVIEW  }
  AF_VOICEVIEW = 18; { VoiceView }
{$NODEFINE AF_FIREFOX    }
  AF_FIREFOX = 19; { FireFox }
{$NODEFINE AF_UNKNOWN1   }
  AF_UNKNOWN1 = 20; { Somebody is using this! }
{$NODEFINE AF_BAN        }
  AF_BAN = 21; { Banyan }

{$NODEFINE AF_MAX        }
  AF_MAX = 22;

type
  { Structure used by kernel to store most addresses. }

{$NODEFINE PSOCKADDR}
  PSOCKADDR = ^TSockAddr;
{$NODEFINE TSockAddr}
  TSockAddr = sockaddr_in;

  { Structure used by kernel to pass protocol information in raw sockets. }
{$NODEFINE PSockProto}
  PSockProto = ^TSockProto;
{$NODEFINE sockproto}
  sockproto = record
    sp_family: u_short;
    sp_protocol: u_short;
  end;
{$NODEFINE TSockProto}
  TSockProto = sockproto;

const
{ Protocol families }

{$NODEFINE PF_UNSPEC     }
  PF_UNSPEC = AF_UNSPEC;
{$NODEFINE PF_UNIX       }
  PF_UNIX = AF_UNIX;
{$NODEFINE PF_INET       }
  PF_INET = AF_INET;
{$NODEFINE PF_IMPLINK    }
  PF_IMPLINK = AF_IMPLINK;
{$NODEFINE PF_PUP        }
  PF_PUP = AF_PUP;
{$NODEFINE PF_CHAOS      }
  PF_CHAOS = AF_CHAOS;
{$NODEFINE PF_NS         }
  PF_NS = AF_NS;
{$NODEFINE PF_IPX        }
  PF_IPX = AF_IPX;
{$NODEFINE PF_ISO        }
  PF_ISO = AF_ISO;
{$NODEFINE PF_OSI        }
  PF_OSI = AF_OSI;
{$NODEFINE PF_ECMA       }
  PF_ECMA = AF_ECMA;
{$NODEFINE PF_DATAKIT    }
  PF_DATAKIT = AF_DATAKIT;
{$NODEFINE PF_CCITT      }
  PF_CCITT = AF_CCITT;
{$NODEFINE PF_SNA        }
  PF_SNA = AF_SNA;
{$NODEFINE PF_DECnet     }
  PF_DECnet = AF_DECnet;
{$NODEFINE PF_DLI        }
  PF_DLI = AF_DLI;
{$NODEFINE PF_LAT        }
  PF_LAT = AF_LAT;
{$NODEFINE PF_HYLINK     }
  PF_HYLINK = AF_HYLINK;
{$NODEFINE PF_APPLETALK  }
  PF_APPLETALK = AF_APPLETALK;
{$NODEFINE PF_VOICEVIEW  }
  PF_VOICEVIEW = AF_VOICEVIEW;
{$NODEFINE PF_FIREFOX    }
  PF_FIREFOX = AF_FIREFOX;
{$NODEFINE PF_UNKNOWN1   }
  PF_UNKNOWN1 = AF_UNKNOWN1;
{$NODEFINE PF_BAN        }
  PF_BAN = AF_BAN;

{$NODEFINE PF_MAX        }
  PF_MAX = AF_MAX;

type
{ Structure used for manipulating linger option. }
{$NODEFINE PLinger}
  PLinger = ^TLinger;
{$NODEFINE linger}
  linger = record
    l_onoff: u_short;
    l_linger: u_short;
  end;
{$NODEFINE TLinger}
  TLinger = linger;

const
{ Level number for (get/set)sockopt() to apply to socket itself. }

{$NODEFINE SOL_SOCKET     }
  SOL_SOCKET = $FFFF; {options for socket level }

{ Maximum queue length specifiable by listen. }

{$NODEFINE SOMAXCONN     }
  SOMAXCONN = 5;

{$NODEFINE MSG_OOB        }
  MSG_OOB = $1; {process out-of-band data }
{$NODEFINE MSG_PEEK       }
  MSG_PEEK = $2; {peek at incoming message }
{$NODEFINE MSG_DONTROUTE  }
  MSG_DONTROUTE = $4; {send without using routing tables }

{$NODEFINE MSG_MAXIOVLEN }
  MSG_MAXIOVLEN = 16;

{$NODEFINE MSG_PARTIAL    }
  MSG_PARTIAL = $8000; {partial send or recv for message xport }

{ Define constant based on rfc883, used by gethostbyxxxx() calls. }

{$NODEFINE MAXGETHOSTSTRUCT      }
  MAXGETHOSTSTRUCT = 1024;

{ Define flags to be used with the WSAAsyncSelect() call. }

{$NODEFINE FD_READ        }
  FD_READ = $01;
{$NODEFINE FD_WRITE       }
  FD_WRITE = $02;
{$NODEFINE FD_OOB         }
  FD_OOB = $04;
{$NODEFINE FD_ACCEPT      }
  FD_ACCEPT = $08;
{$NODEFINE FD_CONNECT     }
  FD_CONNECT = $10;
{$NODEFINE FD_CLOSE       }
  FD_CLOSE = $20;

{ All Windows Sockets error constants are biased by WSABASEERR from the "normal" }

{$NODEFINE WSABASEERR}
  WSABASEERR = 10000;

{ Windows Sockets definitions of regular Microsoft C error constants }

{$NODEFINE WSAEINTR                }
  WSAEINTR = (WSABASEERR + 4);
{$NODEFINE WSAEBADF                }
  WSAEBADF = (WSABASEERR + 9);
{$NODEFINE WSAEACCES               }
  WSAEACCES = (WSABASEERR + 13);
{$NODEFINE WSAEFAULT               }
  WSAEFAULT = (WSABASEERR + 14);
{$NODEFINE WSAEINVAL               }
  WSAEINVAL = (WSABASEERR + 22);
{$NODEFINE WSAEMFILE               }
  WSAEMFILE = (WSABASEERR + 24);

  { Windows Sockets definitions of regular Berkeley error constants }

{$NODEFINE WSAEWOULDBLOCK          }
  WSAEWOULDBLOCK = (WSABASEERR + 35);
{$NODEFINE WSAEINPROGRESS          }
  WSAEINPROGRESS = (WSABASEERR + 36);
{$NODEFINE WSAEALREADY             }
  WSAEALREADY = (WSABASEERR + 37);
{$NODEFINE WSAENOTSOCK             }
  WSAENOTSOCK = (WSABASEERR + 38);
{$NODEFINE WSAEDESTADDRREQ         }
  WSAEDESTADDRREQ = (WSABASEERR + 39);
{$NODEFINE WSAEMSGSIZE             }
  WSAEMSGSIZE = (WSABASEERR + 40);
{$NODEFINE WSAEPROTOTYPE           }
  WSAEPROTOTYPE = (WSABASEERR + 41);
{$NODEFINE WSAENOPROTOOPT          }
  WSAENOPROTOOPT = (WSABASEERR + 42);
{$NODEFINE WSAEPROTONOSUPPORT      }
  WSAEPROTONOSUPPORT = (WSABASEERR + 43);
{$NODEFINE WSAESOCKTNOSUPPORT      }
  WSAESOCKTNOSUPPORT = (WSABASEERR + 44);
{$NODEFINE WSAEOPNOTSUPP           }
  WSAEOPNOTSUPP = (WSABASEERR + 45);
{$NODEFINE WSAEPFNOSUPPORT         }
  WSAEPFNOSUPPORT = (WSABASEERR + 46);
{$NODEFINE WSAEAFNOSUPPORT         }
  WSAEAFNOSUPPORT = (WSABASEERR + 47);
{$NODEFINE WSAEADDRINUSE           }
  WSAEADDRINUSE = (WSABASEERR + 48);
{$NODEFINE WSAEADDRNOTAVAIL        }
  WSAEADDRNOTAVAIL = (WSABASEERR + 49);
{$NODEFINE WSAENETDOWN             }
  WSAENETDOWN = (WSABASEERR + 50);
{$NODEFINE WSAENETUNREACH          }
  WSAENETUNREACH = (WSABASEERR + 51);
{$NODEFINE WSAENETRESET            }
  WSAENETRESET = (WSABASEERR + 52);
{$NODEFINE WSAECONNABORTED         }
  WSAECONNABORTED = (WSABASEERR + 53);
{$NODEFINE WSAECONNRESET           }
  WSAECONNRESET = (WSABASEERR + 54);
{$NODEFINE WSAENOBUFS              }
  WSAENOBUFS = (WSABASEERR + 55);
{$NODEFINE WSAEISCONN              }
  WSAEISCONN = (WSABASEERR + 56);
{$NODEFINE WSAENOTCONN             }
  WSAENOTCONN = (WSABASEERR + 57);
{$NODEFINE WSAESHUTDOWN            }
  WSAESHUTDOWN = (WSABASEERR + 58);
{$NODEFINE WSAETOOMANYREFS         }
  WSAETOOMANYREFS = (WSABASEERR + 59);
{$NODEFINE WSAETIMEDOUT            }
  WSAETIMEDOUT = (WSABASEERR + 60);
{$NODEFINE WSAECONNREFUSED         }
  WSAECONNREFUSED = (WSABASEERR + 61);
{$NODEFINE WSAELOOP                }
  WSAELOOP = (WSABASEERR + 62);
{$NODEFINE WSAENAMETOOLONG         }
  WSAENAMETOOLONG = (WSABASEERR + 63);
{$NODEFINE WSAEHOSTDOWN            }
  WSAEHOSTDOWN = (WSABASEERR + 64);
{$NODEFINE WSAEHOSTUNREACH         }
  WSAEHOSTUNREACH = (WSABASEERR + 65);
{$NODEFINE WSAENOTEMPTY            }
  WSAENOTEMPTY = (WSABASEERR + 66);
{$NODEFINE WSAEPROCLIM             }
  WSAEPROCLIM = (WSABASEERR + 67);
{$NODEFINE WSAEUSERS               }
  WSAEUSERS = (WSABASEERR + 68);
{$NODEFINE WSAEDQUOT               }
  WSAEDQUOT = (WSABASEERR + 69);
{$NODEFINE WSAESTALE               }
  WSAESTALE = (WSABASEERR + 70);
{$NODEFINE WSAEREMOTE              }
  WSAEREMOTE = (WSABASEERR + 71);

{$NODEFINE WSAEDISCON              }
  WSAEDISCON = (WSABASEERR + 101);

{ Extended Windows Sockets error constant definitions }

{$NODEFINE WSASYSNOTREADY          }
  WSASYSNOTREADY = (WSABASEERR + 91);
{$NODEFINE WSAVERNOTSUPPORTED      }
  WSAVERNOTSUPPORTED = (WSABASEERR + 92);
{$NODEFINE WSANOTINITIALISED       }
  WSANOTINITIALISED = (WSABASEERR + 93);

{ Error return codes from gethostbyname() and gethostbyaddr()
  (when using the resolver). Note that these errors are
  retrieved via WSAGetLastError() and must therefore follow
  the rules for avoiding clashes with error numbers from
  specific implementations or language run-time systems.
  For this reason the codes are based at WSABASEERR+1001.
  Note also that [WSA]NO_ADDRESS is defined only for
  compatibility purposes. }

{ Authoritative Answer: Host not found }

{$NODEFINE WSAHOST_NOT_FOUND       }
  WSAHOST_NOT_FOUND = (WSABASEERR + 1001);
{$NODEFINE HOST_NOT_FOUND         }
  HOST_NOT_FOUND = WSAHOST_NOT_FOUND;

{ Non-Authoritative: Host not found, or SERVERFAIL }

{$NODEFINE WSATRY_AGAIN            }
  WSATRY_AGAIN = (WSABASEERR + 1002);
{$NODEFINE TRY_AGAIN              }
  TRY_AGAIN = WSATRY_AGAIN;

{ Non recoverable errors, FORMERR, REFUSED, NOTIMP }

{$NODEFINE WSANO_RECOVERY          }
  WSANO_RECOVERY = (WSABASEERR + 1003);
{$NODEFINE NO_RECOVERY            }
  NO_RECOVERY = WSANO_RECOVERY;

{ Valid name, no data record of requested type }

{$NODEFINE WSANO_DATA              }
  WSANO_DATA = (WSABASEERR + 1004);
{$NODEFINE NO_DATA                }
  NO_DATA = WSANO_DATA;

{ no address, look for MX record }

{$NODEFINE WSANO_ADDRESS          }
  WSANO_ADDRESS = WSANO_DATA;
{$NODEFINE NO_ADDRESS             }
  NO_ADDRESS = WSANO_ADDRESS;

{ Windows Sockets errors redefined as regular Berkeley error constants.
  These are commented out in Windows NT to avoid conflicts with errno.h.
  Use the WSA constants instead. }

{$NODEFINE EWOULDBLOCK        }
  EWOULDBLOCK = WSAEWOULDBLOCK;
{$NODEFINE EINPROGRESS        }
  EINPROGRESS = WSAEINPROGRESS;
{$NODEFINE EALREADY           }
  EALREADY = WSAEALREADY;
{$NODEFINE ENOTSOCK           }
  ENOTSOCK = WSAENOTSOCK;
{$NODEFINE EDESTADDRREQ       }
  EDESTADDRREQ = WSAEDESTADDRREQ;
{$NODEFINE EMSGSIZE           }
  EMSGSIZE = WSAEMSGSIZE;
{$NODEFINE EPROTOTYPE         }
  EPROTOTYPE = WSAEPROTOTYPE;
{$NODEFINE ENOPROTOOPT        }
  ENOPROTOOPT = WSAENOPROTOOPT;
{$NODEFINE EPROTONOSUPPORT    }
  EPROTONOSUPPORT = WSAEPROTONOSUPPORT;
{$NODEFINE ESOCKTNOSUPPORT    }
  ESOCKTNOSUPPORT = WSAESOCKTNOSUPPORT;
{$NODEFINE EOPNOTSUPP         }
  EOPNOTSUPP = WSAEOPNOTSUPP;
{$NODEFINE EPFNOSUPPORT       }
  EPFNOSUPPORT = WSAEPFNOSUPPORT;
{$NODEFINE EAFNOSUPPORT       }
  EAFNOSUPPORT = WSAEAFNOSUPPORT;
{$NODEFINE EADDRINUSE         }
  EADDRINUSE = WSAEADDRINUSE;
{$NODEFINE EADDRNOTAVAIL      }
  EADDRNOTAVAIL = WSAEADDRNOTAVAIL;
{$NODEFINE ENETDOWN           }
  ENETDOWN = WSAENETDOWN;
{$NODEFINE ENETUNREACH        }
  ENETUNREACH = WSAENETUNREACH;
{$NODEFINE ENETRESET          }
  ENETRESET = WSAENETRESET;
{$NODEFINE ECONNABORTED       }
  ECONNABORTED = WSAECONNABORTED;
{$NODEFINE ECONNRESET         }
  ECONNRESET = WSAECONNRESET;
{$NODEFINE ENOBUFS            }
  ENOBUFS = WSAENOBUFS;
{$NODEFINE EISCONN            }
  EISCONN = WSAEISCONN;
{$NODEFINE ENOTCONN           }
  ENOTCONN = WSAENOTCONN;
{$NODEFINE ESHUTDOWN          }
  ESHUTDOWN = WSAESHUTDOWN;
{$NODEFINE ETOOMANYREFS       }
  ETOOMANYREFS = WSAETOOMANYREFS;
{$NODEFINE ETIMEDOUT          }
  ETIMEDOUT = WSAETIMEDOUT;
{$NODEFINE ECONNREFUSED       }
  ECONNREFUSED = WSAECONNREFUSED;
{$NODEFINE ELOOP              }
  ELOOP = WSAELOOP;
{$NODEFINE ENAMETOOLONG       }
  ENAMETOOLONG = WSAENAMETOOLONG;
{$NODEFINE EHOSTDOWN          }
  EHOSTDOWN = WSAEHOSTDOWN;
{$NODEFINE EHOSTUNREACH       }
  EHOSTUNREACH = WSAEHOSTUNREACH;
{$NODEFINE ENOTEMPTY          }
  ENOTEMPTY = WSAENOTEMPTY;
{$NODEFINE EPROCLIM           }
  EPROCLIM = WSAEPROCLIM;
{$NODEFINE EUSERS             }
  EUSERS = WSAEUSERS;
{$NODEFINE EDQUOT             }
  EDQUOT = WSAEDQUOT;
{$NODEFINE ESTALE             }
  ESTALE = WSAESTALE;
{$NODEFINE EREMOTE            }
  EREMOTE = WSAEREMOTE;

{ Socket function prototypes }
type
{$NODEFINE TAcceptProc}
  TAcceptProc = function(s: TSocket; addr: PSockAddr; addrlen: PInteger):
    TSocket; stdcall;
{$NODEFINE TBindProc}
  TBindProc = function(s: TSocket; var addr: TSockAddr; namelen: Integer):
    Integer; stdcall;
{$NODEFINE TClosesocketProc}
  TClosesocketProc = function(s: TSocket): Integer; stdcall;
{$NODEFINE TConnectProc}
  TConnectProc = function(s: TSocket; var name: TSockAddr; namelen: Integer):
    Integer; stdcall;
{$NODEFINE TIoctlSocketProc}
  TIoctlSocketProc = function(s: TSocket; cmd: DWORD; var arg: u_long): Integer;
    stdcall;
{$NODEFINE TGetPeerNameProc}
  TGetPeerNameProc = function(s: TSocket; var name: TSockAddr; var namelen:
    Integer): Integer; stdcall;
{$NODEFINE TGetSockNameProc}
  TGetSockNameProc = function(s: TSocket; var name: TSockAddr; var namelen:
    Integer): Integer; stdcall;
{$NODEFINE TGetSockOptProc }
  TGetSockOptProc = function(s: TSocket; level, optname: Integer; optval: PChar;
    var optlen: Integer): Integer; stdcall;
{$NODEFINE THtonlProc}
  THtonlProc = function(hostlong: u_long): u_long; stdcall;
{$NODEFINE THtonsProc}
  THtonsProc = function(hostshort: u_short): u_short; stdcall;
{$NODEFINE TInet_AddrProc}
  TInet_AddrProc = function(cp: PChar): u_long; stdcall; {PInAddr;} { TInAddr }
{$NODEFINE TInet_NtoaProc}
  TInet_NtoaProc = function(inaddr: TInAddr): PChar; stdcall;
{$NODEFINE TListenProc}
  TListenProc = function(s: TSocket; backlog: Integer): Integer; stdcall;
{$NODEFINE TNtohlProc}
  TNtohlProc = function(netlong: u_long): u_long; stdcall;
{$NODEFINE TNtohsProc}
  TNtohsProc = function(netshort: u_short): u_short; stdcall;
{$NODEFINE TRecvProc}
  TRecvProc = function(s: TSocket; var Buf; len, flags: Integer): Integer;
    stdcall;
{$NODEFINE TRecvFromProc}
  TRecvFromProc = function(s: TSocket; var Buf; len, flags: Integer;
    var from: TSockAddr; var fromlen: Integer): Integer; stdcall;
{$NODEFINE TSelectProc}
  TSelectProc = function(nfds: Integer; readfds, writefds, exceptfds: PFDSet;
    timeout: PTimeVal): Longint; stdcall;
{$NODEFINE TSendProc}
  TSendProc = function(s: TSocket; var Buf; len, flags: Integer): Integer;
    stdcall;
{$NODEFINE TSendToProc}
  TSendToProc = function(s: TSocket; var Buf; len, flags: Integer; var addrto:
    TSockAddr;
    tolen: Integer): Integer; stdcall;
{$NODEFINE TSetSockOptProc}
  TSetSockOptProc = function(s: TSocket; level, optname: Integer; optval: PChar;
    optlen: Integer): Integer; stdcall;
{$NODEFINE TShutDownProc}
  TShutDownProc = function(s: TSocket; how: Integer): Integer; stdcall;
{$NODEFINE TSocketProc}
  TSocketProc = function(af, Struct, protocol: Integer): TSocket; stdcall;
{$NODEFINE TGetHostByAddrProc}
  TGetHostByAddrProc = function(addr: Pointer; len, Struct: Integer): PHostEnt;
    stdcall;
{$NODEFINE TGetHostByNameProc}
  TGetHostByNameProc = function(name: PChar): PHostEnt; stdcall;
{$NODEFINE TGetHostNameProc}
  TGetHostNameProc = function(name: PChar; len: Integer): Integer; stdcall;
{$NODEFINE TGetServByPortProc}
  TGetServByPortProc = function(port: Integer; proto: PChar): PServEnt; stdcall;
{$NODEFINE TGetServByNameProc}
  TGetServByNameProc = function(name, proto: PChar): PServEnt; stdcall;
{$NODEFINE TgetProtoByNumberProc}
  TgetProtoByNumberProc = function(proto: Integer): PProtoEnt; stdcall;
{$NODEFINE TGetProtoByNameProc}
  TGetProtoByNameProc = function(name: PChar): PProtoEnt; stdcall;
{$NODEFINE TWSAStartupProc}
  TWSAStartupProc = function(wVersionRequired: word; var WSData: TWSAData):
    Integer; stdcall;
{$NODEFINE TWSACleanupProc}
  TWSACleanupProc = function: Integer; stdcall;
{$NODEFINE TWSASetLastErrorProc}
  TWSASetLastErrorProc = procedure(iError: Integer); stdcall;
{$NODEFINE TWSAGetLastErrorProc}
  TWSAGetLastErrorProc = function: Integer; stdcall;
{$NODEFINE TWSAIsBlockingProc}
  TWSAIsBlockingProc = function: BOOL; stdcall;
{$NODEFINE TWSAUnhookBlockingHookProc}
  TWSAUnhookBlockingHookProc = function: Integer; stdcall;
{$NODEFINE TWSASetBlockingHookProc}
  TWSASetBlockingHookProc = function(lpBlockFunc: TFarProc): TFarProc; stdcall;
{$NODEFINE TWSACancelBlockingCallProc}
  TWSACancelBlockingCallProc = function: Integer; stdcall;
{$NODEFINE TWSAAsyncGetServByNameProc}
  TWSAAsyncGetServByNameProc = function(HWindow: HWND; wMsg: u_int;
    name, proto, buf: PChar; buflen: Integer): THandle; stdcall;
{$NODEFINE TWSAAsyncGetServByPortProc}
  TWSAAsyncGetServByPortProc = function(HWindow: HWND; wMsg, port: u_int;
    proto, buf: PChar; buflen: Integer): THandle; stdcall;
{$NODEFINE TWSAAsyncGetProtoByNameProc}
  TWSAAsyncGetProtoByNameProc = function(HWindow: HWND; wMsg: u_int;
    name, buf: PChar; buflen: Integer): THandle; stdcall;
{$NODEFINE TWSAAsyncGetProtoByNumberProc}
  TWSAAsyncGetProtoByNumberProc = function(HWindow: HWND; wMsg: u_int; number:
    Integer;
    buf: PChar; buflen: Integer): THandle; stdcall;
{$NODEFINE TWSAAsyncGetHostByNameProc}
  TWSAAsyncGetHostByNameProc = function(HWindow: HWND; wMsg: u_int;
    name, buf: PChar; buflen: Integer): THandle; stdcall;
{$NODEFINE TWSAAsyncGetHostByAddrProc}
  TWSAAsyncGetHostByAddrProc = function(HWindow: HWND; wMsg: u_int; addr: PChar;
    len, Struct: Integer; buf: PChar; buflen: Integer): THandle; stdcall;
{$NODEFINE TWSACancelAsyncRequestProc}
  TWSACancelAsyncRequestProc = function(hAsyncTaskHandle: THandle): Integer;
    stdcall;
{$NODEFINE TWSAAsyncSelectProc}
  TWSAAsyncSelectProc = function(s: TSocket; HWindow: HWND; wMsg: u_int; lEvent:
    Longint): Integer; stdcall;
{$NODEFINE TWSARecvExProc}
  TWSARecvExProc = function(s: TSocket; var buf; len: Integer; var flags:
    Integer): Integer; stdcall;
{$NODEFINE T__WSAFDIsSetProc}
  T__WSAFDIsSetProc = function(s: TSocket; var FDSet: TFDSet): Bool; stdcall;
{$NODEFINE TTransmitFileProc}
  TTransmitFileProc = function(hSocket: TSocket; hFile: THandle;
    nNumberOfBytesToWrite: DWORD;
    nNumberOfBytesPerSend: DWORD; lpOverlapped: POverlapped;
    lpTransmitBuffers: PTransmitFileBuffers; dwReserved: DWORD): BOOL; stdcall;
{$NODEFINE TAcceptExProc}
  TAcceptExProc = function(sListenSocket, sAcceptSocket: TSocket;
    lpOutputBuffer: Pointer; dwReceiveDataLength, dwLocalAddressLength,
    dwRemoteAddressLength: DWORD; var lpdwBytesReceived: DWORD;
    lpOverlapped: POverlapped): BOOL; stdcall;
{$NODEFINE TGetAcceptExSockaddrsProc}
  TGetAcceptExSockaddrsProc = procedure(lpOutputBuffer: Pointer;
    dwReceiveDataLength, dwLocalAddressLength, dwRemoteAddressLength: DWORD;
    var LocalSockaddr: TSockAddr; var LocalSockaddrLength: Integer;
    var RemoteSockaddr: TSockAddr; var RemoteSockaddrLength: Integer); stdcall;

var
{$NODEFINE Accept}
  Accept: TAcceptProc = nil;
{$NODEFINE Bind  }
  Bind: TBindProc = nil;
{$NODEFINE CloseSocket}
  CloseSocket: TCloseSocketProc = nil;
{$NODEFINE Connect}
  Connect: TConnectProc = nil;
{$NODEFINE IoctlSocket}
  IoctlSocket: TIoctlSocketProc = nil;
{$NODEFINE GetPeerName}
  GetPeerName: TGetPeerNameProc = nil;
{$NODEFINE GetSockName}
  GetSockName: TGetSockNameProc = nil;
{$NODEFINE GetSockOpt }
  GetSockOpt: TGetSockOptProc = nil;
{$NODEFINE Htonl}
  Htonl: THtonlProc = nil;
{$NODEFINE Htons}
  Htons: THtonsProc = nil;
{$NODEFINE Inet_Addr}
  Inet_Addr: TInet_AddrProc = nil;
{$NODEFINE Inet_Ntoa}
  Inet_Ntoa: TInet_NtoaProc = nil;
{$NODEFINE Listen}
  Listen: TListenProc = nil;
{$NODEFINE Ntohl}
  Ntohl: TNtohlProc = nil;
{$NODEFINE Ntohs}
  Ntohs: TNtohsProc = nil;
{$NODEFINE Recv }
  Recv: TRecvProc = nil;
{$NODEFINE RecvFrom}
  RecvFrom: TRecvFromProc = nil;
{$NODEFINE Select}
  Select: TSelectProc = nil;
{$NODEFINE Send}
  Send: TSendProc = nil;
{$NODEFINE SendTo}
  SendTo: TSendToProc = nil;
{$NODEFINE SetSockOpt}
  SetSockOpt: TSetSockOptProc = nil;
{$NODEFINE ShutDown}
  ShutDown: TShutDownProc = nil;
{$NODEFINE Socket}
  Socket: TSocketProc = nil;
{$NODEFINE GetHostByAddr}
  GetHostByAddr: TGetHostByAddrProc = nil;
{$NODEFINE GetHostByName}
  GetHostByName: TGetHostByNameProc = nil;
{$NODEFINE GetHostName}
  GetHostName: TGetHostNameProc = nil;
{$NODEFINE GetServByPort}
  GetServByPort: TGetServByPortProc = nil;
{$NODEFINE GetServByName}
  GetServByName: TGetServByNameProc = nil;
{$NODEFINE GetProtoByNumber}
  GetProtoByNumber: TGetProtoByNumberProc = nil;
{$NODEFINE GetProtoByname}
  GetProtoByname: TGetProtoByNameProc = nil;
{$NODEFINE WSAStartup}
  WSAStartup: TWSAStartupProc = nil;
{$NODEFINE WSACleanup}
  WSACleanup: TWSACleanupProc = nil;
{$NODEFINE WSASetLastError}
  WSASetLastError: TWSASetLastErrorProc = nil;
{$NODEFINE WSAGetLastError}
  WSAGetLastError: TWSAGetLastErrorProc = nil;
{$NODEFINE WSAIsBlocking}
  WSAIsBlocking: TWSAIsBlockingProc = nil;
{$NODEFINE WSAUnhookBlockingHook}
  WSAUnhookBlockingHook: TWSAUnhookBlockingHookProc = nil;
{$NODEFINE WSASetBlockingHook}
  WSASetBlockingHook: TWSASetBlockingHookProc = nil;
{$NODEFINE WSACancelBlockingCall}
  WSACancelBlockingCall: TWSACancelBlockingCallProc = nil;
{$NODEFINE WSAAsyncGetServByName}
  WSAAsyncGetServByName: TWSAAsyncGetServByNameProc = nil;
{$NODEFINE WSAAsyncGetServByPort}
  WSAAsyncGetServByPort: TWSAAsyncGetServByPortProc = nil;
{$NODEFINE WSAAsyncGetProtoByName}
  WSAAsyncGetProtoByName: TWSAAsyncGetProtoByNameProc = nil;
{$NODEFINE WSAAsyncGetProtoByNumber}
  WSAAsyncGetProtoByNumber: TWSAAsyncGetProtoByNumberProc = nil;
{$NODEFINE WSAAsyncGetHostByName}
  WSAAsyncGetHostByName: TWSAAsyncGetHostByNameProc = nil;
{$NODEFINE WSAAsyncGetHostByAddr}
  WSAAsyncGetHostByAddr: TWSAAsyncGetHostByAddrProc = nil;
{$NODEFINE WSACancelAsyncRequest}
  WSACancelAsyncRequest: TWSACancelAsyncRequestProc = nil;
{$NODEFINE WSAAsyncSelect}
  WSAAsyncSelect: TWSAAsyncSelectProc = nil;
{$NODEFINE WSARecvEx}
  WSARecvEx: TWSARecvExProc = nil;
{$NODEFINE __WSAFDIsSet}
  __WSAFDIsSet: T__WSAFDIsSetProc = nil;
{$NODEFINE TransmitFile}
  TransmitFile: TTransmitFileProc = nil;
{$NODEFINE AcceptEx}
  AcceptEx: TAcceptExProc = nil;
{$NODEFINE GetAcceptExSockaddrs}
  GetAcceptExSockaddrs: TGetAcceptExSockaddrsProc = nil;

{$NODEFINE WSAMakeSyncReply}
function WSAMakeSyncReply(Buflen, Error: Word): Longint;
{$NODEFINE WSAMakeSelectReply}
function WSAMakeSelectReply(Event, Error: Word): Longint;
{$NODEFINE WSAGetAsyncBuflen}
function WSAGetAsyncBuflen(Param: Longint): Word;
{$NODEFINE WSAGetAsyncError}
function WSAGetAsyncError(Param: Longint): Word;
{$NODEFINE WSAGetSelectEvent}
function WSAGetSelectEvent(Param: Longint): Word;
{$NODEFINE WSAGetSelectError}
function WSAGetSelectError(Param: Longint): Word;

{$NODEFINE FD_CLR}
procedure FD_CLR(Socket: TSocket; var FDSet: TFDSet);
{$NODEFINE FD_ISSET}
function FD_ISSET(Socket: TSocket; var FDSet: TFDSet): Boolean;
{$NODEFINE FD_SET}
procedure FD_SET(Socket: TSocket; var FDSet: TFDSet);
{$NODEFINE FD_ZERO}
procedure FD_ZERO(var FDSet: TFDSet);

  {Winsock dynamic load management routines}
{$NODEFINE LoadWinsock}
procedure LoadWinsock;
{$NODEFINE WinsockLoaded :}
function WinsockLoaded: Boolean;
{$NODEFINE UnloadWinsock}
procedure UnloadWinsock;

(*type
{$NODEFINE EIdStackCanNotLoadWinsock}
  EIdStackCanNotLoadWinsock = class(EIdException);
 *)
implementation

uses
  IdResourceStrings;

const
  DLLStackName = 'wsock32.dll';

var
  LibHandle: THandle = 0;

function WSAMakeSyncReply;
begin
  WSAMakeSyncReply := MakeLong(Buflen, Error);
end;

function WSAMakeSelectReply;
begin
  WSAMakeSelectReply := MakeLong(Event, Error);
end;

function WSAGetAsyncBuflen;
begin
  WSAGetAsyncBuflen := LOWORD(Param);
end;

function WSAGetAsyncError;
begin
  WSAGetAsyncError := HIWORD(Param);
end;

function WSAGetSelectEvent;
begin
  WSAGetSelectEvent := LOWORD(Param);
end;

function WSAGetSelectError;
begin
  WSAGetSelectError := HIWORD(Param);
end;

procedure FD_CLR(Socket: TSocket; var FDSet: TFDSet);
var
  I: Integer;
begin
  I := 0;
  while I < FDSet.fd_count do
  begin
    if FDSet.fd_array[I] = Socket then
    begin
      while I < FDSet.fd_count - 1 do
      begin
        FDSet.fd_array[I] := FDSet.fd_array[I + 1];
        Inc(I);
      end;
      Dec(FDSet.fd_count);
      Break;
    end;
    Inc(I);
  end;
end;

function FD_ISSET(Socket: TSocket; var FDSet: TFDSet): Boolean;
begin
  Result := __WSAFDIsSet(Socket, FDSet);
end;

procedure FD_SET(Socket: TSocket; var FDSet: TFDSet);
begin
  if FDSet.fd_count < FD_SETSIZE then
  begin
    FDSet.fd_array[FDSet.fd_count] := Socket;
    Inc(FDSet.fd_count);
  end;
end;

procedure FD_ZERO(var FDSet: TFDSet);
begin
  FDSet.fd_count := 0;
end;

procedure LoadWinsock;
begin
  LibHandle := Windows.LoadLibrary(PChar(DLLStackName));
  if LibHandle <> 0 then
  begin
    Accept := Windows.GetProcAddress(LibHandle, PChar('accept'));
    Bind := Windows.GetProcAddress(LibHandle, PChar('bind'));
    CloseSocket := Windows.GetProcAddress(LibHandle, PChar('closesocket'));
    Connect := Windows.GetProcAddress(LibHandle, PChar('connect'));
    GetPeerName := Windows.GetProcAddress(LibHandle, PChar('getpeername'));
    GetSockName := Windows.GetProcAddress(LibHandle, PChar('getsockname'));
    GetSockOpt := Windows.GetProcAddress(LibHandle, PChar('getsockopt'));
    Htonl := Windows.GetProcAddress(LibHandle, PChar('htonl'));
    Htons := Windows.GetProcAddress(LibHandle, PChar('htons'));
    Inet_Addr := Windows.GetProcAddress(LibHandle, PChar('inet_addr'));
    Inet_Ntoa := Windows.GetProcAddress(LibHandle, PChar('inet_ntoa'));
    IoctlSocket := Windows.GetProcAddress(LibHandle, PChar('ioctlsocket'));
    Listen := Windows.GetProcAddress(LibHandle, PChar('listen'));
    Ntohl := Windows.GetProcAddress(LibHandle, PChar('ntohl'));
    Ntohs := Windows.GetProcAddress(LibHandle, PChar('ntohs'));
    Recv := Windows.GetProcAddress(LibHandle, PChar('recv'));
    RecvFrom := Windows.GetProcAddress(LibHandle, PChar('recvfrom'));
    Select := Windows.GetProcAddress(LibHandle, PChar('select'));
    Send := Windows.GetProcAddress(LibHandle, PChar('send'));
    SendTo := Windows.GetProcAddress(LibHandle, PChar('sendto'));
    SetSockOpt := Windows.GetProcAddress(LibHandle, PChar('setsockopt'));
    ShutDown := Windows.GetProcAddress(LibHandle, PChar('shutdown'));
    Socket := Windows.GetProcAddress(LibHandle, PChar('socket'));

    GetHostByAddr := Windows.GetProcAddress(LibHandle, PChar('gethostbyaddr'));
    GetHostByName := Windows.GetProcAddress(LibHandle, PChar('gethostbyname'));
    GetProtoByName := Windows.GetProcAddress(LibHandle,
      PChar('getprotobyname'));
    GetProtoByNumber := Windows.GetProcAddress(LibHandle,
      PChar('getprotobynumber'));
    GetServByName := Windows.GetProcAddress(LibHandle, PChar('getservbyname'));
    GetServByPort := Windows.GetProcAddress(LibHandle, PChar('getservbyport'));
    GetHostName := Windows.GetProcAddress(LibHandle, PChar('gethostname'));

    WSAAsyncSelect := Windows.GetProcAddress(LibHandle,
      PChar('WSAAsyncSelect'));
    WSARecvEx := Windows.GetProcAddress(LibHandle, PChar('WSARecvEx'));
    WSAAsyncGetHostByAddr := Windows.GetProcAddress(LibHandle,
      PChar('WSAAsyncGetHostByAddr'));
    WSAAsyncGetHostByName := Windows.GetProcAddress(LibHandle,
      PChar('WSAAsyncGetHostByName'));
    WSAAsyncGetProtoByNumber := Windows.GetProcAddress(LibHandle,
      PChar('WSAAsyncGetProtoByNumber'));
    WSAAsyncGetProtoByName := Windows.GetProcAddress(LibHandle,
      PChar('WSAAsyncGetProtoByName'));
    WSAAsyncGetServByPort := Windows.GetProcAddress(LibHandle,
      PChar('WSAAsyncGetServByPort'));
    WSAAsyncGetServByName := Windows.GetProcAddress(LibHandle,
      PChar('WSAAsyncGetServByName'));
    WSACancelAsyncRequest := Windows.GetProcAddress(LibHandle,
      PChar('WSACancelAsyncRequest'));
    WSASetBlockingHook := Windows.GetProcAddress(LibHandle,
      PChar('WSASetBlockingHook'));
    WSAUnhookBlockingHook := Windows.GetProcAddress(LibHandle,
      PChar('WSAUnhookBlockingHook'));
    WSAGetLastError := Windows.GetProcAddress(LibHandle,
      PChar('WSAGetLastError'));
    WSASetLastError := Windows.GetProcAddress(LibHandle,
      PChar('WSASetLastError'));
    WSACancelBlockingCall := Windows.GetProcAddress(LibHandle,
      PChar('WSACancelBlockingCall'));
    WSAIsBlocking := Windows.GetProcAddress(LibHandle, PChar('WSAIsBlocking'));
    WSAStartup := Windows.GetProcAddress(LibHandle, PChar('WSAStartup'));
    WSACleanup := Windows.GetProcAddress(LibHandle, PChar('WSACleanup'));
    __WSAFDIsSet := Windows.GetProcAddress(LibHandle, PChar('__WSAFDIsSet'));

    TransmitFile := Windows.GetProcAddress(LibHandle, PChar('TransmitFile'));
    AcceptEx := Windows.GetProcAddress(LibHandle, PChar('AcceptEx'));
    GetAcceptExSockaddrs := Windows.GetProcAddress(LibHandle,
      PChar('GetAcceptExSockaddrs'));
  end
  else
  begin
{    raise EIdStackCanNotLoadWinsock.CreateFmt(RSCouldNotLoad, [DLLStackName]);}
  end;
end;

procedure UnloadWinsock;
begin
  if LibHandle <> 0 then
  begin
    Windows.FreeLibrary(libHandle);
  end;
  LibHandle := 0;
end;

function WinsockLoaded: Boolean;
begin
  Result := (LibHandle <> 0);
end;

end.
