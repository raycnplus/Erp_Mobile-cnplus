import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/routes/app_routes.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/pos/store/data/models/store_models.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/widgets/pos_pin_dialog.dart';
import 'package:erp_mobile_cnplus/features/pos/store/presentation/controllers/store_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/store/presentation/widgets/store_list_item.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/screens/pos_transaction_screen.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';

class PosStoreSelectScreen extends StatefulWidget {
  const PosStoreSelectScreen({super.key});

  @override
  State<PosStoreSelectScreen> createState() => _PosStoreSelectScreenState();
}

class _PosStoreSelectScreenState extends State<PosStoreSelectScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<StoreController>().fetchList(),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _openTransaction(StoreModel store) async {
    final ctrl = context.read<StoreController>();

    if (ctrl.posRequirePin) {
      final ok = await showPosPinDialog(
        context,
        storeName: store.storeName,
        onVerify: (pin) async {
          final r = await ctrl.doVerifyPin(store.encryption, pin);
          if (r['success'] == true) return null; // PIN benar
          return r['message']?.toString() ?? 'PIN salah';
        },
      );
      if (!ok || !mounted) return;
    }

    await Navigator.pushNamed(
      context,
      AppRoutes.posTransaction,
      arguments: PosTransactionArgs(
        idStore: store.idStore,
        storeName: store.storeName,
      ),
    );

    if (mounted) context.read<StoreController>().fetchList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Toko',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: colorTextPrimary,
                fontSize: 20,
              ),
            ),
            Text(
              'Pilih toko untuk memulai transaksi',
              style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 12),
            ),
          ],
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Column(
        children: [
          Container(
            color: colorCard,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) {
                setState(() {});
                context.read<StoreController>().search(v);
              },
              decoration: InputDecoration(
                hintText: 'Search store...',
                hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
                prefixIcon: const Icon(Icons.search, color: colorGrey, size: 20),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: colorGrey, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() {});
                          context.read<StoreController>().clearSearch();
                        },
                      )
                    : null,
                filled: true,
                fillColor: colorBackground,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: colorGreyLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: colorPrimary, width: 1.5),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<StoreController>(
              builder: (_, ctrl, __) {
                if (ctrl.isLoadingList) {
                  return const Center(
                    child: CircularProgressIndicator(color: colorPrimary),
                  );
                }

                if (ctrl.listError != null && ctrl.pageItems.isEmpty) {
                  return _buildMessage(
                    icon: Icons.error_outline,
                    color: colorError,
                    text: ctrl.listError!,
                    actionLabel: 'Try Again',
                    onAction: () => ctrl.fetchList(),
                  );
                }

                if (ctrl.pageItems.isEmpty) {
                  return _buildMessage(
                    icon: _searchCtrl.text.isNotEmpty
                        ? Icons.search_off
                        : Icons.store_outlined,
                    color: colorGrey,
                    text: _searchCtrl.text.isNotEmpty
                        ? 'Store not found'
                        : 'Belum ada toko',
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: ctrl.fetchList,
                        color: colorPrimary,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                          itemCount: ctrl.pageItems.length,
                          itemBuilder: (_, i) {
                            final store = ctrl.pageItems[i];
                            return StoreListItem(
                              store: store,
                              onTap: () {
                                if (store.idStore == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Terjadi kesalahan')),
                                  );
                                  return;
                                }
                                _openTransaction(store);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    PaginationBottomBar(
                      currentPage: ctrl.currentPage,
                      lastPage: ctrl.lastPage,
                      hasPrev: ctrl.hasPrev,
                      hasNext: ctrl.hasNext,
                      onGoToPage: ctrl.goToPage,
                      onPrev: ctrl.prevPage,
                      onNext: ctrl.nextPage,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage({
    required IconData icon,
    required Color color,
    required String text,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: color),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: color),
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  foregroundColor: colorWhite,
                ),
                child: Text(actionLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}