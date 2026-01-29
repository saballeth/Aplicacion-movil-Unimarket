// lib/core/injection_container.dart (agregar esto)
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../constants/app_constants.dart';

import '../data/datasources/product_remote_data_source.dart';
import '../data/repositories/product_repository_impl.dart';
import '../domain/repositories/product_repository.dart';
import '../domain/usecases/get_products_usecase.dart';
import '../presentation/viewmodels/product/product_cubit.dart';
import '../presentation/viewmodels/onboarding/onboarding_cubit.dart';
import '../presentation/viewmodels/registration/registration_cubit.dart';
import '../presentation/viewmodels/login/login_cubit.dart';
import '../presentation/viewmodels/password_recovery/password_recovery_cubit.dart';
import '../presentation/viewmodels/email_confirmation/email_confirmation_cubit.dart';
import '../presentation/viewmodels/auth/auth_cubit.dart';
import '../presentation/viewmodels/product_detail/product_detail_cubit.dart';
import '../presentation/viewmodels/orders/orders_cubit.dart';
import '../presentation/viewmodels/profile/profile_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();  // Agregar esta línea
  sl.registerLazySingleton(() => sharedPreferences);  // Agregar esta línea
  
  sl.registerLazySingleton(() => Dio(BaseOptions(
    baseUrl: AppConstants.apiBaseUrl,
    connectTimeout: const Duration(milliseconds: AppConstants.apiTimeout),
  )));
  
  //! Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(),
  );
  
  //! Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );
  
  //! Use Cases
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  
  //! Bloc / Cubit
  sl.registerFactory(() => ProductCubit(sl()));
  sl.registerFactory(() => OnboardingCubit(sl()));  // Agregar esta línea
  sl.registerFactory(() => RegistrationCubit());
  sl.registerFactory(() => LoginCubit());
  sl.registerFactory(() => PasswordRecoveryCubit());
  sl.registerFactory(() => OrdersCubit());
  sl.registerFactory(() => ProfileCubit());
  // AuthCubit should be singleton so auth state persists across app
  sl.registerLazySingleton(() => AuthCubit());
  sl.registerFactory(() => EmailConfirmationCubit());
  sl.registerFactory(() => ProductDetailCubit());
}