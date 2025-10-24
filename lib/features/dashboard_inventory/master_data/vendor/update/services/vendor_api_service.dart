import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';
import '../models/update_models_vendor.dart';

class VendorApiService {
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async => await _storage.read(key: "token");

  // 1. Mengambil detail vendor
  Future<Map<String, dynamic>> fetchVendorDetail(String vendorId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("${ApiBase.baseUrl}/purchase/vendor/$vendorId"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return (body is Map && body['data'] != null) ? body['data'] : body;
    }
    throw Exception("Failed to fetch vendor detail: ${response.statusCode}");
  }

  // 2. Mengambil daftar negara
  Future<List<CountryModel>> fetchCountries() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("${ApiBase.baseUrl}/master/countries/"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final list = (body is Map && body['data'] is List) ? body['data'] : (body is List ? body : []);
      return (list as List).map((e) => CountryModel.fromJson(e)).toList();
    }
    throw Exception("Failed to fetch countries");
  }

  // 3. Mengambil daftar mata uang
  Future<List<CurrencyModel>> fetchCurrencies() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("${ApiBase.baseUrl}/master/currency/"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final list = (body is Map && body['data'] is List) ? body['data'] : (body is List ? body : []);
      return (list as List).map((e) => CurrencyModel.fromJson(e)).toList();
    }
    throw Exception("Failed to fetch currencies");
  }

  // 4. Mengupdate vendor
  Future<bool> updateVendor({
    required String vendorId,
    required Map<String, dynamic> data,
  }) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse("${ApiBase.baseUrl}/purchase/vendor/$vendorId"),
      headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return response.statusCode == 200;
  }
}