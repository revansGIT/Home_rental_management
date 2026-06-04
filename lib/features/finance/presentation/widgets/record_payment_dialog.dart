import 'package:flutter/material.dart';
import 'package:home_rental_management/features/tenants/presentation/providers/tenant_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/activity_provider.dart';
import '../providers/finance_provider.dart';

class RecordPaymentDialog extends StatefulWidget {
  const RecordPaymentDialog({super.key});

  @override
  State<RecordPaymentDialog> createState() => _RecordPaymentDialogState();
}

class _RecordPaymentDialogState extends State<RecordPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedTenantId;
  double _amount = 0.0;
  String _status = 'Collected';

  @override
  Widget build(BuildContext context) {
    final tenantProv = context.watch<TenantProvider>();
    final tenants = tenantProv.tenants;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 400,
        child: tenants.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No tenants available. Please add a tenant first.',
                    textAlign: TextAlign.center),
              )
            : Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Record Payment',
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
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select Tenant',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.person),
                      ),
                      items: tenants.map((t) {
                        return DropdownMenuItem(
                          value: t.id,
                          child: Text(t.name),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedTenantId = val;
                        });
                      },
                      validator: (val) =>
                          val == null ? 'Please select a tenant' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Required' : null,
                      onSaved: (val) => _amount = double.tryParse(val!) ?? 0.0,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _status,
                      decoration: InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.info),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'Collected', child: Text('Collected')),
                        DropdownMenuItem(
                            value: 'Pending', child: Text('Pending')),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _status = val!;
                        });
                      },
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
                              _selectedTenantId != null) {
                            _formKey.currentState!.save();
                            final financeProv = context.read<FinanceProvider>();
                            final actProv = context.read<ActivityProvider>();
                            
                            await financeProv.addPayment(
                                  _selectedTenantId!,
                                  _amount,
                                  DateTime.now(),
                                  _status,
                                  'Rent Payment',
                                );
                                
                            actProv.logActivity(
                              iconCode: 'payment',
                              titleKey: 'Payment Recorded',
                              subtitle: '\$$_amount - $_status',
                            );
                            
                            if (context.mounted) Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Save Payment',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
