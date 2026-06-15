import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/address_entity.dart';
import '../../../../domain/usecases/get_addresses_usecase.dart';
import 'address_checkout_state.dart';

class AddressCheckoutCubit extends Cubit<AddressCheckoutState> {
  final GetAddressesUseCase getAddressesUseCase;

  AddressCheckoutCubit({required this.getAddressesUseCase})
    : super(AddressCheckoutInitial());

  AddressEntity? _selectedAddress;

  AddressEntity? get selectedAddress => _selectedAddress;

  Future<void> loadAddresses(String userId) async {
    emit(AddressCheckoutLoading());
    try {
      final addresses = await getAddressesUseCase(userId);
      // Seleccionar la dirección por defecto o la primera disponible
      _selectedAddress = addresses.isNotEmpty
          ? addresses.firstWhere(
              (addr) => addr.isDefault,
              orElse: () => addresses.first,
            )
          : null;
      emit(
        AddressCheckoutLoaded(
          addresses: addresses,
          selectedAddress: _selectedAddress,
        ),
      );
    } catch (e) {
      emit(AddressCheckoutError('Error cargando direcciones: ${e.toString()}'));
    }
  }

  void selectAddress(AddressEntity address) {
    _selectedAddress = address;
    if (state is AddressCheckoutLoaded) {
      final currentState = state as AddressCheckoutLoaded;
      emit(
        AddressCheckoutLoaded(
          addresses: currentState.addresses,
          selectedAddress: _selectedAddress,
        ),
      );
    }
  }

  // Mock data - útil para desarrollo
  Future<void> loadMockAddresses(String userId) async {
    emit(AddressCheckoutLoading());
    try {
      final addresses = [
        AddressEntity(
          id: '1',
          userId: userId,
          fullName: 'Juan Pérez',
          phone: '3001234567',
          street: 'Calle 45 #23-67',
          city: 'Bogotá',
          state: 'Cundinamarca',
          zipCode: '110111',
          country: 'Colombia',
          apartment: 'Apto 402',
          instructions: 'Tocar timbre 2 veces',
          isDefault: true,
          createdAt: DateTime.now(),
        ),
        AddressEntity(
          id: '2',
          userId: userId,
          fullName: 'Juan Pérez',
          phone: '3001234567',
          street: 'Carrera 15 #80-45',
          city: 'Bogotá',
          state: 'Cundinamarca',
          zipCode: '110222',
          country: 'Colombia',
          isDefault: false,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
      ];
      _selectedAddress = addresses[0];
      emit(
        AddressCheckoutLoaded(
          addresses: addresses,
          selectedAddress: _selectedAddress,
        ),
      );
    } catch (e) {
      emit(AddressCheckoutError('Error cargando direcciones: ${e.toString()}'));
    }
  }
}
