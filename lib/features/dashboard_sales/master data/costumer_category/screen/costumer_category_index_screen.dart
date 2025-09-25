import 'package:flutter/material.dart';
import '../widget/costumer_category_index_widget.dart';
import '../screen/costumer_category_create_screen.dart';
import '../screen/costumer_category_show_screen.dart';

class CustomerCategoryScreen extends StatefulWidget {
  const CustomerCategoryScreen({super.key});

  @override
  State<CustomerCategoryScreen> createState() => _CustomerCategoryScreenState();
}

class _CustomerCategoryScreenState extends State<CustomerCategoryScreen> {
  Future<void> _navigateToCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CustomerCategoryCreateScreen(),
      ),
    );

    // kalau berhasil create (pop dengan true) -> refresh list
    if (result == true) {
      setState(() {}); // trigger rebuild → UniqueKey akan ganti
    }
  }

  Future<void> _navigateToDetail(int id) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerCategoryShowScreen(id: id),
      ),
    );

    // kalau dari detail/update balik dengan true -> refresh list
    if (result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Category"),
      ),
      body: CustomerCategoryIndexWidget(
        key: UniqueKey(), // 👈 penting biar fetchCategories() kepanggil ulang
        onTap: _navigateToDetail, // kasih callback ke widget index
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreate,
        child: const Icon(Icons.add),
      ),
    );
  }
}
