import 'package:flutter/material.dart';
import 'package:home_rental_management/core/localization/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../utils/app_provider.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../providers/finance_provider.dart';
import 'package:intl/intl.dart';

class FinancialReportsScreen extends StatelessWidget {
  const FinancialReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final appProvider = Provider.of<AppProvider>(context);
    final financeProv = context.watch<FinanceProvider>();
    
    final payments = financeProv.payments;
    final totalCollected = financeProv.totalCollected;
    final totalPending = financeProv.totalPending;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: localizations.financialReports,
        showBackButton: false,
        actions: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.blue[50],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(Icons.payment, color: Colors.blue[700], size: 20),
            tooltip: 'Record Payment', 
            onPressed: () {
              // showDialog(
              //   context: context,
              //   builder: (_) => const RecordPaymentDialog(),
              // );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            Row(
              children: [
                _PeriodChip(label: localizations.monthly, isSelected: true),
                const SizedBox(width: 8),
                _PeriodChip(label: localizations.quarterly, isSelected: false),
                const SizedBox(width: 8),
                _PeriodChip(label: localizations.yearly, isSelected: false),
              ],
            ),
            const SizedBox(height: 16),

            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: localizations.totalRevenue,
                    value: appProvider.formatCurrency(totalCollected),
                    color: Colors.green,
                    icon: Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    title: localizations.totalExpense,
                    value: appProvider.formatCurrency(totalPending),
                    color: Colors.red,
                    icon: Icons.trending_down,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _SummaryCard(
              title: localizations.netProfit,
              value: appProvider.formatCurrency(80000),
              subtitle: '64% ${localizations.margin}',
              color: Colors.blue,
              icon: Icons.account_balance_wallet,
              isWide: true,
            ),
            const SizedBox(height: 24),

            // Expense Breakdown
            Text(
              localizations.expenseBreakdown,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _ExpenseItem(
                    label: 'Maintenance',
                    amount: appProvider.formatCurrency(20000),
                    percentage: 44,
                    color: Colors.blue,
                  ),
                  _ExpenseItem(
                    label: 'Utilities',
                    amount: appProvider.formatCurrency(15000),
                    percentage: 33,
                    color: Colors.orange,
                  ),
                  _ExpenseItem(
                    label: 'Other',
                    amount: appProvider.formatCurrency(10000),
                    percentage: 23,
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent Transactions
            Text(
              localizations.recentTransactions,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            payments.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('No payments recorded.')),
                )
              : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final payment = payments[index];
                return _TransactionItem(
                  title: payment.description,
                  subtitle: DateFormat('MMM d, yyyy').format(payment.date),
                  amount: appProvider.formatCurrency(payment.amount),
                  isIncome: payment.status == 'Collected',
                  date: '', // Not used anymore as it's merged into subtitle in our previous attempt
                );
              },
            ),
            const SizedBox(height: 16),

            // Export Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download),
                label: Text(localizations.exportReports),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _PeriodChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? Colors.blue : Colors.grey[300]!),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final Color color;
  final IconData icon;
  final bool isWide;

  const _SummaryCard({
    required this.title,
    required this.value,
    this.subtitle,
    required this.color,
    required this.icon,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}

class _ExpenseItem extends StatelessWidget {
  final String label;
  final String amount;
  final int percentage;
  final Color color;

  const _ExpenseItem({
    required this.label,
    required this.amount,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(amount, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final bool isIncome;
  final String date;

  const _TransactionItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isIncome ? Colors.green[50] : Colors.red[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? Colors.green[700] : Colors.red[700],
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}$amount',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isIncome ? Colors.green[700] : Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }
}
