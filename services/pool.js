// get the client
import mysql from 'mysql2';

// Create the connection pool. The pool-specific settings are the defaults
const pool = mysql.createPool({
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE,
  port: process.env.MYSQL_PORT,
  waitForConnections: true,
  connectionLimit: 999,
  maxIdle: 999, // max idle connections, the default value is the same as `connectionLimit`
  idleTimeout: 60000, // idle connections timeout, in milliseconds, the default value 60000
  queueLimit: 0
});

pool.getConnection((err, connection) => {
  return new Promise((resolve, reject) => {
      if (err) {
          if (err.code === 'PROTOCOL_CONNECTION_LOST') {
              reject('Database connection was closed.');
          }
          if (err.code === 'ER_CON_COUNT_ERROR') {
              reject('Database has too many connections.');
          }
          if (err.code === 'ECONNREFUSED') {
              reject('Database connection was refused.');
          }
      }
      if (connection) connection.release()
      resolve();
  });
});


module.exports = pool;