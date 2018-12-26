inherited fFormServiceURL: TfFormServiceURL
  Left = 397
  Top = 290
  Width = 575
  Height = 501
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #26381#21153#22320#22336
  OldCreateOrder = True
  Position = poDesktopCenter
  OnClose = FormClose
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 12
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 567
    Height = 200
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      567
      200)
    object Label1: TLabel
      Left = 6
      Top = 8
      Width = 54
      Height = 12
      Caption = #26412#22320#26381#21153':'
    end
    object MemoLocal: TMemo
      Left = 5
      Top = 25
      Width = 554
      Height = 170
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 0
      OnChange = MemoLocalChange
    end
  end
  object PanelMID: TPanel
    Left = 0
    Top = 200
    Width = 567
    Height = 234
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      567
      234)
    object Label2: TLabel
      Left = 6
      Top = 8
      Width = 54
      Height = 12
      Caption = #36828#31243#26381#21153':'
    end
    object MemoRemote: TMemo
      Left = 5
      Top = 25
      Width = 554
      Height = 204
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 0
      OnChange = MemoLocalChange
    end
  end
  object PanelBTM: TPanel
    Left = 0
    Top = 434
    Width = 567
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      567
      40)
    object Bevel1: TBevel
      Left = 5
      Top = 2
      Width = 557
      Height = 5
      Anchors = [akLeft, akRight, akBottom]
      Shape = bsBottomLine
    end
    object BtnExit: TButton
      Left = 490
      Top = 12
      Width = 60
      Height = 20
      Anchors = [akRight, akBottom]
      Caption = #21462#28040
      ModalResult = 2
      TabOrder = 0
    end
    object BtnOK: TButton
      Left = 427
      Top = 12
      Width = 60
      Height = 20
      Anchors = [akRight, akBottom]
      Caption = #30830#23450
      TabOrder = 1
      OnClick = BtnOKClick
    end
  end
end
