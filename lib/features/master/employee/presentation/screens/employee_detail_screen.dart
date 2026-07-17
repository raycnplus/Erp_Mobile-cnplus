import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/master/employee/presentation/controllers/employee_controller.dart';
import 'package:erp_mobile_cnplus/features/master/employee/presentation/widgets/employee_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'employee_form_screen.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final String encryption;

  const EmployeeDetailScreen({super.key, required this.encryption});

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  late String _enc;

  @override
  void initState() {
    super.initState();
    _enc = widget.encryption;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<EmployeeController>();
      ctrl.fetchDetail(_enc);
      ctrl.fetchFormDropdownData();
    });
  }

  Future<void> _handleDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Delete Employee',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete this employee?',
          style: GoogleFonts.poppins(),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: colorGreyDark),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorError,
              foregroundColor: colorWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Delete', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      final ctrl = context.read<EmployeeController>();
      final success = await ctrl.remove(_enc);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Employee deleted' : ctrl.formError ?? 'Failed to delete',
          ),
          backgroundColor: success ? colorSuccess : colorError,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      if (success) Navigator.pop(context, true);
    }
  }

  Future<void> _handleCreateUserAccount() async {
    final ctrl = context.read<EmployeeController>();
    if (ctrl.dropdownData == null) {
      await ctrl.fetchFormDropdownData();
      if (!mounted) return;
    }

    final roles = ctrl.roles;
    int? selectedRoleId = roles.isNotEmpty ? roles.first.id : null;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(
            'Create User Account',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select role for this employee:',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: colorTextSubtle,
                ),
              ),
              const SizedBox(height: 12),
              roles.isEmpty
                  ? Text(
                      'No roles available',
                      style: GoogleFonts.poppins(
                        color: colorGrey,
                        fontSize: 14,
                      ),
                    )
                  : DropdownButtonFormField<int>(
                      value: selectedRoleId,
                      decoration: InputDecoration(
                        labelText: 'Role',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      items: roles
                          .map(
                            (r) => DropdownMenuItem<int>(
                              value: r.id,
                              child: Text(
                                r.name,
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setDialogState(() => selectedRoleId = v),
                    ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: colorGreyDark),
              ),
            ),
            ElevatedButton(
              onPressed: selectedRoleId == null
                  ? null
                  : () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                foregroundColor: colorWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Create', style: GoogleFonts.poppins()),
            ),
          ],
        ),
      ),
    );

    if (ok == true && mounted && selectedRoleId != null) {
      final success = await ctrl.makeUserAccount(_enc, selectedRoleId!);
      if (!mounted) return;
      if (success) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(
              'Account Created!',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: colorSuccess,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Username: ${ctrl.createdUsername}',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                Text(
                  'Password: ${ctrl.createdPassword}',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please save these credentials!',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: colorGrey,
                  ),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  foregroundColor: colorWhite,
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ctrl.formError ?? 'Failed to create account'),
            backgroundColor: colorError,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text(
          'Employee Details',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
          ),
        ),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EmployeeFormScreen(encryption: _enc),
              ),
            ).then((_) {
              if (!mounted) return;
              final ctrl = context.read<EmployeeController>();
              final newEnc = ctrl.updatedEncryption;
              if (newEnc != null && newEnc != _enc) {
                setState(() => _enc = newEnc);
              } else {
                ctrl.fetchDetail(_enc);
              }
            }),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: Consumer<EmployeeController>(
        builder: (_, ctrl, __) {
          if (ctrl.isLoadingDetail) {
            return const Center(
              child: CircularProgressIndicator(color: colorPrimary),
            );
          }
          if (ctrl.detailError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: colorError),
                  const SizedBox(height: 16),
                  Text(
                    ctrl.detailError!,
                    style: GoogleFonts.poppins(color: colorError),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ctrl.fetchDetail(_enc),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary,
                      foregroundColor: colorWhite,
                    ),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          if (ctrl.detail == null) {
            return Center(
              child: Text(
                'No data',
                style: GoogleFonts.poppins(color: colorGrey),
              ),
            );
          }
          return Stack(
            children: [
              EmployeeDetailTabs(
                detail: ctrl.detail!,
                onCreateUserAccount: _handleCreateUserAccount,
              ),
              if (ctrl.isSaving)
                Container(
                  color: Colors.black26,
                  child: const Center(
                    child: CircularProgressIndicator(color: colorPrimary),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}