import { ArrowLeft, Phone, Mail, MapPin, Calendar, DollarSign, FileText, CheckCircle, XCircle, AlertCircle, Download } from 'lucide-react';
import { useApp } from '../utils/context';
import { t, formatCurrency, formatNumber, formatDate } from '../utils/localization';

interface TenantProfileProps {
  tenantId: string | null;
  onBack: () => void;
}

const tenantData = {
  name: 'আহমেদ হাসান',
  phone: '+৮৮০ ১৭১২-৩৪৫৬৭৮',
  email: 'ahmed.hasan@email.com',
  id: 'TEN-2024-001',
  unit: 'সানসেট অ্যাপার্টমেন্ট - ইউনিট ২০৪',
  address: 'বনানী, ঢাকা-১২১৩',
  leaseStart: '2024-01-01',
  leaseEnd: '2024-12-31',
  monthlyRent: 25000, // BDT
  advance: 75000, // 3 months advance (common in Bangladesh)
  serviceCharge: 3000, // Monthly service charge
  gasElectricityBill: 'separate', // Tenant pays separately
  waterBill: 'included', // Included in rent
  securityDeposit: 50000,
  dueDate: 'প্রতি মাসের ১ তারিখ',
  status: 'active',
  paymentHistory: [
    { id: '1', month: 'জুন ২০২৪', amount: 25000, serviceCharge: 3000, status: 'paid', date: '2024-06-01', method: 'ব্যাংক ট্রান্সফার' },
    { id: '2', month: 'মে ২০২৪', amount: 25000, serviceCharge: 3000, status: 'paid', date: '2024-05-01', method: 'বিকাশ' },
    { id: '3', month: 'এপ্রিল ২০২৪', amount: 25000, serviceCharge: 3000, status: 'paid', date: '2024-04-05', method: 'নগদ', lateFee: 500 },
    { id: '4', month: 'মার্চ ২০২৪', amount: 25000, serviceCharge: 3000, status: 'paid', date: '2024-03-01', method: 'ব্যাংক ট্রান্সফার' },
    { id: '5', month: 'ফেব্রুয়ারি ২০২৪', amount: 25000, serviceCharge: 3000, status: 'paid', date: '2024-02-01', method: 'বিকাশ' },
    { id: '6', month: 'জানুয়ারি ২০২৪', amount: 25000, serviceCharge: 3000, status: 'paid', date: '2024-01-01', method: 'নগদ', note: 'অগ্রিম ৩ মাসের ভাড়া সহ' },
  ],
  documents: [
    { id: '1', name: 'ভাড়া চুক্তিপত্র', type: 'PDF', date: '২০২৪-০১-০১', size: '২.৪ MB' },
    { id: '2', name: 'জাতীয় পরিচয়পত্র', type: 'PDF', date: '২০২৩-১২-২৮', size: '১.২ MB' },
    { id: '3', name: 'পুলিশ ভেরিফিকেশন', type: 'PDF', date: '২০২৩-১২-২৮', size: '৮৫৬ KB' },
  ]
};

