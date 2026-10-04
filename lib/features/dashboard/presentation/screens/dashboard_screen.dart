import 'package:flutter/material.dart';
import 'package:home_rental_management/core/theme/app_theme.dart';
import 'package:home_rental_management/core/localization/app_localizations.dart';
import 'package:home_rental_management/features/finance/presentation/providers/finance_provider.dart';
import 'package:home_rental_management/core/providers/activity_provider.dart';
import 'package:home_rental_management/features/finance/presentation/widgets/record_payment_dialog.dart';
import 'package:home_rental_management/features/properties/presentation/providers/property_provider.dart';
import 'package:home_rental_management/features/properties/presentation/widgets/add_property_dialog.dart';
import 'package:home_rental_management/features/tenants/presentation/providers/tenant_provider.dart';
import 'package:home_rental_management/features/tenants/presentation/widgets/add_tenant_dialog.dart';
import 'package:provider/provider.dart';
import '../../../../utils/app_provider.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final appProvider = Provider.of<AppProvider>(context);
    final propertyProv = context.watch<PropertyProvider>();
    final tenantProv = context.watch<TenantProvider>();
    final financeProv = context.watch<FinanceProvider>();
    final activityProv = context.watch<ActivityProvider>();

    int totalBuildings = propertyProv.properties.length;
    int totalUnits = propertyProv.units.length;
    int totalTenants = tenantProv.tenants.length;
    double collected = financeProv.totalCollected;
    double pending = financeProv.totalPending;

    return Scaffold(
      backgroundColor: context.cs.surface,
      appBar: CustomAppBar(
        subtitle: localizations.welcomeBack,
        title: localizations.propertyManagerDashboard,
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: localizations.buildings,
                    value: appProvider.formatNumber(totalBuildings),
                    icon: Icons.business,
                    color: context.cs.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: localizations.units,
                    value: appProvider.formatNumber(totalUnits),
                    icon: Icons.apartment,
                    color: context.appColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: localizations.totalTenants,
                    value: appProvider.formatNumber(totalTenants),
                    icon: Icons.people,
                    color: context.appColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: localizations.thisMonth,
                    value: appProvider.formatCurrency(collected),
                    icon: Icons.attach_money,
                    color: context.appColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Text(
              localizations.quickActions,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.add_business,
                    label: localizations.addProperty,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => const AddPropertyDialog());
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.person_add,
                    label: localizations.addTenant,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => const AddTenantDialog());
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.payment,
                    label: localizations.addPayment,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => const RecordPaymentDialog());
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Monthly Revenue
            Text(
              localizations.monthlyRevenue,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: context.cs.shadow.withValues(alpha: 0.06),
                    spreadRadius: 1,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.collectedVsPending,
                    style: TextStyle(fontSize: 14, color: context.cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.collected,
                            style: TextStyle(
                                fontSize: 12, color: context.cs.onSurfaceVariant),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            appProvider.formatCurrency(collected),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: context.appColors.success,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.pending,
                            style: TextStyle(
                                fontSize: 12, color: context.cs.onSurfaceVariant),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            appProvider.formatCurrency(pending),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: context.appColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent Activity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.recentActivity,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    context.push('/recent-activity');
                  },
                  child: Text(localizations.viewAll),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (activityProv.activities.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text('No recent activity')),
              )
            else
              ...activityProv.activities.take(3).map((activity) {
                IconData icon;
                switch (activity.iconCode) {
                  case 'business':
                    icon = Icons.business;
                    break;
                  case 'apartment':
                    icon = Icons.apartment;
                    break;
                  case 'person_add':
                    icon = Icons.person_add;
                    break;
                  case 'payment':
                    icon = Icons.payment;
                    break;
                  default:
                    icon = Icons.notifications;
                }
                return _ActivityItem(
                  icon: icon,
                  title: activity.titleKey,
                  subtitle: activity.subtitle,
                  time: timeago.format(activity.timestamp),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: context.cs.shadow.withValues(alpha: 0.06),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: TextStyle(fontSize: 12, color: context.cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: context.cs.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: context.cs.primary, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10, color: context.cs.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: context.cs.shadow.withValues(alpha: 0.06),
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.cs.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: context.cs.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: context.cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 12, color: context.cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
