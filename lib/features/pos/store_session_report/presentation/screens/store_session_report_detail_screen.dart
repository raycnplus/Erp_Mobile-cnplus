import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/controllers/store_session_report_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/widgets/store_session_info_tab.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/widgets/store_session_transactions_tab.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/widgets/store_session_cash_movements_tab.dart';

class StoreSessionReportDetailScreen extends StatefulWidget {
  final String encryption;

  const StoreSessionReportDetailScreen({super.key, required this.encryption});

  @override
  State<StoreSessionReportDetailScreen> createState() => _StoreSessionReportDetailScreenState();
}

class _StoreSessionReportDetailScreenState extends State<StoreSessionReportDetailScreen> {
  late final StoreSessionReportController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = context.read<StoreSessionReportController>();
    _ctrl.prepareSession(widget.encryption);
    _ctrl.addListener(_onCtrlChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.fetchFormOptions();
      _ctrl.loadSession();
    });
  }

  void _onCtrlChanged() {
    if (!mounted) return;
    if (!(ModalRoute.of(context)?.isCurrent ?? false)) return;
    final msg = _ctrl.consumeStatusMessage();
    if (msg != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onCtrlChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: colorBackground,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Consumer<StoreSessionReportController>(
            builder: (context, ctrl, child) => Text(
              ctrl.detail?.idSessionLabel ?? 'Session Detail',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: colorTextPrimary,
                fontSize: 18,
              ),
            ),
          ),
          elevation: 0.5,
          backgroundColor: colorWhite,
          foregroundColor: colorTextPrimary,
          actions: [
            Consumer<StoreSessionReportController>(
              builder: (context, ctrl, child) {
                if (ctrl.isExporting) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: colorPrimary),
                    ),
                  );
                }
                return IconButton(
                  tooltip: 'Export Excel',
                  icon: const Icon(Icons.file_download_outlined),
                  onPressed: ctrl.canExportSession ? ctrl.exportSession : null,
                );
              },
            ),
          ],
          bottom: TabBar(
            labelColor: colorPrimary,
            unselectedLabelColor: colorTextSubtle,
            indicatorColor: colorPrimary,
            labelStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
            unselectedLabelStyle: GoogleFonts.poppins(fontSize: 13),
            tabs: const [
              Tab(text: 'Info'),
              Tab(text: 'Transactions'),
              Tab(text: 'Cash Movements'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            StoreSessionInfoTab(),
            StoreSessionTransactionsTab(),
            StoreSessionCashMovementsTab(),
          ],
        ),
      ),
    );
  }
}