{$I VERSIONS.INC}
unit mckListEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, mckListEdit,
{$IFNDEF DSGNINTF_GONE}
  DsgnIntf;
{$ELSE}
  DesignEditors, DesignIntf;
{$ENDIF}

type
{$IFDEF NOIFORMDESIGNER}
  IFormDesigner = TFormDesigner;
{$ENDIF}

{$IFDEF IFORMDESIGNER_MOVED}
  IFormDesigner = DesignIntf.IDesigner;
{$ENDIF}

  TListEditColumnsProperty = class(TClassProperty)
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TListEditColumnsEditor = class(TDefaultEditor)
  protected
{$IFDEF EDITPROPERTY_CHANGED}
    procedure EditProperty(const PropertyEditor: IProperty;     
      var Continue: Boolean); override;
{$ELSE}
    procedure EditProperty(PropertyEditor: TPropertyEditor;
      var Continue, FreeEditor: Boolean); override;
{$ENDIF}
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

type
  TDlgProps = class(TForm)
    GB1: TGroupBox;
    LV: TListBox;
    GB2: TGroupBox;
    GB3: TGroupBox;
    L1: TLabel;
    EDC: TEdit;
    L2: TLabel;
    CBA: TComboBox;
    L3: TLabel;
    CBF: TComboBox;
    L4: TLabel;
    EDW: TEdit;
    L5: TLabel;
    EDM: TEdit;
    procedure LVClick(Sender: TObject);
    procedure TBWidthChange(Sender: TObject);
    procedure EDCExit(Sender: TObject);
    procedure CBAChange(Sender: TObject);
    procedure CBFChange(Sender: TObject);
    procedure EDMChange(Sender: TObject);
  private
    FColumns: TListEditColumns;
    FDesigner: IFormDesigner;
    procedure SetColumns(Value: TListEditColumns);
    function GetColCaption: TCaption;
    procedure SetColCaption(Value: TCaption);
    function GetColMask: string;
    procedure SetColMask(Value: string);
    function GetAlignment: TAlignment;
    procedure SetAlignment(Value: TAlignment);
    function GetColWidth: integer;
    procedure SetColWidth(Value: integer);
    function GetFName: string;
    procedure SetFName(Value: string);
    property ColCaption: TCaption read GetColCaption write SetColCaption;
    property Aligmnent: TAlignment read GetAlignment write SetAlignment;
    property ColWidth: integer read GetColWidth write SetColWidth;
    property FieldName: string read GetFName write SetFName;
    property ColMask: string read GetColMask write SetColMask;
  public
    constructor Create(AOwner: TComponent; Designer: IFormDesigner); {$IFDEF HAS_REINTRODUCE} reintroduce; {$ENDIF}
    property Columns: TListEditColumns read FColumns write SetColumns;
  end;

procedure Register;
procedure EditColumns(Cols: TListEditColumns; Designer: IFormDesigner; IsListData: boolean);

implementation

uses
  TypInfo;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
// public Globals
//

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(TListEditColumns), TKOLListEdit, '', TListEditColumnsProperty);
  RegisterComponentEditor(TKOLListEdit, TListEditColumnsEditor);
end;

procedure EditColumns;
begin
  with TDlgProps.Create(Application, Designer) do
    try
      if not IsListData then begin
         L3.Visible  := False;
         CBF.Visible := False;
      end;
      Columns := Cols;
      ShowModal;
    finally
      Free;
    end;
end;

////////////////////////////////////////////////////////////////////////////////
// TListEditColumnsProperty
//

procedure TListEditColumnsProperty.Edit;
begin
  EditColumns(TListEditColumns(GetOrdValue), Designer, TKOLListEdit(GetComponent( 0 )).IsListData);
  Modified;
end;

function TListEditColumnsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog, paReadOnly] - [paSubProperties];
end;

////////////////////////////////////////////////////////////////////////////////
// TListEditColumnsEditor
//

{$IFDEF EDITPROPERTY_CHANGED}
procedure TListEditColumnsEditor.EditProperty(const PropertyEditor: IProperty;
  var Continue: Boolean);
{$ELSE}
procedure TListEditColumnsEditor.EditProperty(PropertyEditor: TPropertyEditor;
  var Continue, FreeEditor: Boolean);
{$ENDIF}
var
  PropName: string;
begin
  PropName := PropertyEditor.GetName;
  if (CompareText(PropName, 'COLUMNS') = 0) then
  begin
    PropertyEditor.Edit;
    Continue := False;
  end;
end;

function TListEditColumnsEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

function TListEditColumnsEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := 'Colu&mns...'
  else Result := '';
end;

procedure TListEditColumnsEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then Edit;
end;

////////////////////////////////////////////////////////////////////////////////
// private TDlgProps
//

