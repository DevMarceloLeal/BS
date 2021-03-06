unit Auxiliar.Classes;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Rtti,
  System.UITypes,
  System.TypInfo,
  System.Variants,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.Samples.Spin,
  Vcl.ExtCtrls,
  Vcl.Graphics,
  Data.DB,
  Datasnap.DBClient,
  Model.Conexao.Interfaces,
  Model.FireDAC.DataFunctions,
  Auxiliar.Datas,
  Auxiliar.Forms,
  Auxiliar.Dialogos,
  Auxiliar.Conversoes,
  Auxiliar.Comandos.SQL,
  Auxiliar.Variaveis.Globais,
  Classe.Atributos;

type
  TClasses = class
  private
    FObjeto: TObject;
    FDataSource: TDataSource;
    FFormulario: TForm;
    FOperacao: TOperacao;
    function DataType(pType: TRttiType): TFieldType;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: TClasses;
    function Objeto(pObjeto: TObject): TClasses;
    function DataSource(pDSDados: TDataSource): TClasses;
    function Formulario(pJanela: TForm): TClasses;
    function Operacao(pOperacao: TOperacao): TClasses;
    function Classe_To_SQL: String;
    function Classe_To_Form: TClasses;
    function Form_To_Classe: TClasses;
    function DataSource_To_Classe: TClasses;
    function Classe_To_DataSource: TClasses;
  end;

implementation

uses
  FireDAC.Comp.DataSet;

constructor TClasses.Create;
begin

end;

destructor TClasses.Destroy;
begin
  inherited;
end;

class function TClasses.New: TClasses;
begin
  Result := Self.Create;
end;

function TClasses.Formulario(pJanela: TForm): TClasses;
begin
  Result := Self;
  FFormulario := pJanela;
end;

function TClasses.DataSource(pDSDados: TDataSource): TClasses;
begin
  Result := Self;
  FDataSource := pDSDados;
end;

function TClasses.Objeto(pObjeto: TObject): TClasses;
begin
  Result := Self;
  FObjeto := pObjeto;
end;

function TClasses.Operacao(pOperacao: TOperacao): TClasses;
begin
  Result := Self;
  FOperacao := pOperacao;
end;

//####################################################################################################################
// Fun??o   : Classe_To_SQL()
// Objetivo : Respons?vel Pela Transforma??o da Classe em Linguagem SQL
//####################################################################################################################
function TClasses.Classe_To_SQL: String;
var
  Contexto: TRttiContext;
  Tipo: TRttiType;
  Propriedade: TRttiProperty;
  Valor: Variant;
  Tabela, Campos, Valores, cWhere, pSQL: String;
  NumCampo, QtdCampos: Integer;

begin
  // Cria o contexto do RTTI
  Contexto := TRttiContext.Create;

  // Obt?m as informa??es de RTTI da classe
  Tipo := Contexto.GetType(FObjeto.ClassInfo);

  try
    Tabela    := FObjeto.ClassName.Replace('T','');
    Campos    := EmptyStr;
    Valores   := EmptyStr;
    cWhere    := EmptyStr;
    NumCampo  := 1;
    QtdCampos := 0;

    for Propriedade in Tipo.GetProperties do
      begin
        Inc(QtdCampos);
      end;

    // Executa um loop nas propriedades do objeto
    for Propriedade in Tipo.GetProperties do
      begin
        // Obt?m o nome e o valor da propriedade
        Valor := Propriedade.GetValue(FObjeto).AsVariant;

