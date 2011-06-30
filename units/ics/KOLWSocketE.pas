unit WSocketE;

interface

uses KOL, 
  WinTypes, WinProcs { , Classes } ,
{$IFNDEF VER80}  { Delphi 1 }
{$IFNDEF VER90}  { Delphi 2 }
{$IFNDEF VER100} { Delphi 3 }
{$IFNDEF VER120} { Delphi 4 }
{$IFNDEF VER130} { Delphi 5 }
{$IFNDEF VER140} { Delphi 6 and Bcb 6}
{$IFNDEF VER93}  { Bcb 1    }
{$IFNDEF VER110} { Bcb 3    }
{$IFNDEF VER125} { Bcb 4    }
{$IFNDEF VER135} { Bcb 5    }
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}

{$IFDEF VER140}
  { Delphi 6: Add $(DELPHI)\Source\ToolsAPI to your library path }
  { and add designide.dcp to ICS package.                        }
  DesignIntf, DesignEditors,
{$ELSE}
{$IFDEF VER150}
  { Delphi 7: Add $(DELPHI)\Source\ToolsAPI to your library path }
  { and add designide.dcp to ICS package.                        }
  DesignIntf, DesignEditors,
{$ELSE}
  DsgnIntf,
{$ENDIF}
{$ENDIF}
  SysUtils;

type
    TWSocketLineEndProperty = object(TStringProperty)
    public
        function  GetLineEnd(const Value: String): String;
        function  SetLineEnd(const Value: String): String;
        function  GetValue: String; override;
        procedure SetValue(const Value: String); override;
    end;
PWSocketLineEndProperty=^TWSocketLineEndProperty; type  MyStupid0=DWord; 

procedure Register;

implementation

uses
    WSocket;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure Register;
begin
    RegisterComponents('FPiette', [TWSocket]);
    RegisterPropertyEditor(TypeInfo(string), TWSocket, 'LineEnd',
                           TWSocketLineEndProperty);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{                         LineEnd Property Editor                           }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TWSocketLineEndProperty.SetLineEnd(const Value: String): String;
var
    Offset : Integer;
    C      : Char;
begin
    if Pos('#', Value) = 0 then
        raise Exception.Create('Invalid value');

    Offset := 1;
    Result := '';
    repeat
        if Value[Offset] <> '#' then
            break;

        Inc(Offset);
        C := #0;
        while (Offset <= Length(Value)) and
              (Value[Offset] in ['0'..'9']) do begin
            C := Char(Ord(C) * 10 + Ord(Value[Offset]) - Ord('0'));
            Inc(Offset);
        end;

        Result := Result + C;
    until Offset > Length(Value);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TWSocketLineEndProperty.GetLineEnd(const Value: String): String;
var
    N: integer;
begin
    Result := '';
    for N := 1 to Length(Value) do
        Result := Result + '#' + IntToStr(Ord(Value[N]));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TWSocketLineEndProperty.GetValue: String;
begin
    Result := GetLineEnd(inherited GetValue);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TWSocketLineEndProperty.SetValue(const Value: String);
begin
    inherited SetValue(SetLineEnd(Value));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

end.
