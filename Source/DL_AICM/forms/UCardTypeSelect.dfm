object fFormCardTypeSelect: TfFormCardTypeSelect
  Left = 433
  Top = 247
  BorderStyle = bsNone
  Caption = #35831#36873#25321#21345#29255#31867#22411
  ClientHeight = 183
  ClientWidth = 471
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object rgCardType: TcxRadioGroup
    Left = 8
    Top = 8
    Caption = #35831#36873#25321#24744#35201#21150#29702#30340#21345#29255#31867#22411
    ParentFont = False
    Properties.Items = <
      item
        Caption = #38144#21806#31867#65306#27700#27877#12289#29087#26009#31561
      end
      item
        Caption = #37319#36141#31867#65306#21407#26448#26009
      end>
    ItemIndex = 0
    Style.Font.Charset = ANSI_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -32
    Style.Font.Name = #23435#20307
    Style.Font.Style = []
    Style.IsFontAssigned = True
    TabOrder = 0
    Height = 137
    Width = 457
  end
  object btnOk: TcxButton
    Left = 288
    Top = 152
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TcxButton
    Left = 384
    Top = 152
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
