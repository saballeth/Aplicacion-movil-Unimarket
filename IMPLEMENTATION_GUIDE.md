# Guía de Implementación - Base de Datos y Responsividad

## 📋 Resumen de Cambios

Has realizado 3 mejoras principales en UniMarket:

### 1. ✅ Mensaje de Bienvenida Personalizado
**Archivo:** `lib/presentation/pages/login/login_page.dart`

El mensaje ahora cambia según el rol del usuario:
- **Consumidor:** "¡Bienvenido a UniMarket! 🛍️ Disfruta comprando con nosotros"
- **Emprendedor:** "¡Hola emprendedor! 📈 Gestiona tu negocio con éxito"
- **Admin:** "¡Bienvenido Admin! ⚙️ Sistema listo para administrar"

**Cómo funciona:**
```dart
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
```

---

### 2. ✅ Sistema de Responsividad Global

**Archivos Creados:**
- `lib/core/utils/responsive_constants.dart` - Constantes de tamaño
- `lib/core/utils/responsive_helper.dart` - Helper con funciones responsivas
- `lib/core/utils/responsive_widgets.dart` - Widgets responsive reutilizables

**Características:**
- Breakpoints para mobile, tablet y desktop
- Cálculo dinámico de tamaños de fuente, padding y elementos
- Widgets responsive listos para usar
- Funciones para detectar tipo de dispositivo

**Uso Básico:**
```dart
import 'package:unimarket/core/utils/responsive_helper.dart';
import 'package:unimarket/core/utils/responsive_constants.dart';

// Obtener tamaño de fuente responsivo
double fontSize = ResponsiveHelper.getFontSize(
  context,
  mobileSize: ResponsiveConstants.fontLarge,
);

// Detectar tipo de dispositivo
bool isMobile = ResponsiveHelper.isMobile(context);

// Calcular padding responsivo
double padding = ResponsiveHelper.getPadding(
  context,
  mobilePadding: ResponsiveConstants.paddingMedium,
);

// Usar widgets responsivos
ResponsiveCard(
  child: Text('Contenido responsivo'),
)

ResponsiveGridView(
  children: products.map((p) => ProductCard(p)).toList(),
)

ResponsiveButton(
  label: 'Enviar',
  onPressed: () {},
  fullWidth: true,
)
```

**Breakpoints:**
```dart
- Mobile: < 768 dp
- Tablet: 768 - 1024 dp
- Desktop: >= 1440 dp
```

---

### 3. ✅ Estructura Completa de Base de Datos

#### Archivo de Documentación
**Archivo:** `DATABASE_STRUCTURE.md`

Este archivo contiene:
- Diagrama Entidad-Relación (ER) completo
- Especificación SQL de todas las tablas
- Índices recomendados
- Relaciones entre tablas
- Flujo de datos por rol

#### Modelos de Datos Creados

**`lib/data/models/user_model.dart`**
```dart
class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String roleId;
  final String? profilePicUrl;
  final bool emailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  // ... métodos fromJson, toJson, copyWith
}
```

**`lib/data/models/entrepreneur_model.dart`**
```dart
class EntrepreneurModel {
  final String id;
  final String userId;
  final String businessName;
  final String ownerName;
  final String category;
  // ... más campos
  // ... métodos fromJson, toJson, copyWith
}
```

**`lib/data/models/order_model.dart`**
```dart
class OrderModel {
  final String id;
  final String userId;
  final double totalAmount;
  final String status; // pending, confirmed, shipped, delivered, cancelled
  // ... más campos
}

class OrderItemModel {
  // Items dentro de una orden
}
```

**`lib/data/models/address_model.dart`**
```dart
class AddressModel {
  final String id;
  final String userId;
  final String? alias; // 'home', 'work'
  final String street;
  final String city;
  // ... más campos
}
```

**`lib/data/models/interaction_models.dart`**
```dart
class ReviewModel { /* Reseñas de productos */ }
class FavoriteModel { /* Favoritos */ }
class CartItemModel { /* Items del carrito */ }
```

#### Base de Datos Local
**Archivo:** `lib/core/database/database_helper.dart`

Helper para gestionar SQLite:
```dart
final db = DatabaseHelper();

// Insertar
await db.insert('products', productData);

// Consultar
final products = await db.query('products');

// Actualizar
await db.update('products', updateData, 'id = ?');

// Eliminar
await db.delete('products', 'id = ?');

// Transacción
await db.transaction((txn) async {
  // Operaciones múltiples
});
```

