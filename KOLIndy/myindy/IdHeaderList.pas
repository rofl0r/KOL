// 22-nov-2002
unit IdHeaderList;

interface

uses KOL { , 
  Classes } ;

type
  TIdHeaderList = object(TStrList)
  protected
    FNameValueSeparator: string;
    FCaseSensitive: Boolean;
    FUnfoldLines: Boolean;
    FFoldLines: Boolean;
    FFoldLinesLength: Integer;
    procedure DeleteFoldedLines(Index: Integer);
    function FoldLine(AString: string): PStrList;
    procedure FoldAndInsert(AString: string; Index: Integer);
    function GetName(Index: Integer): string;
    function GetValue(const Name: string): string;
    procedure SetValue(const Name, Value: string);
    function GetValueFromLine(ALine: Integer): string;
    function GetNameFromLine(ALine: Integer): string;
  public
     { constructor Create;
     }
     procedure Init; virtual;
     procedure Extract(const AName: string; ADest: PStrList);
    function IndexOfName(const Name: string): Integer; reintroduce;
    property Names[Index: Integer]: string read GetName;
    property Values[const Name: string]: string read GetValue write SetValue;
    property NameValueSeparator: string read FNameValueSeparator
    write FNameValueSeparator;
    property CaseSensitive: Boolean read FCaseSensitive write FCaseSensitive;
    property UnfoldLines: Boolean read FUnfoldLines write FUnfoldLines;
    property FoldLines: Boolean read FFoldLines write FFoldLines;
    property FoldLength: Integer read FFoldLinesLength write FFoldLinesLength;
  end;
PIdHeaderList=^TIdHeaderList;
function NewIdHeaderList:PIdHeaderList;

implementation

uses
  IdGlobal,IndyProcs;

