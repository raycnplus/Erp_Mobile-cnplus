import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../models/index_models_lsn.dart';

class LotSerialIndexWidget extends StatefulWidget {
  const LotSerialIndexWidget({super.key});

  @override
  State<LotSerialIndexWidget> createState() => _LotSerialIndexWidgetState();
}

class _LotSerialIndexWidgetState extends State<LotSerialIndexWidget> {
  final storage = const FlutterSecureStorage();
  late Future<List<LotSerialIndexModel>> futureLots;

  // Fungsi untuk mengambil data dari API (tidak ada perubahan)
  Future<List<LotSerialIndexModel>> fetchLots() async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/inventory/serial-number/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> data = decoded is List ? decoded : decoded['data'];
      return data.map((json) => LotSerialIndexModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load lot/serial number data');
    }
  }

  @override
  void initState() {
    super.initState();
    futureLots = fetchLots();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LotSerialIndexModel>>(
      future: futureLots,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text("Error: ${snapshot.error}",
                  style: GoogleFonts.poppins()));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text("No data available", style: GoogleFonts.poppins()));
        } else {
          final lots = snapshot.data!;
          // Menggunakan ListView.builder untuk performa yang lebih baik
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            itemCount: lots.length,
            itemBuilder: (context, index) {
              final lot = lots[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 2.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Baris Header Kartu: Nama Produk dan Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              lot.productName,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700, // Dibuat lebih tebal
                                color: Colors.black, // Hitam solid untuk fokus
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: lot.status.toLowerCase() == 'active'
                                  ? Colors.green.shade100
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              lot.status,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600, // Dibuat lebih tebal
                                color: lot.status.toLowerCase() == 'active'
                                    ? Colors.green.shade800
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Lot/Serial: ${lot.lotSerialNumber}',
                        style: GoogleFonts.poppins(
                          color: Colors.blueGrey.shade800, // Warna gelap yang berbeda
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Divider(height: 24, thickness: 0.5),

                      // Bagian Kuantitas
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildQuantityInfo("Initial", lot.initialQuantity),
                          _buildQuantityInfo("Used", lot.usedQuantity),
                          _buildQuantityInfo("Remaining", lot.remainingQuantity,
                              highlight: true),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Informasi Tambahan
                      _buildInfoRow("Tracking Method", lot.trackingMethod),
                      _buildInfoRow("Created Date", lot.createdDate),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  // Widget helper untuk menampilkan informasi kuantitas dengan gaya
  Widget _buildQuantityInfo(String label, String value,
      {bool highlight = false}) {
    // Menetapkan warna utama dari tema (biasanya warna biru)
    final highlightColor = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: highlight ? FontWeight.w900 : FontWeight.w700, // Remaining paling tebal
            color: highlight
                ? highlightColor // Menggunakan Primary Color untuk Remaining
                : Colors.black87, // Hitam solid untuk Initial & Used
          ),
        ),
      ],
    );
  }

  // Widget helper untuk baris informasi tambahan
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: Colors.grey.shade600)), // Label lebih terang
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600)), // Nilai lebih gelap dan tebal
        ],
      ),
    );
  }
}