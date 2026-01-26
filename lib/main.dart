import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'utils/app_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/property_list_screen.dart';
import 'screens/property_details_screen.dart';
import 'screens/tenant_profile_screen.dart';
import 'screens/financial_reports_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: Consumer<AppProvider>(
        builder: (context, appProvider, _) {
          return MaterialApp(
            title: 'Home Rental Management',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('bn'), // Bengali
            ],
            locale: appProvider.locale,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? _selectedPropertyId;
  String? _selectedTenantId;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Reset selections when changing tabs
      if (index != 1) _selectedPropertyId = null;
      if (index != 2) _selectedTenantId = null;
    });
  }

  void _navigateToPropertyDetails(String propertyId) {
    setState(() {
      _selectedPropertyId = propertyId;
      _selectedIndex = 1;
    });
  }

  void _navigateToTenantProfile(String tenantId) {
    setState(() {
      _selectedTenantId = tenantId;
      _selectedIndex = 2;
    });
  }

  void _navigateBack() {
    setState(() {
      _selectedPropertyId = null;
      _selectedTenantId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final List<Widget> screens = [
      DashboardScreen(
        onNavigateToProperty: _navigateToPropertyDetails,
        onNavigateToTenant: _navigateToTenantProfile,
      ),
      _selectedPropertyId != null
          ? PropertyDetailsScreen(
              propertyId: _selectedPropertyId!,
              onBack: _navigateBack,
              onViewTenant: _navigateToTenantProfile,
            )
          : PropertyListScreen(
              onSelectProperty: _navigateToPropertyDetails,
            ),
      _selectedTenantId != null
          ? TenantProfileScreen(
              tenantId: _selectedTenantId!,
              onBack: _navigateBack,
            )
          : const Center(child: Text('Select a tenant')),
      const FinancialReportsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
      ),
    );
  }
}
