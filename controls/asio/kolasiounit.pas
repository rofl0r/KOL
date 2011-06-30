{
       Unit: KolAsioUnit
    purpose: pASIO demo project
     Author: KOL adapttation Thaddy de Koning
             Original codeMartin Fay
  Copyright: See below
    Remarks:
}
unit kolasiounit;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:25-3-2003 19:36:29
//********************************************************************


interface
uses
  Windows, Messages, Kol,kolasio,kolasiolist,kolopenasio;

const
     // private message
     PM_ASIO = WM_User + 1652;   // unique we hope

     // asio message(s), as wParam for PM_ASIO
     AM_ResetRequest         = 0;
     AM_BufferSwitch         = 1;     // new buffer index in lParam
     AM_BufferSwitchTimeInfo = 2;     // new buffer index in lParam
                                      // time passed in Form1.BufferTime
     AM_LatencyChanged       = 3;


     PM_UpdateSamplePos      = PM_ASIO + 1;  // sample pos in wParam (hi) and lParam (lo)



type

PForm1=^TForm1;
TForm1=object(Tobj)
    Form:pControl;
    DriverCombo,      //: TComboBox;
    DriverInfoBox,    //: TGroupBox;
    ControlPanelBtn,  //: TButton;
    lblName,          //: TLabel;
    lblVersion,       //: TLabel;
    lblInputChannels, //: TLabel;
    lblOutputChannels,//: TLabel;
    lblCanSampleRate, //: TLabel;
    StartBtn,         //: TButton,//;
    StopBtn,          //: TButton, //;
    CreateBuffersBtn, //: TButton;
    DestroyBuffersBtn,//: TButton;
    lblBufferSizes,   //: TLabel;
    GroupBox1,        //: TGroupBox;
    lblInputLatency,  //: TLabel;
    lblOutputLatency, //: TLabel;
    lblTotalLatency,
    GroupBox2,        //: TGroupBox;
    lblLeftChannelType,//: TLabel;
    lblRightChannelType,//: TLabel;
    GroupBox3,        //: TGroupBox;
    lblSamplePos,     //: TLabel;
    lblTime:pControl;
private
    procedure ChangeEnabled;
    procedure CloseDriver;
    procedure BufferSwitch(index: integer);
    procedure BufferSwitchTimeInfo(index: integer; const params: TAsioTime);
protected
    procedure DriverComboChange(sender:pObj);
    procedure StartBtnClick(Sender: pObj);
    procedure StopBtnClick(Sender: pObj);
    procedure CreateBuffersBtnClick(Sender: pObj);
    procedure DestroyBuffersBtnClick(Sender: pObj);
public
    driverlist        : TAsioDriverList;
    Driver            : IOpenAsio;
    BuffersCreated    : boolean;
    IsStarted         : boolean;
    callbacks         : TASIOCallbacks;
    bufferinfo        : PAsioBufferInfo;
    BufferTime        : TAsioTime;
    ChannelInfos      : array[0..1] of TASIOChannelInfo;
    SampleRate        : TASIOSampleRate;
    procedure PMAsio(var Message: TMsg);
    procedure PMUpdateSamplePos(var Message: TMsg);
    destructor destroy;virtual;
    procedure ControlPanelBtnClick(Sender: pObj);
    function DoMessage(var Msg:Tmsg;var Rslt:integer):boolean;
end;


procedure NewForm1( var Result: PForm1; AParent: PControl );

var
  Form1:pForm1;

implementation
function ChannelTypeToString(vType: TAsioSampleType): string;
begin
  Result := '';
  case vType of
    ASIOSTInt16MSB   :  Result := 'Int16MSB';
    ASIOSTInt24MSB   :  Result := 'Int24MSB';
    ASIOSTInt32MSB   :  Result := 'Int32MSB';
    ASIOSTFloat32MSB :  Result := 'Float32MSB';
    ASIOSTFloat64MSB :  Result := 'Float64MSB';

    // these are used for 32 bit data buffer, with different alignment of the data inside
    // 32 bit PCI bus systems can be more easily used with these
    ASIOSTInt32MSB16 :  Result := 'Int32MSB16';
    ASIOSTInt32MSB18 :  Result := 'Int32MSB18';
    ASIOSTInt32MSB20 :  Result := 'Int32MSB20';
    ASIOSTInt32MSB24 :  Result := 'Int32MSB24';

    ASIOSTInt16LSB   :  Result := 'Int16LSB';
    ASIOSTInt24LSB   :  Result := 'Int24LSB';
    ASIOSTInt32LSB   :  Result := 'Int32LSB';
    ASIOSTFloat32LSB :  Result := 'Float32LSB';
    ASIOSTFloat64LSB :  Result := 'Float64LSB';

    // these are used for 32 bit data buffer, with different alignment of the data inside
    // 32 bit PCI bus systems can more easily used with these
    ASIOSTInt32LSB16 :  Result := 'Int32LSB16';
    ASIOSTInt32LSB18 :  Result := 'Int32LSB18';
    ASIOSTInt32LSB20 :  Result := 'Int32LSB20';
    ASIOSTInt32LSB24 :  Result := 'Int32LSB24';
  end;
