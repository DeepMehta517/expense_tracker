import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../expenseScreen/expense_model.dart';
import '../expenseScreen/expense_provider.dart';

class Category {
  String name;
  IconData icon;
  List<String> subCategories;

  Category({required this.name, required this.icon, required this.subCategories});
}

class AddExpenseProvider extends ChangeNotifier {
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController date = TextEditingController();
  bool showCategoryList = false;
  FocusNode categoryFocus = FocusNode();

  AddExpenseProvider() {
    categoryFocus.addListener(() {
      if (!categoryFocus.hasFocus && showCategoryList) {
        Future.delayed(const Duration(milliseconds: 200), () {
          showCategoryList = false;
          notifyListeners();
        });
      }
    });
  }

  void categoryListClick(String category) {
    categoryController.text = category;
    notifyListeners();
  }

  final List<String> categories = [
    "Food",
    "Transport",
    "Shopping",
    "Rent",
    "Entertainment",
    "Health",
    "Bills",
    "Education",
    "Groceries",
    "Travel",
    "Dining Out",
    "Fitness",
    "Subscriptions",
    "Insurance",
    "Gifts",
    "Household",
    "Electronics",
    "Clothing",
    "Investment",
    "Charity"
  ];

  void clickedOnCategoriesField() {
    showCategoryList = true;
    notifyListeners();
  }

  void onOutsideTapField() {
    showCategoryList = false;
    notifyListeners();
  }

  var selectedDate = DateTime.now();

  void selectDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());
    if (pickedDate != null) {
      date.text = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      selectedDate = pickedDate;
      notifyListeners();
    }
  }

  void submitExpense(BuildContext context) {
    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Add amount")));
      return;
    }
    if (categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Add category")));
      return;
    }

    if (date.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Add Date")));
      return;
    }
    Provider.of<ExpenseProvider>(context, listen: false).addExpense(
        Expense(
            amount: double.parse(amountController.text),
            category: categoryController.text,
            date: selectedDate,
            description: descriptionController.text),
        context);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    amountController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    date.dispose();
    super.dispose();
  }
}
