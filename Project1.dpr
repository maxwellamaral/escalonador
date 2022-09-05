program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {frmEscalonador},
  Unit2 in 'Unit2.pas' {Form2},
  Unit3 in 'Unit3.pas' {Form3},
  Unit4 in 'Unit4.pas' {Form4},
  Unit5 in 'Unit5.pas' {Frame5: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Projeto Escalonador';
  Application.CreateForm(TfrmEscalonador, frmEscalonador);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
