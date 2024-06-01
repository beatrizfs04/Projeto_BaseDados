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

--------------------------Trigger Financiador---------------
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

----------------Trigger instituição e programa --------------
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

--------------Projeto e Prestacao Servico-----------------------------------

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

--delete

-- Gatilho de exclusão para a tabela Projeto
CREATE TRIGGER DeleteProjetoServico
ON Projeto
AFTER DELETE
AS
BEGIN
    DELETE FROM Projeto_Servico
    WHERE IdProjeto_Servico IN (SELECT IdProjeto FROM deleted);
END;
GO

-- Gatilho de exclusão para a tabela PrestacaoServico
CREATE TRIGGER DeletePrestacaoServico
ON PrestacaoServico
AFTER DELETE
AS
BEGIN
    DELETE FROM Projeto_Servico
    WHERE IdProjeto_Servico IN (SELECT IdPrestacaoServico FROM deleted);
END;
GO

---------------trigger tornar o interno líder de um projeto líder na tabela de posições---------------------------------
CREATE TRIGGER TRG_AssignProjectLeader
ON Projeto
AFTER INSERT
AS
BEGIN
    DECLARE @IdProjeto INT, @IdInterno INT

    -- Obter o IdProjeto e IdInterno do novo registro inserido na tabela Projeto
    SELECT @IdProjeto = IdProjeto, @IdInterno = IdInterno FROM inserted

    -- Verificar se o membro já é líder neste projeto
    IF NOT EXISTS (SELECT 1 FROM PosicaoInterno WHERE IdInterno = @IdInterno AND IdProjeto = @IdProjeto)
    BEGIN
        -- Inserir o membro como líder do projeto na tabela PosicaoInterno
        INSERT INTO PosicaoInterno (IdPosicao, IdInterno, IdProjeto)
        VALUES (1, @IdInterno, @IdProjeto) -- 1 representa a posição de líder
    END
END

---se o interno for atualizado:
CREATE TRIGGER TRG_UpdateProjectLeader
ON Projeto
AFTER UPDATE
AS
BEGIN
    DECLARE @IdProjeto INT, @OldIdInterno INT, @NewIdInterno INT

    -- Obter o IdProjeto, o IdInterno antigo e o novo IdInterno dos registros atualizados na tabela Projeto
    SELECT @IdProjeto = inserted.IdProjeto, 
           @NewIdInterno = inserted.IdInterno, 
           @OldIdInterno = deleted.IdInterno
    FROM inserted
    JOIN deleted ON inserted.IdProjeto = deleted.IdProjeto

    -- Se o IdInterno foi alterado
    IF @OldIdInterno <> @NewIdInterno
    BEGIN
        -- Atualizar a tabela PosicaoInterno para refletir a nova liderança
        UPDATE PosicaoInterno
        SET IdInterno = @NewIdInterno
        WHERE IdProjeto = @IdProjeto AND IdPosicao = 1
        
        -- Verificar se o novo líder já não é um líder em algum outro projeto
        IF NOT EXISTS (SELECT 1 FROM PosicaoInterno WHERE IdInterno = @NewIdInterno AND IdProjeto = @IdProjeto)
        BEGIN
            -- Atualizar o membro antigo como não sendo mais líder
            DELETE FROM PosicaoInterno WHERE IdInterno = @OldIdInterno AND IdProjeto = @IdProjeto AND IdPosicao = 1

            -- Inserir o novo líder do projeto na tabela PosicaoInterno
            INSERT INTO PosicaoInterno (IdPosicao, IdInterno, IdProjeto)
            VALUES (1, @NewIdInterno, @IdProjeto) -- 1 representa a posição de líder
        END
    END
END

-----------------Evitar que o valor da equipa e do projeto sejam maiores que o valor total------------

CREATE TRIGGER TRG_CheckCustoElegivelEquipa
ON CustoElegivelEquipa
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @IdFinanciamento INT
    DECLARE @TotalCusto DECIMAL(15, 2)
    DECLARE @ValorFinanciamento DECIMAL(15, 2)
    
    -- Obter o IdFinanciamento do registro inserido ou atualizado
    SELECT @IdFinanciamento = inserted.IdFinanciamento
    FROM inserted

    -- Calcular a soma de CustoEquipa e CustoProjeto para o financiamento específico
    SELECT @TotalCusto = ISNULL(
        (SELECT SUM(CustoEquipa) FROM CustoElegivelEquipa WHERE IdFinanciamento = @IdFinanciamento), 0) +
        ISNULL((SELECT SUM(CustoProjeto) FROM CustoElegivelProjeto WHERE IdFinanciamento = @IdFinanciamento), 0)
    
    -- Obter o valor total do financiamento específico
    SELECT @ValorFinanciamento = Valor FROM Financiamento WHERE IdFinanciamento = @IdFinanciamento

    -- Verificar se a soma dos custos não excede o valor do financiamento
    IF @TotalCusto > @ValorFinanciamento
    BEGIN
        -- Abortar a operação se a soma dos custos exceder o valor do financiamento
        RAISERROR('A soma dos custos excede o valor do financiamento.', 16, 1)
        ROLLBACK TRANSACTION
    END
END

CREATE TRIGGER TRG_CheckCustoElegivelProjeto
ON CustoElegivelProjeto
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @IdFinanciamento INT
    DECLARE @TotalCusto DECIMAL(15, 2)
    DECLARE @ValorFinanciamento DECIMAL(15, 2)
    
    -- Obter o IdFinanciamento do registro inserido ou atualizado
    SELECT @IdFinanciamento = inserted.IdFinanciamento
    FROM inserted

    -- Calcular a soma de CustoEquipa e CustoProjeto para o financiamento específico
    SELECT @TotalCusto = ISNULL(
        (SELECT SUM(CustoEquipa) FROM CustoElegivelEquipa WHERE IdFinanciamento = @IdFinanciamento), 0) +
        ISNULL((SELECT SUM(CustoProjeto) FROM CustoElegivelProjeto WHERE IdFinanciamento = @IdFinanciamento), 0)
    
    -- Obter o valor total do financiamento específico
    SELECT @ValorFinanciamento = Valor FROM Financiamento WHERE IdFinanciamento = @IdFinanciamento

    -- Verificar se a soma dos custos não excede o valor do financiamento
    IF @TotalCusto > @ValorFinanciamento
    BEGIN
        -- Abortar a operação se a soma dos custos exceder o valor do financiamento
        RAISERROR('A soma dos custos excede o valor do financiamento.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
