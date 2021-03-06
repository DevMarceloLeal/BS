unit Model.DAO.BS.Doacao;

interface

uses
  System.SysUtils,
  System.DateUtils,
  Vcl.Forms,
  Vcl.DBGrids,
  Data.DB,
  Datasnap.Provider,
  Datasnap.DBClient,
  RLReport,
  Model.Conexao.Interfaces,
  Controller.Conexao.Interfaces,
  Controller.Conexao.Factory,
  Controller.DAO.Interfaces,
  Auxiliar.Datas,
  Auxiliar.Forms,
  Auxiliar.Classes,
  Auxiliar.Dialogos,
  Auxiliar.DataGrid,
  Auxiliar.Validacoes,
  Auxiliar.Conversoes,
  Auxiliar.Informacoes,
  Auxiliar.Formatacoes,
  Auxiliar.Variaveis.Globais,
  Classe.BS.Doacao;

type
  TRegistro = record
    Qtde: Currency;
    Status: String;
    Pessoa: Integer;
  end;

  TModelDAODoacao = class(TInterfacedObject, iModelDAO)
  private
    FConexao: iModelConexaoFactory;
    FClasse: TClasses;
    FFormulario: TForm;
    FOperacao: TOperacao;
    FDBSource: TDataSource;
    FObj: TBS_Doacao;
    procedure ExecSQL(pSql: String);
    procedure Criar_Registros;
    procedure Preencher_DataSource(pDataSource: TDataSource; pSQL: String);
    function Validar_Campos(pDataSource: TDataSource): Boolean;
    function Liberar_Doacao(pDoador, pData: String): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelDAO;
    function Criar_Tabela: iModelDAO;
    function Formulario(pForm: TForm): iModelDAO;
    function Operacao(pOperacao: TOperacao): iModelDAO;
    function Carregar_Registros(pDBGrid: TDBGrid; pDataSource: TDataSource): iModelDAO;
    procedure Buscar_Doador(pCodigo: String);
    procedure Montar_Janela_Manutencao(pDataSource: TDataSource);
    procedure Executar_Operacoes(pDataSource: TDataSource);
    procedure Filtrar_Registros(pDataSource: TDataSource; pCampo, pTexto: String);
    procedure Listar_Registros;
  end;

const
  FRegistros: array[0..14] of TRegistro =
  (
      (Qtde: 1.00; Status:''; Pessoa: 1),
      (Qtde: 1.00; Status:''; Pessoa: 2),
      (Qtde: 1.00; Status:''; Pessoa: 3),
      (Qtde: 1.00; Status:''; Pessoa: 4),
      (Qtde: 1.00; Status:''; Pessoa: 5),
      (Qtde: 1.00; Status:''; Pessoa: 6),
      (Qtde: 1.00; Status:''; Pessoa: 7),
      (Qtde: 1.00; Status:''; Pessoa: 8),
      (Qtde: 1.00; Status:''; Pessoa: 9),
      (Qtde: 1.00; Status:''; Pessoa: 10),
      (Qtde: 1.00; Status:''; Pessoa: 11),
      (Qtde: 1.00; Status:''; Pessoa: 1),
      (Qtde: 1.00; Status:''; Pessoa: 2),
      (Qtde: 1.00; Status:''; Pessoa: 7),
      (Qtde: 1.00; Status:''; Pessoa: 8)
  );

  aFields  : array[0..4] of String  = ('DOA_ID', 'DOA_DATA', 'PES_NOME', 'DOA_QTDE', 'STATUS');
  aHeaders : array[0..4] of String  = ('C?digo', 'Data Doa??o', 'Doador', 'Qtde', 'Status');
  aWidths  : array[0..4] of Integer = (40, 60, 250, 60, 110);
  aAligns  : array[0..4] of String  = ('Right', 'Center', 'Left', 'Right', 'Center');

  // Configura??o do Relat?rio
  FTituloReport  : String = 'Listagem do Cadastro de Doa??es';
  aCamposReport  : array[0..5] of String  = ('DOA_ID', 'DOA_DATA', 'PES_NOME', 'PES_TIPOSANG', 'DOA_QTDE', 'STATUS');
  aLabelsReport  : array[0..5] of String  = ('    ID', 'Data Doa??o', 'Nome do Doador', 'Tipo Sangu?neo', 'Qtde Doada', 'Status');
  aWidthReport   : array[0..5] of Integer = ( 50, 100, 200, 110,  80, 100);
  aPosicaoReport : array[0..5] of Integer = (  5,  70, 170, 390, 510, 600);
  aAlignReport   : array[0..5] of String  = ('Right', 'Center', 'Left', 'Center', 'Right', 'Left');

