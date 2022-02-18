unit Auxiliar.Forms;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Controls,
  Vcl.Graphics,
  Vcl.Buttons,
  Vcl.DBGrids,
  Auxiliar.Helpers,
  Auxiliar.Dialogos,
  Auxiliar.Fundo.Esmaecido;

  procedure Abrir_Janela(pForm: String; pModal: Boolean = True);
  procedure Limpar_Edits(pFrm: TForm);
  function Form_Componente(pFrm: TForm; pTag: Integer): TComponent;
  procedure Modo_Componente(pFrm: TForm; pNomeComponente: String; pHabilita: Boolean = True; pVisivel: Boolean = True);
  procedure Foco_Componente(pFrm: TForm; pNomeComponente: String);
  function Componente_Vazio(pFrm: TForm; pNomeComponente: String): Boolean;
  function Componente_Valor(pFrm: TForm; pNomeComponente: String; pTexto: String = ''; pZerar: Boolean = False): String;
  procedure Componente_Fonte(pFrm: TForm; pNomeComponente: String; pFonte: String = ''; pCor: TColor = clWindowText);

implementation

uses
  Vcl.ComCtrls;

///####################################################################################################################
/// Função   : Abrir_Janela()
/// Objetivo : Responsável Pela Abertura de Janelas do Sistema
///####################################################################################################################
procedure Abrir_Janela(pForm: String; pModal: Boolean = True);
var
  FormClasse: TFormClass;
  FormTela: TForm;
  i: Integer;
  bCriado: Boolean;
  Fundo: TFundoEsmaecido;

begin
  Fundo := TFundoEsmaecido.New;
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

  if pModal then
     begin
       Fundo.Escurecer;
       FormTela.ShowModal;
       FormTela.Free;
       Fundo.Clarear;
       Fundo.Destroy;
     end
  else
     begin
       FormTela.Show;
     end;
end;

///####################################################################################################################
/// Função   : Limpar_Edits()
/// Objetivo : Responsável Pela Limpeza dos Edit´s no Form
///####################################################################################################################
procedure Limpar_Edits(pFrm: TForm);
var
  i: Integer;

begin
  for i := pFrm.ComponentCount - 1 downto 0 do
    begin
      if (pFrm.Components[i] is TCustomEdit) then
         (pFrm.Components[i] as TCustomEdit).Clear
      else if (pFrm.Components[i] is TLabel) and (String((pFrm.Components[i] as TLabel).Name).Contains('edt')) then
         (pFrm.Components[i] as TLabel).Caption := '';
    end;
end;

///####################################################################################################################
/// Função   : Form_Componente()
/// Objetivo : Responsável Por Retornar o Componente do Formulário
///####################################################################################################################
function Form_Componente(pFrm: TForm; pTag: Integer): TComponent;
var
  i: Integer;

begin
  Result := nil;
  for i := 0 to pFrm.ComponentCount - 1 do
  begin
    if (pFrm.Components[i].Tag = pTag) then
       Result := (pFrm.Components[i] as TComponent);
  end;
end;

///####################################################################################################################
/// Função   : Modo_Componente()
/// Objetivo : Responsável Pela Mudança de Comportamento do Componente
///####################################################################################################################
procedure Modo_Componente(pFrm: TForm; pNomeComponente: String; pHabilita: Boolean = True; pVisivel: Boolean = True);
var
  Componente: TComponent;

