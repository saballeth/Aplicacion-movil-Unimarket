// lib/core/constants/app_constants.dart
class AppConstants {
  static const String appName = 'UNIMARKET';
  static const String apiBaseUrl = 'https://api.unimarket.com';
  static const int apiTimeout = 30000; // 30 segundos
  
  // Rutas
  static const String homeRoute = '/';
  static const String productDetailRoute = '/product/:id';
  static const String cartRoute = '/cart';
  static const String profileRoute = '/profile';
  
  // Preferencias
  static const String prefToken = 'auth_token';
  static const String prefUser = 'user_data';
}