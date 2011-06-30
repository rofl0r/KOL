{-----------------------------------------------------------------------------
 Unit Name: KOLXmlObjects
 Author:    Unknown (Possibly Delphi Magazine?), adapted by Thaddy

 Remarks:   The filedate stamp of the original files date from 1999
            The original code and the objectmodel are very elegant.
            It really does hide most complexity from the user.
            If you know who wrote the original, i'd like to know
            so I can give her or him credits.
            There were  NO copyright claims in the code.
            Still, I had to adapt it a lot to get it to work with KOL
            I also added all comments and explanation

 Purpose:   Simple XML Objects for use with KOL
            Far lighter than using the VCL and still powerfull!
            See the enclosed example.  Explains itself.


 History:   Translated March 6, 2003, tdk.
            Reworked July 2, 2003, tdk.
-----------------------------------------------------------------------------}


unit KOLXmlObjects;

interface
//
// Remove dot if you want to use Err.pas
// Slightly more robust, but about 8 K Fatter
{.$DEFINE USE_ERR}
uses KOL{$IFDEF USE_ERR},Err{$ENDIF};

type
  TXmlNodeType = (xntDocument, xntElement, xntText,
      xntComment, xntCDATASection);

const
  XmlNodeNames: array[xntDocument..xntCDATASection] of String =
      ('#document', '', '#text', '#comment', '#cdata-section');

type
{$IFDEF USE_ERR}
  EXmlDError = Exception;
{$ENDIF}
  TXmlName = String;

  //Object pointers
  pXmlDDocument=^TXmlDDocument;
  pXmlDStructureNode=^TXmlDStructureNode;
  pXmlDElement=^TXmlDElement;
  pXmlDCDATASection=^TXmlDCDATASection;
  pXmlDComment=^TXmlDComment;
  pXmlDtext=^TXmlDText;
  pXmlDAttrList=^TXmlDAttrList;
  pXmlDNode =^TXmlDNode;

//****************************************************
// Abstract Base Object for both Structure and Content
//****************************************************

  //Base class
  TXmlDNode = object(Tobj)
    private
      FPreviousSibling: pXmlDNode;
      FNextSibling:     pXmlDNode;
      FParentNode:      pXmlDStructureNode;
      FNodeType:        TXmlNodeType;
    protected
      function GetFirstChild: pXmlDNode; virtual;
      function GetLastChild: pXmlDNode; virtual;
      function GetOwnerDocument: pXmlDDocument;
      function GetNodeName: TXmlName; virtual;
      function GetNodeValue: String; virtual;
      procedure SetNodeName(const Value: TXmlName); virtual;
      procedure SetNodeValue(const Value: String); virtual;
      function GetLevel: Integer;
      procedure WriteToStream(Stream: pStream;
          FormattedForPrint: Boolean); virtual;
      procedure WriteFormattedPrefix(Stream: pStream);
      procedure WriteFormattedSuffix(Stream: pStream);
    public
      function CloneNode(RecurseChildren: Boolean = False): pXmlDNode;virtual;
      procedure AppendChild(NewNode: pXmlDNode); virtual;
      function ReplaceChild(NewNode: pXmlDNode; OldNode: pXmlDNode):
          pXmlDNode; virtual;
      procedure InsertBefore(NewNode: pXmlDNode; ThisNode: pXmlDNode);
      function RemoveChild(ThisNode: pXmlDNode): pXmlDNode; virtual;
      function HasChildNodes: Boolean; virtual;
      property FirstChild: pXmlDNode read GetFirstChild;
      property LastChild: pXmlDNode read GetLastChild;
      property PreviousSibling: pXmlDNode read FPreviousSibling;
      property NextSibling: pXmlDNode read FNextSibling;
      property ParentNode: pXmlDStructureNode read FParentNode;
      property OwnerDocument: pXmlDDocument read GetOwnerDocument;
      property NodeName: TXmlName read GetNodeName write SetNodeName;
      property NodeType: TXmlNodeType read FNodeType;
      property NodeValue: String read GetNodeValue write SetNodeValue;
      property Level: Integer read GetLevel;
  end;

