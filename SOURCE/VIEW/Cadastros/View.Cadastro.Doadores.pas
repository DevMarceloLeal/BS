unit View.Cadastro.Doadores;

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
  Vcl.ImgList,
  Vcl.ActnList,
  Vcl.StdCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.Buttons,
  Vcl.ExtCtrls,
  Vcl.Imaging.pngimage,
  Vcl.ComCtrls,
  Data.DB,
  View.Cadastro.Padrao,
  Controller.DAO.Interfaces,
  Controller.DAO.Factory,
  Auxiliar.Dialogos,
  Auxiliar.Variaveis.Globais;

type
  TfrmDoadores = class(TfrmBaseCadastros)
    edtPES_NOME: TEdit;
    edtPES_DATANASC: TDateTimePicker;
    edtPES_CPF: TEdit;
    edtPES_TIPOSANG: TComboBox;
    edtPES_CELULAR: TEdit;
    edtPES_EMAIL: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FDAO: iModelDAO;
  public
    procedure Buscar_Registros(pDataSource: TDataSource); override;
    procedure Carregar_Janela; override;
    procedure Imprimir_Listagem; override;
    procedure Executar_Operacao; override;
  end;

var
  frmDoadores: TfrmDoadores;

implementation

uses
  Datasnap.DBClient;

{$R *.dfm}

procedure TfrmDoadores.FormCreate(Sender: TObject);
begin
  inherited;
  FDAO := TControllerDAO.New.Pessoa;
end;

procedure TfrmDoadores.FormShow(Sender: TObject);
begin
  inherited;
  lblTitulo.Caption := 'Cadastro de Doadores';

  FDAO.Carregar_Registros(dbgCadastro, dsCadastro);

  dbgCadastro.DataSource := dsCadastro;
  Preencher_Cbx_Filtros;
end;

procedure TfrmDoadores.Buscar_Registros(pDataSource: TDataSource);
begin
  inherited;
  FDAO.Filtrar_Registros(pDataSource, cbxFiltros.Text, edtLocalizar.Text);
  dbgCadastro.SetFocus;
end;

procedure TfrmDoadores.Carregar_Janela;
begin
  inherited;
  FDAO.Formulario(Self).Operacao(FOperacao).Montar_Janela_Manutencao(dsCadastro);
  if FOperacao <> opConsultar then
     edtPES_NOME.SetFocus;
end;

procedure TfrmDoadores.Imprimir_Listagem;
begin
  inherited;
  FDAO.Listar_Registros;
end;

procedure TfrmDoadores.Executar_Operacao;
begin
  inherited;
  FDAO.Formulario(Self).Operacao(FOperacao).Executar_Operacoes(dsCadastro);
end;

initialization
  RegisterClass(TfrmDoadores);

finalization
  UnRegisterClasses([TfrmDoadores]);

end.
