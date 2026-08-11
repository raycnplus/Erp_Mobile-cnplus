import 'package:erp_mobile_cnplus/features/sales/price_list/data/repositories/price_list_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/data/models/price_list_models.dart';

class GetPriceListList {
  final PriceListRepository r;
  GetPriceListList(this.r);
  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100}) => r.getList(page: page, perPage: perPage);
}

class GetPriceListDetail {
  final PriceListRepository r;
  GetPriceListDetail(this.r);
  Future<PriceListDetailModel> call(String enc) => r.getDetail(enc);
}

class GetPriceListProducts {
  final PriceListRepository r;
  GetPriceListProducts(this.r);
  Future<List<PriceListProductOption>> call() => r.getFormOptions();
}

class CreatePriceList {
  final PriceListRepository r;
  CreatePriceList(this.r);
  Future<void> call(PriceListFormModel f) async {
    if (!f.isValid()) throw Exception('Price list name and at least 1 product are required');
    await r.create(f);
  }
}

class UpdatePriceList {
  final PriceListRepository r;
  UpdatePriceList(this.r);
  Future<String> call(String enc, PriceListFormModel f) async {
    if (!f.isValid()) throw Exception('Price list name and at least 1 product are required');
    return r.update(enc, f);
  }
}

class DeletePriceList {
  final PriceListRepository r;
  DeletePriceList(this.r);
  Future<void> call(String enc) => r.delete(enc);
}