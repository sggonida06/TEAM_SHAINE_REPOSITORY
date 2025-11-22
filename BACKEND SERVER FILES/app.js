const mysql = require('mysql2');

const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',            
    password: '',            
    database: 'db_commission' 
}).promise();

async function confirmAllOrders() {
    try {
    
        const [orders] = await pool.query("SELECT OrderID FROM tbl_progtrack");

        for (let order of orders) {
            await pool.query("UPDATE tbl_progtrack SET ProjStat = 'Completed' WHERE OrderID = ?", [order.OrderID]);
            console.log(`Order ${order.OrderID} has been confirmed!`);
        }

        const [rows] = await pool.query("SELECT * FROM tbl_progtrack");

        console.log("\n--- ORDER RECORDS ---\n");
        rows.forEach((order, index) => {  
            console.log(`order ${index + 1}`);
            console.log("OrderID:", order.OrderID);
            console.log("Order Label:", order.OrderLabel);
            console.log("Status:", order.ProjStat);
            console.log("------------\n");
        });

        console.log("\nAll orders have been finalized and user returned to HOME PAGE.");

    } catch (err) {
        console.error("Failed to confirm orders:", err);
    }
}

confirmAllOrders();
