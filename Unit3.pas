unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids;

type
  TForm3 = class(TForm)
    StringGrid1: TStringGrid;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm3.FormShow(Sender: TObject);
var
  i, q : Integer;
begin
  q := UCP.noProcessos - 1;
  with StringGrid1 do
  begin
    if (UCP.TipoEscalonamento = 'P') or (UCP.TipoEscalonamento = 'O') then
      ColCount := 3
    else
      ColCount := 2;
      
    DefaultColWidth := 70;
    DefaultRowHeight:= 18;
    RowCount := UCP.noProcessos+1;
    Cells[0,0] := 'Nome';
    Cells[1,0] := 'Tempo UCP';
    Cells[2,0] := 'Prioridade';
    for i := 0 to q do
    begin
        Cells[0,i+1] := frmEscalonador.StringGrid1.Cells[0,i+1];
        Cells[1,i+1] := frmEscalonador.StringGrid1.Cells[1,i+1];
        Cells[2,i+1] := frmEscalonador.StringGrid1.Cells[4,i+1];
    end;
  end;
end;

procedure TForm3.BitBtn1Click(Sender: TObject);
var
  i, q : Integer;
begin
  q := UCP.noProcessos - 1;
  for i := 0 to q do
  begin
    Processo[i].tempoUCP := StrToInt(StringGrid1.Cells[1,i+1]);
    Processo[i].Prioridade := StrToInt(StringGrid1.Cells[2,i+1]);
  end;
  Close;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i, q : Integer;
begin
  q := UCP.noProcessos - 1;
  for i := 0 to q do
  begin
    if (StringGrid1.Cells[1,i+1] = '0') or (StringGrid1.Cells[1,i+1] = '0 ms')then
    begin
      MessageBox(0, 'Exitem colunas de Tempo UCP com valor 0. Adicione um valor entre 10 e 1000.', 'Erro', MB_ICONSTOP or MB_OK);
      Action := caNone;
      Break;
    end;
    if (UCP.TipoEscalonamento = 'P') or (UCP.TipoEscalonamento = 'O') then
      if (StringGrid1.Cells[2,i+1] = '0') then
      begin
        MessageBox(0, 'Exitem colunas de Prioridade com valor 0. Adicione um valor entre 1 e 31.', 'Erro', MB_ICONSTOP or MB_OK);
        Action := caNone;
        Break;
      end;
  end;
end;

end.