constructor TDlgProps.Create(AOwner: TComponent; Designer: IFormDesigner);
begin
  FDesigner := Designer;
  inherited Create(AOwner);
end;

procedure TDlgProps.SetColumns(Value: TListEditColumns);
var
  c: integer;
begin
  FColumns := Value;
  with LV.Items do begin
    clear;
    for c := 0 to FColumns.count - 1 do
      AddObject(IntToStr(c) + ': ' + FColumns[c].Caption, FColumns[c]);
  end;
  if fColumns.FieldNames <> nil then begin
     for c := 0 to fColumns.FieldNames.Count - 1 do begin
        CBF.Items.Add(fColumns.FieldNames[c]);
     end;
  end;
  LV.ItemIndex := 0;
  LV.OnClick(self);
end;

function TDlgProps.GetColCaption: TCaption;
begin
  result := '';
  with LV do
    if ItemIndex >= 0 then
      result := TListEditColumnsItem(items.objects[ItemIndex]).Caption;
end;

procedure TDlgProps.SetColCaption(Value: TCaption);
var
  i: integer;
begin
  with LV do begin
    i := ItemIndex;
    if  i >= 0 then begin
      TListEditColumnsItem(items.objects[ItemIndex]).Caption := Value;
      items[ItemIndex] := IntToStr(ItemIndex) + ': ' + Value;
      ItemIndex := i;
    end;
  end;
  fColumns.Owner.UpdateColumns;
end;

function TDlgProps.GetColMask;
begin
  result := '';
  with LV do
    if ItemIndex >= 0 then
      result := TListEditColumnsItem(items.objects[ItemIndex]).Mask;
end;

procedure TDlgProps.SetColMask;
begin
  with LV do
    if ItemIndex >= 0 then
      TListEditColumnsItem(items.objects[ItemIndex]).Mask := Value;
  fColumns.Owner.UpdateColumns;
end;

function TDlgProps.GetAlignment: TAlignment;
begin
  result := taLeftJustify;
  with LV do
    if ItemIndex >= 0 then
      result := TListEditColumnsItem(items.objects[ItemIndex]).Alignment;
end;

procedure TDlgProps.SetAlignment(Value: TAlignment);
begin
  with LV do
    if ItemIndex >= 0 then
      TListEditColumnsItem(items.objects[ItemIndex]).Alignment := Value;
  fColumns.Owner.UpdateColumns;
end;

function TDlgProps.GetColWidth: integer;
begin
  result := 0;
  with LV do
    if ItemIndex >= 0 then
      result := TListEditColumnsItem(items.objects[ItemIndex]).Width;
end;

procedure TDlgProps.SetColWidth(Value: integer);
begin
  with LV do
    if ItemIndex >= 0 then
      TListEditColumnsItem(items.objects[ItemIndex]).Width := Value;
  fColumns.Owner.UpdateColumns;
end;

function TDlgProps.GetFName: string;
begin
  result := '';
  with LV do
    if ItemIndex >= 0 then
      result := TListEditColumnsItem(items.objects[ItemIndex]).FieldName;
end;

procedure TDlgProps.SetFName(Value: string);
begin
  with LV do
    if ItemIndex >= 0 then
      TListEditColumnsItem(items.objects[ItemIndex]).FieldName := Value;
  fColumns.Owner.UpdateColumns;
end;

////////////////////////////////////////////////////////////////////////////////
// EventHandler TDlgProps
//

procedure TDlgProps.LVClick(Sender: TObject);
begin
  EdC.text := ColCaption;
  EDW.Text := inttostr(ColWidth);
  case Aligmnent of
    taLeftJustify:   CBA.ItemIndex := 0;
    taCenter:        CBA.ItemIndex := 1;
    taRightJustify:  CBA.ItemIndex := 2;
  end;
  CBF.ItemIndex := CBF.Items.IndexOf(FieldName);
  EDM.Text := ColMask;
end;

procedure TDlgProps.EDCExit(Sender: TObject);
begin
  ColCaption := EdC.text;
end;

procedure TDlgProps.TBWidthChange(Sender: TObject);
begin
  ColWidth := StrToInt(EDW.Text);
end;

procedure TDlgProps.CBAChange(Sender: TObject);
begin
  case CBA.ItemIndex of
    0:  Aligmnent := taLeftJustify;
    1:  Aligmnent := taCenter;
    2:  Aligmnent := taRightJustify;
  end;
end;

procedure TDlgProps.CBFChange(Sender: TObject);
begin
   FieldName := CBF.Items[CBF.ItemIndex];
end;

procedure TDlgProps.EDMChange(Sender: TObject);
begin
   ColMask := EDM.Text;
end;

end.
