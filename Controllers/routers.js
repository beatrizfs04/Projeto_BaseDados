const express = require('express');
const queries = express.Router();
const mysql = require('mysql');
const { sql, poolPromise } = require('./pool');
/* const db = mysql.createConnection({ host: 'localhost', user: 'root', password: '', database: 'projetobd'}); db.connect(); */

/* 
queries.update = async function() {
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
} 
*/