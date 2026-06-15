import 'package:equatable/equatable.dart';

/// Modelo de Emprendedor para la Base de Datos
class EntrepreneurModel extends Equatable {
  final String id;
  final String userId;
  final String businessName;
  final String ownerName;
  final String category;
  final String? phone;
  final String? address;
  final String? description;
  final int verificationLevel;
  final String status; // pending, approved, rejected
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EntrepreneurModel({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.ownerName,
    required this.category,
    this.phone,
    this.address,
    this.description,
    this.verificationLevel = 0,
    this.status = 'pending',
    this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EntrepreneurModel.fromJson(Map<String, dynamic> json) {
    return EntrepreneurModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      businessName: json['business_name'] ?? '',
      ownerName: json['owner_name'] ?? '',
      category: json['category'] ?? '',
      phone: json['phone'],
      address: json['address'],
      description: json['description'],
      verificationLevel: json['verification_level'] ?? 0,
      status: json['status'] ?? 'pending',
      rejectionReason: json['rejection_reason'],
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'business_name': businessName,
      'owner_name': ownerName,
      'category': category,
      'phone': phone,
      'address': address,
      'description': description,
      'verification_level': verificationLevel,
      'status': status,
      'rejection_reason': rejectionReason,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  EntrepreneurModel copyWith({
    String? id,
    String? userId,
    String? businessName,
    String? ownerName,
    String? category,
    String? phone,
    String? address,
    String? description,
    int? verificationLevel,
    String? status,
    String? rejectionReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EntrepreneurModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      businessName: businessName ?? this.businessName,
      ownerName: ownerName ?? this.ownerName,
      category: category ?? this.category,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      description: description ?? this.description,
      verificationLevel: verificationLevel ?? this.verificationLevel,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    businessName,
    ownerName,
    category,
    phone,
    address,
    description,
    verificationLevel,
    status,
    rejectionReason,
    createdAt,
    updatedAt,
  ];
}
