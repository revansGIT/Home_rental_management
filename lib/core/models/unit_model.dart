import 'package:hive/hive.dart';

part 'unit_model.g.dart';

@HiveType(typeId: 1)
class UnitModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String propertyId;

  @HiveField(2)
  final String unitNumber;

  @HiveField(3)
  final double rentAmount;

  @HiveField(4)
  final String? tenantId;

  UnitModel({
    required this.id,
    required this.propertyId,
    required this.unitNumber,
    required this.rentAmount,
    this.tenantId,
  });

  bool get isOccupied => tenantId != null && tenantId!.isNotEmpty;
}
