import 'package:erp_mobile_cnplus/features/accounting/journal_entry/data/repositories/journal_entry_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/journal_entry/data/models/journal_entry_models.dart';

class GetJournalEntryList {
  final JournalEntryRepository r;
  GetJournalEntryList(this.r);
  Future<Map<String, dynamic>> call({
    int page = 1, int perPage = 100, String? search, String? status,
    String? startDate, String? endDate,
  }) => r.getList(page: page, perPage: perPage, search: search, status: status, startDate: startDate, endDate: endDate);
}

class GetJournalEntryDetail {
  final JournalEntryRepository r;
  GetJournalEntryDetail(this.r);
  Future<JournalEntryDetailModel> call(String enc) => r.getDetail(enc);
}

class GetJournalEntryFormOptions {
  final JournalEntryRepository r;
  GetJournalEntryFormOptions(this.r);
  Future<JournalEntryFormOptions> call() => r.getFormOptions();
}

class SaveJournalEntry {
  final JournalEntryRepository r;
  SaveJournalEntry(this.r);
  Future<Map<String, dynamic>> call(JournalEntryFormModel f) {
    if (f.isEditMode) return r.update(f.encryption!, f, 'save');
    return r.store(f, 'save');
  }
}

class PostJournalEntry {
  final JournalEntryRepository r;
  PostJournalEntry(this.r);
  Future<Map<String, dynamic>> call(JournalEntryFormModel f) {
    if (f.isEditMode) return r.update(f.encryption!, f, 'post');
    return r.store(f, 'post');
  }
}

class UnpostJournalEntry {
  final JournalEntryRepository r;
  UnpostJournalEntry(this.r);
  Future<Map<String, dynamic>> call(String encryption) => r.unpost(encryption);
}

class DeleteJournalEntry {
  final JournalEntryRepository r;
  DeleteJournalEntry(this.r);
  Future<void> call(String encryption) => r.delete(encryption);
}