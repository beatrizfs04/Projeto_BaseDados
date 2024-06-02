----busca o valor total de tempo já dedicado de um mebro a todos os projetos envolvidos
SELECT 
    m.IdMembro,
    m.TipoMembro,
    SUM(DATEDIFF(MINUTE, '00:00', ta.TempoTrabalho)) AS TempoTotalMinutos,
    CONCAT(ROUND((SUM(DATEDIFF(MINUTE, '00:00', ta.TempoTrabalho)) / 112800.0) * 100, 2), '%') AS PorcentagemTempoTrabalhado
FROM 
    Membro m
LEFT JOIN 
    TempoAtividade ta ON m.IdMembro = ta.IdMembro
GROUP BY 
    m.IdMembro, m.TipoMembro;

---------------busca um id projeto e nome por um idprojeto_servico + tipoprojeto_servico
SELECT 
    ps.IdProjeto_Servico, 
    ps.TipoProjeto_Servico,
    CONCAT(p.IdProjeto, ' - ', p.NomeProjeto) AS ProjetoNome
FROM 
    Projeto_Servico ps
INNER JOIN 
    Projeto p ON p.IdProjeto = ps.IdProjeto_Servico
WHERE 
    ps.IdProjeto_Servico = [SEU_ID_PROJETO_SERVICO] 
    AND ps.TipoProjeto_Servico = 'Projeto';

---------------busca um id prestacaoservico e nome por um idprojeto_servico + tipoprojeto_servico

SELECT 
    ps.IdProjeto_Servico, 
    ps.TipoProjeto_Servico,
    CONCAT(ps.IdProjeto_Servico, ' - ', ps.TipoProjeto_Servico) AS ServicoNome
FROM 
    Projeto_Servico ps
WHERE 
    ps.IdProjeto_Servico = [SEU_ID_PROJETO_SERVICO] 
    AND ps.TipoProjeto_Servico = 'PrestacaoServico';

---------------porcentagem de trabalho de cada membro em proejtos
SELECT 
    m.IdMembro,
    ps.IdProjeto_Servico,
    ps.TipoProjeto_Servico,
    CONCAT(p.IdProjeto, ' - ', p.NomeProjeto) AS ProjetoNome,
    SUM(DATEDIFF(MINUTE, '00:00', ta.TempoTrabalho)) AS TempoTotalMinutos,
    CONCAT(ROUND((SUM(DATEDIFF(MINUTE, '00:00', ta.TempoTrabalho)) / 112800.0) * 100, 2), '%') AS PorcentagemTempoTrabalhado
FROM 
    Membro m
LEFT JOIN 
    TempoAtividade ta ON m.IdMembro = ta.IdMembro
LEFT JOIN
    Atividade a ON ta.IdAtividade = a.IdAtividade
LEFT JOIN
    Projeto_Servico ps ON a.IdProjeto_Servico = ps.IdProjeto_Servico AND a.TipoProjeto_Servico = ps.TipoProjeto_Servico
LEFT JOIN
    Projeto p ON p.IdProjeto = ps.IdProjeto_Servico
GROUP BY 
    m.IdMembro, ps.IdProjeto_Servico, ps.TipoProjeto_Servico, p.IdProjeto, p.NomeProjeto;

--mesma coisa mas para um membro específico
DECLARE @IdMembro INT; -- Defina o IdMembro desejado aqui
SET @IdMembro = 4; -- Substitua Seu_Id_Membro pelo IdMembro específico

SELECT 
    m.IdMembro,
    ps.IdProjeto_Servico,
    ps.TipoProjeto_Servico,
    CONCAT(p.IdProjeto, ' - ', p.NomeProjeto) AS ProjetoNome,
    SUM(DATEDIFF(MINUTE, '00:00', ta.TempoTrabalho)) AS TempoTotalMinutos,
    CONCAT(ROUND((SUM(DATEDIFF(MINUTE, '00:00', ta.TempoTrabalho)) / 112800.0) * 100, 2), '%') AS PorcentagemTempoTrabalhado
FROM 
    Membro m
LEFT JOIN 
    TempoAtividade ta ON m.IdMembro = ta.IdMembro
LEFT JOIN
    Atividade a ON ta.IdAtividade = a.IdAtividade
LEFT JOIN
    Projeto_Servico ps ON a.IdProjeto_Servico = ps.IdProjeto_Servico AND a.TipoProjeto_Servico = ps.TipoProjeto_Servico
LEFT JOIN
    Projeto p ON p.IdProjeto = ps.IdProjeto_Servico
WHERE
    m.IdMembro = @IdMembro -- Filtrar pelo IdMembro específico
GROUP BY 
    m.IdMembro, ps.IdProjeto_Servico, ps.TipoProjeto_Servico, p.IdProjeto, p.NomeProjeto;
