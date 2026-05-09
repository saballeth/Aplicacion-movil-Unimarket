import 'package:flutter_bloc/flutter_bloc.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit() : super(const ReportsInitial());

  String _selectedPeriod = 'Este mes';

  /// Load reports data
  void loadReports(String period) {
    emit(const ReportsLoading());
    _selectedPeriod = period;
    try {
      // TODO: Replace with actual API call
      // final data = await adminRepository.getReports(period);

      final data = _generateReportsData(period);
      emit(ReportsLoaded(data));
    } catch (e) {
      emit(ReportsError('Error al cargar reportes: ${e.toString()}'));
    }
  }

  /// Generate sample reports data based on period
  ReportsData _generateReportsData(String period) {
    late double totalSales;
    late int totalOrders;
    late int newUsers;

    switch (period) {
      case 'Hoy':
        totalSales = 2450.00;
        totalOrders = 23;
        newUsers = 5;
        break;
      case 'Esta semana':
        totalSales = 12450.00;
        totalOrders = 145;
        newUsers = 28;
        break;
      case 'Este mes':
        totalSales = 45230.00;
        totalOrders = 567;
        newUsers = 123;
        break;
      case 'Este año':
        totalSales = 350000.00;
        totalOrders = 4234;
        newUsers = 890;
        break;
      default:
        totalSales = 45230.00;
        totalOrders = 567;
        newUsers = 123;
    }

    return ReportsData(
      totalSales: totalSales,
      totalOrders: totalOrders,
      totalUsers: 1234,
      totalBusinesses: 45,
      topSellers: [
        const TopSeller(
          rank: 1,
          name: 'Tienda de Ropa María',
          revenue: 12450.00,
          sales: 234,
        ),
        const TopSeller(
          rank: 2,
          name: 'Comidas Caseras Juan',
          revenue: 8900.00,
          sales: 89,
        ),
        const TopSeller(
          rank: 3,
          name: 'Tech Shop',
          revenue: 7230.00,
          sales: 156,
        ),
      ],
      salesData: _generateSalesData(period),
      userGrowth: UserGrowthData(
        newUsersToday: period == 'Hoy' ? 5 : 12,
        newUsersThisWeek: period.contains('semana') ? 28 : 45,
        newUsersThisMonth: newUsers,
        growthPercentage: 12.5,
      ),
      reportDate: DateTime.now(),
    );
  }

  /// Generate sales data for chart
  List<SalesData> _generateSalesData(String period) {
    final today = DateTime.now();
    final salesList = <SalesData>[];

    if (period == 'Hoy') {
      // Hourly data
      for (int i = 0; i < 24; i++) {
        salesList.add(
          SalesData(
            date: today.subtract(Duration(hours: 24 - i)),
            amount: (100 + (i * 50 % 300)).toDouble(),
            orderCount: (5 + (i % 10)).toInt(),
          ),
        );
      }
    } else if (period == 'Esta semana') {
      // Daily data
      for (int i = 0; i < 7; i++) {
        salesList.add(
          SalesData(
            date: today.subtract(Duration(days: 7 - i)),
            amount: (1500 + (i * 300 % 2000)).toDouble(),
            orderCount: (20 + (i * 5)).toInt(),
          ),
        );
      }
    } else if (period == 'Este mes') {
      // Weekly data
      for (int i = 0; i < 4; i++) {
        salesList.add(
          SalesData(
            date: today.subtract(Duration(days: (4 - i) * 7)),
            amount: (10000 + (i * 1000)).toDouble(),
            orderCount: (150 + (i * 50)).toInt(),
          ),
        );
      }
    } else {
      // Monthly data
      for (int i = 0; i < 12; i++) {
        salesList.add(
          SalesData(
            date: today.subtract(Duration(days: (12 - i) * 30)),
            amount: (25000 + (i * 2000)).toDouble(),
            orderCount: (400 + (i * 100)).toInt(),
          ),
        );
      }
    }

    return salesList;
  }

  /// Export reports as PDF
  void exportReportsPDF() {
    emit(const ReportsExporting());
    try {
      // TODO: Implement PDF export
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      emit(ReportsExported('/storage/reports_$timestamp.pdf'));
      loadReports(_selectedPeriod);
    } catch (e) {
      emit(ReportsError('Error al exportar PDF: ${e.toString()}'));
    }
  }

  /// Export reports as Excel
  void exportReportsExcel() {
    emit(const ReportsExporting());
    try {
      // TODO: Implement Excel export
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      emit(ReportsExported('/storage/reports_$timestamp.xlsx'));
      loadReports(_selectedPeriod);
    } catch (e) {
      emit(ReportsError('Error al exportar Excel: ${e.toString()}'));
    }
  }

  /// Get period comparison
  Map<String, dynamic> getPeriodComparison(
    String currentPeriod,
    String previousPeriod,
  ) {
    // TODO: Implement period comparison logic
    return {'salesChange': 12.5, 'ordersChange': 8.3, 'usersChange': 15.2};
  }
}
