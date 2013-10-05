program Project1;

uses
  Forms,
  mainspace in 'mainspace.pas' {Form1},
  Unit2 in 'Unit2.pas' {About},
  FormZakaz in 'FormZakaz.pas' {Zakaz},
  options in 'options.pas' {PersonalSettings};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Программа Заказа Медикаментов';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TAbout, About);
  Application.CreateForm(TZakaz, Zakaz);
  Application.CreateForm(TPersonalSettings, PersonalSettings);
  Application.Run;
end.
