
# Home Rental Management Mobile App

A Flutter mobile application for home rental property management with support for English and Bengali (Bangladesh) localization.

## Features

- **Dashboard**: Overview of properties, units, tenants, and monthly revenue
- **Property Management**: View and manage properties and units
- **Tenant Management**: Track tenant information, lease details, and payment history
- **Financial Reports**: Monitor revenue, expenses, and profit with detailed breakdowns
- **Settings**: Configure language (EN/BN), currency (BDT/USD), and app preferences
- **Localization**: Full support for English and Bengali languages

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/revansGIT/Homerentalmanagement.git
   cd Homerentalmanagement
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate localizations:
   ```bash
   flutter gen-l10n
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Localization

The app supports two languages:
- English (en)
- Bengali (bn)

Localization files are located in `lib/l10n/`:
- `app_en.arb` - English translations
- `app_bn.arb` - Bengali translations

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/                  # UI screens
│   ├── dashboard_screen.dart
│   ├── property_list_screen.dart
│   ├── property_details_screen.dart
│   ├── tenant_profile_screen.dart
│   ├── financial_reports_screen.dart
│   └── settings_screen.dart
├── utils/                    # Utilities
│   └── app_provider.dart    # State management
└── l10n/                     # Localization files
    ├── app_en.arb
    └── app_bn.arb
```

## Design

The original design is available at https://www.figma.com/design/uWLbDF9d1Au7IQdAUDM5E3/Home-Rental-Management-UI.
  