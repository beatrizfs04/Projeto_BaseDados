-- Create Tables as MySQL Server
USE `DIUBI`;

CREATE TABLE Interno
(
  IdInterno INT NOT NULL,
  PrimeiroNome VARCHAR(250),
  UltimoNome VARCHAR(250),
  Email VARCHAR(250) NOT NULL,
  Telefone VARCHAR(20),
  PRIMARY KEY (IdInterno)
);

CREATE TABLE Externo
(
  IdExterno INT NOT NULL,
  PrimeiroNome VARCHAR(250) NOT NULL,
  UltimoNome VARCHAR(250) NOT NULL,
  Email VARCHAR(250) NOT NULL,
  Telefone VARCHAR(20),
  PRIMARY KEY (IdExterno)
);

CREATE TABLE DataInfo
(
  IdData INT NOT NULL,
  DataInicio DATE NOT NULL,
  DataFim DATE NOT NULL,
  PRIMARY KEY (IdData)
);

CREATE TABLE Estado
(
  IdEstado INT NOT NULL,
  NomeEstado VARCHAR(250) NOT NULL,
  PRIMARY KEY (IdEstado)
);

CREATE TABLE Programa
(
  IdPrograma INT NOT NULL,
  NomePrograma VARCHAR(250) NOT NULL,
  PRIMARY KEY (IdPrograma)
);

CREATE TABLE Instituicao
(
  IdInstituicao INT NOT NULL,
  NomeInstituicao VARCHAR(250) NOT NULL,
  PRIMARY KEY (IdInstituicao)
);

CREATE TABLE DominioCientifico
(
  IdDominio INT NOT NULL,
  NomeDominio VARCHAR(250) NOT NULL,
  PRIMARY KEY (IdDominio)
);

CREATE TABLE AreaCientifica
(
  IdArea INT NOT NULL,
  NomeArea VARCHAR(250) NOT NULL,
  PRIMARY KEY (IdArea)
);

CREATE TABLE PalavraChave
(
  IdPalavraChave INT NOT NULL,
  PalavraChave VARCHAR(250) NOT NULL,
  PRIMARY KEY (IdPalavraChave)
);

CREATE TABLE Posicao
(
  IdPosicao INT NOT NULL,
  NomePosicao VARCHAR(250) NOT NULL,
  PRIMARY KEY (IdPosicao)
);

CREATE TABLE Membro
(
  IdMembro INT NOT NULL,
  TipoMembro VARCHAR(250) NOT NULL,
  PRIMARY KEY (IdMembro),
  FOREIGN KEY (IdMembro) REFERENCES Interno(IdInterno),
  FOREIGN KEY (IdMembro) REFERENCES Externo(IdExterno)
);

CREATE TABLE Orcid
(
  IdOrcid INT NOT NULL,
  IdMembro INT NOT NULL,
  PRIMARY KEY (IdOrcid),
  FOREIGN KEY (IdMembro) REFERENCES Membro(IdMembro)
);

CREATE TABLE Instituicao_Membro
(
  IdMembro INT NOT NULL,
  IdInstituicao INT NOT NULL,
  PRIMARY KEY (IdMembro, IdInstituicao),
  FOREIGN KEY (IdMembro) REFERENCES Membro(IdMembro),
  FOREIGN KEY (IdInstituicao) REFERENCES Instituicao(IdInstituicao)
);

CREATE TABLE Financiamento
(
  IdFinanciamento INT NOT NULL,
  Valor DECIMAL(15, 2) NOT NULL,
  TipoFinanciamento VARCHAR(250) NOT NULL,
  OrigemFinanciamento VARCHAR(250) NOT NULL,
  TipoFinanciador VARCHAR(250) NOT NULL,
  IdProgramaouServico INT NOT NULL,
  PRIMARY KEY (IdFinanciamento),
  FOREIGN KEY (IdProgramaouServico) REFERENCES Instituicao(IdInstituicao),
  FOREIGN KEY (IdProgramaouServico) REFERENCES Programa(IdPrograma)
);

