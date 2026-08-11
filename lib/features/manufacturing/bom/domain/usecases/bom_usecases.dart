import 'package:erp_mobile_cnplus/features/manufacturing/bom/data/repositories/bom_repository.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/bom/data/models/bom_models.dart';

class GetBomList {
  final BomRepository r;

  GetBomList(this.r);

  Future<Map<String, dynamic>> call({int page = 1, int perPage = 100}) =>
      r.getList(page: page, perPage: perPage);
}

class GetBomDetail {
  final BomRepository r;

  GetBomDetail(this.r);

  Future<BomDetailModel> call(String enc) => r.getDetail(enc);
}

class GetBomFormOptions {
  final BomRepository r;

  GetBomFormOptions(this.r);

  Future<BomFormOptions> call() => r.getFormOptions();
}

class CreateBom {
  final BomRepository r;

  CreateBom(this.r);

  Future<void> call(BomFormModel form) async {
    if (!form.isValid()) {
      throw Exception(
        'BOM name, product, and at least 1 component are required',
      );
    }
    await r.create(form);
  }
}

class UpdateBom {
  final BomRepository r;

  UpdateBom(this.r);

  Future<String> call(String enc, BomFormModel form) async {
    if (!form.isValid()) {
      throw Exception(
        'BOM name, product, and at least 1 component are required',
      );
    }
    return r.update(enc, form);
  }
}

class DeleteBom {
  final BomRepository r;

  DeleteBom(this.r);

  Future<void> call(String enc) => r.delete(enc);
}