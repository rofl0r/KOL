unit vcltestdriver1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,mmsystem, StdCtrls;
const
  DRV_CUSTOM_MESSAGE = WM_USER + 11*11*11;
  // That would be:
  // My father's birthday October, 11
  // My mother's birthday September, 11 (true!)
  // My youngest sister's Birthday November,11

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    DRV:HDRVR;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);

begin
  Drv:=OpenDriver('d:\Testdriver.dll',nil,0);
  if Drv <> HDRVR(nil) then
  begin
    Showmessage(inttostr(integer(Drv)));
    if SendDriverMessage(Drv,DRV_QUERYCONFIGURE,0,0) > 0 then
      begin
        SendDriverMessage(Drv,DRV_CONFIGURE,0,0);
        SendDriverMessage(Drv,DRV_CUSTOM_MESSAGE,0,0)
      end;
  end
  else
   Showmessage('error');
   CloseDriver(Drv,0,0);
end;

end.
