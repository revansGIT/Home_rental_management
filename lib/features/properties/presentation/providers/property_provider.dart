import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/models/property_model.dart';
import '../../../../core/models/unit_model.dart';

class PropertyProvider extends ChangeNotifier {
  final Box<PropertyModel> _propertyBox = Hive.box<PropertyModel>('properties');
  final Box<UnitModel> _unitBox = Hive.box<UnitModel>('units');
  final _uuid = const Uuid();

  List<PropertyModel> get properties => _propertyBox.values.toList();
  List<UnitModel> get units => _unitBox.values.toList();

  PropertyModel? getProperty(String id) => _propertyBox.get(id);

  List<UnitModel> getUnitsForProperty(String propertyId) {
    return _unitBox.values.where((unit) => unit.propertyId == propertyId).toList();
  }

  Future<void> addProperty(String name, String address, int yearBuilt) async {
    final newProperty = PropertyModel(
      id: _uuid.v4(),
      name: name,
      address: address,
      totalUnits: 0,
      yearBuilt: yearBuilt,
    );
    await _propertyBox.put(newProperty.id, newProperty);
    notifyListeners();
  }

  Future<void> addUnit(String propertyId, String unitNumber, double rentAmount) async {
    final newUnit = UnitModel(
      id: _uuid.v4(),
      propertyId: propertyId,
      unitNumber: unitNumber,
      rentAmount: rentAmount,
    );
    await _unitBox.put(newUnit.id, newUnit);
    
    // Update property totalUnits
    final property = _propertyBox.get(propertyId);
    if (property != null) {
      final updatedProperty = PropertyModel(
        id: property.id,
        name: property.name,
        address: property.address,
        totalUnits: property.totalUnits + 1,
        yearBuilt: property.yearBuilt,
      );
      await _propertyBox.put(property.id, updatedProperty);
    }
    notifyListeners();
  }

  Future<void> assignTenantToUnit(String unitId, String tenantId) async {
    final unit = _unitBox.get(unitId);
    if (unit != null) {
      final updatedUnit = UnitModel(
        id: unit.id,
        propertyId: unit.propertyId,
        unitNumber: unit.unitNumber,
        rentAmount: unit.rentAmount,
        tenantId: tenantId,
      );
      await _unitBox.put(unitId, updatedUnit);
      notifyListeners();
    }
  }

  Future<void> removeTenantFromUnit(String unitId) async {
    final unit = _unitBox.get(unitId);
    if (unit != null) {
      final updatedUnit = UnitModel(
        id: unit.id,
        propertyId: unit.propertyId,
        unitNumber: unit.unitNumber,
        rentAmount: unit.rentAmount,
        tenantId: null,
      );
      await _unitBox.put(unitId, updatedUnit);
      notifyListeners();
    }
  }
}
