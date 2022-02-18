unit Model.Relatorios.Doacoes;

interface

uses
  System.SysUtils,
  System.DateUtils,
  System.Variants,
  Vcl.Forms,
  Vcl.DBGrids,
  Data.DB,
  Datasnap.Provider,
  Datasnap.DBClient,
  RLReport,
  Model.Conexao.Interfaces,
  Controller.Conexao.Interfaces,
  Controller.Conexao.Factory,
  Controller.Relatorios.Interfaces,
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
  TModelRelatorioDoacoes = class(TInterfacedObject, iModelRelatorios)
  private
    FConexao: iModelConexaoFactory;
    FDBSource: TDataSource;
  public
    constructor Create;
    destructor Destroy; override;
    class function New : iModelRelatorios;
    procedure Imprimir;
  end;

const
  // Configura��o do Relat�rio
  FTituloReport  : String = 'Relat�rio de Doa��es';
  aCamposReport  : array[0..1] of String  = ('TIPOSANG', 'QTDEDOADA');
  aLabelsReport  : array[0..1] of String  = ('Tipo Sangu�neo', 'Quantidade');
  aWidthReport   : array[0..1] of Integer = ( 100,  80);
  aPosicaoReport : array[0..1] of Integer = (  5,  155);
  aAlignReport   : array[0..1] of String  = ('Center', 'Right');

implementation

uses
  View.Listagem.Padrao, Winapi.ActiveX;

{ TModelRelatorioDoacoes }

constructor TModelRelatorioDoacoes.Create;
begin
  FConexao := TControllerConexao.New.Conexao;
end;

destructor TModelRelatorioDoacoes.Destroy;
begin
  inherited;
end;

class function TModelRelatorioDoacoes.New: iModelRelatorios;
begin
  Result := Self.Create;
end;

procedure TModelRelatorioDoacoes.Imprimir;
var
  i, y:Integer;
  FQtdeDoados: Currency;
  cdsTemp: TClientDataSet;
  FTipoSang: String;
  FQtde: Double;

begin
  // Cria o Relat�rio
  Application.CreateForm(TfrmBaseListagem, frmBaseListagem);

  // Define o DataSource com os Dados do Relat�rio
  FDBSource := TDataSource.Create(nil);
  FDBSource.DataSet := FConexao.Query.OpenTable(TBS_DOACAO.SQL_Selecionar_Registros).DataSet;
  FormataDataSet(FDBSource.DataSet);

  // Define a Qtde de Doa��es Executadas
  FDBSource.DataSet.Filtered := false;
  FDBSource.DataSet.Filter   := Format('DOA_STATUS = %s',[QuotedStr('')]);
  FDBSource.DataSet.Filtered := true;

  // Cria um DataSet Tempor�rio Para Executar o C�lculo do Relat�rio
  cdsTemp := TClientDataSet.Create(nil);
  cdsTemp.Close;
  cdsTemp.FieldDefs.Clear;
  cdsTemp.FieldDefs.add('TIPOSANG', ftString, 3);
  cdsTemp.FieldDefs.add('QTDEDOADA', ftFloat);
  cdsTemp.CreateDataSet;
  cdsTemp.Open;

  // Executando os C�lculos
  FQtdeDoados := 0;
  while not (FDBSource.DataSet.Eof) do
    begin
      FTipoSang := FDBSource.DataSet.FieldByName('PES_TIPOSANG').AsString;
      FQtde     := FDBSource.DataSet.FieldByName('DOA_QTDE').AsFloat;
      if cdsTemp.Locate('TIPOSANG', VarArrayOf([FTipoSang]), []) then
         begin
           cdsTemp.Edit;
           cdsTemp.FieldByName('QTDEDOADA').AsFloat := cdsTemp.FieldByName('QTDEDOADA').AsFloat + FQtde;
         end
      else
         begin
           cdsTemp.Append;
           cdsTemp.FieldByName('TIPOSANG').AsString := FTipoSang;
           cdsTemp.FieldByName('QTDEDOADA').AsFloat := FQtde;
         end;

      cdsTemp.Post;
      FQtdeDoados := FQtdeDoados + FQtde;
      FDBSource.DataSet.Next;
    end;

  cdsTemp.AddIndex('idxQTDEDOADA', 'QTDEDOADA', [], 'QTDEDOADA');
  cdsTemp.IndexName := 'idxQTDEDOADA';
  cdsTemp.First;

  // Define o T�tulo do Relat�rio
  frmBaseListagem.RLReportBase.Title := FTituloReport;

  // Configura o DataSource do Relat�rio
  FDBSource.DataSet := cdsTemp;
  frmBaseListagem.RLReportBase.DataSource := FDBSource;

  // Define o Cabe�alho do Relat�rio
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

  // Define os Dados do Relat�rio
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

  // Definindo os Totais do Relat�rio
  frmBaseListagem.RLBandTotais.Visible := True;
  for i := 0 to frmBaseListagem.ComponentCount - 1 do
    begin
      if (frmBaseListagem.Components[i] is TRLLabel) then
         begin
           if TRLLabel(frmBaseListagem.Components[i]).Name = 'rlLabelTotal1' then
              begin
                TRLLabel(frmBaseListagem.Components[i]).Caption := 'Total Sangue Arrecadado : ';
                TRLLabel(frmBaseListagem.Components[i]).Visible := True;
              end;
         end;

      if (frmBaseListagem.Components[i] is TRLDBResult) then
         begin
           if TRLDBResult(frmBaseListagem.Components[i]).Name = 'RLDBResult1' then
              begin
                TRLDBResult(frmBaseListagem.Components[i]).Alignment   := TRLTextAlignment.taLeftJustify;
                TRLDBResult(frmBaseListagem.Components[i]).DataSource  := FDBSource;
                TRLDBResult(frmBaseListagem.Components[i]).Info        := riSimple;
                TRLDBResult(frmBaseListagem.Components[i]).Text        := FormatFloat('#,##0', FQtdeDoados);
                TRLDBResult(frmBaseListagem.Components[i]).Visible     := True;
              end;
         end;
    end;

  // Pr�-Visualiza��o da Listagem
  frmBaseListagem.RLReportBase.Preview();
end;

end.
