import 'package:erp_mobile_cnplus/features/sales/quotation/data/repositories/quotation_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/quotation/data/models/quotation_models.dart';

class GetQuotationList {
  final QuotationRepository r;
  GetQuotationList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) => r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetQuotationDetail {
  final QuotationRepository r;
  GetQuotationDetail(this.r);

  Future<QuotationDetailModel> call(String enc) => r.getDetail(enc);
}

class GetQuotationFormOptions {
  final QuotationRepository r;
  GetQuotationFormOptions(this.r);

  Future<QuotationFormOptions> call() => r.getFormOptions();
}

class SaveQuotation {
  final QuotationRepository r;
  SaveQuotation(this.r);

  Future<String> call(QuotationFormModel f, String status, {double defaultTaxRate = 11.0}) {
    if (f.isEditMode) return r.update(f.encryption!, f, status, defaultTaxRate: defaultTaxRate);
    return r.store(f, status, defaultTaxRate: defaultTaxRate);
  }
}

class CancelQuotation {
  final QuotationRepository r;
  CancelQuotation(this.r);

  Future<void> call(int id, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(id, reason);
  }
}

class DeleteQuotation {
  final QuotationRepository r;
  DeleteQuotation(this.r);

  Future<void> call(int id) => r.delete(id);
}

class CreateSalesOrderFromQuotation {
  final QuotationRepository r;
  CreateSalesOrderFromQuotation(this.r);

  Future<Map<String, dynamic>> call(int id) => r.createSO(id);
}

class GetProductsByLocation {
  final QuotationRepository r;
  GetProductsByLocation(this.r);

  Future<List<ProductOption>> call(int locationId) => r.getProductsByLocation(locationId);
}

class GetPriceFromList {
  final QuotationRepository r;
  GetPriceFromList(this.r);

  Future<double?> call(int productId, int priceListId) => r.getPriceFromList(productId, priceListId);
}

class ApproveQuotation {
  final QuotationRepository r;
  ApproveQuotation(this.r);

  Future<void> call(int id) => r.approve(id);
}

class RejectQuotation {
  final QuotationRepository r;
  RejectQuotation(this.r);

  Future<void> call(int id) => r.reject(id);
}

class GetQuotationSteps {
  final QuotationRepository r;
  GetQuotationSteps(this.r);

  Future<Map<String, dynamic>> call(int id) => r.getSteps(id);
}