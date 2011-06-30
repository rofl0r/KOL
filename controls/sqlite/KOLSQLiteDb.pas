unit KOLSQLiteDb;
{* This unit is created for KOL to allow communication with SQLite database.
|<br> ========================================================================
|<br> Copyright (C) 2002,2003 by Bogus³aw Brandys.  Email: brandys@o2.pl
|<br> ========================================================================
|<br>Version 1.2
|<br>
|<br>
|<FIELDSET>
|<FORM>
|<INPUT TYPE="button" VALUE="Send comment"  onClick="parent.location.href='mailto:brandys@o2.pl?cc=bonanzas@xcl.cjb.net&subject=Comments about TKOLSQLiteDb unit.&body=Hello Boguslaw,'">
|</FORM>
|</FIELDSET>
|<p>
	This unit contains three objects TSLDataSource, TSLSession and TSLQuery to implement
	the most important things: to open/create database, to manually control transactions,
	to perform queries (with parameters)  and obtain results or update tables.
	It needs sqlite.dll library to be installed somewhere on system path.
	|<br>
	|<br>
	|<i>Look for SQLite on page : <A HREF="http://www.sqlite.org">http://www.sqlite.org</A> ( Version used : 2.8.0, 23.02.2003)</i>
	|<br>
	|<br>
	SQLite is in continuos development so I'm sure that soon or later more features will
	be available.
|</p>
|<p>
|<br>
|<br>
|<i>History :</i>
|<br>
09-04-2003 (version 1.2) [-] Fixed bug in TDataSource.Close which prevent of opening another database during run-time using Open method
												 [-] Fixed bug in EOF implementation which caused improper calculation of last row
												 [-] Fixed MCK bug : improper creation order of SL database objects causes program to crash
												 [*] First usage in large database program - working like a charm,
												 but visual components and report generator are more then welcome
												 to allow faster process of development
|<br>
23-02-2003 (version 1.1) [*] Adapted for SQLite 2.8.0. First usage in simple database program.
|<br>
09-10-2002 (version 1.0) [N] First official version.
|<br>
|</p>
}


interface
uses Windows,Messages,KOL;


const
	SQLITE_OK         =  0;
	SQLITE_ERROR      =  1;
	SQLITE_INTERNAL   =  2;
	SQLITE_PERM       =  3;
	SQLITE_ABORT      =  4;
	SQLITE_BUSY       =  5;
	SQLITE_LOCKED     =  6;
	SQLITE_NOMEM      =  7;
	SQLITE_READONLY   =  8;
	SQLITE_INTERRUPT  =  9;
	SQLITE_IOERR      = 10;
	SQLITE_CORRUPT    = 11;
	SQLITE_NOTFOUND   = 12;
	SQLITE_FULL       = 13;
	SQLITE_CANTOPEN   = 14;
	SQLITE_PROTOCOL   = 15;
	SQLITE_EMPTY      = 16;
	SQLITE_SCHEMA     = 17;
	SQLITE_TOOBIG     = 18;
	SQLITE_CONSTRAINT = 19;
	SQLITE_MISMATCH   = 20;
	SQLITE_MISUSE     = 21;
	SQLITE_NOLFS      = 22;
  SQLITE_AUTH       = 23;



type
    TSLOpen = function(dbname: PChar; mode: Integer; var ErrMsg: PChar): Pointer; cdecl;
    TSLClose = procedure(db: Pointer); cdecl;
    TSLInfo = function(): PChar; cdecl; {Version and Encoding}
    TSLBusyHandler = procedure(db: Pointer; CallbackPtr: Pointer; Sender: PObj); cdecl;
    TSLBusyTimeout = procedure(db: Pointer; TimeOut: integer); cdecl;
    TSLFreeMem = procedure(P: PChar); cdecl;
    TSLErrorString = function(ErrNo: Integer): PChar; cdecl;
    TSLExecV = function(db: Pointer; SQLStatement: PChar; CallbackPtr: Pointer; Sender: PObj; var ErrMsg: PChar;params : va_list): integer; cdecl;
    TSLExec = function(db: Pointer; SQLStatement: PChar; CallbackPtr: Pointer; Sender: PObj; var ErrMsg: PChar): integer; cdecl;
    TSLComplete = function(P: PChar): boolean; cdecl;
    TSLChanges = function(db: Pointer): integer; cdecl;{LastInsertRow and Changes}
    TSLCancel = procedure(db: Pointer); cdecl;
    TSLExecCallback = function(Sender: PObj; Columns: Integer; ColumnValues: Pointer; ColumnNames: Pointer): Integer of object; cdecl;
    TSLBusyCallback = function(Sender: PObj; ObjectName: PChar; BusyCount: integer): integer of object; cdecl;
    TConflict = (cfRollback,cfAbort,cfFail,cfIgnore,cfReplace);
     {* OnConflict transaction behaviour}

