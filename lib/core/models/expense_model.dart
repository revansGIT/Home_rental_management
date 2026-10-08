import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 6)
class ExpenseModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? propertyId;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String description;

  ExpenseModel({
    required this.id,
    this.propertyId,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
  });
}
