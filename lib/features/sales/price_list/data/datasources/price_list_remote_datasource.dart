import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/data/models/price_list_models.dart';

class PriceListRemoteDataSource {
  final Dio dio;

  PriceListRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100}) async {
    try {
      final response = await dio.get(
        '/sales/price-lists',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final json = response.data as Map<String, dynamic>;
      final dynamic raw = json['data'] ?? json;

      List<dynamic> items;
      int currentPage, lastPage, perPageVal, total;

      if (raw is Map && raw['data'] is List) {
        items = raw['data'];
        currentPage = raw['current_page'] ?? 1;
        lastPage = raw['last_page'] ?? 1;
        perPageVal = raw['per_page'] ?? 15;
        total = raw['total'] ?? 0;
      } else {
        items = raw is List ? raw : [];
        currentPage = json['current_page'] ?? 1;
        lastPage = json['last_page'] ?? 1;
        perPageVal = json['per_page'] ?? 15;
        total = json['total'] ?? items.length;
      }

      return {
        'items': items.map((e) => PriceListModel.fromJson(e)).toList(),
        'meta': PriceListPaginationMeta(
          currentPage: currentPage,
          lastPage: lastPage,
          perPage: perPageVal,
          total: total,
        ),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<PriceListDetailModel> getDetail(String encryption) async {
    try {
      final response = await dio.get('/sales/price-lists/$encryption');
      return PriceListDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<List<PriceListProductOption>> getFormOptions() async {
    try {
      final response = await dio.get('/sales/price-lists/form-options');
      final json = response.data;
      final products = json['products'] as List? ?? [];
      return products.map((e) => PriceListProductOption.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> create(PriceListFormModel f) async {
    try {
      await dio.post('/sales/price-lists', data: f.toJson());
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> update(String encryption, PriceListFormModel f) async {
    try {
      final response = await dio.put('/sales/price-lists/$encryption', data: f.toJson());
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(String encryption) async {
    try {
      await dio.delete('/sales/price-lists/$encryption');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  String _err(DioException e) => e.response?.data['message'] ?? 'Network error: ${e.message}';
}