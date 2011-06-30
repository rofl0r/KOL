unit kolsnif1;
//
// purpose: Packet sniffer demo for use with the open source WinPcap driver
//  author: Authorized KOL version, © 2005, Thaddy de Koning
//          Original version © Umar Sear
// Remarks: The WinPCap driver is free ware and available from
//          http://winpcap.polito.it/ under a BSD style license
//
//          This KOL demo and the KOL headerfile translations are not freeware
//          They are subject to the same license as Umar states in his header
//          comments

interface
uses
  Windows, Messages, Kol, KolSniffer, kolwinpcap,kolwinpcaptypes,winsock;

type

PForm1=^TForm1;
TForm1=object(Tobj)
  Form:pControl;
  Sniffer1:PSniffer;
  fchk,
  Pnl,
  pnl2,
  Gb,
  DevMask,
  DevAddr,
  CapLength,
  Filter,
  ComboBox1,
  Bitbtn1,
  Bitbtn2,
  Bitbtn3,
  Label1,
  Listview1:Pcontrol;
public
    procedure BitBtn1Click(Sender: PObj);
    procedure BitBtn3Click(Sender: PObj);
    procedure BitBtn2Click(Sender: PObj);
    procedure Sniffer1Capture(const Header: PTpcap_pkthdr;
      const Data: Pointer);
    procedure Sniffer1CaptureTCP(const Header: PTpcap_pkthdr;
      const Data: PTCPPckt);
    procedure ComboBox1Change(Sender: PObj);
    procedure Label1Click(Sender: PObj);
    procedure FormClose( Sender: PObj; var Accept: Boolean );
end;


procedure NewForm1( var Result: PForm1; AParent: PControl );

var
  Form1:pForm1;
  cap  : Integer=0;
  disp : Integer=0;
  MaxCapLen : Integer=0;
  MaxLen : Integer=0;

implementation

procedure NewForm1( var Result: PForm1; AParent: PControl );
var
 i:integer;
begin
  New(Result,Create);
  with Result^ do
  begin
    Form:= NewForm(AParent,'KOL TCP Sniffer demo using the WinPCap driver').SetSize(600,400).centeronparent.Tabulate;
    Applet:=Form;
    Form.Add2AutoFree(Result);
    Form.OnClose:=Formclose;
    Form.Font.ReleaseHandle;
    Form.Font.assignhandle(GetStockObject(DEFAULT_GUI_FONT));
    pnl:=Newpanel(form,esNone).setalign(catop);
    Bitbtn1:=Newbutton(pnl,'Start').PlaceRight;
    Bitbtn1.OnClick:=Bitbtn1Click;
    Bitbtn2:=NewButton(pnl,'Stop').Placeright;
    Bitbtn2.Onclick:=Bitbtn2Click;
    Bitbtn3:=NewButton(pnl,'Clear').Placeright;
    Bitbtn3.OnClick:=Bitbtn3click;
    form.SimpleStatustext:='' ;

    Listview1:=NewlistView(form,lvsdetail,[],nil,nil,nil).setalign(caClient);
    ListView1.LVColAdd('Service',taright, 50);
    ListView1.LVColAdd('Length',taright, 50);
    ListView1.LVColAdd('ID',taright, 50);
    ListView1.LVColAdd('Time to live',taright, 50);
    ListView1.LVColAdd('Protocol',taright, 50);
    ListView1.LVColAdd('Checksum',taright, 50);
    ListView1.LVColAdd('Source',taright, 50);
    ListView1.LVColAdd('Port',taright, 50);
    ListView1.LVColAdd('Destination',taright, 50);
    ListView1.LVColAdd('Port',taright, 50);

    pnl2:=Newpanel(form, esnone).setalign(caTop);
    pnl2.Margin:=8;
    gb:=Newgroupbox(pnl2,'Device and Filter').Setalign(caClient);
    Newlabel(gb,'Device address: ').AutoSize(True);
    DevAddr:=NewEditbox(gb,[eoReadOnly]).PlaceRight;
    DevAddr.color:=clWindow;
    DevAddr.Text:='0.0.0.0';
    Newlabel(gb,'Device Mask: ').AutoSize(True).placeright;
    DevMask:=NewEditbox(gb,[eoReadOnly]).PlaceRight;
    Devmask.Color:=clWindow;
    DevMask.Text:='0.0.0.0';
    Newlabel(gb,'Capture length: ').AutoSize(True).placeright;
    CapLength:=NewEditbox(gb,[eoNumber]).PlaceRight;
    Caplength.Color:=clWindow;
    Caplength.width:=40;
    Caplength.text:='45';
    NewLabel(gb,'Filter :').PlaceDown;
    Filter:=NewEditBox(Gb,[]).placeright;
    Filter.Width:=300;
    Filter.Text:= 'tcp';
    Filter.left:=DevAddr.Left;
    Filter.Width:=DevMask.Left+DevMask.Width-DevAddr.Left;
    Filter.Color:=clWindow;
    fchk:=NewCheckBox(gb,'Filtered').placeright;
    fchk.OnClick:=label1click;
  Sniffer1:=Newsniffer(form);
  With Sniffer1^ do
  begin
    OnCapture:=Sniffer1Capture;
    OnCaptureTCP:=Sniffer1capturetcp;
    DeviceName := 'Invalid interface';
    DeviceDescription := 'Invalid interface';
    CaptureLength := Str2int(CapLength.text);
    FilterString := filter.Text;
    //Filtered:=true;
    DeviceMask := DevAddr.Text;
    DeviceAddress := DevMask.Text;
    OnCapture := Sniffer1Capture;
    OnCaptureTCP := Sniffer1CaptureTCP;
    CaptureMode := capPromiscuous;
  end;

  Label1:=Newlabel(form.StatusCtl,' ').AutoSize(true);
  If Sniffer1.Filtered Then
    Label1.Caption:='YES';

  Combobox1:=NewComboBox(pnl,[]).placeright.setsize(300,20).Resizeparent;
  Combobox1.Color:=clWindow;
  for i:= 0 to Sniffer1.DeviceDescriptions.Count-1 do
  ComboBox1.Add(Sniffer1.DeviceDescriptions.Items[i]);
  Combobox1.OnChange:=Combobox1change;
  If ComboBox1.Count>0 then
  Begin
    Sniffer1.DeviceIndex:=0;
    Combobox1.Curindex:=0;
  End;
  end;
