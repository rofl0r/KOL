(*-----------------------------------------------------------------------------

Автор:  Сапронов Алексей Владимирович (Savva)
        г.Орел. 
        savva@nm.ru
        ICQ: 126578975 
        http://null.wallst.ru
Дата:   26.02.2003г.  

данный компонент представляет собой адаптированный (перенесенный) под
библиотеку KOL Владимира Кладова пример работы с Audio 
Compression Manager (автор Franзois Piette).
Ниже приводится сведения о примере (в редакции автора)

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Description:  Wave audio direct-to-disk recorder using low-level multimedia
              wave audio API and real-time audio compression.
              This program shows how to perform direct-to-disk recording and
              playing of wave audio using a dual-buffer procedure.  While one
              buffer is being filled with recorded data, the other is being
              written to disk. RecDemo also includes function calls to the
              Audio Compression Manager (ACM) for setting the wave audio format.
              This allows various compression formats to be selected by the
              user.  When compresison is used, the size of the wave file is
              reduced significantly while retaining high audio quality.
              This program is based on DDREC Windows SDK sample program.
Author:       (c) 1999, Franзois Piette. All rights reserved.
              http://www.rtfm.be/fpiette/indexuk.htm
              francois.piette@rtfm.be
              francois.piette@pophost.eunet.be
Creation:     June 16, 1999
Version       1.00
Legal Stuff:  This software may be used without charge provided this notice is
              not removed. An acknowledgement for the author's work is welcome.

              THIS SOFTWARE IS PROVIDED BY FRANCOIS PIETTE "AS IS" AND ANY
              EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
              THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
              PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR
              OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
              SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
              LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
              USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
              AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
              LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
              ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
              POSSIBILITY OF SUCH DAMAGE.
Support:      This code is unsupported. Anyway, I'll do my best to make it
              works correctly. If you find any problem, send me an EMail, I'll
              see if I can do something for you.
History:
Jul 21, 1999  V1.00 Released


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

В следствии того что этот код  больше не поддерживается автором - 
я не вижу проблем в том, что код распространяется открыто.

--------------------------------------------------------------------------------*)

{$IFDEF _D7orHigher}
  {$WARNINGS OFF}
{$ENDIF}


unit KOLACMIn;

interface
uses
  KOL, objects, Windows,Messages,MSAcm,MMSystem,err;


const
  FOURCC_WAVE   = $45564157;   { 'WAVE' }
  FOURCC_FMT    = $20746d66;   { 'fmt ' }
  FOURCC_FACT   = $74636166;   { 'fact' }
  FOURCC_DATA   = $61746164;   { 'data' }

  WAVE_BUFSIZE  = 32768;
  
type
  TACMWaveFormat = packed record
    case integer of
      0 : (Format : TWaveFormatEx);
      1 : (RawData : Array[0..128] of byte);
  end;



 PACMIn = ^TACMIn;
{----------------------------------------------------------------------

                            TKOLACMIn object

-----------------------------------------------------------------------}

  TRecorderMode     = (recModeOff, recModeRecord, recModePlay);

  TACMBufferCount = 2..64;
  TBufferFullEvent = procedure( Sender: PObj;Data : Pointer; Size:longint) of object;

  EACMIn = Class(Exception);
  TACMIn = object(TObj)
  {* Test TKOLACMIn component for KOL. }
  private
    FActive                   : Boolean;
    FHandle                   : HWND;