///        ShowMessage(Propriedade.Name + ' := '+ VarToStr(Valor));

        case TOperacao(FOperacao) of
           opNovo:
             begin
               if NumCampo < QtdCampos then
                  begin
                    Campos := Format('%s %s, ',[Campos, Propriedade.Name]);
                    if (UpperCase(Propriedade.PropertyType.ToString) = 'CURRENCY') or
                       (UpperCase(Propriedade.PropertyType.ToString) = 'DOUBLE') then
                       if VarToStr(Valor) = '0' then
                          Valores := Format('%s %s, ',[Valores, QuotedStr('0.00')])
                       else
                          Valores := Format('%s %s, ',[Valores, QuotedStr(ToStr(StrCurrency(Valor)).Replace('.','').Replace(',','.'))])
                    else if (UpperCase(Propriedade.PropertyType.ToString) = 'TDATETIME') then
                       Valores := Format('%s %s, ',[Valores, QuotedStr(DataSQL(VarToStr(Valor)))])
                    else
                       Valores := Format('%s %s, ',[Valores, QuotedStr(VarToStr(Valor))]);
                  end
               else
                  begin
                    Campos := Format('%s %s ',[Campos, Propriedade.Name]);
                    if (UpperCase(Propriedade.PropertyType.ToString) = 'CURRENCY') or
                       (UpperCase(Propriedade.PropertyType.ToString) = 'DOUBLE') then
                       if VarToStr(Valor) = '0' then
                          Valores := Format('%s %s',[Valores, QuotedStr('0.00')])
                       else
                          Valores := Format('%s %s',[Valores, QuotedStr(ToStr(StrCurrency(Valor)).Replace('.','').Replace(',','.'))])
                    else if (UpperCase(Propriedade.PropertyType.ToString) = 'TDATETIME') then
                       Valores := Format('%s %s, ',[Valores, QuotedStr(DataSQL(VarToStr(Valor)))])
                    else
                       Valores := Format('%s %s',[Valores, QuotedStr(VarToStr(Valor))]);
                  end;
             end;

           opAlterar:
             begin
               if NumCampo < QtdCampos then
                  if NumCampo = 1 then
                     begin
                       cWhere := Format('%s = %s',[Propriedade.Name, QuotedStr(VarToStr(Valor))]);
                     end
                  else
                     begin
                       if (UpperCase(Propriedade.PropertyType.ToString) = 'CURRENCY') or
                          (UpperCase(Propriedade.PropertyType.ToString) = 'DOUBLE') then
                          if VarToStr(Valor) = '0' then
                             Campos := Format('%s %s = %s, ',[Campos, Propriedade.Name, QuotedStr('0.00')])
                          else
                             Campos := Format('%s %s = %s, ',[Campos, Propriedade.Name, QuotedStr(ToStr(StrCurrency(Valor)).Replace('.','').Replace(',','.'))])
                       else if (UpperCase(Propriedade.PropertyType.ToString) = 'TDATETIME') then
                          Campos := Format('%s %s = %s, ',[Campos, Propriedade.Name, QuotedStr(DataSQL(VarToStr(Valor)))])
                       else
                          Campos := Format('%s %s = %s, ',[Campos, Propriedade.Name, QuotedStr(VarToStr(Valor))]);
                     end
               else
                  begin
                    if (UpperCase(Propriedade.PropertyType.ToString) = 'CURRENCY') or
                       (UpperCase(Propriedade.PropertyType.ToString) = 'DOUBLE') then
                          if VarToStr(Valor) = '0' then
                             Campos := Format('%s %s = %s ',[Campos, Propriedade.Name, QuotedStr('0.00')])
                          else
                             Campos := Format('%s %s = %s ',[Campos, Propriedade.Name, QuotedStr(ToStr(StrCurrency(Valor)).Replace('.','').Replace(',','.'))])
                    else if (UpperCase(Propriedade.PropertyType.ToString) = 'TDATETIME') then
                       Campos := Format('%s %s = %s ',[Campos, Propriedade.Name, QuotedStr(DataSQL(VarToStr(Valor)))])
                    else
                       Campos := Format('%s %s = %s ',[Campos, Propriedade.Name, QuotedStr(VarToStr(Valor))]);
                  end;
             end;

           opExcluir:
             begin
               if NumCampo < QtdCampos then
                  if NumCampo = 1 then
                     begin
                       cWhere := Format('%s = %s',[Propriedade.Name, QuotedStr(VarToStr(Valor))]);
                     end;
             end;
        end;
        Inc(NumCampo);
      end;

    // Come?a a formar o par?metro SQL de acordo com a opera??o
    case TOperacao(FOperacao) of
       opNovo:
         pSQL := Format('INSERT INTO %s (%s) VALUES (%s)',[Tabela, Campos, Valores]);

       opAlterar:
         pSQL := Format('UPDATE %s SET %s WHERE %s',[Tabela, Campos, cWhere]);

       opExcluir:
         pSQL := Format('DELETE FROM %s WHERE %s',[Tabela, cWhere]);
    end;

  finally
    Contexto.Free;
    Result := pSQL;
  end;
end;

//####################################################################################################################
// Fun??o   : Classe_To_Form()
// Objetivo : Respons?vel Pela Coloca??o de Uma Classe Nos Edit?s do Form
//####################################################################################################################
function TClasses.Classe_To_Form: TClasses;
var
  Contexto: TRttiContext;
  Tipo: TRttiType;
  Propriedade: TRttiProperty;
  Valor: variant;
  Componente: TComponent;

