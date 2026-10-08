# Home Rental Management App - Complete Features (A to Z)

An overview and comprehensive A-Z reference of all capabilities and features currently implemented in the **Home Rental Management** Flutter application.

---

## 🗂️ Features by Category Overview

- **Architecture & Local Storage**: Powered by Hive for offline-first fast performance, GoRouter for stateful indexed navigation, and Provider for state management.
- **Properties & Units Management**: Real-time property listings, building analytics, multi-unit creation, rental rates, and occupancy tracking.
- **Tenant Directory & Lifecycle**: Tenant profile cards, lease agreements, contact management, photo uploads, unit assignment, and quick communication.
- **Financial Accounting & Reports**: Tracking collections, pending rent dues, profit/loss calculations, interactive charts (`fl_chart`), and CSV export/sharing.
- **System Settings & Customization**: Dynamic Material You theming, dark/light modes, bilingual support (English & Bengali), and localized currency conversions.

---

## 🔤 Comprehensive A to Z Feature Index

### **A**
- **Activity Log & Audit Trail**
  - Logs critical operational events (property creation/deletion, unit addition, tenant registration, and payment records).
  - Relative time display powered by `timeago` (e.g., *"2 hours ago"*).
  - Dedicated **Recent Activity Screen** with detailed timeline history.
- **Add Payment Dialog**
  - Modal form allowing quick entry of tenant payments, amounts, dates, and statuses (Collected vs. Pending).
- **Add Property Flow**
  - Dialog modal to record new building/property details including Name, Address, and Year Built.
- **Add Tenant Flow**
  - Multi-field tenant onboarding modal: name, phone, initial advance payment, monthly service charges, and profile photo.
- **Add Unit Flow**
  - Unit creation modal with property binding, unit number (e.g. *1A*, *2B*), and monthly base rent.
- **Advance Deposit Management**
  - Records and monitors security deposit/advance paid by incoming tenants.
- **Appearance Settings**
  - Support for `System Default`, `Light Mode`, and `Dark Mode` via Material 3 segmented button.

---

### **B**
- **Bengali Localization & Numerals Support**
  - Full English (`en`) and Bengali (`bn`) language toggle across all labels and navigation.
  - Automatic numeral conversion to Bengali script (`০-৯`) for stats and currency display when Bengali is selected.
- **Building / Property List View**
  - Card-based overview of all properties with real-time indicators for total units, occupancy percentage, and potential monthly revenue.

---

### **C**
- **Call Tenant (Direct Dial)**
  - Direct telephone dialing integration via `url_launcher` (`tel:`) from the Tenant Profile.
- **CSV Financial Export**
  - RFC 4180 compliant CSV export generator with UTF-8 BOM encoding for Excel compatibility.
  - Generates date, description, amount, payment status, and tenant IDs.
- **Currency Selection (BDT & USD)**
  - Dynamic currency switching between Bangladeshi Taka (`৳`) and US Dollars (`$`) across the app.
- **Custom App Bar**
  - Consistent elevated header displaying screen titles, personalized greetings, and context action buttons.

---

### **D**
- **Dashboard Overview**
  - High-level metric KPI cards displaying total buildings, total units, registered tenants, and monthly revenue.
  - Real-time comparison widget of **Collected vs. Pending** rent dues.
- **Dark Mode Support**
  - Full Material 3 theme palette tailored for low-light environments with high-contrast surfaces.
- **Dynamic Color (Material You)**
  - Toggle dynamic system color theming based on user wallpaper (Android 12+).

---

### **E**
- **Edit Property Dialog**
  - Update property name, address, year built, or banner image.
- **Edit Tenant Dialog**
  - Edit personal tenant information, lease duration, contact numbers, and service charge terms.
- **Edit Unit Dialog**
  - Adjust unit identifiers and update monthly rent values.

---

### **F**
- **Financial Reports & Analytics**
  - Visual financial breakdown using `fl_chart` bar and line charts.
  - Period toggles for **Monthly**, **Quarterly**, and **Yearly** performance.
  - Net profit, total revenue, and total pending calculations.

