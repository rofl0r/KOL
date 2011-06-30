unit fmtmain;

// Test program for Magenta Check Disk and Format Disk component
// 20th October 2005 - Release 1.0 (C) Magenta Systems Ltd, 2005

// Copyright by Angus Robertson, Magenta Systems Ltd, England
// delphi@magsys.co.uk, http://www.magsys.co.uk/delphi/

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, magfmtdisk, FileCtrl, ComCtrls ;

type
  TMainForm = class(TForm)
    Log: TMemo;
    Panel1: TPanel;
    doChkDsk: TButton;
    doExit: TButton;
    DriveBox: TDriveComboBox;
    OptCorrectErrors: TCheckBox;
    OptVerbose: TCheckBox;
    OptCheckDirty: TCheckBox;
    OptScanDrive: TCheckBox;
    OptQuickFmt: TCheckBox;
    doAbort: TButton;
    doFrmtDsk: TButton;
    ProgressBar: TProgressBar;
    FileSystem: TComboBox;
    Label1: TLabel;
    VolumeLabel: TEdit;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure doChkDskClick(Sender: TObject);
    procedure doExitClick(Sender: TObject);
    procedure doAbortClick(Sender: TObject);
    procedure doFrmtDskClick(Sender: TObject);
  private
    { Private declarations }
    procedure LogInfo (Info: String) ;
    procedure ProgressEvent (Percent: integer; var Cancel: boolean) ;
    procedure InfoEvent (Info: string; var Cancel: boolean) ;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  MagFmtChkDsk: TMagFmtChkDsk ;
  CancelFlag: boolean ;

implementation

{$R *.dfm}

procedure TMainForm.FormDestroy(Sender: TObject);
begin
    FreeAndNil (MagFmtChkDsk) ;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
    MagFmtChkDsk := TMagFmtChkDsk.Create (self) ;
    MagFmtChkDsk.onProgressEvent := ProgressEvent ;
    MagFmtChkDsk.onInfoEvent := InfoEvent ;
end;

procedure TMainForm.LogInfo (Info: String) ;
begin
    Log.Lines.Add (Info) ;
end ;

procedure 