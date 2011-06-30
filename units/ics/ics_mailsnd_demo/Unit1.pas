{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes,
  mckCtrls, Controls {$ENDIF},KOLSmtpProt;
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
    Button1: TKOLButton;
    Button2: TKOLButton;
    Button3: TKOLButton;
    Button4: TKOLButton;
    Button5: TKOLButton;
    Button6: TKOLButton;
    Button7: TKOLButton;
    Button8: TKOLButton;
    Button9: TKOLButton;
    QuitButton: TKOLButton;
    AbortButton: TKOLButton;
    ClearDisplayButton: TKOLButton;
    AllInOneButton: TKOLButton;
    MsgMemo: TKOLMemo;
    Memo2: TKOLMemo;
    DisplayMemo: TKOLMemo;
    HostEdit: TKOLEditBox;
    FromEdit: TKOLEditBox;
    CcEdit: TKOLEditBox;
    SubjectEdit: TKOLEditBox;
    EditBox5: TKOLEditBox;
    PortEdit: TKOLEditBox;
    ToEdit: TKOLEditBox;
    BccEdit: TKOLEditBox;
    SignOnEdit: TKOLEditBox;
    EditBox10: TKOLEditBox;
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure AllInOneButtonClick(Sender: PObj);
    procedure QuitButtonClick(Sender: PObj);
    procedure AbortButtonClick(Sender: PObj);
    procedure ClearDisplayButtonClick(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure BuildRcptList;
    procedure SmtpClientGetData(
    Sender  : PObj;
    LineNum : Integer;
    MsgLine : Pointer;
    MaxLen  : Integer;
    var More: Boolean);
    procedure SmtpClientRequestDone(
    Sender : PObj;
    RqType : TSmtpRequest;
    Error  : Word);
    procedure Display(const Msg : String);
    procedure SmtpClientHeaderLine(
    Sender : PObj;
    Msg    : Pointer;
    Size   : Integer);
    procedure SmtpClientDisplay(Sender: PObj; Msg: String);
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;
  SmtpClient:PSmtpCli;
  FAllInOneFlag:Boolean;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

(*

const
    SectionData   = 'Data';
    KeyHost       = 'HostName';
    KeyPort       = 'Port';
    KeyFrom       = 'From';
    KeyTo         = 'To';
    KeyCc         = 'Cc';
    KeyBcc        = 'Bcc';
    KeySubject    = 'Subject';
    KeySignOn     = 'SignOn';
    KeyUser       = 'UserName';
    KeyPass       = 'Password';
    KeyAuth       = 'Authentification';
    SectionWindow = 'Window';
    KeyTop        = 'Top';
    KeyLeft       = 'Left';
    KeyWidth      = 'Width';
    KeyHeight     = 'Height';

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Display a message in display memo box, making sure we don't overflow it.  }



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSmtpTestForm.FormCreate(Sender: TObject);
begin
    Application.OnException := ExceptionHandler;
    DisplayMemo.Clear;
    FIniFileName := LowerCase(ExtractFileName(Application.ExeName));
    FIniFileName := Copy(FIniFileName, 1, Length(FIniFileName) - 3) + 'ini';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSmtpTestForm.FormShow(Sender: TObject);
var
    IniFile : TIniFile;
begin
    if not FInitialized then begin
        FInitialized := TRUE;
        IniFile := TIniFile.Create(FIniFileName);
        HostEdit.Text    := IniFile.ReadString(SectionData, KeyHost,
                                               'localhost');
        PortEdit.Text    := IniFile.ReadString(SectionData, KeyPort,
                                               'smtp');
        FromEdit.Text    := IniFile.ReadString(SectionData, KeyFrom,
                                               'first.last@company.com');
        ToEdit.Text      := IniFile.ReadString(SectionData, KeyTo,
                                               'john.doe@acme;tartempion@brol.fr');
        CcEdit.Text      := IniFile.ReadString(SectionData, KeyCc,
                                               '');
        BccEdit.Text     := IniFile.ReadString(SectionData, KeyBcc,
                                               'francois.piette@swing.be');
        SubjectEdit.Text := IniFile.ReadString(SectionData, KeySubject,
                                               'This is the message subject');
        SignOnEdit.Text  := IniFile.ReadString(SectionData, KeySignOn,
                                               'your name');
        UsernameEdit.Text :=  IniFile.ReadString(SectionData, KeyUser,
                                               'account name');
        PasswordEdit.Text      :=  IniFile.ReadString(SectionData, KeyPass,
                                               'account password');
        AuthComboBox.ItemIndex :=  IniFile.ReadInteger(SectionData, KeyAuth,
                                               0);

        Top    := IniFile.ReadInteger(SectionWindow, KeyTop,    (Screen.Height - Height) div 2);
        Left   := IniFile.ReadInteger(SectionWindow, KeyLeft,   (Screen.Width - Width) div 2);
        Width  := IniFile.ReadInteger(SectionWindow, KeyWidth,  Width);
        Height := IniFile.ReadInteger(SectionWindow, KeyHeight, Height);

        IniFile.Free;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSmtpTestForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
    IniFile : TIniFile;
begin
    IniFile := TIniFile.Create(FIniFileName);
    IniFile.WriteString(SectionData, KeyHost,      HostEdit.Text);
    IniFile.WriteString(SectionData, KeyPort,      PortEdit.Text);
    IniFile.WriteString(SectionData, KeyFrom,      FromEdit.Text);
    IniFile.WriteString(SectionData, KeyTo,        ToEdit.Text);
    IniFile.WriteString(SectionData, KeyCc,        CcEdit.Text);
    IniFile.WriteString(SectionData, KeyBcc,       BccEdit.Text);
    IniFile.WriteString(SectionData, KeySubject,   SubjectEdit.Text);
    IniFile.WriteString(SectionData, KeySignOn,    SignOnEdit.Text);
    IniFile.WriteString(SectionData, KeyUser,      UsernameEdit.Text);
    IniFile.WriteString(SectionData, KeyPass,      PasswordEdit.Text);
    IniFile.WriteInteger(SectionData, KeyAuth,     AuthComboBox.ItemIndex);
    IniFile.WriteInteger(SectionWindow, KeyTop,    Top);
    IniFile.WriteInteger(SectionWindow, KeyLeft,   Left);
    IniFile.WriteInteger(SectionWindow, KeyWidth,  Width);
    IniFile.WriteInteger(SectionWindow, KeyHeight, Height);
    IniFile.Free;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF VER80}
function TrimRight(Str : String) : String;
var
    i : Integer;
begin
    i := Length(Str);
    while (i > 0) and (Str[i] = ' ') do
        i := i - 1;
    Result := Copy(Str, 1, i);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TrimLeft(Str : String) : String;
var
    i : Integer;
begin
    if Str[1] <> ' ' then
        Result := Str
    else begin
        i := 1;
        while (i <= Length(Str)) and (Str[i] = ' ') do
            i := i + 1;
        Result := Copy(Str, i, Length(Str) - i + 1);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Trim(Str : String) : String;
begin
    Result := TrimLeft(TrimRight(Str));
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSmtpTestForm.ExceptionHandler(Sender: TObject; E: Exception);
begin
    Application.ShowException(E);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Connect to the mail server }
procedure TSmtpTestForm.ConnectButtonClick(Sender: TObject);
begin
    FAllInOneFlag   := FALSE;
    SmtpClient.Host := HostEdit.Text;
    SmtpClient.Port := PortEdit.Text;
    SmtpClient.Connect;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Send HELO command with our local identification }
