unit kolrbjfilter;
interface
{
       Unit: Delphi Implementation of a Filter designed by robert bristow-johnson
    purpose: All purpose audio filtering using nine different filtertypes
     Author: Thaddy de Koning
  Copyright:
    Remarks:
}
uses
  kol,kolmath,vstUtils;

type

PFxRbjFilter=^TFxRbjFilter;
TFxRbjFilter=object(Tobj)
private
	// filter coeffs
	b0a0,
  b1a0,
  b2a0,
  a1a0,
  a2a0:single;

	// in/out history
	ou1,
  ou2,
  in1,
  in2:single;
public
  procedure CalcFilterCoeffs(const atype:integer;const frequency:double;
    const sample_rate:Double;const q:double;const db_gain:double;q_is_bandwidth:Boolean);
  function Filter(In0:single):single;
end;

function NewFxRbjFilter:pFxRbjFilter;
implementation

function NewFxRbjFilter:pFxRbjFilter;
begin
  New(Result,Create);
  with result^do
  begin
  // reset filter coeffs
	 b0a0:=0;
   b1a0:=0;
   b2a0:=0;
   a1a0:=0;
   a2a0:=0.0;

  // reset in/out history
 	ou1:=0;
  ou2:=0;
  in1:=0;
  in2:=0.0;
  end;
end;

const
  kDenorm   = 1.0e-25;


function TFxRbjFilter.Filter(In0:single):single;
// filter
begin
    //if (PCardinal(@In0)^ and $7F800000) = 0 then In0:=0;
    result:= KDenorm+b0a0*in0 + b1a0*in1 + b2a0*in2 - a1a0*ou1 - a2a0*ou2;
		// push in/out buffers
		in2:=in1;
		in1:=in0;
		ou2:=ou1;
		ou1:=result;
end;

procedure TFxRbjFilter.CalcFilterCoeffs(const atype:integer;const frequency:double;
    const sample_rate:Double;const q:double;const db_gain:double;q_is_bandwidth:Boolean);
const
  temp_pi:double=3.1415926535897932384626433832795;
var
  alpha,
  a0,
  a1,
  a2,
  b0,
  b1,
  b2:double;
	A,
	omega,
	tsin,
	tcos:double;
  Beta:double;
begin
   if aType>8 then exit;
  // peaking, lowshelf and hishelf
		if atype>=6 then
		begin
			A		:=	power(10.0,(db_gain/40.0));
			omega	:=	2.0*temp_pi*frequency/sample_rate;
			tsin	:=	sin(omega);
			tcos	:=	cos(omega);

			if(q_is_bandwidth) then
			  alpha:=tsin*sinh(log10(2.0)/2.0*q*omega/tsin)
			else
			  alpha:=tsin/(2.0*q);

			beta	:=	sqrt(A)/q;

			// peaking
			if atype=6 then
			begin
				b0:=1.0+alpha*A;
				b1:=-2.0*tcos;
				b2:=1.0-alpha*A;
				a0:=1.0+alpha/A;
				a1:=-2.0*tcos;
				a2:=1.0-alpha/A;
			end;

			// lowshelf
			if atype=7 then
			begin
				b0:=(A*((A+1.0)-(A-1.0)*tcos+beta*tsin));
				b1:=(2.0*A*((A-1.0)-(A+1.0)*tcos));
				b2:=(A*((A+1.0)-(A-1.0)*tcos-beta*tsin));
				a0:=((A+1.0)+(A-1.0)*tcos+beta*tsin);
				a1:=(-2.0*((A-1.0)+(A+1.0)*tcos));
				a2:=((A+1.0)+(A-1.0)*tcos-beta*tsin);
			end;

			// hishelf
			if atype=8 then
			begin
				b0:=(A*((A+1.0)+(A-1.0)*tcos+beta*tsin));
				b1:=(-2.0*A*((A-1.0)+(A+1.0)*tcos));
				b2:=(A*((A+1.0)+(A-1.0)*tcos-beta*tsin));
				a0:=((A+1.0)-(A-1.0)*tcos+beta*tsin);
				a1:=(2.0*((A-1.0)-(A+1.0)*tcos));
				a2:=((A+1.0)-(A-1.0)*tcos-beta*tsin);
			end;
		end
		else
		begin
			// other filters
			omega	:=	2.0*temp_pi*frequency/sample_rate;
			tsin	:=	sin(omega);
			tcos	:=	cos(omega);

			if(q_is_bandwidth) then
			  alpha:=tsin*sinh(log10(2.0)/2.0*q*omega/tsin)
			else
			  alpha:=tsin/(2.0*q);


			// lowpass
			if atype=0 then
			begin
				b0:=(1.0-tcos)/2.0;
				b1:=1.0-tcos;
				b2:=(1.0-tcos)/2.0;
				a0:=1.0+alpha;
				a1:=-2.0*tcos;
				a2:=1.0-alpha;
			end;

			// hipass
			if atype=1 then
			begin
				b0:=(1.0+tcos)/2.0;
				b1:=-(1.0+tcos);
				b2:=(1.0+tcos)/2.0;
				a0:=1.0+ alpha;
				a1:=-2.0*tcos;
				a2:=1.0-alpha;
			end;

			// bandpass csg
			if atype=2 then
			begin
				b0:=tsin/2.0;
				b1:=0.0;
        b2:=-tsin/2;
				a0:=1.0+alpha;
				a1:=-2.0*tcos;
				a2:=1.0-alpha;
			end;

			// bandpass czpg
			if atype=3 then
			begin
				b0:=alpha;
				b1:=0.0;
				b2:=-alpha;
				a0:=1.0+alpha;
				a1:=-2.0*tcos;
				a2:=1.0-alpha;
			end;

			// notch
			if atype=4 then
			begin
				b0:=1.0;
				b1:=-2.0*tcos;
				b2:=1.0;
				a0:=1.0+alpha;
				a1:=-2.0*tcos;
				a2:=1.0-alpha;
			end;

			// allpass
			if atype=5 then
			begin
				b0:=1.0-alpha;
				b1:=-2.0*tcos;
				b2:=1.0+alpha;
				a0:=1.0+alpha;
				a1:=-2.0*tcos;
				a2:=1.0-alpha;
			end;
		end;

		// set filter coeffs
		b0a0:=(b0/a0);
		b1a0:=(b1/a0);
		b2a0:=(b2/a0);
		a1a0:=(a1/a0);
		a2a0:=(a2/a0);
end;

end.
