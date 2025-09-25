import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../models/costumer_category_show_models.dart';

class CustomerCategoryShowWidget extends StatefulWidget {
  final int id; // id_customer_category

  const CustomerCategoryShowWidget({super.key, required this.id});

  @override
  State<CustomerCategoryShowWidget> createState() =>
      _CustomerCategoryShowWidgetState();
}

class _CustomerCategoryShowWidgetState
    extends State<CustomerCategoryShowWidget> {
  final storage = const FlutterSecureStorage();
  CustomerCategoryShowModel? category;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategoryDetail();
  }

  Future<void> fetchCategoryDetail() async {
    try {
      final token = await storage.read(key: 'token');
      final response = await http.get(
        Uri.parse('${ApiBase.baseUrl}/sales/customer-category/${widget.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          category = CustomerCategoryShowModel.fromJson(data);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        debugPrint("Failed to load detail: ${response.body}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error: $e");
    }
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(value.isEmpty ? '-' : value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (category == null) {
      return const Center(child: Text("No data available"));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildRow("Customer Category Name", category!.customerCategoryName),
          buildRow("Customer Category Code", category!.customerCategoryCode),
          buildRow("Created On", category!.createdDate),
          const SizedBox(height: 10),
          buildRow("Description", category!.description),
          buildRow("Created By", category!.createdBy),
        ],
      ),
    );
  }
}
