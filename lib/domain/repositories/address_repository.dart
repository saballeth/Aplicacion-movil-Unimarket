import '../entities/address_entity.dart';

abstract class AddressRepository {
  Future<List<AddressEntity>> getAddressesByUserId(String userId);
  Future<AddressEntity?> getDefaultAddress(String userId);
  Future<AddressEntity> createAddress(AddressEntity address);
  Future<void> updateAddress(AddressEntity address);
  Future<void> deleteAddress(String addressId);
  Future<void> setDefaultAddress(String addressId);
}
