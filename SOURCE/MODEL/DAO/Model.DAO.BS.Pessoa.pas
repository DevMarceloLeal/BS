unit Model.DAO.BS.Pessoa;

interface

uses
  System.SysUtils,
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
  Classe.BS.Pessoa;

type
  TRegistro = record
    Nome: String;
    DataNasc: String;
    TipoSang: String;
    Email: String;
    Celular: String;
    CPF: String;
  end;

  TModelDAOPessoa = class(TInterfacedObject, iModelDAO)
  private
    FConexao: iModelConexaoFactory;
    FClasse: TClasses;
    FFormulario: TForm;
    FOperacao: TOperacao;
    FDBSource: TDataSource;
    FDBFuncoes: iModelFuncoes;
    procedure ExecSQL(pSql: String);
    procedure Criar_Registros;
    procedure Preencher_DataSource(pDataSource: TDataSource; pSQL: String);
    function Validar_Campos(pDataSource: TDataSource): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelDAO;
    function Criar_Tabela: iModelDAO;
    function Formulario(pForm: TForm): iModelDAO;
    function Operacao(pOperacao: TOperacao): iModelDAO;
    procedure Buscar_Doador(pCodigo: String);
    function Carregar_Registros(pDBGrid: TDBGrid; pDataSource: TDataSource): iModelDAO;
    procedure Montar_Janela_Manutencao(pDataSource: TDataSource);
    procedure Executar_Operacoes(pDataSource: TDataSource);
    procedure Filtrar_Registros(pDataSource: TDataSource; pCampo, pTexto: String);
    procedure Listar_Registros;
  end;

const
  FRegistros: array[0..11] of TRegistro =
  (
      (Nome:'MARCELO LEAL'; DataNasc: '11/03/1971'; TipoSang:'A+'; Email: 'lealsistemas@hotmail.com'; Celular: '96548-7754'; CPF:'000.654.617-89'),
      (Nome:'MONIQUE';      DataNasc: '17/06/1979'; TipoSang:'B+'; Email: 'monique@hotmail.com';      Celular: '97554-9874'; CPF:'010.446.485-89'),
      (Nome:'ANA BEATRIZ';  DataNasc: '28/11/2002'; TipoSang:'O+'; Email: 'anabeatriz@hotmail.com';   Celular: '94538-9630'; CPF:'221.034.999-89'),
      (Nome:'EVANDER';      DataNasc: '07/01/1999'; TipoSang:'O-'; Email: 'evander@hotmail.com';      Celular: '98541-2254'; CPF:'123.014.377-89'),
      (Nome:'MARCELINHO';   DataNasc: '04/09/2003'; TipoSang:'B-'; Email: 'marcelinho@hotmail.com';   Celular: '92018-4657'; CPF:'456.201.977-89'),
      (Nome:'RAIA';         DataNasc: '05/06/1989'; TipoSang:'A-'; Email: 'raia@hotmail.com';         Celular: '90018-4785'; CPF:'789.202.777-89'),
      (Nome:'DIAMOND';      DataNasc: '06/10/1994'; TipoSang:'O+'; Email: 'diamond@hotmail.com';      Celular: '98818-8554'; CPF:'123.446.177-89'),
      (Nome:'DENGO';        DataNasc: '14/04/2000'; TipoSang:'B+'; Email: 'dengo@hotmail.com';        Celular: '96646-1810'; CPF:'456.403.577-89'),
      (Nome:'RUAN';         DataNasc: '23/05/2004'; TipoSang:'A+'; Email: 'ruan@hotmail.com';         Celular: '96949-6543'; CPF:'895.304.677-89'),
      (Nome:'RICHARD';      DataNasc: '15/07/1978'; TipoSang:'O-'; Email: 'richard@hotmail.com';      Celular: '99028-1818'; CPF:'880.886.607-89'),
      (Nome:'BRUNA';        DataNasc: '29/12/1999'; TipoSang:'B-'; Email: 'bruna@hotmail.com';        Celular: '99845-0302'; CPF:'145.963.807-89'),
      (Nome:'ANA JULIA';    DataNasc: '24/02/1979'; TipoSang:'A-'; Email: 'anajulia@hotmail.com';     Celular: '93654-0011'; CPF:'204.753.857-89')
  );

  // Configura??o do DBGrid
  aFields  : array[0..2] of String  = ('PES_ID', 'PES_NOME', 'PES_CELULAR');
  aHeaders : array[0..2] of String  = ('C?digo', 'Nome do Doador', 'Celular');
  aWidths  : array[0..2] of Integer = (40, 250, 80);
  aAligns  : array[0..2] of String  = ('Right', 'Left', 'Left');

  // Configura??o do Relat?rio
  FTituloReport  : String = 'Listagem do Cadastro de Doadores';
  aCamposReport  : array[0..3] of String  = ('PES_ID', 'PES_NOME', 'PES_TIPOSANG', 'PES_CELULAR');
  aLabelsReport  : array[0..3] of String  = ('C?digo', 'Nome do Doador', 'Tipo Sangu?neo', 'Celular');
  aWidthReport   : array[0..3] of Integer = ( 50, 200, 110, 130);
  aPosicaoReport : array[0..3] of Integer = (  5,  70, 290, 410);
  aAlignReport   : array[0..3] of String  = ('Right', 'Left', 'Center', 'Left');

