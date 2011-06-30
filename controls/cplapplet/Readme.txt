TKOLCPLApplet, TKOLCPLProject components (C) by Boguslaw Brandys.

The proper way working with these objects is to put TKOLCPLProject and
TKOLCPLApplet on  VCL project form much like with ordinary KOL-MCK projects
(TKOLCPLProject replaces TKOlProject and TKOlCPLApplet replaces TKOlForm).

Some important informations:
- do not change name of VCL form where TKOlCPlProject were placed in any way
(this must be "Form1" name) !
- OnSelect event seems not working becouse control panel is not sending
CPL_SELECT message to CPlApplet function exported from CPL library (strange,
- attached demonstration about how to use TKOlForm in cpl , but ShowModal
must be used always (or some processing like while Main.Form.Visible do;)
- TKOlApplet is created before OnInit is fired and is also destroyed after
OnExit event (so Applet variable  is availlable for all events) see demo

Only package for Delphi5 provided in the archive. For other Delphi versions,
create the package manually, please (this is just to minimize archive size).