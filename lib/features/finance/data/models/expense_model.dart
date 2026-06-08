class ExpenseModel {
  final int? id;
  final int propertyId;
  final String category; // Maintenance, Utility, Tax, Insurance, etc.
  final double amount;
  final DateTime date;
  final String description;

  ExpenseModel({
    this.id,
    required this.propertyId,
    required this.category,
    required this.amount,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'propertyId': propertyId,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] as int?,
      propertyId: map['propertyId'] as int,
      category: map['category'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      description: map['description'] as String,
    );
  }

  ExpenseModel copyWith({
    int? id,
    int? propertyId,
    String? category,
    double? amount,
    DateTime? date,
    String? description,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }
}