//*****************************************
// Derived Base class for Structure Objects
//*****************************************
  TXmlDStructureNode = object(TXmlDNode)
    private
      FFirstChild:      pXmlDNode;
      FLastChild:       pXmlDNode;
    protected
      procedure CloneChildren(FromNode: pXmlDStructureNode);
      procedure WriteChildrenToStream(Stream: pStream;
          FormattedForPrint:Boolean);
    public
      destructor Destroy; virtual;
      function GetFirstChild: pXmlDNode; virtual;
      function GetLastChild: pXmlDNode; virtual;
      procedure AppendChild(NewNode: pXmlDNode); virtual;
      function ReplaceChild(NewNode: pXmlDNode; OldNode: pXmlDNode):
          pXmlDNode; virtual;
      function RemoveChild(ThisNode: pXmlDNode): pXmlDNode;virtual;
      function HasChildNodes: Boolean; virtual;
    end;


//***************************************
// Derived Base class for Content Objects
//***************************************
  TXmlDContentNode = object(TXmlDNode)
    private
      FValue: String;
    protected
      function GetNodeValue: String; virtual;
      procedure SetNodeValue(const Value: String); virtual;
  end;

//*********************************
// Implementation Objects Structure
//*********************************

  //Document implementation
  TXmlDDocument = object(TXmlDStructureNode)
    private
      FDocumentElement: pXmlDElement;
      FDocumentTypeDefinition: String;
    protected
      procedure WriteToStream(Stream: pStream;
          FormattedForPrint: Boolean); virtual;
    public
      function CloneNode(RecurseChildren: Boolean): pXmlDNode;
          virtual;
      procedure Clear;
      procedure AppendChild(NewNode: pXmlDNode); virtual;
      function ReplaceChild(NewNode: pXmlDNode; OldNode: pXmlDNode):
          pXmlDNode; virtual;
      procedure InsertBefore(NewNode: pXmlDNode; ThisNode: pXmlDNode);
      function RemoveChild(ThisNode: pXmlDNode): pXmlDNode; virtual;
      function CreateCDATASection(const Text: String):
          pXmlDCDATASection;
      function CreateComment(const Text: String): pXmlDComment;
      function CreateElement(const TagName: TXmlName): pXmlDElement;
          overload;
      function CreateElement(const TagName: TXmlName;
          const Data: String): pXmlDElement; overload;
      function CreateElement(const TagName: TXmlName;
          const Data: String; const AttrName:TXmlName;
          const AttrValue: String): pXmlDElement; overload;
      function CreateElement(const TagName: TXmlName;
          const Data: String; const AttrNames: array of TXmlName;
          const AttrValues: array of String): pXmlDElement; overload;
      function CreateTextNode(const Text: String): pXmlDText;
      procedure SaveToStream(Stream: pStream;
          FormattedForPrint: Boolean = False);
      procedure SaveToFile(const FileName: String;
          FormattedForPrint: Boolean = False);
      property DocumentElement: pXmlDElement read FDocumentElement;
      property DocumentTypeDefinition: String
          read FDocumentTypeDefinition write FDocumentTypeDefinition;
  end;

  // Element implementation
  TXmlDElement = object(TXmlDStructureNode)
    private
      FNodeName:        TXmlName;
      FAttrList:        pXmlDAttrList;
    protected
      function GetNodeName: TXmlName; virtual;
      procedure SetNodeName(const Value: TXmlName); virtual;
      procedure WriteToStream(Stream: pStream;
          FormattedForPrint: Boolean); virtual;
    public
      destructor Destroy; virtual;
      function CloneNode(RecurseChildren: Boolean): pXmlDNode;
          virtual;
      property AttrList: pXmlDAttrList read FAttrList;
  end;