implementation

uses
  View.Listagem.Padrao;

{ TModelDAODoacao }

constructor TModelDAODoacao.Create;
begin
  FConexao := TControllerConexao.New.Conexao;
  FClasse  := TClasses.New;
end;

destructor TModelDAODoacao.Destroy;
begin
  inherited;
end;

procedure TModelDAODoacao.ExecSQL(pSql: String);
begin
  try
    FConexao.Query.ExecSQL(pSql);
  except on E: Exception do
    MsgSys('Erro ao Executar Comando SQL !!!' + #13#13 + E.Message);
  end;
end;

procedure TModelDAODoacao.Criar_Registros;
var
  I: Integer;
  FObj: TBS_Doacao;

begin
  for I := 0 to Length(FRegistros) - 1 do
    begin
      FObj := TBS_Doacao.New;
      FObj.DOA_QTDE     := FRegistros[I].Qtde;
      FObj.DOA_STATUS   := FRegistros[I].Status;
      FObj.PES_ID       := FRegistros[I].Pessoa;
      ExecSQL(TBS_Doacao.SQL_Incrementa + FClasse.Objeto(FObj).Classe_To_SQL);
    end;
end;

procedure TModelDAODoacao.Preencher_DataSource(pDataSource: TDataSource; pSQL: String);
var
  FDataSetProvider: TDataSetProvider;

begin
  FDataSetProvider := TDataSetProvider.Create(nil);
  pDataSource.DataSet := TClientDataSet.Create(nil);

  FDataSetProvider.DataSet := FConexao.Query.OpenTable(pSQL).DataSet;
  TClientDataSet(pDataSource.DataSet).SetProvider(FDataSetProvider);

  pDataSource.DataSet.Open;
  FormataDataSet(pDataSource.DataSet);
end;

function TModelDAODoacao.Liberar_Doacao(pDoador, pData: String): Boolean;
var
  FDataSetProvider: TDataSetProvider;
  FClientDataSet: TClientDataSet;

begin
  FDataSetProvider := TDataSetProvider.Create(nil);
  FClientDataSet   := TClientDataSet.Create(nil);

  FDataSetProvider.DataSet := FConexao.Query.OpenTable(TBS_DOACAO.SQL_Ultima_Doacao(pDoador, pData)).DataSet;
  FClientDataSet.SetProvider(FDataSetProvider);
  FClientDataSet.Open;

  Result := False;
  if DaysBetween(StrToDate(pData), FClientDataSet.FieldByName('DOA_DATA').AsDateTime) > 15 then
     Result := True;

  FClientDataSet.Close;
  FDataSetProvider.Free;
  FClientDataSet.Free;
end;

function TModelDAODoacao.Validar_Campos(pDataSource: TDataSource): Boolean;
var
  FObj: TBS_Doacao;
  FIdade: Integer;

begin
  FObj := TBS_Doacao.New;
  FClasse.Formulario(FFormulario).Objeto(FObj).Form_To_Classe;
  FIdade := Calcular_Idade(pDataSource.DataSet.FieldByName('PES_DATANASC').AsDateTime);

  if ((FIdade < 18) or (FIdade > 60)) then
     begin
       Foco_Componente(FFormulario, 'edtPES_ID');
       raise Exception.Create('Esta Pessoa N?o Tem Idade Para Doador !!!');
     end;

  if pDataSource.DataSet.FieldByName('DOA_DATA').AsDateTime <> FObj.DOA_DATA then
     begin
       if FObj.DOA_DATA > Date then
          begin
            Foco_Componente(FFormulario, 'edtDOA_DATA');
            raise Exception.Create('Data da Doa??o N?o Pode Ser Maior q a Data de Hoje !!!');
          end
       else
          begin
            if not Liberar_Doacao(FObj.PES_ID.ToString, FObj.DOA_DATA.ToString) then
               begin
                 Foco_Componente(FFormulario, 'edtDOA_DATA');
                 raise Exception.Create('Doador Doou Sangue ? Menos de 15 Dias !!!');
               end;
          end;
     end;

  if pDataSource.DataSet.FieldByName('DOA_QTDE').AsCurrency <> FObj.DOA_QTDE then
     begin
       if (FObj.DOA_QTDE <= 0.00) or (FObj.DOA_QTDE > 1.00) then
          begin
            Foco_Componente(FFormulario, 'edtDOA_QTDE');
            raise Exception.Create(Format('Qtd n?o Poder Ser %s !!!', [iif(FObj.DOA_QTDE <= 0.00,'Igual a Zero','Maior q 1 Litro')]));
          end
     end;

  Result := True;
end;

class function TModelDAODoacao.New: iModelDAO;
begin
  Result := Self.Create;
end;

function TModelDAODoacao.Criar_Tabela: iModelDAO;
begin
  // Verifica a Exist?ncia da Tabela de Dados
  if (FConexao.DBFuncoes.Gerar_ID('BS_DOACAO') > 0) then
     exit;

  // Caso Ela N?o Exista Ela ? Criada
  try
    ExecSQL(TBS_Doacao.SQL_Criar_Tabela);
    Criar_Registros;
  except on E: Exception do
    MsgSys('Erro ao Criar Tabela !!!' + #13#13 + E.Message);
  end;

  Result := Self;
end;

function TModelDAODoacao.Formulario(pForm: TForm): iModelDAO;
begin
  Result      := Self;
  FFormulario := pForm;
end;

function TModelDAODoacao.Operacao(pOperacao: TOperacao): iModelDAO;
begin
  Result    := Self;
  FOperacao := pOperacao;
end;

procedure TModelDAODoacao.Buscar_Doador(pCodigo: String);
var
  FDataSetProvider: TDataSetProvider;
  FClientDataSet: TClientDataSet;

begin
  FDataSetProvider := TDataSetProvider.Create(nil);
  FClientDataSet   := TClientDataSet.Create(nil);

  FDataSetProvider.DataSet := FConexao.Query.OpenTable(TBS_Doacao.SQL_Seleciona_Doador(pCodigo)).DataSet;
  FClientDataSet.SetProvider(FDataSetProvider);
  FClientDataSet.Open;

  if FClientDataSet.FieldByName('PES_NOME').AsString.IsEmpty then
     begin
       MsgSys('Doador N?o Localizado !!!');
       Componente_Valor(FFormulario, 'edtPES_ID', '', True);
       Componente_Valor(FFormulario, 'edtNomeDoador', '', True);
       Componente_Valor(FFormulario, 'edtIdadeDoador', '', True);
       Foco_Componente(FFormulario, 'edtPES_ID');
     end
  else
     if not Componente_Vazio(FFormulario, 'edtPES_ID') then
        begin
          Componente_Valor(FFormulario, 'edtNomeDoador', FClientDataSet.FieldByName('PES_NOME').AsString);
          Componente_Valor(FFormulario, 'edtIdadeDoador', Calcular_Idade(FClientDataSet.FieldByName('PES_DATANASC').AsDateTime).ToString);
        end;
end;

function TModelDAODoacao.Carregar_Registros(pDBGrid: TDBGrid; pDataSource: TDataSource): iModelDAO;
begin
  Result := Self;
  MontarGrid(pDBGrid, aFields, aHeaders, aAligns, aWidths);

  Preencher_DataSource(pDataSource, TBS_Doacao.SQL_Selecionar_Registros);
  DimensionarGrid(pDBGrid);

  pDataSource.DataSet.Fields[0].SetFieldType(ftInteger);
  pDataSource.DataSet.Fields[0].FieldKind := fkData;
  pDataSource.DataSet.Fields[0].ReadOnly := False;
end;

procedure TModelDAODoacao.Montar_Janela_Manutencao(pDataSource: TDataSource);
begin
  FObj := TBS_Doacao.New;

  if FOperacao <> opNovo then
     begin
       FClasse
         .Formulario(FFormulario)
         .Objeto(FObj)
         .DataSource(pDataSource)
         .DataSource_To_Classe
         .Classe_To_Form;

       Buscar_Doador(FObj.PES_ID.ToString);
     end
  else
     begin
       FClasse
         .Formulario(FFormulario)
         .Objeto(FObj)
         .Classe_To_Form;
     end;

  if FObj.DOA_STATUS = 'A' then
     begin
       Componente_Valor(FFormulario, 'lblStatusDoacao', '* DOA??O ANULADA *');
       Modo_Componente(FFormulario, 'lblStatusDoacao');
     end
  else
     begin
       Componente_Valor(FFormulario, 'lblStatusDoacao', '', True);
       Modo_Componente(FFormulario, 'lblStatusDoacao', False, False);
     end;

  if FOperacao <> opConsultar then
     begin
       if FObj.DOA_STATUS = 'A' then
          raise Exception.Create('ALTERA??O n?o Permitida !!! A Doa??o est? ANULADA !!!')
       else
          Foco_Componente(FFormulario, 'edtPES_ID');
     end;
end;

procedure TModelDAODoacao.Executar_Operacoes(pDataSource: TDataSource);
begin
  FObj := TBS_Doacao.New;

  try
    case FOperacao of
      opNovo:
        begin
          if Validar_Campos(pDataSource) then
             begin
               ExecSQL(TBS_Doacao.SQL_Incrementa
                       +
                       FClasse
                         .Objeto(FObj)
                         .Operacao(FOperacao)
                         .DataSource(pDataSource)
                         .Form_To_Classe
                         .Classe_To_DataSource
                         .Classe_To_SQL
                       +
                       TBS_Doacao.SQL_Incrementa(False)
                      );
             end;
        end;
      opAlterar:
        begin
          if Validar_Campos(pDataSource) then
             begin
               FObj.DOA_ID := pDataSource.DataSet.Fields[0].AsInteger;

               ExecSQL(FClasse
                        .Objeto(FObj)
                        .Operacao(FOperacao)
                        .DataSource(pDataSource)
                        .Form_To_Classe
                        .Classe_To_DataSource
                        .Classe_To_SQL
                      );
             end;
        end;
      opExcluir:
        begin
          if pDataSource.DataSet.FieldByName('DOA_STATUS').AsString = 'A' then
             begin
               MsgSys('Opera??o n?o Permitida !!! A Doa??o J? est? ANULADA !!!', 3);
               Exit;
             end
          else
             begin
               if not (pDataSource.State in [dsInactive]) then
                  begin
                    if (pDataSource.DataSet.RecordCount > 0) then
                       if Pergunta('Confirma a Anula??o Desta Doa??o ?') then
                          begin
                            pDataSource.DataSet.Edit;
                            pDataSource.DataSet.FieldByName('DOA_STATUS').AsString := 'A';
                            pDataSource.DataSet.Post;

                            ExecSQL(FClasse
                                      .Objeto(FObj)
                                      .Operacao(opAlterar)
                                      .DataSource(pDataSource)
                                      .DataSource_To_Classe
                                      .Classe_To_SQL
                                   );
                          end;
                  end;
             end;
        end;
    end;
  except on E: Exception do
    begin
      MsgSys(E.Message, 3);
      raise Exception.Create('');
    end;
  end;

  Preencher_DataSource(pDataSource, TBS_Doacao.SQL_Selecionar_Registros);
end;

procedure TModelDAODoacao.Filtrar_Registros(pDataSource: TDataSource; pCampo, pTexto: String);
var
  FCampo: String;

begin
  FCampo := aFields[IndexOf(aHeaders, pCampo)];
  if FCampo = 'STATUS' then
     FCampo := 'DOA_STATUS';

  Preencher_DataSource(pDataSource, TBS_Doacao.SQL_Selecionar_Registros(FCampo, pTexto));
end;

procedure TModelDAODoacao.Listar_Registros;
var
  i, y, Executadas, Canceladas :Integer;
  QtdeDoados: Currency;

begin
  // Cria o Relat?rio
  Application.CreateForm(TfrmBaseListagem, frmBaseListagem);

  // Define o DataSource com os Dados do Relat?rio
  FDBSource := TDataSource.Create(nil);
  FDBSource.DataSet := FConexao.Query.OpenTable(TBS_DOACAO.SQL_Selecionar_Registros).DataSet;
  FormataDataSet(FDBSource.DataSet);

  // Define a Qtde de Doa??es Canceladas
  FDBSource.DataSet.Filtered := false;
  FDBSource.DataSet.Filter   := Format('DOA_STATUS = %s',[QuotedStr('')]);
  FDBSource.DataSet.Filtered := true;

  try
    Executadas := FDBSource.DataSet.RecordCount;
    FDBSource.DataSet.First;
    QtdeDoados := 0.00;
    While not(FDBSource.DataSet.EOF) do begin
      QtdeDoados := QtdeDoados + FDBSource.DataSet.FieldByName('DOA_QTDE').AsCurrency;
      FDBSource.DataSet.Next;
    end;
  finally
    FDBSource.DataSet.Filtered := false;
    FDBSource.DataSet.First;
  end;

  // Define a Qtde de Doa??es Executadas
  Canceladas := FDBSource.DataSet.RecordCount - Executadas;

  // Define o T?tulo do Relat?rio
  frmBaseListagem.RLReportBase.Title := FTituloReport;

  // Configura o DataSource do Relat?rio
  frmBaseListagem.RLReportBase.DataSource := FDBSource;

  // Define o Cabe?alho do Relat?rio
  y := 0;
  for i := 0 to frmBaseListagem.ComponentCount - 1 do
    begin
      if (frmBaseListagem.Components[i] is TRLLabel) then
         begin
           TRLLabel(frmBaseListagem.Components[i]).Caption := aLabelsReport[y];
           TRLLabel(frmBaseListagem.Components[i]).Left    := aPosicaoReport[y];
           TRLLabel(frmBaseListagem.Components[i]).Visible := True;
           TRLLabel(frmBaseListagem.Components[i]).Width   := aWidthReport[y];
           Inc(y);
         end;

      if y > Length(aLabelsReport) - 1 then
         break;
    end;

  // Define os Dados do Relat?rio
  y := 0;
  for i := 0 to frmBaseListagem.ComponentCount - 1 do
    begin
      if (frmBaseListagem.Components[i] is TRLDBText) then
         begin
           TRLDBText(frmBaseListagem.Components[i]).Alignment  := TRLTextAlignment(StrToAlignment(aAlignReport[y]));
           TRLDBText(frmBaseListagem.Components[i]).DataField  := aCamposReport[y];
           TRLDBText(frmBaseListagem.Components[i]).DataSource := FDBSource;
           TRLDBText(frmBaseListagem.Components[i]).Left       := aPosicaoReport[y];
           TRLDBText(frmBaseListagem.Components[i]).Visible    := True;
           TRLDBText(frmBaseListagem.Components[i]).Width      := aWidthReport[y];
           Inc(y);
         end;

      if y > Length(aLabelsReport) - 1 then
         break;
    end;

  // Definindo os Totais do Relat?rio
  frmBaseListagem.RLBandTotais.Visible := True;
  for i := 0 to frmBaseListagem.ComponentCount - 1 do
    begin
      if (frmBaseListagem.Components[i] is TRLLabel) then
         begin
           if TRLLabel(frmBaseListagem.Components[i]).Name = 'rlLabelTotal1' then
              begin
                TRLLabel(frmBaseListagem.Components[i]).Caption := 'Total de Doa??es Cadastradas : ';
                TRLLabel(frmBaseListagem.Components[i]).Visible := True;
              end;

           if TRLLabel(frmBaseListagem.Components[i]).Name = 'rlLabelTotal2' then
              begin
                TRLLabel(frmBaseListagem.Components[i]).Caption := 'Total de Doa??es Anuladas : ';
                TRLLabel(frmBaseListagem.Components[i]).Visible := True;
              end;

           if TRLLabel(frmBaseListagem.Components[i]).Name = 'rlLabelTotal3' then
              begin
                TRLLabel(frmBaseListagem.Components[i]).Caption := 'Total de Doa??es Executadas : ';
                TRLLabel(frmBaseListagem.Components[i]).Visible := True;
              end;

           if TRLLabel(frmBaseListagem.Components[i]).Name = 'rlLabelTotal4' then
              begin
                TRLLabel(frmBaseListagem.Components[i]).Caption := 'Qtd Total de Sangue Doados : ';
                TRLLabel(frmBaseListagem.Components[i]).Visible := True;
              end;
         end;

      if (frmBaseListagem.Components[i] is TRLDBResult) then
         begin
           if TRLDBResult(frmBaseListagem.Components[i]).Name = 'RLDBResult1' then
              begin
                TRLDBResult(frmBaseListagem.Components[i]).Alignment   := TRLTextAlignment.taRightJustify;
                TRLDBResult(frmBaseListagem.Components[i]).DataSource  := FDBSource;
                TRLDBResult(frmBaseListagem.Components[i]).Visible     := True;
              end;

           if TRLDBResult(frmBaseListagem.Components[i]).Name = 'RLDBResult2' then
              begin
                TRLDBResult(frmBaseListagem.Components[i]).Alignment   := TRLTextAlignment.taRightJustify;
                TRLDBResult(frmBaseListagem.Components[i]).DataSource  := FDBSource;
                TRLDBResult(frmBaseListagem.Components[i]).Info        := riSimple;
                TRLDBResult(frmBaseListagem.Components[i]).Text        := IntToStr(Canceladas);
                TRLDBResult(frmBaseListagem.Components[i]).Visible     := True;
              end;

           if TRLDBResult(frmBaseListagem.Components[i]).Name = 'RLDBResult3' then
              begin
                TRLDBResult(frmBaseListagem.Components[i]).Alignment   := TRLTextAlignment.taRightJustify;
                TRLDBResult(frmBaseListagem.Components[i]).DataSource  := FDBSource;
                TRLDBResult(frmBaseListagem.Components[i]).Info        := riSimple;
                TRLDBResult(frmBaseListagem.Components[i]).Text        := IntToStr(Executadas);
                TRLDBResult(frmBaseListagem.Components[i]).Visible     := True;
              end;

           if TRLDBResult(frmBaseListagem.Components[i]).Name = 'RLDBResult4' then
              begin
                TRLDBResult(frmBaseListagem.Components[i]).Alignment   := TRLTextAlignment.taRightJustify;
                TRLDBResult(frmBaseListagem.Components[i]).DataSource  := FDBSource;
                TRLDBResult(frmBaseListagem.Components[i]).Info        := riSimple;
                TRLDBResult(frmBaseListagem.Components[i]).Text        := FormatCurr('#,##0.00', QtdeDoados) + 'L';
                TRLDBResult(frmBaseListagem.Components[i]).Visible     := True;
              end;
         end;
    end;

  // Pr?-Visualiza??o da Listagem
  frmBaseListagem.RLReportBase.Preview();
end;

end.
