unit DirTreeView;
{* Simple extension for tree view control: directory list view. }

interface

uses Windows, messages, KOL, shellApi;

type
  TIconOptions = ( ioReal, ioOffline, ioNone );
  {*    ioReal = real folder icons are used;
  |<br> ioOffline = real icons are used only for root nodes, all other
        folders represented with the same standard folder icon;
  |<br> ioNone = icons are not used. }

function NewDirTreeView( AParent: PControl; Options: TTreeViewOptions;
         IconOptions: TIconOptions; const Path: String ): PControl;
{* Creates new tree view control with given directory loaded as root.
   If Path = '*', all disks are loaded to the root. If Path = '', there are no
   disks or directories loaded initially. Call SetDirTreeViewRootPath procedure
   later to fill it. }

procedure SetDirTreeViewRootPath( DirTreeView: PControl; const Path: String );
{* Call this function to change root directory for DirTreeView control (must
   be created by function NewDirTreeView). Rules on Path parameter are the
   same as for constructing function NewDirTreeView. }

type
  TKOLDirTreeView = PControl; // fake declaration

implementation

type
  PDirTreeViewData = ^TDirTreeViewData;
  TDirTreeViewData = packed record
    IconOptions: TIconOptions;
  end;

var IL: PImageList = nil;
    FolderIconIdx: Integer;

function GetFolderIconIdx: Integer;
var SFI: TShFileInfo;
begin
  if FolderIconIdx = 0 then
  begin
    ShGetFileInfo( nil, FILE_ATTRIBUTE_DIRECTORY, SFI, sizeof( SFI ),
                   SHGFI_ATTRIBUTES or SHGFI_ICON or SHGFI_SMALLICON or
                   SHGFI_SYSICONINDEX );
    FolderIconIdx := SFI.iIcon;
  end;
  Result := FolderIconIdx;
end;

procedure FillChildren( Sender: PControl; Item: THandle );
var DL: PDirList;
    I, Ico: Integer;
    SubItem: THandle;
    DTVData: PDirTreeViewData;
begin
  SubItem := Sender.TVItemChild[ Item ];
  if SubItem <> 0 then Exit;
  DL := NewDirListEx( IncludeTrailingPathDelimiter(
                      Sender.TVItemPath( Item, '\' ) ), '*',
                      FILE_ATTRIBUTE_DIRECTORY );

  DTVData := Sender.CustomData;
  Sender.BeginUpdate;
  for I := 0 to DL.Count-1 do
  begin
    SubItem := Sender.TVInsert( Item, TVI_SORT, DL.Names[ I ] );
    case DTVData.IconOptions of
    ioReal: Ico := FileIconSystemIdx( DL.Path + DL.Names[ I ] );
    ioOffline: Ico := GetFolderIconIdx;
    else Ico := -1;
    end;
    Sender.TVItemImage[ SubItem ] := Ico;
    Sender.TVItemSelImg[ SubItem ] := Ico;
    if DirectoryHasSubdirs( DL.Path + DL.Names[ I ] ) then
      Sender.TVItemHasChildren[ SubItem ] := TRUE;
  end;
  Sender.EndUpdate;
  DL.Free;
end;

function WndProcDirTreeView( Sender: PControl; var Msg: TMsg; var Rslt: Integer ): Boolean;
var NM: PNMTreeView;
begin
  if Msg.message = WM_NOTIFY then
  begin
    NM := Pointer( Msg.lParam );
    case NM.hdr.code of
    TVN_ITEMEXPANDING:
      begin
        if NM.action=TVE_EXPAND then
        begin
          FillChildren( Sender, NM.itemNew.hItem );
        end;
      end;
    end;
  end;
  Result := FALSE;
end;

procedure SetDirTreeViewRootPath( DirTreeView: PControl; const Path: String );
var Root: THandle;
    C: Char;
    DrivesMask: Integer;
begin
  DirTreeView.BeginUpdate;
  DirTreeView.Clear;
  if Path <> '' then
  if Path = '*' then
  begin
    DrivesMask := GetLogicalDrives;
    Root := 0;
    for C := 'A' to 'Z' do
    begin
      if LongBool( DrivesMask and 1 ) then
      begin
        Root := DirTreeView.TVInsert( 0, Root, C + ':' );
        DirTreeView.TVItemImage[ Root ] := FileIconSystemIdx( C + ':\' );
        DirTreeView.TVItemSelImg[ Root ] := DirTreeView.TVItemImage[ Root ];
        DirTreeView.TVItemHasChildren[ Root ] := TRUE;
      end;
      DrivesMask := DrivesMask shr 1;
    end;
  end
    else
  begin
    Root := DirTreeView.TVInsert( 0, 0, ExcludeTrailingPathDelimiter( Path ) );
    DirTreeView.TVItemImage[ Root ] := FileIconSystemIdx( Path );
    DirTreeView.TVItemSelImg[ Root ] := DirTreeView.TVItemImage[ Root ];
    FillChildren( DirTreeView, Root );
    DirTreeView.TVExpand( Root, TVE_EXPAND );
  end;
  DirTreeView.EndUpdate;
end;

function NewDirTreeView( AParent: PControl; Options: TTreeViewOptions;
         IconOptions: TIconOptions; const Path: String ): PControl;
var DTVData: PDirTreeViewData;
begin
  if IconOptions <> ioNone then
  if IL = nil then
  begin
    IL := NewImageList( nil );
    IL.LoadSystemIcons( TRUE );
  end;
  Result := NewTreeView( AParent, Options, IL, nil );
  GetMem( DTVData, Sizeof( TDirTreeViewData ) );
  DTVData.IconOptions := IconOptions;
  Result.CustomData := DTVData;

  Result.AttachProc( WndProcDirTreeView );
  SetDirTreeViewRootPath( Result, Path );

end;

initialization

finalization
  if IL <> nil then
    IL.Free;

end.
