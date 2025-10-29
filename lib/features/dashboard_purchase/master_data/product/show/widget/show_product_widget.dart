// show_product_widget.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../../../../../../../services/api_base.dart';
import '../models/show_product_models.dart'; // PERBAIKI: import model, bukan widget

class ProductShowWidget extends StatefulWidget {
  final int productId;

  const ProductShowWidget({super.key, required this.productId});

  @override
  State<ProductShowWidget> createState() => _ProductShowWidgetState();
}

class _ProductShowWidgetState extends State<ProductShowWidget>
    with SingleTickerProviderStateMixin {
  final storage = const FlutterSecureStorage();
  late TabController _tabController;
  late Future<ProductShowResponse> _futureProduct;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _futureProduct = fetchProductDetail(widget.productId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<ProductShowResponse> fetchProductDetail(int id) async {
    try {
      final token = await storage.read(key: 'token');
      final url = Uri.parse("${ApiBase.baseUrl}/inventory/products/$id");

      debugPrint("=== FETCH PRODUCT DETAIL ===");
      debugPrint("URL: $url");

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      debugPrint("STATUS CODE: ${response.statusCode}");
      debugPrint("RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return ProductShowResponse.fromJson(jsonData);
      } else {
        throw Exception("Failed to load product: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      rethrow;
    }
  }

  String formatPrice(double? price) {
    if (price == null || price == 0) return "-";
    // Format dengan thousand separator
    final formatter = NumberFormat('#,###', 'id_ID');
    return "Rp ${formatter.format(price)}";
  }

  String safeString(String? value) {
    if (value == null || value.isEmpty) return "-";
    return value;
  }

  String safeInt(int? value) {
    if (value == null) return "-";
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "General"),
            Tab(text: "Inventory"),
          ],
        ),
      ),
      body: FutureBuilder<ProductShowResponse>(
        future: _futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      "Failed to load product",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _futureProduct = fetchProductDetail(widget.productId);
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No data available"));
          }

          final product = snapshot.data!;

          return TabBarView(
            controller: _tabController,
            children: [
              // General Tab
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildField("Product Name", product.productName),
                  _buildField("Product Code", product.productCode),
                  _buildField("Product Type", safeInt(product.productType)),
                  _buildField("Product Category", safeInt(product.productCategory)),
                  _buildField("Product Brand", safeString(product.productBrand)),
                  _buildField("Unit of Measure", product.unitOfMeasureName),
                  _buildField("Sales Price", formatPrice(product.salesPrice)),
                  _buildField("Cost Price", formatPrice(product.costPrice)),
                  _buildField("Barcode", safeString(product.detailBarcode)),
                  _buildField("Tracking", safeString(product.trackingMethod)), // <- Menggunakan safeString di sini
                  _buildField("Created On", product.createdDate),
                  _buildField("Created By", safeString(product.createdByName)),
                   _buildField("General Notes", safeString(product.noteDetail)), // <- Menggunakan safeString di sini
                ],
              ),

              // Inventory Tab
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildField("Weight", safeString(product.weight)),
                  _buildField("Length", safeString(product.length)),
                  _buildField("Width", safeString(product.width)),
                  _buildField("Height", safeString(product.height)),
                  _buildField("Volume", safeString(product.volume)),
                  _buildField("Tracking Method", safeString(product.trackingMethod)), // <- Menggunakan safeString di sini
                  _buildField("Created On", product.inventoryCreatedDate),
                  _buildField("Inventory Notes", safeString(product.noteInventory)), // <- Menggunakan safeString di sini
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // =======================================================================
  // ====================== PERBAIKAN DI SINI ==============================
  // =======================================================================
  
  Widget _buildField(String label, String? value) { // [UBAH 1] Menerima String? (nullable)
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value ?? "-", // [UBAH 2] Menampilkan "-" jika nilai value adalah null
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}