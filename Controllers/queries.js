const express = require('express');
const queries = express.Router();
/* const mysql = require('mysql');
const db = mysql.createConnection({ host: 'localhost', user: 'root', password: '', database: 'projetobd'}); db.connect(); */
const { sql, poolPromise } = require('../pool');

queries.get("/estado_projeto/:IdProjeto", async (req, res) => {
    const { IdProjeto } = req.params;
    if (!IdProjeto || isNaN(IdProjeto) || IdProjeto < 0) { res.status(400).send("ID do Projeto Inválido."); return; }
    const query = "SELECT DISTINCT P.IdProjeto, P.NomeProjeto, E.NomeEstado FROM Projeto P, Estado E WHERE P.IdProjeto = @IdProjeto AND P.IdEstado = E.IdEstado";
    const sqlRequest = new sql.Request();
    sqlRequest.input('IdProjeto', sql.Int, IdProjeto);
    const result = await sqlRequest.query(query);
    res.status(200).send(result.recordset);
});

queries.get("/financiamento_projetos", async (req, res) => {
    const query = "SELECT DISTINCT P.IdProjeto, P.NomeProjeto, F.Valor FROM Projeto P JOIN Financiamento F ON F.IdFinanciador = P.IdProjeto JOIN Financiamento_Projeto_PrestacaoServico FPP ON FPP.TipoProjeto_Servico LIKE 'Projeto' ORDER BY F.VALOR DESC";
    const sqlRequest = new sql.Request();
    const result = await sqlRequest.query(query);
    res.status(200).send(result.recordset);
});

queries.get("/membros_projetos", async (req, res) => {
    const query = "SELECT DISTINCT P.IdProjeto, P.NomeProjeto, COUNT(EM.IdMembro) as QuantidadeMembros FROM Projeto P JOIN Equipa E ON E.IdProjeto = P.IdProjeto JOIN Equipa_Membro EM ON EM.IdEquipa = E.IdEquipa JOIN Membro M ON M.IdMembro = EM.IdMembro GROUP BY P.IdProjeto, P.NomeProjeto ORDER BY QuantidadeMembros DESC";
    const sqlRequest = new sql.Request();
    const result = await sqlRequest.query(query);
    res.status(200).send(result.recordset);
});

queries.get("/instituicao_projetos_financiamentos", async (req, res) => {
    const query = "SELECT DISTINCT I.NomeInstituicao, COUNT(F.IdFinanciamento) as QuantidadeFinanciamentos FROM Instituicao I JOIN Financiamento F ON F.IdFinanciador = I.IdInstituicao JOIN Financiamento_Projeto_PrestacaoServico Fin ON Fin.IdProjeto_Servico = F.IdFinanciador AND Fin.TipoProjeto_Servico LIKE 'Projeto' GROUP BY I.NomeInstituicao ORDER BY QuantidadeFinanciamentos DESC";
    const sqlRequest = new sql.Request();
    const result = await sqlRequest.query(query);
    res.status(200).send(result.recordset);
});

queries.get("/publicacoes_projetos", async (req, res) => {
    const query = "SELECT DISTINCT P.IdProjeto, P.NomeProjeto, COUNT(Pub.IdPublicacao) as QuantidadePublicacoes FROM Projeto P JOIN Publicacao Pub ON P.IdProjeto = Pub.IdProjeto GROUP BY P.IdProjeto, P.NomeProjeto ORDER BY QuantidadePublicacoes DESC";
    const sqlRequest = new sql.Request();
    const result = await sqlRequest.query(query);
    res.status(200).send(result.recordset);
});

queries.get("/instituicoes_financiamento", async (req, res) => {
    const query = "SELECT DISTINCT I.NomeInstituicao, COUNT(F.IdFinanciamento) as QuantidadeFinanciamentos FROM Instituicao I JOIN Financiamento F ON F.IdFinanciador = I.IdInstituicao JOIN Financiador Fin ON Fin.IdFinanciador = F.IdFinanciador AND Fin.TipoFinanciador LIKE 'Instituicao' GROUP BY I.NomeInstituicao ORDER BY QuantidadeFinanciamentos DESC";
    const sqlRequest = new sql.Request();
    const result = await sqlRequest.query(query);
    res.status(200).send(result.recordset);
});

queries.patch("/atualizar_estado_projeto/:IdProjeto", async (req, res) => {
    const { IdProjeto } = req.params;
    if (!IdProjeto || isNaN(IdProjeto) || IdProjeto < 0) { res.status(400).send("ID do Projeto Inválido."); return; }
    const NovoEstado = (req.body && req.body.NovoEstado ? req.body.NovoEstado : null)
    if (!NovoEstado || NovoEstado == null) { res.status(400).send("Novo Estado do Projeto Inválido."); return; }
    const query = "SELECT DISTINCT IdEstado FROM Projeto WHERE IdProjeto = @IdProjeto";
    var sqlRequest = new sql.Request();
    sqlRequest.input('IdProjeto', sql.Int, IdProjeto);
    const selectResult = await sqlRequest.query(query);
    if (selectResult.IdEstado == null || selectResult.IdEstado == "[]") { res.status(400).send("Esse ID de Estado é Inválido."); return; }
    const updateQuery = "UPDATE `Estado` WHERE IdEstado = @IdEstado SET NomeEstado = @NomeEstado";
    sqlRequest = new sql.Request();
    sqlRequest.input('IdEstado', sql.Int, selectResult.IdEstado);
    sqlRequest.input('NomeEstado', sql.Int, NovoEstado);
    const updateResult = await sqlRequest.query(updateQuery);
    res.status(200).send(updateResult.recordset);
});

