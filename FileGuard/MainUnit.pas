{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit MainUnit;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLMHXP {$IFNDEF KOL_MCK}, MCKMHXP, mirror, Classes, Controls, mckControls, mckObjs, Graphics,  mckCtrls {$ENDIF}, MultiDirsChange, FileVersionUnit, err;
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;
{$ENDIF}

//const Registry = 'Software\Bonanzas\FileGuard\';
const
  WM_USER_HIDE = WM_USER + 111;

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TfmMainGuard = class; PfmMainGuard = TfmMainGuard; {$ELSE OBJECTS} PfmMainGuard = ^TfmMainGuard; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TfmMainGuard.inc}{$ELSE} TfmMainGuard = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TfmMainGuard = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    TrayIcon1: TKOLTrayIcon;
    Panel1: TKOLPanel;
    lStatus: TKOLLabel;
    bExit: TKOLButton;
    KOLApplet1: TKOLApplet;
    pm1: TKOLPopupMenu;
    tc1: TKOLTabControl;
    TabControl1_Tab0: TKOLPanel;
    TabControl1_Tab1: TKOLPanel;
    TabControl1_Tab2: TKOLPanel;
    Memo1: TKOLMemo;
    Panel2: TKOLPanel;
    eStoragePath: TKOLEditBox;
    bBrowseStorage: TKOLButton;
    dSelStorage: TKOLOpenDirDialog;
    Panel3: TKOLPanel;
    Toolbar1: TKOLToolbar;
    ImageList1: TKOLImageList;
    lv1: TKOLListView;
    tc1_Tab3: TKOLPanel;
    lLink: TKOLLabel;
    Panel4: TKOLPanel;
    ImageShow1: TKOLImageShow;
    ImageList2: TKOLImageList;
    Panel5: TKOLPanel;
    LabelEffect1: TKOLLabelEffect;
    LabelEffect2: TKOLLabelEffect;
    Panel6: TKOLPanel;
    lDescription_About: TKOLLabel;
    Panel7: TKOLPanel;
    lStorageStatus: TKOLLabel;
    tvDirs: TKOLTreeView;
    lvFiles: TKOLListView;
    Splitter1: TKOLSplitter;
    ImageList3: TKOLImageList;
    pm2: TKOLPopupMenu;
    pm3: TKOLPopupMenu;
    KOLForm1: TKOLForm;
    TimerHide: TKOLTimer;
    pnLogInfo: TKOLPanel;
    cDetailed: TKOLCheckBox;
    lQueued: TKOLLabel;
    MHXP1: TKOLMHXP;
    TimerCheckConnect: TKOLTimer;
    ThreadRescanStorageTree: TKOLThread;
    procedure TrayIcon1Mouse(Sender: PObj; Message: Word);
    procedure pm1pmStateMenu(Sender: PMenu; Item: Integer);
    procedure KOLForm1Close(Sender: PObj; var Accept: Boolean);
    procedure bExitClick(Sender: PObj);
    procedure pm1pmExitMenu(Sender: PMenu; Item: Integer);
    procedure bBrowseStorageClick(Sender: PObj);
    procedure KOLForm1Destroy(Sender: PObj);
    procedure KOLForm1Show(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure eStoragePathChange(Sender: PObj);
    procedure lv1LVData(Sender: PControl; Idx, SubItem: Integer;
      var Txt: String; var ImgIdx: Integer; var State: Cardinal;
      var Store: Boolean);
    procedure Toolbar1TBAddClick(Sender: PControl; BtnID: Integer);
    procedure lv1LVStateChange(Sender: PControl; IdxFrom, IdxTo: Integer;
      OldState, NewState: Cardinal);
    procedure Toolbar1TBEditClick(Sender: PControl; BtnID: Integer);
    procedure Toolbar1TBDelClick(Sender: PControl; BtnID: Integer);
    procedure Toolbar1TBUpClick(Sender: PControl; BtnID: Integer);
    procedure Toolbar1TBDnClick(Sender: PControl; BtnID: Integer);
    procedure lv1MouseDblClk(Sender: PControl; var Mouse: TMouseEventData);
    procedure lv1KeyDown(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
    procedure lLinkMouseEnter(Sender: PObj);
    procedure lLinkMouseLeave(Sender: PObj);
    procedure lLinkClick(Sender: PObj);
    procedure lvFilesLVData(Sender: PControl; Idx, SubItem: Integer;
      var Txt: String; var ImgIdx: Integer; var State: Cardinal;
      var Store: Boolean);
    procedure tvDirsSelChange(Sender: PObj);
    procedure pm2pmHistoryMenu(Sender: PMenu; Item: Integer);
    procedure pm2pmRestoreMenu(Sender: PMenu; Item: Integer);
    procedure pm3pmDirRestoreMenu(Sender: PMenu; Item: Integer);
    procedure KOLForm1Minimize(Sender: PObj);
    procedure TimerHideTimer(Sender: PObj);
    procedure lvFilesLVStateChange(Sender: PControl; IdxFrom,
      IdxTo: Integer; OldState, NewState: Cardinal);
    procedure pm3pmDirOpenMenu(Sender: PMenu; Item: Integer);
    procedure lvFilesMouseDblClk(Sender: PControl;
      var Mouse: TMouseEventData);
    procedure lvFilesKeyDown(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
    procedure TimerCheckConnectTimer(Sender: PObj);
    function ThreadRescanStorageTreeExecute(Sender: PThread): Integer;
  private
    { Private declarations }
    LastChanged: String;
    procedure DirChanged( Sender: PObj; const Path: string; CheckFirstTime: Boolean = FALSE ); overload;
    procedure DirChanged( Sender: PObj; const Path: string ); overload;
    procedure AddToTree( Tree: PTree; const Path: String; WithSubdirs: Boolean );
  public
    { Public declarations }
    WantClose: Boolean;
    AdminMessage: Boolean;
    Restricted: Boolean;
    StorageOK: Boolean;
    MonitorList: PStrListEx;
    FiltersList: PStrListEx;
    AnyDirsChange: PAnyDirsChange;
    TreeDirs: PTree;
    LastUCLProgress: DWORD;
    procedure DoExit;
    procedure ShowStatus;
    procedure SaveSettings;
    procedure EnableCommands;
    procedure PrepareTree;
    procedure UCLOnProgress( const Sender: PObj; const InBytes, OutBytes: Cardinal );
    procedure AcceptDirItem( Sender: PObj; var FindData: TWin32FindData;
              var Action: TDirItemAction );
  public
    DirChangesQueue: PStrListEx;
    procedure IdleEvent( Sender: PObj );
    procedure HandleDirChanges( const Path: String; FirstHandling: Boolean );
    procedure HandleFileChange( const FilePath: String; Action: Integer );
  public
    StorageChanged, StorageTreeChanged: Boolean;
    Directory: PStrListEx;
    Directory_Path, Directory_Root, Directory_Prefix: String;
    procedure RebuildStorageTree;
    procedure AddPathToTVDirs( DirPath: String; Obj: Integer );
    procedure ClearDirectory;
    procedure CollectAllVersionsInfo( FileStream: PStream; const FI: TFileVersionInfo;
      SecType: Byte; SecLen: DWORD; var Cont: Boolean );
    procedure RestoreFiles( FileList: PStrList );
    procedure AddFilesFromSubdirs( SL: PStrList; Node: THandle;
      SubdirsRecursively: Boolean );
  public
    VerDate: TDateTime;
    VersionFile: PStream;
    VerIdx: Integer;
    VerFileName: String;
    procedure RestoreForDate( FileStream: PStream; const FI: TFileVersionInfo;
      SecType: Byte; SecLen: DWORD; var Cont: Boolean );
    procedure RestoreSubdirs( Sender: PObj );
    procedure RestoreSelected( Sender: PObj );
    procedure ViewFile;
    procedure ShowQueued;
  end;

var
  fmMainGuard {$IFDEF KOL_MCK} : PfmMainGuard {$ELSE} : TfmMainGuard {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewfmMainGuard( var Result: PfmMainGuard; AParent: PControl );
{$ENDIF}

procedure Log( const S: String );
function DoApplyUpdates( Strm1, Strm2, Strm3: PStream ): Boolean;

implementation

uses EditFilterUnit, StorageUnit, HistoryUnit, RestoreUnit, DIUCLStreams,
     UpdatesUnit;

function DoApplyUpdates( Strm1, Strm2, Strm3: PStream ): Boolean;
begin
  Result := TRUE;
  TRY
    ApplyUpdates( Strm1, Strm2, Strm3, Storage.ProgressHandler );
  EXCEPT
    Result := FALSE;
  END;
end;

type
  PDirData = ^TDirData;
  TDirData = packed record
    FT: TFileTime;
    Sz: DWORD;
    TotalSz: DWORD;
  end;

procedure Log(const S: String);
var L: Integer;
    SL: PStrList;
    I: Integer;
    T: String;
begin
  T := DateTime2StrShort( Now ) + ' ';
  if not StrIsStartingFrom( PChar( S ), '-' ) then
    LogFileOutput( GetStartDir + 'fileguard.log', T + S );
  if StrIsStartingFrom( PChar( S ), '-' ) and not fmMainGuard.cDetailed.Checked then Exit;
  L := fmMainGuard.Memo1.TextSize;
  if L > 16384 then
  begin
    SL := NewStrList;
    SL.Text := fmMainGuard.Memo1.Text;
    I := SL.Count div 2;
    for I := 1 to I do
      SL.Delete( 0 );
    fmMainGuard.Memo1.Text := SL.Text;
    SL.Free;
    L := fmMainGuard.Memo1.TextSize;
  end;
  fmMainGuard.Memo1.Add( T + S + #13#10 );
  fmMainGuard.Memo1.SelStart := L;
  fmMainGuard.Memo1.Perform( EM_SCROLLCARET, 0, 0 );
end;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I MainUnit_1.inc}
{$ENDIF}

procedure TfmMainGuard.TrayIcon1Mouse(Sender: PObj; Message: Word);
var P: TPoint;
begin
  CASE Message OF
  WM_LBUTTONDOWN:
    begin
      Applet.Show;
      if Applet.WindowState = wsMinimized then
        AppletRestore;
      Form.Show;
    end;
  WM_RBUTTONUP:
    begin
      GetCursorPos( P );
      pm1.PopupEx( P.X, P.Y );
    end;
  END;
end;

procedure TfmMainGuard.pm1pmStateMenu(Sender: PMenu; Item: Integer);
begin
  Applet.Show;
      if Applet.WindowState = wsMinimized then
        AppletRestore;
  Form.Show;
end;

procedure TfmMainGuard.KOLForm1Close(Sender: PObj; var Accept: Boolean);
begin
  Accept := FALSE;
  Applet.Visible := FALSE;
  Form.Hide;
end;

procedure TfmMainGuard.bExitClick(Sender: PObj);
begin
  WantClose := TRUE;
  DoExit;
end;

procedure TfmMainGuard.DoExit;
begin
  PostQuitMessage( 0 );
end;

procedure TfmMainGuard.pm1pmExitMenu(Sender: PMenu; Item: Integer);
begin
  DoExit;
end;

procedure TfmMainGuard.bBrowseStorageClick(Sender: PObj);
var S: String;
begin
  if dSelStorage.Execute then
  begin
    S := dSelStorage.Path;
    eStoragePath.Text := S;
  end;
end;

procedure TfmMainGuard.KOLForm1Destroy(Sender: PObj);
begin
  SaveSettings;
  AnyDirsChange.Clear;
  Sleep( 200 );
  MonitorList.Free;
  FiltersList.Free;
  DirChangesQueue.Free;
  ClearDirectory;
  LastChanged := '';
  if ThreadRescanStorageTree.Suspended then
    ThreadRescanStorageTree.Resume;
  ThreadRescanStorageTree.WaitFor;
end;

procedure TfmMainGuard.KOLForm1Show(Sender: PObj);
var R: TRect;
begin
  Toolbar1.Perform( TB_SETROWS, 1 shl 16, Integer( @ R ) );
  //
  //Applet.Font.FontName := 'Arial';
  //Applet.Font.FontHeight := 16;
end;
{var R: THandle;
begin
  R := RegKeyOpenCreate( HKEY_LOCAL_MACHINE, Registry );
  if R = 0 then
  begin
    if not AdminMessage then
    begin
      AdminMessage := TRUE;
      ShowMessage( 'You must have administrator rights to change settings!' );
    end;
    Restricted := TRUE;
    Exit;
  end;
  RegKeyClose( R );
end;}

procedure TfmMainGuard.KOLForm1FormCreate(Sender: PObj);
var //R: THandle;
    I: Integer;
    S: String;
    C: Char;
    Ini: PIniFile;
begin
  SetPriorityClass( GetCurrentProcess, IDLE_PRIORITY_CLASS );
  tc1.CurIndex := 0;
  lDescription_About.Caption := 'Automatic Backup Files System. ' +
  'Monitors changes in specified directories and for files satisfying to ' +
  'specified filters performs specified action. It is possible to provide ' +
  'saving last modified version only or save entire history of changes for ' +
  'certain kinds of files. Either a directory on another HDD, or network ' +
  'shared folder can be used as a storage for saved files.';
  Directory := NewStrListEx;
  new( Storage, Create );
  DirChangesQueue := NewStrListEx;
  AnyDirsChange := NewAnyDirsChange( DirChanged, FILE_NOTIFY_CHANGE_FILE_NAME or
              FILE_NOTIFY_CHANGE_DIR_NAME or
              FILE_NOTIFY_CHANGE_SIZE or
              FILE_NOTIFY_CHANGE_LAST_WRITE );
  MonitorList := NewStrListEx;
  FiltersList := NewStrListEx;
  TreeDirs := NewTree( nil, '' );
  for C := 'A' to 'Z' do
    NewTree( TreeDirs, C + ':' );
  Ini := OpenIniFile( GetStartDir + 'fileguard.ini' );
  TRY
    Ini.Section := 'Main';
    I := Ini.ValueInteger( 'DirCount', 0 );
    for I := 1 to I do
    begin
      S := Ini.ValueString( 'Dir' + Int2Str( I ), '' );
      if S = '' then continue;
      S := IncludeTrailingPathDelimiter( S );
      MonitorList.AddObject( S, Ini.ValueInteger( 'Action' + Int2Str( I ), 0 ) );
      S := Ini.ValueString( 'Filter' + Int2Str( I ), '*.*' );
      FiltersList.AddObject( S, Ini.ValueInteger( 'Time' + Int2Str( I ), 0 ) );
    end;
    lv1.LVCount := MonitorList.Count;
    eStoragePath.Text := Ini.ValueString( 'Storage', '' );
    Storage.Path := eStoragePath.Text;
    ShowStatus;
    PrepareTree;
  FINALLY
    Ini.Free;
  END;
  {R := RegKeyOpenRead( HKEY_LOCAL_MACHINE, Registry );
  TRY
    I := RegKeyGetDw( R, 'DirCount' );
    for I := 1 to I do
    begin
      S := RegKeyGetStr( R, 'Dir' + Int2Str( I ) );
      S := IncludeTrailingPathDelimiter( S );
      MonitorList.AddObject( S, RegKeyGetDw( R, 'Action' + Int2Str( I ) ) );
      S := RegKeyGetStr( R, 'Filter' + Int2Str( I ) );
      FiltersList.AddObject( S, RegKeyGetDw( R, 'Time' + Int2Str( I ) ) );
    end;
    lv1.LVCount := MonitorList.Count;
    eStoragePath.Text := RegKeyGetStr( R, 'Storage' );
    Storage.Path := eStoragePath.Text;
    ShowStatus;
    PrepareTree;
  FINALLY
    RegKeyClose( R );
  END;}
  RegisterIdleHandler( IdleEvent );
end;

procedure TfmMainGuard.eStoragePathChange(Sender: PObj);
var S: String;
    OK: Boolean;
    F: HFile;
    Buffer: array[ 0..1023 ] of Char;
    E: Boolean;
begin
  OK := TRUE;
  lStorageStatus.Caption := '';
  S := eStoragePath.Text;
  E := DirectoryExists( S );
  if E or
     (pos( ':', S ) > 0) and (Length( S ) <= 3) and (S <> '') and
     (S[ 1 ] in [ 'a'..'z', 'A'..'Z' ]) and (S[ 3 ] = '\') then
  begin
    if StrIsStartingFrom( PChar( S ), '\\' ) then
    begin
      // сетева€ директори€ - проверить, что запись туда возможна...
      F := FileCreate( S + 'test.file', ofOpenWrite or ofOpenAlways );
      if F = INVALID_HANDLE_VALUE then OK := FALSE
      else
      TRY
        FillChar( Buffer, Sizeof( Buffer ), 255 );
        if FileWrite( F, Buffer, Sizeof( Buffer ) ) <> Sizeof( Buffer ) then
          OK := FALSE;
      FINALLY
        FileClose( F );
      END;
      if not OK then
      begin
        if E then
          lStorageStatus.Caption := 'Access denied'
        else
          lStorageStatus.Caption := 'Disconnected';
        TimerCheckConnect.Enabled := TRUE;
      end;
    end
      else
    if pos( ':', S ) = 2 then
    begin
      CASE GetDriveType( PChar( Copy( S, 1, 2 ) + '\' ) ) OF
      DRIVE_UNKNOWN: ShowMessage( 'Drive ' + S[ 1 ] + ' unknown. Saving will be ' +
                     'performed as to the another HDD or to shared network folder.' );
      DRIVE_REMOVABLE, DRIVE_FIXED, DRIVE_REMOTE:
        begin
          //todo: проверить, что это не тот же самый диск, который мониторируетс€
        end;
      DRIVE_CDROM:
        begin
          lStorageStatus.Caption := 'Storing on CD-ROM not supported!';
          OK := FALSE;
        end;
      DRIVE_RAMDISK:
        begin
          lStorageStatus.Caption := 'Storing on RAM-disk has no sense!';
          OK := FALSE;
        end;
      else
        begin
          lStorageStatus.Caption := 'This kind of storage can not be used!';
          OK := FALSE;
        end;
      END;
    end;
  end
    else
  begin
    if StrIsStartingFrom( PChar( S ), '\\' ) then
    begin
      lStorageStatus.Caption := 'Disconnected';
      TimerCheckConnect.Enabled := TRUE;
    end;
    OK := FALSE;
  end;
  StorageOK := OK;
  if OK then
  begin
    lStorageStatus.Caption := 'Storage OK.';
    StorageChanged := TRUE;
    StorageTreeChanged := TRUE;
    ShowStatus;
    SaveSettings;
    Storage.Path := eStoragePath.Text;
    PrepareTree;
  end;
  ShowStatus;
end;

procedure TfmMainGuard.ShowStatus;
var S: String;
begin
  if StorageOK then
    S := eStoragePath.Text
  else
    S := '<not set>';
  lStatus.Caption := 'Monitored: ' + Int2Str( MonitorList.Count ) + ' dirs   ' +
                     'Storage: ' + S;
end;

procedure TfmMainGuard.lv1LVData(Sender: PControl; Idx, SubItem: Integer;
  var Txt: String; var ImgIdx: Integer; var State: Cardinal;
  var Store: Boolean);
begin
  CASE SubItem OF
  0: Txt := MonitorList.Items[ Idx ];
  1: Txt := FiltersList.Items[ Idx ];
  2: Txt := Int2Str( FiltersList.Objects[ Idx ] );
  END;
  ImgIdx := MonitorList.Objects[ Idx ] and 3;
  if MonitorList.Objects[ Idx ] and 4 <> 0 then
    State := (3+1) shl 12;
  Store := FALSE;
end;

procedure TfmMainGuard.Toolbar1TBAddClick(Sender: PControl;
  BtnID: Integer);
begin
  if fmEditFilter = nil then
    NewfmEditFilter( fmEditFilter, Applet );
  fmEditFilter.Operation := -1;
  fmEditFilter.Form.Show;
  //fmEditFilter.Form.Hide;
end;

procedure TfmMainGuard.SaveSettings;
var //R: THandle;
    I: Integer;
    Ini: PIniFile;
begin
  Ini := OpenIniFile( GetStartDir + 'fileguard.ini' );
  TRY
    Ini.Section := 'Main';
    Ini.Mode := ifmWrite;
    Ini.ValueString( 'Storage', eStoragePath.Text );
    Ini.ValueInteger( 'DirCount', MonitorList.Count );
    for I := 0 to MonitorList.Count-1 do
    begin
      Ini.ValueString( 'Dir' + Int2Str( I+1 ), MonitorList.Items[ I ] );
      Ini.ValueString( 'Filter' + Int2Str( I+1 ), FiltersList.Items[ I ] );
      Ini.ValueInteger( 'Action' + Int2Str( I+1 ), MonitorList.Objects[ I ] );
      Ini.ValueInteger( 'Time' + Int2Str( I+1 ), FiltersList.Objects[ I ] );
    end;
  FINALLY
    Ini.Free;
  END;
  {R := RegKeyOpenCreate( HKEY_LOCAL_MACHINE, Registry );
  if R = 0 then Exit;
  TRY
    RegKeySetStr( R, 'Storage', eStoragePath.Text );
    RegKeySetDw( R, 'DirCount', MonitorList.Count );
    for I := 0 to MonitorList.Count-1 do
    begin
      RegKeySetStr( R, 'Dir' + Int2Str( I+1 ), MonitorList.Items[ I ] );
      RegKeySetStr( R, 'Filter' + Int2Str( I+1 ), FiltersList.Items[ I ] );
      RegKeySetDw( R, 'Action' + Int2Str( I+1 ), MonitorList.Objects[ I ] );
      RegKeySetDw( R, 'Time' + Int2Str( I+1 ), FiltersList.Objects[ I ] );
    end;
  FINALLY
    RegKeyClose( R );
  END;}
end;


procedure TfmMainGuard.EnableCommands;
begin
  //Toolbar1.TBButtonEnabled[ TBAdd ] := TRUE;
  Toolbar1.TBButtonEnabled[ TBEdit ] := lv1.LVCurItem >= 0;
  Toolbar1.TBButtonEnabled[ TBDel ] := lv1.LVCurItem >= 0;
  Toolbar1.TBButtonEnabled[ TBUp ] := lv1.LVCurItem > 0;
  Toolbar1.TBButtonEnabled[ TBDn ] := (lv1.LVCurItem >= 0)
    and (lv1.LVCurItem < lv1.LVCount - 1);
end;

procedure TfmMainGuard.lv1LVStateChange(Sender: PControl; IdxFrom,
  IdxTo: Integer; OldState, NewState: Cardinal);
begin
  EnableCommands;
end;

procedure TfmMainGuard.Toolbar1TBEditClick(Sender: PControl;
  BtnID: Integer);
var Idx: Integer;
begin
  Idx := lv1.LVCurItem;
  if Idx < 0 then Exit;
  if fmEditFilter = nil then
    NewfmEditFilter( fmEditFilter, Applet );
  fmEditFilter.eDir.Text := MonitorList.Items[ Idx ];
  fmEditFilter.eFilter.Text := FiltersList.Items[ Idx ];
  fmEditFilter.eAction.CurIndex := MonitorList.Objects[ Idx ] and 3;
  fmEditFilter.eActionChange( nil );
  fmEditFilter.eTime.Text := Int2Str( FiltersList.Objects[ Idx ] );
  fmEditFilter.Operation := Idx;
  fmEditFilter.cSubdirectories.Checked := MonitorList.Objects[ Idx ] and 4 <> 0;
  fmEditFilter.cSubdirectoriesClick( nil );
  fmEditFilter.Form.Show;
end;

procedure TfmMainGuard.Toolbar1TBDelClick(Sender: PControl;
  BtnID: Integer);
var Idx: Integer;
begin
  Idx := lv1.LVCurItem;
  if Idx < 0 then Exit;
  MonitorList.Delete( Idx );
  FiltersList.Delete( Idx );
  lv1.LVCount := MonitorList.Count;
  SaveSettings;
  EnableCommands;
  ShowStatus;
end;

procedure TfmMainGuard.Toolbar1TBUpClick(Sender: PControl; BtnID: Integer);
var Idx: Integer;
begin
  Idx := lv1.LVCurItem;
  MonitorList.Swap( Idx - 1, Idx );
  lv1.Invalidate;
  lv1.LVCurItem := lv1.LVCurItem-1;
  EnableCommands;
  SaveSettings;
end;

procedure TfmMainGuard.Toolbar1TBDnClick(Sender: PControl; BtnID: Integer);
var Idx: Integer;
begin
  Idx := lv1.LVCurItem;
  MonitorList.Swap( Idx + 1, Idx );
  lv1.Invalidate;
  lv1.LVCurItem := lv1.LVCurItem+1;
  EnableCommands;
  SaveSettings;
end;

procedure TfmMainGuard.DirChanged(Sender: PObj; const Path: string; CheckFirstTime: Boolean = FALSE);
var I: Integer;
begin
  I := DirChangesQueue.IndexOf( Path );
  if I < 0 then
  begin
    if CheckFirstTime then
      DirChangesQueue.AddObject( Path, 1 )
    else
      DirChangesQueue.AddObject( Path, 0 );
    ShowQueued;
    if not CheckFirstTime and (LastChanged <> Path) then
    begin
      LastChanged := Path;
      Log( 'Changed: ' + Path );
    end;
  end
    else
  if not CheckFirstTime then
  begin
    DirChangesQueue.Objects[ I ] := 0;
  end;
end;

procedure TfmMainGuard.lv1MouseDblClk(Sender: PControl;
  var Mouse: TMouseEventData);
begin
  if Toolbar1.TBButtonEnabled[ TBEdit ] then
    Toolbar1TBEditClick( nil, 0 );
end;

procedure TfmMainGuard.lv1KeyDown(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
begin
  if Key = VK_RETURN then
  if Toolbar1.TBButtonEnabled[ TBEdit ] then
    Toolbar1TBEditClick( nil, 0 );
end;

procedure TfmMainGuard.PrepareTree;
var I: Integer;
    S: String;
begin
  for I := 0 to MonitorList.Count-1 do
  begin
    S := MonitorList.Items[ I ];
    AddToTree( TreeDirs, S, MonitorList.Objects[ I ] and 4 <> 0 );
  end;
end;

procedure TfmMainGuard.AddToTree(Tree: PTree; const Path: String; WithSubdirs: Boolean);
var Node, Child: PTree;
    I, J: Integer;
    DName: String;
    DL: PDirList;
    PC: DWORD;
    SrcPath: String;
begin
  Applet.ProcessMessages;
  SrcPath := Path;
  //SetThreadPriority( GetCurrentThread,  )
  if not( (Path <> '') and (Path[ 1 ] in [ 'A'..'Z', 'a'..'z' ]) and
     (Path[ 2 ] = ':') ) then Exit;
  if not DirectoryExists( Path ) then Exit;
  //DL := NewDirList( SrcPath, '*.*', FILE_ATTRIBUTE_DIRECTORY );
  DL := NewDirList( '', '', 0 );
  DL.OnItem := AcceptDirItem;
  DL.ScanDirectory( SrcPath, '*.*', FILE_ATTRIBUTE_DIRECTORY );
  PC := GetPriorityClass( GetCurrentProcess );
  SetPriorityClass( GetCurrentProcess, IDLE_PRIORITY_CLASS );
  if not AnsiEq( IncludeTrailingPathDelimiter( Path ), GetStartDir ) then
    AnyDirsChange.Add( SrcPath );
  TRY

    Node := nil;
    DName := '';
    for I := 0 to Tree.Count-1 do
    begin
      Node := Tree.Items[ I ];
      if StrEq( Node.Name[ 1 ], SrcPath[ 1 ] ) then
      begin
        DName := Parse( SrcPath, '\' );
        while Path <> '' do
        begin
          DName := Parse( SrcPath, '\' );
          Child := nil;
          for J := 0 to Node.Count-1 do
          begin
            Child := Node.Items[ J ];
            if AnsiEq( DName, Child.Name ) then
            begin
              Node := Child;
              break;
            end
              else Child := nil;
          end;
          if Child = nil then break;
        end;
        break;
      end
        else
        Node := nil;
    end;
    if Node = nil then Exit;
    if DName = '' then
      DName := Parse( SrcPath, '\' );
    while (DName <> '') or (SrcPath <> '') do
    begin
      Child := NewTree( Node, DName );
      DName := Parse( SrcPath, '\' );
      Node := Child;
    end;

    DirChanged( nil, DL.Path, TRUE );

    //Log( 'Added: ' + DL.Path );

    if WithSubdirs then
      for I := 0 to DL.Count-1 do
      begin
        if DL.IsDirectory[ I ] then
          AddToTree( TreeDirs, DL.Path + DL.Names[ I ], TRUE );
      end;

  FINALLY
    DL.Free;
    SetPriorityClass( GetCurrentProcess, PC );
  END;
end;

procedure TfmMainGuard.IdleEvent(Sender: PObj);
var Path: String;
    I: Integer;
    IsFirst: Boolean;
begin
  if DirChangesQueue.Count > 0 then
  begin
    for I := 1 to DirChangesQueue.Count do
    begin
      Applet.ProcessMessages;
      if WantClose then Exit;
      if DirChangesQueue.Count = 0 then
        break;
      Path := DirChangesQueue.Items[ 0 ];
      IsFirst := DirChangesQueue.Objects[ 0 ] <> 0;
      DirChangesQueue.Delete( 0 );
      ShowQueued;
      HandleDirChanges( Path, IsFirst );
      if StorageTreeChanged then
      begin
        Log( '-Started: rescanning Storage and building tree' );
        //RebuildStorageTree;
        if ThreadRescanStorageTree.Suspended then
          ThreadRescanStorageTree.Resume;
        //StorageTreeChanged := TRUE;
        Log( '-Finished: rescanning Storage and building tree' );
      end;
    end;
  end;
  if StorageTreeChanged then
  begin
    Log( '-Started: rescanning Storage and building tree' );
    RebuildStorageTree;
    Log( '-Finished: rescanning Storage and building tree' );
  end;
end;

procedure TfmMainGuard.HandleDirChanges(const Path: String; FirstHandling: Boolean);
var DL: PDirList;
    I, J: Integer;
    S, S1: String;
    Satisfied: Boolean;
    AllHandled: Boolean;
    FT: TFileTime;
    ST: TSystemTime;
    ChangeTime, TimeElapsed: TDateTime;
    Time2Wait: Integer;
begin
  Log( '-Handling directory (scan for changes): ' + Path );
  Applet.ProcessMessages;
  //DL := NewDirList( Path, '*.*', 0 );
  DL := NewDirList( '', '', 0 );
  DL.OnItem := AcceptDirItem;
  DL.ScanDirectory( Path, '*.*', 0 );
  AllHandled := TRUE;
  TRY
    for I := 0 to DL.Count-1 do
    begin
      Applet.ProcessMessages;
      if not DL.IsDirectory[ I ] then
      begin
        for J := 0 to MonitorList.Count-1 do
        begin
          if WantClose then Exit;
          S := MonitorList.Items[ J ];
          if AnsiEq( Copy( Path, 1, Length( S ) ), S ) and
             ( (MonitorList.Objects[ J ] and 4 <> 0) OR
               (pos( '\', CopyEnd( Path, Length( S )+1 )) <= 0)
             ) then
          begin
            S := FiltersList.Items[ J ];
            if S = '' then Satisfied := TRUE
            else
            begin
              Satisfied := FALSE;
              while S <> '' do
              begin
                S1 := Parse( S, ';' );
                if StrSatisfy( DL.Names[ I ], S1 ) then
                begin
                  Satisfied := TRUE; break;
                end;
              end;
            end;
            if Satisfied then
            begin
              if not FirstHandling then
              begin
                if MonitorList.Objects[ J ] and 3 = 2 then break; // Action = not handle
                FT := DL.Items[ I ].ftLastWriteTime;
                FileTimeToSystemTime( FT, ST );
                SystemTime2DateTime( ST, ChangeTime );
                ChangeTime := DateTime_System2Local( ChangeTime );
                TimeElapsed := Now - ChangeTime;
                Time2Wait := FiltersList.Objects[ J ];
                if TimeElapsed * 24 * 3600 < Time2Wait then
                begin
                  AllHandled := FALSE;
                  break; // ¬рем€ ожидани€ еще не вышло
                end;
              end;
              HandleFileChange( DL.Path + DL.Names[ I ], MonitorList.Objects[ J ] and 3 );
            end;
          end;
        end;
      end;
    end;
    if not AllHandled then
    begin
      I := DirChangesQueue.IndexOf( Path );
      if I < 0 then
      begin
        DirChangesQueue.Add( Path );
        ShowQueued;
      end;
    end;
  FINALLY
    DL.Free;
  END;
end;

procedure TfmMainGuard.HandleFileChange(const FilePath: String;
  Action: Integer);
var ChkSum: DWORD;
begin
  Applet.ProcessMessages;
  if not Storage.OK then Exit;
  if not Storage.CheckFile( FilePath, ChkSum ) then
    Storage.UpdateFile( FilePath, ChkSum, Action );
  //Log( 'File: ' + FilePath );
end;

procedure TfmMainGuard.lLinkMouseEnter(Sender: PObj);
begin
  lLink.Font.FontStyle := [ fsItalic, fsUnderline ];
end;

procedure TfmMainGuard.lLinkMouseLeave(Sender: PObj);
begin
  lLink.Font.FontStyle := [ fsUnderline ];
end;

procedure TfmMainGuard.lLinkClick(Sender: PObj);
begin
  ShellExecute( 0, nil, 'http://bonanzas.rinet.ru', nil, nil, SW_SHOW );
end;

procedure TfmMainGuard.DirChanged(Sender: PObj; const Path: string);
begin
  DirChanged( Sender, Path, FALSE );
end;

procedure TfmMainGuard.RebuildStorageTree;
var DL, DL1: PDirList;
    I, J, P: Integer;
    L: PStrListEx;
    FS: PStream;
    S: String;
begin
  StorageTreeChanged := FALSE;
  if not Storage.OK then
  begin
    tvDirs.Clear;
    Exit;
  end;
  //DL := NewDirList( eStoragePath.Text, '*.*', FILE_ATTRIBUTE_DIRECTORY );
  DL := NewDirList( '', '', 0 );
  DL.OnItem := AcceptDirItem;
  DL.ScanDirectory( eStoragePath.Text, '*.*', FILE_ATTRIBUTE_DIRECTORY );
  TRY
    for I := 0 to DL.Count-1 do
    begin
      //Applet.ProcessMessages;
      if DL.IsDirectory[ I ] and FileExists( DL.Path + DL.Names[ I ] + '\FileGuard.dir' ) then
      begin
        if tvDirs.TVRoot = 0 then
          tvDirs.TVInsert( 0, 0, 'ROOT' );
        AddPathToTVDirs( DL.Names[ I ], -1 );
        //DL1 := NewDirList( DL.Path + DL.Names[ I ] + '\', '*.*', FILE_ATTRIBUTE_NORMAL );
        DL1 := NewDirList( '', '', 0 );
        DL1.OnItem := AcceptDirItem;
        DL1.ScanDirectory( DL.Path + DL.Names[ I ] + '\', '*.*', FILE_ATTRIBUTE_NORMAL );
        L := NewStrListEx;
        TRY
          for J := 0 to DL1.Count-1 do
          begin
            //Applet.ProcessMessages;
            if not DL1.IsDirectory[ J ] then
            begin
              P := Str2Int( DL1.Names[ J ] );
              if (P > 0) and (L.IndexOfObj( Pointer( P ) ) < 0) then
              begin
                FS := NewReadFileStream( DL1.Path + DL1.Names[ J ] );
                TRY
                  if FS.Handle <> INVALID_HANDLE_VALUE then
                  begin
                    S := FS.ReadStrZ;
                    L.AddObject( S, P );
                    AddPathToTVDirs( DL.Names[ I ] + '\' + S, P );
                  end;
                FINALLY
                  FS.Free;
                END;
              end;
            end;
          end;
        FINALLY
          DL1.Free;
          L.Free;
        END;
      end;
    end;
  FINALLY
    DL.Free;
  END;
end;

procedure TfmMainGuard.AddPathToTVDirs(DirPath: String; Obj: Integer);
var Node, Child: THandle;
    DName, SrcPath: String;
    I: Integer;
begin
  Applet.ProcessMessages;
  SrcPath := DirPath;
  I := pos( ':', SrcPath );
  if I > 0 then
    SrcPath := CopyEnd( SrcPath, I-1 );
  Node := tvDirs.TVRoot;
  while TRUE do
  begin
    DName := Parse( DirPath, '\' );
    if DName = '' then
    begin
      if Obj > 0 then
        tvDirs.TVItemData[ Node ] := Pointer( Obj );
      Exit;
    end;
    Child := tvDirs.TVItemChild[ Node ];
    while Child <> 0 do
    begin
      Applet.ProcessMessages;
      if AnsiEq( tvDirs.TVItemText[ Child ], DName ) then
      begin
        Node := Child;
        DName := Parse( DirPath, '\' );
        if DName = '' then
        begin
          if Obj > 0 then
            tvDirs.TVItemData[ Child ] := Pointer( Obj );
          Exit;
        end;
        Child := tvDirs.TVItemChild[ Node ];
        continue;
      end;
      Child := tvDirs.TVItemNext[ Child ];
    end;
    Child := tvDirs.TVInsert( Node, 0, DName );
    if DirPath = '' then
      tvDirs.TVItemData[ Child ] := Pointer( Obj );

    if (DirPath = '') and (Obj = -1) then
    begin
      tvDirs.TVItemImage[ Child ] := FileIconSystemIdx( ParamStr( 0 ) );
    end
    else
      if pos( ':', DName ) > 0 then
        tvDirs.TVItemImage[ Child ] := FileIconSysIdxOffline( 'C:\' )
      else
        tvDirs.TVItemImage[ Child ] := FileIconSystemIdx( GetStartDir );

    tvDirs.TVItemSelImg[ Child ] := tvDirs.TVItemImage[ Child ];
    tvDirs.TVSort( Node );
    if DirPath = '' then Exit;
    Node := Child;
  end;
end;

procedure TfmMainGuard.lvFilesLVData(Sender: PControl; Idx,
  SubItem: Integer; var Txt: String; var ImgIdx: Integer;
  var State: Cardinal; var Store: Boolean);
var DirData: PDirData;
    ST: TSystemTime;
    DT: TDateTime;
begin
  DirData := Pointer( Directory.Objects[ Idx ] );
  CASE SubItem OF
  ColName: Txt := Directory.Items[ Idx ];
  ColDate: begin
             FileTimeToSystemTime( DirData.FT, ST );
             SystemTime2DateTime( ST, DT );
             DT := DateTime_System2Local( DT );
             Txt := DateTime2StrShort( DT );
           end;
  ColSize: begin
             Txt := Num2Bytes( DirData.Sz );
           end;
  ColUsed: begin
             Txt := Num2Bytes( DirData.TotalSz );
           end;
  END;
  ImgIdx := FileIconSysIdxOffline( Directory_Path + Directory.Items[ Idx ] );
end;

procedure TfmMainGuard.ClearDirectory;
var I: Integer;
    DirData: PDirData;
begin
  lvFiles.LVCount := 0;
  for I := 0 to Directory.Count-1 do
  begin
    DirData := Pointer( Directory.Objects[ I ] );
    if DirData <> nil then
      FreeMem( DirData );
  end;
  Directory.Clear;
  Directory_Path := '';
  Directory_Root := '';
  Directory_Prefix := '';
end;

procedure TfmMainGuard.tvDirsSelChange(Sender: PObj);
var Node, Node0: THandle;
    DL: PDirList;
    I, P: Integer;
    DirData: PDirData;
    FN: String;
    FS: PStream;
begin
  Node := tvDirs.TVSelected;
  Node0 := Node;
  ClearDirectory;
  if Node <> 0 then
  begin
    Directory_Path := '';
    while (Node <> 0) and (pos( ':', Directory_Path ) <= 0) do
    begin
      Directory_Path := tvDirs.TVItemText[ Node ] + '\' + Directory_Path;
      Node := tvDirs.TVItemParent[ Node ];
    end;
    if Node = 0 then Exit;
    Directory_Prefix := '';
    if Integer( tvDirs.TVItemData[ Node0 ] ) > 0 then
      Directory_Prefix := Format( '%.08d+',
        [ Integer( tvDirs.TVItemData[ Node0 ] ) ] );
    Directory_Root := tvDirs.TVItemText[ Node ] + '\';
    Directory_Path := Directory_Root + Directory_Path;
    P := Integer( tvDirs.TVItemData[ Node0 ] );
    if P <= 0 then Exit;
    //DL := NewDirList( IncludeTrailingPathDelimiter( eStoragePath.Text ) +
    //  tvDirs.TVItemText[ Node ] + '\',
    //  Format( '%.08d', [ P ] ) + '+*.*', FILE_ATTRIBUTE_NORMAL );
    DL := NewDirList( '','', 0 );
    DL.OnItem := AcceptDirItem;
    DL.ScanDirectory( IncludeTrailingPathDelimiter( eStoragePath.Text ) +
      tvDirs.TVItemText[ Node ] + '\',
      Format( '%.08d', [ P ] ) + '+*.*', FILE_ATTRIBUTE_NORMAL );
    TRY
      for I := 0 to DL.Count-1 do
      begin
        if not DL.IsDirectory[ I ] then
        begin
          FN := CopyEnd( DL.Names[ I ], 10 );
          DirData := AllocMem( Sizeof( TDirData ) );
          FS := NewReadFileStream( DL.Path + DL.Names[ I ] );
          TRY
            Storage.EnumSections( FS, Storage.LookForLastVersionInfo );
          FINALLY
            FS.Free;
          END;
          DirData.FT := Storage.LastInfo.FT;
          DirData.Sz := Storage.LastInfo.Sz;
          DirData.TotalSz := DL.Items[ I ].nFileSizeLow;
          Directory.AddObject( FN, DWORD( DirData ) );
        end;
      end;
      Directory.Sort( FALSE );
      lvFiles.LVCount := Directory.Count;
    FINALLY
      DL.Free;
    END;
  end;
end;

procedure TfmMainGuard.pm2pmHistoryMenu(Sender: PMenu; Item: Integer);
var FS: PStream;
    LI: Integer;
begin
  LI := lvFiles.LVCurItem;
  if LI < 0 then Exit;
  if fmHistory = nil then
    NewfmHistory( fmHistory, Applet );
  FS := NewReadFileStream( IncludeTrailingPathDelimiter( eStoragePath.Text )
     + Directory_Root + Directory_Prefix + Directory.Items[ LI ] );
  TRY
    fmHistory.CurFile := LI;
    fmHistory.HL.Clear;
    Storage.EnumSections( FS, CollectAllVersionsInfo );
    fmHistory.lvHistory.LVCount := fmHistory.HL.Count;
    if (fmHistory.lvHistory.LVCount > 0) and (fmHistory.lvHistory.LVCurItem < 0) then
      fmHistory.lvHistory.LVCurItem := 0;
  FINALLY //
    FS.Free;
  END;
  fmHistory.Form.Caption := 'History of version: ' + Directory.Items[ LI ];
  fmHistory.CurFile := LI;
  if not fmHistory.Form.Visible then
    fmHistory.Form.Show;
  //fmHistory.Form.Hide;
end;

procedure TfmMainGuard.CollectAllVersionsInfo(FileStream: PStream;
  const FI: TFileVersionInfo; SecType: Byte; SecLen: DWORD;
  var Cont: Boolean);
var ST: TSystemTime;
    DT: TDateTime;
    L: DWORD;
begin
  FileTimeToSystemTime( FI.FT, ST );
  SystemTime2DateTime( ST, DT );
  DT := DateTime_System2Local( DT );
  FileStream.Position := FileStream.Position - 4;
  FileStream.Read( L, 4 );
  fmHistory.HL.Add( DateTime2StrShort( DT )+#9+Num2Bytes( FI.Sz )+#9+Int2Str( L ) );
end;

procedure TfmMainGuard.pm2pmRestoreMenu(Sender: PMenu; Item: Integer);
begin
  if fmRestore = nil then
  begin
    NewfmRestore( fmRestore, Applet );
    fmRestore.eDate.DateTime := Trunc( Now );
    fmRestore.eTime.DateTime := Frac( Now );
  end;
  fmRestore.lFilescount.Caption := Int2Str( lvFiles.LVSelCount );
  fmRestore.cSubdirsRecursively.Visible := FALSE;
  fmRestore.OnRestore := RestoreSelected;
  fmRestore.Form.Show;
end;

procedure TfmMainGuard.pm3pmDirRestoreMenu(Sender: PMenu; Item: Integer);
var S: String;
    N: Integer;
begin
  if fmRestore = nil then
  begin
    NewfmRestore( fmRestore, Applet );
    fmRestore.eDate.DateTime := Trunc( Now );
    fmRestore.eTime.DateTime := Frac( Now );
  end;
  S := Int2Str( Directory.Count ) + ' files';
  N := tvDirs.TVItemChildCount[ tvDirs.TVSelected ];
  if N > 0 then
    S := S + ' and ' + Int2Str( N ) + ' dirs';
  fmRestore.lFilescount.Caption := S;
  fmRestore.cSubdirsRecursively.Visible := TRUE;
  fmRestore.OnRestore := RestoreSubdirs;
  fmRestore.Form.Show;
  //fmRestore.Form.Hide;
end;

procedure TfmMainGuard.AddFilesFromSubdirs(SL: PStrList; Node: THandle;
  SubdirsRecursively: Boolean);
var Child: THandle;
    P: Integer;
    DL: PDirList;
    I: Integer;
begin
  Child := tvDirs.TVItemChild[ Node ];
  while Child <> 0 do
  begin
    P := Integer( tvDirs.TVItemData[ Child ] );
    if P > 0 then
    begin
      //DL := NewDirList( IncludeTrailingPathDelimiter( eStoragePath.Text ) +
      //  Directory_Root, Format( '%.08d+', [ P ] ) + '*.*', FILE_ATTRIBUTE_NORMAL  );
      DL := NewDirList( '', '', 0 );
      DL.OnItem := AcceptDirItem;
      DL.ScanDirectory( IncludeTrailingPathDelimiter( eStoragePath.Text ) +
        Directory_Root, Format( '%.08d+', [ P ] ) + '*.*', FILE_ATTRIBUTE_NORMAL  );
      TRY
        for I := 0 to DL.Count-1 do
        if not DL.IsDirectory[ I ] then
        begin
          SL.Add( Directory_Root + DL.Names[ I ] );
        end;
      FINALLY
        DL.Free;
      END;
    end;
    if SubdirsRecursively then
      AddFilesFromSubdirs( SL, Child, TRUE );
    Child := tvDirs.TVItemNext[ Child ];
  end;
end;

procedure TfmMainGuard.RestoreFiles(FileList: PStrList);
var I: Integer;
    FS, VS, DS: PStream;
    S, FN: String;
    Yes_All: Boolean;
    Q: Integer;
begin
  Yes_All := FALSE;
  for I := 0 to FileList.Count-1 do
  begin
    Log( 'Restore: ' + FileList.Items[ I ] );
    FN := CopyEnd( ExtractFileName( FileList.Items[ I ] ), 10 );
    FS := nil;
    while TRUE do
    begin
      Applet.ProcessMessages;
      FS := NewReadFileStream( IncludeTrailingPathDelimiter( eStoragePath.Text ) +
        FileList.Items[ I ] );
      if FS.Handle = INVALID_HANDLE_VALUE then
      begin
        Log( 'Can not open ' + IncludeTrailingPathDelimiter( eStoragePath.Text ) +
          FileList.Items[ I ] );
        CASE MessageBox( Form.Handle, PChar( 'Can not open file ' +
          IncludeTrailingPathDelimiter( eStoragePath.Text ) +
          FileList.Items[ I ] ), Pchar( Applet.Caption ),
          MB_RETRYCANCEL ) OF
        ID_CANCEL: Exit;
        ID_RETRY: continue;
        END;
      end;
      break;
    end;
    TRY
      VS := NewMemoryStream;
      TRY
        VerFileName := FileList.Items[ I ];
        VerDate := fmRestore.eDate.Date + fmRestore.eTime.Time;
        VersionFile := VS;
        VerIdx := 0;
        Storage.EnumSections( FS, RestoreForDate );
        if VS.Size = 0 then
        begin
          Log( 'File not restored - 0 bytes read' );
        end
          else
        begin
          FS.Position := 0;
          S := FS.ReadStrZ;
          if not DirectoryExists( S ) then
          begin
            if Yes_All then Q := 0
            else
              Q := ShowQuestion( 'Directory ' +  S + ' not exists. Create it?',
                'Yes/Yes All/No, cancel' );
            if Q = 1 then Yes_All := TRUE;
            CASE Q OF
            0, 1:
              begin
                MkDir( S );
                if not DirectoryExists( S ) then
                begin
                  ShowMessage( 'Could not create directory ' + S + '. ' +
                             'Operation aborted.' ); Exit;
                end;
                PrepareTree;
              end;
            2: Exit;
            END;
          end;
          if FileExists( S + FN ) then
            DeleteFile2Recycle( S + FN );
          DS := NewWriteFileStream( S + FN );
          TRY
            if DS.Handle = INVALID_HANDLE_VALUE then
            begin
              ShowMessage( 'Can not write file ' + S + FN + '. Operation is ' +
                'aborting. If the existing file already deleted, you can restore ' +
                'it from Recycle.' ); Exit;
            end;
            VS.Position := 0;
            Stream2Stream( DS, VS, VS.Size );
            Log( 'Restored: ' + S + FN );
          FINALLY
            DS.Free;
          END;
        end;
      FINALLY
        VS.Free;
      END;
    FINALLY
      FS.Free;
    END;
  end;
end;

procedure TfmMainGuard.RestoreForDate(FileStream: PStream;
  const FI: TFileVersionInfo; SecType: Byte; SecLen: DWORD;
  var Cont: Boolean);
var L: DWORD;
    US: PStream;
    OldVersion, CmdStream: PStream;
    ST: TSystemTime;
    DT: TDateTime;
begin
  Inc( VerIdx );
  FileTimeToSystemTime( FI.FT, ST );
  SystemTime2DateTime( ST, DT );
  DT := DateTime_Local2System( DT );
  if (VersionFile.Size > 0) and (DT > VerDate) then
  begin
    Cont := FALSE; // восстановлено за предшествующую дату, дажльше не надо
    Exit;
  end;
  if SecType and 1 = 0 then
  begin // полна€ верси€ здесь
    VersionFile.Position := 0;
    if SecType and 2 = 0 then
      Stream2Stream( VersionFile, FileStream, SecLen )
    else
    begin // сжата€ полна€ верси€
      FileStream.Read( L, 4 );
      US := DIUCLStreams.NewUclDStream( $80000, FileStream, UCLOnProgress );
      TRY
        Stream2Stream( VersionFile, US, L );
      FINALLY
        US.Free;
      END;
    end;
  end
    else
  begin // обновление от предыдущей версии здесь
    OldVersion := NewMemoryStream;
    CmdStream := NewMemoryStream;
    TRY
      if SecType and 2 = 0 then
        Stream2Stream( CmdStream, FileStream, SecLen )
      else
      begin // командный поток сжат
        FileStream.Read( L, 4 );
        US := DIUCLStreams.NewUclDStream( $80000, FileStream, UCLOnProgress );
        TRY
          Stream2Stream( CmdStream, FileStream, L );
        FINALLY
          US.Free;
        END;
      end;
      // теперь распаковка новой версии
      if CmdStream.Size > 0 then
      begin
        VersionFile.Position := 0;
        Stream2Stream( OldVersion, VersionFile, VersionFile.Size );
        OldVersion.Position := 0;
        VersionFile.Position := 0;
        CmdStream.Position := 0;
        if not DoApplyUpdates( VersionFile, OldVersion, CmdStream ) then
        begin
          Log( 'Can not unpack version #' + Int2Str( VerIdx ) + ' of ' + VerFileName );
          VersionFile.Position := 0;
          OldVersion.Position := 0;
          Stream2Stream( VersionFile, OldVersion, OldVersion.Size );
          Cont := FALSE;
        end;
      end
        else
        VersionFile.Position := VersionFile.Size;
    FINALLY
      OldVersion.Free;
      CmdStream.Free;
    END;
  end;
  VersionFile.Size := VersionFile.Position;
  VersionFile.Position := 0;
end;

procedure TfmMainGuard.KOLForm1Minimize(Sender: PObj);
begin
  Form.Hide;
  TimerHide.Enabled := TRUE;
end;

procedure TfmMainGuard.TimerHideTimer(Sender: PObj);
begin
  TimerHide.Enabled := FALSE;
  if not Form.Visible and Applet.Visible then
    Applet.Hide;
end;

procedure TfmMainGuard.RestoreSubdirs(Sender: PObj);
var SL: PStrList;
    LI: Integer;
begin
  SL := NewStrList;
  TRY
    for LI := 0 to Directory.Count-1 do
      SL.Add( Directory_Root + Directory_Prefix + Directory.Items[ LI ] );
    if fmRestore.cSubdirsRecursively.Checked then
      AddFilesFromSubdirs( SL, tvDirs.TVSelected, TRUE );
    RestoreFiles( SL );
  FINALLY
    SL.Free;
  END;
end;

procedure TfmMainGuard.RestoreSelected(Sender: PObj);
var SL: PStrList;
    LI: Integer;
begin
  SL := NewStrList;
  TRY
    LI := lvFiles.LVCurItem;
    while LI >= 0 do
    begin
      SL.Add( Directory_Prefix + Directory.Items[ LI ] );
      LI := lvFiles.LVNextSelected( LI );
    end;
    RestoreFiles( SL );
  FINALLY
    SL.Free;
  END;
end;

procedure TfmMainGuard.UCLOnProgress(const Sender: PObj; const InBytes, OutBytes: Cardinal );
begin
  if Abs( Integer( GetTickCount - LastUCLProgress ) ) > 100 then
  begin
    LastUCLProgress := GetTickCount;
    Applet.ProcessMessages;
  end;
end;

procedure TfmMainGuard.lvFilesLVStateChange(Sender: PControl; IdxFrom,
  IdxTo: Integer; OldState, NewState: Cardinal);
begin
  if fmHistory <> nil then
  if fmHistory.Form.Visible then
  if lvFiles.LVCurItem >= 0 then
  begin
    pm2pmHistoryMenu( nil, 0 );
  end;
end;

procedure TfmMainGuard.pm3pmDirOpenMenu(Sender: PMenu; Item: Integer);
var S: String;
begin
  if tvDirs.TVSelected = 0 then Exit;
  S := tvDirs.TVItemPath( tvDirs.TVSelected, '\' );
  Parse( S, '\' ); // ROOT\...
  Parse( S, '\' ); // machinename\...
  if not DirectoryExists( S ) then
    ShowMessage( 'Directory does not exists: ' + S )
  else
    ShellExecute( 0, nil, PChar( IncludeTrailingPathDelimiter( S ) ),
      nil, nil, SW_SHOW );
end;

procedure TfmMainGuard.lvFilesMouseDblClk(Sender: PControl;
  var Mouse: TMouseEventData);
begin
  ViewFile;
end;

procedure TfmMainGuard.ViewFile;
begin
  if fmHistory = nil then
    NewfmHistory( fmHistory, Applet );
  fmHistory.VerIdx := MaxInt;
  fmHistory.CurFile := lvFiles.LVCurItem;
  if fmHistory.CurFile >= 0 then
    fmHistory.ViewHistory;
end;

procedure TfmMainGuard.lvFilesKeyDown(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
begin
  if Key = VK_RETURN then
    ViewFile;
end;

procedure TfmMainGuard.TimerCheckConnectTimer(Sender: PObj);
begin
  TimerCheckConnect.Enabled := FALSE;
  eStoragePathChange( nil );
end;

function TfmMainGuard.ThreadRescanStorageTreeExecute(
  Sender: PThread): Integer;
begin
  while not AppletTerminated do
  begin
    RebuildStorageTree;
    Sender.Suspend;
  end;
  Result := 0;
end;

procedure TfmMainGuard.AcceptDirItem(Sender: PObj;
  var FindData: TWin32FindData; var Action: TDirItemAction);
begin
  if AppletTerminated then
    Action := diCancel
  else
    Applet.ProcessMessages;
end;

procedure TfmMainGuard.ShowQueued;
begin
  if DirChangesQueue.Count > 0 then
    lQueued.Caption := 'Queued: ' + Int2Str( DirChangesQueue.Count ) + ' dirs'
  else
    lQueued.Caption := '';
  Global_Align( pnLogInfo );
end;

end.






