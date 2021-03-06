unit Model.Conexao.Parametros;

interface

uses
  System.SysUtils,
  Vcl.Forms,
  XMLIntf,
  XMLdoc,
  Auxiliar.Informacoes,
  Auxiliar.Dialogos,
  Model.Conexao.Interfaces;

type
  TModelConexaoParametros = class(TInterfacedObject, iModelParametros)
  private
    FPathSys, FNomeSys: String;
    FConfiguracao: TConfiguracao;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelParametros;
    function Configuracao: TConfiguracao;
    procedure Gravar(pConfiguracao: TConfiguracao);
    procedure Criar_Xml;
    procedure Atribuir;
  end;

implementation

{ TModelConexaoParametros }

constructor TModelConexaoParametros.Create;
begin
  FPathSys := ExtractFileDir(Application.ExeName);
  FNomeSys := String(Application.ExeName).Replace('.exe', '').Replace(FPathSys, '').Replace('\','');
  Atribuir;
end;

destructor TModelConexaoParametros.Destroy;
begin
  inherited;
end;

class function TModelConexaoParametros.New: iModelParametros;
begin
  Result := Self.Create;
end;

function TModelConexaoParametros.Configuracao: TConfiguracao;
begin
  Result := FConfiguracao;
end;

procedure TModelConexaoParametros.Atribuir;
var
  ArqXml: String;
  XML: TXMLDocument;
  No: IXMLNode;
  FrmXml: TForm;

begin
  FrmXml := TForm.Create(nil);
  ArqXml := Format('%s\%s.xml',[FPathSys, FNomeSys]);
  XML    := TXMLDocument.Create(FrmXml);

  if not FileExists(ArqXml) Then
     Criar_Xml;

  XML.LoadFromFile(ArqXml);
  XML.Active := True;

  try
    No := XML.ChildNodes.Last;
    if No <> nil then
       begin
         FConfiguracao[0] := No.ChildNodes['TipoConexao'].Text;
         FConfiguracao[1] := No.ChildNodes['DriverDBFireDAC'].Text;
         FConfiguracao[2] := No.ChildNodes['ServidorFireDAC'].Text;
         FConfiguracao[3] := No.ChildNodes['BancoDadosFireDAC'].Text;
         FConfiguracao[4] := No.ChildNodes['UsuarioFireDAC'].Text;
         FConfiguracao[5] := No.ChildNodes['SenhaFireDAC'].Text;
         FConfiguracao[6] := No.ChildNodes['PortaFireDAC'].Text;
       end;
  except on E: Exception do
    Msg('Erro ao Obter as Configura??es de Conex?o !!!', '', 3);
  end;

  XML.Active := False;
  FreeAndNil(XML);
  FreeAndNil(FrmXml);

end;

procedure TModelConexaoParametros.Criar_Xml;
var
  ArqXml: String;
  XML: TXMLDocument;
  NodeXml: IXMLNode;

begin
  ArqXml := Format('%s\%s.xml',[FPathSys, FNomeSys]);
  XML := TXMLDocument.Create(nil);
  XML.Active   := True;
  XML.Encoding := 'UTF-8';
  XML.Version  := '1.0';

  if not FileExists(ArqXml) Then
     begin
       NodeXml := XML.AddChild('Config');
       NodeXml.ChildValues['TipoConexao']       := 'FireDAC';
       NodeXml.ChildValues['DriverDBFireDAC']   := 'MSSQL';
       NodeXml.ChildValues['ServidorFireDAC']   := 'localhost\SQLEXPRESS';
       NodeXml.ChildValues['BancoDadosFireDAC'] := Nome_Sistema;
       NodeXml.ChildValues['UsuarioFireDAC']    := 'sa';
       NodeXml.ChildValues['SenhaFireDAC']      := '1208';
       NodeXml.ChildValues['PortaFireDAC']      := '1433';
     end
  else
     begin
       NodeXml := XML.AddChild('Config');
       NodeXml.ChildValues['TipoConexao']       := FConfiguracao[0];
       NodeXml.ChildValues['DriverDBFireDAC']   := FConfiguracao[1];
       NodeXml.ChildValues['ServidorFireDAC']   := FConfiguracao[2];
       NodeXml.ChildValues['BancoDadosFireDAC'] := FConfiguracao[3];
       NodeXml.ChildValues['UsuarioFireDAC']    := FConfiguracao[4];
       NodeXml.ChildValues['SenhaFireDAC']      := FConfiguracao[5];
       NodeXml.ChildValues['PortaFireDAC']      := FConfiguracao[6];
     end;

   XML.SaveToFile(ArqXml);
end;

procedure TModelConexaoParametros.Gravar(pConfiguracao: TConfiguracao);
var
  i: Integer;

begin
  for i := 0 to Length(FConfiguracao) - 1 do
    FConfiguracao[i] := pConfiguracao[i];

  Criar_Xml;
end;

end.
