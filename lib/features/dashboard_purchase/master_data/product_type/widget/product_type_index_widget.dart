import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../../../../../../../services/api_base.dart';
import '../models/product_type_index_models.dart';

import '../widget/product_type_update_widget.dart';
import '../../product_type/models/product_type_update_models.dart';
import 'product_type_list_shimmer.dart';

class ProductTypeScreen extends StatefulWidget {
  final void Function(ProductType type)? onTap;
  final VoidCallback? onUpdateSuccess;
  final Function(String name)? onDeleteSuccess;

  const ProductTypeScreen({
    super.key,
    this.onTap,
    this.onUpdateSuccess,
    this.onDeleteSuccess,
  });

  @override
  State<ProductTypeScreen> createState() => ProductTypeScreenState();
}

class ProductTypeScreenState extends State<ProductTypeScreen> {
  bool _isLoading = true;
  List<ProductType> _productTypes = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Saat refresh, jangan langsung set state agar data lama tetap terlihat
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final data = await fetchProductTypes();
      if (mounted) {
        setState(() {
          _productTypes = data;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
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

  Future<List<ProductType>> fetchProductTypes() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }
    final url = Uri.parse("${ApiBase.baseUrl}/purchase/product-type/");
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      if (decoded['status'] == true && decoded['data'] is List) {
        final List<dynamic> dataList = decoded['data'];
        return dataList.map((item) => ProductType.fromJson(item)).toList();
      } else {
        throw Exception("Format respons API tidak valid atau status gagal.");
      }
    } else {
      throw Exception("Gagal memuat data: Status code ${response.statusCode}");
    }
  }

  Future<void> _showUpdateDialog(ProductType type) async {
    final bool? wasUpdated = await showUpdateProductTypeDialog(
      context,
      id: type.id,
      initialData: ProductTypeUpdateModel(productTypeName: type.name),
    );
    if (wasUpdated == true) {
      reloadData();
      widget.onUpdateSuccess?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_isLoading && _productTypes.isEmpty) {
      content = const ProductTypeListShimmer();
    } else if (_error != null) {
      content = Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Error: $_error"),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: reloadData, child: const Text("Coba Lagi")),
        ]),
      );
    } else if (_productTypes.isEmpty) {
      // 3. State Data Kosong
      content = const Center(child: Text("Tidak ada data product type"));
    } else {
      // 4. State Data Tersedia (atau saat refresh)
      content = _isLoading
        ? ProductTypeListShimmer(itemCount: _productTypes.length)
        : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _productTypes.length,
            itemBuilder: (context, index) {
              final type = _productTypes[index];
              return _buildProductTypeCard(type);
            },
          );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: content,
    );
  }

  Widget _buildProductTypeCard(ProductType type) {
    final cardBorderRadius = BorderRadius.circular(12);
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        borderRadius: cardBorderRadius,
        boxShadow: [BoxShadow(color: Colors.grey.withAlpha(26), spreadRadius: 0, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Dismissible(
        key: Key(type.id.toString()),
        background: _buildSwipeActionContainer(color: Colors.blue, icon: Icons.edit, text: 'Edit', alignment: Alignment.centerLeft),
        secondaryBackground: _buildSwipeActionContainer(color: Colors.red, icon: Icons.delete, text: 'Delete', alignment: Alignment.centerRight),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            bool? deleteConfirmed = await _showDeleteConfirmationDialog(type);
            if (deleteConfirmed == true) {
              final success = await _deleteProductType(type.id);
              if (!mounted) return false;
              if (success) {
                reloadData();
                widget.onDeleteSuccess?.call(type.name);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menghapus ${type.name}'), backgroundColor: Colors.redAccent));
              }
              return success;
            }
            return false;
          } else {
            _showUpdateDialog(type);
            return false;
          }
        },
        child: ClipRRect(
          borderRadius: cardBorderRadius,
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                if (widget.onTap != null) {
                  widget.onTap!(type);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(type.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text("Created: ${_formatDate(type.createdDate)}", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Sisa fungsi helper
  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'No date';
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('d MMM yyyy').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  Future<bool> _deleteProductType(int id) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final url = Uri.parse("${ApiBase.baseUrl}/sales/product-type/$id");
    final response = await http.delete(url, headers: {"Authorization": "Bearer $token", "Accept": "application/json"});
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['status'] == true;
    }
    return false;
  }

  Container _buildSwipeActionContainer({required Color color, required IconData icon, required String text, required Alignment alignment}) {
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerLeft) ...[Icon(icon, color: Colors.white), const SizedBox(width: 8)],
          Text(text, style: const TextStyle(color: Colors.white)),
          if (alignment == Alignment.centerRight) ...[const SizedBox(width: 8), Icon(icon, color: Colors.white)],
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(ProductType type) {
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 50, width: 50,
                    child: Stack(
                      clipBehavior: Clip.none, alignment: Alignment.center,
                      children: const [
                        Icon(Icons.delete_rounded, color: Color(0xFFF35D5D), size: 50.0),
                        Positioned(top: -2, right: -8, child: Icon(Icons.star_rate_rounded, color: Color(0xFFF35D5D), size: 15)),
                        Positioned(top: 12, left: -5, child: Icon(Icons.star_rate_rounded, color: Color(0xFFF35D5D), size: 10)),
                        Positioned(bottom: 2, right: -5, child: Icon(Icons.star_rate_rounded, color: Color(0xFFF35D5D), size: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text("Are you sure you want to delete ${type.name}?", textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}