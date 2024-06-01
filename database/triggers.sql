/* create trigger [trigger_name] 

[before | after]  

{insert | update | delete}  

on [table_name]  

[for each row]  

[trigger_body] */

-- Em cada projeto existe um investigador responsável (IR) que deve exercer essa função
--a 35% do seu tempo, o sistema deve assegurar a consistência dos dados na base de dados. 

--De modo a impedir atribuições indevidas nenhum membro da equipa de investigação pode ficar com uma
--percentagem de alocação a projetos nacionais superior a 100% 

--sendo também considerada para os membros da equipa de investigação a percentagem mínima de tempo de dedicação de 15%.

----trigger inserir Tabela Pessoa, Membro, Interno, Externo---------------------
CREATE PROCEDURE InserirPessoa 
(
    @PrimeiroNome VARCHAR(250),
    @UltimoNome VARCHAR(250),
    @Email VARCHAR(250),
    @Telefone VARCHAR(20),
    @TipoMembro VARCHAR(250)
)
AS
BEGIN
    DECLARE @newIdPessoa INT;
    
    -- Insere a pessoa
    INSERT INTO Pessoa (PrimeiroNome, UltimoNome, Email, Telefone)
    VALUES (@PrimeiroNome, @UltimoNome, @Email, @Telefone);
    
    -- Obtém o ID da pessoa recém-inserida
    SET @newIdPessoa = SCOPE_IDENTITY();
    
    -- Insere no Interno ou Externo baseado no tipo de membro
    IF @TipoMembro = 'Interno'
    BEGIN
        INSERT INTO Interno (IdPessoa) VALUES (@newIdPessoa);
    END
    ELSE IF @TipoMembro = 'Externo'
    BEGIN
        INSERT INTO Externo (IdPessoa) VALUES (@newIdPessoa);
    END
END
GO

CREATE TRIGGER after_interno_insert
ON Interno
AFTER INSERT
AS
BEGIN
    DECLARE @newIdInterno INT;
    DECLARE @newIdPessoa INT;
    
    -- Define o ID do membro como o ID do interno recém-inserido
    SELECT @newIdInterno = IdInterno, @newIdPessoa = IdPessoa FROM inserted;
    
    -- Insere na tabela Membro
    INSERT INTO Membro (IdPessoa, TipoMembro)
    VALUES (@newIdPessoa, 'Interno');
END
GO

CREATE TRIGGER after_externo_insert
ON Externo
AFTER INSERT
AS
BEGIN
    DECLARE @newIdExterno INT;
    DECLARE @newIdPessoa INT;
    
    -- Define o ID do membro como o ID do externo recém-inserido
    SELECT @newIdExterno = IdExterno, @newIdPessoa = IdPessoa FROM inserted;
    
    -- Insere na tabela Membro
    INSERT INTO Membro (IdPessoa, TipoMembro)
    VALUES (@newIdPessoa, 'Externo');
END
GO

-----------remover triggers-----------------------
--DROP TRIGGER IF EXISTS after_interno_insert;
--DROP TRIGGER IF EXISTS after_externo_insert;
--GO

--------------------------trigger Financiador---------------
CREATE TRIGGER after_instituicao_insert
ON Instituicao
AFTER INSERT
AS
BEGIN
    DECLARE @newIdFinanciador INT;

    -- Insere na tabela Financiador automaticamente
    INSERT INTO Financiador (IdFinanciador, TipoFinanciador)
    VALUES (SCOPE_IDENTITY(), 'Instituicao');
END

CREATE TRIGGER after_programa_insert
ON Programa
AFTER INSERT
AS
BEGIN
    DECLARE @newIdFinanciador INT;

    -- Insere na tabela Financiador automaticamente
    INSERT INTO Financiador (IdFinanciador, TipoFinanciador)
    VALUES (SCOPE_IDENTITY(), 'Programa');
END

----------------trigger instituição e programa --------------
-- Criação da sequência para gerar IDs únicos para financiadores
CREATE SEQUENCE FinanciadorIdSequence
    START WITH 1
    INCREMENT BY 1;

