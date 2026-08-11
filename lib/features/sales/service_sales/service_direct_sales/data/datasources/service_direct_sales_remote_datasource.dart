import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/data/models/service_direct_sales_models.dart';

class ServiceDirectSalesRemoteDataSource {
  final Dio dio;

  ServiceDirectSalesRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) async {
    try {
      final r = await dio.get('/sales/service/direct-sales', queryParameters: {
        'page':     page,
        'per_page': perPage,
        if (status != null) 'status': status,
        if (search != null && search.isNotEmpty) 'search': search,
      });
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List).map((e) => ServiceDirectSalesModel.fromJson(e)).toList(),
        'meta': ServiceDirectSalesPaginationMeta(
          currentPage: _pi(pd['current_page']),
          lastPage:    _pi(pd['last_page']),
          perPage:     _pi(pd['per_page']),
          total:       _pi(pd['total']),
        ),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<ServiceDirectSalesDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('/sales/service/direct-sales/$enc');
      return ServiceDirectSalesDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<ServiceDirectSalesFormOptions> getFormOptions() async {
    try {
      final results = await Future.wait([
        dio.get('/sales/service/direct-sales/form-options'),
        dio.get('/sales/service/direct-sales/service-list'),
      ]);
      final optData = Map<String, dynamic>.from(results[0].data['data'] ?? results[0].data);
      final svcData = results[1].data['services'] as List? ?? [];
      optData['services'] = svcData;
      return ServiceDirectSalesFormOptions.fromJson({'data': optData});
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> store(
    ServiceDirectSalesFormModel f,
    String status, {
    double defaultTaxRate = 11.0,
  }) async {
    try {
      final r = await dio.post(
        '/sales/service/direct-sales',
        data: f.toJson(status, defaultTaxRate: defaultTaxRate),
      );
      return _extractEncryption(r.data) ?? '';
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> update(
    String enc,
    ServiceDirectSalesFormModel f,
    String status, {
    double defaultTaxRate = 11.0,
  }) async {
    try {
      final r = await dio.put(
        '/sales/service/direct-sales/$enc',
        data: f.toJson(status, defaultTaxRate: defaultTaxRate),
      );
      return _extractEncryption(r.data) ?? enc;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> cancel(int id, String reason) async {
    try {
      await dio.post('/sales/service/direct-sales/$id/cancel', data: {'cancel_reason': reason});
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(int id) async {
    try {
      await dio.delete('/sales/service/direct-sales/$id');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> createInvoiceFromTerm(int sdsId, int scheduleId) async {
    try {
      final r = await dio.post('/sales/service/direct-sales/$sdsId/create-invoice-term/$scheduleId');
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<double?> getPriceFromList(int serviceId, int priceListId) async {
    try {
      final r = await dio.get(
        '/sales/service/direct-sales/price-from-list',
        queryParameters: {'id_service': serviceId, 'id_price_list': priceListId},
      );
      if (r.data['success'] == true && r.data['custom_price'] != null) {
        return double.tryParse(r.data['custom_price'].toString());
      }
      return null;
    } on DioException catch (_) {
      return null;
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
      e.response?.data?['message'] ?? e.response?.data?.toString() ?? 'Network error';

  int _pi(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }
}