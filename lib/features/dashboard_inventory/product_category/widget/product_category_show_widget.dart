import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../services/api_base.dart';
import '../../product_category/models/product_category_show_models.dart';

class ProductCategoryShowScreen extends StatefulWidget {
  final int id;

  const ProductCategoryShowScreen({super.key, required this.id});

  @override
  State<ProductCategoryShowScreen> createState() =>
      _ProductCategoryShowScreenState();
}

class _ProductCategoryShowScreenState
    extends State<ProductCategoryShowScreen> {
  late Future<ProductCategoryShowModels> futureDetail;

  @override
  void initState() {
    super.initState();
    futureDetail = fetchProductCategoryDetail(widget.id);
  }

  Future<ProductCategoryShowModels> fetchProductCategoryDetail(int id) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }

    final url = Uri.parse("${ApiBase.baseUrl}/inventory/product-category/$id");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    print("Response Body (detail): ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);

      if (decoded['status'] == true && decoded['data'] != null) {
        return ProductCategoryShowModels.fromJson(decoded['data']);
      } else {
        throw Exception("Format respons API tidak valid atau data kosong.");
      }
    } else {
      throw Exception("Gagal memuat detail: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Category Detail")),
      body: FutureBuilder<ProductCategoryShowModels>(
        future: futureDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${snapshot.error}"),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureDetail =
                            fetchProductCategoryDetail(widget.id);
                      });
                    },
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Data tidak ditemukan"));
          }

          final category = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text("ID: ${category.id}",
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text("Category Product Name: ${category.productCategoryName}",
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text("Created On: ${category.createdOn}",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("Created By: ${category.createdBy ?? '-'}",
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
