unit Auxiliar.Achoice;

interface

uses
  System.Classes,
  System.SysUtils,
  Vcl.Forms,
  Vcl.Dialogs,
  Data.DB,
  Datasnap.DBClient,
  Auxiliar.Variaveis.Globais;

  function Achoice(pDataSet: TDataSet): String;

implementation

uses
  View.Achoice;

///####################################################################################################################
// Função   : Achoice()
// Objetivo : Seleciona Uma Opção Num ListBox
///####################################################################################################################
function Achoice(pDataSet: TDataSet): String;
var
 vNewHeight: Integer;

begin
  Application.CreateForm(TfrmEscolher, frmEscolher);

  try
    vNewHeight := 80 + ((pDataSet.RecordCount + 1) * 20);
    if vNewHeight > 226 then
       frmEscolher.Height := 350;

    frmEscolher.Panel3.Caption    := 'Favor Selecionar '  ;
    frmEscolher.Width             := frmEscolher.Width + 8;
    frmEscolher.dsAchoice.DataSet := pDataSet;
    frmEscolher.ShowModal;
  finally
    Result := frmEscolher.Choiced;
    FreeAndNil(frmEscolher);
  end;
end;

end.
