enum PaymentMethod { cash, bank, mobileBanking }
enum PaymentStatus { paid, pending, overdue }

class PaymentModel {
  final int? id;
  final int tenantId;
  final int unitId;
  final double amount;
  final DateTime date;
  final String monthYear; // e.g. "May 2026"
  final PaymentMethod paymentMethod;
  final String? notes;
  final PaymentStatus status;

  PaymentModel({
    this.id,
    required this.tenantId,
    required this.unitId,
    required this.amount,
    required this.date,
    required this.monthYear,
    required this.paymentMethod,
    this.notes,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'tenantId': tenantId,
      'unitId': unitId,
      'amount': amount,
      'date': date.toIso8601String(),
      'monthYear': monthYear,
      'paymentMethod': paymentMethod.name,
      'notes': notes,
      'status': status.name,
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'] as int?,
      tenantId: map['tenantId'] as int,
      unitId: map['unitId'] as int,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      monthYear: map['monthYear'] as String,
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == map['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      notes: map['notes'] as String?,
      status: PaymentStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => PaymentStatus.pending,
      ),
    );
  }

  PaymentModel copyWith({
    int? id,
    int? tenantId,
    int? unitId,
    double? amount,
    DateTime? date,
    String? monthYear,
    PaymentMethod? paymentMethod,
    String? notes,
    PaymentStatus? status,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      unitId: unitId ?? this.unitId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      monthYear: monthYear ?? this.monthYear,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      status: status ?? this.status,
    );
  }
}
