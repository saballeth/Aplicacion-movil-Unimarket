import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/constants/app_colors.dart';
import 'package:unimarket/core/injection_container.dart';
import 'package:unimarket/presentation/pages/order_detail/order_detail_page.dart';
import 'package:unimarket/presentation/pages/product_review/product_review_page.dart';
import 'package:unimarket/presentation/viewmodels/profile/order_preferences_controller.dart';
import '../../viewmodels/orders/orders_cubit.dart';
import '../../viewmodels/orders/orders_state.dart';
import '../../models/order_model.dart';

class OrdersPage extends StatefulWidget {
  final bool deliveredOnly;

  const OrdersPage({super.key, this.deliveredOnly = false});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String selectedFilter = "Entregados";
  late final OrderPreferencesController _prefs;

  @override
  void initState() {
    super.initState();
    _prefs = sl<OrderPreferencesController>();
    _prefs.addListener(_onPrefsChanged);
  }

  void _onPrefsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _prefs.removeListener(_onPrefsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (_) => OrdersCubit()..loadOrders(),
        child: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            if (state is OrdersFailure) {
              return Center(child: Text(state.message));
            }

            if (state is OrdersLoaded) {
              final orders = state.orders;

              final filteredOrders = orders.where((o) {
                final isDelivered = o.status.toLowerCase() == "entregado";
                if (!_prefs.showOldOrders && isDelivered) {
                  return false;
                }

                if (selectedFilter == "Entregados") {
                  return isDelivered;
                }

                return o.status.toLowerCase() == "pendiente";
              }).toList();

              final visibleOrders = _prefs.groupByStore
                  ? _groupOrdersByStore(filteredOrders)
                  : null;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Mis pedidos",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildFilters(),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: _buildOrderPreferenceSummary(),
                  ),

                  const SizedBox(height: 20),

                  /// 🔥 LISTA
                  Expanded(
                    child: filteredOrders.isEmpty
                        ? const Center(
                            child: Text(
                              "No hay pedidos",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : _prefs.groupByStore
                            ? ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                itemCount: visibleOrders!.length,
                                itemBuilder: (context, index) {
                                  final section = visibleOrders[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: _buildStoreSection(
                                      section.key,
                                      section.orders,
                                    ),
                                  );
                                },
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                itemCount: filteredOrders.length,
                                itemBuilder: (context, index) {
                                  return _buildOrderCard(filteredOrders[index]);
                                },
                              ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// Filtros
  Widget _buildFilters() {
    final filters = ["Entregados", "Pendientes"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: filters.map((filter) {
        final isSelected = selectedFilter == filter;

        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () {
              setState(() => selectedFilter = filter);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.grey.shade400,
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrderPreferenceSummary() {
    final chips = <Widget>[
      _buildSummaryChip(
        _prefs.showOldOrders ? 'Historial visible' : 'Historial oculto',
        _prefs.showOldOrders ? Colors.green.shade700 : Colors.orange.shade700,
      ),
      const SizedBox(width: 8),
      _buildSummaryChip(
        _prefs.groupByStore ? 'Agrupado por tienda' : 'Lista simple',
        Colors.indigo.shade700,
      ),
      const SizedBox(width: 8),
      _buildSummaryChip(
        _prefs.notifyEstimatedArrival ? 'ETA activa' : 'ETA apagada',
        _prefs.notifyEstimatedArrival ? Colors.green.shade700 : Colors.grey.shade700,
      ),
    ];

    return Wrap(
      runSpacing: 8,
      children: chips,
    );
  }

  Widget _buildSummaryChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<_StoreOrdersSection> _groupOrdersByStore(List<OrderModel> orders) {
    final grouped = <String, List<OrderModel>>{};
    for (final order in orders) {
      grouped.putIfAbsent(order.storeName, () => []).add(order);
    }

    return grouped.entries
        .map((entry) => _StoreOrdersSection(entry.key, entry.value))
        .toList();
  }

  Widget _buildStoreSection(String storeName, List<OrderModel> orders) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.storefront_outlined, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    storeName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Text(
                  '${orders.length} pedido${orders.length == 1 ? '' : 's'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...orders.map((order) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildOrderCard(order),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel o) {
  final isDelivered = o.status.toLowerCase() == "entregado";
  
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderDetailPage(order: o)
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              /// Avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Icon(
                  o.icon,
                  size: 24,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 16),

              /// Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      o.storeName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${o.status} - ${o.date}",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              /// Flecha
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
          
          /// Botón de Calificar (solo si está entregado)
          if (isDelivered)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductReviewPage(
                          productId: o.id,
                          productName: o.storeName,
                          sellerName: o.storeName,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.star_outline, size: 18),
                  label: const Text('Calificar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade100,
                    foregroundColor: Colors.amber.shade800,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

}

class _StoreOrdersSection {
  final String key;
  final List<OrderModel> orders;

  _StoreOrdersSection(this.key, this.orders);
}
