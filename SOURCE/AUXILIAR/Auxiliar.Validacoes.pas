unit Auxiliar.Validacoes;

interface

uses
  System.SysUtils,
  Winapi.Windows,
  Winapi.WinInet,
  Auxiliar.Dialogos;

  function IsNumero(const Texto: String): Boolean;
  function IsLetra(const Texto: String): Boolean;
  function iif(Condicao, ParteTRUE, ParteFALSE: Variant): Variant;

  function IsEmailValido(const Value: string): boolean;
  function IsCPFValido(CPF: string): Boolean;

const
  FSiteList: array of PWidechar = ['http://www.google.com/', 'http://www.microsoft.com/', 'http://www.yahoo.com/'];

implementation

/// ####################################################################################################################
/// Fun??o   : IsNumero()
/// Objetivo : Respons?vel Pela Verifica??o da Exist?ncia de N?meros em Uma Vari?vel
/// ####################################################################################################################
function IsNumero(const Texto: String): Boolean;
var
  i: integer;

begin
  Result := False;
  for i := 1 to Length(Texto) do
    if (CharInSet(Texto[i], ['0' .. '9'])) or
       (String(Texto[i]).Contains('.')) or
       (String(Texto[i]).Contains(',')) then
       Result := True
    else
       begin
         Msg('Somente N?meros S?o Permitidos !!!', '', 3);
         keybd_event(VK_BACK, 0, 0, 0);
         Result := False;
       end;
end;

/// ####################################################################################################################
/// Fun??o   : IsLetra()
/// Objetivo : Respons?vel Pela Verifica??o da Exist?ncia de Letras em Uma Vari?vel
/// ####################################################################################################################
function IsLetra(const Texto: String): Boolean;
var
  i: integer;

begin
  Result := False;
  for i := 1 to Length(Texto) do
    if CharInSet(Texto[i], ['a' .. 'z', 'A' .. 'Z']) then
       Result := True
    else
       begin
         Msg('Somente Letras S?o Permitidas !!!', '', 3);
         keybd_event(VK_BACK, 0, 0, 0);
         Result := False;
       end;
end;

/// ####################################################################################################################
/// Fun??o   : IsInternet()
/// Objetivo : Verifica Se Existe Conex?o Com a Internet
/// ####################################################################################################################
function IsInternet: Boolean;
var
  i: Byte;

begin
  Result := False;

  for i := 0 to Pred(Length(FSiteList)) do
    begin
      Result := InternetCheckConnection(FSiteList[i], 1, 0);
      if Result then
         Break;
    end;
end;

/// ####################################################################################################################
/// Fun??o   : IIF()
/// Objetivo : Respons?vel Por Pequenos e R?pidos Testes
/// ####################################################################################################################
function iif(Condicao, ParteTRUE, ParteFALSE: Variant): Variant;
begin
  if Condicao then
     Result := ParteTRUE
  else
     Result := ParteFALSE;
end;

/// ####################################################################################################################
/// Fun??o   : ValidaCNPJ()
/// Objetivo : Respons?vel pela valida??o de CNPJ'S
/// ####################################################################################################################
function ValidarCNPJ(const pCNPJ: String): Boolean;
var
  v: array [1 .. 2] of Word;
  cnpj: array [1 .. 14] of Byte;
  i: Byte;

begin
  try
    for i := 1 to 14 do
      cnpj[i] := StrToInt(pCNPJ[i]);

    // Nota: Calcula o primeiro d?gito de verifica??o.
    v[1] := 5 * cnpj[1] + 4 * cnpj[2] + 3 * cnpj[3] + 2 * cnpj[4];
    v[1] := v[1] + 9 * cnpj[5] + 8 * cnpj[6] + 7 * cnpj[7] + 6 * cnpj[8];
    v[1] := v[1] + 5 * cnpj[9] + 4 * cnpj[10] + 3 * cnpj[11] + 2 * cnpj[12];
    v[1] := 11 - v[1] mod 11;
    v[1] := iif(v[1] >= 10, 0, v[1]);

    // Nota: Calcula o segundo d?gito de verifica??o.
    v[2] := 6 * cnpj[1] + 5 * cnpj[2] + 4 * cnpj[3] + 3 * cnpj[4];
    v[2] := v[2] + 2 * cnpj[5] + 9 * cnpj[6] + 8 * cnpj[7] + 7 * cnpj[8];
    v[2] := v[2] + 6 * cnpj[9] + 5 * cnpj[10] + 4 * cnpj[11] + 3 * cnpj[12];
    v[2] := v[2] + 2 * v[1];
    v[2] := 11 - v[2] mod 11;
    v[2] := iif(v[2] >= 10, 0, v[2]);

    // Nota: Verdadeiro se os d?gitos de verifica??o s?o os esperados.
    Result := ((v[1] = cnpj[13]) and (v[2] = cnpj[14]));
  except
    on E: Exception do
      Result := False;
  end;
end;

/// ####################################################################################################################
/// Fun??o   : ValidaCPF()
/// Objetivo : Respons?vel pela valida??o de CPF
/// ####################################################################################################################
function ValidarCPF(const pCPF: String): Boolean;
var
  v: array [0 .. 1] of Word;
  cpf: array [0 .. 10] of Byte;
  i: Byte;

