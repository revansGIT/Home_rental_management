import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/activity_model.dart';

class ActivityProvider with ChangeNotifier {
  final Box<ActivityModel> _activitiesBox = Hive.box<ActivityModel>('activities');

  List<ActivityModel> get activities {
    final list = _activitiesBox.values.toList();
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  Future<void> logActivity({
    required String iconCode,
    required String titleKey,
    required String subtitle,
  }) async {
    final activity = ActivityModel(
      iconCode: iconCode,
      titleKey: titleKey,
      subtitle: subtitle,
      timestamp: DateTime.now(),
    );

    await _activitiesBox.add(activity);

    // Keep only the last 100 entries to save space
    if (_activitiesBox.length > 100) {
      // Since it's appended sequentially, the lowest keys are usually the oldest, 
      // but let's just delete the oldest by iterating manually to be safe.
      final list = _activitiesBox.values.toList();
      list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      
      final itemsToDelete = list.length - 100;
      for (int i = 0; i < itemsToDelete; i++) {
        await list[i].delete();
      }
    }

    notifyListeners();
  }
}
