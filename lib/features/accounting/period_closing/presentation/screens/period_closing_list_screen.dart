import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/period_closing/presentation/controllers/period_closing_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/period_closing/presentation/widgets/period_closing_list_item.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';
import 'period_closing_detail_screen.dart';
import 'period_closing_form_screen.dart';

class PeriodClosingListScreen extends StatefulWidget {
  const PeriodClosingListScreen({super.key});

  @override
  State<PeriodClosingListScreen> createState() => _PeriodClosingListScreenState();
}

class _PeriodClosingListScreenState extends State<PeriodClosingListScreen> {
  String? _selectedStatus;
  String? _selectedType;

  static const _statuses = ['DRAFT', 'POSTING'];
  static const _types = ['MONTHLY', 'YEARLY'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<PeriodClosingController>().fetchList(),
    );
  }

  Future<void> _applyFilter() {
    return context.read<PeriodClosingController>().fetchList(
          status: _selectedStatus,
          type: _selectedType,
        );
  }

  void _goToForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PeriodClosingFormScreen()),
    ).then((_) => _applyFilter());
  }

  bool get _hasActiveFilter => _selectedStatus != null || _selectedType != null;

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
              'Period Closing',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: colorTextPrimary,
                fontSize: 20,
              ),
            ),
            Text(
              'Accounting period closing',
              style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 12),
            ),
          ],
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        actions: [
          PopupMenuButton<String>(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.filter_list, size: 20),
                if (_hasActiveFilter) ...[
                  const SizedBox(width: 2),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: colorPrimary, shape: BoxShape.circle),
                  ),
                ],
              ],
            ),
            onSelected: (v) {
              if (v == 'clear') {
                setState(() {
                  _selectedStatus = null;
                  _selectedType = null;
                });
              } else if (v.startsWith('status:')) {
                setState(() => _selectedStatus = v.substring(7).isEmpty ? null : v.substring(7));
              } else if (v.startsWith('type:')) {
                setState(() => _selectedType = v.substring(5).isEmpty ? null : v.substring(5));
              }
              _applyFilter();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(enabled: false, child: Text('Status')),
              const PopupMenuItem(value: 'status:', child: Text('  All Status')),
              ..._statuses.map((s) => PopupMenuItem(value: 'status:$s', child: Text('  $s'))),
              const PopupMenuDivider(),
              const PopupMenuItem(enabled: false, child: Text('Type')),
              const PopupMenuItem(value: 'type:', child: Text('  All Types')),
              ..._types.map((t) => PopupMenuItem(value: 'type:$t', child: Text('  $t'))),
              if (_hasActiveFilter) ...[
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'clear',
                  child: Text('Clear Filters', style: TextStyle(color: colorError)),
                ),
              ],
            ],
          ),
        ],
      ),
      body: Consumer<PeriodClosingController>(
        builder: (_, ctrl, __) {
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

          if (ctrl.listError != null && ctrl.items.isEmpty) {
            return _buildErrorState(ctrl);
          }

          if (ctrl.items.isEmpty) {
            return Column(
              children: [
                Expanded(child: _buildEmptyState(_hasActiveFilter)),
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
                      '${ctrl.total} period closings',
                      style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                    ),
                    Text(
                      'Pages ${ctrl.currentPage} of ${ctrl.lastPage}',
                      style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _applyFilter,
                  color: colorPrimary,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    itemCount: ctrl.items.length,
                    itemBuilder: (_, i) => PeriodClosingListItem(
                      item: ctrl.items[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PeriodClosingDetailScreen(
                            encryption: ctrl.items[i].encryption,
                          ),
                        ),
                      ).then((_) => _applyFilter()),
                    ),
                  ),
                ),
              ),
              bar,
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorState(PeriodClosingController ctrl) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: colorError),
            const SizedBox(height: 16),
            Text(
              ctrl.listError!,
              style: GoogleFonts.poppins(color: colorError),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _applyFilter,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                foregroundColor: colorWhite,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isFiltering) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isFiltering ? Icons.filter_alt_off_outlined : Icons.event_repeat_outlined,
            size: 80,
            color: colorGrey,
          ),
          const SizedBox(height: 16),
          Text(
            isFiltering ? 'No period closing matches the filter' : 'No period closings yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: colorTextSubtle,
            ),
            textAlign: TextAlign.center,
          ),
          if (isFiltering) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedStatus = null;
                  _selectedType = null;
                });
                _applyFilter();
              },
              icon: const Icon(Icons.close, size: 16, color: colorPrimary),
              label: Text('Clear filter',
                  style: GoogleFonts.poppins(color: colorPrimary, fontSize: 14)),
            ),
          ],
        ],
      ),
    );
  }
}