end;

procedure AsioBufferSwitch(doubleBufferIndex: longint; directProcess: TASIOBool); cdecl;
begin
  case directProcess of
    ASIOFalse :  PostMessage(Form1.Form.Handle, PM_ASIO, AM_BufferSwitch, doubleBufferIndex);
    ASIOTrue  :  Form1.BufferSwitch(doubleBufferIndex);
  end;
end;

procedure AsioSampleRateDidChange(sRate: TASIOSampleRate); cdecl;
begin
  MsgOk('The sample rate has been changed to ' + Extended2Str(sRate));
end;

function AsioMessage(selector, value: longint; message: pointer; opt: pdouble): longint; cdecl;
begin
  Result := 0;

  case selector of
    kAsioSelectorSupported    :   // return 1 if a selector is supported
      begin
        case value of
          kAsioEngineVersion        :  Result := 1;
          kAsioResetRequest         :  Result := 1;
          kAsioBufferSizeChange     :  Result := 0;
          kAsioResyncRequest        :  Result := 1;
          kAsioLatenciesChanged     :  Result := 1;
          kAsioSupportsTimeInfo     :  Result := 1;
          kAsioSupportsTimeCode     :  Result := 1;
          kAsioSupportsInputMonitor :  Result := 0;
        end;
      end;
    kAsioEngineVersion        :  Result := 2;   // ASIO 2 is supported
    kAsioResetRequest         :
      begin
        PostMessage(Form1.form.Handle, PM_Asio, AM_ResetRequest, 0);
        Result := 1;
      end;
    kAsioBufferSizeChange     :
      begin
        PostMessage(Form1.form.Handle, PM_Asio, AM_ResetRequest, 0);
        Result := 1;
      end;
    kAsioResyncRequest        :  ;
    kAsioLatenciesChanged     :
      begin
        PostMessage(Form1.form.Handle, PM_Asio, AM_LatencyChanged, 0);
        Result := 1;
      end;
    kAsioSupportsTimeInfo     :  Result := 1;
    kAsioSupportsTimeCode     :  Result := 0;
    kAsioSupportsInputMonitor :  ;
  end;
end;

function AsioBufferSwitchTimeInfo(var params: TASIOTime; doubleBufferIndex: longint; directProcess: TASIOBool): PASIOTime; cdecl;
begin
  case directProcess of
    ASIOFalse :
      begin
        Form1.BufferTime := params;
        PostMessage(Form1.form.Handle, PM_ASIO, AM_BufferSwitchTimeInfo, doubleBufferIndex);
      end;
    ASIOTrue  :  Form1.BufferSwitchTimeInfo(doubleBufferIndex, params);
  end;

  Result := nil;
end;



