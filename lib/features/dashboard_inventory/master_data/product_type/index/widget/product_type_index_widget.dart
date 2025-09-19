import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../../../../../../../services/api_base.dart';
import '../models/product_type_index_model.dart';

import '../../update/widget/product_type_update_widget.dart';
import '../../update/models/product_type_update_models.dart';

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
  late Future<List<ProductType>> futureTypes;

  @override
  void initState() {
    super.initState();
    futureTypes = fetchProductTypes();
  }

  void reloadData() {
    setState(() {
      futureTypes = fetchProductTypes();
    });
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
    final url = Uri.parse("${ApiBase.baseUrl}/inventory/product-type/$id");
    final response = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['status'] == true;
    }
    return false;
  }

  Future<List<ProductType>> fetchProductTypes() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }
    final url = Uri.parse("${ApiBase.baseUrl}/inventory/product-type/");
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

  Future<bool?> _showDeleteConfirmationDialog(ProductType type) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withAlpha(102),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.white.withAlpha(230),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: const [
                        Icon(Icons.delete_rounded, color: Color(0xFFF35D5D), size: 50.0),
                        Positioned(top: -2, right: -8, child: Icon(Icons.star_rate_rounded, color: Color(0xFFF35D5D), size: 15)),
                        Positioned(top: 12, left: -5, child: Icon(Icons.star_rate_rounded, color: Color(0xFFF35D5D), size: 10)),
                        Positioned(bottom: 2, right: -5, child: Icon(Icons.star_rate_rounded, color: Color(0xFFF35D5D), size: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    "Are you sure you want to delete ${type.name}?",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF35D5D),
                      foregroundColor: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductType>>(
      future: futureTypes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error: ${snapshot.error}"),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: reloadData, child: const Text("Coba Lagi")),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Tidak ada data product type"));
        }

        final types = snapshot.data!;

        return RefreshIndicator(
          onRefresh: () async => reloadData(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: types.length,
            itemBuilder: (context, index) {
              final type = types[index];
              final cardBorderRadius = BorderRadius.circular(12);

              return Container(
                margin: const EdgeInsets.only(bottom: 12.0),
                decoration: BoxDecoration(
                  borderRadius: cardBorderRadius,
                  boxShadow: [BoxShadow(color: Colors.grey.withAlpha(26), spreadRadius: 0, blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Dismissible(
                  key: Key(type.id.toString()),
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Gagal menghapus ${type.name}'), backgroundColor: Colors.redAccent),
                          );
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
            },
          ),
        );
      },
    );
  }
}