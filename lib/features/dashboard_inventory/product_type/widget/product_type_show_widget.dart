import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../services/api_base.dart';
import '../../product_type/models/product_type_show_model.dart';

class ProductTypeShowScreen extends StatefulWidget {
  final int id;

  const ProductTypeShowScreen({super.key, required this.id});

  @override
  State<ProductTypeShowScreen> createState() => _ProductTypeShowScreenState();
}

class _ProductTypeShowScreenState extends State<ProductTypeShowScreen> {
  late Future<ProductTypeShowModel> futureDetail;

  @override
  void initState() {
    super.initState();
    futureDetail = fetchProductTypeDetail(widget.id);
  }

  Future<ProductTypeShowModel> fetchProductTypeDetail(int id) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }

    final url = Uri.parse("${ApiBase.baseUrl}/inventory/product-type/$id");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    print("Response Body (detail): ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);

      if (decoded['status'] == true && decoded['data'] != null) {
        return ProductTypeShowModel.fromJson(decoded['data']);
      } else {
        throw Exception("Format respons API tidak valid atau data kosong.");
      }
    } else {
      throw Exception("Gagal memuat detail: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Type Detail")),
      body: FutureBuilder<ProductTypeShowModel>(
        future: futureDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${snapshot.error}"),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureDetail = fetchProductTypeDetail(widget.id);
                      });
                    },
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Data tidak ditemukan"));
          }

          final type = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text("ID: ${type.idProductType}",
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text("Product Type Name: ${type.productTypeName}",
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text("Created On: ${type.createdDate ?? '-'}",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("Created By: ${type.createdBy ?? '-'}",
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
