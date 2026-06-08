class PropertyModel {
  final int? id;
  final String name;
  final String address;
  final int floors;
  final double totalSize; // sq ft
  final int yearBuilt;
  final String? imageUrl;

  PropertyModel({
    this.id,
    required this.name,
    required this.address,
    required this.floors,
    required this.totalSize,
    required this.yearBuilt,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'address': address,
      'floors': floors,
      'totalSize': totalSize,
      'yearBuilt': yearBuilt,
      'imageUrl': imageUrl,
    };
  }

  factory PropertyModel.fromMap(Map<String, dynamic> map) {
    return PropertyModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      address: map['address'] as String,
      floors: map['floors'] as int,
      totalSize: (map['totalSize'] as num).toDouble(),
      yearBuilt: map['yearBuilt'] as int,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  PropertyModel copyWith({
    int? id,
    String? name,
    String? address,
    int? floors,
    double? totalSize,
    int? yearBuilt,
    String? imageUrl,
  }) {
    return PropertyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      floors: floors ?? this.floors,
      totalSize: totalSize ?? this.totalSize,
      yearBuilt: yearBuilt ?? this.yearBuilt,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
