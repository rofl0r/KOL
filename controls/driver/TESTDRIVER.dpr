library TESTDRIVER;
{$DESCRIPTION 'MIDI: "This is not a midi driver yet"'}
{
       Unit: TESTDRIVER
    purpose: Template for an installable (multimedia) driver
             using the KOL library by Vladimir Kladov.

     Author: Thaddy de Koning
  Copyright: (c) 2003, Thaddy de Koning
             thaddy@thaddy.com
             
             Portions (C) Microsoft Corporation

  PLATFORMS:  (Shameless Plug)
              PowerBasic/DLL 6.00 version available on request
             (PowerBasic is the successor to TurboBasic,
              Bought back from Borland by its designer in about 1991, Bob Zale,
              and has all the language features that Delphi or C has, except OOP.
              Whats more: It creates often even smaller WIN32 programs than
              Delphi + KOL or even plain C!
              And.. contrary to Borland claims, this really is the worlds
              fastest Win32 Compiler. IT BURNS DELPHI FROM THE TRACK by a
              factor of almost 2.
              Its language features includes pointer operations, built in
              assembler, true structured exception handling, TCP/IP and UDP
              commands and much much more.
              Not your basic BASIC...
              Its executables are so small, the latest compiler has even a
              BLOAT switch to create more "professional" looking executable
              sizes....... (TRUE!) and it links with Delphi or C obj files.

              www.PowerBasic.Com,

              Highly recommended.
              KOL users will love it.
              (End Shameless plug)

    Remarks: I have searched long and hard but couldn't find
             ANY (yes, shouting!) example of a driver written in Delphi,
             except for services.
             Device drivers were notoriously hard to write in pascal when I was
             doing them in the late 80's and early '90's
              - and frankly in plain C too - because nothing else would do
              easily in 16 bit in Borland Pascal.
             (manual relocation of the code block, etc, it could be done but
             don't ask how, separate linking, duffing things up with TASM or
             MASM, nice:-))

             BUT...
             Here is one in plain KOL! It does nothing much, but..
             I believe this to be the only Delphi one published as freeware to
             date.
             And it proved to be very very simple ;)
             A (MM) driver is just a DLL that serves messages instead of
             procedures or functions. And provides an optional callback
             entrypoint to respond. And it has very high priority by default.
             Which means it has a lot more potential than just MM.

             This is partly a translation from the WIN32 Multimedia programmers
             reference example with some additions.
             Tested and works! with a VCL based App and a KOL one,
             Both included.
             (Platforms tested: WIN98,WINME WIN2000 pro and WIN XP)

Known issue: The driver seems to get called two times, before even an
             eventhandler is assigned?? (in plain C and C++ too)
             It's not really a problem, but less elegant and I can't
             trace the bug, if it is one.

 **********
 SIMPLE USE
 **********
             To use it simple, create an entry in the registry in the

    'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Drivers32'

             section that contains the name of the dll as keyvalue and
             the full path to your dll + its name as the keydata.

             Example:

             'Testdriver' -  <'REG_SZ'> -  'd:\testdriver.dll'

             Or alternatively keep your exe and driver in the same directory.
             Which means:
***********
SIMPLER USE
***********
            Don't bother with the above, simply run the DLL with
            one of the example clients

*********************************
ADVANCED USE AND PROOF OF CONCEPT
*********************************

              To use it more complex, try installing it as a hardware device!
              Yup, it thinks it's hardware;:;:;)(O))))( very big smile with very
              big eyes, blinking, mouth falling open)

              You need to write a small INF file to do that:

*********************************
             BEGIN TESTDRIVER.INF
*********************************
[disks]
    1 =. ,"TESTDRIVER Driver",disk1

[Installable.Drivers]
TESTDRIVER = 1:testdriver.dll,  "MIDI", "This is not a midi driver yet",,,

[TESTDRIVER]

*********************************
               END TESTFRIVER.INF
*********************************


***************************************
INSTALL INSTRUCTIONS WINDOWS XP (US v.)
***************************************

