object Frame5: TFrame5
  Left = 0
  Top = 0
  Width = 770
  Height = 443
  TabOrder = 0
  object Chart1: TChart
    Left = 0
    Top = 0
    Width = 770
    Height = 443
    AnimatedZoom = True
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Gradient.Direction = gdBottomTop
    Gradient.Visible = True
    Title.Text.Strings = (
      'Escalonador de Processos')
    LeftAxis.LabelStyle = talText
    LeftAxis.Title.Caption = 'Processos'
    Legend.LegendStyle = lsSeries
    Legend.TextStyle = ltsRightPercent
    Legend.Visible = False
    RightAxis.Title.Caption = 'dfs'
    View3DOptions.Perspective = 8
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvLowered
    BorderStyle = bsSingle
    TabOrder = 0
    object Series1: TGanttSeries
      ColorEachPoint = True
      Marks.ArrowLength = 0
      Marks.Clip = True
      Marks.Visible = False
      SeriesColor = 4227327
      Pointer.HorizSize = 1
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.VertSize = 5
      Pointer.Visible = True
      XValues.DateTime = False
      XValues.Name = 'Start'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
      StartValues.DateTime = False
      StartValues.Name = 'Start'
      StartValues.Multiplier = 1.000000000000000000
      StartValues.Order = loAscending
      EndValues.DateTime = True
      EndValues.Name = 'End'
      EndValues.Multiplier = 1.000000000000000000
      EndValues.Order = loNone
      NextTask.DateTime = False
      NextTask.Name = 'NextTask'
      NextTask.Multiplier = 1.000000000000000000
      NextTask.Order = loNone
    end
  end
end
