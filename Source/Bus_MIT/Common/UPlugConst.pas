{*******************************************************************************
  作者: dmzn@163.com 2013-11-22
  描述: 插件模块公用常量定义
*******************************************************************************}
unit UPlugConst;

interface

const
  {*Form ID*}
  cFI_Base            = $0100;                       //标识参考
  cFI_FormTest1       = cFI_Base + $001;
  cFI_FormTest2       = cFI_Base + $002;

ResourceString
  sHint               = '提示';                      //对话框标题
  sWarn               = '警告';                      //==
  sAsk                = '询问';                      //询问对话框
  sError              = '错误';                      //错误对话框

implementation

end.
