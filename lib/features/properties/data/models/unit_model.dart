enum UnitStatus { vacant, occupied }

class UnitModel {
  final int? id;
  final int propertyId;
  final String unitNumber;
  final double rentAmount;
  final UnitStatus status;

  UnitModel({
    this.id,
    required this.propertyId,
    required this.unitNumber,
    required this.rentAmount,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'propertyId': propertyId,
      'unitNumber': unitNumber,
      'rentAmount': rentAmount,
      'status': status.name,
    };
  }

  factory UnitModel.fromMap(Map<String, dynamic> map) {
    return UnitModel(
      id: map['id'] as int?,
      propertyId: map['propertyId'] as int,
      unitNumber: map['unitNumber'] as String,
      rentAmount: (map['rentAmount'] as num).toDouble(),
      status: UnitStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => UnitStatus.vacant,
      ),
    );
  }

  UnitModel copyWith({
    int? id,
    int? propertyId,
    String? unitNumber,
    double? rentAmount,
    UnitStatus? status,
  }) {
    return UnitModel(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      unitNumber: unitNumber ?? this.unitNumber,
      rentAmount: rentAmount ?? this.rentAmount,
      status: status ?? this.status,
    );
  }
}
