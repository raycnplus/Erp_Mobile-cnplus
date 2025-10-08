// costumer_index_screen.dart

import 'package:flutter/material.dart';
import '../models/costumer_index_models.dart';
import 'costumer_create_screens.dart';
import 'costumer_show_screen.dart';
import 'costumer_update_screen.dart'; // <-- Tambahkan import untuk update screen
import '../widget/costumer_index_widget.dart';

class CustomerIndexScreen extends StatefulWidget {
  const CustomerIndexScreen({super.key});

  @override
  State<CustomerIndexScreen> createState() => _CustomerIndexScreenState();
}

class _CustomerIndexScreenState extends State<CustomerIndexScreen> {
  final GlobalKey<CustomerIndexWidgetState> _listKey =
      GlobalKey<CustomerIndexWidgetState>();

  Future<void> _refreshList() async {
    _listKey.currentState?.fetchData();
  }

  Future<void> _navigateToCreate() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const CustomerCreateScreen()),
    );
    if (result == true) {
      _refreshList();
    }
  }

  Future<void> _navigateToDetail(CustomerIndexModel customer) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CustomerShowScreen(id: customer.idCustomer)),
    );
    if (result == true) {
      _refreshList();
    }
  }

  // ▼▼▼ FUNGSI BARU UNTUK MENANGANI EDIT ▼▼▼
  Future<void> _navigateToUpdate(CustomerIndexModel customer) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CustomerUpdateScreen(id: customer.idCustomer)),
    );
    if (result == true) {
      _refreshList(); // Refresh daftar jika update berhasil
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customers"),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshList,
        child: CustomerIndexWidget(
          key: _listKey,
          onTap: _navigateToDetail,
          onEdit: _navigateToUpdate, // <-- Hubungkan fungsi edit ke widget
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreate,
        tooltip: 'Add Customer',
        child: const Icon(Icons.add),
      ),
    );
  }
}