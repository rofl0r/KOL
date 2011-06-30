// 25-nov-2002
unit IdGopherConsts;

interface
uses IdGlobal;

const
  IdGopherItem_Document = '0'; // Item is a file
  IdGopherItem_Directory = '1'; // Item is a directory
  IdGopherItem_CSO = '2'; // Item is a CSO phone-book server
  IdGopherItem_Error = '3'; // Error
  IdGopherItem_BinHex = '4'; // Item is a BinHexed Macintosh file.
  IdGopherItem_BinDOS = '5'; // Item is DOS binary archive of some sort.
    // Client must read until the TCP connection closes.
  IdGopherItem_UUE = '6'; // Item is a UNIX uuencoded file.
  IdGopherItem_Search = '7'; // Item is an Index-Search server.
  IdGopherItem_Telnet = '8'; // Item points to a text-based telnet session.
  IdGopherItem_Binary = '9'; // Item is a binary file.
    // Client must read until the TCP connection closes.
  IdGopherItem_Redundant = '+'; // Item is a redundant server
  IdGopherItem_TN3270 = 'T'; // Item points to a text-based tn3270 session.
  IdGopherItem_GIF = 'g'; // Item is a GIF format graphics file.
  IdGopherItem_Image = ':'; // Item is some kind of image file.
    // Client decides how to display.  Was 'I', but depracted
  IdGopherItem_Image2 = 'I'; //Item is some kind of image file -

  {"Gopher RFC + - extensions etc}
  IdGopherItem_Sound = '<'; //Was 'S', but deprecated
  IdGopherItem_Sound2 = 'S';
    //This was depreciated but should be used with clients
  IdGopherItem_Movie = ';'; //Was 'M', but deprecated
  IdGopherItem_HTML = 'h';
  IdGopherItem_MIME = 'M'; //See above for a potential conflict with Movie
  IdGopherItem_Information = 'i'; // Not a file - just information

  IdGopherPlusIndicator = IdGopherItem_Redundant;

  IdGopherPlusInformation = '!'; // Formatted information
  IdGopherPlusDirectoryInformation = '$';

  IdGopherPlusInfo = '+INFO: ';
  IdGopherPlusAdmin = '+ADMIN:' + EOL;
  IdGopherPlusViews = '+VIEWS:' + EOL;
  IdGopherPlusAbstract = '+ABSTRACT:' + EOL;
  IdGopherPlusAsk = '+ASK:';

  //Questions for +ASK section:
  IdGopherPlusAskPassword = 'AskP: ';
  IdGopherPlusAskLong = 'AskL: ';
  IdGopherPlusAskFileName = 'AskF: ';

  // Prompted responses for +ASK section:
  IdGopherPlusSelect = 'Select: '; // Multi-choice, multi-selection
  IdGopherPlusChoose = 'Choose: '; // Multi-choice, single-selection
  IdGopherPlusChooseFile = 'ChooseF: '; //Multi-choice, single-selection

  //Known response types:
  IdGopherPlusData_BeginSign = '+-1' + EOL;
  IdGopherPlusData_EndSign = EOL + '.' + EOL;
  IdGopherPlusData_UnknownSize = '+-2' + EOL;
  IdGopherPlusData_ErrorBeginSign = '--1' + EOL;
  IdGopherPlusData_ErrorUnknownSize = '--2' + EOL;
  IdGopherPlusError_NotAvailable = '1';
  IdGopherPlusError_TryLater = '2';
  IdGopherPlusError_ItemMoved = '3';

implementation

end.
