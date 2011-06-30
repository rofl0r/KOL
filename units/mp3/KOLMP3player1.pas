unit KOLMP3player1;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:25-8-2003 12:40:18
//********************************************************************


interface
{$DEFINE USE_SCROLLINGLABEL}

uses
  Windows,
  messages,
  Kol,
  err,
  KOLOBuffer_Wave,
  KolOBuffer_MCI,
  KolMPEGPlayer,
  Shellapi,
  ShlObj,
  kolplayer,
  ActiveX;

const
  //My favorite shading color with black
  clSteelBlue: TColor = $FF8482;
type
  TEnumFolderFlag = (efFolders, efNonFolders, efIncludeHidden);
  TEnumFolderFlags = set of TEnumFolderFlag;
  TEnumFolderRec = record
    DisplayName: string;
    Attributes: DWORD;
    IconLarge: HICON;
    IconSmall: HICON;
    Item: PItemIdList;
    EnumIdList: IEnumIdList;
    Folder: IShellFolder;
  end;

  TUnicodePath = array[0..MAX_PATH - 1] of widechar;

type

  PForm1 = ^TForm1;
  TForm1 = object(Tobj)
    Form: pControl;
    Play: PMpegPlayer;
    PlayThread: PThread;
    List,
    Pn,
    Pnl,
    pn2,
    pn3,
    Pn4,
    Lbl1,
    lbl2,
    lbl3,
    Lbl5,
    btnOn,
    BtnSize,
    BtnRepeat,
    BtnHelp,
    BtnPrev,
    BtnNext,
    BtnExit,
    BtnDir,
    BtnPlay: PControl;
    btnList: pControl;
    Pnlbitmap,
    SmlImage,
    btnImage: pBitmap;
    Txt: Pcontrol;
    Diropendialog: POpendirdialog;
  private
    FFileList: PStrlist;
    FFilename: string;
    Offset: integer;
    MinClientHeight: integer;
    Current,
    SaveCurrent: integer;
  public
    // Add your eventhandlers here, example:
    procedure ButtonClick(Sender: pObj);
    procedure formpaint(Sender: pcontrol; dc: hdc);
    function domessage(var Msg: TMsg; var Rslt: integer): boolean;
    procedure mousedown(Sender: PControl; var Mouse: TMouseEventData);
    procedure MouseUp(Sender: PControl; var Mouse: TMouseEventData);
    procedure dropfiles(Sender: PControl; const FileList: string; const Pt: TPoint);
    function PlayFiles(Sender: pThread): integer;
    //procedure PlayFiles(sender:pObj);
    procedure providedata(Sender: PControl; Idx, SubItem: integer;
      var aTxt: string; var ImgIdx: integer; var State: DWORD;
      var Store: boolean);
    procedure ListClick(Sender: pObj);
  end;


procedure NewForm1(var Result: PForm1; AParent: PControl);
procedure GradFill(Clr1, Clr2: TColor; TheBitmap: PBitmap; Count: integer = 2);

var
  Form1: pForm1;

implementation


