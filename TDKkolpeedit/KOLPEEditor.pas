{***************************************************************
 *
 * Unit Name: KOLPEEditor
 * Purpose  : Several executable file info and edit options
 * Author   : KOL version:Thaddy de Koning
 * History  : Original by eminence.
 *            Changed public vars to properties
 *            Changed Class to Object
 *            Changed Tlists into pLists etc.
 *            'Beautified' the example
 *            cleaned the code somewhat
 *            Oh, and fixed some bugs as well.
 ****************************************************************}

//!!!Please do not remove or edit the following comments!!!//
                                   /////////////////////////////////////////
                                  //         e!m Team presents:          //
                                 // <TPEEditor 1.0 component for Delphi>//
                                //      (Cr)Sergi /e!MiNENCE team/     //
                               // We will never stop living this way! //
                              //   http://www.the-eminence.com/    //
                             //        Written on 04.05.02          //
                            //        Released on 04.05.02))       //
                           /////////////////////////////////////////
//This  info  was used to create the following code.--->>>
//                              +----------------------------+
//                              |     PortableExecutables    |
//                              |           Format           | <<I have'nt that dock
//                              |     Release: 27-Dec-1997y  | <<In englis,only in russian.
//                              |  Created by: Hard Wisdom   | <<So i do not post it.
//                              +----------------------------+
//This code written by impression of the "Mea Culpa" song (ENIGMA) - u realy should hear this!
    ///////////////////////////////////////////////////////////////////
   //Greets fly out to:                                             //
  //naboo, bpX, Saiygin, k4, ProtectX, RelayX, ThaDocta, MP3FINDER,//
 //and the others, who keeps the spirit alive.                    //
///////////////////////////////////////////////////////////////////


//-----------------------------------How to install-----------------------------------
//Just select install component from your component menu, and build it.)
//It'll appear in the e!MiNENCE page
//For "How to use" see examples & readme.txt.

unit KOLPEEditor;

interface


uses
Windows,
KOL;


type TDirectory = packed record
  RVA             :DWORD;
  Size            :DWORD;
end;

type PDirectory=^TDirectory;

Type TSection = packed record
  o_name	        :array[0..7] of char;
  o_virtual_size  :DWORD;
  o_rva           :DWORD;
  o_physical_size	:DWORD;
  o_physical_offs	:DWORD;
  o_reserved	:array[0..11] of char;
  o_flags		:DWORD;
end;

type PSection=^TSection;

type TExportTable=packed record
  Flags:Dword;
  TDS:Dword;
  MV:word;
  MinV:word;
  Name_RVA:Dword;
  Ordinal_Base:dword;
  Num_of_Functions:dword;
  Num_of_Name_Pointers:dword;
  Address_Table_RVA:dword;
  Name_Pointers_RVA:dword;
  Ordinal_Table_RVA:dword;
end;

type TExportedFunction=record
  Name:string;
  Ordinal:word;
end;

type PExportedFunction=^TExportedFunction;

type TImportDirElement = packed record
  id_ilt_rva      :DWORD;
  id_timedate     :DWORD;
  id_ifc_rva      :DWORD;
  id_name_rva     :DWORD;
  id_iat_rva      :DWORD;
end;

type PImportDirElement=^TImportDirElement;

type TImportedFunction=record
  Name:string;
  Ordinal:word;
  Rva:dword;
  NameOffset:Dword;
end;

type PImportedFunction=^TImportedFunction;

type TimportedLibrary=record
  Name:string;
  FunctionList:pList;
end;

type PImportedLibrary=^TImportedLibrary;

type
  pPeEditor=^TPEEditor;
  TPeEditor=object(Tobj)
private
  PE:Dword;
  IS_MEM_ALLOCATED:BOOLEAN;
  ImportedDirs:pList;
  name_of_lib:array[0..255] of char;
  name_of_func:array[0..1024] of char;
  Section:PSection;
  Sect_Cnt:Word;Dirs_cnt:Dword;
  F_PEFilePath:string;
  PE_HEADEROFFSET:Dword;
  PE_NT_HEADERSIZE:WORD;
  MEMPTR:Pointer;
  MEMSZ:DWORD;
  _SectionList:pList;
  _ImportedList:plist;
  _exportedlist:plist;
  _directorylist:pList;
  Procedure SetImageSize(a:dword);
  Procedure SetImageBase(a:dword);
  Procedure SetEntryPoint(a:dword);
  Function GetImageSize:dword;
  Function GetImageBase:dword;
  Function GetEntryPoint:dword;
  Function LoadPE:boolean;
  procedure LoadImportDir;
  procedure LoadImportedFunctions;
  procedure LoadPEFromMEM;
  procedure LoadExportedFunctions;
  procedure OpenPe(pat:string);
  procedure Init;virtual;

