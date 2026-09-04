import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/core/injector/injector.dart';

import 'package:erp_mobile_cnplus/features/hr/my_payslip/data/models/my_payslip_models.dart';
import 'package:erp_mobile_cnplus/features/hr/my_payslip/presentation/controllers/my_payslip_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/my_payslip/presentation/screens/my_payslip_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/my_payslip/presentation/widgets/my_payslip_filter_sheet.dart';

class MyPaySlipListScreen extends StatefulWidget {
  const MyPaySlipListScreen({
    super.key,
  });

  @override
  State<MyPaySlipListScreen> createState() => _MyPaySlipListScreenState();
}

class _MyPaySlipListScreenState extends State<MyPaySlipListScreen> {
  late MyPaySlipController _controller;

  final TextEditingController _searchController = TextEditingController();

  static const Color _themeColor = Color(0xFF2D6A4F);

  @override
  void initState() {
    super.initState();

    _controller = getIt<MyPaySlipController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    _controller.clearSearch();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyPaySlipController>.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Payslip',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 20,
                ),
              ),
              Text(
                'Your monthly payslip history',
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          elevation: 0.5,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          actions: [
            Consumer<MyPaySlipController>(
              builder: (context, controller, _) {
                return IconButton(
                  tooltip: 'Filter',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: colorWhite,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (sheetContext) {
                        return ChangeNotifierProvider.value(
                          value: controller,
                          child: const MyPaySlipFilterSheet(),
                        );
                      },
                    );
                  },
                  icon: Stack(
                    children: [
                      const Icon(Icons.filter_list_outlined),
                      if (controller.hasActiveFilter)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: Consumer<MyPaySlipController>(
          builder: (context, controller, _) {
            if (controller.isLoading && !controller.hasFetchedOnce) {
              return const Center(
                child: CircularProgressIndicator(
                  color: _themeColor,
                ),
              );
            }

            if (controller.status == MyPaySlipStatus.error) {
              return _buildError(controller);
            }

            return Column(
              children: [
                _buildSearch(),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.refresh,
                    color: _themeColor,
                    child: _buildBody(controller),
                  ),
                ),

                _buildPagination(controller),
              ],
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearch() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          _controller.searchList(value);
          setState(() {});
        },
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: 'Search payslip period...',
          hintStyle: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.grey,
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                    size: 18,
                  ),
                  onPressed: _clearSearch,
                )
              : null,
          filled: true,
          fillColor: Colors.grey.shade100,
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
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: _themeColor,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BODY (info bar + list)
  // ============================================================

  Widget _buildBody(MyPaySlipController controller) {
    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: _themeColor,
        ),
      );
    }

    if (controller.items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _buildEmptyState(
            isSearching: _searchController.text.isNotEmpty,
            onClearSearch: _clearSearch,
          ),
        ],
      );
    }

    final pagination = controller.pagination;

    return Column(
      children: [
        if (pagination != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${pagination.total} payslip',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  'Page ${pagination.currentPage} of ${pagination.lastPage}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final item = controller.items[index];
              return _buildPayslipCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPayslipCard(MyPaySlipModel item) {
    final isPaid = item.status.toLowerCase() == 'paid';

    final statusColor = isPaid ? Colors.green : Colors.blue;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MyPaySlipDetailScreen(
                encryption: item.encryption,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _themeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: _themeColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.periodName,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.dateRange,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.status,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.takeHomePayDisplay,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _themeColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
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
        padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching
                  ? Icons.search_off
                  : Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              isSearching ? 'Payslip not found' : 'No payslip found',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSearching) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onClearSearch,
                icon: const Icon(
                  Icons.close,
                  size: 16,
                  color: _themeColor,
                ),
                label: Text(
                  'Clear search',
                  style: GoogleFonts.poppins(
                    color: _themeColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PAGINATION
  // ============================================================

  Widget _buildPagination(MyPaySlipController controller) {
    final pagination = controller.pagination;

    if (pagination == null || pagination.lastPage <= 1) {
      return const SizedBox.shrink();
    }

    final hasPrev = pagination.currentPage > 1;
    final hasNext = pagination.currentPage < pagination.lastPage;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: hasPrev ? controller.previousPage : null,
            icon: const Icon(Icons.chevron_left),
            color: _themeColor,
          ),
          Text(
            'Page ${pagination.currentPage} of ${pagination.lastPage}',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          IconButton(
            onPressed: hasNext ? controller.nextPage : null,
            icon: const Icon(Icons.chevron_right),
            color: _themeColor,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FILTER
  // ============================================================

  Future<void> _showFilterSheet(MyPaySlipController controller) async {
    String? tempStatus = controller.selectedStatus;

    int? tempYear = controller.selectedYear;

    final currentYear = DateTime.now().year;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Filter Payslip',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: tempStatus,
                    decoration: InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Approved',
                        child: Text('Approved'),
                      ),
                      DropdownMenuItem(
                        value: 'Paid',
                        child: Text('Paid'),
                      ),
                    ],
                    onChanged: (value) {
                      setModalState(() {
                        tempStatus = value;
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<int>(
                    value: tempYear,
                    decoration: InputDecoration(
                      labelText: 'Year',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: List.generate(6, (index) {
                      final year = currentYear - index;

                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }),
                    onChanged: (value) {
                      setModalState(() {
                        tempYear = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            controller.setStatus(null);
                            controller.setYear(null);
                            controller.applyFilter();
                            Navigator.pop(context);
                          },
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.setStatus(tempStatus);
                            controller.setYear(tempYear);
                            controller.applyFilter();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _themeColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError(MyPaySlipController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 56,
            ),
            const SizedBox(height: 12),
            Text(
              controller.errorMessage ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                controller.fetchList();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _themeColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}