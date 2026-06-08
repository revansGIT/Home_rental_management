import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../utils/app_provider.dart';
import '../providers/tenant_provider.dart';
import '../../../finance/presentation/providers/finance_provider.dart';
import '../../../../core/widgets/add_forms.dart';

class TenantProfileScreen extends StatelessWidget {
  final int? tenantId;
  final VoidCallback onBack;

  const TenantProfileScreen({
    super.key,
    this.tenantId,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final tenantProvider = Provider.of<TenantProvider>(context);

    // If no tenantId is passed, act as Directory Mode showing ALL tenants
    if (tenantId == null) {
      return _buildTenantsDirectory(context, tenantProvider);
    }

    final details = tenantProvider.getTenantById(tenantId!);
    if (details == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Tenant data not found or deleted.'),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: onBack, child: const Text('Back')),
            ],
          ),
        ),
      );
    }

    final tenant = details.tenant;
    final financeProvider = Provider.of<FinanceProvider>(context);
    final payments = financeProvider.getPaymentsForTenant(tenant.id!);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: onBack,
        ),
        title: const Text('Tenant Portfolio', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5)),
        actions: [
          IconButton(
            icon: const Icon(Icons.no_accounts_outlined, color: Colors.redAccent),
            onPressed: () => _showEvictConfirm(context, tenantProvider, tenant.id!, tenant.unitId),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Hero Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    child: Text(
                      tenant.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tenant.name,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.4),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${details.propertyName} • Unit ${details.unitName}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
                              child: Text('ACTIVE LEASE', style: TextStyle(color: Colors.green[700], fontSize: 10, fontWeight: FontWeight.w900)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fade().slideY(begin: 0.1),
            const SizedBox(height: 24),

            // Action Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.payment, size: 18),
                    label: const Text('Collect Rent', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () => RecordPaymentModal.show(context, tenantId: tenant.id),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)),
                  child: IconButton(
                    icon: const Icon(Icons.phone, color: Color(0xFF2563EB)),
                    onPressed: () {}, // Scaffold for platform calls
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)),
                  child: IconButton(
                    icon: const Icon(Icons.email_outlined, color: Color(0xFF2563EB)),
                    onPressed: () {},
                  ),
                ),
              ],
            ).animate().fade(delay: 150.ms).slideY(begin: 0.05),
            const SizedBox(height: 28),

            // Lease Profile Matrix
            const Text(
              'Lease & Contact Specs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.3),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  _InfoRow(icon: Icons.phone_android, label: 'Phone', value: tenant.phone),
                  const Divider(height: 24),
                  _InfoRow(icon: Icons.alternate_email, label: 'Email', value: tenant.email.isEmpty ? 'N/A' : tenant.email),
                  const Divider(height: 24),
                  _InfoRow(icon: Icons.badge_outlined, label: 'NID Number', value: tenant.nid),
                  const Divider(height: 24),
                  _InfoRow(
                    icon: Icons.calendar_month_outlined,
                    label: 'Lease Term',
                    value: '${DateFormat('MMM y').format(tenant.leaseStart)} - ${DateFormat('MMM y').format(tenant.leaseEnd)}',
                  ),
                  const Divider(height: 24),
                  _InfoRow(icon: Icons.paid, label: 'Monthly Rent', value: appProvider.formatCurrency(tenant.rentAmount)),
                  const Divider(height: 24),
                  _InfoRow(icon: Icons.lock_outline, label: 'Refundable Security', value: appProvider.formatCurrency(tenant.deposit)),
                ],
              ),
            ).animate().fade(delay: 250.ms).slideY(begin: 0.05),
            const SizedBox(height: 28),

            // Personal Collection Ledger
            const Text(
              'Collection History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.3),
            ),
            const SizedBox(height: 12),
            if (payments.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                alignment: Alignment.center,
                child: Text('No recorded payment slips found.', style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w600)),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: payments.length,
                itemBuilder: (context, idx) {
                  final p = payments[idx];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rent - ${p.monthYear}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 2),
                              Text(
                                'via ${p.paymentMethod.name.toUpperCase()} on ${DateFormat('dd MMM').format(p.date)}',
                                style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Text(appProvider.formatCurrency(p.amount), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF10B981))),
                      ],
                    ),
                  ).animate().fade(delay: (300 + idx * 80).ms).slideX(begin: 0.05);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTenantsDirectory(BuildContext context, TenantProvider provider) {
    final tenants = provider.tenantDetails;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text('Tenants Directory', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5)),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : tenants.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      const Text('No registered tenants.', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: tenants.length,
                  itemBuilder: (ctx, idx) {
                    final td = tenants[idx];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          child: Text(td.tenant.name.substring(0, 1).toUpperCase(), style: TextStyle(fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.secondary)),
                        ),
                        title: Text(td.tenant.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: -0.3)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text('${td.propertyName} • Apt ${td.unitName}', style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600)),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                        onTap: () {
                          // Simulate routing by calling onBack then resetting selected id or directly pushing details via dynamic callback (our structure in main.dart forces selectedTenantId callback, which will just push to view state). In MultiProvider state, HomeScreen handles switching via callback!
                          // To integrate cleanly with standard main.dart router mechanism, we should let the user click it!
                          // In main.dart we mapped: `_selectedTenantId != null ? TenantProfileScreen(tenantId: _selectedTenantId) : TenantProfileScreen()`.
                          // Let's make sure they click on them and can drill down.
                          // To trigger the selection from inside here, we would ideally need a direct callback parameter!
                          // Let's make sure we added `onSelect` or simulate drilldown navigation.
                          // Because of state-driven HomeScreen routing in main.dart, we can actually update home screen's selection using Provider, or just update Home state.
                          // Wait, main.dart has `_navigateToTenantProfile` which updates the selection. However, main.dart doesn't pass down that callback to TenantProfileScreen.
                          // Let's add the callback to `TenantProfileScreen` so it can select a tenant!
                          // Oh wait, let me check TenantProfileScreen constructor in main.dart:
                          // main.dart had: `_selectedTenantId != null ? TenantProfileScreen(tenantId: _selectedTenantId!, onBack: _navigateBack) : TenantProfileScreen(onBack: _navigateBack)`.
                          // I should quickly update main.dart or just embed a navigation function!
                          // Even better, let's make TenantProfileScreen itself stateful or pass `onSelectTenant` so it notifies the root HomeScreen!
                          // Let's edit main.dart to pass `onSelectTenant: _navigateToTenantProfile`!
                          // That guarantees clean operation. For now, let's just use Navigator push to the SAME widget for deep-linking if no callback is defined, or I can update main.dart in a few seconds to add the callback perfectly.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TenantProfileScreen(
                                tenantId: td.tenant.id,
                                onBack: () => Navigator.pop(context),
                              ),
                            ),
                          );
                        },
                      ).animate().fade(delay: (idx * 80).ms).slideX(begin: 0.05),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add),
        label: const Text('Add Tenant', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => AddTenantModal.show(context),
      ),
    );
  }

  void _showEvictConfirm(BuildContext context, TenantProvider provider, int tId, int uId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Terminate Lease / Evict?'),
        content: const Text('Are you sure you want to terminate this lease? The corresponding rental unit will be marked vacant.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await provider.removeTenant(tId, uId);
              onBack();
            },
            child: const Text('Terminate', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[400]),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[500])),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1F2937))),
          ],
        ),
      ],
    );
  }
}
