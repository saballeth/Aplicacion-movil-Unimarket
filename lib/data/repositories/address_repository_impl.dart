import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  @override
  Future<List<AddressEntity>> getAddressesByUserId(String userId) async {
    // TODO: Conectar a API real
    // Mock data para desarrollo
    await Future.delayed(const Duration(milliseconds: 500));
    return [
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
  }

  @override
  Future<AddressEntity?> getDefaultAddress(String userId) async {
    // TODO: Conectar a API real
    final addresses = await getAddressesByUserId(userId);
    try {
      return addresses.firstWhere((addr) => addr.isDefault);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AddressEntity> createAddress(AddressEntity address) async {
    // TODO: Conectar a API real
    await Future.delayed(const Duration(milliseconds: 500));
    return address;
  }

  @override
  Future<void> updateAddress(AddressEntity address) async {
    // TODO: Conectar a API real
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    // TODO: Conectar a API real
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> setDefaultAddress(String addressId) async {
    // TODO: Conectar a API real
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
