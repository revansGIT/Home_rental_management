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
      imagePath: null,
    );
    await _propertyBox.put(newProperty.id, newProperty);
    notifyListeners();
  }

  Future<void> updateProperty(
    String id,
    String name,
    String address,
    int yearBuilt,
    String? imagePath,
  ) async {
    final property = _propertyBox.get(id);
    if (property != null) {
      final updatedProperty = PropertyModel(
        id: property.id,
        name: name,
        address: address,
        totalUnits: property.totalUnits,
        yearBuilt: yearBuilt,
        imagePath: imagePath,
      );
      await _propertyBox.put(id, updatedProperty);
      notifyListeners();
    }
  }

  Future<void> deleteProperty(String id) async {
    // Delete associated units first
    final unitsToDelete = _unitBox.values.where((u) => u.propertyId == id).toList();
    for (var unit in unitsToDelete) {
      await _unitBox.delete(unit.id);
    }
    // Delete property
    await _propertyBox.delete(id);
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
        imagePath: property.imagePath,
      );
      await _propertyBox.put(property.id, updatedProperty);
    }
    notifyListeners();
  }

  Future<void> updateUnit(String unitId, String unitNumber, double rentAmount) async {
    final unit = _unitBox.get(unitId);
    if (unit != null) {
      final updatedUnit = UnitModel(
        id: unit.id,
        propertyId: unit.propertyId,
        unitNumber: unitNumber,
        rentAmount: rentAmount,
        tenantId: unit.tenantId,
      );
      await _unitBox.put(unitId, updatedUnit);
      notifyListeners();
    }
  }

  Future<void> deleteUnit(String unitId) async {
    final unit = _unitBox.get(unitId);
    if (unit != null) {
      // Update property totalUnits
      final property = _propertyBox.get(unit.propertyId);
      if (property != null) {
        final updatedProperty = PropertyModel(
          id: property.id,
          name: property.name,
          address: property.address,
          totalUnits: property.totalUnits > 0 ? property.totalUnits - 1 : 0,
          yearBuilt: property.yearBuilt,
          imagePath: property.imagePath,
        );
        await _propertyBox.put(property.id, updatedProperty);
      }
      
      await _unitBox.delete(unitId);
      notifyListeners();
    }
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
