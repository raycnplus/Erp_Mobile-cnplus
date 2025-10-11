// costumer_show_screen.dart

import 'package:flutter/material.dart';
import '../widget/costumer_show_widget.dart';
import '../../update/screen/costumer_update_screen.dart'; 

class CustomerShowScreen extends StatefulWidget {
  final int id;

  const CustomerShowScreen({super.key, required this.id});

  @override
  State<CustomerShowScreen> createState() => _CustomerShowScreenState();
}

class _CustomerShowScreenState extends State<CustomerShowScreen> {
  Key _childKey = UniqueKey();
  bool _hasBeenUpdated = false;

  Future<void> _navigateToUpdate() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CustomerUpdateScreen(id: widget.id),
      ),
    );

    if (result == true && mounted) {
      setState(() {
        _hasBeenUpdated = true;
        _childKey = UniqueKey(); 
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Customer updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _hasBeenUpdated);
        return false;
      },
      child: Scaffold(
        // ▼▼▼ PERUBAHAN DI SINI ▼▼▼
        backgroundColor: const Color(0xFFF8F9FA), // Latar belakang abu-abu muda
        appBar: AppBar(
          backgroundColor: const Color(0xFFF8F9FA), // Samakan dengan body
          elevation: 0, // Hapus bayangan agar clean
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54),
            onPressed: () => Navigator.pop(context, _hasBeenUpdated),
          ),
          title: const Text(
            "Customer Detail",
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'Edit Customer',
              icon: const Icon(Icons.edit_outlined, color: Colors.black54),
              onPressed: _navigateToUpdate,
            ),
          ],
        ),
        body: CustomerShowWidget(
          key: _childKey,
          id: widget.id,
        ),
      ),
    );
  }
}