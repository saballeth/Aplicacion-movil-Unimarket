import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/order_model.dart';
import 'orders_state.dart';
import 'package:flutter/material.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());

  Future<void> loadOrders() async {
    emit(OrdersLoading());
    try {
      // Simulated data; replace with repository calls in domain layer.
      await Future.delayed(const Duration(milliseconds: 300));
      final orders = <OrderModel>[
        OrderModel(id: 'ORD001', storeName: 'Accesorios Martina', status: 'Entregado', date: '23/07/2024', statusColor: Colors.green, icon: Icons.shopping_bag),
        OrderModel(id: 'ORD002', storeName: 'Mr FOX', status: 'Entregado', date: '23/07/2024', statusColor: Colors.green, icon: Icons.restaurant),
        OrderModel(id: 'ORD003', storeName: 'Jeikol Pizza', status: 'Entregado', date: '23/07/2024', statusColor: Colors.green, icon: Icons.local_pizza),
      ];
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrdersFailure('No se pudieron cargar los pedidos'));
    }
  }
}
