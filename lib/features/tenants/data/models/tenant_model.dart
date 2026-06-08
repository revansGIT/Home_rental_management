class TenantModel {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String nid; // National ID or Identification Number
  final int propertyId;
  final int unitId;
  final DateTime leaseStart;
  final DateTime leaseEnd;
  final double rentAmount;
  final double deposit;
  final bool isActive;

  TenantModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.nid,
    required this.propertyId,
    required this.unitId,
    required this.leaseStart,
    required this.leaseEnd,
    required this.rentAmount,
    required this.deposit,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'nid': nid,
      'propertyId': propertyId,
      'unitId': unitId,
      'leaseStart': leaseStart.toIso8601String(),
      'leaseEnd': leaseEnd.toIso8601String(),
      'rentAmount': rentAmount,
      'deposit': deposit,
      'isActive': isActive ? 1 : 0,
    };
  }

  factory TenantModel.fromMap(Map<String, dynamic> map) {
    return TenantModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      nid: map['nid'] as String,
      propertyId: map['propertyId'] as int,
      unitId: map['unitId'] as int,
      leaseStart: DateTime.parse(map['leaseStart'] as String),
      leaseEnd: DateTime.parse(map['leaseEnd'] as String),
      rentAmount: (map['rentAmount'] as num).toDouble(),
      deposit: (map['deposit'] as num).toDouble(),
      isActive: (map['isActive'] as int) == 1,
    );
  }

  TenantModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? nid,
    int? propertyId,
    int? unitId,
    DateTime? leaseStart,
    DateTime? leaseEnd,
    double? rentAmount,
    double? deposit,
    bool? isActive,
  }) {
    return TenantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      nid: nid ?? this.nid,
      propertyId: propertyId ?? this.propertyId,
      unitId: unitId ?? this.unitId,
      leaseStart: leaseStart ?? this.leaseStart,
      leaseEnd: leaseEnd ?? this.leaseEnd,
      rentAmount: rentAmount ?? this.rentAmount,
      deposit: deposit ?? this.deposit,
      isActive: isActive ?? this.isActive,
    );
  }
}
