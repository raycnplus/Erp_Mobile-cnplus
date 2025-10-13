// lib/features/dashboard_sales/master data/costumer_category/screen/costumer_category_index_screen.dart

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../../../../../../shared/widgets/success_bottom_sheet.dart';
import '../widget/costumer_category_index_widget.dart';
import '../../show/models/costumer_category_show_models.dart';
import '../../show/widget/costumer_category_show_sheet.dart';
import '../../create/widget/costumer_category_create_widget.dart'; 

class CustomerCategoryScreen extends StatefulWidget {
  const CustomerCategoryScreen({super.key});

  @override
  State<CustomerCategoryScreen> createState() => _CustomerCategoryScreenState();
}

class _CustomerCategoryScreenState extends State<CustomerCategoryScreen> {
  final GlobalKey<CustomerCategoryIndexWidgetState> _listKey =
      GlobalKey<CustomerCategoryIndexWidgetState>();

  Future<void> _refreshData() async {
    _listKey.currentState?.reloadData();
  }

  Future<CustomerCategoryShowModel> fetchCategoryDetail(int id) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/sales/customer-category/$id'),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = decoded is Map<String, dynamic> && decoded.containsKey('data')
          ? decoded['data']
          : decoded;
      return CustomerCategoryShowModel.fromJson(data);
    } else {
      throw Exception('Failed to load detail');
    }
  }

  Future<void> _showDetailModal(int id) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final detail = await fetchCategoryDetail(id);
      if (!mounted) return;
      Navigator.pop(context); // Close loading
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => CustomerCategoryDetailSheet(category: detail),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  void _showCreateSuccessMessage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SuccessBottomSheet(
        title: "Successfully Created!",
        message: "New customer category has been added.",
      ),
    );
  }

  void _showUpdateSuccessMessage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SuccessBottomSheet(
        title: "Successfully Updated!",
        message: "The customer category has been updated.",
        themeColor: Color(0xFF4A90E2),
      ),
    );
  }

  void _showDeleteSuccessMessage(String deletedItemName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SuccessBottomSheet(
        title: "Successfully Deleted!",
        message: "'$deletedItemName' has been removed.",
        themeColor: const Color(0xFFF35D5D),
      ),
    );
  }

  void _showCreateModal() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Wajib transparan
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
            child: Container(
              color: Colors.white.withOpacity(0.95), 
              child: const CustomerCategoryCreateWidget(),
            ),
          ),
        ),
      ),
    );

    if (result == true) {
      _listKey.currentState?.reloadData();
      _showCreateSuccessMessage();
    }
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
            Text("Customer Category", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 20)),
            Text('Swipe an item for actions', style: GoogleFonts.poppins(fontWeight: FontWeight.normal, color: Colors.grey.shade600, fontSize: 12)),
          ],
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: CustomerCategoryIndexWidget(
        key: _listKey,
        onTap: (category) {
          _showDetailModal(category.id);
        },
        onUpdateSuccess: () {
          _showUpdateSuccessMessage();
        },
        onDeleteSuccess: (String itemName) {
          _showDeleteSuccessMessage(itemName);
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
          tooltip: 'Add Customer Category',
          backgroundColor: const Color(0xFF679436),
          elevation: 0,
          child: const Icon(Icons.add, color: Color(0xFFF0E68C)),
        ),
      ),
    );
  }
}