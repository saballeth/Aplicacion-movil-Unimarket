import 'package:flutter/material.dart';

class OrderModel {
  final String id;
  final String storeName;
  final String status;
  final String date;
  final Color statusColor;
  final IconData icon;

  OrderModel({
    required this.id,
    required this.storeName,
    required this.status,
    required this.date,
    required this.statusColor,
    required this.icon,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) => OrderModel(
        id: map['id'] as String,
        storeName: map['storeName'] as String,
        status: map['status'] as String,
        date: map['date'] as String,
        statusColor: map['statusColor'] as Color,
        icon: map['icon'] as IconData,
      );
}
