import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/presentation/controllers/product_type_controller.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/presentation/widgets/product_type_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'product_type_form_screen.dart';

class ProductTypeDetailScreen extends StatefulWidget {
  final String encryption;
  const ProductTypeDetailScreen({super.key, required this.encryption});

  @override
  State<ProductTypeDetailScreen> createState() => _ProductTypeDetailScreenState();
}

class _ProductTypeDetailScreenState extends State<ProductTypeDetailScreen> {
  late String _activeEncryption;

  @override
  void initState() {
    super.initState();
    _activeEncryption = widget.encryption;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductTypeController>().fetchTypeDetail(_activeEncryption);
    });
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Type',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to delete this product type?',
          style: GoogleFonts.poppins(),
        ),
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

    if (confirmed == true && mounted) {
      final controller = context.read<ProductTypeController>();
      final success = await controller.removeType(_activeEncryption);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(success
            ? 'Product type deleted successfully'
            : controller.formError ?? 'Failed to delete'),
        backgroundColor: success ? colorSuccess : colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));
      if (success) Navigator.pop(context, true);
    }
  }

  void _navigateToEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductTypeFormScreen(encryption: _activeEncryption),
      ),
    ).then((_) {
      if (!mounted) return;
      final controller = context.read<ProductTypeController>();
      final newEnc = controller.updatedEncryption;
      if (newEnc != null && newEnc != _activeEncryption) {
        setState(() => _activeEncryption = newEnc);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text("Type Details",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, color: colorTextPrimary)),
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        elevation: 1,
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _navigateToEdit),
          IconButton(icon: const Icon(Icons.delete), onPressed: _handleDelete),
        ],
      ),
      body: Consumer<ProductTypeController>(
        builder: (context, controller, child) {
          if (controller.isLoadingDetail) {
            return const Center(
                child: CircularProgressIndicator(color: colorPrimary));
          }
          if (controller.detailError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: colorError),
                  const SizedBox(height: 16),
                  Text(controller.detailError!,
                      style: GoogleFonts.poppins(color: colorError),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        controller.fetchTypeDetail(_activeEncryption),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: colorPrimary,
                        foregroundColor: colorWhite),
                    child: const Text("Try Again"),
                  ),
                ],
              ),
            );
          }
          if (controller.typeDetail == null) {
            return Center(
                child: Text("No data available",
                    style: GoogleFonts.poppins(color: colorGrey)));
          }
          return ProductTypeDetailTabs(typeDetail: controller.typeDetail!);
        },
      ),
    );
  }
}