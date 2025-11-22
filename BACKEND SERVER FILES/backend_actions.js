const mysql = require('mysql2');

const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',            
    password: '',            
    database: 'db_commission' 
}).promise();

async function cancelOrder(orderId) {
    try {
        const query = "UPDATE tbl_progtrack SET ProjStat = 'Cancelled' WHERE OrderID = ?";
        const [result] = await pool.query(query, [orderId]);
        
        if (result.affectedRows > 0) {
            console.log(`\n✅ Order ${orderId} has been CANCELLED.`);
        } else {
            console.log(`\n⚠️ Failed to cancel Order ${orderId}. Order not found.`);
        }
        return result;
    } catch (err) {
        console.error("Failed to cancel order:", err);
        throw err;
    }
}


async function modifyOrder(orderId, newOrderLabel, newClientContact) {
    try {
        const updateClient = "UPDATE tbl_clientprogdetails SET OrderLabel = ?, ClientContact = ? WHERE OrderID = ?";
        const [clientResult] = await pool.query(updateClient, [newOrderLabel, newClientContact, orderId]);


        console.log(`\n✅ Order ${orderId} details modified successfully.`);
        return clientResult;

    } catch (err) {
        console.error("Failed to modify order:", err);
        throw err;
    }
}


async function displayAllOrders() {
    try {
        const [rows] = await pool.query("SELECT * FROM tbl_progtrack");

        console.log("\n--- UPDATED ORDER RECORDS (tbl_progtrack) ---");
        rows.forEach((order, index) => {  
            console.log(`Order ${index + 1}`);
            console.log("OrderID:", order.OrderID);
            console.log("Order Label:", order.OrderLabel);
            console.log("Status:", order.ProjStat);
            console.log("------------\n");
        });

    } catch (err) {
        console.error("Failed to display orders:", err);
    }
}

async function runBackendActions() {

    try {
        await cancelOrder(12346); 


        await modifyOrder(12345, 'NEW: Capybara Keychain RUSH', '09123456789');


        await displayAllOrders();

        console.log("All backend actions completed.");

    } catch (e) {
        console.log("A critical error occurred during backend execution.");
    } finally {
        pool.end();
    }
}

// runBackendActions();