{==============================================================================|
| Project : Delphree - Synapse                                   | 001.005.000 |
|==============================================================================|
| Content: MIME message object                                                 |
|==============================================================================|
| The contents of this file are Subject to the Mozilla Public License Ver. 1.1 |
| (the "License"); you may not use this file except in compliance with the     |
| License. You may obtain a copy of the License at http://www.mozilla.org/MPL/ |
|                                                                              |
| Software distributed under the License is distributed on an "AS IS" basis,   |
| WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for |
| the specific language governing rights and limitations under the License.    |
|==============================================================================|
| The Original Code is Synapse Delphi Library.                                 |
|==============================================================================|
| The Initial Developer of the Original Code is Lukas Gebauer (Czech Republic).|
| Portions created by Lukas Gebauer are Copyright (c)2000,2001.                |
| All Rights Reserved.                                                         |
|==============================================================================|
| Contributor(s):                                                              |
|==============================================================================|
| History: see HISTORY.HTM From distribution package                           |
|          (Found at URL: http://www.ararat.cz/synapse/)                       |
|==============================================================================}

{$WEAKPACKAGEUNIT ON}

unit MIMEmess;

interface

uses
  KOL,
  MIMEpart, SynaChar, SynaUtil, MIMEinLn;

type
	PMessHeader = ^TMessHeader;
	TMessHeader = object(TObj)
	private
		FFrom: string;
		FToList: PStrList;
		FSubject: string;
		FOrganization: string;
		FCustomHeaders: PStrList;
	public
		destructor Destroy; virtual;
		procedure Clear;
		procedure EncodeHeaders(Value: PStrList);
		procedure DecodeHeaders(Value: PStrList);
		property From: string read FFrom Write FFrom;
		property ToList: PStrList read FToList;
		property Subject: string read FSubject Write FSubject;
		property Organization: string read FOrganization Write FOrganization;
		property CustomHeaders: PStrList read FCustomHeaders;
	end;

	PMimeMess = ^TMimeMess;
	TMimeMess = object(TObj)
	private
		FPartList: PList;
		FLines: PStrList;
		FHeader: PMessHeader;
		FMultipartType: string;
	public
		destructor Destroy; virtual;
		procedure Clear;
		function AddPart: Integer;
		procedure AddPartText(Value: PStrList);
		procedure AddPartHTML(Value: PStrList);
		procedure AddPartHTMLBinary(Value, Cid: string);
		procedure AddPartBinary(Value: string);
		procedure EncodeMessage;
		procedure FinalizeHeaders;
		procedure ParseHeaders;
		procedure DecodeMessage;
		property PartList: PList read FPartList;
		property Lines: PStrList read FLines;
		property Header: PMessHeader read FHeader;
		property MultipartType: string read FMultipartType Write FMultipartType;
	end;


function NewMessHeader : PMessHeader;

function NewMimeMess : PMimeMess;

implementation

{==============================================================================}


function NewMessHeader : PMessHeader;
begin
    New(Result,Create);
	Result.FToList := NewStrList;//TStringList.Create;
	Result.FCustomHeaders := NewStrList;//TStringList.Create;
end;



destructor TMessHeader.Destroy;
begin
  FCustomHeaders.Free;
  FToList.Free;
  inherited Destroy;
end;

{==============================================================================}

procedure TMessHeader.Clear;
begin
  FFrom := '';
  FToList.Clear;
  FSubject := '';
  FOrganization := '';
  FCustomHeaders.Clear;
end;

procedure TMessHeader.EncodeHeaders(Value: PStrList);
var
  n: Integer;
begin
  for n := FCustomHeaders.Count - 1 downto 0 do
    if FCustomHeaders.Items[n] <> '' then
      Value.Insert(0, FCustomHeaders.Items[n]);
  Value.Insert(0, 'x-mailer: Synapse - Delphi TCP/IP library by Lukas Gebauer');
  Value.Insert(0, 'MIME-Version: 1.0 (produced by Synapse)');
  Value.Insert(0, 'date: ' + Rfc822DateTime(Now));
  if FOrganization <> '' then
    Value.Insert(0, 'Organization: ' + InlineCode(FOrganization));
  if FSubject <> '' then
    Value.Insert(0, 'Subject: ' + InlineCode(FSubject));
  for n := 0 to FToList.Count - 1 do
    Value.Insert(0, 'To: ' + InlineEmail(FToList.Items[n]));
  Value.Insert(0, 'From: ' + InlineEmail(FFrom));
end;

procedure TMessHeader.DecodeHeaders(Value: PStrList);
var
  s: string;
  x: Integer;
  cp: TMimeChar;
begin
  cp := GetCurCP;
  Clear;
  x := 0;
  while Value.Count > x do
  begin
    s := NormalizeHeader(Value, x);
    if s = '' then
      Break;
    if Pos('FROM:', UpperCase(s)) = 1 then
    begin
      FFrom := InlineDecode(SeparateRight(s, ':'), cp);
      continue;
    end;
    if Pos('SUBJECT:', UpperCase(s)) = 1 then
    begin
      FSubject := InlineDecode(SeparateRight(s, ':'), cp);
      continue;
    end;
    if Pos('ORGANIZATION:', UpperCase(s)) = 1 then
    begin
      FOrganization := InlineDecode(SeparateRight(s, ':'), cp);
      continue;
    end;
    if Pos('TO:', UpperCase(s)) = 1 then
    begin
      FToList.Add(InlineDecode(SeparateRight(s, ':'), cp));
      continue;
    end;
    FCustomHeaders.Add(s);
  end;
end;

{==============================================================================}

function NewMimeMess : PMimeMess;
begin
  New(Result,Create);
  Result.FPartList := NewList;//TList.Create;
  Result.FLines := NewStrList;//TStringList.Create;
  Result.FHeader := NewMessHeader;//TMessHeader.Create;
  Result.FMultipartType := 'Mixed';
end;

destructor TMimeMess.Destroy;
begin
  FHeader.Free;
  Lines.Free;
  PartList.Free;
  inherited Destroy;
end;

{==============================================================================}

procedure TMimeMess.Clear;
var
  n: Integer;
begin
  FMultipartType := 'Mixed';
  Lines.Clear;
  for n := 0 to FPartList.Count - 1 do
    PMimePart(FPartList.Items[n]).Free;
  FPartList.Clear;
  FHeader.Clear;
end;

{==============================================================================}

function TMimeMess.AddPart: Integer;
var
 Part : PMimePart;
begin
  Part := NewMimePart;
  FPartList.Add(Part);//  Result := FPartList.Add(TMimePart.Create);
  Result := FPartList.Count -1;
end;

{==============================================================================}

procedure TMimeMess.AddPartText(Value: PStrList);
begin
  with PMimePart(FPartList.Items[AddPart])^ do
  begin
    Value.SaveToStream(DecodedLines);
    Primary := 'text';
    Secondary := 'plain';
    Description := 'Message text';
    Disposition := 'inline';
    CharsetCode := IdealCharsetCoding(Value.Text, TargetCharset,
      [ISO_8859_1, ISO_8859_2, ISO_8859_3, ISO_8859_4, ISO_8859_5,
      ISO_8859_6, ISO_8859_7, ISO_8859_8, ISO_8859_9, ISO_8859_10]);
    EncodingCode := ME_QUOTED_PRINTABLE;
    EncodePart;
  end;
end;

{==============================================================================}

procedure TMimeMess.AddPartHTML(Value: PStrList);
begin
  with PMimePart(FPartList.Items[AddPart])^ do
  begin
    Value.SaveToStream(DecodedLines);
    Primary := 'text';
    Secondary := 'html';
    Description := 'HTML text';
    Disposition := 'inline';
    CharsetCode := UTF_8;
    EncodingCode := ME_QUOTED_PRINTABLE;
    EncodePart;
  end;
end;

{==============================================================================}

procedure TMimeMess.AddPartBinary(Value: string);
var
  s: string;
  Part : PMimePart;
begin
  Part := PMimePart(FPartList.Items[AddPart]);
  with Part^ do
  begin
    DecodedLines.LoadFromFile(Value);
    s := ExtractFileName(Value);
    MimeTypeFromExt(s);
    Description := 'Attached file: ' + s;
    Disposition := 'attachment';
    FileName := s;
    EncodingCode := ME_BASE64;
    EncodePart;
  end;
end;

procedure TMimeMess.AddPartHTMLBinary(Value, Cid: string);
var
  s: string;
begin
  with PMimePart(FPartList[AddPart])^ do
  begin
    DecodedLines.LoadFromFile(Value);
    s := ExtractFileName(Value);
    MimeTypeFromExt(s);
    Description := 'Included file: ' + s;
    Disposition := 'inline';
    ContentID := Cid;
    FileName := s;
    EncodingCode := ME_BASE64;
    EncodePart;
  end;
end;

{==============================================================================}

procedure TMimeMess.EncodeMessage;
var
  bound: string;
  n: Integer;
  Part : NewMimePart;
begin
  FLines.Clear;
  if FPartList.Count = 1 then
    FLines.Assign(PMimePart(FPartList[0])^.Lines)
  else
  begin
    bound := GenerateBoundary;
    for n := 0 to FPartList.Count - 1 do
    begin
      FLines.Add('--' + bound);
      FLines.AddStrings(PMimePart(FPartList[n])^.Lines);
    end;
    FLines.Add('--' + bound + '--');
    Part := NewMimePart;
    with Part^ do
    try
      @Self.FLines.SaveToStream(DecodedLines);
      Primary := 'Multipart';
      Secondary := FMultipartType;
      Description := 'Multipart message';
      Boundary := bound;
      EncodePart;
      @Self.FLines.Assign(Lines);
    finally
      Free;
    end;
  end;
end;

{==============================================================================}

procedure TMimeMess.FinalizeHeaders;
begin
  FHeader.EncodeHeaders(FLines);
end;

{==============================================================================}

procedure TMimeMess.ParseHeaders;
begin
  FHeader.DecodeHeaders(FLines);
end;

{==============================================================================}

procedure TMimeMess.DecodeMessage;
var
  l: PStrList;
  m: PMimePart;
  i: Integer;
  bound: string;
begin
  l := NewStrList;//TStringList.Create;
  m := NewMimePart;//TMimePart.Create;
  try
    l.Assign(FLines);
    FHeader.Clear;
    ParseHeaders;
    m.ExtractPart(l, 0);
    if m.PrimaryCode = MP_MULTIPART then
    begin
      bound := m.Boundary;
      i := 0;
      repeat
        with PMimePart(PartList[AddPart])^ do
        begin
          Boundary := bound;
          i := ExtractPart(l, i);
          DecodePart;
        end;
      until i >= l.Count - 2;
    end
    else
    begin
      with PMimePart(PartList[AddPart])^ do
      begin
        ExtractPart(l, 0);
        DecodePart;
      end;
    end;
  finally
    m.Free;
    l.Free;
  end;
end;

end.
