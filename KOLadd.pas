//[START OF KOL.pas]
{****************************************************************
                                                                    d       d
        KKKKK    KKKKK    OOOOOOOOO    LLLLL                        d       d
        KKKKK    KKKKK  OOOOOOOOOOOOO  LLLLL                        d       d
        KKKKK    KKKKK  OOOOO   OOOOO  LLLLL          aaaa          d       d
        KKKKK  KKKKK    OOOOO   OOOOO  LLLLL              a         d       d
        KKKKKKKKKK      OOOOO   OOOOO  LLLLL              a         d       d
        KKKKK  KKKKK    OOOOO   OOOOO  LLLLL          aaaaa    dddddd  dddddd
        KKKKK    KKKKK  OOOOO   OOOOO  LLLLL         a     a  d     d d     d
        KKKKK    KKKKK  OOOOOOOOOOOOO  LLLLLLLLLLLLL a     a  d     d d     d
        KKKKK    KKKKK    OOOOOOOOO    LLLLLLLLLLLLL  aaaaa aa dddddd  dddddd

  Key Objects Library (C) 2000 by Kladov Vladimir.

//[VERSION]
****************************************************************
* VERSION 2.04
****************************************************************
//[END OF VERSION]

The only reason why this part of KOL separated into another unit is that
Delphi has a restriction to DCU size exceeding which it is failed to debug
it normally and in attempt to execute code step by step an internal error
is occur which stops Delphi from working at all.

Version indicated above is a version of KOL, having place when KOLadd.pas was
modified last time, this is not a version of KOLadd itself.
}

unit KOLadd;

interface

{$I KOLDEF.INC}

uses Windows, KOL;

{------------------------------------------------------------------------------)
|                                                                              |
|                                  T L i s t E x                               |
|                                                                              |
(------------------------------------------------------------------------------}
type

//[TListEx DEFINITION]
  {++}(*TListEx = class;*){--}
  PListEx = {-}^{+}TListEx;
  TListEx = object( TObj )
  {* Extended list, with Objects[ ] property. Created calling NewListEx function. }
  protected
    fList: PList;
    fObjects: PList;
    function GetEx(Idx: Integer): Pointer;
    procedure PutEx(Idx: Integer; const Value: Pointer);
    function GetCount: Integer;
    function GetAddBy: Integer;
    procedure Set_AddBy(const Value: Integer);
  public
    destructor Destroy; {-}virtual;{+}{++}(*override;*){--}
    {* }
    property AddBy: Integer read GetAddBy write Set_AddBy;
    {* }
    property Items[ Idx: Integer ]: Pointer read GetEx write PutEx;
    {* }
    property Count: Integer read GetCount;
    {* }
    procedure Clear;
    {* }
    procedure Add( Value: Pointer );
    {* }
    procedure AddObj( Value, Obj: Pointer );
    {* }
    procedure Insert( Idx: Integer; Value: Pointer );
    {* }
    procedure InsertObj( Idx: Integer; Value, Obj: Pointer );
    {* }
    procedure Delete( Idx: Integer );
    {* }
    procedure DeleteRange( Idx, Len: Integer );
    {* }
    function IndexOf( Value: Pointer ): Integer;
    {* }
    function IndexOfObj( Obj: Pointer ): Integer;
    {* }
    procedure Swap( Idx1, Idx2: Integer );
    {* }
    procedure MoveItem( OldIdx, NewIdx: Integer );
    {* }
    property ItemsList: PList read fList;
    {* }
    property ObjList: PList read fObjects;
    {* }
    function Last: Pointer;
    {* }
    function LastObj: Pointer;
    {* }
  end;
//[END OF TListEx DEFINITION]

//[NewListEx DECLARATION]
function NewListEx: PListEx;
{* Creates extended list. }

{------------------------------------------------------------------------------)
|                                                                              |
|                                  T B i t s                                   |
|                                                                              |
(------------------------------------------------------------------------------}
type
//[TBits DEFINITION]
  {++}(*TBits = class;*){--}
  PBits = {-}^{+}TBits;
  TBits = object( TObj )
  {* Variable-length bits array object. Created using function NewBits. See also
     |<a href="kol_pas.htm#Small bit arrays (max 32 bits in array)">
     Small bit arrays (max 32 bits in array)
     |</a>. }
  protected
    fList: PList;
    fCount: Integer;
    function GetBit(Idx: Integer): Boolean;
    procedure SetBit(Idx: Integer; const Value: Boolean);
    function GetCapacity: Integer;
    function GetSize: Integer;
    procedure SetCapacity(const Value: Integer);
  public
    destructor Destroy; {-}virtual;{+}{++}(*override;*){--}
    {* }
    property Bits[ Idx: Integer ]: Boolean read GetBit write SetBit;
    {* }
    property Size: Integer read GetSize;
    {* Size in bytes of the array. To get know number of bits, use property Count. }
    property Count: Integer read fCount;
    {* Number of bits an the array. }
    property Capacity: Integer read GetCapacity write SetCapacity;
    {* Number of bytes allocated. Can be set before assigning bit values
       to improve performance (minimizing amount of memory allocation
       operations).  }
    function Copy( From, BitsCount: Integer ): PBits;
    {* Use this property to get a sub-range of bits starting from given bit
       and of BitsCount bits count. }
    function IndexOf( Value: Boolean ): Integer;
    {* Returns index of first bit with given value (True or False). }
    function OpenBit: Integer;
    {* Returns index of the first bit not set to true. }
    procedure Clear;
    {* Clears bits array. Count, Size and Capacity become 0. }
    function LoadFromStream( strm: PStream ): Integer;
    {* Loads bits from the stream. Data should be stored in the stream
       earlier using SaveToStream method. While loading, previous bits
       data are discarded and replaced with new one totally. In part,
       Count of bits also is changed. Count of bytes read from the stream
       while loading data is returned. }
    function SaveToStream( strm: PStream ): Integer;
    {* Saves entire array of bits to the stream. First, Count of bits
       in the array is saved, then all bytes containing bits data. }
    function Range( Idx, N: Integer ): PBits;
    {* Creates and returns new TBits object instance containing N bits
       starting from index Idx. If you call this method, you are responsible
       for destroying returned object when it become not neccessary. }
    procedure AssignBits( ToIdx: Integer; FromBits: PBits; FromIdx, N: Integer );
    {* Assigns bits from another bits array object. N bits are assigned
       starting at index ToIdx. }
  end;
//[END OF TBits DEFINITION]

//[NewBits DECLARATION]
function NewBits: PBits;
{* Creates variable-length bits array object. }

