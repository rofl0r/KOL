unit Lnk;
{* Additional unit. Has two procedures to get system folder by its CSIDL and
   to create shortcut to the specified file object. Sources are from public place.
   Actually, made on base of sample from MSDN.
   Adapted to use with KOL.  }

interface

uses windows, shlobj, ShellAPI, ActiveX, {OLE2,} KOL;

function GetSystemFolder(Const Folder:integer):string;
{* Returns specified system folder location. Following constant can be passed
   as a parameter:
|<pre>
  CSIDL_DESKTOP            <desktop> (root of namespace)
  CSIDL_PROGRAMS           Start Menu\Programs
  CSIDL_STARTMENU          Settings\username\Start Menu
  CSIDL_PERSONAL           Settings\username\My Documents
  CSIDL_FAVORITES
  CSIDL_STARTUP
  CSIDL_INTERNET
  CSIDL_CONTROLS
  CSIDL_PRINTERS
  CSIDL_RECENT
  CSIDL_SENDTO
  CSIDL_BITBUCKET
|</pre> see other in documentation on API "CSIDL Values" }
function CreateLinkDesc(const FileName,Arguments,WorkDir,IconFile:String;
                    IconNumber:integer; LinkName:String;
                    Description:String
                    ): Boolean;
{* Creates a shortcut with description. }

function CreateLink(const FileName,Arguments,WorkDir,IconFile:String;
                    IconNumber:integer; LinkName:String
                    ): Boolean;
{* Creates a shortcut to specified file object. An example:
!
!  CreateLink( ParamStr( 0 ), '', '', '', 1, GetSystemFolder(CSIDL_DESKTOP)+
!               '\MyProg.lnk' );
}

function ResolveLink( const LinkName: String; var FileName, Arguments, WorkDir,
         Description: String; var IconSmall, IconLarge: HIcon; DialogParentWnd: HWND ): Boolean;
{* Attempts to resolve given link (given by a path to link file). If a link is
   resolved, TRUE returned and FileName, Arguments, WorkDir, Description, Icon(s)
   fields are containing resolved parameters of the link. Set ParentDialogWnd to
   a handle of your window (or 0), if a dialog is allowed to appear if linked
   file is absent (moved or renamed). If DialogParentWnd = THandle(-1) and linked
   file is not found, FALSE is returned silently, without showing dialog box.
   |<br>
   Note: if IconSmall and / or IconLarge are returned <> 0, your code is responsible
   for releasing it calling DestroyIcon function(s). }

function IsLink2RecycleBin( const LinkName: String ): Boolean;
{* Returns TRUE, if the link is a link to Recycle Bin. }

