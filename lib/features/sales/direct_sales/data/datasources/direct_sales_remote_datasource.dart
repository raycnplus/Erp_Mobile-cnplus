import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales/data/models/direct_sales_models.dart';

class DirectSalesRemoteDataSource {
  final Dio dio;

  DirectSalesRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) async {
    try {
      final r = await dio.get(
        '/sales/direct-sales',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (status != null) 'status': status,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List)
            .map((e) => DirectSalesModel.fromJson(e))
            .toList(),
        'meta': DirectSalesPaginationMeta(
          currentPage: _pi(pd['current_page']),
          lastPage: _pi(pd['last_page']),
          perPage: _pi(pd['per_page']),
          total: _pi(pd['total']),
        ),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<DirectSalesDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('/sales/direct-sales/$enc');
      return DirectSalesDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<DirectSalesFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('/sales/direct-sales/form-options');
      return DirectSalesFormOptions.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> store(
    DirectSalesFormModel f,
    String status, {
    double defaultTaxRate = 11.0,
  }) async {
    try {
      final r = await dio.post(
        '/sales/direct-sales',
        data: f.toJson(status, defaultTaxRate: defaultTaxRate),
      );
      return _extractEncryption(r.data) ?? '';
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> update(
    String enc,
    DirectSalesFormModel f,
    String status, {
    double defaultTaxRate = 11.0,
  }) async {
    try {
      final r = await dio.put(
        '/sales/direct-sales/$enc',
        data: f.toJson(status, defaultTaxRate: defaultTaxRate),
      );
      return _extractEncryption(r.data) ?? enc;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> cancel(int id, String reason) async {
    try {
      await dio.post(
        '/sales/direct-sales/$id/cancel',
        data: {'cancel_reason': reason},
      );
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(int id) async {
    try {
      await dio.delete('/sales/direct-sales/$id');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> createInvoice(int id) async {
    try {
      final r = await dio.post('/sales/direct-sales/$id/create-invoice');
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> createInvoiceFromTerm(
    int dsId,
    int scheduleId,
  ) async {
    try {
      final r = await dio.post(
        '/sales/direct-sales/$dsId/create-invoice-from-term/$scheduleId',
      );
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<List<DSProductOption>> getProductsByLocation(int locationId) async {
    try {
      final r = await dio.get(
        '/sales/direct-sales/products-by-location',
        queryParameters: {'id_location': locationId},
      );
      return (r.data['products'] as List? ?? [])
          .map((e) => DSProductOption.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<double?> getPriceFromList(int productId, int priceListId) async {
    try {
      final r = await dio.get(
        '/sales/direct-sales/price-from-list',
        queryParameters: {
          'id_product': productId,
          'id_price_list': priceListId,
        },
      );
      if (r.data['success'] == true && r.data['custom_price'] != null) {
        return double.tryParse(r.data['custom_price'].toString());
      }
      return null;
    } on DioException catch (_) {
      return null;
    }
  }

  Future<void> approve(int id) async {
    try {
      await dio.post('/sales/direct-sales/$id/approve');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> reject(int id) async {
    try {
      await dio.post('/sales/direct-sales/$id/reject');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> getSteps(int id) async {
    try {
      final r = await dio.get('/sales/direct-sales/$id/steps');
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  String? _extractEncryption(dynamic data) {
    if (data is Map) {
      final inner = data['data'];
      if (inner is Map && inner['encryption'] != null) {
        return inner['encryption'].toString();
      }
    }
    return null;
  }

  String _err(DioException e) =>
      e.response?.data?['message'] ??
      e.response?.data?.toString() ??
      'Network error';

  int _pi(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }
}