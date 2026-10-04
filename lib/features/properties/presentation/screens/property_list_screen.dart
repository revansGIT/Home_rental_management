import 'package:flutter/material.dart';
import 'package:home_rental_management/core/theme/app_theme.dart';
import 'package:home_rental_management/core/localization/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/property_provider.dart';
import '../widgets/add_property_dialog.dart';
import '../../../../utils/app_provider.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final propertyProv = context.watch<PropertyProvider>();
    final appProvider = context.watch<AppProvider>();
    final properties = propertyProv.properties.where((p) {
      if (_searchQuery.isEmpty) return true;
      return p.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
             p.address.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: context.cs.surface,
      appBar: CustomAppBar(
        title: localizations.properties,
        showBackButton: false,
        actions: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: context.cs.primaryContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(Icons.add, color: context.cs.primary, size: 20),
            tooltip: localizations.addProperty,
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const AddPropertyDialog(),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: localizations.searchProperties,
                hintStyle: TextStyle(color: context.cs.onSurfaceVariant),
                prefixIcon: Icon(Icons.search, color: context.cs.onSurfaceVariant),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: context.cs.surfaceContainerLow,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: properties.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.business_outlined, size: 80, color: context.cs.outlineVariant),
                        const SizedBox(height: 16),
                        Text(
                          'No properties found',
                          style: TextStyle(fontSize: 18, color: context.cs.onSurfaceVariant, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Click + to add your first property',
                          style: TextStyle(fontSize: 14, color: context.cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 24, left: 16, right: 16),
                    itemCount: properties.length,
                    itemBuilder: (context, index) {
                      final prop = properties[index];
                      
                      // Calculate real metrics
                      final units = propertyProv.getUnitsForProperty(prop.id);
                      final totalUnits = units.length;
                      final occupiedUnits = units.where((u) => u.isOccupied).length;
                      final occupancyRate = totalUnits == 0 ? 0.0 : (occupiedUnits / totalUnits);
                      final monthlyValue = units.fold(0.0, (sum, unit) => sum + unit.rentAmount);

                      return _PropertyCard(
                        title: prop.name,
                        address: prop.address,
                        unitsText: '$totalUnits ${localizations.units}',
                        revenue: appProvider.formatCurrency(monthlyValue),
                        occupancyRate: occupancyRate,
                        onTap: () => context.go('/properties/${prop.id}'),
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
            builder: (_) => const AddPropertyDialog(),
          );
        },
        backgroundColor: context.cs.primary,
        icon: Icon(Icons.add_business, color: context.cs.onPrimary),
        label: Text(localizations.addProperty, style: TextStyle(color: context.cs.onPrimary, fontWeight: FontWeight.bold)),
        elevation: 4,
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final String title;
  final String address;
  final String unitsText;
  final String revenue;
  final double occupancyRate;
  final VoidCallback onTap;

  const _PropertyCard({
    required this.title,
    required this.address,
    required this.unitsText,
    required this.revenue,
    required this.occupancyRate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: context.cs.shadow.withValues(alpha: 0.06),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [context.cs.primary.withValues(alpha: 0.75), context.cs.primary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: context.cs.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      ),
                      child: Icon(Icons.business, color: context.cs.onPrimary, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: context.cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 14, color: context.cs.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  address,
                                  style: TextStyle(fontSize: 13, color: context.cs.onSurfaceVariant),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: context.cs.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        unitsText,
                        style: TextStyle(
                          color: context.cs.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.cs.outlineVariant),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monthly Value',
                            style: TextStyle(fontSize: 12, color: context.cs.onSurfaceVariant, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            revenue,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: context.cs.onSurface,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 32,
                        width: 1,
                        color: context.cs.outlineVariant,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Occupancy',
                            style: TextStyle(fontSize: 12, color: context.cs.onSurfaceVariant, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              SizedBox(
                                width: 60,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: occupancyRate,
                                    minHeight: 6,
                                    backgroundColor: context.cs.outlineVariant,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      occupancyRate >= 0.8 ? context.appColors.success : (occupancyRate >= 0.5 ? context.appColors.warning : context.cs.error)
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${(occupancyRate * 100).toInt()}%',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: context.cs.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
