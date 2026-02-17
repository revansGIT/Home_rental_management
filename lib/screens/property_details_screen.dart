import 'package:flutter/material.dart';
import 'package:home_rental_management/l10n/app_localizations.dart';

import 'package:provider/provider.dart';
import '../utils/app_provider.dart';

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

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: const Text(
          'Building 1',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
                  label: localizations.floors,
                  value: appProvider.formatNumber(5),
                ),
                _InfoRow(
                  label: localizations.totalSize,
                  value: '5,000 sq ft',
                ),
                _InfoRow(
                  label: localizations.yearBuilt,
                  value: appProvider.formatNumber(2015),
                ),
                _InfoRow(
                  label: localizations.occupancyRate,
                  value: '85%',
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) {
                return _UnitCard(
                  unitNumber: '${index + 1}A',
                  tenant: index % 3 == 0 ? null : 'Tenant ${index + 1}',
                  rent: appProvider.formatCurrency(15000 + index * 1000),
                  status: index % 3 == 0 ? localizations.vacant : localizations.occupied,
                  onTap: () {
                    if (index % 3 != 0) {
                      onViewTenant('tenant_$index');
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
            color: Colors.grey.withOpacity(0.1),
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
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
