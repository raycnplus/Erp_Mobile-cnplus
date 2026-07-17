import 'package:erp_mobile_cnplus/features/master/uom/data/models/uom_models.dart';
import 'package:erp_mobile_cnplus/features/master/uom/data/repositories/uom_repository.dart';

class GetUomList {
  final UomRepository repository;

  GetUomList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
  }) {
    return repository.getList(
      page: page,
      perPage: perPage,
    );
  }
}

class GetUomDetail {
  final UomRepository repository;

  GetUomDetail(this.repository);

  Future<UomDetailModel> call(String enc) {
    return repository.getDetail(enc);
  }
}

class GetUomFormOptions {
  final UomRepository repository;

  GetUomFormOptions(this.repository);

  Future<List<UomRefOption>> call() {
    return repository.getFormOptions();
  }
}

class CreateUom {
  final UomRepository repository;

  CreateUom(this.repository);

  Future<void> call(UomFormModel form) async {
    if (!form.isValid()) {
      throw Exception('Name and quantity are required');
    }

    await repository.create(form);
  }
}

class UpdateUom {
  final UomRepository repository;

  UpdateUom(this.repository);

  Future<String> call(
    String enc,
    UomFormModel form,
  ) async {
    if (!form.isValid()) {
      throw Exception('Name and quantity are required');
    }

    return repository.update(enc, form);
  }
}

class DeleteUom {
  final UomRepository repository;

  DeleteUom(this.repository);

  Future<void> call(String enc) {
    return repository.delete(enc);
  }
}