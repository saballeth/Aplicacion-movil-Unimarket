import 'package:equatable/equatable.dart';

/// Estados para el manejo de datos bancarios
abstract class BankDataState extends Equatable {
  const BankDataState();

  @override
  List<Object?> get props => [];
}

class BankDataInitial extends BankDataState {
  const BankDataInitial();
}

class BankDataLoading extends BankDataState {
  const BankDataLoading();
}

class BankDataLoaded extends BankDataState {
  final BankDataModel bankData;

  const BankDataLoaded(this.bankData);

  @override
  List<Object?> get props => [bankData];
}

class BankDataUpdated extends BankDataState {
  final BankDataModel bankData;

  const BankDataUpdated(this.bankData);

  @override
  List<Object?> get props => [bankData];
}

class WithdrawalProcessing extends BankDataState {
  const WithdrawalProcessing();
}

class WithdrawalSuccess extends BankDataState {
  final double amount;
  final String transactionId;

  const WithdrawalSuccess({required this.amount, required this.transactionId});

  @override
  List<Object?> get props => [amount, transactionId];
}

class BankDataError extends BankDataState {
  final String message;

  const BankDataError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Modelo de datos bancarios
class BankDataModel extends Equatable {
  final int id;
  final String bankName;
  final String accountNumber;
  final String accountHolderName;
  final String accountType; // 'Cuenta Corriente', 'Cuenta Ahorros'
  final String bankCode;
  final bool isVerified;
  final double availableBalance;
  final double totalEarnings;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const BankDataModel({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolderName,
    required this.accountType,
    required this.bankCode,
    required this.isVerified,
    required this.availableBalance,
    required this.totalEarnings,
    required this.createdAt,
    this.updatedAt,
  });

  BankDataModel copyWith({
    int? id,
    String? bankName,
    String? accountNumber,
    String? accountHolderName,
    String? accountType,
    String? bankCode,
    bool? isVerified,
    double? availableBalance,
    double? totalEarnings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BankDataModel(
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      accountType: accountType ?? this.accountType,
      bankCode: bankCode ?? this.bankCode,
      isVerified: isVerified ?? this.isVerified,
      availableBalance: availableBalance ?? this.availableBalance,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    bankName,
    accountNumber,
    accountHolderName,
    accountType,
    bankCode,
    isVerified,
    availableBalance,
    totalEarnings,
    createdAt,
    updatedAt,
  ];
}
