import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/top_product_model.dart'; // model

class TopProductList extends StatefulWidget {
  final String endpoint;

  const TopProductList({super.key, required this.endpoint});

  @override
  State<TopProductList> createState() => _TopProductListState();
}

class _TopProductListState extends State<TopProductList> {
  late Future<List<TopProduct>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchTopProducts();
  }

  Future<List<TopProduct>> fetchTopProducts() async {
    final response = await http.get(Uri.parse(widget.endpoint));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return TopProduct.fromList(jsonData);
    } else {
      throw Exception('Gagal mengambil data produk');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TopProduct>>(
      future: futureProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('Tidak ada data produk');
        }

        final top5Products = snapshot.data!;
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Product",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "QTY",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: top5Products.length,
                  itemBuilder: (context, index) {
                    final product = top5Products[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(product.name),
                          Text(
                            "${product.quantity}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
