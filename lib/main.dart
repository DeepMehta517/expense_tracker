import 'package:expense_tracker/features/auth/auth_provider.dart';
import 'package:expense_tracker/features/expenseScreen/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'features/splashScreen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
      ],
      child: Sizer(
        builder: (a, b, c) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Expense Tracker',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
                useMaterial3: true,
              ),
              home: const SplashScreen());
        },
      ),
    );
  }
}
