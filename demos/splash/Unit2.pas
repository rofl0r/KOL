{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit2;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  PfmSplash = ^TfmSplash;
  TfmSplash = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TfmSplash = class(TForm)
  {$ENDIF KOL_MCK}
    KOLForm1: TKOLForm;
    LabelEffect1: TKOLLabelEffect;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmSplash {$IFDEF KOL_MCK} : PfmSplash {$ELSE} : TfmSplash {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewfmSplash( var Result: PfmSplash; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit2_1.inc}
{$ENDIF}

end.
 
 


