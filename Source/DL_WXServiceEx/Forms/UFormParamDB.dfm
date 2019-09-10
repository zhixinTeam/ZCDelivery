inherited fFormParamDB: TfFormParamDB
  Left = 397
  Top = 302
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #25968#25454#24211
  ClientHeight = 420
  ClientWidth = 621
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
    Left = 410
    Top = 32
    Width = 38
    Height = 15
    Caption = #21517#31216':'
  end
  object Bevel1: TBevel
    Left = 5
    Top = 376
    Width = 609
    Height = 6
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsBottomLine
  end
  object Label4: TLabel
    Left = 195
    Top = 91
    Width = 83
    Height = 15
    Caption = #26381#21153#22120#22320#22336':'
  end
  object Label5: TLabel
    Left = 410
    Top = 91
    Width = 83
    Height = 15
    Caption = #26381#21153#22120#31471#21475':'
  end
  object Label6: TLabel
    Left = 195
    Top = 209
    Width = 83
    Height = 15
    Caption = #25968#25454#24211#21517#31216':'
  end
  object Label7: TLabel
    Left = 195
    Top = 150
    Width = 68
    Height = 15
    Caption = #30331#24405#29992#25143':'
  end
  object Label8: TLabel
    Left = 410
    Top = 150
    Width = 68
    Height = 15
    Caption = #29992#25143#23494#30721':'
  end
  object Label9: TLabel
    Left = 410
    Top = 209
    Width = 98
    Height = 15
    Caption = #24037#20316#23545#35937#20010#25968':'
  end
  object Label10: TLabel
    Left = 195
    Top = 268
    Width = 83
    Height = 15
    Caption = #36830#25509#23383#31526#20018':'
  end
  object ListParam: TListBox
    Left = 8
    Top = 32
    Width = 175
    Height = 342
    Style = lbOwnerDrawFixed
    ItemHeight = 20
    TabOrder = 0
    OnClick = ListParamClick
  end
  object BtnAdd: TButton
    Left = 8
    Top = 386
    Width = 55
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = #28155#21152
    TabOrder = 10
    OnClick = BtnAddClick
  end
  object BtnDel: TButton
    Left = 65
    Top = 386
    Width = 55
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = #21024#38500
    TabOrder = 11
    OnClick = BtnDelClick
  end
  object EditID: TEdit
    Left = 195
    Top = 50
    Width = 200
    Height = 23
    TabOrder = 1
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
    OnKeyPress = EditIDKeyPress
  end
  object EditName: TEdit
    Left = 410
    Top = 50
    Width = 200
    Height = 23
    TabOrder = 2
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object BtnExit: TButton
    Left = 534
    Top = 386
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 13
  end
  object BtnOK: TButton
    Left = 454
    Top = 386
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #30830#23450
    TabOrder = 12
    OnClick = BtnOKClick
  end
  object EditIP: TEdit
    Left = 195
    Top = 109
    Width = 200
    Height = 23
    TabOrder = 3
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditPort: TEdit
    Left = 410
    Top = 109
    Width = 200
    Height = 23
    TabOrder = 4
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditDB: TEdit
    Left = 195
    Top = 228
    Width = 200
    Height = 23
    TabOrder = 7
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditUser: TEdit
    Left = 195
    Top = 168
    Width = 200
    Height = 23
    TabOrder = 5
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditPwd: TEdit
    Left = 410
    Top = 169
    Width = 200
    Height = 23
    PasswordChar = '*'
    TabOrder = 6
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditWorker: TEdit
    Left = 410
    Top = 228
    Width = 200
    Height = 23
    TabOrder = 8
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object MemoConn: TMemo
    Left = 195
    Top = 287
    Width = 415
    Height = 87
    ScrollBars = ssVertical
    TabOrder = 9
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
end
