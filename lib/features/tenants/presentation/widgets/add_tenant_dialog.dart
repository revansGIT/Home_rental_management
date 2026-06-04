import 'package:flutter/material.dart';
import 'package:home_rental_management/features/properties/presentation/providers/property_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/activity_provider.dart';
import '../providers/tenant_provider.dart';

class AddTenantDialog extends StatefulWidget {
  const AddTenantDialog({super.key});

  @override
  State<AddTenantDialog> createState() => _AddTenantDialogState();
}

class _AddTenantDialogState extends State<AddTenantDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phone = '';
  String? _selectedUnitId;
  double _advance = 0.0;
  double _serviceCharge = 0.0;

  @override
  Widget build(BuildContext context) {
    final propertiesProv = context.watch<PropertyProvider>();
    final availableUnits =
        propertiesProv.units.where((u) => !u.isOccupied).toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 400,
        child: availableUnits.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                    'No vacant units available. Please add a unit first.',
                    textAlign: TextAlign.center),
              )
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add New Tenant',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Tenant Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Required' : null,
                        onSaved: (val) => _name = val!,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.phone),
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Required' : null,
                        onSaved: (val) => _phone = val!,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Assign Unit',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.meeting_room),
                        ),
                        items: availableUnits.map((u) {
                          final prop = propertiesProv.getProperty(u.propertyId);
                          return DropdownMenuItem(
                            value: u.id,
                            child: Text(
                                '${prop?.name ?? "Unknown"} - Unit ${u.unitNumber}'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedUnitId = val;
                          });
                        },
                        validator: (val) =>
                            val == null ? 'Please select a unit' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Advance Paid',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                prefixIcon: const Icon(Icons.money),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (val) => val == null || val.isEmpty
                                  ? 'Required'
                                  : null,
                              onSaved: (val) =>
                                  _advance = double.tryParse(val!) ?? 0.0,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Service Chg',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                prefixIcon: const Icon(Icons.build),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (val) => val == null || val.isEmpty
                                  ? 'Required'
                                  : null,
                              onSaved: (val) =>
                                  _serviceCharge = double.tryParse(val!) ?? 0.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate() &&
                                _selectedUnitId != null) {
                              _formKey.currentState!.save();
                              final tenantProv = context.read<TenantProvider>();
                              final actProv = context.read<ActivityProvider>();

                              final tId = await tenantProv.addTenant(
                                  _name,
                                  _phone,
                                  _selectedUnitId!,
                                  DateTime.now(),
                                  DateTime.now().add(const Duration(days: 365)),
                                  _advance,
                                  _serviceCharge);

                              await propertiesProv.assignTenantToUnit(
                                  _selectedUnitId!, tId);

                              actProv.logActivity(
                                iconCode: 'person_add',
                                titleKey: 'New Tenant Added',
                                subtitle: _name,
                              );

                              if (context.mounted) Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Save Tenant',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
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
