// lib/data/models/product_model.dart
import '../../../domain/entities/product_entity.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final String category;
  final String imageUrl;
  final int stock;
  final double rating;
  final bool isFeatured;
  final String createdAt;
  
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.category,
    required this.imageUrl,
    required this.stock,
    this.rating = 0.0,
    this.isFeatured = false,
    required this.createdAt,
  });
  
  // Convertir JSON a Modelo
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountPrice: json['discountPrice']?.toDouble(),
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      stock: json['stock'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      isFeatured: json['isFeatured'] ?? false,
      createdAt: json['createdAt'] ?? '',
    );
  }
  
  // Convertir Modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discountPrice': discountPrice,
      'category': category,
      'imageUrl': imageUrl,
      'stock': stock,
      'rating': rating,
      'isFeatured': isFeatured,
      'createdAt': createdAt,
    };
  }
  
  // Convertir Modelo a Entidad
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      discountPrice: discountPrice,
      category: category,
      imageUrl: imageUrl,
      stock: stock,
      rating: rating,
      isFeatured: isFeatured,
      createdAt: DateTime.parse(createdAt),
    );
  }
  
  // Convertir Entidad a Modelo
  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      discountPrice: entity.discountPrice,
      category: entity.category,
      imageUrl: entity.imageUrl,
      stock: entity.stock,
      rating: entity.rating,
      isFeatured: entity.isFeatured,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }
}