const mysql = require('mysql2/promise');

// Create the connection pool
const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',            
    password: '',            
    database: 'db_commission', 
    waitForConnections: true,
    connectionLimit: 10,     
    queueLimit: 0
});

module.exports = pool.promise();

