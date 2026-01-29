import 'package:flutter/material.dart';
import '../../viewmodels/order_detail/order_detail_viewmodel.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final OrderDetailViewModel vm = OrderDetailViewModel();

  @override
  void initState() {
    super.initState();
    vm.addListener(_onVmChanged);
  }

  void _onVmChanged() => setState(() {});

  @override
  void dispose() {
    vm.removeListener(_onVmChanged);
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
        '9:41',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.black),
          onPressed: () => vm.shareOrder(),
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vm.restaurantName,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 20),

          _buildDeliveryOptions(),

          const SizedBox(height: 24),

          _buildOrderStatus(),

          const SizedBox(height: 32),

          const Text(
            'Productos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          _buildProductList(),

          const SizedBox(height: 32),

          _buildPaymentSummary(),
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
                  color: vm.isDeliverySelected
                      ? const Color(0xFFF5A623)
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Domicilio',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: vm.isDeliverySelected ? Colors.white : Colors.black87,
                    ),
                  ),
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
                  color: !vm.isDeliverySelected
                      ? const Color(0xFFF5A623)
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Ir a recoger',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: !vm.isDeliverySelected ? Colors.white : Colors.black87,
                    ),
                  ),
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
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estado de pedido',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Entregado',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  vm.statusMessage,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: vm.products.map((p) => _buildProductItem(
          name: p.name,
          restaurant: p.restaurant,
          quantity: p.quantity,
          price: p.price,
        )).toList(),
      ),
    );
  }

  Widget _buildProductItem({
    required String name,
    required String restaurant,
    required int quantity,
    required double price,
  }) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(245, 166, 35, 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.local_pizza,
                color: Color(0xFFF5A623),
                size: 30,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    restaurant,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$quantity',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Text(
                        '\$${(price * quantity).toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Container(
          height: 1,
          color: Colors.grey.shade200,
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            const Icon(
              Icons.note_outlined,
              size: 18,
              color: Colors.grey,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Sin cebolla, por favor',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Resumen de pago',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 16),

          _buildPriceRow(label: 'Precio', value: '\$ 8.000', isBold: false),

          const SizedBox(height: 8),

          _buildPriceRow(label: 'Domicilio', value: '\$ 0', isBold: false),

          const SizedBox(height: 8),

          _buildPriceRow(label: 'Propina', value: '\$ 0', isBold: false),

          const SizedBox(height: 16),

          Container(
            height: 1,
            color: Colors.grey.shade300,
          ),

          const SizedBox(height: 16),

          _buildPriceRow(label: 'Total de pago', value: '\$ 8.000', isBold: true, isTotal: true),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => vm.repeatOrder(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5A623),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Repetir este pedido',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    required String value,
    required bool isBold,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black87 : Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? const Color(0xFFF5A623) : Colors.black87,
          ),
        ),
      ],
    );
  }
}
