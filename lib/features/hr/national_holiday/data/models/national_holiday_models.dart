class NationalHolidayPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  NationalHolidayPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory NationalHolidayPaginationMeta.fromJson(
    Map<String, dynamic> json,
  ) {
    final meta =
        json['data'] is Map<String, dynamic>
            ? json['data']
                as Map<String, dynamic>
            : json;

    return NationalHolidayPaginationMeta(
      currentPage:
      meta['current_page'] ?? 1,
      lastPage: meta['last_page'] ?? 1,
      perPage: meta['per_page'] ?? 15,
      total: meta['total'] ?? 0,
    );
  }
}

class NationalHolidayModel {
  final String encryption;
  final String holidayName;
  final String holidayDate;

  NationalHolidayModel({
    required this.encryption,
    required this.holidayName,
    required this.holidayDate,
  });

  factory NationalHolidayModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return NationalHolidayModel(
      encryption: json['encryption']?.toString() ?? '',
      holidayName: json['holiday_name']?.toString() ?? '',
      holidayDate: json['holiday_date_formatted'] ?.toString() ?? json['holiday_date'] ?.toString() ?? '',
    );
  }
}

class NationalHolidayDetailModel {
  final NationalHolidayData holiday;
  final String? createdByName;
  final String? updatedByName;

  NationalHolidayDetailModel({
    required this.holiday,
    this.createdByName,
    this.updatedByName,
  });

  factory NationalHolidayDetailModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] ?? json;

    return NationalHolidayDetailModel(
      holiday: NationalHolidayData.fromJson(
        data,
      ),
      createdByName: data['created_by_name'] ?.toString(),
      updatedByName: data['updated_by_name'] ?.toString(),
    );
  }
}

class NationalHolidayData {
  final String encryption;
  final String holidayName;
  final String holidayDate;
  final String? createdDate;
  final String? updatedDate;

  NationalHolidayData({
    required this.encryption,
    required this.holidayName,
    required this.holidayDate,
    this.createdDate,
    this.updatedDate,
  });

  factory NationalHolidayData.fromJson(
    Map<String, dynamic> json,
  ) {
    return NationalHolidayData(
      encryption: json['encryption']?.toString() ?? '',
      holidayName: json['holiday_name']?.toString() ?? '',
      holidayDate: json['holiday_date_formatted'] ?.toString() ?? json['holiday_date'] ?.toString() ?? '',
      createdDate: json['created_date'] ?.toString(),
      updatedDate: json['updated_date'] ?.toString(),
    );
  }
}

class NationalHolidayFormModel {
  String? encryption;
  String holidayName;
  String holidayDate;
  String? createdDate;
  String? updatedDate;

  NationalHolidayFormModel({
    this.encryption,
    this.holidayName = '',
    this.holidayDate = '',
    this.createdDate,
    this.updatedDate,
  });

  factory NationalHolidayFormModel.fromDetail(
    NationalHolidayDetailModel detail,
  ) {
    return NationalHolidayFormModel(
      encryption: detail.holiday.encryption,
      holidayName: detail.holiday.holidayName,
      holidayDate: detail.holiday.holidayDate,
      createdDate: detail.holiday.createdDate,
      updatedDate: detail.holiday.updatedDate,
    );
  }

  bool isValid() {
    return holidayName.trim().isNotEmpty &&
        holidayDate.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'holiday_name': holidayName,
      'holiday_date': holidayDate,
    };
  }
}