//shlobj.h
//some CSIDL_XXX like CSIDL_PROGRAM_FILES need version 5.00
//(Shlwapi.dll, Microsoft® Internet Explorer 5)
const
 CSIDL_DESKTOP                   =$0000;        // <desktop>
 CSIDL_INTERNET                  =$0001;        // Internet Explorer (icon on desktop)
 CSIDL_PROGRAMS                  =$0002;        // Start Menu\Programs
 CSIDL_CONTROLS                  =$0003;        // My Computer\Control Panel
 CSIDL_PRINTERS                  =$0004;        // My Computer\Printers
 CSIDL_PERSONAL                  =$0005;        // My Documents
 CSIDL_FAVORITES                 =$0006;        // <user name>\Favorites
 CSIDL_STARTUP                   =$0007;        // Start Menu\Programs\Startup
 CSIDL_RECENT                    =$0008;        // <user name>\Recent
 CSIDL_SENDTO                    =$0009;        // <user name>\SendTo
 CSIDL_BITBUCKET                 =$000a;        // <desktop>\Recycle Bin
 CSIDL_STARTMENU                 =$000b;        // <user name>\Start Menu
 CSIDL_MYDOCUMENTS               =$000c;        // logical "My Documents" desktop icon
 CSIDL_MYMUSIC                   =$000d;        // "My Music" folder
 CSIDL_MYVIDEO                   =$000e;        // "My Videos" folder
 CSIDL_DESKTOPDIRECTORY          =$0010;        // <user name>\Desktop
 CSIDL_DRIVES                    =$0011;        // My Computer
 CSIDL_NETWORK                   =$0012;        // Network Neighborhood
 CSIDL_NETHOOD                   =$0013;        // <user name>\nethood
 CSIDL_FONTS                     =$0014;        // windows\fonts
 CSIDL_TEMPLATES                 =$0015;
 CSIDL_COMMON_STARTMENU          =$0016;        // All Users\Start Menu
 CSIDL_COMMON_PROGRAMS           =$0017;        // All Users\Programs
 CSIDL_COMMON_STARTUP            =$0018;        // All Users\Startup
 CSIDL_COMMON_DESKTOPDIRECTORY   =$0019;        // All Users\Desktop
 CSIDL_APPDATA                   =$001a;        // <user name>\Application Data
 CSIDL_PRINTHOOD                 =$001b;        // <user name>\PrintHood
 CSIDL_LOCAL_APPDATA             =$001c;        // <user name>\Local Settings\Applicaiton Data (non roaming)
 CSIDL_ALTSTARTUP                =$001d;        // non localized startup
 CSIDL_COMMON_ALTSTARTUP         =$001e;        // non localized common startup
 CSIDL_COMMON_FAVORITES          =$001f;
 CSIDL_INTERNET_CACHE            =$0020;
 CSIDL_COOKIES                   =$0021;
 CSIDL_HISTORY                   =$0022;
 CSIDL_COMMON_APPDATA            =$0023;        // All Users\Application Data
 CSIDL_WINDOWS                   =$0024;        // GetWindowsDirectory()
 CSIDL_SYSTEM                    =$0025;        // GetSystemDirectory()
 CSIDL_PROGRAM_FILES             =$0026;        // C:\Program Files
 CSIDL_MYPICTURES                =$0027;        // C:\Program Files\My Pictures
 CSIDL_PROFILE                   =$0028;        // USERPROFILE
 CSIDL_SYSTEMX86                 =$0029;        // x86 system directory on RISC
 CSIDL_PROGRAM_FILESX86          =$002a;        // x86 C:\Program Files on RISC
 CSIDL_PROGRAM_FILES_COMMON      =$002b;        // C:\Program Files\Common
 CSIDL_PROGRAM_FILES_COMMONX86   =$002c;        // x86 Program Files\Common on RISC
 CSIDL_COMMON_TEMPLATES          =$002d;        // All Users\Templates
 CSIDL_COMMON_DOCUMENTS          =$002e;        // All Users\Documents
 CSIDL_COMMON_ADMINTOOLS         =$002f;        // All Users\Start Menu\Programs\Administrative Tools
 CSIDL_ADMINTOOLS                =$0030;        // <user name>\Start Menu\Programs\Administrative Tools
 CSIDL_CONNECTIONS               =$0031;        // Network and Dial-up Connections

 CSIDL_FLAG_CREATE               =$8000;        // combine with CSIDL_ value to force folder creation in SHGetFolderPath()
 CSIDL_FLAG_DONT_VERIFY          =$4000;        // combine with CSIDL_ value to return an unverified folder path
 CSIDL_FLAG_NO_ALIAS             =$1000;        // combine with CSIDL_ value to insure non-alias versions of the pidl
 CSIDL_FLAG_MASK                 =$FF00;        // mask for all possible flag values

implementation

function GetSystemFolder(Const Folder:integer):string;
var
 PIDL: PItemIDList;
 Path: array[ 0..MAX_PATH ] of Char;
begin
  Result := '';
  if SHGetSpecialFolderLocation(0, Folder, PIDL) = NOERROR then
  begin
    if SHGetPathFromIDList(PIDL, Path) then  Result := Path;
    CoTaskMemFree( PIDL );
  end;
end;

const
  IID_IPersistFile: TGUID = (
    D1:$0000010B;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));

function CreateLink(const FileName,Arguments,WorkDir,IconFile:String;
                    IconNumber:integer; LinkName:String ): Boolean;
begin
  Result := CreateLinkDesc( FileName, Arguments, WorkDir, IconFile, IconNumber,
         LinkName, '' );
end;

function CreateLinkDesc(const FileName,Arguments,WorkDir,IconFile:String;
                    IconNumber:integer; LinkName:String;
                    Description:String): Boolean;
var
  SLink   : IShellLink;
  PFile   : IPersistFile;
  WFileName : WideString;
