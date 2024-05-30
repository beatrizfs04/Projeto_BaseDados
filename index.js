/* Requirements */
const path = require('path');
const express = require('express');
const app = express();
const port = 3000;
const pageTitle = "Projeto Final - Base de Dados";

app.get('/', function(req, res) {
    res.sendFile(path.join(__dirname, '/páginas/index.html'));
});

app.listen(port, () => {
    console.log(`> ${pageTitle} - http://localhost:${port}`);
});