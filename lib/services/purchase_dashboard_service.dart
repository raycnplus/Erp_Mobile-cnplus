import 'package:http/http.dart' as http;
import 'dart:convert';
import '../features/dashboard_purchase/models/purchase_dashboard_models.dart'; // pastikan model ini ada

class PurchaseDashboardService {
  Future<DashboardData> fetchDashboardData() async {
    final response = await http.get(Uri.parse('https://erp.sorlem.com/api/purchase'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return DashboardData.fromJson(jsonData); // konversi ke model
    } else {
      throw Exception('Gagal mengambil data');
    }
  }
}