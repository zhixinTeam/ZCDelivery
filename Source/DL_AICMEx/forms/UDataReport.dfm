object FDR: TFDR
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 416
  Top = 315
  Height = 225
  Width = 269
  object Report1: TfrxReport
    Version = '4.7.109'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.AllowEdit = False
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = #39044#35774
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 40029.413540046300000000
    ReportOptions.LastChange = 40029.729132129630000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    OnGetValue = Report1GetValue
    OnAfterPrintReport = Report1AfterPrintReport
    Left = 28
    Top = 16
    Datasets = <>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
    end
  end
  object Dataset1: TfrxDBDataset
    UserName = 'DA'
    CloseDataSource = False
    BCDToCurrency = False
    Left = 30
    Top = 70
  end
  object Dataset2: TfrxDBDataset
    UserName = 'DB'
    CloseDataSource = False
    BCDToCurrency = False
    Left = 86
    Top = 70
  end
  object Designer1: TfrxDesigner
    DefaultScriptLanguage = 'PascalScript'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = -13
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    DefaultLeftMargin = 10.000000000000000000
    DefaultRightMargin = 10.000000000000000000
    DefaultTopMargin = 10.000000000000000000
    DefaultBottomMargin = 10.000000000000000000
    DefaultPaperSize = 9
    DefaultOrientation = poPortrait
    TemplatesExt = 'fr3'
    Restrictions = []
    RTLLanguage = False
    MemoParentFont = False
    Left = 86
    Top = 16
  end
  object UserDS1: TfrxUserDataSet
    UserName = 'UA'
    Left = 138
    Top = 16
  end
  object Gradient1: TfrxGradientObject
    Left = 32
    Top = 134
  end
  object Rich1: TfrxRichObject
    Left = 88
    Top = 132
  end
  object Cross1: TfrxCrossObject
    Left = 140
    Top = 132
  end
  object Dataset3: TfrxDBDataset
    UserName = 'DC'
    CloseDataSource = False
    BCDToCurrency = False
    Left = 138
    Top = 70
  end
end
