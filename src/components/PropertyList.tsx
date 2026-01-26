import { Search, Plus, MapPin, Home, Users, DollarSign, Filter } from 'lucide-react';
import { useState } from 'react';
import { useApp } from '../utils/context';
import { t, formatCurrency, formatNumber } from '../utils/localization';

interface PropertyListProps {
  onSelectProperty: (propertyId: string) => void;
}

const properties = [
  {
    id: '1',
    name: 'সানসেট অ্যাপার্টমেন্ট',
    address: 'বনানী, ঢাকা-১২১৩',
    type: 'অ্যাপার্টমেন্ট কমপ্লেক্স',
    units: 12,
    occupied: 10,
    vacant: 2,
    monthlyRevenue: 144000,
    status: 'active',
  },
  {
    id: '2',
    name: 'ওক বিল্ডিং',
    address: 'গুলশান, ঢাকা-১২১২',
    type: 'বাণিজ্যিক ভবন',
    units: 8,
    occupied: 7,
    vacant: 1,
    monthlyRevenue: 182000,
    status: 'active',
  },
  {
    id: '3',
    name: 'পাইন টাওয়ার',
    address: 'ধানমন্ডি, ঢাকা-১২০৫',
    type: 'আবাসিক টাওয়ার',
    units: 24,
    occupied: 22,
    vacant: 2,
    monthlyRevenue: 268000,
    status: 'active',
  },
  {
    id: '4',
    name: 'গ্রীন ভ্যালি হোমস',
    address: 'উত্তরা, ঢাকা-১২৩০',
    type: 'টাউনহাউস',
    units: 6,
    occupied: 4,
    vacant: 2,
    monthlyRevenue: 72000,
    status: 'active',
  },
];

