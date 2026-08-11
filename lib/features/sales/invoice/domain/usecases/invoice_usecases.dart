import 'package:erp_mobile_cnplus/features/sales/invoice/data/repositories/invoice_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/invoice/data/models/invoice_models.dart';

class GetInvoiceList {
  final InvoiceRepository r;

  GetInvoiceList(this.r);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
    String? status,
    String? search,
  }) =>
      r.getList(page: page, perPage: perPage, status: status, search: search);
}

class GetInvoiceDetail {
  final InvoiceRepository r;

  GetInvoiceDetail(this.r);

  Future<InvoiceDetailModel> call(String enc) => r.getDetail(enc);
}

class GetInvoiceFormOptions {
  final InvoiceRepository r;

  GetInvoiceFormOptions(this.r);

  Future<InvoiceFormOptions> call() => r.getFormOptions();
}

class SaveInvoice {
  final InvoiceRepository r;

  SaveInvoice(this.r);

  Future<String> call(InvoiceFormModel f, String status, {double defaultTaxRate = 11.0}) {
    if (f.isEditMode) {
      return r.update(f.encryption!, f, status, defaultTaxRate: defaultTaxRate);
    }
    return r.store(f, status, defaultTaxRate: defaultTaxRate);
  }
}

class CancelInvoice {
  final InvoiceRepository r;

  CancelInvoice(this.r);

  Future<void> call(int id, String reason) {
    if (reason.trim().isEmpty) throw Exception('Cancel reason is required');
    return r.cancel(id, reason);
  }
}

class DeleteInvoice {
  final InvoiceRepository r;

  DeleteInvoice(this.r);

  Future<void> call(int id) => r.delete(id);
}

class CreatePaymentFromInvoice {
  final InvoiceRepository r;

  CreatePaymentFromInvoice(this.r);

  Future<Map<String, dynamic>> call(int id) => r.createPayment(id);
}

class GetInvPriceFromList {
  final InvoiceRepository r;

  GetInvPriceFromList(this.r);

  Future<double?> call(int productId, int priceListId) =>
      r.getPriceFromList(productId, priceListId);
}

class ApproveInvoice {
  final InvoiceRepository r;

  ApproveInvoice(this.r);

  Future<void> call(int id) => r.approve(id);
}

class RejectInvoice {
  final InvoiceRepository r;

  RejectInvoice(this.r);

  Future<void> call(int id) => r.reject(id);
}

class GetInvoiceSteps {
  final InvoiceRepository r;

  GetInvoiceSteps(this.r);

  Future<Map<String, dynamic>> call(int id) => r.getSteps(id);
}