----não usar esse insert value para pessoa
INSERT INTO Pessoa (IdPessoa, PrimeiroNome, UltimoNome, Email, Telefone) VALUES
(1, 'João', 'Silva', 'joao.silva@example.com', '123456789'),
(2, 'Maria', 'Oliveira', 'maria.oliveira@example.com', '987654321');
(3, 'Rafael', 'Santos', 'rafael.santos@gmail.com', '145236897');

----usar esses comandos para inserir (temporariamente a ser adaptado na interface)
EXEC InserirPessoa 'João', 'Silva', 'joao.silva@example.com', '123456789', 'Interno';
EXEC InserirPessoa 'Maria', 'Oliveira', 'maria.oliveira@example.com', '987654321', 'Interno';

INSERT INTO Interno (IdInterno, IdPessoa) VALUES
(1, 1),
(2, 2);

INSERT INTO Externo (IdExterno, IdPessoa) VALUES
(1, 3);  

INSERT INTO Membro (IdMembro, IdPessoa, TipoMembro) VALUES
(1, 1, 'Interno'),
(2, 2, 'Interno'),
(3, 3, 'Externo');

INSERT INTO Projeto_Servico (IdProjeto_Servico, TipoProjeto_Servico) VALUES
(1, 'Servico'),
(2, 'Projeto');

INSERT INTO DataInfo (IdData, DataInicio, DataFim) VALUES
(1, '2023-01-01', '2023-12-31'),
(2, '2024-01-01', '2024-12-31');

INSERT INTO Estado (IdEstado, NomeEstado) VALUES
(1, 'Aprovado'),
(2, 'Cancelado'),
(3, 'Concluído'),
(4, 'Em curso'),
(5, 'Encerrado'),
(6, 'Renovado'),
(7, 'Em submissão');

INSERT INTO Programa (IdPrograma, NacionalidadePrograma, NomePrograma) VALUES
(1,'Portugal', 'Programa A'),
(2,'Espanha', 'Programa B');

INSERT INTO Instituicao (IdInstituicao, NomeInstituicao, NacionalidadeInstituicao) VALUES
(1, 'Universidade da Beira Interior', 'Portugal'),
(2, 'Universidade de Aveiro', 'Portugal'),
(3, 'Fundação Gulbenkian', 'Portugal'),
(4, 'Universidade Complutense de Madrid', 'Espanha');

INSERT INTO DominioCientifico (IdDominio, NomeDominio) VALUES
(1, 'Ciências Naturais'),
(2, 'Engenharia');

INSERT INTO AreaCientifica (IdArea, NomeArea) VALUES
(1, 'Biologia'),
(2, 'Computação');

INSERT INTO PalavraChave (IdPalavraChave, PalavraChave) VALUES
(1, 'Inteligência Artificial'),
(2, 'Sustentabilidade');

---- trigger para quando um membro é metido no projeto, automaticamente seja classificado com líder do projeto
INSERT INTO Posicao (IdPosicao, NomePosicao) VALUES
(1, 'Líder'),
(2, 'Promotor'),
(3, 'Copromotor'),
(4, 'Participante');

INSERT INTO Financiador (IdFinanciador, TipoFinanciador) VALUES
(1, 'Instituição'),
(2, 'Programa');

----FALTA
INSERT INTO Projeto (IdProjeto, NomeProjeto, Descricao, IdData, IdInstituicao, IdEstado, IdArea, IdDominio, IdInterno) VALUES
(1, 'Projeto Alpha', 'Pesquisa sobre sustentabilidade', 1, 1, 1, 1, 1, 1),
(2, 'Projeto Beta', 'Desenvolvimento de IA', 2, 2, 6, 2, 2, 2);

--INSERT INTO Financiamento (IdFinanciamento, Valor, TipoFinanciamento, OrigemFinanciamento, IdFinanciador, TipoFinanciador, IdProjeto_Servico, TipoProjeto_Servico) VALUES
--(1, 1000.00, 'Não Competitivo', 'Interno', 1, 'Instituicao', 1, 'Servico'),
--(2, 2000.00, 'Competitivo', 'Externo', 1, 'Programa', 2, 'Projeto'),
--(3, 200.00, 'Competitivo', 'Externo', 1, 'Programa', 2, 'Projeto');

INSERT INTO Financiamento (IdFinanciamento, Valor, TipoFinanciamento, OrigemFinanciamento, IdFinanciador, TipoFinanciador) VALUES
(1, 1000.00, 'Não Competitivo', 'Interno', 1, 'Instituicao'),
(2, 2000.00, 'Competitivo', 'Externo', 1, 'Programa'),
(3, 200.00, 'Competitivo', 'Externo', 1, 'Programa');

EXEC InserirFinanciamento 
    @Valor = 5000.00, 
    @TipoFinanciamento = 'Competitivo', 
    @OrigemFinanciamento = 'Externo', 
    @IdFinanciador = 1, 
    @TipoFinanciador = 'Instituicao', 
    @IdProjeto_Servico = 1, 
    @TipoProjeto_Servico = 'Projeto';

INSERT INTO Equipa (IdEquipa, IdProjeto) VALUES
(1, 1),

INSERT INTO Equipa_Membro (IdEquipa, IdMembro) VALUES
(1, 1)

INSERT INTO CustoElegivelEquipa (IdCustoElegivelEquipa, IdEquipa, CustoEquipa, IdFinanciamento) VALUES
(1, 1, 600.00, 2),
(2, 2, 1000.00, 2);

INSERT INTO CustoElegivelProjeto (IdCustoElegivelProjeto, IdProjeto, CustoProjeto, IdFinanciamento) VALUES
(1, 1, 400.00, 1),
(2, 2, 10000.00, 2);

INSERT INTO AssociarPalavraChave (IdAssociacao, IdProjeto, IdPalavraChave) VALUES
(1, 1, 2),  
(2, 2, 1);  

INSERT INTO PrestacaoServico (IdPrestacaoServico, NomePrestacaoServico, Descricao, IdInterno, IdData, IdEstado) VALUES
(1, 'Consultoria Ambiental', 'Serviço de consultoria em práticas sustentáveis', 1, 1, 1),
(2, 'Desenvolvimento de Software', 'Serviço de desenvolvimento de aplicações de IA', 2, 2, 2);

INSERT INTO Atividade (IdAtividade, NomeAtividade, TipoAtividade, IdProjeto_Servico, TipoProjeto_Servico) VALUES
(1, 'Pesquisa de Campo', 'Pesquisa', 1, 'Servico'),
(2, 'Desenvolvimento de Algoritmo', 'Desenvolvimento', 2, 'Projeto');

INSERT INTO TempoAtividade (IdMembro, TempoTrabalho, IdAtividade) 
VALUES (10, DATEADD(HOUR, 500, '00:00:00'), 10);

INSERT INTO PosicaoInterno (IdPosicao, IdInterno, IdProjeto) VALUES
(1, 1, 1),  -- João (Interno) no Projeto Alpha como Líder
(2, 2, 2);  -- Maria (Interno) no Projeto Beta como Promotor

INSERT INTO Publicacao (IdPublicacao, DOI, IdProjeto, IdInterno, IdData) VALUES
(1, '10.1234/abcd.2023.001', 1, 1, 1), --publicação feita pelo joão sobre o projeto alpha
(2, '10.1234/abcd.2024.002', 2, 2, 2); -- publicação feita pela maria sobre o projeto beta










