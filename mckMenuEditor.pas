unit mckMenuEditor;

interface

{$I KOLDEF.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ComCtrls,
//*///////////////////////////////////////
     {$IFDEF _D6orHigher}               //
     DesignIntf, DesignEditors,         //
     {$ELSE}                            //
//////////////////////////////////////////
  DsgnIntf,
//*///////////////////////////////////////
     {$ENDIF}                           //
//*///////////////////////////////////////
  ToolIntf, EditIntf, ExptIntf;

  {$I MckMenuEditor.inc}

end.

