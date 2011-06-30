peSplitter.SetTextureColor1(const Value: TColor);
begin
  if FTextureColor1 <> Value then
  begin
    FTextureColor1 := Value;
    if (ButtonStyle = bsNetscape) and ShowButton then
      Invalidate;
  end;
end;

procedure TJvCustomNetscapeSplitter.SetTextureColor2(const Value: TColor);
begin
  if FTextureColor2 <> Value then
  begin
    FTextureColor2 := Value;
    if (ButtonStyle = bsNetscape) and ShowButton then
      Invalidate;
  end;
end;

procedure TJvCustomNetscapeSplitter.SetWindowsButtons(const Value: TJvWindowsButtons);
begin
  FWindowsButtons := Value;
  if (ButtonStyle = bsWindows) and ShowButton then
    Invalidate;
end;

procedure TJvCustomNetscapeSplitter.StoreOtherProperties(Writer: TWriter);
begin
  Writer.WriteInteger(RestorePos);
end;

procedure TJvCustomNetscapeSplitter.UpdateControlSize(NewSize: Integer);

  procedure MoveViaMouse(FromPos, ToPos: Integer; Horizontal: Boolean);
  begin
    if Horizontal then
    begin
      MouseDown(mbLeft, [ssLeft], FromPos, 0);
      MouseMove([ssLeft], ToPos, 0);
      MouseUp(mbLeft, [ssLeft], ToPos, 0);
    end
    else
    begin
      MouseDown(mbLeft, [ssLeft], 0, FromPos);
      MouseMove([ssLeft], 0, ToPos);
      MouseUp(mbLeft, [ssLeft], 0, ToPos);
    end;
  end;

begin
  if FControl <> nil then
  begin
    { You'd think that using FControl directly would be the way to change it's
      position (and thus the splitter's position), wouldn't you?  But, TSplitter
      has this nutty idea that the only way a control's size will change is if
      the mouse moves the splitter.  If you size the control manually, the
      splitter has an internal variable (FOldSize) that will not get updated.
      Because of this, if you try to then move the newly positioned splitter
      back to the old position, it won't go there (NewSize <> OldSize must be
      True).  Now, what are the odds that the user will move the splitter back
      to the exact same pixel it used to be on?  Normally, extremely low.  But,
      if the splitter has been restored from it's minimized position, it then
      becomes quite likely:  i.e. they drag it back all the way to the min
      position.  What a pain. }
    case Align of
      alLeft:
        MoveViaMouse(Left, FControl.Left + NewSize, Tru