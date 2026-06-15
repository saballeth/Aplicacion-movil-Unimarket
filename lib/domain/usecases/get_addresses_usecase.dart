import '../entities/address_entity.dart';
import '../repositories/address_repository.dart';

class GetAddressesUseCase {
  final AddressRepository repository;

  GetAddressesUseCase(this.repository);

  Future<List<AddressEntity>> call(String userId) async {
    return await repository.getAddressesByUserId(userId);
  }
}
