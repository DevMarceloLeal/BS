unit Controller.Relatorios.Factory;

interface

uses
  Controller.Relatorios.Interfaces,
  Model.Relatorios.Doacoes;

type
  TControllerRelatorios = class(TInterfacedObject, iControllerRelatorios)
  private
    FRelatorioDoacoes: iModelRelatorios;
  public
    constructor Create;
    destructor Destroy; override;
    class function New : iControllerRelatorios;
    function Doacoes: iModelRelatorios;
  end;

implementation

{ TControllerDAO }

constructor TControllerRelatorios.Create;
begin
  FRelatorioDoacoes := TModelRelatorioDoacoes.New;
end;

destructor TControllerRelatorios.Destroy;
begin
  inherited;
end;

class function TControllerRelatorios.New: iControllerRelatorios;
begin
  Result := Self.Create;
end;

function TControllerRelatorios.Doacoes: iModelRelatorios;
begin
  Result := FRelatorioDoacoes;
end;

end.

