unit Auxiliar.Comandos.SQL;

interface

uses
  System.SysUtils,
  Vcl.Dialogs,
  Auxiliar.Conversoes;

  function SQL_Banco_Dados_Existe(pBanco: String; pDriverID: String = 'MySQL'): String;
  function SQL_Criar_Banco_Dados(pBanco: String; pDriverID: String = 'MySQL'): String;
  function SQL_Tabela_Dados_Existe(pBanco, pTabela: String; pDriverID: String = 'MySQL'): String;
  function SQL_Criar_Tabela_Dados(pTabela, pCampos: String; pDriverID: String = 'MySQL'): String;
  function SQL_Gerar_ID(pBanco, pTabela: String; pDriverID: String = 'MySQL'): String;
  function SQL_Selecao_Registros(pTabela, pCampo: String; pTexto: String = ''; pCampoBusca: String = ''): String;
  function SQL_Selecionar_Registro(pTabela: String; pCampo, pTexto: Array of String; pTodos: Boolean = False): String;
  function SQL_Excluir_Registros(pTabela, pCampo, pTexto: String): String;
  function SQL_Incrementar_ID(pTabela: String; pLiga: Boolean = True): String;
  function SQL_Selecionar_Doacoes(pCampos, pTextos: Array of String; pTodos: Boolean = True; pContido: Boolean = False): String;
  function SQL_Selecionar_Ultima_Doacao(pDoador, pData: String): String;

implementation

///####################################################################################################################
/// Fun??o   : Banco_Dados_Existe()
/// Objetivo : Retorna o Comando SQL P/Verificar Exist?ncia do Banco de Dados
///####################################################################################################################
function SQL_Banco_Dados_Existe(pBanco: String; pDriverID: String = 'MySQL'): String;
begin
  if pDriverID = 'MySQL' then
     Result := Format('SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = "%s")',[pBanco])
  else if pDriverID = 'MSSQL' then
     Result := Format('SELECT NAME FROM master.dbo.sysdatabases WHERE NAME = %s',[QuotedStr(pBanco)]);
end;

///####################################################################################################################
/// Fun??o   : Criar_Banco_Dados()
/// Objetivo : Retorna o Comando SQL P/Criar Banco de Dados
///####################################################################################################################
function SQL_Criar_Banco_Dados(pBanco: String; pDriverID: String = 'MySQL'): String;
begin
  if pDriverID = 'MySQL' then
     Result := Format('CREATE DATABASE IF NOT EXISTS %s DEFAULT CHARACTER SET latin1 DEFAULT COLLATE latin1_general_ci',[pBanco])
  else if pDriverID = 'MSSQL' then
     Result := Format('CREATE DATABASE %s ',[pBanco])
end;

///####################################################################################################################
/// Fun??o   : Tabela_Dados_Existe()
/// Objetivo : Retorna o Comando SQL P/Verificar Exist?ncia da Tabela de Dados
///####################################################################################################################
function SQL_Tabela_Dados_Existe(pBanco, pTabela: String; pDriverID: String = 'MySQL'): String;
begin
  if pDriverID = 'MySQL' then
     Result := Format('SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = %s AND TABLE_NAME = %s)',[QuotedStr(pBanco), QuotedStr(pTabela)])
  else if pDriverID = 'MSSQL' then
     Result := Format('SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = %s AND TABLE_NAME = %s',[QuotedStr(pBanco), QuotedStr(pTabela)]);
end;

///####################################################################################################################
/// Fun??o   : Criar_Tabela_Dados()
/// Objetivo : Respons?vel Por Retornar o Comando SQL P/Criar Tabela de Dados
///####################################################################################################################
function SQL_Criar_Tabela_Dados(pTabela, pCampos: String; pDriverID: String = 'MySQL'): String;
begin
  if pDriverID = 'MySQL' then
     Result := Format('CREATE TABLE IF NOT EXISTS %s (%s) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci AUTO_INCREMENT=1', [pTabela, pCampos])
  else if pDriverID = 'MSSQL' then
     Result := Format('CREATE TABLE %s (%s) ',[pTabela, pCampos]);
end;

///####################################################################################################################
/// Fun??o   : Criar_Tabela_Dados()
/// Objetivo : Respons?vel Por Retornar o Comando SQL P/Criar Tabela de Dados
///####################################################################################################################
function SQL_Gerar_ID(pBanco, pTabela: String; pDriverID: String = 'MySQL'): String;
begin
  if pDriverID = 'MySQL' then
     Result := Format('SELECT * FROM TABLES WHERE table_schema = "%s" AND table_name = "%s"',[pBanco, pTabela])
  else if pDriverID = 'MSSQL' then
     Result := Format('SELECT IDENT_CURRENT(%s) AS Identity_Increment',[QuotedSTr(pTabela)]);
end;

