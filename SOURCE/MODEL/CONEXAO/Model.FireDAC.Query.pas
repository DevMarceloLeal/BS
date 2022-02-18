unit Model.FireDAC.Query;

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Dialogs,
  Data.DB,
  Datasnap.Provider, Datasnap.DBClient,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI,
  Model.Conexao.Interfaces,
  Auxiliar.Dialogos;

type
  TFireDACQuery = class(TInterfacedObject, iModelQuery)
  FDGUIxWaitCursor1: TFDGUIxWaitCursor;
  private
    FQuery: TFDQuery;
    FConexao: iModelConexao;
  public
    constructor Create(pConexao: iModelConexao);
    destructor Destroy; override;
    class function New(pConexao: iModelConexao): iModelQuery;
    function DataSet: TDataSet;
    function DataSetToXML(pSQL, pArqXML: String): iModelQuery;
    function OpenTable(pSQL: String): iModelQuery;
    function ExecSQL(pSQL: String): iModelQuery;
  end;

implementation

{ TFiredacQuery }

constructor TFireDACQuery.Create(pConexao: iModelConexao);
begin
  FConexao := pConexao;
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := TFDConnection(FConexao.Connection);
end;

destructor TFireDACQuery.Destroy;
begin
  FreeAndNil(FQuery);
  inherited;
end;

class function TFireDACQuery.New(pConexao: iModelConexao): iModelQuery;
begin
  Result := Self.Create(pConexao);
end;

function TFireDACQuery.DataSet: TDataSet;
begin
  Result := FQuery;
end;

function TFireDACQuery.DataSetToXML(pSQL, pArqXML: String): iModelQuery;
var
  dspData: TDataSetProvider;
  cdsData: TClientDataSet;

begin
  dspData := TDataSetProvider.Create(nil);
  cdsData := TClientDataSet.Create(nil);

  // configuração dos objetos
  dspData.DataSet := FQuery;
  cdsData.SetProvider(dspData);

  FQuery.Open(pSQL);

  cdsData.Open;
  cdsData.SaveToFile(pArqXML, dfXMLUTF8);
  FreeAndNil(cdsData);
  FreeAndNil(dspData);
end;

function TFireDACQuery.OpenTable(pSQL: String): iModelQuery;
begin
  Result := Self;
  FConexao.Status;

  FQuery.SQL.Clear;
  FQuery.SQL.Add(pSQL);

  try
    FQuery.OpenOrExecute;
    FQuery.First;
  except On E: Exception do
  end;
end;

function TFireDACQuery.ExecSQL(pSQL: String): iModelQuery;
begin
  Result := Self;
  FConexao.Status;

  FQuery.SQL.Clear;
  FQuery.SQL.Add(pSQL);

  try
    FQuery.ExecSQL;
  except On E: Exception do
  end;
end;

end.
