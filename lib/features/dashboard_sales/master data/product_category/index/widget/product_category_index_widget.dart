import 'package:erp_mobile_cnplus/features/dashboard_sales/master%20data/product_category/index/widget/product_category_skeleton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../../services/api_base.dart';
import '../models/product_category_index_models.dart';

import '../../../../../dashboard_inventory/master_data/product_category/update/widget/product_category_update_dialog.dart';
import '../../../../../dashboard_inventory/master_data/product_category/update/models/product_category_update_models.dart';

List<ProductCategory> _parseProductCategories(String responseBody) {
  final decoded = jsonDecode(responseBody);
  if (decoded is List) {
    return decoded.map((e) => ProductCategory.fromJson(e)).toList();
  }
  if (decoded is Map<String, dynamic> && decoded['status'] == true && decoded['data'] is List) {
    final List<dynamic> dataList = decoded['data'];
    return dataList.map((e) => ProductCategory.fromJson(e)).toList();
  }
  throw Exception("Format respons API tidak valid.");
}

class ProductCategoryListWidget extends StatefulWidget {
  final ValueChanged<ProductCategory> onTap;
  final Function(String name)? onDeleteSuccess;
  final VoidCallback? onUpdateSuccess; 

  const ProductCategoryListWidget({
    super.key,
    required this.onTap,
    this.onDeleteSuccess,
    this.onUpdateSuccess, 
  });

  @override
  State<ProductCategoryListWidget> createState() => ProductCategoryListWidgetState();
}

class ProductCategoryListWidgetState extends State<ProductCategoryListWidget> {
  late Future<List<ProductCategory>> futureCategories;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    futureCategories = fetchProductCategories();
  }

  void reloadData() {
    setState(() {
      futureCategories = fetchProductCategories();
    });
  }

  Future<List<ProductCategory>> fetchProductCategories() async {
    final token = await _storage.read(key: 'token');
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }
    final url = Uri.parse("${ApiBase.baseUrl}/sales/product-category/");
    final response = await http.get(url, headers: {"Authorization": "Bearer $token", "Accept": "application/json"});
    if (response.statusCode == 200) {
      return compute(_parseProductCategories, response.body);
    } else {
      throw Exception("Gagal memuat data: Status code ${response.statusCode}");
    }
  }

  Future<bool> _deleteCategory(int id) async {
    final token = await _storage.read(key: "token");
    final url = Uri.parse("${ApiBase.baseUrl}/sales/product-category/$id");
    final response = await http.delete(url, headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool?> _showDeleteConfirmationDialog(ProductCategory category) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withAlpha(102),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.white.withAlpha(230),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const SizedBox(height: 50, width: 50, child: Icon(Icons.delete_rounded, color: Color(0xFFF35D5D), size: 50.0)),
                const SizedBox(height: 28),
                Text("Are you sure you want to delete ${category.name}?", textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF35D5D), foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  // [PERBAIKAN] Mengganti 'Bóld' (typo) menjadi 'FontWeight.bold'
                  child: const Text("Yes, Delete", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Keep It", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductCategory>>(
      future: futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ProductCategorySkeleton();
        } else if (snapshot.hasError) {
          return Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(padding: const EdgeInsets.all(16.0), child: Text("Error: ${snapshot.error.toString().replaceFirst("Exception: ", "")}")),
              ElevatedButton(onPressed: reloadData, child: const Text("Coba Lagi")),
            ]),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Tidak ada data product category"));
        }

        final categories = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async => reloadData(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final cardBorderRadius = BorderRadius.circular(12);

              return Container(
                margin: const EdgeInsets.only(bottom: 12.0),
                decoration: BoxDecoration(
                  borderRadius: cardBorderRadius,
                  boxShadow: [BoxShadow(color: const Color.fromARGB(26, 158, 158, 158), spreadRadius: 0, blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Dismissible(
                  key: Key(category.id.toString()),
                  background: Container(
                    decoration: BoxDecoration(color: Colors.blue, borderRadius: cardBorderRadius),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: const Row(children: [Icon(Icons.edit, color: Colors.white), SizedBox(width: 8), Text('Edit', style: TextStyle(color: Colors.white))]),
                  ),
                  secondaryBackground: Container(
                    decoration: BoxDecoration(color: Colors.red, borderRadius: cardBorderRadius),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text('Delete', style: TextStyle(color: Colors.white)), SizedBox(width: 8), Icon(Icons.delete, color: Colors.white)]),
                  ),

                  // [PERBAIKAN] Memperbaiki penggunaan BuildContext di async gap
                  confirmDismiss: (direction) async {
                    // Ambil ScaffoldMessenger sebelum await
                    final scaffoldMessenger = ScaffoldMessenger.of(context);

                    if (direction == DismissDirection.endToStart) {
                      final confirmed = await _showDeleteConfirmationDialog(category);
                      if (confirmed == true) {
                        final success = await _deleteCategory(category.id);
                        if (!mounted) return false; // Guard
                        if (success) {
                          reloadData();
                          widget.onDeleteSuccess?.call(category.name);
                        } else {
                          // Gunakan scaffoldMessenger yang sudah diambil
                          scaffoldMessenger.showSnackBar(SnackBar(content: Text('Gagal menghapus ${category.name}'), backgroundColor: Colors.redAccent));
                        }
                        return success;
                      }
                      return false;
                    } else {
                      // Tambahkan guard 'mounted' sebelum menggunakan context lagi
                      if (!mounted) return false;
                      
                      final result = await showUpdateProductCategoryDialog(
                        context, // Context ini sekarang aman
                        id: category.id,
                        initialData: ProductCategoryUpdateModel(productCategoryName: category.name),
                      );
                      if (result == true) {
                        reloadData();
                        widget.onUpdateSuccess?.call();
                      }
                      return false;
                    }
                  },
                  child: ClipRRect(
                    borderRadius: cardBorderRadius,
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () => widget.onTap(category),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text("Source: Lokal", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                              ]),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}