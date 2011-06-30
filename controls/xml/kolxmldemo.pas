unit kolxmldemo;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:5-3-2003 23:04:03
//********************************************************************

interface
uses
  Windows, Kol, kolxmlObjects;

type

PForm1=^TForm1;
TForm1=object(Tobj)
  Form:pControl;
  memo:pControl;
public
  procedure FormShow(sender:pObj);
end;


procedure NewForm1( var Result: PForm1; AParent: PControl );

var
  Form1:pForm1;

implementation

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin
  New(Result,Create);
  with Result^ do
  begin
    Form:= NewForm(AParent,'KOLForm').SetSize(600,400);
    Applet:=Form;
    Form.Add2AutoFree(Result);
    Form.OnShow:=FormShow;
    Memo:=neweditbox(Form,[eoMultiline]).SetAlign(caClient);
    memo.Color:=clWhite;
  end;
end;



procedure Tform1.FormShow(Sender: pObj);
var
  MemStream:  pStream;
  Invoice:    pXmlDDocument;
  Items:      pXmlDElement;
  Item:       pXmlDElement;
  RootElmt:   pXmlDElement;
begin
  Invoice := NewXmlDDocument;
  Invoice.NodeName := 'CustomerInvoice';
    Invoice.AppendChild(Invoice.CreateComment(
        ' The Buy-More-Great Music Club  '));
    Invoice.AppendChild(Invoice.CreateComment(
        '      Customer Statement        '));
    RootElmt := Invoice.CreateElement('CustomerInvoice');
    Invoice.AppendChild(RootElmt);
    RootElmt.AppendChild(Invoice.CreateElement(
        'MemberNumber', '017883  B8  ZG1'));
    RootElmt.AppendChild(Invoice.CreateElement(
        'InvoiceDate', '20030305'));
    Items := Invoice.CreateElement('Items');
    RootElmt.AppendChild(Items);
      Item := Invoice.CreateElement('Item');
      Items.AppendChild(Item);
      Item.AppendChild(Invoice.CreateElement(
          'CatalogNumber', '2561215', 'Format', 'CD'));
      Item.AppendChild(Invoice.CreateElement(
          'Artist', 'Joie Dead Blond Girlfriend'));
      Item.AppendChild(Invoice.CreateElement(
          'homepage', 'http://www.joiedbg.com'));
      Item.AppendChild(Invoice.CreateElement(
          'Price', '5.66', 'Terms', '66% Off'));
      Item.AppendChild(Invoice.CreateElement(
          'Shipping', '2.59'));
      Item.AppendChild(Invoice.CreateElement(
          'Tax', '0.66', 'TaxLocale', 'NY'));
      Item.AppendChild(Invoice.CreateElement(
          'ItemTotal', '8.91'));
    RootElmt.AppendChild(Invoice.CreateElement(
        'AmountDue', '8.91'));

  MemStream := NewMemoryStream;
  Invoice.SaveToStream(MemStream, true);
 // MemStream.Position := 0;
  //**********************************************
  // Hack Alert!  Same as LoadFromStream, but that
  // doesn't exist in KOL for simple memo's.
  //**********************************************
//Also possible, but not failsafe:  Memo.Text:=Pchar(Memstream.memory);//
  memo.Text:=Copy(Pchar(MemStream.Memory),1,memStream.Size);
  //
  MemStream.Free;
  Invoice.Free;
end;

end.