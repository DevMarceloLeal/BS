unit Model.FireDAC.Conexao;

interface

uses
  System.SysUtils,
  Vcl.Dialogs,
  Vcl.Graphics,
  Vcl.StdCtrls,
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
  Model.Conexao.Interfaces,
  Model.Conexao.Parametros,
  Model.FireDAC.DataFunctions,
  Auxiliar.Dialogos,
  Auxiliar.Informacoes,
  Auxiliar.Comandos.SQL;

type
  TFireDACConexao = class(TInterfacedObject, iModelConexao)
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
  private
    FConexao: TFDConnection;
    FParametros: iModelParametros;
    FDBFuncoes: TDataFunctions;
    FStatus, FTipoConexao: String;
    procedure Configurar(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelConexao;
    function Status: String;
    function Connection: TCustomConnection;
    function Conectar: iModelConexao;
    function Desconectar: iModelConexao;
  end;

implementation

{ TFiredacConexao }

constructor TFireDACConexao.Create;
begin
  FDBFuncoes := TDataFunctions.Create();
  FConexao := TFDConnection.Create(nil);
  FParametros := TModelConexaoParametros.New;
  FTipoConexao := FParametros.Configuracao[0];
  FConexao.BeforeConnect := Configurar;
end;

destructor TFireDACConexao.Destroy;
begin
  FreeAndNil(FConexao);
  inherited;
end;

procedure TFireDACConexao.Configurar(Sender: TObject);
begin
  FParametros.Atribuir;

  try
    With FConexao do
      begin
        With Params do
          begin
            Clear;
            Add(Format('DriverID=%s',  [FParametros.Configuracao[1]]));
            Add(Format('Server=%s',    [FParametros.Configuracao[2]]));
            Add(Format('Database=%s',  [FParametros.Configuracao[3]]));
            Add(Format('User_Name=%s', [FParametros.Configuracao[4]]));
            Add(Format('Password=%s',  [FParametros.Configuracao[5]]));
            Add('OSAuthent=No');
            Add('MARS=Yes');
            Add('MetaDefSchema=dbo');
          end;

        LoginPrompt := False;

        With ResourceOptions do
          begin
            KeepConnection := False;
            AutoReconnect := True;
          end;
      end;
  except on E: Exception do
      Msg('Erro ao Atribuir os Par?metros de Configura??o !!!', '', 3);
  end;
end;

class function TFireDACConexao.New: iModelConexao;
begin
  Result := Self.Create;
end;

function TFireDACConexao.Status: String;
begin
  try
    FParametros.Atribuir;

    // Verifica se o Banco de Dados Existe Se N?o Existir Ele ? Criado
    if not FDBFuncoes.Banco_Dados_Existe() then
       begin
         if FDBFuncoes.Criar_Banco_Dados then
            begin
              MsgSys(Format('Banco de Dados %s Criado C/Sucesso !!!', [QuotedStr(FParametros.Configuracao[3])]));
              Status;
            end;
       end
    else
       begin
         Conectar;
         if FConexao.Connected then
            FStatus := 'On-Line'
         else
            FStatus := 'Off-Line';
       end;
  except on E: Exception do
    begin
      if E.Message.Contains('Erro ao Localizar Servidor') then
         MsgSys('Erro ao Executar Comando SQL !!!' + #13#13 + 'Servidor SQL N?o Localizado', 3)
      else
         MsgSys('Erro ao Executar Comando SQL !!!' + #13#13 + E.Message);

      FStatus := 'Off-Line';
    end;
  end;

  Result := Format('%s - %s - %s - %s',[FParametros.Configuracao[2], FParametros.Configuracao[3], FStatus, Obter_IP_Interno])
end;

function TFireDACConexao.Connection: TCustomConnection;
begin
  Result := FConexao;
end;

function TFireDACConexao.Conectar: iModelConexao;
begin
  Result := Self;

  try
    // Exexuta a Conex?o do Banco de Dados
    try
      if FConexao.Connected then
         FConexao.Connected := False;

      FConexao.Connected := True;
    except on E: EFDException do
      MsgSys(E.Message, 3);
    end;
  except on E: EFDException do
    MsgSys(E.Message, 3);
  end;
end;

function TFireDACConexao.Desconectar: iModelConexao;
begin
  Result := Self;

  try
    if FConexao.Connected then
       begin
         FConexao.Connected := False;
         FConexao.Close;
       end;
  except on E: Exception do
    Msg('Erro ao Desconectar Banco de Dados', '', 3);
  end;

  Status;
end;

end.
