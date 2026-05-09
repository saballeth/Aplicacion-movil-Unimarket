import 'package:flutter/material.dart';

class UsersManagementSection extends StatefulWidget {
  const UsersManagementSection({super.key});

  @override
  State<UsersManagementSection> createState() => _UsersManagementSectionState();
}

class _UsersManagementSectionState extends State<UsersManagementSection> {
  String _selectedFilter = 'Todos';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Header with stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gestión de Usuarios',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Usuarios',
                        '234',
                        Colors.blue,
                        Icons.people,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Emprendedores',
                        '45',
                        Colors.purple,
                        Icons.store,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Consumidores',
                        '189',
                        Colors.green,
                        Icons.shopping_cart,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Filter buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filtrar por rol',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Todos', _selectedFilter == 'Todos', () {
                        setState(() => _selectedFilter = 'Todos');
                      }),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'Consumidores', _selectedFilter == 'Consumidores', () {
                        setState(() => _selectedFilter = 'Consumidores');
                      }),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'Emprendedores', _selectedFilter == 'Emprendedores', () {
                        setState(() => _selectedFilter = 'Emprendedores');
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Users list
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Listado de Usuarios',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final roles = ['Consumidor', 'Emprendedor', 'Consumidor'];
                    final role = roles[index % roles.length];
                    final roleColor = role == 'Consumidor'
                        ? Colors.blue
                        : Colors.purple;

                    return _buildUserListItem(
                      name: 'Usuario ${index + 1}',
                      email: 'usuario${index + 1}@uni.edu.co',
                      role: role,
                      joinDate: '${15 - (index % 15)} días atrás',
                      roleColor: roleColor,
                      isActive: index % 2 == 0,
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

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    bool isSelected,
    VoidCallback onPressed,
  ) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onPressed(),
      backgroundColor: Colors.grey[100],
      selectedColor: Colors.purple.withOpacity(0.2),
      labelStyle: TextStyle(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? Colors.purple : Colors.black,
      ),
    );
  }

  Widget _buildUserListItem({
    required String name,
    required String email,
    required String role,
    required String joinDate,
    required Color roleColor,
    required bool isActive,
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
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: roleColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: roleColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      email,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isActive ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: roleColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  role,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: roleColor,
                  ),
                ),
              ),
              Text(
                'Se unió $joinDate',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('Ver'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Editar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