begin
  Result := Self;

  // Cria o contexto do RTTI
  Contexto := TRttiContext.Create;

  // Obt?m as informa??es de RTTI da classe
  Tipo := Contexto.GetType(FObjeto.ClassInfo);

  // Limpa todos os campos edit?veis do form
  Limpar_Edits(FFormulario);

  try
    // Executa um loop nas propriedades do objeto
    for Propriedade in Tipo.GetProperties do
      begin
        // Obt?m o valor da propriedade
        Valor := Propriedade.GetValue(FObjeto).AsVariant;

        // Encontra o componente relacionado, como, por exemplo, "edtNome"
        Componente := FFormulario.FindComponent(Format('edt%s',[Propriedade.Name]));

        {
        MsgSys('TEdit : '+ Format('edt%s',[Propriedade.Name]) + #13 +
               'Valor : '+ String(Valor));}

        // Testa se o componente ? da classe "TLabel" para acessar a propriedade "Text"
        if Componente is TLabel then
           if (UpperCase(Propriedade.PropertyType.ToString) = 'CURRENCY') or
              (UpperCase(Propriedade.PropertyType.ToString) = 'DOUBLE') then
              (Componente as TLabel).Caption := FormatFloat('#,##0.00', Valor)
           else
              (Componente as TLabel).Caption := Valor;

        // Testa se o componente ? da classe "TEdit" para acessar a propriedade "Text"
        if Componente is TEdit then
           if (UpperCase(Propriedade.PropertyType.ToString) = 'CURRENCY') or
              (UpperCase(Propriedade.PropertyType.ToString) = 'DOUBLE') then
              (Componente as TEdit).Text := FormatFloat('#,##0.00', Valor)
           else
              if Valor <> '0' then
                 (Componente as TEdit).Text := Valor;

        // Testa se o componente ? da classe "TMemo" para acessar a propriedade "Lines"
        if (Componente is TMemo) then
           (Componente as TMemo).Lines.Add(Valor);

        // Testa se o componente ? da classe "TComboBox" para acessar a propriedade "ItemIndex"
        if Componente is TComboBox then
           if (UpperCase(Propriedade.PropertyType.ToString) = 'INTEGER') then
              (Componente as TComboBox).ItemIndex := Valor - 1
           else
              (Componente as TComboBox).ItemIndex := (Componente as TComboBox).Items.IndexOf(Valor);

        // Testa se o componente ? da classe "TRadioGroup" para acessar a propriedade "ItemIndex"
        if Componente is TRadioGroup then
          (Componente as TRadioGroup).ItemIndex := (Componente as TRadioGroup).Items.IndexOf(Valor);

        // Testa se o componente ? da classe "TCheckBox" para acessar a propriedade "Checked"
        if Componente is TCheckBox then
          (Componente as TCheckBox).Checked := Valor;

        // Testa se o componente ? da classe "TTrackBar" para acessar a propriedade "Position"
        if Componente is TTrackBar then
          (Componente as TTrackBar).Position := Valor;

        // Testa se o componente ? da classe "TDateTimePicker" para acessar a propriedade "Date"
        if Componente is TDateTimePicker then
          (Componente as TDateTimePicker).Date := VarToDateTime(Valor);

        // Testa se o componente ? da classe "TShape" para acessar a propriedade "Brush.Color"
        if Componente is TShape then
          (Componente as TShape).Brush.Color := Valor;
      end;
  finally
      begin
        Contexto.Free;
      end;
  end;
end;

//####################################################################################################################
// Fun??o   : Form_To_Classe()
// Objetivo : Respons?vel Pela Coloca??o dos Dados do Form em Uma Classe
//####################################################################################################################
function TClasses.Form_To_Classe: TClasses;
var
  Contexto: TRttiContext;
  Tipo: TRttiType;
  Propriedade: TRttiProperty;
  Valor: variant;
  Componente: TComponent;
  lAtribuir: Boolean;