procedure NewForm1(var Result: PForm1; AParent: PControl);
begin
  New(Result, Create);
  with Result^ do
  begin
    Form := NewForm(AParent, 'Pico MP3 Player').centeronparent.Tabulate;
    Applet := Form;
    Form.Add2AutoFree(Result);
    Form.style := Form.Style - WS_CAPTION - WS_SYSMENU - WS_THICKFRAME;

    form.OnMessage := domessage;
    form.Margin := 0;
    Form.Border := 0;
    form.OnMouseDown := Mousedown;
    form.OnMouseUp := Mouseup;
    form.stayontop := True;
    form.ExStyle := form.ExStyle or WS_EX_ACCEPTFILES;
    form.OnDropFiles := Dropfiles;
    form.Color := clSteelblue;
    pnlbitmap := NewBitmap(245,28);
    GradFill(clSteelblue, clBlack, pnlbitmap, 1);

    pn := NewPanel(form, esNone).setsize(245,28);
    pn.Color := clBlack;
    pn.Border := 0;
    pn.margin := 5;
    pn.OnPaint := formpaint;

    pn2 := newpanel(pn, esnone).setalign(caClient);
    pn2.Height := pn.Height;
    pn2.ResizeParent;
    pn2.Color := clBlack;
    pn2.OnMouseUp := Mouseup;
    pn2.Onmousedown := Mousedown;


    Lbl1 := NewLabel(Pn2, '00.00').SetSize(30,15).Placeright;
    lbl1.Color := clBlack;
    lbl1.Font.Color := clLime;
    lbl1.Font.FontHeight := 14;
    lbl1.Font.FontName := 'Arial';
    lbl1.DoubleBuffered := True;
    lbl1.OnMouseDown := Mousedown;
    lbl1.OnMouseUp := MouseUp;

    Lbl2 := NewLabel(Pn2, '00.00').SetSize(30,15).Placeright;
    lbl2.Color := clBlack;
    lbl2.Font.Color := clRed;
    lbl2.Font.FontHeight := 14;
    lbl2.Font.FontName := 'Arial';
    lbl2.OnMouseDown := Mousedown;
    lbl2.OnMouseUp := MouseUp;

    lbl3 := NewLabel(Pn2, '000 kb/s').SetSize(30,15).Placeright.autosize(True).resizeparent;
    lbl3.Color := clBlack;
    lbl3.Font.Color := clYellow;
    lbl3.Font.FontHeight := 14;
    lbl3.Font.FontName := 'Arial';
    lbl3.OnMouseDown := Mousedown;
    lbl3.OnMouseUp := MouseUp;

    pn3 := newpanel(pn2, esnone).placeright.setsize(100,pn.Height).resizeparent;
    pn3.Border := 0;
    pn3.Height := pn.Height;
    pn3.ResizeParent;
    pn3.Color := clBlack;
    pn3.OnMouseUp := Mouseup;
    pn3.Onmousedown := Mousedown;
    lbl5 := NewLabel(Pn3, 'Pico mp3 player').SetSize(30,15).Placeright.autosize
      (True).resizeparent;
    lbl5.DoubleBuffered := True;
    lbl5.Color := clBlack;
    lbl5.Font.Color := clWhite;
    lbl5.Font.FontHeight := 14;
    lbl5.Font.FontName := 'Arial';
    lbl5.OnMouseDown := Mousedown;
    lbl5.OnMouseUp := MouseUp;

    pnl := NewPanel(form, esNone).setsize(245,28).PlaceDown.resizeparent;
    pnl.Color := clBlack;
    pnl.Border := 0;
    pnl.margin := 2;
    pnl.OnPaint := formpaint;

    btnImage := NewBitmap(60,20);
    GradFill(clSteelblue, clblack, btnimage);
    btndir := Newbitbtn(Pnl, #$3B, [bboNoBorder, bbofixed], Glyphover,
      BtnImage.handle, 2).setsize(30,20).setposition(5,5);

    btndir.Font.FontName := 'webdings';
    btndir.Font.Color := clSilver;
    btndir.TextShiftX := 1;
    btndir.TextShiftY := 1;
    btndir.OnClick := ButtonClick;
    btndir.Transparent := True;

    btnPlay := Newbitbtn(Pnl, #$34, [bboNoBorder, bboFixed], Glyphover,
      BtnImage.handle, 2).setsize(30,20).placeright;
    btnPlay.Font.Color := clLime;
    btnplay.Font.FontName := 'webdings';
    btnplay.TextShiftX := 1;
    btnplay.TextShiftY := 1;
    BtnPlay.OnClick := ButtonClick;


    btnprev := Newbitbtn(Pnl, #$39, [bboNoBorder, bbofixed], Glyphover,
      BtnImage.handle, 2).setsize(30,20).placeright.resizeparent;
    btnprev.Font.Color := clSilver;
    btnprev.Font.FontName := 'webdings';
    btnprev.TextShiftX := 1;
    btnprev.TextShiftY := 1;
    btnprev.OnClick := ButtonClick;

    btnnext := Newbitbtn(Pnl, #$3A, [bboNoBorder, bbofixed], Glyphover,
      BtnImage.handle, 2).setsize(30,20).placeright.resizeparent;
    btnnext.Font.Color := clSilver;
    btnnext.Font.FontName := 'webdings';
    btnnext.TextShiftX := 1;
    btnnext.TextShiftY := 1;
    btnnext.OnClick := ButtonClick;

    btnrepeat := Newbitbtn(Pnl, #$71, [bboNoBorder, bbofixed], Glyphover,
      BtnImage.handle, 2).setsize(30,20).placeright.resizeparent;
    btnrepeat.Font.Color := clSilver;
    btnrepeat.Font.FontName := 'webdings';
    btnrepeat.TextShiftX := 1;
    btnrepeat.TextShiftY := 1;
    btnrepeat.OnClick := ButtonClick;

    btnList := Newbitbtn(Pnl, #$36, [bboNoBorder, bbofixed], Glyphover,
      BtnImage.handle, 2).setsize(30,20).placeright.resizeparent;
    btnList.Font.Color := clSilver;
    btnList.Font.FontName := 'webdings';
    btnList.TextShiftX := 1;
    btnList.TextShiftY := 1;
    btnList.OnClick := ButtonClick;

    btnHelp := Newbitbtn(Pnl, #$69, [bboNoBorder], Glyphover,
      BtnImage.handle, 2).setsize(30,20).placeright.resizeparent;
    btnHelp.Font.Color := clSilver;;
    btnHelp.Font.FontName := 'webdings';
    btnHelp.TextShiftX := 1;
    btnHelp.TextShiftY := 1;
    btnHelp.OnClick := ButtonClick;
    MinClientheight := Form.ClientHeight;

    smlImage := NewBitmap(22,22);
    GradFill(clBlack, clred, smlimage);
    BtnExit := Newbitbtn(Pnl, '', [bboNoBorder, bbofixed], Glyphover,
      smlImage.handle, 2).setsize(10,20).placeright.resizeparent;
    btnexit.OnClick := ButtonClick;

    Pn4 := NewPanel(form, esNone).Placedown.setsize(Form.ClientWidth - 5,200);
    List := NewListView(Pn4, lvsDetail, [lvoOwnerdata, lvorowselect],
      nil, nil, nil).SetAlign(caClient);
    List.LVTextBkColor := ClBlack;
    List.LVBkColor := ClBlack;
    List.LVTextColor := ClYellow;

    List.LVColAdd('Title', taLeft, 150);
    List.LVColAdd('Location', taLeft, 150);
    List.OnLVData := Providedata;
    List.OnClick := ListClick;
    FFileList := NewStrlist;
    Form.Add2AutoFree(FFilelist);
  end;
