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

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        return decoded.map((e) => ProductType.fromJson(e)).toList();
      } else if (decoded is Map) {
        return [ProductType.fromJson(decoded as Map<String, dynamic>)];
      } else {
        throw Exception("Format response tidak dikenali");
      }
    } else {
      throw Exception("Gagal memuat data: Status code ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Types")),
      body: FutureBuilder<List<ProductType>>(
        future: futureTypes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data product type"));
          }

          final types = snapshot.data!;

          return ListView.builder(
            itemCount: types.length,
            itemBuilder: (context, index) {
              final type = types[index];
              return ListTile(
                leading: Text("${type.id}"),
                title: Text(type.name),
              );
            },
          );
        },
      ),
    );
  }
}
