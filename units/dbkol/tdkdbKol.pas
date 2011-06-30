unit tdkDbKOL;

interface
uses KOL,Windows;

{********************************************************
 *** dBase (R) File Handling for KOL                  ***
 *** (C)2001, Thaddy de Koning.                       ***
 *** This implementation: Thaddy de Koning            ***
 *** email: thaddy@thaddy.com                         ***
 ********************************************************
 *** Copyrighted freeware for Commercial              ***
 *** and Non-commercial use.                          ***
 *** Use as you like, no guarantees and no warranties ***
 *** And most certainly not any liabilities!!!        ***
 ********************************************************
 *** The source is heavily commented, use it as you   ***
 *** like, BUT                                        ***
 *** - I will add the missing features myself, or I   ***
 ***   will include your code suggestions after       ***
 ***   approval.                                      ***
 ***   - So please do not distribute modified versions***
 ***   without me knowing about it!                   ***
 ********************************************************
 ***  Version History                                 ***
 ***  January 15, 2001, initial release version 1.00  ***
 ***  January 17, 2001, Update                  1.01a ***
 ***  January 19, 2001, Release Update          1.01  ***
 ***  A:1.01a Changed Seek routine                    ***
 ***  F+:1.01 dBase version recognition added         ***
 ***  F+:1.01 dBase 3 and 4 Memo Read added           ***
 ***  Some Read-only properties replaced by functions ***
 ***  Some private fields replaced by header access   ***
 ***  Please notify me of any bugs.                   ***
 ********************************************************
 *** Legend:                                          ***
 *** A:Adapted, no functionality change               ***
 *** F+/-:Functionality added/removed                 ***
 *** B:Bugfix                                         ***
 ********************************************************
 Why did I write this?
 Well, I saw a small database prototype in KOL that used a proprietary
 format.
 Since dBase is still the most widely available format, either in use or
 conversion/export options, I thought, why not write me a fast and easy
 dBase reader/writer.
 So I spend a couple of hours putting this out.
 (I've done far more complex dBase libraries, so it wasn't a bother.)
 I promise you Blob access very soon, (easy, just haven't got the
 time right now) and NTX (Clipper) indices a bit later, since I have
 to write a treebalancing routine from scratch).
 Again, reading the indices is easy enough, the tree balancing
 after writes is far more complex.

 This version does no errorchecking, but is written in such a way
 that it just won't perform illegal actions: No exceptions are raised but
 If something is out-of-bounds either BOF or EOF becomes true.


 Write and BLOB routines maybe next week, promise}


Type

  PByteArray = ^TByteArray;
  TByteArray = array[0..32767] of Byte;

TdBaseHdr=packed record
  id:Byte;                        //01
  LastUpDateYY:byte;              //02
  LastUpdateMM:Byte;              //03
  LastUpDateDD:Byte;              //04
  RecordCount:DWORD;              //08
  HeaderSize:Word;                //10
  RecordSize:Word;                //12
  __Reserved_1:Word;              //14
  TransFlag:Byte;                 //15
  CryptFlag:Byte;                 //16
  MultiUser:array[0..11]of byte;  //28
  ProdIndexFlag:Byte;             //29
  LanguageDriverId:Byte;          //30
  __Reserved_2:WORD;              //32
end;


TdbField=packed record
  FieldName:array[0..10] of char;  //11
  FieldType:Char;                  //12
  FieldPtr:DWORD;                  //16
  FieldLength:Byte;                //17
  Decimals:Byte;                   //18
  __Reserved_1:Word;               //20
  WorkAreaID:Byte;                 //21
  __Reserved_2:array[0..9] of byte;//31
  IsProdIndex:Byte;                //32
end;

{Description of dBase header Record:
 HDR 32 ->Array of TdbFields n* 32-> Hdr Terminator $0D
 So the first record starts at (n+1)*32+2}

pDbField=^TdbField;

TdbDate= packed record
 Year :array[0..3] of char;
 Month:array[0..1] of char;
 Day  :array[0..1] of char;
end;
pDbDate=^TdbDate;

TMemoHeader= packed record
  NextAvailable:DWORD;               //0..3
  __Reserved_1 :DWORD;               //4..7
  DbfFilename  :Array [0..7] of char;//8..15
  __Reserved_2 :DWORD;               //16..19
  BlockSize    :WORD;                //20..21
  __Reserved   :array[0..489]of byte;//22..511
end;
pMemoHeader=^TmemoHeader;

TmemoBlock=packed record
  __Reserved_1:DWORD;{Always $FFFF ???, not shure}
  MemoLength  :DWORD;{Even if a memo exceeds blockboundaries
                      you can rely on this value to read the
                      memo as a whole, but subtract 8 for this size}
end;

