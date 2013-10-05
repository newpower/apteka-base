unit mainspace;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, xmldom, XMLIntf, StdCtrls, msxmldom, XMLDoc, oxmldom,
  xercesxmldom, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP,IdMultipartFormData, Grids,inifiles, Menus, Spin, ImgList,
  ExtCtrls, ComCtrls, ToolWin;

type
  TForm1 = class(TForm)
    XMLDocument1: TXMLDocument;
    Button1: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    IdHTTP1: TIdHTTP;
    Button2: TButton;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    PriceGrid: TStringGrid;
    ZakazEdit: TSpinEdit;
    BottomPanel: TPanel;
    Panel1: TPanel;
    Bevel2: TBevel;
    Bevel5: TBevel;
    Label3: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    Bevel3: TBevel;
    Bevel6: TBevel;
    Label5: TLabel;
    Label4: TLabel;
    Panel4: TPanel;
    Bevel4: TBevel;
    Bevel7: TBevel;
    Label6: TLabel;
    Label9: TLabel;
    Label8: TLabel;
    Bevel10: TBevel;
    Label12: TLabel;
    Panel3: TPanel;
    Bevel8: TBevel;
    Bevel9: TBevel;
    Label7: TLabel;
    Label10: TLabel;
    Panel5: TPanel;
    Bevel1: TBevel;
    PrWithNacLabel: TLabel;
    PriceWithNac: TLabel;
    TopPanel: TPanel;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton5: TToolButton;
    ToolButton3: TToolButton;
    Panel6: TPanel;
    ProgressPanel: TPanel;
    Label11: TLabel;
    Label13: TLabel;
    ProgressBar1: TProgressBar;
    Button3: TButton;
    FindEdit: TEdit;
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    N9: TMenuItem;
    N8: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    N4: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N10: TMenuItem;
    aboutBoxItem: TMenuItem;
    Timer1: TTimer;
    ImageList: TImageList;
    AptNac: TSpinEdit;
    N5: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PricegridKeyPress(Sender: TObject; var Key: Char);
    procedure PriceGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure PriceGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ZakazEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ZakazEditEnter(Sender: TObject);
    procedure PriceGridKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PriceGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure ZakazEditExit(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure IdHTTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure N5Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);



  private
    { Private declarations }
  public
    procedure   LoadPrice;
    procedure  runingdir(Key: String);
    procedure ClearOrder;
    procedure SendData(id_param:integer);
    procedure LoadNewPrice;
    function deleteDelimeter(Delimeter: string; var str: string): string;
  end;
  type PriceRecord = record
    code :string [10];
    name : string [100];
    Maker :string [50];
    Codser : string [9];
    Goden: string [10];
    Seria : string [25];
    Price : real;
    Count : integer;
    Group : byte;
    zakaz : integer;
    Summa : real;
    ZN:string [1];
    RegKR : string [25];
    cost_min:real;
    cost_max:real;
    end;
  type TClientData =  record
    UserName:string;
     UserPass:string;
     user_id:integer;
     ShowLogin:boolean;
     AptNac:real;
     connection:byte;
     Server:string;
     Price:string;
     UseProxy:boolean;
     ProxyHost:string;
     ProxyPort:integer;
     ProxyLogin:string;
     ProxyPass:string;
     SmtpHost:string;
     EMail:string;
     SmtpAuth:boolean;
     SmtpUser:string;
     SMTPPass:string;
     SMTPFrom:string;
     ClientName:string;
     ClientPhone:string;
     ClientCode:string;
     OrdersCount:integer;
     PriceDate:string;
     FtpUserName:string;
     FTPPassword:String;
     ProxyType:integer;
  end;

var
  Form1: TForm1;
    ExeDir:string;
    ExeIni:string;
    PriceFile:file of PriceRecord;
    ClientData:TClientData;

    maxkoef:integer;
    clientcoef:array of real;

  col_idtovar:integer =0;
  col_codtovar:integer =1;
  col_tovarname:integer =2;
  col_macker:integer =3;
  col_codser:integer =4;
  col_goodnes:integer =5;
  col_numser:integer =6;
  col_prise:integer =7;
  col_number:integer =8;
  col_group:integer =9;
  col_zakaz:integer =10;
  col_summa:integer =11;
  col_zn:integer =12;
  col_regkr:integer =13;
  col_cost_min:integer =14;
  col_cost_max:integer =15;
implementation

uses Unit2, FormZakaz, options;

{$R *.dfm}
function GetComputerNetName: string;
var
  buffer: array[0..255] of char;
  size: dword;
begin
  size := 256;
  if GetComputerName(buffer, size) then
    Result := buffer
  else
    Result := ''
