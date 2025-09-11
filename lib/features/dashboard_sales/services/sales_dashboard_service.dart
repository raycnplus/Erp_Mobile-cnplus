import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/sales_dashboard_model.dart';
import '../../../../services/api_base.dart';

class SalesDashboardService {
  static Future<SalesDashboardResponse> fetchDashboardData() async {
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/sales'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load sales dashboard. Status code: ${response.statusCode}');
    }

    final contentType = response.headers['content-type'];
    if (contentType == null || !contentType.contains('application/json')) {
      throw Exception('Invalid response format. Expected JSON.');
    }

    try {
      return SalesDashboardResponse.fromJson(json.decode(response.body));
    } catch (e) {
      throw Exception('Failed to parse sales dashboard data: $e');
    }
  }
}