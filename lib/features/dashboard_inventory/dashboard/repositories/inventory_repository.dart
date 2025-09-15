
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../services/api_base.dart'; 

class InventoryRepository {
  Future<Map<String, dynamic>> fetchDashboardData(String token) async {
    if (token.isEmpty) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/inventory/'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Token tidak valid atau sudah expired. Silakan login ulang.');
    } else {
      throw Exception('Failed to load dashboard data');
    }
  }
}