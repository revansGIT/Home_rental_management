import { ChevronRight, Globe, DollarSign, Bell, Shield, Database, Moon, User, HelpCircle, LogOut, Check } from 'lucide-react';
import { useState } from 'react';
import { useApp } from '../utils/context';
import { t, Language, Currency } from '../utils/localization';

export function Settings() {
  const { language, currency, setLanguage, setCurrency } = useApp();
  const [notifications, setNotifications] = useState(true);
  const [darkMode, setDarkMode] = useState(false);
  const [showCurrencyModal, setShowCurrencyModal] = useState(false);
  const [showLanguageModal, setShowLanguageModal] = useState(false);

  const currencies: { value: Currency; label: string; symbol: string }[] = [
    { value: 'BDT', label: 'Bangladeshi Taka', symbol: '৳' },
    { value: 'USD', label: 'US Dollar', symbol: '$' },
  ];

  const languages: { value: Language; label: string; native: string }[] = [
    { value: 'bn', label: 'Bengali', native: 'বাংলা' },
    { value: 'en', label: 'English', native: 'English' },
  ];

  return (
    <div className="max-w-md mx-auto bg-gray-50 min-h-screen pb-6">
      {/* Header */}
      <div className="bg-gradient-to-br from-green-600 to-green-700 px-5 pt-12 pb-8 rounded-b-3xl shadow-lg">
        <h1 className="text-white text-2xl mb-1">{t('settings', language)}</h1>
        <p className="text-green-100 text-sm">{t('appSettings', language)}</p>
      </div>

      {/* Profile Section */}
      <div className="px-5 -mt-4 mb-6">
        <div className="bg-white rounded-2xl p-4 shadow-md">
          <div className="flex items-center gap-4">
            <div className="w-16 h-16 bg-gradient-to-br from-green-500 to-green-600 rounded-full flex items-center justify-center">
              <span className="text-white text-xl">PM</span>
            </div>
            <div className="flex-1">
              <h3 className="text-gray-900 mb-1">প্রপার্টি ম্যানেজার</h3>
              <p className="text-xs text-gray-500">manager@rentalapp.com</p>
            </div>
            <button className="w-9 h-9 bg-gray-50 rounded-lg flex items-center justify-center active:scale-95 transition-transform">
              <ChevronRight className="w-5 h-5 text-gray-400" />
            </button>
          </div>
        </div>
      </div>

      {/* App Settings */}
      <div className="px-5 mb-6">
        <h3 className="text-xs text-gray-500 mb-3 uppercase tracking-wide">{t('appSettings', language)}</h3>
        
        {/* Currency Setting */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden mb-3">
          <button 
            onClick={() => setShowCurrencyModal(true)}
            className="w-full px-4 py-4 flex items-center justify-between hover:bg-gray-50 active:bg-gray-100 transition-colors"
          >
            <div className="flex items-center gap-3">
              <div className="w-11 h-11 bg-green-50 rounded-lg flex items-center justify-center">
                <DollarSign className="w-5 h-5 text-green-600" />
              </div>
              <div className="text-left">
                <p className="text-sm text-gray-900">{t('currency', language)}</p>
                <p className="text-xs text-gray-500">{t('setCurrency', language)}</p>
              </div>
            </div>
            <div className="flex items-center gap-2">
              <span className="text-sm text-gray-600">{currency === 'BDT' ? '৳ BDT' : '$ USD'}</span>
              <ChevronRight className="w-5 h-5 text-gray-400" />
            </div>
          </button>
        </div>

        {/* Language Setting */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden mb-3">
          <button 
            onClick={() => setShowLanguageModal(true)}
            className="w-full px-4 py-4 flex items-center justify-between hover:bg-gray-50 active:bg-gray-100 transition-colors"
          >
            <div className="flex items-center gap-3">
              <div className="w-11 h-11 bg-blue-50 rounded-lg flex items-center justify-center">
                <Globe className="w-5 h-5 text-blue-600" />
              </div>
              <div className="text-left">
                <p className="text-sm text-gray-900">{t('language', language)}</p>
                <p className="text-xs text-gray-500">{t('displayLanguage', language)}</p>
              </div>
            </div>
            <div className="flex items-center gap-2">
              <span className="text-sm text-gray-600">{language === 'bn' ? 'বাংলা' : 'English'}</span>
              <ChevronRight className="w-5 h-5 text-gray-400" />
            </div>
          </button>
        </div>

        {/* Notifications Setting */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden mb-3">
          <div className="px-4 py-4 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-11 h-11 bg-orange-50 rounded-lg flex items-center justify-center">
                <Bell className="w-5 h-5 text-orange-600" />
              </div>
              <div className="text-left">
                <p className="text-sm text-gray-900">{t('notifications', language)}</p>
                <p className="text-xs text-gray-500">{t('notificationDesc', language)}</p>
              </div>
            </div>
            <button
              onClick={() => setNotifications(!notifications)}
              className={`relative w-12 h-7 rounded-full transition-colors ${
                notifications ? 'bg-green-600' : 'bg-gray-300'
              }`}
            >
              <div
                className={`absolute top-0.5 left-0.5 w-6 h-6 bg-white rounded-full transition-transform shadow-md ${
                  notifications ? 'translate-x-5' : 'translate-x-0'
                }`}
              ></div>
            </button>
          </div>
        </div>

        {/* Dark Mode Setting */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
          <div className="px-4 py-4 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-11 h-11 bg-purple-50 rounded-lg flex items-center justify-center">
                <Moon className="w-5 h-5 text-purple-600" />
              </div>
              <div className="text-left">
                <p className="text-sm text-gray-900">{t('darkMode', language)}</p>
                <p className="text-xs text-gray-500">{t('enableDarkTheme', language)}</p>
              </div>
            </div>
            <button
              onClick={() => setDarkMode(!darkMode)}
              className={`relative w-12 h-7 rounded-full transition-colors ${
                darkMode ? 'bg-green-600' : 'bg-gray-300'
              }`}
            >
              <div
                className={`absolute top-0.5 left-0.5 w-6 h-6 bg-white rounded-full transition-transform shadow-md ${
                  darkMode ? 'translate-x-5' : 'translate-x-0'
                }`}
              ></div>
            </button>
          </div>
        </div>
      </div>

      {/* Data & Security */}
      <div className="px-5 mb-6">
        <h3 className="text-xs text-gray-500 mb-3 uppercase tracking-wide">{t('dataSecurity', language)}</h3>
        
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden mb-3">
          <button className="w-full px-4 py-4 flex items-center justify-between hover:bg-gray-50 active:bg-gray-100 transition-colors">
            <div className="flex items-center gap-3">
              <div className="w-11 h-11 bg-blue-50 rounded-lg flex items-center justify-center">
                <Database className="w-5 h-5 text-blue-600" />
              </div>
              <div className="text-left">
                <p className="text-sm text-gray-900">{t('backupRestore', language)}</p>
                <p className="text-xs text-gray-500">{t('backupDesc', language)}</p>
              </div>
            </div>
            <ChevronRight className="w-5 h-5 text-gray-400" />
          </button>
        </div>

        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
          <button className="w-full px-4 py-4 flex items-center justify-between hover:bg-gray-50 active:bg-gray-100 transition-colors">
            <div className="flex items-center gap-3">
              <div className="w-11 h-11 bg-green-50 rounded-lg flex items-center justify-center">
                <Shield className="w-5 h-5 text-green-600" />
              </div>
              <div className="text-left">
                <p className="text-sm text-gray-900">{t('privacySecurity', language)}</p>
                <p className="text-xs text-gray-500">{t('privacyDesc', language)}</p>
              </div>
            </div>
            <ChevronRight className="w-5 h-5 text-gray-400" />
          </button>
        </div>
      </div>

      {/* Support */}
      <div className="px-5 mb-6">
        <h3 className="text-xs text-gray-500 mb-3 uppercase tracking-wide">{t('support', language)}</h3>
        
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden mb-3">
          <button className="w-full px-4 py-4 flex items-center justify-between hover:bg-gray-50 active:bg-gray-100 transition-colors">
            <div className="flex items-center gap-3">
              <div className="w-11 h-11 bg-orange-50 rounded-lg flex items-center justify-center">
                <HelpCircle className="w-5 h-5 text-orange-600" />
              </div>
              <div className="text-left">
                <p className="text-sm text-gray-900">{t('helpCenter', language)}</p>
                <p className="text-xs text-gray-500">{t('helpDesc', language)}</p>
              </div>
            </div>
            <ChevronRight className="w-5 h-5 text-gray-400" />
          </button>
        </div>

        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
          <button className="w-full px-4 py-4 flex items-center justify-between hover:bg-gray-50 active:bg-gray-100 transition-colors">
            <div className="flex items-center gap-3">
              <div className="w-11 h-11 bg-purple-50 rounded-lg flex items-center justify-center">
                <User className="w-5 h-5 text-purple-600" />
              </div>
              <div className="text-left">
                <p className="text-sm text-gray-900">{t('contactSupport', language)}</p>
                <p className="text-xs text-gray-500">{t('supportDesc', language)}</p>
              </div>
            </div>
            <ChevronRight className="w-5 h-5 text-gray-400" />
          </button>
        </div>
      </div>

      {/* App Info */}
      <div className="px-5 mb-6">
        <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
          <div className="flex justify-between items-center mb-2">
            <span className="text-xs text-gray-500">{t('appVersion', language)}</span>
            <span className="text-xs text-gray-900">১.০.০</span>
          </div>
          <div className="flex justify-between items-center">
            <span className="text-xs text-gray-500">{t('lastBackup', language)}</span>
            <span className="text-xs text-gray-900">১৫ জুন, ২০২৪</span>
          </div>
        </div>
      </div>

      {/* Logout Button */}
      <div className="px-5 mb-6">
        <button className="w-full bg-red-50 text-red-600 py-4 rounded-2xl hover:bg-red-100 active:scale-[0.98] transition-all flex items-center justify-center gap-2 font-medium">
          <LogOut className="w-5 h-5" />
          <span>{t('logout', language)}</span>
        </button>
      </div>

      {/* Currency Modal */}
      {showCurrencyModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-end justify-center z-50 max-w-md mx-auto">
          <div className="bg-white rounded-t-3xl w-full p-6 animate-slide-up">
            <div className="w-12 h-1 bg-gray-300 rounded-full mx-auto mb-6"></div>
            <h3 className="text-lg text-gray-900 mb-4">{t('currency', language)}</h3>
            <div className="space-y-2 mb-6">
              {currencies.map((curr) => (
                <button
                  key={curr.value}
                  onClick={() => {
                    setCurrency(curr.value);
                    setShowCurrencyModal(false);
                  }}
                  className={`w-full px-4 py-4 rounded-xl flex items-center justify-between transition-all ${
                    currency === curr.value
                      ? 'bg-green-50 border-2 border-green-500'
                      : 'bg-gray-50 border-2 border-transparent hover:bg-gray-100'
                  }`}
                >
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-white rounded-full flex items-center justify-center shadow-sm">
                      <span className="text-lg">{curr.symbol}</span>
                    </div>
                    <div className="text-left">
                      <p className="text-sm text-gray-900">{curr.label}</p>
                      <p className="text-xs text-gray-500">{curr.value}</p>
                    </div>
                  </div>
                  {currency === curr.value && (
                    <Check className="w-5 h-5 text-green-600" />
                  )}
                </button>
              ))}
            </div>
            <button
              onClick={() => setShowCurrencyModal(false)}
              className="w-full bg-gray-100 text-gray-700 py-3 rounded-xl hover:bg-gray-200 active:scale-95 transition-all"
            >
              বন্ধ করুন
            </button>
          </div>
        </div>
      )}

      {/* Language Modal */}
      {showLanguageModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-end justify-center z-50 max-w-md mx-auto">
          <div className="bg-white rounded-t-3xl w-full p-6 animate-slide-up">
            <div className="w-12 h-1 bg-gray-300 rounded-full mx-auto mb-6"></div>
            <h3 className="text-lg text-gray-900 mb-4">{t('language', language)}</h3>
            <div className="space-y-2 mb-6">
              {languages.map((lang) => (
                <button
                  key={lang.value}
                  onClick={() => {
                    setLanguage(lang.value);
                    setShowLanguageModal(false);
                  }}
                  className={`w-full px-4 py-4 rounded-xl flex items-center justify-between transition-all ${
                    language === lang.value
                      ? 'bg-green-50 border-2 border-green-500'
                      : 'bg-gray-50 border-2 border-transparent hover:bg-gray-100'
                  }`}
                >
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-white rounded-full flex items-center justify-center shadow-sm">
                      <Globe className="w-5 h-5 text-gray-600" />
                    </div>
                    <div className="text-left">
                      <p className="text-sm text-gray-900">{lang.native}</p>
                      <p className="text-xs text-gray-500">{lang.label}</p>
                    </div>
                  </div>
                  {language === lang.value && (
                    <Check className="w-5 h-5 text-green-600" />
                  )}
                </button>
              ))}
            </div>
            <button
              onClick={() => setShowLanguageModal(false)}
              className="w-full bg-gray-100 text-gray-700 py-3 rounded-xl hover:bg-gray-200 active:scale-95 transition-all"
            >
              {language === 'bn' ? 'বন্ধ করুন' : 'Close'}
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
