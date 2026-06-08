import 'package:flutter/material.dart';
import '../../../../core/services/database_helper.dart';
import '../../data/models/payment_model.dart';
import '../../data/models/expense_model.dart';

class FinanceProvider extends ChangeNotifier {
  final _db = DatabaseHelper.instance;

  List<PaymentModel> _payments = [];
  List<ExpenseModel> _expenses = [];
  bool _isLoading = false;

  List<PaymentModel> get payments => _payments;
  List<ExpenseModel> get expenses => _expenses;
  bool get isLoading => _isLoading;

  FinanceProvider() {
    refreshData();
  }

  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final payMaps = await _db.queryAll('payments', orderBy: 'date DESC');
      _payments = payMaps.map((map) => PaymentModel.fromMap(map)).toList();

      final expMaps = await _db.queryAll('expenses', orderBy: 'date DESC');
      _expenses = expMaps.map((map) => ExpenseModel.fromMap(map)).toList();
    } catch (e) {
      debugPrint('Error fetching financial records: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // --- Revenue / Collected Analytics ---

  double getCollectedRevenue({int? propertyId, String? monthYear}) {
    return _payments
        .where((p) => p.status == PaymentStatus.paid)
        .where((p) => monthYear == null || p.monthYear == monthYear)
        .fold(0.0, (sum, p) => sum + p.amount);
  }

  double getPendingRevenue({int? propertyId, String? monthYear}) {
    return _payments
        .where((p) => p.status == PaymentStatus.pending || p.status == PaymentStatus.overdue)
        .where((p) => monthYear == null || p.monthYear == monthYear)
        .fold(0.0, (sum, p) => sum + p.amount);
  }

  double getTotalExpenses({int? propertyId}) {
    return _expenses
        .where((e) => propertyId == null || e.propertyId == propertyId)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  List<PaymentModel> getPaymentsForTenant(int tenantId) {
    return _payments.where((p) => p.tenantId == tenantId).toList();
  }

  Map<String, double> getExpenseBreakdown() {
    final Map<String, double> breakdown = {};
    for (var exp in _expenses) {
      breakdown[exp.category] = (breakdown[exp.category] ?? 0) + exp.amount;
    }
    return breakdown;
  }

  Future<void> recordPayment(PaymentModel payment) async {
    await _db.insert('payments', payment.toMap());
    await refreshData();
  }

  Future<void> addExpense(ExpenseModel expense) async {
    await _db.insert('expenses', expense.toMap());
    await refreshData();
  }
}
