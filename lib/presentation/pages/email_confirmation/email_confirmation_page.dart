import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../viewmodels/email_confirmation/email_confirmation_cubit.dart';
import '../../viewmodels/email_confirmation/email_confirmation_state.dart';
import 'package:unimarket/core/injection_container.dart';
import 'package:unimarket/presentation/pages/login/login_page.dart';
import '../../viewmodels/login/login_cubit.dart';

class EmailConfirmationPage extends StatelessWidget {
  final String email;
  const EmailConfirmationPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(32),
          child: BlocProvider(
            create: (_) => sl<EmailConfirmationCubit>(),
            child: BlocConsumer<EmailConfirmationCubit, EmailConfirmationState>(
              listener: (context, state) {
                if (state is EmailConfirmationResent) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
                if (state is EmailConfirmationFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is EmailConfirmationLoading;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mark_email_read_outlined,
                        size: 60,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      '¡Correo enviado!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Vez a tu correo electronico para cambiar tu contraseña.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navegar a login
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
                          backgroundColor: Colors.blue.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Iniciar sesión',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () => context
                              .read<EmailConfirmationCubit>()
                              .resendEmail(email),
                      child: Text(
                        isLoading
                            ? 'Reenviando...'
                            : '¿No recibiste el correo? Reenviar',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
