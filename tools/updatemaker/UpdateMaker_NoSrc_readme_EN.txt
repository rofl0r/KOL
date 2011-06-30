UPDATEMAKER v3.1 Copyright (C) by Vladimir Kladov, 1999-2003
============================================================

  This application can prepare file with changes given in some
files of the directory in comparison to the older version of
the directory. Such file (with extension .upd) can be used on
another PC with the same old versions of files (to be updated)
in a directory to upgrade it to newer version. Only what needed
to do this - to have another utility UPDATER (packed size is
about 19K GUI version and 12K console version). 
  Possible usage are: patching executables, documents, etc. by
developers (you) without forcing your users to download again
Megabytes of your great software/doc; synchronizing two directories
on two different PC's with just one floppy; may be other...
don't know.

  Updated files must not be changed since it were obtained
previous time. Therefore, the UPDATER utility is capable to find out
which files are modified (length and check sum are used to do
this) and skip those files from update process.

USAGE INSTRUCTION.
1. To install the application just copy it to a directory where 
   you wish.
2. When you run it, provide correct both paths for the Old and 
   the New versions of the directory and a path to a file,
   where found changes will be stored. You also can define
   filters containing file name masks (';' separated) with usual
   wildcards '*' and '?' to include or exclude some files.
3. It is possible to launch the UPDATEMAKER with three or more
   (up to 5) command line parameters (Old directory path,
   New directory path, etc. - the order is the same as you
   can see comboboxes on the main form). If at least 3 first
   parameters are passed, all other assumed to be empty and
   update making is started automatically. Such mode is
   especially design to automate your work: just create batch
   file or a shortcut with desired paths, and run it each
   time you wish to prepare new patch-file.

  Version 3.0 is totally incompatible with preview ones.
The algorithm of preparing update is simplified and improved a lot in
comparison with Version 2 but now it is much more effective for case
when source files were changed in many places by shuffling of blocks
for example. Earlier version often created too large update file in
such case, sometimes larger then the orinal ones.

  Version 3.1 is compatible with The Updater v3.0 and 3.1, as well as
UpdateMaker v3.0 is compatible with The Updater both v3.0 and 3.1.
New feature added: directory version hint for Updater v3.1.
Such hint is used in the Updater v3.1 to rename old versions of files
updated to a name such as:
  <previous file name with extension>.<version hint>-NNN.old
By the way, Updater also creates file VERSION if the hint is present
(if such file exists, it is renamed as usual in Updater 3.0, and overriden
in Updater 3.1). The compatibility is not lost, update file format is
not changed (the first section is containing bytes [XXXX]!VERSION<#0>hint ).

------------------------------------------------------------------

  Update file format. It consists mainly of commands,
coded by a different ways depending on current context. These commands
control how data should be added to the output stream from two
input streams: older version of the source and from commands
stream itself. There are only three commands:
  INSERT, FORWARD+COPY and BACK+COPY.
INSERT inserts data directly from commands stream, FORWARD+COPY
moves caret (read position in source file) onto a certain bytes forward
and inserts given bytes count from the source, and BACK+COPY moves
the caret back onto certain offset and also inserts some amount of
bytes to the output stream.
  In most cases, these commands are coded by only one (high, 7th) bit
of a command byte. The first command in a sequence can be only
<FWD+CP> or <INSERT>, because it is not possible to move source pointer at
that time to position less than 0. So, for the first command its code
is following:
  FWD+CP: bit7=0 
  INSERT: bit7=1
  If a previous command is INSERT, following command can be only
FWD+CP or BCK+CP (otherwise it could be possible to insert both data
in a single command). So, in such case, commands are coded as follows:
  FWD+CP: bit7=0
  BCK+CP: bit7=1
  After copy commands, any of three commands can be used. So, in such
case bit7 indicates which type of command (copy or insert) is present,
and if command is copy, bit6 determines which copy command is coded:
  FWD+CP: bit7=0, bit6=0
  BCK+CP: bit7=0, bit6=1
  INSERT: bit7=1
  Least space in the byte, which determines operation, is used to
code 6 or 5 low bits of the first parameter, which means Length of
data moved (copied from the old file or inserted directly from the
command stream). All numbers used as parameters are coded in variable-
length manner, such is: highest available bit is used as a boolean
flag if a number has one more byte to code it (1-yes, 0-no). This
allows to code numbers from 0 to 127 in a single byte, numbers from
128 to 16383 in two bytes, etc.
  INSERT command requires only one variable number parameter followed
by data which are inserted. FWD+CP and BCK+CP both have two parameters:
a length of data to be copied and the second parameter is an offset
which should be used to move caret position in source file. After 
copying data the caret is also moved to be set onto the byte following
the last copied one.
  For all the commands length parameter before coding decreased, i.e
length 0 means that 1 byte should be copied or inserted. For command
FWD+CP the secons parameter (offset) is coded as is. I.e. offset 0
means that caret should not be moved before copying data. And for
command BCK+CP offset is meaning not a distance between start of
data copied but between the byte following the last byte which 
should be copyed and a byte under caret. This makes a distance
less and allows to code correspondent value in less bytes.

  A header of data section for each updated file has following data:
COUNT (4 bytes) - total size of data section correspondent to a
		certain file (including COUNT field itself); this value
		also is used to determine when to stop update process
		for a given file while applying the update.
TYPE  (1 byte)  - type of the update.
		'!' means new file creation. In such case file
		content is totally placed just after FILENAME1,
		without any commands, and the field COUNT determines
		how much data are there.
		'=' file is created on base of same-called one. 
		FILENAME2 is not used in such case.
		'<' file is created on base of some other-called,
		both FILENAME1 and FILENAME2 are present.
FILENAME1 (null-terminated) - file name to be updated or created.
FILENAME2 (null-terminated) - only for type '<'.
SRCLEN (variable length bytes number) - source file length, used for
		types '=' and '<' to check if source file is what
		expected.
CHKSUM (4 bytes) - check sum of the source file, used for types '='
		and '<' to check if the source file is the same.

  Finally, all data sections are concatenated to a single file
with extension .upd to be ready to use.

FILENAME1 and FILENAME2 are null-terminated strings, and represent
paths to file(s) starting from the directory updated as a root.
For example, a name 'Sub1\File1.txt' represents file in a subdirectory
Sub1, not in root.

  UPDATER 3.1 and UPDATEMAKER 3.1 both are published with all
sources included, ABSOLUTELY FREE. Though I reserve all rights
to it. If you use the sources, or the algorithm in your code,
you MUST refer to me. This archive contains only compiled
Win32 application. To get sources, go to the Key Objects Library
WEB-Page:
		   http://bonanzas.rinet.ru

e-mail: bonanzas@online.sinor.ru
------------------------------------------------------------
Vladimir Kladov, 20 Jan 2003.