import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/core/injection_container.dart';
import 'package:unimarket/presentation/viewmodels/notifications/notifications_cubit.dart';
import 'package:unimarket/presentation/viewmodels/profile/profile_cubit.dart';
import 'package:unimarket/presentation/viewmodels/profile/profile_state.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late final NotificationsCubit _notificationsCubit;
  late final ProfileCubit _profileCubit;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _notificationsCubit = sl<NotificationsCubit>();
    _profileCubit = sl<ProfileCubit>();

    // Load notifications when profile is loaded
    _profileCubit.stream.listen((state) {
      if (state is ProfileLoaded) {
        _notificationsCubit.loadNotifications(state.user.id, state.user.role);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider<NotificationsCubit>(
      create: (_) => _notificationsCubit,
      child: Scaffold(
        backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text(
            'Notificaciones',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          backgroundColor: isDarkMode ? const Color(0xFF1B1B1B) : Colors.white,
          foregroundColor: isDarkMode ? Colors.white : Colors.black,
          elevation: 0,
          actions: [
            // Botón para eliminar notificaciones antiguas
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Center(
                    child: Tooltip(
                      message: 'Eliminar notificaciones leídas',
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _showDeleteOldNotificationsDialog(
                              context,
                              isDarkMode,
                              _notificationsCubit,
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.delete_sweep_outlined,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                final unreadCount = state is NotificationsLoaded
                    ? state.notifications.where((n) => !n.isRead).length
                    : 0;

                return Container(
                  color: isDarkMode ? const Color(0xFF1B1B1B) : Colors.white,
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        labelColor: isDarkMode ? Colors.white : Colors.black87,
                        unselectedLabelColor: isDarkMode
                            ? Colors.grey[500]
                            : Colors.grey[600],
                        indicatorColor: const Color(0xFF4B2AAD),
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: [
                          const Tab(text: 'Todas'),
                          Tab(
                            text: unreadCount > 0
                                ? 'No leídas ($unreadCount)'
                                : 'No leídas',
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NotificationsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            if (state is NotificationsLoaded) {
              final allNotifications = state.notifications;
              final unreadNotifications = allNotifications
                  .where((n) => !n.isRead)
                  .toList();

              return TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Todas las notificaciones
                  _buildNotificationsList(
                    allNotifications,
                    isDarkMode,
                    _notificationsCubit,
                  ),
                  // Tab 2: Solo no leídas
                  _buildNotificationsList(
                    unreadNotifications,
                    isDarkMode,
                    _notificationsCubit,
                    onlyUnread: true,
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

  Widget _buildNotificationsList(
    List<dynamic> notifications,
    bool isDarkMode,
    NotificationsCubit cubit, {
    bool onlyUnread = false,
  }) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              onlyUnread
                  ? Icons.check_circle_outline
                  : Icons.notifications_off_outlined,
              size: 80,
              color: isDarkMode ? Colors.grey[600] : Colors.grey[300],
            ),
            const SizedBox(height: 20),
            Text(
              onlyUnread
                  ? 'Todas las notificaciones leídas'
                  : 'No tienes notificaciones',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              onlyUnread
                  ? 'Estás al día con todo'
                  : 'Vuelve pronto para actualizaciones',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: _buildNotificationCard(
            context,
            notification,
            isDarkMode,
            cubit,
          ),
        );
      },
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    dynamic notification,
    bool isDarkMode,
    NotificationsCubit cubit,
  ) {
    final color = _getNotificationColor(notification.type);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          cubit.markAsRead(notification.id);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead
                ? (isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey.shade50)
                : (isDarkMode
                      ? const Color(0xFF2A2A2A)
                      : const Color(0xFFFAF5FF)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: notification.isRead
                  ? (isDarkMode ? Colors.grey[700]! : Colors.grey[200]!)
                  : color.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon container with gradient background
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withOpacity(0.8), color],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _getNotificationIcon(notification.type),
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Title and body
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (!notification.isRead) ...[
                              const SizedBox(width: 8),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.withOpacity(0.5),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (notification.body != null &&
                            notification.body!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            notification.body!,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getTimeAgo(notification.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.grey[600] : Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getNotificationTypeLabel(notification.type),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'order_update':
        return Icons.local_shipping_outlined;
      case 'business_update':
        return Icons.trending_up_outlined;
      case 'consumer_update':
        return Icons.people_alt_outlined;
      case 'promo':
        return Icons.local_offer_outlined;
      case 'message':
        return Icons.mail_outline;
      case 'system':
      default:
        return Icons.info_outline;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'order_update':
        return const Color(0xFF0066FF); // Blue
      case 'business_update':
        return const Color(0xFF00AA00); // Green
      case 'consumer_update':
        return const Color(0xFFFF6B00); // Orange
      case 'promo':
        return const Color(0xFFFFB300); // Amber
      case 'message':
        return const Color(0xFFEE4B6B); // Pink
      case 'system':
      default:
        return const Color(0xFF4B2AAD); // Purple
    }
  }

  String _getNotificationTypeLabel(String type) {
    switch (type) {
      case 'order_update':
        return 'Orden';
      case 'business_update':
        return 'Negocio';
      case 'consumer_update':
        return 'Consumidor';
      case 'promo':
        return 'Promoción';
      case 'message':
        return 'Mensaje';
      case 'system':
      default:
        return 'Sistema';
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays}d';
    } else {
      return dateTime.toString().split(' ')[0];
    }
  }

  void _showDeleteOldNotificationsDialog(
    BuildContext context,
    bool isDarkMode,
    NotificationsCubit cubit,
  ) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              final readCount = state is NotificationsLoaded
                  ? state.notifications.where((n) => n.isRead).length
                  : 0;
              final unreadCount = state is NotificationsLoaded
                  ? state.notifications.where((n) => !n.isRead).length
                  : 0;

              return AlertDialog(
                backgroundColor: isDarkMode
                    ? const Color(0xFF1B1B1B)
                    : Colors.white,
                title: Text(
                  'Limpiar notificaciones',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.grey[900]
                            : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF4B2AAD).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: const Color(0xFF4B2AAD),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Notificaciones leídas: $readCount',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: const Color(0xFF4B2AAD),
                                size: 8,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Notificaciones sin leer: $unreadCount (protegidas)',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[700],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Se eliminarán solo las notificaciones que ya has leído. Las notificaciones sin leer se mantendrán protegidas.',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                  if (readCount > 0)
                    FilledButton(
                      onPressed: () {
                        _deleteReadNotifications(cubit);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '$readCount notificación${readCount > 1 ? 'es' : ''} leída${readCount > 1 ? 's' : ''} eliminada${readCount > 1 ? 's' : ''}',
                            ),
                            backgroundColor: Colors.green.shade600,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF4B2AAD),
                      ),
                      child: const Text('Eliminar leídas'),
                    )
                  else
                    FilledButton(
                      onPressed: null,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey,
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: const Text('No hay para eliminar'),
                    ),
                ],
              );
            },
          );
        },
      );
    }
  }

  void _deleteReadNotifications(NotificationsCubit cubit) {
    cubit.deleteReadNotifications();
  }
}
