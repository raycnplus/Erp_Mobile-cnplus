import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/data/repositories/service_quotation_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/data/models/service_quotation_models.dart';

class GetSQList {
  final ServiceQuotationRepository r;

  GetSQList(this.r);

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

class GetSQDetail {
  final ServiceQuotationRepository r;

  GetSQDetail(this.r);

  Future<ServiceQuotationDetailModel> call(String enc) => r.getDetail(enc);
}

class GetSQFormOptions {
  final ServiceQuotationRepository r;

  GetSQFormOptions(this.r);

  Future<ServiceQuotationFormOptions> call() => r.getFormOptions();
}

class SaveServiceQuotation {
  final ServiceQuotationRepository r;

  SaveServiceQuotation(this.r);

  Future<String> call(
    ServiceQuotationFormModel f,
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

class CancelServiceQuotation {
  final ServiceQuotationRepository r;

  CancelServiceQuotation(this.r);

  Future<void> call(int id, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(id, reason);
  }
}

class DeleteServiceQuotation {
  final ServiceQuotationRepository r;

  DeleteServiceQuotation(this.r);

  Future<void> call(int id) => r.delete(id);
}

class CreateSSOFromSQ {
  final ServiceQuotationRepository r;

  CreateSSOFromSQ(this.r);

  Future<Map<String, dynamic>> call(int id) => r.createSSO(id);
}

class GetSQPriceFromList {
  final ServiceQuotationRepository r;

  GetSQPriceFromList(this.r);

  Future<double?> call(int serviceId, int priceListId) =>
      r.getPriceFromList(serviceId, priceListId);
}

class ApproveSQ {
  final ServiceQuotationRepository r;

  ApproveSQ(this.r);

  Future<void> call(int id) => r.approve(id);
}

class RejectSQ {
  final ServiceQuotationRepository r;

  RejectSQ(this.r);

  Future<void> call(int id) => r.reject(id);
}

class GetSQSteps {
  final ServiceQuotationRepository r;

  GetSQSteps(this.r);

  Future<Map<String, dynamic>> call(int id) => r.getSteps(id);
}