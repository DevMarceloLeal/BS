unit Auxiliar.Informacoes;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Variants,
  Winsock,
  Vcl.Forms,
  Vcl.Dialogs,
  Auxiliar.Datas;

  function Nome_Sistema: String;
  function Versao_Sistema: String;
  function Obter_IP_Externo: String;
  function Obter_IP_Interno: string;
  function IndexOf(pArray: array of string; pTexto: String): Integer;
  function Calcular_Idade(Nascimento: TDate): Integer;
  function Tipo_Variavel(varVar: Variant): String;

implementation

///####################################################################################################################
/// Fun??o   : Nome_Sistema()
/// Objetivo : Respons?vel Pelo Retorno do Nome do Sistema
///####################################################################################################################
function Nome_Sistema: String;
var
  PathSys: String;

begin
  PathSys := ExtractFileDir(Application.ExeName);
  Result := String(Application.ExeName).Replace('.exe', '').Replace(PathSys, '').Replace('\','');
end;

///####################################################################################################################
/// Fun??o   : Versao_Sistema()
/// Objetivo : Respons?vel Pelo Retorno da Vers?o do Sistema
///####################################################################################################################
function Versao_Sistema: String;
type
    PFFI = ^vs_FixedFileInfo;
var
    F : PFFI;
    Handle : Dword;
    Len : Longint;
    Data : Pchar;
    Buffer : Pointer;
    Tamanho : Dword;
    pArquivo: Pchar;
    Arquivo : String;

begin
  Arquivo := Application.ExeName;
  pArquivo := StrAlloc(Length(Arquivo) + 1);
  StrPcopy(pArquivo, Arquivo);
  Len := GetFileVersionInfoSize(pArquivo, Handle);
  Result := '';
  if Len > 0 then
     begin
       Data := StrAlloc(Len+1);
       if GetFileVersionInfo(pArquivo, Handle, Len, Data) then
          begin
            VerQueryValue(Data, '\',Buffer,Tamanho);
            F := PFFI(Buffer);
            Result := Format('Vers?o : %d.%d.%d.%d',[HiWord(F^.dwFileVersionMs),LoWord(F^.dwFileVersionMs),HiWord(F^.dwFileVersionLs),Loword(F^.dwFileVersionLs)]);
          end;
          StrDispose(Data);
     end;

  StrDispose(pArquivo);
end;

///####################################################################################################################
/// Fun??o   : Obter_IP_Externo()
/// Objetivo : Respons?vel Pelo Retorno do IP Remoto "Externo"
///####################################################################################################################
function Obter_IP_Externo: string;
var
  WSAData: TWSAData;
  HostEnt: PHostEnt;
  Name: AnsiString;

begin
  WSAStartup(2, WSAData);
  SetLength(Name, 255);
  Gethostname(PAnsiChar(Name), 255);
  SetLength(Name, StrLen(PChar(String(Name))));
  HostEnt := gethostbyname(PAnsiChar(Name));
  with HostEnt^ do
    begin
      Result := Format('%d.%d.%d.%d', [Byte(h_addr^[0]),Byte(h_addr^[1]), Byte(h_addr^[2]),Byte(h_addr^[3])]);
    end;

  WSACleanup;
end;

///####################################################################################################################
/// Fun??o   : Obter_IP_Interno()
/// Objetivo : Respons?vel Pelo Retorno do IP Local "Interno"
///####################################################################################################################
function Obter_IP_Interno: string;
type
  TaPInAddr = array [0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;

var
  phe: PHostEnt;
  pptr: PaPInAddr;
  Buffer: array [0..63] of Ansichar;
  i: Integer;
  GInitData: TWSADATA;

begin
  WSAStartup($101, GInitData);
  Result := '';
  GetHostName(Buffer, SizeOf(Buffer));
  phe := GetHostByName(Buffer);
  if phe = nil then
     Exit;

  i := 0;
  pptr := PaPInAddr(phe^.h_addr_list);
  while pptr^[i] <> nil do
    begin
      Result := String(inet_ntoa(pptr^[i]^));
      Inc(i);
    end;

  WSACleanup;
end;

///####################################################################################################################
/// Fun??o   : IndexOf()
/// Objetivo : Respons?vel Por Retornar a Posi??o de uma String Dentro de um Array
///####################################################################################################################
function IndexOf(pArray: array of String; pTexto: String): Integer;
begin
  Result := 0;

  while (Result < Length(pArray) - 1) and (pArray[Result] <> pTexto) do
    Inc(Result);

  if (pArray[Result] <> pTexto) then
     Result := -1;
end;

///####################################################################################################################
/// Fun??o   : Calcular_Idade()
/// Objetivo : Respons?vel Pelo Retorno da Idade de Acordo Com o Nascimento
///####################################################################################################################
function Calcular_Idade(Nascimento: TDate): Integer;
var
  Month, Day, Year, CurrentYear, CurrentMonth, CurrentDay: Word;

begin
  DecodeDate(Nascimento, Year, Month, Day);
  DecodeDate(Date, CurrentYear, CurrentMonth, CurrentDay);
  if (Year = CurrentYear) and (Month = CurrentMonth) and (Day = CurrentDay) then
     begin
       Result := 0;
     end
  else
     begin
       Result := CurrentYear - Year;
       if (Month > CurrentMonth) then
          Dec(Result)
       else
          begin
            if Month = CurrentMonth then
              if (Day > CurrentDay) then
                Dec(Result);
          end;
     end;
end;

function Tipo_Variavel(varVar: Variant): String;
var
  typeString: string;
  basicType : Integer;

begin
  basicType := VarType(varVar) and VarTypeMask;
  case basicType of
    varEmpty     : typeString := 'varEmpty';
    varNull      : typeString := 'varNull';
    varSmallInt  : typeString := 'varSmallInt';
    varInteger   : typeString := 'varInteger';
    varSingle    : typeString := 'varSingle';
    varDouble    : typeString := 'varDouble';
    varCurrency  : typeString := 'varCurrency';
    varDate      : typeString := 'varDate';
    varOleStr    : typeString := 'varOleStr';
    varDispatch  : typeString := 'varDispatch';
    varError     : typeString := 'varError';
    varBoolean   : typeString := 'varBoolean';
    varVariant   : typeString := 'varVariant';
    varUnknown   : typeString := 'varUnknown';
    varByte      : typeString := 'varByte';
    varWord      : typeString := 'varWord';
    varLongWord  : typeString := 'varLongWord';
    varInt64     : typeString := 'varInt64';
    varStrArg    : typeString := 'varStrArg';
    varString    : typeString := 'varString';
    varAny       : typeString := 'varAny';
    varTypeMask  : typeString := 'varTypeMask';
  else
    typeString := IntToStr(basicType);
  end;

  Result := typeString;
end;

end.