procedure NewForm1( var Result: PForm1; AParent: PControl );
var i:Integer;
begin
  New(Result,Create);
  with Result^ do
  begin
    Form:= NewForm(AParent,'KOL ASIO Demo').SetSize(350,500).centeronparent.Tabulate;
    Applet:=Form;
    form.Font.fontheight:=16;
    Form.OnMessage:=DoMessage;
    Form.Add2AutoFree(Result);
    DriverCombo:=NewComboBox(Form,[]).setalign(caTop);
    Drivercombo.OnChange:=Form1.DriverComboChange;
    drivercombo.color:=clWhite;
    Controlpanelbtn:=NewButton(Form,'Control Panel').AutoSize(True).setposition(5,25);
    ControlPanelbtn.Onclick:=form1.ControlPanelBtnClick;
    DriverInfoBox:=NewGroupBox(Form,'Driver Info').setposition(5,50);    //: TGroupBox;
    Driverinfobox.Width:=form.ClientWidth-10;
    lblName:=NewLabel(DriverInfoBox,'Name').setposition(20,20).AutoSize(True);          //: TLabel;
    lblVersion:=NewLabel(DriverInfobox,'Version:').PlaceUnder.AutoSize(True);       //: TLabel;
    lblInputChannels:=NewLabel(Driverinfobox,'Input channels:').PlaceUnder.AutoSize(True); //: TLabel;
    lblOutputChannels:=NewLabel(DriverInfoBox,'Output channels:').PlaceUnder.AutoSize(True);//: TLabel;
    lblCanSampleRate:=NewLabel(DriverInfoBox,'Can Samplerate:').PlaceUnder.AutoSize(True); //: TLabel;
    lblBufferSizes:=NewLabel(DriverInfoBox,'Buffersizes:').PlaceUnder.AutoSize(True);
    StartBtn:=NewButton(Form,'&Start').SetPosition(5,350).AutoSize(true);         //: TButton,//;
    StartBtn.OnClick:=form1.StartBtnClick;
    StopBtn:=NewButton(Form,'&Stop').PlaceRight.AutoSize(True);          //: TButton, //;
    StopBtn.OnClick:=Form1.StopBtnClick;
    CreateBuffersBtn:=NewButton(Form,'Create Buffers').SetPosition(5,200).AutoSize(True); //: TButton;
    CreateBuffersbtn.OnClick:=Form1.CreateBuffersBtnClick;
    DestroyBuffersBtn:=NewButton(Form,'Destroy Buffers').PlaceRight.AutoSize(true);//: TButton;
    Destroybuffersbtn.OnClick:=Form1.DestroyBuffersBtnClick;;
    GroupBox1:=NewGroupBox(Form,'Latencies').SetPosition(5,230);        //: TGroupBox;
    GroupBox1.Width:=Form.Clientwidth-10;Groupbox1.Height:=65;
    lblInputLatency:=NewLabel(GroupBox1,'Input:').setposition(20,20).autosize(true);  //: TLabel;
    lblOutputLatency:=NewLabel(Groupbox1,'Output').setposition(165,20).autosize(true); //: TLabel;
    lblTotallatency:=newlabel(Groupbox1,'Total latency:').setposition(20,40).AutoSize(true);
    GroupBox2:=NewGroupBox(form,'Channels').SetPosition(5,295);        //: TGroupBox;
    GroupBox2.Width:=Form.Clientwidth-10;Groupbox2.Height:=45;
    lblLeftChannelType:=NewLabel(Groupbox2,'Left').Setposition(20,20).AutoSize(True);//: TLabel;
    lblRightChannelType:=NewLabel(GroupBox2,'Right').setposition(165,20).AutoSize(true);//: TLabel;
    GroupBox3:=NewGroupBox(Form,'Play Info').SetPosition(5,380);        //: TGroupBox;
    GroupBox3.Width:=Form.Clientwidth-10;Groupbox3.Height:=65;
    lblSamplePos:=NewLabel(GroupBox3,'Sample pos:').SetPosition(20,20).AutoSize(true);     //: TLabel;
    lblTime:=NewLabel(GroupBox3,'Time:').setposition(20,40).AutoSize(true);



//
    bufferinfo := nil;
    // init the driver list
    SetLength(driverlist, 0);
    ListAsioDrivers(driverlist);
    for i := Low(driverlist) to High(driverlist) do
      DriverCombo.Add(driverlist[i].name);

    // set the callbacks record fields
    callbacks.bufferSwitch := AsioBufferSwitch;
    callbacks.sampleRateDidChange := AsioSampleRateDidChange;
    callbacks.asioMessage := AsioMessage;
    callbacks.bufferSwitchTimeInfo := AsioBufferSwitchTimeInfo;

    // set the driver itself to nil for now
    Driver := nil;
    BuffersCreated := FALSE;
    IsStarted := FALSE;

    // and make sure all controls are enabled or disabled
    ChangeEnabled;

  end;
end;


function TForm1.DoMessage(var Msg:TMsg;var Rslt:integer):Boolean;
{ var
   Samples     : TAsioSamples;
   SampleCount : Int64;
   seconds     : Int64;
   minutes     : Int64;
   hours       : Int64;
   inp, outp: integer;
}
begin
  case msg.message of
    PM_ASIO:begin
              PMASIO(Msg);
              Result:=true;
            end;
    PM_UpdateSamplePos:
            begin
              PMUpdateSamplepos(Msg);
              Result:=true;
            end
    else
      Result:=false;
  end;
