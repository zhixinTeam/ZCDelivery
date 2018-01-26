inherited fFormPack: TfFormPack
  Left = 901
  Top = 361
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #21442#25968#32452#31649#29702
  ClientHeight = 347
  ClientWidth = 424
  OldCreateOrder = True
  Position = poDesktopCenter
  PixelsPerInch = 120
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 14
    Width = 68
    Height = 15
    Caption = #21442#25968#21015#34920':'
  end
  object Label2: TLabel
    Left = 195
    Top = 32
    Width = 38
    Height = 15
    Anchors = [akTop, akRight]
    Caption = #26631#35782':'
  end
  object Label3: TLabel
    Left = 195
    Top = 90
    Width = 38
    Height = 15
    Anchors = [akTop, akRight]
    Caption = #21517#31216':'
  end
  object Label4: TLabel
    Left = 195
    Top = 147
    Width = 53
    Height = 15
    Anchors = [akTop, akRight]
    Caption = #25968#25454#24211':'
  end
  object Label5: TLabel
    Left = 195
    Top = 204
    Width = 32
    Height = 15
    Anchors = [akTop, akRight]
    Caption = 'SAP:'
  end
  object Label6: TLabel
    Left = 195
    Top = 262
    Width = 38
    Height = 15
    Anchors = [akTop, akRight]
    Caption = #24615#33021':'
  end
  object Bevel1: TBevel
    Left = 5
    Top = 306
    Width = 412
    Height = 6
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsBottomLine
  end
  object ListPack: TListBox
    Left = 8
    Top = 32
    Width = 175
    Height = 271
    Style = lbOwnerDrawFixed
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 20
    TabOrder = 0
    OnClick = ListPackClick
  end
  object BtnAdd: TButton
    Left = 8
    Top = 316
    Width = 55
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = #28155#21152
    TabOrder = 1
    OnClick = BtnAddClick
  end
  object BtnDel: TButton
    Left = 65
    Top = 316
    Width = 55
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = #21024#38500
    TabOrder = 2
    OnClick = BtnDelClick
  end
  object EditDB: TComboBox
    Left = 195
    Top = 164
    Width = 215
    Height = 24
    Style = csOwnerDrawFixed
    Anchors = [akTop, akRight]
    ItemHeight = 18
    TabOrder = 3
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditID: TEdit
    Left = 195
    Top = 50
    Width = 215
    Height = 23
    Anchors = [akTop, akRight]
    TabOrder = 4
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
    OnKeyPress = EditIDKeyPress
  end
  object EditName: TEdit
    Left = 195
    Top = 107
    Width = 215
    Height = 23
    Anchors = [akTop, akRight]
    TabOrder = 5
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditSAP: TComboBox
    Left = 195
    Top = 221
    Width = 215
    Height = 24
    Style = csOwnerDrawFixed
    Anchors = [akTop, akRight]
    ItemHeight = 18
    TabOrder = 6
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditPerform: TComboBox
    Left = 195
    Top = 279
    Width = 215
    Height = 24
    Style = csOwnerDrawFixed
    Anchors = [akTop, akRight]
    ItemHeight = 18
    TabOrder = 7
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object BtnExit: TButton
    Left = 335
    Top = 316
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 8
  end
  object BtnOK: TButton
    Left = 257
    Top = 316
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #30830#23450
    TabOrder = 9
    OnClick = BtnOKClick
  end
end
