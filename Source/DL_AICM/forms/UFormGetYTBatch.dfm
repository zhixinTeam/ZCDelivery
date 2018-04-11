inherited fFormGetYTBatch: TfFormGetYTBatch
  Left = 392
  Top = 160
  Width = 726
  Height = 311
  BorderStyle = bsSizeable
  Constraints.MinHeight = 300
  Constraints.MinWidth = 445
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 710
    Height = 273
    inherited BtnOK: TButton
      Left = 563
      Top = 240
      Caption = #30830#23450
      TabOrder = 3
    end
    inherited BtnExit: TButton
      Left = 634
      Top = 240
      TabOrder = 4
    end
    object EditCus: TcxButtonEdit [2]
      Left = 84
      Top = 29
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditCIDPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.ButtonStyle = bts3D
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object ListQuery: TcxListView [3]
      Left = 24
      Top = 79
      Width = 417
      Height = 145
      Columns = <
        item
          Caption = #29289#26009#32534#21495
          Width = 120
        end
        item
          Caption = #20986#21378#32534#21495
          Width = 150
        end
        item
          Caption = #21097#20313#25968#37327'('#21544')'
          Width = 105
        end
        item
          Caption = #20179#24211#32534#21495
          Width = 130
        end
        item
          Caption = #22791#27880
          Width = 150
        end>
      HideSelection = False
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 2
      ViewStyle = vsReport
      OnDblClick = ListQueryDblClick
      OnKeyPress = ListQueryKeyPress
    end
    object cxLabel1: TcxLabel [4]
      Left = 24
      Top = 56
      Caption = #26597#35810#32467#26524':'
      ParentFont = False
      Transparent = True
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        CaptionOptions.Text = #26597#35810#26465#20214
        object dxLayout1Item5: TdxLayoutItem
          CaptionOptions.Text = #29289#26009#21517#31216':'
          Control = EditCus
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          CaptionOptions.Text = 'cxLabel1'
          CaptionOptions.Visible = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          AlignVert = avClient
          CaptionOptions.Text = #26597#35810#32467#26524':'
          CaptionOptions.Visible = False
          Control = ListQuery
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
