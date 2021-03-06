unit Model.Conexao.Interfaces;

interface

uses
  Data.DB;

type
  TConfiguracao = array[0..6] of string;

  iModelFuncoes = interface
    ['{029AECCB-977E-41A2-B9A9-32979EE0CB91}']
     function Banco_Dados_Existe: Boolean;
     function Criar_Banco_Dados: Boolean;
     function Registro_Existe(pSql: String): Boolean;
     function Gerar_ID(pTabela: String): Integer;
     function ID_Gerado(pTabela, pCampo: String): Integer;
  end;

  iModelParametros = interface
    ['{A12C2471-FDC7-4243-94A6-37A8AF35B184}']
    function Configuracao: TConfiguracao;
    procedure Gravar(pConfiguracao: TConfiguracao);
    procedure Criar_Xml;
    procedure Atribuir;
  end;

  iModelConexao = interface
    ['{88A9088A-5DDA-4047-8E45-D1F4FC753CBE}']
    function Status: String;
    function Connection: TCustomConnection;
    function Conectar: iModelConexao;
    function Desconectar: iModelConexao;
  end;

  iModelQuery = interface
    ['{73B2DB04-12CD-41EA-9538-E1947E61DD92}']
    function DataSet: TDataSet;
    function DataSetToXML(pSQL, pArqXML: String): iModelQuery;
    function OpenTable(aSQL: String): iModelQuery;
    function ExecSQL(aSQL: String): iModelQuery;
  end;

  iModelConexaoFactory = interface
    ['{0D27026B-C524-41E4-BC97-487388B56537}']
    function Parametros: iModelParametros;
    function Driver: iModelConexao;
    function Query: iModelQuery;
    function DBFuncoes: iModelFuncoes;
  end;

implementation

end.
