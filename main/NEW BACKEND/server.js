const express = require('express');
const cors = require('cors');
const studentRoutes = require('./routes/studentRoute');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors()); // anyone can connect
app.use(express.json()); // naka json file
app.use(express.urlencoded({ extended: true })); // sanitized file, hindi naka sql indiction

// Routes
// app.use('/api/students', studentRoutes);





app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
//   console.log(`API URL: http://localhost:${PORT}/api/students`);
});