#### DataSources
**Archivos:**
- `lib/data/datasources/remote_data_source.dart` - API REST
- `lib/data/datasources/local_data_source.dart` - SQLite local

```dart
// Remote
final remoteDS = RemoteDataSourceImpl(dio: dio);
final product = await remoteDS.getProduct(id);

// Local
final localDS = LocalDataSourceImpl(databaseHelper: db);
await localDS.saveProduct(product);
```

---

## 📦 Dependencias Agregadas

```yaml
dependencies:
  sqflite: ^2.3.0  # Base de datos SQLite
  path: ^1.8.3     # Manejo de rutas de archivos
```

**Instalación:**
```bash
flutter pub get
```

---

## 🔧 Próximos Pasos Recomendados

### 1. Crear Repositories
```dart
// lib/data/repositories/product_repository_impl.dart
class ProductRepositoryImpl implements ProductRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<ProductModel> getProduct(String id) async {
    // Primero intenta local, luego remoto con caché
  }
}
```

### 2. Actualizar Injection Container
```dart
// lib/core/injection_container.dart
void setupDataSources() {
  sl.registerLazySingleton(
    () => DatabaseHelper(),
  );
  
  sl.registerLazySingleton(
    () => RemoteDataSourceImpl(dio: sl()),
  );
  
  sl.registerLazySingleton(
    () => LocalDataSourceImpl(databaseHelper: sl()),
  );
}
```

### 3. Migración de SharedPreferences a SQLite
```dart
class MigrationService {
  Future<void> migrateFromSharedPreferences() async {
    // 1. Leer datos de SP
    // 2. Convertir a modelos
    // 3. Guardar en SQLite
    // 4. Eliminar de SP
  }
}
```

### 4. Refactorizar Más Páginas
Aplicar ResponsiveHelper a más páginas para mejora consistente:
- RegistrationPage
- HomePage
- ProfilePage
- ProductDetailPage

---

## 📱 Testing de Responsividad

Para probar en diferentes tamaños:

```bash
# Flutter DevTools
flutter pub global activate devtools
flutter pub global run devtools

# O en VS Code: Run > Run with Arguments
flutter run -d chrome --web-renderer=html
```

Cambiar tamaño de ventana en DevTools para ver adaptación.

---

## 🗄️ Estructura Final

```
lib/
├── core/
│   ├── database/
│   │   └── database_helper.dart ✨ NUEVO
│   └── utils/
│       ├── responsive_constants.dart ✨ NUEVO
│       ├── responsive_helper.dart ✨ NUEVO
│       └── responsive_widgets.dart ✨ NUEVO
├── data/
│   ├── datasources/
│   │   ├── remote_data_source.dart ✨ NUEVO
│   │   └── local_data_source.dart ✨ NUEVO
│   └── models/
│       ├── user_model.dart ✨ NUEVO
│       ├── entrepreneur_model.dart ✨ NUEVO
│       ├── order_model.dart ✨ NUEVO
│       ├── address_model.dart ✨ NUEVO
│       └── interaction_models.dart ✨ NUEVO
└── presentation/
    └── pages/
        └── login/
            └── login_page.dart 🔄 MODIFICADO
```

---

## ✨ Mejoras Implementadas

| Aspecto | Antes | Después |
|--------|-------|---------|
| **Mensaje Login** | Genérico "¡Bienvenido!" | Personalizado por rol |
| **Responsividad** | Hardcoded sizes | Dinámico según dispositivo |
| **Mobile Support** | Potencial overflow | Adaptado a diferentes pantallas |
| **Base de Datos** | SharedPreferences | SQLite con arquitectura completa |
| **Escalabilidad** | Limitada | Estructura preparada para backend |
| **Mantenibilidad** | Código disperso | Centralizado en helpers/modelos |

---

## 🚀 Ejecución

```bash
# Actualizar dependencias
flutter pub get

# Ejecutar en dispositivo
flutter run

# Ejecutar en web (para probar responsividad)
flutter run -d chrome
```

---

## 📝 Notas Importantes

1. **SQLite vs SharedPreferences:**
   - SharedPreferences: Bueno para datos simples y pares clave-valor
   - SQLite: Mejor para estructuras complejas, consultas avanzadas

2. **Responsividad:**
   - Usar ResponsiveHelper en lugar de tamaños hardcoded
   - Testear en múltiples dispositivos

3. **Seguridad:**
   - Implementar hashing de passwords
   - Validar datos en nivel de BD
   - Usar transacciones para operaciones críticas

