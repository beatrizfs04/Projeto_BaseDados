USE DIUBI;


CREATE TABLE Pessoa
(
  IdPessoa INT NOT NULL,
  PrimeiroNome VARCHAR(250),
  UltimoNome VARCHAR(250),
  Email VARCHAR(250) NOT NULL,
  Telefone VARCHAR(20),
  PRIMARY KEY (IdPessoa)
);

CREATE TABLE Interno
(
  IdInterno INT NOT NULL,
  IdPessoa INT NOT NULL,
  PRIMARY KEY (IdInterno),
  FOREIGN KEY (IdPessoa) REFERENCES Pessoa(IdPessoa)
);

CREATE TABLE Externo
(
  IdExterno INT NOT NULL,
  IdPessoa INT NOT NULL,
  PRIMARY KEY (IdExterno),
  FOREIGN KEY (IdPessoa) REFERENCES Pessoa(IdPessoa)
);

CREATE TABLE Projeto_Servico
(
  IdProjeto_Servico INT NOT NULL,
  TipoProjeto_Servico VARCHAR(50) NOT NULL, 
  PRIMARY KEY (IdProjeto_Servico, TipoProjeto_Servico)
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
  NacionalidadeInstituicao VARCHAR(250) NOT NULL,
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

CREATE TABLE Financiador
(
  IdFinanciador INT NOT NULL,
  TipoFinanciador VARCHAR(50) NOT NULL, 
  PRIMARY KEY (IdFinanciador, TipoFinanciador)
);

CREATE TABLE Membro
(
  IdMembro INT NOT NULL,
  IdPessoa INT NOT NULL,
  TipoMembro VARCHAR(250) NOT NULL,
  PRIMARY KEY (IdMembro),
  FOREIGN KEY (IdPessoa) REFERENCES Pessoa(IdPessoa)
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
  IdFinanciador INT NOT NULL,
  TipoFinanciador VARCHAR(50) NOT NULL, 
  IdProjeto_Servico INT NOT NULL,
  TipoProjeto_Servico VARCHAR(50) NOT NULL, 
  PRIMARY KEY (IdFinanciamento),
  FOREIGN KEY (IdProjeto_Servico, TipoProjeto_Servico) REFERENCES Projeto_Servico(IdProjeto_Servico, TipoProjeto_Servico),
  FOREIGN KEY (IdFinanciador, TipoFinanciador) REFERENCES Financiador(IdFinanciador, TipoFinanciador)
);

CREATE TABLE Projeto
(
  IdProjeto INT NOT NULL,
  NomeProjeto VARCHAR(250) NOT NULL,
  Descricao VARCHAR(250) NOT NULL,
  IdData INT NOT NULL,
  IdInstituicao INT NOT NULL,
  IdEstado INT NOT NULL,
  IdArea INT NOT NULL,
  IdDominio INT NOT NULL,
  IdMembro INT NOT NULL,
  PRIMARY KEY (IdProjeto),
  FOREIGN KEY (IdData) REFERENCES DataInfo(IdData),
  FOREIGN KEY (IdInstituicao) REFERENCES Instituicao(IdInstituicao),
  FOREIGN KEY (IdEstado) REFERENCES Estado(IdEstado),
  FOREIGN KEY (IdArea) REFERENCES AreaCientifica(IdArea),
  FOREIGN KEY (IdDominio) REFERENCES DominioCientifico(IdDominio),
  FOREIGN KEY (IdMembro) REFERENCES Membro(IdMembro)
);

CREATE TABLE Equipa
(
  IdEquipa INT NOT NULL,
  IdMembro INT NOT NULL,
  IdProjeto INT NOT NULL,
  PRIMARY KEY (IdEquipa),
  FOREIGN KEY (IdMembro) REFERENCES Membro(IdMembro),
  FOREIGN KEY (IdProjeto) REFERENCES Projeto(IdProjeto)
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
  FOREIGN KEY (IdFinanciamento) REFERENCES Financiamento(IdFinanciamento),
  FOREIGN KEY (IdEquipa) REFERENCES Equipa(IdEquipa),
  FOREIGN KEY (IdProjeto) REFERENCES Projeto(IdProjeto)
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
  IdProjeto_Servico  INT NOT NULL,
  TipoProjeto_Servico VARCHAR(50) NOT NULL, 
  PRIMARY KEY (IdAtividade),
  FOREIGN KEY (IdProjeto_Servico, TipoProjeto_Servico) REFERENCES Projeto_Servico(IdProjeto_Servico, TipoProjeto_Servico)
);

CREATE TABLE TempoAtividade
(
  IdMembro INT NOT NULL,
  TempoTrabalho DECIMAL(5, 2) NOT NULL,
  IdAtividade INT NOT NULL,
  PRIMARY KEY (IdMembro, IdAtividade),
  FOREIGN KEY (IdAtividade) REFERENCES Atividade(IdAtividade)
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


