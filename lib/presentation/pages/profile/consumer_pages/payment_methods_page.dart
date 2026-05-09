import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/core/injection_container.dart';
import 'package:unimarket/presentation/viewmodels/payment/payment_methods_cubit.dart';
import 'package:unimarket/presentation/viewmodels/payment/payment_methods_state.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PaymentMethodsCubit>()..loadPaymentMethods(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Métodos de Pago'),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: BlocConsumer<PaymentMethodsCubit, PaymentMethodsState>(
          listener: (context, state) {
            if (state is PaymentMethodsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is PaymentMethodAdded ||
                state is PaymentMethodDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state is PaymentMethodAdded
                        ? 'Método de pago agregado'
                        : 'Método de pago eliminado',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<PaymentMethodsCubit>().loadPaymentMethods();
            }
          },
          builder: (context, state) {
            if (state is PaymentMethodsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PaymentMethodsLoaded) {
              final methods = state.methods;

              if (methods.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.credit_card_off,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay métodos de pago',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...methods.map(
                    (method) => _buildPaymentMethodCard(context, method),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showAddPaymentDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar método de pago'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B2AAD),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              );
            }

            if (state is PaymentMethodsError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    PaymentMethodModel method,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: method.isDefault ? const Color(0xFF4B2AAD) : Colors.grey[300]!,
          width: method.isDefault ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    _getCardIcon(method.issuer),
                    color: const Color(0xFF4B2AAD),
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method.issuer,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '•••• ${method.lastDigits}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
              if (method.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B2AAD).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Por defecto',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4B2AAD),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vencimiento: ${method.expiryDate}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  if (!method.isDefault)
                    PopupMenuItem(
                      onTap: () {
                        context
                            .read<PaymentMethodsCubit>()
                            .setDefaultPaymentMethod(method.id);
                      },
                      child: const Text('Establecer como predeterminado'),
                    ),
                  PopupMenuItem(
                    onTap: () =>
                        _confirmDeletePaymentMethod(context, method.id),
                    child: const Text(
                      'Eliminar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getCardIcon(String issuer) {
    switch (issuer.toLowerCase()) {
      case 'visa':
      case 'mastercard':
      case 'amex':
        return Icons.credit_card;
      default:
        return Icons.credit_card;
    }
  }

  void _showAddPaymentDialog(BuildContext context) {
    final cardController = TextEditingController();
    final cvvController = TextEditingController();
    final expiryController = TextEditingController();
    final holderController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Agregar Método de Pago'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cardController,
                decoration: const InputDecoration(
                  labelText: 'Número de tarjeta',
                  hintText: '0000 0000 0000 0000',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: expiryController,
                      decoration: const InputDecoration(
                        labelText: 'Vencimiento',
                        hintText: 'MM/YY',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        hintText: '000',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: holderController,
                decoration: const InputDecoration(
                  labelText: 'Nombre en la tarjeta',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4B2AAD),
            ),
            onPressed: () {
              context.read<PaymentMethodsCubit>().addPaymentMethod(
                cardNumber: cardController.text,
                expiryDate: expiryController.text,
                holderName: holderController.text,
                cvv: '000',
              );
              Navigator.pop(dialogContext);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _confirmDeletePaymentMethod(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar Método de Pago'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar este método de pago?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<PaymentMethodsCubit>().deletePaymentMethod(id);
              Navigator.pop(dialogContext);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
