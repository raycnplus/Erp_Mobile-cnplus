import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../../../../services/api_base.dart';
import '../../../../../../../shared/widgets/success_bottom_sheet.dart';
import '../widget/brand_index_widget.dart';
import '../models/brand_index_models.dart';
import '../../show/models/brand_show_models.dart';
import '../../show/widget/brand_show_sheet.dart';
import '../../create/widget/brand_create_form_widget.dart';

class BrandIndexScreen extends StatefulWidget {
  const BrandIndexScreen({super.key});

  @override
  State<BrandIndexScreen> createState() => _BrandIndexScreenState();
}

class _BrandIndexScreenState extends State<BrandIndexScreen> {
  final GlobalKey<BrandListWidgetState> _listKey = GlobalKey<BrandListWidgetState>();

  Future<void> _refreshData() async {
    _listKey.currentState?.reloadData();
  }

  Future<BrandShowModel> fetchBrandDetail(int id) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception("Token tidak ditemukan.");
    
    final url = Uri.parse("${ApiBase.baseUrl}/inventory/brand/$id");
    final response = await http.get(url, headers: {"Authorization": "Bearer $token", "Accept": "application/json"});

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return BrandShowModel.fromJson(data);
    } else {
      throw Exception("Gagal memuat detail: Status ${response.statusCode}");
    }
  }

  Future<void> _showDetailModal(BrandIndexModel brand) async {
    showDialog(context: context, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      final brandDetail = await fetchBrandDetail(brand.brandId);
      if (mounted) Navigator.pop(context);
      if (mounted) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => BrandDetailSheet(brand: brandDetail),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.redAccent));
      }
    }
  }

  Future<void> _showCreateModal() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: const BrandCreateWidget(),
        ),
      ),
    );

    if (result == true) {
      _refreshData();
      _showCreateSuccessMessage();
    }
  }

  void _showCreateSuccessMessage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SuccessBottomSheet(
        title: "Successfully Created!",
        message: "New brand has been added to the list.",
      ),
    );
  }

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
          _showDetailModal(brand);
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