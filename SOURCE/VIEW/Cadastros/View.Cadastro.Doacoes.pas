unit View.Cadastro.Doacoes;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.Actions,
  System.ImageList,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ImgList,
  Vcl.ActnList,
  Vcl.StdCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.Buttons,
  Vcl.ExtCtrls,
  Vcl.Imaging.pngimage,
  Data.DB,
  View.Cadastro.Padrao,
  Controller.DAO.Interfaces,
  Controller.DAO.Factory,
  AUxiliar.Helpers,
  Auxiliar.Dialogos,
  Auxiliar.Variaveis.Globais, Vcl.ComCtrls;

type
  TfrmDoacoes = class(TfrmBaseCadastros)
    Label3: TLabel;
    edtPES_ID: TEdit;
    edtNomeDoador: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtIdadeDoador: TEdit;
    Label5: TLabel;
    edtDOA_DATA: TDateTimePicker;
    edtDOA_QTDE: TEdit;
    Label4: TLabel;
    lblStatusDoacao: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtPES_IDExit(Sender: TObject);
    procedure edtDOA_QTDEExit(Sender: TObject);
  private
    FDAO: iModelDAO;
  public
    procedure Buscar_Registros(pDataSource: TDataSource); override;
    procedure Carregar_Janela; override;
    procedure Imprimir_Listagem; override;
    procedure Executar_Operacao; override;
  end;

var
  frmDoacoes: TfrmDoacoes;

implementation

{$R *.dfm}

procedure TfrmDoacoes.FormCreate(Sender: TObject);
begin
  inherited;
  FDAO := TControllerDAO.New.Doacao;
end;

procedure TfrmDoacoes.FormShow(Sender: TObject);
begin
  inherited;
  lblTitulo.Caption  := 'Cadastro de Doa??es';
  btnExcluir.Caption := 'A&nular';
  actExcluir.Hint    := '<F4> Para ANULAR a DOA??O Selecionada no GRID';

  FDAO.Carregar_Registros(dbgCadastro, dsCadastro);

  dbgCadastro.DataSource := dsCadastro;
  Preencher_Cbx_Filtros;
end;

procedure TfrmDoacoes.edtDOA_QTDEExit(Sender: TObject);
begin
  inherited;
  actSalvar.Execute;
end;

procedure TfrmDoacoes.edtPES_IDExit(Sender: TObject);
begin
  inherited;
  if not edtPES_ID.IsEmpty then
     FDAO.Formulario(Self).Buscar_Doador(edtPES_ID.Text);
end;

procedure TfrmDoacoes.Buscar_Registros(pDataSource: TDataSource);
begin
  inherited;
  FDAO.Filtrar_Registros(pDataSource, cbxFiltros.Text, edtLocalizar.Text);
  dbgCadastro.SetFocus;
end;

procedure TfrmDoacoes.Carregar_Janela;
begin
  inherited;
  try
    FDAO.Formulario(Self).Operacao(FOperacao).Montar_Janela_Manutencao(dsCadastro);
  except on E: Exception do
    begin
      MsgSys(E.Message, 3);
      raise Exception.Create('');
    end;
  end;
end;

procedure TfrmDoacoes.Imprimir_Listagem;
begin
  inherited;
  FDAO.Listar_Registros;
end;

procedure TfrmDoacoes.Executar_Operacao;
begin
  inherited;
  FDAO.Formulario(Self).Operacao(FOperacao).Executar_Operacoes(dsCadastro);
end;

initialization
  RegisterClass(TfrmDoacoes);

finalization
  UnRegisterClasses([TfrmDoacoes]);

end.