CREATE TABLE CustoElegivel
(
  IdCustoElegivel INT NOT NULL,
  IdEquipa INT NOT NULL,
  IdProjeto INT NOT NULL,
  CustoEquipa DECIMAL(15, 2) NOT NULL,
  CustoProjeto DECIMAL(15, 2) NOT NULL,
  IdFinanciamento INT NOT NULL,
  PRIMARY KEY (IdCustoElegivel),
  FOREIGN KEY (IdFinanciamento) REFERENCES Financiamento(IdFinanciamento)
);

CREATE TABLE Projeto
(
  IdProjeto INT NOT NULL,
  NomeProjeto VARCHAR(250) NOT NULL,
  Descricao TEXT NOT NULL,
  IdData INT NOT NULL,
  IdInstituicao INT NOT NULL,
  IdEstado INT NOT NULL,
  IdArea INT NOT NULL,
  IdDominio INT NOT NULL,
  IdMembro INT NOT NULL,
  IdCustoElegivel INT NOT NULL,
  PRIMARY KEY (IdProjeto),
  FOREIGN KEY (IdData) REFERENCES DataInfo(IdData),
  FOREIGN KEY (IdInstituicao) REFERENCES Instituicao(IdInstituicao),
  FOREIGN KEY (IdEstado) REFERENCES Estado(IdEstado),
  FOREIGN KEY (IdArea) REFERENCES AreaCientifica(IdArea),
  FOREIGN KEY (IdDominio) REFERENCES DominioCientifico(IdDominio),
  FOREIGN KEY (IdMembro) REFERENCES Membro(IdMembro),
  FOREIGN KEY (IdCustoElegivel) REFERENCES CustoElegivel(IdCustoElegivel)
);

CREATE TABLE AssociarPalavraChave
(
  IdAssociacao INT NOT NULL,
  IdProjeto INT NOT NULL,
  IdPalavraChave INT NOT NULL,
  PRIMARY KEY (IdAssociacao),
  FOREIGN KEY (IdProjeto) REFERENCES Projeto(IdProjeto),
  FOREIGN KEY (IdPalavraChave) REFERENCES PalavraChave(IdPalavraChave)
);

CREATE TABLE Equipa
(
  IdEquipa INT NOT NULL,
  IdMembro INT NOT NULL,
  IdProjeto INT NOT NULL,
  IdCustoElegivel INT NOT NULL,
  PRIMARY KEY (IdEquipa),
  FOREIGN KEY (IdMembro) REFERENCES Membro(IdMembro),
  FOREIGN KEY (IdProjeto) REFERENCES Projeto(IdProjeto),
  FOREIGN KEY (IdCustoElegivel) REFERENCES CustoElegivel(IdCustoElegivel)
);

CREATE TABLE PrestacaoServico
(
  IdPrestacaoServico INT NOT NULL,
  NomePrestacaoServico VARCHAR(250) NOT NULL,
  Descricao TEXT NOT NULL,
  IdInterno INT NOT NULL,
  IdData INT NOT NULL,
  IdEstado INT NOT NULL,
  IdFinanciamento INT NOT NULL,
  PRIMARY KEY (IdPrestacaoServico),
  FOREIGN KEY (IdInterno) REFERENCES Interno(IdInterno),
  FOREIGN KEY (IdData) REFERENCES DataInfo(IdData),
  FOREIGN KEY (IdEstado) REFERENCES Estado(IdEstado),
  FOREIGN KEY (IdFinanciamento) REFERENCES Financiamento(IdFinanciamento)
);

CREATE TABLE Atividade
(
  IdAtividade INT NOT NULL,
  NomeAtividade VARCHAR(250) NOT NULL,
  TipoAtividade VARCHAR(250) NOT NULL,
  IdProjetoPrestacao  INT NOT NULL,
  PRIMARY KEY (IdAtividade),
  FOREIGN KEY (IdProjetoPrestacao) REFERENCES Projeto(IdProjeto),
  FOREIGN KEY (IdProjetoPrestacao) REFERENCES PrestacaoServico(IdPrestacaoServico)
);

