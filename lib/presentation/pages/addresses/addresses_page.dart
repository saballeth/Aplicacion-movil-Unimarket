import 'package:flutter/material.dart';
import '../../viewmodels/addresses/addresses_viewmodel.dart';
import 'add_address_page.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  final AddressesViewModel vm = AddressesViewModel();

  @override
  void initState() {
    super.initState();
    vm.addListener(_onVm);
  }

  void _onVm() => setState(() {});

  @override
  void dispose() {
    vm.removeListener(_onVm);
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Mis direcciones',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.grey.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${vm.addresses.length} direcciones guardadas',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: vm.addresses.length,
            itemBuilder: (context, index) {
              return _buildAddressCard(vm.addresses[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard(Address address, int index) {
    final isSelected = vm.selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFFF5A623) : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => vm.select(index),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? const Color(0xFFF5A623) : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFF5A623),
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.mainAddress,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        address.secondaryAddress,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (address.isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(245, 166, 35, 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Predeterminada',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFFF5A623),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () => _editAddress(address),
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _addNewAddress,
      backgroundColor: const Color(0xFFF5A623),
      elevation: 4,
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  void _editAddress(Address address) async {
    final result = await Navigator.of(context).push<Address>(MaterialPageRoute(builder: (_) => AddAddressPage(initial: address)));
    if (result != null) {
      vm.editAddress(result);
      if (result.isDefault) vm.setDefaultById(result.id);
    }
  }

  void _addNewAddress() async {
    final result = await Navigator.of(context).push<Address>(MaterialPageRoute(builder: (_) => const AddAddressPage()));
    if (result != null) {
      vm.addAddress(result);
      if (result.isDefault) vm.setDefaultById(result.id);
    }
  }

  
}
