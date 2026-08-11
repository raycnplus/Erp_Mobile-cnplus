import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/data/repositories/service_direct_sales_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/data/models/service_direct_sales_models.dart';

class GetSDSList {
  final ServiceDirectSalesRepository r;

  GetSDSList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) =>
      r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetSDSDetail {
  final ServiceDirectSalesRepository r;

  GetSDSDetail(this.r);

  Future<ServiceDirectSalesDetailModel> call(String enc) => r.getDetail(enc);
}

class GetSDSFormOptions {
  final ServiceDirectSalesRepository r;

  GetSDSFormOptions(this.r);

  Future<ServiceDirectSalesFormOptions> call() => r.getFormOptions();
}

class SaveServiceDirectSales {
  final ServiceDirectSalesRepository r;

  SaveServiceDirectSales(this.r);

  Future<String> call(ServiceDirectSalesFormModel f, String status, {double defaultTaxRate = 11.0}) {
    if (f.isEditMode) {
      return r.update(f.encryption!, f, status, defaultTaxRate: defaultTaxRate);
    }
    return r.store(f, status, defaultTaxRate: defaultTaxRate);
  }
}

class CancelServiceDirectSales {
  final ServiceDirectSalesRepository r;

  CancelServiceDirectSales(this.r);

  Future<void> call(int id, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(id, reason);
  }
}

class DeleteServiceDirectSales {
  final ServiceDirectSalesRepository r;

  DeleteServiceDirectSales(this.r);

  Future<void> call(int id) => r.delete(id);
}

class CreateInvoiceFromSDSTerm {
  final ServiceDirectSalesRepository r;

  CreateInvoiceFromSDSTerm(this.r);

  Future<Map<String, dynamic>> call(int sdsId, int scheduleId) => r.createInvoiceFromTerm(sdsId, scheduleId);
}

class GetSDSPriceFromList {
  final ServiceDirectSalesRepository r;

  GetSDSPriceFromList(this.r);

  Future<double?> call(int serviceId, int priceListId) => r.getPriceFromList(serviceId, priceListId);
}