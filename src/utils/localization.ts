export type Language = 'en' | 'bn';
export type Currency = 'BDT' | 'USD';

export interface LocalizationConfig {
  language: Language;
  currency: Currency;
  dateFormat: string;
}

// Translation dictionary
export const translations = {
  en: {
    // Navigation
    home: 'Home',
    properties: 'Properties',
    tenants: 'Tenants',
    financial: 'Financial',
    settings: 'Settings',
    
    // Dashboard
    welcomeBack: 'Welcome back!',
    propertyManagerDashboard: 'Property Manager Dashboard',
    buildings: 'Buildings',
    units: 'Units',
    totalTenants: 'Tenants',
    thisMonth: 'This Month',
    quickActions: 'Quick Actions',
    addProperty: 'Add Property',
    addTenant: 'Add Tenant',
    addPayment: 'Add Payment',
    monthlyRevenue: 'Monthly Revenue',
    collectedVsPending: 'Collected vs Pending',
    collected: 'Collected',
    pending: 'Pending',
    monthlyExpenses: 'Monthly Expenses',
    totalExpenses: 'Total Expenses',
    recentActivity: 'Recent Activity',
    viewAll: 'View All',
    occupied: 'Occupied',
    vacant: 'Vacant',
    
    // Property
    totalProperties: 'total properties',
    searchProperties: 'Search properties...',
    allProperties: 'All Properties',
    apartments: 'Apartments',
    commercial: 'Commercial',
    residential: 'Residential',
    active: 'Active',
    revenue: 'Revenue',
    occupancyRate: 'Occupancy Rate',
    propertyInformation: 'Property Information',
    floors: 'Floors',
    totalSize: 'Total Size',
    yearBuilt: 'Year Built',
    vacancyRate: 'Vacancy Rate',
    utilitiesIncluded: 'Utilities Included',
    amenities: 'Amenities',
    unitsOverview: 'Units Overview',
    
    // Tenant
    activeTenant: 'Active Tenant',
    leaseInformation: 'Lease Information',
    leaseStart: 'Lease Start',
    leaseEnd: 'Lease End',
    monthlyRent: 'Monthly Rent',
    advance: 'Advance',
    serviceCharge: 'Service Charge',
    securityDeposit: 'Security Deposit',
    paymentDue: 'Payment Due',
    paymentOverview: 'Payment Overview',
    totalPaid: 'Total Paid',
    payments: 'Payments',
    onTime: 'On Time',
    paymentHistory: 'Payment History',
    documents: 'Documents',
    recordPayment: 'Record Payment',
    sendMessage: 'Send Message',
    
    // Financial
    financialReports: 'Financial Reports',
    trackRevenueExpenses: 'Track your revenue & expenses',
    monthly: 'Monthly',
    quarterly: 'Quarterly',
    yearly: 'Yearly',
    totalRevenue: 'Total Revenue',
    totalExpense: 'Total Expenses',
    netProfit: 'Net Profit',
    margin: 'margin',
    revenueVsExpenses: 'Revenue vs Expenses',
    expenseBreakdown: 'Expense Breakdown',
    recentTransactions: 'Recent Transactions',
    exportReports: 'Export Reports',
    exportPDF: 'Export as PDF',
    exportExcel: 'Export as Excel',
    
    // Settings
    appSettings: 'App Settings',
    currency: 'Currency',
    setCurrency: 'Set default currency',
    language: 'Language',
    displayLanguage: 'App display language',
    notifications: 'Notifications',
    notificationDesc: 'Payment & lease reminders',
    darkMode: 'Dark Mode',
    enableDarkTheme: 'Enable dark theme',
    dataSecurity: 'Data & Security',
    backupRestore: 'Backup & Restore',
    backupDesc: 'Save and restore your data',
    privacySecurity: 'Privacy & Security',
    privacyDesc: 'Manage data privacy',
    support: 'Support',
    helpCenter: 'Help Center',
    helpDesc: 'FAQs and guides',
    contactSupport: 'Contact Support',
    supportDesc: 'Get help from our team',
    appVersion: 'App Version',
    lastBackup: 'Last Backup',
    logout: 'Log Out',
  },
  bn: {
    // Navigation
    home: 'হোম',
    properties: 'সম্পত্তি',
    tenants: 'ভাড়াটিয়া',
    financial: 'আর্থিক',
    settings: 'সেটিংস',
    
    // Dashboard
    welcomeBack: 'স্বাগতম!',
    propertyManagerDashboard: 'প্রপার্টি ম্যানেজার ড্যাশবোর্ড',
    buildings: 'ভবন',
    units: 'ইউনিট',
    totalTenants: 'ভাড়াটিয়া',
    thisMonth: 'এই মাসে',
    quickActions: 'দ্রুত কাজ',
    addProperty: 'সম্পত্তি যোগ করুন',
    addTenant: 'ভাড়াটিয়া যোগ করুন',
    addPayment: 'পেমেন্ট যোগ করুন',
    monthlyRevenue: 'মাসিক আয়',
    collectedVsPending: 'সংগৃহীত বনাম বাকি',
    collected: 'সংগৃহীত',
    pending: 'বাকি',
    monthlyExpenses: 'মাসিক খরচ',
    totalExpenses: 'মোট খরচ',
    recentActivity: 'সাম্প্রতিক কার্যক্রম',
    viewAll: 'সব দেখুন',
    occupied: 'ভাড়া দেওয়া',
    vacant: 'খালি',
    
    // Property
    totalProperties: 'মোট সম্পত্তি',
    searchProperties: 'সম্পত্তি খুঁজুন...',
    allProperties: 'সকল সম্পত্তি',
    apartments: 'অ্যাপার্টমেন্ট',
    commercial: 'বাণিজ্যিক',
    residential: 'আবাসিক',
    active: 'সক্রিয়',
    revenue: 'আয়',
    occupancyRate: 'দখলের হার',
    propertyInformation: 'সম্পত্তির তথ্য',
    floors: 'তলা',
    totalSize: 'মোট আকার',
    yearBuilt: 'নির্মাণ বছর',
    vacancyRate: 'খালির হার',
    utilitiesIncluded: 'অন্তর্ভুক্ত সুবিধা',
    amenities: 'সুযোগ-সুবিধা',
    unitsOverview: 'ইউনিট সংক্ষিপ্ত বিবরণ',
    
    // Tenant
    activeTenant: 'সক্রিয় ভাড়াটিয়া',
    leaseInformation: 'লিজের তথ্য',
    leaseStart: 'লিজ শুরু',
    leaseEnd: 'লিজ শেষ',
    monthlyRent: 'মাসিক ভাড়া',
    advance: 'অগ্রিম',
    serviceCharge: 'সার্ভিস চার্জ',
    securityDeposit: 'নিরাপত্তা জামানত',
    paymentDue: 'পেমেন্ট নির্ধারিত',
    paymentOverview: 'পেমেন্ট সংক্ষিপ্ত বিবরণ',
    totalPaid: 'মোট পরিশোধিত',
    payments: 'পেমেন্ট',
    onTime: 'সময়মত',
    paymentHistory: 'পেমেন্ট ইতিহাস',
    documents: 'নথিপত্র',
    recordPayment: 'পেমেন্ট রেকর্ড করুন',
    sendMessage: 'বার্তা পাঠান',
    
    // Financial
    financialReports: 'আর্থিক রিপোর্ট',
    trackRevenueExpenses: 'আপনার আয় ও খরচ ট্র্যাক করুন',
    monthly: 'মাসিক',
    quarterly: 'ত্রৈমাসিক',
    yearly: 'বার্ষিক',
    totalRevenue: 'মোট আয়',
    totalExpense: 'মোট খরচ',
    netProfit: 'নিট মুনাফা',
    margin: 'মার্জিন',
    revenueVsExpenses: 'আয় বনাম খরচ',
    expenseBreakdown: 'খরচের বিবরণ',
    recentTransactions: 'সাম্প্রতিক লেনদেন',
    exportReports: 'রিপোর্ট রপ্তানি',
    exportPDF: 'PDF হিসেবে রপ্তানি',
    exportExcel: 'Excel হিসেবে রপ্তানি',
    
    // Settings
    appSettings: 'অ্যাপ সেটিংস',
    currency: 'মুদ্রা',
    setCurrency: 'ডিফল্ট মুদ্রা সেট করুন',
    language: 'ভাষা',
    displayLanguage: 'অ্যাপের প্রদর্শন ভাষা',
    notifications: 'বিজ্ঞপ্তি',
    notificationDesc: 'পেমেন্ট ও লিজ রিমাইন্ডার',
    darkMode: 'ডার্ক মোড',
    enableDarkTheme: 'ডার্ক থিম সক্ষম করুন',
    dataSecurity: 'ডেটা ও নিরাপত্তা',
    backupRestore: 'ব্যাকআপ ও পুনরুদ্ধার',
    backupDesc: 'আপনার ডেটা সংরক্ষণ ও পুনরুদ্ধার করুন',
    privacySecurity: 'গোপনীয়তা ও নিরাপত্তা',
    privacyDesc: 'ডেটা গোপনীয়তা পরিচালনা করুন',
    support: 'সহায়তা',
    helpCenter: 'সাহায্য কেন্দ্র',
    helpDesc: 'প্রশ্নোত্তর ও গাইড',
    contactSupport: 'সাপোর্টের সাথে যোগাযোগ',
    supportDesc: 'আমাদের টিম থেকে সাহায্য পান',
    appVersion: 'অ্যাপ সংস্করণ',
    lastBackup: 'শেষ ব্যাকআপ',
    logout: 'লগ আউট',
  },
};

// Format currency based on locale
export const formatCurrency = (amount: number, currency: Currency = 'BDT'): string => {
  if (currency === 'BDT') {
    return `৳${amount.toLocaleString('bn-BD')}`;
  }
  return `$${amount.toLocaleString('en-US')}`;
};

// Format number based on locale
export const formatNumber = (num: number, language: Language = 'bn'): string => {
  if (language === 'bn') {
    return num.toLocaleString('bn-BD');
  }
  return num.toLocaleString('en-US');
};

// Convert to Bengali numerals
export const toBengaliNumber = (num: number | string): string => {
  const bengaliNumerals = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
  return String(num).replace(/\d/g, (digit) => bengaliNumerals[parseInt(digit)]);
};

// Format date based on locale
export const formatDate = (date: string, language: Language = 'bn'): string => {
  const d = new Date(date);
  if (language === 'bn') {
    return d.toLocaleDateString('bn-BD', { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric' 
    });
  }
  return d.toLocaleDateString('en-US', { 
    year: 'numeric', 
    month: 'short', 
    day: 'numeric' 
  });
};

// Get translation
export const t = (key: keyof typeof translations.en, language: Language = 'bn'): string => {
  return translations[language][key] || translations.en[key] || key;
};
