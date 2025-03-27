import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_screen.dart';
import 'expense_model.dart';
import 'package:http/http.dart' as http;

class ExpenseProvider extends ChangeNotifier {
  final List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;
  final ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());
  bool isLoading = true;

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void changeMonth(int change) {
    selectedDate.value = DateTime(selectedDate.value.year, selectedDate.value.month + change, 1);
  }

  Future<void> fetchExpenses() async {
    final token = await getToken();
    final url = Uri.parse("http://10.0.2.2:5002/expenses/fetch");
    if (token == null) {
      print("No token found. Please login.");
      return;
    }

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData["expenses"] is List) {
          final List<dynamic> data = responseData["expenses"];
          _expenses.clear();
          _expenses.addAll(data.map((e) => Expense.fromJson(e)).toList());
          getExpensesByMonthGrouped(selectedDate.value.month, selectedDate.value.year);
        } else {
          debugPrint("Unexpected response format: $responseData");
        }
        notifyListeners();
      } else {
        debugPrint("Failed to fetch expenses: ${response.body}");
      }
    } catch (error) {
      print("Error fetching expenses: $error");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> addExpense(Expense expense, BuildContext context) async {
    final url = Uri.parse("http://10.0.2.2:5002/expenses/addExpenses");
    final token = await getToken();
    if (token == null) {
      debugPrint("No token found. Please login.");
      return;
    }
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "amount": expense.amount,
          "category": expense.category,
          "description": expense.description,
          "date": expense.date.toIso8601String(), // Format Date Properly
        }),
      );

      if (response.statusCode == 200) {
        final newExpense = Expense.fromJson(jsonDecode(response.body)["expense"]);
        _expenses.add(newExpense);
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Expense Added Successfully")),
        );
        fetchExpenses();
      } else {
        debugPrint("Failed to add expense: ${response.body}");
      }
    } catch (error) {
      debugPrint("Error adding expense: $error");
    }
  }

  void deleteItem(BuildContext context, int id) async {
    final url = Uri.parse(
      "http://10.0.2.2:5002/expenses/delete/$id",
    );
    final token = await getToken();
    if (token == null) {
      print("No token found. Please login.");
      return;
    }
    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(jsonDecode(response.body)["message"])));
        fetchExpenses();
      }
    } catch (e) {
      debugPrint("Error adding expense: $e");
    }
  }

  Map<String, List<Expense>> getExpensesByMonthGrouped(int month, int year) {
    List<Expense> filteredExpenses = _expenses.where((expense) => expense.date.month == month && expense.date.year == year).toList();

    Map<String, List<Expense>> groupedExpenses = {};

    for (var expense in filteredExpenses) {
      String formattedDate = "${expense.date.day} ${_getMonthName(expense.date.month)} ${expense.date.year}";

      if (!groupedExpenses.containsKey(formattedDate)) {
        groupedExpenses[formattedDate] = [];
      }
      groupedExpenses[formattedDate]!.add(expense);
    }

    Map<String, List<Expense>> sortedExpenses = Map.fromEntries(
      groupedExpenses.entries.toList()
        ..sort((a, b) {
          DateTime dateA = DateTime.parse("$year-${month.toString().padLeft(2, '0')}-${a.key.split(" ")[0].padLeft(2, '0')}");
          DateTime dateB = DateTime.parse("$year-${month.toString().padLeft(2, '0')}-${b.key.split(" ")[0].padLeft(2, '0')}");
          return dateB.compareTo(dateA);
        }),
    );

    return sortedExpenses;
  }

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

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    prefs.setBool('isLoggedIn', false);

    if (token != null) {
      var response = await http.post(
        Uri.parse('http://10.0.2.2:5002/auth/logout'),
        headers: {
          'Authorization': 'Bearer $token', // Send token in header
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove('token');
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()), // Redirect to Login
          (route) => false, // Remove all previous routes
        );
      } else {
        debugPrint("Logout failed: ${response.body}");
      }
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()), // Redirect to Login
        (route) => false, // Remove all previous routes
      );
    }
  }
}
