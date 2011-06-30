// 27-nov-2002
unit IdCoderIMF;

interface

uses KOL { , 
  Classes } ,
  IdCoder,
  SysUtils;

const
  ConstIMFStart = 0;
  ConstIMFMessageStart = 1;
  ConstIMFBoundaryEnd = 2;

  ConstContentType = 'content-type';
  ConstContentTransferEncoding = 'content-transfer-encoding';
  ConstContentDisposition = 'content-disposition';
  ConstContentMD5 = 'content-md5';

  ConstBoundary = 'boundary';
  ConstFileName = 'filename';
  ConstName = 'name';

type
  TIdIMFDecoder = object(TIdCoder)
  protected
    FState: Byte;
    FContentType, FContentTransferEncoding: string;
    FDefaultContentType, FDefaultContentTransferEncoding: string;
    FDefaultContentFound, FDefaultContentTypeFound,
      FDefaultContentTransferEncodingFound: Boolean;
    FLastContentType, FLastContentTransferEncoding: string;
    FCurHeader, FTrueString: string;
    FMIMEBoundary: PStrList;
    FInternalDecoder: TIdCoder;

    procedure CreateDecoder; virtual;

    procedure Coder; virtual;//override;
    procedure CompleteCoding; virtual;//override;

    procedure IMFStart; virtual;
    procedure IMFMessageStart; virtual;
    procedure IMFBoundaryEnd; virtual;

    procedure ProcessHeader; virtual;
    procedure RenewCoder; virtual;

//    procedure WriteOutput(Sender: TComponent; const sOut: string);
  public
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy; 

     virtual; procedure Reset; virtual;//override;
  end;
PIdIMFDecoder=^TIdIMFDecoder;
function NewIdIMFDecoder(AOwner: PControl):PIdIMFDecoder;
 type

  TIdIMFUUDecoder = object(TIdIMFDecoder)
  protected
    procedure CreateDecoder; virtual;//override;
    procedure RenewCoder; virtual;//override;
  public
     { constructor Create(AOwner: TComponent); override;
     } destructor Destroy; 
   virtual; end;
PIdIMFUUDecoder=^TIdIMFUUDecoder;
function NewIdIMFUUDecoder(AOwner: PControl):PIdIMFUUDecoder;


implementation

uses
  IdGlobal;

  function NewIdIMFDecoder(AOwner: PControl):PIdIMFDecoder;
  //constructor TIdIMFDecoder.Create;
begin
New( Result, Create );
with Result^ do
begin
//  FMIMEBoundary := PStrList.Create;
//  inherited Create(AOwner);
  FState := ConstIMFStart;
  FContentType := '';
  FContentTransferEncoding := '';
  FDefaultContentType := '';
  fDefaultContentTransferEncoding := '8bit';
  FDefaultContentFound := False;
  FDefaultContentTypeFound := False;
  FDefaultContentTransferEncodingFound := False;
  FLastContentType := '';
  FLastContentTransferEncoding := '';
  FCurHeader := '';
  FTrueString := '';
  fAddCRLF := False;
  CreateDecoder;
  FInternalDecoder.UseEvent := True;
//  FInternalDecoder.OnCodedData := WriteOutput;
end;
end;

destructor TIdIMFDecoder.Destroy;
begin
  FMIMEBoundary.Free;
  inherited Destroy;
end;

procedure TIdIMFDecoder.CreateDecoder;
var
  CItem: TIdCoderItem;
begin
  CItem := CoderCollective.GetCoderType('',
    '7bit', CT_REALISATION);
//  FInternalDecoder := CItem.IdCoderClass.Create(Self);
end;

procedure TIdIMFDecoder.Reset;
begin
  inherited;
  FState := ConstIMFStart;
end;

procedure TIdIMFDecoder.RenewCoder;
var
  CItem: TIdCoderItem;
  exactType, exactEnc, temp: string;
begin
  temp := FContentType;
  exactType := Fetch(temp, ';');
  temp := FContentTransferEncoding;
  exactEnc := Fetch(temp, ';');

  if (FContentType <> FLastContentType) or
    (FContentTransferEncoding <> FLastContentTransferEncoding) then
  begin
    FInternalDecoder.Free;
    CItem := CoderCollective.GetCoderType(exactType, exactEnc, CT_REALISATION);
