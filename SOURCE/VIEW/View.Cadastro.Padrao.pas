unit View.Cadastro.Padrao;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Actions,
  System.ImageList,
  Data.DB,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.VirtualImage,
  Vcl.StdCtrls,
  Vcl.Imaging.pngimage,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Vcl.ActnList,
  Vcl.ImgList,
  Vcl.Grids,
  Vcl.DBGrids,
  Auxiliar.Dialogos,
  Auxiliar.Teclado,
  Auxiliar.Validacoes,
  Auxiliar.Variaveis.Globais;

type
  TfrmBaseCadastros = class(TForm)
    pnlCabecalho: TPanel;
    lblTitulo: TLabel;
    bhFormBase: TBalloonHint;
    aclFormBase: TActionList;
    actRetornar: TAction;
    pnlTrabalho: TPanel;
    imgFundoTrabalho: TImage;
    pnlJanelaDados: TPanel;
    pnlDBGrid: TPanel;
    pnlManutencaoDados: TPanel;
    Image1: TImage;
    btnNovo: TSpeedButton;
    btnAlterar: TSpeedButton;
    btnRetornar: TSpeedButton;
    btnConsultar: TSpeedButton;
    btnListar: TSpeedButton;
    btnExcluir: TSpeedButton;
    actNovo: TAction;
    actAlterar: TAction;
    actExcluir: TAction;
    actConsultar: TAction;
    actListar: TAction;
    dbgCadastro: TDBGrid;
    pnlPesquisa: TPanel;
    GroupBox1: TGroupBox;
    cbxFiltros: TComboBox;
    GroupBox2: TGroupBox;
    edtLocalizar: TEdit;
    Panel1: TPanel;
    img32: TImageList;
    btnSalvar: TSpeedButton;
    btnCancelar: TSpeedButton;
    actSalvar: TAction;
    actCancelar: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dbgCadastroKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbxFiltrosSelect(Sender: TObject);
    procedure actRetornarExecute(Sender: TObject);
    procedure actNovoExecute(Sender: TObject);
    procedure actAlterarExecute(Sender: TObject);
    procedure actExcluirExecute(Sender: TObject);
    procedure actConsultarExecute(Sender: TObject);
    procedure actListarExecute(Sender: TObject);
    procedure actCancelarExecute(Sender: TObject);
    procedure actSalvarExecute(Sender: TObject);
    procedure dbgCadastroTitleClick(Column: TColumn);
    procedure edtLocalizarExit(Sender: TObject);
  private
    FCampo: String;
    FDesc: Boolean;
    FTitulo_Antigo: String;
    FManutencao_Aberta: Boolean;
    procedure Janela_Manutencao;
  public
    dsCadastro: TDataSource;
    FOperacao: TOperacao;
    procedure Preencher_Cbx_Filtros;
    procedure Buscar_Registros(pDataSource: TDataSource); virtual;
    procedure Imprimir_Listagem; virtual;
    procedure Carregar_Janela; virtual;
    procedure Executar_Operacao; virtual;
  end;

var
  frmBaseCadastros: TfrmBaseCadastros;

implementation

uses
  Datasnap.DBClient;

{$R *.dfm}

procedure TfrmBaseCadastros.FormCreate(Sender: TObject);
begin
  Inc(gJanelas_Abertas);
  FCampo := '';
  FDesc := False;
  FManutencao_Aberta := False;
end;

procedure TfrmBaseCadastros.FormShow(Sender: TObject);
begin
  dsCadastro := TDataSource.Create(nil);
  pnlDBGrid.BringToFront;
  dbgCadastro.SetFocus;
end;

procedure TfrmBaseCadastros.cbxFiltrosSelect(Sender: TObject);
begin
  edtLocalizar.SetFocus;
end;

procedure TfrmBaseCadastros.dbgCadastroKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_F2: if btnNovo.Enabled      then actNovo.Execute;
    VK_F3: if btnAlterar.Enabled   then actAlterar.Execute;
    VK_F4: if btnExcluir.Enabled   then actExcluir.Execute;
    VK_F5: if btnConsultar.Enabled then actConsultar.Execute;
    VK_F6: if btnListar.Enabled    then actListar.Execute;
    VK_F9: edtLocalizar.SetFocus;
    VK_RETURN: begin Key := 0; actAlterar.Execute; end;
    VK_ESCAPE: begin Key := 0; actRetornar.Execute; end;
  end;
end;

procedure TfrmBaseCadastros.dbgCadastroTitleClick(Column: TColumn);
var
  vloIndices: TStrings;
  vliCont: Integer;

