KOL Help Generator v3.0 (19-Apr-2001)
Copyright (C) 2000-2001 by Vladimir Kladov
----------------------------------------------------
This utility is intended to generate help files for
KOL and/or XCL (http://xcl.cjb.net) in html format. 
Generation is automatic (on base of comments in the
siurce) and is occure every time when xHelpGen discover
that sources are changed.

Installation:
-------------
1. Unpack XHelpGen.exe where You wish (it is a good idea to
unpack it into your KOL directory).
2. If You wish, You can add it into Tools menu manually:
(Tools|Configure|Add...) and launch it from IDE menu.
Either, launch it (e.g. by mouse doule click) to
generate new version of the help.

Usage:
------
Just run it in the directory where sources containing
comments (defined below) are located. Or run it, passing
directory with sources as a parameter.
  For instance, KOL.PAS contains such comments.

----------------------------------------------------------
As it is said, help files are generated automatically on
base of comments {* }, placed into pas-files (in interface
part).
  (Note: '*' character is now optional, and can be changed
to get several versions of help files on base of the same
sources).

Syntax is very easy.
All such comments must be starting from {*, and finished as
usual with }. Also, such comments must be follow certain
lines of text in source (i.e. to be located AFTER considering
line).

First of such comments must be after 'unit UnitName;' Pascal directive.
Only modules, having such comment followed unit directive, are
looking further for getting other such comments.

Comments {* } are looking for only in interface part.
Implementation part is out of consideration.

To comment global declaration of constant, variable, function
or procedure, simple type (nigher class nor record), just place
{* comment } in the line, following the declaration.

To comment class or record, first place {* comment } (even
empty} after the first line of the declaration (e.g. after 
		name=class(ancestor) or name=object(ancestor)
). Only classes, having {* comment } following the first 
line of the declaration, are looking for {* comments } for its
fields, methods and properties of the class/record.

Private fields are not considering.
To comment any public or protected field, method or property,
place {* comment } in the line, following declaration of
commented item.

It is also possible to place {* comment } after directive 'end;',
finishing class/record declaration. This comment will be appearing
in common 'Tasks' part of the html-file, corresponding to the 
class/object.

All {* comment } text is reformatted before placing it into docs,
and all words, which can refer to other parts of the
documentation, are represented with html links. To prevent 
for word to become a link, write it in small case (not Index, 
but index).

Comments {* } for class declaration if are started with {*! 
after class/object head are showing with bold font in class tree.
Recommended for most important end-use classes.

Also it is possible to insert text without changes, including
any html tags. Lines of {* comment }, started from
'|' character (may be, with leading spaces), are placed into html
doc file without chages (symbol '|' is removed, therefore).

Starting from v1.1, capability added to create tagged macroses - to
make comments more readable and compact.
  To create macro, insert definition line '|&X=macro' (without
quotes) into any {* comments } (only into comments under consideration,
i.e. following some Pascal constructions, listed above). Definition
must be placed before first usage of a macro.
Letter X - any capital A-Z letter or digit. Macro - any characters
You wish. Combinations %n (n - decimal number) are considered as
a references to macro parameters.
  To use macro, insert anywhere <X params> (even in line without
first '|' symbol - macro is always inserted as a separate line
into html. Params are not necessary and can be separated with commas
e.g. <Xparam1, param2, param3>. Spaces are Trim'med. Reference to
%0 parameter can be used to get all the parameters as a single line
(with internal spaces and commas).
  Macro ones defined is available down to the end of the unit. And
can be redefined just by defining a macro with the same capital
letter (digit).

new in version 1.4:
- added intro into index.htm (is inserted from intro.bdy file);
- added buttons and javascript functions to show units/classes
  sorted or by dependances, and to expand/collapse all classes
  in tree. Cookies are used to save/restore view state You
  prefer.

  Starting from version 1.5, xHelpGen automatically generates samples,
Sample is starting from a string, beginning with '|*sample title' 
(without quotas), and is finishing with line '|*'. All lines between 
those two are considered as a sample text topic (which can contain also Pascal code, starting from '!' -
see below).
  Sample is always placed to separate html document, and a link is generated to html document with a sample.

  Also, starting from v1.5, lines starting from character '!', are
considering as containing Pascal code, and some syntax highlighting
is provided for such code. (This is useful for including samples).

  XHelpGen automatically inserts references to images with names
matching class/object name (but with .gif or .jpg extension) - if
such files are found in the directory, there help files are located.
In unit text, .gif is preferred, in class(or object) - related article .jpg is preferred (so You can provide two different images for your
class/object).

 Starting from version 2.0, program is ported from XCL to KOL,
so it became smaller. Also, following enchancements are added:
- it is possible now to pass a path to your source files as a
  command line parameter, so there are no more needs to have
  several copies of xHelpGen exe to document several different
  projects;
- it is possible to adjust several new parameters, changing
  directly xHelpGen.ini file (located in target directory).
  Such parameters are:
  o  Color scheme (colors for background and different parts of
     the text);
  o  Title of the project (appearing in index.htm);
  o  Using Webdings font instead of images (for marks "read-only",
     "protected" and so on). Now this parameter is set to 1 by
     default;
  o  It is possible to set Subfolders to 1 to scan all subfolders
     together with the target folder;
- it is possible now to document interfaces and interfaced classes.
- once more feature: special character now is configurable, and not
  only '*' can be used. Moreover, You can write several comments
  starting from different characters, e.g. {*, {+, {s, etc. to 
  generate several independant documentations on base of the same
  source. (This can be used to prepare multi-lingual documentation,
  for instance).

  Version 2.1 has some fixes for interfaced object declarations,
also default color scheme is changed.

  Version 3.0:
- multi-language/multi-aid support (several different characters
  can be used simultaneously in comments, SourcePath and ResultPath
  can be changed in ini-file, a folder to search ini-file/source
  can be set in command line as an argument);
- careful handling of 'overload', interfaces, some nested type
  definitions;
- local glossaries support ( |#name -> |<#name> , |<#name> , ... ).

-------------------CONCLUSIONS-------------------
I am sure, that this utility can be used to create
help not only for KOL or XCL. You are free to use it for such
purposes.

If You have problems with launching browser from xHelpGen.EXE
to show generated help, try following:
- change UseJavaScript key value in xHelpGen.ini (can be
  found in the same directory there xHelpGen installed)
  from No to Yes. This also can change if an article will
  be shown in the same window, or will be or not #hash
  understand by browser to go directly to a topic.

-----------------------
WEB: http://xcl.cjb.net
 or  http://kol.nm.ru

mailto: bonanzas@xcl.cjb.net
