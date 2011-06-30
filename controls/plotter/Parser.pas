unit Parser;

interface

uses KOL, Calculus, standardFuncs;

type

TParser = class
public
      constructor Create;
      destructor Destroy; override;
      Function compile(s: string; var err:Byte): TCalculus;
      Procedure addFunc(f: TFuncDef);
      Procedure removeFunc(f: TFuncDef);
      Procedure addVar(v: TVarDef);
      Procedure removeVar(v: TVarDef);
      procedure standardFunctions;
private
       funcs : PList;
       vars  : PList;
       Function funcNum(i: integer): TFuncDef;
       Function varNum(i: integer): TVarDef;
       Function checkBrackets(s: String): Boolean;
       Function expresionCompile(s: string; var err: Byte): TCalculus;
       Function FactorCompile(s: string; var err: Byte): TCalculus;
       Function SimpleCompile(s: string; var err: Byte): TCalculus;
       procedure dropSpaces(var s: string);
end;

implementation

constructor TParser.Create;
begin
   funcs := NewList;
   vars  := NewList;
end;

destructor TParser.Destroy;
var
   i:integer;
begin
     For i:=0 to funcs.Count-1 do
         TFuncDef(funcs.Items[i]).Free;
     funcs.Free;
     For i:=0 to vars.Count-1 do
         TVarDef(vars.Items[i]).Free;
     vars.Free;
end;

Function TParser.compile(s:string; var err:Byte):TCalculus;
begin
     dropSpaces(s);
     compile:=expresionCompile(s,err);
end;

Procedure TParser.addFunc(f:TFuncDef);
begin
     funcs.add(f);
end;

Procedure TParser.removeFunc(f:TFuncDef);
begin
     funcs.remove(f);
end;

Procedure TParser.addVar(v:TVarDef);
begin
     vars.add(v);
end;

Procedure TParser.removeVar(v:TVarDef);
begin
     vars.remove(v);
end;

procedure TParser.standardFunctions;
var
   fd:TFuncDef;
   vd:TVarDef;
begin
     fd:=TSqr.Create;
     addFunc(fd);
     fd:=TSqrt.Create;
     addFunc(fd);
     fd:=TSin.Create;
     addFunc(fd);
     fd:=TCos.Create;
     addFunc(fd);
     fd:=TTan.Create;
     addFunc(fd);
     fd:=TArcTan.Create;
     addFunc(fd);
     fd:=TArcSin.Create;
     addFunc(fd);
     fd:=TArcCos.Create;
     addFunc(fd);
     fd:=TLog.Create;
     addFunc(fd);
     fd:=TExp.Create;
     addFunc(fd);
     vd:=TVarDef.Create;
     vd.name:='Pi';
     vd.value:=Pi;
     addVar(vd);
end;

Function TParser.funcNum(i:integer):TFuncDef;
begin
     funcNum:=TFuncDef(funcs.Items[i]);
end;

Function TParser.varNum(i:integer):TVarDef;
begin
     varNum:=TVarDef(vars.Items[i]);
end;

Function TParser.checkBrackets(s:String):Boolean;
var
   i,c:integer;
begin
     c:=0;
     For i:=1 to length(s) do
     begin
          case s[i] of
            '(':c:=c+1;
            ')':c:=c-1;
          end;
          if c<0 then
             begin
                  checkBrackets:=False;
                  exit;
             end;
     end;
     checkBrackets:=(c=0);
end;

Function TParser.expresionCompile(s:string; var err:Byte):TCalculus;
var
   i:integer;
   e1,e2:Byte;
   c1,c2:TCalculus;

begin
     if (s='') then
     begin
          err:=3;
          expresionCompile:=nil;
          exit;
     end;

     if not checkBrackets(s) then
     begin
          err:=1;
          expresionCompile:=nil;
          exit;
     end;

     {----- -factor -----}
     if s[1]='-' then
     begin
          c1:=FactorCompile(copy(s,2,length(s)-1),e1);
          if e1=0 then
             begin
                  c2:=TConst.Create(0);
                  expresionCompile:=TMinus.Create(c2,c1);
                  err:=0;
                  exit;
             end;
     end;

     {----- exp+factor -----}
     {----- exp-factor -----}
     For i:=length(s) downTo 1 do
     begin
     case s[i] of
     '+':
         begin
              c1:=ExpresionCompile(copy(s,1,i-1),e1);
              if e1=0 then
              begin
                   c2:=FactorCompile(copy(s,i+1,length(s)-i),e2);
                   if e2=0 then
                   begin
                        ExpresionCompile:=TSum.Create(c1,c2);
                        err:=0;
                        exit;
                   end
                   else
                       c1.Free;
              end;
         end;
     '-':
         begin
              c1:=ExpresionCompile(copy(s,1,i-1),e1);
              if e1=0 then
              begin
                   c2:=FactorCompile(copy(s,i+1,length(s)-i),e2);
                   if e2=0 then
                   begin
                        ExpresionCompile:=TMinus.Create(c1,c2);
                        err:=0;
                        exit;
                   end
                      else c1.Free;
              end;
         end;
     end;  {case}
     end;  {For}
     ExpresionCompile:=FactorCompile(s,err);