begin
  inherited;
  vloIndices := TStringList.Create;

  TClientDataSet(Column.Grid.DataSource.DataSet).GetIndexNames(vloIndices);
  TClientDataSet(Column.Grid.DataSource.DataSet).IndexName := EmptyStr;

  vliCont := vloIndices.IndexOf('idx' + Column.FieldName);
  if vliCont > 0 then
     TClientDataSet(Column.Grid.DataSource.DataSet).DeleteIndex('idx' + Column.FieldName);

  if FCampo = Column.FieldName then
     begin
       if not FDesc then
          begin
            FDesc := True;
            TClientDataSet(Column.Grid.DataSource.DataSet).AddIndex('idx' + Column.FieldName, Column.FieldName, [], Column.FieldName)
          end
       else
          begin
            FDesc := False;
            TClientDataSet(Column.Grid.DataSource.DataSet).AddIndex('idx' + Column.FieldName, Column.FieldName, []);
          end;
     end
  else
     begin
       FCampo := Column.FieldName;
       TClientDataSet(Column.Grid.DataSource.DataSet).AddIndex('idx' + Column.FieldName, Column.FieldName, []);
     end;

  TClientDataSet(Column.Grid.DataSource.DataSet).IndexName := 'idx' + Column.FieldName;
  TClientDataSet(Column.Grid.DataSource.DataSet).First;

  cbxFiltros.Text := Column.Title.Caption;
end;

procedure TfrmBaseCadastros.edtLocalizarExit(Sender: TObject);
begin
  Buscar_Registros(dsCadastro);
end;

procedure TfrmBaseCadastros.actNovoExecute(Sender: TObject);
begin
  FOperacao := opNovo;
  Janela_Manutencao;
end;

procedure TfrmBaseCadastros.actAlterarExecute(Sender: TObject);
begin
  FOperacao := opAlterar;
  Janela_Manutencao;
end;

procedure TfrmBaseCadastros.actExcluirExecute(Sender: TObject);
begin
  FOperacao := opExcluir;
  Janela_Manutencao;
end;

procedure TfrmBaseCadastros.actConsultarExecute(Sender: TObject);
begin
  FOperacao := opConsultar;
  Janela_Manutencao;
end;

procedure TfrmBaseCadastros.actListarExecute(Sender: TObject);
begin
  Limpar_Buffer_Teclado;
  Imprimir_Listagem;
end;

procedure TfrmBaseCadastros.actRetornarExecute(Sender: TObject);
begin
  Limpar_Buffer_Teclado;
  if not FManutencao_Aberta then
     begin
       Dec(gJanelas_Abertas);
       Close;
     end
  else
     actCancelar.Execute;
end;

procedure TfrmBaseCadastros.actSalvarExecute(Sender: TObject);
begin
  try
    Executar_Operacao;
    actCancelar.Execute;
  except on E: Exception do
  end;
end;

procedure TfrmBaseCadastros.actCancelarExecute(Sender: TObject);
begin
  FManutencao_Aberta := False;
  if not (dsCadastro.State in [dsInactive]) then
     dsCadastro.DataSet.Cancel;

  lblTitulo.Caption := FTitulo_Antigo;
  dbgCadastro.SetFocus;
  pnlDBGrid.BringToFront;
end;

procedure TfrmBaseCadastros.Preencher_Cbx_Filtros;
var
  i: Integer;

begin
  if dbgCadastro.Columns.Count > 0 then
     begin
       cbxFiltros.Items.Clear;
       for i := 0 to dbgCadastro.Columns.Count - 1 do
           begin
             cbxFiltros.Items.Add(dbgCadastro.Columns[i].Title.Caption);
           end;
       cbxFiltros.ItemIndex := 0;
     end;
end;

procedure TfrmBaseCadastros.Janela_Manutencao;
var
  FTitulo_Operacao: String;

begin
  Limpar_Buffer_Teclado;
  FManutencao_Aberta := True;
  FTitulo_Antigo := lblTitulo.Caption;
  case FOperacao of
    opNovo:
      FTitulo_Operacao := 'Inclusão';
    opAlterar:
      FTitulo_Operacao := 'Alteração';
    opConsultar:
      FTitulo_Operacao := 'Consulta';
    opExcluir:
      begin
        FManutencao_Aberta := False;
        Executar_Operacao;
        exit;
      end;
  end;

  if FOperacao <> opConsultar then
     btnSalvar.Visible := True
  else
     btnSalvar.Visible := False;

  lblTitulo.Caption := Format('%s - %s', [FTitulo_Antigo, FTitulo_Operacao]);

  try
    Carregar_Janela;
    pnlManutencaoDados.BringToFront;
  except on E: Exception do
    actCancelar.Execute;
  end;

end;

procedure TfrmBaseCadastros.Buscar_Registros(pDataSource: TDataSource);
begin
end;

procedure TfrmBaseCadastros.Imprimir_Listagem;
begin
end;

procedure TfrmBaseCadastros.Carregar_Janela;
begin
end;

procedure TfrmBaseCadastros.Executar_Operacao;
begin
end;

end.
