import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/presentation/controllers/fixed_asset_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/presentation/widgets/fixed_asset_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'fixed_asset_form_screen.dart';

class FixedAssetDetailScreen extends StatefulWidget {
  final String encryption;

  const FixedAssetDetailScreen({super.key, required this.encryption});

  @override
  State<FixedAssetDetailScreen> createState() => _FixedAssetDetailScreenState();
}

class _FixedAssetDetailScreenState extends State<FixedAssetDetailScreen> {
  late String _enc;

  @override
  void initState() {
    super.initState();
    _enc = widget.encryption;
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<FixedAssetController>().fetchDetail(_enc));
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: success ? colorSuccess : colorError,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  Future<bool?> _confirmDialog(String title, String content, {String confirmLabel = 'Confirm', Color? confirmColor}) =>
      showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text(content, style: GoogleFonts.poppins()),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel', style: GoogleFonts.poppins(color: colorGreyDark))),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: confirmColor ?? colorPrimary, foregroundColor: colorWhite, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: Text(confirmLabel, style: GoogleFonts.poppins()),
            ),
          ],
        ),
      );

  Future<void> _handleDelete() async {
    final ctrl = context.read<FixedAssetController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog('Delete Fixed Asset', 'Delete "${d.assetName}"?', confirmLabel: 'Delete', confirmColor: colorError);
    if (ok != true || !mounted) return;

    final success = await ctrl.remove(d.encryption);
    if (!mounted) return;
    _snack(success ? 'Deleted' : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  void _goEdit() {
    final ctrl = context.read<FixedAssetController>();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FixedAssetFormScreen(encryption: _enc)),
    ).then((_) {
      if (!mounted) return;
      final ne = ctrl.savedEncryption;
      if (ne != null && ne.isNotEmpty && ne != _enc) {
        setState(() => _enc = ne);
      }
      ctrl.fetchDetail(_enc);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text('Fixed Asset', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary)),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
        actions: [
          Consumer<FixedAssetController>(
            builder: (_, ctrl, __) {
              final d = ctrl.detail;
              if (d == null) return const SizedBox();
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (d.canEdit) IconButton(icon: const Icon(Icons.edit_outlined), onPressed: _goEdit),
                  if (d.canDelete) IconButton(icon: const Icon(Icons.delete_outline, color: colorError), onPressed: _handleDelete),
                  const SizedBox(width: 4),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<FixedAssetController>(
        builder: (_, ctrl, __) {
          if (ctrl.isLoadingDetail) return const Center(child: CircularProgressIndicator(color: colorPrimary));
          if (ctrl.detailError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: colorError),
                  const SizedBox(height: 16),
                  Text(ctrl.detailError!, style: GoogleFonts.poppins(color: colorError), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ctrl.fetchDetail(_enc),
                    style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, foregroundColor: colorWhite),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (ctrl.detail == null) return Center(child: Text('No data', style: GoogleFonts.poppins(color: colorGrey)));

          return Stack(
            children: [
              FixedAssetDetailTabs(detail: ctrl.detail!),
              if (ctrl.isSaving)
                Container(color: Colors.black26, child: const Center(child: CircularProgressIndicator(color: colorPrimary))),
            ],
          );
        },
      ),
    );
  }
}