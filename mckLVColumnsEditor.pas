unit mckLVColumnsEditor;

interface

{$I KOLDEF.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls,
  {$IFDEF _D6orHigher}
  DesignIntf, DesignEditors, DesignConst, Variants
  {$ELSE}
  DsgnIntf
  {$ENDIF}
  ;

{$I mckLVColumnsEditor.inc}

end.
