import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/core/injection_container.dart';
import 'package:unimarket/presentation/viewmodels/admin/admin_users_cubit.dart';
import 'package:unimarket/presentation/viewmodels/admin/admin_users_state.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdminUsersCubit>()..loadUsers(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Gestionar Usuarios'),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: BlocConsumer<AdminUsersCubit, AdminUsersState>(
          listener: (context, state) {
            if (state is AdminUsersError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is AdminUserDeleted || state is AdminUserUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state is AdminUserDeleted
                        ? 'Usuario eliminado'
                        : 'Usuario actualizado',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<AdminUsersCubit>().loadUsers();
            }
          },
          builder: (context, state) {
            if (state is AdminUsersLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AdminUsersLoaded) {
              final users = state.users;

              if (users.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_off, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        'No hay usuarios',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                itemBuilder: (context, index) =>
                    _buildUserCard(context, users[index]),
              );
            }

            if (state is AdminUsersError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, AdminUserModel user) {
    Color statusColor = user.isActive ? Colors.green : Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  user.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(
                label: Text(user.role),
                backgroundColor: const Color(0xFF4B2AAD).withOpacity(0.1),
              ),
              Text(
                'Desde ${user.joinDate.toString().split(' ')[0]}',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showUserDetailsDialog(context, user),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('Ver'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4B2AAD),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _toggleUserStatus(context, user),
                  icon: Icon(
                    user.isActive ? Icons.lock : Icons.lock_open,
                    size: 16,
                  ),
                  label: Text(user.isActive ? 'Suspender' : 'Activar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showUserDetailsDialog(BuildContext context, AdminUserModel user) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(user.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Email:', user.email),
            _buildDetailRow('Rol:', user.role),
            _buildDetailRow('Estado:', user.status),
            _buildDetailRow(
              'Registrado:',
              user.joinDate.toString().split(' ')[0],
            ),
            _buildDetailRow('Total Órdenes:', '${user.totalOrders}'),
            _buildDetailRow(
              'Gastado:',
              '\$${user.totalSpent.toStringAsFixed(2)}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<AdminUsersCubit>().deleteUser(user.id);
              Navigator.pop(dialogContext);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  void _toggleUserStatus(BuildContext context, AdminUserModel user) {
    if (user.isActive) {
      context.read<AdminUsersCubit>().suspendUser(user.id);
    } else {
      context.read<AdminUsersCubit>().activateUser(user.id);
    }
  }
}
