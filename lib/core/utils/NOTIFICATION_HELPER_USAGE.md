# NotificationHelper - Guía de Uso

`NotificationHelper` es una clase reutilizable para mostrar notificaciones (SnackBars/Toasts) centradas en la pantalla con soporte para tema oscuro y duración corta.

## Ubicación

```
lib/core/utils/notification_helper.dart
```

## Importación

```dart
import 'package:unimarket/core/utils/notification_helper.dart';
```

## Métodos Disponibles

### 1. Notificación de Éxito

Muestra una notificación verde con icono de verificación

```dart
NotificationHelper.showSuccess(
  context: context,
  message: 'Operación completada exitosamente',
);

// Con duración personalizada
NotificationHelper.showSuccess(
  context: context,
  message: 'Guardado',
  duration: const Duration(seconds: 1),
);
```

### 2. Notificación de Error

Muestra una notificación roja con icono de error

```dart
NotificationHelper.showError(
  context: context,
  message: 'Ocurrió un error durante la operación',
);
```

### 3. Notificación de Advertencia

Muestra una notificación naranja con icono de advertencia

```dart
NotificationHelper.showWarning(
  context: context,
  message: 'Por favor revisa los datos ingresados',
);
```

### 4. Notificación Informativa

Muestra una notificación azul con icono de información

```dart
NotificationHelper.showInfo(
  context: context,
  message: 'Este es un mensaje informativo',
);
```

### 5. Notificación Personalizada

Personaliza color, icono y duración

```dart
NotificationHelper.show(
  context: context,
  message: 'Acción custom',
  backgroundColor: Colors.purple,
  icon: Icons.favorite,
  duration: const Duration(milliseconds: 1500),
);
```

## Características

- ✅ **Centrada en pantalla**: Aparece en el centro inferior sin afectar el layout
- ✅ **Tema oscuro**: Se adapta automáticamente al tema actual (light/dark)
- ✅ **Duración corta**: Por defecto 1.5 segundos (personalizable)
- ✅ **Iconos incluidos**: Cada tipo tiene su propio icono
- ✅ **Floating behavior**: No empuja el contenido
- ✅ **Rounded corners**: Diseño moderno con bordes redondeados
- ✅ **Multi-línea**: Soporta mensajes largos (hasta 2 líneas)

## Ejemplos de Uso Completos

### En un BlocListener

```dart
BlocListener<MyCubit, MyState>(
  listener: (context, state) {
    if (state is MySuccess) {
      NotificationHelper.showSuccess(
        context: context,
        message: state.successMessage,
      );
    } else if (state is MyFailure) {
      NotificationHelper.showError(
        context: context,
        message: state.errorMessage,
      );
    }
  },
  child: YourWidget(),
)
```

### En un BlocConsumer

```dart
BlocConsumer<MyCubit, MyState>(
  listener: (context, state) {
    if (state is OperationComplete) {
      NotificationHelper.showSuccess(
        context: context,
        message: 'Cambios guardados',
      );
    }
  },
  builder: (context, state) {
    return YourWidget();
  },
)
```

### En un método simple

```dart
void _deleteItem(BuildContext context) {
  // Realizar operación
  if (success) {
    NotificationHelper.showSuccess(
      context: context,
      message: 'Elemento eliminado',
    );
  } else {
    NotificationHelper.showError(
      context: context,
      message: 'No se pudo eliminar',
    );
  }
}
```

## Duraciones Recomendadas

- **Éxito/Error**: 1.5s (default) - rápido feedback
- **Advertencia**: 2s - dar tiempo para leer
- **Información**: 2-3s - contextual
- **Transacciones críticas**: 3-4s

## Ventajas sobre ScaffoldMessenger directo

| Aspecto | ScaffoldMessenger | NotificationHelper |
|--------|-------------------|-------------------|
| Posición | Lateral (abajo) | Centro (flotante) |
| Tema Oscuro | Manual | Automático |
| Iconos | No | Sí, contextual |
| Duración | Manual cada vez | Default inteligente |
| Diseño | Básico | Moderno redondeado |
| Reutilización | No | Sí, 5 métodos |

## Notas Importantes

- ⚠️ Requiere que `context` tenga un `Scaffold` padre
- ✅ Automáticamente limpia notificaciones previas (una a la vez)
- ✅ Funciona en light mode y dark mode sin cambios
- ✅ Compatible con navegación y transiciones
