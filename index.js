/* Requirements */
const path = require('path');
const express = require('express');
const mysql = require('mysql');
const db = mysql.createConnection({ host: 'localhost', user: 'root', password: '', database: 'projetobd'}); db.connect();
const app = express();
const queries = express.Router();
const port = 3000;
const pageTitle = "Projeto Final - Base de Dados";

/* queries.update = async function() {
    db.query('UPDATE tabela SET objeto = ? WHERE campo = ?', (error, results) => {
        if (error) throw error; 
        res.send(results);
    })
}

queries.select = async function() {
    db.query('SELECT objetos FROM tabela WHERE campo = ?', (error, results) => {
        if (error) throw error; 
        res.send(results);
    })
}

queries.insert = async function() {
    db.query('INSERT INTO tabela (campos, campos, campos) VALUES (objeto, objeto, objeto)', (error, results) => {
        if (error) throw error; 
        res.send(results);
    })
}

queries.delete = async function() {
    db.query('DELETE FROM tabela WHERE campo = ?', (error, results) => {
        if (error) throw error; 
        res.send(results);
    })
} */

app.get('/', function(req, res) {
    res.sendFile(path.join(__dirname, '/index.html'));
});

app.listen(port, () => {
    console.log(`> ${pageTitle} - http://localhost:${port}`);
});