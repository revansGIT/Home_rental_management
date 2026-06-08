import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../features/properties/presentation/providers/property_provider.dart';
import '../../features/properties/data/models/property_model.dart';
import '../../features/properties/data/models/unit_model.dart';

import '../../features/tenants/presentation/providers/tenant_provider.dart';
import '../../features/tenants/data/models/tenant_model.dart';

import '../../features/finance/presentation/providers/finance_provider.dart';
import '../../features/finance/data/models/payment_model.dart';
import '../../features/finance/data/models/expense_model.dart';

class AddPropertyModal extends StatefulWidget {
  const AddPropertyModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const AddPropertyModal(),
    );
  }

  @override
  State<AddPropertyModal> createState() => _AddPropertyModalState();
}

class _AddPropertyModalState extends State<AddPropertyModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addrController = TextEditingController();
  final _floorsController = TextEditingController();
  final _sizeController = TextEditingController();
  final _yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add New Property',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Property Name',
                  prefixIcon: Icon(Icons.business),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addrController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _floorsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Floors',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _sizeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Total SqFt',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Year Built',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final prop = PropertyModel(
                      name: _nameController.text,
                      address: _addrController.text,
                      floors: int.tryParse(_floorsController.text) ?? 1,
                      totalSize: double.tryParse(_sizeController.text) ?? 0.0,
                      yearBuilt: int.tryParse(_yearController.text) ?? DateTime.now().year,
                    );
                    await Provider.of<PropertyProvider>(context, listen: false).addProperty(prop);
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: const Text('Create Property', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class AddTenantModal extends StatefulWidget {
  const AddTenantModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const AddTenantModal(),
    );
  }

  @override
  State<AddTenantModal> createState() => _AddTenantModalState();
}

