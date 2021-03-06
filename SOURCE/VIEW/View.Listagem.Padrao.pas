unit View.Listagem.Padrao;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Data.DB,
  RLReport;

type
  TfrmBaseListagem = class(TForm)
    RLReportBase: TRLReport;
    RLBand_Cabecalho_Titulo: TRLBand;
    RLSystemInfo1: TRLSystemInfo;
    RLSystemInfo2: TRLSystemInfo;
    RLSystemInfo4: TRLSystemInfo;
    RLBand_Dados_Header: TRLBand;
    RLLblCampo1: TRLLabel;
    RLLblCampo2: TRLLabel;
    RLLblCampo3: TRLLabel;
    RLBand_Dados_Registros: TRLBand;
    RLDBText1: TRLDBText;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLBand_Rodape: TRLBand;
    RLSystemInfo3: TRLSystemInfo;
    RLSystemInfo5: TRLSystemInfo;
    RLLblCampo4: TRLLabel;
    RLLblCampo5: TRLLabel;
    RLLblCampo6: TRLLabel;
    RLLblCampo7: TRLLabel;
    RLLblCampo8: TRLLabel;
    RLLblCampo9: TRLLabel;
    RLDBText4: TRLDBText;
    RLDBText5: TRLDBText;
    RLDBText6: TRLDBText;
    RLDBText7: TRLDBText;
    RLDBText8: TRLDBText;
    RLDBText9: TRLDBText;
    RLBandTotais: TRLBand;
    rlLabelTotal1: TRLLabel;
    RLDBResult1: TRLDBResult;
    rlLabelTotal2: TRLLabel;
    RLDBResult2: TRLDBResult;
    rlLabelTotal3: TRLLabel;
    RLDBResult3: TRLDBResult;
    rlLabelTotal4: TRLLabel;
    RLDBResult4: TRLDBResult;
    { Private declarations }
  public
  end;

var
  frmBaseListagem: TfrmBaseListagem;

implementation

{$R *.dfm}

end.
