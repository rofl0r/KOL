{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit HistoryUnit;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes, Controls, mckControls, mckObjs, Graphics,
  mckCtrls {$ENDIF}, FileVersionUnit;
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TfmHistory = class; PfmHistory = TfmHistory; {$ELSE OBJECTS} PfmHistory = ^TfmHistory; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TfmHistory.inc}{$ELSE} TfmHistory = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TfmHistory = class(TForm)
  {$ENDIF KOL_MCK}
    KOLForm1: TKOLForm;
    lvHistory: TKOLListView;
    dSaveAs: TKOLOpenSaveDialog;
    Panel1: TKOLPanel;
    Panel2: TKOLPanel;
    Toolbar1: TKOLToolbar;
    Panel3: TKOLPanel;
    Toolbar2: TKOLToolbar;
    procedure KOLForm1Destroy(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure KOLForm1Show(Sender: PObj);
    procedure lvHistoryLVData(Sender: PControl; Idx, SubItem: Integer;
      var Txt: String; var ImgIdx: Integer; var State: Cardinal;
      var Store: Boolean);
    procedure KOLForm1Close(Sender: PObj; var Accept: Boolean);
    procedure lvHistoryLVStateChange(Sender: PControl; IdxFrom,
      IdxTo: Integer; OldState, NewState: Cardinal);
    procedure Toolbar1TBSaveClick(Sender: PControl; BtnID: Integer);
    procedure Toolbar1TBViewClick(Sender: PControl; BtnID: Integer);
    procedure lvHistoryMouseDblClk(Sender: PControl;
      var Mouse: TMouseEventData);
    procedure lvHistoryKeyDown(Sender: PControl; var Key: Integer;
      Shift: Cardinal);
    procedure Toolbar1TBCloseClick(Sender: PControl; BtnID: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    HL: PStrList;
    CurFile: Integer;
    VerIdx, VerIdx0: Integer;
    FileVersion: PStream;
    VerError: Boolean;
    procedure GetVersion( FileStream: PStream; const FI: TFileVersionInfo;
      SecType: Byte; SecLen: DWORD; var Cont: Boolean );
    procedure ViewHistory;
  end;

var
  fmHistory {$IFDEF KOL_MCK} : PfmHistory {$ELSE} : TfmHistory {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewfmHistory( var Result: PfmHistory; AParent: PControl );
{$ENDIF}

implementation

uses MainUnit, StorageUnit, DIUCLStreams, UpdatesUnit;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I HistoryUnit_1.inc}
{$ENDIF}

var FirstShow: Boolean = TRUE;
procedure TfmHistory.KOLForm1Destroy(Sender: PObj);
begin
  HL.Free;
  fmHistory := nil;
  FirstShow := TRUE;
end;

procedure TfmHistory.KOLForm1FormCreate(Sender: PObj);
begin
  HL := NewStrList;
end;

procedure TfmHistory.KOLForm1Show(Sender: PObj);
var DR: TRect;
begin
  if FirstShow then
  begin
    FirstShow := FALSE;
    DR := GetDesktopRect;
    Form.Left := Min( DR.Right - Form.Width, fmMainGuard.Form.Left + fmMainGuard.Form.Width );
  end;
  lvHistory.LVCount := HL.Count;
  if (lvHistory.LVCount > 0) and (lvHistory.LVCurItem < 0) then
    lvHistory.LVCurItem := 0;
end;

procedure TfmHistory.lvHistoryLVData(Sender: PControl; Idx,
  SubItem: Integer; var Txt: String; var ImgIdx: Integer;
  var State: Cardinal; var Store: Boolean);
var S: String;
begin
  S := HL.Items[ Idx ];
  CASE SubItem OF
  ColDate: S := Parse( S, #9 );
  ColSize: begin
             Parse( S, #9 );
             S := Parse( S, #9 );
           end;
  colUsed: begin
             Parse( S, #9 );
             Parse( S, #9 );
           end;
  END;
  Txt := S;
end;

procedure TfmHistory.KOLForm1Close(Sender: PObj; var Accept: Boolean);
begin
  Accept := FALSE;
  Form.Hide;
  Applet.Show;
  if Applet.WindowState = wsMinimized then
    AppletRestore;
  fmMainGuard.Form.Show;
end;

procedure TfmHistory.lvHistoryLVStateChange(Sender: PControl; IdxFrom,
  IdxTo: Integer; OldState, NewState: Cardinal);
begin
  if lvHistory.LVCurItem < 0 then
  begin
    Toolbar1.TBButtonEnabled[ TBSave ] := FALSE;
    Toolbar1.TBButtonEnabled[ TBView ] := FALSE;
  end
    else
  begin
    Toolbar1.TBButtonEnabled[ TBSave ] := TRUE;
    Toolbar1.TBButtonEnabled[ TBView ] := TRUE;
  end;
end;

procedure TfmHistory.Toolbar1TBSaveClick(Sender: PControl; BtnID: Integer);
var FS, WS: PStream;
begin
  dSaveAs.Filename := fmMainGuard.Directory.Items[ CurFile ];
  if dSaveAs.Execute then
  begin
    dSaveAs.InitialDir := ExtractFilePath( dSaveAs.Filename );
    FS := NewReadFileStream( IncludeTrailingPathDelimiter( fmMainGuard.eStoragePath.Text )
     + fmMainGuard.Directory_Root + fmMainGuard.Directory_Prefix + fmMainGuard.Directory.Items[ CurFile ] );
    TRY
      VerIdx := lvHistory.LVCurItem;
      VerIdx0 := 0;
      FileVersion := NewMemoryStream;
      TRY
        VerError := FALSE;
        Storage.EnumSections( FS, GetVersion );
        if not VerError then
        begin
          FileVersion.Position := 0;
          WS := NewWriteFileStream( dSaveAs.Filename );
          TRY
            Stream2Stream( WS, FileVersion, FileVersion.Size );
          FINALLY
            WS.Free;
          END;
        end
          else
        begin
          ShowMessage( 'Could not unpack version requested due an error!' );
        end;
      FINALLY
        FileVersion.Free;
      END;
    FINALLY
      FS.Free;
    END;
  end;
end;

procedure TfmHistory.GetVersion(FileStream: PStream;
  const FI: TFileVersionInfo; SecType: Byte; SecLen: DWORD;
  var Cont: Boolean);
var L: DWORD;
    US: PStream;
    OldVersion, CmdStream: PStream;
begin
  Inc( VerIdx0 );
  TRY
    if SecType and 1 = 0 then
    begin // полная версия здесь
      VerError := FALSE;
      FileVersion.Position := 0;
      if SecType and 2 = 0 then
        Stream2Stream( FileVersion, FileStream, SecLen )
      else
      begin // сжатая полная версия
        FileStream.Read( L, 4 );
        US := DIUCLStreams.NewUclDStream( $80000, FileStream, fmMainGuard.UCLOnProgress );
        TRY
          Stream2Stream( FileVersion, US, L );
        FINALLY
          US.Free;
        END;
      end;
    end
      else
    begin // обновление от предыдущей версии здесь
      if VerError then Exit;
      OldVersion := NewMemoryStream;
      CmdStream := NewMemoryStream;
      TRY
        if SecType and 2 = 0 then
          Stream2Stream( CmdStream, FileStream, SecLen )
        else
        begin // командный поток сжат
          FileStream.Read( L, 4 );
          US := DIUCLStreams.NewUclDStream( $80000, FileStream, fmMainGuard.UCLOnProgress );
          TRY
            Stream2Stream( CmdStream, FileStream, L );
          FINALLY
            US.Free;
          END;
        end;
        // теперь распаковка новой версии
        if CmdStream.Size > 0 then
        begin
          FileVersion.Position := 0;
          Stream2Stream( OldVersion, FileVersion, FileVersion.Size );
          OldVersion.Position := 0;
          FileVersion.Position := 0;
          CmdStream.Position := 0;
          if not DoApplyUpdates( FileVersion, OldVersion, CmdStream ) then
          begin
            Log( 'Could not unpack file ' + fmMainGuard.Directory.Items[ CurFile ] +
                 ', version #' + Int2Str( VerIdx0 ) );
            VerError := TRUE;
            OldVersion.Position := 0;
            FileVersion.Position := 0;
            Stream2Stream( FileVersion, OldVersion, OldVersion.Size );
            //Cont := FALSE;
            FileVersion.Size := FileVersion.Position;
            FileVersion.Position := 0;
            Exit;
          end;
        end
          else
          FileVersion.Position := FileVersion.Size;
      FINALLY
        OldVersion.Free;
        CmdStream.Free;
      END;
    end;
    FileVersion.Size := FileVersion.Position;
    FileVersion.Position := 0;
  FINALLY
    Dec( VerIdx );
    Cont := VerIdx >= 0;
  END;
end;

procedure TfmHistory.Toolbar1TBViewClick(Sender: PControl; BtnID: Integer);
begin
  VerIdx := lvHistory.LVCurItem;
  ViewHistory;
end;

procedure TfmHistory.lvHistoryMouseDblClk(Sender: PControl;
  var Mouse: TMouseEventData);
begin
  if Toolbar1.TBButtonEnabled[ TBView ] then
    Toolbar1TBViewClick( nil, 0 );
end;

procedure TfmHistory.lvHistoryKeyDown(Sender: PControl; var Key: Integer;
  Shift: Cardinal);
begin
  if Key = VK_RETURN then
  if Toolbar1.TBButtonEnabled[ TBView ] then
    Toolbar1TBViewClick( nil, 0 );
end;

procedure TfmHistory.Toolbar1TBCloseClick(Sender: PControl;
  BtnID: Integer);
begin
  Form.Close;
end;

procedure TfmHistory.ViewHistory;
var FS, WS: PStream;
    Temp: String;
begin
  Temp := GetTempDir;
  FS := NewReadFileStream( IncludeTrailingPathDelimiter( fmMainGuard.eStoragePath.Text )
   + fmMainGuard.Directory_Root + fmMainGuard.Directory_Prefix + fmMainGuard.Directory.Items[ CurFile ] );
  TRY
    FileVersion := NewMemoryStream;
    TRY
      Storage.EnumSections( FS, GetVersion );
      FileVersion.Position := 0;
      WS := NewWriteFileStream( Temp + fmMainGuard.Directory.Items[ CurFile ] );
      TRY
        Stream2Stream( WS, FileVersion, FileVersion.Size );
        if ShellExecute( 0, nil, PChar( Temp + fmMainGuard.Directory.Items[ CurFile ] ),
          nil, nil, SW_SHOW ) <= 32 then
          ShellExecute( 0, nil, 'notepad.exe', PChar( Temp + fmMainGuard.Directory.Items[ CurFile ] ),
            nil, SW_SHOW );
        DeleteFile( PChar( Temp + fmMainGuard.Directory.Items[ CurFile ] ) );
      FINALLY
        WS.Free;
      END;
    FINALLY
      FileVersion.Free;
    END;
  FINALLY
    FS.Free;
  END;
end;

end.