end;
function STRtoXML(Value:string):string;
  var i:integer;
  begin
    result:=value;
     For i:=1  to  Length(Value) do
      if result[i]=Chr(39) then
        result[i]:=' '
      else
      if result[i]=Chr(34) then
        result[i]:=' '
      else
      if result[i]=Chr(38) then
        result[i]:=' '
      else
      if result[i]=Chr(92) then
        result[i]:=' '
      else
      if result[i]=Chr(60) then
        result[i]:=' '
      else
      if result[i]=Chr(62) then
        result[i]:=' '
      else
      if result[i]=Chr(13) then
        result[i]:=' '
      else
      if result[i]=Chr(10) then
        result[i]:=' '
      else
      if result[i]=Chr(32) then
        result[i]:=' ';
  end;


function strtoi(Value:string):integer;
var fvalue:string;
begin
  fvalue:=value;
  if fvalue='' then fvalue:='0';
  try
    result:=strtoint(fvalue);
  except
    result:=0
  end;

end;

function strtof(Value:string):real;
var fvalue:string;
begin
  fvalue:=value;
  if fvalue='' then fvalue:='0';
  if Pos(',',fvalue) >0 then
  fvalue[Pos(',',fvalue)]:=decimalseparator;
  if Pos('.',fvalue) >0 then
  fvalue[Pos('.',fvalue)]:=decimalseparator;
  try
    result:=strtofloat(fvalue);
  except
    result:=0;
  end;
end;



procedure TForm1.Button1Click(Sender: TObject);
var DOM:String;
i:Integer;
ForecastNode: IXMLNode;
begin
 try
    XMLDocument1.LoadFromFile('C:\Users\dns\Documents\delphi project\xml.xml');
    Label1.Caption:=XMLDocument1.DOMDocument.documentElement.attributes.item[0].nodeValue;

    //ищем узел forecast
    Label1.Caption:=XMLDocument1.DocumentElement.ChildNodes.FindNode('DataBase').Attributes['name'];

     ForecastNode:=XMLDocument1.DocumentElement.ChildNodes.FindNode('DataBase').ChildNodes.FindNode('data');

    if Assigned(ForecastNode) then
    begin
    //раз нашли - пробегаемся по всем дочерним узлам
     for i := 0 to ForecastNode.ChildNodes.Count-1 do
       begin
          Memo1.Text:=Memo1.Text+IntToStr(i)+' id '+ForecastNode.ChildNodes.Nodes[i].Attributes['id'];
         // ForecastNode.ChildNodes.Nodes[i].Attributes['id']
       end;
    end;


 //sPanel22.Caption:=XMLDocument1.DocumentElement.ChildNodes['forecast'].ChildNodes[0].ChildNodes['cloud'].Text+' °С';
  finally
     DOM:='nill';
    end;
end;
procedure TForm1.Button2Click(Sender: TObject);
begin
   Form1.SendData(1);
end;


//Функция отправления, получения данных
// параметр 1 получить правйс лист
// параметр 2 получить все без прайс листа
// параметр 3 передать файлы outputs
procedure TForm1.SendData(id_param:integer);
var LocalFile:TStream;
 str_file_name,str_arh_file,str_param_zip,str_arh_file_out:string;
dt: TIdMultiPartFormDataStream;
  sr: TSearchRec;
    FileAttrs,k,count_files: Integer;
    flag_connect:Boolean;
