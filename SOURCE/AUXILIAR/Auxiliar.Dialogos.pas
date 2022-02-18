unit Auxiliar.Dialogos;

interface

uses
  Winapi.Windows,
  System.UITypes,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Controls,
  Auxiliar.Fundo.Esmaecido;

  procedure MsgSys(StrMsg: String; Tipo: Integer = 1);
  procedure Msg(StrMsg: String; StrTitulo: String = ''; Tipo: Integer = 1);
  function Pergunta(StrMsg: String; StrTitulo: String = ''): Boolean;

const
  TITULOJANELA : String = 'OMEGA Sistemas';

implementation

uses
  View.Mensagens;

/// ####################################################################################################################
/// Função   : MsgSys()
/// Objetivo : Responsável pela janela de mensagens nativas da linguagem
///####################################################################################################################
procedure MsgSys(StrMsg: String; Tipo: Integer = 1);
const
  mbOK = [TMsgDlgBtn.mbOK];

var
  I: Integer;
  StrTitulo: String;
  DlgType: TMsgDlgType;
  Fundo: TFundoEsmaecido;
  bhMsgSys: TBalloonHint;

begin
  Fundo          := TFundoEsmaecido.New;
  bhMsgSys       := TBalloonHint.Create(nil);
  bhMsgSys.Style := bhsBalloon;

  if StrTitulo = '' then
     StrTitulo := TITULOJANELA;

  DlgType := mtInformation;
  if Tipo = 2 then
     DlgType := mtWarning
  else if Tipo = 3 then
     DlgType := mtError;

  Fundo.Escurecer;
  with CreateMessageDialog(StrMsg, DlgType, mbOk) do
    try
      for I := 0 to ComponentCount - 1 do
          if Components[I] IS TButton then
             begin
               with TButton(Components[I]) do
                 case ModalResult of
                   mrOK:
                     begin
                       Caption := '&OK';
                       Cursor  := crHandPoint;
                       Hint    := 'Tecle Para Encerrar a Janela';
                     end;
                 end;
             end;

      MessageBeep(MB_ICONINFORMATION);

      Caption    := StrTitulo;
      CustomHint := bhMsgSys;
      ShowHint   := True;
      ShowModal;
    finally
      Fundo.Clarear;
      Fundo.Free;
      bhMsgSys.Free;
      Free
    end;
end;

///####################################################################################################################
/// Função   : Msg()
/// Objetivo : Responsável pela janela de mensagens gerada por VCL
///####################################################################################################################
procedure Msg(StrMsg: String; StrTitulo: String = ''; Tipo: Integer = 1);
begin
  if StrTitulo = '' then
     StrTitulo := TITULOJANELA;

   if Tipo = 1 then
      TFrmMensagens.Mensagem(StrTitulo, StrMsg, 'I', [mbOK])
   else if Tipo = 2 then
      TFrmMensagens.Mensagem(StrTitulo, StrMsg, 'C', [mbOK])
   else if Tipo = 3 then
      TFrmMensagens.Mensagem(StrTitulo, StrMsg, 'E', [mbOK])
end;

///####################################################################################################################
/// Função   : Pergunta()
/// Objetivo : Responsável pela janela de perguntas gerada por VCL
///####################################################################################################################
function Pergunta(StrMsg: String; StrTitulo: String = ''): Boolean;
begin
  if StrTitulo = '' then
     StrTitulo := TITULOJANELA;

  Result := TFrmMensagens.Mensagem(StrTitulo, StrMsg,'P',[mbNao, mbSim]);
end;

end.
