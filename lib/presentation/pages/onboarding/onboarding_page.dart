import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_colors.dart';
import '../../viewmodels/onboarding/onboarding_cubit.dart';
import 'package:unimarket/core/injection_container.dart';
import 'package:unimarket/presentation/pages/login/login_page.dart';
import '../../viewmodels/login/login_cubit.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.purpleGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Top: image occupying ~70%
              Expanded(
                flex: 7,
                child: Center(
                  child: Image.asset(
                    'lib/assets/images/Bienvenida.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Bottom: welcome text and button occupying ~30%
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'La comodidad que buscabas, descubre el mercado UniMarket, por y para estudiantes.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Bienvenido a UniMarket, La mejor experiencia de compra en línea.',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () async {
                            await context
                                .read<OnboardingCubit>()
                                .markOnboardingAsSeen();
                            if (!context.mounted) return;
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) => sl<LoginCubit>(),
                                  child: const LoginPage(),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'Comenzar',
                            style: TextStyle(
                              color: Color(0xFF230989),
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
