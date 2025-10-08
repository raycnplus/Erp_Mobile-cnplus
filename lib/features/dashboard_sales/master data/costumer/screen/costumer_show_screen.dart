// costumer_show_screen.dart

import 'package:flutter/material.dart';
import '../widget/costumer_show_widget.dart';
import 'costumer_update_screen.dart'; // Pastikan path ini benar

class CustomerShowScreen extends StatefulWidget {
  final int id;

  const CustomerShowScreen({super.key, required this.id});

  @override
  State<CustomerShowScreen> createState() => _CustomerShowScreenState();
}

class _CustomerShowScreenState extends State<CustomerShowScreen> {
  // Key untuk me-refresh child widget setelah update berhasil
  Key _childKey = UniqueKey();
  bool _hasBeenUpdated = false;

  // Fungsi untuk navigasi ke halaman update
  Future<void> _navigateToUpdate() async {
    // Navigasi ke halaman update dan tunggu hasilnya (true jika berhasil)
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CustomerUpdateScreen(id: widget.id),
      ),
    );

    // Jika hasilnya 'true' (artinya update berhasil), refresh halaman ini
    if (result == true && mounted) {
      setState(() {
        _hasBeenUpdated = true;
        _childKey = UniqueKey(); // Mengganti key akan memaksa widget untuk rebuild
      });
      // Tampilkan notifikasi sukses
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
    // Mengirim status 'updated' kembali ke halaman index saat tombol back ditekan
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _hasBeenUpdated);
        return false; // Mencegah pop default agar tidak terjadi dua kali
      },
      child: Scaffold(
        appBar: AppBar(
          // Tombol kembali manual untuk mengirimkan hasil
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context, _hasBeenUpdated),
          ),
          title: const Text("Customer Detail"),
          // ▼▼▼ TOMBOL EDIT ADA DI BAGIAN INI ▼▼▼
          actions: [
            IconButton(
              tooltip: 'Edit Customer',
              icon: const Icon(Icons.edit_outlined),
              onPressed: _navigateToUpdate, // Panggil fungsi navigasi
            ),
          ],
        ),
        body: CustomerShowWidget(
          key: _childKey, // Gunakan key di sini untuk kontrol refresh
          id: widget.id,
        ),
      ),
    );
  }
}