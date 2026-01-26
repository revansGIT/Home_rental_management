import { ArrowLeft, MapPin, Home, Users, DollarSign, Edit, Calendar } from 'lucide-react';
import { useApp } from '../utils/context';
import { t, formatCurrency, formatNumber } from '../utils/localization';

interface PropertyDetailsProps {
  propertyId: string;
  onBack: () => void;
  onViewTenant: (tenantId: string) => void;
}

const propertyData = {
  '1': {
    name: 'সানসেট অ্যাপার্টমেন্ট',
    address: 'বনানী, ঢাকা-১২১৩',
    type: 'অ্যাপার্টমেন্ট কমপ্লেক্স',
    floors: 3,
    totalUnits: 12,
    size: '১৫,০০০ বর্গফুট',
    yearBuilt: 2018,
    units: [
      { id: 'u1', number: '১০১', floor: 1, rooms: 2, size: '৮৫০ বর্গফুট', status: 'occupied', tenant: 'আহমেদ হাসান', rent: 25000, dueDate: '১ তারিখ' },
      { id: 'u2', number: '১০২', floor: 1, rooms: 2, size: '৮৫০ বর্গফুট', status: 'occupied', tenant: 'ফাতিমা খাতুন', rent: 25000, dueDate: '১ তারিখ' },
      { id: 'u3', number: '১০৩', floor: 1, rooms: 3, size: '১১০০ বর্গফুট', status: 'occupied', tenant: 'রহিম উদ্দিন', rent: 30000, dueDate: '৫ তারিখ' },
      { id: 'u4', number: '১০৪', floor: 1, rooms: 1, size: '৬৫০ বর্গফুট', status: 'vacant', tenant: null, rent: 18000, dueDate: null },
      { id: 'u5', number: '২০১', floor: 2, rooms: 2, size: '৮৫০ বর্গফুট', status: 'occupied', tenant: 'নাজমুল হক', rent: 25000, dueDate: '১ তারিখ' },
      { id: 'u6', number: '২০২', floor: 2, rooms: 2, size: '৮৫০ বর্গফুট', status: 'occupied', tenant: 'সালমা বেগম', rent: 25000, dueDate: '১০ তারিখ' },
      { id: 'u7', number: '২০৩', floor: 2, rooms: 3, size: '১১০০ বর্গফুট', status: 'occupied', tenant: 'করিম মিয়া', rent: 30000, dueDate: '১ তারিখ' },
      { id: 'u8', number: '২০৪', floor: 2, rooms: 1, size: '৬৫০ বর্গফুট', status: 'occupied', tenant: 'রুমানা আক্তার', rent: 18000, dueDate: '১৫ তারিখ' },
      { id: 'u9', number: '৩০১', floor: 3, rooms: 2, size: '৮৫০ বর্গফুট', status: 'occupied', tenant: 'তানভীর আহমেদ', rent: 25000, dueDate: '১ তারিখ' },
      { id: 'u10', number: '৩০২', floor: 3, rooms: 2, size: '৮৫০ বর্গফুট', status: 'occupied', tenant: 'শাহিনুর রহমান', rent: 25000, dueDate: '৫ তারিখ' },
      { id: 'u11', number: '৩০৩', floor: 3, rooms: 3, size: '১১০০ বর্গফুট', status: 'occupied', tenant: 'নাসরিন সুলতানা', rent: 30000, dueDate: '১ তারিখ' },
      { id: 'u12', number: '৩০৪', floor: 3, rooms: 1, size: '৬৫০ বর্গফুট', status: 'vacant', tenant: null, rent: 18000, dueDate: null },
    ],
    utilities: ['পানি', 'বিদ্যুৎ', 'গ্যাস', 'ইন্টারনেট'],
    amenities: ['পার্কিং', 'লিফট', 'সিকিউরিটি', 'জিম'],
  }
};

