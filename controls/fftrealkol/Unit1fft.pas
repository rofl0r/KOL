unit Unit1fft;
//********************************************************************
//  Created by KOL project Expert Version 2.00 on:25-2-2003 13:02:08
//********************************************************************


interface
uses
  Windows, Messages,Kol,fftrealkol,kolmath;

//var

type

PForm1=^TForm1;
TForm1=object(Tobj)
  Form:pControl;
  Memo:pControl;
  Panel:pControl;
  Button:pControl;
private
   nbr_points  : longint;
   x, f        : pflt_array;
   fft         : pFFTReal;
   PI          : double;
   areal, img  : double;
   f_abs       : double;
   buffer_size : longint;
   nbr_tests   : longint;
   time0, time1, time2 : int64;
   timereso    : int64;
   offset      : longint;
   t0, t1      : double;
   nbr_s_chn   : longint;
   tempp1, tempp2 : pflt_array;

public
   // Add your eventhandlers here, example:
  procedure Click(sender:pObj);
end;


procedure NewForm1( var Result: PForm1; AParent: PControl );

var
  Form1:pForm1;

implementation

procedure Writeln(S:String = '');
begin
 form1.Memo.Add(S+#13#10);
end;

procedure Tform1.Click(sender:pObj);
var i,temp:integer;

begin
memo.Clear;
Randomize;
  (*______________________________________________
   *
   * Exactness test
   *______________________________________________
   *)


  nbr_points := 32;       // Power of 2
  GetMem(x, nbr_points * sizeof_flt);
  GetMem(f, nbr_points * sizeof_flt);
  fft := NewFFTReal(nbr_points);    // FFT object initialized here

  // Test signal
  PI := ArcTan(1) * 4;
  for i := 0 to nbr_points-1 do
  begin
    x^[i] := -1 + sin (3*2*PI*i/nbr_points)
                + cos (5*2*PI*i/nbr_points) * 2
                - sin (7*2*PI*i/nbr_points) * 3
                + cos (8*2*PI*i/nbr_points) * 5;
  end;

  // Compute FFT and IFFT
  fft.do_fft(f, x);
  fft.do_ifft(f, x);
  fft.rescale(x);

  // Display the result
  //WriteLn('FFT:');

  memo.lvItemadd('Accuracy test:');
  Memo.LVItemAdd('FFT');

  Memo.Invalidate;
  form.ProcessMessages;

  for i := 0 to nbr_points div 2 do
  begin
    areal := f^[i];
    if (i > 0) and (i < nbr_points div 2) then
      img := f^[i + nbr_points div 2]
    else
      img := 0;

    f_abs := Sqrt(areal * areal + img * img);
    Memo.LvAdd(int2str(i),0,[],0,0,0);
    Memo.LvItems[Memo.Count-1,1]:=Extended2str(aReal);
    Memo.LvItems[Memo.Count-1,2]:=Extended2str(img);
    Memo.LvItems[Memo.Count-1,3]:=Extended2str(f_abs);

  end;
  Memo.Invalidate;
  form.ProcessMessages;
  Memo.LVItemAdd('');
  Memo.LVItemAdd('IFFT');

  for i := 0 to nbr_points-1 do
   begin
    Memo.LvAdd(int2str(i),0,[],0,0,0);
    temp:=i;
    Memo.LvItems[Memo.Count-1,1]:=Extended2str(X^[temp]);
   end;

  FreeMem(x);
  FreeMem(f);
  fft.Free;


  (*______________________________________________
   *
   * Speed test
   *______________________________________________
   *)

  Memo.LVItemAdd('');
  Memo.LVItemAdd('Speed test:');

  nbr_points := 256;	          // Power of 2
  buffer_size := 256*nbr_points;  // Number of flt_t (float or double)
  nbr_tests := 10000;

  assert(nbr_points <= buffer_size);
  GetMem(x, buffer_size * sizeof_flt);
  GetMem(f, buffer_size * sizeof_flt);
  fft := NewFFTReal(nbr_points);					// FFT object initialized here

  // Test signal: noise
  for i := 0 to nbr_points-1 do
    x^[i] := Random($7fff) - ($7fff shr 1);

  // timing
  QueryPerformanceFrequency(timereso);
  QueryPerformanceCounter(time0);

  for i := 0 to nbr_tests-1 do
  begin
    offset := (i * nbr_points) and (buffer_size - 1);
    tempp1 := f;
    inc(tempp1, offset);
    tempp2 := x;
    inc(tempp2, offset);
    fft.do_fft(tempp1, tempp2);
  end;

  QueryPerformanceCounter(time1);

  for i := 0 to nbr_tests-1 do
  begin
    offset := (i * nbr_points) and (buffer_size - 1);
    tempp1 := f;
    inc(tempp1, offset);
    tempp2 := x;
    inc(tempp2, offset);
    fft.do_ifft(tempp1, tempp2);
    fft.rescale(x);
  end;

  QueryPerformanceCounter(time2);

  t0 := ((time1-time0) / timereso) / nbr_tests;
  t1 := ((time2-time1) / timereso) / nbr_tests;
  Memo.LVItemAdd('IFFT');

  Memo.LvAdd(int2str(nbr_points)+' FFT:',0,[],0,0,0);
  Memo.LvItems[Memo.Count-1,1]:=Num2Bytes(t0 *1000000)+ ' uSec';
  Memo.LvAdd(int2str(nbr_points)+' IFFT + scaling:',0,[],0,0,0);
  Memo.LvItems[Memo.Count-1,1]:=Num2Bytes(t1 *1000000)+' uSec';

  Memo.Invalidate;
  form.ProcessMessages;

  nbr_s_chn := Floor(nbr_points / ((t0 + t1) * 44100 * 2));
  Memo.LvAdd('PeakPerformance: FFT+IFFT on:'+int2str(nbr_s_chn),0,[],0,0,0);
  Memo.LvItems[Memo.Count-1,1]:='mono channels at 44.1 KHz (with overlapping)';
  FreeMem(x);
  FreeMem(f);
  fft.Free;
end;

procedure NewForm1( var Result: PForm1; AParent: PControl );
var i:integer;
begin
  New(Result,Create);
  with Result^ do
  begin
    Form:= NewForm(AParent,'FF Transformation Test').SetSize(800,600).centeronparent.Tabulate;
    Applet:=Form;
    Form.Add2AutoFree(Result);
    Panel:=NewPanel(Form,esRaised).setalign(caBottom);
    Button:=NewButton(Panel,'Start').ResizeParent;
    Button.OnClick:=click;
    Memo:=NewListView(form,lvsdetail,[lvogridlines],0,0,0).SetAlign(caClient);
    for i:=0 to 3 do
     memo.LVColAdd('',taLeft,-1);
    with memo^ do
      for i:=0 to LvColcount-1 do
        lvcolwidth[i]:=(Clientwidth div LvColcount) -3;
  end;
end;



end.

