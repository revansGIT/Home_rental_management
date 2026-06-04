import 'package:hive/hive.dart';

part 'payment_model.g.dart';

@HiveType(typeId: 3)
class PaymentModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String tenantId;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String status; // 'Collected' or 'Pending'

  @HiveField(5)
  final String description;

  PaymentModel({
    required this.id,
    required this.tenantId,
    required this.amount,
    required this.date,
    required this.status,
    required this.description,
  });
}
