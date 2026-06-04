import 'package:flutter/material.dart';
import 'package:home_rental_management/core/models/tenant_model.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/activity_provider.dart';
import '../providers/tenant_provider.dart';

class EditTenantDialog extends StatefulWidget {
  final TenantModel tenant;
  const EditTenantDialog({super.key, required this.tenant});

  @override
  State<EditTenantDialog> createState() => _EditTenantDialogState();
}

class _EditTenantDialogState extends State<EditTenantDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _phone;
  late double _advance;
  late double _serviceCharge;

  @override
  void initState() {
    super.initState();
    _name = widget.tenant.name;
    _phone = widget.tenant.phone;
    _advance = widget.tenant.advancePaid;
    _serviceCharge = widget.tenant.serviceCharge;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 400,
        child: Form(
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
                      'Edit Tenant',
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
                  initialValue: _name,
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
                  initialValue: _phone,
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _advance.toString(),
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
                        initialValue: _serviceCharge.toString(),
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
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final tenantProv = context.read<TenantProvider>();
                        final actProv = context.read<ActivityProvider>();

                        await tenantProv.updateTenant(
                            widget.tenant.id,
                            _name,
                            _phone,
                            widget.tenant.unitId,
                            widget.tenant.leaseStart,
                            widget.tenant.leaseEnd,
                            _advance,
                            _serviceCharge);

                        actProv.logActivity(
                          iconCode: 'person_add',
                          titleKey: 'Tenant Updated',
                          subtitle: _name,
                        );

                        if (context.mounted) Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Save Changes',
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
