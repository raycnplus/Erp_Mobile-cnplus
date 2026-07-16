import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/master/location/presentation/controllers/location_controller.dart';
import 'package:erp_mobile_cnplus/features/master/location/presentation/widgets/location_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'location_form_screen.dart';

class LocationDetailScreen extends StatefulWidget {
  final String encryption;
  const LocationDetailScreen({super.key, required this.encryption});

  @override
  State<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  late String _activeEncryption;

  @override
  void initState() {
    super.initState();
    _activeEncryption = widget.encryption;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationController>().fetchLocationDetail(_activeEncryption);
    });
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Location',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure? Location with active stock cannot be deleted.',
          style: GoogleFonts.poppins(),
        ),
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
      final controller = context.read<LocationController>();
      final success = await controller.removeLocation(_activeEncryption);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(success
            ? 'Location deleted successfully'
            : controller.formError ?? 'Failed to delete location'),
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
        builder: (context) =>
            LocationFormScreen(encryption: _activeEncryption),
      ),
    ).then((_) {
      if (!mounted) return;
      final controller = context.read<LocationController>();
      final newEncryption = controller.updatedEncryption;
      if (newEncryption != null && newEncryption != _activeEncryption) {
        setState(() => _activeEncryption = newEncryption);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text("Location Details",
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
      body: Consumer<LocationController>(
        builder: (context, controller, child) {
          if (controller.isLoadingDetail) {
            return const Center(
                child: CircularProgressIndicator(color: colorPrimary));
          }
          if (controller.detailError != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
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
                          controller.fetchLocationDetail(_activeEncryption),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: colorPrimary,
                          foregroundColor: colorWhite),
                      child: const Text("Try Again"),
                    ),
                  ],
                ),
              ),
            );
          }
          if (controller.locationDetail == null) {
            return Center(
                child: Text("No data available",
                    style: GoogleFonts.poppins(color: colorGrey)));
          }
          return LocationDetailTabs(locationDetail: controller.locationDetail!);
        },
      ),
    );
  }
}