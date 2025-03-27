import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../expenseScreen/expense_model.dart';
import '../expenseScreen/expense_provider.dart';

class SummaryProvider extends ChangeNotifier {
  late final ExpenseProvider _homeProvider;

  SummaryProvider(BuildContext context) {
    _homeProvider = Provider.of<ExpenseProvider>(context, listen: false); // Directly access ExpenseProvider
  }
  final ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());
  String selectedView = "Month";

  List<Expense> get _expenses => _homeProvider.expenses;

  // Change View (Day, Week, Month, Year)
  void changeView(String view) {
    selectedView = view;
    notifyListeners();
  }

  // Change the selected year
  void changeYear(int change) {
    selectedDate.value = DateTime(selectedDate.value.year + change, 1, 1);
    notifyListeners();
  }

  // Change the selected month
  void changeMonth(int change) {
    int newMonth = selectedDate.value.month + change;
    int newYear = selectedDate.value.year;

    if (newMonth > 12) {
      newMonth = 1;
      newYear++;
    } else if (newMonth < 1) {
      newMonth = 12;
      newYear--;
    }

    // Get last day of the new month
    int lastDay = DateTime(newYear, newMonth + 1, 0).day;

    // Ensure day is valid for the new month
    int newDay = selectedDate.value.day > lastDay ? lastDay : selectedDate.value.day;

    if (selectedView == "Day" || selectedView == "Weekly") {
      selectedDate.value = DateTime(newYear, newMonth, newDay);
    } else {
      selectedDate.value = DateTime(newYear, newMonth, lastDay);
    }

    notifyListeners();
  }

  // Change the selected day
  void changeDay(int change) {
    selectedDate.value = selectedDate.value.add(Duration(days: change));
    notifyListeners();
  }

  // Get expenses based on the selected view
  List<Expense> _getExpensesForSelectedYear() {
    DateTime currentDate = selectedDate.value;

    if (selectedView == "Day") {
      return _expenses
          .where((expense) => expense.date.year == currentDate.year && expense.date.month == currentDate.month && expense.date.day == currentDate.day)
          .toList();
    } else if (selectedView == "Week") {
      DateTime startOfWeek = currentDate.subtract(const Duration(days: 6));
      DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

      return _expenses
          .where((expense) =>
              expense.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) && expense.date.isBefore(endOfWeek.add(const Duration(days: 1))))
          .toList();
    } else if (selectedView == "Month") {
      return _expenses.where((expense) => expense.date.year == currentDate.year && expense.date.month == currentDate.month).toList();
    } else {
      return _expenses.where((expense) => expense.date.year == currentDate.year).toList();
    }
  }

  // Group and sort expenses by day, week, month, or year
  Map<String, double> _groupAndSortExpenses(String type) {
    Map<String, double> groupedExpenses = {};
    for (var expense in _getExpensesForSelectedYear()) {
      String key;
      if (type == "day") {
        key = "${expense.date.day} ${_getMonthName(expense.date.month)} ${expense.date.year}";
      } else if (type == "week") {
        int weekNumber = (expense.date.day - 1) ~/ 7 + 1;
        key = "Week $weekNumber ${_getMonthName(expense.date.month)} ${expense.date.year}";
      } else if (type == "month") {
        key = "${_getMonthName(expense.date.month)} ${expense.date.year}";
      } else {
        key = "${expense.date.year}";
      }

      groupedExpenses[key] = (groupedExpenses[key] ?? 0) + expense.amount;
    }

    // Sort in descending order by expense amount
    return Map.fromEntries(
      groupedExpenses.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );
  }

  // Get Daily Expenses
  Map<String, double> getDailyExpenses() {
    return _groupAndSortExpenses("day");
  }

  // Get Weekly Expenses
  Map<String, double> getWeeklyExpenses() {
    return _groupAndSortExpenses("week");
  }

  // Get Monthly Expenses
  Map<String, double> getMonthlyExpenses() {
    return _groupAndSortExpenses("month");
  }

  // Get Yearly Expenses
  Map<String, double> getYearlyExpenses() {
    return _groupAndSortExpenses("year");
  }

  // Get expenses grouped and sorted for pie chart display
  Map<String, double> getCategoryWiseExpenses() {
    Map<String, double> categoryTotals = {};
    for (var expense in _getExpensesForSelectedYear()) {
      categoryTotals[expense.category] = (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    // Sort categories by expense amount in descending order
    return Map.fromEntries(
      categoryTotals.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );
  }

  // Utility to convert month number to string
  String _getMonthName(int month) {
    List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }

  // Get total expenses
  double getTotalExpense() {
    return _getExpensesForSelectedYear().fold(0, (sum, expense) => sum + expense.amount);
  }

  // Get Category Color (for charts)
  Color getCategoryColor(String category) {
    final List<Color> colors = [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.teal];
    return colors[category.hashCode % colors.length];
  }
}
