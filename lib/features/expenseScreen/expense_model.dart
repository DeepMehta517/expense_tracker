class Expense {
  final int? id;
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Expense({
    this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(), // Ensure double type
      category: json['category'],
      description: json['description'] ?? "",
      date: DateTime.parse(json['date']),
      userId: json['userId'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
