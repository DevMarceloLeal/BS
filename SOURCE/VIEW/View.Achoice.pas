unit View.Achoice;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
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
  Vcl.ImgList,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.Mask,
  Data.DB,
  Datasnap.DBClient,
  Auxiliar.Helpers,
  Auxiliar.Forms,
  Auxiliar.Datas,
  Auxiliar.Informacoes,
  Vcl.Buttons, Vcl.Imaging.pngimage;

type
  TfrmEscolher = class(TForm)
    pnTrabalho: TPanel;
    dbgAchoice: TDBGrid;
    dsAchoice: TDataSource;
    Label1: TLabel;
    Panel3: TPanel;
    imgIcone: TImage;
    btnFechar: TSpeedButton;
    img16: TImageList;
    Panel1: TPanel;
    btnCancelar: TBitBtn;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dsAchoiceDataChange(Sender: TObject; Field: TField);
    procedure DBListBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBListBoxClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    FChoiced: String;
    procedure LimpaEscolhaFechaForm;
    procedure AtribuiEscolhaFechaForm;
    procedure RemoveScrollBar;
  published
    property Choiced: String read FChoiced write FChoiced;
  end;

var
  frmEscolher: TfrmEscolher;

implementation

{$R *.dfm}

procedure TfrmEscolher.FormCreate(Sender: TObject);
begin
//
end;

procedure TfrmEscolher.FormShow(Sender: TObject);
begin
  RemoveScrollBar;
end;

procedure TfrmEscolher.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      LimpaEscolhaFechaForm;
  end;
end;

procedure TfrmEscolher.dsAchoiceDataChange(Sender: TObject; Field: TField);
begin
  RemoveScrollBar;
end;

procedure TfrmEscolher.DBListBoxClick(Sender: TObject);
begin
  AtribuiEscolhaFechaForm;
end;

procedure TfrmEscolher.DBListBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  NomeCampo, Pesquisa: string;

begin
  case Key of
    VK_F9:
     begin
       if InputQuery('Selecione', 'Digite o conte?do a Pesquisar', Pesquisa) then
          begin
            NomeCampo := TDBGrid(Sender).Columns[TDBGrid(Sender).SelectedIndex].FieldName;
            Pesquisa := QuotedStr('%' + Pesquisa + '%');
            TDBGrid(Sender).DataSource.DataSet.Filter := NomeCampo + ' LIKE ' + Pesquisa;
            TDBGrid(Sender).DataSource.DataSet.Filtered := True;
          end
       else
          TDBGrid(Sender).DataSource.DataSet.Filtered := False;
     end;

    VK_RETURN:
      AtribuiEscolhaFechaForm;
  end;
end;

procedure TfrmEscolher.btnCancelarClick(Sender: TObject);
begin
  LimpaEscolhaFechaForm;
end;

procedure TfrmEscolher.Label1Click(Sender: TObject);
begin
  keybd_event(VK_F9, 0, 0, 0);
end;

procedure TfrmEscolher.LimpaEscolhaFechaForm;
begin
  Choiced := EmptyStr;
  Close;
end;

procedure TfrmEscolher.AtribuiEscolhaFechaForm;
begin
  Choiced := dbgAchoice.Columns[0].Field.Value;
  dbgAchoice.DataSource.DataSet.Filter := '';
  dbgAchoice.DataSource.DataSet.Filtered := False;
  Close;
end;

procedure TfrmEscolher.RemoveScrollBar;
begin
  ShowScrollBar(dbgAchoice.handle, SB_VERT, False);
  ShowScrollBar(dbgAchoice.handle, SB_HORZ, False);
end;

initialization
  RegisterClass(TfrmEscolher);

finalization
  UnRegisterClasses([TfrmEscolher]);

end.
