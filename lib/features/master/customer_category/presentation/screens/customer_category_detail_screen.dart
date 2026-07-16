import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/presentation/controllers/customer_category_controller.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/presentation/widgets/customer_category_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'customer_category_form_screen.dart';

class CustomerCategoryDetailScreen extends StatefulWidget {
  final String encryption;
  const CustomerCategoryDetailScreen({super.key, required this.encryption});

  @override
  State<CustomerCategoryDetailScreen> createState() =>
      _CustomerCategoryDetailScreenState();
}

class _CustomerCategoryDetailScreenState
    extends State<CustomerCategoryDetailScreen> {
  late String _activeEncryption;

  @override
  void initState() {
    super.initState();
    _activeEncryption = widget.encryption;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<CustomerCategoryController>()
          .fetchCategoryDetail(_activeEncryption);
    });
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Category',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete this category?',
            style: GoogleFonts.poppins()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: colorGreyDark)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorError,
              foregroundColor: colorWhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Delete', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final controller = context.read<CustomerCategoryController>();
      final success = await controller.removeCategory(_activeEncryption);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(success
            ? 'Customer category deleted successfully'
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
        builder: (_) =>
            CustomerCategoryFormScreen(encryption: _activeEncryption),
      ),
    ).then((_) {
      if (!mounted) return;
      final controller = context.read<CustomerCategoryController>();
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
        title: Text("Customer Category Details",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, color: colorTextPrimary)),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _navigateToEdit),
          IconButton(
              icon: const Icon(Icons.delete), onPressed: _handleDelete),
        ],
      ),
      body: Consumer<CustomerCategoryController>(
        builder: (context, controller, child) {
          if (controller.isLoadingDetail) {
            return const Center(
                child: CircularProgressIndicator(color: colorPrimary));
          }
          if (controller.detailError != null) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.error_outline, size: 64, color: colorError),
                const SizedBox(height: 16),
                Text(controller.detailError!,
                    style: GoogleFonts.poppins(color: colorError),
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      controller.fetchCategoryDetail(_activeEncryption),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary, foregroundColor: colorWhite),
                  child: const Text("Try Again"),
                ),
              ]),
            );
          }
          if (controller.categoryDetail == null) {
            return Center(
                child: Text("No data available",
                    style: GoogleFonts.poppins(color: colorGrey)));
          }
          return CustomerCategoryDetailTabs(
              categoryDetail: controller.categoryDetail!);
        },
      ),
    );
  }
}