class _AddTenantModalState extends State<AddTenantModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nidController = TextEditingController();
  final _rentController = TextEditingController();
  final _depositController = TextEditingController();

  int? _selectedPropertyId;
  int? _selectedUnitId;

  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    final availableUnits = _selectedPropertyId == null
        ? <UnitModel>[]
        : propertyProvider.getUnitsForProperty(_selectedPropertyId!)
            .where((u) => u.status == UnitStatus.vacant).toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enroll New Tenant',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Select Property
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Select Property', border: OutlineInputBorder()),
                value: _selectedPropertyId,
                items: propertyProvider.properties.map((p) => DropdownMenuItem(
                  value: p.id,
                  child: Text(p.name),
                )).toList(),
                onChanged: (v) {
                  setState(() {
                    _selectedPropertyId = v;
                    _selectedUnitId = null;
                  });
                },
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              // Select Unit
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Select Unit', border: OutlineInputBorder()),
                value: _selectedUnitId,
                items: availableUnits.map((u) => DropdownMenuItem(
                  value: u.id,
                  child: Text('Unit ${u.unitNumber} (Rent: \$${u.rentAmount})'),
                )).toList(),
                onChanged: (v) {
                  setState(() {
                    _selectedUnitId = v;
                    if (v != null) {
                      final u = availableUnits.firstWhere((unit) => unit.id == v);
                      _rentController.text = u.rentAmount.toStringAsFixed(0);
                    }
                  });
                },
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tenant Name', prefixIcon: Icon(Icons.person), border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _nidController,
                      decoration: const InputDecoration(labelText: 'National ID (NID)', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _rentController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Agreed Rent', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _depositController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Security Deposit', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _selectedPropertyId != null && _selectedUnitId != null) {
                    final tenant = TenantModel(
                      name: _nameController.text,
                      email: _emailController.text.trim(),
                      phone: _phoneController.text,
                      nid: _nidController.text,
                      propertyId: _selectedPropertyId!,
                      unitId: _selectedUnitId!,
                      leaseStart: DateTime.now(),
                      leaseEnd: DateTime.now().add(const Duration(days: 365)),
                      rentAmount: double.tryParse(_rentController.text) ?? 0.0,
                      deposit: double.tryParse(_depositController.text) ?? 0.0,
                      isActive: true,
                    );
                    await Provider.of<TenantProvider>(context, listen: false).addTenant(tenant);
                    // Also trigger dynamic UI fetch refresh in property provider (to update unit occupied count)
                    await propertyProvider.refreshData();
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: const Text('Enroll Tenant', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class RecordPaymentModal extends StatefulWidget {
  final int? tenantId;
  const RecordPaymentModal({super.key, this.tenantId});

  static Future<void> show(BuildContext context, {int? tenantId}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => RecordPaymentModal(tenantId: tenantId),
    );
  }

  @override
  State<RecordPaymentModal> createState() => _RecordPaymentModalState();
}

class _RecordPaymentModalState extends State<RecordPaymentModal> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  int? _selectedTenantId;
  PaymentMethod _selectedMethod = PaymentMethod.cash;
  String _monthYear = DateFormat('MMMM yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _selectedTenantId = widget.tenantId;
  }

  @override
  Widget build(BuildContext context) {
    final tenantProvider = Provider.of<TenantProvider>(context);

    // If predefined tenant, fill amount automatically
    if (_selectedTenantId != null && _amountController.text.isEmpty) {
      final tenantDet = tenantProvider.getTenantById(_selectedTenantId!);
      if (tenantDet != null) {
        _amountController.text = tenantDet.tenant.rentAmount.toStringAsFixed(0);
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Record Rent Collection',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Tenant', border: OutlineInputBorder()),
                value: _selectedTenantId,
                items: tenantProvider.tenantDetails.map((td) => DropdownMenuItem(
                  value: td.tenant.id,
                  child: Text('${td.tenant.name} (${td.propertyName} - ${td.unitName})'),
                )).toList(),
                onChanged: widget.tenantId != null ? null : (v) {
                  setState(() {
                    _selectedTenantId = v;
                    if (v != null) {
                      final td = tenantProvider.getTenantById(v);
                      if (td != null) {
                        _amountController.text = td.tenant.rentAmount.toStringAsFixed(0);
                      }
                    }
                  });
                },
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount Received', prefixIcon: Icon(Icons.attach_money), border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PaymentMethod>(
                decoration: const InputDecoration(labelText: 'Payment Method', border: OutlineInputBorder()),
                value: _selectedMethod,
                items: PaymentMethod.values.map((m) => DropdownMenuItem(
                  value: m,
                  child: Text(m.name.toUpperCase()),
                )).toList(),
                onChanged: (v) => setState(() => _selectedMethod = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Notes / Reference', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _selectedTenantId != null) {
                    final td = tenantProvider.getTenantById(_selectedTenantId!);
                    if (td != null) {
                      final pay = PaymentModel(
                        tenantId: _selectedTenantId!,
                        unitId: td.tenant.unitId,
                        amount: double.tryParse(_amountController.text) ?? 0.0,
                        date: DateTime.now(),
                        monthYear: _monthYear,
                        paymentMethod: _selectedMethod,
                        notes: _noteController.text,
                        status: PaymentStatus.paid,
                      );
                      await Provider.of<FinanceProvider>(context, listen: false).recordPayment(pay);
                      if (mounted) Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Mark Paid & Record', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class AddExpenseModal extends StatefulWidget {
  const AddExpenseModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const AddExpenseModal(),
    );
  }

  @override
  State<AddExpenseModal> createState() => _AddExpenseModalState();
}

class _AddExpenseModalState extends State<AddExpenseModal> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descController = TextEditingController();

  int? _selectedPropertyId;
  String _selectedCategory = 'Maintenance';
  final List<String> _cats = ['Maintenance', 'Utility', 'Tax', 'Insurance', 'Other'];

  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Log Maintenance / Expense',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Property', border: OutlineInputBorder()),
                value: _selectedPropertyId,
                items: propertyProvider.properties.map((p) => DropdownMenuItem(
                  value: p.id,
                  child: Text(p.name),
                )).toList(),
                onChanged: (v) => setState(() => _selectedPropertyId = v),
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                      value: _selectedCategory,
                      items: _cats.map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      )).toList(),
                      onChanged: (v) => setState(() => _selectedCategory = v!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Cost', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description of work', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _selectedPropertyId != null) {
                    final exp = ExpenseModel(
                      propertyId: _selectedPropertyId!,
                      category: _selectedCategory,
                      amount: double.tryParse(_amountController.text) ?? 0.0,
                      date: DateTime.now(),
                      description: _descController.text,
                    );
                    await Provider.of<FinanceProvider>(context, listen: false).addExpense(exp);
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: const Text('Record Expense', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class AddUnitModal extends StatefulWidget {
  final int propertyId;
  const AddUnitModal({super.key, required this.propertyId});

  static Future<void> show(BuildContext context, int propertyId) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddUnitModal(propertyId: propertyId),
    );
  }

  @override
  State<AddUnitModal> createState() => _AddUnitModalState();
}

class _AddUnitModalState extends State<AddUnitModal> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _rentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add Rental Unit',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(labelText: 'Unit Number / Flat (e.g., A-402)', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _rentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Base Rent Amount', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final u = UnitModel(
                      propertyId: widget.propertyId,
                      unitNumber: _numberController.text,
                      rentAmount: double.tryParse(_rentController.text) ?? 0.0,
                      status: UnitStatus.vacant,
                    );
                    await Provider.of<PropertyProvider>(context, listen: false).addUnit(u);
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: const Text('Create Unit', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
