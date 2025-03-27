import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../addExpense/add_expense_screen.dart';
import '../expenseSummary/expense_summary.dart';
import 'expense_provider.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<ExpenseProvider>(context, listen: false).fetchExpenses();

    return Scaffold(
        appBar: AppBar(title: const Text('Expense Tracker'), actions: [
          IconButton(
              icon: const Icon(Icons.pie_chart),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SummaryScreen()));
              }),
          IconButton(icon: const Icon(Icons.logout), onPressed: () => Provider.of<ExpenseProvider>(context, listen: false).logout(context)),
        ]),
        body: Consumer<ExpenseProvider>(builder: (context, provider, child) {
          return ValueListenableBuilder<DateTime>(
              valueListenable: provider.selectedDate,
              builder: (context, date, child) {
                return provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(children: [
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              IconButton(icon: const Icon(Icons.arrow_left, size: 30), onPressed: () => provider.changeMonth(-1)),
                              Text(DateFormat('MMMM yyyy').format(date), style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                              IconButton(icon: const Icon(Icons.arrow_right, size: 30), onPressed: () => provider.changeMonth(1)),
                            ])),
                        Expanded(child: Consumer<ExpenseProvider>(builder: (context, provider, child) {
                          var groupedExpenses = provider.getExpensesByMonthGrouped(date.month, date.year);

                          if (groupedExpenses.isEmpty) {
                            return const Center(child: Text("No expenses found for this month."));
                          }

                          return ListView(
                              children: groupedExpenses.entries.map((entry) {
                            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                                child: Text(
                                  entry.key,
                                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                              ),
                              ...entry.value.map((expense) {
                                return ListTile(
                                    leading: CircleAvatar(child: Text(expense.category[0])),
                                    title: Text(expense.category, style: TextStyle(fontSize: 15.sp)),
                                    subtitle: Text(expense.description, style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
                                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                                      Text(
                                        '\$${expense.amount.toString()}',
                                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 5.w),
                                      GestureDetector(
                                          onTap: () => provider.deleteItem(context, expense.id ?? 0),
                                          child: const Icon(Icons.delete, color: Colors.red))
                                    ]));
                              })
                            ]);
                          }).toList());
                        }))
                      ]);
              });
        }),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddExpenseScreen())).then(
                (value) {
                  Provider.of<ExpenseProvider>(context, listen: false).fetchExpenses();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Expense Added")));
                },
              );
            },
            child: const Icon(Icons.add)));
  }
}
