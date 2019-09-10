unit uReadCardThread;

interface
uses
  Classes,Uszttce_api;
type
  TReadCardThread = class(TThread)
  private
    FSzttceApi:TSzttceApi;
  protected
    procedure Execute; override;
  public
    property SzttceApi:TSzttceApi read FSzttceApi write FSzttceApi;
    property Terminated;
  end;

implementation
uses
  SysUtils,ULibFun,UFormMain;

resourcestring
  sHint       = 'Ã· æ';
{ TReadCardThread }

procedure TReadCardThread.Execute;
var
  nCard,nStr: string;
begin
  nCard := '';
  if not FSzttceApi.IsInsertedCard then
  begin
    nStr := '∂¡»°ø®∫≈ ß∞‹£∫[Errorcode=%d,ErrorMsg=%s]';
    nStr := Format(nStr,[FSzttceApi.ErrorCode,FSzttceApi.ErrorMsg]);
    Exit;
  end;
//  fFormMain.TimerInsertCard.Enabled := False;
  if not FSzttceApi.ReadCardSerialNo(nCard) then
  begin
    nStr := '∂¡»°ø®∫≈ ß∞‹£∫[Errorcode=%d,ErrorMsg=%s],«Î…‘∫Û÷ÿ ‘';
    nStr := Format(nStr,[FSzttceApi.ErrorCode,FSzttceApi.ErrorMsg]);
    ShowMsg(nStr,sHint);
//    fFormMain.TimerInsertCard.Enabled := True;
    Exit;
  end;
  fFormMain.FCardType := ctTTCE;
  fFormMain.QueryCard(nCard);
end;

end.
 