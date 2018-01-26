program RemotePrinter;

uses
  FastMM4,
  Forms,
  UDataReport,
  UFormMain in 'UFormMain.pas' {fFormMain},
  UDataModule in 'UDataModule.pas' {FDM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFDM, FDM);
  Application.CreateForm(TFDR, FDR);
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.