//*******************************
// Implementation Objects Content
//*******************************

  // Text content implementation
  TXmlDText = object(TXmlDContentNode)
  protected
    procedure WriteToStream(Stream: pStream;
        FormattedForPrint: Boolean); virtual;
  public
    function CloneNode(RecurseChildren: Boolean): pXmlDNode; virtual;
  end;

  // Comment implementation
  TXmlDComment = object(TXmlDContentNode)
  protected
    procedure WriteToStream(Stream: pStream;
        FormattedForPrint: Boolean); virtual;
  public
    function CloneNode(RecurseChildren: Boolean): pXmlDNode; virtual;
  end;

  // Unstructured data implementation
  TXmlDCDATASection = object(TXmlDContentNode)
  protected
    procedure WriteToStream(Stream: pStream;
        FormattedForPrint: Boolean); virtual;
  public
    function CloneNode(RecurseChildren: Boolean): pXmlDNode; virtual;
  end;

//*************************************
// Helper Object for Attribute handling
//*************************************
  TXmlDAttrList = object(TStrList)
  protected
    //  Why not in TStrlist object??
    function GetNames(Index: Integer): TXmlName;
    procedure WriteToStream(Stream: pStream);
  public
    property Names[Index: Integer]: TXmlName read GetNames;
  end;

//**********************
// Constructor functions
//**********************
function NewXmlDATTRLIST:PxMLDAttrList;
function NewXmlDText:pXmlDText;
function NewXmlDcomment:pXmlDComment;
function NewXMLDCDATASection:pXmlDCDATASection;
function NewXmlDDocument:pXmlDDocument;

implementation

{ TXmlDNode }

