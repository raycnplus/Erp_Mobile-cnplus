import 'package:erp_mobile_cnplus/features/accounting/journal_entry/data/datasources/journal_entry_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/journal_entry/data/models/journal_entry_models.dart';

class JournalEntryRepository {
  final JournalEntryRemoteDataSource ds;
  JournalEntryRepository(this.ds);

  Future<Map<String, dynamic>> getList({
    int page = 1, int perPage = 100, String? search, String? status,
    String? startDate, String? endDate,
  }) => ds.getList(page: page, perPage: perPage, search: search, status: status, startDate: startDate, endDate: endDate);

  Future<JournalEntryDetailModel> getDetail(String enc) => ds.getDetail(enc);
  Future<JournalEntryFormOptions> getFormOptions() => ds.getFormOptions();

  Future<Map<String, dynamic>> store(JournalEntryFormModel f, String action) => ds.store(f, action);
  Future<Map<String, dynamic>> update(String encryption, JournalEntryFormModel f, String action) =>
      ds.update(encryption, f, action);

  Future<void> delete(String encryption) => ds.delete(encryption);
  Future<Map<String, dynamic>> unpost(String encryption) => ds.unpost(encryption);
}