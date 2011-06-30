unit kolmiditest1;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:2-7-2003 15:34:13
//********************************************************************


interface
uses
  Windows, Messages, Kol, kolmidiin, kolmidiout, kolmiditype, kolmonprocs;

type

PForm1=^TForm1;
TForm1=object(Tobj)
  Form:pControl;
  MIDIInput1: PMIDIInput;
	lstLog,
	pnlColumnHeading:pControl;
	MidiOutput1: PMidiOutput;
	MainMenu1: PMenu;
	Label1,
	cmbInput,
	cmbOutput:pControl;
private

public
  procedure LogMessage(ThisEvent:pMyMidiEvent);
  procedure OpenDevs;
  procedure Closedevs;
  procedure mnuExitClick(Sender: PMenu;idx:integer);
  procedure cmbInputChange(Sender: PObj);
  procedure MIDIInput1MidiInput(Sender: pObj);
end;


procedure NewForm1( var Result: PForm1; AParent: PControl );

var
  Form1:pForm1;

implementation

procedure NewForm1( var Result: PForm1; AParent: PControl );
var
	thisDevice: Word;
begin
  New(Result,Create);
  with Result^ do
  begin
    Form:= NewForm(AParent,ExtractFilenameWOExt(Paramstr(0))).SetSize(600,400).centeronparent.Tabulate;
    Applet:=Form;
    Form.Add2AutoFree(Result);
    //
    //Controls
    //
    MidiInput1:=NewMidiInput(Form);
    MidiInput1.OnMidiInput:=MidiInput1MidiInput;
    MidiOutput1:=NewMidiOutput(Form);
    MainMenu1:=NewMenu(Form,0,['&File','(', 'E&xit',')','&Options', '&Help',''],mnuExitClick);
    pnlColumnHeading:=NewPanel(Form,esRaised).SetAlign(caTop);
    cmbInput:=NewCombobox(pnlColumnheading,[]);
    cmbInput.Width:=pnlColumnheading.ClientWidth div 2;
    cmbInput.Onchange:=cmbInputChange;
    cmbInput.Color:=clWhite;
    cmbOutput:=NewCombobox(pnlColumnheading,[]).placeright;
    cmbOutput.Width:=pnlColumnheading.ClientWidth div 2;
    cmbOutput.Onchange:=cmbInputChange;
    cmbOutput.Color:=clWhite;
    Label1:=NewLabel(pnlColumnHeading,'Timestamp  Message  Data1 Data2  Description            ').autosize(true).placedown.ResizeParent;
    lstLog:=NewListBox(form,[]).SetAlign(caClient);
    lstLog.Font.FontName:='Courier';
    lstLog.Font.FontStyle:=[fsBold];
    lstlog.Font.Color:=clYellow;
    lstlog.Color:=clBlack;
    lstlog.DoubleBuffered:=true;

    { Load the lists of installed MIDI devices }
    cmbInput.Clear;
    for thisDevice := 0 To MidiInput1.NumDevs - 1 do
      begin
      MidiInput1.DeviceID := thisDevice;
      cmbInput.Add(MidiInput1.ProductName);
      end;
    cmbInput.CurIndex := 0;
    cmbOutput.Clear;
    for thisDevice := 0 To MidiOutput1.NumDevs - 1 do
      begin
      MidiOutput1.DeviceID := thisDevice;
      cmbOutput.Add(MidiOutput1.ProductName);
      end;
    cmbOutput.CurIndex := 0;
    OpenDevs;
    end;
end;



procedure TForm1.LogMessage(ThisEvent:pMyMidiEvent);
{ Logging MIDI messages with a Windows list box is rather slow and ugly,
  but it makes the example very simple.  If you need a faster and less
  flickery log you could port the rest of Microsoft's MIDIMON.C example. }
begin
		With lstLog^ do
      begin
      ItemSelected[0]:=false;
 			insert(0,MonitorMessageText(ThisEvent));
      ItemSelected[0]:=true;
      end;
end;

procedure TForm1.MIDIInput1MidiInput(Sender: pObj);
var
	thisEvent: pMyMidiEvent;
begin
	with pMidiInput(Sender)^ do
		begin
		while (MessageCount > 0) do
			begin
			{ Get the event as an object }
			thisEvent := GetMidiEvent;
			{ Log it }
			LogMessage(thisEvent);
			{ Echo to the output device }
      thisevent.Data1:=thisevent.Data1;
			MidiOutput1.PutMidiEvent(thisEvent);

	{ Event was dynamically created by GetMyMidiEvent so must
				free it here }
			thisEvent.Free;
			end;
		end;
end;

procedure TForm1.OpenDevs;
begin
	{ Use selected devices }
	MidiInput1.ProductName := cmbInput.Text;
	MidiOutput1.ProductName := cmbOutput.Text;
	{ Open devices }
	MidiInput1.Open;
	MidiInput1.Start;
	MidiOutput1.Open;
end;

procedure TForm1.CloseDevs;
begin
	MidiInput1.Close;
	MidiOutput1.Close;
end;


procedure TForm1.mnuExitClick(Sender: PMenu;idx:integer);
begin
	case idx of
  1:form.Close;
  else
   // My debug option, tdk
   MsgOk(int2str(idx));
  end;
end;


procedure TForm1.cmbInputChange(Sender: PObj);
begin
	{ Close and reopen devices with changed device selection }
	CloseDevs;
	OpenDevs;
end;

end.

