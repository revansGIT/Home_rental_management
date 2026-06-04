import 'package:flutter/material.dart';
import 'package:home_rental_management/core/localization/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/activity_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecentActivityScreen extends StatelessWidget {
  const RecentActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final activityProv = context.watch<ActivityProvider>();
    final activities = activityProv.activities;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          localizations.recentActivity,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: activities.isEmpty
          ? const Center(child: Text('No recent activity'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                IconData icon;
                Color color;

                switch (activity.iconCode) {
                  case 'business':
                    icon = Icons.business;
                    color = Colors.blue;
                    break;
                  case 'apartment':
                    icon = Icons.apartment;
                    color = Colors.indigo;
                    break;
                  case 'person_add':
                    icon = Icons.person_add;
                    color = Colors.orange;
                    break;
                  case 'payment':
                    icon = Icons.payment;
                    color = Colors.green;
                    break;
                  default:
                    icon = Icons.notifications;
                    color = Colors.grey;
                }

                return _ActivityItem(
                  icon: icon,
                  title: activity.titleKey,
                  subtitle: activity.subtitle,
                  time: timeago.format(activity.timestamp),
                  color: color,
                );
              },
            ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
