import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/models/payment_model.dart';

class FinanceProvider extends ChangeNotifier {
  final Box<PaymentModel> _paymentBox = Hive.box<PaymentModel>('payments');
  final _uuid = const Uuid();

  List<PaymentModel> get payments => _paymentBox.values.toList();

  List<PaymentModel> getPaymentsForTenant(String tenantId) {
    return _paymentBox.values.where((p) => p.tenantId == tenantId).toList();
  }

  double get totalCollected {
    return _paymentBox.values
        .where((p) => p.status == 'Collected')
        .fold(0.0, (sum, p) => sum + p.amount);
  }

  double get totalPending {
    return _paymentBox.values
        .where((p) => p.status == 'Pending')
        .fold(0.0, (sum, p) => sum + p.amount);
  }

  Future<void> addPayment(
    String tenantId,
    double amount,
    DateTime date,
    String status,
    String description,
  ) async {
    final newPayment = PaymentModel(
      id: _uuid.v4(),
      tenantId: tenantId,
      amount: amount,
      date: date,
      status: status,
      description: description,
    );
    await _paymentBox.put(newPayment.id, newPayment);
    notifyListeners();
  }

  Future<void> markAsCollected(String paymentId) async {
    final payment = _paymentBox.get(paymentId);
    if (payment != null) {
      final updated = PaymentModel(
        id: payment.id,
        tenantId: payment.tenantId,
        amount: payment.amount,
        date: payment.date,
        status: 'Collected',
        description: payment.description,
      );
      await _paymentBox.put(paymentId, updated);
      notifyListeners();
    }
  }
}
