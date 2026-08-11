import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_quota/presentation/controllers/leave_quota_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_quota/data/models/leave_quota_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';
import 'leave_quota_detail_screen.dart';

class LeaveQuotaListScreen extends StatefulWidget {
  const LeaveQuotaListScreen({super.key});

  @override
  State<LeaveQuotaListScreen> createState() => _LeaveQuotaListScreenState();
}

class _LeaveQuotaListScreenState extends State<LeaveQuotaListScreen> {
  final _searchCtrl = TextEditingController();
  String _selectedPeriod = DateTime.now().year.toString();
  String _selectedShowType = 'all';

  List<int> get _years {
    final y = DateTime.now().year;
    return [y + 1, y, y - 1, y - 2];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<LeaveQuotaController>().fetchList(
            period: _selectedPeriod,
          ),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
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
              'Leave Quota',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: colorTextPrimary,
                fontSize: 20,
              ),
            ),
            Text(
              'Employee leave quota overview',
              style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 12),
            ),
          ],
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        actions: [
          Consumer<LeaveQuotaController>(
            builder: (_, ctrl, __) => PopupMenuButton<String>(
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    _selectedPeriod,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              onSelected: (year) {
                setState(() => _selectedPeriod = year);
                ctrl.fetchList(period: year, showType: _selectedShowType);
              },
              itemBuilder: (_) => _years
                  .map((y) => PopupMenuItem(value: '$y', child: Text('$y')))
                  .toList(),
            ),
          ),
          Consumer<LeaveQuotaController>(
            builder: (_, ctrl, __) => PopupMenuButton<String>(
              icon: const Icon(Icons.filter_list, size: 20),
              onSelected: (type) {
                setState(() => _selectedShowType = type);
                ctrl.fetchList(period: _selectedPeriod, showType: type);
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'all', child: Text('All')),
                PopupMenuItem(value: 'available', child: Text('Available')),
                PopupMenuItem(value: 'exhausted', child: Text('Exhausted')),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: colorCard,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) =>
                  context.read<LeaveQuotaController>().search(v),
              decoration: InputDecoration(
                hintText: 'Search employee or leave type...',
                hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
                prefixIcon: const Icon(Icons.search, color: colorGrey, size: 20),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: colorGrey, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          context.read<LeaveQuotaController>().clearSearch();
                        },
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
            child: Consumer<LeaveQuotaController>(
              builder: (_, ctrl, __) {
                final bar = PaginationBottomBar(
                  currentPage: ctrl.currentPage,
                  lastPage: ctrl.lastPage,
                  hasPrev: ctrl.hasPrev,
                  hasNext: ctrl.hasNext,
                  onGoToPage: ctrl.goToPage,
                  onPrev: ctrl.prevPage,
                  onNext: ctrl.nextPage,
                  onCreateTap: () {},
                );

                if (ctrl.isLoadingList) {
                  return const Center(
                    child: CircularProgressIndicator(color: colorPrimary),
                  );
                }
                if (ctrl.listError != null && ctrl.pageItems.isEmpty) {
                  return _error(ctrl);
                }
                if (ctrl.pageItems.isEmpty) {
                  return Column(
                    children: [
                      Expanded(child: _empty(_searchCtrl.text.isNotEmpty)),
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
                            '${ctrl.total} records',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: colorTextSubtle,
                            ),
                          ),
                          Text(
                            'Pages ${ctrl.currentPage} of ${ctrl.lastPage}',
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
                        onRefresh: () => ctrl.fetchList(
                          period: _selectedPeriod,
                          showType: _selectedShowType,
                        ),
                        color: colorPrimary,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          itemCount: ctrl.pageItems.length,
                          itemBuilder: (_, i) => _LeaveQuotaItem(
                            quota: ctrl.pageItems[i],
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LeaveQuotaDetailScreen(
                                  employeeEncryption:
                                      ctrl.pageItems[i].employeeEncryption,
                                  leaveTypeId: ctrl.pageItems[i].idLeaveType,
                                  employeeName:
                                      ctrl.pageItems[i].employeeName,
                                  leaveTypeName:
                                      ctrl.pageItems[i].leaveTypeName,
                                  period: _selectedPeriod,
                                ),
                              ),
                            ),
                          ),
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

  Widget _error(LeaveQuotaController ctrl) {
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
              onPressed: () =>
                  ctrl.fetchList(period: _selectedPeriod, showType: _selectedShowType),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                foregroundColor: colorWhite,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _empty(bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching
                ? Icons.search_off
                : Icons.event_available_outlined,
            size: 80,
            color: colorGrey,
          ),
          const SizedBox(height: 16),
          Text(
            isSearching
                ? 'No leave quota found'
                : 'No quota data',
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
                context.read<LeaveQuotaController>().clearSearch();
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

class _LeaveQuotaItem extends StatelessWidget {
  final LeaveQuotaModel quota;
  final VoidCallback onTap;

  const _LeaveQuotaItem({required this.quota, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final pct = quota.usagePercent;
    final isExhausted = quota.totalRemaining <= 0;
    final barColor = isExhausted
        ? colorError
        : pct > 0.7
            ? Colors.orange
            : colorPrimary;

    return Card(
      color: colorCard,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: colorGreyLight),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      quota.employeeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: colorTextPrimary,
                      ),
                    ),
                  ),
                  if (isExhausted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorError.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Exhausted',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: colorError,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                quota.leaveTypeName,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    quota.remainingFormatted ??
                        '${quota.totalRemaining.toStringAsFixed(0)} days remaining',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: colorTextSubtle,
                    ),
                  ),
                  Text(
                    '${quota.totalUsed.toStringAsFixed(0)} / ${quota.totalQuota.toStringAsFixed(0)} days',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: colorTextSubtle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: pct,
                  minHeight: 6,
                  backgroundColor: colorGreyLight,
                  color: barColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}