//    FBufferList               : PList;
    FOnBufferFull             : TBufferFullEvent;

    FWaveHdr       : array [0..1] of PWAVEHDR; // Points to wave header information
    FWaveMem       : array [0..1] of PChar;    // Points to wave buffers
    FBufIndex      : Integer;                  // Which buffer are we using
    FWaveIn        : HWAVEIN;                  // Device ID for recording input


    FMaxFmtSize    : DWORD;                   // largest format size required for compression
    FFormatDesc    : String;                   // Format description
    FFormatTag     : String;                   // Format tag description
    FDeviceOpened  : Boolean;                  // Device open status
    FRecorderMode  : TRecorderMode;            // Recording/playing mode

    FInitialized   : Boolean;
    FWaveFormat    : PWAVEFORMATEX;
    FTotalWaveSize : DWORD;                    // Number of samples recorded
    FByteDataSize  : DWORD;                    // Accumulative size of recorded data

    FWaveBufSize   : DWORD;                    // Size of buffer
    FRecordedData  : Boolean;                  // Did we recorded data

    FTmpFileHandle : HFILE;                    // Handle to temporary wave file
    FTmpFileName   : String;                   // temporary wave filename
    FDiskFreeSpace : DWORD;                    // Free space for temp file
    FFilename : string;

    procedure DoBufferFull(Header : PWaveHdr);
{
    procedure SetNumBuffers(const Value: TACMBufferCount);
}

    function  CreateTmpFile : integer;
    procedure DeleteTmpFile;
    procedure CloseTmpFile;
    function  CopyDataToWaveFile(mmfp : HMMIO) : integer;



  protected
    function InitWaveRecorder : integer;
    procedure DestroyWaveRecorder;
    function  AllocWaveFormatEx : Integer;
    procedure FreeWaveFormatEx;
    function  AllocPCMBuffers : Integer;
    procedure FreePCMBuffers;
    function  AllocWaveHeader : integer;
    procedure FreeWaveHeader;
    function  GetFormatDetails(pfmtin : PWAVEFORMATEX) : integer;
    function  GetFormatTagDetails(wFormatTag : WORD) : integer;

    procedure InitWaveHeaders;
    procedure CloseWaveDeviceRecord;
    function  AddNextBuffer : integer;
    function  StartWaveRecord : Integer;
    procedure StopWaveRecord;




    procedure WndProc(var Message: TMessage);
    procedure RaiseException(const aMessage: String; Result: Integer);
    destructor Destroy; virtual;
    {* Destructor. }
  public
    UseTempFile : boolean; // for saving data to wave file
    procedure Open;
    procedure Close;
    procedure SetBufferSize(const Value: DWord);
    function  GetWaveFormat(OwnerHandle : HWND) : integer;
    function SaveWaveFile : Integer;

    property BufferSize     : DWord
        read FWaveBufSize
        write SetBufferSize;

    property OnBufferFull   : TBufferFullEvent read FOnBufferFull write FOnBufferFull;
    {* Event }
  end;
  TKOLACMIn = PACMIn;


function NewACMIn: PACMIn;

implementation

{---------------------}
{Destructor TKOLACMIn }
{---------------------}
destructor TACMIn.Destroy;
begin
// All Strings := '';
// Free_And_Nil(All PObj);
    if FRecorderMode = recModeRecord then
        StopWaveRecord;
    DestroyWaveRecorder;

 inherited;
end;
////////////////////////////////////////////////////////////////////////////////

{-----------------------------}
{ КОНСТРУКТОР ДЛЯ TKOLACMIn   }
{-----------------------------}
function NewACMIn : PACMIn;
begin
  New(Result, Create);
  
  Result.FActive := False;
  Result.FWaveBufSize := 8192;
  Result.FWaveIn := 0;
  Result.FHandle:=AllocateHWND(Result.WndProc);

  if Result.InitWaveRecorder <> 0 then begin
    try
     Result.RaiseException('Unable Init Wave Recorder',0)
    except
     Free_And_Nil(Result);
     Raise;
    end
  end;

//  Result.FNumBuffers := 4;

end;


// Create the temporary file for writing the wave data to.
function TACMIn.CreateTmpFile : integer;
var
    Temp : array [0..MAX_PATH] of char;
    RootPathName          : array [0..MAX_PATH] of char;
    SectorsPerCluster     : DWORD;
    BytesPerSector        : DWORD;
    NumberOfFreeClusters  : DWORD;
    TotalNumberOfClusters : DWORD;
