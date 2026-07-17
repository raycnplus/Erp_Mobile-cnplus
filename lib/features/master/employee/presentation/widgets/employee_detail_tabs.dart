import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/master/employee/data/models/employee_models.dart';
import 'package:erp_mobile_cnplus/features/master/employee/presentation/controllers/employee_controller.dart';

class EmployeeDetailTabs extends StatefulWidget {
  final EmployeeDetailModel detail;
  final VoidCallback? onCreateUserAccount;

  const EmployeeDetailTabs({super.key, required this.detail, this.onCreateUserAccount});

  @override
  State<EmployeeDetailTabs> createState() => _EmployeeDetailTabsState();
}

class _EmployeeDetailTabsState extends State<EmployeeDetailTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  String _fmt(String? d) {
    if (d == null || d.isEmpty) return '-';
    try {
      return DateFormat('d MMMM yyyy').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  String _fmtDt(String? d) {
    if (d == null || d.isEmpty) return '-';
    try {
      return DateFormat('d MMMM yyyy, hh:mm a').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  String _safe(dynamic v) => (v == null || v.toString().isEmpty) ? '-' : v.toString();

  String _currency(double? v) {
    if (v == null || v == 0) return '-';
    return 'Rp ${v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\b)'), (m) => '${m[1]}.')}';
  }

  String _roleNameById(dynamic roleValue) {
    final asInt = int.tryParse(roleValue?.toString() ?? '');
    if (asInt == null) return _safe(roleValue);

    final roles = Provider.of<EmployeeController>(context, listen: false).roles;
    final found = roles.where((r) => r.id == asInt).firstOrNull;
    return found?.name ?? _safe(roleValue);
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.detail.employee;
    return Column(
      children: [
        TabBar(
          controller: _tab,
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          isScrollable: true,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Personal'),
            Tab(text: 'Employment'),
            Tab(text: 'Finance'),
            Tab(text: 'Audit'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _card('Personal Info', Icons.person_outline, {
                      'Full Name': _safe(e.employeeName),
                      'Gender': e.gender == 'M' ? 'Male' : e.gender == 'F' ? 'Female' : '-',
                      'Birth Date': _fmt(e.birthDate),
                      'Phone': _safe(e.phoneNumber),
                      'Email': _safe(e.email),
                      'Address': _safe(e.address),
                    }),
                    const SizedBox(height: 16),
                    _card('Identity Numbers', Icons.badge_outlined, {
                      'KTP Number': _safe(e.ktpNumber),
                      'NPWP Number': _safe(e.npwpNumber),
                      'BPJS Number': _safe(e.bpjsNumber),
                    }),
                    const SizedBox(height: 16),
                    if (widget.detail.hasUserAccount)
                      _card('User Account', Icons.account_circle_outlined, {
                        'Username': _safe(widget.detail.userDetails?.username),
                        'Role': _roleNameById(widget.detail.userDetails?.role),
                      })
                    else
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: colorCard,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.account_circle_outlined, color: colorGrey, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'No user account yet',
                                  style: GoogleFonts.poppins(color: colorGrey, fontSize: 14),
                                ),
                              ),
                              if (widget.onCreateUserAccount != null)
                                ElevatedButton(
                                  onPressed: widget.onCreateUserAccount,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorPrimary,
                                    foregroundColor: colorWhite,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Text(
                                    'Create',
                                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _card('Job Info', Icons.work_outline, {
                  'Department': _safe(e.departmentName),
                  'Position': _safe(e.positionName),
                  'Status': _safe(e.employeeStatusName),
                  'Manager': _safe(e.managerName),
                }),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _card('Bank Account', Icons.account_balance_outlined, {
                      'Bank Name': _safe(e.bankName),
                      'Account Number': _safe(e.bankAccountNumber),
                      'Account Holder': _safe(e.bankAccountHolder),
                    }),
                    const SizedBox(height: 16),
                    _card('Salary', Icons.payments_outlined, {
                      'Basic Salary': _currency(e.basicSalary),
                      'Allowance': _currency(e.allowance),
                    }),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _card('Creation', Icons.add_circle_outline, {
                      'Created By': _safe(widget.detail.createdByName),
                      'Created On': _fmtDt(e.createdDate),
                    }),
                    const SizedBox(height: 16),
                    _card('Last Update', Icons.update_outlined, {
                      'Updated By': _safe(widget.detail.updatedByName),
                      'Updated On': _fmtDt(e.updatedDate),
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _card(String title, IconData icon, Map<String, String> fields) {
    final visible = {
      for (final e in fields.entries)
        if (e.value != '-') e.key: e.value,
    };
    if (visible.isEmpty) return const SizedBox.shrink();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorPrimary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorTextPrimary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...visible.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.key, style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 14)),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Text(
                        e.value,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: colorTextPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}