import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../models/costumer_category_index_models.dart';
import '../screen/costumer_category_show_screen.dart'; 
class CustomerCategoryIndexWidget extends StatefulWidget {
  const CustomerCategoryIndexWidget({super.key});

  @override
  State<CustomerCategoryIndexWidget> createState() => _CustomerCategoryIndexWidgetState();
}

class _CustomerCategoryIndexWidgetState extends State<CustomerCategoryIndexWidget> {
  final storage = const FlutterSecureStorage();
  List<CustomerCategoryModel> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final token = await storage.read(key: 'token');
      final response = await http.get(
        Uri.parse('${ApiBase.baseUrl}/sales/customer-category/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          setState(() {
            categories = data.map((e) => CustomerCategoryModel.fromJson(e)).toList();
            isLoading = false;
          });
        } else if (data is Map) {
          setState(() {
            categories = [CustomerCategoryModel.fromJson(Map<String, dynamic>.from(data))];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        debugPrint("Failed to load categories: ${response.body}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error: $e");
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      final token = await storage.read(key: 'token');
      final response = await http.delete(
        Uri.parse('${ApiBase.baseUrl}/sales/customer-category/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          categories.removeWhere((item) => item.idCustomerCategory == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Category deleted successfully")),
        );
      } else {
        debugPrint("Failed to delete: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to delete category")),
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error occurred while deleting")),
      );
    }
  }

  void confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this category?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              deleteCategory(id);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (categories.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          child: ListTile(
            leading: Text('${index + 1}'),
            title: Text(category.customerCategoryName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Code: ${category.customerCategoryCode.isEmpty ? '-' : category.customerCategoryCode}"),
                Text("Description: ${category.description.isEmpty ? '-' : category.description}"),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => confirmDelete(category.idCustomerCategory),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerCategoryShowScreen(
                    id: category.idCustomerCategory,
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
