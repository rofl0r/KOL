{ KOL MCK } // Do not remove this line!
const mStyle = 0;
const N2 = 1;
const N3 = 2;
const N4 = 3;
const N5 = 4;
const N6 = 5;
const mCols = 6;
const N8 = 7;
const N9 = 8;
const mProps = 9;
const N11 = 10;
const N12 = 11;
const mSort = 12;
const N14 = 13;
const N15 = 14;
const N16 = 15;
const N17 = 16;


procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'BAPFileBrowser v1.01' ).SetPosition( 115, 48 ).SetClientSize( 608, 429 ).Tabulate;
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Style := Result.Form.Style and not WS_MAXIMIZEBOX;
    Result.Form.Font.FontHeight := 8;

    Result.mMain := NewMenu( Result.Form, 0, [ 'Стиль', '('
      , '+!' + 'lvsDetail', '-!' + 'lvsDetailNoHeader'
      , '-!' + 'lvsIcon', '-!' + 'lvsList'
      , '-!' + 'lvsSmallIcon', ')', 'Столбцы', '(', '+' + 'Size'
      , '+' + 'Date', ')', 'Свойства', '('
      , '+' + 'ShowOnlyFiles', '+' + 'ShowUpDir', ')'
      , 'Сортировать по...', '(', '-!' + 'Имени'
      , '+!' + 'Расширению', '-!' + 'Дате', '-!' + 'Размеру'
      , ')', '' ], nil );
    Result.mMain.AssignEvents( 1, [ Result.KOLForm1N2Menu ] );
    Result.mMain.AssignEvents( 2, [ Result.KOLForm1N2Menu ] );
    Result.mMain.AssignEvents( 3, [ Result.KOLForm1N2Menu ] );
    Result.mMain.AssignEvents( 4, [ Result.KOLForm1N2Menu ] );
    Result.mMain.AssignEvents( 5, [ Result.KOLForm1N2Menu ] );
    Result.mMain.AssignEvents( 7, [ Result.KOLForm1N8Menu ] );
    Result.mMain.AssignEvents( 8, [ Result.KOLForm1N8Menu ] );
    Result.mMain.AssignEvents( 10, [ Result.mMainN11Menu ] );
    Result.mMain.AssignEvents( 11, [ Result.mMainN11Menu ] );
    Result.mMain.AssignEvents( 13, [ Result.mMainN14Menu ] );
    Result.mMain.AssignEvents( 14, [ Result.mMainN14Menu ] );
    Result.mMain.AssignEvents( 15, [ Result.mMainN14Menu ] );
    Result.mMain.AssignEvents( 16, [ Result.mMainN14Menu ] );
    // Result.lPath.TabOrder = -1
    Result.lPath := NewLabel( Result.Form, '' ).SetPosition( 72, 12 ).SetSize( 465, 17 );
    Result.lPath.Color := clGray;
    Result.lPath.Font.Color := clWhite;
    // Result.Label5.TabOrder = -1
    Result.Label5 := NewLabel( Result.Form, 'Выбранный каталог:' ).SetPosition( 8, 368 ).SetSize( 121, 17 );
    Result.Label5.Font.FontStyle := [ fsBold ];
    // Result.lSelDir.TabOrder = -1
    Result.lSelDir := NewLabel( Result.Form, '' ).SetPosition( 8, 386 ).SetSize( 593, 17 );
    Result.lSelDir.Color := clGray;
    Result.lSelDir.Font.Color := clWhite;
    // Result.Label2.TabOrder = -1
    Result.Label2 := NewLabel( Result.Form, 'Фильтр файлов:' ).SetPosition( 16, 300 ).SetSize( 97, 17 );
    Result.Label2.Font.FontStyle := [ fsBold ];
    // Result.lSelFile.TabOrder = -1
    Result.lSelFile := NewLabel( Result.Form, '' ).SetPosition( 8, 344 ).SetSize( 593, 17 );
    Result.lSelFile.Color := clGray;
    Result.lSelFile.Font.Color := clWhite;
    // Result.Label3.TabOrder = -1
    Result.Label3 := NewLabel( Result.Form, 'Выбранный файл:' ).SetPosition( 8, 328 ).SetSize( 105, 17 );
    Result.Label3.Font.FontStyle := [ fsBold ];
    // Result.BAPFileBrowser1.TabOrder = 0
    Result.BAPFileBrowser1 := NewBAPFileBrowser(Result.Form, lvsDetail, [fbcSize, fbcDate], '*.*', sdrByExt, False, True);
    Result.BAPFileBrowser1.SetPosition( 8, 40 ).SetSize( 410, 250 );
    Result.BAPFileBrowser1.Color := clWindow;
    Result.BAPFileBrowser1.LVColText[0] := 'Name';
    Result.BAPFileBrowser1.LVColWidth[0] := 202;
    Result.BAPFileBrowser1.LVColText[1] := 'Size';
    Result.BAPFileBrowser1.LVColWidth[1] := 102;
    Result.BAPFileBrowser1.LVColText[2] := 'Date';
    Result.BAPFileBrowser1.LVColWidth[2] := 84;
    Result.BAPFileBrowser1.Directory := '*';
    // Result.BAPDriveBox1.TabOrder = 1
    Result.BAPDriveBox1 := NewBAPDriveBox(Result.Form, False);
    Result.BAPDriveBox1.SetPosition( 8, 8 ).SetSize( 62, 24 );
    Result.BAPDriveBox1.Color := clWindow;
    // Result.bLevelUp.TabOrder = 2
    Result.bLevelUp := NewButton( Result.Form, '..' ).SetPosition( 544, 8 ).SetSize( 25, 0 );
    Result.bLevelUp.Font.FontStyle := [ fsBold ];
    // Result.bRoot.TabOrder = 3
    Result.bRoot := NewButton( Result.Form, '\' ).SetPosition( 576, 8 ).SetSize( 25, 0 );
    Result.bRoot.Font.FontStyle := [ fsBold ];
    // Result.ebFilter.TabOrder = 4
    Result.ebFilter := NewEditBox( Result.Form, [  ] ).SetPosition( 120, 296 ).SetSize( 145, 0 );
    Result.ebFilter.Color := clWindow;
    Result.ebFilter.Text := '*.dpr;*.pas';
    // Result.cbShowPath.TabOrder = 5
    Result.cbShowPath := NewCheckBox( Result.Form, 'Показывать полный путь' ).SetPosition( 272, 296 ).SetSize( 150, 0 );
    Result.cbShowPath.Checked := TRUE;
    // Result.ListBox1.TabOrder = 6
    Result.ListBox1 := NewListBox( Result.Form, [ loNoIntegralHeight ] ).SetPosition( 424, 40 ).SetSize( 177, 193 );
    Result.ListBox1.Color := clWindow;
    Result.ListBox1.CurIndex := 0;
    // Result.cbAddPath.TabOrder = 7
    Result.cbAddPath := NewCheckBox( Result.Form, 'Добавлять путь' ).SetPosition( 432, 240 ).SetSize( 105, 0 );
    // Result.cbSelect.TabOrder = 8
    Result.cbSelect := NewCheckBox( Result.Form, 'Снимать выделение с файлов' ).SetPosition( 432, 264 ).SetSize( 174, 0 );
    Result.cbSelect.Checked := TRUE;
    // Result.bAddList.TabOrder = 9
    Result.bAddList := NewButton( Result.Form, 'Добавить выделенные файлы' ).SetPosition( 432, 288 ).SetSize( 169, 0 );
    // Result.bRefresh.TabOrder = 10
    Result.bRefresh := NewButton( Result.Form, 'Refresh' ).SetPosition( 432, 316 ).SetSize( 65, 0 );
    // Result.bClearList.TabOrder = 11
    Result.bClearList := NewButton( Result.Form, 'Очистить список' ).SetPosition( 504, 316 ).SetSize( 97, 0 );
      Result.BAPFileBrowser1.OnChangeDir := Result.BAPFileBrowser1ChangeDir;
      Result.BAPFileBrowser1.OnGetSelFiles := Result.BAPFileBrowser1GetSelFiles;
      Result.BAPFileBrowser1.OnSelFile := Result.BAPFileBrowser1SelFile;
      Result.BAPDriveBox1.OnChangeDrive := Result.BAPDriveBox1ChangeDrive;
      Result.bLevelUp.OnClick := Result.bLevelUpClick;
      Result.bRoot.OnClick := Result.bRootClick;
      Result.ebFilter.OnChar := Result.ebFilterChar;
      Result.bAddList.OnClick := Result.bAddListClick;
      Result.bRefresh.OnClick := Result.bRefreshClick;
      Result.bClearList.OnClick := Result.bClearListClick;
    Result.Form.CanResize := False;
    Result.KOLForm1FormCreate( Result );

end;

