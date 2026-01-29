import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../viewmodels/order_confirmation/order_confirmation_viewmodel.dart';

class OrderConfirmationPage extends StatefulWidget {
  const OrderConfirmationPage({super.key});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  final OrderConfirmationViewModel vm = OrderConfirmationViewModel();

  @override
  void initState() {
    super.initState();
    vm.addListener(_onVmChanged);
  }

  void _onVmChanged() => setState(() {});

  @override
  void dispose() {
    vm.removeListener(_onVmChanged);
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cheerful animated Lottie
                Center(
                  child: SizedBox(
                    height: 180,
                    child: Lottie.network(
                      'https://assets10.lottiefiles.com/packages/lf20_touohxv0.json',
                      fit: BoxFit.contain,
                      repeat: false,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  vm.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                ),

                const SizedBox(height: 12),

                Text(
                  vm.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Close the confirmation and navigate back to home
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5A623),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Volver al inicio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () {
                    // Optionally view order history
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    // In a real app you might navigate to Orders screen
                  },
                  child: const Text('Ver historial de pedidos'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
