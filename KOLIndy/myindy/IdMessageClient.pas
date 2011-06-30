// 27-nov-2002
unit IdMessageClient;

interface

uses KOL { , 
  Classes } ,windows,
  IdMessage, IdTCPClient, IdHeaderList,
  IdCoder, IdCoderIMF, IdCoder3To4, IdCoderText;

type
  TIdMessageClient = object(TIdTCPClient)
  protected
    FMsgLineLength: Word;
    FMsgLineFold: string;

    procedure ReceiveBody(AMsg: pIdMessage); virtual;
    procedure ReceiveHeader(AMsg: pIdMessage; const ADelim: string); virtual;
    procedure ReceiveMsg(AMsg: pIdMessage; const ADelim: string); virtual;
    procedure SendBody(AMsg: pIdMEssage; const Attcount, Textcount, RelCount:
      integer); virtual;
    procedure SendMsg(AMsg: pIdMessage); virtual;
    procedure SendHeader(AMsg: pIdMessage; var AttCount, TextCount, RelCount:
      Integer); virtual;

    procedure WriteFoldedLine(const ALine: string);
  public
     { constructor Create(AOwner: TComponent); override;

     } property MsgLineLength: Word read FMsgLineLength write FMsgLineLength;
    property MsgLineFold: string read FMsgLineFold write FMsgLineFold;
  end;
PIdMessageClient=^TIdMessageClient;
function NewIdMessageClient(AOwner: {TComponent}PControl):PIdMessageClient;
type

  PIMFCoderUsage = ^TIMFCoderUsage;
  TIMFCoderUsage = record
    InUse: Boolean;
    BodyCoder: TIdCoder;
    MP: TIdMessagePart;
  end;

const
  MultiPartBoundary = '=_NextPart_2rfkindysadvnqw3nerasdf'; {do not localize}
  MultiPartAlternativeBoundary = '=_NextPart_2altrfkindysadvnqw3nerasdf';
    {do not localize}
  MultiPartRelatedBoundary = '=_NextPart_2relrfksadvnqindyw3nerasdf';
    {do not localize}

  MIMEGenericText = 'text/'; {do not localize}
  MIME7Bit = '7bit'; {do not localize}

implementation

uses
  IdComponent,
 { IdException,}
  IdGlobal,
  IdHeaderCoder,
  IdResourceStrings,
  IdTCPConnection;

function GetLongestLine(var ALine: string; ADelim: string): string;
var
  i, fnd, lineLen, delimLen: Integer;
begin
  i := 0;
  fnd := -1;
  delimLen := length(ADelim);
  lineLen := length(ALine);
  while i < lineLen do
  begin
    if ALine[i] = ADelim[1] then
    begin
      if Copy(ALine, i, delimLen) = ADelim then
      begin
        fnd := i;
      end;
    end;
    Inc(i);
  end;

  if fnd = -1 then
  begin
    result := '';
  end
  else
  begin
    result := Copy(ALine, 1, fnd - 1);
    ALine := Copy(ALine, fnd + delimLen, lineLen);
  end;
end;

//constructor TIdMessageClient.Create;
function NewIdMessageClient(AOwner: {TComponent}PControl):PIdMessageClient;
begin
//  inherited;
New( Result, Create );
with Result^ do
begin
  FMsgLineLength := 79;
  FMsgLineFold := #9;
end;  
end;

procedure TIdMessageClient.WriteFoldedLine;
var
  ins, s, line, spare: string;
  msgLen, insLen: Word;
begin
  s := ALine;

  ins := FMsgLineFold;
  insLen := length(ins);
  msgLen := FMsgLineLength;

  if length(s) > FMsgLineLength then
  begin
    spare := Copy(s, 1, msgLen);
    line := GetLongestLine(spare, ' ');
    s := spare + Copy(s, msgLen + 1, length(s));
    WriteLn(line);

    while length(s) > (msgLen - insLen) do
    begin
      spare := Copy(s, 1, (msgLen - insLen));
      line := GetLongestLine(spare, ' ');
      s := ins + spare + Copy(s, (msgLen - insLen) + 1, length(s));
      WriteLn(line);
    end;

    if Trim(s) <> '' then
    begin
      WriteLn(ins + s);
    end;
  end
  else
  begin
    WriteLn(s);
  end;

end;

procedure TIdMessageClient.ReceiveBody;
var
  s, cRet: string;
  i, cnt: Integer;
  IMFDecoder: PIMFCoderUsage;
//  SpoolToFile: TFileStream;
  fBodyCoders: TList;
