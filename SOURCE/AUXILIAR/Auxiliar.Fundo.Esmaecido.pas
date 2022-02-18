unit Auxiliar.Fundo.Esmaecido;

interface

uses
  System.Classes,
  View.BackTransparent;

type
  TFundoEsmaecido = class(TComponent)
  public
    FFundoEsmaecido: TfrmBlack;
    destructor Destroy; override;
    class function New: TFundoEsmaecido;
    procedure Escurecer;
    procedure Clarear;
  end;

implementation

uses
  System.SysUtils;

{ TFundoEsmaecido }

destructor TFundoEsmaecido.Destroy;
begin
  inherited;
end;

class function TFundoEsmaecido.New: TFundoEsmaecido;
begin
  Result := TFundoEsmaecido.Create(nil);
end;

procedure TFundoEsmaecido.Escurecer;
begin
  FFundoEsmaecido := TfrmBlack.New;
  FFundoEsmaecido.Show;
end;

procedure TFundoEsmaecido.Clarear;
begin
  FFundoEsmaecido.Close;
end;

end.

