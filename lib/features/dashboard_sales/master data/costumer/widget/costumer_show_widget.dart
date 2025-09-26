import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../models/costumer_show_models.dart';

class CustomerShowWidget extends StatefulWidget {
  final int id;

  const CustomerShowWidget({super.key, required this.id});

  @override
  State<CustomerShowWidget> createState() => _CustomerShowWidgetState();
}

class _CustomerShowWidgetState extends State<CustomerShowWidget> {
  final _storage = const FlutterSecureStorage();
  late Future<CustomerShowModel> _futureCustomer;

  Future<CustomerShowModel> fetchCustomer() async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/sales/customer/${widget.id}'), // ✅ pakai customer
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint("Response status: ${response.statusCode}");
    debugPrint("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return CustomerShowModel.fromJson(data);
    } else {
      throw Exception("Failed to load customer detail");
    }
  }

  @override
  void initState() {
    super.initState();
    _futureCustomer = fetchCustomer();
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CustomerShowModel>(
      future: _futureCustomer,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("Customer not found"));
        }

        final c = snapshot.data!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildRow("Customer Name", c.customerName)),
                  Expanded(child: _buildRow("Customer Code", c.customerCode)),
                  Expanded(child: _buildRow("Created On", c.createdDate)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildRow("Customer Type", c.customerType)),
                  Expanded(child: _buildRow("Customer Category", c.customerCategory ?? "-")),
                  Expanded(child: _buildRow("Created By", c.createdBy ?? "-")),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildRow("Phone No", c.phoneNo ?? "-")),
                  Expanded(child: _buildRow("Email", c.email ?? "-")),
                  Expanded(child: _buildRow("Country", c.country ?? "-")),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildRow("Province", c.province ?? "-")),
                  Expanded(child: _buildRow("City", c.city ?? "-")),
                  Expanded(child: _buildRow("Postal Code", c.postalCode ?? "-")),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildRow("Address", c.address ?? "-")),
                  Expanded(child: _buildRow("Website", c.website ?? "-")),
                ],
              ),
              const Divider(height: 32, thickness: 1),
              Row(
                children: [
                  Expanded(child: _buildRow("PIC Name", c.picName ?? "-")),
                  Expanded(child: _buildRow("PIC Phone", c.picPhone ?? "-")),
                  Expanded(child: _buildRow("PIC Email", c.picEmail ?? "-")),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
