//////////////////////////////////////////////////
//						//
//						//
//		TKOLPDF v1.0			//
//						//
//	Author: Dimaxx (dimaxx@atnet.ru)	//
//						//
//						//
//////////////////////////////////////////////////
unit KOLPDF;

interface

uses KOL, PDF_TLB;

type
  TKOLPDF = PPDF;
  PKOLPDF = PPDF;

function NewKOLPDF(AOwner: PControl): PKOLPDF;

implementation

function NewKOLPDF;
begin
  New(Result,CreateParented(AOwner));
end;

end.

