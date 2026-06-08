import 'package:flutter/material.dart';
import 'package:home_rental_management/core/localization/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../utils/app_provider.dart';
import '../providers/property_provider.dart';
import '../../../tenants/presentation/providers/tenant_provider.dart';
import '../../../../core/widgets/add_forms.dart';
import '../../data/models/unit_model.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final int propertyId;
  final VoidCallback onBack;
  final Function(int) onViewTenant;

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
    final propProvider = Provider.of<PropertyProvider>(context);
    final tenantProvider = Provider.of<TenantProvider>(context);

    // Safe lookup
    final propertyList = propProvider.properties.where((p) => p.id == propertyId).toList();
    if (propertyList.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final property = propertyList.first;
    final units = propProvider.getUnitsForProperty(propertyId);
    final occRate = propProvider.getOccupancyRate(propertyId);

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
        title: Text(
          property.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.5),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => _showDeleteConfirm(context, propProvider),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image/Card
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1E3A8A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.2), blurRadius: 20, spreadRadius: 0, offset: const Offset(0, 10)),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Icon(Icons.business_rounded, size: 180, color: Colors.white.withOpacity(0.1)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.apartment_rounded, size: 48, color: Colors.white),
                        const Spacer(),
                        Text(
                          property.address,
                          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Occupancy: ${occRate.toStringAsFixed(0)}%',
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().scale(delay: 100.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 24),

            // Quick Metrics
            Text(
              localizations.propertyInformation,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.3),
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
                  _DetailsRow(label: localizations.floors, value: appProvider.formatNumber(property.floors)),
                  const Divider(height: 24),
                  _DetailsRow(label: localizations.totalSize, value: '${appProvider.formatNumber(property.totalSize.toInt())} sq ft'),
                  const Divider(height: 24),
                  _DetailsRow(label: localizations.yearBuilt, value: appProvider.formatNumber(property.yearBuilt)),
                ],
              ),
            ).animate().fade(delay: 200.ms).slideY(begin: 0.05),
            const SizedBox(height: 28),

            // Units Header & Add Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.unitsOverview,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.3),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Unit', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () => AddUnitModal.show(context, propertyId),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Units Listing
            if (units.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text('No units added to this building yet.', style: TextStyle(color: Colors.grey[400])),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: units.length,
                itemBuilder: (context, idx) {
                  final unit = units[idx];
                  final isOccupied = unit.status == UnitStatus.occupied;
                  // If occupied, lookup resident
                  final linkedTenant = isOccupied
                      ? tenantProvider.tenantDetails.firstWhere(
                          (td) => td.tenant.unitId == unit.id,
                          orElse: () => TenantDetails(
                              tenant: null as dynamic,
                              propertyName: '',
                              unitName: '')) // will fail gracefully or just empty
                      : null;

                  return _UnitCard(
                    unitNumber: unit.unitNumber,
                    tenantName: isOccupied ? (linkedTenant?.tenant.name ?? 'Active Tenant') : null,
                    rentAmount: appProvider.formatCurrency(unit.rentAmount),
                    isOccupied: isOccupied,
                    onTap: () {
                      if (isOccupied && linkedTenant != null && linkedTenant.tenant != null) {
                        onViewTenant(linkedTenant.tenant.id!);
                      }
                    },
                  ).animate().fade(delay: (250 + idx * 80).ms).slideX(begin: 0.05);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, PropertyProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Property?'),
        content: const Text('Are you sure? All attached Units, Tenants, and Records will be permanently erased.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx); // close dialog
              await provider.deleteProperty(propertyId);
              onBack(); // return to list
            },
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

class _DetailsRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailsRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[500])),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1F2937))),
      ],
    );
  }
}

class _UnitCard extends StatelessWidget {
  final String unitNumber;
  final String? tenantName;
  final String rentAmount;
  final bool isOccupied;
  final VoidCallback onTap;

  const _UnitCard({
    required this.unitNumber,
    required this.tenantName,
    required this.rentAmount,
    required this.isOccupied,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isOccupied ? const Color(0xFF10B981) : const Color(0xFF9CA3AF);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isOccupied ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(isOccupied ? Icons.door_back_door : Icons.door_back_door_outlined, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unit $unitNumber',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: -0.2),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isOccupied ? 'Leased to: $tenantName' : 'Vacant',
                        style: TextStyle(fontSize: 12, color: isOccupied ? Colors.grey[600] : Colors.grey[400], fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(rentAmount, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: color)),
                    const SizedBox(height: 2),
                    if (isOccupied)
                      Text('Tap to view Profile', style: TextStyle(fontSize: 10, color: Colors.grey[400], fontWeight: FontWeight.w600))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
