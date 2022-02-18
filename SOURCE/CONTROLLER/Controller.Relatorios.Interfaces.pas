unit Controller.Relatorios.Interfaces;

interface

type
  iModelRelatorios = interface
    ['{C4CF5B1C-3D45-41B1-82D6-1B2FFDBD9754}']
    procedure Imprimir;
  end;

  iControllerRelatorios = interface
    ['{07EBE7F0-4039-4BE0-AB1A-B5EFE74001D3}']
    function Doacoes: iModelRelatorios;
  end;

implementation

end.
