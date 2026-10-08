import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/models/payment_model.dart';
import '../../../../core/models/rent_invoice_model.dart';

class FinanceProvider extends ChangeNotifier {
  final Box<PaymentModel> _paymentBox = Hive.box<PaymentModel>('payments');
  final Box<RentInvoiceModel> _invoiceBox = Hive.box<RentInvoiceModel>('rent_invoices');
  final _uuid = const Uuid();

  List<PaymentModel> get payments => _paymentBox.values.toList();
  List<RentInvoiceModel> get invoices => _invoiceBox.values.toList();

  List<PaymentModel> getPaymentsForTenant(String tenantId) {
    return _paymentBox.values.where((p) => p.tenantId == tenantId).toList();
  }

  List<RentInvoiceModel> getInvoicesForTenant(String tenantId) {
    return _invoiceBox.values.where((i) => i.tenantId == tenantId).toList();
  }

  RentInvoiceModel? getInvoice(String id) {
    return _invoiceBox.get(id);
  }

  double get totalCollected {
    return _paymentBox.values
        .where((p) => p.status == 'Collected')
        .fold(0.0, (sum, p) => sum + p.amount);
  }

  double get totalPending {
    return _invoiceBox.values
        .where((i) => i.status != 'Paid')
        .fold(0.0, (sum, i) => sum + i.remainingBalance);
  }

  Future<void> addPayment(
    String tenantId,
    double amount,
    DateTime date,
    String status,
    String description,
    {String? invoiceId}
  ) async {
    final newPayment = PaymentModel(
      id: _uuid.v4(),
      tenantId: tenantId,
      amount: amount,
      date: date,
      status: status,
      description: description,
      invoiceId: invoiceId,
    );
    await _paymentBox.put(newPayment.id, newPayment);

    if (invoiceId != null && status == 'Collected') {
      final invoice = _invoiceBox.get(invoiceId);
      if (invoice != null) {
        final newPaid = invoice.amountPaid + amount;
        String newStatus = invoice.status;
        if (newPaid >= invoice.totalDue) {
          newStatus = 'Paid';
        } else if (newPaid > 0) {
          newStatus = 'Partially Paid';
        }
        
        final updatedInvoice = RentInvoiceModel(
          id: invoice.id,
          tenantId: invoice.tenantId,
          unitId: invoice.unitId,
          monthYear: invoice.monthYear,
          dueDate: invoice.dueDate,
          baseRent: invoice.baseRent,
          serviceCharge: invoice.serviceCharge,
          otherCharges: invoice.otherCharges,
          previousBalance: invoice.previousBalance,
          amountPaid: newPaid,
          status: newStatus,
        );
        await _invoiceBox.put(invoiceId, updatedInvoice);
      }
    }

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
        invoiceId: payment.invoiceId,
      );
      await _paymentBox.put(paymentId, updated);
      
      if (payment.invoiceId != null) {
        final invoice = _invoiceBox.get(payment.invoiceId);
        if (invoice != null) {
          final newPaid = invoice.amountPaid + payment.amount;
          String newStatus = invoice.status;
          if (newPaid >= invoice.totalDue) {
            newStatus = 'Paid';
          } else if (newPaid > 0) {
            newStatus = 'Partially Paid';
          }
          
          final updatedInvoice = RentInvoiceModel(
            id: invoice.id,
            tenantId: invoice.tenantId,
            unitId: invoice.unitId,
            monthYear: invoice.monthYear,
            dueDate: invoice.dueDate,
            baseRent: invoice.baseRent,
            serviceCharge: invoice.serviceCharge,
            otherCharges: invoice.otherCharges,
            previousBalance: invoice.previousBalance,
            amountPaid: newPaid,
            status: newStatus,
          );
          await _invoiceBox.put(payment.invoiceId, updatedInvoice);
        }
      }

      notifyListeners();
    }
  }

  Future<void> addInvoice(RentInvoiceModel invoice) async {
    await _invoiceBox.put(invoice.id, invoice);
    notifyListeners();
  }
}
