import 'package:hive/hive.dart';

part 'property_model.g.dart';

@HiveType(typeId: 0)
class PropertyModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String address;

  @HiveField(3)
  final int totalUnits;

  @HiveField(4)
  final int yearBuilt;

  PropertyModel({
    required this.id,
    required this.name,
    required this.address,
    required this.totalUnits,
    required this.yearBuilt,
  });
}
