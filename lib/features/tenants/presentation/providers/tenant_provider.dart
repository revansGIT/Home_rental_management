import 'package:flutter/material.dart';
import '../../../../core/services/database_helper.dart';
import '../../data/models/tenant_model.dart';

class TenantDetails {
  final TenantModel tenant;
  final String propertyName;
  final String unitName;

  TenantDetails({
    required this.tenant,
    required this.propertyName,
    required this.unitName,
  });
}

class TenantProvider extends ChangeNotifier {
  final _db = DatabaseHelper.instance;

  List<TenantModel> _tenants = [];
  List<TenantDetails> _tenantDetails = [];
  bool _isLoading = false;

  List<TenantModel> get tenants => _tenants;
  List<TenantDetails> get tenantDetails => _tenantDetails;
  bool get isLoading => _isLoading;

  TenantProvider() {
    refreshData();
  }

  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final tenantMaps = await _db.queryAll('tenants');
      _tenants = tenantMaps.map((map) => TenantModel.fromMap(map)).toList();

      final fullMaps = await _db.getTenantsWithDetails();
      _tenantDetails = fullMaps.map((map) {
        return TenantDetails(
          tenant: TenantModel.fromMap(map),
          propertyName: map['propertyName'] as String? ?? 'N/A',
          unitName: map['unitName'] as String? ?? 'N/A',
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching tenants: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  TenantDetails? getTenantById(int id) {
    try {
      return _tenantDetails.firstWhere((td) => td.tenant.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<int> addTenant(TenantModel tenant) async {
    // 1. Insert Tenant
    final id = await _db.insert('tenants', tenant.toMap());
    
    // 2. Automatically update related unit status to 'occupied'
    await _db.update('units', {'id': tenant.unitId, 'status': 'occupied'}, 'id');
    
    await refreshData();
    return id;
  }

  Future<void> removeTenant(int tenantId, int unitId) async {
    // 1. Mark unit back to 'vacant'
    await _db.update('units', {'id': unitId, 'status': 'vacant'}, 'id');
    
    // 2. Delete tenant
    await _db.delete('tenants', 'id', tenantId);
    
    await refreshData();
  }
}
