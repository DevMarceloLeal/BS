unit Classe.BS.Pessoa;

interface

uses
  System.SysUtils,
  Vcl.Forms,
  Model.Conexao.Interfaces,
  Model.FireDAC.DataFunctions,
  Auxiliar.Datas,
  Auxiliar.Dialogos,
  Auxiliar.Informacoes,
  Auxiliar.Formatacoes,
  AUxiliar.Validacoes,
  Auxiliar.Comandos.SQL;

type
  TBS_Pessoa = class
  private
    FPES_ID: Integer;
    FPES_NOME: String;
    FPES_DATANASC: TDateTime;
    FPES_TIPOSANG: String;
    FPES_EMAIL: String;
    FPES_CELULAR: String;
    FPES_CPF: String;
    FDBFuncoes: iModelFuncoes;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: TBS_Pessoa;
    class function SQL_Criar_Tabela: String;
    class function SQL_Selecionar_Registros(pCampo: String = ''; pTexto: String = ''): String;
    class function SQL_Seleciona_Registro(pTexto: String): String;
    class function SQL_Incrementa(pLiga: Boolean = True): String;
    class function SQL_Deletar_Registros(pTexto: String): String;
    class function SQL_Registro_Existe(pCampos, pTextos: Array of String): String;

    property PES_ID:       Integer   read FPES_ID       write FPES_ID;
    property PES_NOME:     String    read FPES_NOME     write FPES_NOME;
    property PES_DATANASC: TDateTime read FPES_DATANASC write FPES_DATANASC;
    property PES_TIPOSANG: String    read FPES_TIPOSANG write FPES_TIPOSANG;
    property PES_EMAIL:    String    read FPES_EMAIL    write FPES_EMAIL;
    property PES_CELULAR:  String    read FPES_CELULAR  write FPES_CELULAR;
    property PES_CPF:      String    read FPES_CPF      write FPES_CPF;
  end;

const
  FTabela: String = 'BS_PESSOA';
  FCampos: String = 'PES_ID INT NOT NULL IDENTITY, '+
                    'PES_NOME VARCHAR(100) NOT NULL, ' +
                    'PES_DATANASC DATETIME NOT NULL, ' +
                    'PES_TIPOSANG CHAR(02) NOT NULL, ' +
                    'PES_EMAIL VARCHAR(100) NOT NULL, ' +
                    'PES_CELULAR VARCHAR(100) NOT NULL, ' +
                    'PES_CPF VARCHAR(100) NOT NULL ' +
                    'CONSTRAINT pk_PES_ID PRIMARY KEY (PES_ID)';

implementation

{ TBS_Pessoa }

constructor TBS_Pessoa.Create;
begin
  FDBFuncoes := TDataFunctions.New;
  try
    PES_ID       := FDBFuncoes.ID_Gerado('BS_PESSOA', 'PES_ID');
    PES_NOME     := '';
    PES_TIPOSANG := '';
    PES_EMAIL    := '';
    PES_CELULAR  := '';
    PES_CPF      := '';
  except on E: Exception do
  end;
end;

destructor TBS_Pessoa.Destroy;
begin
  inherited;
end;

class function TBS_Pessoa.New: TBS_Pessoa;
begin
  Result := Self.Create;
end;

class function TBS_Pessoa.SQL_Criar_Tabela: String;
begin
  Result := SQL_Criar_Tabela_Dados(FTabela, FCampos, 'MSSQL');
end;

class function TBS_Pessoa.SQL_Selecionar_Registros(pCampo: String = ''; pTexto: String = ''): String;
begin
  if pCampo = '' then
     Result := SQL_Selecao_Registros(FTabela, '*')
  else
     Result := SQL_Selecao_Registros(FTabela, '*', pTexto, pCampo);
end;

class function TBS_Pessoa.SQL_Seleciona_Registro(pTexto: String): String;
begin
  Result := SQL_Selecionar_Registro(FTabela, ['PES_ID'], [pTexto], True);
end;

class function TBS_Pessoa.SQL_Incrementa(pLiga: Boolean = True): String;
begin
  Result := SQL_Incrementar_ID(FTabela, pLiga);
end;

class function TBS_Pessoa.SQL_Deletar_Registros(pTexto: String): String;
begin
  Result := SQL_Excluir_Registros(FTabela, 'PES_ID', pTexto);
end;

class function TBS_Pessoa.SQL_Registro_Existe(pCampos, pTextos: array of String): String;
begin
  Result := SQL_Selecionar_Registro(FTabela, pCampos, pTextos, True);
end;

end.