{------------------------------------------------------------------------------)
|                                                                              |
|                         T F a s t S t r L i s t                              |
|                                                                              |
(------------------------------------------------------------------------------}
type
  PFastStrListEx = ^TFastStrListEx;
  TFastStrListEx = object( TObj )
  private
    function GetItemLen(Idx: Integer): Integer;
    function GetObject(Idx: Integer): DWORD;
    procedure SetObject(Idx: Integer; const Value: DWORD);
    function GetValues(AName: PChar): PChar;
  protected
    procedure Init; virtual;
  protected
    fList: PList;
    fCount: Integer;
    fCaseSensitiveSort: Boolean;
    fTextBuf: PChar;
    fTextSiz: DWORD;
    fUsedSiz: DWORD;
  protected
    procedure ProvideSpace( AddSize: DWORD );
    function Get(Idx: integer): string;
    function GetTextStr: string;
    procedure Put(Idx: integer; const Value: string);
    procedure SetTextStr(const Value: string);
    function GetPChars( Idx: Integer ): PChar;
  {++}(*public*){--}
    destructor Destroy; {-}virtual;{+}{++}(*override;*){--}
  public
    function AddAnsi( const S: String ): Integer;
    {* Adds Ansi String to a list. }
    function AddAnsiObject( const S: String; Obj: DWORD ): Integer;
    {* Adds Ansi String and correspondent object to a list. }
    function Add(S: PChar): integer;
    {* Adds a string to list. }
    function AddLen(S: PChar; Len: Integer): integer;
    {* Adds a string to list. The string can contain #0 characters. }
  public
    FastClear: Boolean;
    {* }
    procedure Clear;
    {* Makes string list empty. }
    procedure Delete(Idx: integer);
    {* Deletes string with given index (it *must* exist). }
    function IndexOf(const S: string): integer;
    {* Returns index of first string, equal to given one. }
    function IndexOf_NoCase(const S: string): integer;
    {* Returns index of first string, equal to given one (while comparing it
       without case sensitivity). }
    function IndexOfStrL_NoCase( Str: PChar; L: Integer ): integer;
    {* Returns index of first string, equal to given one (while comparing it
       without case sensitivity). }
    function Find(const S: String; var Index: Integer): Boolean;
    {* Returns Index of the first string, equal or greater to given pattern, but
       works only for sorted TFastStrListEx object. Returns TRUE if exact string found,
       otherwise nearest (greater then a pattern) string index is returned,
       and the result is FALSE. }
    procedure InsertAnsi(Idx: integer; const S: String);
    {* Inserts ANSI string before one with given index. }
    procedure InsertAnsiObject(Idx: integer; const S: String; Obj: DWORD);
    {* Inserts ANSI string before one with given index. }
    procedure Insert(Idx: integer; S: PChar);
    {* Inserts string before one with given index. }
    procedure InsertLen( Idx: Integer; S: PChar; Len: Integer );
    {* Inserts string from given PChar. It can contain #0 characters. }
    function LoadFromFile(const FileName: string): Boolean;
    {* Loads string list from a file. (If file does not exist, nothing
       happens). Very fast even for huge text files. }
    procedure LoadFromStream(Stream: PStream; Append2List: boolean);
    {* Loads string list from a stream (from current position to the end of
       a stream). Very fast even for huge text. }
    procedure MergeFromFile(const FileName: string);
    {* Merges string list with strings in a file. Fast. }
    procedure Move(CurIndex, NewIndex: integer);
    {* Moves string to another location. }
    procedure SetText(const S: string; Append2List: boolean);
    {* Allows to set strings of string list from given string (in which
       strings are separated by $0D,$0A or $0D characters). Text can
       contain #0 characters. Works very fast. This method is used in
       all others, working with text arrays (LoadFromFile, MergeFromFile,
       Assign, AddStrings). }
    function SaveToFile(const FileName: string): Boolean;
    {* Stores string list to a file. }
    procedure SaveToStream(Stream: PStream);
    {* Saves string list to a stream (from current position). }
    function AppendToFile(const FileName: string): Boolean;
    {* Appends strings of string list to the end of a file. }
    property Count: integer read fCount;
    {* Number of strings in a string list. }
    property Items[Idx: integer]: string read Get write Put; default;
    {* Strings array items. If item does not exist, empty string is returned.
       But for assign to property, string with given index *must* exist. }
    property ItemPtrs[ Idx: Integer ]: PChar read GetPChars;
    {* Fast access to item strings as PChars. }
    property ItemLen[ Idx: Integer ]: Integer read GetItemLen;
    {* Length of string item. }
    function Last: String;
    {* Last item (or '', if string list is empty). }
    property Text: string read GetTextStr write SetTextStr;
    {* Content of string list as a single string (where strings are separated
       by characters $0D,$0A). }
    procedure Swap( Idx1, Idx2 : Integer );
    {* Swaps to strings with given indeces. }
    procedure Sort( CaseSensitive: Boolean );
    {* Call it to sort string list. }
  public
    function AddObject( S: PChar; Obj: DWORD ): Integer;
    {* Adds string S (null-terminated) with associated object Obj. }
    function AddObjectLen( S: PChar; Len: Integer; Obj: DWORD ): Integer;
    {* Adds string S of length Len with associated object Obj. }
    procedure InsertObject( Idx: Integer; S: PChar; Obj: DWORD );
    {* Inserts string S (null-terminated) at position Idx in the list,
       associating it with object Obj. }
    procedure InsertObjectLen( Idx: Integer; S: PChar; Len: Integer; Obj: DWORD );
    {* Inserts string S of length Len at position Idx in the list,
       associating it with object Obj. }
    property Objects[ Idx: Integer ]: DWORD read GetObject write SetObject;
    {* Access to objects associated with strings in the list. }
  public
    procedure Append( S: PChar );
    {* Appends S (null-terminated) to the last string in FastStrListEx object, very fast. }
    procedure AppendLen( S: PChar; Len: Integer );
    {* Appends S of length Len to the last string in FastStrListEx object, very fast. }
    procedure AppendInt2Hex( N: DWORD; MinDigits: Integer );
    {* Converts N to hexadecimal and appends resulting string to the last
       string, very fast. }
  public
    property Values[ Name: PChar ]: PChar read GetValues;
    {* Returns a value correspondent to the Name an ini-file-like string list
       (having Name1=Value1 Name2=Value2 etc. in each string). }
    function IndexOfName( AName: PChar ): Integer;
    {* Searches string starting from 'AName=' in string list like ini-file. }
  end;

function NewFastStrListEx: PFastStrListEx;
         {* Creates FastStrListEx object. }

var Upper: array[ Char ] of Char;
    {* An table to convert char to uppercase very fast. First call InitUpper. }

    Upper_Initialized: Boolean;
procedure InitUpper;
          {* Call this fuction ones to fill Upper[ ] table before using it. }

//[TWStrList]

{-}
{$IFNDEF _FPC}
procedure WStrCopy( Dest, Src: PWideChar );
{* Copies null-terminated Unicode string (terminated null also copied). }
function WStrCmp( W1, W2: PWideChar ): Integer;
{* Compares two null-terminated Unicode strings. }
{$ENDIF _FPC}

{$IFNDEF _D2} //------------------ WideString is not supported in D2 -----------

type
  PWStrList = ^TWstrList;
  {* }
//[TWstrList DEFINITION]
  TWStrList = object( TObj )
  {* String list to store Unicode (null-terminated) strings. }
  protected
    function GetCount: Integer;
    function GetItems(Idx: Integer): WideString;
    procedure SetItems(Idx: Integer; const Value: WideString);
    function GetPtrs(Idx: Integer): PWideChar;
    function GetText: WideString;
  protected
    fList: PList;
    fText: PWideChar;
    fTextBufSz: Integer;
    fTmp1, fTmp2: WideString;
    procedure Init; virtual;
  public
    procedure SetText(const Value: WideString);
    {* See also TStrList.SetText }
    destructor Destroy; virtual;
    {* }
    procedure Clear;
    {* See also TStrList.Clear }
    property Items[ Idx: Integer ]: WideString read GetItems write SetItems;
    {* See also TStrList.Items }
    property ItemPtrs[ Idx: Integer ]: PWideChar read GetPtrs;
    {* See also TStrList.ItemPtrs }
    property Count: Integer read GetCount;
    {* See also TStrList.Count }
    function Add( const W: WideString ): Integer;
    {* See also TStrList.Add }
    procedure Insert( Idx: Integer; const W: WideString );
    {* See also TStrList.Insert }
    procedure Delete( Idx: Integer );
    {* See also TStrList.Delete }
    property Text: WideString read GetText write SetText;
    {* See also TStrList.Text }
    procedure AddWStrings( WL: PWStrList );
    {* See also TStrList.AddStrings }
    procedure Assign( WL: PWStrList );
    {* See also TStrList.Assign }
    function LoadFromFile( const Filename: String ): Boolean;
    {* See also TStrList.LoadFromFile }
    procedure LoadFromStream( Strm: PStream );
    {* See also TStrList.LoadFromStream }
    function MergeFromFile( const Filename: String ): Boolean;
    {* See also TStrList.MergeFromFile }
    procedure MergeFromStream( Strm: PStream );
    {* See also TStrList.MergeFromStream }
    function SaveToFile( const Filename: String ): Boolean;
    {* See also TStrList.SaveToFile }
    procedure SaveToStream( Strm: PStream );
    {* See also TStrList.SaveToStream }
    function AppendToFile( const Filename: String ): Boolean;
    {* See also TStrList.AppendToFile }
    procedure Swap( Idx1, Idx2: Integer );
    {* See also TStrList.Swap }
    procedure Sort( CaseSensitive: Boolean );
    {* See also TStrList.Sort }
    procedure Move( IdxOld, IdxNew: Integer );
    {* See also TStrList.Move }
  end;
//[END OF TWStrList DEFINITION]

//[TWStrListEx]
  PWStrListEx = ^TWStrListEx;

//[TWStrListEx DEFINITION]
  TWStrListEx = object( TWStrList )
  {* Extended Unicode string list (with Objects). }
  protected
    function GetObjects(Idx: Integer): DWORD;
    procedure SetObjects(Idx: Integer; const Value: DWORD);
    procedure ProvideObjectsCapacity( NewCap: Integer );
  protected
    fObjects: PList;
    procedure Init; virtual;
  public
    destructor Destroy; virtual;
    {* }
    property Objects[ Idx: Integer ]: DWORD read GetObjects write SetObjects;
    {* }
    procedure AddWStrings( WL: PWStrListEx );
    {* }
    procedure Assign( WL: PWStrListEx );
    {* }
    procedure Clear;
    {* }
    procedure Delete( Idx: Integer );
    {* }
    procedure Move( IdxOld, IdxNew: Integer );
    {* }
    function AddObject( const S: WideString; Obj: DWORD ): Integer;
    {* Adds a string and associates given number with it. Index of the item added
       is returned. }
    procedure InsertObject( Before: Integer; const S: WideString; Obj: DWORD );
    {* Inserts a string together with object associated. }
    function IndexOfObj( Obj: Pointer ): Integer;
    {* Returns an index of a string associated with the object passed as a
       parameter. If there are no such strings, -1 is returned. }
  end;
//[END OF TWStrListEx DEFINITION]

//[NewWStrList DECLARATION]
function NewWStrList: PWStrList;
{* Creates new TWStrList object and returns a pointer to it. }

//[NewWStrListEx DECLARATION]
function NewWStrListEx: PWStrListEx;
{* Creates new TWStrListEx objects and returns a pointer to it. }

{$ENDIF}

//[CABINET FILES OBJECT]
type
  {++}(*TCabFile = class;*){--}
  PCABFile = {-}^{+}TCABFile;

  TOnNextCAB = function( Sender: PCABFile ): String of object;
  TOnCABFile = function( Sender: PCABFile; var FileName: String ): Boolean of object;

{ ----------------------------------------------------------------------

                TCabFile - windows cabinet files

----------------------------------------------------------------------- }
//[TCabFile DEFINITION]
  TCABFile = object( TObj )
  {* An object to simplify extracting files from a cabinet (.CAB) files.
     The only what need to use this object, setupapi.dll. It is provided
     with all latest versions of Windows. }
  protected
    FPaths: PStrList;
    FNames: PStrList;
    FOnNextCAB: TOnNextCAB;
    FOnFile: TOnCABFile;
    FTargetPath: String;
    FSetupapi: THandle;
    function GetNames(Idx: Integer): String;
    function GetCount: Integer;
    function GetPaths(Idx: Integer): String;
    function GetTargetPath: String;
  protected
    FGettingNames: Boolean;
    FCurCAB: Integer;
  public
    destructor Destroy; {-}virtual;{+}{++}(*override;*){--}
    {* }
    property Paths[ Idx: Integer ]: String read GetPaths;
    {* A list of CAB-files. It is stored, when constructing function
       OpenCABFile called. }
    property Names[ Idx: Integer ]: String read GetNames;
    {* A list of file names, stored in a sequence of CAB files. To get know,
       how many files are there, check Count property. }
    property Count: Integer read GetCount;
    {* Number of files stored in a sequence of CAB files. }
    function Execute: Boolean;
    {* Call this method to extract or enumerate files in CAB. For every
       file, found during executing, event OnFile is alled (if assigned).
       If the event handler (if any) does not provide full target path for
       a file to extract to, property TargetPath is applyed (also if it
       is assigned), or file is extracted to the default directory (usually
       the same directory there CAB file is located, or current directory
       - by a decision of the system).
       |<br>
       If a sequence of CAB files is used, and not all names for CAB files
       are provided (absent or represented by a string '?' ), an event
       OnNextCAB is called to obtain the name of the next CAB file.}
    property CurCAB: Integer read FCurCAB;
    {* Index of current CAB file in a sequence of CAB files. When OnNextCAB
       event is called (if any), CurCAB property is already set to the
       index of path, what should be provided. }
    property OnNextCAB: TOnNextCAB read FOnNextCAB write FOnNextCAB;
    {* This event is called, when a series of CAB files is needed and not
       all CAB file names are provided (absent or represented by '?' string).
       If this event is not assigned, the user is prompted to browse file. }
    property OnFile: TOnCABFile read FOnFile write FOnFile;
    {* This event is called for every file found during Execute method.
       In an event handler (if any assigned), it is possible to return
       False to skip file, or to provide another full target path for
       file to extract it to, then default. If the event is not assigned,
       all files are extracted either to default directory, or to the
       directory TargetPath, if it is provided. }
    property TargetPath: String read GetTargetPath write FTargetPath;
    {* Optional target directory to place there extracted files. }
  end;
//[END OF TCABFile DEFINITION]

//[OpenCABFile DECLARATION]
function OpenCABFile( const APaths: array of String ): PCABFile;
{* This function creates TCABFile object, passing a sequence of CAB file names
   (fully qualified). It is possible not to provide all names here, or pass '?'
   string in place of some of those. For such files, either an event OnNextCAB
   will be called, or (and) user will be prompted to browse file during
   executing (i.e. Extracting). }

//[DIRCHANGE]
type
  {++}(*TDirChange = class;*){--}
  PDirChange = {-}^{+}TDirChange;
  {* }

  TOnDirChange = procedure (Sender: PDirChange; const Path: string) of object;
  {* Event type to define OnChange event for folder monitoring objects. }

  TFileChangeFilters = (fncFileName, fncDirName, fncAttributes, fncSize,
      fncLastWrite, fncLastAccess, fncCreation, fncSecurity);
  {* Possible change monitor filters. }
  TFileChangeFilter = set of TFileChangeFilters;
  {* Set of filters to pass to a constructor of TDirChange object. }

{ ----------------------------------------------------------------------

                          TDirChange object

----------------------------------------------------------------------- }
//[TDirChange DEFINITION]
  TDirChange = object(TObj)
  {* Object type to monitor changes in certain folder. }
  protected
    FOnChange: TOnDirChange;
    FHandle: THandle;
    FPath: string;
    FMonitor: PThread;
    function Execute( Sender: PThread ): Integer;
    procedure Changed;
  protected
  {++}(*public*){--}
    destructor Destroy; {-}virtual;{+}{++}(*override;*){--}
    {*}
  public
    property Handle: THandle read FHandle;
    {* Handle of file change notification object. *}
    property Path: String read FPath; //write SetPath;
    {* Path to monitored folder (to a root, if tree of folders
       is under monitoring). }
  end;
//[END OF TDirChange DEFINITION]

//[NewDirChangeNotifier DECLARATION]
function NewDirChangeNotifier( const Path: String; Filter: TFileChangeFilter;
                               WatchSubtree: Boolean; ChangeProc: TOnDirChange ): PDirChange;
{* Creates notification object TDirChangeNotifier. If something wrong (e.g.,
   passed directory does not exist), nil is returned as a result. When change
   is notified, ChangeProc is called always in main thread context.
   (Please note, that ChangeProc can not be nil).
   If empty filter is passed, default filter is used:
   [fncFileName..fncLastWrite]. }

//[METAFILES]

type
  {++}(*TMetafile = class;*){--}
  PMetafile = {-}^{+}TMetafile;
{ ----------------------------------------------------------------------

      TMetafile - Windows metafile and Enchanced Metafile image

----------------------------------------------------------------------- }
//[TMetafile DEFINITION]
  TMetafile = object( TObj )
  {* Object type to incapsulate metafile image. }
  protected
    function GetHeight: Integer;
    function GetWidth: Integer;
    procedure SetHandle(const Value: THandle);
  protected
    fHandle: THandle;
    fHeader: PEnhMetaHeader;
    procedure RetrieveHeader;
  public
    destructor Destroy; {-}virtual;{+}{++}(*override;*){--}
    {* }
    procedure Clear;
    {* }
    function Empty: Boolean;
    {* Returns TRUE if empty}
    property Handle: THandle read fHandle write SetHandle;
    {* Returns handle of enchanced metafile. }
    function LoadFromStream( Strm: PStream ): Boolean;
    {* Loads emf or wmf file format from stream. }
    function LoadFromFile( const Filename: String ): Boolean;
    {* Loads emf or wmf from stream. }
    procedure Draw( DC: HDC; X, Y: Integer );
    {* Draws enchanced metafile on DC. }
    procedure StretchDraw( DC: HDC; const R: TRect );
    {* Draws enchanced metafile stretched. }
    property Width: Integer read GetWidth;
    {* Native width of the metafile. }
    property Height: Integer read GetHeight;
    {* Native height of the metafile. }
  end;
//[END OF TMetafile DEFINITION]

//[NewMetafile DECLARATION]
function NewMetafile: PMetafile;
{* Creates metafile object. }

//[Metafile CONSTANTS, STRUCTURES, ETC.]
const
  WMFKey = Integer($9AC6CDD7);
  WMFWord = $CDD7;
type
  TMetafileHeader = packed record
    Key: Longint;
    Handle: SmallInt;
    Box: TSmallRect;
    Inch: Word;
    Reserved: Longint;
    CheckSum: Word;
  end;

function ComputeAldusChecksum(var WMF: TMetafileHeader): Word;

{++}(*
function SetEnhMetaFileBits(p1: UINT; p2: PChar): HENHMETAFILE; stdcall;
function PlayEnhMetaFile(DC: HDC; p2: HENHMETAFILE; const p3: TRect): BOOL; stdcall;
*){--}

// NewActionList, TAction - by Yury Sidorov
//[ACTIONS OBJECT]
{ ----------------------------------------------------------------------

                TAction and TActionList

----------------------------------------------------------------------- }
type
  PControlRec = ^TControlRec;
  TOnUpdateCtrlEvent = procedure(Sender: PControlRec) of object;

  TCtrlKind = (ckControl, ckMenu, ckToolbar);
  TControlRec = record
    Ctrl: PObj;
    CtrlKind: TCtrlKind;
    ItemID: integer;
    UpdateProc: TOnUpdateCtrlEvent;
  end;

  {++}(* TAction = class;*){--}
  PAction = {-}^{+}TAction;

  {++}(* TActionList = class;*){--}
  PActionList = {-}^{+}TActionList;

//[TAction DEFINITION]
  TAction = {-} object( TObj ) {+}{++}(*class*){--}
  {*! Use action objects, in conjunction with action lists, to centralize the response
      to user commands (actions).
      Use AddControl, AddMenuItem, AddToolbarButton methods to link controls to an action.
      See also TActionList.
      }
  protected
    FControls: PList;
    FCaption: string;
    FChecked: boolean;
    FVisible: boolean;
    FEnabled: boolean;
    FHelpContext: integer;
    FHint: string;
    FOnExecute: TOnEvent;
    FAccelerator: TMenuAccelerator;
    FShortCut: string;
    procedure DoOnMenuItem(Sender: PMenu; Item: Integer);
    procedure DoOnToolbarButtonClick(Sender: PControl; BtnID: Integer);
    procedure DoOnControlClick(Sender: PObj);

    procedure SetCaption(const Value: string);
    procedure SetChecked(const Value: boolean);
    procedure SetEnabled(const Value: boolean);
    procedure SetHelpContext(const Value: integer);
    procedure SetHint(const Value: string);
    procedure SetVisible(const Value: boolean);
    procedure SetAccelerator(const Value: TMenuAccelerator);
    procedure UpdateControls;

    procedure LinkCtrl(ACtrl: PObj; ACtrlKind: TCtrlKind; AItemID: integer; AUpdateProc: TOnUpdateCtrlEvent);
    procedure SetOnExecute(const Value: TOnEvent);

    procedure UpdateCtrl(Sender: PControlRec);
    procedure UpdateMenu(Sender: PControlRec);
    procedure UpdateToolbar(Sender: PControlRec);

  public
    destructor Destroy; {-}virtual;{+}{++}(*override;*){--}
    procedure LinkControl(Ctrl: PControl);
    {* Add a link to a TControl or descendant control. }
    procedure LinkMenuItem(Menu: PMenu; MenuItemIdx: integer);
    {* Add a link to a menu item. }
    procedure LinkToolbarButton(Toolbar: PControl; ButtonIdx: integer);
    {* Add a link to a toolbar button. }
    procedure Execute;
    {* Executes a OnExecute event handler. }
    property Caption: string read FCaption write SetCaption;
    {* Text caption. }
    property Hint: string read FHint write SetHint;
    {* Hint (tooltip). Currently used for toolbar buttons only. }
    property Checked: boolean read FChecked write SetChecked;
    {* Checked state. }
    property Enabled: boolean read FEnabled write SetEnabled;
    {* Enabled state. }
    property Visible: boolean read FVisible write SetVisible;
    {* Visible state. }
    property HelpContext: integer read FHelpContext write SetHelpContext;
    {* Help context. }
    property Accelerator: TMenuAccelerator read FAccelerator write SetAccelerator;
    {* Accelerator for menu items. }
    property OnExecute: TOnEvent read FOnExecute write SetOnExecute;
    {* This event is executed when user clicks on a linked object or Execute method was called. }
  end;
//[END OF TAction DEFINITION]

//[TActionList DEFINITION]
  TActionList = {-} object( TObj ) {+}{++}(*class*){--}
  {*! TActionList maintains a list of actions used with components and controls,
     such as menu items and buttons.
     Action lists are used, in conjunction with actions, to centralize the response
     to user commands (actions).
     Write an OnUpdateActions handler to update actions state.
     Created using function NewActionList.
     See also TAction.
  }
  protected
    FOwner: PControl;
    FActions: PList;
    FOnUpdateActions: TOnEvent;
    function GetActions(Idx: integer): PAction;
    function GetCount: integer;
  protected
    procedure DoUpdateActions(Sender: PObj);
  public
    destructor Destroy; {-}virtual;{+}{++}(*override;*){--}
    function Add(const ACaption, AHint: string; OnExecute: TOnEvent): PAction;
    {* Add a new action to the list. Returns pointer to action object. }
    procedure Delete(Idx: integer);
    {* Delete action by index from list. }
    procedure Clear;
    {* Clear all actions in the list. }
    property Actions[Idx: integer]: PAction read GetActions;
    {* Access to actions in the list. }
    property Count: integer read GetCount;
    {* Number of actions in the list.. }
    property OnUpdateActions: TOnEvent read FOnUpdateActions write FOnUpdateActions;
    {* Event handler to update actions state. This event is called each time when application
      goes in the idle state (no messages in the queue). }
  end;
//[END OF TActionList DEFINITION]

//[NewActionList DECLARATION]
function NewActionList(AOwner: PControl): PActionList;
{* Action list constructor. AOwner - owner form. }


implementation

type
  PCrackList = ^TCrackList;
  TCrackList = object( TList )
  end;

{------------------------------------------------------------------------------)
|                                                                              |
|                                  T L i s t E x                               |
|                                                                              |
(------------------------------------------------------------------------------}
{ TListEx }

//[function NewListEx]
function NewListEx: PListEx;
begin
  {-}
  new( Result, Create );
  {+}{++}(*Result := PListEx.Create;*){--}
  Result.fList := NewList;
  Result.fObjects := NewList;
end;
//[END NewListEx]

//[procedure TListEx.Add]
procedure TListEx.Add(Value: Pointer);
begin
  AddObj( Value, nil );
end;

//[procedure TListEx.AddObj]
procedure TListEx.AddObj(Value, Obj: Pointer);
var C: Integer;
begin
  C := Count;
  fList.Add( Value );
  fObjects.Insert( C, Obj );
end;

//[procedure TListEx.Clear]
procedure TListEx.Clear;
begin
  fList.Clear;
  fObjects.Clear;
end;

//[procedure TListEx.Delete]
procedure TListEx.Delete(Idx: Integer);
begin
  DeleteRange( Idx, 1 );
end;

//[procedure TListEx.DeleteRange]
procedure TListEx.DeleteRange(Idx, Len: Integer);
begin
  fList.DeleteRange( Idx, Len );
  fObjects.DeleteRange( Idx, Len );
end;

//[destructor TListEx.Destroy]
destructor TListEx.Destroy;
begin
  fList.Free;
  fObjects.Free;
  inherited;
end;

//[function TListEx.GetAddBy]
function TListEx.GetAddBy: Integer;
begin
  Result := fList.AddBy;
end;

//[function TListEx.GetCount]
function TListEx.GetCount: Integer;
begin
  Result := fList.Count;
end;

//[function TListEx.GetEx]
function TListEx.GetEx(Idx: Integer): Pointer;
begin
  Result := fList.Items[ Idx ];
end;

//[function TListEx.IndexOf]
function TListEx.IndexOf(Value: Pointer): Integer;
begin
  Result := fList.IndexOf( Value );
end;

//[function TListEx.IndexOfObj]
function TListEx.IndexOfObj(Obj: Pointer): Integer;
begin
  Result := fObjects.IndexOf( Obj );
end;

//[procedure TListEx.Insert]
procedure TListEx.Insert(Idx: Integer; Value: Pointer);
begin
  InsertObj( Idx, Value, nil );
end;

//[procedure TListEx.InsertObj]
procedure TListEx.InsertObj(Idx: Integer; Value, Obj: Pointer);
begin
  fList.Insert( Idx, Value );
  fObjects.Insert( Idx, Obj );
end;

//[function TListEx.Last]
function TListEx.Last: Pointer;
begin
  Result := fList.Last;
end;

//[function TListEx.LastObj]
function TListEx.LastObj: Pointer;
begin
  Result := fObjects.Last;
end;

//[procedure TListEx.MoveItem]
procedure TListEx.MoveItem(OldIdx, NewIdx: Integer);
begin
  fList.MoveItem( OldIdx, NewIdx );
  fObjects.MoveItem( OldIdx, NewIdx );
end;

//[procedure TListEx.PutEx]
procedure TListEx.PutEx(Idx: Integer; const Value: Pointer);
begin
  fList.Items[ Idx ] := Value;
end;

//[procedure TListEx.Set_AddBy]
procedure TListEx.Set_AddBy(const Value: Integer);
begin
  fList.AddBy := Value;
  fObjects.AddBy := Value;
end;

//[procedure TListEx.Swap]
procedure TListEx.Swap(Idx1, Idx2: Integer);
begin
  fList.Swap( Idx1, Idx2 );
  fObjects.Swap( Idx1, Idx2 );
end;

{------------------------------------------------------------------------------)
|                                                                              |
|                                  T B i t s                                   |
|                                                                              |
(------------------------------------------------------------------------------}
{ TBits }

//[function NewBits]
function NewBits: PBits;
begin
  {-}
  new( Result, Create );
  {+}{++}(*Result := PBits.Create;*){--}
  Result.fList := NewList;
  //Result.fList.fAddBy := 1;
end;

//[procedure TBits.AssignBits]
procedure TBits.AssignBits(ToIdx: Integer; FromBits: PBits; FromIdx,
  N: Integer);
var i: Integer;
    NewCount: Integer;
begin
  if FromIdx >= FromBits.Count then Exit;
  if FromIdx + N > FromBits.Count then
    N := FromBits.Count - FromIdx;
  Capacity := (ToIdx + N + 8) div 8;
  NewCount := Max( Count, ToIdx + N - 1 );
  fCount := Max( NewCount, fCount );
  PCrackList( fList ).fCount := (Capacity + 3) div 4;
  while ToIdx and $1F <> 0 do
  begin
    Bits[ ToIdx ] := FromBits.Bits[ FromIdx ];
    Inc( ToIdx );
    Inc( FromIdx );
    Dec( N );
    if N = 0 then Exit;
  end;
  Move( PByte( Integer( PCrackList( FromBits.fList ).fItems ) + (FromIdx + 31) div 32 )^,
        PByte( Integer( PCrackList( fList ).fItems ) + ToIdx div 32 )^, (N + 31) div 32 );
  FromIdx := FromIdx and $1F;
  if FromIdx <> 0 then
  begin // shift data by (Idx and $1F) bits right
    for i := ToIdx div 32 to fList.Count-2 do
      fList.Items[ i ] := Pointer(
        (DWORD( fList.Items[ i ] ) shr FromIdx) or
        (DWORD( fList.Items[ i+1 ] ) shl (32 - FromIdx))
        );
    fList.Items[ fList.Count-1 ] := Pointer(
      DWORD( fList.Items[ fList.Count-1 ] ) shr FromIdx
      );
  end;
end;

//[function TBits.Copy]
procedure TBits.Clear;
begin
  fCount := 0;
  fList.Clear;
end;

function TBits.Copy(From, BitsCount: Integer): PBits;
var Shift, N: Integer;
    FirstItemPtr: Pointer;
begin
  Result := NewBits;
  if BitsCount = 0 then Exit;
  Result.Capacity := BitsCount + 32;
  Result.fCount := BitsCount;
  Move( PCrackList( fList ).fItems[ From shr 5 ],
        PCrackList( Result.fList ).fItems[ 0 ], (Count + 31) div 32 );
  Shift := From and $1F;
  if Shift <> 1 then
  begin
    N := (BitsCount + 31) div 32;
    FirstItemPtr := @ PCrackList( Result.fList ).fItems[ N - 1 ];
    asm
          PUSH  ESI
          PUSH  EDI
          MOV   ESI, FirstItemPtr
          MOV   EDI, ESI
          STD
          MOV   ECX, N
          XOR   EAX, EAX
          CDQ
    @@1:
          PUSH  ECX
          LODSD
          MOV   ECX, Shift
          SHRD  EAX, EDX, CL
          STOSD
          SUB   ECX, 32
          NEG   ECX
          SHR   EDX, CL
          POP   ECX

          LOOP  @@1

          CLD
          POP   EDI
          POP   ESI
    end {$IFDEF F_P} ['EAX','EDX','ECX'] {$ENDIF};
  end;
end;

//[destructor TBits.Destroy]
destructor TBits.Destroy;
begin
  fList.Free;
  inherited;
end;

//[function TBits.GetBit]
{$IFDEF ASM_VERSION}
function TBits.GetBit(Idx: Integer): Boolean;
asm
  CMP  EDX, [EAX].FCount
  JL   @@1
  XOR  EAX, EAX
  RET
@@1:
  MOV  EAX, [EAX].fList
  {TEST EAX, EAX
  JZ   @@exit}
  MOV  EAX, [EAX].TList.fItems
  BT   [EAX], EDX
  SETC AL
@@exit:
end;
{$ELSE}
function TBits.GetBit(Idx: Integer): Boolean;
begin
  if (Idx >= Count) {or (PCrackList( fList ).fItems = nil)} then Result := FALSE else
  Result := ( ( DWORD( PCrackList( fList ).fItems[ Idx shr 5 ] ) shr (Idx and $1F)) and 1 ) <> 0;
end;
{$ENDIF}

//[function TBits.GetCapacity]
function TBits.GetCapacity: Integer;
begin
  Result := fList.Capacity * 32;
end;

//[function TBits.GetSize]
function TBits.GetSize: Integer;
begin
  Result := ( PCrackList( fList ).fCount + 3) div 4;
end;

{$IFDEF ASM_noVERSION}
//[function TBits.IndexOf]
function TBits.IndexOf(Value: Boolean): Integer;
asm     //cmd    //opd
        PUSH     EDI
        MOV      EDI, [EAX].fList
        MOV      ECX, [EDI].TList.fCount
@@ret_1:
        OR       EAX, -1
        JECXZ    @@ret_EAX
        MOV      EDI, [EDI].TList.fItems
        TEST     DL, DL
        MOV      EDX, EDI
        JE       @@of_false
        INC      EAX
        REPZ     SCASD
        JE       @@ret_1
        MOV      EAX, [EDI-4]
        NOT      EAX
        JMP      @@calc_offset
        BSF      EAX, EAX
        SUB      EDI, EDX
        SHR      EDI, 2
        ADD      EAX, EDI
        JMP      @@ret_EAX
@@of_false:
        REPE     SCASD
        JE       @@ret_1
        MOV      EAX, [EDI-4]
@@calc_offset:
        BSF      EAX, EAX
        DEC      EAX
        SUB      EDI, 4
        SUB      EDI, EDX
        SHL      EDI, 3
        ADD      EAX, EDI
@@ret_EAX:
        POP      EDI
end;
{$ELSE ASM_VERSION} //Pascal
function TBits.IndexOf(Value: Boolean): Integer;
var I: Integer;
    D: DWORD;
begin
  Result := -1;
  if Value then
  begin
    for I := 0 to fList.Count-1 do
    begin
      D := DWORD( PCrackList( fList ).fItems[ I ] );
      if D <> 0 then
      begin
        asm
          MOV  EAX, D
          BSF  EAX, EAX
          MOV  D, EAX
        end {$IFDEF F_P} [ 'EAX' ] {$ENDIF};
        Result := I * 32 + Integer( D );
        break;
      end;
    end;
  end
    else
  begin
    for I := 0 to PCrackList( fList ).fCount-1 do
    begin
      D := DWORD( PCrackList( fList ).fItems[ I ] );
      if D <> $FFFFFFFF then
      begin
        asm
          MOV  EAX, D
          NOT  EAX
          BSF  EAX, EAX
          MOV  D, EAX
        end {$IFDEF F_P} [ 'EAX' ] {$ENDIF};
        Result := I * 32 + Integer( D );
        break;
      end;
    end;
  end;
end;
{$ENDIF ASM_VERSION}

//[function TBits.LoadFromStream]
function TBits.LoadFromStream(strm: PStream): Integer;
var
 i: Integer;
begin
 Result := strm.Read( i, 4 );
 if Result < 4 then Exit;
 
 bits[ i]:= false; //by miek
 fcount:= i;

 i := (i + 7) div 8;
 Inc( Result, strm.Read( PCrackList( fList ).fItems^, i ) );
end;

//[function TBits.OpenBit]
function TBits.OpenBit: Integer;
begin
  Result := IndexOf( FALSE );
  if Result < 0 then Result := Count;
end;

//[function TBits.Range]
function TBits.Range(Idx, N: Integer): PBits;
begin
  Result := NewBits;
  Result.AssignBits( 0, @ Self, Idx, N );
end;

//[function TBits.SaveToStream]
function TBits.SaveToStream(strm: PStream): Integer;
begin
  Result := strm.Write( fCount, 4 );
  if fCount = 0 then Exit;
  Inc( Result, strm.Write( PCrackList( fList ).fItems^, (fCount + 7) div 8 ) );
end;

//[procedure TBits.SetBit]
{$IFDEF ASM_VERSION}
procedure TBits.SetBit(Idx: Integer; const Value: Boolean);
asm
  PUSH ECX
  MOV  ECX, [EAX].fList
  MOV  ECX, [ECX].TList.fCapacity
  SHL  ECX, 5
  CMP  EDX, ECX
  JLE  @@1

  PUSH EDX
  INC  EDX
  PUSH EAX
  CALL SetCapacity
  POP  EAX
  POP  EDX

@@1:
  CMP  EDX, [EAX].FCount
  JL   @@2
  INC  EDX
  MOV  [EAX].fCount, EDX
  DEC  EDX
@@2:
  POP  ECX
  MOV  EAX, [EAX].fList
  MOV  EAX, [EAX].TList.fItems
  SHR  ECX, 1
  JC   @@2set
  BTR  [EAX], EDX
  JMP  @@exit
@@2set:
  BTS  [EAX], EDX
@@exit:
end;
{$ELSE}
procedure TBits.SetBit(Idx: Integer; const Value: Boolean);
var Msk: DWORD;
begin
  if Idx >= Capacity then
    Capacity := Idx + 1;
  Msk := 1 shl (Idx and $1F);
  if Value then
    PCrackList( fList ).fItems[ Idx shr 5 ] := Pointer(
                  DWORD(PCrackList( fList ).fItems[ Idx shr 5 ]) or Msk)
  else
    PCrackList( fList ).fItems[ Idx shr 5 ] := Pointer(
                  DWORD(PCrackList( fList ).fItems[ Idx shr 5 ]) and not Msk);
  if Idx >= fCount then
    fCount := Idx + 1;
end;
{$ENDIF}

//[procedure TBits.SetCapacity]
procedure TBits.SetCapacity(const Value: Integer);
var OldCap: Integer;
begin
  OldCap := fList.Capacity;
  fList.Capacity := (Value + 31) div 32;
  if OldCap < fList.Capacity then
    FillChar( PChar( Integer( PCrackList( fList ).fItems ) + OldCap * Sizeof( Pointer ) )^,
              (fList.Capacity - OldCap) * sizeof( Pointer ), 0 );
end;

{------------------------------------------------------------------------------)
|                                                                              |
|                         T F a s t S t r L i s t                              |
|                                                                              |
(------------------------------------------------------------------------------}

function NewFastStrListEx: PFastStrListEx;
begin
  new( Result, Create );
end;

procedure InitUpper;
var c: Char;
begin
  for c := #0 to #255 do
    Upper[ c ] := AnsiUpperCase( c + #0 )[ 1 ];
  Upper_Initialized := TRUE;
end;

{ TFastStrListEx }

function TFastStrListEx.AddAnsi(const S: String): Integer;
begin
  Result := AddObjectLen( PChar( S ), Length( S ), 0 );
end;

function TFastStrListEx.AddAnsiObject(const S: String; Obj: DWORD): Integer;
begin
  Result := AddObjectLen( PChar( S ), Length( S ), Obj );
end;

function TFastStrListEx.Add(S: PChar): integer;
begin
  Result := AddObjectLen( S, StrLen( S ), 0 )
end;

function TFastStrListEx.AddLen(S: PChar; Len: Integer): integer;
begin
  Result := AddObjectLen( S, Len, 0 )
end;

function TFastStrListEx.AddObject(S: PChar; Obj: DWORD): Integer;
begin
  Result := AddObjectLen( S, StrLen( S ), Obj )
end;

function TFastStrListEx.AddObjectLen(S: PChar; Len: Integer; Obj: DWORD): Integer;
var Dest: PChar;
begin
  ProvideSpace( Len + 9 );
  Dest := PChar( DWORD( fTextBuf ) + fUsedSiz );
  Result := fCount;
  Inc( fCount );
  fList.Add( Pointer( DWORD(Dest)-DWORD(fTextBuf) ) );
  PDWORD( Dest )^ := Obj;
  Inc( Dest, 4 );
  PDWORD( Dest )^ := Len;
  Inc( Dest, 4 );
  if S <> nil then
    System.Move( S^, Dest^, Len );
  Inc( Dest, Len );
  Dest^ := #0;
  Inc( fUsedSiz, Len+9 );
end;

function TFastStrListEx.AppendToFile(const FileName: string): Boolean;
var F: HFile;
    Txt: String;
begin
  Txt := Text;
  F := FileCreate( FileName, ofOpenAlways or ofOpenReadWrite or ofShareDenyWrite );
  if F = INVALID_HANDLE_VALUE then Result := FALSE
  else begin
         FileSeek( F, 0, spEnd );
         Result := FileWrite( F, PChar( Txt )^, Length( Txt ) ) = DWORD( Length( Txt ) );
         FileClose( F );
       end;
end;

procedure TFastStrListEx.Clear;
begin
  if FastClear then
  begin
    if fList.Count > 0 then
      PCrackList(fList).FCount := 0;
  end
    else
  begin
    fList.Clear;
    if fTextBuf <> nil then
      FreeMem( fTextBuf );
    fTextBuf := nil;
  end;
  fTextSiz := 0;
  fUsedSiz := 0;
  fCount := 0;
end;

procedure TFastStrListEx.Delete(Idx: integer);
begin
  if (Idx < 0) or (Idx >= Count) then Exit;
  if Idx = Count-1 then
    Dec( fUsedSiz, ItemLen[ Idx ]+9 );
  fList.Delete( Idx );
  Dec( fCount );
end;

destructor TFastStrListEx.Destroy;
begin
  FastClear := FALSE;
  Clear;
  fList.Free;
  inherited;
end;

function TFastStrListEx.Find(const S: String; var Index: Integer): Boolean;
var i: Integer;
begin
  for i := 0 to Count-1 do
    if (ItemLen[ i ] = Length( S )) and
       ((S = '') or CompareMem( ItemPtrs[ i ], @ S[ 1 ], Length( S ) )) then
       begin
         Index := i;
         Result := TRUE;
         Exit;
       end;
  Result := FALSE;
end;

function TFastStrListEx.Get(Idx: integer): string;
begin
  if (Idx >= 0) and (Idx <= Count) then
    SetString( Result, PChar( DWORD( fTextBuf ) + DWORD( fList.Items[ Idx ] ) + 8 ),
               ItemLen[ Idx ] )
  else
    Result := '';
end;

function TFastStrListEx.GetItemLen(Idx: Integer): Integer;
var Src: PDWORD;
begin
  if (Idx >= 0) and (Idx <= Count) then
  begin
    Src := PDWORD( DWORD( fTextBuf ) + DWORD( fList.Items[ Idx ] ) + 4 );
    Result := Src^
  end
    else Result := 0;
end;

function TFastStrListEx.GetObject(Idx: Integer): DWORD;
var Src: PDWORD;
begin
  if (Idx >= 0) and (Idx <= Count) then
  begin
    Src := PDWORD( DWORD( fTextBuf ) + DWORD( fList.Items[ Idx ] ) );
    Result := Src^
  end
    else Result := 0;
end;

function TFastStrListEx.GetPChars(Idx: Integer): PChar;
begin
  if (Idx >= 0) and (Idx <= Count) then
    Result := PChar( DWORD( fTextBuf ) + DWORD( fList.Items[ Idx ] ) + 8 )
  else Result := nil;
end;

function TFastStrListEx.GetTextStr: string;
var L, i: Integer;
    p: PChar;
begin
  L := 0;
  for i := 0 to Count-1 do
    Inc( L, ItemLen[ i ] + 2 );
  SetLength( Result, L );
  p := PChar( Result );
  for i := 0 to Count-1 do
  begin
    L := ItemLen[ i ];
    if L > 0 then
    begin
      System.Move( ItemPtrs[ i ]^, p^, L );
      Inc( p, L );
    end;
    p^ := #13; Inc( p );
    p^ := #10; Inc( p );
  end;
end;

function TFastStrListEx.IndexOf(const S: string): integer;
begin
  if not Find( S, Result ) then Result := -1;
end;

function TFastStrListEx.IndexOf_NoCase(const S: string): integer;
begin
  Result := IndexOfStrL_NoCase( PChar( S ), Length( S ) );
end;

function TFastStrListEx.IndexOfStrL_NoCase(Str: PChar;
  L: Integer): integer;
var i: Integer;
begin
  for i := 0 to Count-1 do
    if (ItemLen[ i ] = L) and
       ((L = 0) or (StrLComp_NoCase( ItemPtrs[ i ], Str, L ) = 0)) then
       begin
         Result := i;
         Exit;
       end;
  Result := -1;
end;

procedure TFastStrListEx.Init;
begin
  fList := NewList;
  FastClear := TRUE;
end;

procedure TFastStrListEx.InsertAnsi(Idx: integer; const S: String);
begin
  InsertObjectLen( Idx, PChar( S ), Length( S ), 0 );
end;

procedure TFastStrListEx.InsertAnsiObject(Idx: integer; const S: String;
  Obj: DWORD);
begin
  InsertObjectLen( Idx, PChar( S ), Length( S ), Obj );
end;

procedure TFastStrListEx.Insert(Idx: integer; S: PChar);
begin
  InsertObjectLen( Idx, S, StrLen( S ), 0 )
end;

procedure TFastStrListEx.InsertLen(Idx: Integer; S: PChar; Len: Integer);
begin
  InsertObjectLen( Idx, S, Len, 0 )
end;

procedure TFastStrListEx.InsertObject(Idx: Integer; S: PChar; Obj: DWORD);
begin
  InsertObjectLen( Idx, S, StrLen( S ), Obj );
end;

procedure TFastStrListEx.InsertObjectLen(Idx: Integer; S: PChar;
  Len: Integer; Obj: DWORD);
var Dest: PChar;
begin
  ProvideSpace( Len+9 );
  Dest := PChar( DWORD( fTextBuf ) + fUsedSiz );
  fList.Insert( Idx, Pointer( DWORD(Dest)-DWORD(fTextBuf) ) );
  PDWORD( Dest )^ := Obj;
  Inc( Dest, 4 );
  PDWORD( Dest )^ := Len;
  Inc( Dest, 4 );
  if S <> nil then
    System.Move( S^, Dest^, Len );
  Inc( Dest, Len );
  Dest^ := #0;
  Inc( fUsedSiz, Len+9 );
  Inc( fCount );
end;

function TFastStrListEx.Last: String;
begin
  if Count > 0 then
    Result := Items[ Count-1 ]
  else
    Result := '';
end;

function TFastStrListEx.LoadFromFile(const FileName: string): Boolean;
var Strm: PStream;
begin
  Strm := NewReadFileStream( FileName );
  TRY
    Result := Strm.Handle <> INVALID_HANDLE_VALUE;
    if Result then
      LoadFromStream( Strm, FALSE )
    else
      Clear;
  FINALLY
    Strm.Free;
  END;
end;

procedure TFastStrListEx.LoadFromStream(Stream: PStream;
  Append2List: boolean);
var Txt: String;
begin
  SetLength( Txt, Stream.Size - Stream.Position );
  Stream.Read( Txt[ 1 ], Stream.Size - Stream.Position );
  SetText( Txt, Append2List );
end;

procedure TFastStrListEx.MergeFromFile(const FileName: string);
var Strm: PStream;
begin
  Strm := NewReadFileStream( FileName );
  TRY
    LoadFromStream( Strm, TRUE );
  FINALLY
    Strm.Free;
  END;
end;

procedure TFastStrListEx.Move(CurIndex, NewIndex: integer);
begin
  Assert( (CurIndex >= 0) and (CurIndex < Count) and (NewIndex >= 0) and
          (NewIndex < Count), 'Item indexes violates TFastStrListEx range' );
  fList.MoveItem( CurIndex, NewIndex );
end;

procedure TFastStrListEx.ProvideSpace(AddSize: DWORD);
var OldTextBuf: PChar;
begin
  Inc( AddSize, 9 );
  if AddSize > fTextSiz - fUsedSiz then
  begin // увеличение размера буфера
    fTextSiz := Max( 1024, (fUsedSiz + AddSize) * 2 );
    OldTextBuf := fTextBuf;
    GetMem( fTextBuf, fTextSiz );
    if OldTextBuf <> nil then
    begin
      System.Move( OldTextBuf^, fTextBuf^, fUsedSiz );
      FreeMem( OldTextBuf );
    end;
  end;
  if fList.Count >= fList.Capacity then
    fList.Capacity := Max( 100, fList.Count * 2 );
end;

procedure TFastStrListEx.Put(Idx: integer; const Value: string);
var Dest: PChar;
    OldLen: Integer;
    OldObj: DWORD;
begin
  OldLen := ItemLen[ Idx ];
  if Length( Value ) <= OldLen then
  begin
    Dest := PChar( DWORD( fTextBuf ) + DWORD( fList.Items[ Idx ] ) + 4 );
    PDWORD( Dest )^ := Length( Value );
    Inc( Dest, 4 );
    if Value <> '' then
      System.Move( Value[ 1 ], Dest^, Length( Value ) );
    Inc( Dest, Length( Value ) );
    Dest^ := #0;
    if Idx = Count-1 then
      Dec( fUsedSiz, OldLen - Length( Value ) );
  end
    else
  begin
    OldObj := 0;
    while Idx > Count do
      AddObjectLen( nil, 0, 0 );
    if Idx = Count-1 then
    begin
      OldObj := Objects[ Idx ];
      Delete( Idx );
    end;
    if Idx = Count then
      AddObjectLen( PChar( Value ), Length( Value ), OldObj )
    else
    begin
      ProvideSpace( Length( Value ) + 9 );
      Dest := PChar( DWORD( fTextBuf ) + fUsedSiz );
      fList.Items[ Idx ] := Pointer( DWORD(Dest)-DWORD(fTextBuf) );
      Inc( Dest, 4 );
      PDWORD( Dest )^ := Length( Value );
      Inc( Dest, 4 );
      if Value <> '' then
        System.Move( Value[ 1 ], Dest^, Length( Value ) );
      Inc( Dest, Length( Value ) );
      Dest^ := #0;
      Inc( fUsedSiz, Length( Value )+9 );
    end;
  end;
end;

function TFastStrListEx.SaveToFile(const FileName: string): Boolean;
var Strm: PStream;
begin
  Strm := NewWriteFileStream( FileName );
  TRY
    if Strm.Handle <> INVALID_HANDLE_VALUE then
    SaveToStream( Strm );
    Result := TRUE;
  FINALLY
    Strm.Free;
  END;
end;

procedure TFastStrListEx.SaveToStream(Stream: PStream);
var Txt: String;
begin
  Txt := Text;
  Stream.Write( PChar( Txt )^, Length( Txt ) );
end;

procedure TFastStrListEx.SetObject(Idx: Integer; const Value: DWORD);
var Dest: PDWORD;
begin
  if Idx < 0 then Exit;
  while Idx >= Count do
    AddObjectLen( nil, 0, 0 );
  Dest := PDWORD( DWORD( fTextBuf ) + DWORD( fList.Items[ Idx ] ) );
  Dest^ := Value;
end;

procedure TFastStrListEx.SetText(const S: string; Append2List: boolean);
var Len2Add, NLines, L: Integer;
    p0, p: PChar;
begin
  if not Append2List then Clear;
  // подсчет требуемого пространства
  Len2Add := 0;
  NLines := 0;
  p := Pchar( S );
  p0 := p;
  L := Length( S );
  while L > 0 do
  begin
    if p^ = #13 then
    begin
      Inc( NLines );
      Inc( Len2Add, 9 + DWORD(p)-DWORD(p0) );
      REPEAT Inc( p ); Dec( L );
      UNTIL  (p^ <> #10) or (L = 0);
      p0 := p;
    end
      else
    begin
      Inc( p ); Dec( L );
    end;
  end;
  if DWORD(p) > DWORD(p0) then
  begin
    Inc( NLines );
    Inc( Len2Add, 9 + DWORD(p)-DWORD(p0) );
  end;
  if Len2Add = 0 then Exit;
  // добавление
  ProvideSpace( Len2Add - 9 );
  if fList.Capacity <= fList.Count + NLines then
    fList.Capacity := Max( (fList.Count + NLines) * 2, 100 );
  p := PChar( S );
  p0 := p;
  L := Length( S );
  while L > 0 do
  begin
    if p^ = #13 then
    begin
      AddObjectLen( p0, DWORD(p)-DWORD(p0), 0 );
      REPEAT Inc( p ); Dec( L );
      UNTIL  (p^ <> #10) or (L = 0);
      p0 := p;
    end
      else
    begin
      Inc( p ); Dec( L );
    end;
  end;
  if DWORD(p) > DWORD(p0) then
    AddObjectLen( p0, DWORD(p)-DWORD(p0), 0 );
end;

procedure TFastStrListEx.SetTextStr(const Value: string);
begin
  SetText( Value, FALSE );
end;

function CompareFast(const Data: Pointer; const e1,e2 : Dword) : Integer;
var FSL: PFastStrListEx;
    L1, L2: Integer;
    S1, S2: PChar;
begin
  FSL := Data;
  S1 := FSL.ItemPtrs[ e1 ];
  S2 := FSL.ItemPtrs[ e2 ];
  L1 := FSL.ItemLen[ e1 ];
  L2 := FSL.ItemLen[ e2 ];
  if FSL.fCaseSensitiveSort then
    Result := StrLComp( S1, S2, Min( L1, L2 ) )
  else
    Result := StrLComp_NoCase( S1, S2, Min( L1, L2 ) );
  if Result = 0 then
    Result := L1 - L2;
  if Result = 0 then
    Result := e1 - e2;
end;

procedure SwapFast(const Data : Pointer; const e1,e2 : Dword);
var FSL: PFastStrListEx;
begin
  FSL := Data;
  FSL.Swap( e1, e2 );
end;

procedure TFastStrListEx.Sort(CaseSensitive: Boolean);
begin
  fCaseSensitiveSort := CaseSensitive;
  SortData( @ Self, Count, CompareFast, SwapFast );
end;

procedure TFastStrListEx.Swap(Idx1, Idx2: Integer);
begin
  Assert( (Idx1 >= 0) and (Idx1 <= Count-1) and (Idx2 >= 0) and (Idx2 <= Count-1),
          'Item indexes violates TFastStrListEx range' );
  fList.Swap( Idx1, Idx2 );
end;

function TFastStrListEx.GetValues(AName: PChar): PChar;
var i: Integer;
    s, n: PChar;
begin
  if not Upper_Initialized then
    InitUpper;
  for i := 0 to Count-1 do
  begin
    s := ItemPtrs[ i ];
    n := AName;
    while (Upper[ s^ ] = Upper[ n^ ]) and (s^ <> '=') and (s^ <> #0) and (n^ <> #0) do
    begin
      Inc( s );
      Inc( n );
    end;
    if (s^ = '=') and (n^ = #0) then
    begin
      Result := s;
      Inc( Result );
      Exit;
    end;
  end;
  Result := nil;
end;

function TFastStrListEx.IndexOfName(AName: PChar): Integer;
var i: Integer;
    s, n: PChar;
begin
  if not Upper_Initialized then
    InitUpper;
  for i := 0 to Count-1 do
  begin
    s := ItemPtrs[ i ];
    n := AName;
    while (Upper[ s^ ] = Upper[ n^ ]) and (s^ <> '=') and (s^ <> #0) and (n^ <> #0) do
    begin
      Inc( s );
      Inc( n );
    end;
    if (s^ = '=') and (n^ = #0) then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := -1;
end;

procedure TFastStrListEx.Append(S: PChar);
begin
  AppendLen( S, StrLen( S ) );
end;

procedure TFastStrListEx.AppendInt2Hex(N: DWORD; MinDigits: Integer);
var Buffer: array[ 0..9 ] of Char;
    Mask: DWORD;
    i, Len: Integer;
    B: Byte;
begin
  if MinDigits > 8 then
    MinDigits := 8;
  if MinDigits <= 0 then
    MinDigits := 1;
  Mask := $F0000000;
  for i := 8 downto MinDigits do
  begin
    if Mask and N <> 0 then
    begin
      MinDigits := i;
      break;
    end;
    Mask := Mask shr 4;
  end;
  i := 0;
  Len := MinDigits;
  Mask := $F shl ((Len - 1)*4);
  while MinDigits > 0 do
  begin
    Dec( MinDigits );
    B := (N and Mask) shr (MinDigits * 4);
    Mask := Mask shr 4;
    if B <= 9 then
      Buffer[ i ] := Char( B + Ord( '0' ) )
    else
      Buffer[ i ] := Char( B + Ord( 'A' ) - 10 );
    Inc( i );
  end;
  Buffer[ i ] := #0;
  AppendLen( @ Buffer[ 0 ], Len );
end;

procedure TFastStrListEx.AppendLen(S: PChar; Len: Integer);
var Dest: PChar;
begin
  if Count = 0 then
    AddLen( S, Len )
  else
  begin
    ProvideSpace( Len );
    Dest := PChar( DWORD( fTextBuf ) + fUsedSiz - 1 );
    System.Move( S^, Dest^, Len );
    Inc( Dest, Len );
    Dest^ := #0;
    Inc( fUsedSiz, Len );
    Dest := PChar( DWORD( fTextBuf ) + DWORD( fList.Items[ Count-1 ] ) );
    Inc( Dest, 4 );
    PDWORD( Dest )^ := PDWORD( Dest )^ + DWORD( Len );
  end;
end;

{-}
//[procedure WStrCopy]
procedure WStrCopy( Dest, Src: PWideChar );
asm
        PUSH    EDI
        PUSH    ESI
        MOV     ESI,EAX
        MOV     EDI,EDX
        OR      ECX, -1
        XOR     EAX, EAX
        REPNE   SCASW
        NOT     ECX
        MOV     EDI,ESI
        MOV     ESI,EDX
        REP     MOVSW
        POP     ESI
        POP     EDI
end;

//[function WStrCmp]
function WStrCmp( W1, W2: PWideChar ): Integer;
asm
         PUSH     ESI
         PUSH     EDI
         XCHG     ESI, EAX
         MOV      EDI, EDX
         XOR      EAX, EAX
         CWDE
@@loop:  LODSW
         MOV      DX, [EDI]
         INC      EDI
         INC      EDI
         CMP      EAX, EDX
         JNE      @@exit
         TEST     EAX, EAX
         JNZ      @@loop
@@exit:  SUB      EAX, EDX
         POP      EDI
         POP      ESI
end;

{------------------------------------------------------------------------------)
|                                                                              |
|                         T W S t r L i s t                                    |
|                                                                              |
(------------------------------------------------------------------------------}

{$IFNDEF _D2}

//[function NewWStrList]
function NewWStrList: PWStrList;
begin
  new( Result, Create );
end;

{ TWStrList }

//[function TWStrList.Add]
function TWStrList.Add(const W: WideString): Integer;
begin
  Result := Count;
  Insert( Result, W );
end;

//[procedure TWStrList.AddWStrings]
procedure TWStrList.AddWStrings(WL: PWStrList);
begin
  Text := Text + WL.Text;
end;

//[function TWStrList.AppendToFile]
function TWStrList.AppendToFile(const Filename: String): Boolean;
var Strm: PStream;
begin
  Strm := NewReadWriteFileStream( Filename );
  Result := Strm.Handle <> INVALID_HANDLE_VALUE;
  if Result then
  begin
    Strm.Position := Strm.Size;
    SaveToStream( Strm );
  end;
  Strm.Free;
end;

//[procedure TWStrList.Assign]
procedure TWStrList.Assign(WL: PWStrList);
begin
  Text := WL.Text;
end;

//[procedure TWStrList.Clear]
procedure TWStrList.Clear;
var I: Integer;
    P: Pointer;
begin
  for I := 0 to Count-1 do
  begin
    P := fList.Items[ I ];
    if P <> nil then
    if not( (P >= fText) and (P <= fText + fTextBufSz) ) then
      FreeMem( P );
  end;
  if fText <> nil then
    FreeMem( fText );
  fText := nil;
  fTextBufSz := 0;
  fList.Clear;
end;

//[procedure TWStrList.Delete]
procedure TWStrList.Delete(Idx: Integer);
var P: Pointer;
begin
  P := fList.Items[ Idx ];
  if P <> nil then
  if not( (P >= fText) and (P <= fText + fTextBufSz) ) then
    FreeMem( P );
  fList.Delete( Idx );
end;

//[destructor TWStrList.Destroy]
destructor TWStrList.Destroy;
begin
  Clear;
  fList.Free;
  inherited;
end;

//[function TWStrList.GetCount]
function TWStrList.GetCount: Integer;
begin
  Result := fList.Count;
end;

//[function TWStrList.GetItems]
function TWStrList.GetItems(Idx: Integer): WideString;
begin
  Result := PWideChar( fList.Items[ Idx ] );
end;

//[function TWStrList.GetPtrs]
function TWStrList.GetPtrs(Idx: Integer): PWideChar;
begin
  Result := fList.Items[ Idx ];
end;

//[function TWStrList.GetText]
function TWStrList.GetText: WideString;
const
    EoL: array[ 0..5 ] of Char = ( #13, #0, #10, #0, #0, #0 );
var L, I: Integer;
    P, Dest: Pointer;
begin
  L := 0;
  for I := 0 to Count-1 do
  begin
    P := fList.Items[ I ];
    if P <> nil then
      L := L + WStrLen( P ) + 2
    else
      L := L + 2;
  end;
  SetLength( Result, L );
  Dest := PWideChar( Result );
  for I := 0 to Count-1 do
  begin
    P := fList.Items[ I ];
    if P <> nil then
    begin
      WStrCopy( Dest, P );
      Dest := Pointer( Integer( Dest ) + WStrLen( P ) * 2 );
    end;
    WStrCopy( Dest, Pointer( @ EoL[ 0 ] ) );
    Dest := Pointer( Integer( Dest ) + 4 );
  end;
end;

//[procedure TWStrList.Init]
procedure TWStrList.Init;
begin
  fList := NewList;
end;

//[procedure TWStrList.Insert]
procedure TWStrList.Insert(Idx: Integer; const W: WideString);
var P: Pointer;
begin
  while Idx < Count-2 do
    fList.Add( nil );
  GetMem( P, (Length( W ) + 1) * 2 );
  fList.Insert( Idx, P );
  WStrCopy( P, PWideChar( W ) );
end;

//[function TWStrList.LoadFromFile]
function TWStrList.LoadFromFile(const Filename: String): Boolean;
begin
  Clear;
  Result := MergeFromFile( Filename );
end;

//[procedure TWStrList.LoadFromStream]
procedure TWStrList.LoadFromStream(Strm: PStream);
begin
  Clear;
  MergeFromStream( Strm );
end;

//[function TWStrList.MergeFromFile]
function TWStrList.MergeFromFile(const Filename: String): Boolean;
var Strm: PStream;
begin
  Strm := NewReadFileStream( Filename );
  Result := Strm.Handle <> INVALID_HANDLE_VALUE;
  if Result then
    MergeFromStream( Strm );
  Strm.Free;
end;

//[procedure TWStrList.MergeFromStream]
procedure TWStrList.MergeFromStream(Strm: PStream);
var Buf: WideString;
    L: Integer;
begin
  L := Strm.Size - Strm.Position;
  Assert( L mod 1 = 0, 'Wide strings streams must be of even length in bytes.' );
  if L = 0 then Exit;
  SetLength( Buf, L div 2 );
  Strm.Read( Buf[ 1 ], L );
  Text := Text + Buf;
end;

//[procedure TWStrList.Move]
procedure TWStrList.Move(IdxOld, IdxNew: Integer);
begin
  fList.MoveItem( IdxOld, IdxNew );
end;

//[function TWStrList.SaveToFile]
function TWStrList.SaveToFile(const Filename: String): Boolean;
var Strm: PStream;
begin
  Strm := NewWriteFileStream( Filename );
  Result := Strm.Handle <> INVALID_HANDLE_VALUE;
  if Result then
    SaveToStream( Strm );
  Strm.Free;
end;

//[procedure TWStrList.SaveToStream]
procedure TWStrList.SaveToStream(Strm: PStream);
var Buf, Dest: PWideChar;
    I, L, Sz: Integer;
    P: Pointer;
begin
  Sz := 0;
  for I := 0 to Count-1 do
  begin
    P := fList.Items[ I ];
    if P <> nil then
      Sz := Sz + WStrLen( P ) * 2 + 4
    else
      Sz := Sz + 4;
  end;
  GetMem( Buf, Sz );
  Dest := Buf;
  for I := 0 to Count-1 do
  begin
    P := fList.Items[ I ];
    if P <> nil then
    begin
      L := WStrLen( P );
      System.Move( P^, Dest^, L * 2 );
      Inc( Dest, L );
    end;
    Dest^ := #13;
    Inc( Dest );
    Dest^ := #10;
    Inc( Dest );
  end;
  Strm.Write( Buf^, Sz );
  FreeMem( Buf );
end;

//[procedure TWStrList.SetItems]
procedure TWStrList.SetItems(Idx: Integer; const Value: WideString);
var P: Pointer;
begin
  while Idx > Count-1 do
    fList.Add( nil );
  if WStrLen( ItemPtrs[ Idx ] ) <= Length( Value ) then
    WStrCopy( ItemPtrs[ Idx ], PWideChar( Value ) )
  else
  begin
    P := fList.Items[ Idx ];
    if P <> nil then
    if not ((P >= fText) and (P <= fText + fTextBufSz)) then
      FreeMem( P );
    GetMem( P, (Length( Value ) + 1) * 2 );
    fList.Items[ Idx ] := P;
    WStrCopy( P, PWideChar( Value ) );
  end;
end;

//[procedure TWStrList.SetText]
procedure TWStrList.SetText(const Value: WideString);
var L, N: Integer;
    P: PWideChar;
begin
  Clear;
  if Value = '' then Exit;
  L := (Length( Value ) + 1) * 2;
  GetMem( fText, L );
  System.Move( Value[ 1 ], fText^, L );
  fTextBufSz := Length( Value );
  N := 0;
  P := fText;
  while Word( P^ ) <> 0 do
  begin
    if (Word( P^ ) = 13) then
    begin
      Inc( N );
      PWord( P )^ := 0;
      if Word( P[ 1 ] ) = 10 then
        Inc( P );
    end
      else
    if (Word( P^ ) = 10) and ((P = fText) or (Word( P[ -1 ] ) <> 0)) then
    begin
      Inc( N );
      PWord( P )^ := 0;
    end;
    Inc( P );
  end;
  fList.Capacity := N;
  P := fText;
  while P < fText + fTextBufSz do
  begin
    fList.Add( P );
    while Word( P^ ) <> 0 do Inc( P );
    Inc( P );
    if Word( P^ ) = 10 then Inc( P );
  end;
end;

//[function CompareWStrListItems]
function CompareWStrListItems( const Sender: Pointer; const Idx1, Idx2: DWORD ): Integer;
var WL: PWStrList;
begin
  WL := Sender;
  Result := WStrCmp( WL.fList.Items[ Idx1 ], WL.fList.Items[ Idx2 ] );
end;

//[function CompareWStrListItems_UpperCase]
function CompareWStrListItems_UpperCase( const Sender: Pointer; const Idx1, Idx2: DWORD ): Integer;
var WL: PWStrList;
    L1, L2: Integer;
begin
  WL := Sender;
  L1 := WStrLen( WL.fList.Items[ Idx1 ] );
  L2 := WStrLen( WL.fList.Items[ Idx2 ] );
  if Length( WL.fTmp1 ) < L1 then
    SetLength( WL.fTmp1, L1 + 1 );
  if Length( WL.fTmp2 ) < L2 then
    SetLength( WL.fTmp2, L2 + 1 );
  if L1 > 0 then
    Move( WL.fList.Items[ Idx1 ]^, WL.fTmp1[ 1 ], (L1 + 1) * 2 )
  else
    WL.fTmp1[ 1 ] := #0;
  if L2 > 0 then
    Move( WL.fList.Items[ Idx2 ]^, WL.fTmp2[ 1 ], (L2 + 1) * 2 )
  else
    WL.fTmp2[ 1 ] := #0;
  CharUpperBuffW( PWideChar( WL.fTmp1 ), L1 );
  CharUpperBuffW( PWideChar( WL.fTmp2 ), L2 );
  Result := WStrCmp( PWideChar( WL.fTmp1 ), PWideChar( WL.fTmp2 ) );
end;

//[procedure SwapWStrListItems]
procedure SwapWStrListItems( const Sender: Pointer; const Idx1, Idx2: DWORD );
var WL: PWStrList;
begin
  WL := Sender;
  WL.Swap( Idx1, Idx2 );
end;

//[procedure TWStrList.Sort]
procedure TWStrList.Sort( CaseSensitive: Boolean );
begin
  if CaseSensitive then
    SortData( @ Self, Count, @CompareWStrListItems, @SwapWStrListItems )
  else
  begin
    SortData( @ Self, Count, @CompareWStrListItems_UpperCase, @SwapWStrListItems );
    fTmp1 := '';
    fTmp2 := '';
  end;
end;

//[procedure TWStrList.Swap]
procedure TWStrList.Swap(Idx1, Idx2: Integer);
begin
  fList.Swap( Idx1, Idx2 );
end;

//[function NewWStrListEx]
function NewWStrListEx: PWStrListEx;
begin
  new( Result, Create );
end;

{ TWStrListEx }

//[function TWStrListEx.AddObject]
function TWStrListEx.AddObject(const S: WideString; Obj: DWORD): Integer;
begin
  Result := Count;
  InsertObject( Count, S, Obj );
end;

//[procedure TWStrListEx.AddWStrings]
procedure TWStrListEx.AddWStrings(WL: PWStrListEx);
var I: Integer;
begin
  I := Count;
  if WL.FObjects.Count > 0 then
    ProvideObjectsCapacity( Count );
  inherited AddWStrings( WL );
  if WL.FObjects.Count > 0 then
  begin
    ProvideObjectsCapacity( I + WL.FObjects.Count );
    System.Move( PCrackList( WL.FObjects ).FItems[ 0 ],
                 PCrackList( FObjects ).FItems[ I ],
                 Sizeof( Pointer ) * WL.FObjects.Count );
  end;
end;

//[procedure TWStrListEx.Assign]
procedure TWStrListEx.Assign(WL: PWStrListEx);
begin
  inherited Assign( WL );
  FObjects.Assign( WL.FObjects );
end;

//[procedure TWStrListEx.Clear]
procedure TWStrListEx.Clear;
begin
  inherited Clear;
  FObjects.Clear;
end;

//[procedure TWStrListEx.Delete]
procedure TWStrListEx.Delete(Idx: Integer);
begin
  inherited Delete( Idx );
  if PCrackList( FObjects ).FCount >= Idx then
    FObjects.Delete( Idx );
end;

//[destructor TWStrListEx.Destroy]
destructor TWStrListEx.Destroy;
begin
  fObjects.Free;
  inherited;
end;

//[function TWStrListEx.GetObjects]
function TWStrListEx.GetObjects(Idx: Integer): DWORD;
begin
  Result := DWORD( fObjects.Items[ Idx ] );
end;

//[function TWStrListEx.IndexOfObj]
function TWStrListEx.IndexOfObj(Obj: Pointer): Integer;
begin
  Result := FObjects.IndexOf( Obj );
end;

//[procedure TWStrListEx.Init]
procedure TWStrListEx.Init;
begin
  inherited;
  fObjects := NewList;
end;

//[procedure TWStrListEx.InsertObject]
procedure TWStrListEx.InsertObject(Before: Integer; const S: WideString;
  Obj: DWORD);
begin
  Insert( Before, S );
  FObjects.Insert( Before, Pointer( Obj ) );
end;

//[procedure TWStrListEx.Move]
procedure TWStrListEx.Move(IdxOld, IdxNew: Integer);
begin
  fList.MoveItem( IdxOld, IdxNew );
  if PCrackList( FObjects ).FCount >= Min( IdxOld, IdxNew ) then
  begin
    ProvideObjectsCapacity( Max( IdxOld, IdxNew ) + 1 );
    FObjects.MoveItem( IdxOld, IdxNew );
  end;
end;

//[procedure TWStrListEx.ProvideObjectsCapacity]
procedure TWStrListEx.ProvideObjectsCapacity(NewCap: Integer);
begin
  if fObjects.Capacity >= NewCap then Exit;
  fObjects.Capacity := NewCap;
  FillChar( PCrackList( FObjects ).FItems[ FObjects.Count ],
            (FObjects.Capacity - FObjects.Count) * Sizeof( Pointer ), 0 );
  PCrackList( FObjects ).FCount := NewCap;
end;

//[procedure TWStrListEx.SetObjects]
procedure TWStrListEx.SetObjects(Idx: Integer; const Value: DWORD);
begin
  ProvideObjectsCapacity( Idx + 1 );
  fObjects.Items[ Idx ] := Pointer( Value );
end;

{$ENDIF}
{+}

{ TCABFile }

//[function OpenCABFile]
function OpenCABFile( const APaths: array of String ): PCABFile;
var I: Integer;
begin
  {-}
  New( Result, Create );
  {+}{++}(*Result := PCABFile.Create;*){--}
  Result.FSetupapi := LoadLibrary( 'setupapi.dll' );
  Result.FNames := NewStrList;
  Result.FPaths := NewStrList;
  for I := 0 to High( APaths ) do
    Result.FPaths.Add( APaths[ I ] );
end;

//[destructor TCABFile.Destroy]
destructor TCABFile.Destroy;
begin
  FNames.Free;
  FPaths.Free;
  FTargetPath := '';
  if FSetupapi <> 0 then
    FreeLibrary( FSetupapi );
  inherited;
end;

const
  SPFILENOTIFY_FILEINCABINET  = $11;
  SPFILENOTIFY_NEEDNEWCABINET = $12;

type
  PSP_FILE_CALLBACK = function( Context: Pointer; Notification, Param1, Param2: DWORD ): DWORD;
  stdcall;

  TSetupIterateCabinet = function ( CabinetFile: PChar; Reserved: DWORD;
         MsgHandler: PSP_FILE_CALLBACK; Context: Pointer ): Boolean; stdcall;
         //external 'setupapi.dll' name 'SetupIterateCabinetA';

  TSetupPromptDisk = function (
    hwndParent: HWND; 	// parent window of the dialog box
    DialogTitle: PChar;	// optional, title of the dialog box
    DiskName: PChar;	// optional, name of disk to insert
    PathToSource: PChar;// optional, expected source path
    FileSought: PChar;	// name of file needed
    TagFile: PChar;	// optional, source media tag file
    DiskPromptStyle: DWORD;	// specifies dialog box behavior
    PathBuffer: PChar;	// receives the source location
    PathBufferSize: DWORD;	// size of the supplied buffer
    PathRequiredSize: PDWORD	// optional, buffer size needed
   ): DWORD; stdcall;
   //external 'setupapi.dll' name 'SetupPromptForDiskA';

type
  TCabinetInfo = packed record
    CabinetPath: PChar;
    CabinetFile: PChar;
    DiskName: PChar;
    SetId: WORD;
    CabinetNumber: WORD;
  end;
  PCabinetInfo = ^TCabinetInfo;

  TFileInCabinetInfo = packed record
    NameInCabinet: PChar;
    FileSize: DWORD;
    Win32Error: DWORD;
    DosDate: WORD;
    DosTime: WORD;
    DosAttribs: WORD;
    FullTargetName: array[0..MAX_PATH-1] of Char;
  end;
  PFileInCabinetInfo = ^TFileInCabinetInfo;

//[function CABCallback]
function CABCallback( Context: Pointer; Notification, Param1, Param2: DWORD ): DWORD;
stdcall;
var CAB: PCABFile;
    CABPath, OldPath: String;
    CABInfo: PCabinetInfo;
    CABFileInfo: PFileInCabinetInfo;
    hr: Integer;
    SetupPromptProc: TSetupPromptDisk;
begin
  Result := 0;
  CAB := Context;
  case Notification of
  SPFILENOTIFY_NEEDNEWCABINET:
    begin
      OldPath := CAB.FPaths.Items[ CAB.FCurCAB ];
      Inc( CAB.FCurCAB );
      if CAB.FCurCAB = CAB.FPaths.Count then
        CAB.FPaths.Add( '?' );
      CABPath := CAB.FPaths.Items[ CAB.FCurCAB ];
      if CABPath = '?' then
      begin
        if Assigned( CAB.FOnNextCAB ) then
          CAB.FPaths.Items[CAB.FCurCAB ] := CAB.FOnNextCAB( CAB );
        CABPath := CAB.FPaths.Items[ CAB.FCurCAB ];
        if CABPath = '?' then
        begin
          SetLength( CABPath, MAX_PATH );
          CABInfo := Pointer( Param1 );
          if CAB.FSetupapi <> 0 then
            SetupPromptProc := GetProcAddress( CAB.FSetupapi, 'SetupPromptForDiskA' )
          else
            SetupPromptProc := nil;
          if Assigned( SetupPromptProc ) then
          begin
            hr := SetupPromptProc( 0, nil, nil, PChar( ExtractFilePath( OldPath ) ),
                 CABInfo.CabinetFile, nil, 2 {IDF_NOSKIP}, @CabPath[ 1 ], MAX_PATH, nil );
            case hr of
            0: // success
              begin
                StrCopy( PChar( Param2 ), PChar( CABPath ) );
                Result := 0;
              end;
            2: // skip file
              Result := 0;
            else // cancel
              Result := ERROR_FILE_NOT_FOUND;
            end;
          end;
        end
          else
        begin
          StrCopy( PChar( Param2 ), PChar( CABPath ) );
          Result := 0;
        end;
      end;
    end;
  SPFILENOTIFY_FILEINCABINET:
    begin
      CABFileInfo := Pointer( Param1 );
      if CAB.FGettingNames then
      begin
        CAB.FNames.Add( CABFileInfo.NameInCabinet );
        Result := 2; // FILEOP_SKIP
      end
        else
      begin
        CABPath := CABFileInfo.NameInCabinet;
        if Assigned( CAB.FOnFile ) then
        begin
          if CAB.FOnFile( CAB, CABPath ) then
          begin
            if ExtractFilePath( CABPath ) = '' then
            if CAB.FTargetPath <> '' then
              CABPath := CAB.TargetPath + CABPath;
            StrCopy( @CABFileInfo.FullTargetName[ 0 ], PChar( CABPath ) );
            Result := 1; // FILEOP_DOIT
          end
          else
            Result := 2
        end
        else
        begin
          if CAB.FTargetPath <> '' then
            StrCopy( @CABFileInfo.FullTargetName[ 0 ], PChar( CAB.TargetPath + CABPath ) );
          Result := 1;
        end;
      end;
    end;
  end;
end;

//[function TCABFile.Execute]
function TCABFile.Execute: Boolean;
var SetupIterateProc: TSetupIterateCabinet;
begin
  FCurCAB := 0;
  Result := FALSE;
  if FSetupapi = 0 then Exit;
  SetupIterateProc := GetProcAddress( FSetupapi, 'SetupIterateCabinetA' );
  if not Assigned( SetupIterateProc ) then Exit;
  Result := SetupIterateProc( PChar( FPaths.Items[ 0 ] ), 0, CABCallback, @Self );
end;

//[function TCABFile.GetCount]
function TCABFile.GetCount: Integer;
begin
  GetNames( 0 );
  Result := FNames.Count;
end;

//[function TCABFile.GetNames]
function TCABFile.GetNames(Idx: Integer): String;
begin
  if FNames.Count = 0 then
  begin
    FGettingNames := TRUE;
    Execute;
    FGettingNames := FALSE;
  end;
  Result := '';
  if Idx < FNames.Count then
    Result := FNames.Items[ Idx ];
end;

//[function TCABFile.GetPaths]
function TCABFile.GetPaths(Idx: Integer): String;
begin
  Result := FPaths.Items[ Idx ];
end;

//[function TCABFile.GetTargetPath]
function TCABFile.GetTargetPath: String;
begin
  Result := FTargetPath;
  if Result <> '' then
  if Result[ Length( Result ) ] <> '\' then
    Result := Result + '\';
end;

{ -- TDirChange -- }

const FilterFlags: array[ TFileChangeFilters ] of Integer = (
      FILE_NOTIFY_CHANGE_FILE_NAME, FILE_NOTIFY_CHANGE_DIR_NAME,
      FILE_NOTIFY_CHANGE_ATTRIBUTES, FILE_NOTIFY_CHANGE_SIZE,
      FILE_NOTIFY_CHANGE_LAST_WRITE, $20 {FILE_NOTIFY_CHANGE_LAST_ACCESS},
      $40 {FILE_NOTIFY_CHANGE_CREATION}, FILE_NOTIFY_CHANGE_SECURITY );

//[FUNCTION _NewDirChgNotifier]
{$IFDEF ASM_VERSION}
function _NewDirChgNotifier: PDirChange;
begin
  New( Result, Create );
end;
//[function NewDirChangeNotifier]
function NewDirChangeNotifier( const Path: String; Filter: TFileChangeFilter;
                               WatchSubtree: Boolean; ChangeProc: TOnDirChange )
                               : PDirChange;
const Dflt_Flags = FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_DIR_NAME or
      FILE_NOTIFY_CHANGE_ATTRIBUTES or FILE_NOTIFY_CHANGE_SIZE or
      FILE_NOTIFY_CHANGE_LAST_WRITE;
asm
        PUSH     EBX
        PUSH     ECX // [EBP-8] = WatchSubtree
        PUSH     EDX // [EBP-12] = Filter
        PUSH     EAX // [EBP-16] = Path
        CALL     _NewDirChgNotifier
        XCHG     EBX, EAX
        LEA      EAX, [EBX].TDirChange.FPath
        POP      EDX
        CALL     System.@LStrAsg
        MOV      EAX, [ChangeProc].TMethod.Code
        MOV      [EBX].TDirChange.FOnChange.TMethod.Code, EAX
        MOV      EAX, [ChangeProc].TMethod.Data
        MOV      [EBX].TDirChange.FOnChange.TMethod.Data, EAX
        POP      ECX
        MOV      EAX, Dflt_Flags
        MOVZX    ECX, CL
        JECXZ    @@flags_ready
        PUSH     ECX
        MOV      EAX, ESP
        MOV      EDX, offset[FilterFlags]
        XOR      ECX, ECX
        MOV      CL, 7
        CALL     MakeFlags
        POP      ECX
@@flags_ready:           // EAX = Flags
        POP      EDX
        MOVZX    EDX, DL // EDX = WatchSubtree
        PUSH     EAX
        PUSH     EDX
        PUSH     [EBX].TDirChange.FPath
        CALL     FindFirstChangeNotification
        MOV      [EBX].TDirChange.FHandle, EAX
        INC      EAX
        JZ       @@fault
        PUSH     EBX
        PUSH     offset[TDirChange.Execute]
        CALL     NewThreadEx
        MOV      [EBX].TDirChange.FMonitor, EAX
        JMP      @@exit
@@fault:
        XCHG     EAX, EBX
        CALL     TObj.Free
@@exit:
        XCHG     EAX, EBX
        POP      EBX
end;
{$ELSE ASM_VERSION} //Pascal
function NewDirChangeNotifier( const Path: String; Filter: TFileChangeFilter;
                               WatchSubtree: Boolean; ChangeProc: TOnDirChange )
                               : PDirChange;
var Flags: DWORD;
begin
  {-}
  New( Result, Create );
  {+}{++}(*Result := PDirChange.Create;*){--}

  Result.FPath := Path;
  Result.FOnChange := ChangeProc;
  if Filter = [ ] then
    Flags := FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_DIR_NAME or
      FILE_NOTIFY_CHANGE_ATTRIBUTES or FILE_NOTIFY_CHANGE_SIZE or
      FILE_NOTIFY_CHANGE_LAST_WRITE
  else
    Flags := MakeFlags( @Filter, FilterFlags );
  Result.FHandle := FindFirstChangeNotification(PChar(Result.FPath),
                    Bool( Integer( WatchSubtree ) ), Flags);
  if Result.FHandle <> INVALID_HANDLE_VALUE then
    Result.FMonitor := NewThreadEx( Result.Execute )
  else //MsgOK( 'Can not monitor ' + Result.FPath + #13'Error ' + Int2Str( GetLastError ) );
  begin
    Result.Free;
    Result := nil;
  end;
end;
{$ENDIF ASM_VERSION}
//[END _NewDirChgNotifier]

{ TDirChange }

{$IFDEF ASM_VERSION}
//[procedure TDirChange.Changed]
procedure TDirChange.Changed;
asm
        MOV      ECX, [EAX].FPath
        XCHG     EDX, EAX
        MOV      EAX, [EDX].FOnChange.TMethod.Data
        CALL     [EDX].FOnChange.TMethod.Code
end;
{$ELSE ASM_VERSION} //Pascal
procedure TDirChange.Changed;
begin
  FOnChange(@Self, FPath); // must be assigned always!!!
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_VERSION}
//[destructor TDirChange.Destroy]
destructor TDirChange.Destroy;
asm
        PUSH     EBX
        XCHG     EBX, EAX
        MOV      ECX, [EBX].FMonitor
        JECXZ    @@no_monitor
        XCHG     EAX, ECX
        CALL     TObj.Free
@@no_monitor:
        MOV      ECX, [EBX].FHandle
        JECXZ    @@exit
        PUSH     ECX
        CALL     FindCloseChangeNotification
@@exit:
        LEA      EAX, [EBX].FPath
        CALL     System.@LStrClr
        XCHG     EAX, EBX
        CALL     TObj.Destroy
        POP      EBX
end;
{$ELSE ASM_VERSION} //Pascal
destructor TDirChange.Destroy;
begin
  if FMonitor <> nil then
     FMonitor.Free;
  if FHandle > 0 then // FHandle <> INVALID_HANDLE_VALUE AND FHandle <> 0
     FindCloseChangeNotification(FHandle);
  FPath := '';
  inherited;
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_noVERSION}
//[function TDirChange.Execute]
function TDirChange.Execute(Sender: PThread): Integer;
asm
        PUSH     EBX
        PUSH     ESI
        XCHG     EBX, EAX
        MOV      ESI, EDX
@@loo:
        MOVZX    ECX, [ESI].TThread.FTerminated
        INC      ECX
        LOOP     @@e_loop

        MOV      ECX, [EBX].FHandle
        INC      ECX
        JZ       @@e_loop

        PUSH     INFINITE
        PUSH     ECX
        CALL     WaitForSingleObject
        OR       EAX, EAX
        JNZ      @@loo

        PUSH     [EBX].FHandle
        MOV      EAX, [EBX].FMonitor
        PUSH     EBX
        PUSH     offset[TDirChange.Changed]
        CALL     TThread.Synchronize
        CALL     FindNextChangeNotification
        JMP      @@loo
@@e_loop:

        POP      ESI
        POP      EBX
        XOR      EAX, EAX
end;
{$ELSE ASM_VERSION} //Pascal
function TDirChange.Execute(Sender: PThread): Integer;
begin
  while (not Sender.Terminated and (FHandle <> INVALID_HANDLE_VALUE)) do
    if (WaitForSingleObject(FHandle, INFINITE) = WAIT_OBJECT_0) then
    begin
      if AppletTerminated then break;
      Applet.GetWindowHandle;
      FMonitor.Synchronize( Changed );
      FindNextChangeNotification(FHandle);
    end;
  Result := 0;
end;
{$ENDIF ASM_VERSION}

////////////////////////////////////////////////////////////////////////
//
//
//                         M  E T A F I L E
//
//
////////////////////////////////////////////////////////////////////////

{++}(*
//[API SetEnhMetaFileBits]
function SetEnhMetaFileBits; external gdi32 name 'SetEnhMetaFileBits';
function PlayEnhMetaFile; external gdi32 name 'PlayEnhMetaFile';
*){--}

//[function NewMetafile]
function NewMetafile: PMetafile;
begin
  {-}
  new( Result, Create );
  {+}{++}(*Result := PMetafile.Create;*){--}
end;
//[END NewMetafile]

{ TMetafile }

//[procedure TMetafile.Clear]
procedure TMetafile.Clear;
begin
  if fHandle <> 0 then
    DeleteEnhMetaFile( fHandle );
  fHandle := 0;
end;

//[destructor TMetafile.Destroy]
destructor TMetafile.Destroy;
begin
  if fHeader <> nil then
    FreeMem( fHeader );
  Clear;
  inherited;
end;

//[procedure TMetafile.Draw]
procedure TMetafile.Draw(DC: HDC; X, Y: Integer);
begin
  StretchDraw( DC, MakeRect( X, Y, X + Width, Y + Height ) );
end;

//[function TMetafile.Empty]
function TMetafile.Empty: Boolean;
begin
  Result := fHandle = 0;
end;

//[function TMetafile.GetHeight]
function TMetafile.GetHeight: Integer;
begin
  Result := 0;
  if Empty then Exit;
  RetrieveHeader;
  Result := fHeader.rclBounds.Bottom - fHeader.rclBounds.Top;
end;

//[function TMetafile.GetWidth]
function TMetafile.GetWidth: Integer;
begin
  Result := 0;
  if Empty then Exit;
  RetrieveHeader;
  Result := fHeader.rclBounds.Right - fHeader.rclBounds.Left;
end;

//[function TMetafile.LoadFromFile]
function TMetafile.LoadFromFile(const Filename: String): Boolean;
var Strm: PStream;
begin
  Strm := NewReadFileStream( FileName );
  Result := LoadFromStream( Strm );
  Strm.Free;
end;

//[function ComputeAldusChecksum]
function ComputeAldusChecksum(var WMF: TMetafileHeader): Word;
type
  PWord = ^Word;
var
  pW: PWord;
  pEnd: PWord;
begin
  Result := 0;
  pW := @WMF;
  pEnd := @WMF.CheckSum;
  while Longint(pW) < Longint(pEnd) do
  begin
    Result := Result xor pW^;
    Inc(Longint(pW), SizeOf(Word));
  end;
end;

//[function TMetafile.LoadFromStream]
function TMetafile.LoadFromStream(Strm: PStream): Boolean;
var WMF: TMetaFileHeader;
    WmfHdr: TMetaHeader;
    EnhHdr: TEnhMetaHeader;
    Pos, Pos1: Integer;
    Sz: Integer;
    MemStrm: PStream;
    MFP: TMetafilePict;
begin
  Result := FALSE;
  Pos := Strm.Position;

  if Strm.Read( WMF, Sizeof( WMF ) ) <> Sizeof( WMF ) then
  begin
    Strm.Position := Pos;
    Exit;
  end;

  MemStrm := NewMemoryStream;

  if WMF.Key = WMFKey then
  begin // Windows metafile

    if WMF.CheckSum <> ComputeAldusChecksum( WMF ) then
    begin
      Strm.Position := Pos;
      Exit;
    end;

    Pos1 := Strm.Position;
    if Strm.Read( WmfHdr, Sizeof( WmfHdr ) ) <> Sizeof( WmfHdr ) then
    begin
      Strm.Position := Pos;
      Exit;
    end;

    Strm.Position := Pos1;
    Sz := WMFHdr.mtSize * 2;
    Stream2Stream( MemStrm, Strm, Sz );
    FillChar( MFP, Sizeof( MFP ), 0 );
    MFP.mm := MM_ANISOTROPIC;
    fHandle := SetWinMetafileBits( Sz, MemStrm.Memory, 0, MFP );

  end
    else
  begin // may be enchanced?

    Strm.Position := Pos;
    if Strm.Read( EnhHdr, Sizeof( EnhHdr ) ) < 8 then
    begin
      Strm.Position := Pos;
      Exit;
    end;
    // yes, enchanced
    Strm.Position := Pos;
    Sz := EnhHdr.nBytes;
    Stream2Stream( MemStrm, Strm, Sz );
    fHandle := SetEnhMetaFileBits( Sz, MemStrm.Memory );

  end;

  MemStrm.Free;
  Result := fHandle <> 0;
  if not Result then
    Strm.Position := Pos;

end;

//[procedure TMetafile.RetrieveHeader]
procedure TMetafile.RetrieveHeader;
var SzHdr: Integer;
begin
  if fHeader <> nil then
    FreeMem( fHeader );
  SzHdr := GetEnhMetaFileHeader( fHandle, 0, nil );
  GetMem( fHeader, SzHdr );
  GetEnhMetaFileHeader( fHandle, SzHdr, fHeader );
end;

//[procedure TMetafile.SetHandle]
procedure TMetafile.SetHandle(const Value: THandle);
begin
  Clear;
  fHandle := Value;
end;

//[procedure TMetafile.StretchDraw]
procedure TMetafile.StretchDraw(DC: HDC; const R: TRect);
begin
  if Empty then Exit;
  PlayEnhMetaFile( DC, fHandle, R );
end;

{ ----------------------------------------------------------------------

                TAction and TActionList

----------------------------------------------------------------------- }
//[function NewActionList]
function NewActionList(AOwner: PControl): PActionList;
begin
  {-}
  New( Result, Create );
  {+} {++}(* Result := PActionList.Create; *){--}
  with Result{-}^{+} do begin
    FActions:=NewList;
    FOwner:=AOwner;
    RegisterIdleHandler(DoUpdateActions);
  end;
end;
//[END NewActionList]

//[function NewAction]
function NewAction(const ACaption, AHint: string; AOnExecute: TOnEvent): PAction;
begin
  {-}
  New( Result, Create );
  {+} {++}(* Result := PAction.Create; *){--}
  with Result{-}^{+} do begin
    FControls:=NewList;
    Enabled:=True;
    Visible:=True;
    Caption:=ACaption;
    Hint:=AHint;
    OnExecute:=AOnExecute;
  end;
end;
//[END NewAction]

{ TAction }

//[procedure TAction.LinkCtrl]
procedure TAction.LinkCtrl(ACtrl: PObj; ACtrlKind: TCtrlKind; AItemID: integer; AUpdateProc: TOnUpdateCtrlEvent);
var
  cr: PControlRec;
begin
  New(cr);
  with cr^ do begin
    Ctrl:=ACtrl;
    CtrlKind:=ACtrlKind;
    ItemID:=AItemID;
    UpdateProc:=AUpdateProc;
  end;
  FControls.Add(cr);
  AUpdateProc(cr);
end;

//[procedure TAction.LinkControl]
procedure TAction.LinkControl(Ctrl: PControl);
begin
  LinkCtrl(Ctrl, ckControl, 0, UpdateCtrl);
  Ctrl.OnClick:=DoOnControlClick;
end;

//[procedure TAction.LinkMenuItem]
procedure TAction.LinkMenuItem(Menu: PMenu; MenuItemIdx: integer);
{$IFDEF _FPC}
var
  arr1_DoOnMenuItem: array[ 0..0 ] of TOnMenuItem;
{$ENDIF _FPC}
begin
  LinkCtrl(Menu, ckMenu, MenuItemIdx, UpdateMenu);
  {$IFDEF _FPC}
  arr1_DoOnMenuItem[ 0 ] := DoOnMenuItem;
  Menu.AssignEvents(MenuItemIdx, arr1_DoOnMenuItem);
  {$ELSE}
  Menu.AssignEvents(MenuItemIdx, [ DoOnMenuItem ]);
  {$ENDIF}
end;

//[procedure TAction.LinkToolbarButton]
procedure TAction.LinkToolbarButton(Toolbar: PControl; ButtonIdx: integer);
{$IFDEF _FPC}
var
  arr1_DoOnToolbarButtonClick: array[ 0..0 ] of TOnToolbarButtonClick;
{$ENDIF _FPC}
begin
  LinkCtrl(Toolbar, ckToolbar, ButtonIdx, UpdateToolbar);
  {$IFDEF _FPC}
  arr1_DoOnToolbarButtonClick[ 0 ] := DoOnToolbarButtonClick;
  Toolbar.TBAssignEvents(ButtonIdx, arr1_DoOnToolbarButtonClick);
  {$ELSE}
  Toolbar.TBAssignEvents(ButtonIdx, [DoOnToolbarButtonClick]);
  {$ENDIF}
end;

//[destructor TAction.Destroy]
destructor TAction.Destroy;
begin
  FControls.Release;
  FCaption:='';
  FShortCut:='';
  FHint:='';
  inherited;
end;

//[procedure TAction.DoOnControlClick]
procedure TAction.DoOnControlClick(Sender: PObj);
begin
  Execute;
end;

//[procedure TAction.DoOnMenuItem]
procedure TAction.DoOnMenuItem(Sender: PMenu; Item: Integer);
begin
  Execute;
end;

//[procedure TAction.DoOnToolbarButtonClick]
procedure TAction.DoOnToolbarButtonClick(Sender: PControl; BtnID: Integer);
begin
  Execute;
end;

//[procedure TAction.Execute]
procedure TAction.Execute;
begin
  if Assigned(FOnExecute) and FEnabled then
    FOnExecute(PObj( @Self ));
end;

//[procedure TAction.SetCaption]
procedure TAction.SetCaption(const Value: string);
var
  i: integer;
  c, ss: string;

begin
  i:=Pos(#9, Value);
  if i <> 0 then begin
    c:=Copy(Value, 1, i - 1);
    ss:=Copy(Value, i + 1, MaxInt);
  end
  else begin
    c:=Value;
    ss:='';
  end;
  if (FCaption = c) and (FShortCut = ss) then exit;
  FCaption:=c;
  FShortCut:=ss;
  UpdateControls;
end;

//[procedure TAction.SetChecked]
procedure TAction.SetChecked(const Value: boolean);
begin
  if FChecked = Value then exit;
  FChecked := Value;
  UpdateControls;
end;

//[procedure TAction.SetEnabled]
procedure TAction.SetEnabled(const Value: boolean);
begin
  if FEnabled = Value then exit;
  FEnabled := Value;
  UpdateControls;
end;

//[procedure TAction.SetHelpContext]
procedure TAction.SetHelpContext(const Value: integer);
begin
  if FHelpContext = Value then exit;
  FHelpContext := Value;
  UpdateControls;
end;

//[procedure TAction.SetHint]
procedure TAction.SetHint(const Value: string);
begin
  if FHint = Value then exit;
  FHint := Value;
  UpdateControls;
end;

//[procedure TAction.SetOnExecute]
procedure TAction.SetOnExecute(const Value: TOnEvent);
begin
  if @FOnExecute = @Value then exit;
  FOnExecute:=Value;
  UpdateControls;
end;

//[procedure TAction.SetVisible]
procedure TAction.SetVisible(const Value: boolean);
begin
  if FVisible = Value then exit;
  FVisible := Value;
  UpdateControls;
end;

//[procedure TAction.UpdateControls]
procedure TAction.UpdateControls;
var
  i: integer;
begin
  with FControls{-}^{+} do
    for i:=0 to Count - 1 do
      PControlRec(Items[i]).UpdateProc(Items[i]);
end;

//[procedure TAction.UpdateCtrl]
procedure TAction.UpdateCtrl(Sender: PControlRec);
begin
  with Sender^, PControl(Ctrl){-}^{+} do begin
    if Caption <> Self.FCaption then
      Caption:=Self.FCaption;
    if Enabled <> Self.FEnabled then
      Enabled:=Self.FEnabled;
    if Checked <> Self.FChecked then
      Checked:=Self.FChecked;
    if Visible <> Self.FVisible then
      Visible:=Self.FVisible;
  end;
end;

//[procedure TAction.UpdateMenu]
procedure TAction.UpdateMenu(Sender: PControlRec);
var
  s: string;
begin
  with Sender^, PMenu(Ctrl).Items[ItemID]{-}^{+} do begin
    s:=Self.FCaption;
    if Self.FShortCut <> '' then
      s:=s + #9 + Self.FShortCut;
    if Caption <> s then
      Caption:=s;
    if Enabled <> Self.FEnabled then
      Enabled:=Self.FEnabled;
    if Checked <> Self.FChecked then
      Checked:=Self.FChecked;
    if Visible <> Self.FVisible then
      Visible:=Self.FVisible;
    if HelpContext <> Self.FHelpContext then
      HelpContext:=Self.FHelpContext;
    if Self.FAccelerator.Key <> 0 then {YS}  // ƒобавить
      Accelerator:=Self.FAccelerator;
  end;
end;

//[procedure TAction.UpdateToolbar]
procedure TAction.UpdateToolbar(Sender: PControlRec);
var
  i: integer;
  s: string;
begin
  with Sender^, PControl(Ctrl){-}^{+} do begin
    i:=TBIndex2Item(ItemID);
    s:=TBButtonText[i];
    if (s <> '') and (s <> Self.FCaption) then
      TBButtonText[i]:=Self.FCaption;
    TBSetTooltips(i, [PChar(Self.FHint)]);
    if TBButtonEnabled[ItemID] <> Self.FEnabled then
      TBButtonEnabled[ItemID]:=Self.FEnabled;
    if TBButtonVisible[ItemID] <> Self.FVisible then
      TBButtonVisible[ItemID]:=Self.FVisible;
    if TBButtonChecked[ItemID] <> Self.FChecked then
      TBButtonChecked[ItemID]:=Self.FChecked;
  end;
end;

//[procedure TAction.SetAccelerator]
procedure TAction.SetAccelerator(const Value: TMenuAccelerator);
begin
  if (FAccelerator.fVirt = Value.fVirt) and (FAccelerator.Key = Value.Key) then exit;
  FAccelerator := Value;
  FShortCut:=GetAcceleratorText(FAccelerator);  // {YS}
  UpdateControls;
end;

{ TActionList }

//[function TActionList.Add]
function TActionList.Add(const ACaption, AHint: string; OnExecute: TOnEvent): PAction;
begin
  Result:=NewAction(ACaption, AHint, OnExecute);
  FActions.Add(Result);
end;

//[procedure TActionList.Clear]
procedure TActionList.Clear;
begin
  while FActions.Count > 0 do
    Delete(0);
  FActions.Clear;  
end;

//[procedure TActionList.Delete]
procedure TActionList.Delete(Idx: integer);
begin
  Actions[Idx].Free;
  FActions.Delete(Idx);
end;

//[destructor TActionList.Destroy]
destructor TActionList.Destroy;
begin
  UnRegisterIdleHandler(DoUpdateActions);
  Clear;
  FActions.Free;
  inherited;
end;

//[procedure TActionList.DoUpdateActions]
procedure TActionList.DoUpdateActions(Sender: PObj);
begin
  if Assigned(FOnUpdateActions) and (GetActiveWindow = FOwner.Handle) then
    FOnUpdateActions(PObj( @Self ));
end;

//[function TActionList.GetActions]
function TActionList.GetActions(Idx: integer): PAction;
begin
  Result:=FActions.Items[Idx];
end;

//[function TActionList.GetCount]
function TActionList.GetCount: integer;
begin
  Result:=FActions.Count;
end;

end.
