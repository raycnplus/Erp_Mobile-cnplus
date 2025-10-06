import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widget/index_widget_vendor.dart';
import '../../create/screen/create_screen_vendor.dart';
import '../../../../../../shared/widgets/success_bottom_sheet.dart';

class VendorIndexScreen extends StatefulWidget {
  const VendorIndexScreen({super.key});

  @override
  State<VendorIndexScreen> createState() => _VendorIndexScreenState();
}

class _VendorIndexScreenState extends State<VendorIndexScreen> {
  // [PERBAIKAN]: Tipe GlobalKey diubah menjadi VendorIndexWidgetState (public)
  final GlobalKey<VendorIndexWidgetState> _vendorIndexWidgetKey =
      GlobalKey<VendorIndexWidgetState>();

  // Fungsi untuk menampilkan notifikasi sukses setelah membuat data
  void _showCreateSuccessMessage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SuccessBottomSheet(
        title: "Successfully Created!",
        message: "New vendor has been added to the list.",
      ),
    );
  }

  // Fungsi untuk menampilkan notifikasi sukses setelah update data
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

  // Fungsi untuk menampilkan modal create dan menangani hasilnya
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vendor List",
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
      // Gunakan key untuk menghubungkan dengan child widget
      body: VendorIndexWidget(
        key: _vendorIndexWidgetKey,
        onUpdateSuccess: () {
          _vendorIndexWidgetKey.currentState?.reloadData(); // Muat ulang data
          _showUpdateSuccessMessage(); // Tampilkan notifikasi
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2D6A4F),
        foregroundColor: Colors.white,
        onPressed: _showCreateVendorModal, // Panggil fungsi modal create
        tooltip: 'Add New Vendor',
        elevation: 4,
        child: const Icon(Icons.add),
      ),
    );
  }
}