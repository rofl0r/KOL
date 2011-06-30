Font combobox and color combobox for KOL adapted from RxLibrary with mirrors.Useful for express font/colors  with its original look.

I really like RxLibrary library but not the big EXE sizes ;-)

By Boguslaw Brandys, brandysb@poczta.onet.pl

INSTALLATION
For Delphi5 required package is attached so just open and Install.
For other:
1. Unpack where You wish preserving ralative pathes.
2. Create package (e.g. ENHCOMBOS.DPK), add mckKOLFontCombo.pas and mckKOLColorComboBox there.
3. Change package options to "Design-time only" and "Rebuild as needed".
4. Save it, compile and install it.
5. Compile projects. Do not forget to check if KOL_MCK conditional is defined in project options.

History : 
20.02.2002 Initial version
22.02.2002 Bug with symbol fonts fixed, but still some symbolic font names displayed not correctly.I'm wondering if using old EnumFonts function can fix this bug (now it uses EnumFontFamilies) ? Since even RxLibrary is using ne EnumFontFamilies it is not so important.

Best Regards
Boguslaw Brandys