-- Gatilho para inserção de novas instituições
CREATE TRIGGER InsertInstituicaoFinanciador
ON Instituicao
AFTER INSERT
AS
BEGIN
    DECLARE @IdInstituicao INT;
    DECLARE insert_cursor CURSOR FOR
    SELECT IdInstituicao FROM inserted;

    OPEN insert_cursor;
    FETCH NEXT FROM insert_cursor INTO @IdInstituicao;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO Financiador (IdFinanciador, TipoFinanciador)
        VALUES (@IdInstituicao, 'Instituição');

        FETCH NEXT FROM insert_cursor INTO @IdInstituicao;
    END;

    CLOSE insert_cursor;
    DEALLOCATE insert_cursor;
END;

-- Gatilho para inserção de novos programas
CREATE TRIGGER InsertProgramaFinanciador
ON Programa
AFTER INSERT
AS
BEGIN
    DECLARE @IdPrograma INT;
    DECLARE insert_cursor CURSOR FOR
    SELECT IdPrograma FROM inserted;

    OPEN insert_cursor;
    FETCH NEXT FROM insert_cursor INTO @IdPrograma;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO Financiador (IdFinanciador, TipoFinanciador)
        VALUES (@IdPrograma, 'Programa');

        FETCH NEXT FROM insert_cursor INTO @IdPrograma;
    END;

    CLOSE insert_cursor;
    DEALLOCATE insert_cursor;
END;

-----delete part!

-- Gatilho para exclusão de programas na tabela Programa
CREATE TRIGGER DeleteFinanciadorPrograma
ON Programa
AFTER DELETE
AS
BEGIN
    DECLARE @IdPrograma INT;
    SELECT TOP 1 @IdPrograma = IdPrograma FROM deleted;

    DELETE FROM Financiador WHERE IdFinanciador = @IdPrograma;
END;
GO


-- Gatilho para exclusão de instituições na tabela Instituicao
CREATE TRIGGER DeleteFinanciadorInstituicao
ON Instituicao
AFTER DELETE
AS
BEGIN
    DECLARE @IdInstituicao INT;
    SELECT TOP 1 @IdInstituicao = IdInstituicao FROM deleted;

    DELETE FROM Financiador WHERE IdFinanciador = @IdInstituicao;
END;


----------------------------------------------------------------------------

--------------Projeto e Prestacao Servico------------------------------------

-- Gatilho para inserção de projetos e prestação de serviços na tabela Projeto_Servico
CREATE TRIGGER InsertProjetoServico
ON Projeto
AFTER INSERT
AS
BEGIN
    DECLARE @IdProjeto INT;
    DECLARE insert_cursor CURSOR FOR
    SELECT IdProjeto FROM inserted;

    OPEN insert_cursor;
    FETCH NEXT FROM insert_cursor INTO @IdProjeto;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO Projeto_Servico (IdProjeto_Servico, TipoProjeto_Servico)
        VALUES (@IdProjeto, 'Projeto');

        FETCH NEXT FROM insert_cursor INTO @IdProjeto;
    END;

    CLOSE insert_cursor;
    DEALLOCATE insert_cursor;
END;

CREATE TRIGGER InsertProjetoServico_PrestacaoServico
ON PrestacaoServico
AFTER INSERT
AS
BEGIN
    DECLARE @IdPrestacaoServico INT;
    DECLARE insert_cursor CURSOR FOR
    SELECT IdPrestacaoServico FROM inserted;

    OPEN insert_cursor;
    FETCH NEXT FROM insert_cursor INTO @IdPrestacaoServico;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO Projeto_Servico (IdProjeto_Servico, TipoProjeto_Servico)
        VALUES (@IdPrestacaoServico, 'PrestacaoServico');

        FETCH NEXT FROM insert_cursor INTO @IdPrestacaoServico;
    END;

    CLOSE insert_cursor;
    DEALLOCATE insert_cursor;
END;

----------------------------------------------------------------------------