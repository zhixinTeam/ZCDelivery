inherited fFormParamSAP: TfFormParamSAP
  Left = 397
  Top = 302
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'SAP'#37197#32622
  ClientHeight = 421
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
    Left = 195
    Top = 82
    Width = 38
    Height = 15
    Caption = #21517#31216':'
  end
  object Bevel1: TBevel
    Left = 5
    Top = 378
    Width = 609
    Height = 6
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsBottomLine
  end
  object Label4: TLabel
    Left = 195
    Top = 335
    Width = 112
    Height = 15
    Caption = 'System Number:'
  end
  object Label5: TLabel
    Left = 195
    Top = 234
    Width = 72
    Height = 15
    Caption = 'Password:'
  end
  object Label6: TLabel
    Left = 412
    Top = 82
    Width = 72
    Height = 15
    Caption = 'Language:'
  end
  object Label7: TLabel
    Left = 195
    Top = 184
    Width = 40
    Height = 15
    Caption = 'User:'
  end
  object Label8: TLabel
    Left = 412
    Top = 32
    Width = 56
    Height = 15
    Caption = 'Client:'
  end
  object Label9: TLabel
    Left = 412
    Top = 133
    Width = 80
    Height = 15
    Caption = 'Code Page:'
  end
  object Label10: TLabel
    Left = 195
    Top = 133
    Width = 88
    Height = 15
    Caption = 'App Server:'
  end
  object Label11: TLabel
    Left = 195
    Top = 284
    Width = 64
    Height = 15
    Caption = 'System_:'
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
    Top = 387
    Width = 55
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = #28155#21152
    TabOrder = 1
    OnClick = BtnAddClick
  end
  object BtnDel: TButton
    Left = 65
    Top = 387
    Width = 55
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = #21024#38500
    TabOrder = 2
    OnClick = BtnDelClick
  end
  object EditID: TEdit
    Left = 195
    Top = 50
    Width = 200
    Height = 23
    TabOrder = 3
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
    OnKeyPress = EditIDKeyPress
  end
  object EditName: TEdit
    Left = 195
    Top = 100
    Width = 200
    Height = 23
    TabOrder = 4
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object BtnExit: TButton
    Left = 534
    Top = 387
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 14
  end
  object BtnOK: TButton
    Left = 454
    Top = 387
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #30830#23450
    TabOrder = 13
    OnClick = BtnOKClick
  end
  object EditUser: TEdit
    Left = 195
    Top = 200
    Width = 200
    Height = 23
    TabOrder = 6
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditPwd: TEdit
    Left = 195
    Top = 251
    Width = 200
    Height = 23
    PasswordChar = '*'
    TabOrder = 7
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditLang: TEdit
    Left = 412
    Top = 100
    Width = 200
    Height = 23
    TabOrder = 11
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditNum: TEdit
    Left = 195
    Top = 351
    Width = 200
    Height = 23
    TabOrder = 9
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditClient: TEdit
    Left = 412
    Top = 50
    Width = 200
    Height = 23
    TabOrder = 10
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditPage: TEdit
    Left = 412
    Top = 150
    Width = 200
    Height = 23
    TabOrder = 12
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditServer: TEdit
    Left = 195
    Top = 150
    Width = 200
    Height = 23
    TabOrder = 5
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
  object EditSystem: TEdit
    Left = 195
    Top = 301
    Width = 200
    Height = 23
    TabOrder = 8
    OnChange = EditIDChange
    OnKeyDown = OnCtrlKeyDown
  end
end
