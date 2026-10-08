import 'package:hive/hive.dart';

part 'rent_invoice_model.g.dart';

@HiveType(typeId: 5)
class RentInvoiceModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String tenantId;

  @HiveField(2)
  final String unitId;

  @HiveField(3)
  final DateTime monthYear; // e.g., Oct 2026

  @HiveField(4)
  final DateTime dueDate;

  @HiveField(5)
  final double baseRent;

  @HiveField(6)
  final double serviceCharge;

  @HiveField(7)
  final double otherCharges;

  @HiveField(8)
  final double previousBalance; // carry-forward balance

  @HiveField(9)
  final double amountPaid;

  @HiveField(10)
  final String status; // 'Paid', 'Partially Paid', 'Due', 'Overdue'

  RentInvoiceModel({
    required this.id,
    required this.tenantId,
    required this.unitId,
    required this.monthYear,
    required this.dueDate,
    required this.baseRent,
    required this.serviceCharge,
    required this.otherCharges,
    required this.previousBalance,
    required this.amountPaid,
    required this.status,
  });

  double get totalDue => baseRent + serviceCharge + otherCharges + previousBalance;
  double get remainingBalance => totalDue - amountPaid;
  int get overdueDays {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (status != 'Paid' && dueDate.isBefore(today)) {
      return today.difference(dueDate).inDays;
    }
    return 0;
  }
}
