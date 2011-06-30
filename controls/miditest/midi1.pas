unit midi1;
//  The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at http://www.mozilla.org/MPL/
//  Software distributed under the License is distributed on an "AS IS" basis,
//  WITHOUT WARRANTY OF ANY KIND, either express or implied.
//  See the License for the specific language governing rights and limitations under the License.

//********************************************************************
//  Created by KOL project Expert Version 2.00 on:29-1-2003 11:57:26
//********************************************************************
// Unit:        MIDI1
// Purpose:     Demo KOL port of JEDI JCL MIDI library
// Author:      Thaddy de Koning, (c)2002,2003
// Status:      This demo: Freeware,
//              Library code is subject to the MPL, see original JCLcode
//              (included but not necessary)
// Features:
//              Virtual Keyboard,
//              Pitchbend,
//              Modulation,
//              Notes off,
//              Octave select
//********************************************************************
// This is a demo of my KOL translation of the MIDI high level interfaces
// from the JEDI Code library.
// Note: The demo is not a straight port, the midi library IS,
// so it is not as small as can be.
// Tested under D4, D6 and D7 with several soundcards and midiports
// at the same time!
//(Tascam US428, Hercules Game Theater and Onboard soundchip)
//
// Remarks:
// Needs the trackbarcontrol in KolCCtrls, available from
// www.xcl.cjb.net in the controls section.
// Needs the Updown (NOT MHUpdown!) control available at the same site
// You don't need the MCK

interface
uses
 windows, messages, Shellapi, Kol,tdkkolmidi,kolcctrls,updown;

type
PForm1=^TForm1;
TForm1=object(Tobj)
  Form:pControl;
  Panel:pControl;
  Panel2:pControl;
  Panel3:pControl;
  OffBtn:pControl;
  cbMidiOutSelect:pControl;
  MidiProgramNum:pControl;
  keys:pList;
  Label1,
  Label2,
  Label3:pControl;
  PitchBar,
  ModBar:pTrackBar;
  Octave:pControl;
  UpDown,
  UpDown2:pUpDown;
private
  FMidiOut: pKOLMidiOut;
  FChannel: TMidiChannel;
  FTempStr:pStrListEx;
public
  //Change program number, in this case: instrument
  procedure MidiProgramNumChange(Sender:pObj);
  //Select MIDI out port
  procedure cbMidiOutSelectChange(Sender: pObj);
  //Change the Octave, based on leftmost C
  procedure OctaveChanged(sender:pObj);
  //Keyboard handling
  procedure KeyDown( Sender: PControl; var Key: Longint; Shift: DWORD );
  procedure KeyUp( Sender: PControl; var Key: Longint; Shift: DWORD );

  //All notes off
  procedure AllNotesOff;
  procedure ResetControllers;
  procedure OffBtnClick(sender:pObj);
  procedure MouseDown( Sender: PControl; var Mouse: TMouseEventData );
  procedure MouseUp( Sender: PControl; var Mouse: TMouseEventData );
  procedure PitchScroll( Sender: PTrackbar; Code: Integer );
  procedure ModScroll( Sender: PTrackbar; Code: Integer );
  procedure AppQuit( Sender: PObj; var Accept: Boolean );
  function DoMessage( var Msg: TMsg; var Rslt: Integer ): Boolean;
  end;

function NewWhiteKey(Owner:pControl):pControl;
function NewBlackKey(Owner:pControl):pControl;


procedure NewForm1( var Result: PForm1; AParent: PControl );

var
  Form1:pForm1;

implementation

function NewWhiteKey(Owner:pControl):pControl;
begin
  Result:=NewBitBtn(Owner,'',[],glyphtop,0,0).likespeedbutton;
  Result.Color:=clWhite;
  Result.Width:=20;
  Result.Height:=100;
  Result.OnMouseDown:=Form1.MouseDown;
  Result.OnMouseUp:=Form1.MouseUp;
end;

function NewBlackKey(Owner:pControl):pControl;
begin
  Result:=NewBitBtn(Owner,'',[],glyphtop,0,0).likespeedbutton;
  Result.Color:=clBlack;
  Result.width:=16;
  Result.Height:=70;
  Result.BringToFront;
  Result.OnMouseDown:=Form1.MouseDown;
  Result.OnMouseUp:=Form1.MouseUp;
end;

