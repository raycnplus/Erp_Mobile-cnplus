import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/presentation/controllers/asset_movement_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/presentation/widgets/asset_movement_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class AssetMovementDetailScreen extends StatefulWidget {
  final String encryption;

  const AssetMovementDetailScreen({super.key, required this.encryption});

  @override
  State<AssetMovementDetailScreen> createState() => _AssetMovementDetailScreenState();
}

class _AssetMovementDetailScreenState extends State<AssetMovementDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<AssetMovementController>().fetchDetail(widget.encryption));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text('Asset Movement', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary)),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
      ),
      body: Consumer<AssetMovementController>(
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
                    onPressed: () => ctrl.fetchDetail(widget.encryption),
                    style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, foregroundColor: colorWhite),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (ctrl.detail == null) return Center(child: Text('No data', style: GoogleFonts.poppins(color: colorGrey)));

          return AssetMovementDetailTabs(detail: ctrl.detail!);
        },
      ),
    );
  }
}