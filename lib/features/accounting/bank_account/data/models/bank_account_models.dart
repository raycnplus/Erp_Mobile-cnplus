class BankAccountPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const BankAccountPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory BankAccountPaginationMeta.fromJson(Map<String, dynamic> json) {
    final m = json['data'] is Map
        ? json['data'] as Map<String, dynamic>
        : json;
    return BankAccountPaginationMeta(
      currentPage: m['current_page'] ?? 1,
      lastPage: m['last_page'] ?? 1,
      perPage: m['per_page'] ?? 15,
      total: m['total'] ?? 0,
    );
  }
}

class BankAccountModel {
  final String encryption;
  final String bankName;
  final String bankAccountName;
  final String bankAccountNumber;
  final String? description;
  final String? coaNumber;
  final String? coaName;

  const BankAccountModel({
    required this.encryption,
    required this.bankName,
    required this.bankAccountName,
    required this.bankAccountNumber,
    this.description,
    this.coaNumber,
    this.coaName,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      encryption: json['encryption']?.toString() ?? '',
      bankName: json['bank_name']?.toString() ?? '',
      bankAccountName: json['bank_account_name']?.toString() ?? '',
      bankAccountNumber: json['bank_account_number']?.toString() ?? '',
      description: json['description']?.toString(),
      coaNumber: json['coa_number']?.toString(),
      coaName: json['coa_name']?.toString(),
    );
  }
}

class BankAccountDetailModel {
  final BankAccountData bankAccount;
  final CoaRef? coa;
  final String? createdByName;
  final String? updatedByName;

  const BankAccountDetailModel({
    required this.bankAccount,
    this.coa,
    this.createdByName,
    this.updatedByName,
  });

  factory BankAccountDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return BankAccountDetailModel(
      bankAccount: BankAccountData.fromJson(data),
      coa: data['coa'] != null ? CoaRef.fromJson(data['coa']) : null,
      createdByName: data['created_by_name']?.toString(),
      updatedByName: data['updated_by_name']?.toString(),
    );
  }
}

class CoaRef {
  final int idCoa;
  final String coaNumber;
  final String coaName;

  const CoaRef({
    required this.idCoa,
    required this.coaNumber,
    required this.coaName,
  });

  factory CoaRef.fromJson(Map<String, dynamic> json) {
    return CoaRef(
      idCoa: json['id_coa'] is int
          ? json['id_coa']
          : int.tryParse(json['id_coa']?.toString() ?? '0') ?? 0,
      coaNumber: json['coa_number']?.toString() ?? '',
      coaName: json['coa_name']?.toString() ?? '',
    );
  }
}

class BankAccountData {
  final String encryption;
  final String bankName;
  final String bankAccountName;
  final String bankAccountNumber;
  final String? description;
  final int? idCoa;
  final String? createdDate;
  final String? updatedDate;

  const BankAccountData({
    required this.encryption,
    required this.bankName,
    required this.bankAccountName,
    required this.bankAccountNumber,
    this.description,
    this.idCoa,
    this.createdDate,
    this.updatedDate,
  });

  factory BankAccountData.fromJson(Map<String, dynamic> json) {
    return BankAccountData(
      encryption: json['encryption']?.toString() ?? '',
      bankName: json['bank_name']?.toString() ?? '',
      bankAccountName: json['bank_account_name']?.toString() ?? '',
      bankAccountNumber: json['bank_account_number']?.toString() ?? '',
      description: json['description']?.toString(),
      idCoa: json['id_coa'] is int
          ? json['id_coa']
          : int.tryParse(json['id_coa']?.toString() ?? ''),
      createdDate: json['created_date']?.toString(),
      updatedDate: json['updated_date']?.toString(),
    );
  }
}

class BankAccountCoaOption {
  final int id;
  final String coaNumber;
  final String coaName;

  const BankAccountCoaOption({
    required this.id,
    required this.coaNumber,
    required this.coaName,
  });

  factory BankAccountCoaOption.fromJson(Map<String, dynamic> json) {
    return BankAccountCoaOption(
      id: json['id_coa'] is int
          ? json['id_coa']
          : int.tryParse(json['id_coa']?.toString() ?? '0') ?? 0,
      coaNumber: json['coa_number']?.toString() ?? '',
      coaName: json['coa_name']?.toString() ?? '',
    );
  }

  String get displayName => '$coaNumber - $coaName';

  @override
  bool operator ==(Object o) => o is BankAccountCoaOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class BankAccountFormOptions {
  final List<BankAccountCoaOption> coaList;

  const BankAccountFormOptions({required this.coaList});

  factory BankAccountFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return BankAccountFormOptions(
      coaList: (data['coa_list'] as List? ?? [])
          .map((e) => BankAccountCoaOption.fromJson(e))
          .toList(),
    );
  }
}

class BankAccountFormModel {
  String? encryption;
  String bankName;
  String bankAccountName;
  String bankAccountNumber;
  String? description;
  int? idCoa;

  BankAccountFormModel({
    this.encryption,
    this.bankName = '',
    this.bankAccountName = '',
    this.bankAccountNumber = '',
    this.description,
    this.idCoa,
  });

  factory BankAccountFormModel.fromDetail(BankAccountDetailModel detail) {
    final d = detail.bankAccount;
    return BankAccountFormModel(
      encryption: d.encryption,
      bankName: d.bankName,
      bankAccountName: d.bankAccountName,
      bankAccountNumber: d.bankAccountNumber,
      description: d.description,
      idCoa: d.idCoa,
    );
  }

  bool isValid() =>
      bankName.trim().isNotEmpty &&
      bankAccountName.trim().isNotEmpty &&
      bankAccountNumber.trim().isNotEmpty;

  Map<String, dynamic> toJson() => {
        'bank_name': bankName,
        'bank_account_name': bankAccountName,
        'bank_account_number': bankAccountNumber,
        if (description != null && description!.isNotEmpty)
          'description': description,
        if (idCoa != null) 'id_coa': idCoa,
      };
}