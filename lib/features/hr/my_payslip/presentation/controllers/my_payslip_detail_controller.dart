import 'package:flutter/material.dart';

import 'package:erp_mobile_cnplus/features/hr/my_payslip/data/models/my_payslip_models.dart';
import 'package:erp_mobile_cnplus/features/hr/my_payslip/domain/usecases/my_payslip_usecases.dart';

enum MyPaySlipDetailStatus {
  initial,
  loading,
  loaded,
  error,
}

class MyPaySlipDetailController
    extends ChangeNotifier {
  final GetMyPaySlipDetail getMyPaySlipDetail;

  MyPaySlipDetailController({
    required this.getMyPaySlipDetail,
  });

  MyPaySlipDetailStatus _status =
      MyPaySlipDetailStatus.initial;

  String? _errorMessage;

  MyPaySlipDetailResponse? _data;

  MyPaySlipDetailStatus get status =>
      _status;

  String? get errorMessage =>
      _errorMessage;

  MyPaySlipDetailResponse? get data =>
      _data;

  bool get isLoading =>
      _status ==
      MyPaySlipDetailStatus.loading;

  bool get hasData =>
      _data != null;

  Future<void> fetchDetail(
    String encryption,
  ) async {
    _status =
        MyPaySlipDetailStatus.loading;

    _errorMessage = null;

    notifyListeners();

    try {
      _data =
          await getMyPaySlipDetail(
        encryption,
      );

      _status =
          MyPaySlipDetailStatus.loaded;
    } catch (e) {
      _status =
          MyPaySlipDetailStatus.error;

      _errorMessage = e
          .toString()
          .replaceFirst(
            'Exception: ',
            '',
          );
    } finally {
      notifyListeners();
    }
  }
}