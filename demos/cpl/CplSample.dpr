{ KOL MCK } // Do not remove this line!
library CplSample;

uses
KOL,
  Windows,
  cplconst,
  Unit1 in 'Unit1.pas' {Main};

{$E cpl}








function CPlApplet (hWndCpl: HWnd; msg: Word; lParam1: Longint;var NewCPLInfo: TNewCPLInfo): Longint;stdcall;
begin
 case msg of
  CPL_INIT: begin
    CPlApplet:=1; // CP asks "Are you an Applet"  We reply 1 - "Yes I am"
   end;

  CPL_GETCOUNT:begin
   CPlApplet:=1;// CP asks "How many icons do you want"  We reply 1 .

  end;

  CPL_NEWINQUIRE:
   {CP sends this message once for every icon you require. In our
    case this is only sent once, so we dont need to concern ourself
    with what applet number CP wants to know about}
   begin
    with NewCPLInfo do begin
     dwSize:=sizeof(TNewCPLInfo);
     dwFlags := 0;
     dwHelpContext := 0;
     lData := 0;
     szHelpFile[0]:= #0;
     {Now comes the interesting bit; our icon and names}
     hIcon := LoadIcon(hInstance,'MAINICON');
     StrPCopy(szName,'CplSample');
     StrPCopy(szInfo,'CplSample description');
    end;
   end;

  CPL_DBLCLK:
  { Someone can also experiment with CPL_STOP or CPL_EXIT.
  This way oridinary Show can be used here and
  on CPL_STOP Main.Form.Close and Applet.Free }
  begin
  Applet         := NewApplet('');
  Applet.Visible := False;
  NewMain(Main,Applet);
  Main.Form.ShowModal;
  Applet.Free;
  end;
 end;

end;



{$R *.res}

exports
  CPLApplet;


begin // PROGRAM START HERE -- Please do not remove this comment

{$IFDEF KOL_MCK} {$I CplSample_0.inc} {$ELSE}


{$ENDIF}

end.