CREATE TABLE PosicaoInterno
(
  IdPosicao INT NOT NULL,
  IdInterno INT NOT NULL,
  IdProjeto INT NOT NULL,
  PRIMARY KEY (IdPosicao, IdInterno, IdProjeto),
  FOREIGN KEY (IdPosicao) REFERENCES Posicao(IdPosicao),
  FOREIGN KEY (IdInterno) REFERENCES Interno(IdInterno),
  FOREIGN KEY (IdProjeto) REFERENCES Projeto(IdProjeto)
);

CREATE TABLE TempoAtividade
(
  IdMembro INT NOT NULL,
  TempoTrabalho DECIMAL(5, 2) NOT NULL,
  IdAtividade INT NOT NULL,
  PRIMARY KEY (IdMembro, IdAtividade),
  FOREIGN KEY (IdAtividade) REFERENCES Atividade(IdAtividade)
);

CREATE TABLE Publicacao
(
  IdPublicacao INT NOT NULL,
  DOI VARCHAR(100) NOT NULL,
  IdProjeto INT NOT NULL,
  IdInterno INT NOT NULL,
  IdData INT NOT NULL,
  PRIMARY KEY (IdPublicacao),
  FOREIGN KEY (IdProjeto) REFERENCES Projeto(IdProjeto),
  FOREIGN KEY (IdInterno) REFERENCES Interno(IdInterno),
  FOREIGN KEY (IdData) REFERENCES DataInfo(IdData)
);

-- Create Tables as MySQL Server
USE DIUBI;
GO

CREATE TABLE Interno
(
  IdInterno INT NOT NULL PRIMARY KEY,
  PrimeiroNome NVARCHAR(250),
  UltimoNome NVARCHAR(250),
  Email NVARCHAR(250) NOT NULL,
  Telefone NVARCHAR(20)
);
GO

CREATE TABLE Externo
(
  IdExterno INT NOT NULL PRIMARY KEY,
  PrimeiroNome NVARCHAR(250) NOT NULL,
  UltimoNome NVARCHAR(250) NOT NULL,
  Email NVARCHAR(250) NOT NULL,
  Telefone NVARCHAR(20)
);
GO

CREATE TABLE DataInfo
(
  IdData INT NOT NULL PRIMARY KEY,
  DataInicio DATE NOT NULL,
  DataFim DATE NOT NULL
);
GO

CREATE TABLE Estado
(
  IdEstado INT NOT NULL PRIMARY KEY,
  NomeEstado NVARCHAR(250) NOT NULL
);
GO

CREATE TABLE Programa
(
  IdPrograma INT NOT NULL PRIMARY KEY,
  NomePrograma NVARCHAR(250) NOT NULL
);
GO

CREATE TABLE Instituicao
(
  IdInstituicao INT NOT NULL PRIMARY KEY,
  NomeInstituicao NVARCHAR(250) NOT NULL
);
GO

CREATE TABLE DominioCientifico
(
  IdDominio INT NOT NULL PRIMARY KEY,
  NomeDominio NVARCHAR(250) NOT NULL
);
GO

CREATE TABLE AreaCientifica
(
  IdArea INT NOT NULL PRIMARY KEY,
  NomeArea NVARCHAR(250) NOT NULL
);
GO

CREATE TABLE PalavraChave
(
  IdPalavraChave INT NOT NULL PRIMARY KEY,
  PalavraChave NVARCHAR(250) NOT NULL
);
GO

CREATE TABLE Posicao
(
  IdPosicao INT NOT NULL PRIMARY KEY,
  NomePosicao NVARCHAR(250) NOT NULL
);
GO

CREATE TABLE Membro
(
  IdMembro INT NOT NULL PRIMARY KEY,
  TipoMembro NVARCHAR(250) NOT NULL,
  CONSTRAINT FK_Membro_Interno FOREIGN KEY (IdMembro) REFERENCES Interno(IdInterno),
  CONSTRAINT FK_Membro_Externo FOREIGN KEY (IdMembro) REFERENCES Externo(IdExterno)
);
GO

CREATE TABLE Orcid
(
  IdOrcid INT NOT NULL PRIMARY KEY,
  IdMembro INT NOT NULL,
  CONSTRAINT FK_Orcid_Membro FOREIGN KEY (IdMembro) REFERENCES Membro(IdMembro)
);
GO