begin

      // устанавливаем настройки прокси
        If clientData.UseProxy Then
    begin
    ShowMessage('proxy set up');
      IdHTTP1.ProxyParams.BasicAuthentication:=True;
      IdHTTP1.ProxyParams.ProxyServer:=ClientData.ProxyHost;
      IdHTTP1.ProxyParams.ProxyPort:=ClientData.ProxyPort;
      IdHTTP1.ProxyParams.ProxyUsername:=ClientData.ProxyLogin;
      IdHTTP1.ProxyParams.ProxyPassword:=ClientData.ProxyPass;
    end
    else
    begin
     IdHTTP1.ProxyParams.BasicAuthentication:=False;
           IdHTTP1.ProxyParams.ProxyServer:='';
      IdHTTP1.ProxyParams.ProxyUsername:='';
      IdHTTP1.ProxyParams.ProxyPassword:='';
    end;
       flag_connect:=true;

    //выводим сообщения
      Label6.Caption:='Проводится обмен с сервером! Необходимо подождать!';
  ProgressBar1.Position:=0;

  ProgressPanel.Visible:=True;
  Refresh;
  //

  //IdHTTP1.Request.Host:='http://polimed-yug.ru/load/price_klient.zip';
    try
      begin
        try
         str_arh_file:=exeDir+'Data\Arhive\ar_in'+StringReplace(DateTostr(Date),'.','-',[rfReplaceAll])+' '+StringReplace(TimeToStr(Time),':',' ',[rfReplaceAll])+'.zip';
         str_arh_file_out:=exeDir+'Data\Arhive\ar_out'+StringReplace(DateTostr(Date),'.','-',[rfReplaceAll])+' '+StringReplace(TimeToStr(Time),':',' ',[rfReplaceAll])+'.zip';

          LocalFile:=TFileStream.Create(str_arh_file,fmCreate);
        Except
            ShowMessage(exeDir+'Error write file');
        end;

        if id_param=3 then
        begin
          count_files:=0;
          // Считаем кол-во файлов
          if FindFirst(ExeDir+'Data\Outbox\*.*', FileAttrs, sr) = 0 then
            begin

              repeat
               if ExtractFileExt(sr.Name)='.xml' Then
                begin
                    count_files:=count_files+1;
                 end;
              until FindNext(sr) <> 0;
          FindClose(sr);
          end;
          //

          //Проверяем есть ли файлы если есть то архивируем
          if count_files >0 then
          begin
             Memo2.Lines.Clear;
             Memo2.Lines.Add('Отправка файлов произведена');
             memo2.Lines.SaveToFile(exeDir+'Data\Outbox\version_'+IntToStr(ClientData.user_id)+'.txt');
             Memo2.Lines.Clear;
             str_param_zip:='"'+ExeDir+'7-zip\7z.exe" a -tzip -ssw -mx3 "'+str_arh_file_out+'" "'+exeDir+'Data\Outbox\*.*" >> log.txt';
             WinExec(PAnsiChar(str_param_zip),SW_HIDE);
             sleep(5000);
          end;

        end;

        dt:=TIdMultiPartFormDataStream.Create;
     //
       dt.AddFormField('load', 'Upload');
       if id_param=1 then
       dt.AddFormField('action', 'get');
       if id_param=2 then
       dt.AddFormField('action', 'get');

       if id_param=3 then
       begin
        dt.AddFormField('action', 'put');
         dt.AddFile('filename',str_arh_file_out,'application/octet-stream');
       end;

      dt.AddFormField('user_id', IntToStr(ClientData.user_id));
      if id_param=1 then
      dt.AddFormField('get_price', '1');

       dt.AddFormField('submit-url', '/admin/saveconf_sc.as');

        IdHTTP1.Post('http://agro2b.nawww.ru/myspace/base/obmen.php',dt,LocalFile);
      //    IdHTTP1.Get('http://agro2b.nawww.ru/index_info.php',LocalFile); //
          IdHTTP1.Disconnect
     end;
     except
     flag_connect:=False;
     ShowMessage('Проблема интернет, при подключении к серверу'#13#10);
      //      ShowMessage('1'#13#10+Clearstr);
     end;
       LocalFile.Free;
       if flag_connect then
       begin
       str_param_zip:='"'+ExeDir+'7-zip\7z.exe" e "'+str_arh_file+'" "-o'+exeDir+'Data\Inbox\" -y';

         WinExec(PAnsiChar(str_param_zip),SW_HIDE);
     k:=10;
     while k > 0 do
     begin
      k:=k-1;
      sleep(1000);
      //ShowMessage(ExeDir+'Data\Inbox\version_'+IntToStr(ClientData.user_id)+'.txt');
    if FindFirst(ExeDir+'Data\Inbox\version_'+IntToStr(ClientData.user_id)+'.txt', FileAttrs, sr) = 0 then
    begin
      repeat
        if sr.Name='version_'+IntToStr(ClientData.user_id)+'.txt' Then
          begin
            Label11.Caption:='Полученые данные обрабатываются! ';
            Refresh;

            k:=0;
           // ShowMessage('File poluchen vse ok');
            DeleteFile(str_arh_file);
            DeleteFile(ExeDir+'Data\Inbox\version_'+IntToStr(ClientData.user_id)+'.txt');

            runingdir('1');
          end;

      until FindNext(sr) <> 0;
    end;
      FindClose(sr);
       end;

       if id_param=3 then
       begin
         if FindFirst(ExeDir+'Data\Outbox\*.*', FileAttrs, Sr) = 0 then
            repeat
              if (Sr.Name = '.') or (Sr.Name = '..') then
                continue
              else
                DeleteFile(ExeDir+'Data\Outbox\'+Sr.Name);
            until FindNext(sr) <> 0;
      FindClose(sr);
      DeleteFile(str_arh_file_out);
          end;

    end;



      //Убираем панель
  ProgressPanel.Visible:=False;
  Refresh;
  //

  end;

procedure TForm1.runingdir(Key: String);
var
  sr: TSearchRec;
  FileAttrs,k: Integer;
  str_param,str_param_value,str:string;
  IniFile:TIniFile;
  Text:TextFile;
begin
    IniFile:=TIniFile.Create(ExeIni);
    //ShowMessage('Run procedure');
  if FindFirst(ExeDir+'Data\Inbox\*.*', FileAttrs, sr) = 0 then
    begin
      repeat
      if pos('params_'+IntToStr(ClientData.user_id), 'rem'+sr.Name) > 0 then
      begin
         try
          XMLDocument1.LoadFromFile(ExeDir+'Data\Inbox\'+sr.Name);
          str_param:=XMLDocument1.DocumentElement.ChildNodes.FindNode('SetParam').Attributes['name'];
          str_param_value := XMLDocument1.DocumentElement.ChildNodes.FindNode('SetParam').Attributes['value'];
          if str_param = 'user_id' then
            begin
             ClientData.user_id:=StrToInt(str_param_value);
             IniFile.WriteString('Client','User_id',str_param_value)
            end;
          if str_param = 'user_name'  then
            begin
             ClientData.UserName:=str_param_value;
             IniFile.WriteString('Client','UserName',str_param_value)
            end;
           if str_param = 'SN' then
            begin
             IniFile.WriteString('Client','SN',str_param_value)
            end;
           RenameFile(ExeDir+'Data\Inbox\'+sr.Name,ExeDir+'Data\Params\'+sr.Name);
           DeleteFile(ExeDir+'Data\Inbox\'+sr.Name);
         finally
        // DOM:='nill';
         end;

      //  ShowMessage(sr.Name);
      end;
      //  Обработка сообщений
     if pos('message_'+IntToStr(ClientData.user_id), 'rem'+sr.Name) > 0 then
      begin
         try
          AssignFile(Text,ExeDir+'Data\Inbox\'+sr.Name);
          Reset(Text);
          Readln(text,str);
          while not Eof(Text) do
          begin
            Readln(text,str);
            if Pos('<message',str)>0 Then
            begin
                Delete(str,1,Pos('text="',str)+5);

                ShowMessage(copy(str,1,Pos('"',str)-1));
                end;
            end;

        CloseFile(Text);

            RenameFile(ExeDir+'Data\Inbox\'+sr.Name,ExeDir+'Data\Message\'+sr.Name);
           // DeleteFile(ExeDir+'Data\Inbox\'+sr.Name);
         finally
        // DOM:='nill';
         end;

       // ShowMessage(sr.Name);
      end;


      //Загружаем накладные
        if pos('nakl_'+IntToStr(ClientData.user_id)+'_', 'rem'+sr.Name) > 0 then
      begin
         try
            RenameFile(ExeDir+'Data\Inbox\'+sr.Name,ExeDir+'Data\Nakl\'+sr.Name);
           // DeleteFile(ExeDir+'Data\Inbox\'+sr.Name);
         finally
        // DOM:='nill';
         end;
      end;

            //Загружаем обновления
      if sr.Name = 'client.exe' then
      begin
         try
            RenameFile(ExeDir+'Data\Inbox\'+sr.Name,ExeDir+'Update\'+sr.Name);
           // DeleteFile(ExeDir+'Data\Inbox\'+sr.Name);
         finally
        // DOM:='nill';
         end;
      end;


      //Загружаем прайс лист
     if sr.Name = 'data.csv' then
      begin
         try
           LoadNewPrice;

         finally
          //
         end;
       DeleteFile(ExeDir+'Data\Inbox\'+sr.Name);
      //  ShowMessage('Прайс лист загружен, Вы можете совершить заказ.');

      end;

      until FindNext(sr) <> 0;

    end;
     FindClose(sr);
     IniFile.Destroy;
end;





procedure TForm1.FormCreate(Sender: TObject);
var IniFile:TIniFile;
  clk:string;
  s:real;
begin
 ExeDir:=ExtractFileDir(application.exeName)+'\';
 ExeIni:=ExeDir+'\Data\'+GetComputerNetName+'.ini';
  IniFile:=TIniFile.Create(ExeIni);

  
  //Создаем директории если отцутсвуют
  If not  directoryExists(ExeDir+'Data') Then
 CreateDirectory(PChar(ExeDir+'Data'),nil);
  If not  directoryExists(ExeDir+'Update') Then
 CreateDirectory(PChar(ExeDir+'Update'),nil);
  If not  directoryExists(ExeDir+'Data\Inbox') Then
 CreateDirectory(PChar(ExeDir+'Data\Inbox'),nil);
  If not  directoryExists(ExeDir+'Data\Orders') Then
 CreateDirectory(PChar(ExeDir+'Data\Orders'),nil);
   If not  directoryExists(ExeDir+'Data\OrdersNew') Then
 CreateDirectory(PChar(ExeDir+'Data\OrdersNew'),nil);
  If not  directoryExists(ExeDir+'Data\OutBox') Then
 CreateDirectory(PChar(ExeDir+'Data\OutBox'),nil);

   If not  directoryExists(ExeDir+'Data\Params') Then
 CreateDirectory(PChar(ExeDir+'Data\Params'),nil);

    If not  directoryExists(ExeDir+'Data\Message') Then
 CreateDirectory(PChar(ExeDir+'Data\Message'),nil);

     If not  directoryExists(ExeDir+'Data\Arhive') Then
 CreateDirectory(PChar(ExeDir+'Data\Arhive'),nil);

      If not  directoryExists(ExeDir+'Data\Nakl') Then
 CreateDirectory(PChar(ExeDir+'Data\Nakl'),nil);

 //Получаем коэфициент пользователя
   try
  clk:= IniFile.ReadString('Client','SN','0;0;');
  maxkoef:=-1;
  while length(clk)>0 do
  begin
    maxkoef:=maxkoef+1;
    s:=strtofloat(Copy(PChar(clk),1,Pos(';',clk)-1));
    Delete(clk,1,Pos(';',clk));
    setlength(clientCoef,length(clientCoef)+1);
    clientCoef[length(clientCoef)-1]:=1+(s/100);
  end;
 except
  maxkoef:=1;
  setlength(clientCoef,2);
  ClientCoef[0]:=1;
  ClientCoef[1]:=1;
 end;


   ClientData.UserName:= IniFile.ReadString('Client','UserName','user');
     ClientData.ClientCode:= IniFile.ReadString('Client','ClientCode','55');
     ClientData.ClientPhone:=IniFile.ReadString('Client','ClientPhone','');

     
   ClientData.OrdersCount:= IniFile.ReadInteger('Client','OrdersCount',0);

   //Получаем настрокйки соединения
     ClientData.UseProxy   := IniFile.readBool('Connection','UseProxy',False);
  ClientData.ProxyType   := IniFile.readinteger('Connection','ProxyType',-1);
  ClientData.ProxyHost  := IniFile.readString('Connection','ProxyHost','');
  ClientData.ProxyPort  := IniFile.readInteger('Connection','ProxyPort',0);
  ClientData.ProxyLogin := IniFile.readString('Connection','ProxyLogin','');
  ClientData.ProxyPass  := IniFile.readString('Connection','ProxyPass','');

   ClientData.user_id:= strtoi(IniFile.ReadString('Client','User_id','55'));
   if (Length(ClientData.UserName) =0) then
 //  if (ClientData.user_id = 55) then
    begin
       ShowMessage('Для продолжения работы заполните наименование фирмы нажмите НАСТРОЙКА->ПЕРСОНАЛЬНЫЕ"!');
    //   IniFile.WriteString('Client','User_id',IntToStr(55))
    end;

  Pricegrid.Cells[col_idtovar,0]:='№';
  Pricegrid.Cells[col_codtovar,0]:='Код';
  Pricegrid.Cells[col_tovarname,0]:='Товар';
  Pricegrid.Cells[ col_macker,0]:='Завод';
  Pricegrid.Cells[col_codser,0]:='Код с';
  Pricegrid.Cells[col_goodnes,0]:='Годен';
  Pricegrid.Cells[col_numser,0]:='Серия';
  Pricegrid.Cells[col_prise,0]:='Цена';
  Pricegrid.Cells[col_number,0]:='Склад';
  Pricegrid.Cells[col_group,0]:='Группа';
  Pricegrid.Cells[col_zakaz,0]:='Заказ';
  Pricegrid.Cells[col_summa,0]:='Сумма';
  Pricegrid.Cells[col_zn,0]:='ЖВ';
  Pricegrid.Cells[col_regkr,0]:='';
    Pricegrid.Cells[col_cost_min,0]:='';
      Pricegrid.Cells[col_cost_max,0]:='';
   
 IniFile.Destroy;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
 if Form1.Width<800 then Form1.Width:=800;
 if Form1.Height<550 then Form1.Height:=550;

   PriceGrid.ColWidths[col_idtovar]:=0;
   PriceGrid.ColWidths[col_codTovar]:=0;
   PriceGrid.ColWidths[col_tovarname]:=PriceGrid.ClientWidth-567;
   PriceGrid.ColWidths[col_macker]:=150;
   PriceGrid.ColWidths[col_codser]:=0;
   PriceGrid.ColWidths[col_goodnes]:=60;
   PriceGrid.ColWidths[col_numser]:=75;
   PriceGrid.ColWidths[col_prise]:=60;
   PriceGrid.ColWidths[col_number]:=60;
   PriceGrid.ColWidths[col_group]:=0;
   PriceGrid.ColWidths[col_zakaz]:=60;
   PriceGrid.ColWidths[col_summa]:=60;
   PriceGrid.ColWidths[col_zn]:=27;
   PriceGrid.ColWidths[col_regkr]:=0;
   PriceGrid.ColWidths[col_cost_min]:=0;
   PriceGrid.ColWidths[col_cost_max]:=0;

   FindEdit.Top:=PriceGrid.Top;
   FindEdit.Left:=PriceGrid.Left;
   FindEdit.Width:=PriceGrid.ColWidths[col_tovarname];



     assignFile(PriceFile,ExeDir+'\Data/price.plm');
  If FileExists(ExeDir+'\Data/price.plm') Then
    reset(PriceFile)
  else
    rewrite(PriceFile);


    loadprice;

end;


//Обработчик нажатия кнопок
procedure TForm1.PricegridKeyPress(Sender: TObject; var Key: Char);
var row:integer;
    i:integer;
    s:boolean;
begin

  if Key  in ['0','1','2','3','4','5','6','7','8','9'] then
  begin
  s:=True;
        PriceGridSelectCell(Sender,10,PriceGrid.Row,s);
      zakazEdit.SelectAll;
        zakazEdit.Value:=0;
       zakazEdit.Text:=Key;
       zakazEdit.SelStart:=2;
  end
  else
  begin
  if Ord(key)=8 then
    findEdit.Text:=copy(findEdit.Text,1,length(findEdit.Text)-1)

  else
  findEdit.Text:=findEdit.Text+Key;
  findEdit.Visible:=True;

  Timer1.Enabled:=False;
  row:=0;
  i:=1;

  while (row=0 ) and (i<PriceGrid.RowCount-2) do
  begin
     if Pos(AnsiUpperCase(findEdit.Text),AnsiUpperCase(PriceGrid.Cells[2,i]))=1 Then
      begin
       row:=i;
      end;
   i:=i+1;
  end;
    Timer1.Enabled:=True;
  if row>0 Then
    PriceGrid.row:=Row;
    end;

end;


procedure TForm1.PriceGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  R: TRect;
  price:real;
begin
   Label2.Caption:=PriceGrid.Cells[col_tovarname,Arow];
   Label4.Caption:=PriceGrid.Cells[col_macker,Arow];
   Label9.Caption:=PriceGrid.Cells[col_numser,Arow]+ ' до '+PriceGrid.Cells[col_goodnes,Arow];
   Label10.Caption:=PriceGrid.Cells[col_prise,Arow];
   Label12.Caption:=PriceGrid.Cells[col_regkr,Arow];

   try
     price:=strtofloat(PriceGrid.Cells[col_prise,Arow]);
   except
     price:=0;
   end;
//    if (PriceGrid.Cells[col_zn,PriceGrid.Row] = '*') and (price*(1+AptNac.Value/100) > 100)   then
//    ShowMessage('Tova ZN bolee');
  PriceWithNac.Caption:=floattostrf(price*(1+AptNac.Value/100),fffixed,7,2);

  if ((ACol = col_zakaz) and (ARow <> 0)) then
  begin
    R := PriceGrid.CellRect(ACol, ARow); R.Left := R.Left + PriceGrid.Left;
    R.Right := R.Right + PriceGrid.Left; R.Top := R.Top + PriceGrid.Top;
    R.Bottom := R.Bottom + PriceGrid.Top; ZakazEdit.Left := R.Left + 1;
    ZakazEdit.Top := R.Top + 1; ZakazEdit.Width := (R.Right + 1) - R.Left;
    ZakazEdit.Height := (R.Bottom + 1) - R.Top;
    try
      ZakazEdit.Text:=PriceGrid.Cells[col_zakaz,PriceGrid.Row];
      if (PriceGrid.Cells[col_number,PriceGrid.Row] = '*')   then
        ZakazEdit.maxValue:=999
      else
        ZakazEdit.maxValue:=strtoint(PriceGrid.Cells[col_number,PriceGrid.Row]);
    except
    end;
      ZakazEdit.Visible := True; ZakazEdit.SetFocus;
  end;
  CanSelect := True;
end;

procedure TForm1.LoadPrice;
var i   :integer;
    Rec :PriceRecord;
begin
  PriceGrid.RowCount:=2;
  PriceGrid.RowCount:=filesize(PriceFile);
  //ShowMessage(IntToStr(PriceGrid.RowCount));
  for i:=0 to filesize(PriceFile)-1 do
  begin
    seek(PriceFile,i);
    read(PriceFile,Rec);
    Pricegrid.Cells[col_idtovar,i+1]:='';
    Pricegrid.Cells[col_codtovar,i+1]:=Rec.code;
    Pricegrid.Cells[col_tovarname,i+1]:=Rec.name;
    Pricegrid.Cells[col_macker,i+1]:=Rec.Maker;
    Pricegrid.Cells[col_codser,i+1]:=Rec.Codser;
    Pricegrid.Cells[col_goodnes,i+1]:=Rec.Goden;
    Pricegrid.Cells[col_numser,i+1]:=Rec.Seria;
    if Rec.Group>maxkoef Then
      Pricegrid.Cells[col_prise,i+1]:=floattostr(Rec.Price)
    else
      begin
        Pricegrid.Cells[col_prise,i+1]:=floattostrf(Rec.Price*clientcoef[Rec.group],fffixed,7,2);
        if StrToFloat(Pricegrid.Cells[col_prise,i+1]) < rec.cost_min then
          Pricegrid.Cells[col_prise,i+1]:=FloatToStr(rec.cost_min);

        if (StrToFloat(Pricegrid.Cells[col_prise,i+1]) > rec.cost_max) and (rec.cost_max > 0) then
          Pricegrid.Cells[col_prise,i+1]:=FloatToStr(rec.cost_max);
      end;
    if Rec.Count*Rec.Price > 4000 Then
        Pricegrid.Cells[col_number,i+1]:='*'
    else
    Pricegrid.Cells[col_number,i+1]:=inttostr(Rec.Count);
    Pricegrid.Cells[col_group,i+1]:=inttostr(Rec.Group);

    Pricegrid.Cells[col_zakaz,i+1]:='';
    if Rec.Zakaz>0 then
    begin
      Pricegrid.Cells[col_zakaz,i+1]:=inttostr(Rec.Zakaz);
    end;

    Pricegrid.Cells[col_summa,i+1]:='';
    if Rec.summa >0 then
    begin
      Pricegrid.Cells[col_summa,i+1]:=floattostr(Rec.summa);
    end;

    Pricegrid.Cells[col_zn,i+1]:=Rec.ZN;
    Pricegrid.Cells[col_regkr,i+1]:=Rec.RegKR;
  end;

  PriceGrid.Enabled:=True;
  Form1.Caption:='Электронный заказ товаров. Прайс дист от '+ClientData.PriceDate+'. Кол-во товаров: '+inttostr(i);
end;

function TForm1.deleteDelimeter(Delimeter: string; var str: string): string;
begin
  result:=Copy(PChar(str),1,Pos(Delimeter,str)-2);
  delete(result,1,1);
  Delete(str,1,Pos(Delimeter,str));
end;

procedure TForm1.LoadNewPrice;
var pFile:TextFile;
    str:string;
    i:integer;
    rec:PriceRecord;
    iniFile:TiniFile;
    s:string;
begin
  if not fileexists(ExeDir+'Data/Inbox/data.csv') then
    exit;
  try
    closeFile(PriceFile);
    assignFile(PriceFile,ExeDir+'Data/price.plm');
    rewrite(PriceFile);

    assignFile(PFile,ExeDir+'Data/Inbox/data.xml');
    Reset(PFile);
    readln(PFile,str);
    i:=0;
    while not Eof(PFile) do
    begin
      readln(PFile,str);
      s:=str;
      DeleteDelimeter(';',str);
      Rec.code:=DeleteDelimeter(';',str);
      Rec.name:=DeleteDelimeter(';',str);
      Rec.Maker:=DeleteDelimeter(';',str);
      Rec.Codser:=DeleteDelimeter(';',str);
      Rec.Goden:=DeleteDelimeter(';',str);
      Rec.Seria:=DeleteDelimeter(';',str);
      try
      Rec.Price:=strtof(DeleteDelimeter(';',str));
      Rec.Count:=strtoint(DeleteDelimeter(';',str));
      Rec.Group:=strtoint(DeleteDelimeter(';',str));
      Rec.ZN:=DeleteDelimeter(';',str);
      Rec.RegKR:=DeleteDelimeter(';',str);
      Rec.cost_min:=strtof(DeleteDelimeter(';',str));
      Rec.cost_max:=strtof(DeleteDelimeter(';',str));

      except
      end;

     // delete(str,Length(str),1);
     // delete(str,1,1);
     // Rec.RegKR:=str;
      

//      Rec.Group:=strtoint(str);
      Rec.zakaz:=0;
      Rec.Summa:=0;
      seek(PriceFile,i);
      write(PriceFile,Rec);
      i:=i+1;
    end;
    closeFile(PFile);
    DeleteFile(ExeDir+'Data/Inbox/data.csv');
    try
    IniFile:=TIniFile.Create(ExeIni);
    Inifile.WriteString('Client','PriceDate',datetoStr(now));
    ClientData.PriceDate:=datetoStr(now);
    IniFile.Free;
    except
    end;
  except
    ShowMessage('При приемке прайс листа произошла попробуйте еще раз, если ошибка повторится свяжитесь со службой подержки');
//        ShowMessage(s);
  end;
  closeFile(PriceFile);
    assignFile(PriceFile,ExeDir+'Data/price.plm');
    reset(PriceFile);
  LoadPrice;
end;

procedure TForm1.ClearOrder;
var i:integer;
Rec:PriceRecord;
begin
  for i:=1 to PriceGrid.RowCount-1 do
              begin
                if Trim(PriceGrid.Cells[col_zakaz,i])<>'' then
                  begin
                     seek(PriceFile,i-1);
                     read(PriceFile,Rec);
                     Rec.zakaz:=0;
                     Rec.Summa:=0;
                     seek(PriceFile,i-1);
                     write(PriceFile,Rec);
                     PriceGrid.Cells[col_zakaz,i]:='';
                     PriceGrid.Cells[col_summa,i]:='';
                  end;
  end
end;

procedure TForm1.PriceGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var s:boolean;
begin
 if Key=vk_Space then
  begin
        s:=True;
        PriceGridSelectCell(Sender,10,PriceGrid.Row,s);
  end;
end;



procedure TForm1.ZakazEditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=vk_Return then
  begin
     ZakazEdit.Visible := False;   PriceGrid.SetFocus;
  end;
end;

procedure TForm1.ZakazEditEnter(Sender: TObject);
var i:integer;
begin
 try
    ZakazEdit.SelectAll;
    ZakazEdit.Text:=PriceGrid.Cells[col_zakaz,PriceGrid.Row];
  //  ZakazEdit.Text:='';
//    zakazEdit.Value:=0;

//   ZakazEdit.Text:=inttostr(strtoi(PriceGrid.Cells[col_zakaz,PriceGrid.Row]));
 except
 end;
end;

procedure TForm1.PriceGridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=vk_Return then
  begin
     ZakazEdit.Visible := False;   PriceGrid.SetFocus;
  end;
end;

procedure TForm1.PriceGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  var sumatsklad:real;
begin
if aRow=0 Then
  begin
     with TStringGrid(Sender), Canvas do
        begin
          font.Style:=[fsbold];
          TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Cells[aCol, aRow]);
          //  Form1.Canvas.Brush.Color := clBlack;
          //  Form1.Canvas.FrameRect(TheRect);
         end;

   end
else
  begin
    if Integer(PriceGrid.cells[col_ZAKAZ,aRow])>0 Then
    begin
      with TStringGrid(Sender), Canvas do
      begin
        Brush.Color :=14728997;
        FillRect(Rect);
        TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Cells[aCol, aRow]);
      end;
    end;



  end;
end;
procedure TForm1.ZakazEditExit(Sender: TObject);
var Rec:PriceRecord;
begin
  try
     try
     if PriceGrid.Cells[col_number,PriceGrid.Row]<>'*' Then
      if ZakazEdit.Value>strtoi(PriceGrid.Cells[col_number,PriceGrid.Row]) then
          ZakazEdit.Value:=strtoi(PriceGrid.Cells[col_number,PriceGrid.Row]);
     except
     end;
     PriceGrid.Cells[col_zakaz,PriceGrid.Row] := ZakazEdit.Text;
     ZakazEdit.Visible := False; PriceGrid.SetFocus;
     If ZakazEdit.Value=0 Then
       begin
        PriceGrid.Cells[col_zakaz,PriceGrid.Row] :='';
        PriceGrid.Cells[col_summa,PriceGrid.Row] :='';
       end
     else
     begin
       PriceGrid.Cells[col_summa,PriceGrid.Row] :=floattostr(ZakazEdit.value*strtof(PriceGrid.Cells[col_prise,PriceGrid.Row]));
      end;
    try
     seek(PriceFile,PriceGrid.Row-1);
     read(PriceFile,Rec);
     Rec.zakaz:=ZakazEdit.value;
     Rec.Summa:=ZakazEdit.value*strtof(PriceGrid.Cells[col_prise,PriceGrid.Row]);
     seek(PriceFile,PriceGrid.Row-1);
     write(PriceFile,Rec);
    except
    end;

  except
  end;

end;

procedure TForm1.N14Click(Sender: TObject);
begin
close;
end;

procedure TForm1.N11Click(Sender: TObject);
begin
About.ShowModal;
end;

procedure TForm1.ToolButton1Click(Sender: TObject);
var str:string;
k,i:integer;
begin
   memo2.Lines.Clear;
  memo2.Lines.Add('<?xml version="1.0" encoding="windows-1251"?>');
  memo2.Lines.Add('<orders>');
  str:='<order idorder="'+inttostr(ClientData.OrdersCount+1)+'" datedoc="'+DateTostr(Now)+'" timedoc="'+Timetostr(Now);
  str:=str+'" usercod="'+ClientData.ClientCode+'" contractor="'+STRtoXML(ClientData.ClientName)+'" username="'+STRtoXML(ClientData.UserName)+'" comment="" user_id="'+IntToStr(ClientData.user_id)+'">';
  memo2.Lines.Add(str);
   k:=0;
  for i:=1 to PriceGrid.RowCount-1 do
  begin
    if Trim(PriceGrid.Cells[col_zakaz,i])<>'' then
    begin
      str:='<line codtovar="'+  PriceGrid.Cells[col_codtovar,i]+'" codser="'+  PriceGrid.Cells[col_codser,i];
      str:=str+'" numser="'+  PriceGrid.Cells[col_numser,i]+'" tovarname="'+  PriceGrid.Cells[col_tovarname,i];
      str:=str+'" prise="'+  PriceGrid.Cells[col_prise,i]+'" number="'+  PriceGrid.Cells[col_zakaz,i]+'"/>';
      memo2.Lines.Add(str);
      k:=k+1;
    end;
  end;
  memo2.Lines.Add('</order>');
  memo2.Lines.Add('</orders>');
  if k>0 Then
  begin
      memo2.Lines.SaveToFile(exeDir+'Data\OrdersNew\'+IntToStr(ClientData.OrdersCount+1)+'.xml');
      Zakaz.showModal;
  end
  else
    ShowMessage('Для оформления заказа необходимо выбрать товар!');


end;

procedure TForm1.N12Click(Sender: TObject);
begin
PersonalSettings.showmodal;
end;

procedure TForm1.IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin
  ProgressBar1.Position:=AWorkCount;
  Label11.Caption:='Получено '+inttostr(AWorkCount) +'  б из  '+inttostr(ProgressBar1.Max)+'  б ';
  Refresh;
end;

procedure TForm1.IdHTTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
begin
if AWorkCountMax <=0 then
  ProgressBar1.Max:=1000000
  else
  ProgressBar1.Max:=AWorkCountMax;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
  ClearOrder;
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin
      Zakaz.showModal;
end;

end.
