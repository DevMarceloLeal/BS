unit Controller.DAO.Interfaces;

interface

uses
  Vcl.Forms,
  Vcl.DBGrids,
  Data.DB,
  Auxiliar.Variaveis.Globais;

type
  iModelDAOParametros = interface
    ['{7667509D-BB4B-4757-AA63-6EE1EDD30A30}']
    function Formulario(pForm: TForm; pAtribuir: Boolean = False): iModelDAOParametros;
    procedure Gravar;
  end;

  iModelDAO = interface
    ['{65D3AF98-A505-4ADB-94F4-905B439F5FD3}']
    function Criar_Tabela: iModelDAO;
    function Formulario(pForm: TForm): iModelDAO;
    function Operacao(pOperacao: TOperacao): iModelDAO;
    function Carregar_Registros(pDBGrid: TDBGrid; pDataSource: TDataSource): iModelDAO;
    procedure Buscar_Doador(pCodigo: String);
    procedure Montar_Janela_Manutencao(pDataSource: TDataSource);
    procedure Executar_Operacoes(pDataSource: TDataSource);
    procedure Filtrar_Registros(pDataSource: TDataSource; pCampo, pTexto: String);
    procedure Listar_Registros;
  end;

  iControllerDAO = interface
    ['{A792D5C0-5E62-4699-AC0E-B37B66227030}']
    function Parametros: iModelDAOParametros;
    function Pessoa: iModelDAO;
    function Doacao: iModelDAO;
  end;

implementation

end.
