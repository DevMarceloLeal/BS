unit Classe.Parametros.Conexao;

interface

uses
  System.SysUtils,
  Vcl.Forms,
  Model.Conexao.Interfaces,
  Model.Conexao.Parametros,
  Auxiliar.Classes;

type
  TParametrosConexao = class
  private
    FDriverID: String;
    FServidor: String;
    FBancoDados: String;
    FSenha: String;
    FPorta: String;
    FUsuario: String;
    FForm: TForm;
    FParametros: iModelParametros;
    FConfiguracao: TConfiguracao;
    FClasse: TClasses;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: TParametrosConexao;
    function Formulario(pForm: TForm; pAtribuir: Boolean = False): TParametrosConexao;
    procedure Gravar_Edicao;
    property DriverID: String read FDriverID write FDriverID;
    property Servidor: String read FServidor write FServidor;
    property BancoDados: String read FBancoDados write FBancoDados;
    property Usuario: String read FUsuario write FUsuario;
    property Senha: String read FSenha write FSenha;
    property Porta: String read FPorta write FPorta;
  end;

implementation

{ TParametrosConexao }

constructor TParametrosConexao.Create;
begin
  FParametros   := TModelConexaoParametros.New;
  FConfiguracao := FParametros.Configuracao;
  FClasse       := TClasses.New;

  FDriverID   := FConfiguracao[1];
  FServidor   := FConfiguracao[2];
  FBancoDados := FConfiguracao[3];
  FUsuario    := FConfiguracao[4];
  FSenha      := FConfiguracao[5];
  FPorta      := FConfiguracao[6];
end;

destructor TParametrosConexao.Destroy;
begin
  inherited;
end;

class function TParametrosConexao.New: TParametrosConexao;
begin
  Result := Self.Create;
end;

function TParametrosConexao.Formulario(pForm: TForm; pAtribuir: Boolean = False): TParametrosConexao;
begin
  Result := Self;
  FForm  := pForm;

  if pAtribuir then
     FClasse.Formulario(FForm).Objeto(Self).Classe_To_Form;
end;

procedure TParametrosConexao.Gravar_Edicao;
begin
  FClasse.Formulario(FForm).Objeto(Self).Form_To_Classe;

  FConfiguracao[1] := FDriverID;
  FConfiguracao[2] := FServidor;
  FConfiguracao[3] := FBancoDados;
  FConfiguracao[4] := FUsuario;
  FConfiguracao[5] := FSenha;
  FConfiguracao[6] := FPorta;

  FParametros.Gravar(FConfiguracao);
end;

end.