//    FInternalDecoder := CItem.IdCoderClass.Create(Self);
    FInternalDecoder.UseEvent := True;
//    FInternalDecoder.OnCodedData := WriteOutput;
  end;

  FLastContentType := exactType;
  FLastContentTransferEncoding := exactEnc;

end;

procedure TIdIMFDecoder.Coder;
begin
  case FState of
    ConstIMFStart: IMFStart;
    ConstIMFMessageStart: IMFMessageStart;
    ConstIMFBoundaryEnd: IMFBoundaryEnd;
  end;
end;

procedure TIdIMFDecoder.CompleteCoding;
begin
  fInCompletion := True;
  while FCBufferedData > 0 do
  begin
//    InternSetBufferSize(FCBufferedData);
    FCBufferedData := FCBufferSize;
    Coder;
  end;
  FInternalDecoder.CompletedInput;
  OutputNotification(CN_IMF_DATA_END, '');
  FCBufferedData := 0;
end;

procedure TIdIMFDecoder.IMFStart;
var
  i: LongWord;
  s: string;
  processLine: Boolean;
begin
  if FCBufferedData = 0 then Exit;

  s := Copy(FCBuffer, 1, FCBufferedData);
  i := IndyPos(CR, s);

  while i > 0 do
  begin
    FTrueString := FTrueString + Copy(s, 1, i);

    if (s[1] = ' ') or (s[1] = #9) then
    begin
      ProcessLine := True;
      while ProcessLine do
      begin
        if (s[1] = ' ') or (s[1] = #9) then
        begin
          System.Delete(s, 1, 1);
        end
        else
        begin
          ProcessLine := False;
        end;
      end;

      i := Length(FCurHeader);
      if i > 0 then
      begin
        if not ((FCurHeader[i] = ' ') or (FCurHeader[i] = #9)) then
        begin
          FCurHeader := FCurHeader + ' ';
        end;
      end;

      i := IndyPos(CR, s);
    end;

    FCurHeader := FCurHeader + Copy(s, 1, i - 1);
    s := Copy(s, i + 1, length(s));

    if length(s) > 0 then
    begin
      if s[1] = LF then
      begin
        s := Copy(s, 2, length(s));
        FTrueString := FTrueString + LF;
      end;
    end;

    FCurHeader := Trim(FCurHeader);
    if Length(FCurHeader) > 0 then
    begin

      if Length(s) > 0 then
      begin
        if (s[1] = ' ') or (s[1] = #9) then
        begin
          ProcessLine := False;
        end
        else
        begin
          ProcessLine := True;
        end;
      end
      else
      begin
        ProcessLine := False;
      end;

      if ProcessLine then
      begin
        ProcessHeader;
      end;

    end
    else
    begin
      FState := ConstIMFMessageStart;
      OutputString(FTrueString);
      FTrueString := '';
      Break;
    end;

    i := IndyPos(CR, s);
  end;

  FDefaultContentFound := True;

  if FState = ConstIMFStart then
  begin
    if fInCompletion then
    begin
      OutputString(s);
      s := '';
    end
    else
    begin
      FCurHeader := FCurHeader + s;
    end;
  end;
  FCBufferedData := LongWord(length(s));
  System.Move(s[1], FCBuffer[1], FCBufferedData);
  if FState = ConstIMFMessageStart then
  begin
    OutputString(CR + LF);
    OutputNotification(CN_IMF_BODY_START, '');
    RenewCoder;
    IMFMessageStart;
  end;
end;

procedure TIdIMFDecoder.ProcessHeader;
var
  paramWork: string;
  i: LongWord;

  function GetQuotedPair(const AString: string): string;
  var
    li: LongWord;
    ls: string;
    testSpace: Boolean;
  begin
    if length(AString) = 0 then
    begin
      result := '';
    end
    else
    begin
      ls := AString;
      if ls[1] = '"' then
      begin
        ls := Copy(ls, 2, length(ls));
        li := IndyPos('"', ls);
        if li > 0 then
        begin
          result := Copy(ls, 1, li - 1);
          testSpace := False;
        end
        else
        begin
          testSpace := True;
        end;
      end
      else
      begin
        testSpace := True;
      end;

      if testSpace then
      begin
        result := Fetch(ls, ' ');
      end;

    end;
  end;

begin
  OutputNotification(CN_IMF_HEAD_VALUE, FCurHeader);

  case FCurHeader[1] of
    'c', 'C':
      begin
        if lowercase(Copy(FCurHeader, 1, length(ConstContentTransferEncoding)))
          = ConstContentTransferEncoding then
        begin
          Fetch(FCurHeader, ':');
          FContentTransferEncoding := Trim(FCurHeader);
          if not FDefaultContentFound then
          begin
            FDefaultContentTransferEncodingFound := True;
            fDefaultContentTransferEncoding := FContentTransferEncoding;
          end;

        end
        else
          if lowercase(Copy(FCurHeader, 1, Length(ConstContentType)))
          = ConstContentType then
        begin
          Fetch(FCurHeader, ':');
          FContentType := Trim(FCurHeader);
          FContentTransferEncoding := '';
          if not FDefaultContentFound then
          begin
            FDefaultContentTypeFound := True;
            FDefaultContentType := FContentType;
          end;

          i := IndyPos(ConstBoundary + '=', LowerCase(FContentType));
          if i > 0 then
          begin
            paramWork := Copy(FContentType, i + 9, length(FContentType));

            i := IndyPos('"', paramWork);
            if i > 0 then
            begin
              paramWork := Copy(paramWork, i + 1, length(paramWork));
            end;

            i := IndyPos('"', paramWork);
            if i > 0 then
            begin
              paramWork := Copy(paramWork, 1, i - 1);
            end;

            FMIMEBoundary.Insert(0, paramWork);
          end;

          i := IndyPos(ConstName + '=', LowerCase(FContentType));
          if i > 0 then
          begin
            paramWork := Copy(FContentType, i + 1 + LongWord(length(ConstName)),
              length(FContentType));
            FFileName := GetQuotedPair(paramWork);
            OutputNotification(CN_IMF_NEW_FILENAME, FFileName);
            FTakesFileName := True;
          end;

        end
        else
          if lowercase(Copy(FCurHeader, 1, Length(ConstContentDisposition)))
          = ConstContentDisposition then
        begin
          Fetch(FCurHeader, ':');
          i := IndyPos(ConstFileName + '=', LowerCase(FCurHeader));
          if i > 0 then
          begin
            FCurHeader := Copy(FCurHeader, i + LongWord(length(ConstFileName)) +
              1,
              length(FCurHeader));
            FFileName := GetQuotedPair(FCurHeader);
            OutputNotification(CN_IMF_NEW_FILENAME, FFileName);
            FTakesFileName := True;
          end;
        end
        else
        begin
          OutputString(FTrueString);
          FTrueString := '';
        end;
      end;
  else
    begin
      OutputString(FTrueString);
      FTrueString := '';
    end;
  end;
  FCurHeader := '';
end;

procedure TIdIMFDecoder.IMFMessageStart;
var
  i, bPos, mPos, mIndicator: LongWord;
  s, mData, mTemp: string;
begin
  if FCBufferedData = 0 then Exit;

  s := Copy(FCBuffer, 1, FCBufferedData);

  if FMIMEBoundary.Count > 0 then
  begin
    mPos := LongWord(-1);
    mIndicator := LongWord(-1);
    for i := 0 to FMIMEBoundary.Count - 1 do
    begin
//      bPos := IndyPos(FMIMEBoundary[i], s);
      if (bPos < mPos) and (bPos <> 0) then
      begin
        mPos := bPos;
        mIndicator := i;
      end;
    end;

    if mIndicator <> LongWord(-1) then
    begin
      mData := Copy(s, 1, mPos - 1);
      i := Length(mData);
      if i >= 4 then
      begin
        mTemp := Copy(mData, length(mData) - 3, 4);
        if mTemp = CR + LF + '--' then
        begin
          mData := Copy(mData, 1, i - 4);
          i := 4;
        end
        else
        begin
          i := 5;
        end;
      end
      else
        if i >= 2 then
      begin
        if (mData[i] = '-') and (mData[i - 1] = '-') then
        begin
          mData := Copy(mData, 1, i - 2);
        end;
      end;

      s := Copy(s, length(mData) + 1, length(s));

      if length(mData) > 0 then
      begin
        FInternalDecoder.CodeString(mData);
        FInternalDecoder.CompletedInput;
        FInternalDecoder.Reset;
      end
      else
        if (FInternalDecoder.BytesIn.L > 0) or
        (FInternalDecoder.BytesIn.H > 0) then
      begin
        FInternalDecoder.CompletedInput;
        FInternalDecoder.Reset;
      end;

//      OutputNotification(CN_IMF_NEW_MULTIPART, FMIMEBoundary[mIndicator]);
      if i >= 4 then
      begin
//        FCurHeader := CR + LF + '--' + FMIMEBoundary[mIndicator];
      end
      else
        if i >= 2 then
      begin
//        FCurHeader := '--' + FMIMEBoundary[mIndicator];
      end
      else
      begin
      end;

//      mPos := IndyPos(FMIMEBoundary[mIndicator], s);
//      s := Copy(s, mPos + LongWord(length(FMIMEBoundary[mIndicator])),
//        length(s));

      FCBufferedData := length(s);
      System.Move(s[1], FCBuffer[1], FCBufferedData);

      FState := ConstIMFBoundaryEnd;
    end
    else
    begin
      FInternalDecoder.CodeString(s);
      FCBufferedData := 0;
    end;

  end
  else
  begin
    FInternalDecoder.CodeString(s);
    FCBufferedData := 0;
  end;
end;

procedure TIdIMFDecoder.IMFBoundaryEnd;
var
  s: string;
begin
  if FCBufferedData = 0 then Exit;

  if FCBufferSize < 4 then
  begin
//    InternSetBufferSize(5);
  end
  else
    if (FCBufferedData < 4) and fInCompletion then
  begin
    case FCBufferedData of
      1:
        begin
        end;
      2:
        begin
        end;
      3:
        begin
        end;
    end;
    FCBufferedData := 0;
  end
  else
    if FCBufferedData >= 4 then
  begin
    s := Copy(FCBuffer, 1, FCBufferedData);
    if (s[1] = '-') and (s[2] = '-') then
    begin
      OutputNotification(CN_IMF_END_MULTIPART, '');
      FCurHeader := FCurHeader + '--';
      s := Copy(s, 3, length(s));
    end;

    if s[1] = '-' then
    begin
      FCurHeader := FCurHeader + s[1];
      s := Copy(s, 2, length(s));
    end;

    if s[1] = CR then
    begin
      FCurHeader := FCurHeader + s[1];
      s := Copy(s, 2, length(s));
    end;

    if s[1] = LF then
    begin
      FCurHeader := FCurHeader + s[1];
      s := Copy(s, 2, length(s));
    end;

    if length(FCurHeader) > 0 then
    begin
      OutputString(FCurHeader);
      FCurHeader := '';
    end;

    FCBufferedData := length(s);
    System.Move(s[1], FCBuffer[1], FCBufferedData);
    FState := ConstIMFStart;
  end;
end;

{procedure TIdIMFDecoder.WriteOutput;
begin
  OutputString(sOut);
end;}

//constructor TIdIMFUUDecoder.Create;
function NewIdIMFUUDecoder(AOwner: PControl):PIdIMFUUDecoder;
begin
   New( Result, Create );
//  inherited Create(AOwner);
end;

destructor TIdIMFUUDecoder.Destroy;
begin
  inherited;
end;

procedure TIdIMFUUDecoder.RenewCoder;
begin

end;

procedure TIdIMFUUDecoder.CreateDecoder;
var
  CItem: TIdCoderItem;
begin
  CItem := CoderCollective.GetCoderType('',
    'x-uu', CT_REALISATION);
//  if CItem = nil then
  begin
    inherited;
  end
{  else
  begin
    FInternalDecoder := CItem.IdCoderClass.Create(Self);
  end};
end;

initialization
{  RegisterCoderClass(TIdCoder, CT_REALISATION, CP_FALLBACK,
    '', '7bit');
  RegisterCoderClass(TIdCoder, CT_REALISATION, CP_FALLBACK,
    '', '8bit');
  RegisterCoderClass(TIdCoder, CT_REALISATION, CP_FALLBACK,
    '', 'binary');
  RegisterCoderClass(TIdIMFDecoder, CT_REALISATION, CP_IMF or CP_STANDARD,
    'text/', '8bit');
 }
end.
