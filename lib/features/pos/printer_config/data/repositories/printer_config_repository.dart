import 'package:erp_mobile_cnplus/features/pos/printer_config/data/datasources/printer_config_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/pos/printer_config/data/models/printer_config_models.dart';

class PrinterConfigRepository {
  final PrinterConfigRemoteDataSource ds;
  PrinterConfigRepository(this.ds);

  Future<Map<String, dynamic>> getList({int page = 1, int perPage = 15, String? search}) =>
      ds.getList(page: page, perPage: perPage, search: search);

  Future<PrinterConfigModel> getDetail(int id) => ds.getDetail(id);
  Future<PrinterConfigModel> store(PrinterConfigFormModel f) => ds.store(f);
  Future<PrinterConfigModel> update(int id, PrinterConfigFormModel f) => ds.update(id, f);
  Future<void> delete(int id) => ds.delete(id);
  Future<PrinterConfigModel> setDefault(int id) => ds.setDefault(id);
}