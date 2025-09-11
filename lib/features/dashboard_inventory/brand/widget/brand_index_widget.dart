import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../services/api_base.dart';
import '../../brand/models/brand_index_models.dart';


List<BrandIndexModel> _parseBrands(String responseBody) {
  final List<dynamic> data = jsonDecode(responseBody);
  return data.map((e) => BrandIndexModel.fromJson(e)).toList();
}

class BrandListWidget extends StatefulWidget {
  final ValueChanged<BrandIndexModel> onTap;

  const BrandListWidget({super.key, required this.onTap});

  @override
  State<BrandListWidget> createState() => _BrandListWidgetState();
}

class _BrandListWidgetState extends State<BrandListWidget> {
  late Future<List<BrandIndexModel>> futureBrands;

  @override
  void initState() {
    super.initState();
    futureBrands = fetchBrands();
  }

  void _reloadData() {
    setState(() {
      futureBrands = fetchBrands();
    });
  }

  Future<List<BrandIndexModel>> fetchBrands() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }

    final url = Uri.parse("${ApiBase.baseUrl}/inventory/brand/");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return compute(_parseBrands, response.body);
    } else {
      throw Exception("Gagal memuat data: Status code ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BrandIndexModel>>(
      future: futureBrands,
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
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Tidak ada data brand"));
        }

        final brands = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async => _reloadData(),
          child: ListView.builder(
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
              return ListTile(
                leading: Text("${index + 1}"), 
                title: Text(brand.brandName),
                subtitle: Text("Code: ${brand.brandCode ?? '-'}"),
                trailing: Text(brand.source),
                onTap: () => widget.onTap(brand),
              );
            },
          ),
        );
      },
    );
  }
}
