import 'package:equatable/equatable.dart';

/// Estados para el manejo de reportes
abstract class ReportsState extends Equatable {
  const ReportsState();
  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {
  const ReportsInitial();
}

class ReportsLoading extends ReportsState {
  const ReportsLoading();
}

class ReportsLoaded extends ReportsState {
  final ReportsData data;

  const ReportsLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class ReportsError extends ReportsState {
  final String message;

  const ReportsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ReportsExporting extends ReportsState {
  const ReportsExporting();
}

class ReportsExported extends ReportsState {
  final String filePath;

  const ReportsExported(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

/// Modelo de datos de reportes
class ReportsData extends Equatable {
  final double totalSales;
  final int totalOrders;
  final int totalUsers;
  final int totalBusinesses;
  final List<TopSeller> topSellers;
  final List<SalesData> salesData;
  final UserGrowthData userGrowth;
  final DateTime reportDate;

  const ReportsData({
    required this.totalSales,
    required this.totalOrders,
    required this.totalUsers,
    required this.totalBusinesses,
    required this.topSellers,
    required this.salesData,
    required this.userGrowth,
    required this.reportDate,
  });

  @override
  List<Object?> get props => [
    totalSales,
    totalOrders,
    totalUsers,
    totalBusinesses,
    topSellers,
    salesData,
    userGrowth,
    reportDate,
  ];
}

class TopSeller extends Equatable {
  final int rank;
  final String name;
  final double revenue;
  final int sales;

  const TopSeller({
    required this.rank,
    required this.name,
    required this.revenue,
    required this.sales,
  });

  @override
  List<Object?> get props => [rank, name, revenue, sales];
}

class SalesData extends Equatable {
  final DateTime date;
  final double amount;
  final int orderCount;

  const SalesData({
    required this.date,
    required this.amount,
    required this.orderCount,
  });

  @override
  List<Object?> get props => [date, amount, orderCount];
}

class UserGrowthData extends Equatable {
  final int newUsersToday;
  final int newUsersThisWeek;
  final int newUsersThisMonth;
  final double growthPercentage;

  const UserGrowthData({
    required this.newUsersToday,
    required this.newUsersThisWeek,
    required this.newUsersThisMonth,
    required this.growthPercentage,
  });

  @override
  List<Object?> get props => [
    newUsersToday,
    newUsersThisWeek,
    newUsersThisMonth,
    growthPercentage,
  ];
}
