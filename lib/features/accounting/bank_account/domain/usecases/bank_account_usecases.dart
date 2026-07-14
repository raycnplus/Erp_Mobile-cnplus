import 'package:erp_mobile_cnplus/features/accounting/bank_account/data/models/bank_account_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/bank_account/data/repositories/bank_account_repository.dart';

class GetBankAccountList {
  final BankAccountRepository repository;

  GetBankAccountList(this.repository);

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

class GetBankAccountDetail {
  final BankAccountRepository repository;

  GetBankAccountDetail(this.repository);

  Future<BankAccountDetailModel> call(String encryption) {
    return repository.getDetail(encryption);
  }
}

class GetBankAccountFormOptions {
  final BankAccountRepository repository;

  GetBankAccountFormOptions(this.repository);

  Future<BankAccountFormOptions> call() {
    return repository.getFormOptions();
  }
}

class CreateBankAccount {
  final BankAccountRepository repository;

  CreateBankAccount(this.repository);

  Future<void> call(BankAccountFormModel form) async {
    if (!form.isValid()) {
      throw Exception(
        'Bank name, account name, and account number are required',
      );
    }

    await repository.create(form);
  }
}

class UpdateBankAccount {
  final BankAccountRepository repository;

  UpdateBankAccount(this.repository);

  Future<String> call(
    String encryption,
    BankAccountFormModel form,
  ) async {
    if (!form.isValid()) {
      throw Exception(
        'Bank name, account name, and account number are required',
      );
    }

    return repository.update(
      encryption,
      form,
    );
  }
}

class DeleteBankAccount {
  final BankAccountRepository repository;

  DeleteBankAccount(this.repository);

  Future<void> call(String encryption) {
    return repository.delete(encryption);
  }
}