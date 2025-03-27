import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sizer/sizer.dart';
import 'expense_summary_controller.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SummaryProvider(context),
      child: Consumer<SummaryProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(title: const Text("Expense Summary")),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_left, size: 30),
                        onPressed: () => provider.changeMonth(-1),
                      ),
                      Text(
                        DateFormat('MMMM yyyy').format(provider.selectedDate.value),
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_right, size: 30),
                        onPressed: () => provider.changeMonth(1),
                      ),
                    ],
                  ),
                ),

                // Toggle Buttons
                // Toggle Buttons
                ToggleButtons(
                  isSelected: [provider.selectedView == "Day", provider.selectedView == "Week", provider.selectedView == "Month"],
                  onPressed: (index) {
                    if (index == 0) provider.changeView("Day");
                    if (index == 1) provider.changeView("Week");
                    if (index == 2) provider.changeView("Month");
                  },
                  children: const [
                    Padding(padding: EdgeInsets.all(8.0), child: Text("Daily")),
                    Padding(padding: EdgeInsets.all(8.0), child: Text("Weekly")),
                    Padding(padding: EdgeInsets.all(8.0), child: Text("Monthly")),
                  ],
                ),

                provider.selectedView == "Day"
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_left, size: 30),
                              onPressed: () => provider.changeDay(-1),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy').format(provider.selectedDate.value),
                              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_right, size: 30),
                              onPressed: () => provider.changeDay(1),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                SizedBox(height: 2.h),

                SizedBox(height: 30.h, child: _buildPieChart(provider)),

                SizedBox(height: 2.h),

                // Expense List
                Expanded(child: _buildExpenseList(provider)),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Pie Chart Builder
  Widget _buildPieChart(SummaryProvider provider) {
    Map<String, double> expenseData = provider.getCategoryWiseExpenses();
    double totalExpense = provider.getTotalExpense();

    List<PieChartSectionData> sections = expenseData.entries.map((entry) {
      double percentage = (entry.value / totalExpense) * 100;
      return PieChartSectionData(
        title: "${percentage.toStringAsFixed(1)}%",
        value: entry.value,
        radius: 50,
        color: provider.getCategoryColor(entry.key),
      );
    }).toList();

    return PieChart(PieChartData(sections: sections));
  }

  Widget _buildExpenseList(SummaryProvider provider) {
    Map<String, double> categoryExpenses = provider.getCategoryWiseExpenses();
    double totalExpense = provider.getTotalExpense();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Total Expense: ₹${totalExpense.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView(
            children: categoryExpenses.entries.map((entry) {
              double percentage = (entry.value / totalExpense) * 100;
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: provider.getCategoryColor(entry.key),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "${percentage.toStringAsFixed(1)}%",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(entry.key),
                trailing: Text("₹${entry.value.toStringAsFixed(2)}"),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
