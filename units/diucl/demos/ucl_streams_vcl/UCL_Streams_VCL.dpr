program UCL_Streams_VCL;

uses
  Forms,
  UCL_Streams_VCL_Form in 'UCL_Streams_VCL_Form.pas' {frmStreamVCL};

{$R *.res}

begin
  with Application do
    begin
      Initialize;
      CreateForm(TFrmStreamVCL, frmStreamVCL);
      Run;
    end;
end.