public
  property EntryPoint:dword read GetEntryPoint write SetEntryPoint;
  property ImageBase:dword read GetImageBase write SetImageBase;
  property ImageSize:dword read GetImageSize write SetImageSize;
  property PEFilePath:string read F_PEFilePath write OpenPe;

property HeaderOffset:Dword read PE_HEADEROFFSET write PE_HEADEROFFSET;
property HeaderSize:WORD read PE_NT_HEADERSIZE write PE_NT_HEADERSIZE;
property MemSize:Dword read MEMSZ write MEMSZ;
property SectionList:pList Read _SectionList;
property Importedlist:pList Read _Importedlist;
property Exportedlist:pList read _Exportedlist;
property Directorylist:pList read _Directorylist;
Function RvaToFileOffset(rva:dword):dword;
Function FileOffsetToRva(foffset:dword):dword;
procedure RefreshPE;
procedure SavePE(pat:string);
destructor Destroy;virtual;
end;

function NewPEEditor:pPeEditor;

implementation

function NewPEEditor:pPeEditor;
begin
  New(result,Create);
end;

Destructor TPEEditor.Destroy;
begin
  _SectionList.Free;
  _ImportedList.Free;
  _exportedlist.Free;
  if IS_MEM_ALLOCATED then VirtualFree(MEMPTR,0,MEM_RELEASE);
  inherited;
end;

procedure TPEEditor.Init;
begin
  inherited;
  IS_MEM_ALLOCATED:=False;
  _SectionList:=Newlist;
  _ImportedList:=NewList;
  _exportedlist:=NewList;
  _directorylist:=NewList;
end;

procedure TPEEditor.OpenPE(pat:string);
begin
 if F_PEFilePath<>'' then
 begin
   If IS_MEM_ALLOCATED then
   begin
     VirtualFree(MEMPTR,0,MEM_RELEASE);
     IS_MEM_ALLOCATED:=False;
   end;
 end;
  F_PEFilePath:='';
  if not FileExists(pat) then exit;
  F_PEFilePath:=pat;
  PE:=_lopen(Pchar(pat),0);
  if PE=Dword(-1) then exit;
  MEMSZ:=GetFileSize(PE,nil);
  MEMPTR:=VirtualAlloc(nil,MEMSZ+2048,MEM_COMMIT,PAGE_READWRITE);
  IS_MEM_ALLOCATED:=TRUE;
  _lread(PE,MEMPTR,MEMSZ);
  _lclosE(PE);
  if not LoadPE then
  begin
    F_PEFilePath:='';
    VirtualFree(MEMPTR,0,MEM_RELEASE);
    IS_MEM_ALLOCATED:=FALSE;
    exit;
  end;
  F_PEFilePath:=pat;
end;

procedure TPEEditor.LoadPEFromMEM;
var i:integer;
    Dir:PDirectory;
    _Section:Psection;
begin
  _SectionList.Clear;
  _ImportedList.Clear;
  _exportedlist.Clear;
  _directorylist.Clear;
  For i:=0 to Dirs_Cnt-1 do
  begin
    New(Dir);
    move(Pointer(dword(MEMPTR)+PE_HEADEROFFSET+$78+(i*8))^,Dir^,8);
    _directorylist.Add(Dir);
  end;
  For i:=0 to Sect_Cnt-1 do
  begin
    New(_Section);
    Move(Pointer(dword(MEMPTR)+PE_HEADEROFFSET+$18+PE_NT_HEADERSIZE+(i*40))^,_Section^,40);
    _SectionList.Add(_Section);
  end;
  LoadImportDir;
  LoadImportedFunctions;
  LoadExportedFunctions;
end;

Function TPEEditor.LoadPE:boolean;
var
   CmpMZ:array[0..1] of char;
   CmpPE:array[0..3] of char;
