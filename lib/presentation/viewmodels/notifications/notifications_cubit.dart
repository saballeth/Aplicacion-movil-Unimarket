import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unimarket/domain/entities/notification_entity.dart';
import 'package:unimarket/domain/entities/user_role.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsInitial());

  // Mock data - In a real app, this would come from a repository
  final List<NotificationEntity> _allNotifications = [];

  Future<void> loadNotifications(String userId, UserRole userRole) async {
    try {
      emit(const NotificationsLoading());

      // Simulated API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // In a real app, fetch from repository
      // For now, using mock data
      final notifications = _getMockNotifications(userId, userRole);

      emit(NotificationsLoaded(notifications: notifications));
    } catch (e) {
      emit(NotificationsError(message: e.toString()));
    }
  }

  Future<void> markAsRead(String notificationId) async {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      final updatedNotifications = currentState.notifications.map((n) {
        if (n.id == notificationId) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();

      emit(NotificationsLoaded(notifications: updatedNotifications));

      // In a real app, persist to database
    }
  }

  Future<void> markAllAsRead() async {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      final updatedNotifications = currentState.notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();

      emit(NotificationsLoaded(notifications: updatedNotifications));

      // In a real app, persist to database
    }
  }

  List<NotificationEntity> _getMockNotifications(
    String userId,
    UserRole userRole,
  ) {
    final now = DateTime.now();

    if (userRole.isAdmin) {
      // Admin receives updates about entrepreneurs and consumers
      return [
        NotificationEntity(
          id: '1',
          userId: userId,
          type: 'business_update',
          title: 'Nuevo emprendedor registrado',
          body: 'Juan García ha registrado su tienda de artesanías',
          isRead: false,
          createdAt: now.subtract(const Duration(hours: 2)),
        ),
        NotificationEntity(
          id: '2',
          userId: userId,
          type: 'consumer_update',
          title: 'Actividad de consumidor',
          body: 'María López ha realizado su primera compra',
          isRead: false,
          createdAt: now.subtract(const Duration(hours: 4)),
        ),
        NotificationEntity(
          id: '3',
          userId: userId,
          type: 'business_update',
          title: 'Emprendedor con bajo desempeño',
          body: 'Carlos Mendoza tiene 0 ventas en los últimos 30 días',
          isRead: true,
          createdAt: now.subtract(const Duration(days: 1)),
        ),
        NotificationEntity(
          id: '4',
          userId: userId,
          type: 'consumer_update',
          title: 'Reportes de consumidores',
          body: '5 nuevos reportes requieren atención',
          isRead: true,
          createdAt: now.subtract(const Duration(days: 2)),
        ),
      ];
    } else if (userRole.isEntrepreneur) {
      // Entrepreneurs receive business notifications
      return [
        NotificationEntity(
          id: '5',
          userId: userId,
          type: 'business_update',
          title: 'Nueva orden recibida',
          body: 'Has recibido una orden por \$45.99',
          isRead: false,
          createdAt: now.subtract(const Duration(minutes: 30)),
        ),
        NotificationEntity(
          id: '6',
          userId: userId,
          type: 'business_update',
          title: 'Producto bajo stock',
          body: 'Solo quedan 3 unidades de "Camiseta Azul"',
          isRead: false,
          createdAt: now.subtract(const Duration(hours: 1)),
        ),
        NotificationEntity(
          id: '7',
          userId: userId,
          type: 'business_update',
          title: 'Reseña del cliente',
          body: 'Ana Rodríguez dejó una reseña de 5 estrellas',
          isRead: true,
          createdAt: now.subtract(const Duration(hours: 3)),
        ),
        NotificationEntity(
          id: '8',
          userId: userId,
          type: 'system',
          title: 'Recordatorio de pago',
          body: 'Tu comisión de la semana está disponible',
          isRead: true,
          createdAt: now.subtract(const Duration(days: 1)),
        ),
      ];
    } else {
      // Consumers receive order and general notifications
      return [
        NotificationEntity(
          id: '9',
          userId: userId,
          type: 'order_update',
          title: 'Tu orden ha sido enviada',
          body: 'Pedido #12345 está en camino',
          isRead: false,
          createdAt: now.subtract(const Duration(hours: 1)),
        ),
        NotificationEntity(
          id: '10',
          userId: userId,
          type: 'promo',
          title: 'Oferta especial para ti',
          body: 'Descuento del 20% en ropa deportiva',
          isRead: false,
          createdAt: now.subtract(const Duration(hours: 2)),
        ),
        NotificationEntity(
          id: '11',
          userId: userId,
          type: 'order_update',
          title: 'Tu orden ha sido entregada',
          body: 'Pedido #12340 entregado exitosamente',
          isRead: true,
          createdAt: now.subtract(const Duration(days: 1)),
        ),
      ];
    }
  }

  int getUnreadCount() {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      return currentState.notifications.where((n) => !n.isRead).length;
    }
    return 0;
  }

  Future<void> deleteReadNotifications() async {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      final unreadNotifications = currentState.notifications
          .where((n) => !n.isRead)
          .toList();

      emit(NotificationsLoaded(notifications: unreadNotifications));

      // In a real app, persist to database
    }
  }

  Future<void> deleteOldNotifications(DateTime beforeDate) async {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      final filteredNotifications = currentState.notifications
          .where((n) => n.createdAt.isAfter(beforeDate))
          .toList();

      emit(NotificationsLoaded(notifications: filteredNotifications));

      // In a real app, persist to database
    }
  }
}
