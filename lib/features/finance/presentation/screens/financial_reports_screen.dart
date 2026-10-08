import 'package:flutter/material.dart';
import 'package:home_rental_management/core/theme/app_theme.dart';
import 'package:home_rental_management/core/localization/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../utils/app_provider.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../providers/finance_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/models/payment_model.dart';
import '../widgets/record_payment_dialog.dart';
import '../widgets/record_expense_dialog.dart';

class FinancialReportsScreen extends StatelessWidget {
  const FinancialReportsScreen({super.key});

  /// Minimal RFC 4180 CSV encoder.
  static String _toCsv(List<List<dynamic>> rows) {
    String esc(dynamic v) {
      final s = '${v ?? ''}';
      final needsQuotes = s.contains(RegExp(r'[,"\r\n]'));
      final q = s.replaceAll('"', '""');
      return needsQuotes ? '"$q"' : q;
    }

    return rows.map((r) => r.map(esc).join(',')).join('\r\n');
  }

  Future<void> _exportToCsv(BuildContext context, List<PaymentModel> payments, AppProvider appProvider) async {
    try {
      List<List<dynamic>> rows = [];
      // Header row
      rows.add(['Date', 'Description', 'Amount', 'Status', 'Tenant ID']);

      // Data rows
      for (var payment in payments) {
        rows.add([
          DateFormat('yyyy-MM-dd').format(payment.date),
          payment.description,
          appProvider.formatCurrency(payment.amount),
          payment.status,
          payment.tenantId,
        ]);
      }

      final csvData = _toCsv(rows);

      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/financial_report.csv';
      final file = File(path);
      // BOM so Excel opens UTF-8 (currency symbol, Bengali) correctly.
      await file.writeAsString('\uFEFF$csvData');

      if (context.mounted) {
        final box = context.findRenderObject() as RenderBox?;
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(path)],
            subject: 'Financial Report',
            sharePositionOrigin:
                box == null ? null : box.localToGlobal(Offset.zero) & box.size,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final appProvider = Provider.of<AppProvider>(context);
    final financeProv = context.watch<FinanceProvider>();
    
    final payments = financeProv.payments;
    final totalCollected = financeProv.totalCollected;
    final totalPending = financeProv.totalPending;

    return Scaffold(
      backgroundColor: context.cs.surface,
      appBar: CustomAppBar(
        title: localizations.financialReports,
        showBackButton: false,
        actions: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: context.cs.errorContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(Icons.money_off, color: context.cs.error, size: 20),
            tooltip: 'Record Expense', 
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const RecordExpenseDialog(),
              );
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: context.cs.primaryContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(Icons.payment, color: context.cs.primary, size: 20),
            tooltip: 'Record Payment', 
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const RecordPaymentDialog(),
              );
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

            // Financial Overview Dashboard
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: context.cs.outlineVariant.withValues(alpha: 0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.cs.shadow.withValues(alpha: 0.05),
                    spreadRadius: 2,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _OverviewRow('Expected Rent', appProvider.formatCurrency(totalCollected + totalPending), context.cs.onSurface),
                  const SizedBox(height: 8),
                  _OverviewRow('Collected Rent', appProvider.formatCurrency(totalCollected), context.appColors.success),
                  const SizedBox(height: 8),
                  _OverviewRow('Pending Rent', appProvider.formatCurrency(totalPending), context.appColors.warning),
                  const SizedBox(height: 8),
                  _OverviewRow('Expenses', appProvider.formatCurrency(financeProv.totalExpenses), context.cs.error),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(),
                  ),
                  _OverviewRow(
                    'Net Income',
                    appProvider.formatCurrency(totalCollected - financeProv.totalExpenses),
                    context.cs.primary,
                    isTotal: true,
                  ),
                ],
              ),
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
                color: context.cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: context.cs.shadow.withValues(alpha: 0.06),
                    spreadRadius: 1,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                children: [
                  if (financeProv.expenses.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: Text('No expenses recorded.')),
                    )
                  else
                    ...() {
                      final total = financeProv.totalExpenses;
                      final Map<String, double> categorySums = {};
                      for (var e in financeProv.expenses) {
                        categorySums[e.category] = (categorySums[e.category] ?? 0) + e.amount;
                      }
                      final sortedCategories = categorySums.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
                      final colors = [context.cs.primary, context.appColors.warning, context.appColors.accent, context.cs.error, context.cs.secondary];
                      
                      final sections = sortedCategories.asMap().entries.map((entry) {
                        final index = entry.key;
                        final sum = entry.value.value;
                        final color = colors[index % colors.length];
                        final pct = (sum / total * 100).round();
                        return PieChartSectionData(
                          color: color,
                          value: sum,
                          title: '$pct%',
                          radius: 50,
                          titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.cs.surface),
                        );
                      }).toList();

                      final items = sortedCategories.asMap().entries.map((entry) {
                        final index = entry.key;
                        final category = entry.value.key;
                        final sum = entry.value.value;
                        final color = colors[index % colors.length];
                        final pct = (sum / total * 100).round();
                        return _ExpenseItem(
                          label: category,
                          amount: appProvider.formatCurrency(sum),
                          percentage: pct,
                          color: color,
                        );
                      }).toList();

                      return [
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              sections: sections,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...items,
                      ];
                    }(),
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
                onPressed: () => _exportToCsv(context, payments, appProvider),
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
        color: isSelected ? context.cs.primary : context.cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? context.cs.primary : context.cs.outlineVariant),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? context.cs.onPrimary : context.cs.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
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
              backgroundColor: context.cs.outlineVariant,
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
        color: context.cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: context.cs.shadow.withValues(alpha: 0.06),
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
              color: isIncome ? context.appColors.successContainer : context.cs.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? context.appColors.success : context.cs.error,
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
                  style: TextStyle(fontSize: 12, color: context.cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}$amount',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isIncome ? context.appColors.success : context.cs.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewRow extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;
  final bool isTotal;

  const _OverviewRow(this.label, this.amount, this.color, {this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: context.cs.onSurfaceVariant,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
