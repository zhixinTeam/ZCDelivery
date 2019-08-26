inherited fFormWXBaseLoad: TfFormWXBaseLoad
  Top = 287
  Caption = #37319#36141#22522#30784#25968#25454#19979#36733
  ClientHeight = 232
  ClientWidth = 261
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 261
    Height = 232
    inherited BtnOK: TButton
      Left = 115
      Top = 199
      Caption = #19979#36733
      TabOrder = 1
    end
    inherited BtnExit: TButton
      Left = 185
      Top = 199
      TabOrder = 2
    end
    object chkdept: TcxCheckBox [2]
      Left = 23
      Top = 36
      Caption = ' '#37096#38376#20449#24687
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 0
      Width = 180
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #19979#36733#36873#39033
        LayoutDirection = ldHorizontal
        object dxLayout1Item3: TdxLayoutItem
          Control = chkdept
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object chkCusPro: TcxCheckBox
    Left = 23
    Top = 94
    Caption = ' '#23458#21830#20449#24687
    ParentFont = False
    Style.BorderColor = clWindowFrame
    Style.BorderStyle = ebsSingle
    Style.HotTrack = False
    TabOrder = 2
    Width = 180
  end
  object chkStockType: TcxCheckBox
    Left = 23
    Top = 124
    Caption = ' '#23384#36135#20998#31867
    ParentFont = False
    Style.BorderColor = clWindowFrame
    Style.BorderStyle = ebsSingle
    Style.HotTrack = False
    TabOrder = 3
    Width = 180
  end
  object chkUser: TcxCheckBox
    Left = 23
    Top = 65
    Caption = ' '#20154#21592#20449#24687
    ParentFont = False
    Style.BorderColor = clWindowFrame
    Style.BorderStyle = ebsSingle
    Style.HotTrack = False
    TabOrder = 1
    Width = 180
  end
  object chkStockInfo: TcxCheckBox
    Left = 23
    Top = 153
    Caption = ' '#23384#36135#20449#24687
    ParentFont = False
    Style.BorderColor = clWindowFrame
    Style.BorderStyle = ebsSingle
    Style.HotTrack = False
    TabOrder = 4
    Width = 180
  end
end
