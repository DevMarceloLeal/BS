unit Auxiliar.Calculos;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Variants,
  Data.DB;

  function CalculaPercentual(const nMaior, nMenor: Variant): Currency;
  function CalculaValor(const nNumero, nPercentual: Variant): Currency;
  function CalculaTotal(const nNumero1, nNumero2: Variant): Currency;
  function TotalizarCampoDataSet(pCampoTotalizador: String; pDsResultados: TDataSet): Currency;

implementation

///####################################################################################################################
/// Função   : CalculaPercentual()
/// Objetivo : Responsável por Calcular o Percentual à Partir de Dois Valores
///####################################################################################################################
function CalculaPercentual(const nMaior, nMenor: Variant): Currency;
begin
  Result := (nMenor / nMaior) * 100;
end;

///####################################################################################################################
/// Função   : CalculaValor()
/// Objetivo : Responsável por Calcular o Valor Pelo Percentual
///####################################################################################################################
function CalculaValor(const nNumero, nPercentual: Variant): Currency;
begin
  Result := (nNumero * nPercentual) / 100;
end;

///####################################################################################################################
/// Função   : CalculaTotal()
/// Objetivo : Responsável por Calcular o Valor Pelo Percentual
///####################################################################################################################
function CalculaTotal(const nNumero1, nNumero2: Variant): Currency;
begin
  Result := nNumero1 * nNumero2;
end;

///####################################################################################################################
/// Função   : TotalizarCampoDataSet()
/// Objetivo : Responsável por Totalizar um Determinado Campo de um DataSet
///####################################################################################################################
function TotalizarCampoDataSet(pCampoTotalizador: String; pDsResultados: TDataSet): Currency;
var
  FTotal: Currency;

begin
  FTotal := 0.00;

  pDsResultados.First;
  while not pDsResultados.Eof do
    begin
      FTotal := FTotal + pDsResultados.FieldByName(pCampoTotalizador).AsCurrency;
      pDsResultados.Next
    end;
  pDsResultados.First;

  Result := FTotal;
end;

end.
