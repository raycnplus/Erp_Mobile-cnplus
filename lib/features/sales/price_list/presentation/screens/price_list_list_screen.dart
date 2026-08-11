import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/presentation/controllers/price_list_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/presentation/widgets/price_list_list_item.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';
import 'price_list_detail_screen.dart';
import 'price_list_form_screen.dart';

class PriceListListScreen extends StatefulWidget {
  const PriceListListScreen({super.key});

  @override
  State<PriceListListScreen> createState() => _PriceListListScreenState();
}

class _PriceListListScreenState extends State<PriceListListScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PriceListController>().fetchList();
      context.read<PriceListController>().fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _goToForm() => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PriceListFormScreen()),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Price List",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary, fontSize: 20),
          ),
          Text(
            'Manage price lists',
            style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 12),
          ),
        ]),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Column(children: [
        Container(
          color: colorCard,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: TextField(
            controller: _searchCtrl,
            onChanged: (v) => context.read<PriceListController>().search(v),
            decoration: InputDecoration(
              hintText: 'Search price list...',
              hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
              prefixIcon: const Icon(Icons.search, color: colorGrey, size: 20),
              suffixIcon: _searchCtrl.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, color: colorGrey, size: 18),
                      onPressed: () {
                        _searchCtrl.clear();
                        context.read<PriceListController>().clearSearch();
                      },
                    )
                  : null,
              filled: true,
              fillColor: colorBackground,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: colorGreyLight, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: colorPrimary, width: 1.5),
              ),
            ),
          ),
        ),
        Expanded(
          child: Consumer<PriceListController>(builder: (_, ctrl, __) {
            final bar = PaginationBottomBar(
              currentPage: ctrl.currentPage,
              lastPage: ctrl.lastPage,
              hasPrev: ctrl.hasPrev,
              hasNext: ctrl.hasNext,
              onGoToPage: ctrl.goToPage,
              onPrev: ctrl.prevPage,
              onNext: ctrl.nextPage,
              onCreateTap: _goToForm,
            );

            if (ctrl.isLoadingList) {
              return const Center(child: CircularProgressIndicator(color: colorPrimary));
            }

            if (ctrl.listError != null && ctrl.pageItems.isEmpty) {
              return _buildErrorState(ctrl.listError!, () => ctrl.fetchList());
            }

            if (ctrl.pageItems.isEmpty) {
              return Column(
                children: [
                  Expanded(child: _buildEmptyState(_searchCtrl.text.isNotEmpty)),
                  bar,
                ],
              );
            }

            return Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('${ctrl.total} price lists',
                      style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
                  Text('Pages ${ctrl.currentPage} of ${ctrl.lastPage}',
                      style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
                ]),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => ctrl.fetchList(),
                  color: colorPrimary,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    itemCount: ctrl.pageItems.length,
                    itemBuilder: (_, i) => PriceListListItem(
                      priceList: ctrl.pageItems[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PriceListDetailScreen(encryption: ctrl.pageItems[i].encryption),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              bar,
            ]);
          }),
        ),
      ]),
    );
  }

  Widget _buildErrorState(String error, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: colorError),
            const SizedBox(height: 16),
            Text(
              error,
              style: GoogleFonts.poppins(color: colorError),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                foregroundColor: colorWhite,
              ),
              child: const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.price_check_outlined,
            size: 80,
            color: colorGrey,
          ),
          const SizedBox(height: 16),
          Text(
            isSearching ? 'Price list not found' : 'No price lists yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: colorTextSubtle,
            ),
          ),
          if (isSearching) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                _searchCtrl.clear();
                context.read<PriceListController>().clearSearch();
              },
              icon: const Icon(Icons.close, size: 16, color: colorPrimary),
              label: Text('Clear search',
                  style: GoogleFonts.poppins(color: colorPrimary, fontSize: 14)),
            ),
          ],
        ],
      ),
    );
  }
}