//  InProcess: TStringList;
  StateIn: Integer;
  SingleIgnore: Boolean;
  AddedTo: Boolean;
  Created: Boolean;
  TempList: TIdHeaderList;
  AltBoundary: string;
  AltBoundaryBegin: Boolean;
  AltHeaders: TIdHeaderList;
const
  State_BeforeBody = 0;
  State_EndData = 1;
  State_BodyStart = 2;

  procedure ProcessNotification;
  begin
(*
    case StrToInt(Fetch(cRet, ';')) of
      CN_CODED_DATA:
        begin
          if SingleIgnore then
          begin
            SingleIgnore := False;
          end
          else
            if StateIn > State_EndData then
          begin
            if Length(cRet) > 0 then
            begin
              if IMFDecoder^.MP is TIdText then
              begin
                TIdText(IMFDecoder^.MP).Body.Add(cRet);
              end
              else
              begin
                if (Length(cRet) > 0) and Assigned(SpoolToFile) then
                begin
                  SpoolToFile.Write(cRet[1], Length(cRet));
                end;
              end;
            end;
            AddedTo := True;
          end;
        end;
      CN_IMF_BODY_START:
        begin
          StateIn := State_BodyStart;
        end;
      CN_IMF_BODY_PART_END:
        begin
          Created := False;
        end;
      CN_IMF_HEAD_VALUE:
        begin
          if (StateIn > State_EndData) then
          begin
            if not Created then
            begin
              if (
                (AnsiPos('name', LowerCase(cRet)) = 0) and
                (AnsiPos('text', LowerCase(cRet)) <> 0) or {do not localize}
                (AnsiPos('multipart', LowerCase(cRet)) <> 0) or {do not localize}
                (AnsiPos('message', LowerCase(cRet)) <> 0) or {do not localize}
                (AnsiPos('attachment', LowerCase(cRet)) <> 0) or
                  {do not localize}
                (LowerCase(cRet) = 'content-type:') {do not localize}
                ) then
                IMFDecoder^.MP := TIdText.Create(AMsg.MessageParts)
              else
                IMFDecoder^.MP := TIdAttachment.Create(AMsg.MessageParts);
              Created := True;
            end;
            with IMFDecoder^.MP do
            begin
              Boundary := cRet;
              BoundaryBegin := True;
              Headers.Add(cRet);
            end;
            AddedTo := True;
            SingleIgnore := True;
          end;
        end;
      CN_IMF_NEW_MULTIPART:
        begin
          SingleIgnore := True;
          AddedTo := False;
          Created := False;
        end;
      CN_IMF_END_MULTIPART:
        begin
          IMFDecoder^.MP.BoundaryEnd := True;
          SingleIgnore := True;
          AddedTo := True;
        end;
      CN_IMF_DATA_END:
        begin
          StateIn := State_EndData;
        end;
      CN_IMF_NEW_FILENAME:
        begin
          if IMFDecoder^.MP is TidText then
          begin
            AltBoundary := IMFDecoder^.MP.Boundary;
            AltBoundaryBegin := IMFDecoder^.MP.BoundaryBegin;
            AltHeaders := TIdHeaderList.Create;
            try
              AltHeaders.Assign(IMFDecoder^.MP.Headers);
              IMFDecoder^.MP.Free;
              IMFDecoder^.MP := TIdAttachment.Create(AMsg.MessageParts);
              with IMFDecoder^.MP do
              begin
                Boundary := AltBoundary;
                BoundaryBegin := AltBoundaryBegin;
                Headers.Assign(AltHeaders);
              end;
            finally
              AltHeaders.Free;
            end;
          end;

          TIdAttachment(IMFDecoder^.MP).FileName := DecodeHeader(cRet);
          if Length(IMFDecoder^.MP.StoredPathname) = 0 then
          begin
            IMFDecoder^.MP.StoredPathname := MakeTempFilename;
            if Assigned(SpoolToFile) then
            begin
              SpoolToFile.Free;
            end;
            SpoolToFile := TFileStream.Create(IMFDecoder^.MP.StoredPathname,
              fmCreate);
          end;
          AddedTo := True;
        end;
    end;

    cRet := IMFDecoder^.BodyCoder.GetNotification;*)
  end;

