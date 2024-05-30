USE DIUBI;
GO 

CREATE View Internal AS 
SELECT 
    PrimeiroNome as FirstName, 
    UltimoNome as LastName, 
    Email, 
    Telefone as Phone, 
FROM
    Interno;
GO

CREATE View External AS 
SELECT 
    PrimeiroNome as FirstName, 
    UltimoNome as LastName, 
    Email, 
    Telefone as Phone, 
FROM
    Externo;
GO

CREATE View DateInfo AS 
SELECT 
    IdData as DateId, 
    DataInicio as StartDate, 
    DataFim as EndDate, 
FROM
    DataInfo;
GO

CREATE View DateInfo AS 
SELECT 
    IdData as DateId, 
    DataInicio as StartDate, 
    DataFim as EndDate, 
FROM
    DataInfo;
GO

CREATE View State AS 
SELECT 
    IdEstado as StateId, 
    NomeEstado as StateName, 
FROM
    Estado;
GO

CREATE View Program AS 
SELECT 
    IdPrograma as ProgramId, 
    NomePrograma as ProgramName , 
FROM
    Programa;
GO

CREATE View Institution AS 
SELECT 
    IdInstituicao as InstitutionID, 
    NomeInstituicao as InstitutionName, 
FROM
    Instituicao;
GO

CREATE View ScientificDomain AS 
SELECT 
    IdDominio as DomainID , 
    NomeDominio as DomainName , 
FROM
    DominioCientifico;
GO

CREATE View ScientificArea AS 
SELECT 
    IdArea as AreaID, 
    NomeArea as AreaName, 
FROM
    AreaCientifica;
GO

CREATE View Keyword AS 
SELECT 
    IdPalavraChave as KeywordID, 
    PalavraChave as Keyword, 
FROM
    PalavraChave;
GO

CREATE View PositionInfo AS 
SELECT 
    IdPosicao as PositionID, 
    NomePosicao as PositionName, 
FROM
    Posicao;
GO

CREATE View Member AS 
SELECT 
    IdMembro as MemberID, 
    TipoMembro as MemberType, 
FROM
    Membro;
GO

CREATE View Orcid AS 
SELECT 
    IdOrcid as OrcidID, 
    IdMembro as MemberID, 
FROM
    Orcid;
GO

CREATE View Institution_Member AS 
SELECT 
    IdMembro as MemberID, 
    IdInstituicao as InstitutionID, 
FROM
    Instituicao_Membro;
GO


