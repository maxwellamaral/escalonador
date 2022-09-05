object frmEscalonador: TfrmEscalonador
  Left = 34
  Top = 63
  BorderStyle = bsSingle
  BorderWidth = 10
  Caption = 'Escalonador de Processos'
  ClientHeight = 675
  ClientWidth = 948
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 124
    Width = 72
    Height = 13
    Caption = 'Qtd Processos:'
  end
  object SpinEdit1: TSpinEdit
    Left = 96
    Top = 120
    Width = 49
    Height = 22
    MaxValue = 255
    MinValue = 5
    TabOrder = 0
    Value = 5
    OnChange = MudarParam
  end
  object RadioGroup1: TRadioGroup
    Left = 16
    Top = 16
    Width = 289
    Height = 97
    Caption = ' Escalonamento '
    ItemIndex = 0
    Items.Strings = (
      'Escalonamento Circular'
      'Escalonamento por Prioridades'
      'Escalonamento Circular por Prioridades'
      'Escalonamento FIFO')
    TabOrder = 1
    OnClick = MudarParam
  end
  object btnCriar: TButton
    Left = 224
    Top = 120
    Width = 81
    Height = 22
    Caption = 'Criar'
    TabOrder = 2
    OnClick = btnCriarClick
  end
  object btnExecuteEscalon: TButton
    Left = 16
    Top = 176
    Width = 289
    Height = 73
    TabOrder = 3
    OnClick = btnExecuteEscalonClick
  end
  object GroupBox1: TGroupBox
    Left = 320
    Top = 16
    Width = 457
    Height = 233
    Caption = ' Processador '
    Enabled = False
    TabOrder = 4
    object lblTimeSlice: TLabel
      Left = 16
      Top = 72
      Width = 56
      Height = 13
      Caption = 'lblTimeSlice'
    end
    object Label6: TLabel
      Left = 14
      Top = 16
      Width = 86
      Height = 13
      Caption = 'Velocidade Clock:'
    end
    object lblVelClock: TLabel
      Left = 104
      Top = 16
      Width = 52
      Height = 13
      Caption = 'lblVelClock'
    end
    object Label9: TLabel
      Left = 21
      Top = 176
      Width = 32
      Height = 13
      Alignment = taCenter
      Caption = 'Label9'
    end
    object lblRelogio: TLabel
      Left = 367
      Top = 16
      Width = 64
      Height = 13
      Alignment = taRightJustify
      Caption = 'Rel'#243'gio: 0 ms'
    end
    object TrackBar1: TTrackBar
      Left = 8
      Top = 32
      Width = 433
      Height = 33
      Max = 1000
      Min = 2
      PageSize = 10
      Frequency = 10
      Position = 50
      TabOrder = 0
      OnChange = TrackBar1Change
    end
    object mmUCP: TMemo
      Left = 80
      Top = 96
      Width = 353
      Height = 113
      Lines.Strings = (
        'mmUCP')
      TabOrder = 1
    end
    object TrackBar2: TTrackBar
      Left = 16
      Top = 89
      Width = 45
      Height = 88
      Max = 100
      Min = 10
      Orientation = trVertical
      Frequency = 5
      Position = 50
      TabOrder = 2
      TickMarks = tmBoth
      OnChange = TrackBar2Change
    end
    object chkFixo: TCheckBox
      Left = 16
      Top = 194
      Width = 57
      Height = 17
      Caption = 'Fixo'
      TabOrder = 3
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 272
    Width = 948
    Height = 403
    ActivePage = TabSheet3
    Align = alBottom
    TabOrder = 5
    object TabSheet1: TTabSheet
      Caption = ' Processos Criados e Fila de Cria'#231#227'o '
      object Label2: TLabel
        Left = 16
        Top = 16
        Width = 49
        Height = 13
        Caption = 'Processos'
      end
      object Label3: TLabel
        Left = 392
        Top = 16
        Width = 70
        Height = 13
        Caption = 'Fila de Cria'#231#227'o'
      end
      object StringGrid1: TStringGrid
        Left = 16
        Top = 32
        Width = 369
        Height = 265
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSizing, goColSizing, goEditing]
        TabOrder = 0
        ColWidths = (
          62
          77
          81
          86
          15)
      end
      object StringGrid2: TStringGrid
        Left = 392
        Top = 32
        Width = 369
        Height = 265
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSizing, goColSizing]
        TabOrder = 1
        ColWidths = (
          62
          77
          81
          86
          94)
      end
    end
    object TabSheet2: TTabSheet
      Caption = ' Fila de Pronto e Fila de Espera '
      ImageIndex = 1
      object Label7: TLabel
        Left = 393
        Top = 16
        Width = 67
        Height = 13
        Caption = 'Fila de Espera'
      end
      object Label4: TLabel
        Left = 17
        Top = 16
        Width = 65
        Height = 13
        Caption = 'Fila de Pronto'
      end
      object sgEspera: TStringGrid
        Left = 392
        Top = 33
        Width = 369
        Height = 264
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSizing, goColSizing]
        TabOrder = 0
        ColWidths = (
          62
          77
          81
          86
          94)
      end
      object sgPronto: TStringGrid
        Left = 16
        Top = 33
        Width = 369
        Height = 264
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSizing, goColSizing]
        TabOrder = 1
        ColWidths = (
          62
          77
          81
          86
          94)
      end
    end
    object TabSheet3: TTabSheet
      Caption = ' T'#233'rmino e Gr'#225'fico '
      ImageIndex = 2
      object Label8: TLabel
        Left = 17
        Top = 16
        Width = 89
        Height = 13
        Caption = 'Estado de T'#233'rmino'
      end
      object mmTermino: TMemo
        Left = 16
        Top = 32
        Width = 289
        Height = 326
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object Panel1: TPanel
        Left = 320
        Top = 32
        Width = 601
        Height = 326
        BorderWidth = 10
        TabOrder = 1
        inline Frame51: TFrame5
          Left = 11
          Top = 11
          Width = 579
          Height = 304
          Align = alClient
          TabOrder = 0
          inherited Chart1: TChart
            Width = 579
            Height = 304
            OnDblClick = Frame51Chart1DblClick
          end
        end
      end
    end
  end
  object CheckBox1: TCheckBox
    Left = 152
    Top = 122
    Width = 65
    Height = 17
    Caption = 'Manual'
    TabOrder = 6
  end
  object Button1: TButton
    Left = 224
    Top = 148
    Width = 81
    Height = 22
    Caption = 'Op'#231#245'es'
    TabOrder = 7
    OnClick = Button1Click
  end
  object TimerUCP: TTimer
    Enabled = False
    Interval = 50
    OnTimer = ProcessoTimer
  end
end
