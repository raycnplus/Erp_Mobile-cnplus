import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../models/costumer_index_models.dart';
import '../screen/costumer_show_screen.dart';

class CustomerIndexWidget extends StatefulWidget {
  final Function(CustomerIndexModel)? onTap; // nullable, biar opsional
  final Function(CustomerIndexModel) onEdit;
  final GlobalKey<CustomerIndexWidgetState>? key;

  const CustomerIndexWidget({
    required this.onTap,
    required this.onEdit,
    this.key,
  }) : super(key: key);

  @override
  State<CustomerIndexWidget> createState() => CustomerIndexWidgetState();
}

class CustomerIndexWidgetState extends State<CustomerIndexWidget> {
  final _storage = const FlutterSecureStorage();
  late Future<List<CustomerIndexModel>> _futureCustomers;

  /// panggil ini dari luar pakai GlobalKey untuk refresh data
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
      await fetchData(); // langsung refresh
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
                    Text("Email: ${customer.email ?? '-'}"),
                    Text("Phone: ${customer.phoneNo ?? '-'}"),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(customer.city ?? "-"),
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
                  if (widget.onTap != null) {
                    widget.onTap!(customer);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CustomerShowScreen(id: customer.idCustomer),
                      ),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
