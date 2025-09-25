import 'package:flutter/material.dart';
import '../widget/costumer_category_show_widget.dart';
import '../screen/costumer_category_update.dart';

class CustomerCategoryShowScreen extends StatefulWidget {
  final int id;

  const CustomerCategoryShowScreen({super.key, required this.id});

  @override
  State<CustomerCategoryShowScreen> createState() =>
      _CustomerCategoryShowScreenState();
}

class _CustomerCategoryShowScreenState
    extends State<CustomerCategoryShowScreen> {
  int refreshKey = 0; // dipakai biar ShowWidget rebuild

  Future<void> _navigateToUpdate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerCategoryUpdateScreen(id: widget.id),
      ),
    );

    // kalau update sukses (pop dengan true), refresh detail
    if (result == true) {
      setState(() {
        refreshKey++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Category Detail"),
      ),
      body: CustomerCategoryShowWidget(
        id: widget.id,
        key: ValueKey(refreshKey), // penting biar rebuild
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToUpdate,
        child: const Icon(Icons.edit),
      ),
    );
  }
}