CREATE TABLE Instituicao_Membro
(
  IdMembro INT NOT NULL,
  IdInstituicao INT NOT NULL,
  PRIMARY KEY (IdMembro, IdInstituicao),
  CONSTRAINT FK_Instituicao_Membro_Membro FOREIGN KEY (IdMembro) REFERENCES Membro(IdMembro),
  CONSTRAINT FK_Instituicao_Membro_Instituicao FOREIGN KEY (IdInstituicao) REFERENCES Instituicao(IdInstituicao)
);
GO

CREATE TABLE Financiamento
(
  IdFinanciamento INT NOT NULL PRIMARY KEY,
  Valor DECIMAL(15, 2) NOT NULL,
  TipoFinanciamento NVARCHAR(250) NOT NULL,
  OrigemFinanciamento NVARCHAR(250) NOT NULL,
  TipoFinanciador NVARCHAR(250) NOT NULL,
  IdProgramaouServico INT NOT NULL,
  CONSTRAINT FK_Financiamento_Instituicao FOREIGN KEY (IdProgramaouServico) REFERENCES Instituicao(IdInstituicao),
  CONSTRAINT FK_Financiamento_Programa FOREIGN KEY (IdProgramaouServico) REFERENCES Programa(IdPrograma)
);
GO

CREATE TABLE CustoElegivel
(
  IdCustoElegivel INT NOT NULL PRIMARY KEY,
  IdEquipa INT NOT NULL,
  IdProjeto INT NOT NULL,
  CustoEquipa DECIMAL(15, 2) NOT NULL,
  CustoProjeto DECIMAL(15, 2) NOT NULL,
  IdFinanciamento INT NOT NULL,
  CONSTRAINT FK_CustoElegivel_Financiamento FOREIGN KEY (IdFinanciamento) REFERENCES Financiamento(IdFinanciamento)
);
GO

CREATE TABLE Projeto
(
  IdProjeto INT NOT NULL PRIMARY KEY,
  NomeProjeto NVARCHAR(250) NOT NULL,
  Descricao NVARCHAR(MAX) NOT NULL,
  IdData INT NOT NULL,
  IdInstituicao INT NOT NULL,
  IdEstado INT NOT NULL,
  IdArea INT NOT NULL,
  IdDominio INT NOT NULL,
  IdMembro INT NOT NULL,
  IdCustoElegivel INT NOT NULL,
  CONSTRAINT FK_Projeto_DataInfo FOREIGN KEY (IdData) REFERENCES DataInfo(IdData),
  CONSTRAINT FK_Projeto_Instituicao FOREIGN KEY (IdInstituicao) REFERENCES Instituicao(IdInstituicao),
  CONSTRAINT FK_Projeto_Estado FOREIGN KEY (IdEstado) REFERENCES Estado(IdEstado),
  CONSTRAINT FK_Projeto_AreaCientifica FOREIGN KEY (IdArea) REFERENCES AreaCientifica(IdArea),
  CONSTRAINT FK_Projeto_DominioCientifico FOREIGN KEY (IdDominio) REFERENCES DominioCientifico(IdDominio),
  CONSTRAINT FK_Projeto_Membro FOREIGN KEY (IdMembro) REFERENCES Membro(IdMembro),
  CONSTRAINT FK_Projeto_CustoElegivel FOREIGN KEY (IdCustoElegivel) REFERENCES CustoElegivel(IdCustoElegivel)
);
GO

CREATE TABLE AssociarPalavraChave
(
  IdAssociacao INT NOT NULL PRIMARY KEY,
  IdProjeto INT NOT NULL,
  IdPalavraChave INT NOT NULL,
  CONSTRAINT FK_AssociarPalavraChave_Projeto FOREIGN KEY (IdProjeto) REFERENCES Projeto(IdProjeto),
  CONSTRAINT FK_AssociarPalavraChave_PalavraChave FOREIGN KEY (IdPalavraChave) REFERENCES PalavraChave(IdPalavraChave)
);
GO

