inherited fFormZTMode: TfFormZTMode
  Left = 472
  Top = 330
  Caption = #36710#36742#35843#24230#27169#24335#20999#25442
  ClientHeight = 222
  ClientWidth = 477
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 477
    Height = 222
    inherited BtnOK: TButton
      Left = 331
      Top = 189
      TabOrder = 4
    end
    inherited BtnExit: TButton
      Left = 401
      Top = 189
      TabOrder = 5
    end
    object Radio1: TcxRadioButton [2]
      Left = 23
      Top = 36
      Width = 113
      Height = 17
      Caption = #27491#24120#35843#24230#27169#24335
      ParentColor = False
      TabOrder = 0
    end
    object cxLabel1: TcxLabel [3]
      Left = 23
      Top = 58
      AutoSize = False
      Caption = '   '#27491#24120#27169#24335#19979#65292#25955#35013#36710#36742#19968#36710#19968#21333#65292#19981#33021#39044#24320#65307#36710#36742#19978#23631#21518#26410#22312#25351#23450#26102#38388#20869#36827#21378#65292#20250#33258#21160#31227#20986#38431#21015#12290
      ParentFont = False
      Properties.WordWrap = True
      Transparent = True
      Height = 35
      Width = 456
    end
    object Radio2: TcxRadioButton [4]
      Left = 23
      Top = 98
      Width = 113
      Height = 17
      Caption = #25955#35013#39044#24320#27169#24335
      ParentColor = False
      TabOrder = 2
    end
    object cxLabel2: TcxLabel [5]
      Left = 23
      Top = 120
      AutoSize = False
      Caption = '  '#39044#24320#27169#24335#19979#65292#25955#35013#36710#36742#21487#20197#19968#36710#24320#22810#21333#65307#36710#36742#19981#20250#36229#26102#20986#38431#65292#21487#38543#26102#35013#36710#12290
      ParentFont = False
      Transparent = True
      Height = 35
      Width = 456
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = ''
        object dxLayout1Item3: TdxLayoutItem
          Caption = 'cxRadioButton1'
          ShowCaption = False
          Control = Radio1
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = 'cxRadioButton2'
          ShowCaption = False
          Control = Radio2
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = 'cxLabel2'
          ShowCaption = False
          Control = cxLabel2
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
