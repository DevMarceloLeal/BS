program BS;

{$R *.dres}

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  Controller.Conexao.Factory in 'SOURCE\CONTROLLER\Controller.Conexao.Factory.pas',
  Controller.Conexao.Interfaces in 'SOURCE\CONTROLLER\Controller.Conexao.Interfaces.pas',
  Model.Conexao.Factory in 'SOURCE\MODEL\CONEXAO\Model.Conexao.Factory.pas',
  Model.Conexao.Interfaces in 'SOURCE\MODEL\CONEXAO\Model.Conexao.Interfaces.pas',
  Model.Conexao.Parametros in 'SOURCE\MODEL\CONEXAO\Model.Conexao.Parametros.pas',
  Model.FireDAC.Conexao in 'SOURCE\MODEL\CONEXAO\Model.FireDAC.Conexao.pas',
  Model.FireDAC.DataFunctions in 'SOURCE\MODEL\CONEXAO\Model.FireDAC.DataFunctions.pas',
  Model.FireDAC.Query in 'SOURCE\MODEL\CONEXAO\Model.FireDAC.Query.pas',
  Classe.Parametros.Conexao in 'SOURCE\MODEL\CLASSES\Classe.Parametros.Conexao.pas',
  Classe.BS.Pessoa in 'SOURCE\MODEL\CLASSES\Classe.BS.Pessoa.pas',
  Controller.DAO.Factory in 'SOURCE\CONTROLLER\Controller.DAO.Factory.pas',
  Controller.DAO.Interfaces in 'SOURCE\CONTROLLER\Controller.DAO.Interfaces.pas',
  Model.DAO.Parametros in 'SOURCE\MODEL\DAO\Model.DAO.Parametros.pas',
  Model.DAO.BS.Pessoa in 'SOURCE\MODEL\DAO\Model.DAO.BS.Pessoa.pas',
  Auxiliar.Achoice in 'SOURCE\AUXILIAR\Auxiliar.Achoice.pas',
  Auxiliar.Calculos in 'SOURCE\AUXILIAR\Auxiliar.Calculos.pas',
  Auxiliar.Classes in 'SOURCE\AUXILIAR\Auxiliar.Classes.pas',
  Auxiliar.Comandos.SQL in 'SOURCE\AUXILIAR\Auxiliar.Comandos.SQL.pas',
  Auxiliar.Conversoes in 'SOURCE\AUXILIAR\Auxiliar.Conversoes.pas',
  Auxiliar.DataGrid in 'SOURCE\AUXILIAR\Auxiliar.DataGrid.pas',
  Auxiliar.Datas in 'SOURCE\AUXILIAR\Auxiliar.Datas.pas',
  Auxiliar.Dialogos in 'SOURCE\AUXILIAR\Auxiliar.Dialogos.pas',
  Auxiliar.Forms in 'SOURCE\AUXILIAR\Auxiliar.Forms.pas',
  Auxiliar.Fundo.Esmaecido in 'SOURCE\AUXILIAR\Auxiliar.Fundo.Esmaecido.pas',
  Auxiliar.Helpers in 'SOURCE\AUXILIAR\Auxiliar.Helpers.pas',
  Auxiliar.Informacoes in 'SOURCE\AUXILIAR\Auxiliar.Informacoes.pas',
  Auxiliar.Validacoes in 'SOURCE\AUXILIAR\Auxiliar.Validacoes.pas',
  Auxiliar.Variaveis.Globais in 'SOURCE\AUXILIAR\Auxiliar.Variaveis.Globais.pas',
  View.Achoice in 'SOURCE\VIEW\View.Achoice.pas' {frmEscolher},
  View.BackTransparent in 'SOURCE\VIEW\View.BackTransparent.pas' {frmBlack},
  View.Configurar.Conexao in 'SOURCE\VIEW\View.Configurar.Conexao.pas' {frmConfigurarConexao},
  View.Mensagens in 'SOURCE\VIEW\View.Mensagens.pas' {frmMensagens},
  View.Principal in 'SOURCE\VIEW\View.Principal.pas' {frmPrincipal},
  Classe.BS.Doacao in 'SOURCE\MODEL\CLASSES\Classe.BS.Doacao.pas',
  Model.DAO.BS.Doacao in 'SOURCE\MODEL\DAO\Model.DAO.BS.Doacao.pas',
  View.Cadastro.Padrao in 'SOURCE\VIEW\View.Cadastro.Padrao.pas' {frmBaseCadastros},
  Classe.Atributos in 'SOURCE\MODEL\CLASSES\Classe.Atributos.pas',
  View.Cadastro.Doadores in 'SOURCE\VIEW\Cadastros\View.Cadastro.Doadores.pas' {frmDoadores},
  View.Listagem.Padrao in 'SOURCE\VIEW\View.Listagem.Padrao.pas' {frmBaseListagem},
  Auxiliar.Formatacoes in 'SOURCE\AUXILIAR\Auxiliar.Formatacoes.pas',
  View.Cadastro.Doacoes in 'SOURCE\VIEW\Cadastros\View.Cadastro.Doacoes.pas' {frmDoacoes},
  Auxiliar.Teclado in 'SOURCE\AUXILIAR\Auxiliar.Teclado.pas',
  Controller.Relatorios.Interfaces in 'SOURCE\CONTROLLER\Controller.Relatorios.Interfaces.pas',
  Controller.Relatorios.Factory in 'SOURCE\CONTROLLER\Controller.Relatorios.Factory.pas',
  Model.Relatorios.Doacoes in 'SOURCE\MODEL\RELATORIOS\Model.Relatorios.Doacoes.pas';

{$R *.res}

begin
  TStyleManager.TrySetStyle('Ruby Graphite');

  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
