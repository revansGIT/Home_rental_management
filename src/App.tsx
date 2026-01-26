import { useState } from 'react';
import { Dashboard } from './components/Dashboard';
import { PropertyList } from './components/PropertyList';
import { PropertyDetails } from './components/PropertyDetails';
import { TenantProfile } from './components/TenantProfile';
import { FinancialReports } from './components/FinancialReports';
import { Settings } from './components/Settings';
import { Home, Building2, Users, DollarSign, Settings as SettingsIcon } from 'lucide-react';
import { AppProvider, useApp } from './utils/context';
import { t } from './utils/localization';

type Screen = 'dashboard' | 'properties' | 'propertyDetails' | 'tenants' | 'financial' | 'settings';

function AppContent() {
  const { language } = useApp();
  const [currentScreen, setCurrentScreen] = useState<Screen>('dashboard');
  const [selectedPropertyId, setSelectedPropertyId] = useState<string | null>(null);
  const [selectedTenantId, setSelectedTenantId] = useState<string | null>(null);

  const navigateToPropertyDetails = (propertyId: string) => {
    setSelectedPropertyId(propertyId);
    setCurrentScreen('propertyDetails');
  };

  const navigateToTenantProfile = (tenantId: string) => {
    setSelectedTenantId(tenantId);
    setCurrentScreen('tenants');
  };

  const renderScreen = () => {
    switch (currentScreen) {
      case 'dashboard':
        return (
          <Dashboard 
            onNavigateToProperties={() => setCurrentScreen('properties')}
            onNavigateToProperty={navigateToPropertyDetails}
            onNavigateToTenant={navigateToTenantProfile}
          />
        );
      case 'properties':
        return <PropertyList onSelectProperty={navigateToPropertyDetails} />;
      case 'propertyDetails':
        return (
          <PropertyDetails 
            propertyId={selectedPropertyId || ''} 
            onBack={() => setCurrentScreen('properties')}
            onViewTenant={navigateToTenantProfile}
          />
        );
      case 'tenants':
        return (
          <TenantProfile 
            tenantId={selectedTenantId} 
            onBack={() => setCurrentScreen('dashboard')}
          />
        );
      case 'financial':
        return <FinancialReports />;
      case 'settings':
        return <Settings />;
      default:
        return <Dashboard onNavigateToProperties={() => setCurrentScreen('properties')} onNavigateToProperty={navigateToPropertyDetails} onNavigateToTenant={navigateToTenantProfile} />;
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      {/* Main Content */}
      <div className="h-full">
        {renderScreen()}
      </div>

      {/* Bottom Navigation - Mobile Optimized */}
      <nav className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 px-4 py-2 shadow-lg max-w-md mx-auto safe-area-bottom">
        <div className="flex justify-between items-center">
          <button
            onClick={() => setCurrentScreen('dashboard')}
            className={`flex flex-col items-center gap-0.5 px-3 py-2 rounded-lg transition-all min-w-[60px] ${
              currentScreen === 'dashboard' ? 'text-blue-600 bg-blue-50' : 'text-gray-500'
            }`}
          >
            <Home className="w-6 h-6" />
            <span className="text-[10px]">{t('home', language)}</span>
          </button>
          <button
            onClick={() => setCurrentScreen('properties')}
            className={`flex flex-col items-center gap-0.5 px-3 py-2 rounded-lg transition-all min-w-[60px] ${
              currentScreen === 'properties' || currentScreen === 'propertyDetails' ? 'text-blue-600 bg-blue-50' : 'text-gray-500'
            }`}
          >
            <Building2 className="w-6 h-6" />
            <span className="text-[10px]">{t('properties', language)}</span>
          </button>
          <button
            onClick={() => setCurrentScreen('tenants')}
            className={`flex flex-col items-center gap-0.5 px-3 py-2 rounded-lg transition-all min-w-[60px] ${
              currentScreen === 'tenants' ? 'text-blue-600 bg-blue-50' : 'text-gray-500'
            }`}
          >
            <Users className="w-6 h-6" />
            <span className="text-[10px]">{t('tenants', language)}</span>
          </button>
          <button
            onClick={() => setCurrentScreen('financial')}
            className={`flex flex-col items-center gap-0.5 px-3 py-2 rounded-lg transition-all min-w-[60px] ${
              currentScreen === 'financial' ? 'text-blue-600 bg-blue-50' : 'text-gray-500'
            }`}
          >
            <DollarSign className="w-6 h-6" />
            <span className="text-[10px]">{t('financial', language)}</span>
          </button>
          <button
            onClick={() => setCurrentScreen('settings')}
            className={`flex flex-col items-center gap-0.5 px-3 py-2 rounded-lg transition-all min-w-[60px] ${
              currentScreen === 'settings' ? 'text-blue-600 bg-blue-50' : 'text-gray-500'
            }`}
          >
            <SettingsIcon className="w-6 h-6" />
            <span className="text-[10px]">{t('settings', language)}</span>
          </button>
        </div>
      </nav>
    </div>
  );
}

export default function App() {
  return (
    <AppProvider>
      <AppContent />
    </AppProvider>
  );
}