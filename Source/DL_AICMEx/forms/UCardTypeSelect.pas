unit UCardTypeSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxGroupBox, cxRadioGroup,
  Menus, cxButtons;

type
  TfFormCardTypeSelect = class(TForm)
    rgCardType: TcxRadioGroup;
    btnOk: TcxButton;
    btnCancel: TcxButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fFormCardTypeSelect: TfFormCardTypeSelect;

implementation

{$R *.dfm}

procedure TfFormCardTypeSelect.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfFormCardTypeSelect.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
