import 'package:erp_mobile_cnplus/features/hr/my_payslip/data/models/my_payslip_models.dart';
import 'package:erp_mobile_cnplus/features/hr/my_payslip/data/repositories/my_payslip_repository.dart';

class GetMyPaySlipList {
  final MyPaySlipRepository repository;

  GetMyPaySlipList(this.repository);

  Future<MyPaySlipResponse> call({
    int page = 1,
    int perPage = 10,
    String? search,
    String? status,
    int? year,
  }) {
    return repository.getMyPaySlipList(
      page: page,
      perPage: perPage,
      search: search,
      status: status,
      year: year,
    );
  }
}

class GetMyPaySlipDetail {
  final MyPaySlipRepository repository;

  GetMyPaySlipDetail(this.repository);

  Future<MyPaySlipDetailResponse> call(
    String encryption,
  ) {
    return repository.getMyPaySlipDetail(
      encryption,
    );
  }
}