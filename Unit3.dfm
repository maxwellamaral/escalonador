object Form3: TForm3
  Left = 306
  Top = 223
  BorderStyle = bsDialog
  BorderWidth = 10
  Caption = 'Entre com os Dados'
  ClientHeight = 304
  ClientWidth = 448
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 8
    Top = 8
    Width = 433
    Height = 249
    ColCount = 3
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor]
    TabOrder = 0
  end
  object Button1: TButton
    Left = 184
    Top = 272
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = BitBtn1Click
  end
end
