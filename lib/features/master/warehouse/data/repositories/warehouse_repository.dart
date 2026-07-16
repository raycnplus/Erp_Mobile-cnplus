import 'package:erp_mobile_cnplus/features/master/warehouse/data/datasources/warehouse_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/warehouse/data/models/warehouse_models.dart';

class WarehouseRepository {
  final WarehouseRemoteDataSource remoteDataSource;
  WarehouseRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getWarehouseList({int page = 1, int perPage = 100}) =>
      remoteDataSource.getWarehouseList(page: page, perPage: perPage);

  Future<WarehouseDetailModel> getWarehouseDetail(String encryption) =>
      remoteDataSource.getWarehouseDetail(encryption);

  Future<void> createWarehouse(WarehouseFormModel formData) =>
      remoteDataSource.createWarehouse(formData);

  Future<String> updateWarehouse(String encryption, WarehouseFormModel formData) =>
      remoteDataSource.updateWarehouse(encryption, formData);

  Future<void> deleteWarehouse(String encryption) =>
      remoteDataSource.deleteWarehouse(encryption);
}