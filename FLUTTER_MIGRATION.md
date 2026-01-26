# Flutter Migration Documentation

## Overview
This document describes the migration from React/Vite web application to Flutter mobile application.

## Migration Summary

### What Changed
- **From**: React/TypeScript web application with Vite
- **To**: Flutter mobile application with Dart

### Preserved Features
1. **Localization**: Full support for English and Bengali maintained
2. **Currency Support**: BDT and USD currency formatting
3. **All Screens**: Dashboard, Properties, Tenants, Financial Reports, Settings
4. **State Management**: Migrated from React Context to Flutter Provider
5. **Navigation**: Migrated from state-based routing to BottomNavigationBar

## Project Structure

```
Homerentalmanagement/
├── lib/
│   ├── main.dart                      # App entry point
│   ├── screens/                       # UI screens
│   │   ├── dashboard_screen.dart
│   │   ├── property_list_screen.dart
│   │   ├── property_details_screen.dart
│   │   ├── tenant_profile_screen.dart
│   │   ├── financial_reports_screen.dart
│   │   └── settings_screen.dart
│   ├── utils/
│   │   └── app_provider.dart         # State management
│   ├── l10n/                          # Localization
│   │   ├── app_en.arb                # English translations
│   │   └── app_bn.arb                # Bengali translations
│   ├── models/                        # Data models (empty, for future use)
│   └── widgets/                       # Reusable widgets (empty, for future use)
├── pubspec.yaml                       # Flutter dependencies
├── l10n.yaml                          # Localization configuration
├── analysis_options.yaml              # Linting rules
├── .gitignore                         # Git ignore (Flutter-specific)
└── README.md                          # Project documentation
```

## Localization

### Configuration
- **Location**: `lib/l10n/`
- **Format**: ARB (Application Resource Bundle)
- **Languages**: English (en), Bengali (bn)
- **Total Keys**: 95+ translation keys

### Key Features
- Automatic locale detection
- Runtime language switching
- Bengali numeral support (০১২৩৪৫৬৭৮৯)
- Currency formatting (৳ for BDT, $ for USD)
- Date formatting based on locale

### Usage Example
```dart
// In any screen
final localizations = AppLocalizations.of(context)!;
Text(localizations.home); // "Home" or "হোম" based on locale
```

## State Management

### Provider Pattern
- **Package**: `provider: ^6.1.1`
- **Provider Class**: `AppProvider` in `lib/utils/app_provider.dart`

### Managed State
1. **Locale**: Current app language (en/bn)
2. **Currency**: Current currency format (BDT/USD)
3. **Formatting Methods**:
   - `formatCurrency(double amount)`: Formats currency with symbol
   - `formatNumber(int number)`: Formats numbers with locale-specific numerals

### Usage Example
```dart
final appProvider = Provider.of<AppProvider>(context);
appProvider.setLocale(Locale('bn'));
String amount = appProvider.formatCurrency(15000); // "৳15000"
```

## Screens

### 1. Dashboard Screen
- Overview stats (Buildings, Units, Tenants, Monthly Revenue)
- Quick action buttons
- Monthly revenue breakdown
- Recent activity feed

### 2. Property List Screen
- Search functionality
- List of all properties
- Property cards with revenue and occupancy rate

### 3. Property Details Screen
- Property information (floors, size, year built)
- Units overview with occupancy status
- Navigation to tenant profiles

### 4. Tenant Profile Screen
- Tenant contact information
- Lease details (start, end, rent, deposit)
- Payment overview stats
- Payment history list
- Action buttons (Record Payment, Send Message)

### 5. Financial Reports Screen
- Period selector (Monthly, Quarterly, Yearly)
- Revenue, Expense, and Profit summary
- Expense breakdown with progress bars
- Recent transactions list
- Export functionality

### 6. Settings Screen
- Language selection (English/Bengali)
- Currency selection (BDT/USD)
- Notifications toggle
- Dark mode toggle
- Data & Security options
- Support options
- App version and info

## Dependencies

### Core Dependencies
- `flutter`: SDK
- `flutter_localizations`: SDK (for localization)
- `intl: ^0.19.0`: Internationalization utilities
- `provider: ^6.1.1`: State management
- `cupertino_icons: ^1.0.6`: iOS-style icons

### Dev Dependencies
- `flutter_test`: SDK (for testing)
- `flutter_lints: ^3.0.0`: Linting rules

## Building the App

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Dart SDK
- Android Studio / Xcode

### Commands
```bash
# Get dependencies
flutter pub get

# Generate localization files
flutter gen-l10n

# Run the app
flutter run

# Build for Android
flutter build apk

# Build for iOS
flutter build ios
```

## Migration Details

### Removed Files
All React/Vite files were removed:
- `src/` directory (all React components)
- `index.html`
- `package.json`
- `vite.config.ts`
- All TypeScript configuration files

### New Files
All Flutter-specific files were added:
- `lib/` directory with Dart code
- `pubspec.yaml` for dependencies
- `l10n.yaml` for localization config
- `analysis_options.yaml` for linting
- `.gitignore` updated for Flutter

### Translations Mapping
All translations from `src/utils/localization.ts` were migrated to:
- `lib/l10n/app_en.arb` (English)
- `lib/l10n/app_bn.arb` (Bengali)

## Testing Localization

### English
1. Open Settings screen
2. Select "English" from Language dropdown
3. Navigate through all screens
4. Verify all text is in English

### Bengali
1. Open Settings screen
2. Select "বাংলা" from Language dropdown
3. Navigate through all screens
4. Verify all text is in Bengali
5. Check numbers use Bengali numerals (০১২৩...)
6. Check currency uses ৳ symbol

## Future Enhancements

### Recommended Additions
1. **Data Persistence**: Add local storage (SharedPreferences, Hive)
2. **Backend Integration**: Connect to REST API or Firebase
3. **Authentication**: Add login/logout functionality
4. **Real Data Models**: Create proper model classes in `lib/models/`
5. **Reusable Widgets**: Extract common UI patterns to `lib/widgets/`
6. **Testing**: Add unit and widget tests
7. **Charts**: Add proper chart widgets for financial data
8. **Images**: Add property images support
9. **Notifications**: Implement local and push notifications
10. **PDF Export**: Implement actual PDF export functionality

## Troubleshooting

### Localization Not Working
```bash
# Regenerate localization files
flutter clean
flutter pub get
flutter gen-l10n
```

### Build Errors
```bash
# Clean build
flutter clean
flutter pub get
flutter run
```

## Support
For issues or questions, refer to:
- Flutter Documentation: https://docs.flutter.dev
- Flutter Localization Guide: https://docs.flutter.dev/ui/accessibility-and-localization/internationalization
- Provider Package: https://pub.dev/packages/provider
