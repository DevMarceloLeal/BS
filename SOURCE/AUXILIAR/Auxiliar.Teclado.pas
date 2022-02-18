unit Auxiliar.Teclado;

interface

uses
  Winapi.Windows,
  Winapi.Messages;

  procedure Limpar_Buffer_Teclado;

implementation

procedure Limpar_Buffer_Teclado;
var
  Msg: TMsg;

begin
  while PeekMessage(Msg, 0, WM_KEYFIRST, WM_KEYLAST, PM_REMOVE or PM_NOYIELD) do;
end;

end.
