{*_* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       François PIETTE
Description:  TWSocket class encapsulate the Windows Socket paradigm
Creation:     Feb 24, 2002
Version:      1.00
EMail:        http://www.overbyte.be       francois.piette@overbyte.be
              http://www.rtfm.be/fpiette   francois.piette@rtfm.be
              francois.piette@pophost.eunet.be
Support:      Use the mailing list twsocket@elists.org
              Follow "support" link at http://www.overbyte.be for subscription.
Legal issues: Copyright (C) 2002 by François PIETTE
              Rue de Grady 24, 4053 Embourg, Belgium. Fax: +32-4-365.74.56
              <francois.piette@overbyte.be> <francois.piette@pophost.eunet.be>

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

              4. You must register this software by sending a picture postcard
                 to the author. Use a nice stamp and mention your name, street
                 address, EMail address and any comment you like to say.

History:
Feb 24, 2002 V1.00 Wilfried Mestdagh <wilfried@mestdagh.biz> created a
             property editor for LineEnd property. I moved his code ti this
             new unit so that it is compatible with Delphi 6.


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit WSocketE;

interface

uses
  WinTypes, WinProcs, Classes,
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
    TWSocketLineEndProperty = class(TStringProperty)
    public
        function  GetLineEnd(const Value: String): String;
        function  SetLineEnd(const Value: String): String;
        function  GetValue: String; override;
        procedure SetValue(const Value: String); override;
    end;

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
