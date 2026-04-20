import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/presentation/viewmodels/password_recovery/password_recovery_cubit.dart';
import 'package:unimarket/presentation/viewmodels/password_recovery/password_recovery_state.dart';
import 'package:unimarket/core/injection_container.dart';

class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({Key? key}) : super(key: key);

  @override
  State<PasswordRecoveryPage> createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PasswordRecoveryCubit>(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Recuperar Contrase�a'),
          backgroundColor: const Color(0xFF4B2AAD),
        ),
        body: BlocConsumer<PasswordRecoveryCubit, PasswordRecoveryState>(
          listener: (context, state) {
            if (state is PasswordRecoverySuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Contrase�a restablecida para ${state.email}')),
              );
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pop(context);
              });
            } else if (state is PasswordRecoveryFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state is PasswordRecoveryInitial)
                      _buildEmailStep(context)
                    else if (state is PasswordRecoveryCodeSent)
                      _buildCodeStep(context, state)
                    else if (state is PasswordRecoveryCodeVerified)
                      _buildPasswordStep(context)
                    else if (state is PasswordRecoveryLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmailStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('Ingresa tu correo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Te enviaremos un c�digo', style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 24),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Correo',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.read<PasswordRecoveryCubit>().recoverPassword(_emailController.text),
            child: const Text('Enviar'),
          ),
        ),
      ],
    );
  }

  Widget _buildCodeStep(BuildContext context, PasswordRecoveryCodeSent state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('C�digo de verificaci�n', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('Enviamos un c�digo a ${state.email}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 24),
        TextField(
          controller: _codeController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: InputDecoration(
            labelText: 'C�digo',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.read<PasswordRecoveryCubit>().verifyCode(_codeController.text),
            child: const Text('Verificar'),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('Nueva contrase�a', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Contrase�a',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Confirmar',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.read<PasswordRecoveryCubit>().resetPassword(_passwordController.text, _confirmPasswordController.text),
            child: const Text('Restablecer'),
          ),
        ),
      ],
    );
  }
}