function TxmlDNode.CloneNode(RecurseChildren: Boolean = False): pXmlDNode;
begin
result:=nil;
end;
procedure TXmlDNode.AppendChild(NewNode: pXmlDNode);
begin
{$IFDEF USE_ERR}
  raise EXmlDError.Create(e_Custom,{$ELSE}MsgOk({$ENDIF}'AppendChild operation requested on ' +
      'invalid node type');
end;


function TXmlDNode.GetFirstChild: pXmlDNode;
begin
  Result := nil;
end;

function TXmlDNode.GetLastChild: pXmlDNode;
begin
  Result := nil;
end;

function TXmlDNode.GetLevel: Integer;
var
  aParentNode: pXmlDStructureNode;
begin
  Result := 0;
  aParentNode := FParentNode;
  while aParentNode <> nil do
  begin
    Inc(Result);
    aParentNode := aParentNode.FParentNode;
  end;
end;

function TXmlDNode.GetNodeName: TXmlName;
begin
  Result := XmlNodeNames[FNodeType];
end;

function TXmlDNode.GetNodeValue: String;
begin
  Result := '';
end;

function TXmlDNode.GetOwnerDocument: pXmlDDocument;
var
  aParentNode: pXmlDStructureNode;
begin
  aParentNode := FParentNode;
  while aParentNode <> nil do
    aParentNode := aParentNode.FParentNode;
  Result := pXmlDDocument(aParentNode);
end;

function TXmlDNode.HasChildNodes: Boolean;
begin
  Result := False;
end;

procedure TXmlDNode.InsertBefore(NewNode, ThisNode: pXmlDNode);
begin
  if ThisNode = FParentNode.FFirstChild then
    FParentNode.FFirstChild := NewNode;
  if ThisNode.FPreviousSibling <> nil then
    ThisNode.FPreviousSibling.FNextSibling := NewNode;
  NewNode.FPreviousSibling := ThisNode.FPreviousSibling;
  ThisNode.FPreviousSibling := NewNode;
  NewNode.FNextSibling := ThisNode;
end;

function TXmlDNode.RemoveChild(ThisNode: pXmlDNode): pXmlDNode;
begin
{$IFDEF USE_ERR}
  raise EXmlDError.Create(e_custom,{$ELSE}MsgOk({$ENDIF}'RemoveChild operation requested on ' +
      'invalid node type');
  result:=nil;//To satisfy compiler, really an abstract;
end;

function TXmlDNode.ReplaceChild(NewNode, OldNode: pXmlDNode): pXmlDNode;
begin
{$IFDEF USE_ERR}
  raise EXmlDError.Create(e_Custom,{$ELSE}MsgOk({$ENDIF}'ReplaceChild operation requested on ' +
      'invalid node type');
  result:=nil;//To satisfy compiler, really an abstract;
end;

procedure TXmlDNode.SetNodeName(const Value: TXmlName);
begin
// Placeholder
end;

procedure TXmlDNode.SetNodeValue(const Value: String);
begin
// Placeholder
end;

procedure TXmlDNode.WriteFormattedPrefix(Stream: pStream);
var
  S:  String;
begin
  S := StringOfChar(' ', (Level - 1) * 2);
  Stream.Write(Pointer(S)^, Length(S));
end;

procedure TXmlDNode.WriteFormattedSuffix(Stream: pStream);
const
  CRLF:  String[3] = #13#10;
begin
  Stream.Write(CRLF[1], 2);
end;

{ TXmlDStructureNode }

procedure TXmlDStructureNode.AppendChild(NewNode: pXmlDNode);
begin
  NewNode.FParentNode := @Self;
  if FFirstChild = nil then
  begin
    FFirstChild := NewNode;
    FLastChild := NewNode;
  end
  else
  begin
    FLastChild.FNextSibling := NewNode;
    NewNode.FPreviousSibling := FLastChild;
    FLastChild := NewNode;
  end;
end;

procedure TXmlDStructureNode.CloneChildren(FromNode: pXmlDStructureNode);
var
  N:  pXmlDNode;
begin
  N := FromNode.FFirstChild;
  while N <> nil do
  begin
    AppendChild(N.CloneNode(True));
    N := N.NextSibling;
  end;
end;

destructor TXmlDStructureNode.Destroy;
var
  Node: pXmlDNode;
  NextNode: pXmlDNode;
begin
  Node := FFirstChild;
  while (Node <> nil) do
  begin
    NextNode := Node.FNextSibling;
    Node.Free;
    Node := NextNode;
  end;
  inherited Destroy;
end;

function TXmlDStructureNode.GetFirstChild: pXmlDNode;
begin
  Result := FFirstChild;
end;

function TXmlDStructureNode.GetLastChild: pXmlDNode;
begin
  Result := FLastChild;
end;

function TXmlDStructureNode.HasChildNodes: Boolean;
begin
  Result := FFirstChild <> nil;
end;

function TXmlDStructureNode.RemoveChild(ThisNode: pXmlDNode): pXmlDNode;
begin
  Result := FFirstChild;
  while ((Result <> nil) and (Result <> ThisNode)) do
    Result := Result.FNextSibling;
  if Result <> nil then
  begin
    if FFirstChild = FLastChild then
    begin
      FFirstChild := nil;
      FLastChild := nil;
    end
    else if Result = FFirstChild then
    begin
      FFirstChild := FFirstChild.FNextSibling;
      FFirstChild.FPreviousSibling := nil;
    end
    else if Result = FLastChild then
    begin
      FLastChild := FLastChild.FPreviousSibling;
      FLastChild.FNextSibling := nil;
    end
    else
    begin
      Result.FPreviousSibling.FNextSibling := Result.FNextSibling;
      Result.FNextSibling.FPreviousSibling := Result.FPreviousSibling;
    end;
    Result.FNextSibling := nil;
    Result.FPreviousSibling := nil;
    Result.FParentNode := nil;
  end;
end;

function TXmlDStructureNode.ReplaceChild(NewNode,
  OldNode: pXmlDNode): pXmlDNode;
var
  NextNode: pXmlDNode;
begin
  if OldNode = FLastChild then
  begin
    Result := RemoveChild(OldNode);
    AppendChild(NewNode);
  end
  else
  begin
    NextNode := OldNode.FNextSibling;
    Result := RemoveChild(OldNode);
    InsertBefore(NewNode, NextNode);
  end;
end;

procedure TxmlDNode.WriteToStream(Stream:pStream;Formattedforprint:Boolean);
begin
//

end;
procedure TXmlDStructureNode.WriteChildrenToStream(Stream: pStream;
    FormattedForPrint: Boolean);
var
  N:  pXmlDNode;
begin
  N := FFirstChild;
  while (N <> nil) do
  begin
    N.WriteToStream(Stream, FormattedForPrint);
    N := N.FNextSibling;
  end;
end;

{ TXmlDContentNode }

function TXmlDContentNode.GetNodeValue: String;
begin
  Result := FValue;
end;

procedure TXmlDContentNode.SetNodeValue(const Value: String);
begin
  FValue := Value;
end;

{ TXmlDDocument }

procedure TXmlDDocument.AppendChild(NewNode: pXmlDNode);
begin
  if NewNode.NodeType = xntElement then
  begin
    if FDocumentElement <> nil then
{$IFDEF USE_ERR}
      raise EXmlDError.Create(e_Custom,{$ELSE}MsgOk({$ENDIF}'Second document element add attempted');
    FDocumentElement := pXmlDElement(NewNode);
  end;
  inherited AppendChild(NewNode);
end;

procedure TXmlDDocument.Clear;
var
  Node: pXmlDNode;
  NextNode: pXmlDNode;
begin
  Node := FFirstChild;
  while (Node <> nil) do
  begin
    NextNode := Node.FNextSibling;
    Node.Free;
    Node := NextNode;
  end;
  FFirstChild := nil;
  FLastChild := nil;
  FDocumentElement := nil;
end;

function NewXmlDDocument:pXmlDDocument;
begin
 New(Result,Create);
 Result.FNodeType := xntDocument;
end;

function TXmlDDocument.CloneNode(RecurseChildren: Boolean): pXmlDNode;
var
  Clone: pXmlDDocument;
begin
  Clone := NewXmlDDocument;
  if RecurseChildren then
    Clone.CloneChildren(@Self);
  Result := Clone;
end;


function NewXMLDCDATASection:pXmlDCDATASection;
begin
  New(Result,Create);
  Result.FNodeType := xntCDATASection;
end;

function TXmlDDocument.CreateCDATASection(
  const Text: String): pXmlDCDATASection;
begin
  Result := NewXmlDCDATASection;
  Result.NodeValue := Text;
end;

function NewXmlDcomment:pXmlDComment;
begin
  New(Result,Create);
  Result.FNodeType := xntComment;
end;

function TXmlDDocument.CreateComment(const Text: String): pXmlDComment;
begin
  Result := NewXmlDComment;
  Result.NodeValue := Text;
end;

function NewXmlDelement:pXmlDElement;
begin
  new(Result,Create);
  Result.FAttrList := NewXmlDAttrList;
  Result.FNodeType := xntElement;
end;

function TXmlDDocument.CreateElement(
  const TagName: TXmlName): pXmlDElement;
begin
  Result := NewXmlDElement;
  Result.NodeName := TagName;
end;

function TXmlDDocument.CreateElement(
  const TagName: TXmlName; const Data: String): pXmlDElement;
begin
  Result := NewXmlDElement;
  Result.NodeName := TagName;
  if Data <> '' then
    Result.AppendChild(OwnerDocument.CreateTextNode(Data));
end;

function TXmlDDocument.CreateElement(const TagName: TXmlName;
  const Data: String; const AttrName: TXmlName;
  const AttrValue: String): pXmlDElement;
begin
  Result := NewXmlDElement;
  Result.NodeName := TagName;
  if AttrName <> '' then
    Result.FAttrList.Values[AttrName] := AttrValue;
  if Data <> '' then
    Result.AppendChild(OwnerDocument.CreateTextNode(Data));
end;

function TXmlDDocument.CreateElement(const TagName: TXmlName;
  const Data: String; const AttrNames: array of TXmlName;
  const AttrValues: array of String): pXmlDElement;
var
  I:  Integer;
begin
  if (Low(AttrNames) <> Low(AttrValues)) or
      (High(AttrNames) <> High(AttrValues)) then
{$IFDEF USE_ERR}
    raise EXmlDError.Create(e_Custom,{$ELSE}MsgOk({$ENDIF}'Invalid CreateElement call');
  Result := NewXmlDElement;
  Result.NodeName := TagName;
  for I := Low(AttrNames) to High(AttrNames) do
    if AttrNames[I] <> '' then
      Result.FAttrList.Values[AttrNames[I]] := AttrValues[I];
  if Data <> '' then
    Result.AppendChild(OwnerDocument.CreateTextNode(Data));
end;

function NewXmlDText:pXmlDText;
begin
 New(Result,create);
 Result.FNodeType := xntText;
end;

function TXmlDDocument.CreateTextNode(const Text: String): pXmlDText;
begin
  Result := NewXmlDText;
  Result.NodeValue := Text;
end;

procedure TXmlDDocument.InsertBefore(NewNode, ThisNode: pXmlDNode);
begin
  if NewNode.NodeType = xntElement then
  begin
    if FDocumentElement <> nil then
{$IFDEF USE_ERR}
      raise EXmlDError.Create(e_Custom,{$ELSE}MsgOk({$ENDIF}'Second document element add attempted');
    FDocumentElement := pXmlDElement(NewNode);
  end;
  inherited InsertBefore(NewNode, ThisNode);
end;

function TXmlDDocument.RemoveChild(ThisNode: pXmlDNode): pXmlDNode;
begin
  if ThisNode = FDocumentElement then
    FDocumentElement := nil;
  Result := inherited RemoveChild(ThisNode);
end;

function TXmlDDocument.ReplaceChild(NewNode,
  OldNode: pXmlDNode): pXmlDNode;
begin
  if OldNode = FDocumentElement then
    FDocumentElement := nil;
  if NewNode.NodeType = xntElement then
    FDocumentElement := pXmlDElement(NewNode);
  Result := inherited ReplaceChild(NewNode, OldNode);
end;

procedure TXmlDDocument.SaveToFile(const FileName: String;
    FormattedForPrint: Boolean);
var
  Stream: pStream;
begin
  Stream := NewWriteFileStream(Filename);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TXmlDDocument.SaveToStream(Stream: pStream;
    FormattedForPrint: Boolean = False);
begin
  WriteToStream(Stream, FormattedForPrint);
end;

procedure TXmlDDocument.WriteToStream(Stream: pStream;
    FormattedForPrint: Boolean);
var
  S:  String;
begin
  S := '<?xml version="1.0"?>';
  Stream.Write(Pointer(S)^, Length(S));
  if FormattedForPrint then
    WriteFormattedSuffix(Stream);
  if FDocumentTypeDefinition <> '' then
  begin
    S := '<!DOCTYPE ';
    if DocumentElement<> nil then
      S := S + DocumentElement.NodeName + ' ';
    S := S + FDocumentTypeDefinition + '>';
    Stream.Write(Pointer(S)^, Length(S));
    if FormattedForPrint then
      WriteFormattedSuffix(Stream);
  end;
  WriteChildrenToStream(Stream, FormattedForPrint);
end;

{ TXmlDElement }

function TXmlDElement.CloneNode(RecurseChildren: Boolean): pXmlDNode;
var
  Clone:  pXmlDElement;
begin
  Clone := NewXmlDElement;
  Clone.FNodeName := FNodeName;
  Clone.FAttrList.Assign(FAttrList);
  if RecurseChildren then
    Clone.CloneChildren(@Self);
  Result := Clone;
end;

function NewXmlDATTRLIST:PxMLDAttrList;
begin
  New(Result,Create);
end;


destructor TXmlDElement.Destroy;
begin
  FAttrList.Free;
  inherited Destroy;
end;

function TXmlDElement.GetNodeName: TXmlName;
begin
  Result := FNodeName;
end;

procedure TXmlDElement.SetNodeName(const Value: TXmlName);
begin
  FNodeName := Value;
end;

procedure TXmlDElement.WriteToStream(Stream: pStream;
    FormattedForPrint: Boolean);
var
  S:  String;
  Formatted: Boolean;
begin
  Formatted := FormattedForPrint;
  if Formatted then
  begin
    if (FFirstChild <> nil) and (FFirstChild = FLastChild) and
        (FFirstChild.NodeType = xntText) and
        (Length(FFirstChild.NodeValue) < 48) then
      Formatted := False;
    WriteFormattedPrefix(Stream);
  end;
  S := '<' + FNodeName;
  Stream.Write(Pointer(S)^, Length(S));
  if FAttrList.Count > 0 then
    FAttrList.WriteToStream(Stream);
  if FFirstChild <> nil then
  begin
    S := '>';
    Stream.Write(Pointer(S)^, 1);
    if Formatted then
      WriteFormattedSuffix(Stream);
  end;
  if FFirstChild = nil then
    S := '/>'
  else
  begin
    WriteChildrenToStream(Stream, Formatted);
    if Formatted then
      WriteFormattedPrefix(Stream);
    S := '</' + FNodeName + '>';
  end;
  Stream.Write(Pointer(S)^, Length(S));
  if FormattedForPrint then
    WriteFormattedSuffix(Stream);
end;

{ TXmlDText }

function TXmlDText.CloneNode(RecurseChildren: Boolean): pXmlDNode;
begin
  Result := NewXmlDText;
  Result.NodeValue := NodeValue;
end;


procedure TXmlDText.WriteToStream(Stream: pStream;
    FormattedForPrint: Boolean);
begin
  if FormattedForPrint then
    WriteFormattedPrefix(Stream);
  Stream.Write(Pointer(FValue)^, Length(FValue));
  if FormattedForPrint then
    WriteFormattedSuffix(Stream);
end;

{ TXmlDComment }

function TXmlDComment.CloneNode(RecurseChildren: Boolean): pXmlDNode;
begin
  Result := NewXmlDComment;
  Result.NodeValue := NodeValue;
end;


procedure TXmlDComment.WriteToStream(Stream: pStream;
  FormattedForPrint: Boolean);
var
  S:  String;
begin
  if FormattedForPrint then
    WriteFormattedPrefix(Stream);
  S := '<!--' + FValue + '-->';
  Stream.Write(Pointer(S)^, Length(S));
  if FormattedForPrint then
    WriteFormattedSuffix(Stream);
end;

{ TXmlCDATASection }

function TXmlDCDATASection.CloneNode(RecurseChildren: Boolean): pXmlDNode;
begin
  Result := NewXmlDCDATASection;
  Result.NodeValue := NodeValue;
end;


procedure TXmlDCDATASection.WriteToStream(Stream: pStream;
    FormattedForPrint: Boolean);
var
  S:  String;
begin
  if FormattedForPrint then
    WriteFormattedPrefix(Stream);
  S := '<![CDATA[' + FValue + ']]>';
  Stream.Write(Pointer(S)^, Length(S));
  if FormattedForPrint then
    WriteFormattedSuffix(Stream);
end;

{ TXmlDAttrList }

function TXmlDAttrList.GetNames(Index: Integer): TXmlName;
var temp:String;
begin
  temp:=Items[Index];
  Result:=Parse(temp,'=');
end;


procedure TXmlDAttrList.WriteToStream(Stream: pStream);
var
  I:  Integer;
  J:  Integer;
  S:  String;
begin
  for I := 0 to (Count - 1) do
  begin
    S := Items[I];
    J := Pos('=', S);
    S := ' ' + Copy(S, 1, J) + '"' + Copy(S, J + 1, $7FFF) + '"';
    Stream.Write(Pointer(S)^, Length(S));
  end;
end;

end.
