import 'package:expense_tracker/features/addExpense/widget/categories_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'add_expense_controller.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AddExpenseProvider(),
        child: Consumer<AddExpenseProvider>(builder: (context, provider, child) {
          return Scaffold(
              appBar: AppBar(
                  title: const Text('Add Expense'), centerTitle: true, backgroundColor: Colors.blue, foregroundColor: Colors.white, elevation: 3),
              body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                        child: SingleChildScrollView(
                            child: Column(children: [
                      SizedBox(height: 2.h),
                      TextFormField(
                          autofocus: true,
                          controller: provider.amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          decoration: inputDecoration('Amount', Icons.attach_money)),
                      SizedBox(height: 2.h),
                      TextFormField(
                          focusNode: provider.categoryFocus,
                          onTap: () => provider.clickedOnCategoriesField(),
                          controller: provider.categoryController,
                          decoration: inputDecoration('Category', Icons.category)),
                      SizedBox(height: 2.h),
                      TextFormField(controller: provider.descriptionController, decoration: inputDecoration('Description', Icons.notes)),
                      SizedBox(height: 2.h),
                      GestureDetector(
                          onTap: () => provider.selectDateTime(context),
                          child: AbsorbPointer(
                              absorbing: true,
                              child: TextFormField(
                                  readOnly: true,
                                  autofocus: false,
                                  controller: provider.date,
                                  decoration: inputDecoration('Date', Icons.date_range)))),
                      SizedBox(height: 2.h),
                      provider.showCategoryList ? const CategoriesChip() : const SizedBox(),
                    ]))),
                    SizedBox(
                        width: double.infinity,
                        height: 5.h,
                        child: ElevatedButton(
                            onPressed: () => provider.submitExpense(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text('Add Expense', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.white)))),
                    SizedBox(height: 1.h)
                  ])));
        }));
  }

  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue, width: 2)),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10));
  }
}
