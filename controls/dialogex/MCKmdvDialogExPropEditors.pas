unit MCKmdvDialogExPropEditors;

interface

uses Windows, DesignIntf, DesignEditors, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, extctrls,
     StdCtrls, KOLmdvDialogEx, mckmdvDialogEx;

type
  TcdCustomColorsEditorForm = class(TForm)
    btnOk: TButton;
    bthCancel: TButton;
    Color_3: TPanel;
    Color_11: TPanel;
    Color_4: TPanel;
    Color_10: TPanel;
    Color_1: TPanel;
    Color_9: TPanel;
    Color_2: TPanel;
    Color_12: TPanel;
    Color_7: TPanel;
    Color_15: TPanel;
    Color_8: TPanel;
    Color_14: TPanel;
    Color_5: TPanel;
    Color_13: TPanel;
    Color_6: TPanel;
    Color_16: TPanel;
    ColorDialog: TColorDialog;
    procedure btnOkClick(Sender: TObject);
    procedure Color_12Click(Sender: TObject);
  private
    FcdCustomColors: TcdCustomColors;
  public
    { Public declarations }
    procedure GetValue(ACustomColors: TcdCustomColors);
    procedure SetValue(ACustomColors: TcdCustomColors);
  end;

TcdCustomColorsPropertyEditor = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
end;

procedure Register;

implementation

procedure Register;
begin
    RegisterPropertyEditor(TypeInfo(TcdCustomColors), TKOLmdvDialogEx, 'cdCustomColors', TcdCustomColorsPropertyEditor);
end;

{$R *.DFM}

{ TcdCustomColorsEditorForm }

procedure TcdCustomColorsEditorForm.GetValue(ACustomColors: TcdCustomColors);
var i: Integer;
begin
    FcdCustomColors:= ACustomColors;
    for i:= Low(TCustomColors) to High(TCustomColors) do
      (FindComponent('Color_'+IntToStr(i)) as TPanel).Color:= ACustomColors.FcdCustomColors[i];
end;

procedure TcdCustomColorsEditorForm.SetValue(ACustomColors: TcdCustomColors);
var i: integer;
begin
    for i:= Low(TCustomColors) to High(TCustomColors) do
      ACustomColors.FcdCustomColors[i]:= (FindComponent('Color_'+IntToStr(i)) as TPanel).Color;
end;

procedure TcdCustomColorsEditorForm.btnOkClick(Sender: TObject);
begin
    SetValue(FcdCustomColors);
end;


{ TmdvPropertyIntItems }

procedure TcdCustomColorsPropertyEditor.Edit;
var
  cdCustomColorsEditorForm: TcdCustomColorsEditorForm;
begin
  cdCustomColorsEditorForm:= TcdCustomColorsEditorForm.Create(nil);
  try
    cdCustomColorsEditorForm.GetValue(TcdCustomColors(GetOrdValue));
    if cdCustomColorsEditorForm.ShowModal = idOK then Modified;
  finally
    cdCustomColorsEditorForm.Free;
  end;
end;

function TcdCustomColorsPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paMultiSelect];
end;

procedure TcdCustomColorsEditorForm.Color_12Click(Sender: TObject);
begin
    if ColorDialog.Execute then (Sender as TPanel).Color:= ColorDialog.Color;
end;

end.
