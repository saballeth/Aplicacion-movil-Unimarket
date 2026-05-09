import 'package:flutter_bloc/flutter_bloc.dart';
import 'bank_data_state.dart';

class BankDataCubit extends Cubit<BankDataState> {
  BankDataCubit() : super(const BankDataInitial());

  // Sample data - replace with backend API calls
  late BankDataModel _bankData = BankDataModel(
    id: 1,
    bankName: 'Banco del País',
    accountNumber: '****2345',
    accountHolderName: 'Juan Pérez',
    accountType: 'Cuenta Corriente',
    bankCode: 'BP001',
    isVerified: true,
    availableBalance: 2450.00,
    totalEarnings: 12450.00,
    createdAt: DateTime.now(),
  );

  /// Load bank data
  void loadBankData() {
    emit(const BankDataLoading());
    try {
      // TODO: Replace with actual API call
      // final bankData = await entrepreneurRepository.getBankData();
      emit(BankDataLoaded(_bankData));
    } catch (e) {
      emit(BankDataError('Error al cargar datos bancarios: ${e.toString()}'));
    }
  }

  /// Update bank data
  void updateBankData({
    required String bankName,
    required String accountNumber,
    required String accountHolderName,
    required String accountType,
  }) {
    emit(const BankDataLoading());
    try {
      // TODO: Replace with actual API call
      // await entrepreneurRepository.updateBankData(...)
      _bankData = _bankData.copyWith(
        bankName: bankName,
        accountNumber: accountNumber,
        accountHolderName: accountHolderName,
        accountType: accountType,
        updatedAt: DateTime.now(),
      );
      emit(BankDataUpdated(_bankData));
      loadBankData();
    } catch (e) {
      emit(
        BankDataError('Error al actualizar datos bancarios: ${e.toString()}'),
      );
    }
  }

  /// Process withdrawal
  void requestWithdrawal(double amount) {
    emit(const WithdrawalProcessing());
    try {
      // TODO: Replace with actual API call
      // Validate amount
      if (amount <= 0) {
        throw Exception('El monto debe ser mayor a 0');
      }
      if (amount > _bankData.availableBalance) {
        throw Exception('Saldo insuficiente');
      }

      // Process withdrawal
      final transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';

      // Update balance
      _bankData = _bankData.copyWith(
        availableBalance: _bankData.availableBalance - amount,
      );

      emit(WithdrawalSuccess(amount: amount, transactionId: transactionId));

      loadBankData();
    } catch (e) {
      emit(BankDataError('Error al procesar retiro: ${e.toString()}'));
    }
  }

  /// Get transaction history (placeholder)
  void loadTransactionHistory() {
    // TODO: Implement transaction history loading
  }
}