end;



procedure TForm1.BitBtn1Click(Sender: PObj);
Var ErrStr : String;

begin
  Sniffer1.Filtered:=fChk.Checked;
  Sniffer1.FilterString:=Filter.Text;
  If Sniffer1.Activate=0 then
  Begin
//    StatusBar1.Panels[8].Text:=IntToStr(Sniffer1.CaptureLength);
    ComboBox1.Enabled:=False;
    fChk.enabled:=false;
    Form.StatusText[1]:='Active';
    // this also checks for syntax erors in the filterstring! tdk
    If Sniffer1.Filtered then
    begin
      fchk.Checked:=true;
      form.StatusText[3]:='Yes'
    end
    Else
    begin
      fchk.Checked:=false;
      Form.StatusText[3]:='No';
    end;
  End
  Else
  Form.StatusText[8]:=PChar(' '+ErrStr);
  DevAddr.Text:=Sniffer1.DeviceAddress;
  DevMask.Text:=Sniffer1.DeviceMask;
end;


procedure TForm1.BitBtn3Click(Sender: PObj);
begin
  ListView1.Clear;
end;

procedure TForm1.BitBtn2Click(Sender: PObj);
Var ErrStr : String;
begin
  MaxCapLen:=0;
  MaxLen:=0;
  If Sniffer1.Deactivate=0 then
  Begin
    form.StatusText[1]:='In-active';
    form.StatusText[3]:='No';
    ComboBox1.Enabled:=True;
    fChk.Enabled:=true;
  End
  Else
    form.StatusText[8]:=PChar(' '+ErrStr);
end;

procedure TForm1.Sniffer1Capture(const Header: PTpcap_pkthdr;
  const Data: Pointer);
begin
  Inc(Cap);
  form.StatusText[5]:=PChar(Int2Str(Cap));
end;

procedure TForm1.Sniffer1CaptureTCP(const Header: PTpcap_pkthdr;
  const Data: PTCPPckt);
begin
With Data.TCPHeader do
  Begin
    With ListView1^ do
    Begin
      LvInsert(0,'',0,[],0,0,0);
      LvItems[0,0]:=Int2Str(IPHeader.Service);
      LvItems[0,1]:=(Int2Str(htons(IPHeader.Length)));
      LvItems[0,2]:=(Int2Str(htons(IPHeader.Ident)));
      LvItems[0,3]:=(Int2Str(IPHeader.TimeLive));
      LvItems[0,4]:=(Int2Str(IPHeader.Protocol));
      LvItems[0,5]:=(Int2Str(ntohs(IPHeader.Checksum)));
      LvItems[0,6]:=(IPToStr(ntohl(IPHeader.Source)));
      LvItems[0,7]:=(Int2Str(ntohs(Source)));
      LvItems[0,8]:=(IPToStr(ntohl(IPHeader.Destination)));
      LvItems[0,9]:=(Int2Str(ntohs(Destination)));
    End;
    Inc(disp);
    form.StatusText[7]:=Pchar(Int2Str(disp));
    If Header.CapLen>MaxCapLen Then
      MaxCapLen:=Header.CapLen;

    If Header.Len>MaxLen Then
      MaxLen:=Header.Len;

    form.StatusText[9]:=PChar(Int2Str(Header.CapLen)+'/'+Int2Str(MaxCapLen));
    form.StatusText[11]:=PChar(Int2Str(Header.Len)+'/'+Int2Str(MaxLen));
    End;
end;

procedure TForm1.ComboBox1Change(Sender: PObj);
begin
  Sniffer1.DeviceIndex:=ComboBox1.CurIndex;
end;

procedure TForm1.Label1Click(Sender: PObj);
begin
  If not ComboBox1.Enabled then Exit;
  Sniffer1.Filtered:= Not Sniffer1.Filtered;
  If Sniffer1.Filtered then
  begin
    fchk.checked:=true;
    Label1.Caption:='YES'
  end
  Else
  begin
    fchk.checked:=false;
    Label1.Caption:='NO';
  end;
end;

procedure TForm1.FormClose(Sender: PObj; var Accept:Boolean);
begin
  BitBtn2Click(@self);
  Accept:=true;
end;


end.