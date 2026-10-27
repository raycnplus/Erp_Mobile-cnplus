import 'package:erp_mobile_cnplus/features/pos/printer_config/data/repositories/printer_config_repository.dart';
import 'package:erp_mobile_cnplus/features/pos/printer_config/data/models/printer_config_models.dart';

class GetPrinterConfigList {
  final PrinterConfigRepository r;
  GetPrinterConfigList(this.r);

  Future<Map<String, dynamic>> call({int page = 1, int perPage = 15, String? search}) =>
      r.getList(page: page, perPage: perPage, search: search);
}

class GetPrinterConfigDetail {
  final PrinterConfigRepository r;
  GetPrinterConfigDetail(this.r);

  Future<PrinterConfigModel> call(int id) => r.getDetail(id);
}

class SavePrinterConfig {
  final PrinterConfigRepository r;
  SavePrinterConfig(this.r);

  Future<PrinterConfigModel> call(PrinterConfigFormModel f) {
    if (f.printerName.trim().isEmpty) {
      throw Exception('Printer Name is required');
    }
    if (f.isEditMode) {
      return r.update(f.id!, f);
    }
    return r.store(f);
  }
}

class DeletePrinterConfig {
  final PrinterConfigRepository r;
  DeletePrinterConfig(this.r);

  Future<void> call(int id) => r.delete(id);
}

class SetDefaultPrinterConfig {
  final PrinterConfigRepository r;
  SetDefaultPrinterConfig(this.r);

  Future<PrinterConfigModel> call(int id) => r.setDefault(id);
}