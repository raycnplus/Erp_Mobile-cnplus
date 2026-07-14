import 'package:erp_mobile_cnplus/features/accounting/coa/data/models/coa_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/coa/data/repositories/coa_repository.dart';

class GetCoaList {
  final CoaRepository repository;

  GetCoaList(this.repository);

  Future<List<CoaModel>> call({
    String? search,
  }) {
    return repository.getCoaList(search: search);
  }
}

class GetCoaDetail {
  final CoaRepository repository;

  GetCoaDetail(this.repository);

  Future<CoaDetailModel> call(String encryption) {
    return repository.getCoaDetail(encryption);
  }
}

class GetCoaFormOptions {
  final CoaRepository repository;

  GetCoaFormOptions(this.repository);

  Future<CoaFormOptions> call() {
    return repository.getFormOptions();
  }
}

class GetCoaAutonumber {
  final CoaRepository repository;

  GetCoaAutonumber(this.repository);

  Future<int> call({
    int? parentId,
    String? isHeader,
  }) {
    return repository.getAutonumber(
      parentId: parentId,
      isHeader: isHeader,
    );
  }
}

class CheckCoaChildren {
  final CoaRepository repository;

  CheckCoaChildren(this.repository);

  Future<bool> call(String encryption) {
    return repository.checkChildren(encryption);
  }
}

class CreateCoa {
  final CoaRepository repository;

  CreateCoa(this.repository);

  Future<void> call(CoaFormModel form) async {
    if (!form.isValid()) {
      throw Exception(
        'COA Number, Name, Type, and Report Type are required',
      );
    }

    await repository.createCoa(form);
  }
}

class UpdateCoa {
  final CoaRepository repository;

  UpdateCoa(this.repository);

  Future<String> call(
    String encryption,
    CoaFormModel form,
  ) async {
    if (!form.isValid()) {
      throw Exception(
        'COA Number, Name, Type, and Report Type are required',
      );
    }

    return repository.updateCoa(
      encryption,
      form,
    );
  }
}

class DeleteCoa {
  final CoaRepository repository;

  DeleteCoa(this.repository);

  Future<void> call(String encryption) {
    return repository.deleteCoa(encryption);
  }
}