//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
//  TSLDataSource - open/create SQLite database
//,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,

type
  TOnBusy = procedure(Sender: PObj; ObjectName: String; BusyCount: integer; var Cancel: Boolean) of object;
  {*}
  PSLDataSource = ^TSLDataSource;
  TKOLSLDataSource = PSLDataSource;
  TSLDataSource = object( TObj )
  {* This object provides a connection to SQLite database. Create it using
     NewSLDataSource function and passing a database path to it. Database is opened
     (or created if didn't exist) immediately after that. You can get know if the
     connection established successfully reading Initialized property.(Note: TSLDataSource is a
     container of pointers to all exported functions from sqlite.dll) }
  private
    fSQLite : Pointer;
    fLibHandle: THandle;
    fSessions: PList;
    fInitialized: Boolean;
    fVersion: String;
    fEncoding: String;
    fErrorString : String;
    fOnBusy : TOnBusy;
    fBusyTimeout: Integer;
    SQLite_Open: TSLOpen;
    SQLite_Close: TSLClose;
    SQLite_Version: TSLInfo;
    SQLite_Encoding: TSLInfo;
    SQLite_BusyHandler: TSLBusyHandler;
    SQLite_BusyTimeout: TSLBusyTimeout;
    procedure SetBusyTimeout(const Timeout: integer);
  protected
    SQLite_FreeMem: TSLFreeMem;
    SQLite_ErrorString: TSLErrorString;
    SQLite_Exec_vprintf: TSLExecV;
    SQLite_Exec: TSLExec;
    SQLite_Complete: TSLComplete;
    SQLite_LastInsertRow: TSLChanges;
    SQLite_Cancel: TSLCancel;
    SQLite_Changes: TSLChanges;
    procedure SetOnBusy(const Value : TOnBusy);
  public
    destructor Destroy; virtual;
    {* Do not call this destructor. Use Free method instead. When TSLDataSource
       object is destroyed, all its sessions (and consequensly, all queries)
       are freed automatically. }
    property Initialized: Boolean read fInitialized;
    {* Returns True, if database is opened (without error) or False in two cases:
    |<br>
    1. SQLite.dll library is missing or incorrect/damaged.
    |<br>
    2. Database is missing and/or cannot be created.
    |<hr>
    |<b>
    Note: always check if Initialized = TRUE after creating of TSLDataSource to avoid application crash
   ,becouse all methods (in TSLDataSource,TSLSession,TSLQuery) assume that database connection is established succesfully !
    |</b> }
    property ErrorMessage : String read fErrorString;
    {* Error string if connection to database failed.
      Error codes list is here ->
  |*Error codes
  |<hr>
  Error codes.Most methods in TSLDataSource,TSLSession, TSLQuery return error code from this list.
  |<hr>
  SQLITE_OK         =  0; Successful result
  |<br>
  SQLITE_ERROR      =  1; SQL error or missing database
  |<br>
  SQLITE_INTERNAL   =  2; An internal logic error in SQLite
  |<br>
  SQLITE_PERM       =  3; Access permission denied
  |<br>
  SQLITE_ABORT      =  4; Callback routine requested an abort
  |<br>
  SQLITE_BUSY       =  5; The database file is locked
  |<br>
  SQLITE_LOCKED     =  6; A table in the database is locked
  |<br>
  SQLITE_NOMEM      =  7; A malloc() failed
  |<br>
  SQLITE_READONLY   =  8; Attempt to write a readonly database
  |<br>
  SQLITE_INTERRUPT  =  9; Operation terminated by sqlite_interrupt()
  |<br>
  SQLITE_IOERR      = 10; Some kind of disk I/O error occurred
  |<br>
  SQLITE_CORRUPT    = 11; The database disk image is malformed
  |<br>
  SQLITE_NOTFOUND   = 12; (Internal Only) Table or record not found
  |<br>
  SQLITE_FULL       = 13; Insertion failed because database is full
  |<br>
  SQLITE_CANTOPEN   = 14; Unable to open the database file
  |<br>
  SQLITE_PROTOCOL   = 15; Database lock protocol error
  |<br>
  SQLITE_EMPTY      = 16; (Internal Only) Database table is empty
  |<br>
  SQLITE_SCHEMA     = 17; The database schema changed
  |<br>
  SQLITE_TOOBIG     = 18; Too much data for one row of a table
  |<br>
  SQLITE_CONSTRAINT = 19; Abort due to contraint violation
  |<br>
	SQLITE_MISMATCH   = 20; Data type mismatch
	|<br>
	SQLITE_MISUSE  		= 21; Library used incorrectly
	|<br>
	SQLITE_NOLFS			= 22; Uses OS features not supported on host
	|<br>
	SQLITE_AUTH				= 23; Authorization denied
  |<br>
  |*}

    property Version : String read fVersion;
    {* SQLite Database engine version}
    property Encoding : String read fEncoding;
    {* SQLite Database engine encoding}
    property OnBusy: TOnBusy read fOnBusy write SetOnBusy;
    {* Event fired when database is locked}
    property BusyTimeout: Integer read fBusyTimeout write SetBusyTimeout;
    {* Amount of time to wait for free of database lock}
    function Open(const Database : String) : Boolean;
    {* Opens database. Return false if error occurs (check also ErrorMessage property).}
    procedure Close;
    {* Close connection to database.
    |<hr>
    |<b>Note: closing connection  rollback pending transaction and unlock database
    |</b>
    }
  end;

function NewSLDataSource( const Database: String; CreateNew : Boolean): PSLDataSource;
{* Opens or creates database. Pass a database path (location)
   as a parameter (or pass empty string and use Open method later).See demo provided.
   |<br>
   |<b>
   Note: always check if Initialized = TRUE after creating of TSLDataSource to avoid application crash
   , becouse all methods (in TSLDataSource,TSLSession,TSLQuery) assume that database connection is established succesfully !
   |</b> }

//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
//  TSLSession - transaction session in a connection to SQLite database
//,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,

type
  PSLSession = ^TSLSession;
  TKOLSLSession = PSLSession;
  TSLSession = object( TObj )
  {* This object is intended to provide session transactions. It always
     must be created as a "child" of TSLDataSource object using NewSLSession function,
     and it owns query objects (of type TSLQuery). For each TSLDataSource object, it is
     possible to create several TSLSession objects, and for each session,
     several TSLQuery objects can exist. In current implementation there would
     be only one transaction in the same time becouse of database locking schemma.
     (full database is locked during transaction processing)  }
  private
    fQueryList: PList;
    fDataSource: PSLDataSource;
    fName : String;
    fOnConflict : TConflict;
    fErrorString : String;
  protected
  public
    destructor Destroy; virtual;
    {* Do not call directly, call Free method instead. When TSLSession object is
       destroyed, all it child queries are freed automatically. }
    property DataSource: PSLDataSource read fDataSource;
    {* Returns a pointer to owner TSLDataSource object. }
    property ErrorMessage : String read fErrorString;
    {* Error string if transaction failed. See also TSLDataSource.ErrorMessage for
     list of error codes returned by most of methods}
    property IfConflict : TConflict read fOnConflict write fOnConflict;
    {* Conflict resolution algorithm for transaction. See SQLite documentation.}
    function StartTransaction : Integer;
    {* Start transaction}
    function Commit : Integer;
    {* Commit transaction}
    function Rollback : Integer;
    {* Rollback transaction}
  end;

function NewSLSession(const Name : String;  ADataSource: PSLDataSource ): PSLSession;
{* Creates session object owned by ADataSource (this last must exist). }


//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
//  TSLQuery - a command and resulting rowset(s)
//,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,

type
  TOnQueryData = procedure(Sender: PObj; var Cancel : Boolean) of object;
  {*}
  PSLQuery = ^TSLQuery;
  TKOLSLQuery = PSLQuery;
  TSLQuery = object( TObj )
  {* This object is intended to provide SQL 92 support (SQLite supports
     almost all SQL 92 features). It always must be created as a "child" of
     TSLSession object using NewSLQuery function. For each TSLSession object, it is possible to create
     several TSLQuery objects. There is no need to manually start
     transaction but is highly recommended.
     |<hr>
     Note: Transaction could be started even within
     query (not using TSLSession for this operation) using "BEGIN TRANSACTION" and
     also end transaction using "COMMIT" or "ROLLBACK",
     statements fully supported by SQLite.
     |<hr>
     Unfortunately there must be only one transaction in the same time :-( (SQLite 2.7.2).}
  private
    fSession: PSLSession;
    fErrorString : String;
    fRowCount,fColCount,fCurIndex : Integer;
    fEof,fBof : Boolean;
    fOnQueryComplete : TOnEvent;
    fOnQueryData : TOnQueryData;
    fSQL : PStrList;
    fFields : PStrList;
    procedure SetCurIndex(const Value : Integer);
    function GetLastRowID : Integer;
    function GetLastChanges : Integer;
    function InternalExecute(Params : array of const; Callback : Pointer) : Integer;
    function GetColNames(Idx : Integer) : String;
    function GetColIndex(Name : String) : Integer;
    function GetField(Idx : Integer) : String;
    function GetFieldByName(Name : String) : String;
  protected
  public
    destructor Destroy; virtual;
    {* Do not call directly, call Free method instead.}
    property Session: PSLSession read fSession;
    {* Returns a pointer to owner Session object. }
    property ErrorMessage : String read fErrorString;
    {* Contains text description of last error.See TSLDataSource.ErrorMessage for
     list of error codes returned by most of methods.}
    property SQL : PStrList read fSQL;
    {* SQL text. The main advantage of using PStrList here instead of simple String is
    to allow load/save SQL text data to stream or file.This way also could be used any of powerfull methods of
    PStrList. }
    property RowCount : Integer read fRowCount;
    {* Count of rows  for current resultset}
    property ColCount : Integer read fColCount;
    {* Count of columns  for current resultset}
    property ColName[Idx : Integer] : String read GetColNames;
    {* Returns column name from current resultset, selected by index}
    property ColByName[Name : String] : Integer read GetColIndex;
    {* Returns index of column selected by name}
    property SField[Idx : Integer] : String read GetField;
    {* Returns value of field from current row, selected by index}
    property SFieldByName[Name : String] : String read GetFieldByName;
    {* Returns value of field from current row, selected by name}
    property RawFields : PStrList read fFields;
    {* Pointer to internal list of column names and fields (Note: first fColCount items
    are simply column names another are fields. The main advantage of using this property is
    to allow save(/load?) fetched data to stream or file.You could use here any of powerfull methods of
    PStrList. }
    property CurIndex : Integer read fCurIndex write SetCurIndex;
    {* Index of current selected row from resultset (zero based)}
    property RowID : Integer read GetLastRowID;
    {* Id of the last inserted row (usefull for INSERT queries)}
    property RowsAffected : Integer read GetLastChanges;
    {* Number of changed rows by the last query}
    property EOF : Boolean read fEof;
    {* Indicate that resultset is positioned to the last row.
    Returns True, if end of data is achived (usually after calling Next or Prev method,
    or immediately after Open, if there are no rows in opened rowset). }
    property BOF : Boolean read fBof;
    {* Indicate that resultset is positioned to the first row (Note:
    if EOF and BOF are both true then resultset is surely empty as like when fRowCount =0)}
    property OnComplete : TOnEvent read fOnQueryComplete write fOnQueryComplete;
    {* Fired when query is completed and result fetched}
    property OnData : TOnQueryData read fOnQueryData write fOnQueryData;
    {* Fired when a row of data is fetched into internal fFields.Could be used to Cancel query execution}
    procedure Close;
    {* Close query. Clears fetched record list and SQL text}
    procedure Cancel;
    {* Cancel execution of SQLite query . Can be called from another thread.
    When called Open or Execute functions return SQLITE_INTERRUPT error. }
    procedure First;
    {* Position resultset to first row}
    procedure Last;
    {* Position resultset to last row}
    procedure Next;
    {* Position resultset to next row}
    procedure Prev;
    {* Position resultset to previous row}
    function Open(Params : array of const) : Integer;
    {* Execute SQL query returning resultset}
    function Execute(Params : array of const) : Integer;
    {* Execute SQL query without returning resultset (Note: use RowID to find last inserted row
    for example to establish foreign key relation)}
    function ShowError(const Error : Integer) : String;
    {* Return internal error string for selected error code}
    function IsComplete : Boolean;
    {* Returns TRUE if SQL text is completed}
  end;

function NewSLQuery(ASession: PSLSession ): PSLQuery;
{* Creates Query object to process SQL 92 statements. }


implementation



//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
//  TSLDataSource - open/create SQLite database
//,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,


function NewSLDataSource( const Database: String; CreateNew : Boolean ): PSLDataSource;
begin
  New(Result,Create);
  with Result^ do begin
  fSessions := NewList;
  fLibHandle := 0;
	fSQLite := nil;
	fLibHandle := LoadLibrary('sqlite.dll');
	fInitialized := True;
	if fLibHandle <> 0 then
	begin
		@SQLite_Open := GetProcAddress(fLibHandle, 'sqlite_open');
		if not Assigned(@SQLite_Open) then fInitialized := false;
		@SQLite_Close := GetProcAddress(fLibHandle, 'sqlite_close');
		if not Assigned(@SQLite_Close) then fInitialized := false;
		@SQLite_Version := GetProcAddress(fLibHandle, 'sqlite_libversion');
		if not Assigned(@SQLite_Version) then fInitialized := false;
		@SQLite_Encoding := GetProcAddress(fLibHandle, 'sqlite_libencoding');
		if not Assigned(@SQLite_Encoding) then fInitialized := false;
		@SQLite_FreeMem := GetProcAddress(fLibHandle, 'sqlite_freemem');
		if not Assigned(@SQLite_FreeMem) then fInitialized := false;
		@SQLite_BusyTimeout := GetProcAddress(fLibHandle, 'sqlite_busy_timeout');
		if not Assigned(@SQLite_BusyTimeout) then fInitialized := false;
		@SQLite_BusyHandler := GetProcAddress(fLibHandle, 'sqlite_busy_handler');
		if not Assigned(@SQLite_BusyHandler) then fInitialized := false;
		@SQLite_ErrorString := GetProcAddress(fLibHandle,'sqlite_error_string');
		if not Assigned(@SQLite_ErrorString) then fInitialized := false;
		@SQLite_Complete := GetProcAddress(fLibHandle, 'sqlite_complete');
		if not Assigned(@SQLite_Complete) then fInitialized := false;
		@SQLite_LastInsertRow := GetProcAddress(fLibHandle,'sqlite_last_insert_rowid');
		if not Assigned(@SQLite_LastInsertRow) then fInitialized := false;
		@SQLite_Cancel := GetProcAddress(fLibHandle, 'sqlite_interrupt');
		if not Assigned(@SQLite_Cancel) then fInitialized := false;
		@SQLite_Changes := GetProcAddress(fLibHandle, 'sqlite_changes');
		if not Assigned(@SQLite_Changes) then fInitialized := false;
		@SQLite_Exec := GetProcAddress(fLibHandle, 'sqlite_exec');
		if not Assigned(@SQLite_Exec) then fInitialized := false;
		@SQLite_Exec_vprintf := GetProcAddress(fLibHandle, 'sqlite_exec_vprintf');
		if not Assigned(@SQLite_Exec_vprintf) then fInitialized := false;
	end
	else
		fInitialized := false;
	if (not FileExists(Database)) and (CreateNew=false) then begin
		fInitialized := false;
		Exit;
	end;
	if (Length(Database) > 0) and fInitialized then Open(Database);
	end;
end;


function BusyCallback(Sender: PObj; ObjectName: PChar; BusyCount: integer): integer; cdecl;
var
  sObjName: String;
  bCancel: Boolean;
begin
  Result := -1;
  with PSLDataSource(Sender)^ do
  begin
    if Assigned(fOnBusy) then
    begin
      bCancel := False;
      sObjName := ObjectName;
      fOnBusy(Sender, sObjName, BusyCount, bCancel);
      if bCancel then
        Result := 0;
    end;
  end;
end;

procedure TSLDataSource.SetOnBusy;
begin
	fOnBusy := Value;
	if fSQLite = nil then Exit;
	if @Value <> nil then  begin
		SQLite_BusyTimeout(fSQLite,0);
		SQLite_BusyHandler(fSQLite, @BusyCallback, @Self);
		fBusyTimeout := 0;
	end
	else
		SQLite_BusyHandler(fSQLite, nil, nil);
end;

procedure TSLDataSource.SetBusyTimeout(const Timeout: Integer);
begin
	if fSQLite = nil then Exit;
  fBusyTimeout := Timeout;
  if fInitialized then SQLite_BusyTimeout(fSQLite, fBusyTimeout);
end;


function TSLDataSource.Open(const Database : String) : Boolean;
var
 fPMsg : PChar;
begin
 fErrorString := '';
 Result := fInitialized;
 if fInitialized then
  begin
    if fSQLite <> nil then Close;
    fSQLite := SQLite_Open(PChar(Database), 1, fPMsg);
    if fSQLite <> nil then
    begin
      SetBusyTimeout(0);
      fVersion := SQLite_Version;
      fEncoding := SQLite_Encoding;
    end
      else
        begin
          if StrLen(fPMsg) > 0 then begin
            SetLength(fErrorString,StrLen(fPMsg));
            StrCopy(PChar(fErrorString),fPMsg);
          end;
          Result := False;
        end;
    SQLite_FreeMem(fPMsg);
  end;
end;

procedure TSLDataSource.Close;
begin
  fVersion := '';
  fEncoding := '';
  if fSQLite <> nil then SQLite_Close(fSQLite);
  fSQLite := nil;
end;


destructor TSLDataSource.Destroy;
var I: Integer;
begin
  Close;
  for I := fSessions.Count - 1 downto 0 do
    PObj( fSessions.Items[ I ] ).Free;
  fSessions.Free;
  if fInitialized then FreeLibrary(fLibHandle);
  fErrorString := '';
  inherited;
end;

//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
//  TSLSession - transaction session in a connection to SQLite database
//,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,



function NewSLSession(const Name : String; ADataSource: PSLDataSource ): PSLSession;
begin
  New(Result,Create);
  with Result^ do begin
  fDataSource := ADataSource;
  ADataSource.fSessions.Add(Result);
  fName     := Name;
  fOnConflict := cfAbort;
  fQueryList := NewList;
  end;
end;

destructor TSLSession.Destroy;
var
 I : Integer;
begin
  fName := '';
  fErrorString :='';
  for I := fQueryList.Count - 1 downto 0 do
    PObj( fQueryList.Items[ I ] ).Free;
  fQueryList.Free;
  I := fDataSource.fSessions.IndexOf( @Self );
  if I >= 0 then fDataSource.fSessions.Delete( I );
  inherited;
end;


function TSLSession.StartTransaction : Integer;
var
  SQL : String;
  fPMsg : PChar;
begin
   SQL := 'BEGIN TRANSACTION ' + fName;
   case fOnConflict of
     cfRollback: SQL := SQL +  ' ON CONFLICT ROLLBACK';
     cfFail:SQL := SQL +  ' ON CONFLICT FAIL';
     cfAbort:SQL := SQL +  ' ON CONFLICT ABORT';
     cfIgnore:SQL := SQL +  ' ON CONFLICT IGNORE';
     cfReplace:SQL := SQL +  ' ON CONFLICT REPLACE';
   end;
   Result := fDataSource.SQLite_Exec(fDataSource.fSQLite, PChar(SQL), nil, @Self, fPMsg);
   if StrLen(fPMsg) > 0 then begin
   SetLength(fErrorString,StrLen(fPMsg));
   StrCopy(PChar(fErrorString),fPMsg);
   end;
   fDataSource.SQLite_FreeMem(fPMsg);
   SQL := '';
end;


function TSLSession.Commit : Integer;
var
  fPMsg : PChar;
begin
   Result := fDataSource.SQLite_Exec(fDataSource.fSqlite,pChar('COMMIT TRANSACTION ' + fName),nil,nil,fPMsg);
   if StrLen(fPMsg) > 0 then begin
   SetLength(fErrorString,StrLen(fPMsg));
   StrCopy(PChar(fErrorString),fPMsg);
   end;
   fDataSource.SQLite_FreeMem(fpMsg);
end;

function TSLSession.Rollback : Integer;
var
  fpMsg : PChar;
begin
   Result := fDataSource.SQLite_Exec(fDataSource.fSqlite,pChar('ROLLBACK TRANSACTION ' + fName),nil,nil,fPMsg);
   if StrLen(fPMsg) > 0 then begin
   SetLength(fErrorString,StrLen(fPMsg));
   StrCopy(PChar(fErrorString),fPMsg);
   end;
   fDataSource.SQLite_FreeMem(fpMsg);
end;


//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
//  TSLQuery - a command and resulting rowset(s)
//,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,

function NewSLQuery(ASession: PSLSession ): PSLQuery;
begin
  New(Result,Create);
  with Result^ do begin
  fSession := ASession;
  ASession.fQueryList.Add(Result);
  fSQL := NewStrList;
  fFields := NewStrList;
  end;
end;

destructor TSLQuery.Destroy;
var I : Integer;
begin
  I := fSession.fQueryList.IndexOf( @Self );
  if I >= 0 then
    fSession.fQueryList.Delete( I );
    fSQL.Free;
    fFields.Free;
    fErrorString := '';
    inherited;
end;

procedure TSLQuery.Close;
begin
  fSQL.Clear;
  fFields.Clear;
  fColCount := 0;
  SetCurIndex(0);
end;

function TSLQuery.GetLastRowID : Integer;
begin
    Result := fSession.fDataSource.SQLite_LastInsertRow(fSession.fDataSource.fSQLite);
end;


function TSLQuery.GetLastChanges : Integer;
begin
  Result := fSession.fDataSource.SQLite_Changes(fSession.fDataSource.fSQLite);
end;

function ExecCallback(Sender: PObj; Columns: Integer; ColumnValues: Pointer; ColumnNames: Pointer): Integer; cdecl;
var
  PVal, PName: ^PChar;
  n: integer;
  fCancel : Boolean;
begin
  Result := 0;
  with PSLQuery(Sender)^ do
  begin
    if Columns > 0 then
      begin
        fColCount := Columns;
        fRowCount := fRowCount + 1;
        PName := ColumnNames;
        PVal := ColumnValues;
        if fFields.Count =0 then
           begin
            for n := 0 to Columns - 1 do
              begin
                fFields.Add(PName^);
                Inc(PName);
              end;
           end;
        for n := 0 to Columns - 1 do
        begin
          fFields.Add(PVal^);
          Inc(PVal);
        end;
      if Assigned(fOnQueryData) then begin
      fCancel := false;
      fOnQueryData(Sender,fCancel);
      if fCancel then  Result := -1;
        end;
      end;
  end;
end;



function TSLQuery.Open(Params : array of const) : Integer;
begin
  Result := InternalExecute(Params,@ExecCallback);
end;

function TSLQuery.Execute(Params : array of const) : Integer;
begin
  Result := InternalExecute(Params,nil);
end;


function TSLQuery.InternalExecute(Params : array of const; Callback : Pointer) : Integer;
var
    ElsArray, El: PDWORD;
    I : Integer;
    P : PDWORD;
    fPMsg : PChar;
    s : String;
    fSQLite : Pointer;
begin
  ElsArray := nil;
  if High( Params ) >= 0 then
    GetMem( ElsArray, (High( Params ) + 1) * sizeof( Pointer ) );
  El := ElsArray;
  for I := 0 to High( Params ) do
  begin
    P := @Params[ I ];
    P := Pointer( P^ );
    El^ := DWORD( P );
    Inc( El );
  end;
    s := '';
    fSQLite := fSession.fDataSource.fSQLite;
    fFields.Clear;
    fColCount := 0;
    fCurIndex := 0;
    fRowCount := 0;
    for I := 0 to fSQL.Count -1 do s := s + fSQL.Items[I];
    Result := fSession.fDataSource.SQLite_Exec_vprintf(fSQLite, PChar(s), Callback, @Self, fPMsg,PChar(Elsarray));
    if StrLen(fPMsg) > 0 then begin
      SetLength(fErrorString,StrLen(fPMsg));
      StrCopy(PChar(fErrorString),fPMsg);
    end;
    fSession.fDataSource.SQLite_FreeMem(fPMsg);
    if ElsArray <> nil then FreeMem( ElsArray );
     {Extend in future, allow to send notification to DataSync object
     to synchronize all database controls (attached to DataSync)}
    if Assigned(fOnQueryComplete) then  fOnQueryComplete(@Self);
end;






procedure TSLQuery.Cancel;
begin
 fSession.fDataSource.SQLite_Cancel(fSession.fDataSource.fSQLite);
end;


function TSLQuery.ShowError(const Error : Integer) : String;
begin
      Result := fSession.fDataSource.SQLite_ErrorString(Error);
end;

function TSLQuery.IsComplete: Boolean;
var
  s : String;
  i : Integer;
begin
  s := '';
  for i:=0 to fSQL.Count-1 do s := s + fSQL.Items[i];
  Result := fSession.fDataSource.SQLite_Complete(PChar(s));
  s := '';
end;


function TSLQuery.GetColNames(Idx : Integer) : String;
begin
  Result := '';
  if Idx > fColCount-1 then Exit;
  Result := fFields.Items[Idx];
end;

function TSLQuery.GetColIndex(Name : String) : Integer;
var
 i : Integer;
begin
  Result := -1;
  for i:=0 to fColCount -1 do begin
    if StrEq(fFields.Items[i],Name) then Result := i;
  end;
end;

function TSLQuery.GetField(Idx : Integer) : String;
var
 i : Integer;
begin
Result := '';
if Idx > fColCount -1 then Exit;
i := Idx + fColCount*(fCurIndex + 1);
if i > fFields.Count-1 then Exit;
Result := fFields.Items[i];
end;

function TSLQuery.GetFieldByName(Name : String) : String;
var
 i,k : Integer;
begin
  Result := '';
  for i:=0 to fColCount -1  do begin
    if StrEq(fFields.Items[i],Name) then begin
        k := i + fColCount * (fCurIndex +1);
        if k < fFields.Count then Result := fFields.Items[k];
        break;
      end;
  end;
end;

procedure TSLQuery.SetCurIndex(const Value : Integer);
begin

    fCurIndex := Value;

    {Resultset is empty}
    if fRowCount = 0 then begin
    fEof := true;
    fBof := true;
    fCurIndex := 0;
    Exit;
    end;

    if Value <= 0 then
    begin
      fBof := true;
      fCurIndex := 0;
    end
    else
      fBof := false;


    if Value > (fRowCount-1) then
    begin
      fEof := true;
      fCurIndex := fRowCount -1;
    end
      else
        fEof := false;

     {Extend in future, allow to send notification to TDataSync object
     to synchronize all database controls (attached to TDataSync) to the same
     row position in resultset}
end;

procedure TSLQuery.First;
begin
  SetCurIndex(0);
end;

procedure TSLQuery.Last;
begin
  SetCurIndex(fRowCount-1);
end;

procedure TSLQuery.Next;
begin
  SetCurIndex(fCurIndex + 1);
end;

procedure TSLQuery.Prev;
begin
  SetCurIndex(fCurIndex-1);
end;



end.
