import 'dart:io';
import 'package:flutter/material.dart';
import 'package:home_rental_management/core/theme/app_theme.dart';
import 'package:home_rental_management/core/localization/app_localizations.dart';
import 'package:home_rental_management/core/services/notification_service.dart';
import 'package:home_rental_management/features/properties/presentation/widgets/add_unit_dialog.dart';
import 'package:home_rental_management/features/properties/presentation/widgets/edit_property_dialog.dart';
import 'package:home_rental_management/features/properties/presentation/widgets/edit_unit_dialog.dart';
import 'package:home_rental_management/features/tenants/presentation/providers/tenant_provider.dart';
import 'package:provider/provider.dart';
import '../../../../utils/app_provider.dart';
import '../providers/property_provider.dart';
import '../../../../core/providers/activity_provider.dart';
import 'package:go_router/go_router.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final String propertyId;

  const PropertyDetailsScreen({
    super.key,
    required this.propertyId,
  });

  void _confirmDelete(BuildContext context, PropertyProvider propertyProv, ActivityProvider actProv, String propertyName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Property'),
        content: const Text('Are you sure you want to delete this property? All associated units will also be deleted. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: context.cs.error),
            onPressed: () async {
              await propertyProv.deleteProperty(propertyId);
              actProv.logActivity(
                iconCode: 'business',
                titleKey: 'Property Deleted',
                subtitle: propertyName,
              );
              if (ctx.mounted) {
                Navigator.pop(ctx); // Close dialog
                context.pop(); // Go back to list
              }
            },
            child: Text('Delete', style: TextStyle(color: context.cs.onError)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final appProvider = Provider.of<AppProvider>(context);
    final propertyProv = context.watch<PropertyProvider>();
    final tenantProv = context.watch<TenantProvider>();
    final actProv = context.read<ActivityProvider>();
    
    final property = propertyProv.getProperty(propertyId);
    final units = propertyProv.getUnitsForProperty(propertyId);

    if (property == null) {
      return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back), onPressed: () => context.pop())),
        body: const Center(child: Text('Property not found.')),
      );
    }

    final occupiedUnits = units.where((u) => u.isOccupied).length;
    final occupancyRate =
        units.isEmpty ? 0 : (occupiedUnits / units.length * 100).round();

    return Scaffold(
      backgroundColor: context.cs.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: property.imagePath != null ? Colors.white : context.cs.onSurface,
              onPressed: () => context.pop(),
            ),
            actions: [
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: property.imagePath != null ? Colors.white : context.cs.onSurface),
                onSelected: (value) {
                  if (value == 'edit') {
                    showDialog(
                      context: context,
                      builder: (_) => EditPropertyDialog(property: property),
                    );
                  } else if (value == 'delete') {
                    _confirmDelete(context, propertyProv, actProv, property.name);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit, color: context.cs.primary),
                      title: const Text('Edit Property'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete, color: context.cs.error),
                      title: Text('Delete Property', style: TextStyle(color: context.cs.error)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                property.name,
                style: TextStyle(
                  color: property.imagePath != null ? Colors.white : context.cs.onSurface,
                  fontWeight: FontWeight.bold,
                  shadows: property.imagePath != null ? [
                    const Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ] : null,
                ),
              ),
              background: property.imagePath != null
                  ? Image.file(
                      File(property.imagePath!),
                      fit: BoxFit.cover,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [context.cs.primaryContainer, context.cs.primaryContainer],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Icon(Icons.business, size: 80, color: context.cs.primary.withValues(alpha: 0.5)),
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizations.propertyInformation,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: context.cs.onSurface),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.cs.primary,
                          foregroundColor: context.cs.onPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => AddUnitDialog(propertyId: propertyId));
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Unit'),
                      ),
                    ],
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
                  const SizedBox(height: 24),

                  // Units Overview
                  Text(
                    localizations.unitsOverview,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: context.cs.onSurface),
                  ),
                  const SizedBox(height: 12),
                  units.isEmpty
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          decoration: BoxDecoration(
                            color: context.cs.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: context.cs.outlineVariant),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.home_work_outlined, size: 48, color: context.cs.onSurfaceVariant),
                              const SizedBox(height: 16),
                              Text(
                                'No units added yet',
                                style: TextStyle(color: context.cs.onSurfaceVariant, fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Click "Add Unit" to get started',
                                style: TextStyle(color: context.cs.onSurfaceVariant, fontSize: 14),
                              ),
                            ],
                          ),
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
                                    context.push('/tenants/${unit.tenantId!}');
                                  }
                                },
                                onEdit: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => EditUnitDialog(unit: unit),
                                  );
                                },
                                onNotify: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                  );
                                  if (date == null || !context.mounted) return;
                                  
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (time == null || !context.mounted) return;
                                  
                                  final scheduledDate = DateTime(
                                    date.year, date.month, date.day, time.hour, time.minute
                                  );
                                  
                                  await NotificationService().scheduleNotification(
                                    id: unit.id.hashCode,
                                    title: 'Reminder: Unit ${unit.unitNumber}',
                                    body: 'Scheduled reminder for Unit ${unit.unitNumber}.',
                                    scheduledDate: scheduledDate,
                                  );
                                  
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Reminder set successfully!')),
                                    );
                                  }
                                },
                                onDelete: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Delete Unit'),
                                      content: const Text('Are you sure you want to delete this unit?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: context.cs.error),
                                          onPressed: () async {
                                            await propertyProv.deleteUnit(unit.id);
                                            actProv.logActivity(
                                              iconCode: 'apartment',
                                              titleKey: 'Unit Deleted',
                                              subtitle: 'Unit ${unit.unitNumber} from ${property.name}',
                                            );
                                            if (ctx.mounted) Navigator.pop(ctx);
                                          },
                                          child: Text('Delete', style: TextStyle(color: context.cs.onError)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                ],
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.cs.shadow.withValues(alpha: 0.06),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: context.cs.onSurfaceVariant, fontSize: 15)),
          Expanded(
            child: Text(
              value, 
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: context.cs.onSurface),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
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
  final VoidCallback onEdit;
  final VoidCallback onNotify;
  final VoidCallback onDelete;

  const _UnitCard({
    required this.unitNumber,
    this.tenant,
    required this.rent,
    required this.status,
    required this.onTap,
    required this.onEdit,
    required this.onNotify,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isOccupied = tenant != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.cs.shadow.withValues(alpha: 0.06),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isOccupied ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isOccupied ? context.appColors.successContainer : context.cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isOccupied ? context.appColors.success.withValues(alpha: 0.4) : context.cs.outlineVariant,
                    )
                  ),
                  child: Icon(
                    isOccupied ? Icons.home : Icons.home_outlined,
                    color: isOccupied ? context.appColors.success : context.cs.onSurfaceVariant,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unit $unitNumber',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: context.cs.onSurface),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tenant ?? status,
                        style: TextStyle(fontSize: 14, color: isOccupied ? context.cs.onSurfaceVariant : context.cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isOccupied ? context.cs.primaryContainer : context.cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        rent,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isOccupied ? context.cs.primary : context.cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: context.cs.onSurfaceVariant),
                      onSelected: (value) {
                        if (value == 'edit') {
                          onEdit();
                        } else if (value == 'notify') {
                          onNotify();
                        } else if (value == 'delete') {
                          onDelete();
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit, color: context.cs.primary),
                            title: const Text('Edit Unit'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'notify',
                          child: ListTile(
                            leading: Icon(Icons.notification_add, color: context.appColors.warning),
                            title: const Text('Set Reminder'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete, color: context.cs.error),
                            title: Text('Delete Unit', style: TextStyle(color: context.cs.error)),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
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
