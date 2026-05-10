import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/core/injection_container.dart';
import 'package:unimarket/core/utils/dialog_helper.dart';
import 'package:unimarket/presentation/viewmodels/admin/reports_cubit.dart';
import 'package:unimarket/presentation/viewmodels/admin/reports_state.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReportsCubit>()..loadReports('Hoy'),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Reportes'),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: BlocConsumer<ReportsCubit, ReportsState>(
          listener: (context, state) {
            if (state is ReportsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ReportsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ReportsLoaded) {
              final data = state.data;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Period selector
                    SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: ['Hoy', 'Esta semana', 'Este mes', 'Este año']
                            .map((period) {
                              final isSelected = period == 'Hoy';
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    context.read<ReportsCubit>().loadReports(
                                      period,
                                    );
                                  },
                                  label: Text(period),
                                  selectedColor: const Color(0xFF4B2AAD),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              );
                            })
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Key metrics
                    _buildMetricsSection(data),
                    const SizedBox(height: 24),
                    // Sales chart placeholder
                    _buildChartSection(),
                    const SizedBox(height: 24),
                    // Top sellers
                    _buildTopSellersSection(data),
                    const SizedBox(height: 24),
                    // User growth
                    _buildUserGrowthSection(data),
                    const SizedBox(height: 24),
                    // Export button
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final confirm = await DialogHelper.showConfirmationDialog(
                                context: context,
                                title: 'Exportar PDF',
                                message: '¿Deseas descargar los reportes en formato PDF?',
                                confirmText: 'Descargar',
                                cancelText: 'Cancelar',
                                confirmColor: Colors.red,
                              );
                              if (confirm && context.mounted) {
                                DialogHelper.showLoadingDialog(
                                  context: context,
                                  message: 'Generando PDF...',
                                );
                                context.read<ReportsCubit>().exportReportsPDF();
                                
                                Future.delayed(const Duration(seconds: 2), () {
                                  if (context.mounted) {
                                    DialogHelper.dismissLoadingDialog(context);
                                    DialogHelper.showSuccessDialog(
                                      context: context,
                                      title: 'Éxito',
                                      message: 'El archivo PDF se ha generado correctamente.',
                                    );
                                  }
                                });
                              }
                            },
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text('PDF'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final confirm = await DialogHelper.showConfirmationDialog(
                                context: context,
                                title: 'Exportar Excel',
                                message: '¿Deseas descargar los reportes en formato Excel?',
                                confirmText: 'Descargar',
                                cancelText: 'Cancelar',
                                confirmColor: Colors.green,
                              );
                              if (confirm && context.mounted) {
                                DialogHelper.showLoadingDialog(
                                  context: context,
                                  message: 'Generando Excel...',
                                );
                                context.read<ReportsCubit>().exportReportsExcel();
                                
                                Future.delayed(const Duration(seconds: 2), () {
                                  if (context.mounted) {
                                    DialogHelper.dismissLoadingDialog(context);
                                    DialogHelper.showSuccessDialog(
                                      context: context,
                                      title: 'Éxito',
                                      message: 'El archivo Excel se ha generado correctamente.',
                                    );
                                  }
                                });
                              }
                            },
                            icon: const Icon(Icons.table_chart),
                            label: const Text('Excel'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            if (state is ReportsError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildMetricsSection(ReportsData data) {
    final totalSales = data.totalSales;
    final totalOrders = data.totalOrders.toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Métricas Clave',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Ventas',
                '\$${totalSales.toStringAsFixed(0)}',
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard('Órdenes', totalOrders.toStringAsFixed(0), Colors.green),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard('Usuarios', data.totalUsers.toString(), Colors.purple),
            ),
            const SizedBox(width: 12),
            Expanded(child: _buildMetricCard('Negocios', data.totalBusinesses.toString(), Colors.orange)),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ventas Diarias',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart, size: 40, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    'Gráfico de ventas',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSellersSection(ReportsData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Emprendedores',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...data.topSellers.map((seller) {
          return _buildListItem(
            '${seller.rank}. ${seller.name}',
            '\$${seller.revenue.toStringAsFixed(0)}',
          );
        }),
      ],
    );
  }

  Widget _buildUserGrowthSection(ReportsData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Crecimiento de Usuarios',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '+${data.userGrowth.newUsersThisMonth}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  Text(
                    'Nuevos usuarios',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              Icon(Icons.trending_up, color: Colors.green[700], size: 32),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4B2AAD),
            ),
          ),
        ],
      ),
    );
  }
}
