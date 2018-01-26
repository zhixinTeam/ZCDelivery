object fFormLogin: TfFormLogin
  Left = 433
  Top = 368
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 245
  ClientWidth = 358
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 12
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 358
    Height = 132
    Align = alTop
    AutoSize = True
    Proportional = True
  end
  object LabelCopy: TLabel
    Left = 10
    Top = 225
    Width = 162
    Height = 12
    Caption = #8251'.xxxx'#36719#20214#26377#38480#36131#20219#20844#21496#21046#20316
  end
  object GroupBox1: TGroupBox
    Left = 10
    Top = 135
    Width = 336
    Height = 80
    TabOrder = 0
    object BtnExit: TSpeedButton
      Left = 280
      Top = 43
      Width = 50
      Height = 22
      Caption = #36864#20986
      Flat = True
      OnClick = BtnExitClick
    end
    object BtnSet: TSpeedButton
      Left = 280
      Top = 20
      Width = 50
      Height = 22
      Caption = #35774#32622
      Flat = True
      OnClick = BtnSetClick
    end
    object Edit_User: TLabeledEdit
      Left = 65
      Top = 20
      Width = 141
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      EditLabel.Width = 30
      EditLabel.Height = 12
      EditLabel.Caption = #29992#25143':'
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object Edit_Pwd: TLabeledEdit
      Left = 65
      Top = 45
      Width = 141
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      EditLabel.Width = 30
      EditLabel.Height = 12
      EditLabel.Caption = #23494#30721':'
      LabelPosition = lpLeft
      PasswordChar = '*'
      TabOrder = 1
    end
    object BtnLogin: TButton
      Left = 215
      Top = 20
      Width = 65
      Height = 45
      Caption = #30331#24405
      TabOrder = 2
      OnClick = BtnLoginClick
    end
  end
end
