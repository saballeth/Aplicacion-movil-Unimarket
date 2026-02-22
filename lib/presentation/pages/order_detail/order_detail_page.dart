import 'package:flutter/material.dart';
import '../../models/order_model.dart';

class OrderDetailPage extends StatefulWidget {
  final OrderModel order;
  final VoidCallback? onBack;

  const OrderDetailPage({
    super.key,
    required this.order,
    this.onBack,
  });

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed:
              widget.onBack ?? () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10),

            /// Nombre tienda
            Text(
              widget.order.storeName,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 25),

            /// Calificar
            const Text(
              "Califica tu pedido",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: _showRatingDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4B2CA3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.star,
                        color: Colors.yellow, size: 18),
                    SizedBox(width: 6),
                    Text(
                      "Calificar",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// Estado
            const Text(
              "Estado de pedido",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              widget.order.status,
              style: TextStyle(
                fontSize: 14,
                color: widget.order.statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 30),

            /// Productos
            const Text(
              "Productos",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _buildProductItem(),

            const SizedBox(height: 25),

            Divider(color: Colors.grey.shade300),

            const SizedBox(height: 20),

            /// Resumen
            const Text(
              "Resumen de pago",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _buildPriceRow("Precio", "8.000"),

            const SizedBox(height: 15),

            Divider(color: Colors.grey.shade300),

            const SizedBox(height: 15),

            _buildPriceRow(
              "Total de pago",
              "8.000",
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 MODAL DE CALIFICACIÓN
  void _showRatingDialog() {
    int tempRating = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                "Califica tu pedido",
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setModalState(() {
                            tempRating = index + 1;
                          });
                        },
                        icon: Icon(
                          index < tempRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                      );
                    }),
                  ),

                  if (tempRating > 0)
                    Text(
                      "$tempRating estrella${tempRating > 1 ? "s" : ""}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF4B2CA3),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: tempRating == 0
                      ? null
                      : () {
                          setState(() {
                            rating = tempRating;
                          });

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Calificaste con $rating estrellas ⭐"),
                            ),
                          );
                        },
                  child: const Text("Enviar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildProductItem() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: Icon(
            widget.order.icon,
            color: Colors.amber,
            size: 28,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                "Pizza de chorizo",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.order.storeName,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        const Text(
          "2",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(
      String label, String value,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        Text(
          "\$ $value",
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
