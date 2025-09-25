import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../models/costumer_index_models.dart';

class CustomerIndexWidget extends StatefulWidget {
  final Function(CustomerIndexModel) onTap;

  const CustomerIndexWidget({super.key, required this.onTap});

  @override
  State<CustomerIndexWidget> createState() => _CustomerIndexWidgetState();
}

class _CustomerIndexWidgetState extends State<CustomerIndexWidget> {
  final _storage = const FlutterSecureStorage();
  late Future<List<CustomerIndexModel>> _futureCustomers;

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
                    Text("Email: ${customer.email}"),
                    Text("Phone: ${customer.phoneNo}"),
                  ],
                ),
                trailing: Text(customer.city ?? "-"),
                onTap: () => widget.onTap(customer),
              ),
            );
          },
        );
      },
    );
  }
}
