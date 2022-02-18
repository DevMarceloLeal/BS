unit Auxiliar.Conversoes;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Variants;

  function ToStr(const Value: Variant): String;
  function StringToFloat(const cNumero : Variant): Currency;
  function StrCurrency(const cNumero: Variant): Currency;
  function StrZero(pValor: Variant; pQtd: Integer): string;
  function Moeda(const Texto : Variant) : string;
  function StrToAlignment(const Alignment: String ): TAlignment;

implementation

///####################################################################################################################
/// Função   : ToStr()
/// Objetivo : Responsável Pela Conversão de Qualquer Variável em String
///####################################################################################################################
function ToStr(const Value: Variant): String;
begin
  case TVarData(Value).VType of
    varSmallInt, varInteger :
       Result := IntToStr(Value);
    varSingle, varDouble :
       Result := FloatToStr(Value).Replace('.','');
    varCurrency :
       Result := CurrToStr(Value).Replace('.','');
    varDate :
       Result := FormatDateTime('dd/mm/yyyy', Value);
    varBoolean :
       if Value then
          Result := 'T'
       else
          Result := 'F';
  else
     Result := VarToStr(Value);
  end;
end;

///####################################################################################################################
/// Função   : StringToFloat()
/// Objetivo : Responsável Pela Conversão de STRINGS em FLOAT
///####################################################################################################################
function StringToFloat(const cNumero: Variant): Currency;
begin
  if ToStr(cNumero) <> '0.00' then
     Result := StrToFloat(ToStr(cNumero).Replace('.',''))
  else
     Result := 0.00;
end;

///####################################################################################################################
/// Função   : StrCurrency()
/// Objetivo : Responsável Pela Conversão de STRINGS em FLOAT
///####################################################################################################################
function StrCurrency(const cNumero: Variant): Currency;
begin
  if ToStr(cNumero) <> '0.00' then
     Result := StrToFloat(ToStr(cNumero).Replace('.',''))
  else
     Result := 0.00;
end;

///####################################################################################################################
// Função   : StrZero
// Objetivo : Responsável Pelo Preenchimento de Zeros à Esquerda da String
///####################################################################################################################
function StrZero(pValor: Variant; pQtd: Integer): string;
var
  i, vTam: Integer;
  vAux: String;

begin
  vAux   := pValor;
  vTam   := Length( ToStr(pValor) );
  pValor := '';

  for i := 1 to pQtd - vTam do
    pValor := '0' + pValor;

  vAux   := pValor + vAux;
  result := vAux;
end;

///####################################################################################################################
/// Função   : Moeda()
/// Objetivo : Responsável Pela Conversão de Variáveis em Formato MOEDA
///####################################################################################################################
function Moeda(const Texto: Variant): String;
begin
  if ToStr(Texto) <> EmptyStr then
     Result := FormatCurr('###,##0.00', StrCurrency(Texto))
  else
     Result := '0,00';
end;

///####################################################################################################################
/// Função   : StrToAlignment()
/// Objetivo : Responsável Por Converter Strings em TAlignment
///####################################################################################################################
function StrToAlignment(const Alignment: String ): TAlignment;
begin
  if (Alignment = 'Right') or (Alignment = 'taRight') then
     Result := TAlignment.taRightJustify
  else if (Alignment = 'Left') or (Alignment = 'taLeft') then
     Result := TAlignment.taLeftJustify
  else
     Result := TAlignment.taCenter;
end;

end.
