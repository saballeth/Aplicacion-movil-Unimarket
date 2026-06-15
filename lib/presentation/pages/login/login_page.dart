import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../viewmodels/login/login_cubit.dart';
import '../../viewmodels/login/login_state.dart';
import '../../viewmodels/password_recovery/password_recovery_cubit.dart';
import '../../viewmodels/auth/auth_cubit.dart';
import '../../viewmodels/product/product_cubit.dart';
import '../home_page.dart';
import 'package:unimarket/core/injection_container.dart';
import '../../viewmodels/registration/registration_cubit.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/responsive_constants.dart';
import 'package:unimarket/presentation/pages/registration/registration_page.dart';
import 'package:unimarket/presentation/pages/password_recovery/password_recovery_page.dart';
import 'package:unimarket/core/utils/notification_helper.dart';

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
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) async {
              if (state is LoginFailure) {
                NotificationHelper.showError(
                  context: context,
                  message: state.message,
                );
              }
              if (state is LoginSuccess) {
                // Attempt to authenticate via AuthCubit (mocked test credentials)
                await sl<AuthCubit>().login(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                );
                if (!context.mounted) return;
                if (sl<AuthCubit>().isAuthenticated()) {
                  final user = sl<AuthCubit>().currentUser;
                  final welcomeMessage = _getWelcomeMessage(user?.role.toString() ?? '');
                  
                  NotificationHelper.showSuccess(
                    context: context,
                    message: welcomeMessage,
                    duration: const Duration(seconds: 2),
                  );
                  
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => sl<ProductCubit>(),
                        child: const HomePage(),
                      ),
                    ),
                  );
                } else {
                  NotificationHelper.showError(
                    context: context,
                    message: 'Credenciales inválidas. Usa 1234 / 1234',
                  );
                }
              }
            },
            builder: (context, state) {
              final isLoading = state is LoginLoading;
              final screenHeight = ResponsiveHelper.getScreenHeight(context);
              final isMobile = ResponsiveHelper.isMobile(context);
              final titleFontSize = ResponsiveHelper.getFontSize(
                context,
                mobileSize: ResponsiveConstants.font2XLarge,
              );
              final labelFontSize = ResponsiveHelper.getFontSize(
                context,
                mobileSize: ResponsiveConstants.fontMedium,
              );
              
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: screenHeight - 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: ResponsiveHelper.getPadding(
                          context,
                          mobilePadding: ResponsiveConstants.paddingLarge,
                        ),
                      ),
                      Text(
                        '¡Bienvenido!',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getPadding(
                          context,
                          mobilePadding: ResponsiveConstants.padding2XLarge,
                        ),
                      ),

                      // Input fields container con ancho limitado
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: ResponsiveHelper.getMaxContentWidth(context),
                        ),
                        child: Column(
                          children: [
                            _buildInputField(
                              label: 'Usuario',
                              hintText: '1234',
                              controller: _emailController,
                              keyboardType: TextInputType.text,
                              prefixIcon: Icons.person_outline,
                            ),
                            SizedBox(
                              height: ResponsiveHelper.getPadding(
                                context,
                                mobilePadding: ResponsiveConstants.paddingLarge,
                              ),
                            ),
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
                            SizedBox(
                              height: ResponsiveHelper.getPadding(
                                context,
                                mobilePadding: ResponsiveConstants.paddingMedium,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _navigateToPasswordRecovery,
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(88, 44),
                                ),
                                child: Text(
                                  '¿Olvidaste tu contraseña?',
                                  style: TextStyle(
                                    fontSize: labelFontSize,
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ResponsiveHelper.getPadding(
                                context,
                                mobilePadding: ResponsiveConstants.padding2XLarge,
                              ),
                            ),
                            // Credenciales de prueba
                            if (isMobile)
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: ResponsiveHelper.getPadding(
                                    context,
                                    mobilePadding: ResponsiveConstants.paddingMedium,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Credenciales de prueba:',
                                      style: TextStyle(
                                        fontSize: labelFontSize * 0.85,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: ResponsiveHelper.getPadding(
                                        context,
                                        mobilePadding: ResponsiveConstants.paddingSmall,
                                      ),
                                    ),
                                    Text(
                                      'Consumidor: 1234 / 1234\nEmprendedor: emp / emp\nAdmin: admin / admin',
                                      style: TextStyle(
                                        fontSize: labelFontSize * 0.8,
                                        color: Colors.grey[600],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),

                            // Login button
                            SizedBox(
                              width: double.infinity,
                              height: ResponsiveHelper.getButtonHeight(context),
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveConstants.radiusLarge,
                                    ),
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
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        'Iniciar Sesión',
                                        style: TextStyle(
                                          fontSize: labelFontSize,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(
                              height: ResponsiveHelper.getPadding(
                                context,
                                mobilePadding: ResponsiveConstants.padding2XLarge,
                              ),
                            ),
                            // Divider con texto
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey[300],
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveHelper.getPadding(
                                      context,
                                      mobilePadding: ResponsiveConstants.paddingMedium,
                                    ),
                                  ),
                                  child: Text(
                                    'O',
                                    style: TextStyle(
                                      fontSize: labelFontSize,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey[300],
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: ResponsiveHelper.getPadding(
                                context,
                                mobilePadding: ResponsiveConstants.padding2XLarge,
                              ),
                            ),
                            // Signup link
                            Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                Text(
                                  '¿No tienes cuenta? ',
                                  style: TextStyle(
                                    fontSize: labelFontSize,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _navigateToRegistration,
                                  child: Text(
                                    'Regístrate',
                                    style: TextStyle(
                                      fontSize: labelFontSize,
                                      color: Colors.blue[700],
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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



  String _getWelcomeMessage(String roleString) {
    if (roleString.contains('consumer')) {
      return '¡Bienvenido a UniMarket! 🛍️ Disfruta comprando con nosotros';
    } else if (roleString.contains('entrepreneur')) {
      return '¡Hola emprendedor! 📈 Gestiona tu negocio con éxito';
    } else if (roleString.contains('admin')) {
      return '¡Bienvenido Admin! ⚙️ Sistema listo para administrar';
    }
    return '¡Bienvenido a UniMarket!';
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
