// costumer_show_widget.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';
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

  // ▼▼▼ BAGIAN BARU UNTUK DESAIN ▼▼▼

  // Palet Warna Utama
  static const Color primaryColor = Color(0xFF4A69BD);
  static const Color accentColor = Color(0xFFF1F4F8);
  static const Color textColor = Color(0xFF333333);
  static const Color subtitleColor = Color(0xFF666666);

  @override
  void initState() {
    super.initState();
    _futureCustomer = fetchCustomer();
  }

  Future<CustomerShowModel> fetchCustomer() async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/sales/customer/${widget.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return CustomerShowModel.fromJson(data);
    } else {
      throw Exception("Failed to load customer detail");
    }
  }

  // Helper untuk mendapatkan inisial dari nama
  String _getInitials(String name) {
    if (name.isEmpty) return "?";
    List<String> parts = name.trim().split(' ');
    if (parts.length > 1) {
      return parts[0][0].toUpperCase() + parts.last[0].toUpperCase();
    } else if (parts[0].length > 1) {
      return parts[0].substring(0, 2).toUpperCase();
    } else {
      return parts[0].toUpperCase();
    }
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

        final customer = snapshot.data!;
        // Tampilan utama menggunakan ListView untuk scrolling
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            _buildHeader(customer),
            const SizedBox(height: 24),
            _buildInfoCard(
              title: "Contact Info",
              icon: Icons.contact_phone_outlined,
              children: [
                _buildInfoRow(Icons.phone_outlined, "Phone No", customer.phoneNo),
                _buildInfoRow(Icons.email_outlined, "Email", customer.email),
                _buildInfoRow(Icons.public_outlined, "Website", customer.website),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              title: "Address",
              icon: Icons.location_on_outlined,
              children: [
                _buildInfoRow(Icons.map_outlined, "Address", customer.address),
                _buildInfoRow(Icons.location_city_outlined, "City", customer.city),
                _buildInfoRow(Icons.flag_outlined, "Province", customer.province),
                _buildInfoRow(Icons.public_outlined, "Country", customer.country),
                _buildInfoRow(Icons.markunread_mailbox_outlined, "Postal Code", customer.postalCode),
              ],
            ),
             const SizedBox(height: 16),
            _buildInfoCard(
              title: "Person In Charge (PIC)",
              icon: Icons.person_pin_outlined,
              children: [
                _buildInfoRow(Icons.person_outline, "PIC Name", customer.picName),
                _buildInfoRow(Icons.phone_iphone, "PIC Phone", customer.picPhone),
                _buildInfoRow(Icons.alternate_email, "PIC Email", customer.picEmail),
              ],
            ),
             const SizedBox(height: 16),
             _buildInfoCard(
              title: "System Info",
              icon: Icons.info_outline,
              children: [
                _buildInfoRow(Icons.code, "Customer Code", customer.customerCode),
                _buildInfoRow(Icons.category_outlined, "Category", customer.customerCategory),
                _buildInfoRow(Icons.person_add_alt, "Created By", customer.createdBy),
                _buildInfoRow(Icons.calendar_today_outlined, "Created On", customer.createdDate),
              ],
            ),
          ],
        );
      },
    );
  }

  /// WIDGET HEADER: Menampilkan Avatar dan Nama Customer
  Widget _buildHeader(CustomerShowModel customer) {
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: primaryColor.withOpacity(0.1),
          child: Text(
            _getInitials(customer.customerName),
            style: GoogleFonts.poppins(
              color: primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customer.customerName,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                customer.customerType,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: subtitleColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// WIDGET CARD: Kerangka untuk setiap grup informasi
  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
       decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children, // Menampilkan semua baris info
          ],
        ),
      ),
    );
  }

  /// WIDGET ROW: Baris untuk menampilkan sepasang data (Ikon, Label, Value)
  Widget _buildInfoRow(IconData icon, String label, String? value) {
    // Jika value null atau kosong, jangan tampilkan baris ini
    if (value == null || value.trim().isEmpty || value.trim() == '-') {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: subtitleColor, size: 16),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.lato(fontSize: 12, color: subtitleColor),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}