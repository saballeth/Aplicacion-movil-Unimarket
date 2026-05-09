import 'package:flutter_bloc/flutter_bloc.dart';
import 'addresses_state.dart';

class AddressesCubit extends Cubit<AddressesState> {
  AddressesCubit() : super(const AddressesInitial());

  // Sample data - replace with backend API calls
  final List<AddressModel> _addresses = [
    AddressModel(
      id: 1,
      label: 'Casa',
      address: 'Calle Principal 123, Apartamento 4B',
      city: 'Bogotá',
      country: 'Colombia',
      postalCode: '110221',
      isDefault: true,
      createdAt: DateTime.now(),
    ),
    AddressModel(
      id: 2,
      label: 'Trabajo',
      address: 'Carrera 7 500, Piso 10',
      city: 'Bogotá',
      country: 'Colombia',
      postalCode: '110222',
      isDefault: false,
      createdAt: DateTime.now(),
    ),
  ];

  /// Load all addresses
  void loadAddresses() {
    emit(const AddressesLoading());
    try {
      // TODO: Replace with actual API call
      // final addresses = await addressRepository.getAddresses();
      final defaultAddress = _addresses.firstWhere(
        (addr) => addr.isDefault,
        orElse: () => _addresses.isNotEmpty
            ? _addresses.first
            : AddressModel(
                id: 0,
                label: '',
                address: '',
                city: '',
                isDefault: false,
                createdAt: DateTime.now(),
              ),
      );
      emit(
        AddressesLoaded(addresses: _addresses, defaultAddress: defaultAddress),
      );
    } catch (e) {
      emit(AddressError('Error al cargar direcciones: ${e.toString()}'));
    }
  }

  /// Add new address
  void addAddress({
    required String label,
    required String address,
    required String city,
    String? country,
    String? postalCode,
  }) {
    emit(const AddressesLoading());
    try {
      // TODO: Replace with actual API call
      // await addressRepository.addAddress(...)
      final newAddress = AddressModel(
        id: _addresses.length + 1,
        label: label,
        address: address,
        city: city,
        country: country,
        postalCode: postalCode,
        isDefault: _addresses.isEmpty,
        createdAt: DateTime.now(),
      );
      _addresses.add(newAddress);
      emit(AddressAdded(newAddress));
      loadAddresses();
    } catch (e) {
      emit(AddressError('Error al agregar dirección: ${e.toString()}'));
    }
  }

  /// Update address
  void updateAddress({
    required int id,
    required String label,
    required String address,
    required String city,
    String? country,
    String? postalCode,
  }) {
    emit(const AddressesLoading());
    try {
      // TODO: Replace with actual API call
      // await addressRepository.updateAddress(...)
      final index = _addresses.indexWhere((addr) => addr.id == id);
      if (index != -1) {
        _addresses[index] = _addresses[index].copyWith(
          label: label,
          address: address,
          city: city,
          country: country,
          postalCode: postalCode,
        );
        emit(AddressUpdated(_addresses[index]));
        loadAddresses();
      }
    } catch (e) {
      emit(AddressError('Error al actualizar dirección: ${e.toString()}'));
    }
  }

  /// Delete address
  void deleteAddress(int id) {
    emit(const AddressesLoading());
    try {
      // TODO: Replace with actual API call
      // await addressRepository.deleteAddress(id)
      _addresses.removeWhere((addr) => addr.id == id);
      emit(AddressDeleted(id));
      loadAddresses();
    } catch (e) {
      emit(AddressError('Error al eliminar dirección: ${e.toString()}'));
    }
  }

  /// Set default address
  void setDefaultAddress(int id) {
    emit(const AddressesLoading());
    try {
      // TODO: Replace with actual API call
      // await addressRepository.setDefaultAddress(id)
      for (var addr in _addresses) {
        if (addr.id == id) {
          final index = _addresses.indexOf(addr);
          _addresses[index] = addr.copyWith(isDefault: true);
        } else {
          final index = _addresses.indexOf(addr);
          _addresses[index] = addr.copyWith(isDefault: false);
        }
      }
      loadAddresses();
    } catch (e) {
      emit(
        AddressError(
          'Error al establecer dirección por defecto: ${e.toString()}',
        ),
      );
    }
  }
}
