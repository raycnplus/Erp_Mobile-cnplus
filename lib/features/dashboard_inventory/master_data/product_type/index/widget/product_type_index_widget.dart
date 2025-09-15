import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../../../../../../../services/api_base.dart';
import '../models/product_type_index_model.dart';

class ProductTypeScreen extends StatefulWidget {
  final void Function(ProductType type)? onTap;

  const ProductTypeScreen({super.key, this.onTap});

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

  void _reloadData() {
    setState(() {
      futureTypes = fetchProductTypes();
    });
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'No date';
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('d MMM yyyy').format(dateTime);
    } catch (e) {
      return dateString;
    }
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
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      if (decoded['status'] == true && decoded['data'] is List) {
        final List<dynamic> dataList = decoded['data'];
        return dataList.map((item) => ProductType.fromJson(item)).toList();
      } else {
        throw Exception("Format respons API tidak valid atau status gagal.");
      }
    } else {
      throw Exception("Gagal memuat data: Status code ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductType>>(
      future: futureTypes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error: ${snapshot.error}"),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _reloadData,
                  child: const Text("Coba Lagi"),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Tidak ada data product type"));
        }

        final types = snapshot.data!;

        return RefreshIndicator(
          onRefresh: () async {
            _reloadData();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: types.length,
            itemBuilder: (context, index) {
              final type = types[index];
              final cardBorderRadius = BorderRadius.circular(12);

              // 1. Widget untuk bayangan (di lapisan bawah)
              return Container(
                margin: const EdgeInsets.only(bottom: 12.0),
                decoration: BoxDecoration(
                  borderRadius: cardBorderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                // 2. Dismissible sekarang menjadi anak dari container bayangan
                child: Dismissible(
                  key: Key(type.id.toString()),
                  // 3. Latar belakang aksi juga memiliki border radius
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: cardBorderRadius,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: const Row(
                      children: [
                        Icon(Icons.edit, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Edit', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: cardBorderRadius,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Delete', style: TextStyle(color: Colors.white)),
                        SizedBox(width: 8),
                        Icon(Icons.delete, color: Colors.white),
                      ],
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    // ... (logika confirmDismiss tetap sama)
                    if (direction == DismissDirection.endToStart) {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Konfirmasi"),
                            content: Text("Anda yakin ingin menghapus ${type.name}?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text("Batal"),
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: Panggil API untuk menghapus data di sini
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${type.name} dihapus')),
                                  );
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          );
                        },
                      );
                    } else { // Aksi Edit
                      // TODO: Navigasi ke halaman edit di sini
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Navigasi ke halaman Edit ${type.name}')),
                      );
                      return false; // Jangan hapus item dari list saat edit
                    }
                  },
                  // 4. Ini adalah KARTU KONTEN yang akan bergeser (tanpa bayangan)
                  child: ClipRRect(
                    borderRadius: cardBorderRadius,
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          if (widget.onTap != null) {
                            widget.onTap!(type);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              // Ikon dan SizedBox dihilangkan dari sini
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      type.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Created: ${_formatDate(type.createdDate)}",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
}