import 'package:flutter/material.dart';
import '../models/costumer_index_models.dart';
import '../widget/costumer_index_widget.dart';
import 'costumer_show_screen.dart';
import 'costumer_create_screens.dart';
import 'costumer_update_screen.dart'; // ✅ Tambahkan import ini

class CustomerIndexScreen extends StatefulWidget {
  const CustomerIndexScreen({super.key});

  @override
  State<CustomerIndexScreen> createState() => _CustomerIndexScreenState();
}

class _CustomerIndexScreenState extends State<CustomerIndexScreen> {
  // GlobalKey untuk akses state CustomerIndexWidget
  final GlobalKey<CustomerIndexWidgetState> _listKey =
      GlobalKey<CustomerIndexWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customer")),
      body: CustomerIndexWidget(
        key: _listKey,
        onTap: (CustomerIndexModel customer) async {
          // Navigasi ke detail (show)
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CustomerShowScreen(id: customer.idCustomer),
            ),
          );

          // Refresh kalau detail melakukan update/delete
          if (result == true) {
            _listKey.currentState?.fetchData();
          }
        },
        onEdit: (CustomerIndexModel customer) async {
          // ✅ Navigasi ke update screen
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CustomerUpdateScreen(id: customer.idCustomer),
            ),
          );

          // ✅ Refresh data setelah update sukses
          if (result == true) {
            _listKey.currentState?.fetchData();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CustomerCreateScreen(),
            ),
          );

          if (result == true) {
            // refresh list customer setelah create berhasil
            _listKey.currentState?.fetchData();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
