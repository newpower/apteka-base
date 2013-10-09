unit options;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,mainspace,inifiles;

type
  TPersonalSettings = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ClientName: TEdit;
    ClientPhone: TEdit;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    ClientCode: TEdit;
    Label4: TLabel;
    ServerEdit: TEdit;
    GroupBox3: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label9: TLabel;
    UseProxy: TCheckBox;
    Label10: TLabel;
    ProxyHostEdit: TLabeledEdit;
    ProxyPortEdit: TLabeledEdit;
    ProxyUserEdit: TLabeledEdit;
    ProxyPasswordEdit: TLabeledEdit;
    FtpProxyType: TComboBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PersonalSettings: TPersonalSettings;

implementation

{$R *.dfm}

procedure TPersonalSettings.BitBtn1Click(Sender: TObject);
var IniFile:TIniFile;
begin
  if (ClientName.Text = '') then
  begin
    ShowMessage('Необходимо заполнить поле "Наименование Вашей фирмы"!');
    Label1.Font.Color:=clRed;
    ClientName.SetFocus;
    exit;

  end
  else
  begin
   ClientData.UserName:=ClientName.Text;
   ClientData.ClientPhone:=ClientPhone.Text;
   ClientData.ClientCode:=ClientCode.Text;

   ClientData.Server:= ServerEdit.Text;

   ClientData.UseProxy:= UseProxy.Checked;
   ClientData.ProxyHost:= ProxyHostEdit.Text;
  if Length(ProxyPortEdit.Text) >0  then
  ClientData.ProxyPort:= StrToInt(ProxyPortEdit.Text);
  ClientData.ProxyLogin:= ProxyUserEdit.Text;
  ClientData.ProxyType := FtpProxyType.ItemIndex;
  clientdata.ProxyPass:=ProxyPasswordEdit.Text;

   IniFile:=TIniFile.Create(ExeIni);
   IniFile.WriteString('Client','UserName',ClientData.UserName);
 IniFile.WriteString('Client','ClientPhone',ClientData.ClientPhone);
  IniFile.WriteString('Client','ClientCode',ClientData.ClientCode);

   IniFile.WriteString('Connection','Server',ClientData.Server);
 IniFile.WriteBool('Connection','UseProxy',ClientData.UseProxy);
 IniFile.WriteString('Connection','ProxyHost',ClientData.ProxyHost);
 IniFile.WriteInteger('Connection','ProxyPort',ClientData.ProxyPort);
 IniFile.WriteString('Connection','ProxyLogin',ClientData.ProxyLogin);
  IniFile.WriteInteger('Connection','ProxyType', ClientData.ProxyType);

 IniFile.WriteString('Connection','ProxyPass',ClientData.ProxyPass);
  IniFile.Destroy;
   ShowMessage('Данные сохранены!');
   Close;
   //Exit;
  end;

end;

procedure TPersonalSettings.BitBtn2Click(Sender: TObject);
begin
   Close;
end;

procedure TPersonalSettings.FormShow(Sender: TObject);
begin
   ClientName.Text:=ClientData.UserName;
   ClientPhone.Text:=ClientData.ClientPhone;
   ClientCode.Text:=ClientData.ClientCode;

   ServerEdit.Text:= ClientData.Server;

   UseProxy.Checked:= ClientData.UseProxy;
   ProxyHostEdit.Text:= ClientData.ProxyHost;
  //if Length(ClientData.ProxyPort) >0  then
  ProxyPortEdit.Text:= inttostr(ClientData.ProxyPort);
  ProxyUserEdit.Text:= ClientData.ProxyLogin;
  FtpProxyType.ItemIndex := ClientData.ProxyType;
  ProxyPasswordEdit.Text:=clientdata.ProxyPass;
end;

end.
