import 'package:erp_mobile_cnplus/features/inventory/stock_count/data/repositories/stock_count_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/data/models/stock_count_models.dart';

class GetSCList {
  final StockCountRepository r;
  GetSCList(this.r);
  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100, String? status}) =>
      r.getList(page: page, perPage: perPage, status: status);
}

class GetSCDetail {
  final StockCountRepository r;
  GetSCDetail(this.r);
  Future<StockCountDetailModel> call(String enc) => r.getDetail(enc);
}

class GetSCFormOptions {
  final StockCountRepository r;
  GetSCFormOptions(this.r);
  Future<StockCountFormOptions> call() => r.getFormOptions();
}

class CreateStockCount {
  final StockCountRepository r;
  CreateStockCount(this.r);

  Future<Map<String, dynamic>> call({
    required int idWarehouse,
    int? idLocation,
    required String selectBy,
    String? note,
  }) => r.store({
        'status': 'save',
        'id_warehouse': idWarehouse,
        'id_location': idLocation,
        'select_by': selectBy,
        'note': note,
      });
}

class UpdateStockCountHeader {
  final StockCountRepository r;
  UpdateStockCountHeader(this.r);

  Future<Map<String, dynamic>> call({
    required int idStockOpname,
    required int idWarehouse,
    int? idLocation,
    required String selectBy,
    String? note,
    required String originalStatus,
  }) => r.update(idStockOpname, {
        'status': 'save',
        'original_status': originalStatus,
        'update_header': 'true',
        'id_warehouse': idWarehouse,
        'id_location': idLocation,
        'select_by': selectBy,
        'note': note,
      });
}

class ConfirmStockCount {
  final StockCountRepository r;
  ConfirmStockCount(this.r);

  Future<Map<String, dynamic>> call({
    required int idStockOpname,
    required int idWarehouse,
    int? idLocation,
    required String selectBy,
    String? note,
  }) => r.update(idStockOpname, {
        'status': 'confirm',
        'update_header': 'true',
        'id_warehouse': idWarehouse,
        'id_location': idLocation,
        'select_by': selectBy,
        'note': note,
      });
}

class ValidateStockCount {
  final StockCountRepository r;
  ValidateStockCount(this.r);

  Future<Map<String, dynamic>> call({required int idStockOpname, required int idWarehouse}) =>
      r.update(idStockOpname, {
        'status': 'lock',
        'id_warehouse': idWarehouse,
        'products': <String, dynamic>{},
      });
}

class CancelStockCount {
  final StockCountRepository r;
  CancelStockCount(this.r);
  Future<void> call(String encryption, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(encryption, reason);
  }
}

class DeleteStockCount {
  final StockCountRepository r;
  DeleteStockCount(this.r);
  Future<void> call(int id) => r.delete(id);
}

class StoreLocationCount {
  final StockCountRepository r;
  StoreLocationCount(this.r);

  Future<Map<String, dynamic>> call({
    required int idStockOpname,
    required int idLocation,
    required List<SCFormItem> products,
    required String actionType,
  }) => r.storeCount(idStockOpname: idStockOpname, idLocation: idLocation, products: products, actionType: actionType);
}

class LoadSCProducts {
  final StockCountRepository r;
  LoadSCProducts(this.r);
  Future<Map<String, dynamic>> call({int? warehouseId, int? locationId, int? idStockOpname}) =>
      r.loadProducts(warehouseId: warehouseId, locationId: locationId, idStockOpname: idStockOpname);
}

class GetSCLocationsByWarehouse {
  final StockCountRepository r;
  GetSCLocationsByWarehouse(this.r);
  Future<List<SCLocationOption>> call(int warehouseId) => r.getLocationsByWarehouse(warehouseId);
}

class GetSCIndexLocation {
  final StockCountRepository r;
  GetSCIndexLocation(this.r);
  Future<Map<String, dynamic>> call(String encryption, String warehouseEncryption) =>
      r.indexLocation(encryption, warehouseEncryption);
}

class GetSCSteps {
  final StockCountRepository r;
  GetSCSteps(this.r);
  Future<Map<String, dynamic>> call(int id) => r.getSteps(id);
}

class ApproveStockCount {
  final StockCountRepository r;
  ApproveStockCount(this.r);
  Future<void> call(int id) => r.approve(id);
}

class RejectStockCount {
  final StockCountRepository r;
  RejectStockCount(this.r);
  Future<void> call(int id) => r.reject(id);
}