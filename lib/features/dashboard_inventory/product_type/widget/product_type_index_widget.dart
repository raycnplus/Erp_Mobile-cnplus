import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
    const token = "YOUR_TOKEN_HERE"; 
    const baseUrl = "https://erp.sorlem.com/api/inventory/product-category/"; 

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ProductType.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load product types");
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
            return const Center(child: Text("No product types found"));
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
