unit Auxiliar.Datas;

interface

uses
  Winapi.Windows,
  System.SysUtils;

  function NomeDia(const i: Word; const Tipo: Integer): String;
  function NomeMes(const i: Word; const Tipo: integer): String;
  function DataPorExtenso: String;
  function DataStr: String;
  function HoraStr: String;
  function DataHoraStr: String;
  function DataSQL(pData: String): String;

const
   aDiaSemana : array [0 .. 6]  of string = ('Domingo','Segunda','Ter?a','Quarta','Quinta','Sexta','S?bado');
   aMes       : array [1 .. 12] of string = ('Janeiro','Fevereiro','Mar?o','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro');

implementation

///####################################################################################################################
/// Fun??o   : NomeDia()
/// Objetivo : Respons?vel Pelo Retorno do Nome do Dia da Semana
///####################################################################################################################
function NomeDia(const i: Word; const Tipo: Integer): String;
begin
  if (tipo = 0) then
     Result := aDiaSemana[i] // extenso
  else
     Result := copy(aDiaSemana[i], 1, 3); // abreviado
end;

///####################################################################################################################
/// Fun??o   : NomeMes()
/// Objetivo : Respons?vel Pelo Retorno do Nome do M?s
///####################################################################################################################
function NomeMes(const i: Word; const Tipo: integer): String;
begin
  if (tipo = 0) then
     Result := aMes[i] // Extenso
  else
     Result := copy(aMes[i], 1, 3); // Abreviado
end;

///####################################################################################################################
/// Fun??o   : DataPorExtenso()
/// Objetivo : Respons?vel Pelo Retorno da Data Por Extenso
///####################################################################################################################
function DataPorExtenso: String;
var
  NoDia: integer;
  Dta: TDateTime;
  Dia, mes, Ano: word;

begin
  Dta := Date;
  DecodeDate(Dta, Ano, mes, Dia);
  NoDia := DayOfWeek(Dta) - 1;
  Result := Format('%s, %s de %s de %s',[NomeDia(NoDia, 0), IntToStr(Dia), NomeMes(mes, 0), IntToStr(Ano)]);
end;

///####################################################################################################################
/// Fun??o   : Data()
/// Objetivo : Respons?vel Pelo Retorno da Data do Sistema
///####################################################################################################################
function DataStr: String;
begin
  Result := FormatDateTime('dd/mm/yyyy', Date);
end;

///####################################################################################################################
/// Fun??o   : Hora()
/// Objetivo : Respons?vel Pelo Retorno da Hora do Sistema
///####################################################################################################################
function HoraStr: String;
begin
  Result := TimeToStr(Time);
end;

///####################################################################################################################
/// Fun??o   : DataHora()
/// Objetivo : Respons?vel Pelo Retorno da Data com a Hora do Sistema
///####################################################################################################################
function DataHoraStr: String;
begin
  Result := FormatDateTime('dd/mm/yyyy hh:nn:ss', Now);
end;

///####################################################################################################################
/// Fun??o   : DataSQL()
/// Objetivo : Respons?vel Pelo Retorno da Data para Sintaxe SQL
///####################################################################################################################
function DataSQL(pData: String): String;
var
  DataSys: TDateTime;

begin
  if TryStrToDateTime(pData, DataSys) then
     Result := FormatDateTime('yyyy-dd-mm hh:nn:ss', DataSys)
  else
     Result := 'NULL';
end;

end.
