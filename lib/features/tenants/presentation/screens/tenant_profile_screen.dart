import 'package:flutter/material.dart';
import 'package:home_rental_management/core/localization/app_localizations.dart';
import 'package:home_rental_management/features/finance/presentation/providers/finance_provider.dart';
import 'package:home_rental_management/features/properties/presentation/providers/property_provider.dart';

import 'package:provider/provider.dart';
import '../../../../utils/app_provider.dart';
import '../providers/tenant_provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/providers/activity_provider.dart';
import 'package:home_rental_management/features/tenants/presentation/widgets/edit_tenant_dialog.dart';

class TenantProfileScreen extends StatelessWidget {
  final String tenantId;

  const TenantProfileScreen({
    super.key,
    required this.tenantId,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final appProvider = Provider.of<AppProvider>(context);
    final tenantProv = context.watch<TenantProvider>();
    final propertyProv = context.watch<PropertyProvider>();
    final financeProv = context.watch<FinanceProvider>();

    final tenant = tenantProv.getTenant(tenantId);

    if (tenant == null) {
      return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back), onPressed: () => context.pop())),
        body: const Center(child: Text('Tenant not found.')),
      );
    }

    final unit = propertyProv.units.firstWhere((u) => u.id == tenant.unitId,
        orElse: () => throw Exception('Unit not found'));
    final property = propertyProv.getProperty(unit.propertyId);

    final payments = financeProv.getPaymentsForTenant(tenant.id);
    final totalPaid = payments
        .where((p) => p.status == 'Collected')
        .fold(0.0, (sum, p) => sum + p.amount);
    final onTimeCount = payments.where((p) => p.status == 'Collected').length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: tenant.name,
        subtitle: 'Tenant Profile',
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onSelected: (value) {
              if (value == 'edit') {
                showDialog(
                  context: context,
                  builder: (_) => EditTenantDialog(tenant: tenant),
                );
              } else if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Tenant'),
                    content: const Text('Are you sure you want to delete this tenant?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () async {
                          final propertyProv = context.read<PropertyProvider>();
                          final actProv = context.read<ActivityProvider>();
                          
                          // First remove tenant from their assigned unit
                          await propertyProv.removeTenantFromUnit(tenant.unitId);
                          // Delete the tenant
                          await tenantProv.removeTenant(tenant.id);
                          
                          actProv.logActivity(
                            iconCode: 'person_add',
                            titleKey: 'Tenant Deleted',
                            subtitle: tenant.name,
                          );
                          
                          if (ctx.mounted) {
                            Navigator.pop(ctx);
                            context.pop(); // Go back to tenant list
                          }
                        },
                        child: const Text('Delete', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit, color: Colors.blue),
                  title: Text('Edit Tenant'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Delete Tenant', style: TextStyle(color: Colors.red)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tenant Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue[100],
                    child:
                        Icon(Icons.person, size: 40, color: Colors.blue[700]),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tenant.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${property?.name ?? "Unknown"} - Unit ${unit.unitNumber}',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tenant.phone,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Lease Information
            Text(
              localizations.leaseInformation,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _InfoRow(
                      label: localizations.leaseStart,
                      value:
                          DateFormat('MMM d, yyyy').format(tenant.leaseStart)),
                  _InfoRow(
                      label: localizations.leaseEnd,
                      value: DateFormat('MMM d, yyyy').format(tenant.leaseEnd)),
                  _InfoRow(
                    label: localizations.monthlyRent,
                    value: appProvider.formatCurrency(unit.rentAmount),
                  ),
                  _InfoRow(
                    label: localizations.securityDeposit,
                    value: appProvider.formatCurrency(tenant.advancePaid),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Payment Overview
            Text(
              localizations.paymentOverview,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: localizations.totalPaid,
                    value: appProvider.formatCurrency(totalPaid),
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: localizations.onTime,
                    value: appProvider.formatNumber(onTimeCount),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Payment History
            Text(
              localizations.paymentHistory,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            payments.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: Text('No payments recorded.')),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: payments.length,
                    itemBuilder: (context, index) {
                      final payment = payments[index];
                      return _PaymentHistoryItem(
                        date: DateFormat('MMM d, yyyy').format(payment.date),
                        amount: appProvider.formatCurrency(payment.amount),
                        status: payment.status,
                      );
                    },
                  ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.payment),
                    label: Text(localizations.recordPayment),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.message),
                    label: Text(localizations.sendMessage),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _PaymentHistoryItem extends StatelessWidget {
  final String date;
  final String amount;
  final String status;

  const _PaymentHistoryItem({
    required this.date,
    required this.amount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                amount,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(fontSize: 12, color: Colors.green[700]),
            ),
          ),
        ],
      ),
    );
  }
}
