import 'package:flutter/material.dart';
import 'package:home_rental_management/core/localization/app_localizations.dart';
import 'package:home_rental_management/features/finance/data/models/payment_model.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../utils/app_provider.dart';
import '../providers/finance_provider.dart';
import '../../../properties/presentation/providers/property_provider.dart';
import '../../../../core/widgets/add_forms.dart';

class FinancialReportsScreen extends StatelessWidget {
  const FinancialReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final appProvider = Provider.of<AppProvider>(context);
    final financeProvider = Provider.of<FinanceProvider>(context);

    final double income = financeProvider.getCollectedRevenue();
    final double expense = financeProvider.getTotalExpenses();
    final double profit = income - expense;
    final double profitRatio = income == 0 ? 0.0 : (profit / income);

    final catBreakdown = financeProvider.getExpenseBreakdown();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(
          localizations.financial,
          style: const TextStyle(
              fontWeight: FontWeight.w800, letterSpacing: -0.5, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Big Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0F172A),
                    Color(0xFF1E293B)
                  ], // Sleek dark Obsidian Slate
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NET OPERATING INCOME (NOI)',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    appProvider.formatCurrency(profit),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _MiniFlowItem(
                          icon: Icons.arrow_downward_rounded,
                          color: const Color(0xFF10B981),
                          label: 'Collections',
                          val: appProvider.formatCurrency(income),
                        ),
                      ),
                      Container(width: 1, height: 32, color: Colors.white24),
                      Expanded(
                        child: _MiniFlowItem(
                          icon: Icons.arrow_upward_rounded,
                          color: Colors.redAccent,
                          label: 'Overheads',
                          val: appProvider.formatCurrency(expense),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fade().scale(delay: 100.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 28),

            // Visual Performance Bar Chart
            const Text(
              'Margin & Efficiency Analytics',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3),
            ),
            const SizedBox(height: 12),
            Container(
              height: 180,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Margin Ratio',
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('${(profitRatio * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1)),
                        const SizedBox(height: 12),
                        Text(
                          profitRatio >= 0.5
                              ? 'Outstanding operational efficiency.'
                              : profitRatio > 0
                                  ? 'Healthy margins; monitor repair costs.'
                                  : 'Negative margin; review expenditures.',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Side-by-side Bar Graph Indicator
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: BarChart(
                        BarChartData(
                          borderData: FlBorderData(show: false),
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: income == 0 ? 1 : income,
                                  color: const Color(0xFF10B981),
                                  width: 14,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                BarChartRodData(
                                  toY: expense == 0 ? 0.1 : expense,
                                  color: Colors.redAccent,
                                  width: 14,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fade(delay: 250.ms).slideY(begin: 0.05),
            const SizedBox(height: 28),

            // Expense Category Split
            const Text(
              'Overheads Split by Category',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: catBreakdown.isEmpty
                  ? Center(
                      child: Text('No expenses logged yet.',
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w600)))
                  : Column(
                      children: catBreakdown.entries.map((entry) {
                        final ratio =
                            expense == 0 ? 0.0 : (entry.value / expense);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(entry.key,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13)),
                                  Text(appProvider.formatCurrency(entry.value),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 13)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: ratio,
                                  minHeight: 6,
                                  backgroundColor: Colors.grey[100],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.redAccent),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ).animate().fade(delay: 350.ms).slideY(begin: 0.05),
            const SizedBox(height: 28),

            // Comprehensive Audit Transaction List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Cash Flows',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3),
                ),
                TextButton.icon(
                  onPressed: () => AddExpenseModal.show(context),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Expense',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (financeProvider.payments.isEmpty &&
                financeProvider.expenses.isEmpty)
              Center(
                  child: Text('No transactions found.',
                      style: TextStyle(color: Colors.grey[400])))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (financeProvider.payments.length +
                    financeProvider.expenses.length),
                itemBuilder: (ctx, idx) {
                  final combined = <dynamic>[];
                  combined.addAll(financeProvider.payments);
                  combined.addAll(financeProvider.expenses);
                  // Sort descending dates
                  combined.sort((a, b) => b.date.compareTo(a.date));

                  final item = combined[idx];

                  if (item is PaymentModel) {
                    return _TransacItem(
                      label: 'Rent Paid (${item.monthYear})',
                      dateStr: DateFormat('MMM dd, yyyy').format(item.date),
                      valStr: '+${appProvider.formatCurrency(item.amount)}',
                      isIncome: true,
                    )
                        .animate()
                        .fade(delay: (400 + idx * 50).ms)
                        .slideX(begin: 0.05);
                  } else {
                    return _TransacItem(
                      label: '${item.category} - ${item.description}',
                      dateStr: DateFormat('MMM dd, yyyy').format(item.date),
                      valStr: '-${appProvider.formatCurrency(item.amount)}',
                      isIncome: false,
                    )
                        .animate()
                        .fade(delay: (400 + idx * 50).ms)
                        .slideX(begin: 0.05);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _MiniFlowItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String val;

  const _MiniFlowItem(
      {required this.icon,
      required this.color,
      required this.label,
      required this.val});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: color.withOpacity(0.2), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(val,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800)),
          ],
        ),
      ],
    );
  }
}

class _TransacItem extends StatelessWidget {
  final String label;
  final String dateStr;
  final String valStr;
  final bool isIncome;

  const _TransacItem(
      {required this.label,
      required this.dateStr,
      required this.valStr,
      required this.isIncome});

  @override
  Widget build(BuildContext context) {
    final color = isIncome ? const Color(0xFF10B981) : Colors.redAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                color: color, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(dateStr,
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Text(valStr,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }
}