begin
  try
    for i := 1 to 11 do
      cpf[i - 1] := StrToInt(pCPF[i]);

    // Nota: Calcula o primeiro d?gito de verifica??o.
    v[0] := 10 * cpf[0] + 9 * cpf[1] + 8 * cpf[2];
    v[0] := v[0] + 7 * cpf[3] + 6 * cpf[4] + 5 * cpf[5];
    v[0] := v[0] + 4 * cpf[6] + 3 * cpf[7] + 2 * cpf[8];
    v[0] := 11 - v[0] mod 11;
    v[0] := iif(v[0] >= 10, 0, v[0]);

    // Nota: Calcula o segundo d?gito de verifica??o.
    v[1] := 11 * cpf[0] + 10 * cpf[1] + 9 * cpf[2];
    v[1] := v[1] + 8 * cpf[3] + 7 * cpf[4] + 6 * cpf[5];
    v[1] := v[1] + 5 * cpf[6] + 4 * cpf[7] + 3 * cpf[8];
    v[1] := v[1] + 2 * v[0];
    v[1] := 11 - v[1] mod 11;
    v[1] := iif(v[1] >= 10, 0, v[1]);

    // Nota: Verdadeiro se os d?gitos de verifica??o s?o os esperados.
    Result := ((v[0] = cpf[9]) and (v[1] = cpf[10]));
  except
    on E: Exception do
      Result := False;
  end;
end;

/// ####################################################################################################################
// Fun??o   : ValidarCEP()
// Objetivo : Respons?vel Por Validar o CEP
/// ####################################################################################################################
function ValidarCEP(const NumCEP: String): Boolean;
begin
  if Length(NumCEP) = 8 then
     Result := IsNumero(NumCEP)
  else
     Result := False;
end;

///####################################################################################################################
// Fun??o   : IsEmailValido()
// Objetivo : Respons?vel Por Retornar se O Email Informado ? V?lido
///####################################################################################################################
function IsEmailValido(const Value: string): boolean;
  function Verificar_Permitido(const s: string): boolean;
  var
    i: integer;

  begin
    Result := False;
    for i:= 1 to Length(s) do
      begin
        // Caracter Ilegal n?o Valida o Endere?o
        if not CharInSet(s[i], ['a'..'z','A'..'Z','0'..'9','_','-','.','@']) then
           Exit;
      end;
    Result := True;
  end;

var
  i: integer;
  nomePart, servidorPart: string;

begin
  Result := False;

  i := Pos('@', Value);
  if (i = 0) then
    Exit;

  if(pos('..', Value) > 0) or (pos('@@', Value) > 0) or (pos('.@', Value) > 0)then
    Exit;

  if(pos('.', Value) = 1) or (pos('@', Value) = 1) then
    Exit;

  nomePart := Copy(Value, 1, i - 1);
  servidorPart := Copy(Value, i + 1, Length(Value));
  if (Length(nomePart) = 0) or (Length(servidorPart) < 5)    then
     Exit; // Muito Curto

  i := Pos('.', servidorPart);

  // Deve Ter Ponto e Pelo Menos 3 Lugares do Final
  if (i = 0) or (i > (Length(servidorPart)-2)) then
     Exit;

  Result := Verificar_Permitido(nomePart) and Verificar_Permitido(servidorPart);
end;

///####################################################################################################################
// Fun??o   : IsCPFValido()
// Objetivo : Respons?vel Por Retornar se O CPF Informado ? V?lido
///####################################################################################################################
function IsCPFValido(CPF: string): Boolean;
var
  i: Integer;
  cpfSoNumero: String;
  cpfRepetido: Boolean;
  digito1, digito2: Integer;

begin
  Result := False;

  // Limpa o que n?o for numero
  cpfSoNumero := '';
  for i := 1 To Length(CPF) do
    begin
      case char(CPF[i]) of
        '0' .. '9':
          cpfSoNumero := cpfSoNumero + CPF[i];
      End;
    end;

  // verifica se possui os 11 digitos
  if Length(cpfSoNumero) <> 11 then
     begin
       exit;
     end;

  // testar se o cpf ? repetido como 000.000.000-00
  cpfRepetido := True;
  for i := 2 to Length(cpfSoNumero) do
    begin
      if cpfSoNumero[1] <> cpfSoNumero[i] then
      begin
        // se o cpf possui um digito diferente ele passou no teste
        cpfRepetido := False;
        break;
      end;
    end;

  // se o CPF ? composto por numeros repetido retorna true
  if (cpfRepetido) then
     begin
       exit;
     end;

  // executa o calculo para o primeiro digito verificador
  digito1 := 0;
  for i := 1 to 9 do
    begin
      digito1 := digito1 + (StrToInt(cpfSoNumero[10 - i]) * (i + 1));
    end;

  { formula do primeiro verificador soma=1?*2+2?*3+3?*4.. at? 9?*10 digito1 = 11 - soma mod 11 se digito > 10 digito1 = 0 }
  digito1 := ((11 - (digito1 mod 11)) mod 11) mod 10;

  // verifica se o 1? digito confere
  if inttostr(digito1) <> cpfSoNumero[10] then
     begin
       exit;
     end;

  // executa o calculo para o segundo digito verificador
  digito2 := 0;
  for i := 1 to 10 do
    begin
      digito2 := digito2 + (StrToInt(cpfSoNumero[11 - i]) * (i + 1));
    end;

  { formula do segundo verificador soma=1?*2+2?*3+3?*4.. at? 10?*11 digito2 = 11 - soma mod 11 se digito > 10 digito2 = 0 }
  digito2 := ((11 - (digito2 mod 11)) mod 11) mod 10;

  // confere o 2? digito verificador
  if inttostr(digito2) <> cpfSoNumero[11] then
     begin
       exit;
     end;

  // se chegar at? aqui o CPF ? valido
  Result := True;
end;

end.
