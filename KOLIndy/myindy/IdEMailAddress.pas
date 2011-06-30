// 27-nov-2002
unit IdEMailAddress;

interface

uses KOL { , 
  Classes },KOLClasses ;

type
  PIdEMailAddressItem=^TIdEMailAddressItem;
  PIdEMailAddressList=^TIdEMailAddressList;
  TIdEMailAddressItem = object(TCollectionItem)
  protected
    FAddress: string;
    FName: string;
    function GetText: string;
    procedure SetText(AText: string);
  public
    procedure Assign(Source: PObj);// override;
   { published } 
    property Address: string read FAddress write FAddress;
    property Name: string read FName write FName;
    property Text: string read GetText write SetText;
  end;


  TIdEMailAddressList = object(TOwnedCollection)
  protected
    function GetItem(Index: Integer): pIdEMailAddressItem;
    procedure SetItem(Index: Integer; const Value: pIdEMailAddressItem);
    function GetEMailAddresses: string;
    procedure SetEMailAddresses(AList: string);
  public
     { constructor Create(AOwner: TPersistent);  }// reintroduce;

    procedure FillPStrList(AStrings: PStrList);
    function Add: TIdEMailAddressItem;
    property Items[Index: Integer]: pIdEMailAddressItem read GetItem write
      SetItem; default;
    property EMailAddresses: string read GetEMailAddresses
    write SetEMailAddresses;
  end;
//PdEMailAddressItem=^IdEMailAddressItem;
function NewdIdEMailAddressItem:PIdEMailAddressItem;
function NewdIdEMailAddressList(AOwner: PObj):PIdEMailAddressList;

implementation
uses IdGlobal;

function NewdIdEMailAddressItem:PIdEMailAddressItem;
begin
  New( Result, Create );
end;

procedure TIdEMailAddressItem.Assign(Source: PObj);
var
  Addr: PIdEMailAddressItem;
begin
{  if ClassType <> Source.ClassType then
  begin
    inherited
  end
  else}
  begin
    Addr := PIdEMailAddressItem(Source);
    Address := Addr.Address;
    Name := Addr.Name;
  end;
end;

function TIdEMailAddressItem.GetText: string;
begin
  if (Length(FName) > 0) and (UpperCase(FAddress) <> FName) then
  begin
    Result := FName + ' <' + FAddress + '>';
  end
  else
  begin
    Result := FAddress;
  end;
end;

procedure TIdEMailAddressItem.SetText(AText: string);
var
  nPos: Integer;
begin
  FAddress := '';
  FName := '';
  if Copy(AText, Length(AText), 1) = '>' then
  begin
    nPos := IndyPos('<', AText);
    if nPos > 0 then
    begin
      FAddress := Trim(Copy(AText, nPos + 1, Length(AText) - nPos - 1));
      FName := Trim(Copy(AText, 1, nPos - 1));
    end;
  end
  else
  begin
    if Copy(AText, Length(AText), 1) = ')' then
    begin
      nPos := IndyPos('(', AText);
      if nPos > 0 then
      begin
        FName := Trim(Copy(AText, nPos + 1, Length(AText) - nPos - 1));
        FAddress := Trim(Copy(AText, 1, nPos - 1));
      end;
    end
    else
    begin
      FAddress := AText;
    end;
  end;

  while Length(FName) > 1 do
  begin
    if (FName[1] = '"') and (FName[Length(FName)] = '"') then
    begin
      FName := Copy(FName, 2, Length(FName) - 2);
    end
    else
    begin
      if (FName[1] = '''') and (FName[Length(FName)] = '''') then
      begin
        FName := Copy(FName, 2, Length(FName) - 2);
      end
      else
      begin
        break;
      end;
    end;
  end;
end;

function TIdEMailAddressList.Add: TIdEMailAddressItem;
begin
//  Result := TIdEMailAddressItem(inherited Add);
end;

function NewdIdEMailAddressList(AOwner: PObj):PIdEMailAddressList;
//constructor TIdEMailAddressList.Create(AOwner: TPersistent);
begin
  New( Result, Create );
//  inherited Create(AOwner, TIdEMailAddressItem);
end;

procedure TIdEMailAddressList.FillPStrList(AStrings: PStrList);
var
  idx: Integer;
begin
  idx := 0;
  while (idx < Count) do
  begin
    AStrings.Add(GetItem(idx).Text);
    Inc(idx);
  end;
end;

function TIdEMailAddressList.GetItem(Index: Integer): pIdEMailAddressItem;
begin
//  Result := TIdEMailAddressItem(inherited Items[Index]);
end;

function TIdEMailAddressList.GetEMailAddresses: string;
var
  idx: Integer;
begin
  Result := '';
  idx := 0;
  while (idx < Count) do
  begin
    Result := Result + ', ' + GetItem(idx).Text;
    Inc(idx);
  end;

  System.Delete(Result, 1, 2);
end;

procedure TIdEMailAddressList.SetItem(Index: Integer;
  const Value: pIdEMailAddressItem);
begin
 inherited SetItem(index,Value) ;
end;

procedure TIdEMailAddressList.SetEMailAddresses(AList: string);
var
  EMail: TIdEMailAddressItem;
  iStart,
    iEnd,
    iQuote,
    iPos,
    iLength: integer;
  sTemp: string;
begin
  Clear;
  iQuote := 0;
  iPos := 1;
  iLength := Length(AList);
  while (iPos <= iLength) do
  begin
    iStart := iPos;
    iEnd := iStart;
    while (iPos <= iLength) do
    begin
      if AList[iPos] = '"' then
      begin
        inc(iQuote);
      end;
      if AList[iPos] = ',' then
      begin
        if iQuote <> 1 then
        begin
          break;
        end;
      end;
      inc(iEnd);
      inc(iPos);
    end;
    sTemp := Trim(Copy(AList, iStart, iEnd - iStart));
    if Length(sTemp) > 0 then
    begin
      EMail := Add;
      EMail.Text := TrimLeft(sTemp);
    end;
    iPos := iEnd + 1;
    iQuote := 0;
  end;
end;

end.
