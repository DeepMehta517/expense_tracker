import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../add_expense_controller.dart';

class CategoriesChip extends StatelessWidget {
  const CategoriesChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddExpenseProvider>(
      builder: (context, provider, child) {
        return Wrap(
          spacing: 2.w,
          runSpacing: 2.w,
          children: provider.categories.map((category) {
            return GestureDetector(
              onTap: () => provider.categoryListClick(category),
              child: Chip(
                label: Text(
                  category,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.blue,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
