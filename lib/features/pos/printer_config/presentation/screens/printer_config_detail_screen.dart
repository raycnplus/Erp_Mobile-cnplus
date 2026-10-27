import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/pos/printer_config/presentation/controllers/printer_config_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/printer_config/data/models/printer_config_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'printer_config_form_screen.dart';

class PrinterConfigDetailScreen extends StatefulWidget {
  final int id;

  const PrinterConfigDetailScreen({super.key, required this.id});

  @override
  State<PrinterConfigDetailScreen> createState() => _State();
}

class _State extends State<PrinterConfigDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<PrinterConfigController>().fetchDetail(widget.id),
    );
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: success ? colorSuccess : colorError,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  Future<bool?> _confirmDialog(
    String title,
    String content, {
    String confirmLabel = 'Confirm',
    Color? confirmColor,
  }) =>
      showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text(content, style: GoogleFonts.poppins()),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel', style: GoogleFonts.poppins(color: colorGreyDark)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor ?? colorPrimary,
                foregroundColor: colorWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(confirmLabel, style: GoogleFonts.poppins()),
            ),
          ],
        ),
      );

  Future<void> _handleSetDefault(PrinterConfigModel p) async {
    if (p.isDefault) {
      _snack('This printer is already the default');
      return;
    }
    final ctrl = context.read<PrinterConfigController>();
    final ok = await _confirmDialog('Set as Default', 'Set "${p.printerName}" as default printer?', confirmLabel: 'Yes');
    if (ok != true || !mounted) return;

    final success = await ctrl.setDefault(p.id);
    if (!mounted) return;
    _snack(success ? 'Default printer updated' : ctrl.formError ?? 'Failed', success: success);
    if (success) ctrl.fetchDetail(p.id);
  }

  Future<void> _handleDelete(PrinterConfigModel p) async {
    final ctrl = context.read<PrinterConfigController>();
    final ok = await _confirmDialog(
      'Delete Printer',
      'Printer "${p.printerName}" will be permanently deleted.',
      confirmLabel: 'Delete',
      confirmColor: colorError,
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.remove(p.id);
    if (!mounted) return;
    _snack(success ? 'Printer deleted' : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text(
          'Printer Detail',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
        actions: [
          Consumer<PrinterConfigController>(
            builder: (_, ctrl, __) {
              final p = ctrl.detail;
              if (p == null) return const SizedBox();
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PrinterConfigFormScreen(id: p.id)),
                    ).then((_) {
                      if (!mounted) return;
                      ctrl.fetchDetail(widget.id);
                    }),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: colorError),
                    onPressed: () => _handleDelete(p),
                  ),
                  const SizedBox(width: 4),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<PrinterConfigController>(
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
                    onPressed: () => ctrl.fetchDetail(widget.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary,
                      foregroundColor: colorWhite,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (ctrl.detail == null) {
            return Center(child: Text('No data', style: GoogleFonts.poppins(color: colorGrey)));
          }

          final p = ctrl.detail!;
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _infoCard('Printer Info', Icons.print_outlined, [
                            _row('Printer Name', p.printerName),
                            _row('Description', p.description?.isNotEmpty == true ? p.description! : '-'),
                            _rowBadge('Default', p.isDefault),
                          ]),
                        ],
                      ),
                    ),
                  ),
                  _bottomBar([
                    if (!p.isDefault)
                      _outlineBtn('Set as Default', Icons.star_outline, () => _handleSetDefault(p)),
                    _primaryBtn('Edit', Icons.edit_outlined, () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PrinterConfigFormScreen(id: p.id)),
                    ).then((_) {
                      if (!mounted) return;
                      ctrl.fetchDetail(widget.id);
                    })),
                  ]),
                ],
              ),
              if (ctrl.isSaving)
                Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator(color: colorPrimary)),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _bottomBar(List<Widget> children) {
    final expanded = children.map((w) => w is Expanded ? w : Expanded(child: w)).toList();
    final spaced = <Widget>[];
    for (int i = 0; i < expanded.length; i++) {
      spaced.add(expanded[i]);
      if (i < expanded.length - 1) spaced.add(const SizedBox(width: 10));
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: colorCard,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2)),
        ],
      ),
      child: Row(children: spaced),
    );
  }

  Widget _primaryBtn(String label, IconData icon, VoidCallback onTap) => ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 13),
          backgroundColor: colorPrimary,
          foregroundColor: colorWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
      );

  Widget _outlineBtn(String label, IconData icon, VoidCallback onTap) => OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 13),
          foregroundColor: Colors.orange,
          side: const BorderSide(color: Colors.orange),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 130, child: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle))),
            Expanded(
              child: Text(value, style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );

  Widget _rowBadge(String label, bool isTrue) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 130, child: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle))),
            if (isTrue)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: colorPrimary.withOpacity(0.3)),
                ),
                child: Text('Yes', style: GoogleFonts.poppins(fontSize: 11, color: colorPrimary, fontWeight: FontWeight.w600)),
              )
            else
              Text('No', style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary)),
          ],
        ),
      );

  Widget _infoCard(String title, IconData icon, List<Widget> rows) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: colorCard,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: colorPrimary, size: 18),
                  const SizedBox(width: 8),
                  Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: colorTextPrimary)),
                ],
              ),
              const Divider(height: 16),
              ...rows,
            ],
          ),
        ),
      );
}