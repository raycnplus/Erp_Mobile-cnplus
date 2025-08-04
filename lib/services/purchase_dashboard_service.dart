import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_base.dart'; // Asumsi path ke ApiBase Anda
import '../features/dashboard_purchase/models/purchase_models.dart';

class PurchaseDashboardService {
  static Future<DashboardData> getDashboardData() async {
    // Ganti dengan endpoint API Anda yang sebenarnya
    final url = Uri.parse('${ApiBase.baseUrl}/dashboard/purchase');

    try {
      // Ganti dengan method yang sesuai (GET/POST) dan tambahkan header jika perlu (misal: token)
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer YOUR_TOKEN', // Tambahkan ini jika API butuh otorisasi
      });

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        // 'data' adalah key umum dari respons API, sesuaikan jika berbeda
        return DashboardData.fromJson(jsonData['data']);
      } else {
        // Gagal mendapatkan data dari server
        throw Exception('Failed to load dashboard data: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Gagal terhubung ke server atau error lainnya
      throw Exception('Failed to connect to the server: $e');
    }
  }
}