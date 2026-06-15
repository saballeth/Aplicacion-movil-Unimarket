import 'package:flutter/material.dart';
import 'responsive_constants.dart';

/// Helper para gestionar responsividad en toda la aplicación
/// Proporciona métodos para calcular tamaños basados en el ancho de pantalla
class ResponsiveHelper {
  /// Obtiene el ancho de la pantalla
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Obtiene la altura de la pantalla
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Determina el tipo de dispositivo basado en el ancho de pantalla
  static String getDeviceType(BuildContext context) {
    final width = getScreenWidth(context);

    if (width >= ResponsiveConstants.desktop) {
      return ResponsiveConstants.deviceDesktop;
    } else if (width >= ResponsiveConstants.tablet) {
      return ResponsiveConstants.deviceTablet;
    } else {
      return ResponsiveConstants.deviceMobile;
    }
  }

  /// Verifica si es dispositivo móvil
  static bool isMobile(BuildContext context) {
    return getScreenWidth(context) < ResponsiveConstants.tablet;
  }

  /// Verifica si es tablet
  static bool isTablet(BuildContext context) {
    final width = getScreenWidth(context);
    return width >= ResponsiveConstants.tablet && width < ResponsiveConstants.desktop;
  }

  /// Verifica si es desktop
  static bool isDesktop(BuildContext context) {
    return getScreenWidth(context) >= ResponsiveConstants.desktop;
  }

  /// Calcula tamaño de fuente responsivo
  static double getFontSize(BuildContext context, {
    required double mobileSize,
    double? tabletSize,
    double? desktopSize,
  }) {
    final deviceType = getDeviceType(context);

    if (deviceType == ResponsiveConstants.deviceDesktop) {
      return desktopSize ?? mobileSize * 1.2;
    } else if (deviceType == ResponsiveConstants.deviceTablet) {
      return tabletSize ?? mobileSize * 1.1;
    } else {
      return mobileSize;
    }
  }

  /// Calcula padding responsivo
  static double getPadding(BuildContext context, {
    required double mobilePadding,
    double? tabletPadding,
    double? desktopPadding,
  }) {
    final deviceType = getDeviceType(context);

    if (deviceType == ResponsiveConstants.deviceDesktop) {
      return desktopPadding ?? mobilePadding * 1.5;
    } else if (deviceType == ResponsiveConstants.deviceTablet) {
      return tabletPadding ?? mobilePadding * 1.25;
    } else {
      return mobilePadding;
    }
  }

  /// Calcula ancho de elemento responsivo
  static double getResponsiveWidth(BuildContext context, {
    required double mobileWidth,
    double? tabletWidth,
    double? desktopWidth,
  }) {
    final screenWidth = getScreenWidth(context);
    final deviceType = getDeviceType(context);

    if (deviceType == ResponsiveConstants.deviceDesktop) {
      return desktopWidth ?? mobileWidth * 1.5;
    } else if (deviceType == ResponsiveConstants.deviceTablet) {
      return tabletWidth ?? mobileWidth * 1.2;
    } else {
      return mobileWidth.clamp(0, screenWidth - 32);
    }
  }

  /// Calcula altura de elemento responsivo
  static double getResponsiveHeight(BuildContext context, {
    required double mobileHeight,
    double? tabletHeight,
    double? desktopHeight,
  }) {
    final deviceType = getDeviceType(context);

    if (deviceType == ResponsiveConstants.deviceDesktop) {
      return desktopHeight ?? mobileHeight * 1.5;
    } else if (deviceType == ResponsiveConstants.deviceTablet) {
      return tabletHeight ?? mobileHeight * 1.2;
    } else {
      return mobileHeight;
    }
  }

  /// Número de columnas para grid responsivo
  static int getGridColumns(BuildContext context) {
    final deviceType = getDeviceType(context);

    if (deviceType == ResponsiveConstants.deviceDesktop) {
      return 4;
    } else if (deviceType == ResponsiveConstants.deviceTablet) {
      return 3;
    } else {
      return 2;
    }
  }

  /// Obtiene margen horizontal responsivo
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    final padding = getPadding(context, mobilePadding: ResponsiveConstants.paddingLarge);
    return EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2);
  }

  /// Obtiene padding horizontal responsivo
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final padding = getPadding(context, mobilePadding: ResponsiveConstants.paddingLarge);
    return EdgeInsets.symmetric(horizontal: padding, vertical: padding);
  }

  /// Altura de botón responsiva
  static double getButtonHeight(BuildContext context) {
    final deviceType = getDeviceType(context);

    if (deviceType == ResponsiveConstants.deviceDesktop) {
      return ResponsiveConstants.buttonHeightLarge;
    } else if (deviceType == ResponsiveConstants.deviceTablet) {
      return ResponsiveConstants.buttonHeightMedium;
    } else {
      return ResponsiveConstants.buttonHeightMedium;
    }
  }

  /// Obtiene tamaño de icono responsivo
  static double getIconSize(BuildContext context, {
    required double mobileSize,
    double? tabletSize,
    double? desktopSize,
  }) {
    return getFontSize(
      context,
      mobileSize: mobileSize,
      tabletSize: tabletSize,
      desktopSize: desktopSize,
    );
  }

  /// Calcula aspectRatio para elementos responsivos
  static double getAspectRatio(BuildContext context, {
    required double defaultAspectRatio,
  }) {
    final width = getScreenWidth(context);
    
    // Ajusta el aspect ratio basado en el tamaño de pantalla
    if (width < ResponsiveConstants.mobileLarge) {
      return defaultAspectRatio * 0.9;
    } else if (width >= ResponsiveConstants.tablet) {
      return defaultAspectRatio * 1.1;
    }
    
    return defaultAspectRatio;
  }

  /// Ancho máximo de contenido basado en dispositivo
  static double getMaxContentWidth(BuildContext context) {
    final deviceType = getDeviceType(context);
    final screenWidth = getScreenWidth(context);

    if (deviceType == ResponsiveConstants.deviceDesktop) {
      return ResponsiveConstants.maxContentWidthDesktop;
    } else if (deviceType == ResponsiveConstants.deviceTablet) {
      return ResponsiveConstants.maxContentWidthTablet;
    } else {
      return screenWidth - 32;
    }
  }
}
