import 'package:erp_mobile_cnplus/features/sales/service_sales/service_invoice/data/repositories/service_invoice_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_invoice/data/models/service_invoice_models.dart';

class GetServiceInvoiceList {
  final ServiceInvoiceRepository r;

  GetServiceInvoiceList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) =>
      r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetServiceInvoiceDetail {
  final ServiceInvoiceRepository r;

  GetServiceInvoiceDetail(this.r);

  Future<ServiceInvoiceDetailModel> call(String enc) => r.getDetail(enc);
}

class GetServiceInvoiceFormOptions {
  final ServiceInvoiceRepository r;

  GetServiceInvoiceFormOptions(this.r);

  Future<ServiceInvoiceFormOptions> call() => r.getFormOptions();
}

class SaveServiceInvoice {
  final ServiceInvoiceRepository r;

  SaveServiceInvoice(this.r);

  Future<String> call(ServiceInvoiceFormModel f, String status, {double defaultTaxRate = 11.0}) {
    if (f.isEditMode) {
      return r.update(f.encryption!, f, status, defaultTaxRate: defaultTaxRate);
    }
    return r.store(f, status, defaultTaxRate: defaultTaxRate);
  }
}

class CancelServiceInvoice {
  final ServiceInvoiceRepository r;

  CancelServiceInvoice(this.r);

  Future<void> call(int id, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(id, reason);
  }
}

class DeleteServiceInvoice {
  final ServiceInvoiceRepository r;

  DeleteServiceInvoice(this.r);

  Future<void> call(int id) => r.delete(id);
}

class CreateServiceInvoicePayment {
  final ServiceInvoiceRepository r;

  CreateServiceInvoicePayment(this.r);

  Future<Map<String, dynamic>> call(int id) => r.createPayment(id);
}

class GetServiceInvoicePriceFromList {
  final ServiceInvoiceRepository r;

  GetServiceInvoicePriceFromList(this.r);

  Future<double?> call(int productId, int priceListId) =>
      r.getPriceFromList(productId, priceListId);
}

class ApproveServiceInvoice {
  final ServiceInvoiceRepository r;

  ApproveServiceInvoice(this.r);

  Future<void> call(int id) => r.approve(id);
}

class RejectServiceInvoice {
  final ServiceInvoiceRepository r;

  RejectServiceInvoice(this.r);

  Future<void> call(int id) => r.reject(id);
}

class GetServiceInvoiceSteps {
  final ServiceInvoiceRepository r;

  GetServiceInvoiceSteps(this.r);

  Future<Map<String, dynamic>> call(int id) => r.getSteps(id);
}