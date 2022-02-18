unit Controller.Conexao.Interfaces;

interface

uses
  Vcl.Forms,
  Model.Conexao.Interfaces;

type
  iControllerConexao = interface
    ['{CF6DE8AC-08A8-40AF-BA18-4117A16FCD26}']
    function Conexao: iModelConexaoFactory;
  end;

implementation

end.
