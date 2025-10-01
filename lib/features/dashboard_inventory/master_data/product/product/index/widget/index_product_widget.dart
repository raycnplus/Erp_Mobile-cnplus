import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart'; // Tambahkan import GoogleFonts
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

    final url = Uri.parse("${ApiBase.baseUrl}/inventory/products/");

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
          return const Center(
            child: Text(
              "No product data available",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        final products = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async => _reloadData(),
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              // Tentukan warna dan teks untuk status stok (lebih dari 10 dianggap "Safe")
              Color stockStatusColor = product.onHand > 10 ? const Color(0xFF2D6A4F) : Colors.red.shade700;
              String stockStatusText = product.onHand > 10 ? 'Safe Stock' : 'Low Stock!';

              // Warna untuk harga (Biru lebih cerah dari sebelumnya)
              const Color sellPriceColor = Color(0xFF1E90FF);
              const Color purchasePriceColor = Color(0xFFFFA500); // Warna Oranye

              return Card(
                // Card yang lebih cerah dan elegan
                color: Colors.white,
                elevation: 4, // Shadow yang lebih jelas
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Sudut lebih membulat
                  side: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
                child: InkWell(
                  onTap: () => widget.onTap(product),
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // === 1. TOP SECTION: Product Name & Stock Status Chip ===
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Product Name (Title)
                            Expanded(
                              child: Text(
                                product.productName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18, // Lebih besar dan bold
                                    color: Colors.black87
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Stock Status Chip
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: stockStatusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: stockStatusColor, width: 1),
                              ),
                              child: Text(
                                stockStatusText,
                                style: TextStyle(
                                  color: stockStatusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20, thickness: 0.5),

                        // === 2. MIDDLE SECTION: Code & Stock Value ===
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Product Code (Kode diletakkan di tengah)
                            Row(
                              children: [
                                const Icon(Icons.qr_code, size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(
                                    product.productCode,
                                    style: GoogleFonts.roboto(
                                        color: Colors.grey.shade700,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500
                                    )
                                ),
                              ],
                            ),

                            // On Hand Stock (Menarik Perhatian)
                            Row(
                              children: [
                                Icon(Icons.inventory, size: 16, color: stockStatusColor),
                                const SizedBox(width: 6),
                                Text(
                                  "${product.onHand} Pcs",
                                  style: GoogleFonts.poppins(
                                      color: stockStatusColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // === 3. BOTTOM SECTION: Prices (Inline) ===
                        Row(
                          children: [
                            // Harga Jual (Sell Price)
                            _buildPriceLabel(
                                "Sell Price",
                                product.salesPrice,
                                sellPriceColor,
                                Icons.sell
                            ),
                            const SizedBox(width: 20),
                            // Harga Beli (Purchase Price)
                            _buildPriceLabel(
                                "Buy Price",
                                product.purchasePrice,
                                purchasePriceColor,
                                Icons.shopping_cart
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

  // Helper Widget untuk Harga agar Lebih Rapi
  Widget _buildPriceLabel(String title, double? price, Color color, IconData icon) {
    String formattedPrice = price != null ? price.toStringAsFixed(0) : '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            title,
            style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
                fontWeight: FontWeight.w500
            )
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Icon(icon, size: 14, color: color.withOpacity(0.8)),
            const SizedBox(width: 4),
            Text(
              formattedPrice,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: color
              ),
            ),
          ],
        ),
      ],
    );
  }
}