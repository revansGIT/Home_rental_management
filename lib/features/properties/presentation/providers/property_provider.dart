import 'package:flutter/material.dart';
import '../../../../core/services/database_helper.dart';
import '../../data/models/property_model.dart';
import '../../data/models/unit_model.dart';

class PropertyProvider extends ChangeNotifier {
  final _db = DatabaseHelper.instance;

  List<PropertyModel> _properties = [];
  List<UnitModel> _allUnits = [];
  bool _isLoading = false;

  List<PropertyModel> get properties => _properties;
  List<UnitModel> get allUnits => _allUnits;
  bool get isLoading => _isLoading;

  PropertyProvider() {
    refreshData();
  }

  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final propMaps = await _db.queryAll('properties');
      _properties = propMaps.map((map) => PropertyModel.fromMap(map)).toList();

      final unitMaps = await _db.queryAll('units');
      _allUnits = unitMaps.map((map) => UnitModel.fromMap(map)).toList();
    } catch (e) {
      debugPrint('Error fetching properties: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  List<UnitModel> getUnitsForProperty(int propertyId) {
    return _allUnits.where((unit) => unit.propertyId == propertyId).toList();
  }

  double getOccupancyRate(int propertyId) {
    final propUnits = getUnitsForProperty(propertyId);
    if (propUnits.isEmpty) return 0.0;
    final occupied = propUnits.where((u) => u.status == UnitStatus.occupied).length;
    return (occupied / propUnits.length) * 100.0;
  }

  Future<int> addProperty(PropertyModel property) async {
    final id = await _db.insert('properties', property.toMap());
    await refreshData();
    return id;
  }

  Future<void> addUnit(UnitModel unit) async {
    await _db.insert('units', unit.toMap());
    await refreshData();
  }

  Future<void> updateUnitStatus(int unitId, UnitStatus status) async {
    final unitIndex = _allUnits.indexWhere((u) => u.id == unitId);
    if (unitIndex != -1) {
      final updatedUnit = _allUnits[unitIndex].copyWith(status: status);
      await _db.update('units', updatedUnit.toMap(), 'id');
      await refreshData();
    }
  }

  Future<void> deleteProperty(int id) async {
    await _db.delete('properties', 'id', id);
    // SQL ON DELETE CASCADE will handle Units, but let's refresh state
    await refreshData();
  }
}
