******************************************
Interprocess Communication streams for KOL
******************************************

Based on the need for some simple interprocess communication
I found myself wandering around WIN32.HLP.

The result (after some research) is the set of IPC Tstream descendants
in kolIPCStreams.pas.

These streams make it *extremely* easy to use:
1 - Anonymous Pipes
2 - Named Pipes
3 - Mail Slots

Both Pipe types are Read Blocking for now, so they should be used from a thread.
See the demo's
If you want to use these streams you have to make a small change to KOL.PAS
In Tstream, declare the new public property:

  property Data:TStreamdata read Fdata;

This is necessary to surface the data outside of KOL.PAS.

****************
            I will ask Vladimir Kladov if he wants to change this in a
            future (i.e. higher than 1.68) release, because it seems logical
            as Methods is already a property.
            (Or make both fData and fMethods protected, so descendants or
            typecast-hacks can use them)

Vladimir, if you read this, can you add this to a future release?
or even better: Make both Fdata and Fmethods protected instead of private??

Regards,

  Thaddy
****************

 TODO:    - Write out ALL the TStreammethod stubs to create a more robust implementation.
            Currently the KOL Tstream object is a rightful mess for anything other
            than *real* filestreams and memorystreams.
            Note that the OS consiiders Mailslots and Pipes as Files, so imho this
            should not be the case.
          - Write Non-blocking (asynchronous) pipestreams;
          - Write bidirectional Streams



I've added some OS EVENT and Mutex examples as well,
nut these are covered in KOL (JustOne etc)

Remarks: (In English Please, I can only read Russian a little bit)
mailto:thaddy@thaddy.com
