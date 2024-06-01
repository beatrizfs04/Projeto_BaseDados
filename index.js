/* Requirements */
const path = require('path');
const express = require('express');
const app = express();
const queries = require('./Controllers/queries');
const port = 3000;
const pageTitle = "Projeto Final - Base de Dados";

app.get('/', function(req, res) {
    res.sendFile(path.join(__dirname, '/web/index.html'));
});

app.get('/ver_dados', function(req, res) {
    res.sendFile(path.join(__dirname, '/web/ver_dados.html'));
});

app.get('/eliminar_dados', function(req, res) {
    res.sendFile(path.join(__dirname, '/web/eliminar_dados.html'));
});

app.get('/mudar_dados', function(req, res) {
    res.sendFile(path.join(__dirname, '/web/mudar_dados.html'));
});

app.get('/criar_dados', function(req, res) {
    res.sendFile(path.join(__dirname, '/web/criar_dados.html'));
});

app.get('/ver_creditos', function(req, res) {
    res.sendFile(path.join(__dirname, '/web/ver_creditos.html'));
});

app.get('/styles', function(req, res) {
    res.sendFile(path.join(__dirname, '/web/styles.css'));
});

app.get('/mudar_divs', function(req, res) {
    res.sendFile(path.join(__dirname, '/web/mudar_divs.js'));
});

app.use('/api/', queries);

app.listen(port, () => {
    console.log(`> ${pageTitle} - http://localhost:${port}`);
});