begin
(*  if AMsg.NoDecode then
  begin
    Capture(AMsg.Body, '.');
    Exit;
  end;

  SpoolToFile := nil;
  StateIn := State_BeforeBody;
  AddedTo := False;
  Created := False;

  AMsg.MessageParts.Clear;

  fBodyCoders := TList.Create;
  try

    InProcess := TStringList.Create;
    TempList := AMsg.GenerateHeader;
    try
      InProcess.AddStrings(TempList);
      if InProcess.Count <> 0 then
      begin
        for i := 0 to fBodyCoders.Count - 1 do
        begin
          IMFDecoder := fBodyCoders[i];
          with IMFDecoder^.BodyCoder do
          begin
            IgnoreCodedData := True;
            IgnoreNotification := True;
            cnt := 0;
            while cnt < InProcess.Count do
            begin
              CodeString(InProcess[cnt] + CR + LF);
              Inc(cnt);
            end;
            IgnoreCodedData := False;
            IgnoreNotification := False;
          end;
        end;
      end;
    finally
      InProcess.Free;
      TempList.Free;
    end;

    New(IMFDecoder);
    with IMFDecoder^ do
    begin
      InUse := True;
      BodyCoder := TIdIMFDecoder.Create(Self);
      MP := TIdText.Create(AMsg.MessageParts);
      TIdText(MP).Body.Clear;
    end;
    FBodyCoders.Add(IMFDecoder);

    IMFDecoder^.BodyCoder.CodeString('Content-Type: ' + AMsg.ContentType + EOL);
      {do not localize}
    IMFDecoder^.BodyCoder.CodeString('Content-Transfer-Encoding: ' +
      {do not localize}
      AMsg.ContentTransferEncoding + EOL);

    IMFDecoder^.BodyCoder.CodeString(EOL);

    BeginWork(wmRead);
    try
      repeat
        s := ReadLn;
        if s = '.' then
        begin
          Break;
        end;

        if IMFDecoder^.InUse then
        begin
          cRet := IMFDecoder^.BodyCoder.CodeString(s + EOL);
          while Length(cRet) > 0 do
          begin
            ProcessNotification;
          end;
        end;
      until False;
    finally EndWork(wmRead);
    end;

    with IMFDecoder^ do
    begin
      if InUse then
      begin

        cRet := BodyCoder.CompletedInput;
        while cRet <> '' do
        begin
          ProcessNotification;
        end;

      end;
    end;
    if Assigned(SpoolToFile) then
    begin
      SpoolToFile.Free;
    end;

  finally
    i := 0;
    while i < fBodyCoders.Count - 1 do
    begin
      IMFDecoder := fBodyCoders.Items[1];
      IMFDecoder^.BodyCoder.Free;
    end;
    Dispose(IMFDecoder);
    fBodyCoders.Free;
  end;
  *)
end;

procedure TIdMessageClient.SendHeader;
var
  i: Integer;
  Headers: TIdHeaderList;
begin
  RelCount := 0;
  AttCount := 0;
  TextCount := 0;
(*  for i := 0 to AMsg.MessageParts.Count - 1 do
  begin
    if AMsg.MessageParts.Items[i] is TIdText then
      inc(TextCount)
    else
    begin
      if AMsg.MessageParts.Items[i] is TIdAttachment then
      begin
        if Length(AMsg.MessageParts.Items[i].ExtraHeaders.Values['Content-ID'])
          > 0 then {do not localize}
          inc(RelCount);
        inc(AttCount);
      end;
    end;
  end;
  if RelCount > 0 then
  begin
    AMsg.ContentType :=
      'multipart/related; type="multipart/alternative"; boundary="' + {do not localize}
      MultiPartRelatedBoundary + '"';
  end
  else
  begin
    if AttCount > 0 then
    begin
      AMsg.ContentType := 'multipart/mixed; boundary="' + MultiPartBoundary +
        '"'; {do not localize}
    end
    else
    begin
      if TextCount > 0 then
      begin
        AMsg.ContentType := 'multipart/alternative; boundary="' +
          {do not localize}
          MultiPartBoundary + '"';
      end;
    end;
  end;
  if Length(AMsg.ContentType) = 0 then
    AMsg.ContentType := AMsg.CharSet
  else
    AMsg.ContentType := AMsg.ContentType + ';' + AMsg.CharSet;
  Headers := AMsg.GenerateHeader;
  try
    WriteStrings(Headers);
  finally
    Headers.Free;
  end;*)
end;

procedure TIdMessageClient.SendBody(AMsg: pIdMEssage; const Attcount, Textcount,
  RelCount: integer);

