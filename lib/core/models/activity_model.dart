import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'activity_model.g.dart';

@HiveType(typeId: 4)
class ActivityModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String iconCode;

  @HiveField(2)
  final String titleKey;

  @HiveField(3)
  final String subtitle;

  @HiveField(4)
  final DateTime timestamp;

  ActivityModel({
    String? id,
    required this.iconCode,
    required this.titleKey,
    required this.subtitle,
    required this.timestamp,
  }) : id = id ?? const Uuid().v4();
}