begin
 // generate a temporary filename for writing to...
    GetTempPath(sizeof(Temp), Temp);
    SetLength(FTmpFileName, MAX_PATH);
    GetTempFileName(Temp, 'wr', 0, PChar(FTmpFileName));

    FTmpFileHandle := _lcreat(PChar(FTmpFileName), 0);
    if FTmpFileHandle = HFILE_ERROR then begin
        ShowMessage('Error creating temporary file.');
        Result := -1;
        Exit;
    end;

    // get available space on the temp disk...
    if FTmpFileName[2] = ':' then
        RootPathName[0] := FTmpFileName[1]
    else
        GetCurrentDirectory(sizeof(RootPathName), @RootPathName);
    RootPathName[1] := ':';
    RootPathName[2] := '\';
    RootPathName[3] := #0;

    GetDiskFreeSpace(@RootPathName,
                     SectorsPerCluster,
                     BytesPerSector,
                     NumberOfFreeClusters,
                     TotalNumberOfClusters);
    // We may have more than 2GB (High(Integer)) free space !
    if NumberOfFreeClusters > (High(DWORD) div SectorsPerCluster) then
        FDiskFreeSpace := High(DWORD)
    else begin
        FDiskFreeSpace := NumberOfFreeClusters * SectorsPerCluster;
        if FDiskFreeSpace > (High(DWORD) div BytesPerSector) then
            FDiskFreeSpace := High(DWORD)
        else
            FDiskFreeSpace := FDiskFreeSpace * BytesPerSector;
    end;

    Result := 0;
end;

// Close the temporary file contaning the newly recorded data.
procedure TACMIn.CloseTmpFile;
begin
    if _lclose(FTmpFileHandle) = HFILE_ERROR then
        RaiseException ('Error closing temporary file.',-1);
end;
// Delete the temporary wave file.
procedure TACMIn.DeleteTmpFile;
begin
    if Length(FTmpFileName) > 0 then
        DeleteFile(PChar(FTmpFileName));
end;

// Copy the wave data in the temporary file to the wave file.
function TACMIn.CopyDataToWaveFile(mmfp : HMMIO) : integer;
var
    pbuf   : PChar;
    ht     : HFILE;
    nbytes : integer;
begin
   GetMem(pbuf,1024);
    // open the temp file for reading...
    ht := _lopen(PChar(FTmpFileName), OF_READ);
    if ht = HFILE_ERROR then begin
        Result := -1;
        Exit;
    end;

    // copy to RIFF/wave file...
    while TRUE do begin
        nbytes := _lread(ht, pbuf, 1024);
        if nbytes <= 0 then
            break;
        mmioWrite(mmfp, pbuf, nbytes);
    end;

    // close read file...
    _lclose(ht);
   FreeMem(pbuf,1024);

    Result := 0;
end;

function TACMIn.SaveWaveFile : Integer;
var
    mmfp           : HMMIO;
    dwTotalSamples : DWORD;
    fTotalSamples  : double;
    mminfopar      : TMMCKINFO;
    mminfosub      : TMMCKINFO;
    initsavename : Boolean ;
    saveDialog : POpenSaveDialog;
