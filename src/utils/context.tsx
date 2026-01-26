import { createContext, useContext, useState, ReactNode } from 'react';
import { Language, Currency } from './localization';

interface AppContextType {
  language: Language;
  currency: Currency;
  setLanguage: (lang: Language) => void;
  setCurrency: (curr: Currency) => void;
}

const AppContext = createContext<AppContextType | undefined>(undefined);

export function AppProvider({ children }: { children: ReactNode }) {
  const [language, setLanguage] = useState<Language>('bn'); // Default to Bengali for Bangladesh
  const [currency, setCurrency] = useState<Currency>('BDT'); // Default to BDT

  return (
    <AppContext.Provider value={{ language, currency, setLanguage, setCurrency }}>
      {children}
    </AppContext.Provider>
  );
}

export function useApp() {
  const context = useContext(AppContext);
  if (context === undefined) {
    throw new Error('useApp must be used within an AppProvider');
  }
  return context;
}
