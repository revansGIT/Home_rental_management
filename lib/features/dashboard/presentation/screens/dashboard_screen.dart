import 'package:flutter/material.dart';
import 'package:home_rental_management/core/localization/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../../utils/app_provider.dart';
import '../../../properties/presentation/providers/property_provider.dart';
import '../../../tenants/presentation/providers/tenant_provider.dart';
import '../../../finance/presentation/providers/finance_provider.dart';
import '../../../../core/widgets/add_forms.dart';

class DashboardScreen extends StatelessWidget {
  final Function(int) onNavigateToProperty;
  final Function(int) onNavigateToTenant;

  const DashboardScreen({
    super.key,
    required this.onNavigateToProperty,
    required this.onNavigateToTenant,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final appProvider = Provider.of<AppProvider>(context);

    final propProvider = Provider.of<PropertyProvider>(context);
    final tenantProvider = Provider.of<TenantProvider>(context);
    final financeProvider = Provider.of<FinanceProvider>(context);

    final double collected = financeProvider.getCollectedRevenue();
    final double pending = financeProvider.getPendingRevenue();
    final double total = collected + pending;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Clean subtle background
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.welcomeBack,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500),
                ),
                Text(
                  'Property Manager',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Badge(label: Text('3'), child: Icon(Icons.notifications_none)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await propProvider.refreshData();
          await tenantProvider.refreshData();
          await financeProvider.refreshData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Highlights / Summary Metrics Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.4,
                children: [
                  _ModernStatCard(
                    title: localizations.buildings,
                    value: appProvider.formatNumber(propProvider.properties.length),
                    icon: Icons.business,
                    gradient: const [Color(0xFF3B82F6), Color(0xFF2563EB)],
                  ).animate().fade(delay: 100.ms).slideY(begin: 0.1),
                  _ModernStatCard(
                    title: localizations.units,
                    value: appProvider.formatNumber(propProvider.allUnits.length),
                    icon: Icons.apartment,
                    gradient: const [Color(0xFF10B981), Color(0xFF059669)],
                  ).animate().fade(delay: 200.ms).slideY(begin: 0.1),
                  _ModernStatCard(
                    title: localizations.totalTenants,
                    value: appProvider.formatNumber(tenantProvider.tenants.length),
                    icon: Icons.people_rounded,
                    gradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
                  ).animate().fade(delay: 300.ms).slideY(begin: 0.1),
                  _ModernStatCard(
                    title: 'Collections',
                    value: appProvider.formatCurrency(collected),
                    icon: Icons.account_balance_wallet,
                    gradient: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                  ).animate().fade(delay: 400.ms).slideY(begin: 0.1),
                ],
              ),
              const SizedBox(height: 28),

              // Quick Action Panel
              Text(
                localizations.quickActions,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.5),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, spreadRadius: 0, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ActionIconBtn(
                      icon: Icons.add_business_rounded,
                      label: localizations.addProperty,
                      color: const Color(0xFF3B82F6),
                      onTap: () => AddPropertyModal.show(context),
                    ),
                    _ActionIconBtn(
                      icon: Icons.person_add_rounded,
                      label: localizations.addTenant,
                      color: const Color(0xFF10B981),
                      onTap: () => AddTenantModal.show(context),
                    ),
                    _ActionIconBtn(
                      icon: Icons.paid_rounded,
                      label: 'Record Rent',
                      color: const Color(0xFFF59E0B),
                      onTap: () => RecordPaymentModal.show(context),
                    ),
                    _ActionIconBtn(
                      icon: Icons.build_rounded,
                      label: 'Log Expense',
                      color: Colors.redAccent,
                      onTap: () => AddExpenseModal.show(context),
                    ),
                  ],
                ),
              ).animate().fade(delay: 450.ms).slideY(begin: 0.1),
              const SizedBox(height: 28),

              // Interactive Analytics Ring Chart
              Text(
                localizations.monthlyRevenue,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.5),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, spreadRadius: 0, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: total == 0
                          ? PieChart(PieChartData(sections: [
                              PieChartSectionData(value: 1, color: Colors.grey[200], showTitle: false, radius: 16),
                            ]))
                          : PieChart(
                              PieChartData(
                                sectionsSpace: 4,
                                centerSpaceRadius: 32,
                                sections: [
                                  PieChartSectionData(
                                    color: const Color(0xFF10B981),
                                    value: collected,
                                    title: '${((collected / total) * 100).toStringAsFixed(0)}%',
                                    radius: 16,
                                    titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  PieChartSectionData(
                                    color: const Color(0xFFF59E0B),
                                    value: pending > 0 ? pending : 1,
                                    title: pending > 0 ? '${((pending / total) * 100).toStringAsFixed(0)}%' : '',
                                    radius: 16,
                                    titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        children: [
                          _RevenueIndicator(
                            label: localizations.collected,
                            amount: appProvider.formatCurrency(collected),
                            color: const Color(0xFF10B981),
                          ),
                          const Divider(height: 16),
                          _RevenueIndicator(
                            label: 'Pending/Est.',
                            amount: appProvider.formatCurrency(pending),
                            color: const Color(0xFFF59E0B),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fade(delay: 550.ms).slideY(begin: 0.1),
              const SizedBox(height: 28),

              // Recent Database Transactions / Activities Feed
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localizations.recentActivity,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(localizations.viewAll, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (financeProvider.payments.isEmpty && financeProvider.expenses.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text('No recent logs found', style: TextStyle(color: Colors.grey[400])),
                  ),
                )
              else
                ...[
                  ...financeProvider.payments.take(3).map((pay) {
                    final tenant = tenantProvider.getTenantById(pay.tenantId);
                    return _ActivityFeedCard(
                      icon: Icons.paid,
                      title: 'Collection: ${tenant?.tenant.name ?? 'Tenant'}',
                      subtitle: '${pay.monthYear} • via ${pay.paymentMethod.name.toUpperCase()}',
                      trailing: '+${appProvider.formatCurrency(pay.amount)}',
                      color: const Color(0xFF10B981),
                      time: DateFormat('MMM dd').format(pay.date),
                    );
                  }),
                  ...financeProvider.expenses.take(2).map((exp) {
                    return _ActivityFeedCard(
                      icon: Icons.construction_rounded,
                      title: exp.category,
                      subtitle: exp.description,
                      trailing: '-${appProvider.formatCurrency(exp.amount)}',
                      color: Colors.redAccent,
                      time: DateFormat('MMM dd').format(exp.date),
                    );
                  })
                ].animate(interval: 100.ms).fade().slideX(begin: 0.05),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final List<Color> gradient;

  const _ModernStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: gradient.last.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(icon, size: 56, color: Colors.white.withOpacity(0.15)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const Spacer(),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 2),
              Text(title, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionIconBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionIconBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _RevenueIndicator extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;

  const _RevenueIndicator({required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[600])),
          ],
        ),
        Text(amount, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _ActivityFeedCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;
  final Color color;
  final String time;

  const _ActivityFeedCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.color,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, spreadRadius: 0, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: -0.2)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                trailing,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: trailing.startsWith('+') ? const Color(0xFF10B981) : Colors.redAccent,
                ),
              ),
              const SizedBox(height: 2),
              Text(time, style: TextStyle(fontSize: 10, color: Colors.grey[400], fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