procedure TSmtpTestForm.HeloButtonClick(Sender: TObject);
begin
    FAllInOneFlag              := FALSE;
    SmtpClient.SignOn          := SignOnEdit.Text;
    SmtpClient.Helo;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSmtpTestForm.EhloButtonClick(Sender: TObject);
begin
    FAllInOneFlag              := FALSE;
    SmtpClient.SignOn          := SignOnEdit.Text;
    SmtpClient.EHlo;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSmtpTestForm.AuthButtonClick(Sender: TObject);
begin
    FAllInOneFlag              := FALSE;
    SmtpClient.Username        := UsernameEdit.Text;
    SmtpClient.Password        := PasswordEdit.Text;
    SmtpClient.AuthType        := TSmtpAuthType(AuthComboBox.ItemIndex);
    SmtpClient.Auth;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Open is Connect and Helo methods combined }
procedure TSmtpTestForm.OpenButtonClick(Sender: TObject);
begin
    FAllInOneFlag              := FALSE;
    SmtpClient.Host   := HostEdit.Text;
    SmtpClient.Port   := PortEdit.Text;
    SmtpClient.SignOn := SignOnEdit.Text;
    SmtpClient.Open;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Send originator }
procedure TSmtpTestForm.MailFromButtonClick(Sender: TObject);
begin
    FAllInOneFlag              := FALSE;
    SmtpClient.FromName        := FromEdit.Text;
    SmtpClient.MailFrom;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Send recipients }
