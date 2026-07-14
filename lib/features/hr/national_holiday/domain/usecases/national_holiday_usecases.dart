import 'package:erp_mobile_cnplus/features/hr/national_holiday/data/models/national_holiday_models.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/data/repositories/national_holiday_repository.dart';

class GetNationalHolidayList {
  final NationalHolidayRepository
      repository;

  GetNationalHolidayList(
    this.repository,
  );

  Future<Map<String, dynamic>> call({
    int page = 1,
    int perPage = 100,
  }) {
    return repository.getHolidayList(
      page: page,
      perPage: perPage,
    );
  }
}

class GetNationalHolidayDetail {
  final NationalHolidayRepository
      repository;

  GetNationalHolidayDetail(
    this.repository,
  );

  Future<NationalHolidayDetailModel> call(
    String encryption,
  ) {
    return repository.getHolidayDetail(
      encryption,
    );
  }
}

class CreateNationalHoliday {
  final NationalHolidayRepository
      repository;

  CreateNationalHoliday(
    this.repository,
  );

  Future<void> call(
    NationalHolidayFormModel formData,
  ) async {
    if (!formData.isValid()) {
      throw Exception(
        'Holiday name and date are required',
      );
    }

    await repository.createHoliday(
      formData,
    );
  }
}

class UpdateNationalHoliday {
  final NationalHolidayRepository
      repository;

  UpdateNationalHoliday(
    this.repository,
  );

  Future<String> call(
    String encryption,
    NationalHolidayFormModel formData,
  ) async {
    if (!formData.isValid()) {
      throw Exception(
        'Holiday name and date are required',
      );
    }

    return repository.updateHoliday(
      encryption,
      formData,
    );
  }
}

class DeleteNationalHoliday {
  final NationalHolidayRepository
      repository;

  DeleteNationalHoliday(
    this.repository,
  );

  Future<void> call(
    String encryption,
  ) {
    return repository.deleteHoliday(
      encryption,
    );
  }
}