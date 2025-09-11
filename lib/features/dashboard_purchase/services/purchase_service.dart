// features/dashboard_purchase/services/purchase_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../services/api_base.dart';
import '../models/purchase_dashboard_model.dart';

class PurchaseService {
  final _secureStorage = const FlutterSecureStorage();

  Future<PurchaseDashboardResponse> fetchDashboardData() async {
    final token = await _secureStorage.read(key: 'token');

    if (token == null) {
      throw Exception('Authorization token not found. Please log in again.');
    }

    final url = Uri.parse('${ApiBase.baseUrl}/purchase');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return PurchaseDashboardResponse.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Failed to load dashboard data: ${errorData['message'] ?? response.reasonPhrase}');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      throw Exception('An error occurred: $e');
    }
  }
}