begin
  Result := FALSE;
  CoInitialize( nil );
  if CoCreateInstance( TGUID( CLSID_ShellLink ), nil, CLSCTX_INPROC_SERVER,
                       TGUID( IID_IShellLinkA ), SLink ) <> S_OK then Exit;
  if SLink.QueryInterface( System.TGUID( IID_IPersistFile ), PFile ) <> S_OK then Exit;
  SLink.SetArguments(PChar(Arguments));
  SLink.SetPath(PChar(FileName));
  SLink.SetWorkingDirectory(PChar(WorkDir));
  SLink.SetDescription(PChar(Description));
  SLink.SetIconLocation(PChar(IconFile),IconNumber);
  if not DirectoryExists(ExtractFilePath(LinkName)) then
    CreateDir( ExtractFilePath(LinkName) );
  WFileName := LinkName;
  PFile.Save(PWChar(WFileName),False);
  Result := TRUE;
end;

function ResolveLink( const LinkName: String; var FileName, Arguments, WorkDir,
         Description: String; var IconSmall, IconLarge: HIcon; DialogParentWnd: HWND ): Boolean;
var
  SLink   : IShellLink;
  PFile   : IPersistFile;
  WFileName : WideString;
  Wnd: HWnd;
  Flg: DWORD;
  Buf: array[ 0..4095 ] of Char;
  FD: TWin32FindData;
  I: Integer;
begin
  Result := FALSE;
  CoInitialize( nil );
  if CoCreateInstance( TGUID( CLSID_ShellLink ), nil, CLSCTX_INPROC_SERVER,
                       TGUID( IID_IShellLinkA ), SLink ) <> S_OK then Exit;
  if SLink.QueryInterface( System.TGUID( IID_IPersistFile ), PFile ) <> S_OK then Exit;
  WFileName := LinkName;
  PFile.Load(PWChar(WFileName),STGM_READ);
  Wnd := DialogParentWnd;
  if Wnd = THandle( -1 ) then
    Wnd := 0;
  Flg := SLR_UPDATE;
  if DialogParentWnd = THandle(-1) then
    Flg := SLR_NO_UI;
  if SLink.Resolve( Wnd, Flg ) = NOERROR then
  begin
    if SLink.GetPath( Buf, Sizeof( Buf ), FD, 0 ) <> NOERROR then
      FileName := ''
    else
      FileName := Buf;
    if SLink.GetArguments( Buf, Sizeof( Buf ) ) <> NOERROR then Exit;
    Arguments := Buf;
    if SLink.GetWorkingDirectory( Buf, Sizeof( Buf ) ) <> NOERROR then Exit;
    WorkDir := Buf;
    if SLink.GetDescription( Buf, Sizeof( Buf ) ) <> NOERROR then Exit;
    Description := Buf;
    IconSmall := 0;
    IconLarge := 0;
    if SLink.GetIconLocation( Buf, Sizeof( Buf ), I ) = NOERROR then
      ExtractIconEx( Buf, I, IconLarge, IconSmall, 1 );
    Result := TRUE;
  end;
end;

function IsLink2RecycleBin( const LinkName: String ): Boolean;
var
  SLink   : IShellLink;
  PFile   : IPersistFile;
  WFileName : WideString;
  Flg: DWORD;
  ppidl, ppidl1, p, p1: PItemIDList;
begin
  Result := FALSE;
  CoInitialize( nil );
  if CoCreateInstance( TGUID( CLSID_ShellLink ), nil, CLSCTX_INPROC_SERVER,
                       TGUID( IID_IShellLinkA ), SLink ) <> S_OK then Exit;
  if SLink.QueryInterface( System.TGUID( IID_IPersistFile ), PFile ) <> S_OK then Exit;
  WFileName := LinkName;
  PFile.Load(PWChar(WFileName),STGM_READ);
  Flg := SLR_NO_UI;
  if SLink.Resolve( 0, Flg ) = NOERROR then
  begin
    if SLink.GetIDList( ppidl ) = NOERROR then
    begin
      if SHGetSpecialFolderLocation( 0, CSIDL_BITBUCKET, ppidl1 ) = NOERROR then
      begin
        Result := TRUE;
        p := ppidl;
        p1 := ppidl1;
        while TRUE do
        begin
          if (p1.mkid.cb = p.mkid.cb) and (p1.mkid.cb = 0) then
            break;
          if (p1.mkid.cb <> p.mkid.cb) or
             not CompareMem( @ p.mkid.abID[ 0 ], @ p1.mkid.abID[ 0 ],
                         p.mkid.cb ) then
          begin
            Result := FALSE;
            break;
          end;
          p := Pointer( Integer( p ) + p.mkid.cb );
          p1 := Pointer( Integer( p1 ) + p1.mkid.cb );
        end;
        CoTaskMemFree( ppidl1 );
      end;
      CoTaskMemFree( ppidl );
    end;
  end;
end;

end.
