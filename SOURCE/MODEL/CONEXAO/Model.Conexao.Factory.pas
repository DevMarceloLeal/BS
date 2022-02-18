unit Model.Conexao.Factory;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  Model.Conexao.Interfaces,
  Model.Conexao.Parametros,
  Model.FireDAC.Conexao,
  Model.FireDAC.Query,
  Model.FireDAC.DataFunctions;

type
  TTipoConexao = (tpFireDAC);

  TModelConexaoFactory = class(TInterfacedObject, iModelConexaoFactory)
  private
    FTipoConexao: TTipoConexao;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelConexaoFactory;
    function Parametros: iModelParametros;
    function Driver: iModelConexao;
    function Query: iModelQuery;
    function DBFuncoes: iModelFuncoes;
  end;

implementation

{ TClassePadrao }

constructor TModelConexaoFactory.Create;
begin
  FTipoConexao := tpFireDAC;
end;

destructor TModelConexaoFactory.Destroy;
begin
  inherited;
end;

class function TModelConexaoFactory.New: iModelConexaoFactory;
begin
  Result := Self.Create;
end;

function TModelConexaoFactory.Parametros: iModelParametros;
begin
  Result := TModelConexaoParametros.New;
end;

function TModelConexaoFactory.Driver: iModelConexao;
begin
  case FTipoConexao of
     tpFireDAC:
      Result := TFireDACConexao.New;
  end;
end;

function TModelConexaoFactory.Query: iModelQuery;
begin
  case FTipoConexao of
     tpFireDAC:
      Result := TFireDACQuery.New(Self.Driver);
  end;
end;

function TModelConexaoFactory.DBFuncoes: iModelFuncoes;
begin
  Result := TDataFunctions.New;
end;

end.
