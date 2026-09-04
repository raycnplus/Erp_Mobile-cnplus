import 'package:erp_mobile_cnplus/features/hr/my_payslip/data/datasources/my_payslip_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/my_payslip/data/models/my_payslip_models.dart';

class MyPaySlipRepository {
  final MyPaySlipRemoteDataSource remoteDataSource;

  MyPaySlipRepository({
    required this.remoteDataSource,
  });

  Future<MyPaySlipResponse>
      getMyPaySlipList({
    int page = 1,
    int perPage = 10,
    String? search,
    String? status,
    int? year,
  }) async {
    final raw =
        await remoteDataSource.getMyPaySlipList(
      page: page,
      perPage: perPage,
      search: search,
      status: status,
      year: year,
    );

    return MyPaySlipResponse.fromJson(
      raw,
    );
  }

  Future<MyPaySlipDetailResponse>
      getMyPaySlipDetail(
    String encryption,
  ) async {
    final raw =
        await remoteDataSource
            .getMyPaySlipDetail(
      encryption,
    );

    return MyPaySlipDetailResponse.fromJson(
      _extractDetailData(raw),
    );
  }

  Map<String, dynamic> _extractDetailData(
    Map<String, dynamic> raw,
  ) {
    final data = raw['data'];

    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return {};
  }
}