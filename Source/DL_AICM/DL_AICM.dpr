program DL_AICM;

uses
  Forms,
  USysModule,
  UMITPacker,
  UDataModule in 'forms\UDataModule.pas' {FDM: TDataModule},
  UFormMain in 'forms\UFormMain.pas' {fFormMain},
  uReadCardThread in 'uReadCardThread.pas';

{$R *.res}

begin
  Application.Initialize;
  InitSystemObject;
  Application.CreateForm(TFDM, FDM);
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.
