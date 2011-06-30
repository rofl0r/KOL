Component for visually select date or time (TKOLDatePicker) example for KOL with mirror.IE3+ comctl32 is required.

Version 1.1:

[+] OnChange,OnDropDown,OnCloseUp,OnPaint,OnEraseBkgnd,OnMessage events available.(others still exists in MCK component but are dumb)
[+] Color property for changing colors of any part of control
[+] SetFont method for changing font of attached monthcal 
[+] Checked property for testing if is checked (only when piCheckBox was used)
[+] Format property to change format of displayed date/time (eg.'yyyy-MM-dd')
[+] All properties from MCK control are available (such like Visible,Enabled,TabOrder), others are hidden.

By Boguslaw Brandys,brandysb@poczta.onet.pl

INSTALLATION
This control is not compatible with old one ,so remove old TKOLDatePicker from palette !

1. Unpack where You wish preserving relative pathes.
2. Create package (e.g. KOLPICKER.DPK), add all *.pas there.(if *.dcr are also added then remove them)
3. Change package options to "Design-time only" and "Rebuild as needed".
4. Save it, compile and install it.
5. Compile project. Do not forget to add KOL_MCK conditional define
   in project options.




Best Regards
Boguslaw Brandys