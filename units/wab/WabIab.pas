unit WabIab;

interface

uses
  Windows, ActiveKOL, WabDefs, ActiveX;

{$I WAB.INC}  

{$ALIGN ON}
{$MINENUMSIZE 4}
{$WEAKPACKAGEUNIT}

(*$HPPEMIT '#include <wabiab.h>'*)

{ CreateOneOff *}
//****** MAPI_UNICODE			((ULONG) 0x80000000) */
//****** MAPI_SEND_NO_RICH_INFO		((ULONG) 0x00010000) */

{ RecipOptions }
//****** MAPI_UNICODE			((ULONG) 0x80000000) */

{ QueryDefaultRecipOpt }
//****** MAPI_UNICODE			((ULONG) 0x80000000) */

{ GetSearchPath }
//****** MAPI_UNICODE			((ULONG) 0x80000000) */

const

{ These are WAB only flags for IAdrBook::ResolveName }

//      MAPI_UNICODE                        ((ULONG) 0x80000000)
  WAB_RESOLVE_LOCAL_ONLY                = ULONG($80000000);
  {$EXTERNALSYM WAB_RESOLVE_LOCAL_ONLY}
  WAB_RESOLVE_ALL_EMAILS                = ULONG($40000000);
  {$EXTERNALSYM WAB_RESOLVE_ALL_EMAILS}
  WAB_RESOLVE_NO_ONE_OFFS               = ULONG($20000000);
  {$EXTERNALSYM WAB_RESOLVE_NO_ONE_OFFS}
  WAB_RESOLVE_NEED_CERT                 = ULONG($10000000);
  {$EXTERNALSYM WAB_RESOLVE_NEED_CERT}
  WAB_RESOLVE_NO_NOT_FOUND_UI           = ULONG($08000000);
  {$EXTERNALSYM WAB_RESOLVE_NO_NOT_FOUND_UI}
  WAB_RESOLVE_USE_CURRENT_PROFILE       = ULONG($04000000);
  {$EXTERNALSYM WAB_RESOLVE_USE_CURRENT_PROFILE}
  WAB_RESOLVE_FIRST_MATCH               = ULONG($02000000);
  {$EXTERNALSYM WAB_RESOLVE_FIRST_MATCH}
  WAB_RESOLVE_UNICODE                   = ULONG($01000000);
  {$EXTERNALSYM WAB_RESOLVE_UNICODE}
//      MAPI_DIALOG                         ((ULONG) 0x00000008)

type
  IAddrBook = interface(IMAPIProp)
    function OpenEntry(cbEntryID: ULONG; lpEntryID: PEntryID; lpInterface: PIID;
      ulFlags: ULONG; var lpulObjType: ULONG; out lppUnk: IUnknown): HResult; stdcall;
    function CompareEntryIDs(cbEntryID1: ULONG; lpEntryID1: PEntryID;
      cbEntryID2: ULONG; lpEntryID2: PEntryID; ulFlags: ULONG;
      var lpulResult: ULONG): HResult; stdcall;
    function Advise(cbEntryID: ULONG; lpEntryID: PEntryID; ulEventMask: ULONG;
      lpAdviseSink: IMAPIAdviseSink; var lpulConnection: ULONG): HResult; stdcall;
    function Unadvise(ulConnection: ULONG): HResult; stdcall;
    function CreateOneOff(lpszName, lpszAdrType, lpszAddress: LPTSTR; ulFlags: ULONG;
      var lpcbEntryID: ULONG; var lppEntryID: PEntryID): HResult; stdcall;
    function NewEntry(ulUIParam, ulFlags, cbEIDContainer: ULONG;
      lpEIDContainer: PEntryID; cbEIDNewEntryTpl: ULONG; lpEIDNewEntryTpl: PEntryID;
      var lpcbEIDNewEntry: ULONG; var lppEIDNewEntry: PEntryID): HResult; stdcall;
    function ResolveName(ulUIParam, ulFlags: ULONG; lpszNewEntryTitle: LPTSTR;
      var lpAdrList: PAdrList): HResult; stdcall;
    function Address(var lpulUIParam: ULONG; lpAdrParms: PAdrParam;
      var lppAdrList: PAdrList): HResult; stdcall;
    function Details(var lpulUIParam: ULONG; lpfnDismiss: PFnDismiss;
      lpvDismissContext: Pointer; cbEntryID: ULONG; lpEntryID: PEntryID;
      lpfButtonCallback: PFnButton; lpvButtonContext: Pointer; lpszButtonText: LPTSTR;
      ulFlags: ULONG): HResult; stdcall;
    function RecipOptions(ulUIParam, ulFlags: ULONG; lpRecip: PAdrEntry): HResult; stdcall;
    function QueryDefaultRecipOpt(lpszAdrType: LPTSTR; ulFlags: ULONG;
      var lpcValues: ULONG; var lppOptions: PSPropValue): HResult; stdcall;
    function GetPAB(var lpcbEntryID: ULONG; var lppEntryID: PEntryID): HResult; stdcall;
    function SetPAB(cbEntryID: ULONG; lpEntryID: PEntryID): HResult; stdcall;
    function GetDefaultDir(var lpcbEntryID: ULONG; var lppEntryID: PEntryID): HResult; stdcall;
    function SetDefaultDir(cbEntryID: ULONG; lpEntryID: PEntryID): HResult; stdcall;
    function GetSearchPath(ulFlags: ULONG; var lppSearchPath: PSRowSet): HResult; stdcall;
    function SetSearchPath(ulFlags: ULONG; lpSearchPath: PSRowSet): HResult; stdcall;
    function PrepareRecips(ulFlags: ULONG; lpPropTagArray: PSPropTagArray;
      lpRecipList: PSPropTagArray): HResult; stdcall;
  end;
  {$EXTERNALSYM IAddrBook}

implementation

end.