---

### **H**
- **Hive Offline Storage**
  - No server requirement; data persists locally across app restarts with custom TypeAdapters:
    - `PropertyModel`
    - `UnitModel`
    - `TenantModel`
    - `PaymentModel`
    - `ActivityModel`

---

### **I**
- **Image Picker & Profile Photos**
  - Gallery photo upload support for properties and tenant profile identification using `image_picker`.

---

### **L**
- **Lease Duration Tracking**
  - Displays lease start date, lease expiry date, and lease term countdown on tenant profiles.
- **Local Push Notifications**
  - Notification service setup via `flutter_local_notifications` and `timezone` for scheduled reminders.

---

### **M**
- **Monthly Revenue Breakdown**
  - Summarizes collected revenue against pending rent per month, per property, and per tenant.

---

### **N**
- **Navigation Bar (Bottom Indexed Shell)**
  - Five-tab persistent bottom navigation using `go_router` StatefulShellRoute:
    1. **Dashboard** (`/`)
    2. **Properties** (`/properties`)
    3. **Tenants** (`/tenants`)
    4. **Financial** (`/financial`)
    5. **Settings** (`/settings`)

---

### **O**
- **Occupancy Rate Analytics**
  - Visual progress bar and percentage calculator per building:
    - *Green* ($\ge 80\%$)
    - *Orange* ($50\% - 79\%$)
    - *Red* ($< 50\%$)

---

### **P**
- **Payment History Log**
  - Granular transaction records showing payment date, amount, status, and associated tenant profile.
- **Property Deletion with Cascade Protection**
  - Confirmation dialog that securely deletes properties and removes related child unit records.

---

### **Q**
- **Quick Action Buttons**
  - Direct dashboard shortcut buttons for **Add Property**, **Add Tenant**, and **Add Payment**.

---

### **R**
- **Recent Activity Screen**
  - Full dedicated feed of historical operations and timestamps.
- **Record Payment Directly from Tenant Profile**
  - Pre-fills tenant details to quickly log rent payments directly from that tenant's screen.

---

### **S**
- **Search Capabilities**
  - Real-time search filter in **Property List** (searches by property name and address).
  - Real-time search filter in **Tenant List** (searches by name and phone number).
- **Service Charge & Maintenance Tracking**
  - Accommodates ancillary monthly fees alongside basic rental amount.
- **Share Financial Reports**
  - Direct OS share sheet integration (`share_plus`) to send CSV exports via WhatsApp, Email, Drive, etc.
- **SMS Tenant**
  - One-tap SMS launcher via `url_launcher` (`sms:`) for instant message reminders.

---

### **T**
- **Tenant Assignment to Vacant Units**
  - Dropdown unit assignment with automatic filtering so only vacant units can be occupied.
- **Tenant Eviction / Unlinking**
  - Automatically resets unit occupancy status back to vacant upon tenant deletion.
- **Tenant Profile Screen**
  - Comprehensive overview featuring tenant photo, unit link, lease details, contact actions, advance deposit, service charges, and individual payment history.

---

### **U**
- **Unit Occupancy Toggle**
  - Automatic status updates when a tenant moves in or out of a unit.
- **Unit Management per Property**
  - Embedded list of all units belonging to a building on the Property Details page.

---

### **W**
- **WhatsApp Integration**
  - Direct WhatsApp chat link action (`https://wa.me/...`) to message tenants with one tap.

---

## 📊 Summary Statistics

| Category | Count / Details |
|---|---|
| **Core Screens** | 5 Main Tabs + 3 Details/Sub-screens |
| **Data Adapters** | 5 Hive Entities (`Property`, `Unit`, `Tenant`, `Payment`, `Activity`) |
| **State Providers** | 5 Providers (`Property`, `Tenant`, `Finance`, `Activity`, `App`) |
| **Supported Languages** | English (`en`), Bengali (`bn`) |
| **Supported Currencies** | BDT (`৳`), USD (`$`) |
