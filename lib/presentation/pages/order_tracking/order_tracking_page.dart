import 'package:flutter/material.dart';
import '../../viewmodels/order_tracking/order_tracking_viewmodel.dart';
import '../../widgets/bottom_nav_custom.dart';
import '../order_confirmation/order_confirmation_page.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final OrderTrackingViewModel vm = OrderTrackingViewModel();

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
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: BottomNavCustom(
          selectedIndex: 2,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.of(context).pushReplacementNamed('/');
                break;
              case 1:
                Navigator.of(context).pushReplacementNamed('/promos');
                break;
              case 3:
                break;
              case 4:
                Navigator.of(context).pushReplacementNamed('/favorites');
                break;
            }
          },
          onCartTap: () => Navigator.of(context).pushNamed('/cart'),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        vm.restaurantName,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildDeliveryOptions(),
        Expanded(child: _buildMapPlaceholder()),
        _buildOrderStatus(),
        _buildConfirmButton(),
      ],
    );
  }

  Widget _buildDeliveryOptions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => vm.toggleDelivery(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: vm.isDeliverySelected ? const Color(0xFFF5A623) : Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Domicilio',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: vm.isDeliverySelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () => vm.toggleDelivery(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: !vm.isDeliverySelected ? const Color(0xFFF5A623) : Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Ir a recoger',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: !vm.isDeliverySelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.map_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'Mapa de seguimiento',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mostrando ruta hacia tu ubicación',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 100,
            left: 50,
            child: _buildMapMarker('Inicio', Icons.location_on, Colors.blue),
          ),

          Positioned(
            top: 200,
            left: 150,
            child: _buildMapMarker('Jeikol Pizza', Icons.restaurant, Colors.red),
          ),

          Positioned(
            top: 120,
            left: 70,
            child: CustomPaint(
              size: const Size(100, 80),
              painter: RoutePainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapMarker(String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0,0,0,0.12),
                blurRadius: 6,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0,0,0,0.12),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.5),
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estado de pedido',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          _buildTimeline(),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    final steps = vm.steps;
    return Column(
      children: steps.asMap().entries.map((entry) {
        final int index = entry.key;
        final TimelineStep step = entry.value;
        return _buildTimelineStep(step, index, steps.length);
      }).toList(),
    );
  }

  Widget _buildTimelineStep(TimelineStep step, int index, int totalSteps) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: step.isCompleted ? const Color(0xFFF5A623) : Colors.grey.shade300,
                shape: BoxShape.circle,
                border: Border.all(
                  color: step.isActive ? const Color(0xFFF5A623) : Colors.transparent,
                  width: 2,
                ),
              ),
              child: step.isCompleted ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
            ),

            if (index < totalSteps - 1)
              Container(
                width: 2,
                height: 40,
                color: step.isCompleted ? const Color(0xFFF5A623) : Colors.grey.shade300,
              ),
          ],
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (step.title.isNotEmpty)
                Text(
                  step.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: step.isActive ? Colors.black87 : Colors.grey.shade600,
                  ),
                ),

              Text(
                step.subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: step.isActive ? Colors.grey.shade700 : Colors.grey.shade500,
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            // Navigate to full-screen confirmation
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const OrderConfirmationPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF5A623),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: const Text(
            'Confirmar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // Bottom navigation replaced by shared BottomNavCustom
}

class RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF5A623)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.3, size.width * 0.7, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.7, size.width, size.height);

    canvas.drawPath(path, paint);

    final dotPaint = Paint()..color = const Color(0xFFF5A623)..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(20, 5), 4, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.4), 4, dotPaint);
    canvas.drawCircle(Offset(size.width, size.height), 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
