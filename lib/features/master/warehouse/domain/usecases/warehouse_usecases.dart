import 'package:erp_mobile_cnplus/features/master/warehouse/data/repositories/warehouse_repository.dart';
import 'package:erp_mobile_cnplus/features/master/warehouse/data/models/warehouse_models.dart';

class GetWarehouseList {
  final WarehouseRepository repository;
  GetWarehouseList(this.repository);
  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100}) =>
      repository.getWarehouseList(page: page, perPage: perPage);
}

class GetWarehouseDetail {
  final WarehouseRepository repository;
  GetWarehouseDetail(this.repository);
  Future<WarehouseDetailModel> call(String encryption) =>
      repository.getWarehouseDetail(encryption);
}

class CreateWarehouse {
  final WarehouseRepository repository;
  CreateWarehouse(this.repository);
  Future<void> call(WarehouseFormModel formData) async {
    if (!formData.isValid()) throw Exception('Warehouse name and code are required');
    await repository.createWarehouse(formData);
  }
}

class UpdateWarehouse {
  final WarehouseRepository repository;
  UpdateWarehouse(this.repository);
  Future<String> call(String encryption, WarehouseFormModel formData) async {
    if (!formData.isValid()) throw Exception('Warehouse name and code are required');
    return repository.updateWarehouse(encryption, formData);
  }
}

class DeleteWarehouse {
  final WarehouseRepository repository;
  DeleteWarehouse(this.repository);
  Future<void> call(String encryption) => repository.deleteWarehouse(encryption);
}