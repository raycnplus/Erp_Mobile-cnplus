import 'package:erp_mobile_cnplus/features/hr/national_holiday/data/datasources/national_holiday_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/data/models/national_holiday_models.dart';

class NationalHolidayRepository {
  final NationalHolidayRemoteDataSource remoteDataSource;
  NationalHolidayRepository({required this.remoteDataSource});
  Future<Map<String, dynamic>> getHolidayList({int page = 1, int perPage = 100}) => remoteDataSource.getHolidayList(page: page, perPage: perPage);
  Future<NationalHolidayDetailModel> getHolidayDetail(String enc) => remoteDataSource.getHolidayDetail(enc);
  Future<void> createHoliday(NationalHolidayFormModel f) => remoteDataSource.createHoliday(f);
  Future<String> updateHoliday(String enc, NationalHolidayFormModel f) => remoteDataSource.updateHoliday(enc, f);
  Future<void> deleteHoliday(String enc) => remoteDataSource.deleteHoliday(enc);
}