{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  Controls, mckCtrls, mckObjs {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mirror;
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
    Label1: TKOLLabel;
    Edit1: TKOLEditBox;
    Button1: TKOLButton;
    OpenDlg: TKOLOpenSaveDialog;
    Label2: TKOLLabel;
    Edit2: TKOLEditBox;
    Button2: TKOLButton;
    ListBox1: TKOLListBox;
    DirDlg: TKOLOpenDirDialog;
    Label3: TKOLLabel;
    Bar1: TKOLProgressBar;
    Bar2: TKOLProgressBar;
    Button3: TKOLButton;
    Button4: TKOLButton;
    Button5: TKOLButton;
    Button6: TKOLButton;
    Label4: TKOLLabel;
    Edit3: TKOLEditBox;
    ListBox2: TKOLListBox;
    procedure Button3Click(Sender: PObj);
    procedure Button6Click(Sender: PObj);
    procedure Button4Click(Sender: PObj);
    procedure Button5Click(Sender: PObj);
    procedure Button1Click(Sender: PObj);
    procedure Button2Click(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;
  Count: cardinal = 0;
  BytesExtracted: cardinal = 0;
  CompressedSize: cardinal = 0;
  UnzippedSize: integer = 0;
  Curr: cardinal = 0;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

uses UnZIP;

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

{
  Report вызывается при записи распакованных данных файла.
  Запись R содержит информацию о текущем файле.
  Переменная Retcode содержит объем записанных в выходной файл распакованных
  данных.
}

procedure Report(Retcode: integer; R: PReportRec);
begin
  with R^ do
    begin
      case Status of
        File_Starting:  begin
                          Form1.Form.ProcessMessage;
                          Curr:=0;
                          Form1.Label3.Caption:=FileName;
                          Form1.Bar2.Progress:=0;
                          Form1.Form.ProcessMessage;
                        end;
        File_Completed: begin
                          Form1.Form.ProcessMessage;
                          Curr:=0;
                          Form1.Label3.Caption:='';
                          Form1.Bar1.Progress:=0;
                          Form1.Bar2.Progress:=0;
                          Form1.Form.ProcessMessage;
                        end;
        File_Unzipping: if Retcode>0 then
                          begin
                            Inc(BytesExtracted,Retcode);
                            Form1.Form.ProcessMessage;
                            Form1.Bar1.Progress:=MulDiv(Curr,100,R^.Size);
                            Form1.Bar2.Progress:=MulDiv(BytesExtracted,100,UnzippedSize);
                            Inc(Curr,Retcode);
                            Form1.Form.ProcessMessage;
                          end;
        Unzip_Completed:  begin
                            Form1.Form.ProcessMessage;
                            Curr:=0;
                            Form1.Bar1.Progress:=0;
                            Form1.Bar2.Progress:=0;
                            Form1.Form.ProcessMessage;
                          end;
      end;
    end;
end;

{ Report2 используется для передачи в программу содержимого zip-архива
  Запись R содержит информацию о текущем файле.
}

procedure Report2(Retcode: integer; R: PReportRec);
begin
  if R^.Status<>Unzip_Completed then Form1.ListBox1.Add(R^.Filename);
end;

procedure ShowStats;
begin
  Form1.ListBox2.Clear;
  Form1.ListBox2.Add('Statistics:');
  Form1.ListBox2.Add('Files: '+Int2Str(Count));
  Form1.ListBox2.Add('Real size: '+Int2Str(UnzippedSize));
  Form1.ListBox2.Add('Compressed: '+Int2Str(CompressedSize));
  Form1.ListBox2.Add('Ratio: '+Int2Str(CalcRatio(CompressedSize,UnzippedSize))+'%');
end;

procedure TForm1.Button3Click(Sender: PObj);
begin
  UnzippedSize:=UnzipSize(Edit1.Text,CompressedSize);
  Count:=ViewZip(Edit1.Text,Edit3.Text,Report2);
  ShowStats;
end;

procedure TForm1.Button6Click(Sender: PObj);
begin
  ListBox1.Clear;
  Edit1.Text:='';
  ListBox2.Clear;
end;

procedure TForm1.Button4Click(Sender: PObj);
begin
   ListBox1.Clear;
   ListBox2.Clear;
   UnzippedSize:=UnzipSize(Edit1.Text,CompressedSize);
   Count:=ViewZip(Edit1.Text,Edit3.Text,Report2);
   ShowStats;
end;

procedure TForm1.Button5Click(Sender: PObj);
begin
  CompressedSize:=0;
  Bar1.Progress:=0;
  Bar2.Progress:=0;
  BytesExtracted:=0;
  UnzippedSize:=UnzipSize(Edit1.Text,CompressedSize);
  Count:=FileUnzip(Edit1.Text,Edit2.Text,Edit3.Text,Report,nil);
end;

procedure TForm1.Button1Click(Sender: PObj);
begin
  if OpenDlg.Execute then
    begin
      Edit1.Text:=OpenDlg.Filename;
      Button4.Click;
    end;
end;

procedure TForm1.Button2Click(Sender: PObj);
begin
  if DirDlg.Execute then Edit2.Text:=DirDlg.Path;
end;

end.

