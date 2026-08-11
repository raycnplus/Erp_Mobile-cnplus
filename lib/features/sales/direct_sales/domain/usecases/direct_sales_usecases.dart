import 'package:erp_mobile_cnplus/features/sales/direct_sales/data/repositories/direct_sales_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales/data/models/direct_sales_models.dart';

class GetDSList {
  final DirectSalesRepository r;

  GetDSList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) =>
      r.getList(
        page: page,
        perPage: perPage,
        status: status,
        search: search,
      );
}

class GetDSDetail {
  final DirectSalesRepository r;

  GetDSDetail(this.r);

  Future<DirectSalesDetailModel> call(String enc) => r.getDetail(enc);
}

class GetDSFormOptions {
  final DirectSalesRepository r;

  GetDSFormOptions(this.r);

  Future<DirectSalesFormOptions> call() => r.getFormOptions();
}

class SaveDirectSales {
  final DirectSalesRepository r;

  SaveDirectSales(this.r);

  Future<String> call(
    DirectSalesFormModel f,
    String status, {
    double defaultTaxRate = 11.0,
  }) {
    if (f.isEditMode) {
      return r.update(
        f.encryption!,
        f,
        status,
        defaultTaxRate: defaultTaxRate,
      );
    }
    return r.store(f, status, defaultTaxRate: defaultTaxRate);
  }
}

class CancelDirectSales {
  final DirectSalesRepository r;

  CancelDirectSales(this.r);

  Future<void> call(int id, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(id, reason);
  }
}

class DeleteDirectSales {
  final DirectSalesRepository r;

  DeleteDirectSales(this.r);

  Future<void> call(int id) => r.delete(id);
}

class CreateInvoiceFromDS {
  final DirectSalesRepository r;

  CreateInvoiceFromDS(this.r);

  Future<Map<String, dynamic>> call(int id) => r.createInvoice(id);
}

class CreateInvoiceFromDSTerm {
  final DirectSalesRepository r;

  CreateInvoiceFromDSTerm(this.r);

  Future<Map<String, dynamic>> call(int dsId, int scheduleId) =>
      r.createInvoiceFromTerm(dsId, scheduleId);
}

class GetDSProductsByLocation {
  final DirectSalesRepository r;

  GetDSProductsByLocation(this.r);

  Future<List<DSProductOption>> call(int locationId) =>
      r.getProductsByLocation(locationId);
}

class GetDSPriceFromList {
  final DirectSalesRepository r;

  GetDSPriceFromList(this.r);

  Future<double?> call(int productId, int priceListId) =>
      r.getPriceFromList(productId, priceListId);
}

class ApproveDirectSales {
  final DirectSalesRepository r;

  ApproveDirectSales(this.r);

  Future<void> call(int id) => r.approve(id);
}

class RejectDirectSales {
  final DirectSalesRepository r;

  RejectDirectSales(this.r);

  Future<void> call(int id) => r.reject(id);
}

class GetDSSteps {
  final DirectSalesRepository r;

  GetDSSteps(this.r);

  Future<Map<String, dynamic>> call(int id) => r.getSteps(id);
}