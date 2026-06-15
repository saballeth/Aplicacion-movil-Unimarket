// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/injection_container.dart' as di;
import 'constants/app_colors.dart';
import 'presentation/pages/onboarding/onboarding_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/viewmodels/profile/app_preferences_controller.dart';
import 'presentation/viewmodels/profile/order_preferences_controller.dart';
import 'presentation/viewmodels/profile/privacy_security_controller.dart';
import 'presentation/viewmodels/onboarding/onboarding_cubit.dart';
import 'presentation/viewmodels/product/product_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar dependencias
  await di.init();

  // Obtener shared preferences
  final preferences = await SharedPreferences.getInstance();
  final appPreferences = AppPreferencesController(preferences);
  await appPreferences.load();
  di.sl.registerSingleton<AppPreferencesController>(appPreferences);
  final orderPreferences = OrderPreferencesController(preferences);
  await orderPreferences.load();
  di.sl.registerSingleton<OrderPreferencesController>(orderPreferences);
  final privacySecurity = PrivacySecurityController(preferences);
  await privacySecurity.load();
  di.sl.registerSingleton<PrivacySecurityController>(privacySecurity);

  runApp(
    MyApp(
      preferences: preferences,
      appPreferences: appPreferences,
      orderPreferences: orderPreferences,
      privacySecurity: privacySecurity,
    ),
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences preferences;
  final AppPreferencesController appPreferences;
  final OrderPreferencesController orderPreferences;
  final PrivacySecurityController privacySecurity;

  const MyApp({
    super.key,
    required this.preferences,
    required this.appPreferences,
    required this.orderPreferences,
    required this.privacySecurity,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<ProductCubit>()..loadProducts(),
        ),
        BlocProvider(create: (context) => OnboardingCubit(preferences)),
      ],
      child: AnimatedBuilder(
        animation: Listenable.merge([orderPreferences, privacySecurity]),
        builder: (context, _) {
          return MaterialApp(
            title: 'UNIMARKET',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              scaffoldBackgroundColor: Colors.white,
              cardColor: Colors.white,
              dialogBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                elevation: 0,
                centerTitle: true,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                surfaceTintColor: Colors.white,
              ),
              snackBarTheme: SnackBarThemeData(
                backgroundColor: Colors.grey.shade800,
                contentTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.black87),
                bodyMedium: TextStyle(color: Colors.black87),
                bodySmall: TextStyle(color: Colors.black54),
              ),
            ),
            locale: appPreferences.locale,
            supportedLocales: const [Locale('es'), Locale('en'), Locale('pt')],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            home: _buildHomeScreen(),
          );
        },
      ),
    );
  }

  Widget _buildHomeScreen() {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingLoading) {
          return const SplashScreen();
        }

        if (state is OnboardingComplete) {
          if (!state.hasSeenOnboarding) {
            return const OnboardingPage();
          } else {
            return const HomePage();
          }
        }

        return const SplashScreen();
      },
    );
  }
}

// Pantalla de carga inicial
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.purpleGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo
              Image.asset(
                'lib/assets/images/LOGO_UNIMARKET.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 20),
              Text(
                'UNIMARKET',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