implementation

uses
  View.Listagem.Padrao;

{ TModelDAOPessoa }

constructor TModelDAOPessoa.Create;
begin
  FConexao   := TControllerConexao.New.Conexao;
  FClasse    := TClasses.New;
  FDBFuncoes := TControllerConexao.New.Conexao.DBFuncoes;
end;

destructor TModelDAOPessoa.Destroy;
begin
  inherited;
end;

procedure TModelDAOPessoa.ExecSQL(pSql: String);
begin
  try
    FConexao.Query.ExecSQL(pSql);
  except on E: Exception do
    MsgSys('Erro ao Executar Comando SQL !!!' + #13#13 + E.Message);
  end;
end;

procedure TModelDAOPessoa.Criar_Registros;
var
  I: Integer;
  FObj: TBS_Pessoa;

begin
  for I := 0 to Length(FRegistros) - 1 do
    begin
      FObj := TBS_Pessoa.New;
      FObj.PES_NOME     := FRegistros[I].Nome;
      FObj.PES_DATANASC := StrToDateTime(FRegistros[I].DataNasc);
      FObj.PES_TIPOSANG := FRegistros[I].TipoSang;
      FObj.PES_EMAIL    := FRegistros[I].Email;
      FObj.PES_CELULAR  := FRegistros[I].Celular;
      FObj.PES_CPF      := FRegistros[I].Cpf;

      ExecSQL(TBS_Pessoa.SQL_Incrementa + FClasse.Objeto(FObj).Classe_To_SQL);
    end;
end;

procedure TModelDAOPessoa.Preencher_DataSource(pDataSource: TDataSource; pSQL: String);
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

function TModelDAOPessoa.Validar_Campos(pDataSource: TDataSource): Boolean;
var
  FObj: TBS_Pessoa;
  FIdade: Integer;

begin
  FObj := TBS_Pessoa.New;
  FClasse.Formulario(FFormulario).Objeto(FObj).Form_To_Classe;
  FIdade := Calcular_Idade(FObj.PES_DATANASC);

  if pDataSource.DataSet.FieldByName('PES_NOME').AsString <> FObj.PES_NOME then
     begin
       if (not FObj.PES_NOME.IsEmpty) and (FObj.PES_NOME.Length < 5) then
          begin
            Foco_Componente(FFormulario, 'edtPES_NOME');
            raise Exception.Create('O Nome do Doador Requer Mais de 5 Caracteres !!!');
          end
       else
          begin
            if FDBFuncoes.Registro_Existe(TBS_Pessoa.SQL_Registro_Existe(['PES_NOME'], [FObj.PES_NOME])) then
               begin
                 Foco_Componente(FFormulario, 'edtPES_NOME');
                 raise Exception.Create('J? Existe um Doador Cadastrado com Este NOME !!!');
               end;
          end;
     end;

  if pDataSource.DataSet.FieldByName('PES_DATANASC').AsDateTime <> FObj.PES_DATANASC then
     begin
       if (FObj.PES_DATANASC <> 0) and ((FIdade < 18) or (FIdade > 60)) then
          begin
            Foco_Componente(FFormulario, 'edtPES_DATANASC');
            raise Exception.Create('Esta Pessoa N?o Tem Idade Para Doador !!!');
          end
       else
          begin
            if FDBFuncoes.Registro_Existe(TBS_Pessoa.SQL_Registro_Existe(['PES_NOME', 'PES_DATANASC'], [FObj.PES_NOME, DataSQL(DateToStr(FObj.PES_DATANASC))])) then
               begin
                 Foco_Componente(FFormulario, 'edtPES_NOME');
                 raise Exception.Create('J? Existe um Doador Cadastrado com Este NOME e NASCIMENTO !!!');
               end;
          end;
     end;

  if pDataSource.DataSet.FieldByName('PES_TIPOSANG').AsString <> FObj.PES_TIPOSANG then
     begin
       if (not FObj.PES_TIPOSANG.IsEmpty) then
          begin
            if IndexOf(['A+','A-','B+','B-','O+','O-'], FObj.PES_TIPOSANG) = -1 then
               begin
                 Foco_Componente(FFormulario, 'edtPES_TIPOSANG');
                 raise Exception.Create('Tipo Sangu?neo N?o Compat?vel !!!' + #13#13 +
                                        'Tipos Compat?veis:' + #13 +
                                        'A+, A-, B+, B-, O+, O-');
               end;
          end;
     end;

  if pDataSource.DataSet.FieldByName('PES_EMAIL').AsString <> FObj.PES_EMAIL then
     begin
       if (not FObj.PES_EMAIL.IsEmpty) and (not IsEmailValido(FObj.PES_EMAIL)) then
          begin
            Foco_Componente(FFormulario, 'edtPES_EMAIL');
            raise Exception.Create('E-Mail Inv?lido');
          end;
     end;

  if pDataSource.DataSet.FieldByName('PES_CELULAR').AsString <> FObj.PES_CELULAR then
     begin
       if (not FObj.PES_CELULAR.IsEmpty) then
          FObj.PES_CELULAR := FormataTEL(FObj.PES_CELULAR);
     end;

  if pDataSource.DataSet.FieldByName('PES_CPF').AsString <> FObj.PES_CPF then
     begin
       if (not FObj.PES_CPF.IsEmpty) then
          begin
            if not IsCPFValido(FObj.PES_CPF) then
               begin
                 Foco_Componente(FFormulario, 'edtPES_CPF');
                 raise Exception.Create('CPF Inv?lido !!!');
               end
            else
               begin
                 FObj.PES_CPF := FormataCPF(FObj.PES_CPF);
                 if FDBFuncoes.Registro_Existe(TBS_Pessoa.SQL_Registro_Existe(['PES_CPF'], [FObj.PES_CPF])) then
                    begin
                      Foco_Componente(FFormulario, 'edtPES_CPF');
                      raise Exception.Create('J? Existe um Doador Cadastrado com Este CPF !!!');
                    end;
               end;
          end;
     end;

  FClasse.Formulario(FFormulario).Objeto(FObj).Classe_To_Form;
  Result := True;
end;

class function TModelDAOPessoa.New: iModelDAO;
begin
  Result := Self.Create;
end;

function TModelDAOPessoa.Criar_Tabela: iModelDAO;
begin
  // Verifica a Exist?ncia da Tabela de Dados
  if (FConexao.DBFuncoes.Gerar_ID('BS_PESSOA') > 0) then
     exit;

  // Caso Ela N?o Exista Ela ? Criada
  try
    ExecSQL(TBS_Pessoa.SQL_Criar_Tabela);
    Criar_Registros;
  except on E: Exception do
    MsgSys('Erro ao Criar Tabela !!!' + #13#13 + E.Message);
  end;
  Result := Self;
end;

function TModelDAOPessoa.Formulario(pForm: TForm): iModelDAO;
begin
  Result := Self;
  FFormulario := pForm;
end;

function TModelDAOPessoa.Operacao(pOperacao: TOperacao): iModelDAO;
begin
  Result := Self;
  FOperacao := pOperacao;
end;

procedure TModelDAOPessoa.Buscar_Doador(pCodigo: String);
begin
end;

function TModelDAOPessoa.Carregar_Registros(pDBGrid: TDBGrid; pDataSource: TDataSource): iModelDAO;
begin
  Result := Self;
  MontarGrid(pDBGrid, aFields, aHeaders, aAligns, aWidths);

  Preencher_DataSource(pDataSource, TBS_Pessoa.SQL_Selecionar_Registros);
  DimensionarGrid(pDBGrid);

  pDataSource.DataSet.Fields[0].SetFieldType(ftInteger);
  pDataSource.DataSet.Fields[0].FieldKind := fkData;
  pDataSource.DataSet.Fields[0].ReadOnly := False;
end;

procedure TModelDAOPessoa.Montar_Janela_Manutencao(pDataSource: TDataSource);
var
  FObj: TBS_Pessoa;

begin
  FObj := TBS_Pessoa.New;

  if FOperacao <> opNovo then
     begin
       FClasse
         .Formulario(FFormulario)
         .Objeto(FObj)
         .DataSource(pDataSource)
         .DataSource_To_Classe
         .Classe_To_Form;
     end
  else
     begin
       FClasse
         .Formulario(FFormulario)
         .Objeto(FObj)
         .Classe_To_Form;
     end;
end;

procedure TModelDAOPessoa.Executar_Operacoes(pDataSource: TDataSource);
var
  FObj: TBS_Pessoa;

begin
  FObj := TBS_Pessoa.New;

  try
    case FOperacao of
      opNovo:
        begin
          if Validar_Campos(pDataSource) then
             begin
               ExecSQL(TBS_Pessoa.SQL_Incrementa
                       +
                       FClasse
                         .Objeto(FObj)
                         .Operacao(FOperacao)
                         .DataSource(pDataSource)
                         .Form_To_Classe
                         .Classe_To_DataSource
                         .Classe_To_SQL
                      );
             end;
        end;
      opAlterar:
        begin
          if Validar_Campos(pDataSource) then
             begin
               FObj.PES_ID := pDataSource.DataSet.Fields[0].AsInteger;

               ExecSQL(
                       FClasse
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
          if not (pDataSource.State in [dsInactive]) then
             begin
               if (pDataSource.DataSet.RecordCount > 0) then
                  if Pergunta('Confirma Exclus?o do Registro ?') then
                     begin
                       ExecSQL(FClasse
                                 .Objeto(FObj)
                                 .Operacao(FOperacao)
                                 .DataSource(pDataSource)
                                 .DataSource_To_Classe
                                 .Classe_To_DataSource
                                 .Classe_To_SQL
                              );
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

  Preencher_DataSource(pDataSource, TBS_Pessoa.SQL_Selecionar_Registros);
end;

procedure TModelDAOPessoa.Filtrar_Registros(pDataSource: TDataSource; pCampo: String; pTexto: String);
begin
  Preencher_DataSource(pDataSource, TBS_Pessoa.SQL_Selecionar_Registros(aFields[IndexOf(aHeaders, pCampo)], pTexto));
end;

procedure TModelDAOPessoa.Listar_Registros;
var
  i, y :Integer;

begin
  // Cria o Relat?rio
  Application.CreateForm(TfrmBaseListagem, frmBaseListagem);

  // Define o DataSource com os Dados do Relat?rio
  FDBSource := TDataSource.Create(nil);
  FDBSource.DataSet := FConexao.Query.OpenTable(TBS_Pessoa.SQL_Selecionar_Registros).DataSet;
  FormataDataSet(FDBSource.DataSet);

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
           if TRLLabel(frmBaseListagem.Components[i]).Name <> 'rlLabelTotal' then
              begin
                TRLLabel(frmBaseListagem.Components[i]).Caption := aLabelsReport[y];
                TRLLabel(frmBaseListagem.Components[i]).Left    := aPosicaoReport[y];
                TRLLabel(frmBaseListagem.Components[i]).Visible := True;
                TRLLabel(frmBaseListagem.Components[i]).Width   := aWidthReport[y];
                Inc(y);
              end;
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
                TRLLabel(frmBaseListagem.Components[i]).Caption := 'Total de Doadores Cadastrados : ';
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
         end;
    end;


  // Pr?-Visualiza??o da Listagem
  frmBaseListagem.RLReportBase.Preview();
end;

end.
