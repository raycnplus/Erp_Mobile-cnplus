import 'package:dio/dio.dart';
import 'package:erp_mobile_cnplus/features/master/employee/data/models/employee_models.dart';

class EmployeeRemoteDataSource {
  final Dio dio;

  EmployeeRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getEmployeeList({
    int page = 1,
    int perPage = 100,
    String? search,
  }) async {
    try {
      final params = <String, dynamic>{
        'page': page,
        'per_page': perPage,
      };
      if (search != null && search.isNotEmpty) params['search'] = search;

      final response = await dio.get(
        '/master/employees',
        queryParameters: params,
      );
      final json = response.data as Map<String, dynamic>;
      final dataField = json['data'];

      List<dynamic> items;
      int currentPage, lastPage, perPageVal, total;

      if (dataField is Map) {
        final inner = dataField['data'] as List? ?? [];
        items = inner;
        currentPage = dataField['current_page'] ?? 1;
        lastPage = dataField['last_page'] ?? 1;
        perPageVal = dataField['per_page'] ?? 15;
        total = dataField['total'] ?? 0;
      } else {
        items = dataField is List ? dataField : [];
        currentPage = json['current_page'] ?? 1;
        lastPage = json['last_page'] ?? 1;
        perPageVal = json['per_page'] ?? 15;
        total = json['total'] ?? items.length;
      }

      return {
        'items': items.map((e) => EmployeeModel.fromJson(e)).toList(),
        'meta': EmployeePaginationMeta(
          currentPage: currentPage,
          lastPage: lastPage,
          perPage: perPageVal,
          total: total,
        ),
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<EmployeeDetailModel> getEmployeeDetail(String encryption) async {
    try {
      final response = await dio.get('/master/employees/$encryption');
      return EmployeeDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<EmployeeDropdownData> getFormOptions() async {
    try {
      final response = await dio.get('/master/employees/form-options');
      return EmployeeDropdownData.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> createEmployee(EmployeeFormModel formData) async {
    try {
      final fd = await _buildFormData(formData);
      final response = await dio.post('/master/employees', data: fd);
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<String> updateEmployee(
    String encryption,
    EmployeeFormModel formData,
  ) async {
    try {
      final fd = await _buildFormData(formData, isUpdate: true);
      fd.fields.add(const MapEntry('_method', 'PUT'));
      final response = await dio.post(
        '/master/employees/$encryption',
        data: fd,
      );
      return response.data['data']['encryption'] as String;
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<void> deleteEmployee(String encryption) async {
    try {
      await dio.delete('/master/employees/$encryption');
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<Map<String, String>> createUserAccount(
    String encryption,
    int idRole,
  ) async {
    try {
      final response = await dio.post(
        '/master/employees/$encryption/create-user-account',
        data: {'id_role': idRole},
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return {
        'username': data['username']?.toString() ?? '',
        'password': data['password']?.toString() ?? '',
      };
    } on DioException catch (e) {
      throw Exception(_err(e));
    }
  }

  Future<FormData> _buildFormData(
    EmployeeFormModel f, {
    bool isUpdate = false,
  }) async {
    final map = <String, dynamic>{};

    void addIfNotNull(String key, dynamic val) {
      if (val != null) map[key] = val;
    }

    map['employee_name'] = f.employeeName;
    addIfNotNull('gender', f.gender);
    addIfNotNull('birth_date', f.birthDate);
    addIfNotNull('phone_number', f.phoneNumber);
    addIfNotNull('email', f.email);
    addIfNotNull('address', f.address);
    addIfNotNull('id_department', f.idDepartment);
    addIfNotNull('id_position', f.idPosition);
    addIfNotNull('id_manager', f.idManager);
    addIfNotNull('id_employee_status', f.idEmployeeStatus);
    addIfNotNull('bank_name', f.bankName);
    addIfNotNull('bank_account_number', f.bankAccountNumber);
    addIfNotNull('bank_account_holder', f.bankAccountHolder);
    addIfNotNull('basic_salary', f.basicSalary);
    addIfNotNull('allowance', f.allowance);
    addIfNotNull('ktp_number', f.ktpNumber);
    addIfNotNull('npwp_number', f.npwpNumber);
    addIfNotNull('bpjs_number', f.bpjsNumber);

    if (f.newImagePath != null) {
      map['cropped_image'] = await MultipartFile.fromFile(
        f.newImagePath!,
        filename: 'image.jpg',
      );
    } else if (isUpdate && f.oldHashedImage != null) {
      map['old_image'] = f.oldHashedImage;
    }

    if (f.newKtpFilePath != null) {
      map['ktp_file'] = await MultipartFile.fromFile(
        f.newKtpFilePath!,
        filename: 'ktp.jpg',
      );
    } else if (isUpdate && f.oldHashedKtpFile != null) {
      map['old_ktp_file'] = f.oldHashedKtpFile;
    }

    if (f.newNpwpFilePath != null) {
      map['npwp_file'] = await MultipartFile.fromFile(
        f.newNpwpFilePath!,
        filename: 'npwp.jpg',
      );
    } else if (isUpdate && f.oldHashedNpwpFile != null) {
      map['old_npwp_file'] = f.oldHashedNpwpFile;
    }

    if (f.newBpjsFilePath != null) {
      map['bpjs_file'] = await MultipartFile.fromFile(
        f.newBpjsFilePath!,
        filename: 'bpjs.jpg',
      );
    } else if (isUpdate && f.oldHashedBpjsFile != null) {
      map['old_bpjs_file'] = f.oldHashedBpjsFile;
    }

    return FormData.fromMap(map);
  }

  String _err(DioException e) =>
      e.response?.data['message'] ?? 'Network error: ${e.message}';
}