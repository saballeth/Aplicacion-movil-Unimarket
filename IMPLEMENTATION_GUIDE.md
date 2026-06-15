# Guía de Implementación - Base de Datos y Responsividad

## Resumen de cambios

### 1. Mensaje de bienvenida
**Archivo:** `lib/presentation/pages/login/login_page.dart`

El mensaje ahora cambia según el rol del usuario:
- **Consumidor:** "¡Bienvenido a UniMarket! 🛍️ Disfruta comprando con nosotros"
- **Emprendedor:** "¡Hola emprendedor! 📈 Gestiona tu negocio con éxito"
- **Admin:** "¡Bienvenido Admin! ⚙️ Sistema listo para administrar"

**¿Cómo funciona?**
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

### 2. Sistema responsividad

**Archivos creados:**
- `lib/core/utils/responsive_constants.dart` - Constantes de tamaño
- `lib/core/utils/responsive_helper.dart` - Helper con funciones responsivas
- `lib/core/utils/responsive_widgets.dart` - Widgets responsive reutilizables

**Características:**
- Breakpoints para mobile y tablet
- Cálculo dinámico de tamaños de fuente, padding y elementos
- Widgets responsive listos para usar
- Funciones para detectar tipo de dispositivo

**Uso básico:**
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

### 3. Estructura de la base de datos

#### Archivo de Documentación
**Archivo:** `DATABASE_STRUCTURE.md`

Este archivo contiene:
- Diagrama Entidad-Relación (ER) completo
- Especificación SQL de todas las tablas
- Índices recomendados
- Relaciones entre tablas
- Flujo de datos por rol

#### Modelos de datos creados

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

#### Base de datos local
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

## Dependencias agregadas

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

## Estructura final

```
lib/
├── core/
│   ├── database/
│   │   └── database_helper.dart
│   └── utils/
│       ├── responsive_constants.dart
│       ├── responsive_helper.dart 
│       └── responsive_widgets.dart 
├── data/
│   ├── datasources/
│   │   ├── remote_data_source.dart 
│   │   └── local_data_source.dart 
│   └── models/
│       ├── user_model.dart 
│       ├── entrepreneur_model.dart 
│       ├── order_model.dart 
│       ├── address_model.dart 
│       └── interaction_models.dart 
└── presentation/
    └── pages/
        └── login/
            └── login_page.dart 
```

---

## Mejoras implementadas

| Aspecto | Antes | Después |
|--------|-------|---------|
| **Mensaje Login** | Genérico "¡Bienvenido!" | Personalizado por rol |
| **Responsividad** | Hardcoded sizes | Dinámico según dispositivo |
| **Mobile Support** | Potencial overflow | Adaptado a diferentes pantallas |
| **Base de Datos** | SharedPreferences | SQLite con arquitectura completa |
| **Escalabilidad** | Limitada | Estructura preparada para backend |
| **Mantenibilidad** | Código disperso | Centralizado en helpers/modelos |

---

## Ejecución

```bash
# Actualizar dependencias
flutter pub get

# Ejecutar en dispositivo
flutter run

# Ejecutar en web (para probar responsividad)
flutter run -d chrome
```

---

## Notas importantes

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


## NotificationHelper - Notificaciones

Se ha creado `NotificationHelper` para reemplazar los SnackBars básicos con notificaciones centradas y duración corta.

### Archivo

```
lib/core/utils/notification_helper.dart
```

### Métodos disponibles

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

### Archivos actualizados

Se han actualizado estos archivos para usar `NotificationHelper`:
- `lib/presentation/pages/login/login_page.dart` 
- `lib/presentation/pages/registration/registration_page.dart`
- `lib/presentation/pages/password_recovery/password_recovery_page.dart`
- `lib/presentation/pages/email_confirmation/email_confirmation_page.dart`

---

## Troubleshooting

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

**NotificationHelper no aparece:**
- Verificar que el Scaffold padre está presente
- Asegurar que `context` es válido
- Revisar que ScaffoldMessenger no está siendo bloqueado


---
