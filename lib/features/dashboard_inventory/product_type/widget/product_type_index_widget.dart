import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../services/api_base.dart';
import '../../product_type/models/product_type_index_model.dart';

class ProductTypeScreen extends StatefulWidget {
  const ProductTypeScreen({super.key});

  @override
  State<ProductTypeScreen> createState() => _ProductTypeScreenState();
}

class _ProductTypeScreenState extends State<ProductTypeScreen> {
  late Future<List<ProductType>> futureTypes;

  @override
  void initState() {
    super.initState();
    futureTypes = fetchProductTypes();
  }

  // Fungsi untuk memuat ulang data
  void _reloadData() {
    setState(() {
      futureTypes = fetchProductTypes();
    });
  }

  Future<List<ProductType>> fetchProductTypes() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }

    final url = Uri.parse("${ApiBase.baseUrl}/inventory/product-type/");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    print('Response Body from fetchProductTypes: ${response.body}');

    if (response.statusCode == 200) {
      // 1. Decode respons sebagai Map (objek)
      final Map<String, dynamic> decoded = jsonDecode(response.body);

      // 2. Cek status dan pastikan ada kunci 'data' yang berisi List
      if (decoded['status'] == true && decoded['data'] is List) {
        final List<dynamic> dataList = decoded['data'];
        // 3. Ubah setiap item di dalam list menjadi objek ProductType
        return dataList.map((item) => ProductType.fromJson(item)).toList();
      } else {
        // Lemparkan error jika format tidak sesuai
        throw Exception("Format respons API tidak valid atau status gagal.");
      }
    } else {
      throw Exception("Gagal memuat data: Status code ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ProductType>>(
        future: futureTypes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Tampilkan tombol coba lagi jika ada error
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${snapshot.error}"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _reloadData,
                    child: const Text("Coba Lagi"),
                  )
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data product type"));
          }

          final types = snapshot.data!;

          // Tambahkan RefreshIndicator untuk pull-to-refresh
          return RefreshIndicator(
            onRefresh: () async {
              _reloadData();
            },
            child: ListView.builder(
              itemCount: types.length,
              itemBuilder: (context, index) {
                final type = types[index];
                return ListTile(
                  leading: Text("${type.id}"),
                  title: Text(type.name),
                );
              },
            ),
          );
        },
      ),
      // Tombol FAB untuk refresh manual
      floatingActionButton: FloatingActionButton(
        onPressed: _reloadData,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}