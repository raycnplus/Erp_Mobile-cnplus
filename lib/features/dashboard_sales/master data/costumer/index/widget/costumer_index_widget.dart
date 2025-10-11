// costumer_index_widget.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';
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

  @override
  void initState() {
    super.initState();
    _futureCustomers = fetchCustomers();
  }

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
  
  String _getInitials(String name) {
    if (name.isEmpty) return "?";
    List<String> parts = name.trim().split(' ');
    if (parts.length > 1) {
      return parts[0][0].toUpperCase() + parts.last[0].toUpperCase();
    } else {
      return parts[0].substring(0, 1).toUpperCase();
    }
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: customers.length,
          itemBuilder: (context, index) {
            final customer = customers[index];
            return _buildCustomerCard(customer, context);
          },
        );
      },
    );
  }

  Widget _buildCustomerCard(CustomerIndexModel customer, BuildContext context) {
    const primaryColor = Color(0xFF4A69BD);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), 
            blurRadius: 24, 
            offset: const Offset(0, 4), 
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () => widget.onTap(customer),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: primaryColor.withOpacity(0.1),
                      child: Text(
                        _getInitials(customer.customerName),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.customerName,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            customer.email,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoChip(Icons.phone_outlined, customer.phoneNo),
                    if(customer.city != null && customer.city!.isNotEmpty)
                      _buildInfoChip(Icons.location_city_outlined, customer.city!),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      color: Colors.grey.shade500,
                      tooltip: "Edit Customer",
                      onPressed: () => widget.onEdit(customer),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red.shade400,
                      tooltip: "Delete Customer",
                      onPressed: () => _showDeleteDialog(customer, context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  void _showDeleteDialog(CustomerIndexModel customer, BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete ${customer.customerName}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Delete")),
        ],
      ),
    );
    if (confirm == true) {
      await deleteCustomer(customer.idCustomer);
    }
  }
}