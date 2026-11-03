import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/routes/app_routes.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/controllers/store_session_report_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/widgets/store_session_report_list_item.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/widgets/store_session_report_filter_sheet.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/widgets/store_session_widgets.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';

class StoreSessionReportListScreen extends StatefulWidget {
  const StoreSessionReportListScreen({super.key});

  @override
  State<StoreSessionReportListScreen> createState() => _StoreSessionReportListScreenState();
}

class _StoreSessionReportListScreenState extends State<StoreSessionReportListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoreSessionReportController>().fetchFormOptions();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String v) {
    setState(() {}); 
    context.read<StoreSessionReportController>().searchList(v);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {});
    context.read<StoreSessionReportController>().clearSearch();
  }

  Future<void> _handleRefresh() => context.read<StoreSessionReportController>().fetchList();

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<StoreSessionReportController>(),
        child: const StoreSessionReportFilterSheet(),
      ),
    );
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
          'Store Session Report',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
            fontSize: 20,
          ),
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        actions: [
          Consumer<StoreSessionReportController>(
            builder: (context, ctrl, child) {
              return Stack(
                children: [
                  IconButton(icon: const Icon(Icons.filter_list), onPressed: _openFilterSheet),
                  if (ctrl.hasActiveFilter)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: colorPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
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
                hintText: 'Search session, store, cashier...',
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

          Expanded(
            child: Consumer<StoreSessionReportController>(
              builder: (context, ctrl, child) {
                final bar = PaginationBottomBar(
                  currentPage: ctrl.currentPage,
                  lastPage: ctrl.lastPage,
                  hasPrev: ctrl.hasPrevPage,
                  hasNext: ctrl.hasNextPage,
                  onGoToPage: ctrl.goToPage,
                  onPrev: ctrl.prevPage,
                  onNext: ctrl.nextPage,
                );

                if (!ctrl.hasFetchedOnce) return _buildInitialPromptState();
                if (ctrl.isLoadingList) {
                  return const Center(child: CircularProgressIndicator(color: colorPrimary));
                }
                if (ctrl.listError != null && ctrl.list.isEmpty) {
                  return SessionErrorState(message: ctrl.listError!, onRetry: _handleRefresh);
                }
                if (ctrl.list.isEmpty) {
                  return Column(
                    children: [
                      const Expanded(
                        child: SessionEmptyState(
                          icon: Icons.point_of_sale_outlined,
                          message: 'No store session found',
                        ),
                      ),
                      bar,
                    ],
                  );
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${ctrl.total} sessions',
                            style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                          ),
                          Text(
                            'Page ${ctrl.currentPage} of ${ctrl.lastPage}',
                            style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _handleRefresh,
                        color: colorPrimary,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          itemCount: ctrl.list.length,
                          itemBuilder: (context, index) {
                            final item = ctrl.list[index];
                            return StoreSessionReportListItem(
                              item: item,
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.posStoreSessionReportDetail,
                                arguments: item.encryption,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    bar,
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialPromptState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search, size: 80, color: colorGrey),
            const SizedBox(height: 16),
            Text(
              'Search or select a filter\nto display data',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: colorTextSubtle,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: _openFilterSheet,
              icon: const Icon(Icons.filter_list, size: 18, color: colorPrimary),
              label: Text(
                'Open Filter',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorPrimary),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: colorPrimary),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}