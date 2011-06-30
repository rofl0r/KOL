program vcldrivertest;

uses
  Forms,
  vcltestdriver1 in 'vcltestdriver1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
