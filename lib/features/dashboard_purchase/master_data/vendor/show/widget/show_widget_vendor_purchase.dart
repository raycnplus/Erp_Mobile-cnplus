import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../../../../services/api_base.dart';
import '../models/show_models_vendor_purchase.dart';

class VendorDetailWidget extends StatefulWidget {
  final String vendorId;

  const VendorDetailWidget({super.key, required this.vendorId});

  @override
  State<VendorDetailWidget> createState() => _VendorDetailWidgetState();
}

class _VendorDetailWidgetState extends State<VendorDetailWidget> {
  final storage = const FlutterSecureStorage();
  VendorShowModel? vendor;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchVendor();
  }

  Future<void> fetchVendor() async {
    try {
      final token = await storage.read(key: "token");
      if (token == null) {
        setState(() {
          errorMessage = "Token tidak ditemukan";
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse("${ApiBase.baseUrl}/purchase/vendor/${widget.vendorId}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          vendor = VendorShowModel.fromJson(data);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Gagal memuat data: ${response.body}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
        isLoading = false;
      });
    }
  }

  Widget _item(String title, String? value) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(value ?? "-"),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }
    if (vendor == null) {
      return const Center(child: Text("Data tidak ditemukan"));
    }

    return ListView(
      children: [
        _item("Vendor Name", vendor!.vendorName),
        _item("Vendor Code", vendor!.vendorCode),
        _item("Phone No", vendor!.phoneNo),
        _item("Email", vendor!.email),
        _item("NPWP Number", vendor!.npwpNumber),
        _item("Country", vendor!.country),
        _item("Province", vendor!.province),
        _item("City", vendor!.city),
        _item("Postal Code", vendor!.postalCode),
        _item("Address", vendor!.address),
        const Divider(),
        _item("PIC Name", vendor!.contactPersonName),
        _item("PIC Phone", vendor!.contactPersonPhone),
        _item("PIC Email", vendor!.contactPersonEmail),
        const Divider(),
        _item("Bank Name", vendor!.bankName),
        _item("Bank Account Number", vendor!.bankAccountNumber),
        _item("Bank Account Name", vendor!.bankAccountName),
        _item("Currency", vendor!.currency),
        const Divider(),
        _item("Created Date", vendor!.createdDate),
        _item("Created By", vendor!.createdBy),
        _item("Updated Date", vendor!.updatedDate),
        _item("Updated By", vendor!.updatedBy),
        _item("Status", vendor!.status),
        _item("Is Delete", vendor!.isDelete),
      ],
    );
  }
}
