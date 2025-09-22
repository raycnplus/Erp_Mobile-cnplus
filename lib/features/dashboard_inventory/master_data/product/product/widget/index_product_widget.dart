import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../../../services/api_base.dart';
import '../models/index_product_models.dart';

List<ProductIndexModel> _parseProducts(String responseBody) {
  final dynamic parsed = jsonDecode(responseBody);

  if (parsed is Map<String, dynamic> && parsed.containsKey('data')) {
    final data = parsed['data'];
    if (data is List) {
      return data.map((e) => ProductIndexModel.fromJson(e)).toList();
    } else {
      throw Exception("Field 'data' bukan berupa List");
    }
  } else if (parsed is List) {
    return parsed.map((e) => ProductIndexModel.fromJson(e)).toList();
  } else {
    throw Exception("Format response product tidak sesuai");
  }
}

class ProductListWidget extends StatefulWidget {
  final ValueChanged<ProductIndexModel> onTap;

  const ProductListWidget({
    super.key,
    required this.onTap,
  });

  @override
  State<ProductListWidget> createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  late Future<List<ProductIndexModel>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  void _reloadData() {
    setState(() {
      futureProducts = fetchProducts();
    });
  }

  Future<List<ProductIndexModel>> fetchProducts() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }

    final url = Uri.parse("${ApiBase.baseUrl}/inventory/products/");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      return compute(_parseProducts, response.body);
    } else {
      throw Exception("Gagal memuat data: Status code ${response.statusCode}");
    }
  }

  Future<void> _deleteProduct(BuildContext context, int id) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Token tidak ditemukan")),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Product"),
        content: const Text("Apakah Anda yakin ingin menghapus product ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final url = Uri.parse("${ApiBase.baseUrl}/inventory/products/$id");

    final response = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product berhasil dihapus")),
      );
      _reloadData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal hapus: ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductIndexModel>>(
      future: futureProducts,
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
          return const Center(child: Text("Tidak ada data product"));
        }

        final products = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async => _reloadData(),
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: Text("${index + 1}"),
                title: Text(product.productName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Product Name: ${product.productName}"),
                    Text("Product Code: ${product.productCode}"),
                    Text("Sales Price: ${product.salesPrice ?? '-'}"),
                    Text("Cost Price: ${product.purchasePrice ?? '-'}"),
                    Text("On Hand: ${product.onHand}"),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteProduct(context, product.idProduct),
                ),
                onTap: () => widget.onTap(product),
              );
            },
          ),
        );
      },
    );
  }
}
