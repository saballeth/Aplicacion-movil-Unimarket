import 'package:flutter/material.dart';
import '../../viewmodels/addresses/add_address_viewmodel.dart';
import '../../viewmodels/addresses/addresses_viewmodel.dart';
import 'map_address_page.dart';

class AddAddressPage extends StatefulWidget {
  final Address? initial;

  const AddAddressPage({super.key, this.initial});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  late final AddAddressViewModel vm;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _addressController;
  late final TextEditingController _detailsController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    vm = AddAddressViewModel(initial: widget.initial);
    _addressController = TextEditingController(text: vm.mainAddress.isNotEmpty ? vm.mainAddress : 'Carrera 78 #28 B - 52');
    _detailsController = TextEditingController(text: vm.secondaryAddress);
    _descriptionController = TextEditingController(text: vm.description);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _detailsController.dispose();
    _descriptionController.dispose();
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
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildMapSelector(),
          const SizedBox(height: 32),
          _buildAddressField(),
          const SizedBox(height: 24),
          _buildAddressDetailsField(),
          const SizedBox(height: 24),
          _buildDescriptionField(),
          const SizedBox(height: 40),
          _buildSaveButton(),
        ]),
      ),
    );
  }

  Widget _buildMapSelector() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _openMapSelection,
          borderRadius: BorderRadius.circular(12),
          child: Padding(padding: const EdgeInsets.all(16), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.map_outlined, color: Color(0xFFF5A623), size: 24), SizedBox(width: 12), Text('Seleccionar en el mapa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFF5A623)))])),
        ),
      ),
    );
  }

  Widget _buildAddressField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Dirección', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
      const SizedBox(height: 8),
      TextFormField(
        controller: _addressController,
        decoration: InputDecoration(hintText: 'Ingresa tu dirección', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade400)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade400)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFF5A623), width: 2)), filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), suffixIcon: IconButton(onPressed: _useCurrentLocation, icon: const Icon(Icons.my_location_outlined, color: Color(0xFFF5A623)))),
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        validator: (value) => (value == null || value.isEmpty) ? 'Por favor ingresa una dirección' : null,
      ),
    ]);
  }

  Widget _buildAddressDetailsField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Detalles de la dirección', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
      const SizedBox(height: 4),
      Text('N° de apto, oficina o casa', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
      const SizedBox(height: 8),
      TextFormField(controller: _detailsController, decoration: InputDecoration(hintText: 'Ej: Apartamento 301, Oficina 4B', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade400)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade400)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFF5A623), width: 2)), filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14))),
    ]);
  }

  Widget _buildDescriptionField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Descripción', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
      const SizedBox(height: 4),
      Text('Instrucciones adicionales (opcional)', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
      const SizedBox(height: 8),
      TextFormField(controller: _descriptionController, maxLines: 3, decoration: InputDecoration(hintText: 'Ej: Portón negro, llamar al timbre 3B, dejar con conserjería', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade400)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade400)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFF5A623), width: 2)), filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14))),
    ]);
  }

  Widget _buildSaveButton() {
    return SizedBox(width: double.infinity, height: 56, child: ElevatedButton(onPressed: _saveAddress, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF5A623), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 2), child: const Text('Guardar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))));
  }

  void _openMapSelection() {
    Navigator.of(context).push<String?>(MaterialPageRoute(builder: (_) => const MapAddressPage())).then((result) {
      if (result != null && result.isNotEmpty) {
        _addressController.text = result;
        vm.setMain(result);
      }
    });
  }

  void _useCurrentLocation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usar ubicación actual'),
        content: const Text('¿Deseas usar tu ubicación actual para completar la dirección?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              _addressController.text = 'Carrera 78 #28 B - 52 (Ubicación actual)';
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF5A623)),
            child: const Text('Usar ubicación'),
          ),
        ],
      ),
    );
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      vm.setMain(_addressController.text);
      vm.setSecondary(_detailsController.text);
      vm.setDescription(_descriptionController.text);
      final addr = vm.buildAddress(id: widget.initial?.id);
      Navigator.pop(context, addr);
    }
  }
}
