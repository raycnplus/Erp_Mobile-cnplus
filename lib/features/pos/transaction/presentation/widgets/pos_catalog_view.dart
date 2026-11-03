import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/routes/app_routes.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/controllers/pos_sale_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/widgets/pos_product_card.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/widgets/store_session_widgets.dart';

class PosCatalogView extends StatefulWidget {
  const PosCatalogView({super.key});

  @override
  State<PosCatalogView> createState() => _PosCatalogViewState();
}

class _PosCatalogViewState extends State<PosCatalogView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scroll = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scroll.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
      context.read<PosSaleController>().loadMoreProducts();
    }
  }

  void _onSearchChanged(String v) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) context.read<PosSaleController>().setSearch(v);
    });
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    setState(() {});
    context.read<PosSaleController>().setSearch('');
  }

  Widget _filterChips(PosSaleController sale) {
    Widget chip(String label, bool selected, VoidCallback onTap) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(label),
            selected: selected,
            onSelected: (_) => onTap(),
            selectedColor: colorPrimary.withOpacity(0.15),
            backgroundColor: colorCard,
            side: BorderSide(color: selected ? colorPrimary : colorGreyLight),
            labelStyle: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? colorPrimary : colorTextSubtle,
            ),
          ),
        );

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('In stock'),
              selected: sale.inStockOnly,
              onSelected: sale.setInStockOnly,
              selectedColor: colorPrimary.withOpacity(0.15),
              checkmarkColor: colorPrimary,
              backgroundColor: colorCard,
              side: BorderSide(color: sale.inStockOnly ? colorPrimary : colorGreyLight),
              labelStyle: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: sale.inStockOnly ? colorPrimary : colorTextSubtle,
              ),
            ),
          ),
          chip('All', sale.selectedCategoryId == null, () => sale.selectCategory(null)),
          for (final c in sale.categories)
            chip(c.name, sale.selectedCategoryId == c.idCategory, () => sale.selectCategory(c.idCategory)),
        ],
      ),
    );
  }

  Widget _buildGrid(PosSaleController sale) {
    if (sale.isLoadingProducts && sale.products.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: colorPrimary));
    }
    if (sale.productError != null && sale.products.isEmpty) {
      return SessionErrorState(message: sale.productError!, onRetry: () => sale.loadProducts());
    }
    if (sale.products.isEmpty) {
      return const SessionEmptyState(
        icon: Icons.inventory_2_outlined,
        message: 'No product found',
      );
    }

    final itemCount = sale.products.length + (sale.isLoadingMore ? 1 : 0);

    return RefreshIndicator(
      onRefresh: sale.loadProducts,
      color: colorPrimary,
      child: GridView.builder(
        controller: _scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.72,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index >= sale.products.length) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          final p = sale.products[index];
          return PosProductCard(
            product: p,
            qtyInCart: sale.qtyInCart(p.idProduct),
            onTap: () => sale.addToCart(p), 
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: colorCard,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            style: GoogleFonts.poppins(fontSize: 14, color: colorTextPrimary),
            decoration: InputDecoration(
              hintText: 'Search product name or SKU...',
              hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
              prefixIcon: const Icon(Icons.search, color: colorGrey, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, color: colorGrey, size: 18),
                      onPressed: _clearSearch,
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
        Consumer<PosSaleController>(
          builder: (context, sale, child) => Container(
            color: colorCard,
            padding: const EdgeInsets.only(bottom: 8),
            child: _filterChips(sale),
          ),
        ),
        Expanded(
          child: Consumer<PosSaleController>(
            builder: (context, sale, child) => Column(
              children: [
                if (sale.isLoadingProducts && sale.products.isNotEmpty)
                  const LinearProgressIndicator(minHeight: 2, color: colorPrimary),
                Expanded(child: _buildGrid(sale)),
              ],
            ),
          ),
        ),
        Consumer<PosSaleController>(
          builder: (context, sale, child) {
            if (sale.isCartEmpty) return const SizedBox.shrink();
            return Container(
              decoration: const BoxDecoration(
                color: colorCard,
                boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, -2))],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${sale.cartCount} item(s)',
                              style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                            ),
                            Text(
                              'Rp ${formatPrice(sale.cartTotal)}',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: colorPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.posTransactionCart),
                        icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                        label: Text('View Cart', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorPrimary,
                          foregroundColor: colorWhite,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}