end;

procedure TForm1.ControlPanelBtnClick(Sender: pObj);
begin
  if (Driver <> nil) then
    Driver.ControlPanel;
end;

procedure Tform1.PMAsio(var Message: TMsg);
var
   inp, outp: integer;
begin
  case Message.WParam of
    AM_ResetRequest         :  DriverComboChange(DriverCombo);                    // restart the driver
    AM_BufferSwitch         :  BufferSwitch(Message.LParam);                      // process a buffer
    AM_BufferSwitchTimeInfo :  BufferSwitchTimeInfo(Message.LParam, BufferTime);  // process a buffer with time
    AM_LatencyChanged       :
      if (Driver <> nil) then
      begin
        Driver.GetLatencies(inp, outp);
        lblInputLatency.Caption := 'input : ' + Int2Str(inp);
        lblOutputLatency.Caption := 'output : ' + Int2Str(outp);
      end;
  end;
end;

procedure Tform1.DriverComboChange(sender:pObj);
begin
  if Driver <> nil then
    CloseDriver;

  if DriverCombo.CurIndex >= 0 then
  begin
    if OpenAsioCreate(driverList[Drivercombo.CurIndex].id, Driver) then
      if (Driver <> nil) then
        if not Succeeded(Driver.Init(form.Handle)) then
          Driver := nil;  // RELEASE
  end;

  ChangeEnabled;
end;

procedure TForm1.BufferSwitch(index: integer);
begin
  FillChar(BufferTime, SizeOf(TAsioTime), 0);

  // get the time stamp of the buffer, not necessary if no
  // synchronization to other media is required
  if Driver.GetSamplePosition(BufferTime.timeInfo.samplePosition, BufferTime.timeInfo.systemTime) = ASE_OK then
    BufferTime.timeInfo.flags := kSystemTimeValid or kSamplePositionValid;

  BufferSwitchTimeInfo(index, BufferTime);
end;

procedure TForm1.BufferSwitchTimeInfo(index: integer; const params: TAsioTime);
begin
  // this is where processing occurs, with the buffers provided by Driver.CreateBuffers
  // beware of the buffer output format, of course

  // tell the interface that the sample position has changed
  PostMessage(form.Handle, PM_UpdateSamplePos, params.timeInfo.samplePosition.hi, params.timeInfo.samplePosition.lo);

  Driver.OutputReady;    // some asio drivers require this
end;

procedure TForm1.PMUpdateSamplePos(var Message: TMsg);
var
   Samples     : TAsioSamples;
   SampleCount : Integer;
   seconds     : Integer;
   minutes     : Integer;
   hours       : Integer;
begin
  Samples.hi := Message.wParam;
  Samples.lo := Message.lParam;
  SampleCount := ASIOSamplesToInt64(Samples);
  lblSamplePos.Caption := Format('sample pos : %d (hi:%d) (lo:%d)', [samplecount, Samples.hi,Samples.lo]);

  seconds := SampleCount div 44100;
  hours := seconds div 3600;
  minutes := (seconds mod 3600) div 60;
  seconds := seconds mod 60;
  lblTime.Caption := Format('time : %d:%.2d:%.2d', [hours, minutes, seconds]);
end;

procedure TForm1.ChangeEnabled;
var
   buf       : array[0..255] of char;
   version   : integer;
   inp, outp : integer;
   hr        : HResult;
   min, max, pref, gran : integer;
   i                    : integer;
   can44100, can48000   : boolean;
   Rate:double;
const
     boolstrings : array[0..1] of string = ('no', 'yes');
