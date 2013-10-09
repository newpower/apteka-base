object About: TAbout
  Left = 442
  Top = 154
  Width = 475
  Height = 456
  Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 16
    Top = 8
    Width = 441
    Height = 329
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 0
    object ProductName: TLabel
      Left = 2
      Top = 26
      Width = 437
      Height = 24
      Align = alTop
      Alignment = taCenter
      Caption = #1042#1045#1056#1057#1048#1071' 1.0.0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      IsControl = True
    end
    object Label1: TLabel
      Left = 2
      Top = 2
      Width = 437
      Height = 24
      Align = alTop
      Alignment = taCenter
      Caption = #1050#1083#1080#1077#1085#1090' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1086#1075#1086' '#1079#1072#1082#1072#1079#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      IsControl = True
    end
    object Memo1: TMemo
      Left = 2
      Top = 50
      Width = 437
      Height = 143
      Align = alTop
      Alignment = taCenter
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        #1054#1054#1054' "'#1055#1086#1083#1080#1084#1077#1076'-'#1070#1075'"'
        #1055#1088#1080#1077#1084' '#1079#1072#1103#1074#1086#1082': '#1072#1087#1090'.'#1089#1077#1090#1100' - (863) '
        '299-3476,299-3718,299-3716,299-3719,220-3882,'
        #1073#1086#1083#1100#1085#1080#1094#1099','#1087'-'#1082#1080' - (863) 299-3715,'
        #1086#1090#1076#1077#1083' '#1079#1072#1082#1091#1087#1086#1082' - (863) 220-3881, 299-3475'
        'E-mail: polimed@rostel.ru')
      ParentFont = False
      TabOrder = 0
    end
    object Memo2: TMemo
      Left = 2
      Top = 193
      Width = 437
      Height = 147
      Align = alTop
      Alignment = taCenter
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        #1056#1077#1082#1074#1080#1079#1080#1090#1099':'
        #1048#1053#1053' 6168052137, '#1050#1055#1055' 616801001, '#1054#1050#1055#1054' 13469253, '
        #1054#1050#1042#1069#1044' 51.46.1'
        #1088'/'#1089#1095' 40702810500000001167 '#1074' '#1054#1040#1054' '#1040#1050#1041' '
        '"'#1057#1090#1077#1083#1083#1072'-'#1041#1072#1085#1082'"'
        #1082'/'#1089#1095' 30101810400000000938, '#1041#1048#1050' 046015938'
        #1070#1088'.'#1072#1076#1088#1077#1089': 344091 '#1075'.'#1056#1086#1089#1090#1086#1074'-'#1085#1072'-'#1044#1086#1085#1091', '#1091#1083'.2-'#1103' '
        #1050#1088#1072#1089#1085#1086#1076#1072#1088#1089#1082#1072#1103',92'
        #1060#1072#1082#1090'.'#1072#1076#1088#1077#1089': 344012 '#1075'.'#1056#1086#1089#1090#1086#1074'-'#1085#1072'-'#1044#1086#1085#1091', '
        #1091#1083'.'#1070#1092#1080#1084#1094#1077#1074#1072',17,'#1086#1092'.35')
      ParentFont = False
      TabOrder = 1
    end
  end
  object OKButton: TButton
    Left = 152
    Top = 352
    Width = 146
    Height = 53
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = OKButtonClick
  end
end
