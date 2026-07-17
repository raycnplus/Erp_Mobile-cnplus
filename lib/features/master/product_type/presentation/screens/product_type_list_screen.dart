import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/presentation/controllers/product_type_controller.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/presentation/widgets/product_type_list_item.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'product_type_form_screen.dart';
import 'product_type_detail_screen.dart';

class ProductTypeListScreen extends StatefulWidget {
  const ProductTypeListScreen({super.key});

  @override
  State<ProductTypeListScreen> createState() => _ProductTypeListScreenState();
}

class _ProductTypeListScreenState extends State<ProductTypeListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductTypeController>().fetchTypeList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String v) =>
      context.read<ProductTypeController>().searchTypes(v);

  void _clearSearch() {
    _searchController.clear();
    context.read<ProductTypeController>().clearSearch();
  }

  Future<void> _handleRefresh() =>
      context.read<ProductTypeController>().fetchTypeList();

  void _navigateToCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProductTypeFormScreen()),
    );
    if (result == true && mounted) {
      _showSnackbar('Product type created successfully', colorSuccess);
    }
  }

  void _navigateToDetail(String encryption) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductTypeDetailScreen(encryption: encryption),
      ),
    );
  }

  void _showSnackbar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Product Types",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: colorTextPrimary,
                    fontSize: 20)),
            Text('Manage product types',
                style: GoogleFonts.poppins(
                    color: colorTextSubtle, fontSize: 12)),
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
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: GoogleFonts.poppins(fontSize: 14, color: colorTextPrimary),
              decoration: InputDecoration(
                hintText: 'Cari nama type...',
                hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
                prefixIcon: const Icon(Icons.search, color: colorGrey, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: colorGrey, size: 18),
                        onPressed: _clearSearch)
                    : null,
                filled: true,
                fillColor: colorBackground,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: colorGreyLight, width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: colorPrimary, width: 1.5)),
              ),
            ),
          ),
          Expanded(
            child: Consumer<ProductTypeController>(
              builder: (context, controller, child) {
                if (controller.isLoadingList) {
                  return const Center(
                      child: CircularProgressIndicator(color: colorPrimary));
                }
                if (controller.listError != null &&
                    controller.typeList.isEmpty) {
                  return _buildErrorState(controller.listError!, _handleRefresh);
                }
                if (controller.typeList.isEmpty) {
                  return _buildEmptyState(
                      isSearching: _searchController.text.isNotEmpty);
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${controller.total} type ditemukan',
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: colorTextSubtle)),
                          Text(
                              'Hal ${controller.currentPage} dari ${controller.lastPage}',
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: colorTextSubtle)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _handleRefresh,
                        color: colorPrimary,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          itemCount: controller.typeList.length,
                          itemBuilder: (context, index) {
                            final t = controller.typeList[index];
                            return ProductTypeListItem(
                              productType: t,
                              onTap: () => _navigateToDetail(t.encryption),
                            );
                          },
                        ),
                      ),
                    ),
                    _buildBottomBar(context, controller),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, ProductTypeController controller) {
    final current = controller.currentPage;
    final last = controller.lastPage;
    final sw = MediaQuery.of(context).size.width;
    final maxBtn = ((sw - 32 - (4 * 36) - 90) / 36).floor().clamp(1, 5);
    int start = (current - (maxBtn ~/ 2)).clamp(1, last);
    int end = (start + maxBtn - 1).clamp(1, last);
    if (end - start < maxBtn - 1) start = (end - maxBtn + 1).clamp(1, last);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorCard,
        border: const Border(top: BorderSide(color: colorGreyLight)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05),
              blurRadius: 4, offset: const Offset(0, -2))
        ],
      ),
      child: Row(
        children: [
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PgBtn(icon: Icons.first_page,
                      onTap: current > 1 ? () => controller.goToPage(1) : null),
                  const SizedBox(width: 4),
                  _PgBtn(icon: Icons.chevron_left,
                      onTap: controller.hasPrevPage ? controller.prevPage : null),
                  const SizedBox(width: 4),
                  for (int p = start; p <= end; p++) ...[
                    _PgNumBtn(page: p, isActive: p == current,
                        onTap: () => controller.goToPage(p)),
                    const SizedBox(width: 4),
                  ],
                  _PgBtn(icon: Icons.chevron_right,
                      onTap: controller.hasNextPage ? controller.nextPage : null),
                  const SizedBox(width: 4),
                  _PgBtn(icon: Icons.last_page,
                      onTap: current < last ? () => controller.goToPage(last) : null),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: _navigateToCreate,
            icon: const Icon(Icons.add, size: 18, color: colorWhite),
            label: Text('Tambah',
                style: GoogleFonts.poppins(
                    fontSize: 13, fontWeight: FontWeight.w600, color: colorWhite)),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, VoidCallback onRetry) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: colorError),
              const SizedBox(height: 16),
              Text(error,
                  style: GoogleFonts.poppins(color: colorError),
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimary, foregroundColor: colorWhite),
                child: const Text("Try Again"),
              ),
            ],
          ),
        ),
      );

  Widget _buildEmptyState({bool isSearching = false}) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isSearching ? Icons.search_off : Icons.category_outlined,
                  size: 80, color: colorGrey),
              const SizedBox(height: 16),
              Text(
                isSearching ? 'Type tidak ditemukan' : 'No product types yet',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w500, color: colorTextSubtle),
                textAlign: TextAlign.center,
              ),
              if (isSearching) ...[
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: _clearSearch,
                  icon: const Icon(Icons.close, size: 16, color: colorPrimary),
                  label: Text('Hapus pencarian',
                      style: GoogleFonts.poppins(color: colorPrimary, fontSize: 14)),
                ),
              ] else ...[
                const SizedBox(height: 8),
                Text('Tap + button to add your first type',
                    style: GoogleFonts.poppins(fontSize: 14, color: colorGreyDark)),
              ],
            ],
          ),
        ),
      );
}

class _PgBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _PgBtn({required this.icon, this.onTap});
  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: enabled ? colorBackground : colorGreyLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorGreyLight),
        ),
        child: Icon(icon, size: 17, color: enabled ? colorTextPrimary : colorGrey),
      ),
    );
  }
}

class _PgNumBtn extends StatelessWidget {
  final int page;
  final bool isActive;
  final VoidCallback onTap;
  const _PgNumBtn({required this.page, required this.isActive, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isActive ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: isActive ? colorPrimary : colorBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isActive ? colorPrimary : colorGreyLight),
        ),
        child: Center(
          child: Text('$page',
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive ? colorWhite : colorTextPrimary)),
        ),
      ),
    );
  }
}