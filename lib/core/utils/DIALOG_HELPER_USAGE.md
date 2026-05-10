# DialogHelper - Guía de Uso

`DialogHelper` es una clase reutilizable para mostrar diálogos de confirmación, éxito, error, advertencia e información en toda la aplicación.

## Ubicación
```
lib/core/utils/dialog_helper.dart
```

## Importación
```dart
import 'package:unimarket/core/utils/dialog_helper.dart';
```

## Métodos Disponibles

### 1. Diálogo de Confirmación
Muestra un diálogo que requiere confirmación del usuario.

```dart
final confirm = await DialogHelper.showConfirmationDialog(
  context: context,
  title: 'Eliminar',
  message: '¿Estás seguro de que deseas eliminar este elemento?',
  confirmText: 'Eliminar',
  cancelText: 'Cancelar',
  confirmColor: Colors.red,
);

if (confirm) {
  // Realizar la acción
}
```

### 2. Diálogo de Éxito
Muestra un diálogo de confirmación de proceso exitoso.

```dart
await DialogHelper.showSuccessDialog(
  context: context,
  title: 'Éxito',
  message: 'El proceso se completó correctamente.',
  buttonText: 'Aceptar',
  onPressed: () {
    // Opcional: acción adicional después de cerrar el diálogo
  },
);
```

### 3. Diálogo de Error
Muestra un diálogo informando sobre un error.

```dart
await DialogHelper.showErrorDialog(
  context: context,
  title: 'Error',
  message: 'No se pudo completar la acción. Intenta de nuevo.',
  buttonText: 'Cerrar',
);
```

### 4. Diálogo de Advertencia
Muestra un diálogo de advertencia que requiere confirmación.

```dart
final confirm = await DialogHelper.showWarningDialog(
  context: context,
  title: 'Advertencia',
  message: 'Esta acción no se puede deshacer. ¿Deseas continuar?',
  confirmText: 'Continuar',
  cancelText: 'Cancelar',
);

if (confirm) {
  // Realizar la acción
}
```

### 5. Diálogo de Información
Muestra un diálogo informativo.

```dart
await DialogHelper.showInfoDialog(
  context: context,
  title: 'Información',
  message: 'Detalles importante para el usuario.',
  buttonText: 'Aceptar',
);
```

### 6. Diálogo de Carga
Muestra un diálogo de carga mientras se ejecuta una operación.

```dart
DialogHelper.showLoadingDialog(
  context: context,
  message: 'Procesando...',
);

try {
  // Realizar operación larga
  await miOperacion();
} finally {
  DialogHelper.dismissLoadingDialog(context);
}
```

## Ejemplos Prácticos

### Ejemplo 1: Eliminar un elemento
```dart
ElevatedButton(
  onPressed: () async {
    final confirm = await DialogHelper.showConfirmationDialog(
      context: context,
      title: 'Eliminar Producto',
      message: '¿Estás seguro de que deseas eliminar este producto?',
      confirmText: 'Sí, eliminar',
      cancelText: 'No, cancelar',
      confirmColor: Colors.red,
    );
    
    if (confirm) {
      DialogHelper.showLoadingDialog(
        context: context,
        message: 'Eliminando...',
      );
      
      try {
        await context.read<ProductCubit>().deleteProduct(productId);
        if (context.mounted) {
          DialogHelper.dismissLoadingDialog(context);
          await DialogHelper.showSuccessDialog(
            context: context,
            title: 'Eliminado',
            message: 'El producto ha sido eliminado correctamente.',
          );
        }
      } catch (e) {
        if (context.mounted) {
          DialogHelper.dismissLoadingDialog(context);
          await DialogHelper.showErrorDialog(
            context: context,
            title: 'Error',
            message: 'No se pudo eliminar el producto.',
          );
        }
      }
    }
  },
  child: const Text('Eliminar'),
)
```

### Ejemplo 2: Guardar cambios
```dart
ElevatedButton(
  onPressed: () async {
    final confirm = await DialogHelper.showConfirmationDialog(
      context: context,
      title: 'Guardar Cambios',
      message: '¿Deseas guardar los cambios realizados?',
      confirmText: 'Guardar',
      cancelText: 'Descartar',
    );
    
    if (confirm) {
      DialogHelper.showLoadingDialog(
        context: context,
        message: 'Guardando cambios...',
      );
      
      try {
        await context.read<EditCubit>().save();
        if (context.mounted) {
          DialogHelper.dismissLoadingDialog(context);
          await DialogHelper.showSuccessDialog(
            context: context,
            title: 'Guardado',
            message: 'Los cambios se han guardado correctamente.',
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          DialogHelper.dismissLoadingDialog(context);
          await DialogHelper.showErrorDialog(
            context: context,
            title: 'Error',
            message: 'No se pudieron guardar los cambios.',
          );
        }
      }
    }
  },
  child: const Text('Guardar'),
)
```

### Ejemplo 3: Enviar formulario
```dart
ElevatedButton(
  onPressed: () async {
    final confirm = await DialogHelper.showConfirmationDialog(
      context: context,
      title: 'Enviar Solicitud',
      message: 'Una vez enviada, no podrás hacer cambios. ¿Deseas continuar?',
      confirmText: 'Enviar',
      cancelText: 'Revisar',
      confirmColor: Colors.blue,
    );
    
    if (confirm) {
      DialogHelper.showLoadingDialog(
        context: context,
        message: 'Enviando solicitud...',
      );
      
      try {
        await context.read<FormCubit>().submit();
        if (context.mounted) {
          DialogHelper.dismissLoadingDialog(context);
          await DialogHelper.showSuccessDialog(
            context: context,
            title: 'Enviado',
            message: 'Tu solicitud ha sido enviada correctamente.',
            onPressed: () => Navigator.pop(context),
          );
        }
      } catch (e) {
        if (context.mounted) {
          DialogHelper.dismissLoadingDialog(context);
          await DialogHelper.showErrorDialog(
            context: context,
            title: 'Error',
            message: 'No se pudo enviar la solicitud.',
          );
        }
      }
    }
  },
  child: const Text('Enviar'),
)
```

## Notas Importantes

1. **context.mounted**: Siempre verifica si el widget está montado antes de usarlo después de operaciones asincrónicas.

2. **Colores personalizados**: Puedes personalizar el color del botón de confirmación usando el parámetro `confirmColor`.

3. **Tipos de diálogos**: Elige el tipo de diálogo adecuado según la situación:
   - Confirmación: Decisiones que requieren aprobación
   - Éxito: Operaciones completadas
   - Error: Problemas o fallos
   - Advertencia: Acciones irreversibles
   - Información: Datos importantes
   - Carga: Operaciones en progreso

4. **Personalización**: Si necesitas un diálogo completamente personalizado, puedes extender la clase `DialogHelper`.

## Integración en Otras Páginas

Para usar estos diálogos en cualquier página:

1. Importa `DialogHelper`
2. Reemplaza las acciones directas con confirmaciones
3. Añade manejo de carga y errores
4. Proporciona feedback visual al usuario