begin
    initsavename := FALSE;

    // if no data recorded, don't bother...
    if FTotalWaveSize = 0 then
    begin
        ShowMessage('No recorded wave data to save.');
        Result := 0;
        Exit;
    end;
    saveDialog:=NewOpenSaveDialog('Сохранить',ExtractFilePath(FFilename),[osHideReadOnly]);
    SaveDialog^.Filter      := 'Wave Files (*.wav)|*.wav|All Files (*.*)|*.*';
    SaveDialog^.FileName    := FFilename;
    SaveDialog^.DefExtension  := 'WAV';
    if not SaveDialog^.Execute then exit;
    FFilename :=SaveDialog^.Filename;

    // open the wave file for write...
    mmfp := mmioOpen(PChar(FFilename), nil,
                     MMIO_CREATE or MMIO_WRITE or MMIO_ALLOCBUF);
    if mmfp = 0 then begin
        ShowMessage('Error opening file for write.');
        Result := -1;
        Exit;
    end;

    ScreenCursor :=  LoadCursor( 0, IDC_WAIT	 );

    // create wave RIFF chunk...
    mminfopar.fccType := FOURCC_WAVE;
    mminfopar.cksize := 0;		 	// let the function determine the size
    if mmioCreateChunk(mmfp, @mminfopar, MMIO_CREATERIFF) <> 0 then begin
        ShowMessage('Error creating RIFF wave chunk.');
        Result := -2;
        Exit;
    end;

    // create the format chunk and write the wave format...
    mminfosub.ckid   := FOURCC_FMT;
    mminfosub.cksize := FMaxFmtSize;
    if mmioCreateChunk(mmfp, @mminfosub, 0) <> 0 then begin
        ShowMessage('Error creating RIFF format chunk.');
        Result := -3;
        Exit;
    end;

    if mmioWrite(mmfp, PChar(FWaveFormat), FMaxFmtSize) <> LongInt(FMaxFmtSize) then begin
        ShowMessage('Error writing RIFF format data.');
        Result := -3;
        Exit;
    end;

    // back out of format chunk...
    mmioAscend(mmfp, @mminfosub, 0);

    // write the fact chunk (required for all non-PCM .wav files...
    // this chunk just contains the total length in samples...
    mminfosub.ckid   := FOURCC_FACT;
    mminfosub.cksize := sizeof(DWORD);
    if mmioCreateChunk(mmfp, @mminfosub, 0) <> 0 then begin
        ShowMessage('Error creating RIFF ''fact'' chunk.');
        Result := -4;
        Exit;
    end;

    fTotalSamples := FTotalWaveSize / FWaveFormat.nAvgBytesPerSec *
                     FWaveFormat.nSamplesPerSec;
    dwTotalSamples := Trunc(fTotalSamples);
    if mmioWrite(mmfp, PChar(@dwTotalSamples), sizeof(dwTotalSamples))
       <> sizeof(dwTotalSamples) then begin
        ShowMessage( 'Error writing RIFF ''fact'' data.');
        Result := -4;
        Exit;
    end;

    // back out of fact chunk...
    mmioAscend(mmfp, @mminfosub, 0);

    // now create and write the wave data chunk...
    mminfosub.ckid   := FOURCC_DATA;
    mminfosub.cksize := 0;	 	// let the function determine the size
    if mmioCreateChunk(mmfp, @mminfosub, 0) <> 0 then begin
        ShowMessage('Error creating RIFF data chunk.');
        Result := -5;
        Exit;
    end;

    // copy the data from the temp file to the wave file...
    if CopyDataToWaveFile(mmfp) <> 0 then begin
        ShowMessage('Error writing wave data.');
        Result := -5;
        Exit;
    end;

    // back out and cause the size of the data buffer to be written...
    mmioAscend(mmfp, @mminfosub, 0);

    // ascend out of the RIFF chunk...
    mmioAscend(mmfp, @mminfopar, 0);

    // done...
    mmioClose(mmfp, 0);

    ScreenCursor :=  LoadCursor( 0, IDC_ARROW	 );

    // indicate filename on window title...
//    Caption := WindowCaption + ' - ' + FFileName;

    // set this so we don't ask for a filename when the user does "SAVE"...
//    FFileSaved := TRUE;

    Result := 0;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TACMIn.DoBufferFull(Header : PWaveHdr);
var
   Res                        : Integer;
   BytesRecorded              : Integer;
   Data                       : Pointer;
begin
  if FActive then begin

    BytesRecorded:=header.dwBytesRecorded;
     if UseTempFile then
       if _lwrite(FTmpFileHandle, header.lpData, BytesRecorded ) <> BytesRecorded then begin
         ShowMsg('Error writing data to temporary file.',0);
         Exit;
       end;


    if assigned(FOnBufferFull) then begin
      Getmem(Data, BytesRecorded);
      try
        move(header.lpData^,Data^,BytesRecorded);
        FOnBufferFull(@Self, Data, BytesRecorded);
      finally
        Freemem(Data);
      end;
    // running total bytes recorded...
    Inc(FByteDataSize, BytesRecorded);
      
//        StopWaveRecord;

      if FRecorderMode <> recModeOff then
         AddNextBuffer    	        // queue it again...
      else
         CloseWaveDeviceRecord;          // stop recording...
    end;
  end;

end;

procedure TACMIn.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    MM_WIM_Data: DoBufferFull(PWaveHDR(Message.LParam));
  end;
end;

procedure TACMIn.SetBufferSize(const Value: DWord);
begin
  if FActive then exit;
  FWaveBufSize:= Value;
