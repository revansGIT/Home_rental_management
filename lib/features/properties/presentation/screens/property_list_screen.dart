import 'package:flutter/material.dart';
import 'package:home_rental_management/core/localization/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../utils/app_provider.dart';
import '../providers/property_provider.dart';
import '../../../../core/widgets/add_forms.dart';

class PropertyListScreen extends StatefulWidget {
  final Function(int) onSelectProperty;

  const PropertyListScreen({super.key, required this.onSelectProperty});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final appProvider = Provider.of<AppProvider>(context);
    final propProvider = Provider.of<PropertyProvider>(context);

    final filteredProperties = propProvider.properties.where((p) {
      return p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.address.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(
          localizations.properties,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22, letterSpacing: -0.5),
        ),
      ),
      body: propProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: localizations.searchProperties,
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredProperties.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.business_rounded, size: 64, color: Colors.grey[300]),
                              const SizedBox(height: 16),
                              Text(
                                'No properties found',
                                style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredProperties.length,
                          itemBuilder: (context, index) {
                            final property = filteredProperties[index];
                            final numUnits = propProvider.getUnitsForProperty(property.id!).length;
                            final occRate = propProvider.getOccupancyRate(property.id!);

                            return _PropertyCard(
                              title: property.name,
                              subtitle: property.address,
                              unitsLabel: '$numUnits ${localizations.units}',
                              occupancyPercent: occRate,
                              onTap: () => widget.onSelectProperty(property.id!),
                            ).animate().fade(delay: (index * 100).ms).slideY(begin: 0.1, curve: Curves.easeOut);
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(localizations.addProperty, style: const TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => AddPropertyModal.show(context),
      ).animate().scale(delay: 500.ms, curve: Curves.elasticOut),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String unitsLabel;
  final double occupancyPercent;
  final VoidCallback onTap;

  const _PropertyCard({
    required this.title,
    required this.subtitle,
    required this.unitsLabel,
    required this.occupancyPercent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isFull = occupancyPercent >= 100.0;
    final isHigh = occupancyPercent >= 70.0;

    final statusColor = isFull
        ? const Color(0xFF10B981)
        : isHigh
            ? const Color(0xFF3B82F6)
            : const Color(0xFFF59E0B);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, spreadRadius: 0, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.business_rounded, color: statusColor, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: -0.3),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined, size: 12, color: Colors.grey[500]),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    subtitle,
                                    style: TextStyle(fontSize: 13, color: Colors.grey[500], fontWeight: FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        unitsLabel,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.grey[700]),
                      ),
                      Text(
                        '${occupancyPercent.toStringAsFixed(0)}% Occupied',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: statusColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Sleek Modern Linear Progress
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: occupancyPercent / 100.0,
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
