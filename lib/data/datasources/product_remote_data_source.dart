// lib/data/datasources/product_remote_data_source.dart
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  @override
  Future<List<ProductModel>> getProducts() async {
    // Simulación de API
    await Future.delayed(const Duration(seconds: 2));
    
    return [
      ProductModel(
        id: '1',
        name: 'iPhone 15 Pro',
        description: 'El mejor smartphone de Apple con cámara profesional',
        price: 1299.99,
        discountPrice: 1199.99,
        category: 'Electrónica',
        imageUrl: 'https://example.com/iphone.jpg',
        stock: 25,
        rating: 4.8,
        isFeatured: true,
        createdAt: '2024-01-01T10:00:00Z',
      ),
      ProductModel(
        id: '2',
        name: 'Samsung Galaxy S24',
        description: 'Teléfono Android con IA integrada',
        price: 999.99,
        category: 'Electrónica',
        imageUrl: 'https://example.com/galaxy.jpg',
        stock: 50,
        rating: 4.6,
        isFeatured: true,
        createdAt: '2024-01-02T10:00:00Z',
      ),
      // Agrega más productos...
    ];
  }
  
  @override
  Future<ProductModel> getProductById(String id) async {
    final products = await getProducts();
    return products.firstWhere((product) => product.id == id);
  }
}