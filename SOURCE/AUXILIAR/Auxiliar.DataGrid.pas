unit Auxiliar.DataGrid;

interface

uses
  System.Classes,
  Vcl.DBGrids,
  Data.DB,
  Auxiliar.Dialogos,
  Auxiliar.Informacoes,
  Auxiliar.Conversoes;

  procedure MontarGrid(pDbg: TDBGrid; const pFields, pHeaders, pPosicao: array of String; pTamanhos: array of Integer);
  procedure DimensionarGrid(pDbg: TDBGrid);
  procedure FormataDataSet(pDataSet : TDataSet);

implementation

uses
  System.TypInfo, System.Rtti;

///####################################################################################################################
/// Função   : MontarGrid()
/// Objetivo : Responsável Por Montar DBGrids
///####################################################################################################################
procedure MontarGrid(pDbg: TDBGrid; const pFields, pHeaders, pPosicao: array of String; pTamanhos: array of Integer);
var
  I : Integer;

begin
  pDbg.Columns.Clear;

  for I := 0 to Length(pHeaders) - 1 do
    begin
      { Adiciona Uma Nova Coluna }
      pDbg.Columns.Add;

      { Definição do Título do Cabeçalho do DBGrid }
      pDbg.Columns[I].Title.Alignment := taCenter;
      pDbg.Columns[I].Title.Caption   := pHeaders[I];

      { Definição do Campo das Colunas }
      pDbg.Columns[I].Alignment       := StrToAlignment(pPosicao[I]);
      pDbg.Columns[I].FieldName       := pFields[I];
      pDbg.Columns[I].Width           := pTamanhos[I];
    end;

  DimensionarGrid(pDbg);
end;

///####################################################################################################################
// Função   : DimensionarGrid()
// Objetivo : Responsável Pelo Redimensionamento do DBGrid ao Tamanho da Tela
///####################################################################################################################
procedure DimensionarGrid(pDbg: TDBGrid);
type
  TArray = Array of Integer;

procedure AjustarColumns(Swidth, TSize: Integer; Asize: TArray);
var
  idx: Integer;

begin
  if TSize = 0 then
      begin
        TSize := pDbg.Columns.count;
        for idx := 0 to pDbg.Columns.count - 1 do
          pDbg.Columns[idx].Width := (pDbg.Width - pDbg.Canvas.TextWidth('AAAAAA')) div TSize
      end
   else
      for idx := 0 to pDbg.Columns.count - 1 do
          pDbg.Columns[idx].Width := pDbg.Columns[idx].Width + (Swidth * Asize[idx] div TSize);
end;

var
  idx, Twidth, TSize, Swidth: Integer;
  AWidth: TArray;
  Asize: TArray;
  NomeColuna: String;

begin
  SetLength(AWidth, pDbg.Columns.count);
  SetLength(Asize, pDbg.Columns.count);
  Twidth := 0;
  TSize := 0;
  for idx := 0 to pDbg.Columns.count - 1 do
    begin
      NomeColuna := pDbg.Columns[idx].Title.Caption;
      pDbg.Columns[idx].Width := pDbg.Canvas.TextWidth(pDbg.Columns[idx].Title.Caption + 'A');
      AWidth[idx] := pDbg.Columns[idx].Width;
      Twidth := Twidth + AWidth[idx];

      if Assigned(pDbg.Columns[idx].Field) then
        Asize[idx] := pDbg.Columns[idx].Field.Size + 30
      else
        Asize[idx] := 1;

      TSize := TSize + Asize[idx];
    end;

  if TDBGridOption.dgColLines in pDbg.Options then
    Twidth := Twidth + pDbg.Columns.count;

  // adiciona a largura da coluna indicada do cursor
  if TDBGridOption.dgIndicator in pDbg.Options then
    Twidth := Twidth + IndicatorWidth;

  Swidth := pDbg.ClientWidth - Twidth;
  AjustarColumns(Swidth - 13, TSize, Asize);
end;

///####################################################################################################################
// Função   : FormataDataSet()
// Objetivo : Responsável Pela Formatação de DataSets
///####################################################################################################################
procedure FormataDataSet(pDataSet : TDataSet);
var
  i: Integer;

begin
  for I := 1 to pDataSet.Fields.Count - 1 do
    begin
      if pDataSet.Fields[i] is TIntegerField then
        begin
          TIntegerField(pDataSet.Fields[i]).DisplayFormat := '#,##0';
          TIntegerField(pDataSet.Fields[i]).EditFormat := '#,##0';
        end
      else if (pDataSet.Fields[i] is TCurrencyField) or (pDataSet.Fields[i] is TFloatField) or
              (pDataSet.Fields[i] is TFMTBCDField) then
        begin
          TCurrencyField(pDataSet.Fields[i]).DisplayFormat := '#,##0.00';
          TCurrencyField(pDataSet.Fields[i]).EditFormat := '#,##0.00';
        end
    end;
end;

end.
