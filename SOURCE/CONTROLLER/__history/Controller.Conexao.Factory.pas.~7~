unit Controller.Conexao.Factory;

interface

uses
  Controller.Conexao.Interfaces,
  Model.Conexao.Interfaces,
  Model.Conexao.Factory;

type
  TControllerConexao = class(TInterfacedObject, iControllerConexao)
  private
    FConexao: iModelConexaoFactory;
  public
    constructor Create;
    destructor Destroy; override;
    class function New : iControllerConexao;
    function Conexao: iModelConexaoFactory;
  end;

implementation

{ TControllerConexao }

constructor TControllerConexao.Create;
begin
  FConexao := TModelConexaoFactory.New;
end;

destructor TControllerConexao.Destroy;
begin
  inherited;
end;

class function TControllerConexao.New: iControllerConexao;
begin
  Result := Self.Create;
end;

function TControllerConexao.Conexao: iModelConexaoFactory;
begin
  Result := FConexao;
end;

end.

