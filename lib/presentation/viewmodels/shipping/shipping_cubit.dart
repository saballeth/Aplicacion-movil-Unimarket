import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/shipping_option_entity.dart';
import '../../../../domain/usecases/get_shipping_options_usecase.dart';
import 'shipping_state.dart';

class ShippingCubit extends Cubit<ShippingState> {
  final GetShippingOptionsUseCase getShippingOptionsUseCase;

  ShippingCubit({required this.getShippingOptionsUseCase})
    : super(ShippingInitial());

  ShippingOptionEntity? _selectedShipping;

  ShippingOptionEntity? get selectedShipping => _selectedShipping;

  Future<void> loadShippingOptions() async {
    emit(ShippingLoading());
    try {
      final options = await getShippingOptionsUseCase();
      // Seleccionar la primera opción disponible por defecto
      _selectedShipping = options.isNotEmpty ? options.first : null;
      emit(
        ShippingLoaded(
          shippingOptions: options,
          selectedShipping: _selectedShipping,
        ),
      );
    } catch (e) {
      emit(ShippingError('Error cargando opciones de envío: ${e.toString()}'));
    }
  }

  void selectShipping(ShippingOptionEntity shipping) {
    _selectedShipping = shipping;
    if (state is ShippingLoaded) {
      final currentState = state as ShippingLoaded;
      emit(
        ShippingLoaded(
          shippingOptions: currentState.shippingOptions,
          selectedShipping: _selectedShipping,
        ),
      );
    }
  }

  // Mock data - útil para desarrollo
  Future<void> loadMockShippingOptions() async {
    emit(ShippingLoading());
    try {
      final options = [
        const ShippingOptionEntity(
          id: '1',
          name: 'Envío Estándar',
          description: 'Entrega en 5-7 días',
          cost: 15000,
          estimatedDays: 6,
        ),
        const ShippingOptionEntity(
          id: '2',
          name: 'Envío Express',
          description: 'Entrega en 2-3 días',
          cost: 35000,
          estimatedDays: 2,
        ),
        const ShippingOptionEntity(
          id: '3',
          name: 'Envío Gratis',
          description: 'Entrega en 8-15 días',
          cost: 0,
          estimatedDays: 12,
          isAvailable: false,
        ),
      ];
      _selectedShipping = options[0];
      emit(
        ShippingLoaded(
          shippingOptions: options,
          selectedShipping: _selectedShipping,
        ),
      );
    } catch (e) {
      emit(ShippingError('Error cargando opciones de envío: ${e.toString()}'));
    }
  }
}