end;
{procedure TACMIn.SetNumBuffers(const Value: TACMBufferCount);
begin
  if FActive then exit;
  FNumBuffers := Value;
end;


function TACMIn.NewHeader: PWaveHDR;
var
  Res                         : Integer;
begin
  Getmem(Result, SizeOf(TWaveHDR));
  FBufferList.Add(Result);
  with Result^ do begin
    Getmem(lpData,FBufferSize);
    dwBufferLength := FBufferSize;
    dwBytesRecorded := 0;
    dwFlags := 0;
    dwLoops := 0;
    Res := WaveInPrepareHeader(FWaveInHandle,Result,sizeof(TWaveHDR));
    if Res <> 0 then RaiseException('WaveIn-PrepareHeader',Res);

    Res := WaveInAddBuffer(FWaveInHandle,Result,SizeOf(TWaveHDR));
    if Res <> 0 then RaiseException('WaveIn-AddBuffer',Res);
  end;
end;

procedure TACMIn.DisposeHeader(Header: PWaveHDR);
var
  X                           : Integer;
begin
  X := FBufferList.IndexOf(Header);
  if X < 0 then exit;
  waveInUnprepareHeader(FWaveInHandle,Header,sizeof(TWavehdr));
  Freemem(header.lpData);
  Freemem(header);
  FBufferList.Delete(X);
end;
}

procedure TACMIn.Open;
begin
  if FActive then exit;
  FTmpFileHandle:=0;
  if UseTempFile then
     if CreateTmpFile <> 0 then begin
       RaiseException('Error opening temporary wave file for writing.',-1);
       Exit;
     end;

  StartWaveRecord;
  FActive := True;
end;
procedure TACMIn.Close;
begin
  if not FActive then Exit;
  StopWaveRecord;
  if (UseTempFile) or (FTmpFileHandle<>0) then begin
     if MessageBox(0,'Сохранить записанные данные?','Внимание',
                 MB_ICONQUESTION	+MB_OKCANCEL + MB_DEFBUTTON1)= IDOK then
         SaveWaveFile;
     CloseTmpFile;
     DeleteTmpFile;
  end;

  FActive:=false;
end;

procedure TACMIn.RaiseException(const aMessage: String; Result: Integer);
begin
  case Result of
    ACMERR_NotPossible : Raise EACMIn.CreateCustom(Result,aMessage + ' The requested operation cannot be performed.');
    ACMERR_BUSY : Raise EACMIn.CreateCustom(Result,aMessage + ' The conversion stream is already in use.');
    ACMERR_UNPREPARED : Raise EACMIn.CreateCustom(Result,aMessage + ' Cannot perform this action on a header that has not been prepared.');
    MMSYSERR_InvalFlag : Raise EACMIn.CreateCustom(Result,aMessage + ' At least one flag is invalid.');
    MMSYSERR_InvalHandle : Raise EACMIn.CreateCustom(Result,aMessage + ' The specified handle is invalid.');
    MMSYSERR_InvalParam : Raise EACMIn.CreateCustom(Result,aMessage + ' At least one parameter is invalid.');
    MMSYSERR_NoMem : Raise EACMIn.CreateCustom(Result,aMessage + ' The system is unable to allocate resources.');
    MMSYSERR_NoDriver : Raise EACMIn.CreateCustom(Result,aMessage + ' A suitable driver is not available to provide valid format selections.');
    MMSYSERR_ALLOCATED : Raise EACMIn.CreateCustom(Result,aMessage + ' The specified resource is already in use.');
    MMSYSERR_BADDEVICEID : Raise EACMIn.CreateCustom(Result,aMessage + ' The specified resource does not exist.');
    WAVERR_BADFORMAT : Raise EACMIn.CreateCustom(Result,aMessage + ' Unsupported audio format.');
    WAVERR_SYNC : Raise EACMIn.CreateCustom(Result,aMessage + ' The specified device does not support asynchronous operation.');
  else
    if Result <> 0 then
      Raise EACMIn.CreateCustomFmt(Result,'%s raised an unknown error (code #%d)',[aMessage,Result]);
  end;
end;

// Allocate format and wave headers, data buffers, and temporary filename.
function TACMIn.InitWaveRecorder : integer;
begin
    Result := -1;
    // allocate memory for wave format structure...
    if AllocWaveFormatEx <> 0 then
        Exit;

    // find a device compatible with the available wave characteristics...
    if waveInGetNumDevs < 1 then begin
        RaiseException('No wave audio recording devices found.',0);
        Result := -1;
        Exit;
    end;

    // allocate the wave header memory...
    if AllocWaveHeader <> 0 then begin
        Result := -3;
        Exit;
    end;

    // allocate the wave data buffer memory...
    if AllocPCMBuffers <> 0 then begin
        Result := -4;
        Exit;
    end;
 

    Result := 0;
