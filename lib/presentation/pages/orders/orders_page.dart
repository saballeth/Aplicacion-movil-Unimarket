import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../viewmodels/orders/orders_cubit.dart';
import '../../viewmodels/orders/orders_state.dart';
import '../../models/order_model.dart';

class OrdersPage extends StatelessWidget {
  final bool deliveredOnly;

  const OrdersPage({super.key, this.deliveredOnly = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(deliveredOnly ? 'Historial de pedidos' : 'Mis pedidos')),
      body: BlocProvider(
        create: (_) => OrdersCubit()..loadOrders(),
        child: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrdersLoaded) {
              final List<OrderModel> orders = state.orders;
              final displayOrders = deliveredOnly
                  ? orders.where((o) => o.status.toLowerCase() == 'entregado').toList()
                  : orders;

              if (displayOrders.isEmpty) {
                return Center(
                    child: Text(deliveredOnly ? 'No hay pedidos entregados' : 'No hay pedidos'));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: displayOrders.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final o = displayOrders[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Icon(o.icon, size: 20)),
                      title: Text(o.storeName),
                      subtitle: Text('${o.date} • ${o.id}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(o.status, style: TextStyle(color: o.statusColor)),
                          const SizedBox(height: 4),
                          const Icon(Icons.chevron_right)
                        ],
                      ),
                      onTap: () {
                        // Could navigate to a detail page here.
                      },
                    ),
                  );
                },
              );
            } else if (state is OrdersFailure) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
