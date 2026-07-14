import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/presentation/controllers/national_holiday_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/presentation/widgets/national_holiday_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'national_holiday_form_screen.dart';

class NationalHolidayDetailScreen extends StatefulWidget {
  final String encryption;

  const NationalHolidayDetailScreen({super.key, required this.encryption});

  @override
  State<NationalHolidayDetailScreen> createState() => _NationalHolidayDetailScreenState();
}

class _NationalHolidayDetailScreenState extends State<NationalHolidayDetailScreen> {
  late String _enc;

  @override
  void initState() {
    super.initState();
    _enc = widget.encryption;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<NationalHolidayController>().fetchDetail(_enc),
    );
  }

  Future<void> _handleDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Holiday', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Are you sure?', style: GoogleFonts.poppins()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: GoogleFonts.poppins(color: colorGreyDark)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorError,
              foregroundColor: colorWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Delete', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;

    final ctrl = context.read<NationalHolidayController>();
    final success = await ctrl.remove(_enc);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success ? 'Holiday deleted' : ctrl.formError ?? 'Failed to delete'),
      backgroundColor: success ? colorSuccess : colorError,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));

    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text(
          'Holiday Details',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NationalHolidayFormScreen(encryption: _enc)),
            ).then((_) {
              if (!mounted) return;
              final ctrl = context.read<NationalHolidayController>();
              final newEnc = ctrl.updatedEncryption;
              if (newEnc != null && newEnc != _enc) {
                setState(() => _enc = newEnc);
              } else {
                ctrl.fetchDetail(_enc);
              }
            }),
          ),
          IconButton(icon: const Icon(Icons.delete), onPressed: _handleDelete),
        ],
      ),
      body: Consumer<NationalHolidayController>(
        builder: (_, ctrl, __) {
          if (ctrl.isLoadingDetail) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
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
            return Center(child: Text('No data', style: GoogleFonts.poppins(color: colorGrey)));
          }
          return NationalHolidayDetailTabs(detail: ctrl.detail!);
        },
      ),
    );
  }
}