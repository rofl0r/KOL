unit sysvarnt;
{X: this unit contains some definitions and initializations, needed to
    support variants. To use variants, just place reference to sysvarnt
    unit in your unit uses clause *first* }

interface

var
  Unassigned: Variant;    { Unassigned standard constant }
  Null: Variant;          { Null standard constant }
  EmptyParam: OleVariant; { "Empty parameter" standard constant which can be
                            passed as an optional parameter on a dual interface. }

implementation

initialization

  VarAddRefProc := VariantAddRef;
  VarClrProc := VariantClr;

  TVarData(Unassigned).VType := varEmpty;
  TVarData(Null).VType := varNull;
  TVarData(EmptyParam).VType := varError;
  TVarData(EmptyParam).VError := $80020004; //DISP_E_PARAMNOTFOUND

  ClearAnyProc := @VarInvalidOp;
  ChangeAnyProc := @VarCastError;
  RefAnyProc := @VarInvalidOp;

finalization

end.
