//////////////////////////////////////////////////////////////////////////////////////////
//
//
//
//	Demo using KOL Winamp IO plugin
//	Written by Dimaxx
//
//
//
//////////////////////////////////////////////////////////////////////////////////////////

{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLTrackbar {$IFNDEF KOL_MCK}, mirror, Classes,  Graphics, Controls, mckCtrls,  mckTrackbar,  MCKMHTrackBar,
  mckObjs {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TForm1 = class; PForm1 = TForm1; {$ELSE OBJECTS} PForm1 = ^TForm1; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm1.inc}{$ELSE} TForm1 = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    Button1: TKOLButton;
    Button2: TKOLButton;
    Button3: TKOLButton;
    Button6: TKOLButton;
    Button7: TKOLButton;
    Button4: TKOLButton;
    Button5: TKOLButton;
    Button8: TKOLButton;
    TrackBar1: TKOLTrackBar;
    OpenDlg1: TKOLOpenSaveDialog;
    OpenDlg2: TKOLOpenSaveDialog;
    ListBox1: TKOLListBox;
    procedure Button1Click(Sender: PObj);
    procedure Button2Click(Sender: PObj);
    procedure Button3Click(Sender: PObj);
    procedure Button4Click(Sender: PObj);
    procedure Button5Click(Sender: PObj);
    procedure Button6Click(Sender: PObj);
    procedure Button7Click(Sender: PObj);
    procedure Button8Click(Sender: PObj);
    procedure TrackBar1Scroll(Sender: PTrackbar; Code: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

uses KOLIOPlug;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

var
  IMod: ^TInModule;
  OMod: ^TOutModule;
  S: string;

// if -1, changes ignored? :)
procedure SetInfo1(Bitrate,SRate,Stereo,Synched: integer); cdecl;
begin
  //
end;

function Dsp_IsActive1: integer; cdecl;
begin
  Result:=0;
end;

function Dsp_DoSamples1(Samples: pointer; NumSamples,Bps,Nch,SRate: integer): integer; cdecl;
begin
  Result:=NumSamples;
end;

procedure SAVSAInit1(maxlatency_in_ms:integer;srate:integer);cdecl;
begin
  //
end;

// call in Stop()
procedure SAVSADeInit1; cdecl;
begin
  //
end;

procedure SAAddPCMData1(PCMData: pointer; Nch,Bps,Timestamp: integer); cdecl;
begin
  //
end;

// gets csa (the current type (4=ws,2=osc,1=spec))
function SAGetMode1: integer; cdecl;
begin
  //
end;

// sets the spec data, filled in by winamp
procedure SAAdd1(Data: pointer; Timestamp,Csa: integer); cdecl;
begin
  //
end;

// sets the vis data directly from PCM data
procedure VSAAddPCMData1(PCMData: pointer; Nch,Bps,Timestamp: integer); cdecl;
begin
  //
end;

// use to figure out what to give to VSAAdd
function VSAGetMode1(var SpecNch: integer; var WaveNch: integer): integer; cdecl;
begin
  //
end;

// filled in by winamp, called by plug-in
procedure VSAAdd1(Data: pointer; Timestamp: integer); cdecl;
begin
  //
end;

procedure VSASetInfo1(Nch,SRate: integer); cdecl;
begin
  //
end;

procedure TForm1.Button1Click(Sender: PObj);
begin
  if OpenDlg2.Execute then S:=OpenDlg2.Filename;
end;

procedure TForm1.Button2Click(Sender: PObj);
begin
  if IMod.Play(PChar(S))=0 then
    begin
      ListBox1.Add('Playing '+S);
      Button2.Enabled:=False;
      Button3.Enabled:=True;
    end
  else ListBox1.Add('Cannot playing '+S);
end;

procedure TForm1.Button3Click(Sender: PObj);
begin
  IMod.Stop;
  Button2.Enabled:=True;
  Button3.Enabled:=False;
end;

procedure TForm1.Button4Click(Sender: PObj);
begin
  OpenDlg1.Filter:='Winamp Input plugin|in_*.dll';
  if not OpenDlg1.Execute then Exit;
  if not InitInputDLL(OpenDlg1.FileName) then
    begin
      ListBox1.Add('Failed to load input plugin!');
      Exit;
    end;
  ListBox1.Add('Input plugin loaded!');

  IMod:=GetInModule;
  IMod.hMainWindow:=Form.Handle;
  IMod.hDllInstance:=InputDLLHandle;
  IMod.OutMod:=omod;
  IMod.Init;

  IMod.SetInfo:=SetInfo1;
  IMod.DspIsActive:=Dsp_IsActive1;
  IMod.DspDoSamples:=Dsp_DoSamples1;
  IMod.SAVSAInit:=SAVSAInit1;
  IMod.SAVSADeInit:=SAVSADeinit1;
  IMod.SAAddPCMData:=SAAddPCMData1;
  IMod.SAGetMode:=SAGetMode1;
  IMod.SAAdd:=SAADD1;
  IMod.VSASetInfo:=VSASetInfo1;
  IMod.VSAAddPCMData:=VSAAddPCMData1;
  IMod.VSAGetMode:=VSAGetMode1;
  IMod.VSAAdd:=VSAAdd1;

  IMod.About(0);
end;

procedure TForm1.Button5Click(Sender: PObj);
begin
  OpenDlg1.Filter:='Winamp Output plugin|out_*.dll';
  if IMod=nil then
    begin
     ListBox1.add('Load input plugin first!');
     Exit;
    end;
  if not OpenDlg1.Execute then Exit;
  if not InitOutputDLL(OpenDlg1.Filename) then
    begin
      ListBox1.Add('Failed to load output plugin!');
      Exit;
    end;
  ListBox1.Add('Output plugin loaded!');

  OMod:=GetOutModule;

  OMod.hMainWindow:=Form.Handle;
  OMod.hDllInstance:=OutputDLLHandle;

  OMod.Init;
  OMod.About(0);

  OMod.SetVolume(128);

  IMod.OutMod:=OMod;
  
  Button1.Enabled:=True;
  Button2.Enabled:=True;
  Button6.Enabled:=True;
  Button7.Enabled:=True;
end;

procedure TForm1.Button6Click(Sender: PObj);
begin
  IMod.Config(Form.Handle);
end;

procedure TForm1.Button7Click(Sender: PObj);
begin
  OMod.Config(Form.Handle);
end;

procedure TForm1.Button8Click(Sender: PObj);
begin
  if OMod.IsPlaying<>0 then IMod.Stop; 
  OMod.Quit;
  IMod.Quit;
  Form.Close;
end;

procedure TForm1.TrackBar1Scroll(Sender: PTrackbar; Code: Integer);
begin
  OMod.SetVolume(TrackBar1.Position);
end;

end.

