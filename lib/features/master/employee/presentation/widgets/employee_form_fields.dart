import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/features/master/employee/data/models/employee_models.dart';

class EmployeeFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final EmployeeFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;
  final EmployeeDropdownData? dropdownData;
  final bool isLoadingDropdown;

  const EmployeeFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
    required this.dropdownData,
    required this.isLoadingDropdown,
  });

  @override
  State<EmployeeFormFields> createState() => _EmployeeFormFieldsState();
}

class _EmployeeFormFieldsState extends State<EmployeeFormFields>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  late TextEditingController _nameCtrl, _phoneCtrl, _emailCtrl, _addressCtrl;
  late TextEditingController _ktpCtrl, _npwpCtrl, _bpjsCtrl;
  late TextEditingController _bankNameCtrl, _bankAccCtrl, _bankHolderCtrl;
  late TextEditingController _salaryCtrl, _allowanceCtrl;

  bool _synced = false;
  DateTime? _birthDate;

  static const _genderOptions = [
    {'value': 'M', 'label': 'Male'},
    {'value': 'F', 'label': 'Female'},
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    final f = widget.formData;
    _nameCtrl = TextEditingController(text: f.employeeName);
    _phoneCtrl = TextEditingController(text: f.phoneNumber ?? '');
    _emailCtrl = TextEditingController(text: f.email ?? '');
    _addressCtrl = TextEditingController(text: f.address ?? '');
    _ktpCtrl = TextEditingController(text: f.ktpNumber ?? '');
    _npwpCtrl = TextEditingController(text: f.npwpNumber ?? '');
    _bpjsCtrl = TextEditingController(text: f.bpjsNumber ?? '');
    _bankNameCtrl = TextEditingController(text: f.bankName ?? '');
    _bankAccCtrl = TextEditingController(text: f.bankAccountNumber ?? '');
    _bankHolderCtrl = TextEditingController(text: f.bankAccountHolder ?? '');
    _salaryCtrl = TextEditingController(text: f.basicSalary?.toStringAsFixed(0) ?? '');
    _allowanceCtrl = TextEditingController(text: f.allowance?.toStringAsFixed(0) ?? '');
    if (f.birthDate != null) _birthDate = DateTime.tryParse(f.birthDate!);
    if (widget.dropdownData != null) _synced = true;
  }

  @override
  void didUpdateWidget(EmployeeFormFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_synced && widget.dropdownData != null) setState(() => _synced = true);
  }

  @override
  void dispose() {
    _tab.dispose();
    for (final c in [
      _nameCtrl, _phoneCtrl, _emailCtrl, _addressCtrl,
      _ktpCtrl, _npwpCtrl, _bpjsCtrl,
      _bankNameCtrl, _bankAccCtrl, _bankHolderCtrl,
      _salaryCtrl, _allowanceCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _saveAllFields() {
    final f = widget.formData;
    f.employeeName = _nameCtrl.text;
    f.phoneNumber = _phoneCtrl.text.isEmpty ? null : _phoneCtrl.text;
    f.email = _emailCtrl.text.isEmpty ? null : _emailCtrl.text;
    f.address = _addressCtrl.text.isEmpty ? null : _addressCtrl.text;
    f.ktpNumber = _ktpCtrl.text.isEmpty ? null : _ktpCtrl.text;
    f.npwpNumber = _npwpCtrl.text.isEmpty ? null : _npwpCtrl.text;
    f.bpjsNumber = _bpjsCtrl.text.isEmpty ? null : _bpjsCtrl.text;
    f.bankName = _bankNameCtrl.text.isEmpty ? null : _bankNameCtrl.text;
    f.bankAccountNumber = _bankAccCtrl.text.isEmpty ? null : _bankAccCtrl.text;
    f.bankAccountHolder = _bankHolderCtrl.text.isEmpty ? null : _bankHolderCtrl.text;
    f.basicSalary = double.tryParse(_salaryCtrl.text.replaceAll(RegExp(r'[^\d]'), ''));
    f.allowance = double.tryParse(_allowanceCtrl.text.replaceAll(RegExp(r'[^\d]'), ''));
    if (_birthDate != null) {
      f.birthDate = '${_birthDate!.year}-'
          '${_birthDate!.month.toString().padLeft(2, '0')}-'
          '${_birthDate!.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _pickImage(String type) async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file == null) return;
    setState(() {
      switch (type) {
        case 'image': widget.formData.newImagePath = file.path; break;
        case 'ktp': widget.formData.newKtpFilePath = file.path; break;
        case 'npwp': widget.formData.newNpwpFilePath = file.path; break;
        case 'bpjs': widget.formData.newBpjsFilePath = file.path; break;
      }
    });
  }

  DeptDropdown? _findDept(int? id) {
    if (id == null || widget.dropdownData == null) return null;
    final m = widget.dropdownData!.departments.where((d) => d.id == id);
    return m.isEmpty ? null : m.first;
  }

  PosDropdown? _findPos(int? id) {
    if (id == null || widget.dropdownData == null) return null;
    final m = widget.dropdownData!.positions.where((d) => d.id == id);
    return m.isEmpty ? null : m.first;
  }

  EmpStatusDropdown? _findStatus(int? id) {
    if (id == null || widget.dropdownData == null) return null;
    final m = widget.dropdownData!.employeeStatuses.where((d) => d.id == id);
    return m.isEmpty ? null : m.first;
  }

  ManagerDropdown? _findManager(int? id) {
    if (id == null || widget.dropdownData == null) return null;
    final m = widget.dropdownData!.managers.where((d) => d.id == id);
    return m.isEmpty ? null : m.first;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoadingDropdown) {
      return const Center(child: CircularProgressIndicator(color: colorPrimary));
    }
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Container(
            color: colorCard,
            child: TabBar(
              controller: _tab,
              labelColor: colorPrimary,
              unselectedLabelColor: colorGrey,
              indicatorColor: colorPrimary,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Personal'),
                Tab(text: 'Employment'),
                Tab(text: 'Finance'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [_buildPersonal(), _buildEmployment(), _buildFinance()],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorCard,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _saveAllFields();
                  widget.onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Text(
                  widget.isEditMode ? 'Update Employee' : 'Create Employee',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonal() {
    final f = widget.formData;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: GestureDetector(
              onTap: () => _pickImage('image'),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorBackground,
                  border: Border.all(color: colorGreyLight, width: 2),
                ),
                child: f.newImagePath != null
                    ? ClipOval(child: Image.file(File(f.newImagePath!), fit: BoxFit.cover))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.camera_alt_outlined, color: colorGrey, size: 32),
                          Text('Photo', style: GoogleFonts.poppins(fontSize: 11, color: colorGrey)),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          CustomFormInput(
            controller: _nameCtrl,
            label: 'Employee Name',
            required: true,
            hintText: 'Enter employee name',
            validator: (_) => _nameCtrl.text.trim().isEmpty ? 'Employee name is required' : null,
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gender',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: _genderOptions.map((opt) {
                  final isSelected = f.gender == opt['value'];
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => setState(() => f.gender = opt['value']),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? colorPrimary.withOpacity(0.1) : colorBackground,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected ? colorPrimary : colorGreyLight,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              opt['label']!,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                                color: isSelected ? colorPrimary : colorGrey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Birth Date',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final p = await showDatePicker(
                    context: context,
                    initialDate: _birthDate ?? DateTime(1990),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                    builder: (ctx, child) => Theme(
                      data: Theme.of(ctx).copyWith(
                        colorScheme: const ColorScheme.light(primary: colorPrimary),
                      ),
                      child: child!,
                    ),
                  );
                  if (p != null) setState(() => _birthDate = p);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: colorBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorGreyLight),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: colorPrimary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _birthDate != null
                              ? '${_birthDate!.day.toString().padLeft(2, '0')}/'
                                  '${_birthDate!.month.toString().padLeft(2, '0')}/'
                                  '${_birthDate!.year}'
                              : 'Select birth date',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: _birthDate != null ? colorTextPrimary : colorGrey,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: colorGrey),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: _phoneCtrl,
            label: 'Phone Number',
            hintText: 'Enter phone number',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: _emailCtrl,
            label: 'Email',
            hintText: 'Enter email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          CustomFormInput(
            controller: _addressCtrl,
            label: 'Address',
            hintText: 'Enter address',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Identity Documents',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorTextPrimary,
            ),
          ),
          const SizedBox(height: 10),
          CustomFormInput(controller: _ktpCtrl, label: 'KTP Number', hintText: 'Enter KTP number'),
          const SizedBox(height: 10),
          CustomFormInput(controller: _npwpCtrl, label: 'NPWP Number', hintText: 'Enter NPWP number'),
          const SizedBox(height: 10),
          CustomFormInput(controller: _bpjsCtrl, label: 'BPJS Number', hintText: 'Enter BPJS number'),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEmployment() {
    final f = widget.formData;
    final items = widget.dropdownData;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomSearchableDropdown<DeptDropdown>(
            key: ValueKey('dept_${f.idDepartment}_${items?.departments.length ?? 0}'),
            value: _findDept(f.idDepartment),
            items: items?.departments ?? [],
            itemLabel: (d) => d.name,
            onChanged: (v) => setState(() => f.idDepartment = v?.id),
            label: 'Department',
            clearable: true,
          ),
          const SizedBox(height: 16),
          CustomSearchableDropdown<PosDropdown>(
            key: ValueKey('pos_${f.idPosition}_${items?.positions.length ?? 0}'),
            value: _findPos(f.idPosition),
            items: items?.positions ?? [],
            itemLabel: (p) => p.name,
            onChanged: (v) => setState(() => f.idPosition = v?.id),
            label: 'Position',
            clearable: true,
          ),
          const SizedBox(height: 16),
          CustomSearchableDropdown<EmpStatusDropdown>(
            key: ValueKey('status_${f.idEmployeeStatus}_${items?.employeeStatuses.length ?? 0}'),
            value: _findStatus(f.idEmployeeStatus),
            items: items?.employeeStatuses ?? [],
            itemLabel: (s) => s.name,
            onChanged: (v) => setState(() => f.idEmployeeStatus = v?.id),
            label: 'Employee Status',
            clearable: true,
          ),
          const SizedBox(height: 16),
          CustomSearchableDropdown<ManagerDropdown>(
            key: ValueKey('mgr_${f.idManager}_${items?.managers.length ?? 0}'),
            value: _findManager(f.idManager),
            items: items?.managers ?? [],
            itemLabel: (m) => m.name,
            onChanged: (v) => setState(() => f.idManager = v?.id),
            label: 'Manager',
            clearable: true,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFinance() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Bank Account',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorTextPrimary,
            ),
          ),
          const SizedBox(height: 10),
          CustomFormInput(controller: _bankNameCtrl, label: 'Bank Name', hintText: 'e.g. BCA, Mandiri'),
          const SizedBox(height: 10),
          CustomFormInput(
            controller: _bankAccCtrl,
            label: 'Account Number',
            hintText: 'Enter account number',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          CustomFormInput(
            controller: _bankHolderCtrl,
            label: 'Account Holder',
            hintText: 'Enter account holder name',
          ),
          const SizedBox(height: 16),
          Text(
            'Salary',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorTextPrimary,
            ),
          ),
          const SizedBox(height: 10),
          CustomFormInput(
            controller: _salaryCtrl,
            label: 'Basic Salary',
            hintText: '0',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          CustomFormInput(
            controller: _allowanceCtrl,
            label: 'Allowance',
            hintText: '0',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}