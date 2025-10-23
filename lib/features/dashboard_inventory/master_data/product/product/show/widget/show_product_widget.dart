import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import '../../../../../../../services/api_base.dart';
import '../models/show_product_models.dart';

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

  Future<ProductShowResponse> fetchProductDetail(int id) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse("${ApiBase.baseUrl}/inventory/products/show/$id");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return ProductShowResponse.fromJson(decoded);
    } else {
      throw Exception("Failed to load product: ${response.statusCode}");
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "-";
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('d MMMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }

  String _safe(dynamic value, [String suffix = ""]) {
    if (value == null || value.toString().isEmpty) return "-";
    return "${value.toString()}$suffix";
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4A90E2);
    const Color accentColor = Color(0xFF50E3C2);
    const Color backgroundColor = Color(0xFFF8F9FA);
    const Color cardColor = Colors.white;
    const Color textColor = Color(0xFF333333);
    const Color subtleTextColor = Color(0xFF757575);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Product Details", style: TextStyle(color: textColor)),
        backgroundColor: cardColor,
        elevation: 1,
        iconTheme: const IconThemeData(color: textColor),
        bottom: TabBar(
          controller: _tabController,
          labelColor: primaryColor,
          unselectedLabelColor: subtleTextColor,
          indicatorColor: primaryColor,
          indicatorWeight: 3,
          tabs: const [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline),
                  SizedBox(width: 8),
                  Text("General"),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined),
                  SizedBox(width: 8),
                  Text("Inventory"),
                ],
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<ProductShowResponse>(
        future: _futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: primaryColor));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "No data available.",
                style: TextStyle(color: subtleTextColor),
              ),
            );
          }

          final productData = snapshot.data!;
          final product = productData.product;
          final detail = productData.productDetail;
          final inventory = productData.inventory;

          return TabBarView(
            controller: _tabController,
            children: [
              _buildGeneralTab(product, detail, inventory, productData.createdByName,
                  textColor, subtleTextColor, cardColor, accentColor),
              _buildInventoryTab(
                  inventory, textColor, subtleTextColor, cardColor),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGeneralTab(
    Product product,
    ProductDetail detail,
    Inventory inventory,
    String? createdByName,
    Color textColor,
    Color subtleTextColor,
    Color cardColor,
    Color accentColor,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            cardColor: cardColor,
            textColor: textColor,
            subtleTextColor: subtleTextColor,
            title: product.productName,
            subtitle: product.productCode,
            icon: Icons.label_important_outline,
            iconColor: accentColor,
          ),
          const SizedBox(height: 16),
          _buildDetailsCard(
            cardColor: cardColor,
            textColor: textColor,
            subtleTextColor: subtleTextColor,
            title: "Product Details",
            icon: Icons.category_outlined,
            details: {
              "Product Type": _safe(detail.productType),
              "Category": _safe(detail.productCategory),
              "Brand": _safe(detail.productBrand),
              "Unit of Measure": _safe(detail.unitOfMeasureName),
              "Barcode": _safe(detail.barcode),
              "Tracking Method": _safe(inventory.trackingMethod),
            },
          ),
          const SizedBox(height: 16),
          _buildDetailsCard(
            cardColor: cardColor,
            textColor: textColor,
            subtleTextColor: subtleTextColor,
            title: "Pricing",
            icon: Icons.attach_money_outlined,
            details: {
              "Sales Price": _safe(detail.salesPrice, " USD"),
              "Cost Price": _safe(detail.costPrice, " USD"),
            },
          ),
          const SizedBox(height: 16),
          _buildDetailsCard(
            cardColor: cardColor,
            textColor: textColor,
            subtleTextColor: subtleTextColor,
            title: "Metadata",
            icon: Icons.person_outline,
            details: {
              "Created By": _safe(createdByName),
              "Created On": _formatDate(product.createdDate),
            },
          ),
          const SizedBox(height: 16),
          if (detail.noteDetail != null && detail.noteDetail!.isNotEmpty)
            _buildNotesCard(
              cardColor: cardColor,
              textColor: textColor,
              subtleTextColor: subtleTextColor,
              title: "Notes",
              content: detail.noteDetail!,
            ),
        ],
      ),
    );
  }

  Widget _buildInventoryTab(
    Inventory inventory,
    Color textColor,
    Color subtleTextColor,
    Color cardColor,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildDetailsCard(
            cardColor: cardColor,
            textColor: textColor,
            subtleTextColor: subtleTextColor,
            title: "Dimensions",
            icon: Icons.straighten_outlined,
            details: {
              "Weight": _safe(inventory.weight, " kg"),
              "Length": _safe(inventory.length, " cm"),
              "Width": _safe(inventory.width, " cm"),
              "Height": _safe(inventory.height, " cm"),
              "Volume": _safe(inventory.volume, " m³"),
            },
          ),
          const SizedBox(height: 16),
          _buildDetailsCard(
            cardColor: cardColor,
            textColor: textColor,
            subtleTextColor: subtleTextColor,
            title: "Metadata",
            icon: Icons.person_outline,
            details: {
              "Created By": _safe(inventory.createdBy),
              "Created On": _formatDate(inventory.createdDate),
            },
          ),
          const SizedBox(height: 16),
          if (inventory.noteInventory != null &&
              inventory.noteInventory!.isNotEmpty)
            _buildNotesCard(
              cardColor: cardColor,
              textColor: textColor,
              subtleTextColor: subtleTextColor,
              title: "Inventory Notes",
              content: inventory.noteInventory!,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required Color cardColor,
    required Color textColor,
    required Color subtleTextColor,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.1),
              foregroundColor: iconColor,
              child: Icon(icon),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: subtleTextColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard({
    required Color cardColor,
    required Color textColor,
    required Color subtleTextColor,
    required String title,
    required IconData icon,
    required Map<String, String> details,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: subtleTextColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...details.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(color: subtleTextColor, fontSize: 14),
                    ),
                    Flexible(
                      child: Text(
                        entry.value,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: textColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard({
    required Color cardColor,
    required Color textColor,
    required Color subtleTextColor,
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textColor,
              ),
            ),
            const Divider(height: 24),
            Text(
              content,
              style: TextStyle(color: subtleTextColor, fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}