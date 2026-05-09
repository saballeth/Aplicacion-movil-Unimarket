import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/core/injection_container.dart';
import 'package:unimarket/presentation/viewmodels/addresses/addresses_cubit.dart';
import 'package:unimarket/presentation/viewmodels/addresses/addresses_state.dart';

class AddressesManagementPage extends StatelessWidget {
  const AddressesManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddressesCubit>()..loadAddresses(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Mis Direcciones'),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: BlocConsumer<AddressesCubit, AddressesState>(
          listener: (context, state) {
            if (state is AddressError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is AddressAdded ||
                state is AddressUpdated ||
                state is AddressDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state is AddressAdded
                        ? 'Dirección agregada'
                        : state is AddressUpdated
                        ? 'Dirección actualizada'
                        : 'Dirección eliminada',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              // Reload addresses after any action
              context.read<AddressesCubit>().loadAddresses();
            }
          },
          builder: (context, state) {
            if (state is AddressesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AddressesLoaded) {
              final addresses = state.addresses;

              if (addresses.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_off,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay direcciones registradas',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: addresses.length,
                itemBuilder: (context, index) =>
                    _buildAddressCard(context, addresses[index]),
              );
            }

            if (state is AddressError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF4B2AAD),
          onPressed: () => _showAddAddressDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, AddressModel address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: address.isDefault
              ? const Color(0xFF4B2AAD)
              : Colors.grey[300]!,
          width: address.isDefault ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                address.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (address.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B2AAD).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Por defecto',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4B2AAD),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            address.address,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          Text(
            '${address.city}, ${address.country}',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showEditAddressDialog(context, address),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Editar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4B2AAD),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _confirmDeleteAddress(context, address.id),
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text('Eliminar'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                ),
              ),
              if (!address.isDefault) const SizedBox(width: 8),
              if (!address.isDefault)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context
                        .read<AddressesCubit>()
                        .setDefaultAddress(address.id),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Por defecto'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final countryController = TextEditingController();
    final postalCodeController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Agregar Dirección'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Etiqueta (ej: Casa, Trabajo)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'Ciudad',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: countryController,
                decoration: const InputDecoration(
                  labelText: 'País',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: postalCodeController,
                decoration: const InputDecoration(
                  labelText: 'Código Postal',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4B2AAD),
            ),
            onPressed: () {
              context.read<AddressesCubit>().addAddress(
                label: nameController.text,
                address: addressController.text,
                city: cityController.text,
                country: countryController.text,
                postalCode: postalCodeController.text,
              );
              Navigator.pop(dialogContext);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showEditAddressDialog(BuildContext context, AddressModel address) {
    final nameController = TextEditingController(text: address.label);
    final addressController = TextEditingController(text: address.address);
    final cityController = TextEditingController(text: address.city);
    final countryController = TextEditingController(text: address.country);
    final postalCodeController = TextEditingController(
      text: address.postalCode,
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Editar Dirección'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Etiqueta',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'Ciudad',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: countryController,
                decoration: const InputDecoration(
                  labelText: 'País',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: postalCodeController,
                decoration: const InputDecoration(
                  labelText: 'Código Postal',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4B2AAD),
            ),
            onPressed: () {
              context.read<AddressesCubit>().updateAddress(
                id: address.id,
                label: nameController.text,
                address: addressController.text,
                city: cityController.text,
                country: countryController.text,
                postalCode: postalCodeController.text,
              );
              Navigator.pop(dialogContext);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAddress(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar Dirección'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar esta dirección?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<AddressesCubit>().deleteAddress(id);
              Navigator.pop(dialogContext);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
