--- This archive contains an addon to KOL (Key Objects Library):
  KOLEdb.pas - a unit to access databases via OLE DB tecnology.
               This version is sufficiently power even to create
               small DB-aware applications.

version 1.165

  INSTALLATION. 
1. Extract files into the directory where KOL is installed.
2. Create any folder and extract demo project there.
   (Note: database files should be placed in a subfolder \DATA. To do so,
use Action|Extract|^Use folder name option for WinZip, or create such
subdirectory manually and upack data files otv.mdb and otv.dbf manually
there).
  
  To compile a demo, You should have KOL v1.65 AND MCK v1.65 downloaded
and installed, and to run it, Microsoft Jet Database engine should be
installed. (It ships with Microsoft Access at least. But if You have
not this DB provider, You can install and configure any other SQL-based
DB engine. The only thing, what You have to do - is to change demo
project source to configure connection string passing to NewDataSource
function. Please consult with any specialist who can be accessible for
You. Do not ask me, how to configure your DB to be working with KOLEdb.
I very doubt that I can help You in such task).

Published: 15-Apr-2001 v0.1.67
[ ] Very easy access to DB via OLE DB universal engine provided. Three
    objects: TDataSource, TSession, TQuery. It is possible to open
    database, execute command, scroll through opened dataset. String,
    integer and real fields (only) are supported. Rowset can be only read.
    Query does not support standalone parameters. Small demo, created
    visually (using MCK) provided.
    /Note/ When You open project first time, do not forget to change
    TKOLProject.sourcePath property (in the ObjectInspector).

Updated: 17-Oct-2001 v0.2.103
[ ] Post method added, IField, SField, RField properties made available
    for change, IFieldByName, RFieldByName, SFieldByName properties are
    added.

Updated: 19-Oct-2001 v0.3.104
[ ] DField property to work with ftDate field type, XFieldByName properties,
    ColType, ColTypeByName, FieldAsStr, FieldAsStrByName, IsNull, IsNullByName
    properties are added. CurIndex property direct setting fixed.

Updated: 21-Oct-2001 v0.4.105
[ ] RField property now supports currency format as well. IField improved
    to support more integer formats, including 1-, 2-, 4- bytes signed and 
    unsigned integer numbers. Also, IField can be used to access boolean
    fields. LField property added to work with 8-bytes integer fields.
    Properties RawType and RawTypeByName to return original field type
    constant.

Updated: 27-Nov-2001 v0.5.108
[ ] FieldAsHex and FieldByNameAsHex properties added to provide direct access
    to field data; methods MarkFieldModified and MarkFieldModifiedByName also
    added to make possible to mark record changed when its field data are
    modified using two properties above.
[ ] DBTYPE_DBTIMESTAMP field type fixed.

Updated: 30-Mar-2002 v0.6.124
[ ] Working with DBTYPE_R4 and reading of DBTYPE_WSTR fixed 
    - by Alexander Shakhaylo.

Updated: 5-Apr-2002 v0.7.125
[-] Readint TQuery.ColType property for case of DBTYPE_STR data type fixed
    - by Alexander Shakhaylo.
[+] Function TQuery.FirstColumn function added to return an index of the first column containing data (it can be 0 or 1, in some different cases)
    - by Alexander Shakhaylo.

Updated: 7-Feb-2003 v1.0.165
[*] Int64 changed in KOL.PAS to I64. Correspondent changes made in KOLOleDB.

=======================================================================
Copyright (C) 2001-2003 by Vladimir Kladov
All rights reserved.
=======================================================================
http://bonanzas.rinet.ru
mailto: bonanzas@online.sinor.ru