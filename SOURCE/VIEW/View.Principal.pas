unit View.Principal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.Actions,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.ImageList,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ImgList,
  Vcl.Buttons,
  Vcl.Imaging.jpeg,
  Vcl.Imaging.pngimage,
  Vcl.WinXCtrls,
  Vcl.ActnList,
  Controller.Conexao.Interfaces,
  Controller.Conexao.Factory,
  Controller.DAO.Interfaces,
  Controller.DAO.Factory,
  Controller.Relatorios.Interfaces,
  Controller.Relatorios.Factory,
  Auxiliar.Datas,
  Auxiliar.Forms,
  Auxiliar.Dialogos,
  Auxiliar.Informacoes,
  Auxiliar.Fundo.Esmaecido,
  Auxiliar.Variaveis.Globais;

type
  TfrmPrincipal = class(TForm)
    pnlRodape: TPanel;
    lblConexao: TLabel;
    lblHora: TLabel;
    lblData: TLabel;
    img16: TImageList;
    img24: TImageList;
    bhPrincipal: TBalloonHint;
    tmPrincipal: TTimer;
    pnlCabecalho: TPanel;
    lblTitulo: TLabel;
    btnFechar: TSpeedButton;
    btnMinimizar: TSpeedButton;
    imgIcone: TImage;
    lblVersaoSistema: TLabel;
    aclPrincipal: TActionList;
    actMinimizarSistema: TAction;
    actFecharSistema: TAction;
    actSairSistema: TAction;
    spvPrincipal: TSplitView;
    pnlPrincipal: TPanel;
    actCadastroDoadores: TAction;
    actProcessoDoacao: TAction;
    actRelatorioDoacoes: TAction;
    Panel1: TPanel;
    btnSairSistema: TSpeedButton;
    Image1: TImage;
    SpeedButton1: TSpeedButton;
    btnProcessoDoacao: TSpeedButton;
    btnCadastroPessoas: TSpeedButton;
    Image2: TImage;
    Image3: TImage;
    imgInicio: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure Image3MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure tmPrincipalTimer(Sender: TObject);
    procedure lblConexaoClick(Sender: TObject);
    procedure actMinimizarSistemaExecute(Sender: TObject);
    procedure actFecharSistemaExecute(Sender: TObject);
    procedure actSairSistemaExecute(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure actCadastroDoadoresExecute(Sender: TObject);
    procedure actProcessoDoacaoExecute(Sender: TObject);
    procedure actRelatorioDoacoesExecute(Sender: TObject);
  private
    FControle: iControllerConexao;
    FDAO: iControllerDAO;
    FRelatorios: iControllerRelatorios;
    FJanelas_Abertas: Integer;
    procedure Posicao_Janela;
    procedure Status_Conexao;
    procedure Abrir_Janela_Panel(pForm: String);
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;
  FFundo: TFundoEsmaecido;

implementation

{$R *.dfm}

//###########################################################################
// EVENTOS NATIVOS DO FORM
//###########################################################################
procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  FControle   := TControllerConexao.New;
  FDAO        := TControllerDAO.New;
  FRelatorios := TControllerRelatorios.New;
  FFundo      := TFundoEsmaecido.Create(nil);

  FJanelas_Abertas := 0;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  // Carrega Informa??es de Vers?o do Sistema
  lblVersaoSistema.Caption := Versao_Sistema;

  // Carrega informa??es de Data e Hora
  lblData.Caption    := DataPorExtenso;
  lblHora.Caption    := HoraStr;

  // Carrega informa??es da Posi??o e Tamanho da Janela
  Posicao_Janela;

  // Carrega informa??es do Status da Conex?o do Banco de Dados
  Status_Conexao;

  FDAO.Pessoa.Criar_Tabela;
  FDAO.Doacao.Criar_Tabela;
end;

procedure TfrmPrincipal.Image3MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
begin
  ReleaseCapture();
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
  Posicao_Janela;
end;

procedure TfrmPrincipal.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    Char(VK_ESCAPE):
      begin
        Key := #0;
        if gJanelas_Abertas = 0 then
           Close;
      end;

    char(VK_RETURN):
      begin
        Key := #0;
        keybd_event(VK_TAB, 0, 0, 0);
      end;
  end;
end;

procedure TfrmPrincipal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := Pergunta('Deseja Realmente Sair do Sistema ?');
  if CanClose then
     begin
       ModalResult := mrCancel;
     end
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  Application.Terminate;
  TerminateProcess(GetCurrentProcess, 0);
end;

//###########################################################################
// EVENTO DO TIMER DE ATUALIZA??O DA DATA E DA HORA
//###########################################################################
procedure TfrmPrincipal.tmPrincipalTimer(Sender: TObject);
begin
  lblData.Caption := DataPorExtenso;
  lblHora.Caption := HoraStr;
end;

//###########################################################################
// PERMITE CONFIGURAR A CONEX?O AO BANCO DE DADOS
//###########################################################################
procedure TfrmPrincipal.lblConexaoClick(Sender: TObject);
begin
  Abrir_Janela('TfrmConfigurarConexao');
  Status_Conexao;
end;

//###########################################################################
// EVENTOS DAS A??ES
//###########################################################################
procedure TfrmPrincipal.actMinimizarSistemaExecute(Sender: TObject);
begin
  WindowState := wsMinimized;
end;

procedure TfrmPrincipal.actFecharSistemaExecute(Sender: TObject);
begin
  actSairSistema.Execute;
end;

procedure TfrmPrincipal.actCadastroDoadoresExecute(Sender: TObject);
begin
  Abrir_Janela_Panel('TfrmDoadores');
end;

procedure TfrmPrincipal.actProcessoDoacaoExecute(Sender: TObject);
begin
  Abrir_Janela_Panel('TfrmDoacoes');
end;

procedure TfrmPrincipal.actRelatorioDoacoesExecute(Sender: TObject);
begin
  FRelatorios.Doacoes.Imprimir;
end;

procedure TfrmPrincipal.actSairSistemaExecute(Sender: TObject);
begin
  Close;
end;

//###########################################################################
// EVENTO DO BOT?O RETORNAR DO PAINEL TRABALHO
//###########################################################################
procedure TfrmPrincipal.btnCancelarClick(Sender: TObject);
begin
//
end;

//###########################################################################
// FUN??ES DE AUX?LIO DO FORM
//###########################################################################
procedure TfrmPrincipal.Posicao_Janela;
begin
  gTopo          := Top;
  gEsquerda      := Left;
  gLargura       := Width;
  gComprimento   := Height;
  gPosicao       := poMainFormCenter;
end;

procedure TfrmPrincipal.Status_Conexao;
begin
  lblConexao.Caption := FControle.Conexao.Driver.Status;
  if String(lblConexao.Caption).Contains('Off-Line') then
     begin
       lblConexao.Font.Color := clRed;
     end
  else
     begin
       lblConexao.Font.Color := clLime;
     end;
end;

///####################################################################################################################
/// Fun??o   : Abrir_Janela_Panel()
/// Objetivo : Respons?vel Pela Abertura de Forms no Panel Principal
///####################################################################################################################
procedure TfrmPrincipal.Abrir_Janela_Panel(pForm: String);
var
  FormClasse: TFormClass;
  FormTela: TForm;
  i: Integer;
  bCriado: Boolean;

begin
  bCriado := False;
  FormClasse := TFormClass(FindClass(pForm));
  for i := 0 to Application.ComponentCount - 1 do
    begin
      if (Application.Components[i] is TForm) and (Application.Components[i].ClassName = pForm) then
         begin
           FormTela := TForm(Application.Components[i]);
           bCriado := True;
           Break;
         end;
    end;

  if not bCriado then
     Application.CreateForm(FormClasse, FormTela);

  FormTela.Parent := pnlPrincipal;
  FormTela.Height := pnlPrincipal.Height;
  FormTela.Show;

end;

end.
