unit Controller.DAO.Factory;

interface

uses
  Controller.DAO.Interfaces,
  Model.DAO.Parametros,
  Model.DAO.BS.Pessoa,
  Model.DAO.BS.Doacao;

type
  TControllerDAO = class(TInterfacedObject, iControllerDAO)
  private
    FDAOParametros: iModelDAOParametros;
    FDAOPessoa: iModelDAO;
    FDAODoacao: iModelDAO;
  public
    constructor Create;
    destructor Destroy; override;
    class function New : iControllerDAO;
    function Parametros: iModelDAOParametros;
    function Pessoa: iModelDAO;
    function Doacao: iModelDAO;
  end;

implementation

{ TControllerDAO }

constructor TControllerDAO.Create;
begin
  FDAOParametros := TModelDAOParametros.New;
  FDAOPessoa     := TModelDAOPessoa.New;
  FDAODoacao     := TModelDAODoacao.New;
end;

destructor TControllerDAO.Destroy;
begin
  inherited;
end;

class function TControllerDAO.New: iControllerDAO;
begin
  Result := Self.Create;
end;

function TControllerDAO.Parametros: iModelDAOParametros;
begin
  Result := FDAOParametros;
end;

function TControllerDAO.Pessoa: iModelDAO;
begin
  Result := FDAOPessoa;
end;

function TControllerDAO.Doacao: iModelDAO;
begin
  Result := FDAODoacao;
end;

end.

