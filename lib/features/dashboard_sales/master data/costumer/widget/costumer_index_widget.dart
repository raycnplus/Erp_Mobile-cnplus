// costumer_index_widget.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../models/costumer_index_models.dart';

class CustomerIndexWidget extends StatefulWidget {
  final Function(CustomerIndexModel) onTap;
  final Function(CustomerIndexModel) onEdit;

  const CustomerIndexWidget({
    super.key,
    required this.onTap,
    required this.onEdit,
  });

  @override
  State<CustomerIndexWidget> createState() => CustomerIndexWidgetState();
}

class CustomerIndexWidgetState extends State<CustomerIndexWidget> {
  final _storage = const FlutterSecureStorage();
  late Future<List<CustomerIndexModel>> _futureCustomers;

  Future<void> fetchData() async {
    setState(() {
      _futureCustomers = fetchCustomers();
    });
  }

  Future<List<CustomerIndexModel>> fetchCustomers() async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/sales/customer/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CustomerIndexModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<void> deleteCustomer(int id) async {
    final token = await _storage.read(key: 'token');
    final response = await http.delete(
      Uri.parse('${ApiBase.baseUrl}/sales/customer/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Customer deleted successfully")),
      );
      await fetchData();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete: ${response.body}")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _futureCustomers = fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CustomerIndexModel>>(
      future: _futureCustomers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No customers found"));
        }

        final customers = snapshot.data!;
        return ListView.builder(
          itemCount: customers.length,
          itemBuilder: (context, index) {
            final customer = customers[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text(customer.customerName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ▼▼▼ PERBAIKAN 1: Mengganti 'customerCode' dengan 'email' ▼▼▼
                    Text("Email: ${customer.email}"),
                    // ▼▼▼ PERBAIKAN 2: Menghapus '??' yang tidak perlu ▼▼▼
                    Text("Phone: ${customer.phoneNo}"),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                      tooltip: "Edit Customer",
                      onPressed: () {
                        widget.onEdit(customer);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: "Delete Customer",
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Confirm Delete"),
                            content: Text(
                              "Are you sure you want to delete ${customer.customerName}?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text("Delete"),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await deleteCustomer(customer.idCustomer);
                        }
                      },
                    ),
                  ],
                ),
                onTap: () {
                  widget.onTap(customer);
                },
              ),
            );
          },
        );
      },
    );
  }
}