end;

// Free the memory associated with the wave buffers.
procedure TACMIn.DestroyWaveRecorder;
begin
    FreeWaveFormatEx;
    FreePCMBuffers;
    FreeWaveHeader;
end;
// Allocate and lock WAVEFORMATEX structure based on maximum format size
// according to the ACM.
function TACMIn.AllocWaveFormatEx : Integer;
begin
    // get the largest format size required from installed ACMs...
    // FMaxFmtSize is the sum of sizeof(WAVEFORMATEX) + FWaveFormat.cbSize
    if acmMetrics(nil, ACM_METRIC_MAX_SIZE_FORMAT, FMaxFmtSize) <> 0 then begin
        RaiseException('Error getting the max compression format size.',-1);
        Result := -1;
        Exit;
    end;

    GetMem(FWaveFormat, FMaxFmtSize);
    if FWaveFormat = nil then begin
        RaiseException('Error allocating local memory for WaveFormatEx structure.',-1);
        Result := -2;
        Exit;
    end;

    // initialize the format to standard PCM...
    FillChar(FWaveFormat^, FMaxFmtSize, 0);
    FWaveFormat.wFormatTag      := WAVE_FORMAT_PCM;
    FWaveFormat.nChannels       := 1;
    FWaveFormat.nSamplesPerSec  := 11025;
    FWaveFormat.nAvgBytesPerSec := 11025;
    FWaveFormat.nBlockAlign     := 1;
    FWaveFormat.wBitsPerSample  := 8;
    FWaveFormat.cbSize          := 0;

    // store the format and tag decription strings...
    GetFormatTagDetails(FWaveFormat.wFormatTag);
    GetFormatDetails(FWaveFormat);

    Result := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
// Free the WAVEFORMATEX buffer.
procedure TACMIn.FreeWaveFormatEx;
begin
    if FWaveFormat <> nil then begin
        FreeMem(FWaveFormat);
        FWaveFormat := nil;
    end;
end;

// Allocate and lock wave memory
function TACMIn.AllocPCMBuffers : Integer;
var
    i : Integer;
begin
    for i := Low(FWaveMem) to High(FWaveMem) do begin
        GetMem(FWaveMem[i], WAVE_BUFSIZE);
        if FWaveMem[i] = nil then begin
            RaiseException('Error allocating wave buffer memory.',-1);
            Result := -1;
            Exit;
        end;
        FWaveHdr[i].lpData := FWaveMem[i];
    end;
    Result := 0;
end;
// Free the wave memory.
procedure TACMIn.FreePCMBuffers;
var
    i : Integer;
begin
    for i := Low(FWaveMem) to High(FWaveMem) do begin
        if FWaveMem[i] <> nil then begin
            FreeMem(FWaveMem[i]);
            FWaveMem[i] := nil;
        end;
    end;
end;




// Allocate and lock header memory
function TACMIn.AllocWaveHeader : integer;
var
    i : Integer;
begin
    for i := Low(FWaveHdr) to High(FWaveHdr) do begin
        GetMem(FWaveHdr[i], sizeof(TWAVEHDR));
        if FWaveHdr[i] = nil then begin
            RaiseException('Error allocating wave header memory.',-1);
            Result := -1;
            Exit;
        end;
    end;
    Result := 0;
end;

// Free the wave header memory.
procedure TACMIn.FreeWaveHeader;
var
    i : Integer;
begin
    for i := Low(FWaveHdr) to High(FWaveHdr) do begin
        if FWaveHdr[i] <> nil then begin
            FreeMem(FWaveHdr[i]);
            FWaveHdr[i] := nil;
        end;
    end;
end;

function TACMIn.GetWaveFormat(OwnerHandle : HWND) : integer;
var
    acmopt  : TACMFORMATCHOOSE;
    err     : MMRESULT;
    ptmpfmt : PWAVEFORMATEX;
