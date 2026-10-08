import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';
import '../models/payment_model.dart';
import '../models/tenant_model.dart';
import '../models/property_model.dart';
import '../models/unit_model.dart';
import '../models/activity_model.dart';
import '../models/rent_invoice_model.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await Hive.initFlutter();
      
      Hive.registerAdapter(PropertyModelAdapter());
      Hive.registerAdapter(UnitModelAdapter());
      Hive.registerAdapter(TenantModelAdapter());
      Hive.registerAdapter(PaymentModelAdapter());
      Hive.registerAdapter(ActivityModelAdapter());
      Hive.registerAdapter(RentInvoiceModelAdapter());

      final settingsBox = await Hive.openBox('settings');
      final bool notificationsEnabled = settingsBox.get('notificationsEnabled', defaultValue: true);
      
      final savedReminders = settingsBox.get('rentReminders');
      List<String> rentReminders = ['3_days', '1_day', 'overdue'];
      if (savedReminders != null && savedReminders is List) {
        rentReminders = savedReminders.cast<String>().toList();
      }

      final tenantBox = await Hive.openBox<TenantModel>('tenants');
      final unitBox = await Hive.openBox<UnitModel>('units');
      final invoiceBox = await Hive.openBox<RentInvoiceModel>('rent_invoices');
      
      await NotificationService().init();
      final prefs = await SharedPreferences.getInstance();

      final now = DateTime.now();
      final todayStr = "${now.year}-${now.month}-${now.day}";
      final currentMonthStr = "${now.year}_${now.month}";

      // Generate Invoices for the current month
      if (prefs.getBool("invoices_generated_$currentMonthStr") != true) {
        // Run generation
        for (var tenant in tenantBox.values) {
          final unit = unitBox.values.firstWhere(
            (u) => u.id == tenant.unitId,
            orElse: () => UnitModel(id: '', propertyId: '', unitNumber: '', rentAmount: 0)
          );
          
          if (unit.id.isNotEmpty) {
            final monthYear = DateTime(now.year, now.month, 1);
            // check if invoice already exists for this tenant and month
            final existing = invoiceBox.values.where((i) => i.tenantId == tenant.id && i.monthYear == monthYear).toList();
            if (existing.isEmpty) {
              // Get previous month's invoice for carry-forward balance
              final lastMonth = DateTime(now.year, now.month - 1, 1);
              final prevInvoices = invoiceBox.values.where((i) => i.tenantId == tenant.id && i.monthYear == lastMonth).toList();
              double previousBalance = 0;
              if (prevInvoices.isNotEmpty) {
                previousBalance = prevInvoices.first.remainingBalance;
              }

              final newInvoice = RentInvoiceModel(
                id: DateTime.now().millisecondsSinceEpoch.toString() + tenant.id,
                tenantId: tenant.id,
                unitId: tenant.unitId,
                monthYear: monthYear,
                dueDate: DateTime(now.year, now.month, 5), // default due date is 5th of month
                baseRent: unit.rentAmount,
                serviceCharge: tenant.serviceCharge,
                otherCharges: 0,
                previousBalance: previousBalance,
                amountPaid: 0,
                status: 'Due',
              );
              await invoiceBox.put(newInvoice.id, newInvoice);
            }
          }
        }
        await prefs.setBool("invoices_generated_$currentMonthStr", true);
      }

      if (!notificationsEnabled) {
        return await Future.value(true);
      }

      // Check Invoices for Rent Reminders
      for (var invoice in invoiceBox.values) {
        if (invoice.status != 'Paid') {
          final difference = invoice.dueDate.difference(DateTime(now.year, now.month, now.day)).inDays;
          
          String? notificationType;
          String? title;
          String? body;

          if (difference == 7 && rentReminders.contains('7_days')) {
            notificationType = '7_days';
            title = 'Rent Reminder';
            body = 'Rent is due in 7 days.';
          } else if (difference == 3 && rentReminders.contains('3_days')) {
            notificationType = '3_days';
            title = '🔔 Rent due in 3 days';
            body = 'Rent of ৳${invoice.remainingBalance} is due in 3 days.';
          } else if (difference == 1 && rentReminders.contains('1_day')) {
            notificationType = '1_day';
            title = '🔔 Rent due tomorrow';
            body = 'Rent of ৳${invoice.remainingBalance} is due tomorrow.';
          } else if (difference == 0 && rentReminders.contains('due_date')) {
            notificationType = 'due_date';
            title = 'Rent Due Today';
            body = 'Rent of ৳${invoice.remainingBalance} is due today.';
          } else if (difference < 0 && rentReminders.contains('overdue')) {
            notificationType = 'overdue';
            title = '🔴 Rent overdue';
            body = 'Rent of ৳${invoice.remainingBalance} is overdue by ${-difference} days.';
          }

          if (notificationType != null) {
            final key = "notified_inv_${invoice.id}_${notificationType}_$todayStr";
            if (prefs.getBool(key) != true) {
              await NotificationService().showNotification(
                id: invoice.id.hashCode,
                title: title!,
                body: body!,
              );
              await prefs.setBool(key, true);
            }
          }
        }
      }

      // Check Leases
      for (var tenant in tenantBox.values) {
        final difference = tenant.leaseEnd.difference(DateTime(now.year, now.month, now.day)).inDays;
        
        if (difference == 30) {
          final key = "notified_lease_${tenant.id}_30_days";
          if (prefs.getBool(key) != true) {
            await NotificationService().showNotification(
              id: tenant.id.hashCode ^ 12345, // ensure unique ID
              title: '📅 Lease expires in 30 days',
              body: 'Lease for ${tenant.name} expires in 30 days.',
            );
            await prefs.setBool(key, true);
          }
        }
      }

    } catch (err) {
      if (kDebugMode) {
        print("Workmanager error: $err");
      }
    }
    return Future.value(true);
  });
}
