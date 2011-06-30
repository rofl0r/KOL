{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit Unit1;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, ShellAPI, KOL {$IFNDEF KOL_MCK}, mirror, Classes, mckCtrls, Controls{$ENDIF}, KOL_HHC_unit;
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;
{$ENDIF}

type
  {$IFDEF KOL_MCK}
  {$I MCKfakeClasses.inc}
  PForm1 = ^TForm1;
  TForm1 = object(TObj)
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TForm1 = class(TForm)
  {$ENDIF KOL_MCK}
    KOLProject1: TKOLProject;
    KOLForm1: TKOLForm;
    procedure KOLForm1FormCreate(Sender: PObj);
    procedure KOLForm1Paint(Sender: PControl; DC: HDC);
    procedure Button1Click(Sender: PObj);
    procedure Button2Click(Sender: PObj);
    procedure KOLForm1Destroy(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1 {$IFDEF KOL_MCK} : PForm1 {$ELSE} : TForm1 {$ENDIF} ;
  but1,but2:Pbitmapbutton;
  fon:PBitmap;
  fon_:HBRUSH;

{$IFDEF KOL_MCK}
procedure NewForm1( var Result: PForm1; AParent: PControl );
{$ENDIF}

implementation

{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}

{$IFDEF KOL_MCK}
{$I Unit1_1.inc}
{$ENDIF}

procedure TForm1.KOLForm1FormCreate(Sender: PObj);//здесь мы будем создавать кнопочки
var asd:PBitmap;// битмап для временного хранения картинки
begin
asd:=NewBitmap(0,0);//создаем чистый битмап
asd.LoadFromFile('bot_01.bmp');//загружаем туда картинку из файла
but1:=Newbitmapbuttonex(form,asd.Handle,0,0,clWhite);// создаем битмап буттон,
                  //передавая родителя, шендл нашего битмапа и позицию
but1.OnClick:=Button2Click;//назначаем событие от клика (какую прощедуру выполнить при клике на контроле)
//but1.DoubleBuffered:=true;//если воспользовать ся это й строкой кнопки перестанут моргать,
                            //но в местах пересечений (представте что контрол прямоугольный)
                            //один из контролов станет белым. МОЖЕТ КТО ПОДСКАЖЕТ КАК ИЗБАВИТЬСЯ от мерцания и недопустить подобную бавгу???????
asd.LoadFromFile('bot_02.bmp');
but2:=Newbitmapbuttonex(form,asd.Handle,0,0,clWhite);
but2.OnClick:=Button1Click;
//but2.DoubleBuffered:=true;
asd.Free;//уничтожаем временный битмап, он нам больше не нужен (он копируется в нутрь битмапа кнопочки)


fon:=NewBitmap(0,0);//создаем битмап для фонового рисунка
fon.LoadFromFile('fon.bmp');//грузим изображение  - битмап желательно С truecolor
                            //цветами иначе возможен баг при отрисовке из-за малого кол-ва цветов - возможно скоро исправлю
bit2bg_bit(form.Color,7,fon.Handle);// обрабатываем изображение чтобы оно сливалость с цветом формы, указав нужный цвет, контраст (чем меньше тем контрастней) и фендл нашего битмапа
fon_:=CreatePatternBrush(fon.Handle);//создаем кисть из этого битмапа >>>>> смотри form.onpaint (KOLForm1.paint)
but1.update_rgn;
end;

procedure TForm1.KOLForm1Paint(Sender: PControl; DC: HDC);
begin
FillRect( DC,form.ClientRect,fon_);// заполняем форму битмапами
end;

procedure TForm1.Button1Click(Sender: PObj);
begin
ShowMessage('На рамку нажали!!');
end;

procedure TForm1.Button2Click(Sender: PObj);
begin
ShowMessage('галочка нажата');
end;

procedure TForm1.KOLForm1Destroy(Sender: PObj);
begin // освобождаем занятые ресурсы
fon.Free;           // это можно было зделать (в большенстве случаев нужно!!!) после создание кисти
DeleteObject(fon_);// удаляем кисть (только когда ей больше не будут рисовать)
end;

end.




