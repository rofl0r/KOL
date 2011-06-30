unit StrDB;
{*
  StrDb.pas is an attempt at a small database engine for KOL Objects.
It provides database functionality to the TStrList KOL Object.
As in KOL, the emphasis is on small. The test program, TestStrDB.exe is 29K.
|<br>
|<br>

The records are fixed width strings.
The fields are fixed width substrings of the records.
This simpifies the database functions since everything is stored as a string
 including floats, dates etc.
|<br>
|<br>

The TStrTable object encapsulates:
|<br>
 An array of Field Definition records (FldDefArray)
|<br>
 A TStrList containing all the records (RecList)
|<br>
 A string holding the current record (RecStr)
|<br>
 A Current Record Number integer (fCurrRecNum)
|<br>
 Several Database functions and procedures (AddFldDef, First, EditRec, etc)

|<br>
|<br>
The TStrTable is created with the NewStrTable function.
|<br>
Field Definitions are then added which provides the Field Name and Field Width.
|<br>
The table can be populated manually then saved. (See TestStDb.dpr)
|<br>
 Alternately, fixed width data can be exported from an existing database or
 spreadsheet.
|<br>
Data is copied into the Current Record string (RecStr) via named fields.
|<br>
  Ex:     SetFld('Name',E1.Text);
|<br>
          SetFld('EMail',E2.Text);
|<br>
          SetFld('URL',E3.Text);
|<br>
When complete, RecStr is stored in the TStrList (RecList) via Insert or AddRec.
|<br>
The First, Prior, Next, Last and SetCurrRec procedures copy the indexed RecList
 string into RecStr (the current record).
|<br>
The data is retrieved from RecStr via GetFld('Name'), etc.
|<br>
This can then be modified and stored back in RecList via PostRec.
|<br>
This manner of adding and editing records is different from the normal methods:
|<br>
  (Insert, Fill Fields, Post -and- Edit, Modify Fields, Post)
|<br>
This method is better suited to the StrTable object.
|<br>
If desired, the user interface can be programmed to work normally:
|<br>
  (Insert a Blank Record, Make That Field Current, Enter the Data, Post Record
|<br>
    or Delete the Blank Record if the User Cancels.)
|<br>
|<br>
Access to all the TStrList's methods and properties are available via
 TStrTable.RecList.???
|<br>
In this way Sorting, LoadFromFile, SaveToFile etc can be accomplished.
|<br>
Incidently, Windows API appears to simplify sorting the listview by columns via
 LVM_SORTITEMS.

|<br>
|<br>
A typical program stores and loads it's table via RecList.LoadFromFile and RecList.SaveToFile. Note that data is entered into RecList is not saved to disk until RecList.SaveToFile is executed.

|<br>
|<br>
LoadFromFile is only one means of loading the RecList.
|<br>
If only certain records in a file are needed, a file could be opened via
 TFileStream, filtering could be done and the desired records can be Added
 to RecList.

|<br>
|<br>
Additionally, two procedures are provided to automatically load a TListView
 object from a StrTable:
|<br>
  FillListView adds columns with the same names as the field names. It then calls:
|<br>
  FillListGrid which adds the records found in the RecList as items.
|<br>
   FillListGrid can be called as required to repaint the grid and reflect RecList.
|<br>
  The column width is currently 4pixels * the field width.
|<br>
   This can be adjusted after the Listview is loaded (even to 0 to hide the column). }

interface

uses
  windows,
  messages,
  kol;

