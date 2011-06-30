// 19-nov-2002
unit IdResourceStrings;

interface

resourcestring
 {General}
  RSAlreadyConnected = 'Already connected.';
  RSByteIndexOutOfBounds = 'Byte index out of range.';
  RSCannotAllocateSocket = 'Cannot allocate socket.';
  RSConnectionClosedGracefully = 'Connection Closed Gracefully.';
  RSCouldNotBindSocket =
    'Could not bind socket. Address and port are already in use.';
  RSFailedTimeZoneInfo = 'Failed attempting to retrieve time zone information.';
  RSNoBindingsSpecified = 'No bindings specified.';
  RSOnExecuteNotAssigned = 'OnExecute not assigned.';
  RSNotAllBytesSent = 'Not all bytes sent.';
  RSNotEnoughDataInBuffer = 'Not enough data in buffer.';
  RSPackageSizeTooBig = 'Package Size Too Big.';
  RSUDPReceiveError0 = 'UDP Receive Error = 0.';
  RSRawReceiveError0 = 'Raw Receive Error = 0.';
  RSICMPReceiveError0 = 'ICMP Receive Error = 0.';
  RSWinsockInitializationError = 'Winsock Initialization Error.';
  RSCouldNotLoad = '%s could not be loaded.';
  RSSetSizeExceeded = 'Set Size Exceeded.';
  RSThreadClassNotSpecified = 'Thread Class Not Specified.';
  RSCannotChangeDebugTargetAtWhileActive = 'Cannot change target while active.';
  RSOnlyOneAntiFreeze = 'Only one TIdAntiFreeze can exist per application.';
  RSInterceptPropIsNil =
    'InterceptEnabled cannot be set to true when Intercept is nil.';
  RSInterceptPropInvalid = 'Intercept value is not valid';
  RSObjectTypeNotSupported = 'Object type not supported.';
  RSAcceptWaitCannotBeModifiedWhileServerIsActive
    = 'AcceptWait property cannot be modified while server is active.';
  RSNoExecuteSpecified = 'No execute handler found.';
  RSIdNoDataToRead = 'No data to read.';
  // Status Strings
  RSStatusResolving = 'Resolving hostname %s.';
  RSStatusConnecting = 'Connecting to %s.';
  RSStatusConnected = 'Connected.';
  RSStatusDisconnecting = 'Disconnecting from %s.';
  RSStatusDisconnected = 'Not connected.';
  RSStatusText = '%s';
  //IdRegister
  RSRegIndyClients = 'Indy Clients';
  RSRegIndyServers = 'Indy Servers';
  RSRegIndyMisc = 'Indy Misc';
  //IdCoder3To4
  RSCoderNoTableEntryNotFound = 'Coding table entry not found.';
  // MessageClient Strings
  RSMsgClientEncodingText = 'Encoding text';
  RSMsgClientEncodingAttachment = 'Encoding attachment';
  // NNTP Exceptions
  RSNNTPConnectionRefused = 'Connection explicitly refused by NNTP server.';
  RSNNTPStringListNotInitialized = 'Stringlist not initialized!';
  RSNNTPNoOnNewsgroupList = 'No OnNewsgroupList event has been defined.';
  RSNNTPNoOnNewGroupsList = 'No OnNewGroupsList event has been defined.';
  RSNNTPNoOnNewNewsList = 'No OnNewNewsList event has been defined.';
  // HTTP Status
  RSHTTPChunkStarted = 'Chunk Started';
  RSHTTPContinue = 'Continue';
  RSHTTPSwitchingProtocols = 'Switching protocols';
  RSHTTPOK = 'OK';
  RSHTTPCreated = 'Created';
  RSHTTPAccepted = 'Accepted';
  RSHTTPNonAuthoritativeInformation = 'Non-authoritative Information';
  RSHTTPNoContent = 'No Content';
  RSHTTPResetContent = 'Reset Content';
  RSHTTPPartialContent = 'Partial Content';
  RSHTTPMovedPermanently = 'Moved Permanently';
  RSHTTPMovedTemporarily = 'Moved Temporarily';
  RSHTTPSeeOther = 'See Other';
  RSHTTPNotModified = 'Not Modified';
  RSHTTPUseProxy = 'Use Proxy';
  RSHTTPBadRequest = 'Bad Request';
  RSHTTPUnauthorized = 'Unauthorized';
  RSHTTPForbidden = 'Forbidden';
  RSHTTPNotFound = 'Not Found';
  RSHTTPMethodeNotallowed = 'Method not allowed';
  RSHTTPNotAcceptable = 'Not Acceptable';
  RSHTTPProxyAuthenticationRequired = 'Proxy Authentication Required';
  RSHTTPRequestTimeout = 'Request Timeout';
  RSHTTPConflict = 'Conflict';
  RSHTTPGone = 'Gone';
  RSHTTPLengthRequired = 'Length Required';
  RSHTTPPreconditionFailed = 'Precondition Failed';
  RSHTTPRequestEntityToLong = 'Request Entity To Long';
  RSHTTPRequestURITooLong = 'Request-URI Too Long. 256 Chars max';
  RSHTTPUnsupportedMediaType = 'Unsupported Media Type';
  RSHTTPInternalServerError = 'Internal Server Error';
  RSHTTPNotImplemented = 'Not Implemented';
  RSHTTPBadGateway = 'Bad Gateway';
  RSHTTPServiceUnavailable = 'Service Unavailable';
  RSHTTPGatewayTimeout = 'Gateway timeout';
  RSHTTPHTTPVersionNotSupported = 'HTTP version not supported';
  RSHTTPUnknownResponseCode = 'Unknown Response Code';
  // HTTP Other
  RSHTTPHeaderAlreadyWritten = 'Header has already been written.';
  RSHTTPErrorParsingCommand = 'Error in parsing command.';
  RSHTTPUnsupportedAuthorisationScheme = 'Unsupported authorization scheme.';
  RSHTTPCannotSwitchSessionStateWhenActive =
    'Cannot change session state when the server is active.';

  // FTP
  RSFTPUnknownHost = 'Unknown';
  // Property editor exceptions
  RSCorruptServicesFile = '%s is corrupt.';
  RSInvalidServiceName = '%s is not a valid service.';
  // Stack Error Messages
  RSStackError = 'Socket Error # %d' + #13#10 + '%s';
  RSStackEINTR = 'Interrupted system call.';
  RSStackEBADF = 'Bad file number.';
  RSStackEACCES = 'Access denied.';
  RSStackEFAULT = 'Bad address.';
  RSStackEINVAL = 'Invalid argument.';
  RSStackEMFILE = 'Too many open files.';
  RSStackEWOULDBLOCK = 'Operation would block. ';
  RSStackEINPROGRESS = 'Operation now in progress.';
  RSStackEALREADY = 'Operation already in progress.';
  RSStackENOTSOCK = 'Socket operation on non-socket.';
  RSStackEDESTADDRREQ = 'Destination address required.';
  RSStackEMSGSIZE = 'Message too long.';
  RSStackEPROTOTYPE = 'Protocol wrong type for socket.';
  RSStackENOPROTOOPT = 'Bad protocol option.';
  RSStackEPROTONOSUPPORT = 'Protocol not supported.';
  RSStackESOCKTNOSUPPORT = 'Socket type not supported.';
  RSStackEOPNOTSUPP = 'Operation not supported on socket.';
  RSStackEPFNOSUPPORT = 'Protocol family not supported.';
  RSStackEAFNOSUPPORT = 'Address family not supported by protocol family.';
  RSStackEADDRINUSE = 'Address already in use.';
  RSStackEADDRNOTAVAIL = 'Cannot assign requested address.';
  RSStackENETDOWN = 'Network is down.';
  RSStackENETUNREACH = 'Network is unreachable.';
  RSStackENETRESET = 'Net dropped connection or reset.';
  RSStackECONNABORTED = 'Software caused connection abort.';
  RSStackECONNRESET = 'Connection reset by peer.';
  RSStackENOBUFS = 'No buffer space available.';
  RSStackEISCONN = 'Socket is already connected.';
  RSStackENOTCONN = 'Socket is not connected.';
  RSStackESHUTDOWN = 'Cannot send or receive after socket is closed.';
  RSStackETOOMANYREFS = 'Too many references, cannot splice.';
  RSStackETIMEDOUT = 'Connection timed out.';
  RSStackECONNREFUSED = 'Connection refused.';
  RSStackELOOP = 'Too many levels of symbolic links.';
  RSStackENAMETOOLONG = 'File name too long.';
  RSStackEHOSTDOWN = 'Host is down.';
  RSStackEHOSTUNREACH = 'No route to host.';
  RSStackENOTEMPTY = 'Directory not empty';
  RSStackEPROCLIM = 'Too many processes.';
  RSStackEUSERS = 'Too many users.';
  RSStackEDQUOT = 'Disk Quota Exceeded.';
  RSStackESTALE = 'Stale NFS file handle.';
  RSStackEREMOTE = 'Too many levels of remote in path.';
  RSStackSYSNOTREADY = 'Network subsystem is unavailable.';
  RSStackVERNOTSUPPORTED = 'WINSOCK DLL Version out of range.';
  RSStackNOTINITIALISED = 'Winsock not loaded yet.';
  RSStackHOST_NOT_FOUND = 'Host not found.';
  RSStackTRY_AGAIN =
    'Non-authoritative response (try again or check DNS setup).';
  RSStackNO_RECOVERY = 'Non-recoverable errors: FORMERR, REFUSED, NOTIMP.';
  RSStackNO_DATA = 'Valid name, no data record (check DNS setup).';

  RSCMDNotRecognized = 'command not recognized';

  RSGopherNotGopherPlus = '%s is not a Gopher+ server';

  RSCodeNoError = 'RCode NO Error';
  RSCodeQueryFormat = 'DNS Server Reports Query Format Error';
  RSCodeQueryServer = 'DNS Server Reports Query Server Error';
  RSCodeQueryName = 'DNS Server Reports Query Name Error';
  RSCodeQueryNotImplemented = 'DNS Server Reports Query Not Implemented Error';
  RSCodeQueryQueryRefused = 'DNS Server Reports Query Refused Error';
  RSCodeQueryUnknownError = 'Server Returned Unknown Error';

  RSDNSMFIsObsolete = 'MF is an Obsolete Command. USE MX.';
  RSDNSMDISObsolete = 'MD is an Obsolete Command. Use MX.';
  RSDNSMailAObsolete = 'MailA is an Obsolete Command. USE MX.';
  RSDNSMailBNotImplemented = '-Err 501 MailB is not implemented';

  RSQueryInvalidQueryCount = 'Invaild Query Count %d';
  RSQueryInvalidPacketSize = 'Invalid Packet Size %d';
  RSQueryLessThanFour = 'Received Packet is too small. Less than 4 bytes %d';
  RSQueryInvalidHeaderID = 'Invalid Header Id %d';
  RSQueryLessThanTwelve = 'Received Packet is too small. Less than 12 bytes %d';
  RSQueryPackReceivedTooSmall = 'Received Packet is too small. %d';

  { LPD Client Logging event strings }
  RSLPDDataFileSaved = 'Data file saved to %s';
  RSLPDControlFileSaved = 'Control file save to %s';
  RSLPDDirectoryDoesNotExist = 'Directory %s does not exist';
  RSLPDServerStartTitle = 'Winshoes LPD Server %s ';
  RSLPDServerActive = 'Server status: active';
  RSLPDQueueStatus = 'Queue %s status: %s';
  RSLPDClosingConnection = 'closing connection';
  RSLPDUnknownQueue = 'Unknown queue %s';
  RSLPDConnectTo = 'connected with %s';
  RSLPDAbortJob = 'abort job';
  RSLPDReceiveControlFile = 'Receive control file';
  RSLPDReceiveDataFile = 'Receive data file';

  { LPD Exception Messages }
  RSLPDNoQueuesDefined = 'Error: no queues defined';

  { Trivial FTP Exception Messages }
  RSTimeOut = 'Timeout';
  RSTFTPUnexpectedOp = 'Unexpected operation from %s:%d';
  RSTFTPUnsupportedTrxMode = 'Unsupported transfer mode: "%s"';
  RSTFTPDiskFull =
    'Unable to complete write request, progress halted at %d bytes';
  RSTFTPFileNotFound = 'Unable to open %s';
  RSTFTPAccessDenied = 'Access to %s denied';

  { MESSAGE Exception messages }
  RSTIdTextInvalidCount = 'Invalid Text count. TIdText must be greater than 1';
  RSTIdMessagePartCreate =
    'TIdMessagePart can not be created.  Use descendant classes. ';

  { POP Exception Messages }
  RSPOP3FieldNotSpecified = ' not specified';

  { Telnet Server }
  RSTELNETSRVUsernamePrompt = 'Username: ';
  RSTELNETSRVPasswordPrompt = 'Password: ';
  RSTELNETSRVInvalidLogin = 'Invalid Login.';
  RSTELNETSRVMaxloginAttempt = 'Allowed login attempts exceeded, good bye.';
  RSTELNETSRVNoAuthHandler = 'No authentication handler has been specified.';
  RSTELNETSRVWelcomeString = 'Indy Telnet Server';
  RSTELNETSRVOnDataAvailableIsNil = 'OnDataAvailable event is nil.';

  { Telnet Client }
  RSTELNETCLIConnectError = 'server not responding';
  RSTELNETCLIReadError = 'Server did not respond.';

  { Network Calculator }
  RSNETCALInvalidIPString = 'The string %s does not translate into a valid IP.';
  RSNETCALCInvalidNetworkMask = 'Invalid network mask.';
  RSNETCALCInvalidValueLength = 'Invalid value length: Should be 32.';
  RSNETCALConfirmLongIPList =
    'There is too many IP addresses in the specified range (%d) to be displayed at design time.';

  { About Box stuff }
  RSAAboutFormCaption = 'About';
  RSAAboutBoxCompName = 'Internet Direct (Indy)';
  RSAAboutMenuItemName = 'About Internet &Direct (Indy) %s...';
  RSAAboutBoxVersion = 'Version %s';
  RSAAboutBoxCopyright = 'Copyright © 1993 - 2001'#13#10
    + 'Kudzu (Chad Z. Hower)'#13#10
    + 'and the'#13#10
    + 'Indy Pit Crew';
  RSAAboutBoxPleaseVisit =
    'For the latest updates and information please visit:';
  RSAAboutBoxIndyWebsite = 'http://www.nevrona.com/indy/';
  RSAAboutCreditsCoordinator = 'Project Coordinator';
  RSAAboutCreditsCoCordinator = 'Project Co-Coordinator';

  { Tunnel messages }
  RSTunnelGetByteRange =
    'Call to %s.GetByte [property Bytes] with index <> [0..%d]';
  RSTunnelTransformErrorBS = 'Error in transformation before send';
  RSTunnelTransformError = 'Transform failed';
  RSTunnelCRCFailed = 'CRC Failed';
  RSTunnelConnectMsg = 'Connecting';
  RSTunnelDisconnectMsg = 'Disconnect';
  RSTunnelConnectToMasterFailed = 'Cannt connect to the Master server';
  RSTunnelDontAllowConnections = 'Do not allow connctions now';
  RSTunnelMessageTypeError = 'Message type recognition error';
  RSTunnelMessageHandlingError = 'Message handling failed';
  RSTunnelMessageInterpretError = 'Interpretation of message failed';
  RSTunnelMessageCustomInterpretError = 'Custom message interpretation failed';

  { Socks messages }
  RSSocksRequestFailed = 'Request rejected or failed.';
  RSSocksRequestServerFailed =
    'Request rejected because SOCKS server cannot connect.';
  RSSocksRequestIdentFailed =
    'Request rejected because the client program and identd report different user-ids.';
  RSSocksUnknownError = 'Unknown socks error.';
  RSSocksServerRespondError = 'Socks server did not respond.';
  RSSocksAuthMethodError = 'Invalid socks authentication method.';
  RSSocksAuthError = 'Authentication error to socks server.';
  RSSocksServerGeneralError = 'General SOCKS server failure.';
  RSSocksServerPermissionError = 'Connection not allowed by ruleset.';
  RSSocksServerNetUnreachableError = 'Network unreachable.';
  RSSocksServerHostUnreachableError = 'Host unreachable.';
  RSSocksServerConnectionRefusedError = 'Connection refused.';
  RSSocksServerTTLExpiredError = 'TTL expired.';
  RSSocksServerCommandError = 'Command not supported.';
  RSSocksServerAddressError = 'Address type not supported.';

  { FTP }
  RSDestinationFileAlreadyExists = 'Destination file already exists.';

  { SSL messages }
  RSSSLAcceptError = 'Error accepting connection with SSL.';
  RSSSLConnectError = 'Error connecting with SSL.';
  RSSSLSettingChiperError = 'SetCipher failed.';
  RSSSLCreatingContextError = 'Error creating SSL context.';
  RSSSLLoadingRootCertError = 'Could not load root certificate.';
  RSSSLLoadingCertError = 'Could not load certificate.';
  RSSSLLoadingKeyError = 'Could not load key, check password.';
  RSSSLGetMethodError = 'Error geting SSL method.';
  RSSSLDataBindingError = 'Error binding data to SSL socket.';
  {IdMessage Component Editor}
  RSMsgCmpEdtrNew = '&New Message Part...';
  RSMsgCmpEdtrExtraHead = 'Extra Headers Text Editor';
  RSMsgCmpEdtrBodyText = 'Body Text Editor';
  {IdICMPClient}
  RSICMPNotEnoughtBytes = 'Not enough bytes received';
  RSICMPNonEchoResponse = 'Non-echo type response received';
  RSICMPWrongDestination = 'Received someone else''s packet';
  {IdNNTPServer}
  RSNNTPServerNotRecognized = 'command not recognized (%s)';
  RSNNTPServerGoodBye = 'Goodbye';
  {IdGopherServer}
  RSGopherServerNoProgramCode = 'Error: No program code to return request!';

  {IdOpenSSL}
  RSOSSLModeNotSet = 'Mode has not been set.';
  RSOSSLCouldNotLoadSSLLibrary = 'Could not load SSL library.';
  RSOSSLStatusString = 'SSL status: "%s"';
  RSOSSLConnectionDropped = 'SSL connection has dropped.';
  RSOSSLCertificateLookup = 'SSL certificate request error.';
  RSOSSLInternal = 'SSL library internal error.';

  {IdWinsockStack}
  RSWSockStack = 'Winsock stack';
  {IdLogBase}
  RSLogConnected = 'Connected.';
  RSLogRecV = 'Recv: ';
  RSLogSent = 'Sent: ';
  RSLogDisconnected = 'Disconnected.';
  RSLogEOL = '<EOL>';

implementation

end.
