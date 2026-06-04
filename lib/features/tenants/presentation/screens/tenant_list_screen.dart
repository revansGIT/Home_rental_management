import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../providers/tenant_provider.dart';
import '../widgets/add_tenant_dialog.dart';

class TenantListScreen extends StatelessWidget {
  const TenantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final tenantProv = context.watch<TenantProvider>();
    final tenants = tenantProv.tenants;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: localizations.tenants,
        showBackButton: false,
        actions: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.blue[50],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(Icons.person_add, color: Colors.blue[700], size: 20),
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
      body: tenants.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'No tenants found',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Click + to add your first tenant',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
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
                  shadowColor: Colors.grey.withValues(alpha: 0.1),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      radius: 24,
                      child: Icon(Icons.person, color: Colors.blue[700]),
                    ),
                    title: Text(
                      tenant.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      tenant.phone,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {
                      context.go('/tenants/${tenant.id}');
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AddTenantDialog(),
          );
        },
        backgroundColor: Colors.blue[700],
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text('Add Tenant', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 4,
      ),
    );
  }
}
