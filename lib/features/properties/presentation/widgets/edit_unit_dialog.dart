import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/property_provider.dart';
import '../../../../core/providers/activity_provider.dart';
import '../../../../core/models/unit_model.dart';

class EditUnitDialog extends StatefulWidget {
  final UnitModel unit;
  const EditUnitDialog({super.key, required this.unit});

  @override
  State<EditUnitDialog> createState() => _EditUnitDialogState();
}

class _EditUnitDialogState extends State<EditUnitDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _unitNumber;
  late double _rentAmount;

  @override
  void initState() {
    super.initState();
    _unitNumber = widget.unit.unitNumber;
    _rentAmount = widget.unit.rentAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 300,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Edit Unit',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: _unitNumber,
                decoration: InputDecoration(
                  labelText: 'Unit Number (e.g. 1A)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _unitNumber = val!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _rentAmount.toString(),
                decoration: InputDecoration(
                  labelText: 'Rent Amount',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _rentAmount = double.tryParse(val!) ?? 0.0,
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
                      final propProv = context.read<PropertyProvider>();
                      final actProv = context.read<ActivityProvider>();
                      
                      await propProv.updateUnit(
                        widget.unit.id,
                        _unitNumber,
                        _rentAmount,
                      );
                      
                      actProv.logActivity(
                        iconCode: 'apartment',
                        titleKey: 'Unit Updated',
                        subtitle: 'Unit $_unitNumber',
                      );
                      
                      if (context.mounted) Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
