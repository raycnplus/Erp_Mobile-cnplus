import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';

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
  late Future<Map<String, dynamic>> _futureProduct;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _futureProduct = fetchProductDetail(widget.productId);
  }

  Future<Map<String, dynamic>> fetchProductDetail(int id) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse("${ApiBase.baseUrl}/purchase/products/$id");

    debugPrint("=== FETCH PRODUCT DETAIL ===");
    debugPrint("URL: $url");
    debugPrint("TOKEN: $token");

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
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception("Failed to load product: ${response.statusCode}");
    }
  }

  String safe(dynamic value) {
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No data available"));
          }

          final data = snapshot.data!["data"] ?? {};
          final product = data["product"] ?? {};
          final detail = data["product_detail"] ?? {};
          final inventory = data["inventory"] ?? {};

          return TabBarView(
            controller: _tabController,
            children: [
              // General Tab
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildField("Product Name", safe(product["product_name"])),
                  _buildField("Product Code", safe(product["product_code"])),
                  _buildField("Product Type", safe(detail["product_type"])),
                  _buildField("Product Category", safe(detail["product_category"])),
                  _buildField("Product Brand", safe(detail["product_brand"])),
                  _buildField("Unit of Measure", safe(detail["unit_of_measure_name"])),
                  _buildField("Sales Price", safe(detail["sales_price"])),
                  _buildField("Cost Price", safe(detail["cost_price"])),
                  _buildField("Barcode", safe(detail["barcode"])),
                  _buildField("Tracking", safe(inventory["tracking_method"])),
                  _buildField("Created On", safe(product["created_date"])),
                  _buildField("Created By", safe(data["created_by_name"])),
                  _buildField("General Notes", safe(detail["note_detail"])),
                ],
              ),

              // Inventory Tab
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildField("Weight", safe(inventory["weight"])),
                  _buildField("Length", safe(inventory["length"])),
                  _buildField("Width", safe(inventory["width"])),
                  _buildField("Height", safe(inventory["height"])),
                  _buildField("Volume", safe(inventory["volume"])),
                  _buildField("Created On", safe(inventory["created_date"])),
                  _buildField("Created By", safe(inventory["created_by"])),
                  _buildField("Inventory Notes", safe(inventory["note_inventory"])),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 5, child: Text(value)),
        ],
      ),
    );
  }
}
