{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit UnitX;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL, KOLSQLiteDb {$IFNDEF KOL_MCK}, mirror, Classes,
  mckKOLSQLiteDb, mckCtrls, Controls, mckObjs {$ENDIF};
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  PForm1 = ^TForm1;
  TForm1 = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLApplet1: TKOLApplet;
    KOLForm1: TKOLForm;
    SLData: TKOLSLDataSource;
    SLSession: TKOLSLSession;
    SLQuery: TKOLSLQuery;
    LVData: TKOLListView;
		Label1: TKOLLabel;
		Button1: TKOLButton;
		SQLMemo: TKOLMemo;
		Button2: TKOLButton;
		procedure Button1Click(Sender: PObj);
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure Button2Click(Sender: PObj);
    procedure LVDataLVData(Sender: PControl; Idx, SubItem: Integer;
      var Txt: String; var ImgIdx: Integer; var State: Cardinal;
      var Store: Boolean);
    procedure SLDataBusy(Sender: PObj; ObjectName: String;
      BusyCount: Integer; var Cancel: Boolean);
    procedure LVDataColumnClick(Sender: PControl; Idx: Integer);
	private
	procedure FillList(List : PControl);
		{ Private declarations }
	public
		{ Public declarations }
	end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I UnitX_1.inc}
{$ENDIF}

procedure TForm1.FillList(List : PControl);
var
i : Integer;
begin
		List.BeginUpdate;
		try
		while List.LVColCount > 0 do List.LVColDelete(0);
		for i:=0 to SLQuery.ColCount-1 do List.LVColAdd(SLQuery.ColName[i],taLeft,55);
		List.LVCount := SLQuery.RowCount;
		for i:=0 to LVData.LVColCount-1 do SendMessage(LVData.Handle,LVM_SETCOLUMNWIDTH,i,Integer(LVSCW_AUTOSIZE));		
		finally
				List.EndUpdate;
		end;
end;

procedure TForm1.Button1Click(Sender: PObj);
begin
Form.Close;
end;

procedure TForm1.KOLForm1FormCreate(Sender: PObj);
begin
if SLData.Initialized then 
Label1.Caption := Format('Library SQLite version: %s, encoding : %s',[SLData.Version,SLData.Encoding])
else
Label1.Caption := 'Database engine not initialized';
end;





procedure TForm1.LVDataLVData(Sender: PControl; Idx, SubItem: Integer;
	var Txt: String; var ImgIdx: Integer; var State: Cardinal;
	var Store: Boolean);
begin
 Store := false;
 ImgIdx := -1;
 SLQuery.CurIndex := Idx;
 Txt := SLQuery.SField[SubItem];
end;

procedure TForm1.SLDataBusy(Sender: PObj; ObjectName: String;
  BusyCount: Integer; var Cancel: Boolean);
begin
Label1.Caption := Format('Database is locked (%d)',[BusyCount]);
if BusyCount > 3 then Cancel := true;
end;



procedure TForm1.Button2Click(Sender: PObj);
begin
with SLSession^,SLQuery^ do begin
	Close;
	StartTransaction;
	SQL.Text := SQLMemo.Text;
	if Open([]) > 0 then begin
		Rollback;
		MsgBox(ErrorMessage,mb_iconexclamation);
	end
	else
		Commit;
	First;
	Label1.Caption := Format('RowCount=%d ,RowsAffected=%d, ColCount=%d, RowID=%d, CurIndex=%d',[RowCount,RowsAffected,ColCount,RowID,CurIndex]);
	FillList(LVData);
	end;
end;

procedure TForm1.LVDataColumnClick(Sender: PControl; Idx: Integer);
begin
 SendMessage(LVData.Handle,LVM_SETCOLUMNWIDTH,IDx,Integer(LVSCW_AUTOSIZE));
end;

end.












