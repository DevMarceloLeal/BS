unit Model.FireDAC.DataFunctions;

interface

uses
  System.SysUtils,
  Vcl.Dialogs,
  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef,
  FireDAC.VCLUI.Wait,
  FireDAC.Phys.ODBCBase,
  FireDAC.Comp.Client,
  FireDAC.Comp.UI,
  DBXMSSQL,
  Data.SqlExpr,
  Auxiliar.Comandos.SQL,
  Auxiliar.Dialogos,
  Model.Conexao.Interfaces,
  Model.Conexao.Parametros;

type
  TDataFunctions = class(TInterfacedObject, iModelFuncoes)
   private
   public
     constructor Create;
     destructor Destroy; override;
     class function New: iModelFuncoes;
     procedure Configuracao_Conexao(var pConn: TFDConnection; var pBanco: string);
     function Banco_Dados_Existe: Boolean;
     function Criar_Banco_Dados: Boolean;
     function Registro_Existe(pSql: String): Boolean;
     function Gerar_ID(pTabela: String): Integer;
     function ID_Gerado(pTabela, pCampo: String): Integer;
  end;

var
  FParametros: iModelParametros;
  FConn: TFDConnection;
  FQry: TFDQuery;
  FBanco: String;

implementation

{ TDataFunctions }

constructor TDataFunctions.Create;
begin
  FParametros := TModelConexaoParametros.New;
end;

destructor TDataFunctions.Destroy;
begin
  inherited;
end;

class function TDataFunctions.New: iModelFuncoes;
begin
  Result := Self.Create;
end;

function TDataFunctions.Banco_Dados_Existe: Boolean;
begin
  FQry  := TFDQuery.Create(nil);
  FConn := TFDConnection.Create(nil);

  FConn.DriverName := 'MSSQL';
  FConn.LoginPrompt := False;
  with FConn.Params as TFDPhysMSSQLConnectionDefParams do
    begin
      Server    := FParametros.Configuracao[2];
      UserName  := FParametros.Configuracao[4];
      Password  := FParametros.Configuracao[5];
      OSAuthent := False;
    end;

  FQry.Connection := FConn;
  FQry.SQL.Clear;
  FQry.SQL.Add(SQL_Banco_Dados_Existe(FParametros.Configuracao[3], FParametros.Configuracao[1]));
  try
    FConn.Connected := True;
    FQry.Open;

    if FQry.Fields[0].Text <> '' then
       Result := True
    else
       Result := False;

  except on E: Exception do
    Result := False;
  end;

  FQry.Free;
  FConn.Free;
end;

function TDataFunctions.Criar_Banco_Dados: Boolean;
begin
  FQry  := TFDQuery.Create(nil);
  FConn := TFDConnection.Create(nil);

  FConn.DriverName := 'MSSQL';
  FConn.LoginPrompt := False;
  with FConn.Params as TFDPhysMSSQLConnectionDefParams do
    begin
      Server    := FParametros.Configuracao[2];
      UserName  := FParametros.Configuracao[4];
      Password  := FParametros.Configuracao[5];
      OSAuthent := False;
    end;

  FQry.Connection := FConn;
  FQry.SQL.Clear;
  FQry.SQL.Add(SQL_Criar_Banco_Dados(FParametros.Configuracao[3], FParametros.Configuracao[1]));
  try
    FConn.Connected := True;
    FQry.ExecSQL;
    Result := True
  except on E: Exception do
    raise Exception.Create('Erro ao Executar Comando SQL !!!' + #13 + E.Message);
  end;

  FQry.Free;
  FConn.Free;
end;

function TDataFunctions.Registro_Existe(pSql: String): Boolean;
begin
  FQry  := TFDQuery.Create(nil);
  FConn := TFDConnection.Create(nil);

  Configuracao_Conexao(FConn, FBanco);

  FQry.Connection := FConn;
  FQry.SQL.Clear;
  FQry.SQL.Add(pSql);
  try
    FConn.Connected := True;
    FQry.Open;

    Result := (FQry.RecordCount > 0);
  finally
    FQry.Free;
    FConn.Free;
  end;
end;

function TDataFunctions.Gerar_ID(pTabela: String): Integer;
begin
  FQry   := TFDQuery.Create(nil);
  FConn  := TFDConnection.Create(nil);

  Configuracao_Conexao(FConn, FBanco);

  FQry.Connection := FConn;
  FQry.SQL.Clear;
  FQry.SQL.Add(SQL_Gerar_ID(FBanco, pTabela, 'MSSQL'));
  try
    FConn.Connected := True;
    FQry.Open;

    if FQry.Fields[0].Text <> '' then
       Result := StrToInt(FQry.Fields[0].Text)
    else
       Result := 0;
  except
    Result := 0
  end;

  FQry.Free;
  FConn.Free;
end;

function TDataFunctions.ID_Gerado(pTabela, pCampo: String): Integer;
var
  ID: Integer;

begin
  ID := Gerar_ID(pTabela);
  if (ID = 0) then
     Result := 1
  else
     if Registro_Existe(SQL_Selecionar_Registro(pTabela, [pCampo], [ID.ToString])) then
        Result := ID + 1
     else
        Result := ID;
end;

procedure TDataFunctions.Configuracao_Conexao(var pConn: TFDConnection; var pBanco: string);
begin
  pConn.DriverName  := 'MSSQL';
  pConn.LoginPrompt := False;
  with pConn.Params as TFDPhysMSSQLConnectionDefParams do
  begin
      Server    := FParametros.Configuracao[2];
      Database  := FParametros.Configuracao[3];
      UserName  := FParametros.Configuracao[4];
      Password  := FParametros.Configuracao[5];
      OSAuthent := False;
  end;
end;

end.
