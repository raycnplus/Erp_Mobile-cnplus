import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../../../../services/api_base.dart';
import '../models/index_product_models.dart';

List<ProductIndexModel> _parseProducts(String responseBody) {
  final dynamic parsed = jsonDecode(responseBody);

  if (parsed is Map<String, dynamic> && parsed.containsKey('data')) {
    final data = parsed['data'];
    if (data is List) {
      return data.map((e) => ProductIndexModel.fromJson(e)).toList();
    } else {
      throw Exception("Field 'data' is not a List");
    }
  } else if (parsed is List) {
    return parsed.map((e) => ProductIndexModel.fromJson(e)).toList();
  } else {
    throw Exception("Product response format is invalid");
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
      throw Exception("Token not found. Please log in again.");
    }

    final url = Uri.parse("${ApiBase.baseUrl}/purchase/products/");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      return compute(_parseProducts, response.body);
    } else {
      throw Exception("Failed to load data: Status code ${response.statusCode}");
    }
  }

  // --- _deleteProduct function REMOVED as requested ---
  // The deletion logic should be moved to the Show/Detail screen.
  
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
                  child: const Text("Try Again"),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No product data available"));
        }

        final products = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async => _reloadData(),
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              
              // Determine color for On Hand
              Color onHandColor = product.onHand > 10 ? Colors.green.shade700 : Colors.red.shade700;

              // Mengganti ListTile/Row kustom sebelumnya dengan layout yang lebih ringkas
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                // Menggunakan InkWell untuk efek visual saat diklik
                child: InkWell(
                  onTap: () => widget.onTap(product), 
                  child: Padding(
                    // Padding yang lebih simetris dan aman
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0), 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // === 1. PRODUCT NAME (Title) ===
                        Text(
                          product.productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 16,
                              color: Colors.black87 
                          ), 
                        ),
                        const SizedBox(height: 5), // Pemisah visual

                        // === 2. CODE & STOCK (Baris Detail 1) ===
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Product Code
                            Text(
                              "Code: ${product.productCode}", 
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12)
                            ),
                            
                            // Stock
                            Text(
                              "Stock: ${product.onHand}",
                              style: TextStyle(
                                color: onHandColor, 
                                fontWeight: FontWeight.bold, 
                                fontSize: 13 // Sedikit lebih besar agar menonjol
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),

                        // === 3. PRICES (Baris Detail 2) ===
                        Row(
                          children: [
                            Text(
                              "Sell: ${product.salesPrice?.toStringAsFixed(0) ?? '-'}",
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF4A90E2)), // Warna biru untuk harga jual
                            ),
                            const SizedBox(width: 15),
                            Text(
                              "Buy: ${product.purchasePrice?.toStringAsFixed(0) ?? '-'}",
                              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade500, fontSize: 13),
                            ),
                          ],
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