end;



Function TParser.FactorCompile(s:string; var err:Byte):TCalculus;
var
   i:integer;
   e1,e2:Byte;
   c1,c2:TCalculus;

begin
     if (s='') then
     begin
          err:=3;
          factorCompile:=nil;
          exit;
     end;

     if not checkBrackets(s) then
     begin
          err:=1;
          factorCompile:=nil;
          exit;
     end;

     {----- factor*simple -----}
     {----- factor/simple -----}

     For i:=length(s) downTo 1 do
     begin
     case s[i] of
     '*':
         begin
              c1:=FactorCompile(copy(s,1,i-1),e1);
              if e1=0 then
              begin
                   c2:=simpleCompile(copy(s,i+1,length(s)-i),e2);
                   if e2=0 then
                   begin
                        FactorCompile:=TProduct.Create(c1,c2);
                        err:=0;
                        exit;
                   end
                   else
                       c1.Free;
              end;
         end;
     '/':
         begin
              c1:=FactorCompile(copy(s,1,i-1),e1);
              if e1=0 then
              begin
                   c2:=simpleCompile(copy(s,i+1,length(s)-i),e2);
                   if e2=0 then
                   begin
                        FactorCompile:=TDivision.Create(c1,c2);
                        err:=0;
                        exit;
                   end
                      else c1.Free;
              end;
         end;
     end;  {case}
     end;  {For}

     factorCompile:=simpleCompile(s,err);
end;

procedure TParser.dropSpaces(var s:string);
var
   t:String;
   i:integer;
begin
     t:='';
     For i:=1 to Length(s) do
      if s[i] <> ' ' then t := t + LowerCase(s[i]);
     s:=t;
end;

Function TParser.simpleCompile(s:string; var err:Byte):TCalculus;
var
   i:integer;
   e1,e2:Byte;
   c1,c2:TCalculus;
   d:double;

begin
     if (s='') then
     begin
          err:=3;
          SimpleCompile:=nil;
          exit;
     end;

     if not checkBrackets(s) then
     begin
          err:=1;
          SimpleCompile:=nil;
          exit;
     end;

     {----- const -----}
     val(s,d,i);
     if i=0 then
     begin
          SimpleCompile:=TConst.Create(d);
          err:=0;
          exit;
     end;

     {-----  (exp) -----}
     if (s[1]='(') and (s[length(s)]=')') then
     begin
          c1:=expresionCompile(copy(s,2,length(s)-2),e1);
          if e1=0 then
             begin
                  SimpleCompile:=c1;
                  err:=0;
                  exit;
             end;
     end;

     {----- nameVar -----}
     for i:=0 to (vars.Count-1) do
     begin
          if s=varNum(i).name then
          begin
               SimpleCompile:=TVar.Create(varNum(i));
               err:=0;
               exit;
          end;
     end;

     {----- nameFunc(exp) -----}
     for i:=0 to (funcs.Count-1) do
     begin
          if (Pos(funcNum(i).name+'(',s)=1) and (s[length(s)]=')') then
          begin
               c1:=expresionCompile(copy(s,length(funcNum(i).name)+2,
                                    length(s)-length(funcNum(i).name)-2),e1);
               if e1=0 then
               begin
                    SimpleCompile:=TFunc.Create(c1,funcNum(i));
                    err:=0;
                    exit;
               end;
          end;
     end;

     {----- simple^simple -----}

     For i:=1 To length(s) do
     begin
     case s[i] of
     '^':
         begin
              c1:=SimpleCompile(copy(s,1,i-1),e1);
              if e1=0 then
              begin
                   c2:=SimpleCompile(copy(s,i+1,length(s)-i),e2);
                   if e2=0 then
                   begin
                        SimpleCompile:=TPower.Create(c1,c2);
                        err:=0;
                        exit;
                   end
                   else
                       c1.Free;
              end;
         end;
     end;  {case}
     end;  {For}

     err:=2;
     SimpleCompile:=nil;
end;


end.
