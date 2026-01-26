import { Building2, Users, DollarSign, TrendingUp, Plus, Home, AlertCircle } from 'lucide-react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, PieChart, Pie, Cell } from 'recharts';
import { useApp } from '../utils/context';
import { t, formatCurrency, formatNumber } from '../utils/localization';

interface DashboardProps {
  onNavigateToProperties: () => void;
  onNavigateToProperty: (propertyId: string) => void;
  onNavigateToTenant: (tenantId: string) => void;
}

const monthlyData = [
  { month: 'জানু', collected: 125000, pending: 25000 },
  { month: 'ফেব্রু', collected: 140000, pending: 10000 },
  { month: 'মার্চ', collected: 138000, pending: 12000 },
  { month: 'এপ্রিল', collected: 150000, pending: 0 },
  { month: 'মে', collected: 142000, pending: 8000 },
  { month: 'জুন', collected: 155000, pending: 5000 },
];

const expensesData = [
  { name: 'রক্ষণাবেক্ষণ', value: 32000, color: '#3B82F6' },
  { name: 'ইউটিলিটি', value: 18000, color: '#10B981' },
  { name: 'কর', value: 24000, color: '#F59E0B' },
  { name: 'বিমা', value: 16000, color: '#8B5CF6' },
];

const recentActivity = [
  { id: '1', tenant: 'জন স্মিথ', property: 'সানসেট অ্যাপার্টমেন্ট #২০৪', action: 'ভাড়া পরিশোধ করেছেন', amount: 12000, time: '২ ঘন্টা আগে', type: 'payment' },
  { id: '2', tenant: 'সারা জনসন', property: 'ওক বিল্ডিং #১২', action: 'চুক্তি নবায়ন', amount: 0, time: '১ দিন আগে', type: 'renewal' },
  { id: '3', tenant: 'মাইক ডেভিস', property: 'পাইন টাওয়ার #৩০৫', action: 'ভাড়া বকেয়া', amount: 9500, time: '৩ দিন আগে', type: 'overdue' },
];

