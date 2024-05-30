const sql = require('mssql');

const config = {
  "user": "sa", // Database username
  "password": "paiva001", // Database password
  "server": "127.0.0.1", // Server IP address
  "database": "DIUBI", // Database name
  "options": {
      "encrypt": false // Disable encryption
  }
};

const poolPromise = new sql.ConnectionPool(config)
  .connect()
  .then(pool => {
    console.log('» Conectado ao Microsoft SQL Server');
    return pool;
  })
  .catch(err => {
    console.log('» Falha ao Conectar ao Microsoft SQL Server', err);
    throw err;
  });

module.exports = {
  sql, poolPromise
};