var
  i: Integer;
  MimeCharset: string;
  HeaderEncoding: Char; { B | Q }
  TransferEncoding: TTransfer;
  Boundary: string;

  procedure EncodeAndWriteText(ATextPart: TIdText);
  var
    i: Integer;
    CItem: TIdCoderItem;
    sCT, sCTE: string;
    BodyCoder: TIdCoder;
    Data: string;

  begin

    if Length(ATextPart.ContentType) = 0 then
      ATextPart.ContentType := 'text/plain'; {do not localize}
    if Length(ATextPart.ContentTransfer) = 0 then
      ATextPart.ContentTransfer := 'quoted-printable'; {do not localize}

    sCT := ATextPart.ContentType;
    sCTE := ATextPart.ContentTransfer;

    CItem := CoderCollective.GetCoderType(sCT, sCTE, CT_CREATION);

//    BodyCoder := CItem.IdCoderClass.Create(nil);
    BodyCoder.IgnoreNotification := True;

    WriteLn('Content-Type: ' + ATextPart.ContentType); {do not localize}
    WriteLn('Content-Transfer-Encoding: ' + ATextPart.ContentTransfer);
      {do not localize}
//    WriteStrings(ATextPart.ExtraHeaders);
    WriteLn('');
    try
      for i := 0 to ATextPart.Body.Count - 1 do
      begin
{        if Copy(ATextPart.Body[i], 1, 1) = '.' then
        begin
          ATextPart.Body[i] := '.' + ATextPart.Body[i];
        end;}
//        BodyCoder.CodeString(ATextPart.Body[i] + EOL);
        Data := BodyCoder.CompletedInput;
        Fetch(Data, ';');
        if TransferEncoding = iso2022jp then
          Write(Encode2022JP(Data))
        else
          Write(Data);
      end;
      WriteLn('');
    finally
      BodyCoder.Free;
    end;
  end;

  procedure EncodeAndWriteAttachment(AAttachment: TIdAttachment);
  const
    DefaultLineSize = 57;
  var
//    TFS: TFileStream;
//    TFSTemp: TFileStream;

    StreamRead: Integer;
    BytesRead: Integer;
    CItem: TIdCoderItem;
    sCT, sCTE: string;
    StreamBuffer: string;
    Data: string;
    BodyCoder: TIdCoder;
  begin
    SetLength(StreamBuffer, DefaultLineSize);

    if Length(AAttachment.ContentTransfer) = 0 then
      AAttachment.ContentTransfer := 'base64'; {do not localize}
    if Length(AAttachment.ContentDisposition) = 0 then
      AAttachment.ContentDisposition := 'attachment'; {do not localize}

    sCT := AAttachment.ContentType;
    sCTE := AAttachment.ContentTransfer;
    CItem := CoderCollective.GetCoderType(sCT, sCTE, CT_CREATION);

    if (AAttachment.ContentTransfer = 'base64') and {do not localize}
      (length(AAttachment.ContentType) = 0) then
    begin
      AAttachment.ContentType := 'application/octet-stream'; {do not localize}
    end;

//    BodyCoder := CItem.IdCoderClass.Create(nil);
    BodyCoder.IgnoreNotification := True;
    BodyCoder.AddCRLF := True;

//    TFS := TFileStream.Create(AAttachment.FileName, fmShareDenyNone);

    AAttachment.Storedpathname := MakeTempFilename;
//    TFSTemp := TFileStream.Create(AAttachment.Storedpathname, fmCreate);
    BytesRead := 0;
    try
//      while BytesRead < TFS.Size do
      begin
{        if TFS.Size - BytesRead > DefaultLineSize then
          StreamRead := DefaultLineSize
        else
          StreamRead := TFS.Size - BytesRead;}
        BytesRead := BytesRead + StreamRead;
//        TFS.ReadBuffer(StreamBuffer[1], StreamRead);
        BodyCoder.CodeString(Copy(StreamBuffer, 1, StreamRead));
        Data := BodyCoder.CompletedInput;
        Fetch(Data, ';');
//        TFSTemp.Write(Data[1], Length(Data));
      end;

      WriteLn('Content-Type: ' + AAttachment.ContentType + ';');
        {do not localize}
      WriteLn('        name="' + ExtractFileName(AAttachment.FileName) + '"');
        {do not localize}
      WriteLn('Content-Transfer-Encoding: ' + AAttachment.ContentTransfer);
        {do not localize}
      WriteLn('Content-Disposition: ' + AAttachment.ContentDisposition + ';');
        {do not localize}
      WriteLn('        filename="' + ExtractFileName(AAttachment.FileName) +
        '"'); {do not localize}
