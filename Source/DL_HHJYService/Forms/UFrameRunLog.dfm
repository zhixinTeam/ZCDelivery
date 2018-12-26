inherited fFrameRunLog: TfFrameRunLog
  Width = 632
  Height = 359
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 632
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 3
    ParentColor = True
    TabOrder = 0
    DesignSize = (
      632
      35)
    object Bevel1: TBevel
      Left = 3
      Top = 27
      Width = 626
      Height = 5
      Align = alBottom
      Shape = bsBottomLine
    end
    object Check1: TCheckBox
      Left = 8
      Top = 8
      Width = 138
      Height = 17
      Caption = #26174#31034#36816#34892#26102#35843#35797#26085#24535
      TabOrder = 0
      OnClick = Check1Click
    end
    object BtnClear: TButton
      Left = 568
      Top = 6
      Width = 45
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #28165#31354
      TabOrder = 1
      OnClick = BtnClearClick
    end
    object BtnCopy: TButton
      Left = 522
      Top = 6
      Width = 45
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #22797#21046
      TabOrder = 2
      OnClick = BtnCopyClick
    end
  end
  object MemoLog: TMemo
    Left = 0
    Top = 35
    Width = 632
    Height = 324
    Align = alClient
    BorderStyle = bsNone
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
  end
end