1: Save the text amidst the stars, but without them as
"Testdriver.inf" in the same directory as the testdriver.dll

2: Open the Control panel

3: Open "Ádd new hardware"  <Grin>

4: Ignore the search from the wizard and click
   "Yes, I have already connected the hardware "

5: Click next and (below in the list) "Add a new hardware device"

6: Select Ïnstall the hardware that I manually select from a list"

7: Select "sound, video and game controllers"

8: Select "Have disk" and point to your "testdriver.inf"

9: The driver will now be installed.

10: IGNORE ALL WARNINGS AND ALWAYS SELECT "INSTALL ANYWAY"
    Ofcourse this driver isn't signed! It's pointless and
    whats more it's bloody expensive!!!!!

11: Close the hardware wizard and select "Sounds and Audio devices"

12: Select the "hardware" tab

13: Look up the same text as on the fifth line in your INF file.
("This is not a mididriver yet")

14: Select it and try Properties and again properties

15: expand the tree and select it

16: Wow!

************
TO REMOVE IT
************
Uninstall the driver from the Controlpanel|Sounds and Audio works OK in XP

or else
1: Start up regedit.exe
2: Search for "TESTDRIVER.DLL"
3: Delete the key, there should be only one entry
4: Delete the dll from the driver32 directory
************


             The general idea is you can define custom messages to which the
             driver must respond, besides the default messages as shown in
             this example.
             You can use this project as a template.
             The size of an empty driver is only about 9k ,
             about 5k compressed with UPX.
             (30K smaller than without KOL)
}


uses
  KOL,
  Windows,
  Messages,
  MMSYSTEM;

const
  DRV_CUSTOM_MESSAGE = WM_USER + 11*11*11;
  // That would be:
  // - true!, all of these, please no jokes! -
  // My mother's birthday September, 11,-1930-
  // My father's birthday October, 11,-1926-
  // My youngest sister's Birthday November,11,-1966-

function DriverProc(dwDriverId: DWORD; hdrv: HDRVR;
    Themsg: UINT; lparam1, lparam2: LPARAM): Longint stdcall;
begin
 result := 0;
 case themsg of
 DRV_LOAD:
    begin
      Result:=1;                // Sent when the driver is loaded,
    end;                        // This is always the first message
                                // received by a driver.
                                // Returns 0 to fail

 DRV_FREE:                      // Sent when the driver is about to be discarded
   begin                        // This is always the last message a driver receives
     Result:=1;
   end;
 DRV_OPEN:                       // Returns 0 to fail.
   begin                        // Value subsequently used for dwDriverID
     Result:=1;
   end;
 DRV_CLOSE:                     // See Win32 Multimedia  programmers reference
    begin                       // Installable drivers section
      Result:=1;
    end;
 DRV_ENABLE:                    // see above
    begin
      Result:=1;
    end;

 DRV_DISABLE:                    // see above
    begin
      Result:=1;
    end;

 DRV_INSTALL://Result:=DRVCNF_OK; // see above
    begin
      Messagebox(0,'Installing..','TestDriver',MB_OK);
      Result:=1;
    end;

 DRV_REMOVE:                      // see above
    begin
      Messagebox(0,'Removing..','TestDriver',MB_OK);
      Result:=1;
    end;

 DRV_QUERYCONFIGURE:            // Returns if a driver is
                                // configurable by the user
    begin
      Messagebox(0,'Yes, please..'#13'Configure me..','TestDriver',MB_OK);
      Result:=1;
    end;

 // Displays configuration dialog
 // and should write cfg values to the registry
 DRV_CONFIGURE:Messagebox(0,'Configuring..','TestDriver',MB_OK);

 //Example driver task
 DRV_CUSTOM_MESSAGE:Messagebox(0,'Somebody''s birthday..?','TestDriver',MB_OK);
 else
   Result:=DefDriverProc(dwDriverID,hdrv,TheMsg,Lparam1,Lparam2);
 end;
end;

exports
  DriverProc;
begin

end.