pMemoBlock=^TmemoBlock;

  pDbReader=^TdbReader;

  TdbReader=object(Tobj)
  private
    Fdeleted:boolean;           {record deletion marker}
    Fcurrent:pstrList;          {Current record broken up in strings}
    FBof:Boolean;               {Calculated! Begin-Of-File Marker}
    Feof:Boolean;               {Calculated! End Of File Marker}
    Fstream:pstream;            {File access by stream}
    FmemoStream:pStream;        {Memo File}
    FHeader:TdBaseHdr;          {dBase header}
    FmemoHeader:TmemoHeader;    {dBase memoheader}
    FFieldList:plist;           {Fields, i.e. like Borlands FieldDefs}
    Factive:Boolean;            {ReadOnly, becomes true after open}
    FFilename:string;
    FrawData:pointer;           {Carefull: Access to the raw databuffer,
                                 DO NOT TOUCH when not shure}
    FmemoData:pointer;          {Raw pointer to memodata}
    procedure Fillrecord;       {Fills the Rawdata buffer with current record,
                                 and parses the fields to the CurrentRecord list}
    function getMemo(index:integer):string;
  protected
    procedure Init;virtual;
    destructor destroy;virtual;
    public
    function  FieldCount:word;      {Returns the fieldcount}
    function  Cursor:DWORD;         {Denotes the current record}
    procedure Open(aFilename:string);{Opens a dBase file and initializes
                                     internal data, the reads the first record}
    procedure Close;                {Closes the file and unitializes the internals}
    procedure Seek(Recnum:DWORD);   {if a valid record number is passed it finds it,
                                     otherwise either EOF or BOF becomes true}
    procedure First;                {BOF becomes true, firstrecord is read}
    procedure Last;                 {EOF becomes true, lastrecord is read}
    procedure Next;                 {skips to next record or EOF}
    procedure Prior;                {skips to prior record or BOF}

    {A proper database doesnot have a recordcount
     Still dBase supports it. It's read directly from the header}
    property RecordCount:dword read FHeader.recordCount write FHeader.recordcount;

    property FileName:string read FFilename write FFilename;

    {This implementation relies on 'OPEN' to set active.}
    property Active:boolean read Factive;

    {The fieldlist or Tfielddefs as TdbFields}
    property fields:plist read FFieldlist write FFieldlist;

    {The current record broken up in a Stringlist}
    property CurrentRecord:pstrList read Fcurrent write Fcurrent;

    {Pass it the field index, if it's a memofield,
     it returns the memo from the current record as a string}
    property MemoField[index:integer]:string read GetMemo;

    {Direct Access to the Raw Data buffer,
     provides for copying and assigning for edits etc.
     CAUTION this is a raw pointer, don't touch if not shure,
     It's a database remember, we don't want to loose anything.
     When we implement read/write we need this again,
     it's solely here for experimenting purposes on
     my behalf ;)}
    property RawData:pointer  read FrawData write Frawdata;

    {True if the current record is marked for deletion,
     i.e. the first character in the record is a '*'.($2A)
     Otherwise it 'should' be a space although some proprietary
     dBase implementations misuse this for other purposes}
    property deleted:boolean read Fdeleted;//currently readonly
    property dBaseType:byte read Fheader.Id;
  end;

  function NewdBase:pDbReader;
implementation
{ TdbReader }


procedure TdbReader.Init;
begin
  inherited;
  FFieldList:=Newlist;
  FFieldlist.Clear;
  Fcurrent:=NewStrlist;
  FFieldList.Clear;
  FrawData:=nil;
  Fmemodata:=nil;
end;

procedure TdbReader.Close;
begin
  Fstream.free;
  FMemostream.free;
  Freemem(FrawData);
  Factive:=False;
end;

destructor TdbReader.destroy;
var i:integer;
begin
 Close;
 for i:=FFieldlist.count-1 downto 0 do
     Freemem(FFieldlist.Items[i]);
 FFieldList.Free;
 Fcurrent.free;
 inherited;
end;

procedure TdbReader.Fillrecord;
var
 i:Integer;
 test:string;