export function Dashboard({ onNavigateToProperties, onNavigateToProperty, onNavigateToTenant }: DashboardProps) {
  const { language, currency } = useApp();

  return (
    <div className="max-w-md mx-auto bg-gray-50 min-h-screen">
      {/* Header */}
      <div className="bg-gradient-to-br from-green-600 to-green-700 px-5 pt-12 pb-8 rounded-b-3xl shadow-lg">
        <div className="flex justify-between items-start mb-6">
          <div>
            <h1 className="text-white text-2xl mb-1">{t('welcomeBack', language)}</h1>
            <p className="text-green-100 text-sm">{t('propertyManagerDashboard', language)}</p>
          </div>
          <div className="w-11 h-11 bg-green-500 rounded-full flex items-center justify-center shadow-md">
            <span className="text-white text-sm">PM</span>
          </div>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-2 gap-3 -mb-6">
          <div className="bg-white rounded-2xl p-4 shadow-md active:scale-95 transition-transform">
            <div className="flex items-center gap-2 mb-2">
              <div className="w-9 h-9 bg-green-50 rounded-lg flex items-center justify-center">
                <Building2 className="w-5 h-5 text-green-600" />
              </div>
              <span className="text-xs text-gray-500">{t('buildings', language)}</span>
            </div>
            <p className="text-2xl text-gray-900">{formatNumber(12, language)}</p>
            <p className="text-xs text-green-600 mt-1">+{formatNumber(2, language)} এই মাসে</p>
          </div>

          <div className="bg-white rounded-2xl p-4 shadow-md active:scale-95 transition-transform">
            <div className="flex items-center gap-2 mb-2">
              <div className="w-9 h-9 bg-blue-50 rounded-lg flex items-center justify-center">
                <Home className="w-5 h-5 text-blue-600" />
              </div>
              <span className="text-xs text-gray-500">{t('units', language)}</span>
            </div>
            <p className="text-2xl text-gray-900">{formatNumber(48, language)}</p>
            <p className="text-xs text-gray-500 mt-1">{formatNumber(42, language)} {t('occupied', language)}</p>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="px-5 pt-10 pb-6">
        {/* Quick Stats */}
        <div className="grid grid-cols-2 gap-3 mb-6">
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100 active:scale-95 transition-transform">
            <div className="flex items-center gap-2 mb-2">
              <div className="w-9 h-9 bg-purple-50 rounded-lg flex items-center justify-center">
                <Users className="w-5 h-5 text-purple-600" />
              </div>
              <span className="text-xs text-gray-500">{t('totalTenants', language)}</span>
            </div>
            <p className="text-2xl text-gray-900">{formatNumber(42, language)}</p>
            <p className="text-xs text-gray-500 mt-1">{formatNumber(6, language)} {t('vacant', language)}</p>
          </div>

          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100 active:scale-95 transition-transform">
            <div className="flex items-center gap-2 mb-2">
              <div className="w-9 h-9 bg-orange-50 rounded-lg flex items-center justify-center">
                <DollarSign className="w-5 h-5 text-orange-600" />
              </div>
              <span className="text-xs text-gray-500">{t('thisMonth', language)}</span>
            </div>
            <p className="text-xl text-gray-900">{formatCurrency(155000, currency)}</p>
            <p className="text-xs text-green-600 mt-1">+১২% গত মাস থেকে</p>
          </div>
        </div>

        {/* Quick Actions */}
        <div className="mb-6">
          <h3 className="text-sm text-gray-600 mb-3">{t('quickActions', language)}</h3>
          <div className="grid grid-cols-3 gap-3">
            <button className="bg-white rounded-xl p-4 shadow-sm border border-gray-100 hover:shadow-md active:scale-95 transition-all">
              <div className="w-11 h-11 bg-green-50 rounded-full flex items-center justify-center mx-auto mb-2">
                <Plus className="w-6 h-6 text-green-600" />
              </div>
              <p className="text-xs text-gray-700 text-center leading-tight">{t('addProperty', language)}</p>
            </button>
            <button className="bg-white rounded-xl p-4 shadow-sm border border-gray-100 hover:shadow-md active:scale-95 transition-all">
              <div className="w-11 h-11 bg-blue-50 rounded-full flex items-center justify-center mx-auto mb-2">
                <Users className="w-6 h-6 text-blue-600" />
              </div>
              <p className="text-xs text-gray-700 text-center leading-tight">{t('addTenant', language)}</p>
            </button>
            <button className="bg-white rounded-xl p-4 shadow-sm border border-gray-100 hover:shadow-md active:scale-95 transition-all">
              <div className="w-11 h-11 bg-orange-50 rounded-full flex items-center justify-center mx-auto mb-2">
                <DollarSign className="w-6 h-6 text-orange-600" />
              </div>
              <p className="text-xs text-gray-700 text-center leading-tight">{t('addPayment', language)}</p>
            </button>
          </div>
        </div>

        {/* Monthly Revenue Chart */}
        <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100 mb-6">
          <div className="flex justify-between items-center mb-4">
            <div>
              <h3 className="text-gray-900 text-base">{t('monthlyRevenue', language)}</h3>
              <p className="text-xs text-gray-500 mt-1">{t('collectedVsPending', language)}</p>
            </div>
            <TrendingUp className="w-5 h-5 text-green-600" />
          </div>
          <ResponsiveContainer width="100%" height={160}>
            <BarChart data={monthlyData}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
              <XAxis dataKey="month" tick={{ fontSize: 10 }} stroke="#9CA3AF" />
              <YAxis tick={{ fontSize: 10 }} stroke="#9CA3AF" />
              <Tooltip 
                contentStyle={{ 
                  backgroundColor: '#fff', 
                  border: '1px solid #e5e7eb',
                  borderRadius: '8px',
                  fontSize: '12px'
                }}
                formatter={(value: number) => formatCurrency(value, currency)}
              />
              <Bar dataKey="collected" fill="#10B981" radius={[4, 4, 0, 0]} />
              <Bar dataKey="pending" fill="#F59E0B" radius={[4, 4, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
          <div className="flex justify-center gap-4 mt-3">
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 bg-green-500 rounded"></div>
              <span className="text-xs text-gray-600">{t('collected', language)}</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 bg-orange-500 rounded"></div>
              <span className="text-xs text-gray-600">{t('pending', language)}</span>
            </div>
          </div>
        </div>

        {/* Expenses Breakdown */}
        <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100 mb-6">
          <h3 className="text-gray-900 mb-4 text-base">{t('monthlyExpenses', language)}</h3>
          <div className="flex items-center justify-between">
            <ResponsiveContainer width="40%" height={140}>
              <PieChart>
                <Pie
                  data={expensesData}
                  cx="50%"
                  cy="50%"
                  innerRadius={30}
                  outerRadius={50}
                  paddingAngle={2}
                  dataKey="value"
                >
                  {expensesData.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={entry.color} />
                  ))}
                </Pie>
              </PieChart>
            </ResponsiveContainer>
            <div className="flex-1 space-y-2">
              {expensesData.map((expense) => (
                <div key={expense.name} className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <div className="w-2 h-2 rounded-full" style={{ backgroundColor: expense.color }}></div>
                    <span className="text-xs text-gray-600">{expense.name}</span>
                  </div>
                  <span className="text-xs text-gray-900">{formatCurrency(expense.value, currency)}</span>
                </div>
              ))}
            </div>
          </div>
          <div className="mt-4 pt-4 border-t border-gray-100">
            <div className="flex justify-between items-center">
              <span className="text-sm text-gray-600">{t('totalExpenses', language)}</span>
              <span className="text-gray-900">{formatCurrency(90000, currency)}</span>
            </div>
          </div>
        </div>

        {/* Recent Activity */}
        <div className="mb-6">
          <div className="flex justify-between items-center mb-3">
            <h3 className="text-gray-900 text-base">{t('recentActivity', language)}</h3>
            <button className="text-xs text-green-600 active:scale-95 transition-transform">{t('viewAll', language)}</button>
          </div>
          <div className="space-y-3">
            {recentActivity.map((activity) => (
              <div key={activity.id} className="bg-white rounded-xl p-4 shadow-sm border border-gray-100 active:scale-[0.98] transition-transform">
                <div className="flex items-start gap-3">
                  <div className={`w-11 h-11 rounded-full flex items-center justify-center flex-shrink-0 ${
                    activity.type === 'payment' ? 'bg-green-50' :
                    activity.type === 'renewal' ? 'bg-blue-50' :
                    'bg-red-50'
                  }`}>
                    {activity.type === 'payment' ? <DollarSign className="w-5 h-5 text-green-600" /> :
                     activity.type === 'renewal' ? <Users className="w-5 h-5 text-blue-600" /> :
                     <AlertCircle className="w-5 h-5 text-red-600" />}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex justify-between items-start mb-1">
                      <p className="text-sm text-gray-900">{activity.tenant}</p>
                      {activity.amount > 0 && (
                        <span className={`text-sm ${activity.type === 'overdue' ? 'text-red-600' : 'text-green-600'}`}>
                          {formatCurrency(activity.amount, currency)}
                        </span>
                      )}
                    </div>
                    <p className="text-xs text-gray-500 mb-1">{activity.property}</p>
                    <div className="flex justify-between items-center">
                      <p className="text-xs text-gray-600">{activity.action}</p>
                      <span className="text-xs text-gray-400">{activity.time}</span>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
