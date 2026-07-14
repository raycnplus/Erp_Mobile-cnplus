import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/presentation/controllers/collective_leave_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/presentation/widgets/collective_leave_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'collective_leave_form_screen.dart';

class CollectiveLeaveDetailScreen extends StatefulWidget {
  final String encryption;

  const CollectiveLeaveDetailScreen({super.key, required this.encryption});

  @override
  State<CollectiveLeaveDetailScreen> createState() =>
      _CollectiveLeaveDetailScreenState();
}

class _CollectiveLeaveDetailScreenState
    extends State<CollectiveLeaveDetailScreen> {
  late String _enc;

  @override
  void initState() {
    super.initState();
    _enc = widget.encryption;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<CollectiveLeaveController>().fetchDetail(_enc),
    );
  }

  Future<void> _handleDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Delete Collective Leave',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text('Are you sure?', style: GoogleFonts.poppins()),
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
      final ctrl = context.read<CollectiveLeaveController>();
      final success = await ctrl.remove(_enc);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Collective leave deleted'
                : ctrl.formError ?? 'Failed to delete',
          ),
          backgroundColor: success ? colorSuccess : colorError,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      if (success) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text(
          'Collective Leave Details',
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
                builder: (_) => CollectiveLeaveFormScreen(encryption: _enc),
              ),
            ).then((_) {
              if (!mounted) return;
              final ctrl = context.read<CollectiveLeaveController>();
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
      body: Consumer<CollectiveLeaveController>(
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
          return CollectiveLeaveDetailTabs(detail: ctrl.detail!);
        },
      ),
    );
  }
}