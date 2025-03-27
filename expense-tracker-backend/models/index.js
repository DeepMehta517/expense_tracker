const { Sequelize ,DataTypes} = require("sequelize");
require("dotenv").config();

const sequelize = new Sequelize(process.env.DATABASE_URL, {
  dialect: "postgres",
  logging: false, // Disable logging
});

const db = {};
db.Sequelize = Sequelize;
db.sequelize = sequelize;
db.Expense = require("./expense")(sequelize, DataTypes); 
db.Auth = require("./auth")(sequelize, DataTypes); // Load model

module.exports = db;
