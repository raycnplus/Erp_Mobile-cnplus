import 'package:erp_mobile_cnplus/features/hr/position/data/models/position_models.dart';
import 'package:erp_mobile_cnplus/features/hr/position/data/repositories/position_repository.dart';

class GetPositionList {
  final PositionRepository repository;

  GetPositionList(this.repository);

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
  }) {
    return repository.getPositionList(
      page: page,
      perPage: perPage,
    );
  }
}

class GetPositionDetail {
  final PositionRepository repository;

  GetPositionDetail(this.repository);

  Future<PositionDetailModel> call(
    String encryption,
  ) {
    return repository.getPositionDetail(encryption);
  }
}

class CreatePosition {
  final PositionRepository repository;

  CreatePosition(this.repository);

  Future<void> call(
    PositionFormModel form,
  ) async {
    if (!form.isValid) {
      throw Exception('Position name is required');
    }

    await repository.createPosition(form);
  }
}

class UpdatePosition {
  final PositionRepository repository;

  UpdatePosition(this.repository);

  Future<String> call(
    String encryption,
    PositionFormModel form,
  ) async {
    if (!form.isValid) {
      throw Exception('Position name is required');
    }

    return repository.updatePosition(
      encryption,
      form,
    );
  }
}

class DeletePosition {
  final PositionRepository repository;

  DeletePosition(this.repository);

  Future<void> call(
    String encryption,
  ) {
    return repository.deletePosition(encryption);
  }
}