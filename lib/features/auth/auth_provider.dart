import 'dart:convert';
import 'package:expense_tracker/features/expenseScreen/expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String _token = "";

  String get token => _token;

  bool showPassword = false;
  bool isLoading = false;
  Future<void> saveLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> login(String email, String password, context) async {
    isLoading = true;
    notifyListeners();

    final response = await http.post(
      Uri.parse("http://10.0.2.2:5002/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _token = data['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token);
      saveLoginState();
      isLoading = false;

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ExpenseScreen(),
      ));

      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'])));

      throw Exception(data['message']);
    }
  }

  void showPass() {
    showPassword = !showPassword;
    notifyListeners();
  }

  Future<void> signup(String name, String email, String password, context) async {
    isLoading = true;
    notifyListeners();
    final response = await http.post(
      Uri.parse("http://10.0.2.2:5002/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _token = data['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token);
      isLoading = false;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ExpenseScreen(),
      ));
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'])));

      throw Exception(data['message']);
    }
  }
}
