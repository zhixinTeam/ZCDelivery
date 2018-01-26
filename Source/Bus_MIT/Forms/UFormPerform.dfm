inherited fFormPerform: TfFormPerform
  Left = 397
  Top = 302
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #24615#33021#37197#32622
  ClientHeight = 407
  ClientWidth = 602
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
    Caption = #26631#35782':'
  end
  object Label3: TLabel
    Left = 400
    Top = 32
    Width = 38
    Height = 15
    Caption = #21517#31216':'
  end
  object Bevel1: TBevel
    Left = 5
    Top = 364
    Width = 590
    Height = 6
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsBottomLine
  end
  object Label4: TLabel
    Left = 195
    Top = 148
    Width = 120
    Height = 15
    Caption = 'Conn Pool Size:'
  end
  object Label5: TLabel
    Left = 195
    Top = 90
    Width = 72
    Height = 15
    Caption = 'TCP Port:'
  end
  object Label6: TLabel
    Left = 195
    Top = 264
    Width = 112
    Height = 15
    Caption = 'SAP Pool Size:'
  end
  object Label7: TLabel
    Left = 400
    Top = 264
    Width = 98
    Height = 15
    Caption = #23432#25252#21047#26032#38388#38548':'
  end
  object Label8: TLabel
    Left = 400
    Top = 148
    Width = 152
    Height = 15
    Caption = 'Business Pool Size:'
  end
  object Label9: TLabel
    Left = 195
    Top = 322
    Width = 136
    Height = 15
    Caption = 'Max Record Count:'
  end
  object Label11: TLabel
    Left = 400
    Top = 90
    Width = 80
    Height = 15
    Caption = 'Http Port:'
  end
  object Label10: TLabel
    Left = 195
    Top = 206
    Width = 112
    Height = 15
    Caption = 'Conn Behavior:'
  end
  object Label12: TLabel
    Left = 400
    Top = 206
    Width = 144
    Height = 15
    Caption = 'Business Behavior:'
  end
  object ListParam: TListBox
    Left = 8
    Top = 32
    Width = 175
    Height = 330
    Style = lbOwnerDrawFixed
    ItemHeight = 20
    TabOrder = 0
    OnClick = ListParamClick
  end
  object BtnAdd: TButton
    Left = 8
    Top = 373
    Width = 55
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = #28155#21152
    TabOrder = 12
    OnClick = BtnAddClick
  end
  object BtnDel: TButton
    Left = 65
    Top = 373
    Width = 55
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = #21024#38500
    TabOrder = 13
    OnClick = BtnDelClick
  end
  object EditID: TEdit
    Left = 195
    Top = 50
    Width = 190
    Height = 23
    TabOrder = 1
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
    OnKeyPress = EditIDKeyPress
  end
  object EditName: TEdit
    Left = 400
    Top = 50
    Width = 190
    Height = 23
    TabOrder = 2
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object BtnExit: TButton
    Left = 515
    Top = 373
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 15
  end
  object BtnOK: TButton
    Left = 435
    Top = 373
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #30830#23450
    TabOrder = 14
    OnClick = BtnOKClick
  end
  object EditInterval: TEdit
    Left = 400
    Top = 281
    Width = 190
    Height = 23
    TabOrder = 10
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditTCP: TEdit
    Left = 195
    Top = 108
    Width = 190
    Height = 23
    TabOrder = 3
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditSizeSAP: TEdit
    Left = 195
    Top = 281
    Width = 190
    Height = 23
    TabOrder = 9
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditSizeConn: TEdit
    Left = 195
    Top = 165
    Width = 190
    Height = 23
    TabOrder = 5
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditSizeBus: TEdit
    Left = 400
    Top = 166
    Width = 190
    Height = 23
    TabOrder = 6
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditRecord: TEdit
    Left = 195
    Top = 339
    Width = 190
    Height = 23
    TabOrder = 11
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditHttp: TEdit
    Left = 400
    Top = 108
    Width = 190
    Height = 23
    TabOrder = 4
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditBehConn: TComboBox
    Left = 195
    Top = 223
    Width = 190
    Height = 24
    Style = csOwnerDrawFixed
    ItemHeight = 18
    TabOrder = 7
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
    Items.Strings = (
      '1.'#30452#25509#36864#20986
      '2.'#31561#24453#37322#25918
      '3.'#33258#21160#21019#24314)
  end
  object EditBehBus: TComboBox
    Left = 400
    Top = 223
    Width = 190
    Height = 24
    Style = csOwnerDrawFixed
    ItemHeight = 18
    TabOrder = 8
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
    Items.Strings = (
      '1.'#30452#25509#36864#20986
      '2.'#31561#24453#37322#25918
      '3.'#33258#21160#21019#24314)
  end
end