procedure NewForm1( var Result: PForm1; AParent: PControl );
var i:integer;
begin
  New(Result,Create);
  with Result^ do
  begin
    Form:= NewForm(AParent,'Thaddy''s KOL Midi Demo [F1=Help]').SetSize(510,250).centeronparent;
    Form.Style:=Form.Style-WS_MAXIMIZEBOX - WS_MINIMIZEBOX;
    form.font.fontheight:=12;
    form.Font.FontStyle:=[fsBold];
    form.Margin:=10;
    Panel:=Newpanel(Form,esRaised).SetAlign(caTop);

    Panel.Margin:=0;
    Applet:=Form;
    Applet.OnMessage:=domessage;
    Applet.OnClose:=AppQuit;
    Form.Add2AutoFree(Result);

    FTempStr:=NewSTrlistEx;
    Form.Add2AutoFree(FtempStr);

    Keys:=Newlist;
    Form.Add2AutoFree(Keys);

    //Pitch Bend
    Pitchbar:=Newtrackbar(Panel,[trbvertical,trbnoborder],PitchScroll);
    Pitchbar.perform(TBM_SETTIC,1,0);
    Pitchbar.PlaceRight;
    Pitchbar.RangeMin:=-8192;
    Pitchbar.RangeMax:=8191;
    Pitchbar.SetSize(20,100);

    //Modulation
    Modbar:=Newtrackbar(Panel,[trbvertical,trbnoborder],ModScroll);
    Modbar.PlaceRight;
    Modbar.TextAlign:=taRight;
    Modbar.RangeMin:=0;
    Modbar.RangeMax:=16383;
    Modbar.SetSize(20,100);
    Modbar.ResizeParent;

    //Init White Keys
    for i:=0 to 21 do
      Keys.Add(NewWhiteKey(panel).placeright);

    //Init Black Keys;
    Keys.Insert(1,NewBlackKey(panel));
    pControl(Keys.Items[1]).left:=pControl(Keys.Items[0]).left+12;

    Keys.Insert(3,newblackkey(panel));
    pControl(Keys.Items[3]).left:=pControl(Keys.Items[2]).left+12;

    Keys.Insert(6,newblackkey(panel));
    pControl(Keys.Items[6]).left:=pControl(Keys.Items[5]).left+12;


    Keys.Insert(8,newblackkey(panel));
    pControl(Keys.Items[8]).left:=pControl(Keys.Items[7]).left+12;

    Keys.Insert(10,newblackkey(panel));
    pControl(Keys.Items[10]).left:=pControl(Keys.Items[9]).left+12;

    Keys.Insert(13,newblackkey(panel));
    pControl(Keys.Items[13]).left:=pControl(Keys.Items[12]).left+12;

    Keys.Insert(15,newblackkey(panel));
    pControl(Keys.Items[15]).left:=pControl(Keys.Items[14]).left+12;

    Keys.Insert(18,newblackkey(panel));
    pControl(Keys.Items[18]).left:=pControl(Keys.Items[17]).left+12;

    Keys.Insert(20,Newblackkey(panel));
    pControl(Keys.Items[20]).left:=pControl(Keys.Items[19]).left+12;

    Keys.Insert(22,newblackkey(panel));
    pControl(Keys.Items[22]).left:=pControl(Keys.Items[21]).left+12;

    Keys.Insert(25,newblackkey(panel));
    pControl(Keys.Items[25]).left:=pControl(Keys.Items[24]).left+12;

    Keys.Insert(27,newblackkey(panel));
    pControl(Keys.Items[27]).left:=pControl(Keys.Items[26]).left+12;

    Keys.Insert(30,newblackkey(panel));
    pControl(Keys.Items[30]).left:=pControl(Keys.Items[29]).left+12;

    Keys.Insert(32,newblackkey(panel));
    pControl(Keys.Items[32]).left:=pControl(Keys.Items[31]).left+12;

    Keys.Insert(34,newblackkey(panel));
    pControl(Keys.Items[34]).left:=pControl(Keys.Items[33]).left+12;


    Panel2:=NewPanel(Form,esLowered).setalign(caClient);
    Label1:=NewLabel(Panel2,'Midi Out: ').PlaceDown.AutoSize(true);

    cbMidiOutSelect:=NewComboBox(Panel2,[]).PlaceRight;
    cbMidiOutSelect.Width:=250;
    cbMidiOutSelect.OnChange:=cbMidiOutSelectChange;

    Label2:=NewLabel(Panel2,'Program: ').Placedown.AutoSize(true);
    MidiProgramNum:=NewEditBox(Panel2,[eoReadOnly]).placeright;

    MidiprogramNum.Text:='0';

    MidiProgramNum.Width:=45;
    MidiProgramNum.OnChange:=MidiProgramNumChange;
    Label3:=Newlabel(Panel2,'Octave:').AutoSize(True).PlaceRight;
    Octave:=NewEditBox(Panel2,[eoReadOnly]).PlaceRight;
    Octave.Text:='4';
    Octave.Width:=40;
    Octave.OnChange:=OctaveChanged;


    OffBtn:=NewButton(Panel2,'Notes &Off').AutoSize(True).placeright;
    Offbtn.OnClick:=OffBtnClick;
    FChannel := 1;
    GetMidiOutputs(FtempStr);

    Panel3:=Newpanel(Panel2,esLowered).Setalign(caRight);
    Panel3.Color:=clNavy;
    Label3:=NewLabel(Panel3,'    ').CenterOnParent.autosize(true);
    Label3.Font.fontstyle:=[fsBold];
    Label3.Font.Color:=clWhite;
    Label3.Font.FontHeight:=36;
    Label3.Font.FontQuality:=fqProof;
    for i:=0 to Ftempstr.Count-1 do
    begin
      cbMidiOutSelect.Items[i]:=Ftempstr.Items[i];
      cbMidiOutSelect.Itemdata[i]:=Ftempstr.Objects[i];
    end;

    cbMidiOutSelect.CurIndex := 0;
    cbMidiOutSelectChange(Form);

    UpDown:=NewUpDown(Panel2,[updalignright,updsetbuddy,updwrap]);
    UpDown.Associate:=MidiProgramnum;
    Updown.Glue:=true;
    Updown.Min:=0;
    Updown.Max:=127;
