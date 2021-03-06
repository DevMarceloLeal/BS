unit Classe.BS.Doacao;

interface

uses
  System.SysUtils,
  Vcl.Forms,
  Model.Conexao.Interfaces,
  Model.FireDAC.DataFunctions,
  Auxiliar.Datas,
  Auxiliar.Dialogos,
  Auxiliar.Comandos.SQL;

type
  TBS_Doacao = class
  private
    FDBFuncoes: iModelFuncoes;
    FDOA_ID: Integer;
    FDOA_DATA: TDateTime;
    FDOA_QTDE: Currency;
    FDOA_STATUS: String;
    FPES_ID: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: TBS_Doacao;
    class function SQL_Criar_Tabela: String;
    class function SQL_Selecionar_Registros(pCampo: String = ''; pTexto: String = ''): String;
    class function SQL_Seleciona_Doador(pTexto: String): String;
    class function SQL_Incrementa(pLiga: Boolean = True): String;
    class function SQL_Ultima_Doacao(pDoador, pData: String): String;
    property DOA_ID:     Integer   read FDOA_ID     write FDOA_ID;
    property DOA_DATA:   TDateTime read FDOA_DATA   write FDOA_DATA;
    property DOA_QTDE:   Currency  read FDOA_QTDE   write FDOA_QTDE;
    property DOA_STATUS: String    read FDOA_STATUS write FDOA_STATUS;
    property PES_ID:     Integer   read FPES_ID     write FPES_ID;
  end;

const
  FTabela: String = 'BS_DOACAO';
  FCampos: String = 'DOA_ID INT NOT NULL IDENTITY, '+
                    'DOA_DATA DATETIME NOT NULL, ' +
                    'DOA_QTDE DECIMAL(18,2) NOT NULL, ' +
                    'DOA_STATUS CHAR(1) NOT NULL, ' +
                    'PES_ID INT NOT NULL ' +
                    'CONSTRAINT pk_DOA_ID PRIMARY KEY (DOA_ID) ' +
                    'CONSTRAINT fk_PES_ID FOREIGN KEY (PES_ID) '+
                    'REFERENCES BS_PESSOA (PES_ID) ON DELETE CASCADE';

implementation

{ TBS_Doacao }

constructor TBS_Doacao.Create;
begin
  FDBFuncoes := TDataFunctions.New;
  try
    DOA_ID     := FDBFuncoes.ID_Gerado('BS_DOACAO', 'DOA_ID');
    DOA_DATA   := StrToDate(DataStr);
    DOA_QTDE   := 0.00;
    DOA_STATUS := '';
    PES_ID     := 0;
  except
  end;
end;

destructor TBS_Doacao.Destroy;
begin
  inherited;
end;

class function TBS_Doacao.New: TBS_Doacao;
begin
  Result := Self.Create;
end;

class function TBS_Doacao.SQL_Criar_Tabela: String;
begin
  Result := SQL_Criar_Tabela_Dados(FTabela, FCampos, 'MSSQL');
end;

class function TBS_Doacao.SQL_Selecionar_Registros(pCampo: String = ''; pTexto: String = ''): String;
begin
  if pCampo = '' then
     Result := SQL_Selecionar_Doacoes(['*'], [''])
  else
     Result := SQL_Selecionar_Doacoes([pCampo], [pTexto], True, True);
end;

class function TBS_Doacao.SQL_Seleciona_Doador(pTexto: String): String;
begin
  Result := SQL_Selecionar_Registro('BS_PESSOA', ['PES_ID'], [pTexto]);
end;

class function TBS_Doacao.SQL_Incrementa(pLiga: Boolean = True): String;
begin
  Result := SQL_Incrementar_ID(FTabela, pLiga);
end;

class function TBS_Doacao.SQL_Ultima_Doacao(pDoador, pData: String): String;
begin
  Result := SQL_Selecionar_Ultima_Doacao(pDoador, pData);
end;

end.
