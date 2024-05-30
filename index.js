/* Requirements */
const path = require('path');
const express = require('express');
const mysql = require('mysql');
const db = mysql.createConnection({ host: 'localhost', user: 'root', password: '', database: 'projetobd'}); db.connect();
const app = express();
const queries = express.Router();
const port = 3000;
const pageTitle = "Projeto Final - Base de Dados";

app.get('/', function(req, res) {
    res.sendFile(path.join(__dirname, '/páginas/index.html'));
});

app.listen(port, () => {
    console.log(`> ${pageTitle} - http://localhost:${port}`);
});