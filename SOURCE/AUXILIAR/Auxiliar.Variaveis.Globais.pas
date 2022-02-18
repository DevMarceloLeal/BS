unit Auxiliar.Variaveis.Globais;

interface

uses
  Vcl.Forms,
  Datasnap.DBClient;

type
  TOperacao = (opNovo, opAlterar, opExcluir, opConsultar, opListar, opCancelar);
  TResultado = Array of String;
  TListaExclusao = Array of Integer;

var
  gTopo: Integer;
  gEsquerda: Integer;
  gLargura: Integer;
  gComprimento: Integer;
  gPosicao: TPosition = poMainFormCenter;
  gNumeroPedido: String;
  gAcertouEstoque: Boolean;
  gJanelas_Abertas: Integer;

implementation

end.
