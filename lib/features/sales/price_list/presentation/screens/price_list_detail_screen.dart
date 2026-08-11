import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/presentation/controllers/price_list_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/presentation/widgets/price_list_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'price_list_form_screen.dart';

class PriceListDetailScreen extends StatefulWidget {
  final String encryption;

  const PriceListDetailScreen({super.key, required this.encryption});

  @override
  State<PriceListDetailScreen> createState() => _PriceListDetailScreenState();
}

class _PriceListDetailScreenState extends State<PriceListDetailScreen> {
  late String _enc;

  @override
  void initState() {
    super.initState();
    _enc = widget.encryption;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<PriceListController>().fetchDetail(_enc),
    );
  }

  Future<void> _handleDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Price List', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('This will also delete all product items. Are you sure?', style: GoogleFonts.poppins()),
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
    if (ok == true && mounted) {
      final ctrl = context.read<PriceListController>();
      final success = await ctrl.remove(_enc);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(success ? 'Price list deleted' : ctrl.formError ?? 'Failed'),
        backgroundColor: success ? colorSuccess : colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));
      if (success) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text(
          "Price List Details",
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
              MaterialPageRoute(builder: (_) => PriceListFormScreen(encryption: _enc)),
            ).then((_) {
              if (!mounted) return;
              final ctrl = context.read<PriceListController>();
              final ne = ctrl.updatedEncryption;
              if (ne != null && ne != _enc) {
                setState(() => _enc = ne);
              } else {
                ctrl.fetchDetail(_enc);
              }
            }),
          ),
          IconButton(icon: const Icon(Icons.delete), onPressed: _handleDelete),
        ],
      ),
      body: Consumer<PriceListController>(builder: (_, ctrl, __) {
        if (ctrl.isLoadingDetail) return const Center(child: CircularProgressIndicator(color: colorPrimary));
        if (ctrl.detailError != null) return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.error_outline, size: 64, color: colorError),
            const SizedBox(height: 16),
            Text(ctrl.detailError!, style: GoogleFonts.poppins(color: colorError), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ctrl.fetchDetail(_enc),
              style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, foregroundColor: colorWhite),
              child: const Text("Try Again"),
            ),
          ]),
        );
        if (ctrl.detail == null) return Center(child: Text("No data", style: GoogleFonts.poppins(color: colorGrey)));
        return PriceListDetailTabs(detail: ctrl.detail!);
      }),
    );
  }
}