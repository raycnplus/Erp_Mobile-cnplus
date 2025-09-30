import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Import yang diperlukan
import '../../../../../../services/api_base.dart';
import '../../../../../../shared/widgets/success_bottom_sheet.dart';
import '../widget/brand_index_widget.dart';
import '../models/brand_index_models.dart';
// Import model dan widget detail yang baru
import '../models/brand_show_models.dart';
import '../widget/brand_show_sheet.dart';
// Import create widget (untuk modal)
// import '../../create/widget/brand_create_form_widget.dart'; // Pastikan file ini ada

class BrandIndexScreen extends StatefulWidget {
  const BrandIndexScreen({super.key});

  @override
  State<BrandIndexScreen> createState() => _BrandIndexScreenState();
}

class _BrandIndexScreenState extends State<BrandIndexScreen> {
  final GlobalKey<BrandListWidgetState> _listKey =
      GlobalKey<BrandListWidgetState>();

  Future<void> _refreshData() async {
    _listKey.currentState?.reloadData();
  }

  // FUNGSI BARU: Fetch detail untuk brand
  Future<BrandShowModel> fetchBrandDetail(int id) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan.");
    }
    final url = Uri.parse("${ApiBase.baseUrl}/inventory/brand/$id");
    final response = await http.get(url, headers: {"Authorization": "Bearer $token", "Accept": "application/json"});
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      // Asumsi API mengembalikan data langsung, bukan dibungkus 'data'
      return BrandShowModel.fromJson(data);
    } else {
      throw Exception("Gagal memuat detail: Status ${response.statusCode}");
    }
  }

  // FUNGSI BARU: Menampilkan modal detail
  Future<void> _showDetailModal(BrandIndexModel brand) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final brandDetail = await fetchBrandDetail(brand.brandId);
      if (mounted) Navigator.pop(context); // Tutup loading

      if (mounted) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => BrandDetailSheet(brand: brandDetail),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Tutup loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  // TODO: Implementasikan fungsi show create modal jika belum ada
  Future<void> _showCreateModal() async {
    // const result = await showModalBottomSheet(...);
    // if (result == true) { ... }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Create modal belum diimplementasikan.")));
  }

  // Fungsi Notifikasi (tetap sama)
  void _showUpdateSuccessMessage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SuccessBottomSheet(
        title: "Successfully Updated!",
        message: "The brand has been updated.",
        themeColor: Color(0xFF4A90E2),
      ),
    );
  }

  void _showDeleteSuccessMessage(String brandName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SuccessBottomSheet(
        title: "Successfully Deleted!",
        message: "'$brandName' has been removed.",
        themeColor: const Color(0xFFF35D5D),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Brands", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 20)),
            Text('Swipe an item for actions', style: GoogleFonts.poppins(fontWeight: FontWeight.normal, color: Colors.grey.shade600, fontSize: 12)),
          ],
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: BrandListWidget(
        key: _listKey,
        onTap: (BrandIndexModel brand) {
          _showDetailModal(brand); // PANGGIL FUNGSI MODAL DI SINI
        },
        onUpdateSuccess: () {
          _showUpdateSuccessMessage();
        },
        onDeleteSuccess: (String brandName) {
          _showDeleteSuccessMessage(brandName);
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: const Color(0xFF679436).withAlpha(102), blurRadius: 15, spreadRadius: 2, offset: const Offset(0, 5)),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _showCreateModal,
          tooltip: 'Add Brand',
          backgroundColor: const Color(0xFF679436),
          elevation: 0,
          child: const Icon(Icons.add, color: Color(0xFFF0E68C)),
        ),
      ),
    );
  }
}