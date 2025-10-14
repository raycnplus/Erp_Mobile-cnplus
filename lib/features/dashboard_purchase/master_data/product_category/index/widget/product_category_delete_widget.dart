import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';

class ProductCategoryDeleteWidget {
  static final _storage = const FlutterSecureStorage();

  /// Delete Product Category by ID
  static Future<void> deleteCategory(
      BuildContext context, int id, VoidCallback onSuccess) async {
    final token = await _storage.read(key: "token");

    try {
      final response = await http.delete(
        Uri.parse("${ApiBase.baseUrl}/purchase/product-category/$id"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Product Category berhasil dihapus")),
          );
          onSuccess(); // callback untuk refresh list
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "Gagal menghapus Product Category: ${response.body}")),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }
}
