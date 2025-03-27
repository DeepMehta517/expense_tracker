const db = require("../models");
const Expense = db.Expense;

exports.addExpense = async (req, res) => {
  try {
    const { amount, category, description, date} = req.body;


    if (!amount || !category || !date) {
      return res.status(400).json({ error: "Amount, category, and date are required" });
    }

    const userId = req.user.id; 
    const expense = await Expense.create({ amount, category, description, date, userId });
    res.status(200).json({ success: true, message: "Expense added successfully", expense });

  } catch (error) {
    if (error.name === "SequelizeValidationError") {
      return res.status(400).json({ error: "Invalid input data" });
    }
    res.status(500).json({ success: false, message: "Internal Server Error", details: error.message });
  }
};

exports.getAllExpenses = async (req, res) => {
  try {
    const userId = req.user.id;  
    const expenses = await Expense.findAll({ where: { userId } });
    res.status(200).json({ success: true, expenses });

  } catch (error) {
    res.status(500).json({ success: false, message: "Internal Server Error", details: error.message });
  }
};

exports.deleteExpense = async (req, res) => {
  try {
    const id = parseInt(req.params.id, 10);
    if (isNaN(id)) {
      return res.status(400).json({ error: "Invalid Expense ID" });
    }

    const userId = req.user.id; 
    const selectedExpense = await Expense.findOne({ where: { id, userId } });

    if (!selectedExpense) {
      return res.status(404).json({ error: "Expense not found or unauthorized" });
    }

    await selectedExpense.destroy();
    res.json({ success: true, message: "Expense deleted successfully" });

  } catch (error) {
    res.status(500).json({ success: false, message: "Internal Server Error", details: error.message });
  }
};
