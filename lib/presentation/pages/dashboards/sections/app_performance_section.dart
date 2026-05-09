import 'package:flutter/material.dart';

class AppPerformanceSection extends StatelessWidget {
  const AppPerformanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Main performance stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rendimiento de la Aplicación',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildKPICard(
                        'Descargas',
                        '12,450',
                        '+15%',
                        Colors.blue,
                        Icons.download,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildKPICard(
                        'Usuarios Activos',
                        '8,934',
                        '+8%',
                        Colors.green,
                        Icons.people,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildKPICard(
                        'Transacciones',
                        '3,456',
                        '+22%',
                        Colors.purple,
                        Icons.credit_card,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildKPICard(
                        'Ingresos Totales',
                        '\$234,567',
                        '+12%',
                        Colors.orange,
                        Icons.trending_up,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Recommendations Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recomendaciones Activas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return _buildRecommendationCard(
                      title: 'Recomendación ${index + 1}',
                      description:
                          'Producto: ${['Pizza', 'Ropa', 'Accesorios', 'Bebidas'][index]}',
                      clicks: [245, 189, 412, 156][index],
                      conversions: [34, 21, 67, 18][index],
                      duration: '${5 + (index * 2)} días',
                      progress: [65, 42, 88, 35][index].toDouble(),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Promotions Duration
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Duración de Promociones',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildPromotionTimeline(),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Comments and Ratings Progress
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Progresión de Comentarios y Calificaciones',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _buildRatingProgressItem(
                      rating: 5 - index,
                      count: [156, 234, 412, 189, 45][index],
                      percentage: [22, 33, 58, 27, 6][index].toDouble(),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Product Performance
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rendimiento de Productos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _buildProductPerformanceCard(
                      productName: [
                        'Pizza Casera',
                        'Camisetas',
                        'Headphones',
                        'Juices',
                        'Bolsos',
                      ][index],
                      sales: [234, 189, 412, 156, 98][index],
                      rating: [4.8, 4.5, 4.9, 4.2, 4.6][index],
                      trend: [12, -3, 25, 8, -5][index],
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildKPICard(
    String label,
    String value,
    String change,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  change,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard({
    required String title,
    required String description,
    required int clicks,
    required int conversions,
    required String duration,
    required double progress,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  duration,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Clics: $clicks',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Conversiones: $conversions',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 6,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress > 75
                    ? Colors.green
                    : progress > 50
                    ? Colors.orange
                    : Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionTimeline() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildTimelineItem('Promoción 1', '7 días', '5 días restantes'),
          const Divider(),
          _buildTimelineItem('Promoción 2', '14 días', '3 días restantes'),
          const Divider(),
          _buildTimelineItem('Promoción 3', '3 días', 'Finalizada'),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String name, String duration, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Duración: $duration',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: status == 'Finalizada'
                  ? Colors.red.withOpacity(0.1)
                  : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: status == 'Finalizada' ? Colors.red : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingProgressItem({
    required int rating,
    required int count,
    required double percentage,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  size: 12,
                  color: index < rating ? Colors.orange : Colors.grey[300],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 8,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 40,
            child: Text(
              '($count)',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductPerformanceCard({
    required String productName,
    required int sales,
    required double rating,
    required int trend,
  }) {
    final isPositiveTrend = trend >= 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.shopping_bag, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '$sales ventas',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        Icon(Icons.star, size: 12, color: Colors.orange),
                        const SizedBox(width: 2),
                        Text(
                          '$rating',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPositiveTrend
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${isPositiveTrend ? '+' : ''}$trend%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isPositiveTrend ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
