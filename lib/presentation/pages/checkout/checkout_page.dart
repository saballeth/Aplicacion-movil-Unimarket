import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/core/injection_container.dart';
import 'package:unimarket/presentation/models/cart_item.dart';
import 'package:unimarket/presentation/viewmodels/checkout/checkout_cubit.dart';
import 'package:unimarket/presentation/viewmodels/checkout/checkout_state.dart';
import 'package:unimarket/presentation/pages/checkout/widgets/address_step_widget.dart';
import 'package:unimarket/presentation/pages/checkout/widgets/shipping_step_widget.dart';
import 'package:unimarket/presentation/pages/checkout/widgets/payment_step_widget.dart';
import 'package:unimarket/presentation/pages/order_confirmation/order_confirmation_page.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final String storeId;
  final String storeName;
  final String userId;

  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.storeId,
    required this.storeName,
    required this.userId,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late CheckoutCubit _checkoutCubit;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _checkoutCubit = sl<CheckoutCubit>();
    // Inicializar el checkout
    _checkoutCubit.initCheckout(
      userId: widget.userId,
      storeId: widget.storeId,
      storeName: widget.storeName,
      cartItems: widget.cartItems,
    );
  }

  @override
  void dispose() {
    // No cerrar el cubit aquí, será manejado por BlocProvider
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckoutCubit>(
      create: (_) => _checkoutCubit,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Checkout',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            // Mostrar indicador de progreso
            Widget progressIndicator = _buildProgressIndicator(state);

            if (state is CheckoutLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CheckoutError) {
              return _buildErrorWidget(context, state);
            }

            if (state is CheckoutStep1Addresses) {
              return Column(
                children: [
                  progressIndicator,
                  Expanded(
                    child: AddressStepWidget(
                      addresses: state.addresses,
                      selectedAddress: state.selectedAddress,
                      onAddressSelected: (address) {
                        context.read<CheckoutCubit>().selectAddress(address);
                      },
                      onNext: () {
                        context.read<CheckoutCubit>().proceedToShipping();
                      },
                    ),
                  ),
                ],
              );
            }

            if (state is CheckoutStep2Shipping) {
              return Column(
                children: [
                  progressIndicator,
                  Expanded(
                    child: ShippingStepWidget(
                      shippingOptions: state.shippingOptions,
                      selectedShipping: state.selectedShipping,
                      subtotal: state.subtotal,
                      address: state.address,
                      onShippingSelected: (shipping) {
                        context.read<CheckoutCubit>().selectShipping(shipping);
                      },
                      onBack: () {
                        context.read<CheckoutCubit>().goBackToAddresses();
                      },
                      onNext: () {
                        context.read<CheckoutCubit>().proceedToPayment();
                      },
                    ),
                  ),
                ],
              );
            }

            if (state is CheckoutStep3Payment) {
              return Column(
                children: [
                  progressIndicator,
                  Expanded(
                    child: PaymentStepWidget(
                      address: state.address,
                      shippingOption: state.shippingOption,
                      subtotal: state.subtotal,
                      shippingCost: state.shippingCost,
                      taxAmount: state.taxAmount,
                      totalAmount: state.totalAmount,
                      onBack: () {
                        context.read<CheckoutCubit>().goBackToShipping();
                      },
                      onPayment: (paymentMethod, paymentDetails) {
                        context.read<CheckoutCubit>().processPayment(
                          paymentMethod: paymentMethod,
                          paymentDetails: paymentDetails,
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            if (state is CheckoutProcessing) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Procesando pago...'),
                  ],
                ),
              );
            }

            if (state is CheckoutSuccess) {
              // Navegar a página de confirmación
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => OrderConfirmationPage(order: state.order),
                  ),
                  (route) => route.isFirst,
                );
              });
            }

            return const Center(child: Text('Estado desconocido'));
          },
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(CheckoutState state) {
    int step = 0;
    if (state is CheckoutStep2Shipping) step = 1;
    if (state is CheckoutStep3Payment) step = 2;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      color: Colors.white,
      child: Row(
        children: List.generate(3, (index) {
          bool isActive = index <= step;
          bool isDone = index < step;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? const Color(0xFF4B2AAD)
                              : Colors.grey[300],
                        ),
                        child: Center(
                          child: isDone
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 24,
                                )
                              : Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ['Dirección', 'Envío', 'Pago'][index],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isActive ? Colors.black : Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                if (index < 2)
                  Container(
                    height: 2,
                    color: index < step
                        ? const Color(0xFF4B2AAD)
                        : Colors.grey[300],
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, CheckoutError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(state.message),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              _checkoutCubit.initCheckout(
                userId: widget.userId,
                storeId: widget.storeId,
                storeName: widget.storeName,
                cartItems: widget.cartItems,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4B2AAD),
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
