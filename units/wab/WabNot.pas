unit WabNot;

interface

uses
  Windows, KOLActiveX, WabDefs;

{$I WAB.INC}  

{$ALIGN ON}
{$MINENUMSIZE 4}
{$WEAKPACKAGEUNIT}

(*$HPPEMIT '#include <wabnot.h>'*)


{ Notification key structure for the MAPI notification engine }

type
  PNotifyKey = ^TNotifyKey;
  NOTIFKEY = record
    cb: ULONG;                        // How big the key is
    ab: array[0..MAPI_DIM-1] of Byte; // Key contents
  end;
  {$EXTERNALSYM NOTIFKEY}
  TNotifyKey = NOTIFKEY;

(*!!!
#define CbNewNOTIFKEY(_cb)		(offsetof(NOTIFKEY,ab) + (_cb))
#define CbNOTIFKEY(_lpkey)		(offsetof(NOTIFKEY,ab) + (_lpkey)->cb)
#define SizedNOTIFKEY(_cb, _name) \
	struct _NOTIFKEY_ ## _name \
{ \
	ULONG		cb; \
	BYTE		ab[_cb]; \
} _name
*)

{ For Subscribe() }

const
  NOTIFY_SYNC           = ULONG($40000000);
  {$EXTERNALSYM NOTIFY_SYNC}

{ For Notify() }

  NOTIFY_CANCELED       = ULONG($80000000);
  {$EXTERNALSYM NOTIFY_CANCELED}

{ From the Notification Callback function (well, this is really a ulResult) }

  CALLBACK_DISCONTINUE	= ULONG($80000000);
  {$EXTERNALSYM CALLBACK_DISCONTINUE}

{ For Transport's SpoolerNotify() }

  NOTIFY_NEWMAIL        = ULONG($00000001);
  {$EXTERNALSYM NOTIFY_NEWMAIL}
  NOTIFY_READYTOSEND    = ULONG($00000002);
  {$EXTERNALSYM NOTIFY_READYTOSEND}
  NOTIFY_SENTDEFERRED   = ULONG($00000004);
  {$EXTERNALSYM NOTIFY_SENTDEFERRED}
  NOTIFY_CRITSEC        = ULONG($00001000);
  {$EXTERNALSYM NOTIFY_CRITSEC}
  NOTIFY_NONCRIT        = ULONG($00002000);
  {$EXTERNALSYM NOTIFY_NONCRIT}
  NOTIFY_CONFIG_CHANGE	= ULONG($00004000);
  {$EXTERNALSYM NOTIFY_CONFIG_CHANGE}
  NOTIFY_CRITICAL_ERROR	= ULONG($10000000);
  {$EXTERNALSYM NOTIFY_CRITICAL_ERROR}

{ For Message Store's SpoolerNotify() }

  NOTIFY_NEWMAIL_RECEIVED = ULONG($20000000);
  {$EXTERNALSYM NOTIFY_NEWMAIL_RECEIVED}

{ For ModifyStatusRow() }

  STATUSROW_UPDATE = ULONG($10000000);
  {$EXTERNALSYM STATUSROW_UPDATE}

{ For IStorageFromStream() }

  STGSTRM_RESET   = ULONG($00000000);
  {$EXTERNALSYM STGSTRM_RESET}
  STGSTRM_CURRENT = ULONG($10000000);
  {$EXTERNALSYM STGSTRM_CURRENT}
  STGSTRM_MODIFY  = ULONG($00000002);
  {$EXTERNALSYM STGSTRM_MODIFY}
  STGSTRM_CREATE  = ULONG($00001000);
  {$EXTERNALSYM STGSTRM_CREATE}

{ For GetOneOffTable() }
//****** MAPI_UNICODE			((ULONG) 0x80000000) */

{ For CreateOneOff() }
//****** MAPI_UNICODE			((ULONG) 0x80000000) */
//****** MAPI_SEND_NO_RICH_INFO	((ULONG) 0x00010000) */

{ For ReadReceipt() }
  MAPI_NON_READ = ULONG($00000001);
  {$EXTERNALSYM MAPI_NON_READ}

{ For DoConfigPropSheet() }
//****** MAPI_UNICODE			((ULONG) 0x80000000) */


implementation

end.
