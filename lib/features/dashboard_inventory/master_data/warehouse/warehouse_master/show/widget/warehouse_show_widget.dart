// lib/features/dashboard_inventory/master_data/warehouse/warehouse_master/show/widget/warehouse_show_widget.dart

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
  bool hasBeenUpdated = false;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  Future<void> refreshData() async {
    hasBeenUpdated = true;
    if (mounted) setState(() { _isLoading = true; _error = null; });

    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      if (token == null) throw Exception("Token tidak ditemukan.");

      final response = await http.get(
        Uri.parse("${ApiBase.baseUrl}/inventory/warehouse/${widget.warehouseId}"),
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      );
      
      if (response.statusCode == 200) {
          final Map<String, dynamic> decoded = jsonDecode(response.body);
          
          // [PERBAIKAN] Cek key 'warehouse' sesuai dengan response API
          if (decoded.containsKey('warehouse') && decoded['warehouse'] is Map<String, dynamic>) {
            final warehouseData = decoded['warehouse'] as Map<String, dynamic>;
            if (mounted) {
              setState(() {
                _warehouse = WarehouseShowModel.fromJson(warehouseData);
              });
            }
          } else {
            // Jika struktur tidak sesuai, lempar error
            throw Exception("Struktur JSON tidak sesuai, key 'warehouse' tidak ditemukan.");
          }

      } else {
        throw Exception("Gagal memuat data: Status ${response.statusCode}");
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

  String _safe(dynamic value) {
    return (value == null || value.toString().isEmpty || value.toString() == 'null') ? '-' : value.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Error: $_error"), const SizedBox(height: 16),
          ElevatedButton(onPressed: refreshData, child: const Text("Coba Lagi")),
        ]),
      );
    }
    if (_warehouse == null) {
      return const Center(child: Text("Data tidak ditemukan"));
    }

    final warehouse = _warehouse!;
    const primaryColor = Color(0xFF679436);

    return RefreshIndicator(
      onRefresh: refreshData,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildHeaderCard(
            title: warehouse.warehouseName,
            subtitle: warehouse.warehouseCode,
            icon: Icons.warehouse_rounded,
            iconColor: primaryColor,
          ),
          const SizedBox(height: 16),
          _buildDetailCard(
            title: "General Information",
            children: [
              _buildDetailRow(icon: Icons.store_mall_directory_outlined, label: "Branch", value: _safe(warehouse.branch)),
              _buildDetailRow(icon: Icons.location_on_outlined, label: "Address", value: _safe(warehouse.address)),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailCard(
            title: "Dimensions",
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 16,
                children: [
                  _buildGridItem(label: "Length", value: _safe(warehouse.length), unit: "m"),
                  _buildGridItem(label: "Width", value: _safe(warehouse.width), unit: "m"),
                  _buildGridItem(label: "Height", value: _safe(warehouse.height), unit: "m"),
                  _buildGridItem(label: "Volume", value: _safe(warehouse.volume), unit: "m³"),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailCard(
            title: "Additional Info",
            children: [
              if (_safe(warehouse.description) != '-') _buildDetailRow(icon: Icons.notes_outlined, label: "Description", value: _safe(warehouse.description)),
              _buildDetailRow(icon: Icons.person_outline, label: "Created By", value: _safe(warehouse.createdBy)),
              _buildDetailRow(icon: Icons.calendar_today_outlined, label: "Created Date", value: _formatDate(warehouse.createdDate)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard({required String title, required String subtitle, required IconData icon, required Color iconColor}) {
    return Card(
      elevation: 4, shadowColor: iconColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(radius: 28, backgroundColor: iconColor.withOpacity(0.1), child: Icon(icon, size: 32, color: iconColor)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black87), overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(subtitle, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2, shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade500),
          const SizedBox(width: 12),
          Text(label, style: GoogleFonts.poppins(color: Colors.grey.shade700, fontSize: 14)),
          const Spacer(),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.black87, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem({required String label, required String value, String? unit}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          unit != null && value != '-' ? '$value $unit' : value,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }
}