const
  LWS = [#9, ' '];

function FoldWrapText(const Line, BreakStr: string; BreakChars: TSysCharSet;
  MaxCol: Integer): string;
const
  QuoteChars = ['"'];
var
  Col, Pos: Integer;
  LinePos, LineLen: Integer;
  BreakLen, BreakPos: Integer;
  QuoteChar, CurChar: Char;
  ExistingBreak: Boolean;
begin
  Col := 1;
  Pos := 1;
  LinePos := 1;
  BreakPos := 0;
  QuoteChar := ' ';
  ExistingBreak := False;
  LineLen := Length(Line);
  BreakLen := Length(BreakStr);
  Result := '';
  while Pos <= LineLen do
  begin
    CurChar := Line[Pos];
      if CurChar = BreakStr[1] then
    begin
      if QuoteChar = ' ' then
      begin
        ExistingBreak := AnsiSameText(BreakStr, Copy(Line, Pos, BreakLen));
        if ExistingBreak then
        begin
          Inc(Pos, BreakLen - 1);
          BreakPos := Pos;
        end;
      end
    end
    else
      if CurChar in BreakChars then
    begin
      if QuoteChar = ' ' then
        BreakPos := Pos
    end
    else
      if CurChar in QuoteChars then
      if CurChar = QuoteChar then
        QuoteChar := ' '
      else
        if QuoteChar = ' ' then
        QuoteChar := CurChar;
    Inc(Pos);
    Inc(Col);
    if not (QuoteChar in QuoteChars) and (ExistingBreak or
      ((Col > MaxCol) and (BreakPos > LinePos))) then
    begin
      Col := Pos - BreakPos;
      Result := Result + Copy(Line, LinePos, BreakPos - LinePos + 1);
      if not (CurChar in QuoteChars) then
        while (Pos <= LineLen) and (Line[Pos] in BreakChars + [#13, #10]) do
          Inc(Pos);
      if not ExistingBreak and (Pos < LineLen) then
        Result := Result + BreakStr;
      Inc(BreakPos);
      LinePos := BreakPos;
      ExistingBreak := False;
    end;
  end;
  Result := Result + Copy(Line, LinePos, MaxInt);
end;


function NewIdHeaderList:PIdHeaderList;
//constructor TIdHeaderList.Create;
begin
  New( Result, Create );
  Result.Init;
{  with Result^ do
  begin
//  inherited Create;
  FNameValueSeparator := ': ';
  FCaseSensitive := False;
  FUnfoldLines := True;
  FFoldLines := True;
  FFoldLinesLength := 78;
  end;}
end;

procedure TIdHeaderList.Init;
begin
//with Result^ do
  begin
  inherited;// Create;
  FNameValueSeparator := ': ';
  FCaseSensitive := False;
  FUnfoldLines := True;
  FFoldLines := True;
  FFoldLinesLength := 78;
  end;
end;

procedure TIdHeaderList.DeleteFoldedLines(Index: Integer);
begin
  Inc(Index);
  while (Index < Count) and ((Length(Get(Index)) > 0) and
    (Get(Index)[1] = ' ') or (Get(Index)[1] = #9)) do
  begin
    Delete(Index);
  end;
end;

procedure TIdHeaderList.Extract(const AName: string; ADest: PStrList);
var
  idx: Integer;
begin
  if not Assigned(ADest) then
    Exit;
  for idx := 0 to Count - 1 do
  begin
    if AnsiSameText(AName, GetNameFromLine(idx)) then
    begin
      ADest.Add(GetValueFromLine(idx));
    end;
  end;
end;

procedure TIdHeaderList.FoldAndInsert(AString: string; Index: Integer);
var
  strs: PStrList;
  idx: Integer;
begin
  strs := FoldLine(AString);
  try
    idx := strs.Count - 1;
    Put(Index, strs.Items[idx]);
    Dec(idx);
    while (idx > -1) do
    begin
      Insert(Index, strs.Items[idx]);
      Dec(idx);
    end;
  finally
    FreeAndNil(strs);
  end;
end;

function TIdHeaderList.FoldLine(AString: string): PStrList;
var
  s: string;
begin
  Result := NewStrList;//PStrList.Create;
  try
    s := FoldWrapText(AString, EOL + ' ', LWS, FFoldLinesLength);
    while s <> '' do
    begin
      Result.Add(TrimRight(Fetch(s, EOL)));
    end;
  finally
  end;
end;

function TIdHeaderList.GetName(Index: Integer): string;
var
  P: Integer;
begin
  Result := Get(Index);
  P := IndyPos(FNameValueSeparator, Result);
  if P <> 0 then
  begin
    SetLength(Result, P - 1);
  end
  else
  begin
    SetLength(Result, 0);
  end;
  Result := Result;
end;

function TIdHeaderList.GetNameFromLine(ALine: Integer): string;
var
  p: Integer;
begin
  Result := Get(ALine);
  if not FCaseSensitive then
  begin
    Result := UpperCase(Result);
  end;
  P := IndyPos(TrimRight(FNameValueSeparator), Result);
  Result := Copy(Result, 1, P - 1);
end;

function TIdHeaderList.GetValue(const Name: string): string;
begin
  Result := GetValueFromLine(IndexOfName(Name));
end;

function TIdHeaderList.GetValueFromLine(ALine: Integer): string;
var
  Name: string;
begin
  if ALine >= 0 then
  begin
    Name := GetNameFromLine(ALine);
    Result := Copy(Get(ALine), Length(Name) + 2, MaxInt);
    if FUnfoldLines then
    begin
      Inc(ALine);
      while (ALine < Count) and ((Length(Get(ALine)) > 0) and
        (Get(ALine)[1] in LWS)) do
      begin
        if (Result[Length(Result)] in LWS) then
        begin
          Result := Result + TrimLeft(Get(ALine))
        end
        else
        begin
          Result := Result + ' ' + TrimLeft(Get(ALine))
        end;
        inc(ALine);
      end;
    end;
  end
  else
  begin
    Result := '';
  end;
  Result := TrimLeft(Result);
end;

function TIdHeaderList.IndexOfName(const Name: string): Integer;
var
  S: string;
begin
  for Result := 0 to Count - 1 do
  begin
    S := GetNameFromLine(Result);
    if (AnsiSameText(S, Name)) then
    begin
      Exit;
    end;
  end;
  Result := -1;
end;

procedure TIdHeaderList.SetValue(const Name, Value: string);
var
  I: Integer;
begin
  I := IndexOfName(Name);
  if Value <> '' then
  begin
    if I < 0 then
    begin
      I := Add('');
    end;
    if FFoldLines then
    begin
      DeleteFoldedLines(I);
      FoldAndInsert(Name + FNameValueSeparator + Value, I);
    end
    else
    begin
      Put(I, Name + FNameValueSeparator + Value);
    end;
  end
  else
  begin
    if I >= 0 then
    begin
      if FFoldLines then
      begin
        DeleteFoldedLines(I);
      end;
      Delete(I);
    end;
  end;
end;

end.
