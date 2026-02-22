import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/constants/app_colors.dart';
import 'package:unimarket/presentation/pages/order_detail/order_detail_page.dart';
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
                if (selectedFilter == "Entregados") {
                  return o.status.toLowerCase() == "entregado";
                } else {
                  return o.status.toLowerCase() == "pendiente";
                }
              }).toList();

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
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: filteredOrders.length,
                            itemBuilder: (context, index) {
                              return _buildOrderCard(
                                  filteredOrders[index]);
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

  Widget _buildOrderCard(OrderModel o) {
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
      child: Row(
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
    ),
  );
}

}
