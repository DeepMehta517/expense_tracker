module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn("Expenses", "userId", {
      type: Sequelize.INTEGER,
      allowNull: false,
      references: {
        model: "Auths", // Ensure this is the correct table name
        key: "id",
      },
      onDelete: "CASCADE",
    });
  },
  down: async (queryInterface, Sequelize) => {
    await queryInterface.removeColumn("Expenses", "userId");
  },
};
