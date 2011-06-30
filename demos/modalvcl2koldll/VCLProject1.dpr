program VCLProject1;

uses
  Forms,
  VCLUnit1 in 'VCLUnit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