type

  TFldDefRec = record
{* Record stored in FldDefArray containing Field Definitions for TStrTable}
    FldName: string;
    FldStart: integer;
    FldWidth: integer;
  end;

  PStrTable = ^TStrTable;
  TStrTable = object( TObj )
{* String Table object for accessing fields as substrings from a record string}
  private
    fBOF, fEOF: boolean;
    fCurrRecNum: integer; //Used by Next, Prior, Post, InsertRec, DeleteRec
  protected
    FldDefArray: array of TFldDefRec;
{* Array of Field Def Records - one FldDefRec for each Field in table}
    destructor Destroy; virtual;
  public
    RecList: PStrList;
{* StringList of all string records}
    RecStr: string;
{* String containing record to get or set data from ( = current record)}
    procedure AddFldDef(const FieldName: string; FieldWidth: integer);
{* Used To Add Field Definitions}
    function GetFld(const FieldName: string): string;
{* This is used to retrieve data from a record. Returns Data as substring of RecStr based on FieldName in Field Defs (see FldDefArray)}
    procedure SetFld(const FieldName, Data: string);
{* This is used to modify data in a record. Replaces substring of RecStr with Data based on FieldName in Field Defs. (see FldDefArray)}
    procedure First;
{* Goto First Record - Loads RecStr with First string from RecList and updates CurrRecNum }
    procedure Last;
{* Goto Last Record - Loads RecStr with Last string from RecList and updates CurrRecNum }
    procedure Next;
{* Goto Next Record - Loads RecStr with Next string from RecList and updates CurrRecNum }
    procedure Prior;
{* Goto Prior Record - Loads RecStr with Prior string from RecList and updates CurrRecNum }
    procedure SetCurrRec(RecNum: integer);
{* Goto RecNum Record - Loads RecStr with RecNum string from RecList and updates CurrRecNum }
    property CurrRecNum: integer read fCurrRecNum write SetCurrRec;
{* Current index of string in RecList - Assigning sets current record}
    property EOF: boolean read fEOF;
{* End Of File Indicator}
    property BOF: boolean read fBOF;
{* Beginning File Indicator}
    procedure PostRec;
{* Saves RecStr (current record) into RecList at CurrRecNum}
    procedure InsertRec;
{* Inserts RecStr (current record) into RecList before CurrRecNum}
    procedure AddRec;
{* Adds RecStr to end of RecList}
    procedure DeleteRec;
{* Deletes string in RecList of index CurrRecNum
 TStrTable.First is then executed to keep CurrRecNum in sync}
  end;
{* Notes:
|<br>
1. Editing and Inserting records operate differently than in TDataSet
|<br>
  To Edit: SetCurrRec then SetFld(s) then PostRec - There is no Edit proc.
|<br>
  To Insert: SetCurrRec then SetFld(s) then InsertRec - Do not use PostRec
|<br>
  To Append: SetFld(s) then AddRec - CurrRecNum is not used
|<br>
2. Any database that can connect to fixed width text files can link to tables generated by TStrTable. For Example: 
|<br>
a) Save the table via TStrList.RecList.SavetoFile to a filename.asc.
|<br>
b) Link to the table in MS Access as a Text file - Fixed width.
|<br>
c) MS Access can use this ISAM linked table in a limited manner:
|<br>
  --  New records can be added, existing records can be read - but not edited or
     deleted.
|<br>
  --  For import into MS Access, records can be copied to another table if editing
     is required.
|<br>
  --  For export into a StrTable, an update query can copy data to the linked table.
|<br>
  --  Select queries etc. in MS Access should be no problem.

}

function NewStrTable: PStrTable;
{* Creates a new TStrTable}

procedure FillListView( GivenListView: PControl; GivenStrTable: PStrTable);
{* Automatically adds columns to GivenListView with the same names as the field names found in GivenStrTable. It then calls FillListGrid. The column width is currently 4pixels * the field width. This can be adjusted after the Listview is loaded (even to 0 to hide the column).}

procedure FillListGrid( GivenListView: PControl; GivenStrTable: PStrTable);
{* FillListGrid adds the records found in GivenStrTable.RecList as items to GivenListView. FillListView should be called first to set up the columns. FillListGrid can be called as required to repaint the grid and reflect RecList.}

implementation

function NewStrTable: PStrTable;
begin
  New( Result, Create );
  Result.RecList := NewStrList;
  setlength(result.FldDefArray,0);
  Result.fBOF := true;
  Result.fEOF := true;
  Result.fCurrRecNum := 0;
end;

procedure FillListView( GivenListView: PControl; GivenStrTable: PStrTable);
var
  NoOfCols, f: integer;
begin
  NoOfCols := length(GivenStrTable.FldDefArray);
  GivenListView.Width := ( GivenStrTable.FldDefArray[NoOfCols - 1].FldStart +
    GivenStrTable.FldDefArray[NoOfCols - 1].FldWidth) * 4 + 20; 
  for f := 1 to NoOfCols do
  begin
    GivenListView.LVColAdd(GivenStrTable.FldDefArray[f-1].FldName, taLeft,
      GivenStrTable.FldDefArray[f-1].FldWidth * 4);
  end;
  FillListGrid(GivenListView, GivenStrTable);
end;

procedure FillListGrid( GivenListView: PControl; GivenStrTable: PStrTable);
var
  CurRecNo, NoOfCols, NoOfRecs, f, g: integer;