export function PropertyDetails({ propertyId, onBack, onViewTenant }: PropertyDetailsProps) {
  const { language, currency } = useApp();
  const property = propertyData[propertyId as keyof typeof propertyData] || propertyData['1'];
  const occupiedUnits = property.units.filter(u => u.status === 'occupied').length;
  const vacantUnits = property.units.filter(u => u.status === 'vacant').length;
  const monthlyRevenue = property.units
    .filter(u => u.status === 'occupied')
    .reduce((sum, u) => sum + u.rent, 0);

  return (
    <div className="max-w-md mx-auto bg-gray-50 min-h-screen">
      {/* Header */}
      <div className="bg-gradient-to-br from-green-600 to-green-700 px-5 pt-12 pb-6 relative">
        <button 
          onClick={onBack}
          className="w-11 h-11 bg-white bg-opacity-20 rounded-full flex items-center justify-center mb-6 hover:bg-opacity-30 active:scale-95 transition-all"
        >
          <ArrowLeft className="w-5 h-5 text-white" />
        </button>

        <div className="flex justify-between items-start">
          <div className="flex-1">
            <h1 className="text-white text-2xl mb-2">{property.name}</h1>
            <div className="flex items-center gap-2 text-green-100 mb-4">
              <MapPin className="w-4 h-4" />
              <p className="text-sm">{property.address}</p>
            </div>
            <div className="inline-block px-3 py-1 bg-white bg-opacity-20 rounded-full text-white text-xs">
              {property.type}
            </div>
          </div>
          <button className="w-11 h-11 bg-white bg-opacity-20 rounded-full flex items-center justify-center hover:bg-opacity-30 active:scale-95 transition-all">
            <Edit className="w-5 h-5 text-white" />
          </button>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="px-5 -mt-3 mb-6">
        <div className="grid grid-cols-3 gap-3">
          <div className="bg-white rounded-xl p-3 shadow-md text-center">
            <Home className="w-5 h-5 text-green-600 mx-auto mb-1" />
            <p className="text-xl text-gray-900">{formatNumber(property.totalUnits, language)}</p>
            <p className="text-xs text-gray-500">{t('units', language)}</p>
          </div>
          <div className="bg-white rounded-xl p-3 shadow-md text-center">
            <Users className="w-5 h-5 text-blue-600 mx-auto mb-1" />
            <p className="text-xl text-gray-900">{formatNumber(occupiedUnits, language)}</p>
            <p className="text-xs text-gray-500">{t('occupied', language)}</p>
          </div>
          <div className="bg-white rounded-xl p-3 shadow-md text-center">
            <DollarSign className="w-5 h-5 text-orange-600 mx-auto mb-1" />
            <p className="text-lg text-gray-900">{formatCurrency(monthlyRevenue, currency)}</p>
            <p className="text-xs text-gray-500">মাসিক</p>
          </div>
        </div>
      </div>

      {/* Property Info */}
      <div className="px-5 mb-6">
        <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
          <h3 className="text-gray-900 mb-4 text-base">{t('propertyInformation', language)}</h3>
          <div className="grid grid-cols-2 gap-4">
            <div>
              <p className="text-xs text-gray-500 mb-1">{t('floors', language)}</p>
              <p className="text-sm text-gray-900">{formatNumber(property.floors, language)} তলা</p>
            </div>
            <div>
              <p className="text-xs text-gray-500 mb-1">{t('totalSize', language)}</p>
              <p className="text-sm text-gray-900">{property.size}</p>
            </div>
            <div>
              <p className="text-xs text-gray-500 mb-1">{t('yearBuilt', language)}</p>
              <p className="text-sm text-gray-900">{formatNumber(property.yearBuilt, language)}</p>
            </div>
            <div>
              <p className="text-xs text-gray-500 mb-1">{t('vacancyRate', language)}</p>
              <p className="text-sm text-gray-900">{formatNumber(Math.round((vacantUnits / property.totalUnits) * 100), language)}%</p>
            </div>
          </div>

          <div className="mt-4 pt-4 border-t border-gray-100">
            <p className="text-xs text-gray-500 mb-2">{t('utilitiesIncluded', language)}</p>
            <div className="flex flex-wrap gap-2">
              {property.utilities.map((utility) => (
                <span key={utility} className="px-3 py-1 bg-blue-50 text-blue-600 rounded-lg text-xs">
                  {utility}
                </span>
              ))}
            </div>
          </div>

          <div className="mt-4 pt-4 border-t border-gray-100">
            <p className="text-xs text-gray-500 mb-2">{t('amenities', language)}</p>
            <div className="flex flex-wrap gap-2">
              {property.amenities.map((amenity) => (
                <span key={amenity} className="px-3 py-1 bg-green-50 text-green-600 rounded-lg text-xs">
                  {amenity}
                </span>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Units List */}
      <div className="px-5 mb-6">
        <div className="flex justify-between items-center mb-3">
          <h3 className="text-gray-900 text-base">{t('unitsOverview', language)}</h3>
          <span className="text-xs text-gray-500">{formatNumber(property.totalUnits, language)} {t('units', language)}</span>
        </div>
        
        <div className="space-y-2">
          {property.units.map((unit) => (
            <button
              key={unit.id}
              onClick={() => unit.tenant && onViewTenant(unit.id)}
              className="w-full bg-white rounded-xl p-4 shadow-sm border border-gray-100 hover:shadow-md active:scale-[0.98] transition-all"
            >
              <div className="flex items-center justify-between mb-3">
                <div className="flex items-center gap-3">
                  <div className={`w-11 h-11 rounded-lg flex items-center justify-center ${
                    unit.status === 'occupied' ? 'bg-green-50' : 'bg-gray-50'
                  }`}>
                    <Home className={`w-5 h-5 ${
                      unit.status === 'occupied' ? 'text-green-600' : 'text-gray-400'
                    }`} />
                  </div>
                  <div className="text-left">
                    <p className="text-gray-900">ইউনিট {unit.number}</p>
                    <p className="text-xs text-gray-500">তলা {formatNumber(unit.floor, language)} · {formatNumber(unit.rooms, language)} বেড · {unit.size}</p>
                  </div>
                </div>
                <div className="text-right">
                  <p className="text-gray-900">{formatCurrency(unit.rent, currency)}</p>
                  <p className="text-xs text-gray-500">/মাস</p>
                </div>
              </div>

              <div className="flex items-center justify-between">
                {unit.status === 'occupied' && unit.tenant ? (
                  <>
                    <div className="flex items-center gap-2">
                      <div className="w-7 h-7 bg-blue-100 rounded-full flex items-center justify-center">
                        <Users className="w-4 h-4 text-blue-600" />
                      </div>
                      <span className="text-xs text-gray-600">{unit.tenant}</span>
                    </div>
                    <div className="flex items-center gap-1">
                      <Calendar className="w-3 h-3 text-gray-400" />
                      <span className="text-xs text-gray-500">প্রতি মাসের {unit.dueDate}</span>
                    </div>
                  </>
                ) : (
                  <>
                    <span className="px-3 py-1 bg-orange-50 text-orange-600 rounded-lg text-xs">
                      {t('vacant', language)}
                    </span>
                    <button className="text-xs text-green-600 active:scale-95 transition-transform">ইউনিট ভাড়া দিন</button>
                  </>
                )}
              </div>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}
