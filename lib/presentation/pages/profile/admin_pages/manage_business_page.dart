import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/core/injection_container.dart';
import 'package:unimarket/presentation/viewmodels/admin/admin_businesses_products_cubit.dart';
import 'package:unimarket/presentation/viewmodels/admin/admin_businesses_products_state.dart';

class ManageBusinessPage extends StatelessWidget {
  const ManageBusinessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdminBusinessesCubit>()..loadBusinesses(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Gestionar Emprendimientos'),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: BlocConsumer<AdminBusinessesCubit, AdminBusinessesState>(
          listener: (context, state) {
            if (state is AdminBusinessesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AdminBusinessesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AdminBusinessesLoaded) {
              final businesses = state.businesses;

              if (businesses.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.business_center,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay emprendimientos',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: businesses.length,
                itemBuilder: (context, index) =>
                    _buildBusinessCard(context, businesses[index]),
              );
            }

            if (state is AdminBusinessesError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildBusinessCard(BuildContext context, AdminBusinessModel business) {
    Color statusColor = business.status == 'Activo' ? Colors.green : Colors.red;

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      business.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Propietario: ${business.owner}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
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
                  business.status,
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatBubble('${business.products}', 'Productos'),
              _buildStatBubble('${business.sales}', 'Ventas'),
              _buildStatBubble('${business.rating}', 'Rating'),
            ],
          ),
          const SizedBox(height: 12),
          Chip(
            label: Text(business.category),
            backgroundColor: const Color(0xFF4B2AAD).withOpacity(0.1),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _showBusinessDetailsDialog(context, business),
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
                  onPressed: () => _toggleBusinessStatus(context, business),
                  icon: Icon(
                    business.status == 'Activo'
                        ? Icons.block
                        : Icons.check_circle,
                    size: 16,
                  ),
                  label: Text(
                    business.status == 'Activo' ? 'Suspender' : 'Activar',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: business.status == 'Activo'
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBubble(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4B2AAD),
          ),
        ),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }

  void _showBusinessDetailsDialog(
    BuildContext context,
    AdminBusinessModel business,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(business.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Propietario:', business.owner),
            _buildDetailRow('Categoría:', business.category),
            _buildDetailRow('Productos:', '${business.products}'),
            _buildDetailRow('Ventas:', '${business.sales}'),
            _buildDetailRow('Rating:', '${business.rating} ⭐'),
            _buildDetailRow(
              'Ingresos:',
              '\$${business.revenue.toStringAsFixed(2)}',
            ),
            _buildDetailRow('Estado:', business.status),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cerrar'),
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

  void _toggleBusinessStatus(
    BuildContext context,
    AdminBusinessModel business,
  ) {
    if (business.status == 'Activo') {
      context.read<AdminBusinessesCubit>().suspendBusiness(business.id);
    } else {
      context.read<AdminBusinessesCubit>().activateBusiness(business.id);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          business.status == 'Activo'
              ? 'Emprendimiento suspendido'
              : 'Emprendimiento activado',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class BusinessItem {
  final int id;
  final String name;
  final String owner;
  final String category;
  final int products;
  final int sales;
  final double rating;
  final String status;

  BusinessItem({
    required this.id,
    required this.name,
    required this.owner,
    required this.category,
    required this.products,
    required this.sales,
    required this.rating,
    required this.status,
  });
}
