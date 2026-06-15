import 'package:flutter/material.dart';

/// Helper para mostrar notificaciones tipo toast/snackbar en el centro de la pantalla
/// con soporte para tema oscuro y duración corta
class NotificationHelper {
  /// Duración predeterminada para notificaciones (1.5 segundos)
  static const Duration _defaultDuration = Duration(milliseconds: 1500);

  /// Muestra una notificación de éxito en el centro de la pantalla
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = _defaultDuration,
  }) {
    _showNotification(
      context: context,
      message: message,
      backgroundColor: Colors.green.shade600,
      icon: Icons.check_circle,
      duration: duration,
    );
  }

  /// Muestra una notificación de error en el centro de la pantalla
  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = _defaultDuration,
  }) {
    _showNotification(
      context: context,
      message: message,
      backgroundColor: Colors.red.shade600,
      icon: Icons.error_outline,
      duration: duration,
    );
  }

  /// Muestra una notificación de advertencia en el centro de la pantalla
  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = _defaultDuration,
  }) {
    _showNotification(
      context: context,
      message: message,
      backgroundColor: Colors.orange.shade600,
      icon: Icons.warning_rounded,
      duration: duration,
    );
  }

  /// Muestra una notificación informativa en el centro de la pantalla
  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = _defaultDuration,
  }) {
    _showNotification(
      context: context,
      message: message,
      backgroundColor: Colors.blue.shade600,
      icon: Icons.info_rounded,
      duration: duration,
    );
  }

  /// Notificación genérica personalizable
  static void show({
    required BuildContext context,
    required String message,
    Color backgroundColor = const Color(0xFF4B2AAD),
    IconData? icon,
    Duration duration = _defaultDuration,
  }) {
    _showNotification(
      context: context,
      message: message,
      backgroundColor: backgroundColor,
      icon: icon,
      duration: duration,
    );
  }

  /// Implementación interna que muestra la notificación centrada
  static void _showNotification({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    IconData? icon,
    required Duration duration,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        elevation: 8,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