begin
  Result := Self;

  // Cria o contexto do RTTI
  Contexto := TRttiContext.Create;

  // Obt?m as informa??es de RTTI da classe
  Tipo := Contexto.GetType(FObjeto.ClassInfo);

  try
    // Executa um loop nas propriedades do objeto
    for Propriedade in Tipo.GetProperties do
      begin
        lAtribuir := False;

        // Encontra o componente relacionado, como, por exemplo, "edtNome"
        Componente := FFormulario.FindComponent(Format('edt%s',[Propriedade.Name]));

        // Testa se o componente ? da classe "TEdit" para acessar a propriedade "Text"
        if Componente is TEdit then
           begin
             lAtribuir := True;
             Valor := (Componente as TEdit).Text;
           end;

        // Testa se o componente ? da classe "TLabel" para acessar a propriedade "Text"
        if Componente is TLabel then
           begin
             lAtribuir := True;
             Valor := (Componente as TLabel).Caption;
           end;

        // Testa se o componente ? da classe "TEdit" para acessar a propriedade "Text"
        if Componente is TDateTimePicker then
           begin
             lAtribuir := True;
             Valor := (Componente as TDateTimePicker).Date;
           end;

        // Testa se o componente ? da classe "TComboBox" para acessar a propriedade "Text"
        if Componente is TComboBox then
           begin
             lAtribuir := True;
             if (UpperCase(Propriedade.PropertyType.ToString) = 'INTEGER') then
                 Valor := (Componente as TComboBox).ItemIndex + 1
              else
                 Valor := (Componente as TComboBox).Text;
           end;

        // Testa se o componente ? da classe "TMemo" para acessar a propriedade "Lines"
        if (Componente is TMemo) then
           begin
             lAtribuir := True;
             Valor := WideCharToString((Componente as TMemo).Lines.GetText);
           end;

        // Testa se o componente ? da classe "TRadioGroup" para acessar a propriedade "Items[ItemIndex]"
        if Componente is TRadioGroup then
           begin
             lAtribuir := True;
             Valor := (Componente as TRadioGroup).Items[(Componente as TRadioGroup).ItemIndex];
           end;

        // Testa se o componente ? da classe "TCheckBox" para acessar a propriedade "Checked"
        if Componente is TCheckBox then
           begin
             lAtribuir := True;
             Valor := (Componente as TCheckBox).Checked;
           end;

        // Testa se o componente ? da classe "TTrackBar" para acessar a propriedade "Position"
        if Componente is TTrackBar then
           begin
             lAtribuir := True;
             Valor := (Componente as TTrackBar).Position;
           end;

        // Testa se o componente ? da classe "TDateTimePicker" para acessar a propriedade "Date"
        if Componente is TDateTimePicker then
           begin
             lAtribuir := True;
             Valor := (Componente as TDateTimePicker).Date;
           end;

        // Testa se o componente ? da classe "TShape" para acessar a propriedade "Brush.Color"
        if Componente is TShape then
           begin
             lAtribuir := True;
             Valor := (Componente as TShape).Brush.Color;
           end;

      if lAtribuir then
           if (UpperCase(Propriedade.PropertyType.ToString) = 'INTEGER') then
              Propriedade.SetValue(FObjeto, TValue.FromVariant(StrToInt(Valor)))
           else if (UpperCase(Propriedade.PropertyType.ToString) = 'CURRENCY') or
                   (UpperCase(Propriedade.PropertyType.ToString) = 'DOUBLE') then
              if (VarToStr(Valor) = '0') or
                 (VarToStr(Valor) = '0,00') then
                 Propriedade.SetValue(FObjeto, TValue.FromVariant(StrToFloat('0,00')))
              else
                 Propriedade.SetValue(FObjeto, TValue.FromVariant(StrToFloat(FormatFloat('#.##', StrToFloat(ToStr(Valor).Replace('.',''))))))
           else if (UpperCase(Propriedade.PropertyType.ToString) = 'TDATETIME') then
              Propriedade.SetValue(FObjeto, TValue.FromVariant(StrToDate(DateToStr(Valor))))
           else
              begin
                if Componente is TDateTimePicker then
                   Propriedade.SetValue(FObjeto, TValue.FromVariant(DateToStr((Componente as TDateTimePicker).Date)))
                else
                   Propriedade.SetValue(FObjeto, TValue.FromVariant(Valor));
              end;
      end;
  finally
      begin
        Contexto.Free;
      end;
  end;
end;

//####################################################################################################################
// Fun??o   : DataSource_To_Classe()
// Objetivo : Respons?vel Pela Coloca??o de Uma Classe Nos Edit?s do Form
//####################################################################################################################
function TClasses.DataSource_To_Classe: TClasses;
var
  Contexto: TRttiContext;
  Tipo: TRttiType;
  Propriedade: TRttiProperty;
  Valor: variant;

