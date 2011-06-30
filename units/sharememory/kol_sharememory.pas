unit kol_sharememory;

interface 

uses windows,kol;

{

 This unit has been modified by neuron (neuron@hollowtube.mine.nu) to work with kol.
 Very small modification, all credit goes to the original author, questions regarding
 problems with this modified unit can be sent to me :)

----

  This unit demonstrates how simple it is to share a block of memory
  between several Windows applications.

  The parameter "objectname" identifies the memory block. Please use
  a meaningful and not-too-short name for the thing!

  (please note! Backslashes aren't allowed in this name!
   It is NOT a "dos" name!)


  "size" identifies the size of the block.
  "memory" is the address of the block.




  If another application has already created the object, it should be
  possible to set this parameter to zero (I haven't tried this though, and
  I don't know what happens if the "size" parameter isn't identical in all
  applications  trying to access the block simultaneously....



  Written August 30,1996 by Arthur Hoornweg
  (hoornweg@hannover.sgh-net.de)

  Freeware!


 }

  TYPE
  PSharedMemory = ^TSharedMemory;
  TSharedMemory = object(tobj)
  private
    FMappingHandle :THandle;
    FMemory        :Pointer;
    Fsize          :Longint;
  protected
    destructor  Destroy; virtual;
  public
    property    Memory :Pointer read FMemory;
    Property    Size:Longint read fsize;
  end;

function NewSharedMemory(ObjectName  : PCHAR;       {no \ allowed....}
                       DesiredSize : Longint     {zero if existing}
                       ):PSharedMemory;      {create if not existing}



implementation

function NewSharedMemory(ObjectName  : PCHAR;       {no \ allowed....}
                       DesiredSize : Longint     {zero if existing}
                       ):PSharedMemory;      {create if not existing}
begin
  new(result,Create);
  result.FSize:=DesiredSize;

  result.FMappingHandle :=
     CreateFileMapping(
       $FFFFFFFF,        {no file-use Windows swap file}
       nil,
       page_readwrite,   {read and write access for all!}
       0,
       desiredsize,
       ObjectName);

  result.FMemory := MapViewOfFile( result.FMappingHandle, FILE_MAP_write, 0, 0, 0 );
end;


destructor TSharedMemory.Destroy;
begin
  if ( FMemory <> Nil ) then
    begin
      UnmapViewOfFile( FMemory );
      FMemory := Nil;
    end;

  if ( FMappingHandle <> 0 ) then
    CloseHandle( FMappingHandle );
  inherited Destroy;
end;

end.
