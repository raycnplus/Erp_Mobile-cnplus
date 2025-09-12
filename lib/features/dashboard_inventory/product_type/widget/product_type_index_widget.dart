// product_type_index_widget.dart

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../../../../../services/api_base.dart';
import '../../product_type/models/product_type_index_model.dart';

class ProductTypeScreen extends StatefulWidget {
  final void Function(ProductType type)? onTap;

  const ProductTypeScreen({super.key, this.onTap});

  @override
  State<ProductTypeScreen> createState() => _ProductTypeScreenState();
}

class _ProductTypeScreenState extends State<ProductTypeScreen> {
  late Future<List<ProductType>> futureTypes;

  @override
  void initState() {
    super.initState();
    futureTypes = fetchProductTypes();
  }

  void _reloadData() {
    setState(() {
      futureTypes = fetchProductTypes();
    });
  }

  // Fungsi untuk memilih ikon berdasarkan nama product type
  IconData _getIconForProductType(String productTypeName) {
    String name = productTypeName.toLowerCase();
    if (name.contains('storable')) {
      return Icons.inventory_2_outlined;
    } else if (name.contains('service')) {
      return Icons.build_outlined;
    } else if (name.contains('consumable')) {
      return Icons.fastfood_outlined;
    } else if (name.contains('free')) {
      return Icons.card_giftcard_outlined;
    } else {
      return Icons.category_outlined;
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
                ElevatedButton(
                  onPressed: _reloadData,
                  child: const Text("Coba Lagi"),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Tidak ada data product type"));
        }

        final types = snapshot.data!;

        return RefreshIndicator(
          onRefresh: () async {
            _reloadData();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: types.length,
            itemBuilder: (context, index) {
              final type = types[index];
              return Card(
                color: Colors.white,
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    if (widget.onTap != null) {
                      widget.onTap!(type);
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          _getIconForProductType(type.name),
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                type.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Created: ${_formatDate(type.createdDate)}",
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
              );
            },
          ),
        );
      },
    );
  }
}