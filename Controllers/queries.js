const express = require('express');
const queries = express.Router();
/* const mysql = require('mysql');
const db = mysql.createConnection({ host: 'localhost', user: 'root', password: '', database: 'projetobd'}); db.connect(); */
const { sql, poolPromise } = require('../pool');

queries.get("/estado_projeto/:IdProjeto", async (req, res) => {
    const { IdProjeto } = req.params;
    if (!IdProjeto || isNaN(IdProjeto) || IdProjeto < 0) { res.status(400).send("ID do Projeto Inválido."); return; }
    const query = "SELECT P.IdProjeto, P.NomeProjeto, E.NomeEstado FROM Projeto P, Estado E WHERE P.IdProjeto = @IdProjeto AND P.IdEstado = E.IdEstado";
    const sqlRequest = new sql.Request();
    sqlRequest.input('IdProjeto', sql.Int, IdProjeto);
    const result = await sqlRequest.query(query);
    res.status(200).send(result.recordset);
});

queries.get("/financiamento_projetos", async (req, res) => {
    const query = "SELECT P.IdProjeto, P.NomeProjeto, F.Valor FROM Projeto P, Financiamento F WHERE F.TipoProjeto_Servico = P.IdProjeto AND F.TipoProjeto_Servico LIKE 'projeto' ORDER BY VALOR DESC";
    const sqlRequest = new sql.Request();
    const result = await sqlRequest.query(query);
    res.status(200).send(result.recordset);
});

queries.get("/membros_projetos", async (req, res) => {
    const query = "SELECT P.IdProjeto, P.NomeProjeto, COUNT(E.IdMembro) as QuantidadeMembros FROM Projeto P JOIN Equipa E ON E.IdProjeto = P.IdProjeto JOIN Membro M ON E.IdMembro = M.IdMembro GROUP BY P.IdProjeto, P.NomeProjeto ORDER BY QuantidadeMembros DESC";
    const sqlRequest = new sql.Request();
    const result = await sqlRequest.query(query);
    res.status(200).send(result.recordset);
});

queries.get("/instituicao_financiamentos", async (req, res) => {
    const query = "SELECT I.IdInstituicao, I.NomeInstituicao, COUNT(F.IdFinanciamento) as QuantidadeFinanciamentos FROM Instituicao I, JOIN Financiamento F ON F. = I. GROUP BY I.IdInstituicao, I.NomeInstituicao ORDER BY QuantidadeFinanciamentos DESC";
    const sqlRequest = new sql.Request();
    const result = await sqlRequest.query(query);
    res.status(200).send(result.recordset);
});

queries.get("/publicacoes_projetos", async (req, res) => {
    const query = "SELECT P.IdProjeto, P.NomeProjeto, COUNT(Pub.IdPublicacao) as QuantidadePublicacoes FROM Projeto P JOIN Publicacao Pub ON P.IdProjeto = Pub.IdProjeto GROUP BY P.IdProjeto, P.NomeProjeto ORDER BY QuantidadePublicacoes DESC";
    const sqlRequest = new sql.Request();
    const result = await sqlRequest.query(query);
    res.status(200).send(result.recordset);
});

queries.put("/atualizar_projeto", async (req, res) => {
    const { IdProjeto } = req.params;
    if (!IdProjeto || isNaN(IdProjeto) || IdProjeto < 0) { res.status(400).send("ID do Projeto Inválido."); return; }
    const query = "";
});

module.exports = queries;