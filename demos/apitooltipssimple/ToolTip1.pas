////////////////////////////////////////////////////////////////////////
// An example that demonstrate how to create a standard ToolTip control
// and add tools to it.
// Based on "Using ToolTip Controls" in Win32 Programmer's Reference.
////////////////////////////////////////////////////////////////////////
// A. Kubaszek  <a_kubaszek@poczta.onet.pl>

unit ToolTip1;

interface
  uses
    Windows, KOL;

function CreateTooltipWindow (hWndParent, hInstance :HWND) :HWND;
//see MSDN: "Using ToolTip Controls", CreateMyTooltip()
procedure DestroyTooltipWindow(TThwnd :HWND);

function TooltipAddTool(fTThwnd, hwndTool :HWND; const Hint :string) :boolean;
//if Hint<>'' ADDTOOL else DELTOOL

implementation

function CreateTooltipWindow (hWndParent, hInstance :HWND) :HWND;
begin
  DoInitCommonControls( ICC_WIN95_CLASSES );
    // To ensure that the common control DLL is loaded

    // CREATE A TOOLTIP WINDOW
  Result := CreateWindowEx(WS_EX_TOPMOST, TOOLTIPS_CLASS, nil,
      WS_POPUP or TTS_NOPREFIX or TTS_ALWAYSTIP,
      CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,
      hWndParent, 0, hInstance, nil );
  SetWindowPos(Result, HWND_TOPMOST, 0, 0, 0, 0,
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
end;

procedure DestroyTooltipWindow(TThwnd :HWND);
begin
  DestroyWindow(TThwnd);
end;

function TooltipAddTool(fTThwnd, hwndTool :HWND; const Hint :string) :boolean;
  var
    ti :TTOOLINFO ; // struct specifying info about tool in ToolTip control
begin
  Result:=(fTThwnd <> 0) and (hwndTool <> 0);
  if not Result then EXIT;
    // INITIALIZE MEMBERS OF THE TOOLINFO STRUCTURE
  ti.cbSize := sizeof(TTOOLINFO);
  ti.uFlags := TTF_SUBCLASS or TTF_IDISHWND;
  ti.hwnd := hwndTool;
  ti.hinst := 0;
  ti.uId := hwndTool;
  ti.lpszText := PChar(Hint);

  if (Hint <> '') then
    Result:=BOOL(SendMessage(fTThwnd, TTM_ADDTOOL, 0, LPARAM(@ti)))
  else
    SendMessage(fTThwnd, TTM_DELTOOL, 0, LPARAM(@ti));
end;

end.
