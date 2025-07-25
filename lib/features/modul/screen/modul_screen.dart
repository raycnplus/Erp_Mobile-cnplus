import 'package:flutter/material.dart';
import '../widgets/modul_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_DashboardItem> items = [
      _DashboardItem(title: 'Sales', icon: Icons.show_chart),
      _DashboardItem(title: 'Purchase', icon: Icons.attach_money),
      _DashboardItem(title: 'Inventory', icon: Icons.inventory),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ERP SORLEM', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE7F8F2), Color.fromARGB(255, 27, 99, 51)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ModulCard(
              title: item.title,
              icon: item.icon,
              onTap: () {
                if (item.title == 'Inventory') {
                  Navigator.pushNamed(context, '/dashboard_inventory');
                  
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class _DashboardItem {
  final String title;
  final IconData icon;

  _DashboardItem({required this.title, required this.icon});
}