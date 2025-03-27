const express = require("express");
const { addExpense, getAllExpenses,deleteExpense } = require("../controller/expense_controller");
const router = express.Router();
const { authenticate } = require("../middlewares/auth_middleware"); // Import middleware


router.post("/addExpenses",authenticate ,addExpense);
router.delete("/delete/:id",authenticate, deleteExpense);
router.get("/fetch", authenticate,getAllExpenses);
router.get("/profile", authenticate, async (req, res) => {
    res.status(200).json({ message: "User profile data", user: req.user });
  });

module.exports = router;