begin
  CurRecNo := GivenStrTable.CurrRecNum;
  NoOfCols := length(GivenStrTable.FldDefArray);
  NoOfRecs := GivenStrTable.RecList.Count;
  GivenListView.Clear;
  GivenStrTable.First;
  for f := 0 to NoOfRecs - 1 do
  with GivenListView^, GivenStrTable^ do
  begin
    LVAdd( '', 0, [ ], 0, 0, 0 );
    for g := 0 to NoOfCols - 1 do
    begin
      LVItems[ f, g ] := GetFld(FldDefArray[g].FldName);
    end;
    Next;
  end;
  GivenStrTable.CurrRecNum := CurRecNo;
end;

procedure TStrTable.AddFldDef(const FieldName: string; FieldWidth: integer);
var
  count, FieldStart: integer;
begin
  count := length(FldDefArray);
  if count > 0 then
    FieldStart := FldDefArray[count - 1].FldStart
     + FldDefArray[count - 1].FldWidth
  else
    FieldStart := 0;
  setlength(FldDefArray, count + 1);
  with FldDefArray[count] do
  begin
    FldName := FieldName;
    FldStart := FieldStart;
    FldWidth := FieldWidth;
  end;
end;

function TStrTable.GetFld(const FieldName: string): string;
var
  f, TotFDs: integer;
begin
  result := '';
  TotFDs := length(FldDefArray);
  for f := 0 to TotFDs - 1 do
  begin
    if FldDefArray[f].FldName = FieldName then
    begin
      result := copy(RecStr, FldDefArray[f].FldStart + 1,
       FldDefArray[f].FldWidth);
      exit;
    end;
  end;
end;

procedure TStrTable.SetFld(const FieldName, Data: string);
var
  f, TotFDs: integer;
begin
  TotFDs := length(FldDefArray);
  for f := 0 to TotFDs - 1 do
  with FldDefArray[f] do
  begin
    if FldName = FieldName then
    begin
      RecStr := copy(RecStr, 1, FldStart) +
        copy (Data + stringofchar(' ',FldWidth), 1, FldWidth) +
        copy (RecStr, FldStart + FldWidth + 1,
         length(RecStr) - FldStart + FldWidth);
      exit;
    end;
  end;
end;

procedure TStrTable.First;
begin
  fBOF := true;
  fCurrRecNum := 0;
  if RecList.Count = 0 then
    fEOF := true
  else
  begin
    fEOF := false;
    RecStr := RecList.Items[0];
  end;
end;

procedure TStrTable.Last;
begin
  fEOF := true;
  if RecList.Count = 0 then
  begin
    fBOF := true;
    fCurrRecNum := 0;
  end
  else
  begin
    fBOF := false;
    fCurrRecNum := RecList.Count - 1;
    RecStr := RecList.Items[fCurrRecNum];
  end;
end;

procedure TStrTable.Prior;
begin
  if RecList.Count = 0 then
  begin
    fBOF := true;
    fEOF := true;
    fCurrRecNum := 0;
  end
  else
    if fCurrRecNum = 0 then
      fBOF := true
    else
  begin
    fBOF := false;
    fEOF := false;
    fCurrRecNum := fCurrRecNum - 1;
    RecStr := RecList.Items[fCurrRecNum];
  end;
end;

procedure TStrTable.Next;
begin
  if RecList.Count = 0 then
  begin
    fBOF := true;
    fEOF := true;
    fCurrRecNum := 0;
  end
  else
    if fCurrRecNum = RecList.Count - 1 then
      fEOF := true
    else
      begin
        fBOF := false;
        fEOF := false;
        fCurrRecNum := fCurrRecNum + 1;
        RecStr := RecList.Items[fCurrRecNum];
      end;
end;

procedure TStrTable.SetCurrRec(RecNum: integer);
begin
  if RecList.Count = 0 then
  begin
    fBOF := true;
    fEOF := true;
    fCurrRecNum := 0;
  end
  else
    if RecNum >= RecList.Count then
      fEOF := true
    else
      if RecNum < 0 then
        fBOF := true
      else
        begin
          fBOF := false;
          fEOF := false;
          fCurrRecNum := RecNum;
          RecStr := RecList.Items[fCurrRecNum];
        end;
end;

procedure TStrTable.PostRec;
begin
  RecList.Items[fCurrRecNum] := RecStr;
end;

procedure TStrTable.InsertRec;
begin
  RecList.Insert(fCurrRecNum, RecStr);
end;

procedure TStrTable.AddRec;
begin
  RecList.Add(RecStr);
end;

procedure TStrTable.DeleteRec;
begin
  RecList.Delete(fCurrRecNum);
  self.First;
end;

destructor TStrTable.Destroy;
begin
  RecList.Free;
  setlength(FldDefArray,0);
  inherited;
end;

end.
