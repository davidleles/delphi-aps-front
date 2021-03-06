unit untPessoa;

interface

type
  TPessoa = class
  private
    FAtiva: Boolean;
    FNome: string;
    FCPF: string;
    FTel: string;
    FCel: string;
    FPapel: Integer;
    FPlastico: Integer;
    FVidro: Integer;
    FMetal: Integer;
    FOrganico: Integer;
    FOutros: Integer;

    procedure SetAtiva(const Value: Boolean);
    procedure SetNome(const Value: string);
    procedure SetCel(const Value: string);
    procedure SetCPF(const Value: string);
    procedure SetTel(const Value: string);
    procedure SetPapel(const Value: Integer);
    procedure SetPlastico(const Value: Integer);
    procedure SetVidro(const Value: Integer);
    procedure SetMetal(const Value: Integer);
    procedure SetOrganico(const Value: Integer);
    procedure SetOutros(const Value: Integer);

    public
      property Nome: string read FNome write SetNome;
      property Ativa: Boolean read FAtiva write SetAtiva;
      property CPF: string read FCPF write SetCPF;
      property Tel: string read FTel write SetTel;
      property Cel: string read FCel write SetCel;
      property Papel: Integer read FPapel write SetPapel;
      property Plastico: Integer read FPlastico write SetPlastico;
      property Vidro: Integer read FVidro write SetVidro;
      property Metal: Integer read FMetal write SetMetal;
      property Organico: Integer read FOrganico write SetOrganico;
      property Outros: Integer read FOutros write SetOutros;

  end;

implementation

{ TPessoa }

procedure TPessoa.SetAtiva(const Value: Boolean);
begin
  FAtiva := Value;
end;

procedure TPessoa.SetCel(const Value: string);
begin
  FCel := Value;
end;

procedure TPessoa.SetCPF(const Value: string);
begin
  FCPF := Value;
end;

procedure TPessoa.SetMetal(const Value: Integer);
begin
  FMetal := Value;
end;

procedure TPessoa.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TPessoa.SetOrganico(const Value: Integer);
begin
  FOrganico := Value;
end;

procedure TPessoa.SetOutros(const Value: Integer);
begin
  FOutros := Value;
end;

procedure TPessoa.SetPapel(const Value: Integer);
begin
  FPapel := Value;
end;

procedure TPessoa.SetPlastico(const Value: Integer);
begin
  FPlastico := Value;
end;

procedure TPessoa.SetTel(const Value: string);
begin
  FTel := Value;
end;

procedure TPessoa.SetVidro(const Value: Integer);
begin
  FVidro := Value;
end;

end.