CREATE TABLE Equipa
(
  IdEquipa INT NOT NULL PRIMARY KEY,
  IdMembro INT NOT NULL,
  IdProjeto INT NOT NULL,
  IdCustoElegivel INT NOT NULL,
  CONSTRAINT FK_Equipa_Membro FOREIGN KEY (IdMembro) REFERENCES Membro(IdMembro),
  CONSTRAINT FK_Equipa_Projeto FOREIGN KEY (IdProjeto) REFERENCES Projeto(IdProjeto),
  CONSTRAINT FK_Equipa_CustoElegivel FOREIGN KEY (IdCustoElegivel) REFERENCES CustoElegivel(IdCustoElegivel)
);
GO

CREATE TABLE PrestacaoServico
(
  IdPrestacaoServico INT NOT NULL PRIMARY KEY,
  NomePrestacaoServico NVARCHAR(250) NOT NULL,
  Descricao NVARCHAR(MAX) NOT NULL,
  IdInterno INT NOT NULL,
  IdData INT NOT NULL,
  IdEstado INT NOT NULL,
  IdFinanciamento INT NOT NULL,
  CONSTRAINT FK_PrestacaoServico_Interno FOREIGN KEY (IdInterno) REFERENCES Interno(IdInterno),
  CONSTRAINT FK_PrestacaoServico_DataInfo FOREIGN KEY (IdData) REFERENCES DataInfo(IdData),
  CONSTRAINT FK_PrestacaoServico_Estado FOREIGN KEY (IdEstado) REFERENCES Estado(IdEstado),
  CONSTRAINT FK_PrestacaoServico_Financiamento FOREIGN KEY (IdFinanciamento) REFERENCES Financiamento(IdFinanciamento)
);
GO

CREATE TABLE Atividade
(
  IdAtividade INT NOT NULL PRIMARY KEY,
  NomeAtividade NVARCHAR(250) NOT NULL,
  TipoAtividade NVARCHAR(250) NOT NULL,
  IdProjetoPrestacao  INT NOT NULL,
  CONSTRAINT FK_Atividade_Projeto FOREIGN KEY (IdProjetoPrestacao) REFERENCES Projeto(IdProjeto),
  CONSTRAINT FK_Atividade_PrestacaoServico FOREIGN KEY (IdProjetoPrestacao) REFERENCES PrestacaoServico(IdPrestacaoServico)
);
GO

CREATE TABLE PosicaoInterno
(
  IdPosicao INT NOT NULL,
  IdInterno INT NOT NULL,
  IdProjeto INT NOT NULL,
  PRIMARY KEY (IdPosicao, IdInterno, IdProjeto),
  CONSTRAINT FK_PosicaoInterno_Posicao FOREIGN KEY (IdPosicao) REFERENCES Posicao(IdPosicao),
  CONSTRAINT FK_PosicaoInterno_Interno FOREIGN KEY (IdInterno) REFERENCES Interno(IdInterno),
  CONSTRAINT FK_PosicaoInterno_Projeto FOREIGN KEY (IdProjeto) REFERENCES Projeto(IdProjeto)
);
GO

CREATE TABLE TempoAtividade
(
  IdMembro INT NOT NULL,
  TempoTrabalho DECIMAL(5, 2) NOT NULL,
  IdAtividade INT NOT NULL,
  PRIMARY KEY (IdMembro, IdAtividade),
  CONSTRAINT FK_TempoAtividade_Atividade FOREIGN KEY (IdAtividade) REFERENCES Atividade(IdAtividade)
);
GO

CREATE TABLE Publicacao
(
  IdPublicacao INT NOT NULL PRIMARY KEY,
  DOI NVARCHAR(100) NOT NULL,
  IdProjeto INT NOT NULL,
  IdInterno INT NOT NULL,
  IdData INT NOT NULL,
  CONSTRAINT FK_Publicacao_Projeto FOREIGN KEY (IdProjeto) REFERENCES Projeto(IdProjeto),
  CONSTRAINT FK_Publicacao_Interno FOREIGN KEY (IdInterno) REFERENCES Interno(IdInterno),
  CONSTRAINT FK_Publicacao_DataInfo FOREIGN KEY (IdData) REFERENCES DataInfo(IdData)
);
GO