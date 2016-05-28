unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, ExtCtrls, ComCtrls, Menus;
type
  TForm1 = class(TForm)
    Panel1: TPanel;
    P: TPaintBox;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    GroupBox1: TGroupBox;
    StringGrid2: TStringGrid;
    Button2: TButton;
    Button3: TButton;
    Button5: TButton;
    Button1: TButton;
    Edit1: TEdit;
    StringGrid1: TStringGrid;
    Button4: TButton;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    CheckBox2: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    CheckBox5: TCheckBox;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    PopupMenu2: TPopupMenu;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    Label13: TLabel;
    CheckBox6: TCheckBox;
    Label7: TLabel;
    RadioGroup1: TRadioGroup;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure StringGrid2Exit(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure CheckBox3Exit(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure CheckBox1Exit(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure StringGrid1Enter(Sender: TObject);
    procedure N10Click(Sender: TObject);
  private
  public
  end;

const k_number = 100; { максимальное число дуг (работ) }
 ny = 8;  {число элементов массива для расстановки ординат}
var
  Form1: TForm1;
   i,j,h{step}, k {edges} : word;
  A, MX, MY, MSY, MSX : INTEGER;
                  ST : STRING[4];
 C : array[1..4,1..k_number] of Single; { массив координат начала и конца дуг (работ) }
 L{length} : Single;
y : array[1..ny] of byte; //для размещения ординат

implementation

uses Unit2;

{$R *.DFM}

Procedure Line(X,Y, X1, Y1 : integer);
begin
With Form1.P.Canvas do BEGIN
         Moveto(X,Y);      // - переместить курсор в точку X, Y
         LineTo(X1, Y1);   // - провести из нее линию в точку X1, Y1
                               END;

end;


procedure Arrow(x1,y1,x2,y2,h:integer);
var dx,dy : integer; ym,xm,yn,xn,yk,xk : real;

Procedure notHArrow(x1,y1,x2,y2,h:integer);
label L;
begin
if (x1=x2) and (y1=y2) then goto L;
Form1.P.Canvas.MoveTo(x1,y1);
Form1.P.Canvas.LineTo(x2,y2);
if x1 < x2
 then if y1 < y2
       then begin
             yk := y2 - cos(arctan((x2-x1)/(y2-y1)))*4*h;
             xk := x2 - sin(arctan((x2-x1)/(y2-y1)))*4*h;
            end
       else begin
             yk := y2 + cos(arctan((x2-x1)/(y1-y2)))*4*h;
             xk := x2 - sin(arctan((x2-x1)/(y1-y2)))*4*h;
            end
 else if y1 < y2
       then begin
             yk := y2 - cos(arctan((x1-x2)/(y2-y1)))*4*h;
             xk := x2 - sin(arctan((x2-x1)/(y2-y1)))*4*h;
            end
       else begin
             yk := y2 + cos(arctan((x1-x2)/(y1-y2)))*4*h;
             xk := x2 + sin(arctan((x1-x2)/(y1-y2)))*4*h;
            end;

ym := yk + sin(arctan((x2-x1)/(y2-y1)))*h;
xm := xk - cos(arctan((x2-x1)/(y2-y1)))*h;
yn := yk - sin(arctan((x2-x1)/(y2-y1)))*h;
xn := xk + cos(arctan((x2-x1)/(y2-y1)))*h;
dx := x2-x1; dy := y2-y1;
Form1.P.Canvas.LineTo(round(xm),round(ym));
Form1.P.Canvas.MoveTo(x2,y2);
Form1.P.Canvas.LineTo(round(xn),round(yn)); L:
Form1.P.Canvas.MoveTo(x2,y2);
end;

procedure HArrow(y,x1,x2,h:integer);
begin
Form1.P.Canvas.MoveTo(x1,y);
Form1.P.Canvas.LineTo(x2,y);
if x1 > x2
 then
  begin
   Form1.P.Canvas.LineTo(x2+h*4,y-h);
   Form1.P.Canvas.MoveTo(x2,y);
   Form1.P.Canvas.LineTo(x2+h*4,y+h);
  end
 else
  begin
   Form1.P.Canvas.LineTo(x2-h*4,y-h);
   Form1.P.Canvas.MoveTo(x2,y);
   Form1.P.Canvas.LineTo(x2-h*4,y+h);
  end;
Form1.P.Canvas.LineTo(x2,y);
end;

begin
if y1 = y2 then HArrow(y1,x1,x2,h)
           else notHArrow(x1,y1,x2,y2,h);
end;


// Graph loading
procedure TForm1.Button1Click(Sender: TObject);
var  FName : string;  F : TextFile; a : Single;
begin
ForceCurrentDirectory := True;
CheckBox1.Enabled := False;
CheckBox1.Checked := False;
If OpenDialog1.Execute
 then begin
       Fname := OpenDialog1.FileName;
       AssignFile( F, FName );
       Reset(F);
       readln(F, a);
       k := round(a);
       Edit1.Text := IntToStr(k);
       StringGrid1.ColCount := k+1;
       StringGrid1.RowCount := k+3;
       with StringGrid1 do
         for i := 1 to k do
          begin
           cells[i,0] := 'a'+IntToStr(i);
           cells[0,i+1] := 'a'+IntToStr(i);
           cells[0,k+2] := 'T';
           cells[0,1] := 'a0';
          end;
       for i := 1 to k+2 do {rows}
        begin
         for j := 1 to k do
          begin
           read(F, a);
           StringGrid1.Cells[j,i] := FloatToStr(a);
          end;
        end;
      end;
Button3.Enabled := True;
N7.Enabled := True;
end;


procedure TForm1.Edit1Exit(Sender: TObject);
begin
k := StrToInt(Edit1.text);
StringGrid1.ColCount := k+1;
StringGrid1.RowCount := k+3;
with StringGrid1 do
 for i := 1 to k do
  begin
   cells[i,0] := 'a'+IntToStr(i);
   cells[0,i+1] := 'a'+IntToStr(i);
   cells[0,k+2] := 'T';
   cells[k+1,0] := 'a_k';
   cells[0,1] := 'a0';
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
P.Refresh;
end;

// Вычисление и рисование
procedure TForm1.Button3Click(Sender: TObject);
label L1;
const
yy1 : array[1..ny] of word = (3,7,2,8,1,9,4,6);
yy2 : array[1..ny] of word = (7,2,4,6,1,8,2,9);
yy3 : array[1..ny] of word = (4,7,3,9,1,6,3,8);
yy4 : array[1..ny] of word = (6,2,8,1,6,9,2,7);
var ii, ll, yy{счетчик} : word;
    CP : array[1..k_number] of boolean; {Critical Path - массив дуг критического пути}
var X, B{рабочая переменная}, step : single; iii{код ошибки} : integer;
 x1,x2,y1,y2, x_int,y_int{промежуточные координаты для определения начала пунктирной линии} : word;
const ind = 10;
begin
CheckBox1.Enabled := True;
if CheckBox1.Checked = True then goto L1;
if RadioButton1.Checked = True then for i := 1 to ny do y[i]:=yy1[i];
if RadioButton2.Checked = True then for i := 1 to ny do y[i]:=yy2[i];
if RadioButton3.Checked = True then for i := 1 to ny do y[i]:=yy3[i];
if RadioButton4.Checked = True then for i := 1 to ny do y[i]:=yy4[i];
L := 0; yy := 1;
for i := 1 to k_number do C[1,i] := 0;
for i := 1 to k_number do C[2,i] := 0;
with StringGrid1 do
for ii := 1 to 2 do
for i := 1 to k+1 do {rows}
 begin
  if (ii=2) and (i=1) then yy := 1;
  for j:= 1 to k do {cols}
   if cells[j,i] = '1'
    then begin
          if i = 1
           then
            begin
             C[1,j] := 0;  C[3,j] := 5; C[4,j] := y[yy]; //начальные дуги
             if yy = ny then yy := 1 else yy := yy + 1;
             val(cells[j,k+2],C[2,j],iii);
             if L < C[2,j] then L := C[2,j];  {определение длины пути}
            end
           else
            begin
             if C[1,j] < C[2,i-1] then begin
                                        C[1,j] := C[2,i-1];
                                        C[3,j] := C[4,i-1];
                                       end;
             val(cells[j,k+2],B,iii);
             C[2,j] := C[1,j] + B;
             if L < C[2,j] then L := C[2,j];  {определение длины пути}
             if CheckBox1.Checked = false then {при выборе случайного определения ординат их выравнивания не происходит}
              if abs(C[3,j]-y[yy]) <= 4
                then C[4,j] := y[yy]
                else if C[3,j] = 9
                    then C[4,j] := 8
                    else C[4,j] := C[3,j] + 1;
             if yy = ny then yy := 1 else yy := yy + 1;
            end;
         end;
 end;

L1:
for i := 1 to k do {состыковка концов опорных дуг (в случае, если их было несколько)}
 for j := 1 to k do
  if StringGrid1.Cells[j,i+1] = '1'
   then begin
         C[2,i] := C[1,j];
         C[4,i] := C[3,j];
        end;
if CheckBox1.Checked = True then
 for i := 1 to k do {состыковка начал исходящих дуг (в случае, если их было несколько)}
  for j := 1 to k do
  if StringGrid1.Cells[j,i+1] = '1'
   then begin
          C[1,j] := C[2,i];
          C[3,j] := C[4,i];
        end;

for i := 2 to k+1 do  // все заканчивается в одной точке
  begin       //если какая-либо работа не является опорной, значит она уходит в конец
   B := 0;
   for j := 1 to k do B := B + StrToInt(StringGrid1.Cells[j,i]);
   if B = 0 then begin C[4,i-1] := 5; C[2,i-1] := L; end;
  end;
for j := 1 to k do if StringGrid1.Cells[j,1] = '1' then C[3,j] := 5; //все начинается в одной точке
StringGrid2.ColCount := k;
for i := 1 to k do  //Отображение координат дуг в таблице
 begin
  StringGrid2.Cells[i-1,0] := 'a'+IntToStr(i);
  StringGrid2.Cells[i-1,1] := FloatToStr( C[1,i] ) ;
  val(StringGrid1.Cells[i,k+2],B,iii);
  StringGrid2.Cells[i-1,2] := FloatToStr( C[1,i] + B ) ;
  StringGrid2.Cells[i-1,3] := FloatToStr( C[3,i] ) ;
  StringGrid2.Cells[i-1,4] := FloatToStr( C[4,i] ) ;
 end;

yy := 0;  // теперь эта переменная нужна для суммирования
for i := 1 to k do //опознание дуг критического пути
 begin    // все дуги должны делиться на "помеченные" дуги (CP[i]=False) и "непомеченные" дуги - дуги критического пути
  val(StringGrid1.Cells[i,k+2], B, iii);
  if (C[1,i] + B < C[2,i] + 0.000001) and (C[1,i] + B > C[2,i] - 0.000001) // это то же, что и if C[1,i] + B = C[2,i], но это равенство иногда строго не выполняется из-за специфических особенностей чисел с плавающей точкой
   then CP[i] := True else CP[i] := False;
 end;
for y1 := 1 to k div 4 do //следует пометить все дуги не пропустив ни одной
for i := 1 to k do //cols
 begin
  if CP[i] = False // берем "помеченную" дугу
   then
    begin
     yy := 0;
     for j := 1 to k do  //rows
      begin
       if CP[j] = True // будем иметь дело только с непомеченными дугами
        then
         begin
          if StringGrid1.Cells[i,j+1] = '1' //если "помеченную" дуга опирается на "непомеченную", то эту опорную дугу, возможно, также следует пометить
           then
            begin
             yy := yy + StrToInt( StringGrid1.Cells[i,j+1] ); // если только у нее нет других исходных дуг
             ii := j;
             for ll := 1 to k do
              if (StringGrid1.Cells[ll,j+1] = '1') and (ll<>i) and (CP[ll]=True) //которые "непомеченные"
               then yy := 2;
            end;
         end;
      end;
     if yy = 1 then CP[ii] := False; //мы пометим "непомеченную" дугу, которая является опорной для "помеченной" только если из нее не исходит других "непомеченных" дуг
    end;
 end;

//Drawing
if CheckBox2.Checked = True then P.Refresh;
    MX := P.Width;  MY := P.Height;
if L <= 2.5 then step := 0.1
  else if L < 10 then step := 0.5
   else if L < 35 then step := 1
    else if L < 65 then step := 2
      else step := 5;
With P.Canvas do
 BEGIN
   Pen.Width := 1;
   Pen.Color := clGray;
   {Рисование осей -------}
    Arrow (ind, MY-ind*2, MX-ind, MY-ind*2, 5);      { -- X -- }
    Line (ind, ind, ind, MY-ind*2);   { -- Y -- }
    {Рисование стрелок на осях  }
{ Надписи по осям X и Y ----}
   Brush.Color := Panel1.Color; // - цвет фона под текстом
   Font.Color := clMenuText;      // - цвет текста
   Font.Size := 14;
//   TextOut (MX03 - 20, MY005, ' Y ');
   TextOut (MX - round(ind*2.5),   round(MY*0.9-ind*1.7), ' T ');

// Разметка оси X
   Font.Size := 10;
   MSX := ROUND( (MX*0.9) / L*0.98 );       // - Масштаб по оси X - глобален
   MSY := ROUND( MY / 10 );       // - Масштаб по оси Y - глобален
   X := 0;
   While  X <= L do
      Begin
       if L >= 10 then STR(X : 4 : 0, ST)         // - строка для оцифровки X
                  else STR(X : 4 : 1, ST);
       A := Round( (MSX * X)  );     // -  абсцисса в пикселях
       Line (A+ind, MY-round(ind*2.5), A+ind, MY-round(ind*1.5));  // - черточка по оси X
       Brush.Color := Panel1.Color;
       Font.Color := clRed;
       TextOut (A-2, MY - round(ind*1.3), ST);  // - оцифровка
       X := X + step;                  // - шаг по X в единицах
      End;
   for i := 1 to 9 do
      Begin
       A := Round( (MSY * i)  );     // -  абсцисса в пикселях
       Line (ind-4, MY-A-ind, ind, MY-A-ind);  // - черточка по оси Y
       Brush.Color := Panel1.Color;
       Font.Color := clRed;
      End;
  if X-1 < L then begin
                 STR(L : 4 : 2, ST);
                 A := Round( (MSX * L)  );     // -  абсцисса в пикселях
                 Line (A+ind, MY-round(ind*2.5), A+ind, MY-round(ind*1.5));  // - черточка по оси X
                 Font.Color := clRed;
                 TextOut (A, MY - round(ind*1.3), ST);  // - оцифровка
                end;
  for i := 1 to k do
   begin
    x1 := round(MSX*C[1,i]) + ind;
    x2 := round(MSX*C[2,i]) + ind;
    y1 := round(MY - ind - MSY*C[3,i]);
    y2 := round(MY - ind - MSY*C[4,i]);
    val(StringGrid1.Cells[i,k+2], B, iii);
    x_int := round(MSX*C[1,i]+MSX*B) + ind;
    y_int := y1 + round( (x_int-x1)*(y2-y1)/(x2-x1) );
    if CheckBox3.Checked = true
      then begin
            if L >= 100 then STR(C[1,i]+B : 4 : 0, ST)         // - строка для оцифровки X
                        else STR(C[1,i]+B : 4 : 1, ST);
             Pen.Width := 1;
             Pen.Style := psDot;
             Pen.Color := clSilver; //рисование вертикальной линии
             Line(x_int, MY-ind*2 , x_int, ind);
             Font.Size := 10;
             if CheckBox4.Checked = True then
                TextOut (x_int-2, MY - round(ind*1.3), ST);  // - оцифровка
             Pen.Style := psSolid;
           end;
    if CheckBox6.Checked = True //критический путь - жирной динией
     then if CP[i] = True then Pen.Width := 2 else Pen.Width := 1 else Pen.Width := 1;
    Pen.Color := clBlack;
    Arrow(x1, y1, x_int, y_int, 3); {дуга}
    Pen.Color := clRed;
    Pen.Style := psDash;
    LineTo(x2, y2);                 {резерв}
    Pen.Style := psSolid;
    Font.Color := clGray;
    ST := IntToStr(i);
    Font.Size := 9;
    TextOut ( round((x1+x2)/2)-5, round((y1+y2)/2)+3, 'a'+ST); // - номер работы в ее середине
//    Sleep(500);
   end;
 END; { With}

end;

//Здесь запускается генератор случайных чисел
procedure TForm1.Button4Click(Sender: TObject);
var  iii{код ошибки} : integer;
begin
for i := 1 to k do StringGrid2.Cells[i,3] := IntToStr( random(9)+1 );
for i := 1 to k do  val(StringGrid2.Cells[i-1,3], C[3,i], iii);
end;


procedure TForm1.StringGrid2Exit(Sender: TObject);
var iii{код ошибки} : integer;
begin
for i := 1 to k do  val(StringGrid2.Cells[i-1,3], C[3,i], iii);
end;

//Saving
procedure TForm1.Button5Click(Sender: TObject);
var FName : string; F : TextFile; B : String;
begin
ForceCurrentDirectory := True;
If SaveDialog1.Execute
 then begin
       Fname := SaveDialog1.FileName;
       AssignFile( F, FName );
       Rewrite(F);
       writeln(F, IntToStr(StringGrid1.ColCount - 1));
       for i := 1 to k+1 do {rows}
        begin
         for j := 1 to k do
          if StringGrid1.Cells[j,i] = '1' then write(F, '1 ' )
                                          else write(F, '0 ' ); //если не 1, то - 0
          writeln(F);
        end;
       for j := 1 to k do write(F, StringGrid1.Cells[j,k+2]+' ' ); // Time

       CloseFile(F);
      end;

end;

procedure TForm1.CheckBox3Exit(Sender: TObject);
begin
if CheckBox3.Checked = False then CheckBox4.Checked := False;
if CheckBox3.Checked = False then CheckBox4.Enabled := False
                             else CheckBox4.Enabled := True;
end;

procedure TForm1.CheckBox5Click(Sender: TObject);
begin
if CheckBox3.Checked = True
 then begin
       StringGrid1.ShowHint := True;
       StringGrid2.ShowHint := True;
       Button3.ShowHint := True;
       Button4.ShowHint := True;
       CheckBox1.ShowHint := True;
       Label10.ShowHint := True;
       Label9.ShowHint := True;
       RadioButton1.ShowHint := True;
       RadioButton4.ShowHint := True;
       RadioButton2.ShowHint := True;
       RadioButton3.ShowHint := True;
       RadioGroup1.ShowHint := True;
      end
 else begin
       StringGrid1.ShowHint := False;
       StringGrid2.ShowHint := False;
       Button3.ShowHint := False;
       Button4.ShowHint := False;
       CheckBox1.ShowHint := False;
       Label10.ShowHint := False;
       Label9.ShowHint := False;
       RadioButton1.ShowHint := False;
       RadioButton4.ShowHint := False;
       RadioButton2.ShowHint := False;
       RadioButton3.ShowHint := False;
       RadioGroup1.ShowHint := False;
      end;

end;

procedure TForm1.N1Click(Sender: TObject);
begin
for j := 1 to k+1 do for i := 1 to k+1 do StringGrid1.cells[i,j] := '0';
end;

//Zoom in - приблизить (F2)
procedure TForm1.N5Click(Sender: TObject);
var B : word;
begin
if GroupBox1.Width < 10000
 then begin
            GroupBox1.Width := GroupBox1.Width * 2;
            B := Panel1.Height;
            Panel1.Height := Panel1.Height + B;
            GroupBox1.Top := GroupBox1.Top + B;
      end;
end;

//Zoom out - удалить (F3)
procedure TForm1.N6Click(Sender: TObject);
var B : word;
begin
if Panel1.Height > 300
 then begin
        GroupBox1.Width := GroupBox1.Width div 2;
        B := Panel1.Height div 2;
        Panel1.Height := Panel1.Height - B;
        GroupBox1.Top := GroupBox1.Top - B;
      end;
end;

procedure TForm1.CheckBox1Exit(Sender: TObject);
begin
if CheckBox1.Checked = True then Button4.Enabled := True
                            else Button4.Enabled := False;
if CheckBox1.Checked = True then Label13.Visible := True
                            else Label13.Visible := False;
end;

// Автор
procedure TForm1.N9Click(Sender: TObject);
const slp = 8;
A1 : array[1..25] of char = ('Г','а','б','р','и','е','л','я','н',' ','С','е','р','г','е','й',' ','Ю','р','ь','е','в','и','ч','.');
A2 : array[1..27] of char = ('А','в','т','о','р',' ','п','р','о','г','р','а','м','м','ы',' ','N','e','t','G','r','a','p','h',' ','-',' ');
A3 : array[1..24] of char = ('Я','з','ы','к',' ','п','р','о','г','р','а','м','м','и','р','о','в','а','н','и','я',' ','-',' ');
A4 : array[1..19] of char = ('B','o','r','l','a','n','d',' ','D','e','l','p','h','i',' ','5','.','0','.');
A5 : array[1..15] of char = ('2','0','0','0',' ','г','о','д',',',' ','м','а','й','.',' ');
AC1 : array[1..6] of TColor = (clYellow, clGreen, clBlack, clRed, clBlue, clAqua);
AC2 : array[1..2] of TColor = (clYellow, clBlack);
var jj : word;
begin
with P do
 begin
//        Sleep(55);
        Canvas.Pen.Mode := pmXor;
        SetBkMode(Canvas.Handle, OPAQUE);
        SetBkColor(Canvas.Handle, clRed);
        j := 100;
        for i := 1 to 55 do
         begin
          Canvas.Pen.Color := AC1[random(7)];
          Canvas.Brush.Color := AC2[random(7)];
          j := j + j div 15;
          Canvas.Ellipse(20+i*20, j div 3, 750-i*8, 550 - j);
          Sleep(15);
         end;
   Canvas.Font.Color := clBlack;
   Canvas.Font.Name := 'Courier';
   Canvas.Font.Size := 28;
//   Canvas.Font.Style := TFontStyles(fsBold);
  Canvas.Brush.Color := clYellow;
   for i := 1 to 27 do
     begin
        Canvas.TextOut(i*20 + 2, 12, A2[i]);
        Sleep(slp);
     end;
   for i := 1 to 25 do
     begin
        Canvas.TextOut(i*20 + 2, 62, A1[i]);
        Sleep(slp);
     end;      Canvas.TextOut(i*20 + 2, 62, ' ');
   for i := 1 to 24 do
     begin
        Canvas.TextOut(i*20 + 2, 112, A3[i]);
        Sleep(slp);
     end;
   for i := 1 to 19 do
     begin
        Canvas.TextOut(i*20 + 2, 162, A4[i]);
        Sleep(slp);
     end;      Canvas.TextOut(i*20 + 2, 162, ' ');
   for i := 1 to 15 do
     begin
        Canvas.TextOut(i*20 + 2, 212, A5[i]);
        Sleep(slp);
     end;
        Canvas.Pen.Mode := pmCopy;
 end;
end;

procedure TForm1.StringGrid1Enter(Sender: TObject);
begin
Button3.Enabled := True;
N7.Enabled := True;
end;

// О программе
procedure TForm1.N10Click(Sender: TObject);
var  F : TextFile; a : char;
begin
Canvas.Font.Color := clBlack;
Canvas.Font.Name := 'TimesNewRoman';
Canvas.Font.Size := 10;
ForceCurrentDirectory := True;
Form2.Show;
Form2.Memo1.Lines.LoadFromFile('NetGraph.dat');
end;

end.