begin
    // store the format temporarily...
    GetMem(ptmpfmt, FMaxFmtSize);
    if ptmpfmt = nil then begin
        RaiseException('Error allocating temporary format buffer.',-1);
        Result := -1;
        Exit;
    end;

    Move(FWaveFormat^, ptmpfmt^, FMaxFmtSize);

    // setup ACM choose fields and display the dialog...
    FillChar(acmopt, sizeof(acmopt), 0);  // zero out
    acmopt.cbStruct  := sizeof(acmopt);
    acmopt.fdwStyle  := ACMFORMATCHOOSE_STYLEF_INITTOWFXSTRUCT;
    acmopt.hwndOwner := OwnerHandle;
    acmopt.pwfx      := FWaveFormat;
    acmopt.cbwfx     := FMaxFmtSize;
    acmopt.pszTitle  := 'Select Compression';
    acmopt.fdwEnum   := ACM_FORMATENUMF_INPUT;
    err              := acmFormatChoose(acmopt);

    // if the same format was selected we don't want to reset FTotalWaveSize
    // below, so act like a cancel...
    if CompareMem(FWaveFormat, ptmpfmt, sizeof(TWAVEFORMATEX)) then
        err := ACMERR_CANCELED;
    if err <> MMSYSERR_NOERROR then begin
        Move(ptmpfmt^, FWaveFormat^, FMaxFmtSize);
        FreeMem(ptmpfmt);
        if err = ACMERR_CANCELED then begin
            Result := 0;
            Exit;
        end;
        RaiseException('Error in FormatChoose function',-1);

        Result :=  -2;
        Exit;
    end;

    // store the format description...
    FFormatDesc := acmopt.szFormat;

    // get the format tag details, we don't need to call acmGetFormatDetails since
    // that information was supplied by the choose function...
    GetFormatTagDetails(acmopt.pwfx.wFormatTag);

    FreeMem(ptmpfmt);

    // now set the play button to a grayed state cause we don't want
    // to try to play the recorded data with a different format...
    FTotalWaveSize := 0;

    Result := 0;
end;


// Zero out the wave headers and initialize the data pointers and
// buffer lengths.
procedure TACMIn.InitWaveHeaders;
begin
    // make the wave buffer size a multiple of the block align...
    FWaveBufSize := (FWaveBufSize - FWaveBufSize mod FWaveFormat.nBlockAlign);
    // zero out the wave headers...
    FillChar(FWaveHdr[0]^, sizeof(TWAVEHDR), 0);
    FillChar(FWaveHdr[1]^, sizeof(TWAVEHDR), 0);
    // now init the data pointers and buffer lengths...
    FWaveHdr[0].dwBufferLength := FWaveBufSize;
    FWaveHdr[1].dwBufferLength := FWaveBufSize;
    FWaveHdr[0].lpData         := FWaveMem[0];
    FWaveHdr[1].lpData         := FWaveMem[1];
end;
procedure TACMIn.CloseWaveDeviceRecord;
begin
    // if the device is already closed, just return...
    if not FDeviceOpened then
        Exit;

    // unprepare the headers...
    if waveInUnprepareHeader(FWaveIn, FWaveHdr[0], sizeof(TWAVEHDR)) <> 0 then
        RaiseException('Error in waveInUnprepareHeader (1)',-1);

    if waveInUnprepareHeader(FWaveIn, FWaveHdr[1], sizeof(TWAVEHDR)) <> 0 then
        RaiseException('Error in waveInUnprepareHeader (2)',-1);


    // save the total size recorded and update the display...
    FTotalWaveSize := FByteDataSize;

    // tell the file save functions that we've got unsaved data...
    FRecordedData := TRUE;


    // close the wave input device...
    if waveInClose(FWaveIn) <> 0 then
        RaiseException('Error closing input device.',-1);


    // tell this function we are now closed...
    FDeviceOpened := FALSE;

    // update display...
    // InvalidateRect( hwnd, &specrect, TRUE );
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
// Add the buffer to the wave input queue and toggle buffer index. This
// routine is called from the main window proc.
function TACMIn.AddNextBuffer : integer;
begin
    // queue the buffer for input...
    if waveInAddBuffer(FWaveIn, FWaveHdr[FBufIndex], sizeof(TWAVEHDR)) <> 0 then begin
        StopWaveRecord;
        RaiseException('Error adding buffer.',-1);

        Result := -1;
        Exit;
    end;

    // toggle for next buffer...
    FBufIndex := 1 - FBufIndex;

    Result := 0;
