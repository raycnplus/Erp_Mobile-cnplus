import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';
import '../models/product_category_index_models.dart';

import '../../update/widget/product_category_update_dialog.dart';
import '../../update/models/product_category_update_models.dart';
import '../../../../../../../shared/widgets/master_data_list_shimmer.dart';

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
  // 1. Ganti FutureBuilder dengan state manual
  bool _isLoading = true;
  List<ProductCategory> _productCategories = [];
  String? _error;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    // 3. Panggil _loadData di initState
    _loadData();
  }

  // 2. Tambahkan method _loadData untuk mengambil data dan mengelola state
  Future<void> _loadData() async {
    // Saat refresh, jangan langsung set state agar data lama tetap terlihat
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final data = await fetchProductCategories();
      if (mounted) {
        setState(() {
          _productCategories = data;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst("Exception: ", "");
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void reloadData() {
    _loadData();
  }

  Future<List<ProductCategory>> fetchProductCategories() async {
    final token = await _storage.read(key: 'token');
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }
    final url = Uri.parse("${ApiBase.baseUrl}/inventory/product-category/");
    final response = await http.get(url, headers: {"Authorization": "Bearer $token", "Accept": "application/json"});
    if (response.statusCode == 200) {
      return compute(_parseProductCategories, response.body);
    } else {
      throw Exception("Gagal memuat data: Status code ${response.statusCode}");
    }
  }

  Future<bool> _deleteCategory(int id) async {
    final token = await _storage.read(key: "token");
    final url = Uri.parse("${ApiBase.baseUrl}/inventory/product-category/$id");
    final response = await http.delete(url, headers: {"Authorization": "Bearer $token"});
    return response.statusCode == 200;
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
    // 4. Ubah build method untuk menampilkan shimmer, error, atau list berdasarkan state
    Widget content;

    if (_isLoading && _productCategories.isEmpty) {
      // State Loading Awal
      content = const MasterDataListShimmer();
    } else if (_error != null) {
      // State Error
      content = Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(padding: const EdgeInsets.all(16.0), child: Text("Error: $_error")),
          ElevatedButton(onPressed: reloadData, child: const Text("Coba Lagi")),
        ]),
      );
    } else if (_productCategories.isEmpty) {
      // State Data Kosong
      content = const Center(child: Text("Tidak ada data product category"));
    } else {
      // State Data Tersedia (atau saat refresh)
      content = _isLoading
          ? MasterDataListShimmer(itemCount: _productCategories.length)
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _productCategories.length,
        itemBuilder: (context, index) {
          final category = _productCategories[index];
          return _buildCategoryCard(category);
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: content,
    );
  }

  Widget _buildCategoryCard(ProductCategory category) {
    final cardBorderRadius = BorderRadius.circular(12);
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        borderRadius: cardBorderRadius,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 0, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Dismissible(
        key: Key(category.id.toString()),
        background: _buildSwipeActionContainer(
          color: Colors.blue,
          icon: Icons.edit,
          text: 'Edit',
          alignment: Alignment.centerLeft,
        ),
        secondaryBackground: _buildSwipeActionContainer(
          color: Colors.red,
          icon: Icons.delete,
          text: 'Delete',
          alignment: Alignment.centerRight,
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            final confirmed = await _showDeleteConfirmationDialog(category);
            if (confirmed == true) {
              final success = await _deleteCategory(category.id);
              if (!mounted) return false;
              if (success) {
                reloadData();
                widget.onDeleteSuccess?.call(category.name);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menghapus ${category.name}'), backgroundColor: Colors.redAccent));
              }
              return success;
            }
            return false;
          } else {
            final result = await showUpdateProductCategoryDialog(
              context,
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
  }

  // Helper widget untuk background swipe
  Widget _buildSwipeActionContainer({
    required Color color,
    required IconData icon,
    required String text,
    required Alignment alignment,
  }) {
    bool isLeft = alignment == Alignment.centerLeft;
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLeft) Icon(icon, color: Colors.white),
          if (isLeft) const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.white)),
          if (!isLeft) const SizedBox(width: 8),
          if (!isLeft) Icon(icon, color: Colors.white),
        ],
      ),
    );
  }
}