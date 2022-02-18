unit View.BackTransparent;

interface

uses
  Winapi.Windows,
  System.Classes,
  Vcl.Forms,
  Auxiliar.Variaveis.Globais;

type
  TfrmBlack = class(TForm)
  public
    class function New: TfrmBlack;
  end;

var
  frmBlack: TfrmBlack;

implementation

{$R *.dfm}

{ TfrmBlack }

class function TfrmBlack.New: TfrmBlack;
begin
  frmBlack          := TfrmBlack.Create(nil);
  frmBlack.Width    := gLargura;
  frmBlack.Height   := gComprimento;
  frmBlack.Top      := gTopo;
  frmBlack.Left     := gEsquerda;
  frmBlack.Position := gPosicao;
  Result := frmBlack;
end;

end.
