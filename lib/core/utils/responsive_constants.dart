/// Constantes de responsividad para UniMarket
/// Define los breakpoints y espaciados para diferentes tamaños de pantalla

class ResponsiveConstants {
  // Breakpoints de pantalla (ancho en dp)
  static const double mobileSmall = 320; // Celulares pequeños
  static const double mobileMedium = 480; // Celulares medianos
  static const double mobileLarge = 600; // Celulares grandes (phablets)
  static const double tablet = 768; // Tablets
  static const double tabletLarge = 1024; // Tablets grandes
  static const double desktop = 1440; // Escritorio

  // Categorías de dispositivo
  static const String deviceMobile = 'mobile';
  static const String deviceTablet = 'tablet';
  static const String deviceDesktop = 'desktop';

  // Padding y márgenes responsivos
  static const double paddingXSmall = 4;
  static const double paddingSmall = 8;
  static const double paddingMedium = 12;
  static const double paddingLarge = 16;
  static const double paddingXLarge = 24;
  static const double padding2XLarge = 32;

  // Tamaños de fuente responsivos (en dp)
  static const double fontXSmall = 10;
  static const double fontSmall = 12;
  static const double fontMedium = 14;
  static const double fontLarge = 16;
  static const double fontXLarge = 18;
  static const double font2XLarge = 24;
  static const double font3XLarge = 32;
  static const double font4XLarge = 48;

  // Altura de elementos
  static const double buttonHeightSmall = 36;
  static const double buttonHeightMedium = 44;
  static const double buttonHeightLarge = 56;
  static const double appBarHeight = 56;

  // Radio de bordes
  static const double radiusSmall = 4;
  static const double radiusMedium = 8;
  static const double radiusLarge = 12;
  static const double radiusXLarge = 16;

  // Ancho máximo de contenido
  static const double maxContentWidthMobile = 600;
  static const double maxContentWidthTablet = 900;
  static const double maxContentWidthDesktop = 1200;
}
