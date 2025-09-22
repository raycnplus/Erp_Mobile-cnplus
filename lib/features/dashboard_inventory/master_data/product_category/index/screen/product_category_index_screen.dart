import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../../../services/api_base.dart';
import '../../../../../../shared/widgets/success_bottom_sheet.dart';
import '../widget/product_category_index_widget.dart';
import '../models/product_category_index_models.dart';
import '../../create/screen/product_category_create_screen.dart';
import '../../show/models/product_category_show_models.dart';
import '../../show/widget/product_category_show_sheet.dart';

class ProductCategoryScreen extends StatefulWidget {
  const ProductCategoryScreen({super.key});

  @override
  State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  final GlobalKey<ProductCategoryListWidgetState> _listKey =
      GlobalKey<ProductCategoryListWidgetState>();

  Future<void> _navigateToCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProductCategoryCreateScreen()),
    );

    if (result == true) {
      _listKey.currentState?.reloadData();
      _showCreateSuccessMessage();
    }
  }

  Future<ProductCategoryShowModels> fetchProductCategoryDetail(int id) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan.");
    }
    final url = Uri.parse("${ApiBase.baseUrl}/inventory/product-category/$id");
    final response = await http.get(url, headers: {"Authorization": "Bearer $token", "Accept": "application/json"});

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      if (decoded['status'] == true && decoded['data'] != null) {
        return ProductCategoryShowModels.fromJson(decoded['data']);
      } else {
        throw Exception("Gagal memuat data dari API.");
      }
    } else {
      throw Exception("Gagal memuat detail: Status ${response.statusCode}");
    }
  }

  Future<void> _showDetailModal(int categoryId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final categoryDetail = await fetchProductCategoryDetail(categoryId);
      if (mounted) Navigator.pop(context);

      if (mounted) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => ProductCategoryDetailSheet(category: categoryDetail),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  // Fungsi Notifikasi Sukses
  void _showCreateSuccessMessage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SuccessBottomSheet(
        title: "Successfully Created!",
        message: "New product category has been added.",
        themeColor: Color(0xFF679436),
      ),
    );
  }

  //  Notifikasi untuk update
  void _showUpdateSuccessMessage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SuccessBottomSheet(
        title: "Successfully Updated!",
        message: "The product category has been updated.",
        themeColor: Color(0xFF4A90E2), // Biru
      ),
    );
  }

  void _showDeleteSuccessMessage(String categoryName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SuccessBottomSheet(
        title: "Successfully Deleted!",
        message: "'$categoryName' has been removed.",
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
            Text("Product Category", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 20)),
            Text('Swipe an item for actions', style: GoogleFonts.poppins(fontWeight: FontWeight.normal, color: Colors.grey.shade600, fontSize: 12)),
          ],
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: ProductCategoryListWidget(
        key: _listKey,
        onTap: (ProductCategory category) {
          _showDetailModal(category.id);
        },
        // Sambungkan callback update di sini
        onUpdateSuccess: () {
          _showUpdateSuccessMessage();
        },
        onDeleteSuccess: (String categoryName) {
          _showDeleteSuccessMessage(categoryName);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF679436),
        onPressed: _navigateToCreate,
        elevation: 0,
        tooltip: 'add product category',
        child: const Icon(Icons.add, color: Color(0xFFF0E68C)),
      ),
    );
  }
}