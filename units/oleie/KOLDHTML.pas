unit KOLDHTML;

interface

uses KOL, DHTMLEDLib_TLBKOL;

type

    TDHTMLEDIT = DHTMLEDLib_TLBKOL.PDHTMLEDIT;
    PDHTMLEDIT = DHTMLEDLib_TLBKOL.PDHTMLEDIT;

function NewDHTMLEDIT(AOwner: PControl): PDHTMLEDIT;

implementation

function NewDHTMLEDIT;
begin
   new( Result, CreateParented( AOwner ) );
end;

end.