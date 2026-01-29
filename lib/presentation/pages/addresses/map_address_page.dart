import 'package:flutter/material.dart';
import '../../viewmodels/addresses/map_address_viewmodel.dart';
import 'map_confirmation_page.dart';

class MapAddressPage extends StatefulWidget {
  const MapAddressPage({super.key});

  @override
  State<MapAddressPage> createState() => _MapAddressPageState();
}

class _MapAddressPageState extends State<MapAddressPage> {
  final MapAddressViewModel vm = MapAddressViewModel();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    vm.addListener(_onVm);
    _searchController.addListener(() => vm.filter(_searchController.text));
  }

  void _onVm() => setState(() {});

  @override
  void dispose() {
    vm.removeListener(_onVm);
    _searchController.dispose();
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Agregar una dirección', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
      centerTitle: true,
      leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
      backgroundColor: Colors.white,
      elevation: 1,
      actions: [
        if (vm.selected.isNotEmpty)
          IconButton(icon: const Icon(Icons.check, color: Color(0xFFF5A623)), onPressed: _openConfirmation),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildMapSection(),
        _buildSearchBar(),
        if (vm.selected.isNotEmpty) _buildSelectionIndicator(),
        Expanded(child: _buildStreetList()),
      ],
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.map_outlined, size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('Mapa interactivo', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text(
                  vm.selected.isEmpty ? 'Selecciona una calle en la lista' : 'Seleccionado: ${vm.selected}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),

          if (vm.selected.isNotEmpty)
            Positioned(
              top: 100,
              left: MediaQuery.of(context).size.width / 2 - 20,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5A623),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.location_on, color: Colors.white, size: 24),
              ),
            ),

          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.06), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: const Text(
                'Selecciona una calle de la lista para marcarla en el mapa',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.06), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(hintText: 'Buscar calle...', border: InputBorder.none, hintStyle: TextStyle(color: Colors.grey)),
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              if (_searchController.text.isNotEmpty)
                IconButton(icon: const Icon(Icons.clear, size: 20), onPressed: () {
                  _searchController.clear();
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Color.fromRGBO(245, 166, 35, 0.1),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFFF5A623), size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text('Seleccionado: ${vm.selected}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800))),
          TextButton(
            onPressed: () {
              setState(() {
                vm.select('');
              });
            },
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: const Text('Cambiar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFF5A623))),
          ),
        ],
      ),
    );
  }

  Widget _buildStreetList() {
    return ListView.builder(
      itemCount: vm.filtered.length,
      itemBuilder: (context, index) {
        final street = vm.filtered[index];
        final isSelected = street == vm.selected;
        return Material(
          color: isSelected ? Color.fromRGBO(245, 166, 35, 0.1) : Colors.white,
          child: InkWell(
            onTap: () => vm.select(street),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 0.5))),
              child: Row(
                children: [
                  Icon(Icons.place_outlined, color: isSelected ? const Color(0xFFF5A623) : Colors.grey.shade600, size: 20),
                  const SizedBox(width: 16),
                  Expanded(child: Text(street, style: TextStyle(fontSize: 16, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, color: isSelected ? const Color(0xFFF5A623) : Colors.black87))),
                  if (isSelected) const Icon(Icons.check, color: Color(0xFFF5A623), size: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openConfirmation() async {
    if (vm.selected.isEmpty) return;
    final result = await Navigator.of(context).push<String?>(MaterialPageRoute(builder: (_) => MapConfirmationPage(initialAddress: vm.selected)));
    if (result != null && result.isNotEmpty) {
      if (!mounted) return;
      Navigator.pop(context, result);
    }
  }
}
