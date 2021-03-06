unit Classe.Atributos;

interface

type
  NotNull = class(TCustomAttribute)
  private
    FMensagem: String;
    procedure SetMensagem(const Value: String);
  public
    constructor Create(pMsg: String);
    property Mensagem: String read FMensagem write SetMensagem;
  end;

  MinLength = class(TCustomAttribute)
  private
    FLength: Integer;
    FMsg: String;
    procedure SetLength(const Value: Integer);
    procedure SetMsg(const Value: String);
  public
    constructor Create(pLength: Integer; pMsg: String);
    property Length: Integer read FLength write SetLength;
    property Msg: String read FMsg write SetMsg;
  end;

  Duplicado = class(TCustomAttribute)
  private
    FMsg: String;
    FTabela: String;
    procedure SetMsg(const Value: String);
    procedure SetTabela(const Value: String);
  public
    constructor Create(pTabela, pMsg: String);
    property Tabela: String read FTabela write SetTabela;
    property Msg: String read FMsg write SetMsg;
  end;

  CampoCodigo = class(TCustomAttribute)
  private
    FCampoCodigo: String;
    procedure SetCampoCodigo(const Value: String);
  public
    constructor Create(CampoCodigo: String);
    property CampoCodigo: String read FCampoCodigo write SetCampoCodigo;
  end;

  CampoNome = class(TCustomAttribute)
  private
    FCampoNome: String;
    procedure SetCampoNome(const Value: String);
  public
    constructor Create(CampoNome: String);
    property CampoNome: String read FCampoNome write SetCampoNome;
  end;

  CampoFoco = class(TCustomAttribute)
  private
    FCampoFoco: String;
    procedure SetCampoFoco(const Value: String);
  public
    constructor Create(CampoFoco: String);
    property CampoFoco: String read FCampoFoco write SetCampoFoco;
  end;

  CamposGrid = class(TCustomAttribute)
  private
    FDescricao: String;
    FPosicao: String;
    FTamanho: Integer;
    procedure SetDescricao(const Value: String);
    procedure SetPosicao(const Value: String);
    procedure SetTamanho(const Value: Integer);
  public
    constructor Create(Descricao, Posicao: String; Tamanho: Integer);
    property Descricao: String read FDescricao write SetDescricao;
    property Posicao: String read FPosicao write SetPosicao;
    property Tamanho: Integer read FTamanho write SetTamanho;
  end;

implementation

{ NotNull }

constructor NotNull.Create(pMsg: String);
begin
  FMensagem := pMsg;
end;

procedure NotNull.SetMensagem(const Value: String);
begin
  FMensagem := Value;
end;

{ MinLength }

constructor MinLength.Create(pLength: Integer; pMsg: String);
begin
  FLength := pLength;
  FMsg := pMsg;
end;

procedure MinLength.SetLength(const Value: Integer);
begin
  FLength := Value;
end;

procedure MinLength.SetMsg(const Value: String);
begin
  FMsg := Value;
end;

{ Duplicado }

constructor Duplicado.Create(pTabela, pMsg: String);
begin
  FTabela := pTabela;
  FMsg := pMsg;
end;

procedure Duplicado.SetMsg(const Value: String);
begin
  FMsg := Value;
end;

procedure Duplicado.SetTabela(const Value: String);
begin
  FTabela := Value;
end;

{ CampoCodigo }

constructor CampoCodigo.Create(CampoCodigo: String);
begin
  FCampoCodigo := CampoCodigo;
end;

procedure CampoCodigo.SetCampoCodigo(const Value: String);
begin
  FCampoCodigo := Value;
end;

{ CampoNome }

constructor CampoNome.Create(CampoNome: String);
begin
  FCampoNome := CampoNome;
end;

procedure CampoNome.SetCampoNome(const Value: String);
begin
  FCampoNome := Value;
end;

{ CampoFoco }

constructor CampoFoco.Create(CampoFoco: String);
begin
  FCampoFoco := CampoFoco;
end;

procedure CampoFoco.SetCampoFoco(const Value: String);
begin
  FCampoFoco := Value;
end;

{ CampossGrid }

constructor CamposGrid.Create(Descricao, Posicao: String; Tamanho: Integer);
begin
  FDescricao := Descricao;
  FPosicao := Posicao;
  FTamanho := Tamanho;
end;

procedure CamposGrid.SetDescricao(const Value: String);
begin
  FDescricao := Value;
end;

procedure CamposGrid.SetPosicao(const Value: String);
begin
  FPosicao := Value;
end;

procedure CamposGrid.SetTamanho(const Value: Integer);
begin
  FTamanho := Value;
end;

end.
