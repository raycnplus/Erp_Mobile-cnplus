import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/data/models/service_sales_order_models.dart';

class ServiceSalesOrderRemoteDataSource {
  final Dio dio;

  ServiceSalesOrderRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) async {
    try {
      final r = await dio.get(
        '/sales/service/sales-orders',
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
            .map((e) => ServiceSalesOrderModel.fromJson(e))
            .toList(),
        'meta': ServiceSalesOrderPaginationMeta(
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

  Future<ServiceSalesOrderDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('/sales/service/sales-orders/$enc');
      return ServiceSalesOrderDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<ServiceSalesOrderFormOptions> getFormOptions() async {
    try {
      final results = await Future.wait([
        dio.get('/sales/service/sales-orders/form-options'),
        dio.get('/sales/service/sales-orders/service-list'),
      ]);
      final optData = Map<String, dynamic>.from(
        results[0].data['data'] ?? results[0].data,
      );
      final svcData = results[1].data['services'] as List? ?? [];
      optData['services'] = svcData;
      return ServiceSalesOrderFormOptions.fromJson({'data': optData});
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> store(
    ServiceSalesOrderFormModel f,
    String status, {
    double defaultTaxRate = 11.0,
  }) async {
    try {
      final r = await dio.post(
        '/sales/service/sales-orders',
        data: f.toJson(status, defaultTaxRate: defaultTaxRate),
      );
      return _extractEncryption(r.data) ?? '';
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> update(
    String enc,
    ServiceSalesOrderFormModel f,
    String status, {
    double defaultTaxRate = 11.0,
  }) async {
    try {
      final r = await dio.put(
        '/sales/service/sales-orders/$enc',
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
        '/sales/service/sales-orders/$id/cancel',
        data: {'cancel_reason': reason},
      );
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> close(int id) async {
    try {
      await dio.post('/sales/service/sales-orders/$id/close');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(int id) async {
    try {
      await dio.delete('/sales/service/sales-orders/$id');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> createInvoice(int id) async {
    try {
      final r =
          await dio.post('/sales/service/sales-orders/$id/create-invoice');
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> createInvoiceFromTerm(
    int ssoId,
    int scheduleId,
  ) async {
    try {
      final r = await dio.post(
        '/sales/service/sales-orders/$ssoId/create-invoice-term/$scheduleId',
      );
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<double?> getPriceFromList(int serviceId, int priceListId) async {
    try {
      final r = await dio.get(
        '/sales/service/sales-orders/price-from-list',
        queryParameters: {
          'id_service': serviceId,
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
      await dio.post('/sales/service/sales-orders/$id/approve');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> reject(int id) async {
    try {
      await dio.post('/sales/service/sales-orders/$id/reject');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> getSteps(int id) async {
    try {
      final r = await dio.get('/sales/service/sales-orders/$id/steps');
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