begin
  Result := Self;

  // Cria o contexto do RTTI
  Contexto := TRttiContext.Create;

  // Obt?m as informa??es de RTTI da classe
  Tipo := Contexto.GetType(FObjeto.ClassInfo);

  try
    // Executa um loop nas propriedades do objeto
    for Propriedade in Tipo.GetProperties do
      begin
        // Obt?m o valor do registro
        if (UpperCase(Propriedade.PropertyType.ToString) = 'CURRENCY') then
           Valor := FDataSource.DataSet.FieldByName(Propriedade.Name).AsCurrency
        else
           Valor := FDataSource.DataSet.FieldByName(Propriedade.Name).AsVariant;

        // Atribui o valor do registro ? propriedade da classe
        if (UpperCase(Propriedade.PropertyType.ToString) = 'TDATETIME') then
           Propriedade.SetValue(FObjeto, TValue.FromVariant(StrToDate(VarToStr(Valor))))
        else if (UpperCase(Propriedade.PropertyType.ToString) = 'CURRENCY') then
           Propriedade.SetValue(FObjeto, TValue.FromVariant(Valor))
        else
           Propriedade.SetValue(FObjeto, TValue.FromVariant(Valor));
      end;
  Except on E: Exception do
      begin
        MsgSys(E.Message,3);
        Contexto.Free;
      end;
  end;
end;

//####################################################################################################################
// Fun??o   : Classe_To_DataSource()
// Objetivo : Respons?vel Pela Coloca??o de Uma Classe No DataSource;
//####################################################################################################################
function TClasses.Classe_To_DataSource: TClasses;
var
  Contexto: TRttiContext;
  Tipo: TRttiType;
  Propriedade: TRttiProperty;
  Valor: variant;
  vMsg, vMsgErro: String;
  cdsTemp : TClientDataSet;
  i: Integer;

begin
  Result := Self;

  // Cria o contexto do RTTI
  Contexto := TRttiContext.Create;

  // Obt?m as informa??es de RTTI da classe
  Tipo := Contexto.GetType(FObjeto.ClassInfo);

  // Cria um DataSet Tempor?rio Para Executar as Opera??es de CRUD
  cdsTemp := TClientDataSet.Create(nil);
  cdsTemp.Close;
  cdsTemp.FieldDefs.Clear;

  for Propriedade in Tipo.GetProperties do
    begin
      if Propriedade.PropertyType.ToString = 'string' then
         cdsTemp.FieldDefs.add(Propriedade.Name, DataType(Propriedade.PropertyType), Propriedade.RttiDataSize)
      else
         cdsTemp.FieldDefs.add(Propriedade.Name, DataType(Propriedade.PropertyType));
    end;

  cdsTemp.CreateDataSet;
  cdsTemp.Open;

  // Permitindo Altera??o nos Campos do DataSet
  for i := 0 to FDataSource.DataSet.FieldCount - 1 do
    begin
      FDataSource.DataSet.Fields[i].ReadOnly := False;
    end;

  // Efetuando as Opera??es de CRUD
  case TOperacao(FOperacao) of
    opNovo, opAlterar :
      begin
        case TOperacao(FOperacao) of
          opNovo:
             begin
               cdsTemp.Append;
               FDataSource.DataSet.Append;
               vMsg     := 'Registro inclu?do c/sucesso !!!';
               vMsgErro := 'Erro ao incluir registro !!!';
             end;
          opAlterar :
             begin
               cdsTemp.Edit;
               FDataSource.DataSet.Edit;
               vMsg     := 'Registro alterado c/sucesso !!!';
               vMsgErro := 'Erro ao alterar registro !!!';
             end;
        end;

        try
          // Executa um loop nas propriedades do objeto
          for Propriedade in Tipo.GetProperties do
            begin
              // Obt?m o valor da propriedade
              Valor := Propriedade.GetValue(FObjeto).AsVariant;

              // Atribui o valor do registro ao campo DataSource
              cdsTemp.FieldByName(Propriedade.Name).AsVariant := Valor;
            end;

          cdsTemp.Post;
          FDataSource.DataSet.CopyFields(cdsTemp);
          Msg(vMsg);
        except on E: Exception do
          MsgSys(vMsgErro + #13#13 + E.Message, 3);
        end;
      end;

    opExcluir :
      begin
        try
          FDataSource.DataSet.Delete;
          Msg('Registro exclu?do c/sucesso !!!');
          Exit;
        except on E: Exception do
          MsgSys('Erro ao excluir registro !!!' + #13#13 + E.Message, 3);
        end;
      end;
  end;

  Contexto.Free;
  FDataSource.DataSet.Cancel;
end;

function TClasses.DataType(pType: TRttiType): TFieldType;
begin
  if pType.ToString = 'Integer' then
     Result := ftInteger
  else if pType.ToString = 'String' then
     Result := ftString
  else if pType.ToString = 'Currency' then
     Result := ftCurrency
  else if pType.ToString = 'TDateTime' then
     Result := ftDateTime
  else if pType.ToString = 'string' then
     Result := ftString
  else
     Result := ftUnknown;
end;

end.
