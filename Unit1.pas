unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, Grids, ComCtrls, OleCtrls, Buttons,
  TeEngine, Series, TeeProcs, Chart, GanttCh, StrUtils, Unit5;
type
  TfrmEscalonador = class (TForm)
    btnCriar: TButton;
    btnExecuteEscalon: TButton;
    Button1: TButton;
    CheckBox1: TCheckBox;
    chkFixo: TCheckBox;
    Frame51: TFrame5;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblRelogio: TLabel;
    lblTimeSlice: TLabel;
    lblVelClock: TLabel;
    mmTermino: TMemo;
    mmUCP: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    sgEspera: TStringGrid;
    sgPronto: TStringGrid;
    SpinEdit1: TSpinEdit;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TimerUCP: TTimer;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    procedure btnCriarClick(Sender: TObject);
    procedure btnExecuteEscalonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Frame51Chart1DblClick(Sender: TObject);
    procedure MudarParam(Sender: TObject);
    procedure ProcessoTimer(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
  private
    procedure LimparGrid(Grid: TStringGrid);
  public
    TempoMaximoUCP: Integer;
  end;
  
// Classe Processo
type
  TProcesso = class (TObject)
    Ativo: Boolean;
    Cor: TColor;
    EsperaOk: Boolean;
    ID: Integer;
    Nome: string[4];
    Prioridade: Byte;
    RelogioFim: Integer;
    RelogioInit: Integer;
    tempoEspera: Integer;
    tempoExecuteTemp: Integer;
    tempoTurnaround: Integer;
    tempoUCP: Integer;
    Terminado: Boolean;
  end;
  
type
  TUcp = class (TObject)
    EsperaVazio: Boolean;
    isVazio: Boolean;
    noProcessos: Byte;
    P: TProcesso;
    Relogio: Integer;
    TimeSlice: Integer;
    TimeSliceFixo: Integer;
    TipoEscalonamento: Char;
  public
    FilaCriacao: array of TProcesso;
    FilaEspera: array of TProcesso;
    FilaPronto: array of TProcesso;
    procedure ColocarNaFilaPronto(var Q: TProcesso);
    function ContarNoMaxPrioridades(var Q: array of Tprocesso): Integer;
    procedure CopiarFilas(var O: array of TProcesso;var D: array of TProcesso);
    procedure CriarProcessos(noProcessos: Byte);
    procedure DecrementarProcEmEspera;
    procedure EscalonamentoInicio;
    function EsperaIsVazio: Boolean;
    procedure EstadoEspera;
    procedure IncTurnAroundFilaPronto;
    procedure Inicializar;
    function MenorPrioridade(var Q: array of TProcesso): Integer;
    procedure OrdenarFilaPronto;
    procedure OrdenarProcessos(por: Char);
    procedure PreecherGrid(Grid: TStringGrid; P: array of TProcesso; tamP: 
            Integer);
    function ProntoIsVazio: Boolean;
    procedure ReorganizarFilaPronto;
  end;
  
var
  frmEscalonador: TfrmEscalonador;
  Processo: array of TProcesso;
  UCP: TUcp;

implementation

uses Math, DateUtils, Unit2, Unit3, Unit4;

{$R *.dfm}

{
******************************* TfrmEscalonador ********************************
}
procedure TfrmEscalonador.btnCriarClick(Sender: TObject);
begin
  btnCriar.Enabled := False;
  GroupBox1.Enabled := True;
  lblVelClock.Caption := FloatToStr(1000/TimerUCP.Interval) + ' Hz';
  Label9.Caption := IntToStr(TrackBar2.Position);
  with mmTermino do
  begin
    Clear;
    Lines.Add('RELATÓRIO FINAL DO ESTADO DE TÉRMINO');
    Lines.Add(' ');
  end;
  mmUCP.Clear;
  Frame51.Series1.Clear;
  UCP.Inicializar;
end;

procedure TfrmEscalonador.btnExecuteEscalonClick(Sender: TObject);
begin
  if btnExecuteEscalon.Caption = 'Parar' then
  begin
    TimerUCP.Enabled := False;
    GroupBox1.Enabled := False;
    btnExecuteEscalon.Caption := 'Executar ' +
      RadioGroup1.Items[RadioGroup1.ItemIndex];
  end
  else
  begin
    UCP.EscalonamentoInicio;
    TimerUCP.Enabled := True;
    GroupBox1.Enabled := True;
    btnExecuteEscalon.Caption := 'Parar';
  end;
end;

procedure TfrmEscalonador.Button1Click(Sender: TObject);
begin
  Form2.ShowModal;
  TempoMaximoUCP := Form2.SpinEdit1.Value;
end;

procedure TfrmEscalonador.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
begin
  for i := 0 to (UCP.noProcessos - 1) do
    Processo[i].Free;
  UCP.Free;
end;

procedure TfrmEscalonador.FormCreate(Sender: TObject);
begin
  UCP := TUcp.Create; // Cria o objeto UCP
end;

procedure TfrmEscalonador.FormShow(Sender: TObject);
begin
  TempoMaximoUCP := Form2.SpinEdit1.Value;
end;

procedure TfrmEscalonador.Frame51Chart1DblClick(Sender: TObject);
begin
  Form4.Show;
end;

procedure TfrmEscalonador.LimparGrid(Grid: TStringGrid);
var
  x, y: Integer;
begin
  for x := 0 to Grid.ColCount do
    for y := 0 to Grid.RowCount do
      grid.Cells[x,y] := NullAsStringValue;
end;

procedure TfrmEscalonador.MudarParam(Sender: TObject);
begin
  if btnCriar.Enabled = False then btnCriar.Enabled := True;
  btnExecuteEscalon.Caption := ' ';
end;

procedure TfrmEscalonador.ProcessoTimer(Sender: TObject);
begin
  Randomize;
  //Não existe preempção no FIFO
  with UCP do
  begin
    // Se tempo de Execucao expira
    if (P.tempoExecuteTemp = 0) and not (P.EsperaOk)
    then begin
         //****Vá para estado de espera
           EstadoEspera;
          //Entra Proximo Processo
  
          //Reorganiza a Fila de Pronto por Prioridades
          if (TipoEscalonamento = 'P') or (TipoEscalonamento = 'O') then
          begin
            UCP.OrdenarFilaPronto;
          end;
          P.RelogioFim := Relogio;
          Frame51.Series1.AddGanttColor(P.RelogioInit,P.RelogioFim,P.ID,P.Nome,P.Cor);
          Form4.Frame51.Series1.AddGanttColor(P.RelogioInit,P.RelogioFim,P.ID,P.Nome,P.Cor);
          P := FilaPronto[0];
          P.RelogioInit := Relogio;
          P.tempoExecuteTemp := RandomRange(0,P.tempoUCP);
          ReorganizarFilaPronto;
         end
    else begin
           if (P.tempoUCP > 0) then
           begin
              P.tempoUCP := P.tempoUCP - 1;
              P.tempoTurnaround := P.tempoTurnaround + 1;
              Relogio := Relogio + 1;
              // Escalonamento Circular
              if (TipoEscalonamento = 'C') or (TipoEscalonamento = 'O') then
              begin
                TimeSlice := TimeSlice - 1;
                frmEscalonador.lblTimeSlice.Caption :=
                  'TimeSlice ' + IntToStr(TimeSliceFixo) + ' ms - Restando: ' +
                  IntToStr(TimeSlice) + ' ms';
              end;
  
              // Se existe algum processo de menor prioridade na Fila de Pronto
              // Interrompe o processamento atual
              if (TipoEscalonamento = 'P') xor (TipoEscalonamento = 'O') then
              begin
                if P.Prioridade > MenorPrioridade(FilaPronto) then
                begin
                  ColocarNaFilaPronto(P);
                  P.RelogioFim := Relogio;
                  Frame51.Series1.AddGanttColor(P.RelogioInit,P.RelogioFim,P.ID,P.Nome,P.Cor);
                  Form4.Frame51.Series1.AddGanttColor(P.RelogioInit,P.RelogioFim,P.ID,P.Nome,P.Cor);
                  P := FilaPronto[0];
                  P.RelogioInit := Relogio;
                  OrdenarFilaPronto;
                  ReorganizarFilaPronto;
                end;
              end;
  
              if not P.Terminado then
                P.tempoExecuteTemp := P.tempoExecuteTemp - 1;
              DecrementarProcEmEspera;
           end;
  
           // Processamento de Escalonamentos Circulares
           if TimeSlice < 0 then
           begin
              ColocarNaFilaPronto(P);
              P.RelogioFim := Relogio;
              Frame51.Series1.AddGanttColor(P.RelogioInit,P.RelogioFim,P.ID,P.Nome,P.Cor);
              Form4.Frame51.Series1.AddGanttColor(P.RelogioInit,P.RelogioFim,P.ID,P.Nome,P.Cor);
              P := FilaPronto[0];
              P.RelogioInit:= Relogio;
              ReorganizarFilaPronto;
              if (TipoEscalonamento = 'C') or (TipoEscalonamento = 'O') then
              begin
                if not chkFixo.Checked then
                  TimeSlice := RandomRange(10,frmEscalonador.TrackBar2.Position) // Time Slice será de 10 a 100 ms
                else
                  TimeSlice := frmEscalonador.TrackBar2.Position;
                TimeSliceFixo := TimeSlice;
              end
              else
                TimeSlice := 0; //não possui TimeSlice
              frmEscalonador.lblTimeSlice.Caption :=
               'TimeSlice ' + IntToStr(TimeSliceFixo) + ' ms';
           end;
  
           if (P.tempoUCP <=0) then
           begin
              //TODO: *****Vá para o estado de termino
              P.Terminado := True;
              P.EsperaOk := False;
              with mmTermino.Lines do
              begin
                Add('Nome do Processo: ' + P.Nome);
                Add('Tempo de Turnaround: ' +  IntToStr(P.tempoTurnaround) + ' ms');
                if (TipoEscalonamento = 'P') xor (TipoEscalonamento = 'O') then
                  Add('Prioridade: ' + IntToStr(P.Prioridade));
                Add(' ');
              end;
  
              P.RelogioFim := Relogio;
              Frame51.Series1.AddGanttColor(P.RelogioInit,P.RelogioFim,P.ID,P.Nome,P.Cor);
              Form4.Frame51.Series1.AddGanttColor(P.RelogioInit,P.RelogioFim,P.ID,P.Nome,P.Cor);
  
              if not ProntoIsVazio then
              begin
                P := FilaPronto[0];
                P.RelogioInit := Relogio;
                ReorganizarFilaPronto;
              end;
  
              if ProntoIsVazio and P.Terminado {and EsperaVazio} then
              begin
                TimerUCP.Enabled := False;
                MessageBox(0, 'Processamento Terminado.', 'Prontinho!', MB_ICONASTERISK or MB_OK);
                with mmTermino.Lines do
                begin
                  Add(' ');
                  Add('--------------------------------------------');
                  Add('Total de Processos: ' + IntToStr(noProcessos));
                end;
              end;
           end;
         end;
         if P <> nil then
         begin
            mmUCP.Clear;
            mmUCP.Lines.Add('Processo: ' + P.Nome + #13);
            mmUCP.Lines.Add('Tempo UCP: ' + IntToStr(P.tempoUCP) + ' ms');
            mmUCP.Lines.Add('Tempo de Turnaround: ' + IntToStr(P.tempoTurnaround) + ' ms');
            mmUCP.Lines.Add('Prioridade: ' + IntToStr(P.Prioridade));
         end;
  end;
end;

procedure TfrmEscalonador.TrackBar1Change(Sender: TObject);
begin
  TimerUCP.Enabled := False;
  TimerUCP.Interval := TrackBar1.Position;
  lblVelClock.Caption := FloatToStr(1000/TimerUCP.Interval) + ' Hz';
  TimerUCP.Enabled := True;
end;

procedure TfrmEscalonador.TrackBar2Change(Sender: TObject);
begin
  Label9.Caption := IntToStr(TrackBar2.Position);
end;

{-----------------------------------------------------------------------------
  Procedimento: CopiarFilas
  Autor:         Maxwell Anderson Ielpo do Amaral
  Data:         16-out-2005
  Argumentos:   var O, D: array of TProcesso
  Result:       None

  Copia Filas entre si

-----------------------------------------------------------------------------}
{
************************************* TUcp *************************************
}
procedure TUcp.ColocarNaFilaPronto(var Q: TProcesso);
var
  i: Integer;
begin
  for i := 0 to noProcessos - 1 do
    if FilaPronto[i] = nil then
    begin
      FilaPronto[i] := Q;
      //TODO: Preenche a grade de Pronto
      Break;
    end;
  PreecherGrid(frmEscalonador.sgPronto,FilaPronto,noProcessos - 1);
end;

function TUcp.ContarNoMaxPrioridades(var Q: array of Tprocesso): Integer;
var
  max, i: Integer;
begin
  max := 0;
  for i := 0 to noProcessos -1 do
    if Q[i].Prioridade > max then
      max := Q[i].Prioridade;
  Result := max;
end;

procedure TUcp.CopiarFilas(var O: array of TProcesso;var D: array of TProcesso);
var
  i: Integer;
begin
  for i := 0 to UCP.noProcessos - 1 do
    D[i] := O[i];
end;

procedure TUcp.CriarProcessos(noProcessos: Byte);
var
  i: Integer;
begin
  //Define tamanho da fila de processos a serem criados
  SetLength(Processo, noProcessos);
  with frmEscalonador do
  begin
    I := RadioGroup1.ItemIndex;
    case I of
      0: TipoEscalonamento := 'C';
      1: TipoEscalonamento := 'P';
      2: TipoEscalonamento := 'O';
      3: TipoEscalonamento := 'F';
    end;
    btnExecuteEscalon.Caption := 'Executar ' + RadioGroup1.Items[I];
  end;
  Randomize;
  for i := 0 to noProcessos - 1 do
  begin
      Processo[i] := TProcesso.Create;
      Processo[i].Nome := 'P' +  IntToStr(i);
      Processo[i].ID := i;
      Processo[i].Ativo := True;
      Processo[i].tempoExecuteTemp := 0;
      Processo[i].Terminado := False;
      Processo[i].EsperaOk := False;
      Processo[i].Cor := RGB(Random(254),Random(254),Random(254));
      Processo[i].tempoEspera := 0;
      Processo[i].tempoTurnaround := 0;
  
      if not frmEscalonador.CheckBox1.Checked then
        Processo[i].tempoUCP := RandomRange(10,frmEscalonador.TempoMaximoUCP);
  
      if (UCP.TipoEscalonamento = 'P') or (UCP.TipoEscalonamento = 'O') then
      begin
        if not frmEscalonador.CheckBox1.Checked then
          Processo[i].Prioridade := RandomRange(1,31)
      end
      else
        Processo[i].Prioridade := 0; //sem prioridade
  end;
  if frmEscalonador.CheckBox1.Checked then
    Form3.ShowModal;
  PreecherGrid(frmEscalonador.StringGrid1,Processo, noProcessos);
end;

procedure TUcp.DecrementarProcEmEspera;
var
  i: Integer;
begin
  for i := 0 to noProcessos - 1 do
  begin
    if FilaEspera[i] <> nil then
    begin
      FilaEspera[i].tempoEspera := FilaEspera[i].tempoEspera - 1;
      FilaEspera[i].tempoTurnaround := FilaEspera[i].tempoTurnaround + 1;
      if FilaEspera[i].tempoEspera <= 0 then
      begin
        ColocarNaFilaPronto(FilaEspera[i]);
        FilaEspera[i] := nil;
      end;
    end;
  end;
  PreecherGrid(frmEscalonador.sgEspera,FilaEspera,noProcessos-1);
end;

procedure TUcp.EscalonamentoInicio;
begin
  OrdenarProcessos(TipoEscalonamento);
  CopiarFilas(FilaCriacao, FilaPronto);
  PreecherGrid(frmEscalonador.sgPronto,FilaPronto,noProcessos);
  P := TProcesso.Create;
  P := FilaPronto[0];
  
  with frmEscalonador do
  begin
    if (RadioGroup1.ItemIndex = 0) or (RadioGroup1.ItemIndex = 2) then
    begin
      if not chkFixo.Checked then
        TimeSlice := RandomRange(10,frmEscalonador.TrackBar2.Position) // Time Slice será de 10 a 100 ms
      else
        TimeSlice := frmEscalonador.TrackBar2.Position;
      TimeSliceFixo := TimeSlice;
    end;
  end;
  
  ReorganizarFilaPronto;
  Randomize;
  P.RelogioInit := Relogio;
  P.tempoExecuteTemp := RandomRange(0,P.tempoUCP);
  frmEscalonador.TimerUCP.Enabled := True;
end;

function TUcp.EsperaIsVazio: Boolean;
var
  i: Integer;
  R: Boolean;
begin
  R := True;
  for i := 0 to noProcessos - 1 do
    if FilaEspera[i] <> nil then
      R := False;
  Result := R;
end;

procedure TUcp.EstadoEspera;
var
  i: Integer;
begin
  for i := 0 to noProcessos - 1 do
  begin
    if FilaEspera[i] = nil then
    begin
      FilaEspera[i] := TProcesso.Create;
      FilaEspera[i] := P;
      FilaEspera[i].tempoEspera := RandomRange(0,FilaEspera[i].tempoUCP);
      FilaEspera[i].EsperaOk := True;
      Break;
    end;
  end;
end;

procedure TUcp.IncTurnAroundFilaPronto;
var
  i: Integer;
begin
  for i := 0 to noProcessos - 1 do
    if FilaPronto[i] <> nil then
      FilaPronto[i].tempoTurnaround := FilaPronto[i].tempoTurnaround + 1;
end;

procedure TUcp.Inicializar;
var
  I: Integer;
begin
  
  // Cria as Filas de acordo com o numero de processos
  noProcessos := frmEscalonador.SpinEdit1.Value;
  CriarProcessos(noProcessos);
  SetLength(FilaCriacao,noProcessos);
  SetLength(FilaEspera, noProcessos);
  SetLength(FilaPronto, noProcessos);
  for i := 0 to noProcessos - 1 do
  begin
    FilaCriacao[i]:= TProcesso.Create;
    FilaPronto[i] := TProcesso.Create;
  end;
  
  EsperaVazio := True;
  ProntoIsVazio;
  Relogio := 0;
  TimeSlice := 0;
  frmEscalonador.lblTimeSlice.Caption := 'TimeSlice ' + IntToStr(TimeSlice) + ' ms';
  //Estado de Execução está vazio
  isVazio := True;
  //Transfere os processos criados para o estado de Criação
  CopiarFilas(Processo,FilaCriacao);
end;

function TUcp.MenorPrioridade(var Q: array of TProcesso): Integer;
var
  Min, i: Integer;
begin
  Min := 100;
  if Q[i] <> nil then
    for i := 0 to noProcessos -1 do
      if Q[i].Prioridade < min then
        Min := Q[i].Prioridade;
    Result := Min;
end;

procedure TUcp.OrdenarFilaPronto;
var
  I, J: Integer;
  Aux: TProcesso;
begin
  for J := 1 to (noProcessos - 1) do
    if  (UCP.FilaPronto[J] <> nil) then
    begin
      Aux := UCP.FilaPronto[J];
      I := J - 1;
        while (I <> 0) and (Aux.Prioridade <= UCP.FilaPronto[I].Prioridade) do
      begin
        UCP.FilaPronto[I + 1] := UCP.FilaPronto[I];
        I := I - 1;
      end;
      if Aux.Prioridade > UCP.FilaPronto[I].Prioridade
        then UCP.FilaPronto[I + 1] := Aux
        else begin
             UCP.FilaPronto[I + 1] := UCP.FilaPronto[I];
             UCP.FilaPronto[I] := Aux;
             end;
    end;
    PreecherGrid(frmEscalonador.sgPronto,FilaPronto, noProcessos - 1);
end;

procedure TUcp.OrdenarProcessos(por: Char);
var
  I, J: Integer;
  Aux: TProcesso;
begin
  //ordenar pelo tempo de UCP ou por prioridade na fila de criação.
  if (por = 'P') or (por = 'O') then
  begin // Organiza por prioridades
    for J := 1 to (noProcessos - 1) do
    begin
      Aux := FilaCriacao[J];
      I := J - 1;
      while (I <> 0) and (Aux.Prioridade <= FilaCriacao[I].Prioridade) do
      begin
        FilaCriacao[I + 1] := FilaCriacao[I];
        I := I - 1;
      end;
  
      if Aux.Prioridade > FilaCriacao[I].Prioridade
        then FilaCriacao[I + 1] := Aux
        else begin
             FilaCriacao[I + 1] := FilaCriacao[I];
             FilaCriacao[I] := Aux;
             end;
    end;
  end;
  PreecherGrid(frmEscalonador.StringGrid2,FilaCriacao, noProcessos - 1);
end;

procedure TUcp.PreecherGrid(Grid: TStringGrid; P: array of TProcesso; tamP: 
        Integer);
var
  i, q: Byte;
begin
  frmEscalonador.LimparGrid(Grid);
  Grid.DefaultColWidth := 70;
  Grid.DefaultRowHeight:= 18;
  
  with Grid do
  begin
    ColCount := 5;
    RowCount := noProcessos+1;
    Cells[0,0] := 'Nome';
    Cells[1,0] := 'Tempo UCP';
    Cells[2,0] := 'Tempo Espera';
    Cells[3,0] := 'Turnaround';
    Cells[4,0] := 'Prioridade';
    for i := 0 to tamP do
    begin
      if P[i] <> nil then
      begin
        Cells[0,i+1] := P[i].Nome;
        Cells[1,i+1] := IntToStr(P[i].tempoUCP) + ' ms';
        Cells[2,i+1] := IntToStr(P[i].tempoEspera) + ' ms';
        Cells[3,i+1] := IntToStr(P[i].tempoTurnaround) + ' ms';
        Cells[4,i+1] := IntToStr(P[i].Prioridade);
      end;
    end;
  end;
end;

function TUcp.ProntoIsVazio: Boolean;
var
  i: Integer;
  R: Boolean;
begin
  R := True;
  for i := 0 to noProcessos - 1 do
    if FilaPronto[i] <> nil then
      R := False;
  Result := R;
end;

procedure TUcp.ReorganizarFilaPronto;
var
  i: Integer;
begin
  for i := 0 to noProcessos - 1 do
  begin
    FilaPronto[i] := FilaPronto[i + 1];
    if i = noProcessos - 1 then
      FilaPronto[i] := nil;
  end;
  PreecherGrid(frmEscalonador.sgPronto,FilaPronto,noProcessos-1);
end;

{-----------------------------------------------------------------------------
  Procedimento: Inicializar
  Autor:        Maxwell Anderson Ielpo do Amaral
  Data:         16-out-2005
  Argumentos:   None
  Result:       None

  Incializa a UCP

-----------------------------------------------------------------------------}

{-----------------------------------------------------------------------------
  Procedimento: CriarProcessos
  Autor:         Maxwell Anderson Ielpo do Amaral
  Data:         16-out-2005
  Argumentos:   noProcessos: Byte
  Result:       None

  Cria todos os processos necessários

-----------------------------------------------------------------------------}

{-----------------------------------------------------------------------------
  Procedimento: OrdenarProcessos
  Autor:         Maxwell Anderson Ielpo do Amaral
  Data:         16-out-2005
  Argumentos:   por: Char
  Result:       None
-----------------------------------------------------------------------------}

{-----------------------------------------------------------------------------
  Procedimento: ProcessoTimer
  Autor:        Maxwell Anderson Ielpo do Amaral
  Data:         16-out-2005
  Argumentos:   Sender: TObject
  Result:       None
-----------------------------------------------------------------------------}

{-----------------------------------------------------------------------------
  Procedimento: DecrementarProcEmEspera
  Autor:         Maxwell Anderson Ielpo do Amaral
  Data:         16-out-2005
  Argumentos:   None
  Result:       None
-----------------------------------------------------------------------------}

{-----------------------------------------------------------------------------
  Procedimento: ColocarNaFilaPronto
  Autor:         Maxwell Anderson Ielpo do Amaral
  Data:         16-out-2005
  Argumentos:   var Q: TProcesso
  Result:       None
-----------------------------------------------------------------------------}

{-----------------------------------------------------------------------------
  Procedimento: PreecherGrid
  Autor:         Maxwell Anderson Ielpo do Amaral
  Data:         16-out-2005
  Argumentos:   Grid: TStringGrid; P: array of TProcesso; tamP: Integer
  Result:       None
-----------------------------------------------------------------------------}


end.

