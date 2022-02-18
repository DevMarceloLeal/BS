unit View.Mensagens;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  System.ImageList,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.ImgList,
  Vcl.Imaging.pngimage,
  Auxiliar.Fundo.Esmaecido;

type
  TMyButtons = (mbSim, mbNao, mbOk);

  TfrmMensagens = class(TForm)
    pnlCabecalho: TPanel;
    pnlCorpo: TPanel;
    pnlRodape: TPanel;
    imgIcone: TImage;
    lblTitulo: TLabel;
    btnFechar: TSpeedButton;
    img16: TImageList;
    btnOK: TBitBtn;
    btnSim: TBitBtn;
    btnNao: TBitBtn;
    lblMensagem: TLabel;
    imgMensagem: TImage;
    bhMensagem: TBalloonHint;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure btnFecharClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnSimClick(Sender: TObject);
    procedure btnNaoClick(Sender: TObject);
  public
    class function Mensagem(Titulo, Mensagem: String; Tipo: Char; Botoes: array of TMyButtons) : Boolean;
  end;

var
  frmMensagens: TfrmMensagens;
  Fundo: TFundoEsmaecido;

const
  LEFTBUTTONS : array[0..2] of integer = (326, 247, 168);
  TITULOJANELA : String = '®WK Technology';

implementation

{$R *.dfm}

procedure TfrmMensagens.FormCreate(Sender: TObject);
begin
  lblTitulo.Caption := TITULOJANELA;
end;

procedure TfrmMensagens.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE,
    VK_RETURN:
      begin
        Key := 0;
        Close;
      end;
  end;
end;

procedure TfrmMensagens.Image2MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
begin
  ReleaseCapture();
  PostMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TfrmMensagens.btnFecharClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmMensagens.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfrmMensagens.btnSimClick(Sender: TObject);
begin
  ModalResult := mrYes;
end;

procedure TfrmMensagens.btnNaoClick(Sender: TObject);
begin
  ModalResult := mrNo;
end;

class function TfrmMensagens.Mensagem(Titulo, Mensagem: String; Tipo: Char; Botoes: array of TMyButtons) : Boolean;
var
  i: Integer;
  frm :TfrmMensagens;
  png: TPngImage;

begin
  Fundo := TFundoEsmaecido.New;
  png := TPngImage.Create;
  frm := TfrmMensagens.Create(nil);

  try
    if Titulo.IsEmpty then
       Titulo := TITULOJANELA;

    frm.lblTitulo.Caption   := Titulo;
    frm.lblMensagem.Caption := Mensagem;

    case (Tipo) of
      'I':
        png.LoadFromResourceName(HInstance, 'img_info');
      'P':
        png.LoadFromResourceName(HInstance, 'img_pergunta');
      'C':
        png.LoadFromResourceName(HInstance, 'img_cuidado');
      'E':
        png.LoadFromResourceName(HInstance, 'img_erro');
    else
       png.LoadFromResourceName(HInstance, 'img_info');
    end;

   MessageBeep(MB_YESNO);

   frm.imgMensagem.Picture.Graphic := png;
   Application.ProcessMessages;

   for i := 0 to Length(Botoes) - 1 do
      begin
        case (Botoes[i]) of
          mbOk:
            begin
              frm.btnOK.Left     := LEFTBUTTONS[i];
              frm.btnOK.Visible  := True;
            end;

          mbNao:
            begin
              frm.btnNao.Left    := LEFTBUTTONS[i];
              frm.btnNao.Visible := True;
            end;

          mbSim:
            begin
              frm.btnSim.Left    := LEFTBUTTONS[i];
              frm.btnSim.Visible := True;
            end;
        else
           begin
             frm.btnOK.Left      := LEFTBUTTONS[i];
             frm.btnOK.Visible   := True;
           end;
        end;
      end;

   Fundo.Escurecer;
   frm.ShowModal;
   Fundo.Clarear;

    case (frm.ModalResult) of
       mrOk, mrYes : Result := True;
    else
       Result := False;
    end;

  finally
    if (frm<>nil) then
       FreeAndNil(frm);
  end;
end;

end.