export function TenantProfile({ tenantId, onBack }: TenantProfileProps) {
  const { language, currency } = useApp();
  
  const totalPaid = tenantData.paymentHistory.reduce((sum, payment) => {
    return sum + payment.amount + payment.serviceCharge + (payment.lateFee || 0);
  }, 0);

  const onTimePayments = tenantData.paymentHistory.filter(p => !p.lateFee).length;
  const paymentRate = Math.round((onTimePayments / tenantData.paymentHistory.length) * 100);

  return (
    <div className="max-w-md mx-auto bg-gray-50 min-h-screen pb-6">
      {/* Header */}
      <div className="bg-gradient-to-br from-green-600 to-green-700 px-5 pt-12 pb-8 relative">
        <button 
          onClick={onBack}
          className="w-11 h-11 bg-white bg-opacity-20 rounded-full flex items-center justify-center mb-6 hover:bg-opacity-30 active:scale-95 transition-all"
        >
          <ArrowLeft className="w-5 h-5 text-white" />
        </button>

        {/* Profile Card */}
        <div className="bg-white rounded-2xl p-5 shadow-lg">
          <div className="flex items-start gap-4 mb-4">
            <div className="w-16 h-16 bg-gradient-to-br from-green-500 to-green-600 rounded-full flex items-center justify-center flex-shrink-0">
              <span className="text-white text-xl">আহ</span>
            </div>
            <div className="flex-1">
              <h2 className="text-xl text-gray-900 mb-1">{tenantData.name}</h2>
              <p className="text-xs text-gray-500 mb-3">ID: {tenantData.id}</p>
              <span className="px-3 py-1 bg-green-50 text-green-600 rounded-full text-xs">
                {t('activeTenant', language)}
              </span>
            </div>
          </div>

          <div className="space-y-3">
            <div className="flex items-center gap-3 text-sm">
              <Phone className="w-4 h-4 text-gray-400" />
              <span className="text-gray-600">{tenantData.phone}</span>
            </div>
            <div className="flex items-center gap-3 text-sm">
              <Mail className="w-4 h-4 text-gray-400" />
              <span className="text-gray-600">{tenantData.email}</span>
            </div>
            <div className="flex items-start gap-3 text-sm">
              <MapPin className="w-4 h-4 text-gray-400 mt-0.5" />
              <div>
                <p className="text-gray-900">{tenantData.unit}</p>
                <p className="text-gray-500 text-xs mt-1">{tenantData.address}</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Lease Information */}
      <div className="px-5 mt-6 mb-6">
        <h3 className="text-gray-900 mb-3 text-base">{t('leaseInformation', language)}</h3>
        <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
          <div className="grid grid-cols-2 gap-4 mb-4">
            <div>
              <p className="text-xs text-gray-500 mb-1">{t('leaseStart', language)}</p>
              <div className="flex items-center gap-2">
                <Calendar className="w-4 h-4 text-green-600" />
                <p className="text-sm text-gray-900">{formatDate(tenantData.leaseStart, language)}</p>
              </div>
            </div>
            <div>
              <p className="text-xs text-gray-500 mb-1">{t('leaseEnd', language)}</p>
              <div className="flex items-center gap-2">
                <Calendar className="w-4 h-4 text-orange-600" />
                <p className="text-sm text-gray-900">{formatDate(tenantData.leaseEnd, language)}</p>
              </div>
            </div>
          </div>

          <div className="pt-4 border-t border-gray-100 space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-gray-600">{t('monthlyRent', language)}</span>
              <span className="text-gray-900 font-medium">{formatCurrency(tenantData.monthlyRent, currency)}</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-gray-600">{t('serviceCharge', language)}</span>
              <span className="text-gray-900">{formatCurrency(tenantData.serviceCharge, currency)}</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-gray-600">{t('advance', language)} (৩ মাস)</span>
              <span className="text-gray-900">{formatCurrency(tenantData.advance, currency)}</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-gray-600">{t('securityDeposit', language)}</span>
              <span className="text-gray-900">{formatCurrency(tenantData.securityDeposit, currency)}</span>
            </div>
            <div className="pt-3 border-t border-gray-100">
              <div className="flex justify-between items-center">
                <span className="text-sm text-gray-600">{t('paymentDue', language)}</span>
                <span className="text-gray-900">{tenantData.dueDate}</span>
              </div>
            </div>
          </div>
        </div>

        {/* Utilities Info */}
        <div className="bg-blue-50 rounded-xl p-3 mt-3 border border-blue-100">
          <p className="text-xs text-blue-800 mb-2">ইউটিলিটি তথ্য:</p>
          <div className="space-y-1 text-xs">
            <p className="text-blue-700">• গ্যাস ও বিদ্যুৎ: ভাড়াটিয়া আলাদাভাবে পরিশোধ করবেন</p>
            <p className="text-blue-700">• পানি: ভাড়ার মধ্যে অন্তর্ভুক্ত</p>
          </div>
        </div>
      </div>

      {/* Payment Statistics */}
      <div className="px-5 mb-6">
        <h3 className="text-gray-900 mb-3 text-base">{t('paymentOverview', language)}</h3>
        <div className="grid grid-cols-3 gap-3">
          <div className="bg-white rounded-xl p-3 shadow-sm border border-gray-100 text-center">
            <DollarSign className="w-5 h-5 text-green-600 mx-auto mb-1" />
            <p className="text-lg text-gray-900">{formatCurrency(totalPaid, currency)}</p>
            <p className="text-xs text-gray-500 mt-1">{t('totalPaid', language)}</p>
          </div>
          <div className="bg-white rounded-xl p-3 shadow-sm border border-gray-100 text-center">
            <CheckCircle className="w-5 h-5 text-blue-600 mx-auto mb-1" />
            <p className="text-lg text-gray-900">{formatNumber(tenantData.paymentHistory.length, language)}</p>
            <p className="text-xs text-gray-500 mt-1">{t('payments', language)}</p>
          </div>
          <div className="bg-white rounded-xl p-3 shadow-sm border border-gray-100 text-center">
            <AlertCircle className="w-5 h-5 text-orange-600 mx-auto mb-1" />
            <p className="text-lg text-gray-900">{formatNumber(paymentRate, language)}%</p>
            <p className="text-xs text-gray-500 mt-1">{t('onTime', language)}</p>
          </div>
        </div>
      </div>

      {/* Payment History */}
      <div className="px-5 mb-6">
        <div className="flex justify-between items-center mb-3">
          <h3 className="text-gray-900 text-base">{t('paymentHistory', language)}</h3>
          <button className="text-xs text-green-600 active:scale-95 transition-transform">{t('viewAll', language)}</button>
        </div>
        <div className="space-y-2">
          {tenantData.paymentHistory.map((payment) => (
            <div key={payment.id} className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
              <div className="flex items-start justify-between mb-3">
                <div className="flex items-start gap-3">
                  <div className={`w-10 h-10 rounded-full flex items-center justify-center ${
                    payment.status === 'paid' ? 'bg-green-50' : 'bg-red-50'
                  }`}>
                    {payment.status === 'paid' ? (
                      <CheckCircle className="w-5 h-5 text-green-600" />
                    ) : (
                      <XCircle className="w-5 h-5 text-red-600" />
                    )}
                  </div>
                  <div>
                    <p className="text-sm text-gray-900 mb-1">{payment.month}</p>
                    <p className="text-xs text-gray-500">{formatDate(payment.date, language)} · {payment.method}</p>
                  </div>
                </div>
                <div className="text-right">
                  <p className="text-gray-900">{formatCurrency(payment.amount, currency)}</p>
                  {payment.serviceCharge > 0 && (
                    <p className="text-xs text-gray-500">+{formatCurrency(payment.serviceCharge, currency)} সার্ভিস</p>
                  )}
                  {payment.lateFee && (
                    <p className="text-xs text-orange-600">+{formatCurrency(payment.lateFee, currency)} জরিমানা</p>
                  )}
                </div>
              </div>
              {payment.lateFee && (
                <div className="pt-2 border-t border-gray-100">
                  <p className="text-xs text-orange-600 flex items-center gap-1">
                    <AlertCircle className="w-3 h-3" />
                    পেমেন্ট ২ দিন দেরিতে হয়েছে
                  </p>
                </div>
              )}
              {payment.note && (
                <div className="pt-2 border-t border-gray-100">
                  <p className="text-xs text-blue-600">{payment.note}</p>
                </div>
              )}
            </div>
          ))}
        </div>
      </div>

      {/* Documents */}
      <div className="px-5 mb-6">
        <div className="flex justify-between items-center mb-3">
          <h3 className="text-gray-900 text-base">{t('documents', language)}</h3>
          <button className="text-xs text-green-600 active:scale-95 transition-transform">আপলোড</button>
        </div>
        <div className="space-y-2">
          {tenantData.documents.map((doc) => (
            <div key={doc.id} className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 bg-red-50 rounded-lg flex items-center justify-center">
                    <FileText className="w-5 h-5 text-red-600" />
                  </div>
                  <div>
                    <p className="text-sm text-gray-900">{doc.name}</p>
                    <p className="text-xs text-gray-500">{doc.size} · {doc.date}</p>
                  </div>
                </div>
                <button className="w-9 h-9 bg-gray-50 rounded-lg flex items-center justify-center hover:bg-gray-100 active:scale-95 transition-all">
                  <Download className="w-4 h-4 text-gray-600" />
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Action Buttons */}
      <div className="px-5 mb-6">
        <div className="grid grid-cols-2 gap-3">
          <button className="bg-green-600 text-white py-3.5 rounded-xl hover:bg-green-700 active:scale-95 transition-all font-medium">
            {t('recordPayment', language)}
          </button>
          <button className="bg-white text-gray-700 py-3.5 rounded-xl border border-gray-200 hover:bg-gray-50 active:scale-95 transition-all font-medium">
            {t('sendMessage', language)}
          </button>
        </div>
      </div>
    </div>
  );
}
