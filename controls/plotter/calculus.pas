unit calculus;

interface

type

    TFuncDef = class
          public
                Function name:string; virtual; abstract;
                Function Eval(x:double):double; virtual; abstract;
          end;

    TVarDef = class
          public
                name:String[4];
                value:double;
          end;

    TCalculus = class
              public
              Function eval:double; virtual; abstract;
              end;

    TOperator = class (TCalculus)
          public
                constructor create(c1,c2:TCalculus);
                destructor destroy; override;
          protected
                 e1,e2:TCalculus;
          end;

    TSum = class (TOperator)
          public
              Function eval:double; override;
          end;

    TMinus = class (TOperator)
          public
              Function eval:double; override;
          end;

    TProduct = class (TOperator)
          public
              Function eval:double; override;
          end;

    TDivision = class (TOperator)
          public
              Function eval:double; override;
          end;

    TPower = class (TOperator)
          public
              Function eval:double; override;
          end;

    TFunc = class (TCalculus)
          public
              constructor create(v:TCalculus; f:TFuncDef);
              destructor destroy; override;
              Function eval:double; override;
          protected
              variable:TCalculus;
              def:TFuncDef;
          end;

    TVar = class (TCalculus)
          public
              constructor create(v:TVarDef);
              Function eval:double; override;
          protected
              def:TVarDef;
          end;

    TConst = class (TCalculus)
           public
              constructor create(c:double);
              Function eval:double; override;
           private
              val:double;
           end;

implementation

constructor TOperator.create(c1,c2:TCalculus);
begin
     e1:=c1;
     e2:=c2;
end;

destructor TOperator.destroy;
begin
     e1.Free;
     e2.Free;
end;

Function TSum.eval:double;
begin
     eval:=e1.eval+e2.eval;
end;

Function TMinus.eval:double;
begin
     eval:=e1.eval-e2.eval;
end;

Function TProduct.eval:double;
begin
     eval:=e1.eval*e2.eval;
end;

Function TDivision.eval:double;
begin
     eval:=e1.eval/e2.eval;
end;


Function TPower.eval:double;

 // ripped form borland's math unit
 function IntPower(const Base: Extended; const Exponent: Integer): Extended;
 asm
        mov     ecx, eax
        cdq
        fld1                      { Result := 1 }
        xor     eax, edx
        sub     eax, edx          { eax := Abs(Exponent) }
        jz      @@3
        fld     Base
        jmp     @@2
 @@1:    fmul    ST, ST            { X := Base * Base }
 @@2:    shr     eax,1
        jnc     @@1
        fmul    ST(1),ST          { Result := Result * X }
        jnz     @@1
        fstp    st                { pop X from FPU stack }
        cmp     ecx, 0
        jge     @@3
        fld1
        fdivrp                    { Result := 1 / Result }
 @@3:
        fwait
 end;

 function Power(const Base, Exponent: Extended): Extended;
 begin
  if Exponent = 0.0 then
    Result := 1.0               { n**0 = 1 }
  else if (Base = 0.0) and (Exponent > 0.0) then
    Result := 0.0               { 0**n = 0, n > 0 }
  else if (Frac(Exponent) = 0.0) and (Abs(Exponent) <= MaxInt) then
    Result := IntPower(Base, Integer(Trunc(Exponent)))
  else
    Result := Exp(Exponent * Ln(Base))
 end;

begin
     eval:=Power(e1.eval,e2.eval);
end;

constructor TFunc.create(v:TCalculus; f:TFuncDef);
begin
     variable:=v;
     def:=f;
end;

destructor TFunc.destroy;
begin
     variable.Free;
end;

function TFunc.eval:double;
begin
     eval:=def.eval(variable.eval);
end;

constructor TVar.create(v:TVarDef);
begin
     def:=v;
end;

Function TVar.eval:double;
begin
     eval:=def.value;
end;

constructor TConst.create(c:double);
begin
     val:=c;
end;

Function TConst.eval:double;
begin
     eval:=val;
end;

end.