//      WriteStrings(AAttachment.ExtraHeaders);
      WriteLn('');
//      TFSTemp.Position := 0;
//      WriteStream(TFSTemp, True, False);
      WriteLn('');
    finally
//      TFS.Free;
//      TFSTemp.Free;
      DeleteFile(PChar(AAttachment.StoredPathName));
      BodyCoder.Free;
    end;
  end;

begin

  InitializeMime(TransferEncoding, HeaderEncoding, MimeCharSet);

  BeginWork(wmWrite);
  if AttCount > 0 then
  begin
    WriteLn('This is a multi-part message in MIME format'); {do not localize}
    WriteLn('');
    if RelCount > 0 then
      Boundary := MultiPartRelatedBoundary
    else
      Boundary := MultiPartBoundary;
    WriteLn('--' + Boundary);
    if TextCount > 1 then
    begin
      WriteLn('Content-Type: multipart/alternative; '); {do not localize}
      WriteLn('        boundary="' + MultiPartAlternativeBoundary + '"');
        {do not localize}
      WriteLn('');
      for i := 0 to AMsg.MessageParts.Count - 1 do
      begin
{        if AMsg.MessageParts.Items[i] is TIdText then
        begin
          WriteLn('--' + MultiPartAlternativeBoundary);
          DoStatus(hsText, [RSMsgClientEncodingText]);
          EncodeAndWriteText(AMsg.MessageParts.Items[i] as TIdText);
        end;}
      end;
      WriteLn('--' + MultiPartAlternativeBoundary + '--');
    end
    else
    begin
      WriteLn('Content-Type: text/plain'); {do not localize}
      WriteLn('Content-Transfer-Encoding: 7bit'); {do not localize}
      WriteLn('');
      WriteStrings(AMsg.Body);
    end;
    for i := 0 to AMsg.MessageParts.Count - 1 do
    begin
{      if AMsg.MessageParts.Items[i] is TIdAttachment then
      begin
        WriteLn('');
        WriteLn('--' + Boundary);
        DoStatus(hsText, [RSMsgClientEncodingAttachment]);
        EncodeAndWriteAttachment(AMsg.MessageParts.Items[i] as TIdAttachment);
      end;}
    end;
    WriteLn('--' + Boundary + '--');
  end
  else
  begin
    if TextCount > 1 then
    begin
      WriteLn('This is a multi-part message in MIME format'); {do not localize}
      WriteLn('');
      for i := 0 to AMsg.MessageParts.Count - 1 do
      begin
{        if AMsg.MessageParts.Items[i] is TIdText then
        begin
          WriteLn('--' + MultiPartBoundary);
          DoStatus(hsText, [RSMsgClientEncodingText]);
          EncodeAndWriteText(AMsg.MessageParts.Items[i] as TIdText);
        end;}
      end;
      WriteLn('--' + MultiPartBoundary + '--');
    end
    else
    begin
      DoStatus(hsText, [RSMsgClientEncodingText]);
      if TransferEncoding = iso2022jp then
      begin
        for i := 0 to AMsg.Body.Count - 1 do
        begin
{          if Copy(AMsg.Body[i], 1, 1) = '.' then
          begin
            AMsg.Body.Strings[i] := '.' + AMsg.Body.Strings[i];
          end;}
//          WriteLn(Encode2022JP(Amsg.Body.Strings[i]))
        end
      end
      else
        for i := 0 to AMsg.Body.Count - 1 do
        begin
{          if Copy(AMsg.Body[i], 1, 1) = '.' then
          begin
            AMsg.Body.Strings[i] := '.' + AMsg.Body.Strings[i];
          end;}
//          WriteLn(AMsg.Body.Strings[i]);
        end;
    end;
  end;
  EndWork(wmWrite);
end;

procedure TIdMessageClient.SendMsg;
var
  AttCount, TextCount, RelCount: Integer;
begin
  SendHeader(AMsg, AttCount, TextCount, RelCount);
//  if TextCount = 1 then
//    raise EIdTextInvalidCount.Create(RSTIdTextInvalidCount);
  WriteLn('');
  SendBody(AMsg, AttCount, TextCount, RelCount);
end;

procedure TIdMessageClient.ReceiveMsg;
begin
  ReceiveHeader(AMsg, ' ');
  ReceiveBody(AMsg);
end;

procedure TIdMessageClient.ReceiveHeader(AMsg: pIdMessage;
  const ADelim: string);
begin
  Capture(AMsg.Headers, ADelim, True);
  AMsg.GetHeader;
end;

end.
