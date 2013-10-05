unit FormZakaz;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, Spin, StdCtrls, Buttons, ExtCtrls, Grids,
  Mainspace,inifiles,Printers;

type
  TZakaz = class(TForm)
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    MainTree: TTreeView;
    StringGrid1: TStringGrid;
    StatusBar1: TStatusBar;
    Button1: TButton;
    ToolButton5: TToolButton;
    Button2: TButton;
    ToolButton6: TToolButton;
    Button3: TButton;
    ToolButton7: TToolButton;
    Button4: TButton;
    Memo1: TMemo;
    procedure FormShow(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure MainTreeClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
      procedure  BuildTree;
      procedure LoadNewOrder;
      procedure LoadOrder(str_file:String);
      procedure get_message(str_file:String);
      procedure LoadNakl(str_file:String);
   //   function get_gun_num_str(id_tovar:string):integer;
  end;

var
  Zakaz: TZakaz;
  flag_new:Boolean;
   OrdinaryLineWidth: Integer = 2;
 BoldLineWidth: Integer = 4;

implementation

{$R *.dfm}

procedure TZakaz.LoadNewOrder;
var
  sr: TSearchRec;
  FileAttrs: Integer;
begin
       if FindFirst(ExeDir+'Data\OrdersNew\*.*', FileAttrs, sr) = 0 then
    begin

      repeat
        if ExtractFileExt(sr.Name)='.xml' Then
        begin

        try
           LoadOrder(ExeDir+'Data\OrdersNew\'+sr.Name);

        except
        ShowMessage('Не получается открыть новый заказ');
        end
        end;

      until FindNext(sr) <> 0;
      Button2.Visible:=false;
      Button1.Visible:=true;
      Button3.Visible:=true;
      Button4.Visible:=true;
      if flag_new then
        begin
          MainTree.Items.Add(nil,'Новая заявка');
          flag_new:=false;
        end;
      FindClose(sr);
     end;
end;
procedure TZakaz.get_message(str_file:String);
var
   str,str_mees:String;
   Text:TextFile;
     sr: TSearchRec;
  FileAttrs: Integer;
begin
  if FindFirst(ExeDir+'Data\Message\*.*', FileAttrs, sr) = 0 then
    begin

      repeat
      //ExtractFileExt(sr.Name)='.xml' and
        if (Pos('message_'+IntToStr(ClientData.user_id)+'_'+str_file+'_','dd'+sr.Name) > 0)  Then
        begin

        try
          AssignFile(Text,ExeDir+'Data\Message\'+sr.Name);
          Reset(Text);
          Readln(text,str);
          while not Eof(Text) do
          begin
            Readln(text,str);
            if Pos('<message',str)>0 Then
            begin
                Delete(str,1,Pos('text="',str)+5);
               str_mees:=copy(str,1,Pos('"',str)-1);

               Delete(str,1,Pos('date="',str)+5);
               str_mees:=copy(str,1,Pos('"',str)-1)+' '+str_mees;
                Memo1.Lines.Add(str_mees);
                str_mees:='';
            end;
          end;

        CloseFile(Text);
        except
        //
        end
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
end;
end;
function get_gun_num_str(id_tovar:string; StringGrid:TStringGrid):integer;
var fvalue:string;
i:integer;
begin
result:=0;
   for i:=1 to StringGrid.RowCount-1 do
  begin

    if Trim(StringGrid.Cells[1,i]) = Trim(id_tovar) then
    begin
     // ShowMessage(StringGrid.Cells[1,i]+'i'+inttostr(i)+' to id '+id_tovar);
         result:=i;
        // Break;
    end;
  end;


end;

procedure TZakaz.LoadNakl(str_file:String);
var Text:TextFile;
str,num_zakaz,date_str,id_tovar:string;
num_str:Integer;
sum:real;
begin
   if not FileExists(ExeDir+'Data\Nakl\nakl_'+IntToStr(ClientData.user_id)+'_'+str_file+'.xml') then
      exit;
      try

      AssignFile(Text, ExeDir+'Data\Nakl\nakl_'+IntToStr(ClientData.user_id)+'_'+str_file+'.xml');
       //ShowMessage('FILE '+ExeDir+'Data\Nakl\nakl_'+IntToStr(ClientData.user_id)+'_'+str_file+'.xml');
        Reset(Text);
        Readln(text,str);
        Readln(text,str);
         while not Eof(Text) do
        begin
          Readln(text,str);
          if Pos('<nakl',str)=1 Then
          begin
                Delete(str,1,Pos('datedoc="',str)+8);
                date_str:=copy(str,1,Pos('"',str)-1)+' ';

                Delete(str,1,Pos('timedoc="',str)+8);

          end;

          if Pos('<line',str)=1 Then
          begin


                Delete(str,1,Pos('codtovar="',str)+9);
                id_tovar:= copy(str,1,Pos('"',str)-1);
                num_str:=get_gun_num_str(id_tovar,StringGrid1);
               // ShowMessage(id_tovar+IntToStr(num_str));
                if num_str>0 then
                begin


                Delete(str,1,pos('prise="',str)+6);
                StringGrid1.Cells[7,num_str]:= copy(str,1,Pos('"',str)-1);

                Delete(str,1,pos('number="',str)+7);
                StringGrid1.Cells[8,num_str]:= copy(str,1,Pos('"',str)-1);
                try
                StringGrid1.Cells[9,num_str]:=
                        floattostrf(
                        strtofloat(StringGrid1.Cells[7,num_str])*strtoint(StringGrid1.Cells[8,num_str]),
                        fffixed,14,2);
                        sum:=sum+StrToFloat(StringGrid1.Cells[9,num_str]);
                except
                end;
                 date_str:=date_str+copy(str,1,Pos('"',str)-1);
                memo1.Lines.Add(date_str+' Создана Накладная на сумму: '+FloatToStr(sum));
               Button2.Visible:=False;
                end;
          end;
        end;
        CloseFile(Text);
  except
end;
end;

procedure TZakaz.LoadOrder(str_file:String);
var Text:TextFile;
str,num_zakaz,date_str:string;
sum:real;
begin
  if not FileExists(str_file) then
      exit;
      try
        StringGrid1.rOwCount := 1;
        AssignFile(Text,str_file);
        Reset(Text);
        Readln(text,str);
        Readln(text,str);
       // Readln(text,str);
        while not Eof(Text) do
        begin
          Readln(text,str);
          if Pos('<order',str)=1 Then
          begin
                Delete(str,1,Pos('idorder="',str)+8);
                num_zakaz:= copy(str,1,Pos('"',str)-1);

                Delete(str,1,Pos('datedoc="',str)+8);
                date_str:=copy(str,1,Pos('"',str)-1)+' ';

                Delete(str,1,Pos('timedoc="',str)+8);
                date_str:=date_str+copy(str,1,Pos('"',str)-1);


          end;

          if Pos('<line',str)=1 Then
          begin
                StringGrid1.RowCount:=StringGrid1.RowCount+1;
                 StringGrid1.Cells[0,StringGrid1.RowCount-1]:= inttostr(StringGrid1.RowCount-1);


                Delete(str,1,Pos('codtovar="',str)+9);
                StringGrid1.Cells[1,StringGrid1.RowCount-1]:= copy(str,1,Pos('"',str)-1);


                Delete(str,1,Pos('numser="',str)+7);
                StringGrid1.Cells[3,StringGrid1.RowCount-1]:= copy(str,1,Pos('"',str)-1);



                Delete(str,1,Pos('tovarname="',str)+10);
                StringGrid1.Cells[2,StringGrid1.RowCount-1]:= copy(str,1,Pos('"',str)-1);

                Delete(str,1,pos('prise="',str)+6);
                StringGrid1.Cells[5,StringGrid1.RowCount-1]:= copy(str,1,Pos('"',str)-1);

                Delete(str,1,pos('number="',str)+7);
                StringGrid1.Cells[4,StringGrid1.RowCount-1]:= copy(str,1,Pos('"',str)-1);
                try
                StringGrid1.Cells[6,StringGrid1.RowCount-1]:=
                        floattostrf(
                        strtofloat(StringGrid1.Cells[5,StringGrid1.RowCount-1])*strtoint(StringGrid1.Cells[4,StringGrid1.RowCount-1]),
                        fffixed,14,2);
                sum:=sum+StrToFloat(StringGrid1.Cells[6,StringGrid1.RowCount-1]);
                except


                end;
                StringGrid1.Cells[7,StringGrid1.RowCount-1]:='';
                StringGrid1.Cells[8,StringGrid1.RowCount-1]:='';
                StringGrid1.Cells[9,StringGrid1.RowCount-1]:='';
          end;
        end;

          memo1.Clear;
          memo1.Lines.Add(date_str+'Создан заказ на сумму: '+FloatToStr(sum));
          get_message(num_zakaz);
        CloseFile(Text);
    if   StringGrid1.rOwCount > 1 Then
           StringGrid1.FixedRows := 1;

    StringGrid1.Cells[0,0]:='№';
    StringGrid1.Cells[1,0]:='KT';
    StringGrid1.Cells[2,0]:='Товар';
    StringGrid1.Cells[3,0]:='Серия';
    StringGrid1.Cells[4,0]:='Заказ';
    StringGrid1.Cells[5,0]:='Цена';
    StringGrid1.Cells[6,0]:='Сумма';


    StringGrid1.ColWidths[0]:=50;
    StringGrid1.ColWidths[1]:=1;
    StringGrid1.ColWidths[2]:=250;
    StringGrid1.ColWidths[3]:=70;
    StringGrid1.ColWidths[4]:=60;
    StringGrid1.ColWidths[5]:=60;
    StringGrid1.ColWidths[6]:=60;
    LoadNakl(num_zakaz);

except
end;
end;



procedure TZakaz.BuildTree;
var OrdersNode,DefectNode,NewNode:TTreeNode;
  sr: TSearchRec;
  FileAttrs: Integer;
    Order,OrderFile:string;
    Text:TextFile;
  str:string;
begin
  MainTree.Items.Clear;



   FileAttrs := faReadOnly;
   FileAttrs := FileAttrs + faHidden;
   FileAttrs := FileAttrs + faSysFile;
   FileAttrs := FileAttrs + faVolumeID;
   FileAttrs := FileAttrs + faDirectory;
   FileAttrs := FileAttrs + faArchive;
   FileAttrs := FileAttrs + faAnyFile;

   //Открытие новых заказов
   LoadNewOrder;

   OrdersNode:=MainTree.Items.Add(nil,'Архив заявок');
   if FindFirst(ExeDir+'Data\Orders\*.*', FileAttrs, sr) = 0 then
    begin

      repeat
        if ExtractFileExt(sr.Name)='.xml' Then
        begin

        try
                orderFile := sr.Name;
                AssignFile(Text,ExeDir+'Data\Orders\'+sr.Name);
                Reset(Text);
                Readln(text,str);
                Readln(text,str);
                Readln(text,str);
                CloseFile(Text);
                Delete(str,1,Pos('idorder="',str)+8);
                Order:= '№ ' +copy(str,1,Pos('"',str)-1);
                Delete(str,1,pos('datedoc="',str)+8);
                Order:=Order+ ' От '+copy(str,1,Pos('"',str)-1);
                Delete(str,1,pos('timedoc="',str)+8);
                Order:=Order+' в '+ copy(str,1,Pos('"',str)-1);
                MainTree.Items.AddChild(OrdersNode,Order);
        except
        end
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
     end;


end;


procedure TZakaz.FormShow(Sender: TObject);
begin
       flag_new:=True;
         BuildTree;
         StringGrid1.Cells[0,0]:='№';
    StringGrid1.Cells[1,0]:='KT';
    StringGrid1.Cells[2,0]:='Товар';
    StringGrid1.Cells[3,0]:='Серия';
    StringGrid1.Cells[4,0]:='Заказ';
    StringGrid1.Cells[5,0]:='Цена';
    StringGrid1.Cells[6,0]:='Сумма';

    StringGrid1.Cells[7,0]:='Накл кол-во';
    StringGrid1.Cells[8,0]:='Накл цена';
    StringGrid1.Cells[9,0]:='Накл сумма';

    StringGrid1.ColWidths[0]:=50;
    StringGrid1.ColWidths[1]:=1;
    StringGrid1.ColWidths[2]:=250;
    StringGrid1.ColWidths[3]:=70;
    StringGrid1.ColWidths[4]:=60;
    StringGrid1.RowHeights[0]:=40;

    StringGrid1.ColWidths[5]:=60;
    StringGrid1.ColWidths[6]:=60;
    StringGrid1.ColWidths[7]:=60;
    StringGrid1.ColWidths[8]:=60;
    StringGrid1.ColWidths[9]:=60;
end;




procedure TZakaz.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
S : string;
begin

S := StringGrid1.Cells[ACol,ARow];

  if gdSelected in State then begin
    StringGrid1.Canvas.Brush.Color := clLtGray;
    StringGrid1.Canvas.FillRect(Rect);
  end;
  Inc(Rect.Top, 2);
  Dec(Rect.Bottom, 2);
  Inc(Rect.Left, 2);
  Dec(Rect.Right, 2);
  DrawText(StringGrid1.Canvas.Handle, pChar(S), Length(S), Rect, DT_LEFT or DT_WORDBREAK);
end;

procedure TZakaz.MainTreeClick(Sender: TObject);
var
FileName:string;
begin
  if MainTree.Selected.Text='Новая заявка' then
  begin

    Button2.Visible:=False;
    Button1.Visible:=True;
    Button3.Visible:=True;
    Button4.Visible:=true;
        LoadNewOrder;
  end;
  if MainTree.Selected.Level=0 then
  exit;
      FileName:=MainTree.Selected.Parent.Text;
      If FileName='Архив заявок' Then
      begin
        FileName:=MainTree.Selected.Text;
        FileName:=Copy(FileName,3,Pos('От',FileName)-4)+'.xml';

            Button2.Visible:=True;
        Button1.Visible:=False;
        Button3.Visible:=False;
        Button4.Visible:=False;
        LoadOrder(ExeDir+'Data\Orders\'+FileName);      
      end;



end;

procedure TZakaz.Button2Click(Sender: TObject);
var FileName:string;
begin
if MainTree.Selected.Level=0 then
exit;
      FileName:=MainTree.Selected.Parent.Text;
      If FileName='Архив заявок' Then
      begin
        FileName:=MainTree.Selected.Text;
        FileName:=Copy(FileName,3,Pos('От',FileName)-4)+'.xml';
        RenameFile(ExeDir+'Data\Orders\'+FileName,ExeDir+'Data\Outbox\order_'+IntToStr(ClientData.user_id)+'_'+FileName);
      end;
end;
procedure TZakaz.Button3Click(Sender: TObject);
var FileName:string;
  IniFile:TIniFile;
begin
        ClientData.OrdersCount:=1+ClientData.OrdersCount;
        FileName:=IntToStr(ClientData.OrdersCount)+'.xml';
        CopyFile(PChar(ExeDir+'Data\OrdersNew\'+FileName),PChar(ExeDir+'Data\Orders\'+FileName), True);
        RenameFile(ExeDir+'Data\OrdersNew\'+FileName,ExeDir+'Data\Outbox\order_'+IntToStr(ClientData.user_id)+'_'+FileName);


       Form1.ClearOrder;
        //Записываем новый порядковый номер
        IniFile:=TIniFile.Create(ExeIni);
        Inifile.WriteString('Client','OrdersCount',IntToStr(ClientData.OrdersCount));
        IniFile.Free;
        Zakaz.Visible:=False;
        Zakaz.Close;
        sleep(1000);
        Form1.SendData(3);
end;

procedure TZakaz.Button4Click(Sender: TObject);
begin
  Form1.ClearOrder;
  Zakaz.Visible:=False;
  Zakaz.Close;

end;

procedure TZakaz.Button1Click(Sender: TObject);
begin
  Zakaz.Visible:=False;
  Zakaz.Close;
end;


//Korrectirovka po razmeru
function DrawStringGridEx(Grid: TStringGrid; Scale: Double; FromRow,
LeftMargin, TopMargin, Yfloor: Integer; DestCanvas: TCanvas): Integer;
 // ?????????? ????? ??????, ??????? ?? ??????????? ?? Y = Yfloor
var
 i, j, d, TotalPrevH, TotalPrevW, CellH, CellW, LineWidth: Integer;
 R: TRect;
 s: string;


  procedure CorrectCellHeight(ARow: Integer);
  // ?????????? ?????????? ?????? ?????? ? ?????? ?????????????? ??????
  // ????? ?????????? ?????? ?? ?????? ??????? ??????? ????? ??????????
  var
   i, H: Integer;
   R: TRect;
   s: string;
  begin
   R := Rect(0, 0, CellH*2, CellH);
   s := ':)'; // ????????? ?????? ??????
   CellH := DrawText(DestCanvas.Handle, PChar(s), Length(s), R,
     DT_LEFT or DT_TOP or DT_WORDBREAK or DT_SINGLELINE or
     DT_NOPREFIX or DT_CALCRECT) + 3*d;
   for i := 0 to Grid.ColCount-1 do
   begin
    CellW := Round(Grid.ColWidths[i]*Scale);
    R := Rect(0, 0, CellW, CellH);
    //InflateRect(R, -d, -d);
    R.Left := R.Left+d;
    R.Top := R.Top + d;
    s := Grid.Cells[i, ARow];
    // ?????????? ?????? ? ??????
    H := DrawText(DestCanvas.Handle, PChar(s), Length(s), R,
     DT_LEFT or DT_TOP or DT_WORDBREAK or DT_NOPREFIX or DT_CALCRECT);

    if CellH < H + 2*d then CellH := H + 2*d;
    // if CellW < R.Right - R.Left then ??????? ??????? ????? -
    // ?? ?????????? ? ???? ??????; ??????? ???? ?? ??????????????
   end;
  end;

begin
 Result := -1; // ??? ?????? ?????????? ????? TopMargin ? Yfloor
 if (FromRow < 0)or(FromRow >= Grid.RowCount) then Exit;

 DestCanvas.Brush.Style := bsClear;
 DestCanvas.Font := Grid.Font;
//  DestCanvas.Font.Height := Round(Grid.Font.Height*Scale);
 DestCanvas.Font.Size := 10;


 Grid.Canvas.Font := Grid.Font;
 Scale := DestCanvas.TextWidth('test')/Grid.Canvas.TextWidth('test');
 Scale := Scale*600/Grid.width;

 d := Round(2*Scale);
 TotalPrevH := 0;

 for j := 0 to Grid.RowCount-1 do
 begin
  if (j >= Grid.FixedRows) and (j < FromRow) then Continue;
  // Fixed Rows ???????? ?? ?????? ????????

  TotalPrevW := 0;
  CellH := Round(Grid.RowHeights[j]*Scale);
  CorrectCellHeight(j);

  if TopMargin + TotalPrevH + CellH > YFloor then
  begin
   Result := j; // j-? ?????? ?? ?????????? ? ???????? ????????
   if Result < Grid.FixedRows then Result := -1;
   // ???? ????????????? ?????? ?? ??????? ?? ???????? -
   // ??? ??????? ??????...
   Exit;
  end;

  for i := 0 to Grid.ColCount-1 do
  begin
   CellW := Round(Grid.ColWidths[i]*Scale);

   R := Rect(TotalPrevW, TotalPrevH, TotalPrevW + CellW, TotalPrevH + CellH);
   OffSetRect(R, LeftMargin, TopMargin);

   if (i < Grid.FixedCols)or(j < Grid.FixedRows) then
     LineWidth := BoldLineWidth
   else
     LineWidth := OrdinaryLineWidth;

   DestCanvas.Pen.Width := LineWidth;
   if LineWidth > 0 then
    DestCanvas.Rectangle(R.Left, R.Top, R.Right+1, R.Bottom+1);

   //InflateRect(R, -d, -d);
   R.Left := R.Left+d;
   R.Top := R.Top + d;

   s := Grid.Cells[i, j];
   DrawText(DestCanvas.Handle, PChar(s), Length(s), R,
    DT_LEFT or DT_TOP or DT_WORDBREAK or DT_NOPREFIX);

   TotalPrevW := TotalPrevW + CellW; // ????? ?????? ???? ?????????? ???????
  end;

  TotalPrevH := TotalPrevH + CellH;  // ????? ?????? ???? ?????????? ?????
 end;
end;




procedure PrintStringGrid(Grid: TStringGrid; Scale: Double; LeftMargin,
TopMargin, BottomMargin: Integer);
var NextRow: Integer;
begin
 //Printer.BeginDoc;

 if not Printer.Printing then raise Exception.Create('function PrintStringGrid must be called between Printer.BeginDoc   and Printer.EndDoc');

 NextRow := 0;
 repeat
  NextRow := DrawStringGridEx(Grid, Scale, NextRow, LeftMargin, TopMargin,
   Printer.PageHeight - BottomMargin, Printer.Canvas);
  if NextRow <> -1 then Printer.NewPage;
 until NextRow = -1;

 //Printer.EndDoc;
end;




procedure TZakaz.ToolButton1Click(Sender: TObject);
var K: Double;
    R:Trect;
    s:string;
begin
 if MainTree.Selected.Level=0 then
exit;
      s:=MainTree.Selected.Parent.Text;
      If (s='Архив заявок') Then
      begin
       s :='Заявка '+MainTree.Selected.Text;


 Printer.BeginDoc;
 K :=  Printer.Canvas.Font.PixelsPerInch / Canvas.Font.PixelsPerInch*1.2;
 R.Left := 60;
 R.Top := 40;
 DrawText(Printer.Canvas.Handle, PChar(s), Length(s), R,
 DT_LEFT or DT_TOP or DT_WORDBREAK or DT_NOPREFIX);
 R.Top := 80;



 PrintStringGrid(StringGrid1,
 K,  // Коэф
  60, // отступ слева
  140, // --"-- сверху
  60  // отступ слева
  );

 Printer.EndDoc;
end;
end;

end.