queries.patch("/atualizar_tempo_membro/:IdAtividade", async (req, res) => {
    const { IdAtividade } = req.params;
    if (!IdAtividade || isNaN(IdAtividade) || IdAtividade < 0) { res.status(400).send("ID da Atividade Inválido."); return; }
    const NovoTempo = (req.body && req.body.NovoTempo ? req.body.NovoTempo : null);
    if (!NovoTempo || NovoTempo == null) { res.status(400).send("Novo Tempo a Adicionar Inválido."); return; }
    const IdMembro = (req.body && req.body.IdMembro ? req.body.IdMembro : null);
    if (!IdMembro || IdMembro == null) { res.status(400).send("ID do Membro Inválido."); return; }
    const selectQuery = "SELECT DISTINCT IdMembro FROM Membro WHERE IdMembro = @IdMembro";
    var sqlRequest = new sql.Request();
    sqlRequest.input('IdMembro', sql.Int, IdMembro);
    const selectResult = await sqlRequest.query(selectQuery);
    if (selectResult.IdMembro == null || selectResult.IdMembro == "[]") { res.status(400).send("Esse ID de Membro é Inválido."); return; }
    const selectTempoQuery = "SELECT DISTINCT TempoTrabalho FROM TempoAtividade WHERE IdMembro = @IdMembro AND IdAtividade = @IdAtividade";
    var sqlRequest = new sql.Request();
    sqlRequest.input('IdMembro', sql.Int, IdMembro);
    sqlRequest.input('IdAtividade', sql.Int, IdAtividade);
    const selectTempoResult = await sqlRequest.query(selectTempoQuery);
    if (selectTempoResult.TempoTrabalho == null || selectResult.TempoTrabalho == "[]") { res.status(400).send("Tempo de Atividade Para Esse Membro e Atividade Inválido."); return; }
    const tempoFinal = (parseInt(selectTempoResult.TempoTrabalho) + parseInt(NovoTempo))
    const updateQuery = "UPDATE `TempoAtividade` WHERE IdMembro = @IdMembro AND IdAtividade = @IdAtividade SET TempoTrabalho = @TempoTrabalho";
    sqlRequest = new sql.Request();
    sqlRequest.input('TempoTrabalho', sql.Decimal, tempoFinal);    
    const updateResult = await sqlRequest.query(updateQuery);
    res.status(200).send(updateResult.recordset);
});

queries.put("/inserir_projeto", async (req, res) => {
    const { TipoProjeto_Servico, Nome, Descricao, IdData, IdInterno, IdInstituicao, IdEstado, IdArea, IdDominio, IdMembro } = req.body;
    var query = "";
    const sqlRequest = new sql.Request();
    if (TipoProjeto_Servico == "Projeto") {
        query = "INSERT INTO `Projeto` (NomeProjeto, Descricao, IdData, IdInstituicao, IdEstado, IdArea, IdDominio, IdMembro) VALUES (@NomeProjeto, @Descricao, @IdData, @IdInstituicao, @IdEstado, @IdArea, @IdDominio, @IdMembro)";
        sqlRequest.input('NomeProjeto', sql.VarChar, Nome);
        sqlRequest.input('Descricao', sql.VarChar, Descricao);
        sqlRequest.input('IdData', sql.Int, IdData);
        sqlRequest.input('IdInstituicao', sql.Int, IdInstituicao);
        sqlRequest.input('IdEstado', sql.Int, IdEstado);
        sqlRequest.input('IdArea', sql.Int, IdArea);
        sqlRequest.input('IdDominio', sql.Int, IdDominio);
        sqlRequest.input('IdMembro', sql.Int, IdMembro);
    } else if (TipoProjeto_Servico == "Serviço") {
        query = "INSERT INTO `PrestacaoServico` (NomePrestacaoServico, Descricao, IdInterno, IdData, IdEstado, IdFinanciamento) VALUES (@NomePrestacaoServico, @Descricao, @IdInterno, @IdData, @IdEstado, @IdFinanciamento)";
        sqlRequest.input('NomePrestacaoServico', sql.VarChar, Nome);
        sqlRequest.input('Descricao', sql.VarChar, Descricao);
        sqlRequest.input('IdInterno', sql.Int, IdInterno);
        sqlRequest.input('IdData', sql.Int, IdData);
        sqlRequest.input('IdEstado', sql.Int, IdEstado);
        sqlRequest.input('IdFinanciamento', sql.Int, IdFinanciamento);
    }
    const result = await sqlRequest.query(query);
    res.status(200).send(result.recordset);
});

