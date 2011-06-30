{$IFDEF VER90}
               {$DEFINE _D2}
               {$DEFINE _D2orD3}
               {$DEFINE _D2orD3orD4}
{$ENDIF}

{$IFDEF VER100}
               {$DEFINE _D3}
               {$DEFINE _D3orHigher}
               {$DEFINE _D2orD3}
               {$DEFINE _D2orD3orD4}
               {$DEFINE _D3orD4}
{$ENDIF}

{$IFDEF VER120}
               {$DEFINE _D3orHigher}
               {$DEFINE _D3orD4}
               {$DEFINE _D4}
               {$DEFINE _D4orHigher}
               {$DEFINE _D2orD3orD4}
{$ENDIF}

{$IFDEF VER130}
               {$DEFINE _D3orHigher}
               {$DEFINE _D4orHigher}
               {$DEFINE _D5}
               {$DEFINE _D5orHigher}
{$ENDIF}


{$IFDEF VER140}
               {$DEFINE _D3orHigher}
               {$DEFINE _D4orHigher}
               {$DEFINE _D5orHigher}
               {$DEFINE _D6}
               {$DEFINE _D6orHigher}
{$ENDIF}

{$IFDEF VER150}
               {$DEFINE _D3orHigher}
               {$DEFINE _D4orHigher}
               {$DEFINE _D5orHigher}
               {$DEFINE _D6orHigher}
               {$DEFINE _D7}
               {$DEFINE _D7orHigher}
{$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

{$IFNDEF _NOT_KOLCtrlWrapper_}
  {$DEFINE _KOLCtrlWrapper_}
{$ENDIF}