end;


procedure TForm1.ButtonClick(Sender: pObj);
var
  i: integer;
begin
  if (Sender = btnplay) then
    if (btnPlay.Checked = True) then
    begin
      with NewOpenSaveDialog('', '', [OSAllowMultiSelect, OSFileMustExist])^ do
        if Execute then
        begin
          if assigned(Playthread) then playthread.terminate;
          Playthread := NewThreadAutofree(PlayFiles);
          Playthread.PriorityClass := THREAD_PRIORITY_IDLE;
          Playthread.threadpriority := THREAD_PRIORITY_LOWEST;

          FFileList.Clear;
          FFilelist.Text := Filename;
          //Do we have more than one file?
          if FFilelist.Count > 1 then
          begin
            //Restore full paths
            for i := 1 to FFilelist.Count - 1 do
              FFilelist.items[i] := FFilelist.Items[0] + '\' + FFilelist.items[i];
            //Delete path entry
            FFilelist.Delete(0);
          end;
          List.Count := FFilelist.Count;
          Playthread.Resume;
        end
      else
        btnplay.Checked := False;
    end;

  if Sender = BtnList then
    if btnList.Checked then
      Form.ClientHeight := form.ClientHeight + pn4.Height + 5
    else
      Form.ClientHeight := MinClientheight;

  if Sender = btnexit then
  begin
    if assigned(Playthread) then playthread.terminate;
    Form.Close;
  end;
  if (Sender = BtnHelp) then
  begin
    if fileexists(extractFilepath(ParamStr(0)) + 'picomp3.htm') then
      ShellExecute(Applet.Handle, 'open', PChar(extractFilepath(ParamStr(0))
        + 'picomp3.htm'),
        '', '', sw_ShowNormal)
    else
      MsgOk('Pico MP3 Player'#13'(C)2003, Thaddy de Koning');
  end;
end;

function TForm1.domessage(var Msg: TMsg; var Rslt: integer): boolean;
begin
  if (msg.message = WM_CLOSE) and assigned(play) then
  begin
    if assigned(Playthread) then
    begin
      Play.Stop;
      Playthread.Terminate;
    end;
    Btnplay.Checked := False;
  end;
  Result := False;
end;

function PidlToPath(IdList: PItemIdList): string;
begin
  SetLength(Result, MAX_PATH);
  if SHGetPathFromIdList(IdList, PChar(Result)) then
    Setlength(Result, strlen(PChar(Result)))
  else
    Result := '';
end;


function PidlFree(var IdList: PItemIdList): boolean;
var
  Malloc: IMalloc;
begin
  Result := False;
  if IdList = nil then
    Result := True
  else
  begin
    if Succeeded(SHGetMalloc(Malloc)) and (Malloc.DidAlloc(IdList) > 0) then
    begin
      Malloc.Free(IdList);
      IdList := nil;
      Result := True;
    end;
  end;
end;

function GetSpecialFolderLocation(const Folder: integer): string;
var
  FolderPidl: PItemIdList;
begin
  if Succeeded(SHGetSpecialFolderLocation(0, Folder, FolderPidl)) then
  begin
    Result := PidlToPath(FolderPidl);
    PidlFree(FolderPidl);
  end
  else
    Result := '';
end;



procedure TForm1.dropfiles(Sender: PControl; const FileList: string;
  const Pt: TPoint);
var
  I: integer;
  Lst: PStrlist;
  Ls: PItemIDList;
  T: string;
begin
  if not assigned(Playthread) then
  begin
    Playthread := NewThreadAutofree(PlayFiles);
    Playthread.PriorityClass := THREAD_PRIORITY_IDLE;
    Playthread.threadpriority := THREAD_PRIORITY_LOWEST;
  end;

  Lst := NewStrlist;
  try
    Lst.Add(Filelist);
    FFileList.AddStrings(Lst);
  finally
    Lst.Free;
  end;
  T := GetSpecialFolderLocation(CSIDL_RECENT);
  T := IncludeTrailingPathDelimiter(T);
  for I := FFileList.Count - 1 downto 0 do
  begin
    // Cleanup invalid drags
    if (AnsiLowercase(Extractfileext(FFilelist.Items[i])) <> '.mp3') or
      (AnsiCompareStrNoCase(T, ExtractFilepath(FFilelist.Items[i])) = 0) then
      FFilelist.Delete(i);
    // Recent file list can cause all sorts of mayhem, because it can be
    // on an unreachable media
  end;
  List.Count := FFilelist.Count;
  if list.Count > 0 then
    btnPlay.Checked := True;
end;

procedure TForm1.formpaint(Sender: pcontrol; dc: hdc);
begin
  if assigned(Pnlbitmap) then
    PnlBitmap.Draw(Sender.canvas.Handle, 0,0);
end;

procedure TForm1.ListClick(Sender: pObj);
begin
  // Invalidates the comparison, even if
  // we are in the middle of the loop
  Dec(SaveCurrent);
  // Set to the new selected title
  Current := Max(-1,List.LVCurItem - 1);
end;

procedure TForm1.mousedown(Sender: PControl; var Mouse: TMouseEventData);
begin
  if Mouse.Shift = 1 then
    form.DragStart;
end;

procedure TForm1.MouseUp(Sender: PControl; var Mouse: TMouseEventData);
begin
  form.DragStopEx;
end;

procedure GradFill(Clr1, Clr2: TColor; TheBitmap: PBitmap; Count: integer = 2);
var
  RGBFrom: array[0..2] of byte;    // from RGB values
  RGBDiff: array[0..2] of integer; // difference of from/to RGB values
  ColorBand: TRect;                // color band rectangular coordinates
  Cnt, I: integer;                 // color band index
  R: byte;                         // a color band's R value
  G: byte;                         // a color band's G value
  B: byte;                         // a color band's B value
begin
  // Based on (old) code by John Baumbach, 1996
  // email: mantis@vcnet.com
  // http://www.vcnet.com/mantisor, possibly dead link
  for Cnt := 0 to Count - 1 do
  begin
    RGBFrom[0] := GetRValue(Color2RGB(Clr1));
    RGBFrom[1] := GetGValue(Color2RGB(Clr1));
    RGBFrom[2] := GetBValue(Color2RGB(Clr1));
    // calculate difference of from and to RGB values
    RGBDiff[0] := GetRValue(Color2RGB(Clr2)) - RGBFrom[0];
    RGBDiff[1] := GetGValue(Color2RGB(Clr2)) - RGBFrom[1];
    RGBDiff[2] := GetBValue(Color2RGB(Clr2)) - RGBFrom[2];
    // set pen sytle and mode
    TheBitmap.Canvas.Pen.PenStyle := psSolid;
    TheBitmap.Canvas.Pen.PenMode := pmCopy;
    // set color band's left and right coordinates
    ColorBand.Left := Cnt * (Thebitmap.Width div Count);
    ColorBand.Right := ColorBand.Left + TheBitmap.Width div Count;
    for I := 0 to $ff do
    begin
      // calculate color band's top and bottom coordinates
      ColorBand.Top := MulDiv(I, TheBitmap.Height, $100);
      ColorBand.Bottom := MulDiv(I + 1, TheBitmap.Height, $100);
      // calculate color band color}
      R := RGBFrom[0] + MulDiv(I, RGBDiff[0], $ff);
      G := RGBFrom[1] + MulDiv(I, RGBDiff[1], $ff);
      B := RGBFrom[2] + MulDiv(I, RGBDiff[2], $ff);
      // select brush and paint color band
      TheBitmap.Canvas.Brush.Color := RGB(R, G, B);
      TheBitmap.Canvas.FillRect(ColorBand);
    end;
    Swap(Clr1, Clr2);
  end;
  Thebitmap.Draw(Thebitmap.canvas.Handle, 0,0);
end;

// A lower priority thread that checks the UI
// status and plays the files accordingly
// The playerthread itself has a higher priority and
// is in an Tmpegplayer object
function TForm1.PlayFiles(Sender: pThread): integer;
var
  i: integer;
  tmp: string;
begin
  //Nothing to do
  if Ffilelist.Count = 0 then exit;
  Current := 0;
  SaveCurrent := 0;
  while (Current < FFilelist.Count) and (FFilelist.Count > 0) do
  begin
    List.LVItemState[list.LVCurItem] := [];
    List.LVItemState[Current] := [lvisHighlight, lvisSelect];
    List.Perform(lvm_ensurevisible, Current, 0);

    FFilename := ExtractFilenameWoExt(FFilelist.Items[Current]);
    Applet.Caption := FFilename;
    lbl5.Caption := FFilename;
    if Assigned(Play) then
    begin
      Play.Stop;
      Play.Free;
    end;
    Play := NewMPEGPlayer;
    Play.LoadFile(FFilelist.Items[Current]);
    Play.SetOutput(CreateMCIOBffer(Play));
    Lbl2.Caption := format('%2.2d.%2.2d', [Play.Length div 60, Play.Length mod 60]);
    Lbl3.Caption := format('%3.3d kb/s', [Play.Bitrate div 1000]);
    try
      // All the button handling while playing is done here and NOT
      // in the Buttonclick eventhandler.
      Play.Play;
      repeat
        if SaveCurrent <> Current then
        begin
          SaveCurrent := Current;
          Play.Stop;
          Break;
        end
        else if BtnPrev.Checked then
        begin
          //Cycle if first is reached
          if current > 0 then dec(current, 2)
          else
            current := FFilelist.Count - 2;
          Btnprev.Checked := False;
          Break;
        end
        else if BtnNext.Checked then
        begin
          //Cycle if last is reached
          if Current = FFilelist.Count - 1 then Current := -1;
          BtnNext.Checked := False;
          Break;
        end
        else if btnexit.Checked then
        begin
          Play.Stop;
          btnexit.Checked := False;
        end
        else if BtnPlay.Checked = False then
        begin
          btnplay.Checked := False;
          Play.Stop;
          FFilelist.Clear;
          Lbl5.Caption := 'Pico MP3 Player';
          //this order is important! do not change
        end
        else if BtnDir.Checked then
          Play.Pause
        else if not BtnDir.Checked then play.Continue;
        if BtnPlay.Checked = False then exit;
        // Move the Filename caption, *very* expensive right now
        inc(Offset);
        if Offset > pn3.clientwidth then Offset := 0 - lbl5.canvas.TextWidth(FFilename);
        Lbl5.Left := Offset;

        //Display Playtime
        Lbl1.Caption := Format('%2.2d.%2.2d', [Play.Position div 60, Play.Position mod 60]);
        // Give time back to the system
        // Play is still running its own higher priority thread
        Sleep(100);
      until Play.IsPlaying = False;
    except
      on E: Exception do
        msgok(Format(#13'Exception: %d, %s', [integer(e.code), E.Message]));
    end;
    if (BtnRepeat.Checked) and (Current = FFileList.Count - 1) then
      Current := -1;
    inc(Current);
    inc(SaveCurrent);
    SaveCurrent := Current;
  end;
  Lbl5.Caption := 'Pico MP3 Player';
  //Lbl4.Caption := 'Pico MP3 Player';
  BtnPlay.Checked := False;
end;

procedure TForm1.providedata(Sender: PControl; Idx, SubItem: integer;
  var aTxt: string; var ImgIdx: integer; var State: DWORD;
  var Store: boolean);
begin
  if (subItem < List.LVColCount) and (Idx < List.Count) then
  begin
    if SubItem = 0 then aTxt := ExtractFilenameWoExt(FFilelist.Items[Idx])
    else if SubItem = 1 then aTxt := ExtractFilePath(FFilelist.Items[idx]);
    Store := True;
  end;
end;



end.

