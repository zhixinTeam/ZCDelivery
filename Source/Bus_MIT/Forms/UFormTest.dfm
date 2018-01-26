inherited BaseForm1: TBaseForm1
  Left = 606
  Top = 478
  Width = 644
  Height = 453
  Caption = 'test -default'
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Memo1: TMemo
    Left = 0
    Top = 33
    Width = 636
    Height = 393
    Align = alClient
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 636
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Button1: TButton
      Left = 187
      Top = 10
      Width = 60
      Height = 20
      Caption = 'test'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Edit1: TEdit
      Left = 14
      Top = 10
      Width = 168
      Height = 20
      TabOrder = 1
      Text = 'Edit1'
    end
    object CheckBox1: TCheckBox
      Left = 272
      Top = 12
      Width = 97
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 2
      OnClick = CheckBox1Click
    end
  end
end
