import { DollarSign, TrendingUp, TrendingDown, Download, Filter } from 'lucide-react';
import { LineChart, Line, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { useState } from 'react';
import { useApp } from '../utils/context';
import { t, formatCurrency, formatNumber } from '../utils/localization';

const monthlyRevenueData = [
  { month: 'জানু', revenue: 452000, expenses: 123000, profit: 329000 },
  { month: 'ফেব্রু', revenue: 478000, expenses: 118000, profit: 360000 },
  { month: 'মার্চ', revenue: 465000, expenses: 132000, profit: 333000 },
  { month: 'এপ্রিল', revenue: 489000, expenses: 109000, profit: 380000 },
  { month: 'মে', revenue: 492000, expenses: 121000, profit: 371000 },
  { month: 'জুন', revenue: 504000, expenses: 115000, profit: 389000 },
];

const expenseBreakdown = [
  { category: 'রক্ষণাবেক্ষণ', amount: 32000, percentage: 28, color: '#3B82F6' },
  { category: 'ইউটিলিটি', amount: 28000, percentage: 24, color: '#10B981' },
  { category: 'সম্পত্তি কর', amount: 24000, percentage: 21, color: '#F59E0B' },
  { category: 'বিমা', amount: 16000, percentage: 14, color: '#8B5CF6' },
  { category: 'ব্যবস্থাপনা', amount: 15000, percentage: 13, color: '#EC4899' },
];

const recentTransactions = [
  { id: '1', type: 'income', description: 'ভাড়া - ইউনিট ২০৪', amount: 25000, date: '২০২৪-০৬-০১', property: 'সানসেট অ্যাপার্টমেন্ট' },
  { id: '2', type: 'expense', description: 'প্লাম্বিং মেরামত', amount: 3500, date: '২০২৪-০৬-০২', property: 'ওক বিল্ডিং' },
  { id: '3', type: 'income', description: 'ভাড়া - ইউনিট ১২', amount: 30000, date: '২০২৪-০৬-০১', property: 'পাইন টাওয়ার' },
  { id: '4', type: 'expense', description: 'বিদ্যুৎ বিল', amount: 4800, date: '২০২৪-০৬-০৩', property: 'সানসেট অ্যাপার্টমেন্ট' },
  { id: '5', type: 'income', description: 'ভাড়া - ইউনিট ৩০৫', amount: 28000, date: '২০২৪-০৬-০৫', property: 'ওক বিল্ডিং' },
];

export function FinancialReports() {
  const { language, currency } = useApp();
  const [reportPeriod, setReportPeriod] = useState<'month' | 'quarter' | 'year'>('month');

  const totalRevenue = monthlyRevenueData.reduce((sum, item) => sum + item.revenue, 0);
  const totalExpenses = monthlyRevenueData.reduce((sum, item) => sum + item.expenses, 0);
  const totalProfit = totalRevenue - totalExpenses;
  const profitMargin = Math.round((totalProfit / totalRevenue) * 100);

  return (
    <div className="max-w-md mx-auto bg-gray-50 min-h-screen pb-6">
      {/* Header */}
      <div className="bg-gradient-to-br from-green-600 to-green-700 px-5 pt-12 pb-8 rounded-b-3xl shadow-lg">
        <div className="flex justify-between items-start mb-6">
          <div>
            <h1 className="text-white text-2xl mb-1">{t('financialReports', language)}</h1>
            <p className="text-green-100 text-sm">{t('trackRevenueExpenses', language)}</p>
          </div>
          <button className="w-11 h-11 bg-white bg-opacity-20 rounded-full flex items-center justify-center hover:bg-opacity-30 active:scale-95 transition-all">
            <Download className="w-5 h-5 text-white" />
          </button>
        </div>

        {/* Period Selector */}
        <div className="flex gap-2">
          <button 
            onClick={() => setReportPeriod('month')}
            className={`flex-1 py-2.5 rounded-xl text-sm transition-all active:scale-95 ${
              reportPeriod === 'month' 
                ? 'bg-white text-green-600 shadow-md' 
                : 'bg-white bg-opacity-20 text-white'
            }`}
          >
            {t('monthly', language)}
          </button>
          <button 
            onClick={() => setReportPeriod('quarter')}
            className={`flex-1 py-2.5 rounded-xl text-sm transition-all active:scale-95 ${
              reportPeriod === 'quarter' 
                ? 'bg-white text-green-600 shadow-md' 
                : 'bg-white bg-opacity-20 text-white'
            }`}
          >
            {t('quarterly', language)}
          </button>
          <button 
            onClick={() => setReportPeriod('year')}
            className={`flex-1 py-2.5 rounded-xl text-sm transition-all active:scale-95 ${
              reportPeriod === 'year' 
                ? 'bg-white text-green-600 shadow-md' 
                : 'bg-white bg-opacity-20 text-white'
            }`}
          >
            {t('yearly', language)}
          </button>
        </div>
      </div>

      {/* Summary Cards */}
      <div className="px-5 -mt-4 mb-6">
        <div className="grid grid-cols-2 gap-3 mb-3">
          <div className="bg-white rounded-2xl p-4 shadow-md">
            <div className="flex items-center gap-2 mb-2">
              <div className="w-9 h-9 bg-green-50 rounded-lg flex items-center justify-center">
                <TrendingUp className="w-5 h-5 text-green-600" />
              </div>
              <span className="text-xs text-gray-500">{t('totalRevenue', language)}</span>
            </div>
            <p className="text-2xl text-gray-900">{formatCurrency(totalRevenue, currency)}</p>
            <p className="text-xs text-green-600 mt-1">+১২.৫% গত সময় থেকে</p>
          </div>

          <div className="bg-white rounded-2xl p-4 shadow-md">
            <div className="flex items-center gap-2 mb-2">
              <div className="w-9 h-9 bg-red-50 rounded-lg flex items-center justify-center">
                <TrendingDown className="w-5 h-5 text-red-600" />
              </div>
              <span className="text-xs text-gray-500">{t('totalExpense', language)}</span>
            </div>
            <p className="text-2xl text-gray-900">{formatCurrency(totalExpenses, currency)}</p>
            <p className="text-xs text-red-600 mt-1">-৩.২% গত সময় থেকে</p>
          </div>
        </div>

        <div className="bg-gradient-to-br from-green-600 to-green-700 rounded-2xl p-4 shadow-md">
          <div className="flex items-center justify-between mb-2">
            <div className="flex items-center gap-2">
              <div className="w-9 h-9 bg-white bg-opacity-20 rounded-lg flex items-center justify-center">
                <DollarSign className="w-5 h-5 text-white" />
              </div>
              <span className="text-xs text-green-100">{t('netProfit', language)}</span>
            </div>
            <span className="px-2 py-1 bg-white bg-opacity-20 rounded-lg text-white text-xs">
              {formatNumber(profitMargin, language)}% {t('margin', language)}
            </span>
          </div>
          <p className="text-3xl text-white">{formatCurrency(totalProfit, currency)}</p>
          <p className="text-xs text-green-100 mt-1">শেষ ৬ মাসের মোট</p>
        </div>
      </div>

      {/* Revenue vs Expenses Chart */}
      <div className="px-5 mb-6">
        <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
          <div className="flex justify-between items-center mb-4">
            <h3 className="text-gray-900 text-base">{t('revenueVsExpenses', language)}</h3>
            <button className="w-9 h-9 bg-gray-50 rounded-lg flex items-center justify-center active:scale-95 transition-transform">
              <Filter className="w-4 h-4 text-gray-600" />
            </button>
          </div>
          <ResponsiveContainer width="100%" height={200}>
            <LineChart data={monthlyRevenueData}>
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
              <Line type="monotone" dataKey="revenue" stroke="#10B981" strokeWidth={2} dot={{ r: 4 }} />
              <Line type="monotone" dataKey="expenses" stroke="#EF4444" strokeWidth={2} dot={{ r: 4 }} />
              <Line type="monotone" dataKey="profit" stroke="#3B82F6" strokeWidth={2} dot={{ r: 4 }} />
            </LineChart>
          </ResponsiveContainer>
          <div className="flex justify-center gap-4 mt-3">
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 bg-green-500 rounded"></div>
              <span className="text-xs text-gray-600">আয়</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 bg-red-500 rounded"></div>
              <span className="text-xs text-gray-600">খরচ</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 bg-blue-500 rounded"></div>
              <span className="text-xs text-gray-600">মুনাফা</span>
            </div>
          </div>
        </div>
      </div>

      {/* Expense Breakdown */}
      <div className="px-5 mb-6">
        <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
          <h3 className="text-gray-900 mb-4 text-base">{t('expenseBreakdown', language)}</h3>
          <div className="space-y-3">
            {expenseBreakdown.map((expense) => (
              <div key={expense.category}>
                <div className="flex justify-between items-center mb-2">
                  <div className="flex items-center gap-2">
                    <div className="w-3 h-3 rounded" style={{ backgroundColor: expense.color }}></div>
                    <span className="text-sm text-gray-600">{expense.category}</span>
                  </div>
                  <div className="text-right">
                    <span className="text-sm text-gray-900">{formatCurrency(expense.amount, currency)}</span>
                    <span className="text-xs text-gray-500 ml-2">({formatNumber(expense.percentage, language)}%)</span>
                  </div>
                </div>
                <div className="w-full h-2 bg-gray-100 rounded-full overflow-hidden">
                  <div 
                    className="h-full rounded-full transition-all"
                    style={{ 
                      width: `${expense.percentage}%`,
                      backgroundColor: expense.color
                    }}
                  ></div>
                </div>
              </div>
            ))}
          </div>
          <div className="mt-4 pt-4 border-t border-gray-100">
            <div className="flex justify-between items-center">
              <span className="text-sm text-gray-600">মাসিক মোট খরচ</span>
              <span className="text-gray-900">
                {formatCurrency(expenseBreakdown.reduce((sum, e) => sum + e.amount, 0), currency)}
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* Recent Transactions */}
      <div className="px-5 mb-6">
        <div className="flex justify-between items-center mb-3">
          <h3 className="text-gray-900 text-base">{t('recentTransactions', language)}</h3>
          <button className="text-xs text-green-600 active:scale-95 transition-transform">{t('viewAll', language)}</button>
        </div>
        <div className="space-y-2">
          {recentTransactions.map((transaction) => (
            <div key={transaction.id} className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
              <div className="flex items-start justify-between mb-2">
                <div className="flex items-start gap-3">
                  <div className={`w-11 h-11 rounded-full flex items-center justify-center ${
                    transaction.type === 'income' ? 'bg-green-50' : 'bg-red-50'
                  }`}>
                    {transaction.type === 'income' ? (
                      <TrendingUp className="w-5 h-5 text-green-600" />
                    ) : (
                      <TrendingDown className="w-5 h-5 text-red-600" />
                    )}
                  </div>
                  <div>
                    <p className="text-sm text-gray-900 mb-1">{transaction.description}</p>
                    <p className="text-xs text-gray-500">{transaction.property}</p>
                  </div>
                </div>
                <div className="text-right">
                  <p className={`text-sm ${transaction.type === 'income' ? 'text-green-600' : 'text-red-600'}`}>
                    {transaction.type === 'income' ? '+' : '-'}{formatCurrency(transaction.amount, currency)}
                  </p>
                  <p className="text-xs text-gray-500 mt-1">{transaction.date}</p>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Export Options */}
      <div className="px-5 mb-6">
        <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
          <h3 className="text-gray-900 mb-3 text-base">{t('exportReports', language)}</h3>
          <div className="grid grid-cols-2 gap-3">
            <button className="py-3.5 bg-blue-50 text-blue-600 rounded-xl hover:bg-blue-100 active:scale-95 transition-all text-sm font-medium">
              {t('exportPDF', language)}
            </button>
            <button className="py-3.5 bg-green-50 text-green-600 rounded-xl hover:bg-green-100 active:scale-95 transition-all text-sm font-medium">
              {t('exportExcel', language)}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
