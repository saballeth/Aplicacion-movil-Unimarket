import 'package:flutter/material.dart';
import '../../viewmodels/delivery_confirmation/delivery_confirmation_viewmodel.dart';
import '../addresses/addresses_page.dart';

class DeliveryConfirmationPage extends StatefulWidget {
  const DeliveryConfirmationPage({super.key});

  @override
  State<DeliveryConfirmationPage> createState() => _DeliveryConfirmationPageState();
}

class _DeliveryConfirmationPageState extends State<DeliveryConfirmationPage> {
  final DeliveryConfirmationViewModel vm = DeliveryConfirmationViewModel();

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
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Jeikol Pizza',
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDeliveryOptions(),
          const SizedBox(height: 24),
          _buildOrderStatus(),
          const SizedBox(height: 24),
          _buildProductsSection(),
          const SizedBox(height: 24),
          _buildPaymentSummary(),
          const SizedBox(height: 24),
          _buildDeliveryAddress(),
          const SizedBox(height: 32),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildDeliveryOptions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => vm.toggleDelivery(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: vm.isDeliverySelected ? const Color(0xFFF5A623) : Colors.transparent,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Domicilio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: vm.isDeliverySelected ? Colors.white : Colors.black87)),
                    const SizedBox(height: 4),
                    if (vm.isDeliverySelected)
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => vm.toggleDelivery(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: !vm.isDeliverySelected ? const Color(0xFFF5A623) : Colors.transparent,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Ir a recoger', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: !vm.isDeliverySelected ? Colors.white : Colors.black87)),
                    const SizedBox(height: 4),
                    if (!vm.isDeliverySelected)
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green.shade100)),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text('Estado de pedido', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54)),
              SizedBox(height: 8),
              _DeliveredTag(),
            ]),
          ),
          const Icon(Icons.check_circle, color: Colors.green, size: 40),
        ],
      ),
    );
  }

  Widget _buildProductsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200), boxShadow: [
        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.06), blurRadius: 8, offset: const Offset(0, 2)),
      ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Productos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 16),
        _buildProductItem(),
      ]),
    );
  }

  Widget _buildProductItem() {
    final p = vm.products.first;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 80, height: 80, decoration: BoxDecoration(color: const Color.fromRGBO(245,166,35,0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.local_pizza, color: Color(0xFFF5A623), size: 40)),
      const SizedBox(width: 16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(p.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 4),
        Text(p.restaurant, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 12),
        Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)), child: Text('${vm.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          const Spacer(),
          Text('\$ ${p.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        ])
      ]))
    ]);
  }

  Widget _buildPaymentSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200), boxShadow: [
        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.06), blurRadius: 8, offset: const Offset(0, 2)),
      ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Resumen de pago', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 16),
        _buildPriceRow('Precio', '\$ ${vm.subtotal.toStringAsFixed(0)}'),
        const SizedBox(height: 8),
        _buildPriceRow('Domicilio', '\$ 0', isFree: true),
        const SizedBox(height: 8),
        _buildPriceRow('Propina', '\$ 0', isOptional: true),
        const SizedBox(height: 16),
        Container(height: 1, color: Colors.grey.shade300),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          Text('\$ ${vm.total.toStringAsFixed(0)}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
        ])
      ]),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isFree = false, bool isOptional = false}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
      Row(children: [
        if (isFree) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), margin: const EdgeInsets.only(right: 8), decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green.shade100)), child: Text('Gratis', style: TextStyle(fontSize: 12, color: Colors.green.shade700, fontWeight: FontWeight.bold))),
        if (isOptional) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), margin: const EdgeInsets.only(right: 8), decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.orange.shade100)), child: Text('Opcional', style: TextStyle(fontSize: 12, color: Colors.orange.shade700, fontWeight: FontWeight.bold))),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
      ])
    ]);
  }

  Widget _buildDeliveryAddress() {
    return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200), boxShadow: [
      BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.06), blurRadius: 8, offset: const Offset(0, 2)),
    ]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Dirección de entrega', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
      const SizedBox(height: 16),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.location_on_outlined, color: Color(0xFFF5A623), size: 24),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(vm.addressTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
          const SizedBox(height: 4),
          Text(vm.addressSubtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade100, foregroundColor: const Color(0xFFF5A623), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade300)), elevation: 0), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.edit, size: 16), SizedBox(width: 8), Text('Editar Dirección')]))
        ]))
      ])
    ]));
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          vm.confirmOrder();
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddressesPage()));
        },
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF5A623), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 2),
        child: const Text('Confirmar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _DeliveredTag extends StatelessWidget {
  const _DeliveredTag();

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)), child: const Text('Entregado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)));
  }
}
