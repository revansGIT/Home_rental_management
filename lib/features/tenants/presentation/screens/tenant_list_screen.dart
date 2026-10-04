import 'package:flutter/material.dart';
import 'package:home_rental_management/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../providers/tenant_provider.dart';
import '../widgets/add_tenant_dialog.dart';

class TenantListScreen extends StatefulWidget {
  const TenantListScreen({super.key});

  @override
  State<TenantListScreen> createState() => _TenantListScreenState();
}

class _TenantListScreenState extends State<TenantListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final tenantProv = context.watch<TenantProvider>();
    final tenants = tenantProv.tenants.where((t) {
      if (_searchQuery.isEmpty) return true;
      return t.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
             t.phone.contains(_searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: context.cs.surface,
      appBar: CustomAppBar(
        title: localizations.tenants,
        showBackButton: false,
        actions: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: context.cs.primaryContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(Icons.person_add, color: context.cs.primary, size: 20),
            tooltip: 'Add Tenant', // Should be localized
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const AddTenantDialog(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search tenants...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: context.cs.surfaceContainerLow,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: tenants.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 80, color: context.cs.outlineVariant),
                        const SizedBox(height: 16),
                        Text(
                          'No tenants found',
                          style: TextStyle(fontSize: 18, color: context.cs.onSurfaceVariant, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Click + to add your first tenant',
                          style: TextStyle(fontSize: 14, color: context.cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 24, left: 16, right: 16),
              itemCount: tenants.length,
              itemBuilder: (context, index) {
                final tenant = tenants[index];
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  shadowColor: context.cs.shadow.withValues(alpha: 0.06),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: context.cs.primaryContainer,
                      radius: 24,
                      child: Icon(Icons.person, color: context.cs.primary),
                    ),
                    title: Text(
                      tenant.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      tenant.phone,
                      style: TextStyle(color: context.cs.onSurfaceVariant),
                    ),
                    trailing: Icon(Icons.chevron_right, color: context.cs.onSurfaceVariant),
                    onTap: () {
                      context.go('/tenants/${tenant.id}');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AddTenantDialog(),
          );
        },
        backgroundColor: context.cs.primary,
        icon: Icon(Icons.person_add, color: context.cs.onPrimary),
        label: Text('Add Tenant', style: TextStyle(color: context.cs.onPrimary, fontWeight: FontWeight.bold)),
        elevation: 4,
      ),
    );
  }
}
