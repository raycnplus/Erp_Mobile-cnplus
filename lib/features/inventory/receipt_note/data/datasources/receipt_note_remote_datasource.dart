import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/data/models/receipt_note_models.dart';

class ReceiptNoteRemoteDataSource {
  final Dio dio;

  ReceiptNoteRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) async {
    try {
      final r = await dio.get(
        '/inventory/receipt-notes',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (status != null) 'status': status,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final pd = r.data['data'] as Map<String, dynamic>;
      return {
        'items': (pd['data'] as List).map((e) => ReceiptNoteModel.fromJson(e)).toList(),
        'meta': ReceiptNotePaginationMeta(
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

  Future<ReceiptNoteDetailModel> getDetail(String enc) async {
    try {
      final r = await dio.get('/inventory/receipt-notes/$enc');
      return ReceiptNoteDetailModel.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<ReceiptNoteFormOptions> getFormOptions() async {
    try {
      final r = await dio.get('/inventory/receipt-notes/form-options');
      return ReceiptNoteFormOptions.fromJson(r.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<ReceiptNoteInventorySettings> getInventorySettings(int productId) async {
    try {
      final r = await dio.get(
        '/inventory/receipt-notes/inventory-settings',
        queryParameters: {'product_id': productId},
      );
      return ReceiptNoteInventorySettings.fromJson(r.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> save(ReceiptNoteFormModel f) async {
    try {
      final r = await dio.post('/inventory/receipt-notes', data: f.toSaveJson());
      return _extractEncryption(r.data) ?? f.encryption ?? '';
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> confirm(ReceiptNoteFormModel f) async {
    try {
      final r = await dio.post('/inventory/receipt-notes', data: f.toConfirmJson());
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }
  
  Future<Map<String, dynamic>> validateReceipt(
    ReceiptNoteFormModel f, {
    bool? allowBackorder,
  }) async {
    try {
      final data = f.toValidateJson();
      if (allowBackorder != null) data['allow_backorder'] = allowBackorder;
      final r = await dio.post('/inventory/receipt-notes', data: data);
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> cancel(String encryption, String reason) async {
    try {
      await dio.post('/inventory/receipt-notes/$encryption/cancel', data: {'cancel_reason': reason});
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> delete(int id) async {
    try {
      await dio.delete('/inventory/receipt-notes/$id');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> saveTracking({
    required int idReceiptNoteItem,
    required double receivedQty,
    required List<ReceiptNoteLotSerial> trackingData,
  }) async {
    try {
      await dio.post('/inventory/receipt-notes/save-tracking', data: {
        'id_receipt_note_item': idReceiptNoteItem,
        'received_qty': receivedQty,
        'tracking_data': trackingData.map((e) => e.toJson()).toList(),
      });
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> createReturnFromReceiptNote(String encryption) async {
    try {
      final r = await dio.post('/inventory/receipt-notes/$encryption/return');
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> approve(int id) async {
    try {
      await dio.post('/inventory/receipt-notes/$id/approve');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> reject(int id) async {
    try {
      await dio.post('/inventory/receipt-notes/$id/reject');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, dynamic>> getSteps(int id) async {
    try {
      final r = await dio.get('/inventory/receipt-notes/$id/steps');
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
      e.response?.data?['message'] ?? e.response?.data?.toString() ?? 'Network error';

  int _pi(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }
}