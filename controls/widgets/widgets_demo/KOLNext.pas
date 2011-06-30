{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit KOLNext;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, WidGet {$IFNDEF KOL_MCK}, mirror, mckwidget, Classes {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  PForm2 = ^TForm2;
  TForm2 = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm2 = class(TForm)
  {$ENDIF KOL_MCK}
    KF: TKOLForm;
    WG1: TKOLWidget;
    WG2: TKOLWidget;
    WG3: TKOLWidget;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2 {$IFDEF KOL_MCK} : PForm2 {$ELSE} : TForm2 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm2( var Result: PForm2; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I KOLFor2_1.inc}
{$ENDIF}

end.















