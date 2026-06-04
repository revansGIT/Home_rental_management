import 'package:flutter/material.dart';
import 'package:home_rental_management/core/localization/app_localizations.dart';
import 'package:home_rental_management/features/properties/presentation/widgets/add_unit_dialog.dart';
import 'package:home_rental_management/features/tenants/presentation/providers/tenant_provider.dart';

import 'package:provider/provider.dart';
import '../../../../utils/app_provider.dart';
import '../providers/property_provider.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final String propertyId;
  final VoidCallback onBack;
  final Function(String) onViewTenant;

  const PropertyDetailsScreen({
    super.key,
    required this.propertyId,
    required this.onBack,
    required this.onViewTenant,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final appProvider = Provider.of<AppProvider>(context);
    final propertyProv = context.watch<PropertyProvider>();
    final tenantProv = context.watch<TenantProvider>();
    final property = propertyProv.getProperty(propertyId);
    final units = propertyProv.getUnitsForProperty(propertyId);

    if (property == null) {
      return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back), onPressed: onBack)),
        body: const Center(child: Text('Property not found.')),
      );
    }

    final occupiedUnits = units.where((u) => u.isOccupied).length;
    final occupancyRate =
        units.isEmpty ? 0 : (occupiedUnits / units.length * 100).round();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: Text(
          property.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Unit',
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => AddUnitDialog(propertyId: propertyId));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(Icons.business, size: 80, color: Colors.blue[700]),
              ),
            ),
            const SizedBox(height: 16),

            // Property Information
            Text(
              localizations.propertyInformation,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _InfoCard(
              children: [
                _InfoRow(
                  label: localizations.units,
                  value: appProvider.formatNumber(property.totalUnits),
                ),
                _InfoRow(
                  label: 'Address',
                  value: property.address,
                ),
                _InfoRow(
                  label: localizations.yearBuilt,
                  value: appProvider.formatNumber(property.yearBuilt),
                ),
                _InfoRow(
                  label: localizations.occupancyRate,
                  value: '$occupancyRate%',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Units Overview
            Text(
              localizations.unitsOverview,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            units.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                        child: Text('No units added yet. Click + to add one.')),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: units.length,
                    itemBuilder: (context, index) {
                      final unit = units[index];
                      final tenant = unit.isOccupied
                          ? tenantProv.getTenant(unit.tenantId!)
                          : null;

                      return _UnitCard(
                        unitNumber: unit.unitNumber,
                        tenant: tenant?.name,
                        rent: appProvider.formatCurrency(unit.rentAmount),
                        status: unit.isOccupied
                            ? localizations.occupied
                            : localizations.vacant,
                        onTap: () {
                          if (unit.isOccupied && unit.tenantId != null) {
                            onViewTenant(unit.tenantId!);
                          }
                        },
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({required this.children});

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
      child: Column(children: children),
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

class _UnitCard extends StatelessWidget {
  final String unitNumber;
  final String? tenant;
  final String rent;
  final String status;
  final VoidCallback onTap;

  const _UnitCard({
    required this.unitNumber,
    this.tenant,
    required this.rent,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOccupied = tenant != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: isOccupied ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isOccupied ? Colors.green[50] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isOccupied ? Icons.home : Icons.home_outlined,
                  color: isOccupied ? Colors.green[700] : Colors.grey[500],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Unit $unitNumber',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tenant ?? status,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Text(
                rent,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isOccupied ? Colors.green[700] : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
