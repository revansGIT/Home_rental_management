import 'package:hive/hive.dart';

part 'tenant_model.g.dart';

@HiveType(typeId: 2)
class TenantModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final String unitId;

  @HiveField(4)
  final DateTime leaseStart;

  @HiveField(5)
  final DateTime leaseEnd;

  @HiveField(6)
  final double advancePaid;

  @HiveField(7)
  final double serviceCharge;

  TenantModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.unitId,
    required this.leaseStart,
    required this.leaseEnd,
    required this.advancePaid,
    required this.serviceCharge,
  });
}
