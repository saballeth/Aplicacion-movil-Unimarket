import 'package:equatable/equatable.dart';

class ShippingOptionEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double cost;
  final int estimatedDays;
  final bool isAvailable;

  const ShippingOptionEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.estimatedDays,
    this.isAvailable = true,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    cost,
    estimatedDays,
    isAvailable,
  ];
}
