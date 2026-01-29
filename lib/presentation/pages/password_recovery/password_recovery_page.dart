import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/presentation/pages/email_confirmation/email_confirmation_page.dart';

import '../../viewmodels/password_recovery/password_recovery_cubit.dart';
import '../../viewmodels/password_recovery/password_recovery_state.dart';

class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({super.key});

  @override
  State<PasswordRecoveryPage> createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 40),
              Text(
                '¿Has olvidado tu contraseña?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '¡No te preocupes! Suele ocurrir. Por favor ingresa la dirección de correo electrónico vinculada con su cuenta.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_reset_outlined,
                    size: 60,
                    color: Colors.blue[800],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Estado manejado por el Cubit
              BlocConsumer<PasswordRecoveryCubit, PasswordRecoveryState>(
                listener: (context, state) {
                  if (state is PasswordRecoveryFailure) {
                    _showSnackBar(state.message);
                  }
                  if (state is PasswordRecoverySuccess) {
                    _showSnackBar('Correo de recuperación enviado exitosamente');
                    if (!context.mounted) return;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => EmailConfirmationPage(email: state.email),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state is PasswordRecoveryLoading;
                  final emailSent = state is PasswordRecoverySuccess;
                  final sentEmail = state is PasswordRecoverySuccess
                      ? state.email
                      : '';

                  if (emailSent) {
                    return _buildSuccessMessage(sentEmail);
                  }

                  return _buildRecoveryForm(context, isLoading);
                },
              ),

              const SizedBox(height: 30),

              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'Volver al inicio de sesión',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecoveryForm(BuildContext context, bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingresa tu correo electrónico',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'ejemplo@unimagdalena.edu.co',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu correo electrónico';
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Por favor ingresa un correo válido';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        context.read<PasswordRecoveryCubit>().recoverPassword(
                          _emailController.text.trim(),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                shadowColor: Colors.blue.withAlpha((0.3 * 255).round()),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Recuperar contraseña',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage(String email) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.green[50],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_outline,
            size: 50,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '¡Correo enviado!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Hemos enviado un enlace de recuperación a:',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          email,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.blue[800],
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Por favor revisa tu bandeja de entrada y sigue las instrucciones para restablecer tu contraseña.',
          style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.5),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Volver al formulario
                  context.read<PasswordRecoveryCubit>().reset();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
                child: Text(
                  'Usar otro correo',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _showSnackBar('Correo reenviado exitosamente');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Reenviar',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
