KOLPlotter 1.02

Converted to KOL/MCK by Alexander Shakhaylo, alex_s@kcci.kharkov.ua,
some improvements to KOL-MCK code and the whole idea of the conversion
belongs to Calota Mihai, kP^<kp@xnet.ro>.

This visual (MCK) component is a basic but powerful mathematical 
function plotter for Delphi, adapted for KOL developing, from 
TfuncPlotter by Luis Enrique Silvestre jsilvestre@infovia.com.ar .
 
It also includes a fast build-in math formula parser, sysutils 
(or other math units) independent.


INSTALLATION
1. Unpack files (separate folder) preserving ralative paths.
2. Install component mckPlotter.pas into a new or existing package, 
   compile and save. ('$(DELPHI)\Source\ToolsAPI' may be needed 
   in your search path!)
3. Remember the 'KOL_MCK' conditional definition in project options.


USAGE
1. The formula supports, besides arithmetic operators +, -, *, 
   /, "^" and "()" brackets, other elementary functions declared 
   in standardFuncs.pas: Sin, Cos, Tan, ArcSin, ArcCos, ArcTan, 
   Exp, Log, Sqrt, Sqr.
2. MinX, MinY, MaxX and MaxY are the canvas' margins.
3. Color is the background color.
4. As Pen is the drawing instrument, with can change its properties
  (style, width, color) at runtime, to plot additional stuff.
5. The smaller Step gets a more acurate drawing but takes more time 
   (quality vs cpu).

Zoom procedures are aviable too, and they're pretty easy to use, as
you can see in the demo included.

Enjoy!
Alexander Shakhaylo (alex_s@kcci.kharkov.ua) and 
Calota Mihai (kP^<kp@xnet.ro>)

