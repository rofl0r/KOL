{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  mckCtrls, Controls {$ENDIF},KOLHttpProt,KOLWSocket;
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mirror;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TForm1 = class; PForm1 = TForm1; {$ELSE OBJECTS} PForm1 = ^TForm1; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm1.inc}{$ELSE} TForm1 = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    URLEdit: TKOLEditBox;
    FileNameEdit: TKOLEditBox;
    ProxyHostEdit: TKOLEditBox;
    ProxyPortEdit: TKOLEditBox;
    GetButton: TKOLButton;
    AbortButton: TKOLButton;
    InfoLabel: TKOLLabel;
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure AbortButtonClick(Sender: PObj);
    procedure GetButtonClick(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure HttpCli1DocData(Sender: PObj; Buffer: Pointer;
  Len: Integer);
    procedure HttpCli1HeaderData(Sender: PObj);
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;
  HttpCli1:PHttpCli;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}


const
    SectionData   = 'Data';
    KeyURL        = 'URL';
    KeyProxyHost  = 'ProxyHost';
    KeyProxyPort  = 'ProxyPort';
    KeyFileName   = 'FileName';
    SectionWindow = 'Window';
    KeyTop        = 'Top';
    KeyLeft       = 'Left';
    KeyWidth      = 'Width';
    KeyHeight     = 'Height';

 (*
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpGetForm.HttpCli1DocData(Sender: TObject; Buffer: Pointer;
  Len: Integer);
begin
    InfoLabel.Caption := IntToStr(HttpCli1.RcvdCount);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure THttpGetForm.HttpCli1HeaderData(Sender: TObject);
begin
    InfoLabel.Caption := InfoLabel.Caption + '.';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
*)


procedure TForm1.HttpCli1DocData(Sender: PObj; Buffer: Pointer;
  Len: Integer);
begin
    InfoLabel.Caption := Int2Str(HttpCli1.RcvdCount);
end;


procedure TForm1.HttpCli1HeaderData(Sender: PObj);
begin
    InfoLabel.Caption := InfoLabel.Caption + '.';
end;

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  HttpCli1:=NewHttpCli(nil);
  HttpCli1.OnDocData:=HttpCli1DocData;
  HttpCli1.OnHeaderData:=HttpCli1HeaderData;
  HttpCli1.LocalAddr:= '0.0.0.0';
  HttpCli1.ProxyPort:= '80';
  HttpCli1.Agent:= 'Mozilla/3.0 (compatible)';
  HttpCli1.Accept:= 'image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*';
  HttpCli1.NoCache:= False;
  HttpCli1.ContentTypePost:= 'application/x-www-form-urlencoded';
  HttpCli1.MultiThreaded:= False;
  HttpCli1.SocksLevel:= '5';
  HttpCli1.SocksAuthentication:= socksNoAuthentication;
end;

procedure TForm1.AbortButtonClick(Sender: PObj);
begin
  HttpCli1.Abort;
end;

procedure TForm1.GetButtonClick(Sender: PObj);
begin
HttpCli1.URL        := URLEdit.Text;
    HttpCli1.Proxy      := ProxyHostEdit.Text;
    HttpCli1.ProxyPort  := ProxyPortEdit.Text;
    HttpCli1.RcvdStream := NewReadWriteFileStream(FileNameEdit.Text);//TFileStream.Create(FileNameEdit.Text, fmCreate);
    GetButton.Enabled   := FALSE;
    AbortButton.Enabled := TRUE;
    InfoLabel.Caption   := 'Loading';
//    try
//        try
            HttpCli1.Get;
            InfoLabel.Caption := 'Received ' +
                                 Int2Str(HttpCli1.RcvdStream.Size) + ' bytes';
       { except
            on E: EHttpException do}
            begin
             //   InfoLabel.Caption := 'Failed : ' +
             //                        Int2Str(HttpCli1.StatusCode) + ' ' +
             //                        HttpCli1.ReasonPhrase;;
            end;
{            else
                raise;}
//        end;
 //   finally
        GetButton.Enabled   := TRUE;
        AbortButton.Enabled := FALSE;
        HttpCli1.RcvdStream.Free;//Destroy;
        HttpCli1.RcvdStream := nil;
  //  end;
end;

end.


