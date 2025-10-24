// Lokasi: purchase/vendor/screen/index_screen_vendor_purchase.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widget/index_widget_vendor_purchase.dart';
import '../../create/screen/create_screen_vendor_purchase.dart';
import '../../../../../../shared/widgets/success_bottom_sheet.dart'; // [UBAH] Asumsi path ini benar

class VendorIndexScreen extends StatefulWidget {
  const VendorIndexScreen({super.key});

  @override
  State<VendorIndexScreen> createState() => _VendorIndexScreenState();
}

class _VendorIndexScreenState extends State<VendorIndexScreen> {
  // [UBAH] Tipe GlobalKey diubah menjadi VendorIndexWidgetState (public)
  final GlobalKey<VendorIndexWidgetState> _vendorIndexWidgetKey =
      GlobalKey<VendorIndexWidgetState>();

  // [UBAH] Menambahkan fungsi notifikasi dari referensi
  void _showCreateSuccessMessage() {
    // Pastikan Anda memiliki widget SuccessBottomSheet atau ganti dengan SnackBar biasa
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SuccessBottomSheet(
        title: "Successfully Created!",
        message: "New vendor has been added to the list.",
      ),
    );
  }

  void _showUpdateSuccessMessage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SuccessBottomSheet(
        title: "Successfully Updated!",
        message: "The vendor data has been updated.",
        themeColor: Color(0xFF4A90E2),
      ),
    );
  }

  // [UBAH] Logika untuk menampilkan modal create dan me-refresh data
  void _showCreateVendorModal() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const VendorCreateScreen()),
    );

    // Jika hasil dari create screen adalah true (sukses)
    if (result == true) {
      _vendorIndexWidgetKey.currentState?.reloadData(); // Muat ulang data
      _showCreateSuccessMessage(); // Tampilkan notifikasi
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // [UBAH] AppBar disamakan dengan referensi
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vendor Purchase List", // Judul disesuaikan
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 20),
            ),
            Text(
              'Tap an item for details and actions',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey.shade600,
                  fontSize: 12),
            ),
          ],
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      // [UBAH] Gunakan key dan callback untuk menghubungkan dengan child widget
      body: VendorIndexWidget(
        key: _vendorIndexWidgetKey,
        onUpdateSuccess: () {
          _vendorIndexWidgetKey.currentState?.reloadData(); // Muat ulang data
          _showUpdateSuccessMessage(); // Tampilkan notifikasi
        },
      ),

      // [UBAH] FAB dipindahkan ke sini dari widget, disesuaikan dengan referensi
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2D6A4F),
        foregroundColor: Colors.white,
        onPressed: _showCreateVendorModal,
        tooltip: 'Add New Vendor',
        elevation: 4,
        child: const Icon(Icons.add),
      ),
    );
  }
}