//    UpDown.Visible:=True;
//    UpDown.Enabled:=True;
    //Updown.
    UpDown2:=NewUpDown(Panel2,[updalignright,updsetbuddy,updwrap]);
    UpDown2.Associate:=Octave;
    Updown2.Min:=0;
    Updown2.Max:=8;
    Updown2.Glue:=true;

 //  UpDown:=NewMHUpDown(Panel2,udvertical,False,true,true,true,true,true,udRight);
    //Updown.sec
    //UpDown.Associate:=Midiprogramnum;
    //Updown.Glue:=true;
    //Updown.Visible:=true;
    //Updown.Enabled:=true;
//    pMhUpDown(Updown).Min:=0;
//    pMhUpdown(Updown).Max:=127;

    //Lock
    Form.CanResize:=false;
    OctaveChanged(nil);
  end;
end;

function Tform1.Domessage( var Msg: TMsg; var Rslt: Integer ): Boolean;
begin
 if msg.message=WM_HELP then
 begin
   if  ShellExecute(Applet.Handle,'Open',Pchar('KOLMIDI.HTM'),'','',sw_ShowNormal)
     < 33 then MsgOk('KOLMIDI.HTM not found');
   result:=True;
 end else result:=False;
end;

procedure Tform1.ResetControllers;
begin
  if Assigned(FMidiOut) then
    FMidiOut.ResetAllControllers(FChannel);
  PitchBar.position:=0;
  ModBar.Position:=0;
  Applet.Invalidate;
end;

procedure TForm1.AllNotesOff;
begin
  if Assigned(FMidiOut) then
    FMidiOut.SwitchAllNotesOff(FChannel);
end;


procedure Tform1.cbMidiOutSelectChange(Sender: pObj);
begin
  AllNotesOff;
  ResetControllers;
  FMidiOut := MidiOut(cbMidiOutSelect.CurIndex);
  FMidiOut.SendProgramChange(FChannel, Min(127,Str2Int(MidiProgramNum.text)));
end;



procedure TForm1.OffBtnClick(Sender: pObj);
begin
  AllNotesOff;
end;

procedure TForm1.MidiProgramNumChange(Sender:pObj);
begin
  FMidiOut.SendProgramChange(FChannel, Str2Int(MidiProgramNum.Text));
end;

procedure Tform1.mousedown( Sender: PControl; var Mouse: TMouseEventData );
begin
  if Mouse.Button = mbLeft then
  begin
    FMidiOut.SendNoteOn(FChannel, Sender.Tag,   127);
  Label3.Caption:=MidiNoteToStr(   Sender.tag)
  end;

end;

procedure Tform1.mouseup( Sender: PControl; var Mouse: TMouseEventData );
begin
 if Mouse.Button = mbLeft then
      FMidiOut.SendNoteOff(FChannel, Sender.Tag, 127);
end;

procedure TForm1.PitchScroll( Sender: PTrackbar; Code: Integer );
begin
  FMidiOut.SendPitchWheelChange(FChannel, PitchBar.Position + MidiPitchWheelCenter);
end;

procedure TForm1.ModScroll( Sender: PTrackbar; Code: Integer );
begin
  FMidiOut.SendModulationWheelChangeHR(FChannel, ModBar.Position);
end;

procedure Tform1.OctaveChanged(sender:pObj);
var i:integer;
begin
  for i:=0 to Keys.Count-1 do
    pControl(Keys.Items[i]).Tag:=i+Str2Int(Octave.Text)*12;
end;

procedure Tform1.AppQuit(Sender: PObj; var Accept: Boolean );
begin
  AllNotesOff;
  ResetControllers;
  Accept:=true;
end;

procedure Tform1.KeyDown( Sender: PControl; var Key: Longint; Shift: DWORD );
begin
//For Computer keyboard playing expansion
end;
procedure Tform1.KeyUp( Sender: PControl; var Key: Longint; Shift: DWORD );
begin
//For Computer keyboard playing expansion
end;
end.