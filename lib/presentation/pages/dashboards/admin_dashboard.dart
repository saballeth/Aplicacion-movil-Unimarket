import 'package:flutter/material.dart';
import 'sections/entrepreneurs_section.dart';
import 'sections/users_management_section.dart';
import 'sections/app_performance_section.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.purple,
            labelColor: Colors.purple,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(
                text: 'Emprendimientos',
                icon: Icon(Icons.store),
              ),
              Tab(
                text: 'Usuarios',
                icon: Icon(Icons.people),
              ),
              Tab(
                text: 'Rendimiento',
                icon: Icon(Icons.analytics),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              EntrepreneursSection(),
              UsersManagementSection(),
              AppPerformanceSection(),
            ],
          ),
        ),
      ],
    );
  }
}

