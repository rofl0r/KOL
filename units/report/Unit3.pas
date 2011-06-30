cedure TJvPageManager.AddProxy(Proxy: TJvPageProxy);
begin
  FPageProxies.Add(Proxy);
  Proxy.FPageManager := Self;
end;

procedure TJvPageManager.RemoveProxy(Proxy: TJvPageProxy);
begin
  Proxy.FPageManager := nil;
  FPageProxies.Remove(Proxy);
end;

procedure TJvPageManager.DestroyProxies;
var
  Proxy: TJvPageProxy;
begin
  while FPageProxies.Count > 0 do
  begin
    Proxy := FPageProxies.Last;
    RemoveProxy(Proxy);
    Proxy.Free;
  end;
end;

function TJvPageManager.GetPageCount: Integer;
begin
  Result := 0;
  if FPageOwner <> nil then
    Result := FPageOwner.Pages.Count;
end;

function TJvPageManager.GetPageName(Index: Integer): string;
begin
  Result := '';
  if (FPageOwner <> nil) and (Index < PageCount) then
    Result := FPageOwner.Pages[Index];
end;

function TJvPageManager.FindFreePage: string;
var
  I: Integer;
begin
  Result := '';
  if PageOwner <> nil then
    for I := 0 to PageOwner.Pages.Count - 1 do
      if GetProxyIndex(PageOwner.Pages[I]) = -1 then
      begin
        Result := PageOwner.Pages[I];
        Exit;
      end;
end;

function TJvPageManager.GetPageIndex: Integer;
begin
  if PageOwner <> nil then
    Result := PageOwner.PageIndex
  else
    Result := PageNull;
end;

procedure TJvPageManager.SetPageIndex(Value: Integer);
var
  Page: TPageItem;
  OldPageIndex: Integer;
begin
  if PageOwner <> nil then
  begin
    OldPageIndex := PageOwner.PageIndex;
    PageOwner.PageIndex := Value;
    if DestroyHandles then
      DormantPages;
    if OldPageIndex <> PageOwner.PageIndex then
    begin
      if not FUseHistory then
      begin
        PageHistory.AddPageIndex(PageOwner.PageIndex);
      end
      else
      begin
        case HistoryCommand of
          hcNone:
            ;
          hcAdd:
            PageHistory.AddPageIndex(PageOwner.PageIndex);
          hcBack:
            PageHistory.Current := PageHistory.Current - 1;
          hcForward:
            PageHistory.Current := PageHistory.Current + 1;
          hcGoto:
            ;
        end;
      end;
    end;
    HistoryCommand := hcAdd;
    CheckBtnEnabled;
    { update owner form help context }
    if FChangeHelpContext and (Owner <> nil) and (Owner is TForm) and
      ((Owner as TForm).HelpContext = 0) then
    begin
      Page := TPageItem(PageOwner.Pages.Objects[PageIndex]);
      if Page <> nil then
        (Owner as TForm).HelpContext := Page.HelpContext;
    end;
  end;
end;

function TJvPageManager.GetNextEnabled: Boolean;
begin
  Result := GetNextPageIndex(PageIndex) >= 0;
end;

function TJvPageManager.GetPriorEnabled: Boolean;
begin
  Result := GetPriorPageIndex(PageIndex) >= 0;
end;

procedure TJvPageManager.NextPage;
begin
  ChangePage(True);
end;

procedure TJvPageManager.PriorPage;
begin
  ChangePage(False);
end;

procedure TJvPageManager.GotoHistoryPage(HistoryIndex: Integer);
var
  SaveCurrent: Integer;
begin
  SaveCurrent := PageHistory.Current;
  HistoryCommand := hcGoto;
  PageHistory.Current := HistoryIndex;
  try
    SetPage(PageHistory.PageIndexes[HistoryIndex], False);
  finally
    if PageOwner.PageIndex <> PageHistory.PageIndexes[HistoryIndex] then
      PageHistory.Current := SaveCurrent;
  end;
end;

procedure TJvPageManager.PageEnter(Page: Integer; Next: Boolean);
var
  ProxyIndex: Integer;
begin
  ProxyIndex := GetProxyIndex(PageOwner.Pages.Strings[Page]);
  if ProxyIndex <> PageNull then
  begin
    TJvPageProxy(FPageProxies.Items[ProxyIndex]).PageEnter(Next);
  end;
end;

procedure TJvPageManager.PageLeave(Page: Integer; Next: Bool