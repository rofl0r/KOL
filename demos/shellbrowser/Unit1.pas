{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, DirTreeView {$IFNDEF KOL_MCK}, mirror, Classes,
  mckCtrls, Controls, MCKDirTreeView, mckObjs {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  PForm1 = ^TForm1;
  TForm1 = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    DirTree: TKOLDirTreeView;
    Splitter1: TKOLSplitter;
    FileView: TKOLListView;
    ilShell: TKOLImageList;
    PopupMenu1: TKOLPopupMenu;
    ilSmall: TKOLImageList;
    Toolbar1: TKOLToolbar;
    procedure DirTreeSelChange(Sender: PObj);
    procedure PopupMenu1pmiIconsMenu(Sender: PMenu; Item: Integer);
    procedure PopupMenu1pmiSmallMenu(Sender: PMenu; Item: Integer);
    procedure PopupMenu1pmiListMenu(Sender: PMenu; Item: Integer);
    procedure PopupMenu1pmiTableMenu(Sender: PMenu; Item: Integer);
    procedure PopupMenu1Popup(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure FileViewChar(Sender: PControl; var Key: Char;
      Shift: Cardinal);
    procedure FileViewMouseDblClk(Sender: PControl;
      var Mouse: TMouseEventData);
    procedure Toolbar1TBLevelUpClick(Sender: PControl; BtnID: Integer);
    procedure Toolbar1TBIconsClick(Sender: PControl; BtnID: Integer);
    procedure Toolbar1TBSmallClick(Sender: PControl; BtnID: Integer);
    procedure Toolbar1TBListClick(Sender: PControl; BtnID: Integer);
    procedure Toolbar1TBTableClick(Sender: PControl; BtnID: Integer);
  private
    { Private declarations }
    procedure SelectSubdir( LI: Integer );
    procedure LevelUp;
  public
    { Public declarations }
    CurrentDir: String;
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TForm1.DirTreeSelChange(Sender: PObj);
var N: DWORD;
    DL: PDirList;
    I, LI: Integer;
begin
  N := DirTree.TVSelected;
  if N = 0 then
    FileView.Clear
  else
  begin
    FileView.BeginUpdate;
    FileView.Clear;
    DL := NewDirList( DirTree.TVItemPath( N, '\' ), '*.*', 0 );
    CurrentDir := DL.Path;
    DL.Sort( [ sdrFoldersFirst, sdrByExt ] );
    for I := 0 to DL.Count-1 do
    begin
      LI := FileView.LVItemAdd( DL.Names[ I ] );
      FileView.LVItemImageIndex[ LI ] := FileIconSystemIdx( DL.Path + DL.Names[ I ] );
      FileView.LVItems[ LI, 1 ] := Num2Bytes( Int64_2Double( MakeInt64(
                        DL.Items[ I ].nFileSizeLow, DL.Items[ I ].nFileSizeHigh ) ) );
      FileView.LVItemData[ LI ] := DWORD( DL.IsDirectory[ I ] );
    end;
    DL.Free;
    FileView.EndUpdate;
  end;
end;

procedure TForm1.PopupMenu1pmiIconsMenu(Sender: PMenu; Item: Integer);
begin
  Toolbar1TBIconsClick( nil, TBIcons );
end;

procedure TForm1.PopupMenu1pmiSmallMenu(Sender: PMenu; Item: Integer);
begin
  Toolbar1TBSmallClick( nil, TBSmall );
end;

procedure TForm1.PopupMenu1pmiListMenu(Sender: PMenu; Item: Integer);
begin
  Toolbar1TBListClick( nil, TBList );
end;

procedure TForm1.PopupMenu1pmiTableMenu(Sender: PMenu; Item: Integer);
begin
  Toolbar1TBTableClick( nil, TBTable );
end;

procedure TForm1.PopupMenu1Popup(Sender: PObj);
  procedure Check( MenuItemIdx, TBButtonIdx: Integer );
  begin
    PopupMenu1.ItemChecked[ MenuItemIdx ] := TRUE;
    Toolbar1.TBButtonChecked[ TBButtonIdx ] := TRUE;
  end;
begin
  PopupMenu1.ItemChecked[ pmiIcons ] := FALSE;
  PopupMenu1.ItemChecked[ pmiSmall ] := FALSE;
  PopupMenu1.ItemChecked[ pmiList ] := FALSE;
  PopupMenu1.ItemChecked[ pmiTable ] := FALSE;
  Toolbar1.TBButtonChecked[ TBIcons ] := FALSE;
  Toolbar1.TBButtonChecked[ TBSmall ] := FALSE;
  Toolbar1.TBButtonChecked[ TBList ] := FALSE;
  Toolbar1.TBButtonChecked[ TBTable ] := FALSE;
  case FileView.LVStyle of
  lvsIcon:      Check( pmiIcons, TBIcons );
  lvsSmallIcon: Check( pmiSmall, TBSmall );
  lvsList:      Check( pmiList, TBList );
  lvsDetail:    Check( pmiTable, TBTable );
  end;
end;

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  FileView.LVColAdd( 'Name', taLeft, 200 );
  FileView.LVColAdd( 'Size', taRight, 90 );
  Toolbar1.TBButtonChecked[ TBIcons ] := TRUE;
end;

procedure TForm1.FileViewChar(Sender: PControl; var Key: Char;
  Shift: Cardinal);
var LI: Integer;
begin
  LI := FileView.CurIndex;
  if LI < 0 then Exit;
  if FileView.LVItemData[ LI ] = 0 then Exit;
  case Key of
  #13: SelectSubdir( LI );
  #8:  LevelUp;
  end;
end;

procedure TForm1.FileViewMouseDblClk(Sender: PControl;
  var Mouse: TMouseEventData);
var LI: Integer;
begin
  LI := FileView.CurIndex;
  if LI < 0 then Exit;
  if FileView.LVItemData[ LI ] = 0 then Exit;
  SelectSubdir( LI );
end;

procedure TForm1.SelectSubdir(LI: Integer);
var DirName: String;
    N: DWORD;
begin
  DirName := FileView.LVItems[ LI, 0 ];
  N := DirTree.TVSelected;
  if N = 0 then Exit;
  DirTree.TVExpand( N, TVE_EXPAND );
  N := DirTree.TVItemChild[ N ];
  while N <> 0 do
  begin
    if DirTree.TVItemText[ N ] = DirName then
    begin
      DirTree.TVSelected := N;
      break;
    end;
    N := DirTree.TVItemNext[ N ];
  end;
end;

procedure TForm1.LevelUp;
var N: DWORD;
    DirName: String;
    I: Integer;
begin
  N := DirTree.TVSelected;
  if N = 0 then Exit;
  DirName := DirTree.TVItemText[ N ];
  N := DirTree.TVItemParent[ N ];
  if N = 0 then Exit;
  DirTree.TVSelected := N;
  for I := 0 to FileView.Count-1 do
  begin
    if FileView.LVItems[ I, 0 ] = DirName then
    begin
      FileView.LVItemState[ -1 ] := [ ];
      FileView.LVItemState[ I ] := [ lvisSelect, lvisFocus ];
      FileView.Perform( LVM_ENSUREVISIBLE, I, 0 );
      break;
    end;
  end;
end;

procedure TForm1.Toolbar1TBLevelUpClick(Sender: PControl; BtnID: Integer);
begin
  LevelUp;
end;

procedure TForm1.Toolbar1TBIconsClick(Sender: PControl; BtnID: Integer);
begin
  FileView.LVStyle := lvsIcon;
  PopupMenu1Popup( nil );
end;

procedure TForm1.Toolbar1TBSmallClick(Sender: PControl; BtnID: Integer);
begin
  FileView.LVStyle := lvsSmallIcon;
  PopupMenu1Popup( nil );
end;

procedure TForm1.Toolbar1TBListClick(Sender: PControl; BtnID: Integer);
begin
  FileView.LVStyle := lvsList;
  PopupMenu1Popup( nil );
end;

procedure TForm1.Toolbar1TBTableClick(Sender: PControl; BtnID: Integer);
begin
  FileView.LVStyle := lvsDetail;
  PopupMenu1Popup( nil );
end;

end.



