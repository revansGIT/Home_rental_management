# Home Rental Management App - Bangladesh Edition

A complete home & building rental management application designed specifically for the Bangladesh market with localization support and Bangladesh-style rent system.

## 🇧🇩 Bangladesh-Specific Features

### 1. **Localization**
- **Dual Language Support**: Bengali (বাংলা) and English
- **Bengali Numerals**: Automatic conversion to Bengali numerals (০১২৩৪৫৬৭৮৯)
- **Currency**: BDT (৳) as default currency
- **Date Formatting**: Localized date formats for Bangladesh

### 2. **Bangladesh Rent System**
- **Advance Payment**: 3-month advance payment (common in Bangladesh)
- **Service Charge**: Separate monthly service charge tracking
- **Utility Bills**: 
  - Gas & Electricity: Tenant pays separately
  - Water: Included in rent (common practice)
- **Payment Methods**: Bank Transfer, bKash, Nagad, Cash
- **Late Fee Calculation**: Automatic late fee tracking

### 3. **Mobile-First Design**
- Optimized for Android & iOS devices
- Touch targets minimum 44x44px for accessibility
- Active states with scale animations for better feedback
- Bottom navigation for easy thumb access
- Safe area support for notched devices

## 📱 Key Features

### Dashboard
- Total buildings, units, and tenants overview
- Monthly rent collected vs pending
- Expenses summary with charts
- Recent activity feed
- Quick action buttons

### Property Management
- Add/Edit buildings, floors, and units
- Property details with photos
- Property status (vacant/occupied)
- Utilities and amenities tracking

### Tenant Management
- Complete tenant profiles with documents
- Lease information and dates
- Rent amount with advance and service charges
- Payment history with multiple payment methods
- On-time payment tracking

### Financial Records
- Monthly/Quarterly/Yearly reports
- Automatic rent calculation
- Expense breakdown by category
- Recent transactions
- Export reports (PDF/Excel)

### Settings
- Language switcher (বাংলা/English)
- Currency selection (BDT/USD)
- Notifications preferences
- Dark mode support
- Backup & restore

## 🎨 Design System

### Color Palette
- **Primary**: Green (#16A34A) - Represents Bangladesh's greenery
- **Accent Colors**: 
  - Blue for information
  - Orange for pending/warnings
  - Red for overdue/alerts
  - Green for success/payments

### Typography
- Base font size: 16px (15px on smaller devices)
- Bengali font support: Noto Sans Bengali, Kalpurush
- Readable line heights optimized for both Bengali and English

### Components
- Rounded cards (16px-24px border radius)
- Soft shadows for depth
- Gradient headers for visual hierarchy
- Modal bottom sheets for selections

## 🚀 Flutter Migration Guide

This React/TypeScript app is designed to be easily migrated to Flutter. Here's the structure:

### Component Mapping
```
React Component          →  Flutter Widget
─────────────────────────────────────────────
/App.tsx                →  main.dart
/components/Dashboard   →  screens/dashboard_screen.dart
/components/PropertyList →  screens/property_list_screen.dart
/utils/localization.ts  →  lib/l10n/ (use flutter_localizations)
/utils/context.tsx      →  Provider/Riverpod state management
```

### State Management
- Current: React Context API
- Recommended for Flutter: **Provider** or **Riverpod**

### Data Models
Create these Dart models:
```dart
class Property {
  final String id;
  final String name;
  final String address;
  final int units;
  final int occupied;
  final double monthlyRevenue;
}

class Tenant {
  final String id;
  final String name;
  final double monthlyRent;
  final double advance;
  final double serviceCharge;
  final List<Payment> paymentHistory;
}

class Payment {
  final String month;
  final double amount;
  final double serviceCharge;
  final double? lateFee;
  final PaymentMethod method;
}
```

### Localization in Flutter
```yaml
# pubspec.yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0
```

### Key Packages for Flutter
- **intl**: For number and date formatting
- **flutter_localizations**: For Bengali language support
- **fl_chart**: For charts (similar to recharts)
- **shared_preferences**: For persisting settings
- **path_provider**: For local storage

### Bangladesh-Specific Considerations
1. **Number Formatting**: Use Bengali numerals when language is Bengali
2. **Currency Formatting**: ৳ symbol for BDT
3. **Date Formats**: Use Bengali calendar months
4. **Payment Methods**: Include local options (bKash, Nagad, Rocket)

## 🏗️ File Structure

```
/
├── App.tsx                    # Main app with routing
├── components/
│   ├── Dashboard.tsx          # Home screen
│   ├── PropertyList.tsx       # Properties listing
│   ├── PropertyDetails.tsx    # Single property view
│   ├── TenantProfile.tsx      # Tenant details
│   ├── FinancialReports.tsx   # Financial dashboard
│   └── Settings.tsx           # App settings
├── utils/
│   ├── localization.ts        # i18n utilities
│   └── context.tsx            # Global state
└── styles/
    └── globals.css            # Global styles
```

## 💾 Local Storage Recommendations

For Flutter implementation:
- **Hive** or **SQFlite** for offline data storage
- **Firebase** for cloud sync (optional)
- **Shared Preferences** for settings

## 🔐 Security Notes

- This app is designed for local property management
- Sensitive tenant information should be encrypted
- Consider implementing authentication before production
- Backup data regularly

## 📊 Sample Data Structure

All data is currently mocked. For production:
1. Replace with actual database (SQLite, Firebase, etc.)
2. Implement data validation
3. Add error handling
4. Create backup/restore functionality

## 🌐 Future Enhancements

- [ ] Offline mode support
- [ ] SMS notifications for rent due
- [ ] Digital rent receipt generation
- [ ] Multi-property owner support
- [ ] Maintenance request tracking
- [ ] Document scanner integration
- [ ] Rent increase calculator
- [ ] Tax calculation for Bangladesh

## 📄 License

This project is designed as a template for rental management apps in Bangladesh.

---

**Note**: This is a prototype built with React. For production use in Bangladesh, consider:
- Converting to Flutter for better mobile performance
- Adding proper database integration
- Implementing user authentication
- Adding SMS/notification services
- Complying with Bangladesh data protection regulations
