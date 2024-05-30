const sql = require('mssql');

const config = {
    user: 'sa',
    password: 'PASSWORD',
    server: 'localhost',
    database: 'DATABASE',
    options: {
      encrypt: false, // A maioria das conexões de Named Pipes locais não usa criptografia
      enableArithAbort: true,
      trustedConnection: true,
      instanceName: 'SQLEXPRESS', // Substitua pelo nome da sua instância se for diferente
      pipe: '\\\\.\\pipe\\MSSQL$SQLEXPRESS\\sql\\query' // Substitua pelo seu pipe real
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
