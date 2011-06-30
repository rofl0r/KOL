program basic;
//********************************************************************
//  Created by KOL project Expert Version 2.01 on:14-1-2004 19:09:33
//********************************************************************
{
       Unit: Basic
    purpose: Very basic formdesigner demo
     Author: Thaddy de Koning
  Copyright: 2004, Thaddy de Koning
    Remarks: Demo for version 1.0 beta 1 of designctrl.pas
             This version is not yet for release
             Only for beta testers.
             Compiles to only 25 K in D4 or 5 with sysdcu replacements.
             
}
uses
  Kol,
  Unitbasic in 'Unitbasic.pas';

begin
  Applet:=NewApplet('Basic Formdesign');
  NewForm1( Form1, Applet);
  Run(Applet);
end.