queries.get("/estado_membro", async (req, res) => {
    const { IdMembro } = req.body;
    if (!IdMembro || isNaN(IdMembro) || IdMembro < 0) { res.status(400).send("ID do Membro Inválido."); return; }
    const query = "SELECT DISTINCT TA.IdMembro, TA.TempoTrabalho, TA.IdAtividade FROM TempoAtividade";
    const sqlRequest = new sql.Request();
    const result = await sqlRequest.query(query);
    res.status(200).send(result.recordset);
});

/* UI Page */
queries.get("/getInvestigadores", async (req, res) => {
    const query = "SELECT DISTINCT P.PrimeiroNome, P.UltimoNome, P.IdPessoa FROM Pessoa P JOIN Interno I ON I.IdPessoa = P.IdPessoa";
    const sqlRequest = new sql.Request();
    const result = await sqlRequest.query(query);
    res.status(200).send(result.recordset);
})

queries.get("/getMembros", async (req, res) => {
    const query = "SELECT DISTINCT P.PrimeiroNome, P.UltimoNome, M.IdMembro FROM Pessoa P JOIN Membro M ON M.IdPessoa = P.IdPessoa";
    const sqlRequest = new sql.Request();
    const result = await sqlRequest.query(query);
    res.status(200).send(result.recordset);
})

queries.get("/getAreas", async (req, res) => {
    const query = "SELECT DISTINCT IdArea, NomeArea FROM AreaCientifica";
    const sqlRequest = new sql.Request();
    const result = await sqlRequest.query(query);
    res.status(200).send(result.recordset);
})

queries.get("/getDominios", async (req, res) => {
    const query = "SELECT DISTINCT IdDominio, NomeDominio FROM DominioCientifico";
    const sqlRequest = new sql.Request();
    const result = await sqlRequest.query(query);
    res.status(200).send(result.recordset);
})

queries.get("/getPalavrasChave", async (req, res) => {
    const query = "SELECT DISTINCT IdPalavraChave, PalavraChave FROM PalavraChave";
    const sqlRequest = new sql.Request();
    const result = await sqlRequest.query(query);
    res.status(200).send(result.recordset);
})

queries.get("/getFinanciadores", async (req, res) => {
    var financiadores = [];
    const query_geral = "SELECT DISTINCT IdFinanciador, TipoFinanciador FROM Financiador";
    var sqlRequest = new sql.Request();
    const result_geral = await sqlRequest.query(query_geral);
    for (i=0; i<result_geral.recordset.length; i++) {
        if (result_geral.recordset[i].TipoFinanciador == "Instituicao") {
            const query_inst = "SELECT DISTINCT IdInstituicao, NomeInstituicao, NacionalidadeInstituicao FROM Instituicao WHERE IdInstituicao = @IdInstituicao";
            sqlRequest = new sql.Request();
            sqlRequest.input('IdInstituicao', sql.Int, result_geral.recordset[i].IdFinanciador);
            const result_inst = await sqlRequest.query(query_inst);
            for (i=0; i<result_inst.recordset.length; i++) {
                financiadores.push({ IdFinanciador: result_inst.recordset[i].IdInstituicao, NomeFinanciador: "Instituição: "+result_inst.recordset[i].NomeInstituicao+" | Nacionalidade: "+result_inst.recordset[i].NacionalidadeInstituicao, Tipo: "Instituicao"})
            }
        } else if (result_geral.recordset[i].TipoFinanciador == "Programa") {
            const query_prog = "SELECT DISTINCT IdPrograma, NomePrograma, NacionalidadePrograma FROM Programa WHERE IdPrograma = @IdPrograma";
            sqlRequest = new sql.Request();
            sqlRequest.input('IdPrograma', sql.Int, result_geral.recordset[i].IdFinanciador);
            const result_prog = await sqlRequest.query(query_prog);
            for (i=0; i<result_prog.recordset.length; i++) {
                financiadores.push({ IdFinanciador: result_prog.recordset[i].IdPrograma, NomeFinanciador: "Programa: "+result_prog.recordset[i].NomePrograma+" | Nacionalidade: "+result_prog.recordset[i].NacionalidadePrograma, Tipo: "Programa"})
            }
        }
    }
    res.status(200).send(financiadores);
})

queries.get("/getProjetos", async (req, res) => {
    const query = "SELECT DISTINCT IdProjeto, NomeProjeto, Descricao, IdData, IdInstituicao, IdEstado, IdArea, IdDominio FROM Projeto";
    const sqlRequest = new sql.Request();
    const result = await sqlRequest.query(query);
    res.status(200).send(result.recordset);
})

queries.get("/getPrestServicos", async (req, res) => {
    const query = "SELECT DISTINCT IdPrestacaoServico, NomePrestacaoServico, IdInterno, IdData, IdEstado FROM PrestacaoServico";
    const sqlRequest = new sql.Request();
    const result = await sqlRequest.query(query);
    res.status(200).send(result.recordset);
})

module.exports = queries;