export function PropertyList({ onSelectProperty }: PropertyListProps) {
  const { language, currency } = useApp();
  const [searchQuery, setSearchQuery] = useState('');
  const [filterType, setFilterType] = useState<'all' | 'apartment' | 'commercial' | 'residential'>('all');

  const filteredProperties = properties.filter(property => 
    property.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    property.address.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <div className="max-w-md mx-auto bg-gray-50 min-h-screen pb-6">
      {/* Header */}
      <div className="bg-white px-5 pt-12 pb-6 shadow-sm">
        <div className="flex justify-between items-center mb-6">
          <div>
            <h1 className="text-2xl text-gray-900">{t('properties', language)}</h1>
            <p className="text-sm text-gray-500 mt-1">
              {formatNumber(properties.length, language)} {t('totalProperties', language)}
            </p>
          </div>
          <button className="w-12 h-12 bg-green-600 rounded-full flex items-center justify-center shadow-lg hover:bg-green-700 active:scale-95 transition-all">
            <Plus className="w-6 h-6 text-white" />
          </button>
        </div>

        {/* Search Bar */}
        <div className="relative">
          <Search className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
          <input
            type="text"
            placeholder={t('searchProperties', language)}
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full pl-12 pr-4 py-3.5 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
          />
        </div>

        {/* Filter Chips */}
        <div className="flex gap-2 mt-4 overflow-x-auto pb-2 scrollbar-hide">
          <button 
            onClick={() => setFilterType('all')}
            className={`px-4 py-2.5 rounded-full text-xs whitespace-nowrap transition-all active:scale-95 ${
              filterType === 'all' 
                ? 'bg-green-600 text-white shadow-md' 
                : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
            }`}
          >
            {t('allProperties', language)}
          </button>
          <button 
            onClick={() => setFilterType('apartment')}
            className={`px-4 py-2.5 rounded-full text-xs whitespace-nowrap transition-all active:scale-95 ${
              filterType === 'apartment' 
                ? 'bg-green-600 text-white shadow-md' 
                : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
            }`}
          >
            {t('apartments', language)}
          </button>
          <button 
            onClick={() => setFilterType('commercial')}
            className={`px-4 py-2.5 rounded-full text-xs whitespace-nowrap transition-all active:scale-95 ${
              filterType === 'commercial' 
                ? 'bg-green-600 text-white shadow-md' 
                : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
            }`}
          >
            {t('commercial', language)}
          </button>
          <button 
            onClick={() => setFilterType('residential')}
            className={`px-4 py-2.5 rounded-full text-xs whitespace-nowrap transition-all active:scale-95 ${
              filterType === 'residential' 
                ? 'bg-green-600 text-white shadow-md' 
                : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
            }`}
          >
            {t('residential', language)}
          </button>
        </div>
      </div>

      {/* Property List */}
      <div className="px-5 mt-4 space-y-4">
        {filteredProperties.map((property) => (
          <button
            key={property.id}
            onClick={() => onSelectProperty(property.id)}
            className="w-full bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md active:scale-[0.98] transition-all"
          >
            {/* Property Image/Header */}
            <div className="bg-gradient-to-br from-green-500 to-green-600 h-24 flex items-center justify-center relative">
              <Home className="w-12 h-12 text-white opacity-20" />
              <div className="absolute top-3 right-3">
                <span className="px-3 py-1 bg-white bg-opacity-90 rounded-full text-xs text-green-600 font-medium">
                  {t('active', language)}
                </span>
              </div>
            </div>

            {/* Property Details */}
            <div className="p-4">
              <div className="flex justify-between items-start mb-3">
                <div className="text-left flex-1">
                  <h3 className="text-gray-900 mb-1 text-base">{property.name}</h3>
                  <div className="flex items-center gap-1 text-gray-500">
                    <MapPin className="w-3 h-3" />
                    <p className="text-xs">{property.address}</p>
                  </div>
                </div>
              </div>

              <div className="flex items-center gap-1 mb-3">
                <span className="px-2 py-1 bg-green-50 text-green-600 rounded-lg text-xs">
                  {property.type}
                </span>
              </div>

              {/* Stats Grid */}
              <div className="grid grid-cols-3 gap-3">
                <div className="text-center">
                  <div className="flex items-center justify-center gap-1 mb-1">
                    <Home className="w-4 h-4 text-gray-400" />
                    <span className="text-xs text-gray-500">{t('units', language)}</span>
                  </div>
                  <p className="text-gray-900">{formatNumber(property.units, language)}</p>
                </div>
                <div className="text-center">
                  <div className="flex items-center justify-center gap-1 mb-1">
                    <Users className="w-4 h-4 text-green-500" />
                    <span className="text-xs text-gray-500">{t('occupied', language)}</span>
                  </div>
                  <p className="text-gray-900">{formatNumber(property.occupied, language)}</p>
                </div>
                <div className="text-center">
                  <div className="flex items-center justify-center gap-1 mb-1">
                    <DollarSign className="w-4 h-4 text-orange-500" />
                    <span className="text-xs text-gray-500">{t('revenue', language)}</span>
                  </div>
                  <p className="text-gray-900 text-sm">{formatCurrency(property.monthlyRevenue, currency)}</p>
                </div>
              </div>

              {/* Occupancy Bar */}
              <div className="mt-4 pt-3 border-t border-gray-100">
                <div className="flex justify-between items-center mb-2">
                  <span className="text-xs text-gray-600">{t('occupancyRate', language)}</span>
                  <span className="text-xs text-gray-900">
                    {formatNumber(Math.round((property.occupied / property.units) * 100), language)}%
                  </span>
                </div>
                <div className="w-full h-2 bg-gray-100 rounded-full overflow-hidden">
                  <div 
                    className="h-full bg-gradient-to-r from-green-400 to-green-500 rounded-full transition-all"
                    style={{ width: `${(property.occupied / property.units) * 100}%` }}
                  ></div>
                </div>
              </div>
            </div>
          </button>
        ))}
      </div>
    </div>
  );
}