///####################################################################################################################
/// Fun??o   : SQL_Selecao_Registros()
/// Objetivo : Respons?vel Por Retornar o Comando SQL => SELECT de Registros
///####################################################################################################################
function SQL_Selecao_Registros(pTabela, pCampo: String; pTexto: String = ''; pCampoBusca: String = ''): String;
begin
  Result := Format('SELECT TOP (150) %s FROM %s',[pCampo, pTabela]);
  if pTexto <> ''  then
     Result := Format('%s WHERE %s LIKE %s',[Result, pCampoBusca, QuotedStr('%' + pTexto + '%')]);
end;

///####################################################################################################################
/// Fun??o   : SQL_Selecionar_Registro()
/// Objetivo : Respons?vel Por Retornar o Comando SQL => SELECT de Registro
///####################################################################################################################
function SQL_Selecionar_Registro(pTabela: String; pCampo, pTexto: Array of String; pTodos: Boolean = False): String;
var
  i: Integer;

begin
  Result := Format('SELECT TOP (150) %s FROM %s WHERE %s = %s', [pCampo[0], pTabela, pCampo[0], QuotedStr(pTexto[0])]);
  if (pTodos) and (Length(pCampo) = 1) then
     Result := Format('SELECT TOP (150) * FROM %s WHERE %s = %s', [pTabela, pCampo[0], QuotedStr(pTexto[0])])
  else
     begin
       Result := Format('SELECT TOP (150) * FROM %s WHERE', [pTabela]);
       for i := 0 to Length(pCampo) - 1 do
         begin
           if i < Length(pCampo) - 1 then
              Result := Format('%s %s = %s AND', [Result, pCampo[i], QuotedStr(pTexto[i])])
           else
              Result := Format('%s %s = %s', [Result, pCampo[i], QuotedStr(pTexto[i])]);
         end;
     end;
end;

///####################################################################################################################
/// Fun??o   : SQL_Excluir_Registros()
/// Objetivo : Respons?vel Por Retornar o Comando SQL => DELETE
///####################################################################################################################
function SQL_Excluir_Registros(pTabela, pCampo, pTexto: String): String;
begin
  Result :=  Format('DELETE FROM %s WHERE %s = %s', [pTabela, pCampo, QuotedStr(pTexto)]);
end;

///####################################################################################################################
/// Fun??o   : SQL_Incrementar_ID
/// Objetivo : Respons?vel Por Retornar o Comando SQL => Incrementar ID SQL SERVER
///####################################################################################################################
function SQL_Incrementar_ID(pTabela: String; pLiga: Boolean = True): String;
begin
  Result := Format('SET IDENTITY_INSERT dbo.%s ON %s', [pTabela, #13]);
  if not pLiga then
     Result := Format('SET IDENTITY_INSERT dbo.%s OFF', [pTabela]);
end;

///####################################################################################################################
/// Fun??o   : SQL_Selecionar_Doacoes()
/// Objetivo : Respons?vel Por Retornar o Comando SQL => SELECT
///####################################################################################################################
function SQL_Selecionar_Doacoes(pCampos, pTextos: Array of String; pTodos: Boolean = True; pContido: Boolean = False): String;
var
  i: Integer;

begin
  Result := Format('SELECT TOP (150) *, IIF(DOA_STATUS = %s, %s, %s) AS STATUS FROM BS_DOACAO INNER JOIN BS_PESSOA ON BS_PESSOA.PES_ID = BS_DOACAO.PES_ID',[QuotedStr(''), QuotedStr(''), QuotedStr('* ANULADA *')]);
  if pContido then
     begin
       Result := Format('%s WHERE',[Result]);
       for i := 0 to Length(pCampos) - 1 do
           begin
             if i < Length(pCampos) - 1 then
                begin
                  if not pContido then
                     Result := Format('%s %s = %s AND', [Result, pCampos[i], QuotedStr(pTextos[i])])
                  else
                     Result := Format('%s %s LIKE %s AND', [Result, pCampos[i], QuotedStr('%' + pTextos[i] + '%')])
                end
             else
                begin
                  if not pContido then
                     Result := Format('%s %s = %s', [Result, pCampos[i], QuotedStr(pTextos[i])])
                  else
                     Result := Format('%s %s LIKE %s', [Result, pCampos[i], QuotedStr('%' + pTextos[i] + '%')])
                end
           end;
     end;
end;

///####################################################################################################################
/// Fun??o   : SQL_Selecionar_Ultima_Doacao()
/// Objetivo : Respons?vel Por Retornar o Comando SQL => SELECT ?ltima Doa??o
///####################################################################################################################
function SQL_Selecionar_Ultima_Doacao(pDoador, pData: String): String;
begin
  Result := Format('SELECT TOP (1) * FROM BS_DOACAO WHERE PES_ID = %s AND DOA_DATA <= %s AND DOA_STATUS = %s ORDER BY DOA_DATA DESC', [QuotedStr(pDoador), QuotedStr(pData), QuotedStr('')]);
end;

end.
