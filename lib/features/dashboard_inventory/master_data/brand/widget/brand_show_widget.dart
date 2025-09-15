import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../models/brand_show_models.dart';

BrandShowModel _parseBrand(String responseBody) {
  final Map<String, dynamic> data = jsonDecode(responseBody);
  return BrandShowModel.fromJson(data);
}

class BrandShowWidget extends StatefulWidget {
  final int brandId;

  const BrandShowWidget({super.key, required this.brandId});

  @override
  State<BrandShowWidget> createState() => _BrandShowWidgetState();
}

class _BrandShowWidgetState extends State<BrandShowWidget> {
  late Future<BrandShowModel> futureBrand;

  @override
  void initState() {
    super.initState();
    futureBrand = fetchBrand(widget.brandId);
  }

  void _reloadData() {
    setState(() {
      futureBrand = fetchBrand(widget.brandId);
    });
  }

  Future<BrandShowModel> fetchBrand(int id) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }

    final url = Uri.parse("${ApiBase.baseUrl}/inventory/brand/$id");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return compute(_parseBrand, response.body);
    } else {
      throw Exception("Gagal memuat data: Status code ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BrandShowModel>(
      future: futureBrand,
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
                  child: const Text("Coba Lagi"),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData) {
          return const Center(child: Text("Data brand tidak ditemukan"));
        }

        final brand = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async => _reloadData(),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              ListTile(
                title: const Text("Brand Name"),
                subtitle: Text(brand.brandName),
              ),
              ListTile(
                title: const Text("Brand Code"),
                subtitle: Text(brand.brandCode),
              ),
              ListTile(
                title: const Text("Created Date"),
                subtitle: Text(brand.createdDate ?? "-"),
              ),
              ListTile(
                title: const Text("Updated Date"),
                subtitle: Text(brand.updatedDate ?? "-"),
              ),
            ],
          ),
        );
      },
    );
  }
}
