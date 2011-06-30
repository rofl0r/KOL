// 22-nov-2002
unit IdMIMETypes;

interface

const
  MIMESplit = '/';
  MIMEXVal = 'x-';

  MIMETypeApplication = 'application' + MIMESplit;
  MIMETypeAudio = 'audio' + MIMESplit;
  MIMETypeImage = 'image' + MIMESplit;
  MIMETypeMessage = 'message' + MIMESplit;
  MIMETypeMultipart = 'multipart' + MIMESplit;
  MIMETypeText = 'text' + MIMESplit;
  MIMETypeVideo = 'video' + MIMESplit;
  MaxMIMEType = 6;

     // MIME Sub-Types
  MIMESubOctetStream = 'octet-stream';
  MIMESubMacBinHex40 = 'mac-binhex40';
  MaxMIMESubTypes = 1;

     // BinToASCII
  MIMEEncBase64 = 'base64'; // Correct MIME type
  MIMEEncUUEncode = MIMEXVal + 'uu';
  MIMEEncXXEncode = MIMEXVal + 'xx';
  MaxMIMEBinToASCIIType = 2;

     // Message Digests
  MIMEEncRSAMD2 = MIMEXVal + 'rsa-md2';
  MIMEEncRSAMD4 = MIMEXVal + 'rsa-md4';
  MIMEEncRSAMD5 = MIMEXVal + 'rsa-md5';
  MIMEEncNISTSHA = MIMEXVal + 'nist-sha';
  MaxMIMEMessageDigestType = 3;

     // Compression Types
  MIMEEncRLECompress = MIMEXVal + 'rle-compress';
  MaxMIMECompressType = 0;

  MaxMIMEEncType = MaxMIMEBinToASCIIType + MaxMIMEMessageDigestType + 1 +
    MaxMIMECompressType + 1;

  MIMEFullApplicationOctetStream = MIMETypeApplication + MIMESubOctetStream;

function ReturnMIMEType(var MediaType, EncType: string): Boolean;

var
  MIMEMediaType: array[0..MaxMIMEType] of string;

implementation

uses KOL, 
  IdGlobal;

function ReturnMIMEType;
var
  MType, SType, EType: string;
  i: LongWord;
begin
  i := IndyPos(MIMESplit, MediaType);
  MType := Copy(MediaType, 1, i);
  SType := Copy(MediaType, i + 1, length(MediaType));
  EType := EncType;

  i := PosInStrArray(LowerCase(MType), MIMEMediaType);
  case i of
    0:
      begin
         // MIMETypeApplication - application/
      end;
    1:
      begin
         // MIMETypeAudio - audio/
      end;
    2:
      begin
         // MIMETypeImage - image/
      end;
    3:
      begin
         // MIMETypeMessage - message/
      end;
    4:
      begin
         // MIMETypeMultipart - multipart/
      end;
    5:
      begin
         // MIMETypeText - text/
      end;
    6:
      begin
         // MIMETypeVideo - video/
      end;
  else
    begin
      if LowerCase(Copy(MType, 1, 2)) = MIMEXVal then
      begin
        i := PosInStrArray(LowerCase(Copy(MType, 3, length(MType))),
          MIMEMediaType);
        case i of
          0:
            begin
              MType := MIMETypeApplication;
            end;
          1:
            begin
              MType := MIMETypeAudio;
            end;
          2:
            begin
              MType := MIMETypeImage;
            end;
          3:
            begin
              MType := MIMETypeMessage;
            end;
          4:
            begin
              MType := MIMETypeMultipart;
            end;
          5:
            begin
              MType := MIMETypeText;
            end;
          6:
            begin
              MType := MIMETypeVideo;
            end;
        end;
      end;
    end;
  end;

  result := false;
end;

initialization
  MIMEMediaType[0] := MIMETypeApplication;
  MIMEMediaType[1] := MIMETypeAudio;
  MIMEMediaType[2] := MIMETypeImage;
  MIMEMediaType[3] := MIMETypeMessage;
  MIMEMediaType[4] := MIMETypeMultipart;
  MIMEMediaType[5] := MIMETypeText;
  MIMEMediaType[6] := MIMETypeVideo;
end.
