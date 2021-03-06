unit Auxiliar.Formatacoes;

interface

uses
  System.SysUtils,
  Data.DB,
  Auxiliar.Dialogos;

  function FormataCNPJ(const nCNPJ: String): String;
  function FormataCPF(const nCPF: String): String;
  function FormataCEP(const nCEP: String): String;
  function FormataTEL(const cNumTel: String): String;
  function Pula_Linha(const Texto: String): String;

implementation

Const
  Fim = '<EOF>';

///####################################################################################################################
/// Fun??o   : FormataCNPJ()
/// Objetivo : Respons?vel pela Formata??o do CNPJ : 99.999.999.9999-99
///####################################################################################################################
function FormataCNPJ(const nCNPJ: String): String;
var
  CNPJ : String;

begin
  { Retira a Formata??o Caso Ela Exista }
  CNPJ := nCNPJ.Replace('.','').Replace('/','').Replace('-','');

  { Cria uma Nova Formata??o }
  Result := Format('%s.%s.%s/%s-%s',[copy(CNPJ, 1, 2), copy(CNPJ, 3, 3), copy(CNPJ, 6, 3), copy(CNPJ, 9, 4), copy(CNPJ, 13, 2)]);
end;

///####################################################################################################################
/// Fun??o   : FormataCPF()
/// Objetivo : Respons?vel pela Formata??o do CPF : 999.999.999-99
///####################################################################################################################
function FormataCPF(const nCPF: String): String;
var
  CPF : String;

begin
  { Retira a Formata??o Caso Ela Exista }
  CPF := nCPF.Replace('.','').Replace('-','');

  { Cria uma Nova Formata??o }
  Result := Format('%s.%s.%s-%s', [copy(CPF, 1, 3), copy(CPF, 4, 3), copy(CPF, 7, 3), copy(CPF, 10, 2)]);
end;

///####################################################################################################################
/// Fun??o   : FormataCEP()
/// Objetivo : Respons?vel pela Formata??o do CEP : 99999-999
///####################################################################################################################
function FormataCEP(const nCEP: String): String;
var
  CEP : String;

begin
  { Retira a Formata??o Caso Ela Exista }
  CEP := nCEP.Replace('-','');

  { Cria uma Nova Formata??o }
  Result := Format('%s-%s', [copy(CEP, 1, 5), copy(CEP, 6, 3)]);
end;

///####################################################################################################################
/// Fun??o   : FormataTEL()
/// Objetivo : Respons?vel Pela Formata??o do N? do Telefone
///####################################################################################################################
function FormataTEL(const cNumTel: String): String;
var
  cVartel : string;

begin
  cVarTel := '';
  if (cNumTel <> '') then
     begin
       cVarTel := cNumTel.Replace('(', '').Replace(')', '').Replace('-', '').Replace(' ', '');

       if (cVarTel.Substring(1, 4).Contains('0800')) then
          begin
            cVarTel := Format('(%s) %s-%s',[Copy(cVarTel, 1, 4), Copy(cVarTel, 5, 3), Copy(cVarTel, 8, 4)]);
            Result := cVarTel;
            Exit;
          end;

       if (cVarTel.Length = 8) or (cVarTel.Length = 10) then
          begin
            if cVarTel.Length = 8 then
               cVarTel := Format('(21) %s-%s',[Copy(cVarTel, 1, 4), Copy(cVarTel, 5, 4)])
            else if (cVarTel.Length = 10) then
               cVarTel := Format('(%s) %s-%s',[Copy(cVarTel, 1, 2), Copy(cVarTel, 3, 4), Copy(cVarTel, 7, 4)]);

            Result := cVarTel;
            Exit;
          end;

       if (cVarTel.Length = 9) or (cVarTel.Length = 11) then
          begin
            if (cVarTel.Length = 9) then
               cVarTel := Format('(21) %s-%s',[Copy(cVarTel, 1, 5), Copy(cVarTel, 6, 4)])
            else if (cVarTel.Length = 11) then
               cVarTel := Format('(%s) %s-%s',[Copy(cVarTel, 1, 2), Copy(cVarTel, 3, 5), Copy(cVarTel, 8, 4)]);

            Result := cVarTel;
            Exit;
          end
       else if (cVarTel.Length < 8) or (cVarTel.Length > 11) then
          begin
            MsgSys('N?mero de Telefone Incorreto !!!', 3);
            Result := '';
            Exit;
          end;
     end;
end;

///####################################################################################################################
// Fun??o   : Pula_Linha()
// Objetivo : Respons?vel Pelo Pulo de Linhas
///####################################################################################################################
function Pula_Linha(const Texto: String): String;
var
 i: Integer;
 Teste: String;

begin
 i := 1;
 while i <= Length(Texto) do
   begin
     if Texto[i] = '<' then
        begin
          Teste := Copy(Texto, i, 5);
          if Teste = '<EOF>' then
             begin
               Result := Result + #13;
               Inc(i, 5);
             end;
        end;

     Result := Result + Texto[i];
     Inc(i)
   end;
end;

end.
