object PersonalSettings: TPersonalSettings
  Left = 240
  Top = 196
  Width = 891
  Height = 393
  Caption = #1055#1077#1088#1089#1086#1085#1072#1083#1100#1085#1099#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 32
    Top = 16
    Width = 809
    Height = 129
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1082#1083#1080#1077#1085#1090#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 40
      Width = 264
      Height = 20
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1042#1072#1096#1077#1081' '#1092#1080#1088#1084#1099' *'
    end
    object Label2: TLabel
      Left = 8
      Top = 80
      Width = 95
      Height = 20
      Caption = #1058#1077#1083#1077#1092#1086#1085' *:'
    end
    object ClientName: TEdit
      Left = 280
      Top = 40
      Width = 457
      Height = 28
      TabOrder = 0
    end
    object ClientPhone: TEdit
      Left = 280
      Top = 80
      Width = 457
      Height = 28
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 32
    Top = 160
    Width = 329
    Height = 137
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1089#1080#1089#1090#1077#1084#1099
    TabOrder = 1
    object Label3: TLabel
      Left = 16
      Top = 24
      Width = 74
      Height = 13
      Caption = #1050#1086#1076' '#1074' '#1089#1080#1089#1090#1077#1084#1077
    end
    object Label4: TLabel
      Left = 16
      Top = 56
      Width = 131
      Height = 13
      Caption = #1040#1076#1088#1077#1089' '#1089#1077#1088#1074#1077#1088#1072' '#1087#1086#1083#1091#1095#1077#1085#1080#1103
    end
    object Label9: TLabel
      Left = 16
      Top = 80
      Width = 243
      Height = 13
      Caption = #1044#1072#1085#1085#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1089#1072#1084#1086#1089#1090#1086#1103#1090#1077#1083#1100#1085#1086' '#1085#1077' '#1084#1077#1085#1103#1090#1100
    end
    object ClientCode: TEdit
      Left = 168
      Top = 16
      Width = 57
      Height = 21
      TabOrder = 0
    end
    object ServerEdit: TEdit
      Left = 168
      Top = 56
      Width = 145
      Height = 21
      TabOrder = 1
    end
  end
  object GroupBox3: TGroupBox
    Left = 368
    Top = 160
    Width = 473
    Height = 145
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103' (Proxy)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object Label10: TLabel
      Left = 216
      Top = 24
      Width = 27
      Height = 20
      Caption = #1058#1080#1087
    end
    object UseProxy: TCheckBox
      Left = 16
      Top = 24
      Width = 193
      Height = 17
      Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1087#1088#1086#1082#1089#1080
      TabOrder = 0
    end
    object ProxyHostEdit: TLabeledEdit
      Left = 16
      Top = 64
      Width = 185
      Height = 28
      EditLabel.Width = 37
      EditLabel.Height = 20
      EditLabel.Caption = #1061#1086#1089#1090
      TabOrder = 1
    end
    object ProxyPortEdit: TLabeledEdit
      Left = 264
      Top = 64
      Width = 121
      Height = 28
      EditLabel.Width = 39
      EditLabel.Height = 20
      EditLabel.Caption = #1055#1086#1088#1090
      TabOrder = 2
    end
    object ProxyUserEdit: TLabeledEdit
      Left = 16
      Top = 112
      Width = 185
      Height = 28
      EditLabel.Width = 46
      EditLabel.Height = 20
      EditLabel.Caption = #1051#1086#1075#1080#1085
      TabOrder = 3
    end
    object ProxyPasswordEdit: TLabeledEdit
      Left = 264
      Top = 112
      Width = 121
      Height = 28
      EditLabel.Width = 58
      EditLabel.Height = 20
      EditLabel.Caption = #1055#1072#1088#1086#1083#1100
      TabOrder = 4
    end
    object FtpProxyType: TComboBox
      Left = 264
      Top = 16
      Width = 145
      Height = 28
      ItemHeight = 20
      TabOrder = 5
      Text = 'none'
      Items.Strings = (
        'None'
        'UserSite'
        'Site'
        'Open'
        'UserPass'
        'Transparent'
        'HttpProxyWithFtp')
    end
  end
  object BitBtn1: TBitBtn
    Left = 32
    Top = 312
    Width = 305
    Height = 33
    Cursor = crHandPoint
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    DragCursor = crHandPoint
    ModalResult = 1
    TabOrder = 3
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 552
    Top = 312
    Width = 289
    Height = 33
    Caption = #1042#1099#1093#1086#1076
    ModalResult = 2
    TabOrder = 4
    OnClick = BitBtn2Click
  end
end