begin
  Result:=False;
  Move(MEMPTR^,CmpMZ,2);
  if (CmpMZ[0]<>'M') and (CmpMZ[1]<>'Z') then Exit;
  if MEMSZ<=$40 then exit;
  Move(Pointer(Dword(MEMPTR)+$3C)^,PE_HEADEROFFSET,4);
  If MEMSZ<=PE_HEADEROFFSET+$200 then exit;
  Move(Pointer(Dword(MEMPTR)+PE_HEADEROFFSET)^,CmpPE,4);
  if (CmpPE[0]<>'P') or (CmpPE[1]<>'E') or (CmpPE[2]<>#0) or (CmpPE[3]<>#0) then exit;
  Move(Pointer(Dword(MEMPTR)+PE_HEADEROFFSET+$14)^,PE_NT_HEADERSIZE,2);
  Move(Pointer(Dword(MEMPTR)+PE_HEADEROFFSET+$06)^,Sect_Cnt,2);
  Move(Pointer(Dword(MEMPTR)+PE_HEADEROFFSET+$74)^,Dirs_cnt,4);
  LoadPEFromMEM;
  Result:=TRUE;
end;

Function TPEEditor.FileOffsetToRva(foffset:dword):dword;
var i:integer;
    z:dword;
begin
  Result:=0;
  for i:=0 to _SectionList.count-1 do
  begin
    Section:=PSection(_SectionList.Items[i]);
    if (foffset>=Section.o_physical_offs) and (foffset<=Section.o_physical_offs+Section.o_physical_size) then
    begin
      z:=Section.o_rva+foffset;
      Result:=z;
      exit;
    end;
  end;
end;

Function TPEEditor.RvaToFileOffset(rva:dword):dword;
var i:integer;
    z:dword;
begin
  Result:=0;
  for i:=0 to _SectionList.count-1 do
  begin
    Section:=PSection(_SectionList.Items[i]);
    if (Rva>=Section.o_rva) and (Rva<=Section.o_rva+Section.o_physical_size) then
    begin
      z:=Section.o_physical_offs+RVA-Section.o_rva;
      Result:=z;
      exit;
    end;
  end;
end;

procedure TPEEditor.LoadImportDir;
var
   ImportDirElement:PImportDirElement;
   DirEntry:PDirectory;
   i:integer;phys_dir_offset:dword;
begin
  ImportedDirs:=Newlist;
  DirEntry:=_directorylist.Items[1];
  if DirEntry.RVA=0 then
  begin
    ImportedDirs.Free;
    exit;
  end;
  i:=0;
  phys_dir_offset:=RvaToFileOffset(DirEntry.RVA);
  While true do
  begin
    New(ImportDirElement);
    Move(Pointer(Dword(MEMPTR)+phys_dir_offset+(i*20))^,ImportDirElement^,20);
    if  ImportDirElement.id_name_rva=0 then
    begin
      Dispose(ImportDirElement);
      exit;
    end;
    ImportedDirs.Add(ImportDirElement);
    Inc(i);
  end;
end;

procedure TPEEditor.LoadImportedFunctions;
var
   ImportDirElement:PImportDirElement;
   I:Integer;
   FuncNameOffset,NameOffset:DWORD;
   FuncName,LibName:string;
   z:pchar;
   ImportedLibrary:PImportedLibrary;Plus:dword;
   zzz:dword;
   OrdinalValue:byte;
   ImportedFunction:PImportedFunction;
begin
  For i:=0 to ImportedDirs.Count-1 do
  begin
    New(ImportedLibrary);
    ImportDirElement:=ImportedDirs.items[i];
    NameOffset:=RvaToFileOffset(ImportDirElement.id_name_rva);
    Move(Pointer(DWORD(MEMPTR)+NameOffset)^,name_of_lib,SizeOf(name_of_lib));
    z:=name_of_lib;
    LibName:=z;
    ImportedLibrary.Name:=LibName;
    ImportedLibrary.FunctionList:=Newlist;
    Plus:=0;
    _ImportedList.add(ImportedLibrary);
    if ImportDirElement.id_ilt_rva=0 then
      ImportDirElement.id_ilt_rva:=ImportDirElement.id_iat_rva;
    RvaToFileOffset(ImportDirElement.id_ilt_rva);
    while true do
    begin
      zzz:=ImportDirElement^.id_ilt_rva;
      zzz:=zzz+(Plus*4);
      zzz:=RvaToFileOffset(zzz);
      Move(Pointer(Dword(MEMPTR)+zzz)^,FuncNameOffset,4);
      if FuncNameOffset=0 then break;
      asm
        push ebx
        xor bl,bl
        rcl FuncNameOffset ,1
        jnc @StopThis
        inc bl
      @StopThis:
        shr FuncNameOffset,1
        mov OrdinalValue,bl
        pop ebx
      end;
      if OrdinalValue>0 then
      begin
        New(ImportedFunction);
        ImportedFunction.Name:='';
        ImportedFunction.Ordinal:=FuncNameOffset;
        ImportedLibrary.FunctionList.Add(ImportedFunction);
        ImportedFunction.NameOffset:=0;
        Inc(Plus);
        Continue;
      end;
      FuncNameOffset:=RvaToFileOffset(FuncNameOffset);
      Move(Pointer(Dword(MEMPTR)+FuncNameOffset+2)^,name_of_func,SizeOf(name_of_func));
      z:=name_of_func;
      FuncName:=z;
      New(ImportedFunction);
      ImportedFunction.NameOffset:=FuncNameOffset+2;
      ImportedFunction.Name:=FuncName;
      ImportedFunction.Ordinal:=0;
      ImportedLibrary.FunctionList.Add(ImportedFunction);
      Inc(Plus);
    end;
end;
ImportedDirs.Free;
end;

Function TPEEditor.GetEntryPoint:dword;
begin
  Result:=0;
  if not IS_MEM_ALLOCATED then exit;
  Move(Pointer(Dword(MEMPTR)+PE_HEADEROFFSET+$28)^,Result,4);
end;

Function TPEEditor.GetImageSize:dword;
begin
  Result:=0;
  if not IS_MEM_ALLOCATED then exit;
  Move(Pointer(Dword(MEMPTR)+PE_HEADEROFFSET+$50)^,Result,4);
end;

Function TPEEditor.GetImageBase:dword;
begin
  Result:=0;
  if not IS_MEM_ALLOCATED then exit;
  Move(Pointer(Dword(MEMPTR)+PE_HEADEROFFSET+$34)^,Result,4);
end;

Procedure TPEEditor.SetEntryPoint(a:dword);
begin
  if not IS_MEM_ALLOCATED then exit;
  Move(a,Pointer(Dword(MEMPTR)+PE_HEADEROFFSET+$28)^,4);
end;

Procedure TPEEditor.SetImageSize(a:dword);
begin
  if not IS_MEM_ALLOCATED then exit;
  Move(a,Pointer(Dword(MEMPTR)+PE_HEADEROFFSET+$50)^,4);
end;

Procedure TPEEditor.SetImageBase(a:dword);
begin
  if not IS_MEM_ALLOCATED then exit;
  Move(a,Pointer(Dword(MEMPTR)+PE_HEADEROFFSET+$34)^,4);
end;

procedure TPEEditor.RefreshPE;
var
   i:integer;
begin
  for i:=0 to _directorylist.Count-1 do
  move(PDirectory(_directorylist.Items[i])^,Pointer(Dword(MEMPTR)+PE_HEADEROFFSET+$78+(i*8))^,8);
  for i:=0 to _SectionList.Count-1 do
    Move(PSection(_SectionList.Items[i])^,Pointer(Dword(MEMPTR)+PE_HEADEROFFSET+$18+PE_NT_HEADERSIZE+(i*40))^,40);
  LoadPEFromMEM;
end;

procedure TPEEditor.SavePE(pat:string);
var
   TOPE:dword;
begin
  TOPE:=_lcreat(pchaR(pat),0);
  if TOPE=dword(-1) then MSgOk('ERROR: Cant save to this path.') else
  begin
  RefreshPE;
  _lwrite(TOPE,MEMPTR,MEMSZ);
  _lclose(TOPE);
  end;
end;

Procedure TPEEditor.LoadExportedFunctions;
var FOffset1,FOFFSET,Export_table_rva:dword;
    OrdB:word;
    i:integer;
    ExportTbl:TExportTable;
    pc:pchar;
    g:integer;
    ExportedFunction:PExportedFunction;
    OrdList:PList;
begin
  _exportedlist.Clear;
  OrdList:=NewList;
  pc:=VirtualAlloc(nil,1000,MEM_COMMIT,PAGE_READWRITE);
  Export_table_rva:=PDirectory(_directorylist.Items[0]).RVA;
  if Export_table_rva=0 then
  begin
    OrdList.Free;
    VirtualFree(pc,0,MEM_RELEASE);
    exit;
  end;
  FOffset:=RvaToFileOffset(Export_Table_Rva);
  move(Pointer(DworD(MEMPTR)+FOFFSET)^,ExportTbl,SizeOf(ExportTbl));
  FOffset:=RvaToFileOffset(ExportTbl.Name_Pointers_RVA);
  FOffset1:=FOFFset;
  for i:=0 to ExportTbl.Num_of_Name_Pointers-1 do
  begin
    Move(Pointer(Dword(MEMPTR)+FOffset1+(i*4))^,g,4);
    Move(Pointer(Dword(MEMPTR)+RvaToFileOffset(g))^,pc^,1000);
    Foffset:=RvaToFileOffset(ExportTbl.Ordinal_Table_RVA);
    Move(Pointer(Dword(MEMPTR)+FOffset+(i*2))^,OrdB,2);
    ordb:=ordb+ExportTbl.Ordinal_Base;
    OrdList.Add(Pointer(OrdB));
    New(ExportedFunction);
    ExportedFunction.Name:=Copy(pc,1,Length(pc));
    ExportedFunction.Ordinal:=OrdB;
    _exportedlist.add(ExportedFunction);
  end;
  for i:=1 to ExportTbl.Num_of_Functions do
  begin
    if OrdList.IndexOf(pointer(i+ExportTbl.Ordinal_Base))<0 then
    begin
      New(ExportedFunction);
      ExportedFunction.Name:='';
      ExportedFunction.Ordinal:=i+ExportTbl.Ordinal_Base;
      _exportedlist.add(ExportedFunction)
    end;
  end;
  VirtualFree(pc,0,mem_release);
  OrdList.Free;
end;
end.
