unit VCLUnit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

procedure CallKOLFormModal; external 'KOLDll.dll' name 'CallKOLFormModal';

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  CallKOLFormModal;
end;

end.