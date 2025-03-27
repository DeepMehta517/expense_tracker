module.exports = (sequelize, DataTypes) => {
  const Expense = sequelize.define("Expense", {
    amount: {
      type: DataTypes.FLOAT,
      allowNull: false, // Ensure amount is provided
    },
    category: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    description: {
      type: DataTypes.STRING,
    },
    date: {
      type: DataTypes.DATEONLY, // Stores only date (YYYY-MM-DD)
      allowNull: false,
    },
    userId: {
      type: DataTypes.INTEGER, // Foreign key
      allowNull: false,
      references: {
        model: "Auth", // Make sure this matches the actual table name in the database
        key: "id",
      },
      onDelete: "CASCADE", // Delete expenses if the user is deleted
    },
  });

    // ✅ Define Association: Each Expense belongs to a User
    Expense.associate = (models) => {
      Expense.belongsTo(models.Auth, { foreignKey: "userId", as: "user" });
    };
  
  return Expense;
};
