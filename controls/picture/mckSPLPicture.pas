//---------------------------------------------------------------//
//                                                               //
//                        SPLPicture                             //
//                                                               //
//     Visual KOL control for displaying and storing bitmaps.    //
//                          Mirror                               //
//                           ----                                //
//                                                               //
//        author:     Alexander Pravdin aka SPeller              //
//        version:    1.0                                        //
//        date:       10-dec-2002                                //
//        e-mail:     speller@mail.primorye.ru                   //
//        www:        http://kol.mastak.ru                       //
//                                                               //
//---------------------------------------------------------------//

unit mckSPLPicture;

interface

uses
  Windows, Classes, mirror, mckCtrls, KOL, Graphics, KOLSPLPicture;

type

  TKOLSPLPicture = class( TKOLPanel )
  private
    fBitmap: TBitmap;
    procedure SetBitmap( const NV: TBitmap );
  public
    function TypeName: string; override;
    function AdditionalUnits: string; override;
    function SetupParams( const AName, AParent: string ): string; override;
    procedure SetupFirst( SL: TstringList; const AName, AParent, Prefix: string ); override;
    procedure SetupLast( SL: TstringList; const AName, AParent, Prefix: string ); override;
    procedure SetupConstruct( SL: TstringList; const AName, AParent, Prefix: string ); override;
    procedure Paint; override;
    constructor Create( Owner: TComponent ); override;
    destructor Destroy; override;
  published
    property Bitmap: TBitmap read fBitmap write SetBitmap;
  end;

procedure Register;

//{$R *.dcr}

implementation
uses mckObjs;

procedure Register;
begin
  RegisterComponents('KOL Win32', [TKOLSPLPicture]);
end;

function TKOLSPLPicture.AdditionalUnits;
begin
  Result := ', KOLSPLPicture';
end;

function TKOLSPLPicture.TypeName: string;
begin
  Result := 'TKOLSPLPicture';
end;

function TKOLSPLPicture.SetupParams(const AName, AParent: string): string;
begin
  Result := AParent;
end;

procedure TKOLSPLPicture.SetupConstruct( SL: TstringList; const AName, AParent, Prefix: string );
const EdgeStyles: array[TEdgeStyle] of string = ('esRaised', 'esLowered', 'esNone' );
var S: string;
begin
  S := GenerateTransparentInits;
  SL.Add( Prefix + AName + ' := PSPLPicture( NewSPLPicture( ' + SetupParams( AName, AParent )
    + ', ' + EdgeStyles[ EdgeStyle ] + ' )' + S +' );' );
end;

procedure TKOLSPLPicture.SetupFirst( SL: TstringList; const AName, AParent, Prefix: string );
var tm: Boolean;
const
  EdgeStyles: array[TEdgeStyle] of string = ('esRaised', 'esLowered', 'esNone' );
begin
  if not fBitmap.Empty then begin
      GenerateBitmapResource( fBitmap,
        ParentKOLForm.formName + '_' + Name + 'BMP',
        UPPERCASE( ParentKOLForm.formName + '_' + Name ),
        tm );
      SL.Add( '{$R ' + ParentKOLForm.formName + '_' + Name + '.RES}' );
  end;
  inherited;
end;

procedure TKOLSPLPicture.SetupLast( SL: TstringList; const AName, AParent, Prefix: string );
begin
  inherited;
  if not fBitmap.Empty then
    SL.Add( Prefix + AName + '.Bitmap.LoadFromResourceName( hInstance, ''' + UPPERCASE( ParentKOLForm.formName + '_' + Name + 'BMP' ) + ''' );' );
end;

constructor TKOLSPLPicture.Create;
begin
  inherited;
  fBitmap := TBitmap.Create;
end;

destructor TKOLSPLPicture.Destroy;
begin
  fBitmap.Free;
  inherited;
end;

procedure TKOLSPLPicture.SetBitmap( const NV: TBitmap );
begin
  fBitmap.Assign( NV );
  Paint;
end;

procedure TKOLSPLPicture.Paint;
var r: TRect;
begin
  inherited;
  if not fBitmap.Empty then begin
      r := ClientRect;
      case Edgestyle of
      esLowered:
        begin
            r.Left := 1;
            r.Top := 1;
            Dec( r.Bottom, 2 );
            Dec( r.Right, 2 );
        end;
      esRaised:
        begin
            r.Left := 2;
            r.Top := 2;
            Dec( r.Bottom, 4 );
            Dec( r.Right, 4 );
        end;
      end;
      if fBitmap.Width < ( r.Right - r.Left ) then r.Right := r.Left + fBitmap.Width;
      if fBitmap.Height < ( r.Bottom - r.Top ) then r.Bottom := r.Top + fBitmap.Height;
      BitBlt( Canvas.Handle, r.Left, r.Top, r.Right - r.Left,
        r.Bottom - r.Top, fBitmap.Canvas.Handle, 0, 0, SRCCOPY );
  end;
end;


end.
