import 'package:erp_mobile_cnplus/features/purchase/purchase_request/data/datasources/purchase_request_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request/data/models/purchase_request_models.dart';

class PurchaseRequestRepository {
  final PurchaseRequestRemoteDataSource ds;

  PurchaseRequestRepository(this.ds);

  Future<Map<String, dynamic>> getList({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) {
    return ds.getList(
      page: page,
      perPage: perPage,
      status: status,
      search: search,
    );
  }

  Future<PurchaseRequestDetailModel> getDetail(String enc) {
    return ds.getDetail(enc);
  }

  Future<PurchaseRequestFormOptions> getFormOptions() {
    return ds.getFormOptions();
  }

  Future<String> store(PurchaseRequestFormModel f, String status) {
    return ds.store(f, status);
  }

  Future<String> update(String enc, PurchaseRequestFormModel f, String status) {
    return ds.update(enc, f, status);
  }

  Future<void> cancel(int id, String reason) {
    return ds.cancel(id, reason);
  }

  Future<void> delete(int id) {
    return ds.delete(id);
  }

  Future<Map<String, dynamic>> createRfq(int id) {
    return ds.createRfq(id);
  }

  Future<Map<String, dynamic>> createDp(int id) {
    return ds.createDp(id);
  }

  Future<void> approve(int id) {
    return ds.approve(id);
  }

  Future<void> reject(int id) {
    return ds.reject(id);
  }

  Future<Map<String, dynamic>> getSteps(int id) {
    return ds.getSteps(id);
  }
}