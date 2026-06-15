// lib/core/injection_container.dart (agregar esto)
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../constants/app_constants.dart';

import '../data/datasources/product_remote_data_source.dart';
import '../data/repositories/product_repository_impl.dart';
import '../data/repositories/address_repository_impl.dart';
import '../data/repositories/order_repository_impl.dart';
import '../domain/repositories/product_repository.dart';
import '../domain/repositories/address_repository.dart';
import '../domain/repositories/order_repository.dart';
import '../domain/usecases/get_products_usecase.dart';
import '../domain/usecases/get_addresses_usecase.dart';
import '../domain/usecases/get_shipping_options_usecase.dart';
import '../domain/usecases/create_order_usecase.dart';
import '../presentation/viewmodels/product/product_cubit.dart';
import '../presentation/viewmodels/addresses/addresses_viewmodel.dart';
import '../presentation/viewmodels/onboarding/onboarding_cubit.dart';
import '../presentation/viewmodels/registration/registration_cubit.dart';
import '../presentation/viewmodels/login/login_cubit.dart';
import '../presentation/viewmodels/password_recovery/password_recovery_cubit.dart';
import '../presentation/viewmodels/email_confirmation/email_confirmation_cubit.dart';
import '../presentation/viewmodels/auth/auth_cubit.dart';
import '../presentation/viewmodels/product_detail/product_detail_cubit.dart';
import '../presentation/viewmodels/orders/orders_cubit.dart';
import '../presentation/viewmodels/profile/profile_cubit.dart';
import '../presentation/viewmodels/payment/payment_cubit.dart';
import '../presentation/viewmodels/review/review_cubit.dart';
import '../presentation/viewmodels/cart/cart_cubit.dart';
import '../presentation/viewmodels/favorites/favorites_cubit.dart';
import '../presentation/viewmodels/addresses/addresses_cubit.dart';
import '../presentation/viewmodels/payment/payment_methods_cubit.dart';
import '../presentation/viewmodels/entrepreneur/bank_data_cubit.dart';
import '../presentation/viewmodels/entrepreneur/documents_cubit.dart';
import '../presentation/viewmodels/admin/admin_users_cubit.dart';
import '../presentation/viewmodels/admin/admin_businesses_products_cubit.dart';
import '../presentation/viewmodels/admin/reports_cubit.dart';
import '../presentation/viewmodels/notifications/notifications_cubit.dart';
import '../presentation/viewmodels/checkout/checkout_cubit.dart';
import '../presentation/viewmodels/shipping/shipping_cubit.dart';
import '../presentation/viewmodels/address_checkout/address_checkout_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences =
      await SharedPreferences.getInstance(); // Agregar esta línea
  sl.registerLazySingleton(() => sharedPreferences); // Agregar esta línea

  sl.registerLazySingleton(
    () => Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(milliseconds: AppConstants.apiTimeout),
      ),
    ),
  );

  //! Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(),
  );

  //! Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AddressRepository>(() => AddressRepositoryImpl());
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl());

  //! Use Cases
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetAddressesUseCase(sl<AddressRepository>()));
  sl.registerLazySingleton(
    () => GetShippingOptionsUseCase(sl<OrderRepository>()),
  );
  sl.registerLazySingleton(() => CreateOrderUseCase(sl<OrderRepository>()));

  //! Bloc / Cubit
  sl.registerFactory(() => ProductCubit(sl()));
  sl.registerLazySingleton(() => AddressesViewModel());
  sl.registerFactory(() => OnboardingCubit(sl())); // Agregar esta línea
  sl.registerFactory(() => RegistrationCubit());
  sl.registerFactory(() => LoginCubit());
  sl.registerFactory(() => PasswordRecoveryCubit());
  sl.registerFactory(() => PaymentCubit());
  sl.registerFactory(() => ReviewCubit());
  sl.registerFactory(() => OrdersCubit());
  sl.registerFactory(() => ProfileCubit());
  // AuthCubit should be singleton so auth state persists across app
  sl.registerLazySingleton(() => AuthCubit());
  sl.registerFactory(() => EmailConfirmationCubit());
  sl.registerFactory(() => ProductDetailCubit());
  sl.registerFactory(() => CartCubit());
  sl.registerFactory(() => FavoritesCubit());

  //! New Feature Cubits
  // Addresses Management
  sl.registerFactory(() => AddressesCubit());

  // Payment Methods
  sl.registerFactory(() => PaymentMethodsCubit());

  // Entrepreneur Features
  sl.registerFactory(() => BankDataCubit());
  sl.registerFactory(() => DocumentsCubit());

  // Admin Features
  sl.registerFactory(() => AdminUsersCubit());
  sl.registerFactory(() => AdminBusinessesCubit());
  sl.registerFactory(() => AdminProductsCubit());
  sl.registerFactory(() => ReportsCubit());

  // Notifications
  sl.registerLazySingleton(() => NotificationsCubit());

  // Checkout Flow
  sl.registerFactory(
    () => AddressCheckoutCubit(getAddressesUseCase: sl<GetAddressesUseCase>()),
  );
  sl.registerFactory(
    () => ShippingCubit(
      getShippingOptionsUseCase: sl<GetShippingOptionsUseCase>(),
    ),
  );
  sl.registerFactory(
    () => CheckoutCubit(
      getAddressesUseCase: sl<GetAddressesUseCase>(),
      getShippingOptionsUseCase: sl<GetShippingOptionsUseCase>(),
      createOrderUseCase: sl<CreateOrderUseCase>(),
    ),
  );
}
