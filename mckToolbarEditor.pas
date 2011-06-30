unit mckToolbarEditor;

interface

{$I KOLDEF.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, {$IFDEF _D3orHigher} ExtDlgs, {$ENDIF}
//////////////////////////////////////////////////
     {$IFDEF _D6orHigher}                       //
     DesignIntf, DesignEditors, DesignConst,    //
     Variants                                   //
     {$ELSE}                                    //
//////////////////////////////////////////////////
     DsgnIntf
//////////////////////////////////////////////////
     {$ENDIF}                                   //
//////////////////////////////////////////////////
  {$IFNDEF _D2}{$IFNDEF _D3},ImgList{$ENDIF}{$ENDIF};

{$i mckToolbarEditor.inc}

end.
