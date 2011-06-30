{ ---------------------------------------------------------------------------- }
{ UCL Compression Algorithm for the TinyDB DataBase Engine
{                                   http://www.tinydb.com
{ ---------------------------------------------------------------------------- }

unit Compress_UCL;

{$I DI.inc}

interface

uses
  Classes,
  TinyDB;

type
  TCompressAlgo_UCL = class(TCompressAlgo)
  private
    FCompressionLevel: Integer;
  protected
    procedure SetLevel(Value: TCompressLevel); override;
    function GetLevel: TCompressLevel; override;
  public
    constructor Create(AOwner: TObject); override;
    procedure EncodeStream(Source, Dest: TMemoryStream; DataSize: Integer); override;
    procedure DecodeStream(Source, Dest: TMemoryStream; DataSize: Integer); override;
  end;

implementation

uses
  DIUclStreams;

constructor TCompressAlgo_UCL.Create(AOwner: TObject);
begin
  inherited;
  SetLevel(clNormal);
end;

{ ---------------------------------------------------------------------------- }

procedure TCompressAlgo_UCL.EncodeStream(Source, Dest: TMemoryStream; DataSize: Integer);
begin
  UclCompressStream(Source, Dest, FCompressionLevel);
end;

{ ---------------------------------------------------------------------------- }

procedure TCompressAlgo_UCL.DecodeStream(Source, Dest: TMemoryStream; DataSize: Integer);
begin
  UclDeCompressStream(Source, Dest);
end;

{ ---------------------------------------------------------------------------- }

procedure TCompressAlgo_UCL.SetLevel(Value: TCompressLevel);
begin
  case Value of
    clMaximum:
      FCompressionLevel := 10;
    clNormal:
      FCompressionLevel := 6;
    clFast:
      FCompressionLevel := 3;
  else // clSuperFast:
    FCompressionLevel := 1;
  end;
end;

{ ---------------------------------------------------------------------------- }

function TCompressAlgo_UCL.GetLevel: TCompressLevel;
begin
  case FCompressionLevel of
    10:
      Result := clMaximum;
    6:
      Result := clNormal;
    3:
      Result := clFast;
  else // 1:
    Result := clSuperFast;
  end;
end;

{ ---------------------------------------------------------------------------- }

initialization
  RegisterCompressClass(TCompressAlgo_UCL, 'UCL');

end.