4. **Performance:**
   - Los índices mejoran búsquedas
   - Caché local reduce llamadas API
   - Considerar paginación para listas grandes

---

## � Modo Oscuro Mejorado (v3.0)

Se ha implementado soporte completo para tema oscuro en toda la aplicación con los siguientes cambios:

### Cambios en `lib/main.dart`

**Light Theme:**
- Fondo: Blanco puro
- AppBar: Blanco
- Texto: Negro/Gris oscuro
- Cards: Blanco

**Dark Theme:**
- Fondo: #121212 (Material Design standard)
- AppBar: #1B1B1B
- Cards: #1E1E1E
- Texto: Blanco/Gris claro
- Inputs: Fondo #2C2C2C con bordes gris oscuro

### Características

✅ **Consistencia global** - Todos los componentes respetan el tema
✅ **Transiciones suaves** - AnimatedBuilder para cambios dinámicos
✅ **Material 3** - ColorScheme moderno y escalable
✅ **Inputs mejorados** - InputDecorationTheme específico para dark mode

### Uso en Vistas

```dart
// Obtener si está en modo oscuro
final isDarkMode = Theme.of(context).brightness == Brightness.dark;

// Usar colores del tema
Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
TextStyle textStyle = Theme.of(context).textTheme.bodyMedium!;
```

---

## 📢 NotificationHelper - Notificaciones Mejoradas (v3.0)

Se ha creado `NotificationHelper` para reemplazar los SnackBars básicos con notificaciones centradas, con tema oscuro automático y duración corta.

### Archivo

```
lib/core/utils/notification_helper.dart
```

### Métodos Disponibles

```dart
// Éxito (verde con checkmark)
NotificationHelper.showSuccess(
  context: context,
  message: 'Guardado correctamente',
);

// Error (rojo con icono de error)
NotificationHelper.showError(
  context: context,
  message: 'Error al guardar',
);

// Advertencia (naranja)
NotificationHelper.showWarning(
  context: context,
  message: 'Verifica tus datos',
);

// Información (azul)
NotificationHelper.showInfo(
  context: context,
  message: 'Operación en progreso',
);

// Personalizado
NotificationHelper.show(
  context: context,
  message: 'Custom notification',
  backgroundColor: Colors.purple,
  icon: Icons.favorite,
  duration: Duration(milliseconds: 1500),
);
```

### Características

✅ **Centrado en pantalla** - Aparece en el centro inferior sin desplazar contenido
✅ **Duración corta** - 1.5s por defecto (personalizable)
✅ **Tema oscuro automático** - Se adapta al modo actual
✅ **Iconos contextuales** - Cada tipo tiene su propio icono
✅ **Diseño moderno** - Bordes redondeados y sombra
✅ **Multi-línea** - Soporta hasta 2 líneas

### Archivos Actualizados

Se han actualizado estos archivos para usar `NotificationHelper`:
- `lib/presentation/pages/login/login_page.dart` ✅
- `lib/presentation/pages/registration/registration_page.dart` ✅
- `lib/presentation/pages/password_recovery/password_recovery_page.dart` ✅
- `lib/presentation/pages/email_confirmation/email_confirmation_page.dart` ✅

### Guía Completa

Ver: `lib/core/utils/NOTIFICATION_HELPER_USAGE.md`

---

## �🆘 Troubleshooting

**Error: "Cannot find sqflite"**
```bash
flutter pub get
flutter clean
flutter pub get
```

**Base de datos no se crea:**
- Verificar permisos de escritura
- Usar `getDatabasesPath()` correctamente
- Revisar versión de sqflite

**Responsividad no funciona:**
- Asegurarse de importar ResponsiveHelper
- Usar `context` valido en BuildContext
- Probar en different screen sizes

**Tema oscuro no se aplica:**
- Verificar que `themeMode` en MaterialApp sea válido
- Asegurarse de que AppPreferencesController cargó correctamente
- Revisar que darkTheme está definido en MaterialApp

**NotificationHelper no aparece:**
- Verificar que el Scaffold padre está presente
- Asegurar que `context` es válido
- Revisar que ScaffoldMessenger no está siendo bloqueado

**Notificaciones no tienen tema oscuro:**
- NotificationHelper se adapta automáticamente
- Si no funciona, verificar Theme.of(context) en MaterialApp
- Asegurar que darkTheme está correctamente configurado

---

¡Los cambios están listos para usar! Continúa desarrollando según la arquitectura Clean Architecture + MVVM establecida. 🎉
