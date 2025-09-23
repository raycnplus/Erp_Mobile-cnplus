import 'dart:convert';
import 'package:flutter/material.dart';
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

      // debug print untuk cek struktur API
      debugPrint("API Response: $decoded");

      // cek apakah hasil API berupa list atau object dengan key "data"
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
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No data available"));
        } else {
          final lots = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("No")),
                DataColumn(label: Text("Source Type")),
                DataColumn(label: Text("Lot/Serial Number")),
                DataColumn(label: Text("Product")),
                DataColumn(label: Text("Initial Qty")),
                DataColumn(label: Text("Used Qty")),
                DataColumn(label: Text("Remaining")),
                DataColumn(label: Text("Tracking Method")),
                DataColumn(label: Text("Created Date")),
              ],
              rows: List.generate(lots.length, (index) {
                final lot = lots[index];
                return DataRow(
                  cells: [
                    DataCell(Text("${index + 1}")),
                    DataCell(Text(lot.sourceType)),
                    DataCell(Text(lot.lotSerialNumber)),
                    DataCell(Text(lot.productName)),
                    DataCell(Text(lot.initialQuantity)),
                    DataCell(Text(lot.usedQuantity)),
                    DataCell(Text(lot.remainingQuantity)),
                    DataCell(Text(lot.trackingMethod)),
                    DataCell(Text(lot.createdDate)),
                  ],
                );
              }),
            ),
          );
        }
      },
    );
  }
}
