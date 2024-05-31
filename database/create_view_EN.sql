USE DIUBI;
GO 

CREATE View Person AS 
SELECT 
    IdPessoa as PersonId,
    PrimeiroNome as FirstName, 
    UltimoNome as LastName, 
    Email, 
    Telefone as Phone
FROM
    Pessoa;
GO

CREATE View InternalMember AS 
SELECT 
    IdInterno as InternalId, 
    IdPessoa as PersonId
FROM
    Interno;
GO

CREATE View ExternalMember AS 
SELECT 
    IdExterno as ExternalId, 
    IdPessoa as PersonId
FROM
    Externo;
GO

CREATE View ProjectorService AS 
SELECT 
    IdProjeto_Servico as ProjectOrServiceID, 
    TipoProjeto_Servico  as ProjectOrServiceType
FROM
    Projeto_Servico;
GO

CREATE View DateInfo AS 
SELECT 
    IdData as DateId, 
    DataInicio as StartDate, 
    DataFim as EndDate
FROM
    DataInfo;
GO

CREATE View State AS 
SELECT 
    IdEstado as StateId, 
    NomeEstado as StateName
FROM
    Estado;
GO

CREATE View Program AS 
SELECT 
    IdPrograma as ProgramId, 
    NomePrograma as ProgramName 
FROM
    Programa;
GO

CREATE View Institution AS 
SELECT 
    IdInstituicao as InstitutionID, 
    NomeInstituicao as InstitutionName, 
    NacionalidadeInstituicao as InstitutionNationality 
FROM
    Instituicao;
GO

CREATE View ScientificDomain AS 
SELECT 
    IdDominio as DomainID, 
    NomeDominio as DomainName 
FROM
    DominioCientifico;
GO

CREATE View ScientificArea AS 
SELECT 
    IdArea as AreaID, 
    NomeArea as AreaName 
FROM
    AreaCientifica;
GO

CREATE View Keyword AS 
SELECT 
    IdPalavraChave as KeywordID, 
    PalavraChave as Keyword
FROM
    PalavraChave;
GO

CREATE View PositionInfo AS 
SELECT 
    IdPosicao as PositionID, 
    NomePosicao as PositionName 
FROM
    Posicao;
GO

CREATE View Financier AS 
SELECT 
    IdFinanciador as FinancierId, 
    TipoFinanciador as FinancierType 
FROM
    Financiador;
GO


CREATE View Member AS 
SELECT 
    IdMembro as MemberID, 
    IdPessoa as PersonId,
    TipoMembro as MemberType 
FROM
    Membro;
GO

CREATE View OrcidInfo AS 
SELECT 
    IdOrcid as OrcidID, 
    IdMembro as MemberID
FROM
    Orcid;
GO

CREATE View Institution_Member AS 
SELECT 
    IdMembro as MemberID, 
    IdInstituicao as InstitutionID
FROM
    Instituicao_Membro;
GO

CREATE View Funding AS 
SELECT 
    IdFinanciamento as FundingID, 
    Valor as Amount, 
    TipoFinanciamento as FundingType, 
    OrigemFinanciamento as FundingSource, 
    TipoFinanciador as FunderType, 
    IdProjeto_Servico as ProjectOrServiceID
FROM
    Financiamento;
GO

CREATE View EligibleCost AS 
SELECT 
    IdCustoElegivel as EligibleCostID, 
    IdEquipa as TeamID, 
    IdProjeto as ProjectID, 
    CustoEquipa as TeamCost, 
    CustoProjeto as ProjectCost, 
    IdFinanciamento as FundingID
FROM
    CustoElegivel;
GO

CREATE View Project AS 
SELECT 
    IdProjeto as ProjectID, 
    NomeProjeto as ProjectName, 
    Descricao as Description, 
    IdData as DateID, 
    IdInstituicao as InstitutionID, 
    IdEstado as StateID, 
    IdArea as AreaID, 
    IdDominio as DomainID, 
    IdMembro as MemberID 
FROM
    Projeto;
GO

CREATE View KeywordAssignment AS 
SELECT 
    IdAssociacao as AssignmentID, 
    IdProjeto as ProjectID, 
    IdPalavraChave as KeywordID
FROM
    AssociarPalavraChave;
GO

CREATE View Team AS 
SELECT 
    IdEquipa as TeamID, 
    IdMembro as MemberID, 
    IdProjeto as ProjectID 
FROM
    Equipa;
GO

CREATE View ServiceProvision AS 
SELECT 
    IdPrestacaoServico as ServiceProvisionID, 
    NomePrestacaoServico as ServiceProvisionName, 
    Descricao as Description, 
    IdInterno as InternalId, 
    IdData as DateID, 
    IdEstado as StateID, 
    IdFinanciamento as FundingID
FROM
    PrestacaoServico;
GO

CREATE View Activity AS 
SELECT 
    IdAtividade as ActivityID, 
    NomeAtividade as ActivityName, 
    TipoAtividade as ActivityType, 
    IdProjeto_Servico AS ProjectServiceID,
    TipoProjeto_Servico AS ProjectServiceType
FROM
    Atividade;
GO

CREATE View InternalMemberPosition AS 
SELECT 
    IdPosicao as PositionID, 
    IdInterno as InternalId, 
    IdProjeto as ProjectID
FROM
    PosicaoInterno;
GO

CREATE View ActivityTime AS 
SELECT 
    IdMembro as MemberID, 
    TempoTrabalho as WorkTime, 
    IdAtividade as ActivityID
FROM
    TempoAtividade;
GO

CREATE View Publication AS 
SELECT 
    IdPublicacao as PublicationID, 
    DOI as DOI, 
    IdProjeto as ProjectID, 
    IdInterno as InternalID, 
    IdData as DateID
FROM
    Publicacao;
GO




