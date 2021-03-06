unit Cadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, Data.DB,
  Datasnap.DBClient, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, ACBrBase, ACBrSocket, ACBrCEP, Vcl.Imaging.jpeg, IdMultipartFormData,
  REST.Json, System.JSON, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  TForm2 = class(TForm)
    lbNome: TLabel;
    lbCPF: TLabel;
    lbTel: TLabel;
    lbCel: TLabel;
    Panel1: TPanel;
    EditNome: TEdit;
    EditCPF: TEdit;
    EditCel: TEdit;
    EditTel: TEdit;
    GroupBox1: TGroupBox;
    rgSituacao: TRadioGroup;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    editProduto1: TEdit;
    editProduto2: TEdit;
    editProduto3: TEdit;
    editProduto4: TEdit;
    editProduto5: TEdit;
    cbProduto1: TComboBox;
    cbProduto2: TComboBox;
    cbProduto3: TComboBox;
    cbProduto4: TComboBox;
    cbProduto5: TComboBox;
    Panel2: TPanel;
    Image1: TImage;
    EditProduto6: TEdit;
    cbProduto6: TComboBox;
    Memo1: TMemo;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    procedure EditCPFKeyPress(Sender: TObject; var Key: Char);
    procedure EditTelKeyPress(Sender: TObject; var Key: Char);
    procedure EditCelKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure rgSituacaoClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    vArquivo : string;
    procedure GeraJSON;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses untPessoa;

procedure TForm2.EditCelKeyPress(Sender: TObject; var Key: Char);
begin
  if ((key in ['0'..'9'] = false) and (word(key) <> vk_back)) then
    key := #0;
end;

procedure TForm2.EditCPFKeyPress(Sender: TObject; var Key: Char);
begin
  if ((key in ['0'..'9'] = false) and (word(key) <> vk_back)) then
    key := #0;
end;

procedure TForm2.EditTelKeyPress(Sender: TObject; var Key: Char);
begin
  if ((key in ['0'..'9'] = false) and (word(key) <> vk_back)) then
    key := #0;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  rgSituacao.ItemIndex := 0;
  cbProduto1.ItemIndex := 0;
  cbProduto2.ItemIndex := 0;
  cbProduto3.ItemIndex := 0;
  cbProduto4.ItemIndex := 0;
  cbProduto5.ItemIndex := 0;
  cbProduto6.ItemIndex := 0;
end;

procedure TForm2.GeraJSON;
var
  Pessoa: TPessoa;
  JSONPessoa: TJSONObject;
begin

  Pessoa := TPessoa.Create;

  if rgSituacao.ItemIndex = 0 then
    Pessoa.Ativa:= True
  else
    Pessoa.Ativa:= False;

  Pessoa.Nome     := EditNome.Text;
  Pessoa.CPF      := EditCPF.Text;
  Pessoa.Tel      := EditTel.Text;
  Pessoa.Cel      := EditCel.Text;

  Pessoa.Papel    := StrToInt(cbProduto1.Text);
  Pessoa.Plastico := StrToInt(cbProduto2.Text);
  Pessoa.Vidro    := StrToInt(cbProduto3.Text);
  Pessoa.Metal    := StrToInt(cbProduto4.Text);
  Pessoa.Organico := StrToInt(cbProduto5.Text);
  Pessoa.Outros   := StrToInt(cbProduto6.Text);

  JSONPessoa := TJson.ObjectToJsonObject(Pessoa);

  vArquivo := JSONPessoa.Format;
  vArquivo := StringReplace(vArquivo, #$D#$A, '', [rfReplaceAll]);
end;

procedure TForm2.rgSituacaoClick(Sender: TObject);
begin
  if rgSituacao.ItemIndex = 1 then
    ShowMessage('Aten��o! A situa��o do cadastro atual est� desativado!');
end;

procedure TForm2.SpeedButton1Click(Sender: TObject);
var
  URL, Retorno: String;
  JsonStreamRetorno, JsonStreamEnvio: TStringStream;
begin
  if (Length(EditNome.Text) < 5) then
  begin
    ShowMessage('- Verifiquei se o nome est� completo!');
    EditNome.SetFocus;
    Exit;
  end;

  if (Length(EditCPF.Text) < 11) then
  begin
    ShowMessage('- Verifiquei se o CPF est� correto!');
    EditCPF.SetFocus;
    Exit;
  end;

  if (Length(EditCel.Text) < 8) then
  begin
    ShowMessage('- Verifiquei se o TELEFONE est� completo!');
    EditCel.SetFocus;
    Exit;
  end;

  // Para teste, alterar para a API necess�ria.
  URL := 'http://201.76.56.78:8080/aps-si8/api/v1/async/inserir';

  GeraJSON;

  JsonStreamEnvio := TStringStream.Create(vArquivo);
  JsonStreamRetorno := TStringStream.Create('');

  // Init request:
  try
    idHttp1.Request.ContentType := 'application/json';
    idhttp1.Request.Charset := 'UTF-8';
    IdHttp1.IOHandler := IdSSLIOHandlerSocketOpenSSL1;

    // Set username and password:
    idHttp1.Request.Clear;
    idHttp1.Request.BasicAuthentication := False;

    idHttp1.Response.ContentType := 'application/json';
    idHttp1.Response.CharSet := 'UTF-8';

    try
      idHttp1.Post(URL, JsonStreamEnvio, JsonStreamRetorno);
      ShowMessage('Total: ' + JsonStreamRetorno.DataString);
    except
      on E:EIdHTTPProtocolException do
      ShowMessage(e.ErrorMessage);
    end;

   finally

   end;
end;

end.
