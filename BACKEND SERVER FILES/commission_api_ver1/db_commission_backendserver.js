const express = require('express');
const cors = require('cors');
const pool = require('./db_commission_starter');


app.get('/', (req, res) => {
  res.send('Hello from Express!');
});

const app = express();
app.use(cors());
app.use(express.json());



//Lance and shaine

app.get('/api/view_projecttrackerlist', async (req, res) => {
    try {
        const [rows] = await pool.query("SELECT * FROM view_projecttrackerlist");
        res.json(rows);
    } catch (err) {
        console.error("Error in /api/view_projecttrackerlist:", err); 
        res.status(500).json({ error: 'Error retrieving project tracker' });
    }
});

app.get('/api/view_calendarview', async (req, res) => {
    try {
        const [rows] = await pool.query("SELECT * FROM view_calendarview");
        res.json(rows);
    } catch (err) {
        console.error("Error in /api/view_calendarview:", err); 
        res.status(500).json({ error: 'Error retrieving calendar list' });
    }
});

app.get('/api/tables/tbl_gendetails', async (req, res) => {
    try {
        const [rows] = await pool.query("SELECT * FROM tbl_gendetails");
        res.json(rows);
    } catch (err) {
        console.error("Error in /api/tables/tbl_gendetails:", err); 
        res.status(500).json({ error: 'Error retrieving order details' });
    }
});

app.get('/api/tables/tbl_clientprogdetails', async (req, res) => {
    try {
        const [rows] = await pool.query("SELECT * FROM tbl_clientprogdetails");
        res.json(rows);
    } catch (err) {
        console.error("Error in /api/tables/tbl_clientprogdetails:", err); 
        res.status(500).json({ error: 'Error retrieving client details' });
    }
});

app.get('/api/tables/tbl_paymentdetails', async (req, res) => {
    try {
        const [rows] = await pool.query("SELECT * FROM tbl_paymentdetails");
        res.json(rows);
    } catch (err) {
        console.error("Error in /api/tables/tbl_paymentdetails:", err); 
        res.status(500).json({ error: 'Error retrieving payment details' });
    }
});

app.get('/api/tables/tbl_progtrack', async (req, res) => {
    try {
        const [rows] = await pool.query("SELECT * FROM tbl_progtrack");
        res.json(rows);
    } catch (err) {
        console.error("Error in /api/table/tbl_progtrack:", err); 
        res.status(500).json({ error: 'Error retrieving tracker information' });
    }
});

app.post('/api/orders/cancel', async (req, res) => {
    const { orderId } = req.body;
    try {
        const query = "UPDATE tbl_progtrack SET ProjStat = 'Cancelled' WHERE OrderID = ?";
        const [result] = await pool.query(query, [orderId]);
        
        if (result.affectedRows > 0) {
            console.log(`✅ Order ${orderId} Cancelled.`);
            res.json({ message: `Order ${orderId} has been CANCELLED.` });
        } else {
            res.status(404).json({ message: "Order not found." });
        }
    } catch (err) {
        console.error("Failed to cancel order:", err);
        res.status(500).json({ error: "Internal Server Error" });
    }
});

//fritzie
app.put('/api/orders/edit', async (req, res) => {
    const { orderId, newOrderLabel, newClientContact } = req.body;
    try {
        const updateClient = "UPDATE tbl_clientprogdetails SET OrderLabel = ?, ClientContact = ? WHERE OrderID = ?";
        await pool.query(updateClient, [newOrderLabel, newClientContact, orderId]);

        console.log(`✅ Order ${orderId} details modified.`);
        res.json({ message: `Order ${orderId} details modified successfully.` });
    } catch (err) {
        console.error("Failed to modify order:", err);
        res.status(500).json({ error: "Internal Server Error" });
    }
});

//franchesca
app.post('/api/orders/finalize', async (req, res) => {
    try {
        const [pendingOrders] = await pool.query(
            "SELECT OrderID FROM tbl_progtrack WHERE ProjStat = 'Accepted'" 
        );

        if (pendingOrders.length === 0) {
            return res.json({ message: "No 'Accepted' orders found to finalize." });
        }

        let count = 0;
        for (let order of pendingOrders) {
            await pool.query(
                "UPDATE tbl_progtrack SET ProjStat = 'Completed' WHERE OrderID = ?",
                [order.OrderID]
            );
            console.log(`✅ Order ${order.OrderID} has been confirmed/completed.`);
            count++;
        }

        res.json({ message: `Success! ${count} orders have been finalized to 'Completed'.` });

    } catch (err) {
        console.error("Failed to finalize orders:", err);
        res.status(500).json({ error: "Internal Server Error" });
    }
});

app.listen(3000, () => {
    console.log("Server running on http://localhost:3000");
});



