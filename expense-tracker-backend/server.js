const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const db = require("./models");
require("dotenv").config();

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Import routes
const expenseRoutes = require("./routes/expenseRoutes");
app.use("/expenses", expenseRoutes);
const authRoutes = require("./routes/auth");
app.use("/auth", authRoutes);

const PORT = process.env.PORT || 5002;
db.sequelize.sync().then(() => {
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
});
