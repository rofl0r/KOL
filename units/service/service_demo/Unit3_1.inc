{ KOL MCK } // Do not remove this line!

procedure NewForm3( var Result: PForm3; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm3.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := Service.NewServiceEx( 'KOL_ServiceA', '');
  Result.Form.onExecute        := Result.ServiceExecute;
  Result.Form.onControl        := Result.ServiceControl;
  Result.Form.onStop           := Result.ServiceStop;
  Result.Form.onPause          := Result.ServicePause;
  Result.Form.onResume         := Result.ServiceResume;
  Result.Form.onShutdown       := Result.ServiceShutdown;
  Result.Form.onApplicationRun := Result.runMCK;
  Result.Form.Accepted         := $00000007;

end;


