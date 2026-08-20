import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/inventory/location_report/presentation/controllers/location_report_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/location_report/presentation/widgets/location_report_list_item.dart';
import 'package:erp_mobile_cnplus/features/inventory/location_report/presentation/screens/location_report_detail_screen.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';

class LocationReportListScreen extends StatefulWidget {
  const LocationReportListScreen({super.key});

  @override
  State<LocationReportListScreen> createState() =>
      _LocationReportListScreenState();
}

class _LocationReportListScreenState extends State<LocationReportListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<LocationReportController>();
      ctrl.fetchFormOptions();
      ctrl.fetchReportList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String v) =>
      context.read<LocationReportController>().searchReports(v);

  void _clearSearch() {
    _searchController.clear();
    context.read<LocationReportController>().clearSearch();
  }

  Future<void> _handleRefresh() =>
      context.read<LocationReportController>().fetchReportList();

  void _navigateToDetail(int idLocation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LocationReportDetailScreen(idLocation: idLocation),
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Location Reports",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: colorTextPrimary,
                fontSize: 20,
              ),
            ),
            Text(
              'Stock & traffic overview per location',
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
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: colorTextPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search location or warehouse...',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      color: colorGrey,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: colorGrey,
                      size: 20,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: colorGrey,
                              size: 18,
                            ),
                            onPressed: _clearSearch,
                          )
                        : null,
                    filled: true,
                    fillColor: colorBackground,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: colorGreyLight,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: colorPrimary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Consumer<LocationReportController>(
                  builder: (context, ctrl, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField<int?>(
                        value: ctrl.selectedWarehouseId,
                        isExpanded: true,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: colorTextPrimary,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Filter by warehouse',
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 12,
                            color: colorTextSubtle,
                          ),
                          filled: true,
                          fillColor: colorBackground,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: colorGreyLight,
                              width: 1,
                            ),
                          ),
                        ),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('All Warehouses'),
                          ),
                          ...ctrl.warehouseOptions.map(
                            (w) => DropdownMenuItem<int?>(
                              value: w.idWarehouse,
                              child: Text(w.warehouseName),
                            ),
                          ),
                        ],
                        onChanged: (val) => ctrl.filterByWarehouse(val),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<LocationReportController>(
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

                if (ctrl.isLoadingList) {
                  return const Center(
                    child: CircularProgressIndicator(color: colorPrimary),
                  );
                }
                if (ctrl.listError != null && ctrl.reportList.isEmpty) {
                  return _buildErrorState(ctrl.listError!, _handleRefresh);
                }
                if (ctrl.reportList.isEmpty) {
                  return Column(
                    children: [
                      Expanded(
                        child: _buildEmptyState(
                          isSearching: _searchController.text.isNotEmpty,
                          onClearSearch: _clearSearch,
                        ),
                      ),
                      bar,
                    ],
                  );
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${ctrl.total} locations',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: colorTextSubtle,
                            ),
                          ),
                          Text(
                            'Page ${ctrl.currentPage} of ${ctrl.lastPage}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: colorTextSubtle,
                            ),
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
                          itemCount: ctrl.reportList.length,
                          itemBuilder: (context, index) {
                            final report = ctrl.reportList[index];
                            return LocationReportListItem(
                              report: report,
                              onTap: () => _navigateToDetail(report.idLocation),
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

  Widget _buildEmptyState({
    bool isSearching = false,
    VoidCallback? onClearSearch,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.location_off_outlined,
              size: 80,
              color: colorGrey,
            ),
            const SizedBox(height: 16),
            Text(
              isSearching ? 'Location not found' : 'No location data yet',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: colorTextSubtle,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSearching) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onClearSearch,
                icon: const Icon(Icons.close, size: 16, color: colorPrimary),
                label: Text(
                  'Clear search',
                  style: GoogleFonts.poppins(color: colorPrimary, fontSize: 14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