procedure TSmtpTestForm.RcptToButtonClick(Sender: TObject);
begin
    FAllInOneFlag              := FALSE;
    BuildRcptList;
    SmtpClient.RcptTo;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Send text and attached files to mail server }
procedure TSmtpTestForm.DataButtonClick(Sender: TObject);
begin
    FAllInOneFlag              := FALSE;
    BuildRcptList;
    SmtpClient.HdrFrom         := FromEdit.Text;
    SmtpClient.HdrTo           := ToEdit.Text;
    SmtpClient.HdrCc           := CcEdit.Text;
    SmtpClient.HdrSubject      := SubjectEdit.Text;
    SmtpClient.EmailFiles      := FileAttachMemo.Lines;
    SmtpClient.Data;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ MailFrom, RcptTo and Data methods combined }
procedure TSmtpTestForm.MailButtonClick(Sender: TObject);
begin
    FAllInOneFlag              := FALSE;
    BuildRcptList;
    SmtpClient.HdrFrom         := FromEdit.Text;
    SmtpClient.HdrTo           := ToEdit.Text;
    SmtpClient.HdrTo           := CcEdit.Text;
    SmtpClient.HdrSubject      := SubjectEdit.Text;
    SmtpClient.SignOn          := SignOnEdit.Text;
    SmtpClient.FromName        := FromEdit.Text;
    SmtpClient.EmailFiles      := FileAttachMemo.Lines;
    SmtpClient.Host            := HostEdit.Text;
    SmtpClient.Port            := PortEdit.Text;
    SmtpClient.Mail;
end;



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}


*)

procedure TForm1.BuildRcptList;
var
    Buf : String;
    I   : Integer;
begin
    SmtpClient.RcptName.Clear;
    // Recipient list is the sum of To, Cc and Bcc fields
    Buf := '';
    if Length(Trim(ToEdit.Text)) > 0 then
        Buf := Trim(ToEdit.Text);
    if Length(Trim(CcEdit.Text)) > 0 then
        Buf := Buf + ';' + Trim(CcEdit.Text);
    if Length(Trim(BccEdit.Text)) > 0 then
        Buf := Buf + ';' + Trim(BccEdit.Text);
    if (Length(Buf) > 0) and (Buf[1] = ';') then
        Buf := Trim(Copy(Buf, 2, Length(Buf)));
    while TRUE do begin
        I := Pos(';', Buf);
        if I <= 0 then begin
            SmtpClient.RcptName.Add(Trim(Buf));
            break;
        end
        else begin
            SmtpClient.RcptName.Add(Trim(Copy(Buf, 1, I - 1)));
            Delete(Buf, 1, I);
        end;
    end;
end;

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
  SmtpClient:=NewSmtpCli(nil);
  SmtpClient.OnGetData:=SmtpClientGetData;
  SmtpClient.OnHeaderLine:=SmtpClientHeaderLine;
  SmtpClient.OnDisplay:=SmtpClientDisplay;
  SmtpClient.OnRequestDone:=SmtpClientRequestDone;
end;

procedure TForm1.AllInOneButtonClick(Sender: PObj);
begin
    if SmtpClient.Connected then begin
        MessageBeep(MB_OK);
        Display('All-In-One demo start in non connected state.');
        Display('Please quit or abort the connection first.');
        Exit;
    end;

    FAllInOneFlag              := TRUE;

    { Initialize all SMTP component properties from our GUI }
    SmtpClient.Host            := HostEdit.Text;
    SmtpClient.Port            := PortEdit.Text;
    SmtpClient.SignOn          := SignOnEdit.Text;
    SmtpClient.FromName        := FromEdit.Text;
    SmtpClient.HdrFrom         := FromEdit.Text;
    SmtpClient.HdrTo           := ToEdit.Text;
    SmtpClient.HdrCc           := CcEdit.Text;
    SmtpClient.HdrSubject      := SubjectEdit.Text;
