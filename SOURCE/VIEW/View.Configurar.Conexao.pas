unit View.Configurar.Conexao;

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
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Vcl.ImgList,
  Vcl.ActnList,
  Controller.DAO.Interfaces,
  Controller.DAO.Factory,
  Auxiliar.Forms,
  Auxiliar.Fundo.Esmaecido;

type
  TfrmConfigurarConexao = class(TForm)
    Panel1: TPanel;
    Label8: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    Label3: TLabel;
    edtServidor: TEdit;
    edtBancoDados: TEdit;
    edtPorta: TEdit;
    edtUsuario: TEdit;
    edtSenha: TEdit;
    edtDriverID: TComboBox;
    pnlCabecalho: TPanel;
    lblTitulo: TLabel;
    btnFechar: TSpeedButton;
    imgIcone: TImage;
    img16: TImageList;
    Panel2: TPanel;
    btnGravar: TBitBtn;
    btnCancelar: TBitBtn;
    aclConfigurarConexao: TActionList;
    actGravarConfiguracao: TAction;
    actCancelarConfiguracao: TAction;
    bhConfigurarConexao: TBalloonHint;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actGravarConfiguracaoExecute(Sender: TObject);
    procedure actCancelarConfiguracaoExecute(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtDriverIDExit(Sender: TObject);
  public
    FControle: iControllerDAO;
  end;

var
  frmConfigurarConexao: TfrmConfigurarConexao;

implementation

{$R *.dfm}

procedure TfrmConfigurarConexao.FormCreate(Sender: TObject);
begin
  FControle := TControllerDAO.New;
  Position := poMainFormCenter;
end;

procedure TfrmConfigurarConexao.FormShow(Sender: TObject);
begin
  FControle.Parametros.Formulario(Self, True);
end;

procedure TfrmConfigurarConexao.FormDestroy(Sender: TObject);
begin
//
end;

procedure TfrmConfigurarConexao.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    Char(VK_ESCAPE):
      begin
        Key := #0;
        Close;
      end;
    Char(VK_RETURN):
      begin
        Key := #0;
        Keybd_Event(VK_TAB, 0, 0, 0);
      end;
  end;
end;

procedure TfrmConfigurarConexao.edtDriverIDExit(Sender: TObject);
begin
  actGravarConfiguracaoExecute(Sender);
end;

procedure TfrmConfigurarConexao.actGravarConfiguracaoExecute(Sender: TObject);
begin
  FControle.Parametros.Formulario(Self).Gravar;
  Close;
end;

procedure TfrmConfigurarConexao.actCancelarConfiguracaoExecute(Sender: TObject);
begin
  Close;
end;

initialization
  RegisterClass(TfrmConfigurarConexao);

finalization
  UnRegisterClasses([TfrmConfigurarConexao]);

end.
