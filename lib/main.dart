// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/injection_container.dart' as di;
import 'constants/app_colors.dart';
import 'presentation/pages/onboarding/onboarding_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/viewmodels/onboarding/onboarding_cubit.dart';
import 'presentation/viewmodels/product/product_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar dependencias
  await di.init();
  
  // Obtener shared preferences
  final preferences = await SharedPreferences.getInstance();
  
  runApp(MyApp(preferences: preferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences preferences;
  
  const MyApp({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<ProductCubit>()..loadProducts(),
        ),
        BlocProvider(
          create: (context) => OnboardingCubit(preferences),
        ),
      ],
      child: MaterialApp(
        title: 'UNIMARKET',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: _buildHomeScreen(),
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
        decoration: const BoxDecoration(
          gradient: AppColors.purpleGradient,
        ),
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
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}