inherited fFormBaseInfo: TfFormBaseInfo
  Left = 550
  Top = 270
  Width = 652
  Height = 464
  BorderIcons = [biSystemMenu]
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 15
  object dxLayout1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 644
    Height = 432
    Align = alClient
    TabOrder = 0
    TabStop = False
    AutoContentSizes = [acsWidth, acsHeight]
    LookAndFeel = FDM.dxLayoutWeb1
    object InfoTv1: TcxTreeView
      Left = 29
      Top = 45
      Width = 172
      Height = 341
      Align = alClient
      DragMode = dmAutomatic
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
      OnClick = InfoTv1Click
      OnDblClick = InfoTv1DblClick
      OnDragDrop = InfoTv1DragDrop
      OnDragOver = InfoTv1DragOver
      HideSelection = False
      Images = FDM.ImageBar
      ReadOnly = True
      OnChange = InfoTv1Change
      OnDeletion = InfoTv1Deletion
    end
    object InfoList1: TcxMCListBox
      Left = 262
      Top = 45
      Width = 353
      Height = 121
      HeaderSections = <
        item
          DataIndex = 1
          Text = #33410#28857
          Width = 74
        end
        item
          AutoSize = True
          DataIndex = 2
          Text = #22791#27880
          Width = 275
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 1
      OnClick = InfoList1Click
      OnDblClick = InfoTv1DblClick
    end
    object EditText: TcxTextEdit
      Left = 320
      Top = 247
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 2
      OnExit = EditTextExit
      Width = 151
    end
    object EditPY: TcxTextEdit
      Left = 320
      Top = 272
      TabStop = False
      ParentFont = False
      Properties.MaxLength = 25
      TabOrder = 3
      Width = 151
    end
    object EditMemo: TcxMemo
      Left = 320
      Top = 297
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 4
      Height = 79
      Width = 281
    end
    object BtnAdd: TButton
      Left = 372
      Top = 381
      Width = 78
      Height = 28
      Caption = #28155#21152
      TabOrder = 5
      OnClick = BtnAddClick
    end
    object BtnDel: TButton
      Left = 455
      Top = 381
      Width = 78
      Height = 28
      Caption = #21024#38500
      TabOrder = 6
      OnClick = BtnDelClick
    end
    object BtnSave: TButton
      Left = 538
      Top = 381
      Width = 77
      Height = 28
      Caption = #20445#23384
      TabOrder = 7
      OnClick = BtnSaveClick
    end
    object dxLayout1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      object dxLayout1Group1: TdxLayoutGroup
        AutoAligns = [aaVertical]
        AlignHorz = ahClient
        Caption = #26641#24418#26174#31034
        object dxLayout1Item1: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = #26641#29366#21015#34920
          ShowCaption = False
          Control = InfoTv1
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayout1Group4: TdxLayoutGroup
        AutoAligns = [aaVertical]
        AlignHorz = ahRight
        ShowCaption = False
        Hidden = True
        ShowBorder = False
        object dxLayout1Group2: TdxLayoutGroup
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = #21015#34920#26174#31034
          object dxLayout1Item2: TdxLayoutItem
            AutoAligns = [aaHorizontal]
            AlignVert = avClient
            Caption = 'cxMCListBox1'
            ShowCaption = False
            Control = InfoList1
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group3: TdxLayoutGroup
          AutoAligns = [aaHorizontal]
          AlignVert = avBottom
          Caption = #32534#36753#21306
          object dxLayout1Item4: TdxLayoutItem
            Caption = #33410#28857#20869#23481':'
            Control = EditText
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            Caption = #25340#38899#31616#20889':'
            Control = EditPY
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item6: TdxLayoutItem
            Caption = #22791#27880#20449#24687':'
            Control = EditMemo
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Group5: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item7: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              Caption = 'Button1'
              ShowCaption = False
              Control = BtnAdd
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item8: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              Caption = 'Button2'
              ShowCaption = False
              Control = BtnDel
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item9: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              Caption = 'Button3'
              ShowCaption = False
              Control = BtnSave
              ControlOptions.ShowBorder = False
            end
          end
        end
      end
    end
  end
end
