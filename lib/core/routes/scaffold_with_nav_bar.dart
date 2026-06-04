import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../localization/app_localizations.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[600],
        unselectedItemColor: Colors.grey[500],
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: localizations.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.business),
            label: localizations.properties,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: localizations.tenants,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.attach_money),
            label: localizations.financial,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: localizations.settings,
          ),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
