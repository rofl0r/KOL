
{ ---------------------------------------------------------------------------- }
{ Version Information - Do not change.                                         }
{ ---------------------------------------------------------------------------- }

{ ---------------------------------------------------------------------------- }
{ Windows                                                                      }
{ ---------------------------------------------------------------------------- }

{$IFDEF Win32}
{$IFNDEF MSWINDOWS}
{$DEFINE MSWINDOWS}
{$ENDIF}
{$ENDIF}

{$IFDEF MSWINDOWS}

  { ---------------------------------------------------------------------------- }
  { VERXXX to COMPILER_X, DELPHI_X and CPPB_X mappings
  { ---------------------------------------------------------------------------- }

  {$IFDEF VER150}
    {$DEFINE COMPILER_7}
    {$DEFINE DELPHI}
    {$DEFINE DELPHI_7}
  {$ENDIF}

  {$IFDEF VER140}
    {$DEFINE COMPILER_6}
    {$IFDEF BCB}
      {$DEFINE CPPB}
      {$DEFINE CPPB_6}
    {$ELSE}
      {$DEFINE DELPHI}
      {$DEFINE DELPHI_6}
    {$ENDIF}
  {$ENDIF}

  {$IFDEF VER130}
    {$DEFINE COMPILER_5}
    {$IFDEF BCB}
      {$DEFINE CPPB}
      {$DEFINE CPPB_5}
    {$ELSE}
      {$DEFINE DELPHI}
      {$DEFINE DELPHI_5}
    {$ENDIF}
  {$ENDIF}

  {$IFDEF VER125}
    {$DEFINE COMPILER_4}
    {$DEFINE CPPB}
    {$DEFINE CPPB_4}
  {$ENDIF}

  {$IFDEF VER120}
    {$DEFINE COMPILER_4}
    {$DEFINE DELPHI}
    {$DEFINE DELPHI_4}
  {$ENDIF}

  {$IFDEF VER110}
    {$DEFINE COMPILER_3}
    {$DEFINE CPPB}
    {$DEFINE CPPB_3}
  {$ENDIF}

  {$IFDEF VER100}
    {$DEFINE COMPILER_3}
    {$DEFINE DELPHI}
    {$DEFINE DELPHI_3}
  {$ENDIF}

  {$IFDEF VER93}
    {$DEFINE COMPILER_2} // C++ Builder v1 compiler is really v2
    {$DEFINE CPPB}
    {$DEFINE CPPB_1}
  {$ENDIF}

  {$IFDEF VER90}
    {$DEFINE COMPILER_2}
    {$DEFINE DELPHI}
    {$DEFINE DELPHI_2}
  {$ENDIF}

  {$IFDEF VER80}
    {$DEFINE COMPILER_1}
    {$DEFINE DELPHI}
    {$DEFINE DELPHI_1}
  {$ENDIF}

  { ---------------------------------------------------------------------------- }
  { DELPHI_X_UP from DELPHI_X mappings
  { ---------------------------------------------------------------------------- }

  {$IFDEF DELPHI_1}
    {$DEFINE DELPHI_1_UP}
  {$ENDIF}

  {$IFDEF DELPHI_2}
    {$DEFINE DELPHI_1_UP}
    {$DEFINE DELPHI_2_UP}
  {$ENDIF}

  {$IFDEF DELPHI_3}
    {$DEFINE DELPHI_1_UP}
    {$DEFINE DELPHI_2_UP}
    {$DEFINE DELPHI_3_UP}
  {$ENDIF}

  {$IFDEF DELPHI_4}
    {$DEFINE DELPHI_1_UP}
    {$DEFINE DELPHI_2_UP}
    {$DEFINE DELPHI_3_UP}
    {$DEFINE DELPHI_4_UP}
  {$ENDIF}

  {$IFDEF DELPHI_5}
    {$DEFINE DELPHI_1_UP}
    {$DEFINE DELPHI_2_UP}
    {$DEFINE DELPHI_3_UP}
    {$DEFINE DELPHI_4_UP}
    {$DEFINE DELPHI_5_UP}
  {$ENDIF}

  {$IFDEF DELPHI_6}
    {$DEFINE DELPHI_1_UP}
    {$DEFINE DELPHI_2_UP}
    {$DEFINE DELPHI_3_UP}
    {$DEFINE DELPHI_4_UP}
    {$DEFINE DELPHI_5_UP}
    {$DEFINE DELPHI_6_UP}
  {$ENDIF}

  {$IFDEF DELPHI_7}
    {$DEFINE DELPHI_1_UP}
    {$DEFINE DELPHI_2_UP}
    {$DEFINE DELPHI_3_UP}
    {$DEFINE DELPHI_4_UP}
    {$DEFINE DELPHI_5_UP}
    {$DEFINE DELPHI_6_UP}
    {$DEFINE DELPHI_7_UP}
  {$ENDIF}

  { ---------------------------------------------------------------------------- }
  { CPPB_X_UP from CPPB_X mappings
  { ---------------------------------------------------------------------------- }

  {$IFDEF CPPB_1}
    {$DEFINE CPPB_1_UP}
  {$ENDIF}

  {$IFDEF CPPB_3}
    {$DEFINE CPPB_1_UP}
    {$DEFINE CPPB_3_UP}
  {$ENDIF}

  {$IFDEF CPPB_4}
    {$DEFINE CPPB_1_UP}
    {$DEFINE CPPB_3_UP}
    {$DEFINE CPPB_4_UP}
  {$ENDIF}

  {$IFDEF CPPB_5}
    {$DEFINE CPPB_1_UP}
    {$DEFINE CPPB_3_UP}
    {$DEFINE CPPB_4_UP}
    {$DEFINE CPPB_5_UP}
  {$ENDIF}

  {$IFDEF CPPB_3_UP}
    // C++ Builder requires this if you use Delphi components in run-time packages.
    {$OBJEXPORTALL ON}
  {$ENDIF}

{$ENDIF}

{ ---------------------------------------------------------------------------- }
{ Linux                                                                        }
{ ---------------------------------------------------------------------------- }

{$IFDEF LINUX}

  {$IFDEF VER150}
    {$DEFINE COMPILER_7}
    {$DEFINE KYLIX}
    {$DEFINE KYLIX_3}
  {$ENDIF}

  {$IFDEF VER140}
    {$DEFINE COMPILER_6}
    {$DEFINE KYLIX}
    {$DEFINE KYLIX_2}
  {$ENDIF}

  {$IFDEF KYLIX_2}
    {$DEFINE KYLIX_1_UP}
    {$DEFINE KYLIX_2_UP}
  {$ENDIF}

  {$IFDEF KYLIX_3}
    {$DEFINE KYLIX_1_UP}
    {$DEFINE KYLIX_2_UP}
    {$DEFINE KYLIX_3_UP}
  {$ENDIF}

{$ENDIF}

{ ---------------------------------------------------------------------------- }
{ COMPIlER_X_UP from COMPILER_X mappings
{ ---------------------------------------------------------------------------- }

{$IFDEF COMPILER_1}
  {$DEFINE COMPILER_1_UP}
{$ENDIF}

{$IFDEF COMPILER_2}
  {$DEFINE COMPILER_1_UP}
  {$DEFINE COMPILER_2_UP}
{$ENDIF}

{$IFDEF COMPILER_3}
  {$DEFINE COMPILER_1_UP}
  {$DEFINE COMPILER_2_UP}
  {$DEFINE COMPILER_3_UP}
{$ENDIF}

{$IFDEF COMPILER_4}
  {$DEFINE COMPILER_1_UP}
  {$DEFINE COMPILER_2_UP}
  {$DEFINE COMPILER_3_UP}
  {$DEFINE COMPILER_4_UP}
{$ENDIF}

{$IFDEF COMPILER_5}
  {$DEFINE COMPILER_1_UP}
  {$DEFINE COMPILER_2_UP}
  {$DEFINE COMPILER_3_UP}
  {$DEFINE COMPILER_4_UP}
  {$DEFINE COMPILER_5_UP}
{$ENDIF}

{$IFDEF COMPILER_6}
  {$DEFINE COMPILER_1_UP}
  {$DEFINE COMPILER_2_UP}
  {$DEFINE COMPILER_3_UP}
  {$DEFINE COMPILER_4_UP}
  {$DEFINE COMPILER_5_UP}
  {$DEFINE COMPILER_6_UP}
{$ENDIF}

{$IFDEF COMPILER_7}
  {$DEFINE COMPILER_1_UP}
  {$DEFINE COMPILER_2_UP}
  {$DEFINE COMPILER_3_UP}
  {$DEFINE COMPILER_4_UP}
  {$DEFINE COMPILER_5_UP}
  {$DEFINE COMPILER_6_UP}
  {$DEFINE COMPILER_7_UP}
{$ENDIF}

{ ---------------------------------------------------------------------------- }
{ General                                                                      }
{ ---------------------------------------------------------------------------- }

{.$DEFINE DI_Check_Free}// Default: Off
{ If DI_Check_Free is defined, objects keep track if they were freed before the
  application exits. Disabeling DI_Check_Free will generate smaller and faster
  code. You need the DIContainers Library if you want to enable this option. }

{.$DEFINE DI_Use_Wide_Char_Set_Consts}// Default: Off
{ If defined, code will use constants of WideChar sets. WideChar set constants
  will, however, cause a compiler error when compiled with TD32 debug info.
  This error was detected in D4, D5, D6 and D7. }

{.$DEFINE DI_No_Range_Checking}// Default: Off
{ Defining DI_No_Range_Checking will suppress generation of code which checks
  for ranges errors. No error messages will be thrown in case of violations.
  Enabeling DI_No_Range_Checking generates faster and smaller code. }

{.$DEFINE DI_No_Classes}// Default: Off
{ If defined, The Delphi Inspiration libraries try to avoid using and linking
  Delphi's Classes.pas. Not using Classes.pas usually results in a 15-17 KB
  smaller exe file size for console applications. For Delphi GUI applications,
  turning on DI_No_Classes may actually create larger file sizes. }

{$DEFINE FLOAT_EXTENDED_PRECISION} // Default
{.$DEFINE FLOAT_DOUBLE_PRECISION}
{.$DEFINE FLOAT_SINGLE_PRECISION}
{ Math precision selection, mutually exclusive. }

{.$DEFINE DI_No_Win_9x_Support}// Default: Off
{ Define DI_No_Win_9x_Support if you want to compile your application without
  support for the Win9x platforms Windows 95 and Windows 98. They will then
  run only on Windows NT / Windows 2000 / Windows XP. }

{.$DEFINE DI_Show_Hints}// Default: Off
{ Generation of hints has been disabled for code which is known to be safe.
  To enable these hints, turn on DI_Show_Hints. }

{.$DEFINE DI_Show_Warnings}// Default: Off
{ Generation of warnings has been disabled for code which is known to be safe.
  To enable these warnings, turn on DI_Show_Warnings. }

{ ---------------------------------------------------------------------------- }
{ DIContainers                                                                 }
{ ---------------------------------------------------------------------------- }

{.$DEFINE DI_No_Containers_Assign}// Default: Off
{ If defined, the general assignment capabilities will not be compiled into
  DIContainers. Enabeling DI_No_Containers_Assign will generate smaller exe
  files.

  This option is only available for the DIContainers source code. }

{.$DEFINE DI_No_Containers_Persistent}// Default: Off
{ If DI_No_Containers_Persistent is defined, all DIContainers will inherit
  directly from TObject instead of TPersistent and they will not have
  full streaming support in the IDE. Enabeling DI_No_Containers_Persistent will
  generate smaller exe files.

  This option is only available for the DIContainers source code. }

{.$DEFINE DIC_Design} // Default: Off
{ This option is only relevant for modifications to the the DIContainers source code. }

{ ---------------------------------------------------------------------------- }
{ DIFileFinder                                                                 }
{ ---------------------------------------------------------------------------- }

{.$DEFINE DI_No_FileFinder_Component}// Default: Off
{ If DI_No_FileFinder_Component is defined, TDIFileFinder inherites from TObject
  instead of TComponent. Enabling DI_No_FileFinder_Component creates smaller
  executable files, even more so if Classes.pas is not used. This can be
  useful for console or CGI applications.

  This option is only available for the TDIFileFinder source code. }

{ ---------------------------------------------------------------------------- }
{ DIPcre                                                                       }
{ ---------------------------------------------------------------------------- }

{.$DEFINE DI_No_Pcre_Component}// Default: Off
{ If DI_No_Pcre_Component is defined, TDIPcre inherites from TObject
  instead of TComponent. Enabling DI_No_Pcre_Component creates smaller
  executable files, even more so if Classes.pas is not used. This can be
  useful for console applications or CGI / ISAPI DLLs.

  This option is only available for the DIPcre source code. }

{.$DEFINE DI_No_Pcre_Range_Checking}// Default: Off
{ Defining DI_No_Pcre_Range_Checking will suppress generation of code which
  checks for ranges errors. No error messages will be thrown in case of
  violations. Enabeling DI_No_Pcre_Range_Checking generates faster and smaller
  code.

  This option is only available for the DIPcre source code. }

{ ---------------------------------------------------------------------------- }
{ DIUnicode                                                                    }
{ ---------------------------------------------------------------------------- }

{.$DEFINE DI_No_Unicode_Component}// Default: Off
{ If DI_No_Unicode_Component is defined, the DIUnicode classes inherit from
  TObject instead of TComponent. Enabling DI_No_Unicode_Component creates
  smaller executable files, even more so if Classes.pas is not used. This can be
  useful for console applications or CGI / ISAPI DLLs.

  This option is only available for the DIUnicode source code. }

{ ---------------------------------------------------------------------------- }
{ DIZipWriter                                                                  }
{ ---------------------------------------------------------------------------- }

{.$DEFINE DI_No_ZipWriter_Component}// Default: Off
{ If DI_No_ZipWriter_Component is defined, TDIZipWriter inherites from TObject
  instead of TComponent. Enabling DI_No_ZipWriter_Component creates smaller
  executable files, even more so if Classes.pas is not used. This can be
  useful for console applications or CGI / ISAPI DLLs.

  This option is only available for the DIZipWriter source code. }

{ ---------------------------------------------------------------------------- }
{ Do not modify below here.                                                    }
{ ---------------------------------------------------------------------------- }

{ Check if one of the components requires Classes.pas
  and undefine DI_No_Classes accordingly. }

{$IFNDEF DI_No_Containers_Persistent}
{$UNDEF DI_No_Classes} // TPersistent is defined in Classes.pas.
{$ENDIF}

{$IFNDEF DI_No_FileFinder_component}
{$UNDEF DI_No_Classes} // TComponent is defined in Classes.pas.
{$ENDIF}

{$IFNDEF DI_No_Pcre_component}
{$UNDEF DI_No_Classes} // TComponent is defined in Classes.pas.
{$ENDIF}

{$IFNDEF DI_No_Unicode_component}
{$UNDEF DI_No_Classes} // TComponent is defined in Classes.pas.
{$ENDIF}

{$IFNDEF DI_No_ZipWriter_component}
{$UNDEF DI_No_Classes} // TComponent is defined in Classes.pas.
{$ENDIF}

{ ---------------------------------------------------------------------------- }
{ Compiler                                                                     }
{ ---------------------------------------------------------------------------- }

{$A+}
(* The $A directive controls alignment of fields in record types.

   In the {$A+} state, fields in record types that are declared without the
   packed modifier are aligned. In the {$A-} state, fields in record types
   are never aligned. Record type field alignment is described in the Object
   Pascal Language Guide.

   Regardless of the state of the $A directive, variables and typed constants
   are always aligned for optimal access. In the {$A+} state, execution
   will be faster. *)

{$B-}
(* The $B directive switches between the two different models of code
   generation for the and and or Boolean operators.

   In the {$B+} state, the compiler generates code for complete Boolean
   expression evaluation. This means that every operand of a Boolean
   expression built from the and and or operators is guaranteed to be
   evaluated, even when the result of the entire expression is already known.

   In the {$B-} state, the compiler generates code for short-circuit Boolean
   expression evaluation, which means that evaluation stops as soon as the
   result of the entire expression becomes evident in left to right order
   of evaluation. *)

{$H+}
(* The $H directive controls the meaning of the reserved word string when
   used alone in a type declaration. The generic type string can represent
   either a long, dynamically-allocated string (the fundamental type AnsiString)
   or a short, statically-allocated string (the fundamental type ShortString).

   By default {$H+}, Delphi defines the generic string type to be the long
   AnsiString. All components in the Visual Component Library are compiled
   in this state. If you write components, they should also use long strings,
   as should any code that receives data from VCL string-type properties.

   The {$H-} state is mostly useful for using code from versions of Object
   Pascal that used short strings by default. You can locally override the
   meaning of string-type definitions to ensure generation of short strings.
   You can also change declarations of short string types to string[255] or
   ShortString, which are unambiguous and independent of the $H setting. *)

{$J-}
(* The $J directive controls whether typed constants can be modified or not.
   In the {$J+} state, typed constants can be modified, and are in essence
   initialized variables. In the {$J-} state, typed constants are truly
   constant, and any attempt to modify a typed constant causes the compiler
   to report an error. *)

{$T+}
(* The $T directive controls the types of pointer values generated by the
   @ operator and the compatibility of pointer types.

   In the {$T-} state, the result of the @ operator is always an untyped
   pointer (Pointer) that is compatible with all other pointer types.
   When @ is applied to a variable reference in the {$T+} state, the result
   is a typed pointer that is compatible only with Pointer and with other
   pointers to the type of the variable. *)

{$IFDEF COMPILER_7_UP}
{$WARN UNSAFE_CAST OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_TYPE OFF}
{$ENDIF}
(* Disables .NET warnings for Delphi 7 and later. *)

{$X+}
(* The $X directive enables or disables Delphi's extended syntax. *)

{ }

