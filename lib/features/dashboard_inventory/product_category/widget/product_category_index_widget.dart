import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../services/api_base.dart';
import '../../product_category/models/product_category_index.dart';


List<ProductCategory> _parseProductCategories(String responseBody) {
  final List<dynamic> data = jsonDecode(responseBody);
  return data.map((e) => ProductCategory.fromJson(e)).toList();
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
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
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
                  child: Text("Error: ${snapshot.error}"),
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
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                leading: Text("${index + 1}"),
                title: Text(category.name), // Replace 'name' with the actual property if different
                subtitle: Text("ID: ${category.id}"),
                onTap: () => widget.onTap(category),  
              );
            },
          ),
        );
      },
    );
  }
}