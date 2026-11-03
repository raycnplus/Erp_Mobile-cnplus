import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/routes/app_routes.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/controllers/pos_session_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/controllers/pos_sale_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/widgets/pos_catalog_view.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/widgets/pos_open_session_view.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/widgets/pos_cash_movement_sheet.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/widgets/store_session_widgets.dart';

class PosTransactionArgs {
  final int idStore;
  final String storeName;

  const PosTransactionArgs({required this.idStore, required this.storeName});
}

class PosTransactionScreen extends StatefulWidget {
  final PosTransactionArgs args;

  const PosTransactionScreen({super.key, required this.args});

  @override
  State<PosTransactionScreen> createState() => _PosTransactionScreenState();
}

class _PosTransactionScreenState extends State<PosTransactionScreen> {
  late final PosSessionController _session;
  late final PosSaleController _sale;

  @override
  void initState() {
    super.initState();
    _session = context.read<PosSessionController>();
    _sale = context.read<PosSaleController>();

    _session.setStore(widget.args.idStore, widget.args.storeName);
    _sale.setStore(widget.args.idStore, widget.args.storeName);

    _session.addListener(_onChanged);
    _sale.addListener(_onChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _session.loadCurrent();
      _sale.init();
    });
  }

  void _onChanged() {
    if (!mounted) return;
    if (!(ModalRoute.of(context)?.isCurrent ?? false)) return;

    final messages = [_sale.consumeMessage(), _session.consumeSuccessMessage()].whereType<String>();
    for (final m in messages) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
    }
  }

  @override
  void dispose() {
    _session.removeListener(_onChanged);
    _sale.removeListener(_onChanged);
    super.dispose();
  }

  Future<void> _onMenu(String value) async {
    if (value == 'refresh') {
      _session.loadCurrent();
      _sale.loadProducts();
      return;
    }

    if (value == 'close') {
      final closed = await Navigator.pushNamed(context, AppRoutes.posTransactionCloseSession);
      if (closed == true && mounted) {
        _sale.startNewTransaction();
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.args.storeName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
            fontSize: 18,
          ),
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        actions: [
          Consumer<PosSessionController>(
            builder: (context, ctrl, child) {
              if (!ctrl.hasActiveSession) return const SizedBox.shrink();
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Cash In / Out',
                    icon: const Icon(Icons.swap_vert),
                    onPressed: () => showPosCashMovementSheet(context),
                  ),
                  PopupMenuButton<String>(
                    onSelected: _onMenu,
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'refresh', child: Text('Refresh')),
                      PopupMenuItem(value: 'close', child: Text('Close Session')),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<PosSessionController>(
        builder: (context, ctrl, child) {
          if (!ctrl.hasLoaded) {
            if (ctrl.error != null) {
              return SessionErrorState(
                message: ctrl.error!,
                onRetry: () => ctrl.loadCurrent(),
              );
            }
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          if (!ctrl.hasActiveSession) return const PosOpenSessionView();
          return const PosCatalogView();
        },
      ),
    );
  }
}