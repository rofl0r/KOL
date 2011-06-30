STRUCTURAL EXCEPTION HANDLING and MATHIMATICAL ROUTINES
ADAPTATION (with COMPLEX MATHEMATICS SUPLEMENTS) 
for KEY OBJECTS LIBRARY
-----------------------------------------------------
version 7.0.181, 1-Aug-2003
Copyright (C) 2001-2003, Vladimir Kladov.


This archive contains three additional units for the Key Objects Library:
  ERR.PAS      - replaces SysUtils.pas in part of exceptions handling;
  MMX.PAS      - small utility function to detect MMX capabilities of CPU;
  KOLMATH.PAS  - replaces standard Delphi MATH.PAS with minimal changes.
  CPLXMATH.PAS - a unit to work with complex numbers.

KOL is intended to allow to develop small but power Win32 GUI applications using great Delphi IDE envirnment. With this archive, the lack of exceptions handling in KOL is filling up. Using of ERR.PAS increases a size of executable about 6K bytes. But this allow to create "robust" applications, saving its size therefore small (at least, much smaller than using ANY OTHER Win32 development tools, which support Structural Exception Handling).

To use ERR.PAS, just include a reference to it in uses clause of any unit of the project, or in uses clause of the dpr file.

The main difference of exception handling suggested in ERR.PAS, is that the only single exception class (named Exception) should be used. Do not derive your own exception classes from it, but always create instances of Exception class. Instead of comparing class of the exception object with certain class type using 'is' operator, just compare Code property of the exception with certain predefined constant. Since this, usage of 'except on' construction is changed a bit:

instead of writing
====== CUT BEGIN ======
try ...
except
  on EIntOverflow  do HandleOverflow;
  on EDivideByZero do HandleZeroDivide;
  else HandleOther;
end;
====== CUT END ======

write now following:
====== CUT BEGIN ======
try ...
except on E: Exception do
  case E.Code of
  e_IntOverflow: HandleOverflow;
  e_DivBy0:      HandleZeroDivide;
  else           HandleOther;
  end;
end;
====== CUT END ======

And, to raise your own exception, write one of following:
====== CUT BEGIN ======
  ... raise Exception.Create( e_Custom, 'This is my exception' );
  ... raise Exception.CreateCustom( 12345, 'This my exception 12345' );
  ... raise Exception.CreateCustomFmt( 67890, 'Custom error %d', [ MyBadVar ] );
====== CUT END ======

KOLMATH.PAS is provided as a replacement of standard MATH.PAS unit. The difference is mainly that it uses ERR.PAS instead of SysUtils.pas. Another difference is that all references to Abs function are replaced to EAbs. There are no other differences, so You can use Delphi help system to get know about functions from MATH.PAS. CPLXMATH is additional unit to work with complex numbers. It can be used separately from KOL. To use it in non-visual KOL Delphi projects (KOL without MCK), define a symbol KOL in project options. This is not necessary for MCK projects.

In this version, changes made, which allow to use ON EXCEPTION handling not only for exceptions, raised in our custom code, but all others too (as defined above).
Also, mmx.pas changed (because command CPUID changes EBX register).

------------------------------------------------------------------------
http://bonanzas.rinet.ru
mailto: bonanzas@online.sinor.ru
