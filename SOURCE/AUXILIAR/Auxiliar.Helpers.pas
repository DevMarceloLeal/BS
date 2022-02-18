unit Auxiliar.Helpers;

interface

uses
  System.SysUtils,
  Vcl.StdCtrls,
  Auxiliar.Conversoes;

type
  TEditHelper = class Helper for TEdit
    function IsEmpty: Boolean;
    function ToMoeda : String;
  end;

implementation

{ TEditHelper }

function TEditHelper.IsEmpty: Boolean;
begin
  Result := Trim(Self.Text) = EmptyStr;
end;

function TEditHelper.ToMoeda: String;
begin
  Result := Moeda(Self.Text);
end;

end.
