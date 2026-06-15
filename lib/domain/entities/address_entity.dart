import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String id;
  final String userId;
  final String fullName;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? apartment;
  final String? instructions;
  final bool isDefault;
  final DateTime createdAt;

  const AddressEntity({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.apartment,
    this.instructions,
    this.isDefault = false,
    required this.createdAt,
  });

  String get fullAddress =>
      '$street${apartment != null ? ", $apartment" : ""}, $city, $state $zipCode, $country';

  @override
  List<Object?> get props => [
    id,
    userId,
    fullName,
    phone,
    street,
    city,
    state,
    zipCode,
    country,
    apartment,
    instructions,
    isDefault,
    createdAt,
  ];
}