begin
  Componente := pFrm.FindComponent(pNomeComponente);
  if (Componente is TCustomSpeedButton) then
     begin
       (Componente as TSpeedButton).Enabled := pHabilita;
       (Componente as TSpeedButton).Visible := pVisivel;

       if pHabilita then
          (Componente as TSpeedButton).StyleElements := [seFont, seClient, seBorder]
       else
          begin
            (Componente as TSpeedButton).StyleElements := [seClient, seBorder];
            (Componente as TSpeedButton).Font.Color    := clGrayText;
          end;
     end
  else if (Componente is TCustomButton) then
     begin
       (Componente as TCustomButton).Enabled := pHabilita;
       (Componente as TCustomButton).Visible := pVisivel;
     end
  else if (Componente is TCustomLabel) then
     begin
       (Componente as TCustomLabel).Enabled := pHabilita;
       (Componente as TCustomLabel).Visible := pVisivel;
     end
  else if (Componente is TCustomPanel) then
     begin
       (Componente as TCustomPanel).Enabled := pHabilita;
       (Componente as TCustomPanel).Visible := pVisivel;
     end
  else if (Componente is TCustomGroupBox) then
     begin
       (Componente as TCustomGroupBox).Enabled := pHabilita;
       (Componente as TCustomGroupBox).Visible := pVisivel;
     end
  else if (Componente is TCustomEdit) then
     begin
       (Componente as TCustomEdit).Enabled := pHabilita;
       (Componente as TCustomEdit).Visible := pVisivel;
     end
end;

///####################################################################################################################
/// Função   : Foco_Componente()
/// Objetivo : Responsável Pela Mudança de Comportamento do Componente
///####################################################################################################################
procedure Foco_Componente(pFrm: TForm; pNomeComponente: String);
var
  Componente: TComponent;

begin
  Componente := pFrm.FindComponent(pNomeComponente);
  if (Componente is TCustomButton) then
     begin
       TCustomButton(Componente).SetFocus;
     end
  else if (Componente is TCustomEdit) then
     begin
       TEdit(Componente).SetFocus;
     end
  else if (Componente is TDBGrid) then
     begin
       TDBGrid(Componente).SetFocus;
     end
  else if (Componente is TDateTimePicker) then
     begin
       TDateTimePicker(Componente).SetFocus;
     end
  else if (Componente is TComboBox) then
     begin
       TComboBox(Componente).SetFocus;
     end;

end;

///####################################################################################################################
/// Função   : Componente_Vazio()
/// Objetivo : Responsável Pela Verificação se o Componente está Vazio
///####################################################################################################################
function Componente_Vazio(pFrm: TForm; pNomeComponente: String): Boolean;
var
  Componente: TComponent;

begin
  Componente := pFrm.FindComponent(pNomeComponente);
  if (Componente is TEdit) then
     Result := (Componente as TEdit).IsEmpty
  else
     Result := False;
end;

///####################################################################################################################
/// Função   : Componente_Valor()
/// Objetivo : Responsável Por Preencher ou Recuperar Valores de Componentes
///####################################################################################################################
function Componente_Valor(pFrm: TForm; pNomeComponente: String; pTexto: String = ''; pZerar: Boolean = False): String;
var
  Componente: TComponent;

begin
  Componente := pFrm.FindComponent(pNomeComponente);
  if (Componente is TEdit) then
     begin
       if (pTexto <> '') or (pZerar) then
         (Componente as TEdit).Text := pTexto;
       Result := (Componente as TEdit).Text
     end
  else if (Componente is TLabel) then
     begin
       if (pTexto <> '') or (pZerar) then
          (Componente as TLabel).Caption := pTexto;
       Result := (Componente as TLabel).Caption;
     end;
end;

///####################################################################################################################
/// Função   : Componente_Valor()
/// Objetivo : Responsável Por Preencher ou Recuperar Valores de Componentes
///####################################################################################################################
procedure Componente_Fonte(pFrm: TForm; pNomeComponente: String; pFonte: String = ''; pCor: TColor = clWindowText);
var
  Componente: TComponent;

begin
  Componente := pFrm.FindComponent(pNomeComponente);
  if (Componente is TEdit) then
     begin
       if pFonte <> '' then
          (Componente as TEdit).Font.Name := pFonte;
       (Componente as TEdit).Font.Color   := pCor;
     end
  else if (Componente is TLabel) then
     begin
       if pFonte <> '' then
          (Componente as TLabel).Font.Name := pFonte;
       (Componente as TLabel).Font.Color   := pCor;
     end;
end;

end.
