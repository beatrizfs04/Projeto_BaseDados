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

-----------remover triggers-----------------------
--DROP TRIGGER IF EXISTS after_interno_insert;
--DROP TRIGGER IF EXISTS after_externo_insert;
--GO

----Trigger inserir Tabela Pessoa, Membro, Interno, Externo---------------------OK
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


--------------------------Trigger Financiador---------------
--aqui sempre que adiciono uma instituição ou um programa, automáticamente cria um financiador
CREATE TRIGGER after_programa_insert
ON Programa
AFTER INSERT
AS
BEGIN
    DECLARE @newId INT;
    
    -- Obtém o ID do programa recém-inserido
    SELECT @newId = IdPrograma FROM inserted;

    -- Insere na tabela Financiador
    INSERT INTO Financiador (IdFinanciador, TipoFinanciador)
    VALUES (@newId, 'Programa');
END
GO

CREATE TRIGGER after_instituicao_insert
ON Instituicao
AFTER INSERT
AS
BEGIN
    DECLARE @newId INT;
    
    -- Obtém o ID da instituição recém-inserida
    SELECT @newId = IdInstituicao FROM inserted;

    -- Insere na tabela Financiador
    INSERT INTO Financiador (IdFinanciador, TipoFinanciador)
    VALUES (@newId, 'Instituicao');
END
GO

---delete part!
CREATE TRIGGER after_instituicao_insert
ON Instituicao
AFTER INSERT
AS
BEGIN
    DECLARE @newId INT;
    
    -- Obtém o ID da instituição recém-inserida
    SELECT @newId = IdInstituicao FROM inserted;

    -- Insere na tabela Financiador
    INSERT INTO Financiador (IdFinanciador, TipoFinanciador)
    VALUES (@newId, 'Instituicao');
END
GO


--------------Projeto e Prestacao Servico-----------------------------------
--mesmo esquema, sempre que insiro um projeto ou prestacao de serviço gera um id e tipo na tabela projeto-servico
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

--Delete
-- Gatilho de exclusão para a tabela Projeto
CREATE TRIGGER DeleteProjetoServico
ON Projeto
AFTER DELETE
AS
BEGIN
    DELETE FROM Projeto_Servico
    WHERE IdProjeto_Servico IN (SELECT IdProjeto FROM deleted)
    AND TipoProjeto_Servico = 'Projeto';
END;
GO

-- Gatilho de exclusão para a tabela PrestacaoServico
CREATE TRIGGER DeletePrestacaoServico
ON PrestacaoServico
AFTER DELETE
AS
BEGIN
    DELETE FROM Projeto_Servico
    WHERE IdProjeto_Servico IN (SELECT IdPrestacaoServico FROM deleted)
    AND TipoProjeto_Servico = 'PrestacaoServico';
END;
GO

-----------------------Trigger Financiamento-------------
------agora sempre que um financiamento é inserido, é necessário referenciar o projeto 
--ou prestacao de serviço ao qual ele será associado e insere automáticamente na tabela 
--Financiamento_Projeto_PrestacaoServico

USE DIUBI;
GO

CREATE PROCEDURE InserirFinanciamento
    @Valor DECIMAL(15, 2),
    @TipoFinanciamento VARCHAR(250),
    @OrigemFinanciamento VARCHAR(250),
    @IdFinanciador INT,
    @TipoFinanciador VARCHAR(50),
    @IdProjeto_Servico INT,
    @TipoProjeto_Servico VARCHAR(50)
AS
BEGIN
    DECLARE @IdFinanciamento INT;

    -- Inserir na tabela Financiamento
    INSERT INTO Financiamento (Valor, TipoFinanciamento, OrigemFinanciamento, IdFinanciador, TipoFinanciador)
    VALUES (@Valor, @TipoFinanciamento, @OrigemFinanciamento, @IdFinanciador, @TipoFinanciador);

    -- Obter o último IdFinanciamento inserido
    SET @IdFinanciamento = SCOPE_IDENTITY();

    -- Inserir na tabela Financiamento_Projeto_PrestacaoServico
    INSERT INTO Financiamento_Projeto_PrestacaoServico (IdFinanciamento, IdProjeto_Servico, TipoProjeto_Servico)
    VALUES (@IdFinanciamento, @IdProjeto_Servico, @TipoProjeto_Servico);
END;
GO

EXEC InserirFinanciamento 
    @Valor = 5000.00, 
    @TipoFinanciamento = 'Competitivo', 
    @OrigemFinanciamento = 'Externo', 
    @IdFinanciador = 1, 
    @TipoFinanciador = 'Instituicao', 
    @IdProjeto_Servico = 1, 
    @TipoProjeto_Servico = 'Projeto';


USE DIUBI;
GO

-- Verificar se o trigger já existe e, se sim, removê-lo
IF OBJECT_ID('TR_DeleteFinanciamento', 'TR') IS NOT NULL
    DROP TRIGGER TR_DeleteFinanciamento;
GO

-- Criar o trigger para deletar registros na tabela Financiamento_Projeto_PrestacaoServico
USE DIUBI;
GO

-- Verificar se o trigger já existe e, se sim, removê-lo
IF OBJECT_ID('TR_InsteadOfDeleteFinanciamento', 'TR') IS NOT NULL
    DROP TRIGGER TR_InsteadOfDeleteFinanciamento;
GO

-- Criar o trigger INSTEAD OF DELETE para deletar registros na tabela Financiamento_Projeto_PrestacaoServico
CREATE TRIGGER TR_InsteadOfDeleteFinanciamento
ON Financiamento
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Deletar os registros da tabela Financiamento_Projeto_PrestacaoServico
    DELETE FROM Financiamento_Projeto_PrestacaoServico
    WHERE IdFinanciamento IN (SELECT IdFinanciamento FROM DELETED);

    -- Deletar os registros da tabela Financiamento
    DELETE FROM Financiamento
    WHERE IdFinanciamento IN (SELECT IdFinanciamento FROM DELETED);
END;
GO


-----------------Evitar que o valor da equipa e do projeto sejam maiores que o valor total------------

CREATE OR ALTER TRIGGER VerificarCustos
ON CustoElegivelEquipa
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @TotalCustoEquipa DECIMAL(15, 2);
    DECLARE @TotalCustoProjeto DECIMAL(15, 2);
    DECLARE @IdFinanciamento INT;

    -- Calcular o total do custo da equipe
    SELECT @TotalCustoEquipa = SUM(CustoEquipa)
    FROM CustoElegivelEquipa
    WHERE IdFinanciamento = (SELECT IdFinanciamento FROM inserted);

    -- Calcular o total do custo do projeto
    SELECT @TotalCustoProjeto = SUM(CustoProjeto)
    FROM CustoElegivelProjeto
    WHERE IdFinanciamento = (SELECT IdFinanciamento FROM inserted);

    -- Obter o valor total do financiamento
    SELECT @IdFinanciamento = IdFinanciamento
    FROM inserted;

    DECLARE @ValorFinanciamento DECIMAL(15, 2);

    SELECT @ValorFinanciamento = Valor
    FROM Financiamento
    WHERE IdFinanciamento = @IdFinanciamento;

    -- Verificar se a soma dos custos excede o valor do financiamento
    IF (@TotalCustoEquipa + @TotalCustoProjeto) > @ValorFinanciamento
    BEGIN
        RAISEERROR('A soma dos custos excede o valor total do financiamento.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;

---agora preciso de um trigger para garantir que a equipa de um projeto não use o 
--custo elegivel (idfinanciamento) associado a outro projeto!!

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
