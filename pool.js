const express = require('express');
const sql = require('mssql');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

const config = {
  "user": "sa", // Database username
  "password": "paiva001", // Database password
  "server": "127.0.0.1", // Server IP address
  "database": "DIUBI", // Database name
  "options": {
      "encrypt": false // Disable encryption
  }
};

let pool;

sql.connect(config)
  .then(p => {
    pool = p;
    console.log('» Conectado ao Microsoft SQL Server');
  })
  .catch(err => {
    console.log('» Falha ao Conectar ao Microsoft SQL Server', err);
    throw err;
  });

module.exports = {
  sql, pool
};
