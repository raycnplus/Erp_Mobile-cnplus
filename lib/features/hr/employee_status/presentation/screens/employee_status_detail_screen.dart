import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/presentation/controllers/employee_status_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/presentation/widgets/employee_status_detail_tabs.dart';

import 'employee_status_form_screen.dart';

class EmployeeStatusDetailScreen extends StatefulWidget {
  final String encryption;

  const EmployeeStatusDetailScreen({
    super.key,
    required this.encryption,
  });

  @override
  State<EmployeeStatusDetailScreen> createState() =>
      _EmployeeStatusDetailScreenState();
}

class _EmployeeStatusDetailScreenState
    extends State<EmployeeStatusDetailScreen> {
  late String _enc;

  @override
  void initState() {
    super.initState();

    _enc = widget.encryption;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<EmployeeStatusController>()
          .fetchDetail(_enc);
    });
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Delete Employee Status',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: colorGreyDark,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorError,
                foregroundColor: colorWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Delete',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    final controller =
        context.read<EmployeeStatusController>();

    final success = await controller.remove(_enc);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Employee status deleted'
              : controller.formError ??
                    'Failed to delete',
        ),
        backgroundColor:
            success ? colorSuccess : colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    if (success) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _handleEdit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return EmployeeStatusFormScreen(
            encryption: _enc,
          );
        },
      ),
    );

    if (!mounted) {
      return;
    }

    final controller =
        context.read<EmployeeStatusController>();

    final newEncryption =
        controller.updatedEncryption;

    if (newEncryption != null &&
        newEncryption != _enc) {
      setState(() {
        _enc = newEncryption;
      });
    } else {
      controller.fetchDetail(_enc);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
        title: Text(
          'Employee Status Details',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _handleEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: Consumer<EmployeeStatusController>(
        builder: (_, controller, __) {
          if (controller.isLoadingDetail) {
            return const Center(
              child: CircularProgressIndicator(
                color: colorPrimary,
              ),
            );
          }

          if (controller.detailError != null) {
            return Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: colorError,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.detailError!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: colorError,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      controller.fetchDetail(_enc);
                    },
                    style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                              colorPrimary,
                          foregroundColor:
                              colorWhite,
                        ),
                    child: const Text(
                      'Try Again',
                    ),
                  ),
                ],
              ),
            );
          }

          if (controller.detail == null) {
            return Center(
              child: Text(
                'No data',
                style: GoogleFonts.poppins(
                  color: colorGrey,
                ),
              ),
            );
          }

          return EmployeeStatusDetailTabs(
            detail: controller.detail!,
          );
        },
      ),
    );
  }
}