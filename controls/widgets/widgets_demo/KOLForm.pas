{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit KOLForm;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, WidGet {$IFNDEF KOL_MCK}, mirror, Classes,  mckObjs, Controls, mckCtrls, mckwidget {$ENDIF};
{$ELSE}
{$I uses.inc} mirror,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  PForm1 = ^TForm1;
  TForm1 = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject: TKOLProject;
    KOLForm: TKOLForm;
    wg1: TKOLWidget;
    wg2: TKOLWidget;
    wg3: TKOLWidget;
    PMn: TKOLPopupMenu;
    KA: TKOLApplet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

uses winsock;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I KOLForm_1.inc}
{$ENDIF}

function WSAEnumProtocols(p: pointer; var b; var s: integer): integer; stdcall; external 'ws2_32.dll' name 'WSAEnumProtocolsA';

type
   WSAProtocol_Info = record
   SF1,
   SF2,
   SF3,
   SF4,
   PRF: DWORD;
   ProviderID: TGUID;
   CatalogEID: DWORD;
   ProtocolCH: DWORD;
   ChainEntie: array[0..6] of DWORD;
   buf: array[0..10] of DWORD;
   szProtocol: array[0..254] of char;
   end;

end.









