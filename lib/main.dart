import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:home_rental_management/core/localization/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'utils/app_provider.dart';
import 'features/properties/presentation/providers/property_provider.dart';
import 'features/tenants/presentation/providers/tenant_provider.dart';
import 'features/finance/presentation/providers/finance_provider.dart';

import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/properties/presentation/screens/property_list_screen.dart';
import 'features/properties/presentation/screens/property_details_screen.dart';
import 'features/tenants/presentation/screens/tenant_profile_screen.dart';
import 'features/finance/presentation/screens/financial_reports_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => PropertyProvider()),
        ChangeNotifierProvider(create: (_) => TenantProvider()),
        ChangeNotifierProvider(create: (_) => FinanceProvider()),
      ],
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
              Locale('en'),
              Locale('bn'),
            ],
            locale: appProvider.locale,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF2563EB), // Vibrant Electric Blue
                primary: const Color(0xFF2563EB),
                secondary: const Color(0xFF10B981), // Premium Emerald Green
                surface: Colors.white,
              ),
              useMaterial3: true,
              textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: false,
                titleTextStyle: GoogleFonts.inter(
                  color: const Color(0xFF1F2937),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: const IconThemeData(color: Color(0xFF1F2937)),
              ),
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
  int? _selectedPropertyId;
  int? _selectedTenantId;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index != 1) _selectedPropertyId = null;
      if (index != 2) _selectedTenantId = null;
    });
  }

  void _navigateToPropertyDetails(int propertyId) {
    setState(() {
      _selectedPropertyId = propertyId;
      _selectedIndex = 1;
    });
  }

  void _navigateToTenantProfile(int tenantId) {
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
          : TenantProfileScreen(
              onBack: _navigateBack, // Handles fallback when selected is null
            ),
      const FinancialReportsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFF2563EB).withOpacity(0.1),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home, color: Color(0xFF2563EB)),
              label: localizations.home,
            ),
            NavigationDestination(
              icon: const Icon(Icons.business_outlined),
              selectedIcon: const Icon(Icons.business, color: Color(0xFF2563EB)),
              label: localizations.properties,
            ),
            NavigationDestination(
              icon: const Icon(Icons.people_outline),
              selectedIcon: const Icon(Icons.people, color: Color(0xFF2563EB)),
              label: localizations.tenants,
            ),
            NavigationDestination(
              icon: const Icon(Icons.analytics_outlined),
              selectedIcon: const Icon(Icons.analytics, color: Color(0xFF2563EB)),
              label: localizations.financial,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings, color: Color(0xFF2563EB)),
              label: localizations.settings,
            ),
          ],
        ),
      ),
    );
  }
}
