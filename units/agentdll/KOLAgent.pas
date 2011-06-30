unit KOLAgent;
{*}

interface
uses KOL,Windows,err,AgentObjects_TLBKOL;

type
  PDummy = ^TDummy;
  TDummy = object(TObj)
  private
  protected
  public
  procedure OnChange(Sender : PObj; const GUID : WideString);
  end;

function InitAgent(TTSMode : PChar) : Boolean;stdcall;
procedure FreeAgent;stdcall;
{* Initialize and deinitialize Microsoft Agent 2.0 ActiveX control}
procedure ShowAgent(Hide : Boolean);stdcall;
{* Show and hide agent}
procedure ChangeAgent;stdcall;
{* Display and allow change default  agent}
procedure LoadAgent(Agent : PChar);stdcall;
{* Load agent by name}


procedure MoveAgent(X,Y : Smallint);stdcall;
{* Change agent position on screen}
procedure ResetAgent;stdcall;
{* Reset agent position to default in right-bottom corner of screen}

procedure PlayAgent(Animation : PChar);stdcall;
{* Plays selected animation}
procedure GestureAgent(X,Y :Smallint);stdcall;
{* Point at selected object}
procedure StopAgent;stdcall;
{* Stops all animation in process}

procedure SpeakAgent(Text : PChar);stdcall;
{* Speak text}
procedure ThinkAgent(Text : PChar);stdcall;
{* Think about something}

procedure TTSModeAgent(TTSMode : PChar);stdcall;
{* Select non default TTSMode}

implementation

var
AgentX : PAgent;
Dummy  : PDummy;
TTSModeX,Character : String;


procedure TDummy.OnChange;
var
 v : OleVariant;
 Rect : TRect;
 ax : IAgentCtlCharacter;
begin
      TVarData(v).VType := varEmpty;
      Character := 'character';
      AgentX.Characters.Unload(Character);
      AgentX.Characters.Load(Character,v);
      ShowAgent(False);
      TTSModeAgent(PChar(TTSModeX));
      ax := AgentX.Characters[Character];
      Rect := GetDesktopRect;
      ax.MoveTo(Rect.Right-ax.Width,Rect.Bottom-ax.Height,1);
end;



function InitAgent(TTSMode : PChar) : Boolean;stdcall;
var
 v : OleVariant;
 Rect : TRect;
 ax : IAgentCtlCharacter;
begin
    try
       TVarData(v).VType := varEmpty;
       new(Dummy,Create);
       new(AgentX,CreateParented(nil));
       AgentX.OnDefaultCharacterChange := Dummy.OnChange;
       Character := 'character';
       AgentX.Characters.Load(Character,v);
       TTSModeAgent(TTSMode);
       ax := AgentX.Characters[Character];
       Rect := GetDesktopRect;
       ax.MoveTo(Rect.Right-ax.Width,Rect.Bottom-ax.Height,1);
       Result := True;
     except on Exception do
       Result := False;
    end;
end;


procedure LoadAgent(Agent : PChar);stdcall;
begin
  if not Assigned(AgentX) then Exit;
  try
      AgentX.Characters.Unload(Character);
      Character := String(Agent);
      AgentX.Characters.Load(Character,Character + '.acs');
      TTSModeAgent(PChar(TTSModeX));
  except
  //no exception
  end;
end;

procedure ShowAgent(Hide : Boolean);stdcall;
begin
   if not Assigned(AgentX) then Exit;
   if Hide then
   AgentX.Characters[Character].Hide(False)
   else
   AgentX.Characters[Character].Show(False);
end;





procedure ChangeAgent;stdcall;
begin
   if not Assigned(AgentX) then Exit;
   AgentX.ShowDefaultCharacterProperties;
end;

procedure MoveAgent(X,Y : Smallint);stdcall;
begin
   if not Assigned(AgentX) then Exit;
   AgentX.Characters[Character].MoveTo(X,Y,1);
end;

procedure ResetAgent;stdcall;
var
 Rect : TRect;
 ax : IAgentCtlCharacter;
begin
       if not Assigned(AgentX) then Exit;
       ax := AgentX.Characters[Character];
       Rect := GetDesktopRect;
       ax.MoveTo(Rect.Right-ax.Width,Rect.Bottom-ax.Height,1);
end;


procedure PlayAgent(Animation : PChar);stdcall;
var
    anim : WideString;
begin
    if (not Assigned(AgentX)) or (Animation = nil) then Exit;
    anim := String(Animation);
    try
    AgentX.Characters[Character].Play(anim);
    except
    //no exception
    end;
    anim :='';
end;


procedure StopAgent;stdcall;
begin
    if not Assigned(AgentX) then Exit;
    AgentX.Characters[Character].StopAll('Move');
    AgentX.Characters[Character].StopAll('Play');
    AgentX.Characters[Character].StopAll('Speak');
    PlayAgent('RestPose');
end;

procedure SpeakAgent(Text : PChar);stdcall;
var
 v : WideString;
begin
    if (not Assigned(AgentX)) or (StrLen(Text)=0) then Exit;
    v := String(Text);
    AgentX.Characters[Character].Speak(v,'');
    v := '';
end;

procedure ThinkAgent(Text : PChar);stdcall;
var
 v : WideString;
begin
    if (not Assigned(AgentX)) or (StrLen(Text)=0) then Exit;
    v := String(Text);
    AgentX.Characters[Character].Think(v);
    v := '';
end;

procedure GestureAgent(X,Y :Smallint);stdcall;
var
   Rect : TRect;
   i,j : Integer;
begin
    if not Assigned(AgentX) then Exit;
    Rect := GetDesktopRect;
    i := Integer(X);
    j := Integer(Y);
//    if (i < Rect.Left) or (i > Rect.Right)  or (j > Rect.Top)  or (j < Rect.Bottom) then Exit;
    AgentX.Characters[Character].GestureAt(X,Y);
end;




procedure TTSModeAgent(TTSMode : PChar);stdcall;
begin
 if not Assigned(AgentX) then Exit;
   if StrLen(TTSMode) > 0 then begin
           TTSModeX := String(TTSMode);
           AgentX.Characters[Character].TTSModeID := TTSModeX;
       end;
end;

procedure FreeAgent;stdcall;
begin
    if not Assigned(AgentX) then Exit;
    AgentX.Characters.Unload(Character);
    Character := '';
    TTSModeX := '';
    Dummy.Free;
    AgentX.Free;
end;





end.
