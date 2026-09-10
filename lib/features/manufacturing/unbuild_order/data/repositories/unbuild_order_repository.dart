import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/data/datasources/unbuild_order_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/data/models/unbuild_order_models.dart';

class UnbuildOrderRepository {
  final UnbuildOrderRemoteDataSource ds;
  UnbuildOrderRepository(this.ds);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 100, String? status, String? search}) =>
      ds.getList(page: page, perPage: perPage, status: status, search: search);

  Future<UnbuildOrderDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<UnbuildOrderFormOptions> getFormOptions() => ds.getFormOptions();
  Future<String> generateReference() => ds.generateReference();
  Future<List<UOPreviewComponent>> getComponentsPreview(List<UOPreviewRequestItem> items) =>
      ds.getComponentsPreview(items);
  Future<UOManufacturingOrderDetails> getManufacturingOrderDetails(int moId) =>
      ds.getManufacturingOrderDetails(moId);

  Future<String> store(UnbuildOrderFormModel f, String status) => ds.store(f, status);
  Future<String> update(String enc, UnbuildOrderFormModel f, String status) => ds.update(enc, f, status);
  Future<void> delete(String enc) => ds.delete(enc);

  Future<void> approve(String enc) => ds.approve(enc);
  Future<void> reject(String enc) => ds.reject(enc);
  Future<Map<String, dynamic>> getSteps(String enc) => ds.getSteps(enc);
}