end;


// Prepare headers, add buffer, adjust display, and start recording.
function TACMIn.StartWaveRecord : Integer;
var
    Status : MMRESULT;
begin
    FTotalWaveSize := 0;
    FByteDataSize  := 0;
    FBufIndex      := 0;

    // open the device for recording...
    Status := waveInOpen(@FWaveIn, WAVE_MAPPER, FWaveFormat,
                         FHandle, 0, CALLBACK_WINDOW);
    if Status <> MMSYSERR_NOERROR then begin
        RaiseException('Could not open the input device for recording.',-1);
        Result := -1;
        Exit;
    end;

    // tell CloseWaveDeviceRecord() that the device is open...
    FDeviceOpened := TRUE;

    // prepare the headers...
    InitWaveHeaders;

    if not ((waveInPrepareHeader(FWaveIn, FWaveHdr[0], sizeof(TWAVEHDR)) = 0) and
        (waveInPrepareHeader(FWaveIn, FWaveHdr[1], sizeof(TWAVEHDR)) = 0))
    then begin
        CloseWaveDeviceRecord;
        RaiseException('Error preparing header for recording.',-1);

        Result := -2;
        Exit;
    end;

    // add the first buffer...
    if AddNextBuffer <> 0 then begin
        Result := -3;
        Exit;
    end;


    // start recording to first buffer...
    if waveInStart(FWaveIn) <> 0 then begin
        CloseWaveDeviceRecord;
        RaiseException('Error starting wave record.',-1);

        Result := -5;
        Exit;
    end;

    FRecorderMode := recModeRecord;


    // queue the next buffer...
    if AddNextBuffer <> 0 then begin
        Result := -6;
        Exit;
    end;
    Result := 0;
end;

// Stop the recording.
procedure TACMIn.StopWaveRecord;
begin
    // set flag before stopping since it's used in the MM_WIM_DATA message
    // in our main window proc to control whether we add another buffer
    // or to close the device.
    FRecorderMode := recModeOff;

    // stop recording and return queued buffers...
    if waveInReset(FWaveIn) <> 0 then
        RaiseException('Error in StopRecord',-1);
  CloseWaveDeviceRecord;


end;

// Get the format tag details and store the string description.
function TACMIn.GetFormatTagDetails(wFormatTag : WORD) : integer;
var
    acmtagdetails : TACMFORMATTAGDETAILS;
begin
    // zero out...
    FillChar(acmtagdetails, sizeof(acmtagdetails), 0);

    acmtagdetails.cbStruct    := sizeof(acmtagdetails);
    acmtagdetails.dwFormatTag := wFormatTag;

    if acmFormatTagDetails(nil, acmtagdetails,
                           ACM_FORMATTAGDETAILSF_FORMATTAG) <> 0 then begin
        RaiseException('Warning, FormatTagDetails function failed',-1);
        Result := -1;
        Exit;
    end;

    // store the format tag details description string...
    FFormatTag := acmtagdetails.szFormatTag;
    Result := 0;
end;
// Get the format details and store the string description.
function TACMIn.GetFormatDetails(pfmtin : PWAVEFORMATEX) : integer;
var
    acmfmtdetails : TACMFORMATDETAILS;
begin
    // zero out struct...
    FillChar(acmfmtdetails, sizeof(acmfmtdetails), 0);

    acmfmtdetails.cbStruct    := sizeof(acmfmtdetails);
    acmfmtdetails.pwfx        := pfmtin;
    acmfmtdetails.dwFormatTag := pfmtin.wFormatTag;
    acmfmtdetails.cbwfx       := sizeof(TWAVEFORMATEX) + pfmtin.cbSize;

    if acmFormatDetails(nil, acmfmtdetails,
                        ACM_FORMATDETAILSF_FORMAT) <> 0 then begin
        RaiseException('Warning, FormatDetails function failed',-1);

        Result := -1;
        Exit;
    end;

    // store the format details description string...
    FFormatDesc := acmfmtdetails.szFormat;

    Result := 0;
end;






end.
