import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../../../../services/api_base.dart';
import '../models/index_models_brand.dart';
// IMPORT DIALOG UPDATE YANG BARU
import '../widget/brand_update_diaolog.dart';
import '../models/update_models_brand.dart';

// Import shimmer (asumsi sudah ada)
// import 'brand_list_shimmer.dart'; 

List<BrandIndexModel> _parseBrands(String responseBody) {
  try {
    final List<dynamic> data = jsonDecode(responseBody);
    return data.map((e) => BrandIndexModel.fromJson(e)).toList();
  } catch (e) {
    throw Exception("Format respons API tidak valid.");
  }
}

class BrandListWidget extends StatefulWidget {
  final ValueChanged<BrandIndexModel> onTap;
  final Function(String name)? onDeleteSuccess;
  final VoidCallback? onUpdateSuccess;

  const BrandListWidget({
    super.key,
    required this.onTap,
    this.onDeleteSuccess,
    this.onUpdateSuccess,
  });

  @override
  State<BrandListWidget> createState() => BrandListWidgetState();
}

class BrandListWidgetState extends State<BrandListWidget> {
  late Future<List<BrandIndexModel>> futureBrands;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    futureBrands = fetchBrands();
  }

  void reloadData() {
    setState(() {
      futureBrands = fetchBrands();
    });
  }

  Future<List<BrandIndexModel>> fetchBrands() async {
    final token = await _storage.read(key: 'token');
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan.");
    }
    final url = Uri.parse("${ApiBase.baseUrl}/inventory/brand/");
    final response = await http.get(url, headers: {"Authorization": "Bearer $token", "Accept": "application/json"});
    if (response.statusCode == 200) {
      return compute(_parseBrands, response.body);
    } else {
      throw Exception("Gagal memuat data: ${response.statusCode}");
    }
  }

  Future<bool> _deleteBrand(int brandId) async {
    final token = await _storage.read(key: 'token');
    final url = Uri.parse("${ApiBase.baseUrl}/inventory/brand/$brandId");
    final response = await http.delete(url, headers: {"Authorization": "Bearer $token"});
    return response.statusCode == 200;
  }

  Future<bool?> _showDeleteConfirmationDialog(BrandIndexModel brand) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withAlpha(102),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.white.withAlpha(230),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.delete_rounded, color: Color(0xFFF35D5D), size: 50.0),
                const SizedBox(height: 28),
                Text("Are you sure you want to delete ${brand.brandName}?", textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF35D5D), foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Yes, Delete", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Keep It", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BrandIndexModel>>(
      future: futureBrands,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Ganti dengan Shimmer
        } else if (snapshot.hasError) {
          return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(padding: const EdgeInsets.all(16.0), child: Text("Error: ${snapshot.error}")),
            ElevatedButton(onPressed: reloadData, child: const Text("Coba Lagi")),
          ]));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Tidak ada data brand"));
        }

        final brands = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async => reloadData(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
              final cardBorderRadius = BorderRadius.circular(12);

              return Container(
                margin: const EdgeInsets.only(bottom: 12.0),
                decoration: BoxDecoration(
                  borderRadius: cardBorderRadius,
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 0, blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Dismissible(
                  key: Key(brand.brandId.toString()),
                  background: _buildSwipeActionContainer(color: Colors.blue, icon: Icons.edit, text: 'Edit', alignment: Alignment.centerLeft),
                  secondaryBackground: _buildSwipeActionContainer(color: Colors.red, icon: Icons.delete, text: 'Delete', alignment: Alignment.centerRight),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      final confirmed = await _showDeleteConfirmationDialog(brand);
                      if (confirmed == true) {
                        final success = await _deleteBrand(brand.brandId);
                        if (!mounted) return false;
                        if (success) {
                          reloadData();
                          widget.onDeleteSuccess?.call(brand.brandName);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menghapus brand'), backgroundColor: Colors.redAccent));
                        }
                        return success;
                      }
                      return false;
                    } else {
                      // ##  ##
                      final result = await showUpdateBrandDialog(
                        context,
                        id: brand.brandId,
                        initialData: BrandUpdateModel(
                          idBrand: brand.brandId,
                          brandName: brand.brandName,
                          brandCode: brand.brandCode ?? '',
                        ),
                      );

                      if (result == true) {
                        reloadData();
                        widget.onUpdateSuccess?.call();
                      }
                      return false;
                    }
                  },
                  child: ClipRRect(
                    borderRadius: cardBorderRadius,
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () => widget.onTap(brand),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(brand.brandName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text("Code: ${brand.brandCode ?? '-'}", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                              ]),
                            ),
                          ]),
                        ),
                      ),
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

  Widget _buildSwipeActionContainer({required Color color, required IconData icon, required String text, required Alignment alignment}) {
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (alignment == Alignment.centerLeft) ...[Icon(icon, color: Colors.white), const SizedBox(width: 8)],
        Text(text, style: const TextStyle(color: Colors.white)),
        if (alignment == Alignment.centerRight) ...[const SizedBox(width: 8), Icon(icon, color: Colors.white)],
      ]),
    );
  }
}