//    SmtpClient.EmailFiles      := FileAttachMemo.Lines;
    { Recipient list is computed from To, Cc and Bcc fields }
    { We use a little function to do that.                  }
    BuildRcptList;
    { Start first operation to do to send an email          }
    { Next operations are started from OnRequestDone event  }
    SmtpClient.Connect;
end;

procedure TForm1.QuitButtonClick(Sender: PObj);
begin
  FAllInOneFlag              := FALSE;
  SmtpClient.Quit;
end;

procedure TForm1.AbortButtonClick(Sender: PObj);
begin
  FAllInOneFlag              := FALSE;
  SmtpClient.Abort;
end;

procedure TForm1.SmtpClientGetData(
    Sender  : PObj;
    LineNum : Integer;
    MsgLine : Pointer;
    MaxLen  : Integer;
    var More: Boolean);
var
    Len : Integer;
begin
    if LineNum > MsgMemo.count then
        More := FALSE
    else begin
        Len := Length(MsgMemo.Items[LineNum - 1]);
        { Truncate the line if too long (should wrap to next line) }
        if Len >= MaxLen then
            StrPCopy(MsgLine, Copy(MsgMemo.Items[LineNum - 1], 1, MaxLen - 1))
        else
            StrPCopy(MsgLine, MsgMemo.Items[LineNum - 1]);
    end;
end;

procedure TForm1.SmtpClientRequestDone(
    Sender : PObj;
    RqType : TSmtpRequest;
    Error  : Word);
begin
    { For every operation, we display the status }
    Display('RequestDone Rq=' + Int2Str(Ord(RqType)) +
                          ' Error='+ Int2Str(Error));
    { Check if the user has asked for "All-In-One" demo }
    if not FAllInOneFlag then
        Exit;             { No, nothing more to do here }
    { We are in "All-In-One" demo, start next operation }
    { But first check if previous one was OK            }
    if Error <> 0 then begin
        FAllInOneFlag := FALSE;   { Terminate All-In-One demo }
        Display('Error, stoped All-In-One demo');
        Exit;
    end;
    case RqType of
    smtpConnect:  SmtpClient.Helo;
    smtpHelo:     SmtpClient.MailFrom;
    smtpMailFrom: SmtpClient.RcptTo;
    smtpRcptTo:   SmtpClient.Data;
    smtpData:     SmtpClient.Quit;
    smtpQuit:     Display('All-In-One done !');
    end;
end;

procedure TForm1.Display(const Msg : String);
begin
    DisplayMemo.BeginUpdate;
    try
        if DisplayMemo.Count > 200 then begin
            { We preserve only 200 lines }
            while DisplayMemo.Count > 200 do
                DisplayMemo.Delete(0);
        end;
        DisplayMemo.Add(Msg);
    finally
        DisplayMemo.EndUpdate;
        { Makes last line visible }
        {$IFNDEF VER80}
        SendMessage(DisplayMemo.Handle, EM_SCROLLCARET, 0, 0);
        {$ENDIF}
    end;
end;

procedure TForm1.SmtpClientHeaderLine(
    Sender : PObj;
    Msg    : Pointer;
    Size   : Integer);
begin
    { This demonstrate how to add a line to the message header              }
    { Just detect one of the header lines and add text at the end of this   }
    { line. Use #13#10 to form a new line                                   }
    { Here we check for the From: header line and add a Comments: line      }
//    if StrLIComp(Msg, 'From:', 5) = 0 then
//        StrCat(Msg, #13#10 + 'Comments: This is a test');
end;


procedure TForm1.ClearDisplayButtonClick(Sender: PObj);
begin
  DisplayMemo.Clear;
end;


procedure TForm1.SmtpClientDisplay(Sender: PObj; Msg: String);
begin
    Display(Msg);
end;

end.


