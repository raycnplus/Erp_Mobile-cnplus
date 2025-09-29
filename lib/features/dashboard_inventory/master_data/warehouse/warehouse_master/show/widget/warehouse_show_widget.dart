import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import '../../../../../../../services/api_base.dart';
import '../models/warehouse_show_models.dart';

class WarehouseShowWidget extends StatefulWidget {
  final int warehouseId;

  const WarehouseShowWidget({super.key, required this.warehouseId});

  @override
  State<WarehouseShowWidget> createState() => WarehouseShowWidgetInternalState();
}

class WarehouseShowWidgetInternalState extends State<WarehouseShowWidget> {
  WarehouseShowModel? _warehouse;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  Future<void> refreshData() async {
    if (mounted) setState(() { _isLoading = true; _error = null; });

    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      if (token == null) throw Exception("Token tidak ditemukan.");

      final response = await http.get(
        Uri.parse("${ApiBase.baseUrl}/inventory/warehouse/${widget.warehouseId}"),
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      );
      // DEBUG: Print response body ke console
      print('Warehouse Detail Response: ' + response.body);
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      // Ambil data dari kunci 'warehouse' jika ada
      dynamic rawData = decoded;
      if (decoded.containsKey('warehouse')) {
        rawData = decoded['warehouse'];
      } else if (decoded.containsKey('data')) {
        rawData = decoded['data'];
      }
      Map<String, dynamic>? warehouseData;
      if (rawData is List && rawData.isNotEmpty) {
        warehouseData = rawData.first as Map<String, dynamic>;
      } else if (rawData is Map<String, dynamic>) {
        warehouseData = rawData;
      }
      if (warehouseData == null) {
        throw Exception("Format data tidak valid atau kosong.");
      }
      if (mounted) {
        setState(() {
          _warehouse = WarehouseShowModel.fromJson(warehouseData!);
        });
      }
    } catch (e) {
      if (mounted) _error = e.toString().replaceFirst("Exception: ", "");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('d MMM yyyy, HH:mm').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Error: $_error"),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: refreshData, child: const Text("Coba Lagi")),
        ]),
      );
    }

    if (_warehouse == null) {
      return const Center(child: Text("Data tidak ditemukan"));
    }

    return RefreshIndicator(
      onRefresh: refreshData,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDetailCard(
            context,
            title: "Warehouse Information",
            icon: Icons.warehouse_rounded,
            children: [
              _buildDetailRow("Warehouse Name", _warehouse!.warehouseName),
              _buildDetailRow("Warehouse Code", _warehouse!.warehouseCode),
              _buildDetailRow("Branch", _warehouse!.branch),
              _buildDetailRow("Address", _warehouse!.address),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailCard(
            context,
            title: "Dimensions",
            icon: Icons.straighten_rounded,
            children: [
              _buildDetailRow("Length", _warehouse!.length?.toString(), unit: "m"),
              _buildDetailRow("Width", _warehouse!.width?.toString(), unit: "m"),
              _buildDetailRow("Height", _warehouse!.height?.toString(), unit: "m"),
              _buildDetailRow("Volume", _warehouse!.volume?.toString(), unit: "m³"),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailCard(
            context,
            title: "Details",
            icon: Icons.notes_rounded,
            children: [
              _buildDetailRow("Description", _warehouse!.description),
              _buildDetailRow("Created Date", _formatDate(_warehouse!.createdDate)),
              _buildDetailRow("Created By", _warehouse!.createdBy?.toString()),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildDetailCard(BuildContext context, {required String title, String? subtitle, IconData? icon, required List<Widget> children}) {
  return Card(
    elevation: 2,
    shadowColor: Colors.black.withOpacity(0.05),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: Theme.of(context).primaryColor, size: 28),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          ...children,
        ],
      ),
    ),
  );
}

Widget _buildDetailRow(String label, String? value, {String? unit}) {
  final displayValue = (value == null || value.isEmpty || value == 'null') ? 'N/A' : value;
  final displayUnit = (value == null || value.isEmpty || value == 'null') ? '' : (unit ?? '');

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          displayUnit.isNotEmpty ? '$displayValue $displayUnit' : displayValue,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
      ],
    ),
  );
}