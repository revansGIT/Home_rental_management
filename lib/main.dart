import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:home_rental_management/core/localization/app_localizations.dart';
import 'package:home_rental_management/core/providers/activity_provider.dart';
import 'package:provider/provider.dart';
import 'core/models/property_model.dart';
import 'core/models/unit_model.dart';
import 'core/models/tenant_model.dart';
import 'core/models/payment_model.dart';
import 'core/models/activity_model.dart';
import 'features/properties/presentation/providers/property_provider.dart';
import 'features/tenants/presentation/providers/tenant_provider.dart';
import 'features/finance/presentation/providers/finance_provider.dart';
import 'utils/app_provider.dart';
import 'core/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(PropertyModelAdapter());
  Hive.registerAdapter(UnitModelAdapter());
  Hive.registerAdapter(TenantModelAdapter());
  Hive.registerAdapter(PaymentModelAdapter());
  Hive.registerAdapter(ActivityModelAdapter());

  await Hive.openBox('settings');
  await Hive.openBox<PropertyModel>('properties');
  await Hive.openBox<UnitModel>('units');
  await Hive.openBox<TenantModel>('tenants');
  await Hive.openBox<PaymentModel>('payments');
  await Hive.openBox<ActivityModel>('activities');

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
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, _) {
          return MaterialApp.router(
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
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}


