import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../viewmodels/registration/registration_cubit.dart';
import '../../viewmodels/registration/registration_state.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _acceptTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: BlocConsumer<RegistrationCubit, RegistrationState>(
            listener: (context, state) {
              if (state is RegistrationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
              if (state is RegistrationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Registro exitoso')),
                );
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              final isLoading = state is RegistrationLoading;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(height: 20),
                  const Text('Regístrate', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Crea una cuenta para comenzar', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 40),

                  const Text('Nombre Completo', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
                  const SizedBox(height: 8),
                  _buildInput(_nameController, 'Nombre y Apellidos'),
                  const SizedBox(height: 24),

                  const Text('Correo Institucional', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
                  const SizedBox(height: 8),
                  _buildInput(_emailController, 'name@unimagdalena.edu.co', keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 24),

                  const Text('Contraseña', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
                  const SizedBox(height: 8),
                  _buildPasswordInput(_passwordController, _obscurePassword, () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  }),
                  const SizedBox(height: 12),
                  _buildPasswordInput(_confirmPasswordController, _obscureConfirmPassword, () {
                    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                  }, hint: 'Confirma tu contraseña'),
                  const SizedBox(height: 24),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _acceptTerms,
                          onChanged: (value) => setState(() => _acceptTerms = value ?? false),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          activeColor: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
                            children: [
                              TextSpan(text: 'Aceptas los '),
                              TextSpan(text: 'Términos y Condiciones', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500)),
                              TextSpan(text: ' y la '),
                              TextSpan(text: 'Política de Privacidad', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500)),
                              TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _acceptTerms && !isLoading ? () {
                        context.read<RegistrationCubit>().register(
                              _nameController.text,
                              _emailController.text,
                              _passwordController.text,
                            );
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Regístrate', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(child: GestureDetector(onTap: () {}, child: const Text('¿Ya tienes una cuenta? Inicia sesión', style: TextStyle(color: Colors.blue)))),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String hint, {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.grey), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget _buildPasswordInput(TextEditingController controller, bool obscure, VoidCallback toggle, {String hint = 'Ingresa tu contraseña'}) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: IconButton(onPressed: toggle, icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey)),
        ),
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
