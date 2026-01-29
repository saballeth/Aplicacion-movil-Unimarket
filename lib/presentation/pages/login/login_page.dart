import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../viewmodels/login/login_cubit.dart';
import '../../viewmodels/login/login_state.dart';
import '../../viewmodels/password_recovery/password_recovery_cubit.dart';
import '../../viewmodels/auth/auth_cubit.dart';
import '../../viewmodels/product/product_cubit.dart';
import '../home_page.dart';
import 'package:unimarket/core/injection_container.dart';
import 'package:unimarket/presentation/pages/password_recovery/password_recovery_page.dart';
import '../../viewmodels/registration/registration_cubit.dart';
import 'package:unimarket/presentation/pages/registration/registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) async {
              if (state is LoginFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
              if (state is LoginSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Inicio de sesión exitoso')),
                );
                // Attempt to authenticate via AuthCubit (mocked test credentials)
                await sl<AuthCubit>().login(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                );
                if (!context.mounted) return;
                if (sl<AuthCubit>().isAuthenticated()) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => sl<ProductCubit>(),
                        child: const HomePage(),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Credenciales inválidas. Usa probar@unimarket.test / password123',
                      ),
                    ),
                  );
                }
              }
            },
            builder: (context, state) {
              final isLoading = state is LoginLoading;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Bienvenido!',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  const SizedBox(height: 60),

                  _buildInputField(
                    label: 'Correo Institucional',
                    hintText: 'ejemplo@unimagdalena.edu.co',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 24),
                  _buildInputField(
                    label: 'Contraseña',
                    hintText: 'Ingresa tu contraseña',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _navigateToPasswordRecovery,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Olvidaste tu contraseña?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Credenciales de prueba para acceso rápido
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      'Credenciales de prueba: probar@unimarket.test / password123',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () => context.read<LoginCubit>().login(
                              _emailController.text,
                              _passwordController.text,
                            ),
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
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Iniciar Sesión',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: Colors.grey[300], thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'O',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Colors.grey[300], thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _buildSocialLoginButtons(),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tienes cuenta?',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: _navigateToRegistration,
                        child: Text(
                          'Registrarte',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: Colors.grey[600], size: 20)
                  : null,
              suffixIcon: suffixIcon,
            ),
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _loginWithGoogle,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.grey[300]!, width: 1),
              backgroundColor: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/google_icon.png',
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.g_translate,
                    color: Colors.grey[700],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Continuar con Google',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _loginWithApple,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.grey[300]!, width: 1),
              backgroundColor: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.apple, color: Colors.grey, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Continuar con Apple',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // removed unused _loginUser; login uses LoginCubit directly

  void _navigateToPasswordRecovery() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<PasswordRecoveryCubit>(),
          child: const PasswordRecoveryPage(),
        ),
      ),
    );
  }

  void _navigateToRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<RegistrationCubit>(),
          child: const RegistrationPage(),
        ),
      ),
    );
  }

  void _loginWithGoogle() {
    _showSnackBar('Iniciando sesión con Google...');
  }

  void _loginWithApple() {
    _showSnackBar('Iniciando sesión con Apple...');
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
    _passwordController.dispose();
    super.dispose();
  }
}
