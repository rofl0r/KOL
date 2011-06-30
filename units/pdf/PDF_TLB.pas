unit PDF_TLB;

{ converted by TLB2KOL utility }

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision:   1.88  $
// File generated on 04.09.2003 16:45:46 from Type Library described below.

// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
// ************************************************************************ //
// Type Lib: C:\Program Files\Acrobat5\Reader\ActiveX\pdf.ocx (1)
// IID\LCID: {CA8A9783-280D-11CF-A24D-444553540000}\0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\System32\STDVCL40.DLL)
// Errors:
//   Hint: Parameter 'On' of _DPdf.setShowToolbar changed to 'On_'
//   Hint: Parameter 'to' of _DPdf.printPages changed to 'to_'
//   Hint: Parameter 'to' of _DPdf.printPagesFit changed to 'to_'
//   Hint: Parameter 'On' of _DPdf.setShowScrollbars changed to 'On_'
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
interface

uses KOL, ActiveKOL, Windows, ActiveX, StdVCL;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  PdfLibMajorVersion = 1;
  PdfLibMinorVersion = 3;

  LIBID_PdfLib: TGUID = '{CA8A9783-280D-11CF-A24D-444553540000}';

  DIID__DPdf: TGUID = '{CA8A9781-280D-11CF-A24D-444553540000}';
  DIID__DPdfEvents: TGUID = '{CA8A9782-280D-11CF-A24D-444553540000}';
  CLASS_Pdf: TGUID = '{CA8A9780-280D-11CF-A24D-444553540000}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _DPdf = dispinterface;
  _DPdfEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Pdf = _DPdf;


// *********************************************************************//
// DispIntf:  _DPdf
// Flags:     (4112) Hidden Dispatchable
// GUID:      {CA8A9781-280D-11CF-A24D-444553540000}
// *********************************************************************//
  _DPdf = dispinterface
    ['{CA8A9781-280D-11CF-A24D-444553540000}']
    property src: WideString dispid 1;
    function  LoadFile(const fileName: WideString): WordBool; dispid 2;
    procedure setShowToolbar(On_: WordBool); dispid 3;
    procedure gotoFirstPage; dispid 4;
    procedure gotoLastPage; dispid 5;
    procedure gotoNextPage; dispid 6;
    procedure gotoPreviousPage; dispid 7;
    procedure setCurrentPage(n: Integer); dispid 8;
    procedure goForwardStack; dispid 9;
    procedure goBackwardStack; dispid 10;
    procedure setPageMode(const pageMode: WideString); dispid 11;
    procedure setLayoutMode(const layoutMode: WideString); dispid 12;
    procedure setNamedDest(const namedDest: WideString); dispid 13;
    procedure Print; dispid 14;
    procedure printWithDialog; dispid 15;
    procedure setZoom(percent: Single); dispid 16;
    procedure setZoomScroll(percent: Single; aleft: Single; atop: Single); dispid 17;
    procedure setView(const viewMode: WideString); dispid 18;
    procedure setViewScroll(const viewMode: WideString; offset: Single); dispid 19;
    procedure setViewRect(aleft: Single; atop: Single; awidth: Single; aheight: Single); dispid 20;
    procedure printPages(from: Integer; to_: Integer); dispid 21;
    procedure printPagesFit(from: Integer; to_: Integer; shrinkToFit: WordBool); dispid 22;
    procedure printAll; dispid 23;
    procedure printAllFit(shrinkToFit: WordBool); dispid 24;
    procedure setShowScrollbars(On_: WordBool); dispid 25;
    procedure AboutBox; dispid -552;
  end;

// *********************************************************************//
// DispIntf:  _DPdfEvents
// Flags:     (4096) Dispatchable
// GUID:      {CA8A9782-280D-11CF-A24D-444553540000}
// *********************************************************************//
  _DPdfEvents = dispinterface
    ['{CA8A9782-280D-11CF-A24D-444553540000}']
  end;

// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TPDF
// Help String      : Acrobat Control for ActiveX
// Default Interface: _DPdf
// Def. Intf. DISP? : Yes
// Event   Interface: _DPdfEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  PPDF = ^TPDF;
  TPDF = object(TOleCtl)
  private
    FIntf: _DPdf;
    function  GetControlInterface: _DPdf;
  protected
    procedure CreateControl;
    procedure InitControlData; virtual;
  public
    function LoadFile(const fileName: WideString): WordBool;
    procedure setShowToolbar(On_: WordBool);
    procedure GotoFirstPage;
    procedure GotoLastPage;
    procedure GotoNextPage;
    procedure GotoPreviousPage;
    procedure SetCurrentPage(n: Integer);
    procedure goForwardStack;
    procedure goBackwardStack;
    procedure SetPageMode(const pageMode: WideString);
    procedure SetLayoutMode(const layoutMode: WideString);
    procedure SetNamedDest(const namedDest: WideString);
    procedure Print;
    procedure PrintWithDialog;
    procedure SetZoom(percent: Single);
    procedure SetZoomScroll(percent: Single; aleft: Single; atop: Single);
    procedure SetView(const viewMode: WideString);
    procedure SetViewScroll(const viewMode: WideString; offset: Single);
    procedure SetViewRect(aleft: Single; atop: Single; awidth: Single; aheight: Single);
    procedure PrintPages(from: Integer; to_: Integer);
    procedure PrintPagesFit(from: Integer; to_: Integer; shrinkToFit: WordBool);
    procedure PrintAll;
    procedure PrintAllFit(shrinkToFit: WordBool);
    procedure SetShowScrollbars(On_: WordBool);
    procedure AboutBox;
    property  ControlInterface: _DPdf read GetControlInterface;
    property  DefaultInterface: _DPdf read GetControlInterface;
  //  published
    property  TabStop;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property src: WideString index 1 read GetWideStringProp write SetWideStringProp stored False;
  end;

//procedure Register

implementation

uses KOLComObj;

procedure TPDF.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID: '{CA8A9780-280D-11CF-A24D-444553540000}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil (*HR:$80004005*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
end;

procedure TPDF.CreateControl;
  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as _DPdf;
  end;
begin
  if FIntf = nil then DoCreate;
end;

function TPDF.GetControlInterface: _DPdf;
begin
  CreateControl;
  Result := FIntf;
end;

function  TPDF.LoadFile(const fileName: WideString): WordBool;
begin
  Result := DefaultInterface.LoadFile(fileName);
end;

procedure TPDF.setShowToolbar(On_: WordBool);
begin
  DefaultInterface.setShowToolbar(On_);
end;

procedure TPDF.gotoFirstPage;
begin
  DefaultInterface.gotoFirstPage;
end;

procedure TPDF.gotoLastPage;
begin
  DefaultInterface.gotoLastPage;
end;

procedure TPDF.gotoNextPage;
begin
  DefaultInterface.gotoNextPage;
end;

procedure TPDF.gotoPreviousPage;
begin
  DefaultInterface.gotoPreviousPage;
end;

procedure TPDF.setCurrentPage(n: Integer);
begin
  DefaultInterface.setCurrentPage(n);
end;

procedure TPDF.goForwardStack;
begin
  DefaultInterface.goForwardStack;
end;

procedure TPDF.goBackwardStack;
begin
  DefaultInterface.goBackwardStack;
end;

procedure TPDF.setPageMode(const pageMode: WideString);
begin
  DefaultInterface.setPageMode(pageMode);
end;

procedure TPDF.setLayoutMode(const layoutMode: WideString);
begin
  DefaultInterface.setLayoutMode(layoutMode);
end;

procedure TPDF.setNamedDest(const namedDest: WideString);
begin
  DefaultInterface.setNamedDest(namedDest);
end;

procedure TPDF.Print;
begin
  DefaultInterface.Print;
end;

procedure TPDF.printWithDialog;
begin
  DefaultInterface.printWithDialog;
end;

procedure TPDF.setZoom(percent: Single);
begin
  DefaultInterface.setZoom(percent);
end;

procedure TPDF.setZoomScroll(percent: Single; aleft: Single; atop: Single);
begin
  DefaultInterface.setZoomScroll(percent, aleft, atop);
end;

procedure TPDF.setView(const viewMode: WideString);
begin
  DefaultInterface.setView(viewMode);
end;

procedure TPDF.setViewScroll(const viewMode: WideString; offset: Single);
begin
  DefaultInterface.setViewScroll(viewMode, offset);
end;

procedure TPDF.setViewRect(aleft: Single; atop: Single; awidth: Single; aheight: Single);
begin
  DefaultInterface.setViewRect(aleft, atop, awidth, aheight);
end;

procedure TPDF.printPages(from: Integer; to_: Integer);
begin
  DefaultInterface.printPages(from, to_);
end;

procedure TPDF.printPagesFit(from: Integer; to_: Integer; shrinkToFit: WordBool);
begin
  DefaultInterface.printPagesFit(from, to_, shrinkToFit);
end;

procedure TPDF.printAll;
begin
  DefaultInterface.printAll;
end;

procedure TPDF.printAllFit(shrinkToFit: WordBool);
begin
  DefaultInterface.printAllFit(shrinkToFit);
end;

procedure TPDF.setShowScrollbars(On_: WordBool);
begin
  DefaultInterface.setShowScrollbars(On_);
end;

procedure TPDF.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

end.