begin
  ControlPanelBtn.Enabled := (Driver <> nil);

  CreateBuffersBtn.Enabled := (Driver <> nil) and not BuffersCreated;
  DestroyBuffersBtn.Enabled := BuffersCreated;
  StartBtn.Enabled := (Driver <> nil) and BuffersCreated and not IsStarted;
  StopBtn.Enabled := IsStarted;

  lblName.Caption := 'name : ';
  lblVersion.Caption := 'version : ';
  lblInputChannels.Caption := 'input channels : ';
  lblOutputChannels.Caption := 'output channels : ';
  lblCanSampleRate.Caption := 'can samplerate : ';
  lblInputLatency.Caption := 'input : ';
  lblOutputLatency.Caption := 'output : ';
  lblTotalLatency.Caption:='Total latency:';
  lblLeftChannelType.Caption := 'left type : ';
  lblRightChannelType.Caption := 'right type : ';

  if Driver <> nil then
  begin
    Driver.GetDriverName(buf);
    lblName.Caption := 'name : ' + buf;
    version := Driver.GetDriverVersion;
    lblVersion.Caption := 'version : $' + Format('%.8x', [version]);
    Driver.GetChannels(inp, outp);
    //Driver.
    lblInputChannels.Caption := 'input channels : ' + Int2Str(inp);
    lblOutputChannels.Caption := 'output channels : ' + Int2Str(outp);
    hr := Driver.CanSampleRate(44100);
    can44100 := (hr = ASE_OK);
    hr := Driver.CanSampleRate(48000);
    can48000 := (hr = ASE_OK);
    lblCanSampleRate.Caption := Format('can samplerate : 44100 <%s> 48000 <%s>', [boolstrings[Ord(can44100)], boolstrings[Ord(can48000)]]);
    Driver.GetBufferSize(min, max, pref, gran);
    lblBufferSizes.Caption := Format('buffer sizes : min=%d max=%d pref=%d gran=%d', [min, max, pref, gran]);

    if BuffersCreated then
    begin
      Driver.GetLatencies(inp, outp);
      lblInputLatency.Caption := 'input : ' + Int2Str(inp) + ' samples';
      lblOutputLatency.Caption := 'output : ' + Int2Str(outp) + ' samples';
      Driver.GetSampleRate(Rate);
      lblTotalLatency.Caption:='total latency: '+num2bytes((inp+outp)*1000 / rate)+ ' msec at '+Extended2Str(Rate)+ ' <current>';

      // now get all the buffer details, sample word length, name, word clock group and activation
      for i := 0 to 1 do
      begin
        ChannelInfos[i].channel := i;
        ChannelInfos[i].isInput := ASIOFalse;   //  output
        Driver.GetChannelInfo(ChannelInfos[i]);
        if i = 0 then
          lblLeftChannelType.Caption := 'left type : ' + ChannelTypeToString(ChannelInfos[i].vType)
        else
          lblRightChannelType.Caption := 'right type : ' + ChannelTypeToString(ChannelInfos[i].vType);
      end;
    end;
  end;
end;

procedure TForm1.CloseDriver;
begin
  if Driver <> nil then
  begin
    if IsStarted then
      StopBtn.Click;
    if BuffersCreated then
      DestroyBuffersBtn.Click;
    Driver := nil;  // RELEASE;
  end;
  ChangeEnabled;
end;

destructor Tform1.destroy;
begin
  CloseDriver;
  SetLength(driverlist, 0);
  inherited destroy;
end;
procedure Tform1.StartBtnClick(Sender: pObj);
begin
  if Driver = nil then
    Exit;

  IsStarted := (Driver.Start = ASE_OK);
  ChangeEnabled;
end;

procedure Tform1.StopBtnClick(Sender: pObj);
begin
  if Driver = nil then
    Exit;

  if IsStarted then
  begin
    Driver.Stop;
    IsStarted := FALSE;
  end;

  ChangeEnabled;
end;

procedure Tform1.CreateBuffersBtnClick(Sender: pObj);
var
   min, max, pref, gran : integer;
   currentbuffer        : PAsioBufferInfo;
   i                    : integer;
begin
  if Driver = nil then
    Exit;
  if BuffersCreated then
    DestroyBuffersBtn.Click;

  Driver.GetBufferSize(min, max, pref, gran);

  // two output channels
  GetMem(bufferinfo, SizeOf(TAsioBufferInfo)*2);
  currentbuffer := bufferinfo;
  for i := 0 to 1 do
  begin
    currentbuffer.isInput := ASIOFalse;  // create an output buffer
    currentbuffer.channelNum := i;
    currentbuffer.buffers[0] := nil;
    currentbuffer.buffers[1] := nil;
    inc(currentbuffer);
  end;

  // actually create the buffers
  BuffersCreated := (Driver.CreateBuffers(bufferinfo, 2, pref, callbacks) = ASE_OK);

  ChangeEnabled;
end;

procedure Tform1.DestroyBuffersBtnClick(Sender: pObj);
begin
  if (Driver = nil) or not BuffersCreated then
    Exit;

  if IsStarted then
    StopBtn.Click;

  FreeMem(bufferinfo);
  bufferinfo := nil;
  Driver.DisposeBuffers;
  BuffersCreated := FALSE;

  ChangeEnabled;
end;

end.