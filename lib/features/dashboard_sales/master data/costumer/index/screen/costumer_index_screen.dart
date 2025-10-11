// costumer_index_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/costumer_index_models.dart';
import '../../create/screen/costumer_create_screens.dart';
import '../../show/screen/costumer_show_screen.dart';
import '../../update/screen/costumer_update_screen.dart';
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

  Future<void> _navigateToUpdate(CustomerIndexModel customer) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CustomerUpdateScreen(id: customer.idCustomer)),
    );
    if (result == true) {
      _refreshList();
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF679436);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        // [DIUBAH] Style AppBar disamakan dengan product_type_index_screen.dart
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Customers",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.black87, // Teks hitam
                fontSize: 20,
              ),
            ),
            Text(
              'Tap an item to see the detail', // Subjudul ditambahkan
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.normal,
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        elevation: 0.5,
        backgroundColor: Colors.white, // Latar belakang putih
        foregroundColor: Colors.black87, // Ikon hitam
      ),
      body: RefreshIndicator(
        onRefresh: _refreshList,
        color: primaryGreen,
        child: CustomerIndexWidget(
          key: _listKey,
          onTap: _navigateToDetail,
          onEdit: _navigateToUpdate,
        ),
      ),
      floatingActionButton: Container(
        // [DIUBAH] Menambahkan shadow yang sama seperti referensi
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: primaryGreen.withAlpha(100), // Shadow hijau transparan
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _navigateToCreate,
          tooltip: 'Add Customer',
          backgroundColor: primaryGreen,
          elevation: 0, // Elevation dari FAB di-nol-kan karena sudah pakai shadow dari Container
          child: const Icon(Icons.add, color: Colors.white), // Ikon putih agar kontras
        ),
      ),
    );
  }
}