begin
  {The Record is broken up in strings}
  if not Factive then Exit;
  Fcurrent.Clear;
  Fstream.Read(FrawData^,Fheader.RecordSize);
  for i:=0 to FieldCount -1 do
   with pDbField(FFieldList.Items[i])^ do
   begin
    if (FieldType='L') or
       (FieldType='C') or
       (FieldType='N') or
       (Fieldtype='F') then
        FCurrent.add(Copy(Pchar(FrawData),Fieldptr,FieldLength))
    else if FieldType='D' then
    begin
      test:=Copy(Pchar(FrawData),Fieldptr,FieldLength);
      Fcurrent.Add(pDbDate(test).Day+'-'+pDbDate(Test).Month+'-'+pdbDate(Test).Year);
    end
     else if FieldType='M' then
       case Fheader.ID of
         $83,$8B: {It's a memotype we can handle}
            begin
              Test:=trim(Copy(Pchar(FrawData),Fieldptr,FieldLength));
              {This follows the VCL convention:
               Upper case: Memo present
               Lower case: Memo is empty}
              if length(trim(test))>0 then FCurrent.Add('[MEMO]') else
                FCurrent.Add('[memo]');
            end;
       end
     else
      Fcurrent.add(FieldType);
    end;
      if pbytearray(Frawdata)[0]=$2A then
      Fdeleted:=true
    else
      Fdeleted:=false;
end;


procedure TdbReader.Open(aFilename: string);
var i,
  ptr:integer;
begin
  if Factive then Close;
  FFilename:=aFilename;
  {Initialize dBase file}
  FStream:=NewReadFileStream(aFilename);
  Fstream.Read(Fheader,SizeOf(Fheader));
  Frawdata:=Allocmem(Fheader.RecordSize+1);

  {Initialize memo file}
  if FHeader.ID in [$83,$8B] then {we've got a memo we can handle}
  begin
    FmemoStream:=NewReadFileStream(Copy(aFilename,1,length(afilename)-3)+'dbt');
    FmemoStream.Read(FmemoHeader,SizeOf(TmemoHeader));
    {Ensure a valid blocksize for dBase 3}
    if FmemoHeader.BlockSize=0 then FmemoHeader.BlockSize:=512;
  end;
  ptr:=2;
  For i:=0 to FieldCount-1 do
    begin
      FFieldList.Add(Allocmem(SizeOf(TdbField)));
      Fstream.Read(FFieldList.Items[i]^,SizeOf(TdbField));
      pDbField(FFieldList.Items[i]).FieldPtr:=ptr;
      ptr:=ptr+pDbField(FFieldList.Items[i]).FieldLength;
    end;
   Factive:=True;
   First;
end;

{  TMoveMethod = ( spBegin, spCurrent, spEnd );}
procedure TdbReader.First;
begin
 Fbof:=True;Feof:=False;{Even if there is only one record!}
 Fstream.Seek(FHeader.HeaderSize,spBegin);
 FillRecord;
end;

procedure TdbReader.Last;
begin
 FEof:=True;Fbof:=False;{Even if there is only one record!}
 {Compensate for eof marker $1A}
 Fstream.Seek(-Fheader.RecordSize-1,spEnd);
 Fillrecord;
end;

procedure TdbReader.Next;
begin
 FBof:=False;{Even if there is only one record!}
 if Feof then Last;
 with Fheader do if Fstream.Position>=
   HeaderSize+(RecordCount-1)*RecordSize then
     Last else
 FillRecord;
end;

procedure TdbReader.Prior;
begin
 FEof:=False;{Even if there is only one record!}
 if FBof then First;
 with Fheader do if Fstream.Position<=HeaderSize+RecordSize then
    First else
 begin
 {Note we have just read the current record,
  so we have to move TWO back to start reading
  the previous record}
 Fstream.Seek(-2*RecordSize,spCurrent);
 FillRecord;
 end;
end;

procedure TdbReader.Seek(RecNum: DWORD);
begin
   {We make 'first' equal 1, so we
    subtract 1 from recnum to obtain the
    internal recordnumber}
  if RecNum> Fheader.Recordcount then
  begin
    Last;
    exit;
  end;
  if RecNum < 1 then
  begin
    First;
    Exit;
  end;
  if (not active) or
     (RecNum > Fheader.RecordCount) then Exit;
  Fstream.Seek(Fheader.HeaderSize+(Recnum-1)*Fheader.RecordSize,spBegin);
  Fillrecord;
end;

  function NewdBase:pDbReader;
  begin
   New(result,Create);
  end;

function TdbReader.Cursor: DWORD;
begin
  {Returns the current record as a Number.
   Use it to position to the current record in
   for example multiline controls}
  Result:=-1+(Fstream.Position-Fheader.HeaderSize) div Fheader.RecordSize;
end;

function TdbReader.getMemo(Index:integer):string;
var
  Offset:Dword;
  Test:String;
  MemoBlock:TmemoBlock;
begin
 Result:='';
 with pDbField(FFieldList.Items[index])^ do
  if FieldType='M' then
  Test:=trim(Copy(Pchar(FrawData),Fieldptr,FieldLength));
  if Length(test)>0 then
    begin
    case Fheader.ID of
     $83:{dBase3+ memo, fixed blocksize 512, no further checking}
         begin
           Offset:=str2int(test)*512;
           FmemoData:=Allocmem(512+1);
           FmemoStream.Seek(Offset,spBegin);
           FmemoStream.Read(FmemoData^,512);
         end;
     $8B:{dBase4 with Leading 8 bytes info block}
         begin
           Offset:=str2int(test)*FMemoHeader.BlockSize;
           FmemoStream.Seek(Offset,spBegin);
           Fmemostream.read(MemoBlock,Sizeof(TmemoBlock));
           FmemoData:=Allocmem(memoblock.MemoLength+1);
           FmemoStream.Read(FmemoData^,memoblock.memolength-sizeof(TmemoBlock));
         end;
      end;
      if FmemoData<> nil then
      begin
        {The trim removes dBase 3 eoMemo markers}
        Result:=TrimRight(pChar(Fmemodata));
        Freemem(FmemoData);
      end;
    end;
end;

function TdbReader.FieldCount: word;
begin
   Result:=(Fheader.HeaderSize-sizeof(Fheader)-1)div SizeOf(TdbField);
end;

end.

