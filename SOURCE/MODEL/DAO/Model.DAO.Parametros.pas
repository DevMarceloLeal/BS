unit Model.DAO.Parametros;

interface

uses
  Vcl.Forms,
  Controller.DAO.Interfaces,
  Auxiliar.Classes,
  Auxiliar.Dialogos,
  Auxiliar.Validacoes,
  Classe.Parametros.Conexao;

type
  TModelDAOParametros = class(TInterfacedObject, iModelDAOParametros)
  private
    FClasse: TParametrosConexao;
    FForm: TForm;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelDAOParametros;
    function Formulario(pForm: TForm; pAtribuir: Boolean = False): iModelDAOParametros;
    procedure Gravar;
  end;

implementation

uses
  System.SysUtils, Vcl.Dialogs;

{ TModelDAOParametros }

constructor TModelDAOParametros.Create;
begin
  FClasse := TParametrosConexao.New;
end;

destructor TModelDAOParametros.Destroy;
begin
  FreeAndNil(FClasse);
  inherited;
end;

class function TModelDAOParametros.New: iModelDAOParametros;
begin
  Result := Self.Create;
end;

function TModelDAOParametros.Formulario(pForm: TForm; pAtribuir: Boolean = False): iModelDAOParametros;
begin
  Result := Self;
  FForm  := pForm;

  if pAtribuir then
     FClasse.Formulario(FForm, pAtribuir);
end;

procedure TModelDAOParametros.Gravar;
begin
  try
    FClasse.Formulario(FForm).Gravar_Edicao;
    Msg('Parāmetros Gravados C/Sucesso...');
  except on E: Exception do
    begin
      Msg('Erro ao Gravar Parāmetros...', '', 3);
      ShowMessage(E.Message);
    end;
  end;

end;

end.
