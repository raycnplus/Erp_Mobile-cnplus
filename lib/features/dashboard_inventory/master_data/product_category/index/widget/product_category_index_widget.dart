// product_category_index_widget.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';
import '../models/product_category_index_models.dart';

List<ProductCategory> _parseProductCategories(String responseBody) {
  final decoded = jsonDecode(responseBody);

  if (decoded is List) {
    return decoded.map((e) => ProductCategory.fromJson(e)).toList();
  }

  if (decoded is Map<String, dynamic> &&
      decoded['status'] == true &&
      decoded['data'] is List) {
    final List<dynamic> dataList = decoded['data'];
    return dataList.map((e) => ProductCategory.fromJson(e)).toList();
  }

  throw Exception("Format respons API tidak valid.");
}

class ProductCategoryListWidget extends StatefulWidget {
  final ValueChanged<ProductCategory> onTap;

  const ProductCategoryListWidget({super.key, required this.onTap});

  @override
  State<ProductCategoryListWidget> createState() =>
      _ProductCategoryListWidgetState();
}

class _ProductCategoryListWidgetState extends State<ProductCategoryListWidget> {
  late Future<List<ProductCategory>> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories = fetchProductCategories();
  }

  void _reloadData() {
    setState(() {
      futureCategories = fetchProductCategories();
    });
  }

  Future<List<ProductCategory>> fetchProductCategories() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }

    final url = Uri.parse("${ApiBase.baseUrl}/inventory/product-category/");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      return compute(_parseProductCategories, response.body);
    } else {
      throw Exception("Gagal memuat data: Status code ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductCategory>>(
      future: futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Error: ${snapshot.error.toString().replaceFirst("Exception: ", "")}",
                  ),
                ),
                ElevatedButton(
                  onPressed: _reloadData,
                  child: const Text("Coba Lagi"),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Tidak ada data product category"));
        }

        final categories = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async => _reloadData(),
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Dismissible(
                  key: Key(category.id.toString()),
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: cardBorderRadius,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: const Row(
                      children: [
                        Icon(Icons.edit, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Edit', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: cardBorderRadius,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Delete', style: TextStyle(color: Colors.white)),
                        SizedBox(width: 8),
                        Icon(Icons.delete, color: Colors.white),
                      ],
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      // Aksi Hapus
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Konfirmasi"),
                            content: Text(
                              "Anda yakin ingin menghapus ${category.name}?",
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("Batal"),
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: Panggil API untuk menghapus data di sini
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${category.name} dihapus'),
                                    ),
                                  );
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text(
                                  "Hapus",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // Aksi Edit
                      // TODO: Navigasi ke halaman edit di sini
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Navigasi ke halaman Edit ${category.name}',
                          ),
                        ),
                      );
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
                          // [MODIFIKASI] Menambahkan Row dan Expanded di sini
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      category.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Source: Lokal",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
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
