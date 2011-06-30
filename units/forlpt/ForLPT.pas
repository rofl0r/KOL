(****************************************************************)
(* Модуль ForLPT (v1.1)                                         *)
(*   - работа с LPT-портом средствами ASM                       *)
(*                                                              *)
(* 10.12.2003                                                   *)
(* Rabotahoff Alexandr (RA)                                     *)
(* e-mail: Holden@bk.ru                                         *)
(****************************************************************)

{LPT1  (сам порт)
  2f 3f .  4f 8t 7t 6t 5t 4t 3t 2t 1t +   t-ToPort
   -  -  -  -  -  -  -  -  -  .  1f +     f-FromPort

  "-" - корпус
  "+" - +5B
  "." - не знаю

 Биты №: 87654321
}
Unit ForLPT;

interface
  Function BitFromLPT(Nom:byte):byte;
  {чтение одного бита с LPT-порта с ножки номер Nom
  (пиши тот номер, которым эта ножка обозначена на рисунке вверху
  [с пометкой f - что означает FromPort]) }
  procedure HalfByteFromLPT(var Value:Byte;isLeftHalf:boolean);
  {записует сразу 4 прочитаных бита в value. Если isLeftHalf=true
  то записывается в левую часть (в биты 8765).
  Иначе в биты 4321, причем занчение первой ноги
  помещается в бит1, и т.д.
              если isLeftHalf=false, то:
              xxxx0000-данные, если порт пуст
              ....4321-номера ног
              xxxx1111-данные, если порт полон
              x-зачение в этом бите не изменилось }

  Procedure BitToLPT(bit:byte;Nom:byte);
  {зипись одного бита в LPT-порт на ножку Nom
  (пиши тот номер, которым эта ножка обозначена на рисунке вверху
  [с пометкой t - что означает ToPort]) }
  Procedure ByteToLPT(data:byte);
  {зипись байта в LPT-порт так
  ноги:87654321  [это те ноги, которые с пометкой t]
  биты:87654321 - из Data}
  Procedure ClearLPT;
  {очистить порт - заносит на все ноги 0}

Implementation

function NomToByteForPort(Nom:byte):byte;
begin
  asm
     mov al,1
     mov cl,nom
     dec cl
     shl al,cl //логический сдвиг влево cl раз (может надо циклический - ROL ???)
     mov result,al
  end;
end;

Procedure ByteToLPT(data:byte);
//зипись байта в LPT-порт так
//ноги:87654321
//биты:87654321 - из Data
begin
  asm
     {Адрес порта LPT1}
     mov dx,378h
     {Вносим новое значение на вывод Nom}
     mov al,data
     out dx,al
  end;
end;


Procedure BitToLPT(bit:byte;Nom:byte);
var adr:byte;
begin
  asm
     {!Граници}
     mov al,nom
     cmp al,8
     jbe @m1 //if nom<=8 then goto m1
     mov al,8
     jmp @ex
@m1: cmp al,1
     jae @ex //if nom>=1 then goto ex
     mov al,1

@ex: mov bl,bit
     cmp bl,1
     jbe @go //if a<=1 then goto go
     mov bl,1 //a это bl

@go: {!преобразование номера ноги в адресс(битовая маска нужного бита) }
     mov ah,0
     mov cl,al //сохраняем значение al(nom) для цикла
     call NomToByteForPort //в функцию передается al, а результат функции передается туда же в al
     mov adr,al

     {!ставим бит на нужное место}
     dec cl //типа от 1 до nom-1
     shl bl,cl //логический сдвиг bl влево cl раз
               //a это bl


     {Инвертируем адрес для сохранения старого значения порта}
     mov cl,adr
     not cl
     {Адрес порта LPT1}
     mov dx,378h
     {Сохраняем старое значение порта}
     in al,dx
     and al,cl
     mov cl,al
     {Вносим новое значение на вывод Nom}
     or bl,cl
     mov al,bl
     out dx,al
  end;
end;

Procedure ClearLPT;
begin
  asm
    mov ax,0
    call ByteToLPT
  end;
end;

Function BitFromLPT(Nom:byte):byte;
var adr:byte;
begin
  asm
     {!Граници}
     mov al,nom
     cmp al,4
     jbe @m1 //if nom<=4 then goto m1
     mov al,4
     jmp @ex
@m1: cmp al,1
     jae @ex //if nom>=1 then goto ex
     mov al,1

@ex: {!преобразование номера ноги в адресс(битовая маска нужного бита) }
     mov ah,0
     add al,3
     mov cl,al //сохраняем значение al(nom) для цикла
     call NomToByteForPort //в функцию передается al, а результат функции передается туда же в al
     mov adr,al

     {!Чтение порта}
     mov dx,379h //Адрес порта LPT1
     in al,dx //читаем значение порта
     and al, adr //выбираем нужный бит (все ненужные становятся=0)
//   в al хранятся прочитанные с порта данные

     {!берем нужный бит}
     dec cl //типа от 1 до nom-1
     shr al,cl //логический сдвиг вправо cl раз
     mov result,al
  end;
end;

procedure HalfByteFromLPT(var Value:Byte;isLeftHalf:boolean);
var temp:byte;
begin
 {Биты №: 87654321 }
 temp:=value;
  asm
     {!Чтение порта}
     mov dx,379h //Адрес порта LPT1
     in al,dx //читаем значение порта
              //10000111-отак-данные, если порт пуст
              //.4321...-намера ног
              //11111111-отак-данные, если порт полон

     shl al,1 //надо т.к. 8-й бит то 1 то 0 (он ненужен)
     shr al,4 //сдвигаем на 4 вправо, т.к. биты 321(по состоянию до сдвига влево) =1
              //теперь имеем:
              //00000000-данные, если порт пуст
              //....4321-номера ног
              //00001111-данные, если порт полон

      mov dl,0
      cmp isLeftHalf,dl
      je @ex //if isLeftHalf=false then goto ex
      shl al,4 //сдвигаем данные влево
 @ex: or temp,al
  end;
 value:=temp;
end;

end.
