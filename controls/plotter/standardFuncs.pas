unit standardFuncs;

interface
uses Calculus;

type

    TSqr = class(TFuncDef)
         public
                Function name:string; override;
                Function Eval(x:double):double; override;
          end;

    TSqrt = class(TFuncDef)
         public
                Function name:string; override;
                Function Eval(x:double):double; override;
          end;

    TSin = class(TFuncDef)
         public
                Function name:string; override;
                Function Eval(x:double):double; override;
          end;

    TCos = class(TFuncDef)
         public
                Function name:string; override;
                Function Eval(x:double):double; override;
          end;

    TTan = class(TFuncDef)
         public
                Function name:string; override;
                Function Eval(x:double):double; override;
          end;

    TArcTan = class(TFuncDef)
         public
                Function name:string; override;
                Function Eval(x:double):double; override;
          end;

    TArcSin = class(TFuncDef)
         public
                Function name:string; override;
                Function Eval(x:double):double; override;
          end;

    TArcCos = class(TFuncDef)
         public
                Function name:string; override;
                Function Eval(x:double):double; override;
          end;

    TLog = class(TFuncDef)
         public
                Function name:string; override;
                Function Eval(x:double):double; override;
          end;

    TExp = class(TFuncDef)
         public
                Function name:string; override;
                Function Eval(x:double):double; override;
          end;

implementation


Function TSqr.name:string;
begin
     name:='sqr';
end;

Function TSqr.Eval(x:double):double;
begin
     eval:=Sqr(x);
end;

Function TSqrt.name:string;
begin
     name:='sqrt';
end;

Function TSqrt.Eval(x:double):double;
begin
     eval:=Sqrt(x);
end;

Function TSin.name:string;
begin
     name:='sin';
end;

Function TSin.Eval(x:double):double;
begin
     eval:=Sin(x);
end;

Function TCos.name:string;
begin
     name:='cos';
end;

Function TCos.Eval(x:double):double;
begin
     eval:=Cos(x);
end;

Function TTan.name:string;
begin
     name:='tan';
end;

Function TTan.Eval(x:double):double;

 function Tan(const X: Extended): Extended;
 // ripped form borland's math unit
 asm
        FLD    X
        FPTAN
        FSTP   ST(0)
        FWAIT
 end;

begin
     eval:=Tan(x);
end;

Function TArcTan.name:string;
begin
     name:='arctan';
end;

Function TArcTan.Eval(x:double):double;
begin
     eval:=ArcTan(x);
end;

Function TArcSin.name:string;
begin
     name:='arcsin';
end;


// ripped form borland's math unit
 function ArcTan2(const Y, X: Extended): Extended;
 asm
        FLD     Y
        FLD     X
        FPATAN
        FWAIT
 end;

Function TArcSin.Eval(x:double):double;

 function ArcSin(const X: Extended): Extended;
 begin
  Result := ArcTan2(X, Sqrt(1 - X * X))
 end;

begin
     eval:=ArcSin(x);
end;

Function TArcCos.name:string;
begin
     name:='arccos';
end;

Function TArcCos.Eval(x:double):double;

 // ripped form borland's math unit
 function ArcCos(const X: Extended): Extended;
 begin
  Result := ArcTan2(Sqrt(1 - X * X), X);
 end;

begin
     eval:=ArcCos(x);
end;

Function TLog.name:string;
begin
     name:='log';
end;

Function TLog.Eval(x:double):double;
begin
     eval:=Ln(x);
end;

Function TExp.name:string;
begin
     name:='exp';
end;

Function TExp.Eval(x:double):double;
begin
     eval:=Exp(x);
end;

end.
