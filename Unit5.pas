unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, TeEngine, Series, GanttCh, ExtCtrls, TeeProcs, Chart;

type
  TFrame5 = class(TFrame)
    Chart1: TChart;
    Series1: TGanttSeries;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
