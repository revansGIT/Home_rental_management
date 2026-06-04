import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/models/tenant_model.dart';

class TenantProvider extends ChangeNotifier {
  final Box<TenantModel> _tenantBox = Hive.box<TenantModel>('tenants');
  final _uuid = const Uuid();

  List<TenantModel> get tenants => _tenantBox.values.toList();

  TenantModel? getTenant(String id) => _tenantBox.get(id);

  TenantModel? getTenantForUnit(String unitId) {
    try {
      return _tenantBox.values.firstWhere((tenant) => tenant.unitId == unitId);
    } catch (e) {
      return null;
    }
  }

  Future<String> addTenant(
    String name,
    String phone,
    String unitId,
    DateTime leaseStart,
    DateTime leaseEnd,
    double advancePaid,
    double serviceCharge,
    String? imagePath,
  ) async {
    final newTenant = TenantModel(
      id: _uuid.v4(),
      name: name,
      phone: phone,
      unitId: unitId,
      leaseStart: leaseStart,
      leaseEnd: leaseEnd,
      advancePaid: advancePaid,
      serviceCharge: serviceCharge,
      imagePath: imagePath,
    );
    await _tenantBox.put(newTenant.id, newTenant);
    notifyListeners();
    return newTenant.id;
  }

  Future<void> updateTenant(
    String id,
    String name,
    String phone,
    String unitId,
    DateTime leaseStart,
    DateTime leaseEnd,
    double advancePaid,
    double serviceCharge,
    String? imagePath,
  ) async {
    final tenant = _tenantBox.get(id);
    if (tenant != null) {
      final updatedTenant = TenantModel(
        id: tenant.id,
        name: name,
        phone: phone,
        unitId: unitId,
        leaseStart: leaseStart,
        leaseEnd: leaseEnd,
        advancePaid: advancePaid,
        serviceCharge: serviceCharge,
        imagePath: imagePath ?? tenant.imagePath,
      );
      await _tenantBox.put(id, updatedTenant);
      notifyListeners();
    }
  }

  Future<void> removeTenant(String id) async {
    await _tenantBox.delete(id);
    notifyListeners();
  }
}
